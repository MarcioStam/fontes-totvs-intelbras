
/***********************************************************************************
** SCM Concept Tecnologia da Informacao LTDA
** UPC: CD1525 - Parametro para Permitir Transferir Saldo Bloqueado
***********************************************************************************/
{include/i-prgvrs.i CD1525-UPC 2.00.00.000}  /*** 010000 ***/
/**********************************************************************************/

/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-ind-object                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                         AS HANDLE            NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                          AS WIDGET-HANDLE     NO-UNDO.
DEFINE INPUT PARAM p-cod-table                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-row-table                          AS ROWID             NO-UNDO.

/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-usuario-cd1525         AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-rect-new-cd1525        AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-log-permite-cd1525     AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-permite-cd1525      AS WIDGET-HANDLE  NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-padrao-cd1525       AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-email-cd1525        AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-log-recebeEmail-cd1525 AS WIDGET-HANDLE  NO-UNDO.


/************************** Definicao de Variaveis Locais *************************/
DEFINE VARIABLE wh-objeto                               AS WIDGET-HANDLE  NO-UNDO.

IF p-ind-event  = "BEFORE-DISPLAY":U  THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in":U,    /*** Type ***/
                  INPUT "usuario":U,    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-usuario-cd1525 = wh-objeto.

    CREATE TOGGLE-BOX wh-log-permite-cd1525
    ASSIGN FRAME     = p-wgh-frame
           /* DATA-TYPE = "Logical":U */
           FORMAT    = "Yes/No":U
           NAME      = "wh-log-permite-cd1525":U
           WIDTH     = 20
           HEIGHT    = 0.88
           ROW       = 6.85
           COL       = 66.00
           LABEL     = "Transferància Bloqueado"
           VISIBLE   = YES
           SENSITIVE = NO
           FONT      = 1.
    
    CREATE TEXT wh-lb-padrao-cd1525 
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(9)":U
           WIDTH        = 7.5
           SCREEN-VALUE = "Permiss∆o":U
           ROW          = 6.25
           COL          = 66.29
           VISIBLE      = YES
           FONT         = 1.

    CREATE RECT wh-rect-new-cd1525
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 24
           HEIGHT       = 5.29
           ROW          = 6.42
           COL          = 64.86
           FILLED       = NO
           EDGE-PIXELS = 2
           VISIBLE      = YES.
    
    CREATE RECT wh-rect-new-cd1525
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 24
           HEIGHT       = 1.38
           ROW          = 4.71
           COL          = 64.86
           FILLED       = NO
           EDGE-PIXELS  = 2
           VISIBLE      = YES.
    
    CREATE TEXT wh-lb-email-cd1525 
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(9)":U
           WIDTH        = 4.86
           SCREEN-VALUE = "E-mail":U
           ROW          = 4.5
           COL          = 66.29
           VISIBLE      = YES
           FONT         = 1.

    CREATE TOGGLE-BOX wh-log-recebeEmail-cd1525
    ASSIGN FRAME     = p-wgh-frame
           /* DATA-TYPE = "Logical":U */
           FORMAT    = "Yes/No":U
           NAME      = "wh-log-recebeEmail-cd1525":U
           WIDTH     = 20
           HEIGHT    = 0.88
           ROW       = 5
           COL       = 66.00
           LABEL     = "Recebe Email Picking"
           HELP      = "Recebe Email Necessidades Criaá∆o µreas Picking"
           VISIBLE   = YES
           SENSITIVE = NO
           FONT      = 1.
    
   
END.

IF  p-ind-event  = "AFTER-DISPLAY":U             
AND VALID-HANDLE(wh-usuario-cd1525)
AND VALID-HANDLE(wh-log-permite-cd1525)
AND VALID-HANDLE(wh-log-recebeEmail-cd1525)
THEN DO:
    
    FIND FIRST usuario-scm NO-LOCK 
         WHERE usuario-scm.usuario = wh-usuario-cd1525:SCREEN-VALUE NO-ERROR.
    IF AVAIL usuario-scm
    THEN
        ASSIGN wh-log-permite-cd1525    :CHECKED = usuario-scm.log-2
               wh-log-recebeEmail-cd1525:CHECKED = (ENTRY(1,usuario-scm.char-1,";") = "YES").
    ELSE
        ASSIGN wh-log-permite-cd1525    :CHECKED = NO
               wh-log-recebeEmail-cd1525:CHECKED = NO.
END.

IF  p-ind-event  = "AFTER-ENABLE":U
AND VALID-HANDLE(wh-log-permite-cd1525)
AND VALID-HANDLE(wh-log-recebeEmail-cd1525)
THEN DO:

    ASSIGN wh-log-permite-cd1525    :SENSITIVE = YES
           wh-log-recebeEmail-cd1525:SENSITIVE = YES.

END.

IF  p-ind-event  = "AFTER-DISABLE":U
AND VALID-HANDLE(wh-log-permite-cd1525)
AND VALID-HANDLE(wh-log-recebeEmail-cd1525)
THEN DO:

    ASSIGN wh-log-permite-cd1525    :SENSITIVE = NO
           wh-log-recebeEmail-cd1525:SENSITIVE = NO.

END.

IF p-ind-event  = "AFTER-UNDO":U 
AND VALID-HANDLE(wh-log-permite-cd1525)
AND VALID-HANDLE(wh-log-recebeEmail-cd1525)
THEN DO:
    
    ASSIGN wh-log-permite-cd1525:SENSITIVE = YES.

    FIND FIRST usuario-scm NO-LOCK 
         WHERE usuario-scm.usuario = wh-usuario-cd1525:SCREEN-VALUE NO-ERROR.
    IF AVAIL usuario-scm THEN
        ASSIGN wh-log-permite-cd1525    :CHECKED = usuario-scm.log-2
               wh-log-recebeEmail-cd1525:CHECKED = (ENTRY(1,usuario-scm.char-1,";") = "YES").
    ELSE
        ASSIGN wh-log-permite-cd1525    :CHECKED = NO
               wh-log-recebeEmail-cd1525:CHECKED = NO.

END.
    
IF p-ind-event  = "AFTER-ASSIGN":U    
AND VALID-HANDLE(wh-usuario-cd1525) 
AND VALID-HANDLE(wh-log-permite-cd1525)
AND VALID-HANDLE(wh-log-recebeEmail-cd1525)
THEN DO:     
    
    FIND FIRST usuario-scm EXCLUSIVE-LOCK 
         WHERE usuario-scm.usuario = wh-usuario-cd1525:SCREEN-VALUE NO-ERROR.

    IF AVAIL usuario-scm THEN DO:
        ASSIGN usuario-scm.log-2 = wh-log-permite-cd1525:CHECKED
               usuario-scm.char-1 = STRING(wh-log-recebeEmail-cd1525:CHECKED) + ";". //Entrada 1 do campo ';'
    END.    

END.  

IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wh-rect-new-cd1525)        THEN DELETE OBJECT wh-rect-new-cd1525.   
    IF  VALID-HANDLE(wh-log-permite-cd1525)     THEN DELETE OBJECT wh-log-permite-cd1525.  
    IF  VALID-HANDLE(wh-lb-permite-cd1525)      THEN DELETE OBJECT wh-lb-permite-cd1525.   
    IF  VALID-HANDLE(wh-lb-padrao-cd1525)       THEN DELETE OBJECT wh-lb-padrao-cd1525.
    IF  VALID-HANDLE(wh-lb-email-cd1525)        THEN DELETE OBJECT wh-lb-email-cd1525.
    IF  VALID-HANDLE(wh-log-recebeEmail-cd1525) THEN DELETE OBJECT wh-log-recebeEmail-cd1525.
    

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


/* Fim rscd1525.p */



