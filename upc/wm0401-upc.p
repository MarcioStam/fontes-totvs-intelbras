/***********************************************************************************
** Programa: WM0401-UPC
** Data    : 30/03/2016
** Autor   : Carlos Daniel
***********************************************************************************/

/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-ind-object                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                         AS HANDLE            NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                          AS WIDGET-HANDLE     NO-UNDO.
DEFINE INPUT PARAM p-cod-table                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-row-table                          AS ROWID             NO-UNDO.

/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-fPage1-WM0401      AS WIDGET-HANDLE  NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-WM0401 AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-local-WM0401   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-item-WM0401    AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-refer-WM0401   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-lote-WM0401    AS WIDGET-HANDLE  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-bloq-WM0401    AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-qtd-bloq-WM0401 AS WIDGET-HANDLE  NO-UNDO. 
/************************** Definicao de Variaveis Locais *************************/
DEFINE VARIABLE wh-objeto                               AS WIDGET-HANDLE  NO-UNDO.

DEF VAR d-qtd-bloq      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR c-cod-item      LIKE wm-saldo-estoque.cod-item      NO-UNDO.

/*MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

IF p-ind-event  = "AFTER-INITIALIZE":U  THEN DO:

    IF NOT VALID-HANDLE(wh-qtd-bloq-WM0401) THEN DO:
        CREATE TEXT wh-lb-qtd-bloq-WM0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)":U
               WIDTH        = 13
               SCREEN-VALUE = "Saldo End Bloq:":U
               ROW          = 4.76
               COL          = 39.05
               VISIBLE      = YES
               FONT         = 1.
        CREATE FILL-IN wh-qtd-bloq-WM0401
        ASSIGN FRAME     = p-wgh-frame
               DATA-TYPE = "DECIMAL":U
               FORMAT    = ">>>,>>>,>>9.9999":U
               NAME      = "wh-qtd-bloq-WM0401":U
               WIDTH     = 10.29
               HEIGHT    = 0.88
               ROW       = 4.66
               COL       = 50.15
               VISIBLE   = YES
               SENSITIVE = NO
               FONT      = 1.
    END.
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",               /*** Type ***/
                  INPUT "cod-estabel",           /*** Name ***/
                  INPUT NO,                      /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-estabel-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",             /*** Type ***/
                  INPUT "cod-local",           /*** Name ***/
                  INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-local-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",            /*** Type ***/
                  INPUT "cod-item",           /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-item-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",             /*** Type ***/
                  INPUT "cod-refer",           /*** Name ***/
                  INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-refer-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",            /*** Type ***/
                  INPUT "cod-lote",           /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-lote-WM0401).

    ASSIGN d-qtd-bloq = 0.
        FIND FIRST wm-saldo-estoq 
        WHERE wm-saldo-estoq.cod-estabel = wh-cod-estabel-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-local   = wh-cod-local-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-item    = wh-cod-item-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-refer   = wh-cod-refer-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-lote    = wh-cod-lote-WM0401:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAIL wm-saldo-estoq THEN DO:
        FOR EACH wm-box-saldo OF wm-saldo-estoque WHERE wm-box-saldo.ind-status-saldo <> 2 NO-LOCK,
            FIRST wm-box OF wm-box-saldo WHERE
                wm-box.log-bloq-ret = YES NO-LOCK:
            ASSIGN d-qtd-bloq = d-qtd-bloq + (wm-box-saldo.qtd-item + wm-box-saldo.qtd-item-bloq).
        END.
    END.

    ASSIGN wh-qtd-bloq-WM0401:SCREEN-VALUE = STRING(d-qtd-bloq,">>>,>>>,>>9.9999").

END.

IF  p-ind-event  = "AFTER-DISPLAY":U             
AND VALID-HANDLE(wh-qtd-bloq-WM0401) THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",               /*** Type ***/
                  INPUT "cod-estabel",           /*** Name ***/
                  INPUT NO,                      /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-estabel-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",             /*** Type ***/
                  INPUT "cod-local",           /*** Name ***/
                  INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-local-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",            /*** Type ***/
                  INPUT "cod-item",           /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-item-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",             /*** Type ***/
                  INPUT "cod-refer",           /*** Name ***/
                  INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-refer-WM0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",            /*** Type ***/
                  INPUT "cod-lote",           /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-cod-lote-WM0401).

    ASSIGN d-qtd-bloq = 0.
    FIND FIRST wm-saldo-estoq 
        WHERE wm-saldo-estoq.cod-estabel = wh-cod-estabel-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-local   = wh-cod-local-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-item    = wh-cod-item-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-refer   = wh-cod-refer-WM0401:SCREEN-VALUE
        AND   wm-saldo-estoq.cod-lote    = wh-cod-lote-WM0401:SCREEN-VALUE NO-LOCK NO-ERROR.
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
            ASSIGN d-qtd-bloq = d-qtd-bloq + (wm-box-saldo.qtd-item + wm-box-saldo.qtd-item-bloq).
        END.
        ASSIGN c-cod-item = wm-saldo-estoque.cod-item.
    END.

    ASSIGN wh-qtd-bloq-WM0401:SCREEN-VALUE = STRING(d-qtd-bloq,">>>,>>>,>>9.9999").

END.

IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wh-qtd-bloq-WM0401)     THEN DELETE OBJECT wh-qtd-bloq-WM0401.   
    IF  VALID-HANDLE(wh-lb-qtd-bloq-WM0401)  THEN DELETE OBJECT wh-lb-qtd-bloq-WM0401.

END.


PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS WIDGET-HANDLE NO-UNDO.
    
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


/* Fim rsWM0401.p */



