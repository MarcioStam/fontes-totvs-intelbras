define new global shared var whInsEstadual     as widget-handle no-undo.
define new global shared var whInsEstadualCob  as widget-handle no-undo.

IF VALID-HANDLE(whInsEstadualCob) AND VALID-HANDLE(whInsEstadual) THEN
    IF whInsEstadualCob:SCREEN-VALUE = "" THEN
        ASSIGN whInsEstadualCob:SCREEN-VALUE = whInsEstadual:SCREEN-VALUE.
