def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
{upc/btb910za-upc.i}

DEFINE NEW GLOBAL SHARED VARIABLE wh-num-dias-libera-fft-cc0514 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cond-pag-cc0514        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cond-pag-cc0514          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-num-dias-libera-fft-cc0514 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cc0514-upc                  AS WIDGET-HANDLE NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
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


IF  p-ind-event = "INITIALIZE" 
AND c-objeto    = "v01in426.w" THEN DO:
    ASSIGN wh-cod-cond-pag-cc0514 = getObject(p-wgh-frame,"cod-cond-pag":U)
           wh-c-cond-pag-cc0514   = getObject(p-wgh-frame,"c-cond-pag":U).

    RUN upc/cc0514-upc.p PERSISTENT SET h-cc0514-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  

    CREATE TEXT tx-num-dias-libera-fft-cc0514 
    ASSIGN NAME         = 'tx-num-dias-libera-fft-cc0514':U
           ROW          = wh-c-cond-pag-cc0514:ROW + 0.12
           COLUMN       = wh-c-cond-pag-cc0514:COLUMN + 20
           WIDTH        = 12
           DATA-TYPE    = "character"
           FORMAT       = "x(11)"
           FRAME        = p-wgh-frame
           VISIBLE      = YES
           SCREEN-VALUE = "Libera FFT:".
    
    CREATE FILL-IN wh-num-dias-libera-fft-cc0514
    ASSIGN NAME       = 'wh-num-dias-libera-fft-cc0514':U
           FRAME      = p-wgh-frame
           ROW        = wh-c-cond-pag-cc0514:ROW 
           COLUMN     =tx-num-dias-libera-fft-cc0514:COLUMN + 8.4
           HEIGHT     = 0.88
           WIDTH      = 5
           DATA-TYPE  = "integer"
           FORMAT     = ">>>9"
           TOOLTIP    = "Libera FFT"
           HELP       = "Libera FFT"
           VISIBLE    = TRUE
           SIDE-LABEL-HANDLE = tx-num-dias-libera-fft-cc0514
           SENSITIVE  = NO.

END.

IF  p-ind-event = "DISPLAY" 
AND c-objeto    = "v01in426.w" THEN DO:

    FIND tb-pr-cc NO-LOCK
        WHERE ROWID(tb-pr-cc) = p-row-table NO-ERROR.

    IF AVAIL tb-pr-cc THEN DO:

        FIND FIRST int-tb-pr-cc EXCLUSIVE-LOCK 
             WHERE int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente 
               AND int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
               AND int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab      
               AND int-tb-pr-cc.dt-inicio    = tb-pr-cc.dt-inicio    NO-ERROR.
        
        IF AVAIL int-tb-pr-cc THEN DO:
            ASSIGN wh-num-dias-libera-fft-cc0514:SCREEN-VALUE = STRING(int-tb-pr-cc.num-dias-libera-fft).
        END.
        ELSE DO:
            ASSIGN wh-num-dias-libera-fft-cc0514:SCREEN-VALUE = "0".
        END.
        
    END.
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-cc0514-upc) THEN
        DELETE PROCEDURE h-cc0514-upc.


RETURN "OK".
