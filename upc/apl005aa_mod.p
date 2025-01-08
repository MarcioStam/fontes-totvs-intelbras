/* -------------------------------------------------------------------------------------------------------------
Programa : upc/apl005aa_mod.p
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-combo-mod AS WIDGET-HANDLE    NO-UNDO.


ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    create combo-box wh-combo-mod
    assign frame       = p-wgh-frame
           data-type   = "character"
           format      = "x(10)"
           width       = 12
           row         = 03.85
           col         = 42 
           HIDDEN      = no
           inner-lines = 4
           sensitive   = no
           VISIBLE     = YES
           list-items = "CCB,FINEP,PROCOMP,FINAME,FINIMP,BRDE,PRODEC,BNDES,     ".   
               
END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-combo-mod:SENSITIVE = yes.
END.

IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST produt_financ WHERE RECID(produt_financ) = p-row-table.

    ASSIGN wh-combo-mod:SENSITIVE    = NO
           wh-combo-mod:SCREEN-VALUE = "     ".

    FOR FIRST int_produt_financ OF produt_financ:
        ASSIGN wh-combo-mod:SCREEN-VALUE = int_produt_financ.tip_produt_financ.
    END.

END.

IF p-ind-event = "ASSIGN" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST produt_financ WHERE RECID(produt_financ) = p-row-table.
    FIND FIRST int_produt_financ OF produt_financ EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL int_produt_financ 
    THEN DO:
         CREATE int_produt_financ.
    END.
    ASSIGN int_produt_financ.cod_produt_financ = produt_financ.cod_produt_financ
           int_produt_financ.tip_produt_financ = wh-combo-mod:SCREEN-VALUE.

END.
