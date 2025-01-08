/************************************************************************************************************
**       Programa: wm1050A-upc.p
**           Data: 01/03/2015
**       Objetivo: Inclusao/Modificacao Transp para o Equipamento
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
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-transp-wm1050A       AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-cod-transp-wm1050A    AS WIDGET-HANDLE  NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-equipto-wm1050A      AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cdn-tipo-equipto-wm1050A AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btOk-wm1050A             AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btSave-wm1050A           AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btOk-new-wm1050A         AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btSave-new-wm1050A       AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-equipto-wm1050       AS WIDGET-HANDLE  NO-UNDO.

/************************** Definicao de Variaveis Locais *************************/
DEF VAR wh-objeto        AS WIDGET-HANDLE      NO-UNDO.
DEF VAR wh-bt-requisicao AS WIDGET-HANDLE      NO-UNDO.
DEF VAR wh-aux           AS WIDGET-HANDLE      NO-UNDO.

IF p-ind-event  = "BEFORE-DISPLAY":U  THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in":U,          /*** Type ***/
                  INPUT "cod-equipamento":U,  /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-cod-equipto-wm1050A = wh-objeto.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in":U,          /*** Type ***/
                  INPUT "cdn-tipo-equipamento":U,  /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-cdn-tipo-equipto-wm1050A = wh-objeto.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button":U,    /*** Type ***/
                  INPUT "btOk":U,      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-btOk-wm1050A = wh-objeto.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button":U,    /*** Type ***/
                  INPUT "btSave":U,  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-btSave-wm1050A = wh-objeto.
        
    CREATE BUTTON wh-btOk-new-wm1050A
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-btOk-new-wm1050A":U
           WIDTH     = wh-btOk-wm1050A:WIDTH
           HEIGHT    = wh-btOk-wm1050A:HEIGHT
           ROW       = wh-btOk-wm1050A:ROW
           COL       = wh-btOk-wm1050A:COL
           VISIBLE   = YES
           SENSITIVE = wh-btOk-wm1050A:SENSITIVE
           LABEL     = wh-btOk-wm1050A:LABEL
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN upc/wm1050A-u01.p.
    END.

    CREATE BUTTON wh-btSave-new-wm1050A
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-btSave-new-wm1050A":U
           WIDTH     = wh-btSave-wm1050A:WIDTH 
           HEIGHT    = wh-btSave-wm1050A:HEIGHT
           ROW       = wh-btSave-wm1050A:ROW   
           COL       = wh-btSave-wm1050A:COL   
           VISIBLE   = YES
           SENSITIVE = wh-btSave-wm1050A:SENSITIVE
           LABEL     = wh-btSave-wm1050A:LABEL
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN upc/wm1050A-u02.p.
    END.

    CREATE FILL-IN wh-cod-transp-wm1050A
    ASSIGN FRAME     = p-wgh-frame
           DATA-TYPE = "character":U
           FORMAT    = "x(12)":U
           NAME      = "wh-cod-transp-wm1050A":U
           WIDTH     = 14
           HEIGHT    = 0.88
           ROW       = 4.50
           COL       = 72.35
           VISIBLE   = YES
           SENSITIVE = NO
           FONT      = 1
    TRIGGERS:
       ON f5 PERSISTENT RUN upc/wm1050A-u00.p.
       ON mouse-select-dblclick PERSISTENT RUN upc/wm1050A-u00.p.
    END TRIGGERS.
    wh-cod-transp-wm1050A:LOAD-MOUSE-POINTER("image/lupa.cur").
    
    CREATE TEXT wh-lb-cod-transp-wm1050A
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(16)":U
           WIDTH        = 10
           SCREEN-VALUE = "Transportador:":U
           ROW          = 4.60
           COL          = 62.00
           VISIBLE      = YES
           FONT         = 1.
           
END.

IF  p-ind-event  = "AFTER-DISPLAY":U             
AND VALID-HANDLE(wh-cod-equipto-wm1050A)
AND VALID-HANDLE(wh-cod-transp-wm1050A) THEN DO:
    
    FIND FIRST wm-equipamento WHERE
        wm-equipamento.cod-equipamento = (wh-cod-equipto-wm1050A:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL wm-equipamento THEN
        ASSIGN wh-cod-transp-wm1050A:SCREEN-VALUE = SUBSTRING(wm-equipamento.char-2,110,20)
               wh-cod-transp-wm1050A:VISIBLE      = CAN-FIND(FIRST wm-tipo-equipamento OF wm-equipamento WHERE
                                                             wm-tipo-equipamento.ind-status-equipamento = 2 NO-LOCK)
               wh-lb-cod-transp-wm1050A:VISIBLE   = CAN-FIND(FIRST wm-tipo-equipamento OF wm-equipamento WHERE
                                                             wm-tipo-equipamento.ind-status-equipamento = 2 NO-LOCK).
    ELSE
        ASSIGN wh-cod-transp-wm1050A:SCREEN-VALUE = "":U.

END.


IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wh-cod-transp-wm1050A)    THEN DELETE OBJECT wh-cod-transp-wm1050A.  
    IF  VALID-HANDLE(wh-lb-cod-transp-wm1050A) THEN DELETE OBJECT wh-lb-cod-transp-wm1050A.   
   
END.

IF  p-ind-event  = "AFTER-ENABLE":U             
AND VALID-HANDLE(wh-cod-equipto-wm1050A)
AND VALID-HANDLE(wh-cod-transp-wm1050A) THEN DO:
    
    ASSIGN wh-cod-transp-wm1050A:SENSITIVE = YES.
    
END.


IF  p-ind-event  = "AFTER-ASSIGN":U             
AND VALID-HANDLE(wh-cod-equipto-wm1050A)
AND VALID-HANDLE(wh-cod-transp-wm1050A) THEN DO:
    
    FIND FIRST wm-equipamento WHERE
        wm-equipamento.cod-equipamento = (wh-cod-equipto-wm1050A:SCREEN-VALUE) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-equipamento AND
       CAN-FIND(FIRST wm-tipo-equipamento OF wm-equipamento WHERE
                      wm-tipo-equipamento.ind-status-equipamento = 2 NO-LOCK) THEN DO:
        FIND FIRST transporte WHERE
            transporte.nome-abrev = wh-cod-transp-wm1050A:SCREEN-VALUE NO-LOCK NO-ERROR.
        ASSIGN OVERLAY(wm-equipamento.char-2,100,10) = IF AVAIL transporte THEN STRING(transporte.cod-transp) ELSE ""
               OVERLAY(wm-equipamento.char-2,110,20) = wh-cod-transp-wm1050A:SCREEN-VALUE.
        ASSIGN wh-cod-equipto-wm1050:SCREEN-VALUE = wh-cod-equipto-wm1050A:SCREEN-VALUE.
    END.
    FIND CURRENT wm-equipamento NO-LOCK NO-ERROR.
                                                                                    

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

