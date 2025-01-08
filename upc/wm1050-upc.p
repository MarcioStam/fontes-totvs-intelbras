/************************************************************************************************************
**       Programa: wm1050-upc.p
**           Data: 01/03/2015
**       Objetivo: Apresenta Transp para o Equipamento
**          Autor: Carlos da Costa Junior - SCM Concept
**
*************************************************************************************************************/
/************************************* Defini‡Æo de Parametros **********************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-transp-wm1050      AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-cod-transp-wm1050   AS WIDGET-HANDLE  NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-equipto-wm1050     AS WIDGET-HANDLE  NO-UNDO.

/************************** Definicao de Variaveis Locais *************************/
DEF VAR wh-objeto      AS WIDGET-HANDLE      NO-UNDO.
DEF VAR wh-bt-requisicao AS WIDGET-HANDLE      NO-UNDO.
DEF VAR wh-aux         AS WIDGET-HANDLE      NO-UNDO.

IF p-ind-event  = "BEFORE-DISPLAY":U  THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in":U,    /*** Type ***/
                  INPUT "cod-equipamento":U,  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-cod-equipto-wm1050 = wh-objeto.
        
    CREATE FILL-IN wh-cod-transp-wm1050
    ASSIGN FRAME     = p-wgh-frame
           DATA-TYPE = "character":U
           FORMAT    = "x(12)":U
           NAME      = "wh-cod-transp-wm1050":U
           WIDTH     = 14
           HEIGHT    = 0.88
           ROW       = 2.80
           COL       = 73.72
           VISIBLE   = YES
           SENSITIVE = NO
           FONT      = 1.
    
    CREATE TEXT wh-lb-cod-transp-wm1050
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(16)":U
           WIDTH        = 10
           SCREEN-VALUE = "Transportador:":U
           ROW          = 2.90
           COL          = 63.32
           VISIBLE      = YES
           FONT         = 1.
           
END.

IF  p-ind-event  = "AFTER-DISPLAY":U             
AND VALID-HANDLE(wh-cod-equipto-wm1050)
AND VALID-HANDLE(wh-cod-transp-wm1050) THEN DO:
    
    FIND FIRST wm-equipamento WHERE
        wm-equipamento.cod-equipamento = (wh-cod-equipto-wm1050:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL wm-equipamento THEN
        ASSIGN wh-cod-transp-wm1050:SCREEN-VALUE = SUBSTRING(wm-equipamento.char-2,110,20).
    ELSE
        ASSIGN wh-cod-transp-wm1050:SCREEN-VALUE = "":U.
END.


IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wh-cod-transp-wm1050)    THEN DELETE OBJECT wh-cod-transp-wm1050.  
    IF  VALID-HANDLE(wh-lb-cod-transp-wm1050) THEN DELETE OBJECT wh-lb-cod-transp-wm1050.   
   
END.

PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):              
        
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group":U THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.

