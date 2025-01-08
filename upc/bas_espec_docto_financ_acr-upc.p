/* -------------------------------------------------------------------------------------------------------------
Programa : upc/bas_espec_docto_financ_acr-upc.p
Funcao   : UPC criada para mostrar o campo "Gera Comiss∆o" na espÇcie financeiro do m¢dulo Contas a Receber.
           Essa informaá∆o ser† utilizada para verificar se a espÇcie gera comiss∆o (Previs∆o ou Provis∆o) na
           implantaá∆o do t°tulo.
Autor    : Robson Jeorge Moser
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

DEFINE NEW GLOBAL SHARED VARIABLE hacr030       AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-toggle-bas AS WIDGET-HANDLE    NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").


IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    ASSIGN hacr030 = p-wgh-object.

    CREATE TOGGLE-BOX wh-toggle-bas
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 14
           HEIGHT       = 1.00
           ROW          = 7.00
           LABEL        = "Gera Comiss∆o"
           COLUMN       = 68
           SENSITIVE    = YES
           VISIBLE      = YES.

END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-toggle-bas:SENSITIVE = no.
END.

IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    FIND FIRST espec_docto_financ_acr WHERE RECID(espec_docto_financ_acr) = p-row-table.
    ASSIGN wh-toggle-bas:CHECKED = NO.
    FOR FIRST int_espec_docto_financ_acr OF espec_docto_financ_acr:
        ASSIGN wh-toggle-bas:CHECKED = int_espec_docto_financ_acr.log_gera_comissao.
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
