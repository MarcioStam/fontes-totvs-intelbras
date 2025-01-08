def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/*MESSAGE "EVENTO" p-ind-event skip
        "OBJETO" p-ind-object skip
        "NOME OBJ" c-objeto skip
        "FRAME" p-wgh-frame skip
        "TABELA" p-cod-table skip
        "ROWID" string(p-row-table) view-as alert-box. */

DEFINE VARIABLE h-cod-gr-cob    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-tx-cod-gr-cob AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-lim-adicional AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-nome-abrev    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-dt-lim-cred   AS HANDLE      NO-UNDO.

DEFINE VARIABLE h_object AS HANDLE      NO-UNDO.
DEFINE VARIABLE h_prev   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h_next   AS HANDLE      NO-UNDO.

RUN findWidget(INPUT "h-cod-gr-cob",  INPUT "FILL-IN", INPUT p-wgh-frame, OUTPUT h-cod-gr-cob).
RUN findWidget(INPUT "lim-adicional", INPUT "FILL-IN", INPUT p-wgh-frame, OUTPUT h-lim-adicional).
RUN findWidget(INPUT "nome-abrev",    INPUT "FILL-IN", INPUT p-wgh-frame, OUTPUT h-nome-abrev).
RUN findWidget(INPUT "dt-lim-cred",   INPUT "FILL-IN", INPUT p-wgh-frame, OUTPUT h-dt-lim-cred).

IF  p-ind-event = "INITIALIZE"
AND p-ind-object = "VIEWER" THEN DO:

    IF VALID-HANDLE(h-lim-adicional) THEN DO:

        CREATE TEXT h-tx-cod-gr-cob
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"   
               WIDTH        = 15
               SCREEN-VALUE = "Grupo Cobran‡a:"
               ROW          = h-lim-adicional:ROW
               COL          = h-lim-adicional:COL + h-lim-adicional:WIDTH + 10
               VISIBLE      = YES.

        CREATE FILL-IN h-cod-gr-cob
            ASSIGN NAME = "h-cod-gr-cob"
                   FRAME = p-wgh-frame
                   DATA-TYPE = "INTEGER"
                   FORMAT  = ">9"
                   WIDTH = 3
                   HEIGHT = 0.88
                   ROW = h-lim-adicional:ROW
                   COL = h-lim-adicional:COL + h-lim-adicional:WIDTH + 22
                   VISIBLE = YES
                   SENSITIVE = NO
                   READ-ONLY = NO.

        /* Corrigir Tab Order */
        assign h_object = p-wgh-frame:first-child
               h_object = h_object:first-child
               h_prev   = ?
               h_next   = ?.
        do  while valid-handle(h_object):
            if  h_object:type <> "field_group" then do:
                case h_object:name:
                    when "dt-fim-cred" then
                        assign h_prev = h_object.
                    when "tg-considera-ap-lim-cred" THEN 
                        assign h_next = h_object.
                end case.
                assign h_object = h_object:next-sibling.
            end.
            else do:
                assign h_object = h_object:first-child.
            end.
            if  valid-handle(h_prev) and valid-handle(h_next) then
                leave.
        end.
        h-cod-gr-cob:move-after-tab-item(h_prev).
        h-cod-gr-cob:move-before-tab-item(h_next).
        /* Corrigir Tab Order */

    END.
     /* int-emitente.cod-gr-cobr */

END.

IF  p-ind-event = "ENABLE"
AND p-ind-object = "VIEWER" THEN DO:
    ASSIGN h-cod-gr-cob:SENSITIVE = YES.
    IF h-dt-lim-cred:SCREEN-VALUE = ""
       THEN ASSIGN h-dt-lim-cred:SCREEN-VALUE = STRING(DATE(MONTH(TODAY),DAY(TODAY),2999)).
END.

IF  p-ind-event = "AFTER-ENABLE-fields"
AND p-ind-object = "VIEWER" THEN DO:
    IF h-dt-lim-cred:SCREEN-VALUE = ""
       THEN ASSIGN h-dt-lim-cred:SCREEN-VALUE = STRING(DATE(MONTH(TODAY),DAY(TODAY),2999)).
END.

IF  p-ind-event = "DISABLE"
AND p-ind-object = "VIEWER" THEN DO:
    ASSIGN h-cod-gr-cob:SENSITIVE = NO.
END.

IF  p-ind-event = "DISPLAY"
AND p-ind-object = "VIEWER" THEN DO:

    IF VALID-HANDLE(h-nome-abrev) THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.nome-abrev = h-nome-abrev:SCREEN-VALUE
            NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-ERROR.
            IF AVAIL int-emitente THEN DO:
                ASSIGN h-cod-gr-cob:SCREEN-VALUE = STRING(int-emitente.cod-gr-cob).
            END.
        END.
    END.

END.

IF  p-ind-event = "ASSIGN"
AND p-ind-object = "VIEWER" THEN  DO:

    IF VALID-HANDLE(h-nome-abrev) THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.nome-abrev = h-nome-abrev:SCREEN-VALUE
            NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND int-emitente EXCLUSIVE-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-ERROR.
            IF NOT AVAIL int-emitente THEN DO:
                CREATE int-emitente.
                ASSIGN int-emitente.cod-emitente = emitente.cod-emitente.
            END.
            IF AVAIL int-emitente THEN DO:
                ASSIGN int-emitente.cod-gr-cob = INT(h-cod-gr-cob:SCREEN-VALUE).
            END.
        END.
    END.


END.

PROCEDURE findWidget:

    define input  parameter c-widget-name  as char   no-undo.
    define input  parameter c-widget-type  as char   no-undo.
    define input  parameter h-start-widget as handle no-undo.
    define output parameter h-widget       as handle no-undo.
    
    do while valid-handle(h-start-widget):
        if h-start-widget:name = c-widget-name and
           h-start-widget:type = c-widget-type then do:
            assign h-widget = h-start-widget:handle.
            leave.
        end.
    
        if h-start-widget:type = "field-group":u or
           h-start-widget:type = "frame":u or
           h-start-widget:type = "dialog-box":u then do:
            run findWidget (input  c-widget-name,
                            input  c-widget-type,
                            input  h-start-widget:first-child,
                            output h-widget).
    
            if valid-handle(h-widget) then
                leave.
        end.
        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.
