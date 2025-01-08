/********************************************************************************
**  Programa: UPC-Wm0104A.P                                    
**  Data....: dezembro/2014
**  Autor...: SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: Criar Botao para chamar programa de extencao dos blocos
********************************************************************************/
{method/dbotterr.i}

def input parameter p-ind-event  as char          no-undo.
def input parameter p-ind-object as char          no-undo.
def input parameter p-wgh-object as handle        no-undo.
def input parameter p-wgh-frame  as widget-handle no-undo.
def input parameter p-cod-table  as char          no-undo.
def input parameter p-row-table  as rowid         no-undo.

Define New Global Shared Variable wgh-btgerar     As Handle No-undo.
Define New Global Shared Variable wgh-btBlocoExt  As Handle No-undo.

IF  p-ind-event  = "AFTER-INITIALIZE":U AND 
    p-ind-object = "Container"          THEN DO:

    Run tela-upc (Input p-wgh-frame,
                  Input p-ind-event,
                  Input "button",
                  Input "Btgerar",
                  Input NO,
                  Input 1,
                  Output p-wgh-object).
     If  Valid-handle(p-wgh-object) Then
        Assign wgh-btgerar = p-wgh-object.

    Create Button wgh-btBlocoExt
    Assign Frame     = p-wgh-frame
           Width     = wgh-btgerar:Width
           Height    = wgh-btgerar:Height
           Row       = wgh-btgerar:Row
           Col       = wgh-btgerar:COL + 4
           Font      = wgh-btgerar:Font
           Visible   = Yes
           Sensitive = Yes
           Label     = "Bloco Ext".

     on choose of wgh-btBlocoExt
            PERSISTENT run esp/wmp/eswmp001.w.

    wgh-btBlocoExt:load-image("image/im-f-aps.bmp":U).
           
END.

Procedure tela-upc:

    Define INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    Define INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    Define INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    Define OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):              

        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP
                    "Type do Objeto" wgh-obj:TYPE SKIP
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.
