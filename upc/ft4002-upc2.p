/* ----------------------------------------------------------------------------
   Programa..: upc/ft4002-upc2.p
   Data......: Junho/2015
   Autor.....: Rubia Oliveira - SENSUS.
   Objetivo..: tratativa TNF
---------------------------------------------------------------------------- */


DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-FT4002           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-row-pedido                  AS ROWID         NO-UNDO.

IF  VALID-HANDLE(wh-cod-depos-FT4002   ) THEN DO:

    FIND FIRST ped-venda 
        WHERE rowid(ped-venda) = p-row-pedido NO-LOCK NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        FIND FIRST int-ped-venda
        WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.  
        IF AVAIL int-ped-venda THEN DO: 

            IF SUBSTRING(int-ped-venda.char-1, 11, 1) = "S" THEN DO:
                IF wh-cod-depos-FT4002:SCREEN-VALUE <> "TNF" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Dep¢sito Inv†lido! ~~ Pedido Ç TNF!":U).
                    ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE = "TNF".
                    RETURN NO-APPLY.
                END.
            END.
            ELSE DO:
                IF wh-cod-depos-FT4002:SCREEN-VALUE = "TNF" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Dep¢sito Inv†lido! ~~ Pedido n∆o Ç TNF!":U).
                    ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE = " ".
                    RETURN NO-APPLY.
                END.
            END.

        END. /* IF AVAIL int-ped-venda THEN DO: */

    END. /* IF AVAIL ped-venda THEN DO: */

END.
