/***********************************************************************************
** SCM CONCEPT Tecnologia da Informa»’o
** 
** Programa: WM0402-UPC - UPC Localizacao
** Data    : 20 de Marco de 2016
** Autor   : Carlos da Costa Junior
**
***********************************************************************************/
{include/i-prgvrs.i WM0402-UPC 2.00.00.000}  /*** 010000 ***/
/**********************************************************************************/

/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-ind-object                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                         AS HANDLE            NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                          AS WIDGET-HANDLE     NO-UNDO.
DEFINE INPUT PARAM p-cod-table                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-row-table                          AS ROWID             NO-UNDO.

/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-fPage1-WM0402      AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-bloq-WM0402    AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-qtd-bloq-WM0402 AS WIDGET-HANDLE  NO-UNDO. 
/************************** Definicao de Variaveis Locais *************************/
DEFINE VARIABLE wh-objeto                               AS WIDGET-HANDLE  NO-UNDO.

DEF VAR d-qtd-bloq      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR c-cod-item      LIKE wm-saldo-estoque.cod-item      NO-UNDO.

IF p-ind-event  = "AFTER-INITIALIZE":U  THEN DO:

    IF NOT VALID-HANDLE(wh-qtd-bloq-WM0402) THEN DO:
        CREATE TEXT wh-lb-qtd-bloq-WM0402
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)":U
               WIDTH        = 13
               SCREEN-VALUE = "Saldo End Bloq:":U
               ROW          = 6.93
               COL          = 62.55
               VISIBLE      = YES
               FONT         = 1.
        CREATE FILL-IN wh-qtd-bloq-WM0402
        ASSIGN FRAME     = p-wgh-frame
               DATA-TYPE = "DECIMAL":U
               FORMAT    = ">>>,>>>,>>9.9999":U
               NAME      = "wh-qtd-bloq-WM0402":U
               WIDTH     = 15.29
               HEIGHT    = 0.88
               ROW       = 6.83
               COL       = 73.65
               VISIBLE   = YES
               SENSITIVE = NO
               FONT      = 1.
    END.
    
    ASSIGN d-qtd-bloq = 0.
    FIND FIRST wm-saldo-estoq WHERE
        ROWID(wm-saldo-estoq) = p-row-table NO-LOCK NO-ERROR.
    IF AVAIL wm-saldo-estoq THEN DO:
        FOR EACH wm-box-saldo OF wm-saldo-estoque WHERE wm-box-saldo.ind-status-saldo <> 2 NO-LOCK,
            FIRST wm-box OF wm-box-saldo WHERE
                wm-box.log-bloq-ret = YES NO-LOCK:
            ASSIGN d-qtd-bloq = d-qtd-bloq + (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq).
        END.
    END.

    ASSIGN wh-qtd-bloq-WM0402:SCREEN-VALUE = STRING(d-qtd-bloq,">>>,>>>,>>9.9999").

END.

IF  p-ind-event  = "AFTER-DISPLAY":U             
AND VALID-HANDLE(wh-qtd-bloq-WM0402) THEN DO:
    
    ASSIGN d-qtd-bloq = 0.
    FIND FIRST wm-saldo-estoq WHERE
        ROWID(wm-saldo-estoq) = p-row-table NO-LOCK NO-ERROR.
    IF AVAIL wm-saldo-estoq AND c-cod-item <> wm-saldo-estoque.cod-item THEN DO:
        FOR EACH wm-box-saldo USE-INDEX idx-box-saldo3 WHERE
            wm-box-saldo.cod-estabel      = wm-saldo-estoque.cod-estabel AND
            wm-box-saldo.cod-local        = wm-saldo-estoque.cod-local   AND
            wm-box-saldo.cod-item         = wm-saldo-estoque.cod-item    AND
            wm-box-saldo.cod-refer        = wm-saldo-estoque.cod-refer   AND
            wm-box-saldo.ind-status-saldo <> 2                           NO-LOCK,
            FIRST wm-box WHERE
                wm-box.cod-estabel  = wm-box-saldo.cod-estabel AND
                wm-box.cod-local    = wm-box-saldo.cod-local   AND
                wm-box.id-box       = wm-box-saldo.id-box      AND
                wm-box.log-bloq-ret = YES                      NO-LOCK:
            ASSIGN d-qtd-bloq = d-qtd-bloq + (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq).
        END.
        ASSIGN c-cod-item = wm-saldo-estoque.cod-item.
    END.

    ASSIGN wh-qtd-bloq-WM0402:SCREEN-VALUE = STRING(d-qtd-bloq,">>>,>>>,>>9.9999").

END.

IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wh-qtd-bloq-WM0402)     THEN DELETE OBJECT wh-qtd-bloq-WM0402.   
    IF  VALID-HANDLE(wh-lb-qtd-bloq-WM0402)  THEN DELETE OBJECT wh-lb-qtd-bloq-WM0402.

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


/* Fim rsWM0402.p */



