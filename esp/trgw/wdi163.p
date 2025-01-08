/********************************************************************************
 ** UPC........: wdi163.p - UPC WRITE preco-item
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de precos dos itens comerciais para a Base Oracle
 ********************************************************************************/
DEF PARAM BUFFER b-preco-item      FOR preco-item.
DEF PARAM BUFFER b-old-preco-item  FOR preco-item.
{esp/es0018.i}    
{esp/esb/esesb000.i}
{esp/wso/out/wso0001.i}
{esp/esb/out/msg0195.i}
{utp/ut-glob.i}
{cdp/cd0666.i} /*tt-erro*/
{esp/pdp/espdp006fn.i}
{btb/btb912zb.i}

DEFINE BUFFER b2-preco-item      FOR preco-item.
DEFINE BUFFER bint-preco-ecommerce FOR int-preco-ecommerce.
DEFINE BUFFER btt-prog-ponto FOR tt-prog-ponto.
DEF VAR raw-param AS RAW NO-UNDO.

define temp-table tt-param-espdp096 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD it-codigo        LIKE preco-item.it-codigo.

/*Situa‡Æo da Tabela de pro‡o. 0-Manuten‡Æo / 1-elimina‡Æo */
DEF VAR i-situacao AS INTEGER.
DEF VAR i-situacao-tab AS INTEGER.
DEFINE VARIABLE dt-ini-ult AS DATE        NO-UNDO.
DEFINE VARIABLE i-cont-aux AS INT NO-UNDO.

IF  b-preco-item.situacao = 1 THEN /* ATIVA */
    ASSIGN i-situacao = 0. /* ativa no CRM */
ELSE 
    ASSIGN i-situacao = 1. /* Inativa ou simula‡Æo no totvs, e INATIVA no CRM */

/* VERIFICA SITUA€ÇO DA TABELA DE PRE€O */
FIND tb-preco
    WHERE tb-preco.nr-tabpre = b-preco-item.nr-tabpre NO-LOCK NO-ERROR.

IF  AVAIL tb-preco 
AND tb-preco.situacao = 1 THEN
    ASSIGN i-situacao-tab = 0.
ELSE
    ASSIGN i-situacao-tab = 1.

IF  b-old-preco-item.preco-venda <> b-preco-item.preco-venda   
AND b-preco-item.preco-venda     <> 0 THEN DO:

    FOR EACH lib-item-fat
        WHERE  lib-item-fat.it-codigo  = b-preco-item.it-codigo   
          AND  lib-item-fat.c-status   = "Pendente" EXCLUSIVE-LOCK :
        ASSIGN lib-item-fat.c-status = 'Pendencia Liberada'.
    END.
    FIND CURRENT lib-item-fat NO-LOCK NO-ERROR.
    RELEASE lib-item-fat.

END.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

/*integra wso2*/
IF CAN-FIND (FIRST tt-prog-ponto
              WHERE ENTRY(1,tt-prog-ponto.conteudo, ";") = b-preco-item.nr-tabpre) THEN DO:
    RUN pi-cria-registro.
END.

RETURN "OK".

PROCEDURE pi-cria-registro:

    DEF VAR dvalue-padrao AS DEC NO-UNDO.

    FOR EACH btt-prog-ponto:
        FOR FIRST b2-preco-item
            WHERE b2-preco-item.nr-tabpre = entry(1,btt-prog-ponto.conteudo,";")
              AND b2-preco-item.it-codigo = b-preco-item.it-codigo
              AND b2-preco-item.situacao  = 1:
            IF dvalue-padrao < b2-preco-item.preco-fob THEN
                ASSIGN dvalue-padrao = b2-preco-item.preco-fob.
        END.
    END.

    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo, ";") = b-preco-item.nr-tabpre NO-ERROR.
    
    FIND FIRST int-preco-ecommerce NO-LOCK
         WHERE int-preco-ecommerce.it-codigo     = b-preco-item.it-codigo
           AND int-preco-ecommerce.tradePolicyId = entry(2,tt-prog-ponto.conteudo,";") NO-ERROR.
    IF NOT AVAIL int-preco-ecommerce THEN DO:
        CREATE int-preco-ecommerce.
        ASSIGN int-preco-ecommerce.it-codigo     = b-preco-item.it-codigo                                                                                        
               int-preco-ecommerce.tradePolicyId = entry(2,tt-prog-ponto.conteudo,";").
    END.
    IF int-preco-ecommerce.dvalue    <> b-preco-item.preco-fob
    OR int-preco-ecommerce.listPrice <> b-preco-item.preco-venda THEN DO:
        FIND CURRENT int-preco-ecommerce EXCLUSIVE-LOCK NO-ERROR. 
        ASSIGN int-preco-ecommerce.dateFrom      = STRING(YEAR(TODAY)) + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + "T00:00:00-03:00"     
               int-preco-ecommerce.dateTo        = "2999-12-31T00:00:00-03:00"
               int-preco-ecommerce.dvalue        = b-preco-item.preco-fob  
               int-preco-ecommerce.listPrice     = b-preco-item.preco-venda
               int-preco-ecommerce.minQuantity   = b-preco-item.quant-min                                                                                   
               int-preco-ecommerce.dateFrom      = STRING(YEAR(TODAY)) + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + "T00:00:00-03:00"
               int-preco-ecommerce.dateTo        = "2999-12-31T00:00:00-03:00"                                                                              
               int-preco-ecommerce.situacao      = 1                                                                                                        
               int-preco-ecommerce.dt-atual      = TODAY                                                                                                    
               int-preco-ecommerce.hr-atual      = STRING(TIME,"HH:MM")
               int-preco-ecommerce.nr-tabpre     = b-preco-item.nr-tabpre.
               int-preco-ecommerce.char-1        = IF dvalue-padrao <> 0 THEN STRING(dvalue-padrao) ELSE STRING(b-preco-item.preco-fob).
        FIND CURRENT int-preco-ecommerce NO-LOCK NO-ERROR.
    END.

    DO i-cont-aux = 2 TO 10:
        IF ENTRY(i-cont-aux * 2,tt-prog-ponto.conteudo,";") <> "" THEN DO:
            FIND FIRST bint-preco-ecommerce EXCLUSIVE-LOCK
                 WHERE bint-preco-ecommerce.it-codigo     = b-preco-item.it-codigo
                   AND bint-preco-ecommerce.tradePolicyId = entry(i-cont-aux * 2 + 1,tt-prog-ponto.conteudo,";") NO-ERROR.
            IF NOT AVAIL bint-preco-ecommerce THEN
                CREATE bint-preco-ecommerce.
            
            BUFFER-COPY int-preco-ecommerce EXCEPT tradePolicyId nr-tabpre TO bint-preco-ecommerce.
            ASSIGN bint-preco-ecommerce.tradePolicyId = ENTRY(i-cont-aux * 2 + 1,tt-prog-ponto.conteudo,";")
                   bint-preco-ecommerce.nr-tabpre     = b-preco-item.nr-tabpre.
            FIND CURRENT int-preco-ecommerce NO-LOCK NO-ERROR.
        END.
    END.

END PROCEDURE.
