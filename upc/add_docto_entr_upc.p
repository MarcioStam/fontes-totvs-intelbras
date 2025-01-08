DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table      AS RECID            NO-UNDO.

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

/*
MESSAGE "p-ind-event "  p-ind-event           SKIP
        "p-ind-object " p-ind-object          SKIP
        "p-wgh-object " string(p-wgh-object)  SKIP
        "p-rec-table "  STRING(p-rec-table)   SKIP
        "p-wgh-frame "  STRING(p-wgh-frame)   SKIP
        "p-cod-table "  p-cod-table           SKIP
        "c-objeto "     c-objeto 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF  p-ind-event  = "VALIDATE" 
AND p-ind-object = "VIEWER" THEN DO:

    FIND FIRST docto_ent
        WHERE recid(docto_entr) = p-rec-table NO-LOCK NO-ERROR.

    IF  AVAIL docto_entr 
    AND docto_entr.cdn_fornecedor = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Fornecedor deve ser diferente de zero ! ~~ " +
                                 "Ser  necess rio informar fornecedor diferente de zero.").
        RETURN "NOK". 
    END.
END.
