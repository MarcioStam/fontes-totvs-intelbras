/*------------------------------------------------------------------------
    File        : CD0355-UPC.P

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

DEFINE VARIABLE wh-cd0355-espec                 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0355-consulta              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux                          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                           AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux                           AS INTEGER       NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-h-window-cd0355     AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR h-upc-cd0355          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btfirst-cd0355      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage1-cd0355       AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR h-btDeleteSon-cd0355  AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-search-cd0355      AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-brSon1-cd0355      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-DBOSon-cd0355      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-cd0355  AS INTEGER NO-UNDO. 

/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

if  p-ind-event  = "AFTER-display" THEN DO:
    FIND sit-tribut NO-LOCK
        WHERE ROWID(sit-tribut) =  p-row-table NO-ERROR.
    IF  AVAIL  sit-tribut THEN
        ASSIGN g-cdn-sit-tirbut-cd0355 = sit-tribut.cdn-sit-tribut.
END.


if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN g-h-window-cd0355 = p-wgh-frame:WINDOW.
    
    RUN getDBOSonHandle IN g-h-window-cd0355:INSTANTIATING-PROCEDURE(INPUT 1,
                                                                     OUTPUT wh-DBOSon-cd0355).
      
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):
                   
       if  h-frame:type = "button" and h-frame:name = "btfirst" then
           h-btfirst-cd0355 = h-frame.

       if  h-frame:type = "frame" and h-frame:name = "fpage1" then
           h-fpage1-cd0355 = h-frame.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:FIRST-CHILD.
    end. 

    if  /*h-frame:type = "button" and h-frame:name = "btfirst"*/
        valid-handle( h-btfirst-cd0355) then do:
        create button wh-cd0355-espec
        assign frame     = p-wgh-frame
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 50.3
               visible   = yes
               sensitive = yes
               tooltip       = "Importa‡Æo"
               triggers:
                    on choose PERSISTENT run upc/cd0355-upca.w.
               end triggers.
    
        if wh-cd0355-espec:load-image("image/gr-lay.bmp") then.
        if wh-cd0355-espec:load-image-down("image/gr-lay.bmp") then.


        create button wh-cd0355-consulta
        assign frame = p-wgh-frame
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 45.5
               visible   = yes
               sensitive = yes
               tooltip       = "Consulta"
               triggers:
                    on choose PERSISTENT run upc/cd0355-upcb.w.
               end triggers.
    
        if wh-cd0355-consulta:load-image("adeicon/prevw-u.bmp") then.
        if wh-cd0355-consulta:load-image-down("adeicon/prevw-u.bmp") then.
    END.


   IF  VALID-HANDLE(h-fpage1-cd0355) THEN DO:
        ASSIGN h-frame = h-fpage1-cd0355:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.
        do while valid-handle(h-frame):
           if  h-frame:type = "button" and h-frame:name = "btDeleteSon1" then
               h-btDeleteSon-cd0355 = h-frame.
           if  h-frame:name = "brSon1" then
               wh-brSon1-cd0355 = h-frame.
            if h-frame:type ne "field-group" then
                h-frame = h-frame:next-sibling.
            else
                h-frame = h-frame:FIRST-CHILD.


        end. 

        IF  VALID-HANDLE(h-btDeleteSon-cd0355) THEN DO:

            create button wh-search-cd0355
            assign frame = h-btDeleteSon-cd0355:FRAME
                   width     = h-btDeleteSon-cd0355:WIDTH + 5
                   height    = h-btDeleteSon-cd0355:height
                   row       = h-btDeleteSon-cd0355:row
                   col       = h-btDeleteSon-cd0355:COL + 10
                   visible   = yes
                   sensitive = yes
                   tooltip       = "Localizar Relacionamento"
                   LABEL     = "Pesquisa Relacto"
                   triggers:
                        on choose PERSISTENT run upc/cd0355-upcC.w.
                   end triggers.
 
        END.
 
   END.
END.

