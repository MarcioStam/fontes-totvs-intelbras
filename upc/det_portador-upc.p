/* -------------------------------------------------------------------------------------------------------------
Programa : upc/det_portador-upc.p
Funcao   : UPC criada para mostrar o campo "Considera Comiss∆o Portador" no cadastro do portador do Ems5 na tela
           de detalhe do portador.
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

DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hufn008       AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-toggle-det AS WIDGET-HANDLE    NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    ASSIGN hufn008 = p-wgh-object.

    CREATE TOGGLE-BOX wh-toggle-det
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 25
           HEIGHT       = 1.00
           ROW          = 3.7
           LABEL        = "Considera Comiss∆o Portador"
           COLUMN       = 42
           VISIBLE      = YES
           SENSITIVE    = no.

END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-toggle-det:SENSITIVE = no.
END.


IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    FIND FIRST emscad.portador WHERE RECID(portador) = p-row-table.
    ASSIGN wh-toggle-det:CHECKED = NO.
    FOR FIRST int-portador OF emscad.portador:
        ASSIGN wh-toggle-det:CHECKED = int-portador.log_considera_comissao.
    END.
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
