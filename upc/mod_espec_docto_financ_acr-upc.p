/* -------------------------------------------------------------------------------------------------------------
Programa : upc/mod_espec_docto_financ_acr-upc.p
Funcao   : UPC criada para permitir modificar o campo "Gera Comiss∆o" na espÇcie financeiro do m¢dulo Contas a Receber.
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

DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hacr030       AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-toggle-mod AS WIDGET-HANDLE    NO-UNDO.


ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    ASSIGN hacr030 = p-wgh-object.

    CREATE TOGGLE-BOX wh-toggle-mod
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 13
           HEIGHT       = 1.00
           ROW          = 6.68
           LABEL        = "Gera Comiss∆o"
           COLUMN       = 61
           SENSITIVE    = NO
           VISIBLE      = YES.
END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-toggle-mod:SENSITIVE = yes.
END.

IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST espec_docto_financ_acr WHERE RECID(espec_docto_financ_acr) = p-row-table.
    ASSIGN wh-toggle-mod:CHECKED = NO.
    FOR FIRST int_espec_docto_financ_acr OF espec_docto_financ_acr:
        ASSIGN wh-toggle-mod:CHECKED = int_espec_docto_financ_acr.log_gera_comissao.
    END.
END.

IF p-ind-event = "ASSIGN" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    FIND FIRST espec_docto_financ_acr WHERE RECID(espec_docto_financ_acr) = p-row-table.
    FIND FIRST int_espec_docto_financ_acr OF espec_docto_financ_acr EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL int_espec_docto_financ_acr THEN DO:
        CREATE int_espec_docto_financ_acr.
    END.
    ASSIGN int_espec_docto_financ_acr.cod_espec_docto   = espec_docto_financ_acr.cod_espec_docto
           int_espec_docto_financ_acr.log_gera_comissao = wh-toggle-mod:CHECKED.

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
