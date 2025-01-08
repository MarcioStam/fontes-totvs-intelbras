/***********************************************************************************
** SCM CONCEPT Tecnologia da Informacao
** 
** Programa: CE0830-UPC - UPC no CE0830 - Inclusao de botao para Bloqueados.
** Data    : 21 de Junho de 2016
** Autor   : Luciano Mahl
**
***********************************************************************************/
{include/i-prgvrs.i CE0830-UPC 2.00.00.000}  /*** 010000 ***/
/**********************************************************************************/
/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-ind-object                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-wh-objeto                          AS HANDLE            NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                          AS WIDGET-HANDLE     NO-UNDO.
DEFINE INPUT PARAM p-cod-table                          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-row-table                          AS ROWID             NO-UNDO.

/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-bloqueado-ce0830   AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-browse-ce0830      AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-query-ce0830      AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-buffer-ce0830      AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDetalhar-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-ce0830   AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-ce0830 AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-valid-lote-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-1-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-2-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-3-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-4-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-5-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-6-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-7-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-8-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-9-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-10-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-11-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-12-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-13-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-14-ce0830  AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-dep-ce0830     AS WIDGET-HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-ce0830-upc          AS WIDGET-HANDLE      NO-UNDO.
DEF VAR hFile           AS HANDLE NO-UNDO.
DEF VAR hField          AS HANDLE NO-UNDO.
DEFINE VARIABLE vdt-venc AS DATE   NO-UNDO.

/************************** Definicao de Variaveis Locais *************************/
DEFINE VARIABLE wh-objeto   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-frame-br AS WIDGET-HANDLE NO-UNDO.

IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "CONTAINER"  THEN DO:

    CREATE BUTTON wh-bloqueado-ce0830
    ASSIGN LABEL            = "Bloq"
           FRAME            = p-wgh-frame
           WIDTH            = 4.50
           HEIGHT           = 1.00
           ROW              = 14.35
           COL              = 15.80
           VISIBLE          = YES
           SENSITIVE        = YES
           CONVERT-3D-COLOR = YES
           FONT             = 4
           TOOLTIP          = "Saldo Bloqueado"
           HELP             = "Saldo Bloqueado"
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN upc/ce0830a-upc.p.
    END TRIGGERS.  
    wh-bloqueado-ce0830:MOVE-TO-TOP().
END.

IF p-ind-event  = "DISPLAY" AND
   p-ind-object = "VIEWER"  THEN DO:

    ASSIGN wh-objeto   = p-wgh-frame:FIRST-CHILD
           wh-frame-br = wh-objeto:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wh-frame-br):
        CASE wh-frame-br:NAME:
            WHEN "it-codigo" THEN ASSIGN wh-it-codigo-ce0830 = wh-frame-br:HANDLE.
        END CASE.        
        IF wh-frame-br:TYPE = "field-group" THEN
            ASSIGN wh-frame-br = wh-frame-br:FIRST-CHILD.
        ELSE
            ASSIGN wh-frame-br = wh-frame-br:NEXT-SIBLING.
    END.
END.

IF  p-ind-object = "BROWSER" 
AND p-ind-event  = "BEFORE-INITIALIZE" THEN DO:

    IF NOT VALID-HANDLE(h-ce0830-upc) THEN
        RUN upc/ce0830-upc.p PERSISTENT SET h-ce0830-upc (INPUT "",            
                                                          INPUT "",            
                                                          INPUT p-wh-objeto,  
                                                          INPUT p-wgh-frame,   
                                                          INPUT "",            
                                                          INPUT p-row-table).

    ASSIGN wh-objeto   = p-wgh-frame:FIRST-CHILD
           wh-frame-br = wh-objeto:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wh-frame-br):
        CASE wh-frame-br:NAME:
            WHEN "br-table"   THEN ASSIGN wh-browse-ce0830     = wh-frame-br:HANDLE.
        END CASE.

        IF wh-frame-br:TYPE = "field-group" THEN
            ASSIGN wh-frame-br = wh-frame-br:FIRST-CHILD.
        ELSE
            ASSIGN wh-frame-br = wh-frame-br:NEXT-SIBLING.
    END.

    IF VALID-HANDLE (wh-browse-ce0830) THEN DO:
        
        ASSIGN wh-query-ce0830 = wh-browse-ce0830:QUERY
               wh-buffer-ce0830 = wh-query-ce0830:GET-BUFFER-HANDLE(2).
        ASSIGN wh-1-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(1)
               wh-2-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(2)
               wh-3-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(3)
               wh-4-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(4)
               wh-5-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(5)
               wh-6-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(6)
               wh-7-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(7)
               wh-8-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(8)
               wh-9-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(9)
               wh-10-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(10)
               wh-11-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(11)
               wh-12-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(12)
               wh-13-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(13)
               wh-14-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(14)
               wh-valid-lote-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(6).
        ON ROW-DISPLAY OF wh-browse-ce0830 PERSISTENT RUN pi-row-display IN h-ce0830-upc.
    END.
    
END.

IF (p-ind-event  = "AFTER-OPEN-QUERY"     OR 
    p-ind-event  = 'AFTER-VALUE-CHANGED') AND
    p-ind-object = "BROWSER"              THEN DO:

    ASSIGN wh-objeto   = p-wgh-frame:FIRST-CHILD
           wh-frame-br = wh-objeto:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wh-frame-br):
        CASE wh-frame-br:NAME:
            WHEN "br-table"   THEN ASSIGN wh-browse-ce0830     = wh-frame-br:HANDLE.
            WHEN "btDetalhar" THEN ASSIGN wh-btDetalhar-ce0830 = wh-frame-br:HANDLE.
        END CASE.        
        IF wh-frame-br:TYPE = "field-group" THEN
            ASSIGN wh-frame-br = wh-frame-br:FIRST-CHILD.
        ELSE
            ASSIGN wh-frame-br = wh-frame-br:NEXT-SIBLING.
    END.
    IF  VALID-HANDLE(wh-browse-ce0830) THEN DO:
         ASSIGN wh-cod-estabel-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(1)
                wh-cod-dep-ce0830     = wh-browse-ce0830:GET-BROWSE-COLUMN(2).
         IF wh-cod-estabel-ce0830:NAME = "cod-depos" THEN
             ASSIGN wh-cod-estabel-ce0830 = wh-browse-ce0830:GET-BROWSE-COLUMN(2)
                    wh-cod-dep-ce0830     = wh-browse-ce0830:GET-BROWSE-COLUMN(1).
         IF VALID-HANDLE(wh-bloqueado-ce0830) THEN
             wh-bloqueado-ce0830:MOVE-TO-TOP().
    END.
END.

IF p-ind-event = "destroy" THEN DO:
    DELETE PROCEDURE h-ce0830-upc.
    ASSIGN h-ce0830-upc = ?.
END.

IF p-ind-event  = "DESTROY"   AND 
   p-ind-object = "CONTAINER" THEN DO:
    IF VALID-HANDLE(wh-bloqueado-ce0830) THEN 
        DELETE OBJECT wh-bloqueado-ce0830.
END.
/* Fim - ce0830-upc.p */
PROCEDURE pi-row-display:
    ASSIGN hField     = wh-buffer-ce0830:BUFFER-FIELD("dt-vali-lote")
           vdt-venc   = hField:BUFFER-VALUE.

    IF  vdt-venc <> ? 
    AND vdt-venc < TODAY THEN DO:
        wh-1-ce0830:FGCOLOR = 12.
        wh-2-ce0830:FGCOLOR = 12.
        wh-3-ce0830:FGCOLOR = 12.
        wh-4-ce0830:FGCOLOR = 12.
        wh-5-ce0830:FGCOLOR = 12.
        wh-6-ce0830:FGCOLOR = 12.
        wh-7-ce0830:FGCOLOR = 12.
        wh-8-ce0830:FGCOLOR = 12.
        wh-9-ce0830:FGCOLOR = 12.
        wh-10-ce0830:FGCOLOR = 12.
        wh-11-ce0830:FGCOLOR = 12.
        wh-12-ce0830:FGCOLOR = 12.
        wh-13-ce0830:FGCOLOR = 12.
        wh-14-ce0830:FGCOLOR = 12.
    END.
    
END.
