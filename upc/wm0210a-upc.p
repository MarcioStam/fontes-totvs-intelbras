/****************************************************************************
 * Nome.....: WM0210A-UPC
 * Autor....: SCM Concept / STOUT
 * Data.....: Abril / 2022
 * Objetivo.: Manuten‡Æo de quantidade m¡nima e m xima de caixas
 *            nos endere‡os de Flow Rack
 ***************************************************************************/

def input param p-ind-event  as char          no-undo.
def input param p-ind-object as char          no-undo.
def input param p-wgh-object as handle        no-undo.
def input param p-wgh-frame  as widget-handle no-undo.
def input param p-cod-table  as char          no-undo.
def input param p-row-table  as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-flow-rack   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-qt-min-pick AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-qt-max-pick AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-wm0210a-upc AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-qt-min-wm0210a  AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-estabel-wm0210a  AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-local-wm0210a    AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-picking-wm0210a  AS WIDGET-HANDLE  NO-UNDO.

DEFINE VARIABLE h-lbl-qt-min  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-lbl-qt-max  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-handle-aux AS HANDLE      NO-UNDO.

IF  p-ind-event  = "BEFORE-INITIALIZE" THEN DO:

    IF  NOT VALID-HANDLE(h-wm0210a-upc) THEN
        RUN upc/wm0210a-upc.p PERSISTENT SET h-wm0210a-upc (INPUT "",
                                                            INPUT "",
                                                            INPUT p-wgh-object,
                                                            INPUT p-wgh-frame,
                                                            INPUT "",
                                                            INPUT p-row-table).
    RUN upc/findWidget.p (INPUT 'cod-estabel',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT wgh-cod-estabel-wm0210a).
    
    RUN upc/findWidget.p (INPUT 'cod-local',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT wgh-cod-local-wm0210a).

    RUN upc/findWidget.p (INPUT 'cod-picking',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT wgh-cod-picking-wm0210a).

    RUN upc/findWidget.p (INPUT 'qtd-minima',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT wgh-qt-min-wm0210a).

    RUN upc/findWidget.p (INPUT 'des-picking',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT h-handle-aux).

    IF VALID-HANDLE(h-handle-aux) THEN DO:
        CREATE TOGGLE-BOX wgh-flow-rack
        ASSIGN FRAME     = p-wgh-frame
               NAME      = "wgh-flow-rack"
               WIDTH     = 15
               HEIGHT    = 0.88
               ROW       = h-handle-aux:ROW
               COL       = h-handle-aux:COL + 40
               VISIBLE   = YES
               SENSITIVE = YES
               LABEL     = "Flow Rack"
               FONT      = 1
            TRIGGERS:
               ON "VALUE-CHANGED"
                  PERSISTENT RUN pi-change-flow-rack IN h-wm0210a-upc.
            END triggers.
    END.

    RUN upc/findWidget.p (INPUT 'c-des-refer',
                            INPUT 'FILL-IN',
                            INPUT p-wgh-frame,
                            OUTPUT h-handle-aux).

    IF VALID-HANDLE(h-handle-aux) THEN DO:
        CREATE FILL-IN wgh-qt-min-pick
        ASSIGN FRAME     = p-wgh-frame
               NAME      = "wgh-qt-min-pick"
               DATA-TYPE = "INTEGER"
               WIDTH     = 9
               HEIGHT    = 0.88
               ROW       = h-handle-aux:ROW + 1
               COL       = h-handle-aux:COL + h-handle-aux:WIDTH - 9
               BGCOLOR   = h-handle-aux:BGCOLOR
               FGCOLOR   = h-handle-aux:FGCOLOR
               VISIBLE   = YES
               SENSITIVE = NO
               TAB-STOP  = YES
               FONT      = 1
               FORMAT    = ">>>>>9".

        CREATE TEXT h-lbl-qt-min
        ASSIGN FRAME        = wgh-qt-min-pick:FRAME
               FORMAT       = "x(16)":U
               WIDTH        = 11
               SCREEN-VALUE = "Qtd Min Caixas:"
               ROW          = wgh-qt-min-pick:ROW + .15
               COL          = wgh-qt-min-pick:COL - 11
               VISIBLE      = YES
               FONT         = 1.

        CREATE FILL-IN wgh-qt-max-pick
        ASSIGN FRAME     = p-wgh-frame
               NAME      = "wgh-qt-max-pick"
               DATA-TYPE = "INTEGER"
               WIDTH     = 9
               HEIGHT    = 0.88
               ROW       = h-handle-aux:ROW + 2
               COL       = h-handle-aux:COL + h-handle-aux:WIDTH - 9
               BGCOLOR   = h-handle-aux:BGCOLOR
               FGCOLOR   = h-handle-aux:FGCOLOR
               VISIBLE   = YES
               SENSITIVE = NO
               TAB-STOP  = YES
               FONT      = 1
               FORMAT    = ">>>>>9".

        CREATE TEXT h-lbl-qt-max
        ASSIGN FRAME        = wgh-qt-max-pick:FRAME
               FORMAT       = "x(16)":U
               WIDTH        = 11
               SCREEN-VALUE = "Qtd Max Caixas:"
               ROW          = wgh-qt-max-pick:ROW + .15
               COL          = wgh-qt-max-pick:COL - 11.25
               VISIBLE      = YES
               FONT         = 1.

    END.

END.

IF  p-ind-event  = "AFTER-INITIALIZE" THEN DO:
    RUN pi-display.
END.

IF  p-ind-event  = "AFTER-DISPLAY" THEN DO:
    RUN pi-display.
END.


IF  p-ind-event  = "AFTER-DESTROY-INTERFACE" THEN DO:
    
    IF VALID-HANDLE(wgh-flow-rack) THEN
        DELETE OBJECT wgh-flow-rack NO-ERROR.

    IF VALID-HANDLE(h-wm0210a-upc) THEN
        DELETE PROCEDURE h-wm0210a-upc NO-ERROR.

    IF VALID-HANDLE(wgh-qt-min-pick) THEN
        DELETE OBJECT wgh-qt-min-pick NO-ERROR.

    IF VALID-HANDLE(wgh-qt-max-pick) THEN
        DELETE OBJECT wgh-qt-max-pick NO-ERROR.

    ASSIGN wgh-flow-rack   = ?
           h-wm0210a-upc   = ?
           wgh-qt-min-pick = ?
           wgh-qt-max-pick = ?
           wgh-qt-min-wm0210a  = ?.

END.

RETURN "OK".

/************************ procedure ***************************/
PROCEDURE pi-change-flow-rack:

    IF NOT VALID-HANDLE(wgh-flow-rack) THEN
        RETURN.

    ASSIGN wgh-qt-min-pick:SENSITIVE = wgh-flow-rack:CHECKED
           wgh-qt-max-pick:SENSITIVE = wgh-flow-rack:CHECKED
           wgh-qt-min-wm0210a:SENSITIVE = (wgh-flow-rack:CHECKED = NO).

    IF wgh-flow-rack:CHECKED = NO THEN
        ASSIGN wgh-qt-min-pick:SCREEN-VALUE = "0"
               wgh-qt-max-pick:SCREEN-VALUE = "0".
    ELSE
        ASSIGN wgh-qt-min-wm0210a:SCREEN-VALUE = "0,0000".

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-display:

    FOR FIRST ext-wm-picking NO-LOCK 
        WHERE ext-wm-picking.cod-estabel = wgh-cod-estabel-wm0210a:SCREEN-VALUE
          AND ext-wm-picking.cod-local   = wgh-cod-local-wm0210a:SCREEN-VALUE
          AND ext-wm-picking.cod-picking = wgh-cod-picking-wm0210a:SCREEN-VALUE:
        ASSIGN wgh-flow-rack:CHECKED        = ext-wm-picking.log-flow-rack
               wgh-qt-min-pick:SCREEN-VALUE = STRING(ext-wm-picking.qtd-min-pick)
               wgh-qt-max-pick:SCREEN-VALUE = STRING(ext-wm-picking.qtd-max-pick).
    END.
    
    RUN pi-change-flow-rack.


    RETURN "OK".
END PROCEDURE.


