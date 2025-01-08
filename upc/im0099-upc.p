DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.


DEFINE VARIABLE c-objeto     AS CHAR        NO-UNDO.
DEFINE VARIABLE h-frame      AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-fPage1    AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-im0099-upc AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-browse-im0099   AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-query-im0099    AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-buffer-im0099   AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-qtd-im0099       AS HANDLE        NO-UNDO.

IF p-ind-event  = "AFTER-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.

    /*Pega handle da fPage1*/
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:NAME = "fPage1":U THEN DO:
            ASSIGN wh-fPage1 = h-frame:HANDLE.
            LEAVE.
        END.

        IF h-frame:TYPE = "field-group":U THEN
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        ELSE
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
    END.

    /*Pega Hanlde do browse*/
    ASSIGN wh-fPage1 = wh-fPage1:FIRST-CHILD.
    DO WHILE VALID-HANDLE(wh-fPage1):
        
        IF wh-fPage1:NAME = "brSon1":U THEN DO:
            ASSIGN wh-browse-im0099 = wh-fPage1:HANDLE.
            LEAVE.
        END.

        IF wh-fPage1:TYPE = "field-group":U THEN
            ASSIGN wh-fPage1 = wh-fPage1:FIRST-CHILD.
        ELSE
            ASSIGN wh-fPage1 = wh-fPage1:NEXT-SIBLING.
    END.

     ASSIGN wh-query-im0099  = wh-browse-im0099:QUERY
            wh-buffer-im0099 = wh-query-im0099:GET-BUFFER-HANDLE(1)
            h-qtd-im0099     = wh-buffer-im0099:BUFFER-FIELD("de-quantidade-nac").

    RUN upc/im0099-upc.p PERSISTENT SET h-im0099-upc (INPUT "":U,
                                                      INPUT "":U,
                                                      INPUT p-wgh-object,
                                                      INPUT p-wgh-frame,
                                                      INPUT "",
                                                      INPUT p-row-table).

    IF VALID-HANDLE(wh-browse-im0099) THEN
        ON "MOUSE-SELECT-DBLCLICK":U OF wh-browse-im0099 PERSISTENT RUN pi-mouse-select-blclick IN h-im0099-upc.

END.

PROCEDURE pi-mouse-select-blclick:
    ASSIGN h-qtd-im0099:BUFFER-VALUE = wh-browse-im0099:GET-BROWSE-COLUMN(6):SCREEN-VALUE
           wh-browse-im0099:GET-BROWSE-COLUMN(8):SCREEN-VALUE = wh-browse-im0099:GET-BROWSE-COLUMN(6):SCREEN-VALUE.
END PROCEDURE.
