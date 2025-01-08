/*------------------------------------------------------------------------
    File        : cd0356-UPC.P

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

DEFINE VARIABLE wh-cd0356-espec AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux                  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux                   AS INTEGER     NO-UNDO.



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

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):
                   
       if h-frame:type = "button" and h-frame:name = "btdelete" then
           leave.  

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end. 


    if  h-frame:type = "button" and h-frame:name = "btdelete" then do:
        create button wh-cd0356-espec
        assign frame     = h-frame:FRAME
               width     = 4.00
               height    = 1.10
               row       = 1.15
               col       = 53.3
               visible   = yes
               sensitive = yes
               tooltip       = "Importa‡Æo"
               triggers:
                    on choose PERSISTENT run upc/cd0356-upca.p.
               end triggers.
    
        if wh-cd0356-espec:load-image("image/gr-lay.bmp") then.
        if wh-cd0356-espec:load-image-down("image/gr-lay.bmp") then.


        ASSIGN h-frame:SENSITIVE = NO.
    END.

END.

IF p-ind-event = "AFTER-CONTROL-TOOL-BAR" and 
   p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    do while valid-handle(h-frame):

       if h-frame:type = "button" and h-frame:name = "btdelete" THEN 
           leave.   

        if h-frame:type ne "field-group" then
            h-frame = h-frame:next-sibling.
        else
            h-frame = h-frame:first-child.
    end. 

    if  h-frame:type = "button" and h-frame:name = "btdelete" then 
        ASSIGN h-frame:SENSITIVE = NO.
END.






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


