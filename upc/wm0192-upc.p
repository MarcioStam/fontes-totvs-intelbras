/*------------------------------------------------------------------------
    File        : wm0192-UPC.P

------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto AS CHARACTER    NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE       NO-UNDO.

DEFINE VARIABLE wh-wm0192-espec                   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0192-consulta                AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux                            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                             AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux                             AS INTEGER       NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-h-window-cd0192       AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR h-upc-wm0192            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btfirst-wm0192        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage1-wm0192         AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR h-btDeleteSon-wm0192    AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-search-wm0192        AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-brSon1-wm0192        AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-DBO-wm0192        AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-wm0192 AS INTEGER NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-wm0192-it-codigo      AS CHAR NO-UNDO.
/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

if  p-ind-event  = "AFTER-display" THEN DO:
    FIND sit-tribut NO-LOCK
        WHERE ROWID(sit-tribut) =  p-row-table NO-ERROR.
    IF  AVAIL  sit-tribut THEN
        ASSIGN g-cdn-sit-tirbut-wm0192 = sit-tribut.cdn-sit-tribut.
END.

if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN g-h-window-cd0192 = p-wgh-frame:WINDOW.
    
    RUN getDBOParentHandle IN g-h-window-cd0192:INSTANTIATING-PROCEDURE (OUTPUT wh-DBO-wm0192).

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):
                   
       if  h-frame:type = "button" and h-frame:name = "btfirst" then
           h-btfirst-wm0192 = h-frame.

       if  h-frame:type = "frame" and h-frame:name = "fpage1" then
           h-fpage1-wm0192 = h-frame.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:FIRST-CHILD.
    end. 

    if  valid-handle( h-btfirst-wm0192) then do:

        create button wh-wm0192-consulta
        assign frame = p-wgh-frame
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 35.5
               visible   = yes
               sensitive = yes
               tooltip       = "Pesquisa"
               triggers:
                    on choose PERSISTENT run upc/wm0192-zoom-upc.w.
               end triggers.
    
        if wh-wm0192-consulta:load-image("adeicon/prevw-u.bmp") then.
        if wh-wm0192-consulta:load-image-down("adeicon/prevw-u.bmp") then.
    END.

END.
