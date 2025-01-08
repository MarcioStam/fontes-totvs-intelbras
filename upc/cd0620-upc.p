def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEF VAR wh-cod-cfop-cd0620          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cfop-rever-cd0620    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-cod-cfop-rever-cd0620 AS WIDGET-HANDLE NO-UNDO.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/********************************************************/
/*Functions*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
         IF hHdl:NAME = pObj THEN LEAVE.
        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.

/********************************************************/

IF p-ind-event  = "AFTER-INITIALIZE" THEN DO:

    ASSIGN wh-cod-cfop-cd0620 = getObject(p-wgh-frame,"cod-cfop":U).

    IF VALID-HANDLE( wh-cod-cfop-cd0620 ) THEN DO:
        CREATE TEXT wh-tx-cod-cfop-rever-cd0620 
        ASSIGN NAME         = 'wh-tx-cod-cfop-rever-cd0620 ':U
               ROW          = 15
               COLUMN       = 47
               WIDTH        = 12
               DATA-TYPE    = "character"
               FORMAT       = "x(13)"
               FRAME        = wh-cod-cfop-cd0620:FRAME
               VISIBLE      = YES
               SCREEN-VALUE = "CFOP Reversa:".

        CREATE FILL-IN wh-cod-cfop-rever-cd0620
        ASSIGN NAME       = 'wh-cod-cfop-rever-cd0620':U
               FRAME      = wh-cod-cfop-cd0620:FRAME
               ROW        = 14.95
               COLUMN     = 58
               HEIGHT     = 0.88
               WIDTH      = 8
               DATA-TYPE  = "Character"
               FORMAT     = "x(06)"
               TOOLTIP    = "CFOP Reversa"
               HELP       = "CFOP Reversa"
               VISIBLE    = TRUE
               SENSITIVE  = NO.
    END.

    FIND FIRST cfop-natur NO-LOCK
        WHERE ROWID(cfop-natur) = p-row-table NO-ERROR.

    FIND FIRST int-cfop-natur NO-LOCK
         WHERE int-cfop-natur.cod-cfop = cfop-natur.cod-cfop NO-ERROR.

    IF AVAIL int-cfop-natur THEN
        ASSIGN wh-cod-cfop-rever-cd0620:SCREEN-VALUE = int-cfop-natur.cod-cfop-reversa.
    ELSE
        ASSIGN wh-cod-cfop-rever-cd0620:SCREEN-VALUE = "".
   
END.

IF p-ind-event  = "AFTER-DISPLAY" THEN DO:

    IF VALID-HANDLE(wh-cod-cfop-rever-cd0620) THEN DO:
        FIND FIRST cfop-natur NO-LOCK
            WHERE ROWID(cfop-natur) = p-row-table NO-ERROR.
    
        FIND FIRST int-cfop-natur NO-LOCK
             WHERE int-cfop-natur.cod-cfop = cfop-natur.cod-cfop NO-ERROR.
    
        IF AVAIL int-cfop-natur THEN
            ASSIGN wh-cod-cfop-rever-cd0620:SCREEN-VALUE = int-cfop-natur.cod-cfop-reversa.
        ELSE
            ASSIGN wh-cod-cfop-rever-cd0620:SCREEN-VALUE = "".
    END.

END.

IF p-ind-event  = "AFTER-ENABLE" THEN DO:
    ASSIGN wh-cod-cfop-rever-cd0620:SENSITIVE = YES.
END.

IF p-ind-event  = "AFTER-DISABLE" THEN DO:
    ASSIGN wh-cod-cfop-rever-cd0620:SENSITIVE = NO.
END.

IF p-ind-event  = "BEFORE-ASSIGN" THEN DO:
    IF wh-cod-cfop-rever-cd0620:SCREEN-VALUE <> "" THEN DO:
        IF NOT CAN-FIND (FIRST cfop-natur
                         WHERE cfop-natur.cod-cfop = wh-cod-cfop-rever-cd0620:SCREEN-VALUE) THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 17006,
                               INPUT "CFOP Reversa n∆o cadastrada").
            RETURN ERROR.
        END.
    END.
END.

IF p-ind-event  = "AFTER-ASSIGN" THEN DO:
    FIND FIRST cfop-natur NO-LOCK
         WHERE ROWID(cfop-natur) = p-row-table NO-ERROR.

    FIND FIRST int-cfop-natur EXCLUSIVE-LOCK
         WHERE int-cfop-natur.cod-cfop = cfop-natur.cod-cfop NO-ERROR.

    IF NOT AVAIL int-cfop-natur THEN DO:
        CREATE int-cfop-natur.
        ASSIGN int-cfop-natur.cod-cfop = cfop-natur.cod-cfop.
    END.

    ASSIGN int-cfop-natur.cod-cfop-reversa = wh-cod-cfop-rever-cd0620:SCREEN-VALUE.
END.


/*
IF p-ind-event  = "DESTROY" THEN DO:

    IF VALID-HANDLE(wh-tx-estab-cd0620) THEN
        DELETE OBJECT wh-tx-estab-cd0620.

    IF VALID-HANDLE(wh-fi-estab-cd0620) THEN
        DELETE OBJECT wh-fi-estab-cd0620.

    IF VALID-HANDLE(wh-natur-cd0620) THEN
        DELETE OBJECT wh-natur-cd0620.

END.
*/
