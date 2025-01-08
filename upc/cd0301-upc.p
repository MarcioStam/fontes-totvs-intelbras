/*------------------------------------------------------------------------
    File        : cd0301-UPC.P
    Author      : Carlos Daniel - 11/03/2016
------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/*{esp/es0018.i}*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-cd-plano-cd0301  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tb-multi-estabel AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cons-lote-venc   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0301-del     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux             AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux             AS INTEGER       NO-UNDO.
DEFINE VARIABLE c-ge-codigo       AS CHARACTER     NO-UNDO.

DEFINE VARIABLE wh-frame           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fPage1          AS WIDGET-HANDLE NO-UNDO.

/* ***************************  Main Block  *************************** */
                                                                                        
FUNCTION getWidgetHandle    RETURNS WIDGET-HANDLE (INPUT pWidget     AS CHAR)   FORWARD.
FUNCTION getWidgetHandleSub RETURNS WIDGET-HANDLE (INPUT c-widget    AS CHAR, 
                                                   INPUT p-wgh-frame AS HANDLE) FORWARD.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

/*MESSAGE "EVENTO: ":U   p-ind-event      SKIP
        "OBJETO: ":U   p-ind-object     SKIP
        "NOME OBJ: ":U c-objeto         SKIP
        "FRAME: ":U    p-wgh-frame:NAME SKIP
        "TABELA: ":U   p-cod-table      SKIP
        "ROWID: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

IF p-ind-event  = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:
       
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        
        IF h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" then
           LEAVE.

        IF h-frame:TYPE NE "field-group" THEN
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    IF  h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" THEN DO:
        CREATE BUTTON wh-cd0301-del
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 60
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Deletar Itens do Plano"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN esp/cdp/escdp0301-del.w.
               END TRIGGERS.
    
        IF wh-cd0301-del:LOAD-IMAGE("image/gr-lay.bmp") THEN.
        IF wh-cd0301-del:LOAD-IMAGE-DOWN("image/gr-lay.bmp") THEN.
    END.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cd-plano",
                     OUTPUT wh-cd-plano-cd0301).

    ASSIGN wh-fPage1           = getWidgetHandle("fPage1")
           wh-tb-multi-estabel = getWidgetHandleSub("tb-multi-estabel", wh-fPage1).

    IF  VALID-HANDLE(wh-tb-multi-estabel) 
    AND VALID-HANDLE(wh-fpage1) THEN DO:

        CREATE TOGGLE-BOX wh-cons-lote-venc
        ASSIGN FRAME      = wh-tb-multi-estabel:FRAME
               ROW        = wh-tb-multi-estabel:ROW + 1
               COL        = wh-tb-multi-estabel:COL
               WIDTH      = wh-tb-multi-estabel:WIDTH
               HEIGHT     = wh-tb-multi-estabel:HEIGHT
               FONT       = wh-tb-multi-estabel:FONT
               BGCOLOR    = ?
               HIDDEN     = NO
               SENSITIVE  = NO
               LABEL      = "Considera Lote Vencido".
    END.

    IF  VALID-HANDLE(wh-cons-lote-venc) THEN DO:

        FIND FIRST pl-prod NO-LOCK
            WHERE  ROWID(pl-prod) = p-row-table NO-ERROR.
        IF AVAIL pl-prod THEN DO:
            
            FIND FIRST es-pl-prod EXCLUSIVE-LOCK
                WHERE  es-pl-prod.cd-plano = pl-prod.cd-plano NO-ERROR.
            IF AVAIL es-pl-prod THEN
                ASSIGN wh-cons-lote-venc:SCREEN-VALUE = STRING(es-pl-prod.cons-lote-venc).
            ELSE 
                ASSIGN wh-cons-lote-venc:SCREEN-VALUE = "no".
        END.
    END.

END.
    
IF p-ind-event  = "BEFORE-UPDATE" 
AND p-ind-object = "CONTAINER" THEN DO:

    IF  VALID-HANDLE(wh-cons-lote-venc) THEN
        ASSIGN wh-cons-lote-venc:SENSITIVE  = YES.           

END.

IF p-ind-event  = "AFTER-DISPLAY" 
AND p-ind-object = "CONTAINER" THEN DO:

    IF  VALID-HANDLE(wh-cons-lote-venc) THEN DO:

        FIND FIRST pl-prod NO-LOCK
            WHERE  ROWID(pl-prod) = p-row-table NO-ERROR.
        IF AVAIL pl-prod THEN DO:
            
            FIND FIRST es-pl-prod EXCLUSIVE-LOCK
                WHERE  es-pl-prod.cd-plano = pl-prod.cd-plano NO-ERROR.
            IF AVAIL es-pl-prod THEN
                ASSIGN wh-cons-lote-venc:SCREEN-VALUE = STRING(es-pl-prod.cons-lote-venc).
            ELSE 
                ASSIGN wh-cons-lote-venc:SCREEN-VALUE = "no".
        END.
    END.
END.

IF p-ind-event  = "BEFORE-CANCEL" 
AND p-ind-object = "CONTAINER" THEN DO:

    IF  VALID-HANDLE(wh-cons-lote-venc) THEN
        ASSIGN wh-cons-lote-venc:SENSITIVE  = NO.           

END.

IF p-ind-event  = "AFTER-ASSIGN" 
AND p-ind-object = "CONTAINER" THEN DO:

    IF  VALID-HANDLE(wh-cons-lote-venc) THEN DO:

        FIND FIRST pl-prod NO-LOCK
            WHERE  ROWID(pl-prod) = p-row-table NO-ERROR.
        IF AVAIL pl-prod THEN DO:
            
            FIND FIRST es-pl-prod EXCLUSIVE-LOCK
                WHERE  es-pl-prod.cd-plano = pl-prod.cd-plano NO-ERROR.
            IF AVAIL es-pl-prod THEN
                ASSIGN es-pl-prod.cons-lote-venc = LOGICAL(wh-cons-lote-venc:SCREEN-VALUE).
            ELSE DO:
                CREATE es-pl-prod.
                ASSIGN es-pl-prod.cd-plano       = pl-prod.cd-plano.
                       es-pl-prod.cons-lote-venc = LOGICAL(wh-cons-lote-venc:SCREEN-VALUE).
            END.
    
            ASSIGN wh-cons-lote-venc:SENSITIVE  = NO.           
        END.
    END.
END.

PROCEDURE busca-handle:
    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF NOT valid-handle(h-aux) AND NOT VALID-HANDLE(h-prox) THEN DO:
            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.

/***** Fun‡Æo para buscar os objetos na frame fPage-0 ********/
FUNCTION getWidgetHandle RETURNS WIDGET-HANDLE
    (INPUT c-widget AS CHAR).

    DEF VAR wh-widget-handle AS WIDGET-HANDLE NO-UNDO.
    
    ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD
           wh-frame = wh-frame:FIRST-CHILD.

    DO WHILE wh-frame <> ?:

        IF wh-frame:NAME = c-widget THEN DO:
            ASSIGN wh-widget-handle = wh-frame:HANDLE.
            LEAVE.
        END.
        ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
    END.

    RETURN wh-widget-handle.

END FUNCTION.
/*************************************************/

/***** Fun‡Æo para buscar os objetos nas frames (quando tem mais de uma frame na tela) ********/
FUNCTION getWidgetHandleSub RETURNS WIDGET-HANDLE
    (INPUT c-widget     AS CHAR,
     INPUT p-wgh-frame  AS HANDLE).
    
    DEF VAR wh-widget-handle AS WIDGET-HANDLE NO-UNDO.
    
    ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD
           wh-frame = wh-frame:FIRST-CHILD.

    DO WHILE wh-frame <> ?:
        IF wh-frame:NAME = c-widget THEN DO:
            ASSIGN wh-widget-handle = wh-frame:HANDLE.
            LEAVE.
        END.
        ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
    END.

    RETURN wh-widget-handle.

END FUNCTION.
/*************************************************/

