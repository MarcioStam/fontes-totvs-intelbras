DEFINE INPUT PARAM p-nr-pedcli     LIKE ped-venda.nr-pedcli.
DEFINE INPUT PARAM p-nome-abrev    LIKE ped-venda.nome-abrev.
DEFINE INPUT PARAM p-nome-item-pai AS CHAR.
DEFINE INPUT PARAM p-ncm-item-pai  AS CHAR.
DEFINE INPUT PARAM p-observacao    AS CHAR.

{esbo/boes372.i tt-int-item}
{cdp/cdapi244.i "new shared"}   /* Defini‡Æo temp-table tt-item */
{esp/es0018.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.
DEFINE TEMP-TABLE tt-prog-ponto3 NO-UNDO LIKE tt-prog-ponto.
DEFINE TEMP-TABLE tt-prog-ponto4 NO-UNDO LIKE tt-prog-ponto.

DEFINE TEMP-TABLE tt-item-fabric NO-UNDO
    FIELD cod-fabric LIKE item-fabric.cod-fabric
    FIELD it-fabric  LIKE item-fabric.it-fabric
    FIELD referencia LIKE item-fabric.referencia.

DEFINE TEMP-TABLE tt-item-alt LIKE item
    FIELD cod-maq-origem  AS INTEGER FORMAT "9999"      INITIAL 0
    FIELD num-processo    AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0
    FIELD num-sequencia   AS INTEGER FORMAT ">>>>>9"    INITIAL 0
    FIELD ind-tipo-movto  AS INTEGER FORMAT "99"        INITIAL 1
    INDEX ch-codigo       IS PRIMARY  cod-maq-origem
                                      num-processo
                                      num-sequencia.

/* Temp-table utilizada pelo programa ESCRM005 */
DEFINE TEMP-TABLE tt-atributo-entrada NO-UNDO
    FIELD tipo          AS CHARACTER
    FIELD nome          AS CHARACTER
    FIELD nome-pai      AS CHARACTER
    FIELD valor         AS CHARACTER
    INDEX id_principal  AS PRIMARY UNIQUE
        tipo
        nome
        nome-pai.

/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD ind-origem-msg        AS INTEGER FORMAT "99" /* i01mp900.i */.

/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg           AS CHAR    FORMAT "x(60)"
    FIELD num-sequencia-erro    AS INTEGER FORMAT "999"
    FIELD cod-erro              AS INTEGER FORMAT "99999"   
    FIELD des-erro              AS CHAR    FORMAT "x(60)"
    FIELD cod-maq-origem        AS INTEGER FORMAT "999"
    FIELD num-processo          AS INTEGER FORMAT "999999999".

/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tip-msgs AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD mensagem AS CHARACTER FORMAT "x(250)":U.

DEF BUFFER b-item-mat   FOR item-mat.
DEF BUFFER b-int-item   FOR int-item.
DEF BUFFER b-item       FOR ITEM.
DEF BUFFER b2-item      FOR ITEM.
DEF BUFFER b-item-caixa FOR item-caixa.
    
/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE h-esmsspapi001   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-mensagem       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boes372        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-aux            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-preco-venda    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-peso-bruto     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-peso-liquido   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-financiamento  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-item           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tipo-item      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-arquivo-log1   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-log            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-producao       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-seq-p          AS INT         NO-UNDO.


/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-versao-integr.
EMPTY TEMP-TABLE tt-erros-geral.
EMPTY TEMP-TABLE tt-item.

CREATE tt-versao-integr.
ASSIGN tt-versao-integr.cod-versao-integracao = 1.

/*Busca item que ser  usado como base para cria‡Æo*/
EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "Solar":U,
                   INPUT 6,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

FIND FIRST ITEM NO-LOCK
     WHERE ITEM.it-codigo = tt-prog-ponto.conteudo NO-ERROR.

IF NOT AVAIL ITEM THEN
    RETURN "OK".


EMPTY TEMP-TABLE tt-prog-ponto2.
RUN esp/es0018p.p (INPUT "Solar":U,
                   INPUT 9,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto2).
FIND FIRST tt-prog-ponto2 NO-ERROR.

EMPTY TEMP-TABLE tt-prog-ponto4.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto4).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto4               AND
   tt-prog-ponto4.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES
           i-seq-p    = 1.
ELSE
    ASSIGN l-producao = NO
           i-seq-p    = 2.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto3).

FIND FIRST tt-prog-ponto3 
   WHERE ENTRY(1,tt-prog-ponto3.conteudo,";") = 'wso0010' NO-ERROR.
IF AVAILABLE tt-prog-ponto3 AND
   ENTRY(2,tt-prog-ponto3.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.



IF l-log = YES THEN DO:

    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_wso0010_NEWPED_'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_wso0010_NEWPED_'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

END.

bk-integracao:
DO TRANSACTION ON ERROR UNDO bk-integracao, RETURN "NOK":U
               ON STOP  UNDO bk-integracao, RETURN "NOK":U:

    RUN pi-gerar-dados-extrato(">> ----- ENTREI NO ESCDP058 -----> ").

    do i-cont = int(entry(1,tt-prog-ponto2.conteudo,";")) TO int(entry(2,tt-prog-ponto2.conteudo,";")):
       find first b-item 
            WHERE b-item.it-codigo = string(i-cont) no-lock no-error.
       assign i-item = i-cont.
       if not avail b-item then leave.
    END.

    CREATE tt-item.
    BUFFER-COPY ITEM EXCEPT it-codigo TO tt-item .

    
    
    ASSIGN tt-item.it-codigo      = string(i-item)
           tt-item.ind-tipo-movto = 1 /* InclusÆo */
           tt-item.desc-item      = p-nome-item-pai .

    RUN pi-gerar-dados-extrato(">> ESCDP058 - p-nr-pedcli:  " + STRING(p-nr-pedcli) + " TT-ITENS Criada com base no item: " + STRING(tt-item.it-codigo)).
    RUN pi-gerar-dados-extrato(">> ESCDP058 - p-nr-pedcli:  " + STRING(p-nr-pedcli) + " tt-item.desc-item: " + STRING(tt-item.desc-item)).

    RUN cdp/cdapi344.p (INPUT        TABLE tt-versao-integr,
                        OUTPUT       TABLE tt-erros-geral,
                        INPUT-OUTPUT TABLE tt-item).

    IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
        FOR EACH tt-erros-geral:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = STRING(tt-erros-geral.des-erro).
            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + tt-erros-geral.des-erro ) .
        END.
        UNDO bk-integracao, LEAVE bk-integracao.
    END.


    RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 01") .

    EMPTY TEMP-TABLE tt-item-aux.

    FIND FIRST tt-item NO-ERROR.

    IF NOT AVAIL tt-item THEN DO:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.tip-msgs = 1
               tt-mensagem.mensagem = "NÆo encontrado item na tabela de integra‡Æo.".


        RUN pi-gerar-dados-extrato(">> ESCDP058 - p-nr-pedcli:  " + STRING(p-nr-pedcli) + " ----- NÆo encontrado item na tabela de integra‡Æo" ).

        UNDO bk-integracao, LEAVE bk-integracao.
    END.
    ELSE DO:
        FIND FIRST item NO-LOCK WHERE item.it-codigo = tt-item.it-codigo NO-ERROR.
        IF  NOT AVAIL item THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = "Item nÆo foi cadastrado!".

             RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + STRING(p-nr-pedcli) + "Item nÆo foi cadastrado!" ).
     
            UNDO bk-integracao, LEAVE bk-integracao.
        END.
    END.

    RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 02") .
    
    CREATE tt-item-alt.
    BUFFER-COPY tt-item EXCEPT cod-erro des-erro ind-tipo-movto TO tt-item-alt.
    BUFFER-COPY item EXCEPT it-codigo un desc-item cod-estabel fm-codigo class-fiscal narrativa 
                            responsavel peso-liquido peso-bruto comprim largura altura cd-folh-item ind-serv-mat 
                            tipo-contr ge-codigo contr-qualid fraciona criticidade fm-cod-com perc-nqa reporte-ggf TO tt-item-alt.
    
    ASSIGN tt-item-alt.ind-tipo-movto = 1.
    
    EMPTY TEMP-TABLE tt-erros-geral.
    
    RUN cdp/cdapi306.p (INPUT        TABLE tt-versao-integr,
                        OUTPUT       TABLE tt-erros-geral,
                        INPUT-OUTPUT TABLE tt-item-alt).
    IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 03") . 
        FOR EACH tt-erros-geral:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = tt-erros-geral.des-erro.
            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + tt-erros-geral.des-erro ) .
        END.
        UNDO bk-integracao, LEAVE bk-integracao.
    END.
    ELSE DO:
        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 04") . 
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

        FIND FIRST b-item-mat NO-LOCK
             WHERE b-item-mat.it-codigo = item.it-codigo  NO-ERROR.

        FIND FIRST item-mat EXCLUSIVE-LOCK
             WHERE item-mat.it-codigo = tt-item.it-codigo NO-ERROR.
        
        IF AVAILABLE item-mat THEN
            ASSIGN item-mat.val-aliq-ext-pis    = b-item-mat.val-aliq-ext-pis
                   item-mat.val-aliq-ext-cofins = item-mat.val-aliq-ext-cofins.
        
        FOR EACH tt-item-fabric:
            FIND FIRST fabricante NO-LOCK
                 WHERE fabricante.cod-fabric = tt-item-fabric.cod-fabric NO-ERROR.
        
            IF NOT AVAIL fabricante THEN DO:
                CREATE tt-mensagem.
                ASSIGN tt-mensagem.tip-msgs = 1
                       tt-mensagem.mensagem = "NÆo encontrado ~"Fabricante~" para o c¢digo informado (C¢digo: ":U + TRIM(STRING(tt-item-fabric.cod-fabric, ">>>,>>9":U)) + ")":U.
                RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " +  tt-mensagem.mensagem ) .
                UNDO bk-integracao, LEAVE bk-integracao.
            END.
        
            FIND FIRST item-fabric NO-LOCK
                 WHERE item-fabric.it-codigo  = tt-item.it-codigo
                   AND item-fabric.cod-fabric = tt-item-fabric.cod-fabric NO-ERROR.
        
            IF NOT AVAIL item-fabric THEN DO:
                CREATE item-fabric.
                ASSIGN item-fabric.it-codigo  = tt-item.it-codigo
                       item-fabric.cod-fabric = tt-item-fabric.cod-fabric
                       item-fabric.it-fabric  = tt-item-fabric.it-fabric
                       item-fabric.referencia = tt-item-fabric.referencia.
            END.
        END.
        

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 05") . 
        
        FIND FIRST b-int-item NO-LOCK
             WHERE b-int-item.it-codigo = ITEM.it-codigo NO-ERROR.
        
        RUN esbo/boes372.p PERSISTENT SET h-boes372.
        RUN openQueryStatic IN h-boes372(input "Main":U).

        RUN goToKey      IN h-boes372 (INPUT tt-item.it-codigo).
        FOR EACH RowErrors:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = RowErrors.ErrorDescription.

            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + tt-mensagem.mensagem) .
     
            UNDO bk-integracao, LEAVE bk-integracao.
        END.
        RUN emptyRowErrors IN h-boes372.        
        RUN getRecord    IN h-boes372 (OUTPUT TABLE tt-int-item).
        FOR EACH RowErrors:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = RowErrors.ErrorDescription.
            
            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + tt-mensagem.mensagem) .
            UNDO bk-integracao, LEAVE bk-integracao.
        END.
        

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 06") . 

        FIND FIRST tt-int-item NO-ERROR.

        ASSIGN tt-int-item.destaque        = b-int-item.destaque
               tt-int-item.perc-gatt       = b-int-item.perc-gatt
               tt-int-item.log-gatt        = b-int-item.perc-gatt <> 0
               tt-int-item.ex-tarifario    = b-int-item.ex-tarifario
               tt-int-item.nve             = b-int-item.nve
               tt-int-item.seq-suframa     = b-int-item.seq-suframa
               tt-int-item.log-antidumping = b-int-item.log-antidumping
               tt-int-item.obs-antidumping = b-int-item.obs-antidumping
               tt-int-item.nr-ped-energia  = string(p-nr-pedcli).

        RUN setRecord      IN h-boes372 (INPUT TABLE tt-int-item).
        RUN emptyRowErrors IN h-boes372.        
        RUN UpdateRecord   IN h-boes372.
        RUN getRowErrors   IN h-boes372 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = RowErrors.ErrorDescription.

            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + tt-mensagem.mensagem) .
     
            UNDO bk-integracao, LEAVE bk-integracao.
        END.


        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 07") . 


        IF VALID-HANDLE(h-boes372) THEN DO:
            RUN DESTROY IN h-boes372.
            DELETE OBJECT h-boes372 NO-ERROR.
        END.

        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = tt-prog-ponto.conteudo NO-ERROR.

        /*Totaliza peso*/
        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedcli  = p-nr-pedcli
              AND ped-venda.nome-abrev = p-nome-abrev:
            
            FOR EACH ped-item OF ped-venda NO-LOCK:

                FIND FIRST b2-item NO-LOCK
                     WHERE b2-item.it-codigo = ped-item.it-codigo NO-ERROR.

                ASSIGN v-peso-bruto   = v-peso-bruto   + (b2-item.peso-bruto   * ped-item.qt-pedida) 
                       v-peso-liquido = v-peso-liquido + (b2-item.peso-liquido * ped-item.qt-pedida).
            END.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "Solar":U,
                               INPUT 5,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = string(ped-venda.cod-cond-pag)) THEN 
                ASSIGN l-financiamento = YES.
            ELSE 
                ASSIGN l-financiamento = NO.

            FOR FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE int-ped-venda.nr-pedido  = ped-venda.nr-pedido:
                /*IF l-financiamento THEN
                    ASSIGN int-ped-venda.ind-status-solar = 1.
                ELSE */

                IF ped-venda.cod-sit-ped = 5 THEN //suspenso por causa do financiamento
                    ASSIGN int-ped-venda.ind-status-solar = 2.
                ELSE DO:
                    /*IF l-financiamento THEN
                       ASSIGN int-ped-venda.ind-status-solar = 1.
                    ELSE */
                       ASSIGN int-ped-venda.ind-status-solar = 2.
                END.

                FIND FIRST int-item NO-LOCK
                     WHERE int-item.nr-ped-energia = ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL int-item THEN DO:
                    IF i-tipo-item = 1 THEN
                       ASSIGN int-ped-venda.num-serie-solar = "ON" + STRING(YEAR(TODAY)) + STRING(int-item.it-codigo).
                    ELSE
                       ASSIGN int-ped-venda.num-serie-solar = "OFF" + STRING(YEAR(TODAY)) + STRING(int-item.it-codigo).
                END.
            END.

            FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ped-venda.completo = YES.
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
        END.


        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.0") .
        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.0 - avail item " + STRING(AVAIL ITEM) ) .
        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.0 - avail b-item " + STRING(AVAIL b-item) ) .


        ASSIGN p-ncm-item-pai = REPLACE(p-ncm-item-pai,".","").
        FIND CURRENT ITEM EXCLUSIVE-LOCK.
        ASSIGN ITEM.class-fiscal = p-ncm-item-pai 
               ITEM.comprim      = b-item.comprim 
               ITEM.largura      = b-item.largura     
               ITEM.altura       = b-item.altura      
               //ITEM.class-fiscal = b-item.class-fiscal
               ITEM.compr-fabric = b-item.compr-fabric
               ITEM.cd-trib-icm  = b-item.cd-trib-icm
               ITEM.cd-trib-iss  = b-item.cd-trib-iss
               ITEM.peso-bruto   = v-peso-bruto   
               ITEM.peso-liquido = v-peso-liquido
               ITEM.data-implant = TODAY
               ITEM.data-liberac = TODAY
               ITEM.narrativa    = ITEM.desc-item
               ITEM.codigo-orig  = 5.
        FIND CURRENT ITEM NO-LOCK.

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.1") . 

        /*Copia as embalagens do item base*/
        /*FOR EACH item-caixa NO-LOCK
           WHERE item-caixa.it-codigo = b-item.it-codigo:
            CREATE b-item-caixa.
            BUFFER-COPY item-caixa EXCEPT it-codigo TO b-item-caixa.
            ASSIGN b-item-caixa.it-codigo = ITEM.it-codigo.
        END.*/

        /*cria tabela de pre‡os*/
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "Solar":U,
                           INPUT 4,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.2"). 
        
        FIND FIRST tt-prog-ponto NO-ERROR.

        FIND FIRST preco-item EXCLUSIVE-LOCK
             WHERE preco-item.it-codigo = ITEM.it-codigo
               AND preco-item.cod-refer = ""
               AND preco-item.nr-tabpre = tt-prog-ponto.conteudo NO-ERROR.
    
        IF NOT AVAIL preco-item THEN DO:
            CREATE preco-item.
            ASSIGN preco-item.it-codigo = ITEM.it-codigo
                   preco-item.cod-refer = ""
                   preco-item.nr-tabpre = tt-prog-ponto.conteudo
                   preco-item.dt-inival = TODAY
                   preco-item.quant-min = 0.
        END.

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.3"). 

        ASSIGN c-aux = SUBSTRING(ENTRY(3,p-observacao,"$"),1,12).
        ASSIGN c-aux = SUBSTRING(c-aux, 1, INDEX(c-aux,".") + 2).
        log-manager:write-message('Converte Obs: ' + c-aux, 'DEBUG') no-error.
        ASSIGN v-preco-venda = dec(c-aux) / 100.

        ASSIGN preco-item.dt-useralt   = TODAY
               preco-item.preco-venda  = v-preco-venda
               preco-item.preco-fob    = v-preco-venda
               preco-item.quant-min    = 0
               preco-item.situacao     = 1
               preco-item.user-alter   = USERID("mgadm")
               preco-item.dt-useralt   = TODAY
               preco-item.cod-unid-med = "pc".
    
        FIND CURRENT preco-item NO-LOCK NO-ERROR.

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 08.4" + STRING(c-aux) + "v-preco-venda " + STRING(v-preco-venda)) . 

        /* CEST - C¢digo especificador da substitui‡Æo tribut ria - Carlos Daniel - 04/03/2016*/
        ASSIGN c-mensagem = "" .
        //RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.
        
        //ASSIGN c-mensagem = "".
        /*
        IF VALID-HANDLE(h-esmsspapi001) THEN
            DELETE PROCEDURE h-esmsspapi001.*/



        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 09") . 
        /*
        IF RETURN-VALUE <> "OK" THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = c-mensagem.


            RUN pi-gerar-dados-extrato(">> ESCDP058 ----- p-nr-pedcli: " + c-mensagem) .

            UNDO bk-integracao, LEAVE bk-integracao.
        END.
        */

        RUN pi-gerar-dados-extrato(">> ESCDP058 ----- PONTO 10") . 

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.tip-msgs = 2
               tt-mensagem.mensagem = "Item: ":U + tt-item.it-codigo.

        RUN pi-gerar-dados-extrato(">> FIM -> ESCDP058 ----- p-nr-pedcli: " + tt-mensagem.mensagem) .

    END.


    RUN pi-gerar-dados-extrato(">> FIM -> ESCDP058 ---------------------") .

END.


//RUN pi-gerar-dados-extrato(">> FIM -> ESCDP058 ----- p-nr-pedcli: " + tt-mensagem.mensagem) .



PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string format "x(100)" skip.
        output close. 
    
    end.
END.
