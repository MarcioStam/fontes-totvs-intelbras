/* -------------------------------------------------------------------------------------------------------------
Programa : upc/acr729ab_upc.p
-------------------------------------------------------------------------------------------------------------- */

DEF INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table  AS RECID         NO-UNDO.

DEF VAR c-objeto     AS CHAR          NO-UNDO.
DEF VAR wh_tx_matriz AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_matriz AS WIDGET-HANDLE NO-UNDO.

/*
MESSAGE "p-ind-event "   p-ind-event   skip
        "p-ind-object "  p-ind-object  skip
        "p-wgh-object "  p-wgh-object  skip
        "p-wgh-frame "   p-wgh-frame   skip
        "p-cod-table "   p-cod-table  
        VIEW-AS ALERT-BOX.
*/

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF  p-ind-event = 'INITIALIZE' THEN DO:

    CREATE TEXT wh_tx_matriz
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(12)"
           WIDTH        = 11
           SCREEN-VALUE = "Cod Matriz:"
           ROW          = 6.7
           COL          = 66
           VISIBLE      = YES.

    CREATE FILL-IN wh_matriz
    ASSIGN NAME       = 'wh_matriz':U
           FRAME      = p-wgh-frame
           ROW        = 6.6
           COLUMN     = 74
           HEIGHT     = 0.88
           WIDTH      = 12
           DATA-TYPE  = "Integer"
           FORMAT     = ">>>>>>>>9"
           TOOLTIP    = "C¢digo da Matriz"
           HELP       = "C¢digo da Matriz"
           VISIBLE    = TRUE
           SENSITIVE  = YES.
END.

IF  p-ind-event = 'Valida t¡tulo':U THEN DO:

    IF  VALID-HANDLE(wh_matriz) THEN DO:
        IF  INT(STRING(wh_matriz:SCREEN-VALUE)) <> 0 THEN DO:
            
            FIND FIRST tit_acr
                WHERE RECID(tit_acr) = p-row-table NO-LOCK NO-ERROR.

            IF  AVAIL tit_acr THEN DO:

                IF  INT(STRING(wh_matriz:SCREEN-VALUE)) <> tit_acr.cdn_clien_matriz THEN
                    RETURN "NOK".
            END.
        END.
    END.
END.

RETURN "OK".
