/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GWM0370 2.00.00.000}  /*** 010000 ***/
/******************************************************************************
** Programa: wmp/epcwm0370.p
*******************************************************************************/
{utp/ut-glob.i}
{esp/es0018.i}
{method/dbotterr.i}

/*--- Parametros Recebidos ---*/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-epcwm0370-wmp         AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btIntegraWm0370      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-id-docto            AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-wm0370-fpage1        AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-fpage4        AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-fpage7        AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-fpage9        AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btAddDocto    AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btCopyDocto   AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btUpdateDocto AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btDeleteDocto AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btAddItem     AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btUpdateItem  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btDeleteItem  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btConfirm     AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0370-btConcludeMovto AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btAddDocto     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btCopyDocto    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btUpdateDocto  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDeleteDocto  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btAddItem      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btUpdateItem   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDeleteItem   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btConfirm      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btConcludeMovto AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDeleteMovto     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDeleteMovto-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-cod-estabel       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-cod-local         AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-id-box            AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-cod-item          AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-seq-item         AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDesfazSugestao     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDesfazSugestao-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDevolucaoItem     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-wm0370-btDevolucaoItem-upc AS HANDLE NO-UNDO.

DEFINE VARIABLE  i-cont AS INTEGER NO-UNDO.
DEFINE VARIABLE l-erro  AS LOGICAL NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_grp_usuar_lst AS CHAR NO-UNDO.

DEFINE VARIABLE  l-habilita-botao  AS LOGICAL     NO-UNDO.

IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:
    IF VALID-HANDLE(h-epcwm0370-wmp) THEN
        DELETE PROCEDURE h-epcwm0370-wmp.

    IF VALID-HANDLE(wh-btAddDocto) THEN
        DELETE OBJECT wh-btAddDocto.

    IF VALID-HANDLE(wh-btCopyDocto) THEN
        DELETE OBJECT wh-btCopyDocto.

    IF VALID-HANDLE(wh-btUpdateDocto) THEN
        DELETE OBJECT wh-btUpdateDocto.

    IF VALID-HANDLE(wh-btDeleteDocto) THEN
        DELETE OBJECT wh-btDeleteDocto.

    IF VALID-HANDLE(wh-btAddItem) THEN
        DELETE OBJECT wh-btAddItem.

    IF VALID-HANDLE(wh-btUpdateItem) THEN
        DELETE OBJECT wh-btUpdateItem.

    IF VALID-HANDLE(wh-btDeleteItem) THEN
        DELETE OBJECT wh-btDeleteItem.

    IF VALID-HANDLE(wh-btConfirm) THEN
        DELETE OBJECT wh-btConfirm.

    IF VALID-HANDLE(wh-btConcludeMovto) THEN
        DELETE OBJECT wh-btConcludeMovto.

    IF VALID-HANDLE(wh-wm0370-btDeleteMovto-upc) THEN
        DELETE OBJECT wh-wm0370-btDeleteMovto-upc.

    IF VALID-HANDLE(wh-wm0370-btDesfazSugestao-upc) THEN
       DELETE OBJECT wh-wm0370-btDesfazSugestao-upc.

    IF VALID-HANDLE(wh-wm0370-btDevolucaoItem-upc) THEN
       DELETE OBJECT(wh-wm0370-btDevolucaoItem-upc).

END.


IF p-ind-event = "AFTER-DISPLAY" THEN DO: /*AFTER-INITIALIZE*/

    RUN upc/wm0370-upc.p PERSISTENT SET h-epcwm0370-wmp (INPUT "", 
                                                         INPUT "", 
                                                         INPUT ?, 
                                                         INPUT p-wgh-frame, 
                                                         INPUT "", 
                                                         INPUT ?). 

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage1",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage1).

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",
                  INPUT "id-docto",
                  INPUT NO,
                  OUTPUT wgh-id-docto).

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "cod-estabel",
                  INPUT NO,
                  OUTPUT wh-wm0370-cod-estabel).      

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "cod-local",
                  INPUT NO,
                  OUTPUT wh-wm0370-cod-local).      
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage7",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage7).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage4",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage4).

    RUN tela-upc (INPUT wh-wm0370-fpage4,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "cod-item",
                  INPUT NO,
                  OUTPUT wh-wm0370-cod-item). 

    RUN tela-upc (INPUT wh-wm0370-fpage4,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "num-seq-item",
                  INPUT NO,
                  OUTPUT wh-wm0370-seq-item).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage9",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage9).

    RUN tela-upc (INPUT wh-wm0370-fpage9,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btDevolucaoItem",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDevolucaoItem).

    CREATE BUTTON wh-wm0370-btDevolucaoItem-upc
    ASSIGN  FRAME     = wh-wm0370-fpage9
           FLAT-BUTTON = YES
            WIDTH     = wh-wm0370-btDevolucaoItem:WIDTH
            HEIGHT    = wh-wm0370-btDevolucaoItem:HEIGHT
            ROW       = wh-wm0370-btDevolucaoItem:ROW
            COL       = wh-wm0370-btDevolucaoItem:COL
            LABEL     = wh-wm0370-btDevolucaoItem:LABEL
            HELP      = wh-wm0370-btDevolucaoItem:HELP
            TOOLTIP   = wh-wm0370-btDevolucaoItem:TOOLTIP
            SENSITIVE = NO
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-valida-btDevolucaoItem IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-wm0370-btDevolucaoItem-upc:LOAD-IMAGE-UP(wh-wm0370-btDevolucaoItem:IMAGE-UP) NO-ERROR.
    wh-wm0370-btDevolucaoItem-upc:LOAD-IMAGE-INSENSITIVE(wh-wm0370-btDevolucaoItem:IMAGE-INSENSITIVE) NO-ERROR.
    wh-wm0370-btDevolucaoItem-upc:MOVE-TO-TOP()NO-ERROR.

    RUN tela-upc (INPUT wh-wm0370-fpage7,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btDeleteMovto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDeleteMovto).

    RUN tela-upc (INPUT wh-wm0370-fpage7,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "id-box",
                  INPUT NO,
                  OUTPUT wh-wm0370-id-box).  


    CREATE BUTTON wh-wm0370-btDeleteMovto-upc
    ASSIGN  FRAME     = wh-wm0370-fpage7
            WIDTH     = wh-wm0370-btDeleteMovto:WIDTH
            HEIGHT    = wh-wm0370-btDeleteMovto:HEIGHT
            ROW       = wh-wm0370-btDeleteMovto:ROW
            COL       = wh-wm0370-btDeleteMovto:COL
            LABEL     = wh-wm0370-btDeleteMovto:LABEL
            HELP      = wh-wm0370-btDeleteMovto:HELP
            TOOLTIP   = wh-wm0370-btDeleteMovto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-valida-btDeleteMovto IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-wm0370-btDeleteMovto-upc:LOAD-IMAGE-UP("image\im-ngrava").
    wh-wm0370-btDeleteMovto-upc:LOAD-IMAGE-INSENSITIVE("image\ii-ngrava").
    wh-wm0370-btDeleteMovto-upc:MOVE-TO-TOP().

    ASSIGN l-habilita-botao = NO.

    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.

    RUN esp/es0018p.p (INPUT "wm0370":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        DO i-cont = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo,';'):
           IF LOOKUP(ENTRY(i-cont,tt-prog-ponto.conteudo,';'),v_cod_grp_usuar_lst) <> 0 THEN
              ASSIGN l-habilita-botao = YES. 
        END.
    END.

    IF l-habilita-botao THEN LEAVE.      
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage1",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage1).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage7",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage7).

    /* Add Button */
    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btAddDocto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btAddDocto).

    CREATE BUTTON wh-btAddDocto
    ASSIGN  FRAME     = wh-wm0370-fpage1
            WIDTH     = wh-wm0370-btAddDocto:WIDTH
            HEIGHT    = wh-wm0370-btAddDocto:HEIGHT
            ROW       = wh-wm0370-btAddDocto:ROW
            COL       = wh-wm0370-btAddDocto:COL
            LABEL     = wh-wm0370-btAddDocto:LABEL
            HELP      = wh-wm0370-btAddDocto:HELP
            TOOLTIP   = wh-wm0370-btAddDocto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btAddDocto:LOAD-IMAGE-UP("image\ii-add").
    wh-btAddDocto:LOAD-IMAGE-INSENSITIVE("image\ii-add").
    wh-btAddDocto:MOVE-TO-TOP().
    
    /*
    /* Copy Button */
    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btCopyDocto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btCopyDocto).

    CREATE BUTTON wh-btCopyDocto
    ASSIGN  FRAME     = wh-wm0370-fpage1
            WIDTH     = wh-wm0370-btCopyDocto:WIDTH
            HEIGHT    = wh-wm0370-btCopyDocto:HEIGHT
            ROW       = wh-wm0370-btCopyDocto:ROW
            COL       = wh-wm0370-btCopyDocto:COL
            LABEL     = wh-wm0370-btCopyDocto:LABEL
            HELP      = wh-wm0370-btCopyDocto:HELP
            TOOLTIP   = wh-wm0370-btCopyDocto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btCopyDocto:LOAD-IMAGE-UP("image\ii-copy").
    wh-btCopyDocto:LOAD-IMAGE-INSENSITIVE("image\ii-copy").
    wh-btCopyDocto:MOVE-TO-TOP().
    */

    /*
    /* Update Button */
    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btUpdateDocto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btUpdateDocto).

    CREATE BUTTON wh-btUpdateDocto
    ASSIGN  FRAME     = wh-wm0370-fpage1
            WIDTH     = wh-wm0370-btUpdateDocto:WIDTH
            HEIGHT    = wh-wm0370-btUpdateDocto:HEIGHT
            ROW       = wh-wm0370-btUpdateDocto:ROW
            COL       = wh-wm0370-btUpdateDocto:COL
            LABEL     = wh-wm0370-btUpdateDocto:LABEL
            HELP      = wh-wm0370-btUpdateDocto:HELP
            TOOLTIP   = wh-wm0370-btUpdateDocto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btUpdateDocto:LOAD-IMAGE-UP("image\ii-mod").
    wh-btUpdateDocto:LOAD-IMAGE-INSENSITIVE("image\ii-mod").
    wh-btUpdateDocto:MOVE-TO-TOP().
    */

    /*
    /* Delete Button */
    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btDeleteDocto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDeleteDocto).

    CREATE BUTTON wh-btDeleteDocto
    ASSIGN  FRAME     = wh-wm0370-fpage1
            WIDTH     = wh-wm0370-btDeleteDocto:WIDTH
            HEIGHT    = wh-wm0370-btDeleteDocto:HEIGHT
            ROW       = wh-wm0370-btDeleteDocto:ROW
            COL       = wh-wm0370-btDeleteDocto:COL
            LABEL     = wh-wm0370-btDeleteDocto:LABEL
            HELP      = wh-wm0370-btDeleteDocto:HELP
            TOOLTIP   = wh-wm0370-btDeleteDocto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btDeleteDocto:LOAD-IMAGE-UP("image\ii-era").
    wh-btDeleteDocto:LOAD-IMAGE-INSENSITIVE("image\ii-era").
    wh-btDeleteDocto:MOVE-TO-TOP().
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage9",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage9).
                  */
    /*
    /* Add Button */
    RUN tela-upc (INPUT wh-wm0370-fpage9,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btAddItem",
                  INPUT NO,
                  OUTPUT wh-wm0370-btAddItem).

    CREATE BUTTON wh-btAddItem
    ASSIGN  FRAME     = wh-wm0370-fpage9
            WIDTH     = wh-wm0370-btAddItem:WIDTH
            HEIGHT    = wh-wm0370-btAddItem:HEIGHT
            ROW       = wh-wm0370-btAddItem:ROW
            COL       = wh-wm0370-btAddItem:COL
            LABEL     = wh-wm0370-btAddItem:LABEL
            HELP      = wh-wm0370-btAddItem:HELP
            TOOLTIP   = wh-wm0370-btAddItem:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btAddItem:LOAD-IMAGE-UP("image\ii-add").
    wh-btAddItem:LOAD-IMAGE-INSENSITIVE("image\ii-add").
    wh-btAddItem:MOVE-TO-TOP().

    /* Update Button */
    RUN tela-upc (INPUT wh-wm0370-fpage9,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btUpdateItem",
                  INPUT NO,
                  OUTPUT wh-wm0370-btUpdateItem).

    CREATE BUTTON wh-btUpdateItem
    ASSIGN  FRAME     = wh-wm0370-fpage9
            WIDTH     = wh-wm0370-btUpdateItem:WIDTH
            HEIGHT    = wh-wm0370-btUpdateItem:HEIGHT
            ROW       = wh-wm0370-btUpdateItem:ROW
            COL       = wh-wm0370-btUpdateItem:COL
            LABEL     = wh-wm0370-btUpdateItem:LABEL
            HELP      = wh-wm0370-btUpdateItem:HELP
            TOOLTIP   = wh-wm0370-btUpdateItem:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btUpdateItem:LOAD-IMAGE-UP("image\ii-mod").
    wh-btUpdateItem:LOAD-IMAGE-INSENSITIVE("image\ii-mod").
    wh-btUpdateItem:MOVE-TO-TOP().

    /* Delete Button */
    RUN tela-upc (INPUT wh-wm0370-fpage9,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btDeleteItem",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDeleteItem).

    CREATE BUTTON wh-btDeleteItem
    ASSIGN  FRAME     = wh-wm0370-fpage9
            WIDTH     = wh-wm0370-btDeleteItem:WIDTH
            HEIGHT    = wh-wm0370-btDeleteItem:HEIGHT
            ROW       = wh-wm0370-btDeleteItem:ROW
            COL       = wh-wm0370-btDeleteItem:COL
            LABEL     = wh-wm0370-btDeleteItem:LABEL
            HELP      = wh-wm0370-btDeleteItem:HELP
            TOOLTIP   = wh-wm0370-btDeleteItem:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btDeleteItem:LOAD-IMAGE-UP("image\ii-era").
    wh-btDeleteItem:LOAD-IMAGE-INSENSITIVE("image\ii-era").
    wh-btDeleteItem:MOVE-TO-TOP().

    /* Confirm Button */
    RUN tela-upc (INPUT wh-wm0370-fpage9,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btConfirm",
                  INPUT NO,
                  OUTPUT wh-wm0370-btConfirm).

    CREATE BUTTON wh-btConfirm
    ASSIGN  FRAME     = wh-wm0370-fpage9
            WIDTH     = wh-wm0370-btConfirm:WIDTH
            HEIGHT    = wh-wm0370-btConfirm:HEIGHT
            ROW       = wh-wm0370-btConfirm:ROW
            COL       = wh-wm0370-btConfirm:COL
            LABEL     = wh-wm0370-btConfirm:LABEL
            HELP      = wh-wm0370-btConfirm:HELP
            TOOLTIP   = wh-wm0370-btConfirm:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btConfirm:LOAD-IMAGE-UP("image\ii-desc").
    wh-btConfirm:LOAD-IMAGE-INSENSITIVE("image\ii-desc").
    wh-btConfirm:MOVE-TO-TOP().

    /* Conclude Movto */
    RUN tela-upc (INPUT wh-wm0370-fpage7,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btConcludeMovto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btConcludeMovto).

    CREATE BUTTON wh-btConcludeMovto
    ASSIGN  FRAME     = wh-wm0370-fpage7
            WIDTH     = wh-wm0370-btConcludeMovto:WIDTH
            HEIGHT    = wh-wm0370-btConcludeMovto:HEIGHT
            ROW       = wh-wm0370-btConcludeMovto:ROW
            COL       = wh-wm0370-btConcludeMovto:COL
            LABEL     = wh-wm0370-btConcludeMovto:LABEL
            HELP      = wh-wm0370-btConcludeMovto:HELP
            TOOLTIP   = wh-wm0370-btConcludeMovto:TOOLTIP
            SENSITIVE = YES
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-vazio IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-btConcludeMovto:LOAD-IMAGE-UP("image\ii-desc").
    wh-btConcludeMovto:LOAD-IMAGE-INSENSITIVE("image\ii-desc").
    wh-btConcludeMovto:MOVE-TO-TOP().
    */
    
END.

IF p-ind-event = "AFTER-INITIALIZE" THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage1",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage1).

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",
                  INPUT "id-docto",
                  INPUT NO,
                  OUTPUT wgh-id-docto).

    CREATE BUTTON wh-btIntegraWm0370
    ASSIGN FRAME   = p-wgh-frame
           FLAT-BUTTON = YES
           ROW     = 1.13
           COLUMN  = 60
           WIDTH   = 4
           HEIGHT  = 1.25
           VISIBLE = YES
           SENSITIVE = YES.
    wh-btIntegraWm0370:LOAD-IMAGE-UP('image\toolbar\im-item.bmp').
    //wh-btIntegraWm0370:LOAD-IMAGE-INSENSITIVE('image\toolbar\ii-item.bmp').
    wh-btIntegraWm0370:TOOLTIP = 'Integra documento com o Protheus'.
    wh-btIntegraWm0370:MOVE-TO-TOP().
    ON 'CHOOSE' OF wh-btIntegraWm0370 PERSISTENT RUN pi-choose-bt-integra IN h-epcwm0370-wmp.

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "cod-estabel",
                  INPUT NO,
                  OUTPUT wh-wm0370-cod-estabel).      

    RUN tela-upc (INPUT wh-wm0370-fpage1,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "cod-local",
                  INPUT NO,
                  OUTPUT wh-wm0370-cod-local).      

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage7",
                  INPUT NO,
                  OUTPUT wh-wm0370-fpage7).

    RUN tela-upc (INPUT wh-wm0370-fpage7,
                  INPUT p-ind-event,
                  INPUT "BUTTON",
                  INPUT "btDeleteMovto",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDeleteMovto).

    RUN tela-upc (INPUT wh-wm0370-fpage7,
                  INPUT p-ind-event,
                  INPUT "FILL-IN",
                  INPUT "id-box",
                  INPUT NO,
                  OUTPUT wh-wm0370-id-box).   
    
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "button",
                  INPUT "btDesfazSugestao",
                  INPUT NO,
                  OUTPUT wh-wm0370-btDesfazSugestao).
    

    CREATE BUTTON wh-wm0370-btDesfazSugestao-upc
    ASSIGN  FRAME     = p-wgh-frame
           FLAT-BUTTON = YES
            WIDTH     = wh-wm0370-btDesfazSugestao:WIDTH
            HEIGHT    = wh-wm0370-btDesfazSugestao:HEIGHT
            ROW       = wh-wm0370-btDesfazSugestao:ROW
            COL       = wh-wm0370-btDesfazSugestao:COL
            LABEL     = wh-wm0370-btDesfazSugestao:LABEL
            HELP      = wh-wm0370-btDesfazSugestao:HELP
            TOOLTIP   = wh-wm0370-btDesfazSugestao:TOOLTIP
            SENSITIVE = NO
            VISIBLE   = YES
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-valida-btDesfazSugestao IN h-epcwm0370-wmp.
    END TRIGGERS.
    wh-wm0370-btDesfazSugestao-upc:LOAD-IMAGE-UP(wh-wm0370-btDesfazSugestao:IMAGE-UP).
    wh-wm0370-btDesfazSugestao-upc:LOAD-IMAGE-INSENSITIVE(wh-wm0370-btDesfazSugestao:IMAGE-INSENSITIVE).
    wh-wm0370-btDesfazSugestao-upc:MOVE-TO-TOP().

END.


IF VALID-HANDLE(wh-wm0370-btDesfazSugestao) AND 
   VALID-HANDLE(wh-wm0370-btDesfazSugestao-upc) THEN DO:
   ASSIGN wh-wm0370-btDesfazSugestao-upc:SENSITIVE = wh-wm0370-btDesfazSugestao:SENSITIVE.
END. 

IF VALID-HANDLE(wh-wm0370-btDevolucaoItem) AND 
   VALID-HANDLE(wh-wm0370-btDevolucaoItem-upc) THEN DO:
   ASSIGN wh-wm0370-btDevolucaoItem-upc:SENSITIVE = wh-wm0370-btDevolucaoItem:SENSITIVE.
END.


/* PROCEDURES */
PROCEDURE pi-vazio:
    
END.


PROCEDURE pi-valida-btDevolucaoItem:
     
    /*
    MESSAGE ' wgh-id-docto:SCREEN-VALUE '   wgh-id-docto:SCREEN-VALUE skip
           ' wh-wm0370-cod-item:SCREEN-VALUE  ' wh-wm0370-cod-item:SCREEN-VALUE SKIP 
           ' wh-wm0370-seq-item:SCREEN-VALUE ' wh-wm0370-seq-item:SCREEN-VALUE 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/


    DEFINE VARIABLE l-bloqueado AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-ender     AS CHARACTER   NO-UNDO.

    FIND FIRST wm-docto 
         WHERE wm-docto.id-docto = DEC(wgh-id-docto:SCREEN-VALUE) 
    NO-LOCK NO-ERROR.

    Loop:
    FOR EACH wm-docto-itens OF wm-docto NO-LOCK
        WHERE wm-docto-itens.num-seq-item = INT(wh-wm0370-seq-item:SCREEN-VALUE)
          AND wm-docto-itens.cod-item     = wh-wm0370-cod-item:SCREEN-VALUE:
        FOR EACH Wm-box-movto OF wm-docto-itens NO-LOCK,
            FIRST wm-box NO-LOCK
            WHERE wm-box.cod-estabel = Wm-box-movto.cod-estabel 
              AND wm-box.cod-local   = Wm-box-movto.cod-local  
              AND wm-box.id-box      = Wm-box-movto.id-box
              AND wm-box.log-bloq-retir:
              ASSIGN c-ender = 'Produto: ' + wm-docto-itens.cod-item + ' - ' + wm-box.cod-bloco + '/' + wm-box.cod-rua + '/' + wm-box.cod-nivel + '/' + wm-box.cod-coluna
                     l-bloqueado = YES. 
              LEAVE loop.               
        END. 
    END.
    
    IF l-bloqueado THEN DO:
       RUN utp/ut-msgs.p(INPUT "show",
                         INPUT 17242,
                         INPUT "Endereáo Bloqueado ~~ O endereáo est† bloqueado para retirada." + CHR(13) + CHR(13) + c-ender).
       RETURN "OK".
    END.   

    IF VALID-HANDLE(wh-wm0370-btDevolucaoItem) THEN
       APPLY 'choose' TO wh-wm0370-btDevolucaoItem.


END PROCEDURE.

PROCEDURE pi-valida-btDesfazSugestao:

    DEFINE VARIABLE l-bloqueado AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-ender     AS CHARACTER   NO-UNDO.

    FIND FIRST wm-docto 
         WHERE wm-docto.id-docto = DEC(wgh-id-docto:SCREEN-VALUE) 
    NO-LOCK NO-ERROR.
    
    Loop:
    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:
        FOR EACH Wm-box-movto OF wm-docto-itens NO-LOCK,
            FIRST wm-box NO-LOCK
            WHERE wm-box.cod-estabel = Wm-box-movto.cod-estabel 
              AND wm-box.cod-local   = Wm-box-movto.cod-local  
              AND wm-box.id-box      = Wm-box-movto.id-box
              AND wm-box.log-bloq-retir:
            
              ASSIGN c-ender = c-ender + CHR(13) + 'Produto: ' + wm-docto-itens.cod-item + ' - ' + wm-box.cod-bloco + '/' + wm-box.cod-rua + '/' + wm-box.cod-nivel + '/' + wm-box.cod-coluna
                     l-bloqueado = YES.          

              NEXT loop.
        END. 
    END.
    
    IF l-bloqueado THEN DO:
       RUN utp/ut-msgs.p(INPUT "show",
                         INPUT 17242,
                         INPUT "Endereáo Bloqueado ~~ O endereáo est† bloqueado para retirada." + CHR(13) + c-ender).
       RETURN "OK".
    END.   

    IF VALID-HANDLE(wh-wm0370-btDesfazSugestao) THEN
       APPLY 'choose' TO wh-wm0370-btDesfazSugestao.

END PROCEDURE.




PROCEDURE pi-valida-btDeleteMovto:    

    FIND FIRST wm-box NO-LOCK
         WHERE wm-box.cod-estabel = wh-wm0370-cod-estabel:SCREEN-VALUE
           AND wm-box.cod-local   = wh-wm0370-cod-local:SCREEN-VALUE
           AND wm-box.id-box      = int(wh-wm0370-id-box:SCREEN-VALUE) NO-ERROR.
    IF AVAIL wm-box THEN DO:
        IF wm-box.log-bloq-retir THEN DO:

            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17242,
                              INPUT "Endereáo Bloqueado ~~ O endereáo est† bloqueado para retirada.").
            RETURN "OK".
        END.
    END.

    APPLY 'choose' TO wh-wm0370-btDeleteMovto.
    
END PROCEDURE.

PROCEDURE pi-choose-bt-integra:

    IF VALID-HANDLE(wgh-id-docto) THEN DO:

        FIND FIRST wm-docto NO-LOCK
             WHERE wm-docto.id-docto = DEC(wgh-id-docto:SCREEN-VALUE) NO-ERROR.
        IF AVAIL wm-docto THEN DO:
            /*
            IF wm-docto.ind-sit-docto = 1 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW",
                                   INPUT 17006, 
                                   INPUT "Documento n∆o est† atualizado.").
                RETURN "NOK".

            END.
            */
            // Estabelecimento
            RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                                INPUT 1,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
            IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
                FIND FIRST tt-prog-ponto
                     WHERE ENTRY(2,tt-prog-ponto.conteudo,";") = wm-docto.cod-estabel NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                    IF substring(wm-docto.char-2,1,20) <> "" THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 17006, 
                                           INPUT "Documento j† integrado com o Protheus").
                        RETURN "NOK".
                    END.

                    RUN esp/wmp/returnDoctoEntrada.p(INPUT ROWID(wm-docto),
                                                 OUTPUT l-erro,
                                                 OUTPUT TABLE rowErrors).

                    IF l-erro THEN DO:
                        IF CAN-FIND(FIRST rowErrors) THEN DO:
                            FOR EACH Rowerrors NO-LOCK:
                                RUN utp/ut-msgs.p (INPUT "SHOW",
                                                   INPUT Rowerrors.ErrorNum, 
                                                   INPUT Rowerrors.ErrorDescription).
                            END.
                            RETURN "NOK".
                        END.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 15825, 
                                           INPUT "Integraá∆o realizada com sucesso").
                        RETURN "NOK".

                    END.
                END.
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.

    RELEASE wm-docto NO-ERROR.

    RETURN "OK".

END PROCEDURE.

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
        IF  pApresMsg = YES THEN
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP
                    "Type do Objeto" wgh-obj:TYPE SKIP
                    "P-Ind-Event"    pIndEvent SKIP 
                    "Objeto "        pObjName    
                     VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE = pObjType AND
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
