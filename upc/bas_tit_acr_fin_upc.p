DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_dat_vencto_tit_acr_acr212aa     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_tx_dat_vencto_tit_acr_acr212aa  AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    CREATE TEXT h_tx_dat_vencto_tit_acr_acr212aa
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(12)"   
           WIDTH        = 9
           SCREEN-VALUE = "Dt Vencto:"
           ROW          = 3.8
           COL          = 68
           VISIBLE      = YES.

    CREATE FILL-IN h_dat_vencto_tit_acr_acr212aa
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "DATE"
           FORMAT            = "99/99/9999" 
           WIDTH             = 11
           HEIGHT            = .88
           ROW               = 3.7
           COL               = 75.6
           VISIBLE           = YES
           SENSITIVE         = NO.
    
END.

IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST tit_acr NO-LOCK
        WHERE RECID(tit_acr) = p-row-table NO-ERROR.

    IF AVAIL tit_acr THEN
        ASSIGN h_dat_vencto_tit_acr_acr212aa:SCREEN-VALUE = STRING( tit_acr.dat_vencto_tit_acr).
    ELSE
        ASSIGN h_dat_vencto_tit_acr_acr212aa:SCREEN-VALUE = "".
END.

/*
MESSAGE 
p-ind-event 
p-ind-object
string(p-wgh-object)
STRING(p-row-table)
STRING(p-wgh-frame)
p-cod-table SKIP
c-objeto VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
