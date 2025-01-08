/***********************************************************************
**  Programa..: upc\z22in274-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR l-ok       AS LOGICAL  NO-UNDO.
DEF VAR h-frame    AS HANDLE   NO-UNDO.
DEF VAR h-objeto   AS HANDLE   NO-UNDO.
DEF VAR h-objeto2  AS HANDLE   NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").
  
DEF NEW GLOBAL SHARED VAR wh-brTable     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btExporta   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-inicial     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-final       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-button      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-pedido  AS WIDGET-HANDLE NO-UNDO.

IF  p-ind-object = "CONTAINER"
AND p-ind-event  = "AFTER-INITIALIZE" THEN DO:
    
    assign h-frame = p-wgh-frame:FIRST-CHILD.
    assign h-frame = h-frame:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            IF h-frame:NAME = "fpage1" THEN DO:
                ASSIGN h-objeto = h-frame.
                LEAVE.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-objeto = h-objeto:FIRST-CHILD.
    ASSIGN h-objeto = h-objeto:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-objeto):
        IF  h-objeto:TYPE <> "field-group" THEN DO:
            IF h-objeto:NAME = "brtable1" THEN DO:
                ASSIGN h-objeto2 = h-objeto.
                LEAVE. 
            END.
            ASSIGN h-objeto = h-objeto:NEXT-SIBLING.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-objeto2 = h-objeto2:NEXT-SIBLING.

    DO WHILE VALID-HANDLE(h-objeto2):
        IF  h-objeto2:TYPE <> "field-group" THEN DO:
            
            IF  h-objeto2:TYPE = "FILL-IN"
            AND h-objeto2:NAME = "1" THEN 
                ASSIGN wh-inicial = h-objeto2.

            IF  h-objeto2:TYPE   = "FILL-IN" 
            AND h-objeto2:FORMAT = ">>>>>,>>9"
            AND h-objeto2:NAME  <> "1" THEN
                ASSIGN wh-final = h-objeto2.

            IF  h-objeto2:TYPE   = "BUTTON" 
            AND h-objeto2:NAME   = "1" THEN
                ASSIGN wh-button = h-objeto2.

            ASSIGN h-objeto2 = h-objeto2:NEXT-SIBLING.
        END.
        ELSE LEAVE.
    END.

    IF wh-num-pedido:SCREEN-VALUE <> "0" THEN
        ASSIGN wh-inicial:SCREEN-VALUE = wh-num-pedido:SCREEN-VALUE
               wh-final:SCREEN-VALUE   = wh-num-pedido:SCREEN-VALUE.  

    IF VALID-HANDLE(wh-button) THEN
        APPLY "choose" TO wh-button.
END.

