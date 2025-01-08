/***********************************************************************
**  Programa..: ESP\REP\ESCSP004RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: FEVEREIRO/2009 - Desenvolvimento
**  Descricao.: Relat¢rio Pre‡os/Custo/Fator
**  VersÆo....: 001 04/02/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESSCP004RP 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/csp/escsp004tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Custo/M‚dio/Pre‡o"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESUTP007"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}

    IF tt-param.excel THEN DO:
        {include/i-rpout.i &pagesize="0"}
    END.
    ELSE DO:
        {include/i-rpout.i}

        VIEW FRAME f-cabec.
        VIEW FRAME f-rodape.
    END.


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-relatorio.
    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-relatorio:
    DEFINE VARIABLE de-indice-int AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-preco-un-int AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-preco-conv AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-preco-conv-imp AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-perc AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-imposto  AS DECIMAL   FORMAT ">>9.99999"  NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    IF tt-param.excel THEN
        PUT UNFORMATTED 
            "Item;Pre‡o M‚dio;Pre‡o Ult.Ent;Pre‡o Conv.;Pre‡o Forn.;ConversÆo;Percentual;" SKIP.
    ELSE
        PUT UNFORMATTED 
            "Item                                   Est    Preco M‚dio  Preco Ult.Ent    Preco Conv.    Preco Forn.      ConversÆo     Percentual" SKIP
            "-------------------------------------- --- -------------- -------------- -------------- -------------- -------------- --------------" SKIP.
    FOR EACH ITEM NO-LOCK 
       WHERE ITEM.it-codigo >= tt-param.it-codigo-ini
         AND ITEM.it-codigo <= tt-param.it-codigo-fim:
        
        FOR EACH item-estab NO-LOCK
           WHERE item-estab.it-codigo = ITEM.it-codigo
             AND item-estab.cod-estabel >= tt-param.cod-estabel-ini
             AND item-estab.cod-estabel <= tt-param.cod-estabel-fim:

            ASSIGN de-preco-conv     = 0
                   de-preco-un-int   = 0
                   de-preco-conv-imp = 0
                   de-perc           = 0
                   de-imposto        = 0.
    
            FIND FIRST item-fornec NO-LOCK
                 WHERE item-fornec.it-codigo = ITEM.it-codigo 
                   AND item-fornec.ativo NO-ERROR.
            IF AVAIL item-fornec THEN DO:
                FOR FIRST tb-pr-cc WHERE 
                          tb-pr-cc.cod-emitente = item-fornec.cod-emitente AND   
                          tb-pr-cc.cod-cond-pag = item-fornec.cod-cond-pag AND
                          tb-pr-cc.situacao = 1 AND 
                          tb-pr-cc.dt-termino >= TODAY NO-LOCK:
                    FIND FIRST item-tab 
                         WHERE item-tab.cod-emitente = item-fornec.cod-emitente 
                           AND item-tab.cod-cond-pag = item-fornec.cod-cond-pag 
                           AND item-tab.nr-tab       = tb-pr-cc.nr-tab 
                           AND item-tab.it-codigo    = item-fornec.it-codigo 
                           AND item-tab.situacao     = 1 NO-LOCK NO-ERROR.
                END.
            END.
    
            IF AVAIL item-fornec THEN
               FIND emitente WHERE emitente.cod-emitente = item-tab.cod-emitente NO-LOCK NO-ERROR.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(ITEM.it-codigo)).
    
            IF AVAIL item-fornec AND item-fornec.unid-med-for <> ITEM.un THEN
                ASSIGN de-indice-int = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
            ELSE 
                ASSIGN de-indice-int = 1.
    
            IF AVAIL item-fornec AND
               AVAIL tb-pr-cc AND
               AVAIL item-tab THEN
                ASSIGN de-preco-un-int = item-tab.pr-item * de-indice-int.
            ELSE 
                ASSIGN de-preco-un-int = 0.
    
            IF AVAIL tb-pr-cc AND tb-pr-cc.mo-codigo = 0 THEN
                ASSIGN de-preco-conv = de-preco-un-int.
            ELSE DO:
                IF AVAIL tb-pr-cc THEN DO:
                   RUN "cdp/cd0812.p" (INPUT tb-pr-cc.mo-codigo,
                                       INPUT 0,
                                       INPUT de-preco-un-int,
                                       INPUT TODAY,
                                       OUTPUT de-preco-conv).
                END.
                ELSE ASSIGN de-preco-conv = 0.
            END.
    
            IF de-preco-conv = ? THEN ASSIGN de-preco-conv = 0. 

            ASSIGN de-preco-conv-imp = de-preco-conv.
    
            IF AVAIL emitente AND emitente.natureza <= 2 THEN
                ASSIGN de-imposto        = 1 - ((item-tab.aliquota-icm + 7.6 + 1.65) / 100)
                       de-preco-conv     = de-preco-conv * de-imposto.
    
            IF de-preco-conv > item.preco-ul-ent THEN
                ASSIGN de-perc = (1 - (item.preco-ul-ent / de-preco-conv)) * 100 * -1.
                /*ASSIGN de-perc = (1 - (de-preco-conv / item.preco-ul-ent)) * 100.*/
            ELSE 
                ASSIGN de-perc = ((item.preco-ul-ent / de-preco-conv) - 1) * 100. 
                /*ASSIGN de-perc = (1 - (item.preco-ul-ent / de-preco-conv)) * 100 * -1.**/
    
            IF de-perc = ? THEN
                ASSIGN de-perc = 0.
    
            ASSIGN de-preco-conv-imp = de-preco-conv-imp / de-preco-un-int.

            IF de-preco-conv-imp = ? THEN
                ASSIGN de-preco-conv-imp = 0.

            IF tt-param.excel THEN
                PUT UNFORMATTED 
                     trim(STRING(ITEM.it-codigo)) + " - " + trim(STRING(ITEM.desc-item)) FORMAT "x(48)" ";"
                     item-estab.cod-estabel          FORMAT "x(03)"          ";"
                     item-estab.val-unit-mat-m[1]    FORMAT "->>>,>>9.99999" ";"
                     item.preco-ul-ent               FORMAT "->>>,>>9.99999" ";"
                     de-preco-conv                   FORMAT "->>>,>>9.99999" ";"
                     de-preco-un-int                 FORMAT "->>>,>>9.99999" ";"
                     de-preco-conv-imp               FORMAT "->>>,>>9.99999" ";"
                     de-perc                         FORMAT "->>>,>>9.99999" ";" SKIP.
            ELSE
                PUT UNFORMATTED 
                     trim(STRING(ITEM.it-codigo)) + " - " + trim(STRING(ITEM.desc-item)) FORMAT "x(38)" AT 01
                     item-estab.cod-estabel          FORMAT "x(03)"          AT 40
                     item-estab.val-unit-mat-m[1]    FORMAT "->>>,>>9.99999" TO 57
                     item.preco-ul-ent               FORMAT "->>>,>>9.99999" TO 72
                     de-preco-conv                   FORMAT "->>>,>>9.99999" TO 87
                     de-preco-un-int                 FORMAT "->>>,>>9.99999" TO 102
                     de-preco-conv-imp               FORMAT "->>>,>>9.99999" TO 117
                     de-perc                         FORMAT "->>>,>>9.99999" TO 132 SKIP.
        END.
    END.
END PROCEDURE.
