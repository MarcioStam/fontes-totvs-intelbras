/*******************************************************************************/
/* Programa espdp072 - Roda via web Service                                    */
/*                     O share point passar† para este programa o rowid do     */
/*                     do pedido, retornando uma temp-table                    */                    
/* Data 05/11/2012                                                             */
/* Autor: Roger Marcelino Bruhn                                                */
/*******************************************************************************/

DEF TEMP-TABLE tt-web-ped NO-UNDO
    FIELD nome-repres   LIKE repres.nome
    FIELD nome-emit     LIKE emitente.nome-emit
    FIELD nome-abrev    LIKE ped-venda.nome-abrev
    FIELD nr-pedcli     LIKE ped-venda.nr-pedcli
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-refer     LIKE ped-item.cod-refer
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD desc-item     LIKE ITEM.DESC-item
    FIELD qt-pedida     LIKE ped-item.qt-pedida
    FIELD preco-inf     LIKE ped-item.vl-preuni
    FIELD preco-min-tab LIKE ped-item.vl-preuni
    FIELD aprovador     AS CHAR FORMAT "x(08)".

DEF TEMP-TABLE tt-erro
    FIELD codigo AS INTEGER
    FIELD descricao AS CHAR FORMAT "x(100)".

DEF INPUT  PARAMETER p-nr-pedido  LIKE ped-venda.nr-pedido NO-UNDO.    
DEF INPUT  PARAMETER p-aprovador  AS CHAR FORMAT "x(08)" NO-UNDO.  
DEF OUTPUT PARAM TABLE FOR tt-web-ped.
DEF OUTPUT PARAM TABLE FOR tt-erro.

DEF VAR c-nome-emit   LIKE emitente.nome-emit NO-UNDO.
DEF VAR c-desc-item   LIKE ITEM.desc-item     NO-UNDO.
DEF VAR l-existe      AS LOGICAL NO-UNDO.
DEF VAR de-liquido    LIKE ped-item.vl-preori NO-UNDO.
DEF VAR de-desconto   AS DEC EXTENT 20.

/* Verifica se foi informado um N£mero de Pedido de Venda */
IF  p-nr-pedido > 0 THEN DO:
    
    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedido = p-nr-pedido:
    
        /**************************** Validaá‰es *****************************/
        IF  NOT ped-venda.completo THEN DO:
            RUN pi-cria-erro (1,"Pedido n∆o est† completo."). RETURN "OK".
        END.
    
        CASE ped-venda.cod-sit-ped:
            WHEN 3 THEN DO:
                RUN pi-cria-erro (2,"Pedido j† foi atendido totalmente."). RETURN "OK".
            END.
            WHEN 6 THEN DO:
                RUN pi-cria-erro (5,"Pedido est† Cancelado."). RETURN "OK".
            END.
        END CASE.
        
        FIND FIRST atendente NO-LOCK
            WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

        IF  NOT AVAIL atendente THEN DO:
            RUN pi-cria-erro (6,"Atentende " + ped-venda.tp-pedido + " informado no pedido n∆o existe no cadastro de Atendentes"). 
            RETURN "OK".
        END.

        IF  trim(atendente.aprovador) = "" THEN DO:
            RUN pi-cria-erro (7,"Aprovador do atendente " + ped-venda.tp-pedido + " n∆o foi informado no cadastro no cadastro de Atendentes"). 
            RETURN "OK".
        END.

        FOR FIRST usuar_mestre FIELDS (cod_senha) NO-LOCK
            WHERE usuar_mestre.cod_usuario = atendente.aprovador:
        END.

        IF  NOT AVAIL usuar_mestre THEN DO:
            RUN pi-cria-erro (8,"Aprovador " + atendente.aprovador + " n∆o existe no cadastro de Usu†rios"). 
            RETURN "OK".
        END.

        FOR EACH int-ped-item NO-LOCK
            WHERE int-ped-item.nome-abrev       = ped-venda.nome-abrev
              AND int-ped-item.nr-pedcli        = ped-venda.nr-pedcli
              AND int-ped-item.ind-status-preco = 1 /*Bloqueado*/
            ,FIRST ped-item NO-LOCK
                WHERE ped-item.nome-abrev       = ped-venda.nome-abrev
                  AND ped-item.nr-pedcli        = ped-venda.nr-pedcli
                  AND ped-item.nr-sequencia     = int-ped-item.nr-sequencia
                  AND ped-item.cod-refer        = int-ped-item.cod-refer
                  AND ped-item.it-codigo        = int-ped-item.it-codigo:
            
            RUN PI-CRIA-TT.    
        END.
         
        IF  NOT l-existe THEN 
            RUN pi-cria-erro (9,"N∆o existem itens bloqueados para o pedido " + STRING(p-nr-pedido)). 

    END.
    
    IF  NOT AVAIL ped-venda THEN 
        RUN pi-cria-erro (10,"Pedido n£mero " + STRING(p-nr-pedido) + " inexistente."). 
    
    RETURN "OK".
END.

/* Caso tenha sido informado apenas o c¢digo do Aprovador */
IF  trim(p-aprovador) <> "" THEN DO:
        
    FOR EACH int-ped-item NO-LOCK
        WHERE int-ped-item.cod-aprovador        = p-aprovador
          AND int-ped-item.ind-status-preco = 1 /*Bloqueado*/
        ,FIRST ped-item NO-LOCK
            WHERE ped-item.nome-abrev       = int-ped-item.nome-abrev
              AND ped-item.nr-pedcli        = int-ped-item.nr-pedcli
              AND ped-item.nr-sequencia     = int-ped-item.nr-sequencia
              AND ped-item.cod-refer        = int-ped-item.cod-refer
              AND ped-item.it-codigo        = int-ped-item.it-codigo
         ,FIRST ped-venda NO-LOCK
                OF ped-item
            WHERE ped-venda.completo
              AND ped-venda.cod-sit-ped <> 3
              AND ped-venda.cod-sit-ped <> 6
         ,FIRST atendente FIELDS(aprovador) NO-LOCK
            WHERE atendente.cd-oper = int(ped-venda.tp-pedido) 
              AND atendente.aprovador <> ""
         ,FIRST usuar_mestre FIELDS (cod_senha) NO-LOCK
            WHERE usuar_mestre.cod_usuario = atendente.aprovador:

        RUN PI-CRIA-TT.    

    END.
    
    IF  NOT l-existe THEN 
         RUN pi-cria-erro (11,"N∆o existem itens bloqueados para o Aprovador: " + STRING(p-aprovador)). 

END.

PROCEDURE PI-CRIA-TT:

        ASSIGN c-nome-emit   = ""
               c-desc-item   = ""
               l-existe = YES.
    
        FOR FIRST emitente FIELDS (cod-emitente nome-emit) NO-LOCK
            WHERE emitente.nome-abrev = ped-venda.nome-abrev:
            ASSIGN c-nome-emit = '<![CDATA[' + string(emitente.cod-emitente) + " - " + emitente.nome-emit + ']]>'. /* <![CDATA[VALOR]]> */
        END.
        FOR FIRST ITEM FIELDS (desc-item) NO-LOCK
            WHERE ITEM.it-codigo = ped-item.it-codigo:
            ASSIGN c-desc-item = ITEM.desc-item.
        END.

        ASSIGN de-liquido = ped-item.vl-preori. 
        
        RUN pi-aplica-descontos.
        
        CREATE tt-web-ped.
        ASSIGN tt-web-ped.nome-repres   = ped-venda.no-ab-reppri
               tt-web-ped.nome-abrev    = ped-venda.nome-abrev
               tt-web-ped.nome-emit     = c-nome-emit
               tt-web-ped.nr-pedcli     = ped-venda.nr-pedcli
               tt-web-ped.it-codigo     = int-ped-item.it-codigo
               tt-web-ped.nr-sequencia  = int-ped-item.nr-sequencia
               tt-web-ped.cod-refer     = ped-item.cod-refer
               tt-web-ped.desc-item     = c-desc-item
               tt-web-ped.qt-pedida     = ped-item.qt-pedida
               tt-web-ped.preco-inf     = de-liquido                 
               tt-web-ped.preco-min-tab = int-ped-item.preco-tabela  
               tt-web-ped.aprovador     = atendente.aprovador.
    
END.

PROCEDURE pi-cria-erro:

    DEF INPUT PARAMETER p-erro AS INTEGER.
    DEF INPUT PARAMETER p-descricao AS CHAR.
    CREATE tt-erro.
    ASSIGN tt-erro.codigo    = p-erro
           tt-erro.descricao = p-descricao.

END.



/* Aplica Descontos */
PROCEDURE pi-aplica-descontos:
    DEF VAR i-aux AS INTEGER NO-UNDO.

    DEFINE VARIABLE b AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE e AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE g AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE j AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE m AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE n AS DECIMAL     NO-UNDO.
    
    /*Verifica desconto informado no PEDIDO*/
    IF  trim(ped-venda.des-pct-desconto-inform) <> "" THEN DO:
        RUN pi-extrai-descontos (ped-venda.des-pct-desconto-inform).
        DO  i-aux = 1 TO 20:   
            IF de-desconto[i-aux] = 0 THEN LEAVE.
            de-liquido = de-liquido - ((de-liquido * de-desconto[i-aux]) / 100).
        END.
    END.

    /*Verifica desconto informado no ITEM DO PEDIDO*/
    IF  trim(ped-item.des-pct-desconto-inform) <> "" THEN DO:
       RUN pi-extrai-descontos (INPUT ped-item.des-pct-desconto-inform).
        DO  i-aux = 1 TO 20:   
            IF de-desconto[i-aux] = 0 THEN LEAVE.
            de-liquido = de-liquido - ((de-liquido * de-desconto[i-aux]) / 100).
        END.
    END.

    ASSIGN c = ped-venda.val-pct-desconto-tab-preco
           d = ped-venda.perc-desco1
           f = IF AVAIL ped-item THEN ped-item.val-desconto[1]            ELSE 0
           g = IF AVAIL ped-item THEN ped-item.val-desconto[2]            ELSE 0
           h = IF AVAIL ped-item THEN ped-item.val-desconto[3]            ELSE 0
           i = IF AVAIL ped-item THEN ped-item.val-desconto[4]            ELSE 0
           j = IF AVAIL ped-item THEN ped-item.val-desconto[5]            ELSE 0
           l = IF AVAIL ped-item THEN ped-item.val-pct-desconto-periodo   ELSE 0
           m = IF AVAIL ped-item THEN ped-item.val-pct-desconto-prazo     ELSE 0
           n = IF AVAIL ped-item THEN ped-item.val-pct-desconto-tab-preco ELSE 0  .

    ASSIGN de-liquido = de-liquido - ((de-liquido * c) / 100)
           de-liquido = de-liquido - ((de-liquido * d) / 100)
           de-liquido = de-liquido - ((de-liquido * f) / 100)
           de-liquido = de-liquido - ((de-liquido * g) / 100)
           de-liquido = de-liquido - ((de-liquido * h) / 100)
           de-liquido = de-liquido - ((de-liquido * i) / 100)
           de-liquido = de-liquido - ((de-liquido * j) / 100)
           de-liquido = de-liquido - ((de-liquido * l) / 100)
           de-liquido = de-liquido - ((de-liquido * m) / 100)
           de-liquido = de-liquido - ((de-liquido * n) / 100).
  
END.

/*Procedure para extrair os descontos informados no pedido e tambÇm no item, */
/* que s∆o informados na forma de formula */
PROCEDURE pi-extrai-descontos:
    DEF INPUT PARAM p-desconto AS CHAR .
    DEF VAR i AS INTEGER NO-UNDO.

    DO  i = 1 TO 20: de-desconto[i] = 0. END.

    DO  i = 1 TO NUM-ENTRIES(p-desconto, "+"):
        ASSIGN de-desconto[i] = dec(ENTRY(i, TRIM(p-desconto), "+")).       
    END.
END.


RETURN "OK".
