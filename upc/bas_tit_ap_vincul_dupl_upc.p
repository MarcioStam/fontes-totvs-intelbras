DEF INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table  AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_v_dat_transacao AS HANDLE NO-UNDO.

IF  p-ind-event = "INITIALIZE" THEN DO:
    RUN piFindWidget(INPUT "v_dat_transacao", 
                     INPUT "FILL-IN", 
                     INPUT p-wgh-frame, 
                     OUTPUT h_v_dat_transacao).
END.

IF  p-ind-event = "ENABLE" THEN DO:
    IF  VALID-HANDLE(h_v_dat_transacao) THEN DO:
        ASSIGN h_v_dat_transacao:SCREEN-VALUE = string(TODAY - 1).
    END.
END.

PROCEDURE piFindWidget:
    DEF INPUT  PARAM c-widget-name  AS CHAR   NO-UNDO.
    DEF INPUT  PARAM c-widget-type  AS CHAR   NO-UNDO.
    DEF INPUT  PARAM h-start-widget AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM h-widget       AS HANDLE NO-UNDO.

    DO WHILE VALID-HANDLE(h-start-widget):
        IF  h-start-widget:NAME = c-widget-name
        AND h-start-widget:TYPE = c-widget-type THEN DO:
            
            ASSIGN h-widget = h-start-widget:HANDLE.
            LEAVE.
        END.

        IF  h-start-widget:TYPE = "field-group":u
        OR  h-start-widget:TYPE = "frame":u
        OR  h-start-widget:type = "dialog-box":u THEN DO:
            RUN piFindWidget (INPUT  c-widget-name,
                              INPUT  c-widget-type,
                              INPUT  h-start-widget:FIRST-CHILD,
                              OUTPUT h-widget).

            IF  VALID-HANDLE(h-widget) THEN
                LEAVE.
        END.

        ASSIGN h-start-widget = h-start-widget:NEXT-SIBLING.
    END.

END PROCEDURE.
