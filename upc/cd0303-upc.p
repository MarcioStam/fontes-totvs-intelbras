/*/*------------------------------------------------------------------------
    File        : cd0303-UPC.P

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

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

DEFINE VARIABLE wh-cd0303-espec AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux                  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux                   AS INTEGER     NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-h-window-cd0303     AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR h-upc-cd0303          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btfirst-cd0303      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage1-cd0303       AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR h-btDeleteSon-cd0303  AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-search-cd0303      AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-brSon1-cd0303      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-DBOSon-cd0303      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-cd0303  AS INTEGER NO-UNDO. 



/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).


/* MESSAGE "EVENTO: ":U   p-ind-event      SKIP */
/*         "OBJETO: ":U   p-ind-object     SKIP */
/*         "NOME OBJ: ":U c-objeto         SKIP */
/*         "FRAME: ":U    p-wgh-frame:NAME SKIP */
/*         "TABELA: ":U   p-cod-table      SKIP */
/*         "ROWID: ":U    STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.       */




if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN g-h-window-cd0303 = p-wgh-frame:WINDOW.

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):

       /* MESSAGE "h-frame:type -> " h-frame:TYPE SKIP
                "h-frame:name -> " h-frame:name
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
                   
       if h-frame:type = "button" and h-frame:name = "btfirst" then
          //h-btfirst-cd0303 = h-frame.   
           LEAVE.

       if  h-frame:type = "frame" and h-frame:name = "fpage1" THEN DO:
           h-fpage1-cd0303 = h-frame.
           MESSAGE valid-handle(h-fpage1-cd0303) SKIP "p111"
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       END.

       if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end. 


    MESSAGE "m1" SKIP VALID-HANDLE(h-btfirst-cd0303)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    if  h-frame:type = "button" and h-frame:name = "btfirst" then do:
        MESSAGE "m2"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        create button wh-cd0303-espec
        assign frame     = h-frame:FRAME
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 53.3
               visible   = yes
               sensitive = yes
               tooltip       = "Importa‡Æo"
               triggers:
                    on choose PERSISTENT run upc/cd0303-upca.p.
               end triggers.

        MESSAGE "m3"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    
        if wh-cd0303-espec:load-image("image/gr-lay.bmp") then.
        if wh-cd0303-espec:load-image-down("image/gr-lay.bmp") then.

        MESSAGE "m4"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

    MESSAGE valid-handle(h-fpage1-cd0303) SKIP "p222"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    IF  VALID-HANDLE(h-fpage1-cd0303) THEN DO:
        MESSAGE 111
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN h-frame = h-fpage1-cd0303:FIRST-CHILD.
        MESSAGE 2222
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN h-frame = h-frame:FIRST-CHILD.
        MESSAGE 33333
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        do while valid-handle(h-frame):
           if  h-frame:type = "button" and h-frame:name = "btDeleteSon1" then
               h-btDeleteSon-cd0303 = h-frame.
           if  h-frame:name = "brSon1" then
               wh-brSon1-cd0303 = h-frame.
            if h-frame:type ne "field-group" then
                h-frame = h-frame:next-sibling.
            else
                h-frame = h-frame:FIRST-CHILD.
        end. 

        IF  VALID-HANDLE(h-btDeleteSon-cd0303) THEN DO:

            create button wh-search-cd0303
            assign frame = h-btDeleteSon-cd0303:FRAME
                   width     = h-btDeleteSon-cd0303:WIDTH + 5
                   height    = h-btDeleteSon-cd0303:height
                   row       = h-btDeleteSon-cd0303:row
                   col       = h-btDeleteSon-cd0303:COL + 10
                   visible   = yes
                   sensitive = yes
                   tooltip       = "Localizar Relacionamento"
                   LABEL     = "Pesquisa Relacto"
                   triggers:
                        //on choose PERSISTENT run upc/cd0303-upcC.w.
                   end triggers.
 
        END.
 
   END.

END.




/*

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.

        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
            
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.

        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

        

    END.

END.


*/

*/


/*------------------------------------------------------------------------
    File        : cd0303-UPC.P

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

DEFINE VARIABLE wh-cd0303-espec                 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0303-consulta              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux                          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                           AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux                           AS INTEGER       NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-h-window-cd0303     AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR h-upc-cd0303          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btfirst-cd0303      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage1-cd0303       AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR h-btDeleteSon-cd0303  AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-search-cd0303      AS WIDGET-HANDLE NO-UNDO.   
DEF NEW GLOBAL SHARED VAR wh-brSon1-cd0303      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-DBOSon-cd0303      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-cd0303  AS INTEGER NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-tirbut-cd0303      AS INTEGER NO-UNDO.

/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

if  p-ind-event  = "AFTER-display" THEN DO:
    FIND sit-tribut NO-LOCK
        WHERE ROWID(sit-tribut) =  p-row-table NO-ERROR.
    IF  AVAIL  sit-tribut THEN
        ASSIGN g-cdn-sit-tirbut-cd0303 = sit-tribut.cdn-sit-tribut
               g-cdn-tirbut-cd0303     = sit-tribut.cdn-tribut.
END.

if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN g-h-window-cd0303 = p-wgh-frame:WINDOW.
    
    RUN getDBOSonHandle IN g-h-window-cd0303:INSTANTIATING-PROCEDURE(INPUT 1,
                                                                     OUTPUT wh-DBOSon-cd0303).
      
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):
                   
       if  h-frame:type = "button" and h-frame:name = "btfirst" then
           h-btfirst-cd0303 = h-frame.

       if  h-frame:type = "frame" and h-frame:name = "fpage1" THEN DO:
           h-fpage1-cd0303 = h-frame.
       END.

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:FIRST-CHILD.
    end. 

    if  /*h-frame:type = "button" and h-frame:name = "btfirst"*/
        valid-handle( h-btfirst-cd0303) then do:
        create button wh-cd0303-espec
        assign frame     = p-wgh-frame
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 50.3
               visible   = yes
               sensitive = yes
               tooltip       = "Importa‡Æo"
               triggers:
                    on choose PERSISTENT run upc/cd0303-upca.p.
               end triggers.
    
        if wh-cd0303-espec:load-image("image/gr-lay.bmp") then.
        if wh-cd0303-espec:load-image-down("image/gr-lay.bmp") then.


        create button wh-cd0303-consulta
        assign frame = p-wgh-frame
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 45.5
               visible   = yes
               sensitive = yes
               tooltip       = "Consulta"
               triggers:
                    on choose PERSISTENT run upc/cd0303-upcb.w.
               end triggers.
    
        if wh-cd0303-consulta:load-image("adeicon/prevw-u.bmp") then.
        if wh-cd0303-consulta:load-image-down("adeicon/prevw-u.bmp") then.
    END.

   IF  VALID-HANDLE(h-fpage1-cd0303) THEN DO:
        ASSIGN h-frame = h-fpage1-cd0303:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.
        do while valid-handle(h-frame):
           if  h-frame:type = "button" and h-frame:name = "btDeleteSon1" then
               h-btDeleteSon-cd0303 = h-frame.
           if  h-frame:name = "brSon1" then
               wh-brSon1-cd0303 = h-frame.
            if h-frame:type ne "field-group" then
                h-frame = h-frame:next-sibling.
            else
                h-frame = h-frame:FIRST-CHILD.
        end. 

        IF  VALID-HANDLE(h-btDeleteSon-cd0303) THEN DO:

            create button wh-search-cd0303
            assign frame = h-btDeleteSon-cd0303:FRAME
                   width     = h-btDeleteSon-cd0303:WIDTH + 5
                   height    = h-btDeleteSon-cd0303:height
                   row       = h-btDeleteSon-cd0303:row
                   col       = h-btDeleteSon-cd0303:COL + 10
                   visible   = yes
                   sensitive = yes
                   tooltip       = "Localizar Relacionamento"
                   LABEL     = "Pesquisa Relacto"
                   triggers:
                        on choose PERSISTENT run upc/cd0303-upcC.w.
                   end triggers.
 
        END.
 
   END.
END.


