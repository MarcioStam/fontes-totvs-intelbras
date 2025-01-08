/*******************************************************************************/
/* Programa espdp072 - Roda via web Service                                    */
/*                     AprovaReprovaPreco                                      */                  
/* Data 06/11/2012                                                             */
/* Autor: Roger Marcelino Bruhn                                                */
/*******************************************************************************/

DEF TEMP-TABLE tt-web-ped-status NO-UNDO
    FIELD nr-pedido     LIKE ped-venda.nr-pedido
    FIELD aprovador     AS CHAR FORMAT "x(08)"
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-refer     LIKE ped-item.cod-refer
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD log-aprovado  AS LOGICAL
    FIELD log-reprovado AS LOGICAL
    FIELD motivo-aprov  AS CHAR FORMAT "x(2000)".

DEF TEMP-TABLE tt-erro
    FIELD codigo AS INTEGER
    FIELD descricao AS CHAR FORMAT "x(100)".
    
DEF INPUT  PARAMETER p-nr-pedido     LIKE ped-venda.nr-pedido NO-UNDO.    
DEF INPUT  PARAMETER p-cod-aprovador AS CHAR FORMAT "x(08)" NO-UNDO.
DEF INPUT  PARAMETER p-senha AS CHAR.
DEF INPUT  PARAM TABLE FOR tt-web-ped-status.
DEF OUTPUT PARAM TABLE FOR tt-erro.

FOR FIRST tt-web-ped-status: END.
IF  NOT AVAIL tt-web-ped-status THEN DO:
    RUN pi-cria-erro (101,"N∆o existem dados de retorno na tt-web-ped-status"). 
    RETURN "OK".
END.

DEF VAR c-mensagem         AS CHAR NO-UNDO.
DEF VAR c-mensagem-aprov   AS CHAR NO-UNDO.
DEF VAR c-mensagem-reprov  AS CHAR NO-UNDO.
DEF VAR c-texto            AS CHAR FORMAT "x(9)" NO-UNDO.
DEF VAR l-por-pedido       AS LOGICAL NO-UNDO.
DEF VAR l-avaliou          AS LOGICAL NO-UNDO.
DEF VAR de-liquido    LIKE ped-item.vl-preori NO-UNDO.
DEF VAR de-desconto   AS DEC EXTENT 20.

DEF BUFFER b-int-ped-item FOR int-ped-item.
{utp/utapi019.i}

RUN utp/utapi019.p PERSISTENT SET h-utapi019.

/* Verifica se foi informado o n£mero do pedido de venda */
IF  p-nr-pedido > 0 THEN DO:

    /********** Valida Senha do usu†rio aprovador ***********/
    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedido = p-nr-pedido:

        /* Validar a senha do aprovador */
        RUN pi-valida-senha (INPUT p-cod-aprovador,
                             INPUT p-senha).
        IF  RETURN-VALUE = "NOK" THEN
            RETURN "NOK".

    END.

    IF  NOT AVAIL ped-venda THEN DO:
        RUN pi-cria-erro (102,"Pedido de venda " + STRING(p-nr-pedido) + " Inexistente"). 
        RETURN "OK".
    END.

    DO TRANS:
    
        FOR EACH tt-web-ped-status
            WHERE tt-web-ped-status.nr-pedido = p-nr-pedido
            ,FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedido = p-nr-pedido
              ,FIRST int-ped-item NO-LOCK
                    WHERE int-ped-item.nome-abrev       = ped-venda.nome-abrev
                      AND int-ped-item.nr-pedcli        = ped-venda.nr-pedcli
                      AND int-ped-item.it-codigo        = tt-web-ped-status.it-codigo
                      AND int-ped-item.cod-refer        = tt-web-ped-status.cod-refer
                      AND int-ped-item.nr-sequencia     = tt-web-ped-status.nr-sequencia
                      AND int-ped-item.ind-status-preco = 1 /*Bloqueado*/
                    , FIRST ped-item NO-LOCK
                        WHERE ped-item.nome-abrev    = int-ped-item.nome-abrev  
                          AND ped-item.nr-pedcli     = int-ped-item.nr-pedcli   
                          AND ped-item.it-codigo     = int-ped-item.it-codigo   
                          AND ped-item.nr-sequencia  = int-ped-item.nr-sequencia  
                          AND ped-item.cod-refer     = int-ped-item.cod-refer
                    , FIRST ITEM FIELDS (desc-item)
                        WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK:
        
                      ASSIGN de-liquido = ped-item.vl-preori. 
                                    
                      RUN pi-aplica-descontos.
                      /* Aprovado */
                      IF  tt-web-ped-status.log-aprovado THEN  DO:
                          
                          FOR FIRST b-int-ped-item EXCLUSIVE-LOCK
                              OF int-ped-item:
                              ASSIGN b-int-ped-item.ind-status-preco   = 2
                                     b-int-ped-item.data-aprovacao     = TODAY
                                     b-int-ped-item.motivo-aprovacao   = b-int-ped-item.motivo-aprovacao + " | " + tt-web-ped-status.motivo-aprov
                                     b-int-ped-item.cod-aprovador      = tt-web-ped-status.aprovador
                                     b-int-ped-item.ult-preco-aprov    = de-liquido
                                     l-avaliou = YES.

                          END.

                          IF  c-mensagem-aprov = "" THEN
                              ASSIGN c-mensagem-aprov = tt-web-ped-status.motivo-aprov.
                      END.

                      /* Reprovado */                            
                      IF  tt-web-ped-status.log-reprovado THEN DO:
                          FOR FIRST b-int-ped-item EXCLUSIVE-LOCK
                              OF int-ped-item:

                              ASSIGN b-int-ped-item.ind-status-preco = 3
                                     b-int-ped-item.data-aprovacao   = TODAY
                                     b-int-ped-item.motivo-aprovacao = b-int-ped-item.motivo-aprovacao + " | " + tt-web-ped-status.motivo-aprov
                                     b-int-ped-item.cod-aprovador    = tt-web-ped-status.aprovador
                                     l-avaliou = YES.
                          END.

                          IF  c-mensagem-reprov = "" THEN
                              ASSIGN c-mensagem-reprov = tt-web-ped-status.motivo-aprov.

                      END.

                      ASSIGN c-texto = IF b-int-ped-item.ind-status-preco = 1 THEN "Bloqueado"
                                                       ELSE IF  b-int-ped-item.ind-status-preco = 2 THEN "Aprovado "
                                                            ELSE IF  b-int-ped-item.ind-status-preco = 3 THEN "Reprovado"
                                                                 ELSE "ERRO     ".
    
                      ASSIGN c-mensagem = c-mensagem +  "<TR>" +
                                          "<TD>" + trim(c-texto)                                          + "</TD>" +
                                          "<TD>" + STRING(ped-item.it-codigo          , "x(16)")          + "</TD>" +
                                          "<TD>" + STRING(ITEM.desc-item              , "x(45)")          + "</TD>" +
                                          "<TD>" + STRING(ped-item.qt-pedida          , ">>>>,>>9")       + "</TD>" +
                                          "<TD>" + STRING(de-liquido                  , ">>>,>>>,>>9.99") + "</TD>" +
                                          "<TD>" + STRING(b-int-ped-item.preco-tabela , ">>>,>>>,>>9.99") + "</TD>" +
                                          "</TR>".
    
                      FIND CURRENT b-int-ped-item NO-LOCK NO-ERROR.
                      RELEASE b-int-ped-item.
        END.

        RELEASE int-ped-item.
    END.
    /* Envio do Email para o Atendente, com o Status de cada item do pedido */
    IF  l-avaliou THEN
        RUN pi-envia-email.
    ELSE
        RUN pi-cria-erro (103, "Nenhum item do pedido " + STRING(p-nr-pedido) + " foi Aprovado/Reprovado."). 

    RETURN "Ok".

END.
ELSE DO:
/* Verifica se a tt-web-ped-status veio com o c¢digo do aprovador informado, e n∆o com o n£mero do pedido */
    
    DEF VAR l-validou-ainda AS LOGICAL NO-UNDO.

    DO TRANS:
    
        FOR EACH tt-web-ped-status
            WHERE tt-web-ped-status.aprovador = p-cod-aprovador
            ,FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedido = tt-web-ped-status.nr-pedido
              ,FIRST int-ped-item EXCLUSIVE-LOCK
                    WHERE int-ped-item.nome-abrev       = ped-venda.nome-abrev
                      AND int-ped-item.nr-pedcli        = ped-venda.nr-pedcli
                      AND int-ped-item.it-codigo        = tt-web-ped-status.it-codigo
                      AND int-ped-item.cod-refer        = tt-web-ped-status.cod-refer
                      AND int-ped-item.nr-sequencia     = tt-web-ped-status.nr-sequencia
                      AND int-ped-item.ind-status-preco = 1 /*Bloqueado*/
                    , FIRST ped-item NO-LOCK
                        WHERE ped-item.nome-abrev    = int-ped-item.nome-abrev  
                          AND ped-item.nr-pedcli     = int-ped-item.nr-pedcli   
                          AND ped-item.it-codigo     = int-ped-item.it-codigo   
                          AND ped-item.nr-sequencia  = int-ped-item.nr-sequencia  
                          AND ped-item.cod-refer     = int-ped-item.cod-refer
                    , FIRST ITEM FIELDS (desc-item)
                        WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK
                    BREAK BY ped-venda.nr-pedido
                          BY ped-item.nr-sequencia
                          BY ped-item.it-codigo:
    
                    IF  FIRST-OF (ped-venda.nr-pedido) THEN
                        ASSIGN c-mensagem = ""
                               c-mensagem-aprov  = ""
                               c-mensagem-reprov = "".
    
                    /* Validar a senha do aprovador */
                    IF  NOT l-validou-ainda THEN DO:
                        RUN pi-valida-senha (INPUT p-cod-aprovador,
                                             INPUT p-senha).
                        IF  RETURN-VALUE = "NOK" THEN
                            RETURN "NOK".
                        ASSIGN l-validou-ainda = YES.
                    END.

                    ASSIGN de-liquido = ped-item.vl-preori. 

                    RUN pi-aplica-descontos.

                    /* Aprovado */
                    IF  tt-web-ped-status.log-aprovado THEN  DO:
                        
                        ASSIGN int-ped-item.ind-status-preco = 2
                               int-ped-item.data-aprovacao   = TODAY
                               int-ped-item.motivo-aprovacao = tt-web-ped-status.motivo-aprov
                               int-ped-item.cod-aprovador    = tt-web-ped-status.aprovador
                               int-ped-item.ult-preco-aprov  = de-liquido
                               l-avaliou = YES.

                        IF  c-mensagem-aprov = "" THEN
                            ASSIGN c-mensagem-aprov = tt-web-ped-status.motivo-aprov.
                    END.
                    /* Reprovado */
                    IF  tt-web-ped-status.log-reprovado THEN  DO:
                        ASSIGN int-ped-item.ind-status-preco = 3
                               int-ped-item.data-aprovacao   = TODAY
                               int-ped-item.motivo-aprovacao = tt-web-ped-status.motivo-aprov
                               int-ped-item.cod-aprovador    = tt-web-ped-status.aprovador
                               l-avaliou = YES.
                        IF  c-mensagem-reprov = "" THEN
                            ASSIGN c-mensagem-reprov = tt-web-ped-status.motivo-aprov.
                    END.
                                                              
    
                    ASSIGN c-texto = IF int-ped-item.ind-status-preco = 1 THEN "Bloqueado"
                                                     ELSE IF int-ped-item.ind-status-preco = 2 THEN "Aprovado "
                                                          ELSE IF int-ped-item.ind-status-preco = 3 THEN "Reprovado"
                                                               ELSE "ERRO     ".
    
                    ASSIGN c-mensagem = c-mensagem + "<TR>" +
                                        "<TD>" + trim(c-texto) + "</TD>" +
                                        "<TD>" + STRING(ped-item.it-codigo        , "x(16)")             + "</TD>" +
                                        "<TD>" + STRING(ITEM.desc-item            , "x(45)")             + "</TD>" +
                                        "<TD>" + STRING(ped-item.qt-pedida        , ">>>>,>>9.999")      + "</TD>" +
                                        "<TD>" + STRING(de-liquido                , ">>>,>>>,>>9.99999") + "</TD>" +
                                        "<TD>" + STRING(int-ped-item.preco-tabela , ">>>,>>>,>>9.99999") + "</TD>" +
                                        "</TR>".
    
                    IF  LAST-OF (ped-venda.nr-pedido) THEN DO:
                        IF  NOT l-avaliou THEN
                            RUN pi-cria-erro (104, "Nenhum item do pedido " + STRING(p-nr-pedido) + " foi Aprovado/Reprovado."). 
                        ELSE
                            RUN pi-envia-email.
    
                        ASSIGN l-avaliou = NO.
                    END.
        END.
        RELEASE int-ped-item.
    END.
    RETURN "Ok".

END.

DELETE PROCEDURE h-utapi019.

RETURN "ok".


PROCEDURE pi-envia-email:

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    DEF VAR c-mensagem-Atendente AS CHAR NO-UNDO.
    
    FIND FIRST atendente NO-LOCK
    WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
    
    IF  NOT AVAIL atendente THEN DO:
        RUN pi-cria-erro (105,"Atendente " + ped-venda.tp-pedido + " vinculado ao pedido " + string(ped-venda.nr-pedido) + " n∆o cadastrado" ). 
        RETURN "NOK".
    END.

    FOR FIRST param-global NO-LOCK: END.

    FOR FIRST repres FIELDS (nome) NO-LOCK
        WHERE repres.nome-abrev = ped-venda.no-ab-reppri: END.
    FOR FIRST emitente FIELDS (cod-emitente nome-emit) 
        WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK:
    END.
    
    FIND FIRST usuar_mestre NO-LOCK
    WHERE usuar_mestre.cod_usuario = trim(atendente.aprovador) NO-ERROR.


    ASSIGN c-mensagem-Atendente = "<HTML>Prezado," + "<BR>" + "<BR>" + "    O Pedido foi submetido a avaliaá∆o do Usu†rio Aprovador: " + atendente.aprovador + "." + "<BR>" + "<BR>" +
                                  "PEDIDO: " + STRING(ped-venda.nr-pedcli) + "<BR>" +
                                  "CLIENTE: " + string(emitente.cod-emitente) + " - " + emitente.nome-emit + "<BR>" +
                                  "REPRESENTANTE: " + ped-venda.no-ab-reppri + "<BR>" + "<BR>" +
                                  "Aprovador: " + usuar_mestre.nom_usuario + "<BR>" + "<BR>".

    ASSIGN c-mensagem-Atendente = c-mensagem-Atendente + '<table border=~'1~'>' +
                                   '<TR>' + '<TH>Status</TH>'           +
                                            '<TH>Produto</TH>'          +
                                            '<TH>Descriá∆o</TH>'        +
                                            '<TH>Quantidade</TH>'       +   
                                            '<TH>Preáo Negociado</TH>'  +   
                                            '<TH>Preáo M°nimo</TH>'     +   
                                    '</TR>'                             +
                                     c-mensagem                         +  
                                    '</table>'   +
                                    '<BR>' + '<BR>' +
                                    "Motivo Aprovaá∆o..: " + c-mensagem-aprov  + '<BR>' +
                                    "Motivo Reprovaá∆o.: " + c-mensagem-reprov + '<BR>' +
                                   '<BR>' + '<BR>' + "Atenciosamente," + '</html>'.


    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "EMS@intelbras.com.br"
           tt-envio2.destino           = atendente.email
           tt-envio2.assunto           = "Pedido Avaliado pelo Aprovador " + atendente.aprovador
           tt-envio2.formato           = "HTML"
           tt-envio2.exchange          = NO.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem = c-mensagem-Atendente.

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                   INPUT TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    if  return-value = "NOK" 
    AND AVAIL tt-erros then 
        RUN pi-cria-erro (106,"Erro na rotina de geraá∆o autom†tica de email com itens abaixo do preáo m°nimo para Atendente"). 

END.


PROCEDURE pi-valida-senha:
    DEF INPUT PARAMETER p-aprov AS CHAR NO-UNDO.
    DEF INPUT PARAMETER p-senha AS CHAR NO-UNDO.

    FOR FIRST atendente FIELDS(aprovador cd-oper) NO-LOCK
        WHERE atendente.cd-oper = int(ped-venda.tp-pedido):
    END.

    IF  NOT AVAIL atendente THEN DO:
        RUN pi-cria-erro (107,"Atendente " + ped-venda.tp-pedido + " inexistente"). 
        RETURN "NOK".
    END.

    IF  atendente.aprovador = "" THEN DO:
        RUN pi-cria-erro (108,"Aprovador do pedido " + string(ped-venda.nr-pedido) + " n∆o informado no cadastro de Atendentes"). 
        RETURN "NOK".
    END.

    IF  atendente.aprovador <> p-aprov THEN DO:
        RUN pi-cria-erro (109,"Usu†rio n∆o Ç o aprovador do pedido " + string(ped-venda.nr-pedido)). 
        RETURN "NOK".
    END.

    FOR FIRST usuar_mestre FIELDS (cod_senha) NO-LOCK
        WHERE usuar_mestre.cod_usuario = trim(p-aprov):
    END.

    IF  NOT AVAIL usuar_mestre THEN DO:
        RUN pi-cria-erro (110,"Usu†rio Aprovador n∆o encontrado no cadastro de usu†rios"). 
        RETURN "NOK".
    END.
    
    IF  usuar_mestre.cod_senha <> base64-encode(sha1-digest(lc(p-senha))) THEN DO:
        RUN pi-cria-erro (111,"Senha do Aprovador inv†lida" ). 
        RETURN "NOK".
    END.

    RETURN "OK".

END.

PROCEDURE pi-cria-erro:

    DEF INPUT PARAMETER p-erro AS INTEGER.
    DEF INPUT PARAMETER p-descricao AS CHAR.

    FIND FIRST tt-erro
        WHERE tt-erro.codigo = p-erro NO-ERROR.

    IF  AVAIL tt-erro THEN
        RETURN "OK".

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
