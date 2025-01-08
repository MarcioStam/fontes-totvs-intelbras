/***********************************************************************
**  Programa..: ESP\CEP\ESCEP033RP.P
**  Autor.....: Osnir Ribeiro Junior
**  Data......: Junho/2007 - Desenvolvimento
**  Descricao.: Itens sem movimento de sa¡da 
**  VersÆo....: 001 04/06/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP033 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cep/escep033tt.i} /* tt-param e tt-digita */

{utp/ut-glob.i}
{include/i-rpvar.i}
def var c-data       as char no-undo.
DEF VAR h-acomp      as handle no-undo.
def var de-vlr-1     like saldo-estoq.qtidade-atu no-undo.
def var de-vlr-2     like saldo-estoq.qtidade-atu no-undo.
def var de-vlr-3     like saldo-estoq.qtidade-atu no-undo.
def var c-sel        as char format "x(09)" no-undo.
DEFINE VARIABLE c-tipo AS CHARACTER  FORMAT "x(40)"  NO-UNDO.
def var c-imp        as char format "x(09)" no-undo.
def var c-lb-destino as char no-undo.
def var c-lb-usuario as char no-undo.

DEFINE VARIABLE de-consumo    AS DECIMAL FORMAT "->>>,>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-planejado  AS DECIMAL FORMAT "->>>,>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL FORMAT "->>>,>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-saldo-aux  AS DECIMAL FORMAT "->>>,>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE l-achou-saldo AS LOGICAL NO-UNDO.
DEFINE VARIABLE de-saldo-ini-mes AS DECIMAL FORMAT "->>>,>>>,>>9.9999" NO-UNDO.

DEFINE VARIABLE de-valor  AS DECIMAL FORMAT "->>>,>>>,>>9.99"    NO-UNDO.
DEFINE VARIABLE dt-data   AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini-cons    AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini-plan    AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim-plan    AS DATE        NO-UNDO.

                             
DEFINE VARIABLE da-data-corte     AS DATE  FORMAT "99/99/9999"      NO-UNDO.
DEFINE VARIABLE dt-ultdia-mes     AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ultdia-mes-ant AS DATE        NO-UNDO.

DEFINE VARIABLE c-naturezas AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ignora    AS LOGICAL     NO-UNDO.

DEFINE VARIABLE i-num-calc-plano AS INTEGER     NO-UNDO.

assign c-sel = "SELE€ÇO":U
       c-imp = "IMPRESSÇO":U
       c-lb-destino = "Destino:":U
       c-lb-usuario = "Usu rio:":U.

/****************************  Temp-Tables  ****************************/
define temp-table tt-movto-estoq no-undo
       field cod-estabel like saldo-estoq.cod-estabel
       field cod-depos   like saldo-estoq.cod-depos
       field it-codigo   like saldo-estoq.it-codigo
       field desc-item   like item.desc-item
       field dt-trans    like movto-estoq.dt-trans
       field qtidade-atu like saldo-estoq.qtidade-atu
       field esp-docto   AS CHAR FORMAT "x(03)"
       field situacao    as char format "x(20)"
       field valor       AS DECIMAL FORMAT "->>>,>>>,>>9.99"
       FIELD ge-codigo   LIKE ITEM.ge-codigo
       FIELD unid-negoc  AS CHARACTER
       FIELD consumo     AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
       FIELD planejado   AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
       FIELD meses       AS DECIMAL FORMAT "->>>,>>>,>>9.99"
       index chapri cod-estabel cod-depos it-codigo
       index chave2 cod-estabel it-codigo.              

DEFINE BUFFER b-tt-movto-estoq FOR tt-movto-estoq.

DEFINE TEMP-TABLE tt-consumo NO-UNDO
    FIELD it-codigo AS CHARACTER
    FIELD data-fim  AS DATE 
    FIELD consumo   AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
    FIELD planejado AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
    INDEX chave it-codigo data-fim.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD it-codigo      AS CHARACTER
    FIELD qtidade-atu  like saldo-estoq.qtidade-atu
    INDEX chave it-codigo.

/****************************  Frames       ****************************/
FORM tt-movto-estoq.cod-estabel  COLUMN-LABEL "Estab" 
     da-data-corte               COLUMN-LABEL "Dt.Corte" 
     tt-movto-estoq.it-codigo    COLUMN-LABEL "Item" 
     tt-movto-estoq.desc-item    COLUMN-LABEL "Descri‡Æo" format "x(40)"
     tt-movto-estoq.ge-codigo    COLUMN-LABEL "GE"
     tt-movto-estoq.unid-negoc   COLUMN-LABEL "Unid.Neg."
     tt-movto-estoq.situacao     COLUMN-LABEL "Situa‡Æo"  format "x(20)"
     tt-movto-estoq.cod-depos    COLUMN-LABEL "Dep"
     tt-movto-estoq.esp-docto    COLUMN-LABEL "Esp" 
     tt-movto-estoq.qtidade-atu  COLUMN-LABEL "Quantidade"
     tt-movto-estoq.valor        COLUMN-LABEL "Valor"
     c-data                      COLUMN-LABEL "Dt. Movto" format "x(10)"
     tt-movto-estoq.consumo      COLUMN-LABEL "Consumo"
     tt-movto-estoq.meses        COLUMN-LABEL "Meses"
     WITH FRAME f-relat NO-ATTR-SPACE STREAM-IO WIDTH 200 DOWN.
     
FORM tt-movto-estoq.cod-estabel  COLUMN-LABEL "Estab" 
     da-data-corte               COLUMN-LABEL "Dt.Corte" 
     tt-movto-estoq.it-codigo    COLUMN-LABEL "Item" 
     tt-movto-estoq.desc-item    COLUMN-LABEL "Descri‡Æo" format "x(40)"
     tt-movto-estoq.ge-codigo    COLUMN-LABEL "GE"
     tt-movto-estoq.unid-negoc   COLUMN-LABEL "Unid.Neg."
     tt-movto-estoq.situacao     COLUMN-LABEL "Situa‡Æo"  format "x(20)"
     tt-movto-estoq.cod-depos    COLUMN-LABEL "Dep"
     tt-movto-estoq.esp-docto    COLUMN-LABEL "Esp" 
     tt-movto-estoq.qtidade-atu  COLUMN-LABEL "Quantidade"
     tt-movto-estoq.valor        COLUMN-LABEL "Valor"
     c-data                      COLUMN-LABEL "Dt. Movto" format "x(10)"
     tt-movto-estoq.consumo      COLUMN-LABEL "Consumo"
     tt-movto-estoq.planejado    COLUMN-LABEL "Planejado"
     tt-movto-estoq.meses        COLUMN-LABEL "Meses"
     WITH FRAME f-relat2 NO-ATTR-SPACE STREAM-IO WIDTH 250 DOWN.

form c-sel no-label at 5  skip(1)
     tt-param.c-it-codigo-ini                       colon 25  
     " |< >| " at 44
     tt-param.c-it-codigo-fim   no-label            colon 50
     c-tipo             LABEL "Tipo:"               COLON 25
     tt-param.dt-corte    format "99/99/9999"       colon 25
    with width 132 stream-io side-labels frame f-param-corte.

form c-sel no-label at 5  skip(1)
     tt-param.c-it-codigo-ini                       colon 25  
     " |< >| " at 44
     tt-param.c-it-codigo-fim   no-label            colon 50
     c-tipo             LABEL "Tipo:"               COLON 25
     tt-param.dt-inicio                              COLON 25
     " |< >| " at 44
     tt-param.dt-final          NO-LABEL
    with width 132 stream-io side-labels frame f-param-periodo.

form skip(1)
     c-imp no-label at 5  skip(1)
     c-lb-destino     at 10 no-label
     tt-param.arquivo       no-label skip
     c-lb-usuario     at 10 no-label
     tt-param.usuario       no-label 
     with width 132 stream-io side-labels frame f-parametros.

/***************************** In¡cio ******************************* */
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.            

find first param-global no-lock no-error.
find first empresa no-lock no-error.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Itens sem Movimenta‡Æo de Sa¡da"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP033"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.    

    FOR EACH tt-movto-estoq:
        DELETE tt-movto-estoq.
    END.

    FOR EACH tt-consumo:
        DELETE tt-consumo.
    END.

    FOR EACH tt-saldo:
        DELETE tt-saldo.
    END.

    ASSIGN c-naturezas = "".
    FOR EACH natur-oper NO-LOCK
       WHERE natur-oper.emite-duplic:
        IF c-naturezas = "" THEN
            ASSIGN c-naturezas = natur-oper.nat-operacao.
        ELSE
            ASSIGN c-naturezas = c-naturezas + "," + natur-oper.nat-operacao.
    END.

    find pl-prod no-lock where pl-prod.cd-plano = tt-param.i-cd-plano no-error.
    if avail pl-prod then assign i-num-calc-plano = pl-prod.num-calc-plano.
    else assign i-num-calc-plano = 0.

    RUN pi-ler-saldo.
    
    run pi-imprime-relat.
    run pi-imprime-param.
    
    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.


PROCEDURE pi-ler-saldo:
    RUN pi-inicializar IN h-acomp (INPUT "Iniciando...").
    
    IF tt-param.i-tipo = 1 THEN DO:
        /*data corte*/
        ASSIGN da-data-corte     = tt-param.dt-corte
               dt-ultdia-mes-ant = DATE(MONTH(tt-param.dt-corte),01,YEAR(tt-param.dt-corte)) - 1.

        IF MONTH(tt-param.dt-corte) = 12 THEN
            ASSIGN dt-ultdia-mes = DATE(01,01,YEAR(tt-param.dt-corte) + 1) - 1.
        ELSE
            ASSIGN dt-ultdia-mes = DATE(MONTH(tt-param.dt-corte) + 1,01,YEAR(tt-param.dt-corte)) - 1.
    END.
    ELSE DO:
        /*data periodo*/
        ASSIGN da-data-corte     = tt-param.dt-final
               dt-ultdia-mes-ant = DATE(MONTH(tt-param.dt-final),01,YEAR(tt-param.dt-final)) - 1.

        IF MONTH(tt-param.dt-corte) = 12 THEN
            ASSIGN dt-ultdia-mes = DATE(01,01,YEAR(tt-param.dt-final) + 1) - 1.
        ELSE
            ASSIGN dt-ultdia-mes = DATE(MONTH(tt-param.dt-final) + 1,01,YEAR(tt-param.dt-final)) - 1.
    END.

    /*calcula datas para ver consumo*/
    
    /*3 meses anteriores*/
    ASSIGN dt-ini-cons = DATE(MONTH(dt-ultdia-mes),01,YEAR(dt-ultdia-mes))
           dt-ini-cons = IF MONTH(dt-ini-cons) - 5 < 1 THEN 
                             DATE(12 + MONTH(dt-ini-cons) - 5,01,YEAR(dt-ini-cons) - 1)
                         ELSE 
                             DATE(MONTH(dt-ini-cons) - 5,01,YEAR(dt-ini-cons)).

    IF tt-param.i-tipo-consumo = 2 THEN DO:
        /*calcula data final conforme informado os meses de plano*/
        ASSIGN dt-ini-plan = IF MONTH(dt-ultdia-mes) = 12 THEN 
                                DATE(01,01,YEAR(dt-ultdia-mes) + 1)
                             ELSE 
                                 DATE(MONTH(dt-ultdia-mes) + 1,01,YEAR(dt-ultdia-mes))
               dt-fim-plan = IF tt-param.i-meses = 12 THEN 
                                 IF MONTH(dt-ultdia-mes) = 12 THEN 
                                     DATE(01,01,YEAR(dt-ultdia-mes) + 2) - 1
                                 ELSE 
                                     DATE(MONTH(dt-ultdia-mes) + 1,01,YEAR(dt-ultdia-mes) + 1) - 1
                             ELSE IF tt-param.i-meses + 1 + MONTH(dt-ultdia-mes) <= 12 THEN
                                 DATE(MONTH(dt-ultdia-mes) + 1 + tt-param.i-meses,01,YEAR(dt-ultdia-mes)) - 1
                             ELSE 
                                 DATE(MONTH(dt-ultdia-mes) + 1 + (tt-param.i-meses - 12),01,YEAR(dt-ultdia-mes) + 1) - 1.
    END.

    ASSIGN l-ignora = NO.
    IF CAN-FIND(FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FOR EACH saldo-estoq
               WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel 
                 AND saldo-estoq.it-codigo   = tt-digita.it-codigo NO-LOCK,
               FIRST ITEM NO-LOCK 
               WHERE ITEM.it-codigo = saldo-estoq.it-codigo
                 AND ITEM.tipo-contr = 2 /*somente item controle total*/
                BREAK BY saldo-estoq.it-codigo
                      BY saldo-estoq.cod-depos:
                 
                IF FIRST-OF(saldo-estoq.it-codigo) THEN
                    ASSIGN l-ignora = NO
                           de-valor = 0.

                ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.

                IF LAST-OF(saldo-estoq.it-codigo) OR LAST-OF(saldo-estoq.cod-depos) THEN DO:
                    IF NOT l-ignora THEN 
                        run pi-monta-relat.

                    ASSIGN de-saldo = 0.
                END.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH saldo-estoq
           WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
             AND saldo-estoq.it-codigo  >= tt-param.c-it-codigo-ini
             AND saldo-estoq.it-codigo  <= tt-param.c-it-codigo-fim NO-LOCK,
           FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = saldo-estoq.it-codigo
             AND ITEM.tipo-contr = 2 /*somente item controle total*/
            BREAK BY saldo-estoq.it-codigo
                  BY saldo-estoq.cod-depos:
             
            IF FIRST-OF(saldo-estoq.it-codigo) THEN
                ASSIGN l-ignora = NO
                       de-valor = 0.

            ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.

            IF LAST-OF(saldo-estoq.it-codigo) OR LAST-OF(saldo-estoq.cod-depos) THEN DO:
                IF NOT l-ignora THEN
                    run pi-monta-relat.

                ASSIGN de-saldo = 0.
            END.
        end.
    end.    
END.


procedure pi-monta-relat:
    DEFINE VARIABLE l-valido    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-nr-trans  AS INTEGER     NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT "Lendo item: " + saldo-estoq.it-codigo).

    IF tt-param.i-tipo = 1 THEN DO:
        /*data corte*/
        RUN pi-calc-saldo(INPUT tt-param.dt-corte).

        IF de-saldo = 0 THEN NEXT.

        ASSIGN l-valido    = NO
               i-nr-trans  = 0.

        FIND FIRST b-tt-movto-estoq NO-LOCK
             WHERE b-tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
               AND b-tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
        IF AVAIL b-tt-movto-estoq THEN DO:
            find first tt-movto-estoq
                 where tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos
                   and tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo no-error.
            if not avail tt-movto-estoq then do:
                create tt-movto-estoq.        
                assign tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                       tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos            
                       tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo.
            end.        

            assign tt-movto-estoq.qtidade-atu = tt-movto-estoq.qtidade-atu + /*saldo-estoq.qtidade-atu*/ de-saldo    
                   tt-movto-estoq.dt-trans    = b-tt-movto-estoq.dt-trans
                   tt-movto-estoq.esp-docto   = b-tt-movto-estoq.esp-docto
                   tt-movto-estoq.valor       = tt-movto-estoq.qtidade-atu * de-valor
                   tt-movto-estoq.consumo     = de-consumo
                   tt-movto-estoq.planejado   = de-planejado.
        END.
        ELSE DO:
            IF AVAIL movto-estoq THEN RELEASE movto-estoq.
            IF de-saldo-ini-mes = 0  AND de-saldo <> 0 THEN DO:
                /*busca a ultima entrada pois teve movimenta‡Æo no mˆs e saldo inicial era zerado*/
                find last movto-estoq
                    where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                      and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                      and movto-estoq.dt-trans   >= tt-param.dt-corte - DAY(tt-param.dt-corte) 
                      and movto-estoq.dt-trans   <= tt-param.dt-corte 
                      and movto-estoq.tipo-trans  = 1
                      and movto-estoq.esp-docto  <> 33 /* <> transferencia */ 
                      and movto-estoq.quantidade  > 0 no-lock no-error.   
            END.

            IF NOT AVAIL movto-estoq THEN DO:
                find last movto-estoq
                    where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                      and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                      and movto-estoq.dt-trans   <= tt-param.dt-corte
                      AND movto-estoq.quantidade  > 0
                      and (movto-estoq.esp-docto  = 28            /* REQ */
                       or movto-estoq.esp-docto   = 23            /* NFT */    
                       OR (movto-estoq.esp-docto  = 30 AND ITEM.ge-codigo = 30) /* RM  */   
                       or (movto-estoq.esp-docto  = 22 AND LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0)             /* NFS */
                           ) no-lock no-error.   
                IF NOT avail movto-estoq THEN DO:
                    find first movto-estoq
                         where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                           and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                           and movto-estoq.tipo-trans  = 1
                           and movto-estoq.dt-trans   <= tt-param.dt-corte
                           and movto-estoq.esp-docto  <> 33 /* <> transferencia*/ 
                           and movto-estoq.quantidade  > 0 no-lock no-error.  
                    IF NOT AVAIL movto-estoq THEN DO:
                        ASSIGN l-ignora = YES.
                        NEXT.
                    END.
                END.
            END.
        
            find first tt-movto-estoq
                 where tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos
                   and tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo no-error.
            if not avail tt-movto-estoq then do:
                create tt-movto-estoq.        
                assign tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                       tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos            
                       tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo.
            end.        

            assign tt-movto-estoq.qtidade-atu = tt-movto-estoq.qtidade-atu + /*saldo-estoq.qtidade-atu*/ de-saldo    
                   tt-movto-estoq.dt-trans    = if avail movto-estoq then movto-estoq.dt-trans else 01/01/1900
                   tt-movto-estoq.esp-docto   = if avail movto-estoq then {ininc/i03in218.i 4 movto-estoq.esp-docto} else ""
                   tt-movto-estoq.valor       = tt-movto-estoq.qtidade-atu * de-valor
                   tt-movto-estoq.consumo     = de-consumo
                   tt-movto-estoq.planejado   = de-planejado.
        END.
    END.
    ELSE DO:
        /*periodo*/

        RUN pi-calc-saldo(INPUT tt-param.dt-final).

        IF de-saldo = 0 THEN NEXT.

        ASSIGN l-valido   = NO
               i-nr-trans = 0.

        FIND FIRST b-tt-movto-estoq NO-LOCK
             WHERE b-tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
               AND b-tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
        IF AVAIL b-tt-movto-estoq THEN DO:
            find first tt-movto-estoq
                 where tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos
                   and tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo no-error.
            if not avail tt-movto-estoq then do:
                create tt-movto-estoq.        
                assign tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                       tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos            
                       tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo.
            end.        

            assign tt-movto-estoq.qtidade-atu = tt-movto-estoq.qtidade-atu + /*saldo-estoq.qtidade-atu*/ de-saldo    
                   tt-movto-estoq.dt-trans    = b-tt-movto-estoq.dt-trans
                   tt-movto-estoq.esp-docto   = b-tt-movto-estoq.esp-docto
                   tt-movto-estoq.valor       = tt-movto-estoq.qtidade-atu * de-valor
                   tt-movto-estoq.consumo     = de-consumo
                   tt-movto-estoq.planejado   = de-planejado.
        END.
        ELSE DO:
            IF AVAIL movto-estoq THEN RELEASE movto-estoq.
            IF de-saldo-ini-mes = 0  AND de-saldo <> 0 THEN DO:
                /*busca a ultima entrada pois teve movimenta‡Æo no mˆs e saldo inicial era zerado*/
                find last movto-estoq
                    where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                      and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                      and movto-estoq.dt-trans   >= tt-param.dt-corte - DAY(tt-param.dt-corte) 
                      and movto-estoq.dt-trans   <= tt-param.dt-corte 
                      and movto-estoq.tipo-trans  = 1
                      and movto-estoq.esp-docto  <> 33 /* <> transferencia*/ 
                      and movto-estoq.quantidade  > 0 no-lock no-error.   
            END.

            IF NOT AVAIL movto-estoq THEN DO:
                find first movto-estoq
                     where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                       and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                       AND movto-estoq.dt-trans   >= tt-param.dt-inicio
                       AND movto-estoq.dt-trans   <= tt-param.dt-final
                       AND movto-estoq.quantidade  > 0
                       and (movto-estoq.esp-docto  = 28            /* REQ */
                        or movto-estoq.esp-docto   = 23            /* NFT */   
                        OR (movto-estoq.esp-docto  = 30 AND ITEM.ge-codigo = 30) /* RM  */   
                        or (movto-estoq.esp-docto  = 22 AND LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0)             /* NFS */
                             ) no-lock no-error.   
                IF AVAIL movto-estoq THEN DO: 
                    ASSIGN l-ignora = YES.
                    NEXT.
                END.
                ELSE DO:
                    find first movto-estoq
                         where movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                           and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                           and movto-estoq.tipo-trans  = 1
                           and movto-estoq.esp-docto  <> 33 /* <> transferencia*/ 
                           and movto-estoq.quantidade  > 0 no-lock no-error.  
                END.
            END.

            find first tt-movto-estoq
                 where tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos
                   and tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo no-error.
            if not avail tt-movto-estoq then do:
                create tt-movto-estoq.        
                assign tt-movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                       tt-movto-estoq.cod-depos   = saldo-estoq.cod-depos            
                       tt-movto-estoq.it-codigo   = saldo-estoq.it-codigo.
            end.        

            assign tt-movto-estoq.qtidade-atu = tt-movto-estoq.qtidade-atu + /*saldo-estoq.qtidade-atu*/ de-saldo    
                   tt-movto-estoq.dt-trans    = if avail movto-estoq then movto-estoq.dt-trans else 01/01/1900
                   tt-movto-estoq.esp-docto   = if avail movto-estoq then {ininc/i03in218.i 4 movto-estoq.esp-docto} else ""
                   tt-movto-estoq.valor       = tt-movto-estoq.qtidade-atu * de-valor
                   tt-movto-estoq.consumo     = de-consumo
                   tt-movto-estoq.planejado   = de-planejado.
        END.
    END.
end procedure.

procedure pi-imprime-relat:
    def var c-traducao as char no-undo.

    for each tt-movto-estoq
       break by tt-movto-estoq.dt-trans:

        find item where
             item.it-codigo = tt-movto-estoq.it-codigo no-lock no-error.
             
        if not avail item then next.             
             
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo item: " + tt-movto-estoq.it-codigo).

        /*/*cristian*/
        find item-estab where
             item-estab.cod-estabel = tt-movto-estoq.cod-estabel and
             item-estab.it-codigo   = tt-movto-estoq.it-codigo no-lock no-error.

        if avail item-estab
             and item-estab.val-unit-mat-m[1] > 0 then
            assign tt-movto-estoq.valor = (tt-movto-estoq.qtidade-atu * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1])).
        else if avail item
                  and item.preco-ul-ent > 0 then
            assign tt-movto-estoq.valor = (tt-movto-estoq.qtidade-atu * item.preco-ul-ent).
        else
            assign tt-movto-estoq.valor = 0.                  */
               
        ASSIGN c-traducao = {ininc/i17in172.i 04 item.cod-obsoleto}
               tt-movto-estoq.desc-item = item.desc-item
               tt-movto-estoq.ge-codigo = ITEM.ge-codigo.
        
        IF ITEM.fm-cod-com <> "" THEN DO:
            FIND FIRST fam-com-item NO-LOCK
                 WHERE fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,2) NO-ERROR.
            IF AVAIL fam-com-item THEN
                ASSIGN tt-movto-estoq.unid-negoc = fam-com-item.descricao.
        END.

        FIND FIRST tt-saldo NO-LOCK
             WHERE tt-saldo.it-codigo = tt-movto-estoq.it-codigo NO-ERROR.
        IF AVAIL tt-saldo THEN
            ASSIGN tt-movto-estoq.meses = IF tt-movto-estoq.consumo = 0 THEN 0 ELSE tt-saldo.qtidade-atu / tt-movto-estoq.consumo.
        ELSE
            ASSIGN tt-movto-estoq.meses = 0.

        run utp/ut-liter.p (INPUT REPLACE(c-traducao," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN tt-movto-estoq.situacao = c-traducao.
        
        if tt-movto-estoq.dt-trans = 01/01/1900 then
            assign c-data = "SEM MOVTO".
        else
            assign c-data = string(tt-movto-estoq.dt-trans).
            
        if tt-movto-estoq.dt-trans < (today - 90) and
           tt-movto-estoq.dt-trans > (today - 180) then
            assign de-vlr-1 = de-vlr-1 + tt-movto-estoq.valor.
        else if tt-movto-estoq.dt-trans <= (today - 180) 
            and tt-movto-estoq.dt-trans > (today - 360) then
            assign de-vlr-2 = de-vlr-2 + tt-movto-estoq.valor.
        else assign de-vlr-3 = de-vlr-3 + tt-movto-estoq.valor.

        IF tt-param.i-tipo-consumo = 1 THEN DO:
            disp tt-movto-estoq.cod-estabel
                 da-data-corte 
                 tt-movto-estoq.it-codigo                 
                 tt-movto-estoq.desc-item
                 tt-movto-estoq.ge-codigo
                 tt-movto-estoq.unid-negoc
                 tt-movto-estoq.situacao 
                 tt-movto-estoq.cod-depos                
                 tt-movto-estoq.esp-docto
                 tt-movto-estoq.qtidade-atu               
                 tt-movto-estoq.valor
                 c-data
                 tt-movto-estoq.consumo
                 tt-movto-estoq.meses
                 with frame f-relat.             

            down with frame f-relat.
        END.
        ELSE DO:
            disp tt-movto-estoq.cod-estabel
                 da-data-corte 
                 tt-movto-estoq.it-codigo                 
                 tt-movto-estoq.desc-item
                 tt-movto-estoq.ge-codigo
                 tt-movto-estoq.unid-negoc
                 tt-movto-estoq.situacao 
                 tt-movto-estoq.cod-depos                
                 tt-movto-estoq.esp-docto
                 tt-movto-estoq.qtidade-atu               
                 tt-movto-estoq.valor
                 c-data
                 tt-movto-estoq.consumo
                 tt-movto-estoq.planejado
                 tt-movto-estoq.meses
                 with frame f-relat2.             

            down with frame f-relat2.
        END.
    end.
    
    if de-vlr-1 > 0 or
       de-vlr-2 > 0 or
       de-vlr-3 > 0 then do:
       
        if line-counter >= 60 then
            page.
        else    
            put " " skip(1).            
            
        if de-vlr-1 > 0 then
            put "Valor >  90 dias: " at 88
                de-vlr-1 to 122 skip.
        if de-vlr-2 > 0 then
            put "Valor > 180 dias: " at 88
                de-vlr-2 to 122 skip.
        if de-vlr-3 > 0 then
            put "Valor > 360 dias: " at 88
                de-vlr-3 to 122 skip.
    end.    
end procedure.

procedure pi-imprime-param.
    if line-counter >= 50 then
        page.
    else
        put " " skip(2).
    
    ASSIGN c-tipo = STRING(tt-param.i-tipo) + "-" + IF tt-param.i-tipo = 1 THEN "Data Corte" ELSE "Periodo".

    IF tt-param.i-tipo = 1 THEN
        display c-sel
                tt-param.c-it-codigo-ini
                tt-param.c-it-codigo-fim
                c-tipo
                tt-param.dt-corte with frame f-param-corte.
    ELSE 
        display c-sel
                tt-param.c-it-codigo-ini
                tt-param.c-it-codigo-fim
                c-tipo
                tt-param.dt-inicio
                tt-param.dt-final with frame f-param-periodo.

    display c-imp
            c-lb-destino
            tt-param.arquivo
            c-lb-usuario
            tt-param.usuario            
            with frame f-parametros.
            
    if can-find (first tt-digita) then do:
        put "Digita‡Æo: " at 04 skip(1).
        
        for each tt-digita:
            put tt-digita.it-codigo at 04.
        end.    
    end.
end procedure.

PROCEDURE pi-calc-saldo:
    DEFINE INPUT PARAMETER p-data AS DATE NO-UNDO.

    IF p-data <> TODAY THEN DO:
        IF MONTH(p-data) = MONTH(TODAY) AND 
           YEAR(p-data)  = YEAR(TODAY) THEN DO:

            DO dt-data = p-data + 1 TO TODAY:
                FOR EACH movto-estoq NO-LOCK
                   WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                     AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                     AND movto-estoq.dt-trans    = dt-data
                     AND movto-estoq.cod-depos   = saldo-estoq.cod-depos:
                    IF movto-estoq.tipo-trans = 1 THEN
                        ASSIGN de-saldo = de-saldo - movto-estoq.quantidade.
                    ELSE
                        ASSIGN de-saldo = de-saldo + movto-estoq.quantidade.
                END.
            END.

            IF de-valor = 0 THEN DO:
                FIND FIRST item-estab NO-LOCK 
                     WHERE item-estab.cod-estabel = saldo-estoq.cod-estabel
                       AND item-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
                IF AVAIL item-estab AND item-estab.val-unit-mat-m[1] > 0 THEN
                    ASSIGN de-valor = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].
                ELSE IF ITEM.preco-ul-ent > 0 THEN
                    ASSIGN de-valor = item.preco-ul-ent.
            END.
        END.
        ELSE DO:
            ASSIGN de-saldo-aux = 0
                   l-achou-saldo = NO.
            FOR EACH sl-it-per NO-LOCK
               WHERE sl-it-per.it-codigo   = saldo-estoq.it-codigo
                 AND sl-it-per.cod-depos   = saldo-estoq.cod-depos
                 AND sl-it-per.cod-estabel = saldo-estoq.cod-estabel
                 AND sl-it-per.periodo     = dt-ultdia-mes:
                ASSIGN de-saldo-aux = de-saldo-aux + sl-it-per.quantidade
                       l-achou-saldo = YES.
            END.

            IF NOT l-achou-saldo THEN DO:
                /*se nao encontrar saldo no ultimo dia do mes, recalcula com saldo atual*/
                DO dt-data = p-data + 1 TO TODAY:
                    FOR EACH movto-estoq NO-LOCK
                       WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                         AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                         AND movto-estoq.dt-trans    = dt-data
                         AND movto-estoq.cod-depos   = saldo-estoq.cod-depos:
                        IF movto-estoq.tipo-trans = 1 THEN
                            ASSIGN de-saldo = de-saldo - movto-estoq.quantidade.
                        ELSE
                            ASSIGN de-saldo = de-saldo + movto-estoq.quantidade.
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN de-saldo = de-saldo-aux.
                DO dt-data = p-data + 1 TO dt-ultdia-mes:
                    FOR EACH movto-estoq NO-LOCK
                       WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo 
                         AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                         AND movto-estoq.dt-trans    = dt-data
                         AND movto-estoq.cod-depos   = saldo-estoq.cod-depos:
                        IF movto-estoq.tipo-trans = 1 THEN
                            ASSIGN de-saldo = de-saldo - movto-estoq.quantidade.
                        ELSE
                            ASSIGN de-saldo = de-saldo + movto-estoq.quantidade.
                    END.
                END.
            END.

            IF de-valor = 0 THEN DO:
                IF p-data = dt-ultdia-mes THEN DO:
                    ASSIGN de-valor = 0.
                    FOR EACH pr-it-per NO-LOCK
                       WHERE pr-it-per.it-codigo   = saldo-estoq.it-codigo
                         AND pr-it-per.cod-estabel = saldo-estoq.cod-estabel
                         AND pr-it-per.periodo     = dt-ultdia-mes:

                        ASSIGN de-valor = de-valor + pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].
                    END.

                    IF de-valor = 0 THEN DO:
                        ASSIGN de-valor = 0.
                        FOR EACH pr-it-per NO-LOCK
                           WHERE pr-it-per.it-codigo   = saldo-estoq.it-codigo
                             AND pr-it-per.cod-estabel = saldo-estoq.cod-estabel
                             AND pr-it-per.periodo     = dt-ultdia-mes-ant:

                            ASSIGN de-valor = de-valor + pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN de-valor = 0.
                    FOR EACH pr-it-per NO-LOCK
                       WHERE pr-it-per.it-codigo   = saldo-estoq.it-codigo
                         AND pr-it-per.cod-estabel = saldo-estoq.cod-estabel
                         AND pr-it-per.periodo     = dt-ultdia-mes-ant:

                        ASSIGN de-valor = de-valor + pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].
                    END.
                END.
            END.
        END.
    END.

    IF de-valor = 0 THEN DO:
        FIND FIRST item-estab NO-LOCK 
             WHERE item-estab.cod-estabel = saldo-estoq.cod-estabel
               AND item-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
        IF AVAIL item-estab AND item-estab.val-unit-mat-m[1] > 0 THEN
            ASSIGN de-valor = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].
        ELSE IF ITEM.preco-ul-ent > 0 THEN
            ASSIGN de-valor = item.preco-ul-ent.
    END.


    FIND FIRST tt-saldo NO-LOCK
         WHERE tt-saldo.it-codigo = saldo-estoq.it-codigo NO-ERROR.
    IF NOT AVAIL tt-saldo THEN DO:
        CREATE tt-saldo.
        ASSIGN tt-saldo.it-codigo = saldo-estoq.it-codigo.
    END.
    ASSIGN tt-saldo.qtidade-atu = tt-saldo.qtidade-atu + de-saldo.

    /*busca consumo ultimos 3 meses*/
    ASSIGN de-consumo = 0.
    FIND FIRST tt-consumo NO-LOCK
         WHERE tt-consumo.it-codigo = saldo-estoq.it-codigo 
           AND tt-consumo.data-fim  = dt-ultdia-mes NO-ERROR.
    IF NOT AVAIL tt-consumo THEN DO:

        DO dt-data = dt-ini-cons TO dt-ultdia-mes:
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo
                 AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                 AND movto-estoq.dt-trans    = dt-data
                 AND movto-estoq.quantidade  > 0
                 AND (movto-estoq.esp-docto  = 28            /* REQ */
                  OR movto-estoq.esp-docto   = 23            /* NFT */   
                  OR (movto-estoq.esp-docto  = 30 AND ITEM.ge-codigo = 30) /* RM  */   
                  or (movto-estoq.esp-docto  = 22 AND LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0)             /* NFS */
                  ):

                /*IF  movto-estoq.esp-docto = 33 OR movto-estoq.esp-docto = 21 THEN NEXT.*/

                /*IF movto-estoq.esp-docto  = 22 THEN DO:
                    FIND FIRST natur-oper NO-LOCK
                         WHERE natur-oper.nat-operacao = movto-estoq.nat-operacao NO-ERROR.
                    IF AVAIL natur-oper AND NOT natur-oper.emite-duplic THEN NEXT.
                END.*/

                ASSIGN de-consumo = de-consumo + movto-estoq.quantidade.

                /*IF movto-estoq.tipo-trans = 2 THEN
                    ASSIGN de-consumo = de-consumo + movto-estoq.quantidade.
                ELSE 
                    ASSIGN de-consumo = de-consumo - movto-estoq.quantidade.*/
            END.
        END.

        FIND FIRST tt-consumo NO-LOCK
             WHERE tt-consumo.it-codigo = saldo-estoq.it-codigo 
               AND tt-consumo.data-fim  = dt-ultdia-mes NO-ERROR.
        IF NOT AVAIL tt-consumo THEN DO:
            CREATE tt-consumo.
            ASSIGN tt-consumo.it-codigo = saldo-estoq.it-codigo 
                   tt-consumo.data-fim  = dt-ultdia-mes
                   tt-consumo.consumo   = IF de-consumo < 0 THEN 0 ELSE de-consumo / 6.
        END.
    END.
    ASSIGN de-consumo = tt-consumo.consumo.

    IF tt-param.i-tipo-consumo = 2 THEN DO:
        /*busca consumo atrav‚s do planejamento - pr¢ximos 90 dias (3 meses) apartir do mes posteior a data informada*/
        ASSIGN de-planejado = 0.
        FIND FIRST tt-consumo NO-LOCK
             WHERE tt-consumo.it-codigo = saldo-estoq.it-codigo 
               AND tt-consumo.data-fim  = dt-ultdia-mes NO-ERROR.
        IF NOT AVAIL tt-consumo OR tt-consumo.planejado = 0 THEN DO:
            for each it-periodo no-lock use-index data
               where it-periodo.cod-estabel     = saldo-estoq.cod-estabel
                 AND it-periodo.num-calc-plano  = i-num-calc-plano
                 AND it-periodo.it-codigo       = saldo-estoq.it-codigo 
                 AND it-periodo.data           >= dt-ini-plan
                 AND it-periodo.data           <= dt-fim-plan:
                
                ASSIGN de-planejado = de-planejado + it-periodo.qt-res-plan /*it-periodo.qt-res-plan + it-periodo.qt-ord-plan */ .
            end.

            FIND FIRST tt-consumo NO-LOCK
                 WHERE tt-consumo.it-codigo = saldo-estoq.it-codigo 
                   AND tt-consumo.data-fim  = dt-ultdia-mes NO-ERROR.
            IF NOT AVAIL tt-consumo THEN DO:
                CREATE tt-consumo.
                ASSIGN tt-consumo.it-codigo = saldo-estoq.it-codigo 
                       tt-consumo.data-fim  = dt-ultdia-mes
                       tt-consumo.planejado = IF de-planejado <= 0 THEN 0 ELSE de-planejado / tt-param.i-meses.
            END.
            ELSE 
                ASSIGN tt-consumo.planejado = IF de-planejado <= 0 THEN 0 ELSE de-planejado / tt-param.i-meses.
        END.
        ASSIGN de-planejado = tt-consumo.planejado.
    END.

    ASSIGN de-saldo-ini-mes = 0.
    IF de-saldo <> 0 THEN DO:
        FOR EACH sl-it-per NO-LOCK
           WHERE sl-it-per.it-codigo   = saldo-estoq.it-codigo
             AND sl-it-per.cod-depos   = saldo-estoq.cod-depos
             AND sl-it-per.cod-estabel = saldo-estoq.cod-estabel
             AND sl-it-per.periodo     = dt-ultdia-mes - DAY(dt-ultdia-mes)  /*saldo mˆs anterior*/ :
            ASSIGN de-saldo-ini-mes = de-saldo-ini-mes + sl-it-per.quantidade.
        END.
    END.
END PROCEDURE.
