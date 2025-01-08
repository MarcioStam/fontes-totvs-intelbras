
/* Parametros */
DEF INPUT PARAM p-ind-event  AS CHAR.
DEF INPUT PARAM p-ind-object AS CHAR.
DEF INPUT PARAM p-wgh-object AS HANDLE.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE.
DEF INPUT PARAM p-cod-table  AS CHAR.
DEF INPUT PARAM p-row-table  AS ROWID.

DEFINE NEW GLOBAL SHARED VARIABLE wh-br-dupli-apagar-cex AS WIDGET-HANDLE NO-UNDO.

/*--- Defini»’o das Fun»„es ---*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.

/*
MESSAGE " p-ind-event  "  p-ind-event  SKIP
        " p-ind-object "  p-ind-object SKIP
        " p-wgh-object "  p-wgh-object:FILE-NAME SKIP 
        " p-cod-table  "  p-cod-table  SKIP
        " p-row-table  "  STRING(p-row-table)  SKIP
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF p-ind-event  = "BEFORE-INITIALIZE" AND 
   p-ind-object = "BROWSER"           AND
   p-wgh-object:FILE-NAME = "cxbrw/b02cx255.w" THEN DO:

    ASSIGN wh-br-dupli-apagar-cex = getObject(p-wgh-frame,"br-table").

    wh-br-dupli-apagar-cex:ADD-LIKE-COLUMN("dupli-apagar-cex.vl-a-pagar-mo").
    wh-br-dupli-apagar-cex:ADD-CALC-COLUMN("CHARACTER","x(12)","","Moeda Original").

END.


IF (p-ind-event  = "AFTER-OPEN-QUERY" OR p-ind-event  = "AFTER-VALUE-CHANGED") AND 
   p-ind-object = "BROWSER"           AND
   p-wgh-object:FILE-NAME = "cxbrw/b02cx255.w" THEN DO:

    DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.

    DEFINE VARIABLE lSelected AS LOGICAL     NO-UNDO.


    IF wh-br-dupli-apagar-cex:QUERY:NUM-RESULTS = 0 OR 
       wh-br-dupli-apagar-cex:QUERY:NUM-RESULTS = ? THEN
       RETURN "NOK".
    
    wh-br-dupli-apagar-cex:QUERY:REPOSITION-TO-ROW (1).
    wh-br-dupli-apagar-cex:SELECT-ROW(1) NO-ERROR.
    ASSIGN lSelected = wh-br-dupli-apagar-cex:IS-ROW-SELECTED(1) NO-ERROR.

    DO WHILE lSelected:

        FOR FIRST moeda NO-LOCK
            WHERE moeda.mo-codigo = INT(wh-br-dupli-apagar-cex:QUERY:GET-BUFFER-HANDLE():BUFFER-FIELD("mo-codigo"):BUFFER-VALUE):
            ASSIGN wh-br-dupli-apagar-cex:GET-BROWSE-COLUMN(wh-br-dupli-apagar-cex:NUM-COLUMNS):SCREEN-VALUE = moeda.descricao.
        END.

        ASSIGN lSelected = wh-br-dupli-apagar-cex:SELECT-NEXT-ROW() NO-ERROR.

    END.

END.




PROCEDURE piValidate:
    

END PROCEDURE.


PROCEDURE piHabilitarDesabilitarCampo:
/************************************
Procedure para Habilitar e Desabilitar os Campos nos Eventos Padräes
Parametros: p-object: Objeto criado que dever  ser habilitado / desabilitado.
            p-name-object: Nome do programa que contem o objeto.
************************************/
    DEFINE INPUT PARAMETER p-object      AS WIDGET-HANDLE NO-UNDO. 
    DEFINE INPUT PARAMETER p-name-object AS CHARACTER     NO-UNDO. 

    IF NOT VALID-HANDLE(p-object) THEN 
        RETURN "NOK":U.

    IF  p-ind-event = "AFTER-ENABLE" AND p-wgh-object:FILE-NAME = p-name-object THEN DO:
        ASSIGN p-object:SENSITIVE = YES.        
    END.
    
    IF  p-ind-event = "AFTER-DISABLE" AND p-wgh-object:FILE-NAME = p-name-object THEN DO:          
        ASSIGN p-object:SENSITIVE = NO.       
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piTelaUPC:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):              

        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto " wgh-obj:NAME    SKIP
                    "Type do Objeto " wgh-obj:TYPE    SKIP                    
                    "P-Ind-Event "    pIndEvent VIEW-AS ALERT-BOX.
        
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.

