/* -------------------------------------------------------------------------------------------------------------
Programa : upc/add_portador-upc.p
Funcao   : UPC criada para acrescentar o campo "Considera Comiss∆o Portador" no cadastro do portador do 
           Essa informaá∆o ser† utilizada para verificar se o portador ir† considerar comiss∆o na baixa do t°tulo.
Autor    : Robson Jeorge Moser - Gestech
Data     : 12/2004
Alteraá∆o:
Vers∆o   : 001
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hufn008       AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-toggle-add AS WIDGET-HANDLE    NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").


IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    ASSIGN hufn008 = p-wgh-object.

    CREATE TOGGLE-BOX wh-toggle-add
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 25
           HEIGHT       = 1.00
           ROW          = 3.70
           LABEL        = "Considera Comiss∆o Portador"
           COLUMN       = 43
           SENSITIVE    = YES
           VISIBLE      = YES.
END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-toggle-add:SENSITIVE = yes.
END.


IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    ASSIGN wh-toggle-add:CHECKED = NO.
END.


IF p-ind-event = "ASSIGN" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST emscad.portador WHERE RECID(portador) = p-row-table.
    CREATE int-portador.
    assign int-portador.cod_portador           = emscad.portador.cod_portador
           int-portador.log_considera_comissao = wh-toggle-add:CHECKED.
END.


/*
MESSAGE 
p-ind-event 
p-ind-object
string(p-wgh-object)
STRING(p-row-table)
STRING(p-wgh-frame)
p-cod-table SKIP
c-objeto VIEW-AS ALERT-BOX INFO BUTTONS OK.

*/





