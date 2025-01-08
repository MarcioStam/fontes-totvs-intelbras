/***********************************************************************
**  Programa..: upc\cd1107-upc.p
**  Autor.....: Raphael Paini
**  Data......: 30/03/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 30/03/2009
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

DEFINE VARIABLE h-object AS HANDLE   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE   NO-UNDO.

/*DEF VAR h-fpage1   AS HANDLE   NO-UNDO.
DEF VAR h-frame1   AS HANDLE   NO-UNDO.
DEF VAR h-fpage2   AS HANDLE   NO-UNDO.
DEF VAR h-frame2   AS HANDLE   NO-UNDO.*/

DEF NEW GLOBAL SHARED VAR wh-button-upc-cd1107  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VARIABLE r-row-id-item AS ROWID NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").

/*  MESSAGE "Evento " p-ind-event  SKIP
          "Objeto " p-ind-object SKIP
          "Tabela " p-cod-table  SKIP
          "Rowid  " STRING(p-row-table) SKIP
          "Objeto " c-objeto     SKIP
          VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:

    create button wh-button-upc-cd1107  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.15       
           col       = 60.32       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             on choose persistent run upc/cd0204a-upc.w  .
           end triggers.
  if wh-button-upc-cd1107:load-image("image/gr-lay.bmp") then.
end.

IF c-objeto = "v13in172.w" AND p-ind-event = "DISPLAY" THEN DO:
   FIND FIRST ITEM 
        WHERE ROWID(ITEM) = p-row-table NO-ERROR.
    IF AVAIL ITEM THEN 
        ASSIGN r-row-id-item = p-row-table.
END.

