/* -------------------------------------------------------------------------------------------------------------
Programa : upc/utb112aa_add.p
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-toggle-bas-utb112 AS WIDGET-HANDLE    NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    create TOGGLE-BOX wh-toggle-bas-utb112
    assign frame       = p-wgh-frame
           width       = 12 
           row         = 03.75
           col         = 63 
           HEIGHT      = 0.88
           HIDDEN      = NO
           sensitive   = NO
           VISIBLE     = YES
           LABEL       = "Ativo".   
    
END.

IF p-ind-event = "DISPLAY" AND
   p-ind-object = "VIEWER" THEN DO:

    FIND FIRST representante
        WHERE RECID(representante) = p-row-table NO-LOCK NO-ERROR.
    IF AVAIL representante THEN DO:
        FIND FIRST int-repres
            WHERE int-repres.cod-repres = representante.cdn_repres NO-LOCK NO-ERROR.
        IF AVAIL int-repres THEN DO:
            IF SUBSTRING(char-1,3,1) = "s" THEN
                ASSIGN wh-toggle-bas-utb112:CHECKED = YES.
            ELSE
                ASSIGN wh-toggle-bas-utb112:CHECKED = NO.
        END.
    END.
 END.


