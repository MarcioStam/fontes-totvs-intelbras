DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.
DEFINE VARIABLE c-objeto   AS CHAR        NO-UNDO.

DEFINE VARIABLE h-cd0920-upc AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-mod-cd0920    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tp-codigo-cd0284 AS WIDGET-HANDLE NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "/":U), p-wgh-object:FILE-NAME, "/":U).

IF  p-ind-event  = "DISPLAY" 
AND p-ind-object = "VIEWER" THEN DO:

    FIND FIRST tipo-rec-desp NO-LOCK
         WHERE ROWID(tipo-rec-desp) = p-row-table NO-ERROR.

    IF  AVAIL tipo-rec-desp
    AND tipo-rec-desp.tipo = 2 THEN DO:
        IF VALID-HANDLE(wh-bt-mod-cd0920) THEN
            ASSIGN wh-bt-mod-cd0920:SENSITIVE = YES.
    END.
    ELSE DO:
        IF VALID-HANDLE(wh-bt-mod-cd0920) THEN
            ASSIGN wh-bt-mod-cd0920:SENSITIVE = NO.
    END.
END.

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "VIEWER" THEN DO:
    run pi-busca-handle (INPUT p-wgh-frame,
                         INPUT p-ind-event,
                         INPUT 'fill-in':U,
                         INPUT 'tp-codigo':U,
                         INPUT NO,
                         OUTPUT wh-tp-codigo-cd0284).

END.

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    RUN upc/cd0920-upc.p PERSISTENT SET h-cd0920-upc (INPUT "":U,
                                                      INPUT "":U,
                                                      INPUT p-wgh-object,
                                                      INPUT p-wgh-frame,
                                                      INPUT "",
                                                      INPUT p-row-table).

    CREATE BUTTON wh-bt-mod-cd0920
    ASSIGN NAME       = "wh-bt-mod":U
           FRAME      = p-wgh-frame
           WIDTH      = 4
           HEIGHT     = 1.18
           COLUMN     = 58
           ROW        = 1.35
           SENSITIVE  = YES
           VISIBLE    = YES
        TRIGGERS:
            ON "CHOOSE":U PERSISTENT RUN pi-choose-bt IN h-cd0920-upc.
        END TRIGGERS.

    wh-bt-mod-cd0920:LOAD-IMAGE("image/im-mod.bmp":U).
    wh-bt-mod-cd0920:MOVE-TO-TOP().

    ASSIGN h-cd0920-upc = ?.
END.

PROCEDURE pi-choose-bt:
    RUN esp/cdp/escdp082.w (INPUT INT(wh-tp-codigo-cd0284:SCREEN-VALUE)).

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-obj):
        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto " wgh-obj:NAME SKIP
                    "Type do Objeto " wgh-obj:TYPE skip
                    "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF wgh-obj:TYPE = pObjType AND 
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.

