/***********************************************************************
**  Programa..: upc\cd0284-upc.p
**  Autor.....: Raphael Matei Paini
**  Data......: Novembro/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 
************************************************************************/
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE VARIABLE c-objeto   AS CHAR        NO-UNDO.
DEFINE VARIABLE h-frame    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-frame-br AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-estab-ini-esccp033       AS CHARACTER   NO-UNDO INITIAL "":U.
DEFINE NEW GLOBAL SHARED VARIABLE c-estab-fim-esccp033       AS CHARACTER   NO-UNDO.
/*DEFINE NEW GLOBAL SHARED VARIABLE gr-item-esccp033           AS ROWID       NO-UNDO.*/

DEFINE NEW GLOBAL SHARED VARIABLE gr-item           AS ROWID       NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-item-uni-estab AS ROWID       NO-UNDO.

DEFINE VARIABLE wh-cd-ref            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-c-descricao-refer AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-de-saldo-fat      AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-cd0284-upc AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-bt-mod    AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-txt-fornec    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fornec        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-res-for   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-res-for       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-per-fixo  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-per-fixo      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-dt-res    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-dt-res        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-lote-mult AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-lote-mult     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-lote-min  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-lote-min      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-politica  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-politica      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-sit       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-sit           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-neces     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-neces         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-sit-item  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-sit-item      AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-fi-quant-segur-cd0284     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fi-saldo-inic-cd0284      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fi-saldo-terc-cd0284      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-RECT-21-cd0284            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-un-cd0284                 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-browse AS HANDLE        NO-UNDO.

/*DEFINE VARIABLE wgh-grupo   AS WIDGET-HANDLE  NO-UNDO.*/
DEFINE VARIABLE h-tipo      AS HANDLE         NO-UNDO.
DEFINE VARIABLE h-num-ordem AS HANDLE         NO-UNDO.
DEFINE VARIABLE c-depos     AS CHARACTER      NO-UNDO.

{esp/imp/esimp000.i1} /*tt-emb*/

{upc/btb910za-upc.i}

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "/":U), p-wgh-object:FILE-NAME, "/":U).

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
  
/***********************************************************************************
DEFINE VARIABLE c-frame AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rowid AS CHARACTER   NO-UNDO.

FORM p-ind-event  FORMAT "x(30)":U LABEL "Evento":U      AT 01
     p-ind-object FORMAT "x(20)":U LABEL "Objeto":U      AT 32
     c-objeto     FORMAT "x(30)":U LABEL "Nome Objeto":U AT 53
     c-frame      FORMAT "x(15)":U LABEL "Frame":U       AT 84
     p-cod-table  FORMAT "x(32)":U LABEL "Tabela":U      AT 100
     c-rowid      FORMAT "x(15)":U LABEL "Rowid":U       AT 133
     SKIP(1)
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 148 FRAME f-relat-ponto-upc.

OUTPUT TO VALUE(REPLACE(SESSION:TEMP-DIRECTORY, "~\":U, "/":U) + "/ponto-upc-cd0284-2.txt":U) APPEND CONVERT TARGET "iso8859-1":U.
ASSIGN c-frame = p-wgh-frame:NAME
       c-rowid = STRING(p-row-table).

DISPLAY p-ind-event
        p-ind-object
        c-objeto
        c-frame
        p-cod-table
        c-rowid
    WITH FRAME f-relat-ponto-upc.
DOWN WITH FRAME f-relat-ponto-upc.
OUTPUT CLOSE.
***********************************************************************************/

/** Dessa forma por limitacoes do template padrao. **/
ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
       h-frame = h-frame:FIRST-CHILD.

DO WHILE VALID-HANDLE(h-frame):
    IF h-frame:TYPE <> "field-group":U THEN DO:
        CASE h-frame:NAME:
            WHEN "cb-ref":U          THEN ASSIGN wh-cd-ref            = h-frame.
            WHEN "c-descricao-refer" THEN ASSIGN wh-c-descricao-refer = h-frame.
            WHEN "de-saldo-fat":U    THEN ASSIGN wh-de-saldo-fat      = h-frame.
        END CASE.

        ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
    END.
    ELSE LEAVE.
END.

IF VALID-HANDLE(wh-cd-ref) THEN
    ASSIGN wh-cd-ref:VISIBLE                        = NO
           wh-cd-ref:LABEL                          = "":U
           wh-cd-ref:SIDE-LABEL-HANDLE:SCREEN-VALUE = "":U
           wh-cd-ref:WIDTH                          = 0.05
           wh-cd-ref                                = ?.

IF VALID-HANDLE(wh-c-descricao-refer) THEN
    ASSIGN wh-c-descricao-refer:VISIBLE = NO
           wh-c-descricao-refer:WIDTH   = 0.05
           wh-c-descricao-refer         = ?.

IF VALID-HANDLE(wh-de-saldo-fat) THEN
    ASSIGN wh-de-saldo-fat:VISIBLE                        = NO
           wh-de-saldo-fat:LABEL                          = "":U
           wh-de-saldo-fat:SIDE-LABEL-HANDLE:SCREEN-VALUE = "":U
           wh-de-saldo-fat:SIDE-LABEL-HANDLE:VISIBLE      = NO
           wh-de-saldo-fat:SIDE-LABEL-HANDLE:COLUMN       = 13
           wh-de-saldo-fat:SIDE-LABEL-HANDLE:ROW          = 5.75
           wh-de-saldo-fat:WIDTH                          = 0.05
           wh-de-saldo-fat                                = ?.
                                                             
IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U         THEN DO:

    RUN upc/cd0284-upc.p PERSISTENT SET h-cd0284-upc (INPUT "":U,
                                                      INPUT "":U,
                                                      INPUT p-wgh-object,
                                                      INPUT p-wgh-frame,
                                                      INPUT "",
                                                      INPUT p-row-table).

    CREATE BUTTON wh-bt-mod
    ASSIGN NAME       = "wh-bt-mod":U
           FRAME      = p-wgh-frame
           WIDTH      = 4
           HEIGHT     = 1.18
           COLUMN     = 42
           ROW        = 1.35
           SENSITIVE  = YES
           VISIBLE    = YES
           TOOLTIP    = "CD1112":U
        TRIGGERS:
            ON "CHOOSE":U PERSISTENT RUN pi-choose-bt IN h-cd0284-upc.
        END TRIGGERS.

    wh-bt-mod:LOAD-IMAGE("image/im-mod.bmp":U).

    ASSIGN h-cd0284-upc = ?
           wh-bt-mod    = ?.
END.

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "VIEWER":U            THEN DO:

    CREATE TEXT wh-txt-fornec
    ASSIGN NAME         = "wh-txt-fornec":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(11)":U
           WIDTH        = 10
           COLUMN       = 3.60
           ROW          = 2.38
           SCREEN-VALUE = "Fornecedor:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-fornec
    ASSIGN NAME              = "wh-fornec":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "CHARACTER":U
           FORMAT            = "x(256)":U
           WIDTH             = 14
           HEIGHT            = 0.88
           COLUMN            = wh-txt-fornec:COLUMN + 8.40
           ROW               = 2.25
           SIDE-LABEL-HANDLE = wh-txt-fornec
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-res-for
    ASSIGN NAME         = "wh-txt-res-for":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(15)":U
           WIDTH        = 20
           COLUMN       = 27
           ROW          = 2.35
           SCREEN-VALUE = "Ressupr Fornec:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-res-for
    ASSIGN NAME              = "wh-res-for":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "INTEGER":U
           FORMAT            = ">>>9":U
           WIDTH             = 5
           HEIGHT            = 0.88
           COLUMN            = wh-txt-res-for:COLUMN + 12
           ROW               = 2.25
           SIDE-LABEL-HANDLE = wh-txt-res-for
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-per-fixo
    ASSIGN NAME         = "wh-txt-per-fixo":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(13)":U
           WIDTH        = 20
           COLUMN       = 47
           ROW          = 2.35
           SCREEN-VALUE = "Per°odo Fixo:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-per-fixo
    ASSIGN NAME              = "wh-per-fixo":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "INTEGER":U
           FORMAT            = ">>9":U
           WIDTH             = 5
           HEIGHT            = 0.88
           COLUMN            = wh-txt-per-fixo:COLUMN + 10
           ROW               = 2.25
           SIDE-LABEL-HANDLE = wh-txt-per-fixo
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-dt-res
    ASSIGN NAME         = "wh-txt-dt-res":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(11)":U
           WIDTH        = 10
           COLUMN       = 64
           ROW          = 2.35
           SCREEN-VALUE = "Dt. Ressup:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-dt-res
    ASSIGN NAME              = "wh-dt-res":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "DATE":U
           FORMAT            = "99/99/9999":U
           WIDTH             = 10
           HEIGHT            = 0.88
           COLUMN            = wh-txt-dt-res:COLUMN + 9
           ROW               = 2.25
           SIDE-LABEL-HANDLE = wh-txt-dt-res
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-lote-mult
    ASSIGN NAME         = "wh-txt-lote-mult":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(14)":U
           WIDTH        = 13
           COLUMN       = 63
           ROW          = 4.9
           SCREEN-VALUE = "Lote M£ltiplo:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-lote-mult
    ASSIGN NAME              = "wh-lote-mult":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "INTEGER":U
           FORMAT            = ">>>>,>>9.9999":U
           WIDTH             = 14
           HEIGHT            = 0.88
           COLUMN            = wh-txt-lote-mult:COLUMN + 9
           ROW               = 4.75
           SIDE-LABEL-HANDLE = wh-txt-lote-mult
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-lote-min
    ASSIGN NAME         = "wh-txt-lote-min":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(12)":U
           WIDTH        = 13
           COLUMN       = 63
           ROW          = 5.9
           SCREEN-VALUE = "Lote M°nimo:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-lote-min
    ASSIGN NAME              = "wh-lote-min":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "INTEGER":U
           FORMAT            = ">>>>,>>9.9999":U
           WIDTH             = 14
           HEIGHT            = 0.88
           COLUMN            = wh-txt-lote-min:COLUMN + 9
           ROW               = 5.75
           SIDE-LABEL-HANDLE = wh-txt-lote-min
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-politica
    ASSIGN NAME         = "wh-txt-politica":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(14)":U
           WIDTH        = 13
           COLUMN       = 4.5
           ROW          = 5.90
           SCREEN-VALUE = "Qtd. Pol°tica:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-politica
    ASSIGN NAME              = "wh-politica":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "DECIMAL":U
           FORMAT            = "->>>,>>>,>>9.99":U
           WIDTH             = 14
           HEIGHT            = 0.88
           COLUMN            = wh-txt-politica:COLUMN + 9.5
           ROW               = 5.75
           SIDE-LABEL-HANDLE = wh-txt-politica
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-sit-item
    ASSIGN NAME         = "wh-txt-sit-item":U
           FRAME        = p-wgh-frame
           FORMAT       = "x(14)":U
           WIDTH        = 20
           COLUMN       = 39
           ROW          = 3.90
           SCREEN-VALUE = "Sit Item:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-sit-item
    ASSIGN NAME              = "wh-sit-item":U
           FRAME             = p-wgh-frame
           DATA-TYPE         = "CHARACTER":U
           FORMAT            = "x(30)":U
           WIDTH             = 25
           HEIGHT            = 0.88
           COLUMN            = 45
           ROW               = 3.75
           SIDE-LABEL-HANDLE = wh-txt-sit-item
           VISIBLE           = YES
           SENSITIVE         = NO.

   ASSIGN wh-txt-fornec    = ?
           wh-fornec        = ?
           wh-txt-res-for   = ?
           wh-res-for       = ?
           wh-txt-per-fixo  = ?
           wh-per-fixo      = ?
           wh-txt-dt-res    = ?
           wh-dt-res        = ?
           wh-txt-lote-mult = ?
           wh-lote-mult     = ?
           wh-txt-lote-min  = ?
           wh-lote-min      = ?
           wh-txt-politica  = ?
           wh-politica      = ?
           wh-txt-sit-item  = ?
           wh-sit-item      = ?.
END.

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "BROWSER":U           THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        CASE h-frame:TYPE:
            WHEN "browse":U THEN DO:
                ASSIGN h-frame-br = h-frame:FRAME.
                LEAVE.
            END.
        END CASE.

        IF h-frame:TYPE = "field-group":U THEN
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        ELSE
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
    END.

    CREATE TEXT wh-txt-sit
    ASSIGN NAME         = "wh-txt-sit":U
           FRAME        = h-frame-br
           FORMAT       = "x(2)":U
           WIDTH        = 2
           COLUMN       = 13
           ROW          = 8.28
           SCREEN-VALUE = "S:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-sit
    ASSIGN NAME              = "wh-sit":U
           FRAME             = h-frame-br
           DATA-TYPE         = "CHARACTER":U
           FORMAT            = "x(91)":U
           WIDTH             = 63
           HEIGHT            = 0.88
           COLUMN            = wh-txt-sit:COLUMN + 1.3
           ROW               = 8.18
           SIDE-LABEL-HANDLE = wh-txt-sit
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-neces
    ASSIGN NAME         = "wh-txt-neces":U
           FRAME        = h-frame-br
           FORMAT       = "x(4)":U
           WIDTH        = 4
           COLUMN       = 77.5
           ROW          = 8.28
           SCREEN-VALUE = "Nec:":U
           VISIBLE      = YES.

    CREATE FILL-IN wh-neces
    ASSIGN NAME              = "wh-neces":U
           FRAME             = h-frame-br
           DATA-TYPE         = "DATE":U
           FORMAT            = "99/99/99":U
           WIDTH             = 8
           HEIGHT            = 0.88
           COLUMN            = wh-txt-neces:COLUMN + 3.5
           ROW               = 8.18
           SIDE-LABEL-HANDLE = wh-txt-neces
           VISIBLE           = YES
           SENSITIVE         = NO.

    ASSIGN h-frame      = ?
           h-frame-br   = ?
           wh-txt-sit   = ?
           wh-sit       = ?
           wh-txt-neces = ?
           wh-neces     = ?.
END.

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "BROWSER":U    THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE = "browse":U THEN DO:
            ASSIGN wh-browse = h-frame:HANDLE.
            LEAVE.
        END.

        IF h-frame:TYPE = "field-group":U THEN
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        ELSE
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
    END.

    RUN upc/cd0284-upc.p PERSISTENT SET h-cd0284-upc (INPUT "":U,
                                                      INPUT "":U,
                                                      INPUT p-wgh-object,
                                                      INPUT p-wgh-frame,
                                                      INPUT "",
                                                      INPUT p-row-table).

    IF VALID-HANDLE(wh-browse) THEN
        ON "MOUSE-SELECT-CLICK":U OF wh-browse PERSISTENT RUN pi-value-changed-browse IN h-cd0284-upc.

    ASSIGN h-frame      = ?
           wh-browse    = ?
           h-cd0284-upc = ?.
END.

/***************************************************************/
if p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" and
   c-objeto = "v68in172.w" then do:
    
    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "f-main" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'un':U,
                             input NO,
                             output wh-un-cd0284).
    END.
    
    ASSIGN wh-un-cd0284:COLUMN = 14
           wh-un-cd0284:SIDE-LABEL-HANDLE:COLUMN = 4.5.

    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "f-main" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'fi-quant-segur':U,
                             input NO,
                             output wh-fi-quant-segur-cd0284).
    END.

    ASSIGN wh-fi-quant-segur-cd0284:COLUMN = 14
           wh-fi-quant-segur-cd0284:SIDE-LABEL-HANDLE:SCREEN-VALUE = "Qtd. Segur"
           wh-fi-quant-segur-cd0284:SIDE-LABEL-HANDLE:COLUMN = 5.5.

    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "f-main" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'fi-saldo-inic':U,
                             input NO,
                             output wh-fi-saldo-inic-cd0284).
    END.

    ASSIGN wh-fi-saldo-inic-cd0284:COLUMN = 45
           wh-fi-saldo-inic-cd0284:SIDE-LABEL-HANDLE:COLUMN = 36.

    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "f-main" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'fill-in':U,
                             input 'fi-saldo-terc':U,
                             input NO,
                             output wh-fi-saldo-terc-cd0284).
    END.

    ASSIGN wh-fi-saldo-terc-cd0284:COLUMN = 45
           wh-fi-saldo-terc-cd0284:SIDE-LABEL-HANDLE:COLUMN = 30.
    
    if p-wgh-frame:type = "frame" and p-wgh-frame:name = "f-main" then do:
        run pi-busca-handle (input p-wgh-frame,
                             input p-ind-event,
                             input 'rectangle':U,
                             input 'RECT-21':U,
                             input NO,
                             output wh-RECT-21-cd0284).
    END.

    wh-RECT-21-cd0284:VISIBLE = NO.
       
END.


    /**********************************************/


IF p-ind-event  = "DISPLAY":U AND
   p-ind-object = "VIEWER":U  THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
 
    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "wh-txt-fornec":U    THEN ASSIGN wh-txt-fornec    = h-frame.
                WHEN "wh-fornec"          THEN ASSIGN wh-fornec        = h-frame.
                WHEN "wh-txt-res-for":U   THEN ASSIGN wh-txt-res-for   = h-frame.
                WHEN "wh-res-for":U       THEN ASSIGN wh-res-for       = h-frame.
                WHEN "wh-txt-per-fixo":U  THEN ASSIGN wh-txt-per-fixo  = h-frame.
                WHEN "wh-per-fixo":U      THEN ASSIGN wh-per-fixo      = h-frame.
                WHEN "wh-txt-dt-res":U    THEN ASSIGN wh-txt-dt-res    = h-frame.
                WHEN "wh-dt-res":U        THEN ASSIGN wh-dt-res        = h-frame.
                WHEN "wh-txt-lote-mult":U THEN ASSIGN wh-txt-lote-mult = h-frame.
                WHEN "wh-lote-mult":U     THEN ASSIGN wh-lote-mult     = h-frame.
                WHEN "wh-txt-lote-min":U  THEN ASSIGN wh-txt-lote-min  = h-frame.
                WHEN "wh-lote-min":U      THEN ASSIGN wh-lote-min      = h-frame.
                WHEN "wh-txt-politica":U  THEN ASSIGN wh-txt-politica  = h-frame.
                WHEN "wh-politica":U      THEN ASSIGN wh-politica      = h-frame.
                WHEN "wh-txt-sit-item"    THEN ASSIGN wh-txt-sit-item  = h-frame.
                WHEN "wh-sit-item"        THEN ASSIGN wh-sit-item      = h-frame.
            END CASE.

            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN wh-txt-fornec:SCREEN-VALUE    = "Fornecedor:":U
           wh-fornec:SCREEN-VALUE        = "":U
           wh-txt-res-for:SCREEN-VALUE   = "Ressupr Fornec:":U
           wh-res-for:SCREEN-VALUE       = "":U
           wh-txt-per-fixo:SCREEN-VALUE  = "Per°odo Fixo:":U
           wh-per-fixo:SCREEN-VALUE      = "":U
           wh-txt-dt-res:SCREEN-VALUE    = "Dt. Ressup:":U
           wh-dt-res:SCREEN-VALUE        = "":U
           wh-txt-lote-mult:SCREEN-VALUE = "Lote M£ltiplo:":U
           wh-lote-mult:SCREEN-VALUE     = "":U
           wh-txt-lote-min:SCREEN-VALUE  = "Lote M°nimo:":U
           wh-lote-min:SCREEN-VALUE      = "":U
           wh-txt-politica:SCREEN-VALUE  = "Qtd. Pol°tica:":U
           wh-politica:SCREEN-VALUE      = "0,00":U
           wh-txt-sit-item:SCREEN-VALUE  = "Sit Item:":U
           wh-sit-item:SCREEN-VALUE      = "":U.

    FIND FIRST item
        WHERE ROWID(item) = p-row-table NO-LOCK NO-ERROR.

    IF AVAILABLE item THEN DO:
        FIND FIRST int-item-uni-estab
            WHERE int-item-uni-estab.it-codigo   = item.it-codigo
              AND int-item-uni-estab.cod-estabel = c-estab-ini-esccp033 NO-LOCK NO-ERROR.

        IF AVAILABLE int-item-uni-estab THEN
            ASSIGN wh-politica:SCREEN-VALUE = STRING(int-item-uni-estab.qtd-pol, "->>>,>>>,>>9.99":U).

        FIND FIRST item-fornec-estab
            WHERE item-fornec-estab.it-codigo   = item.it-codigo
              AND item-fornec-estab.cod-estabel = c-estab-ini-esccp033
              AND item-fornec-estab.ativo       = YES
              AND item-fornec-estab.perc-compra > 0 NO-LOCK NO-ERROR.

        IF AVAILABLE item-fornec-estab THEN DO:
            FIND FIRST emitente
                WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN
                ASSIGN wh-fornec:SCREEN-VALUE = emitente.nome-abrev.
        END.
        ELSE DO:
            FIND FIRST item-fornec
                WHERE item-fornec.it-codigo   = item.it-codigo
                  AND item-fornec.ativo       = YES
                  AND item-fornec.perc-compra > 0 NO-LOCK NO-ERROR.

            IF AVAILABLE item-fornec THEN DO:
                FIND FIRST emitente
                    WHERE emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
                    
                IF AVAILABLE emitente THEN
                    ASSIGN wh-fornec:SCREEN-VALUE = emitente.nome-abrev.
            END.
        END.
            
        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = c-estab-ini-esccp033 NO-LOCK NO-ERROR.
        
        IF AVAILABLE item-uni-estab THEN DO:
            ASSIGN wh-res-for:SCREEN-VALUE   = STRING(item-uni-estab.res-for-comp, ">>>9":U)
                   wh-per-fixo:SCREEN-VALUE  = STRING(item-uni-estab.periodo-fixo, ">>9":U)
                   wh-dt-res:SCREEN-VALUE    = STRING(TODAY + item-uni-estab.res-for-comp, "99/99/9999":U)
                   wh-lote-mult:SCREEN-VALUE = STRING(item-uni-estab.lote-multipl, ">>>>,>>9.9999":U)
                   wh-lote-min:SCREEN-VALUE  = STRING(item-uni-estab.lote-minimo, ">>>>,>>9.9999":U).

            IF c-estab-ini-esccp033 = c-estab-fim-esccp033 THEN DO:
                wh-sit-item:SCREEN-VALUE  = {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}.
                
                IF item-uni-estab.cod-obsoleto = 1 THEN
                    ASSIGN wh-sit-item:FGCOLOR = ?.
                ELSE
                    ASSIGN wh-sit-item:FGCOLOR = 12.
            END.
            ELSE
                wh-sit-item:SCREEN-VALUE = "".

            ASSIGN gr-item-uni-estab = ROWID(item-uni-estab).
        END.
        ELSE DO:
            FIND FIRST item-uni-estab NO-LOCK NO-ERROR.

            IF AVAILABLE item-uni-estab THEN
                ASSIGN gr-item-uni-estab = ROWID(item-uni-estab).
        END.
    END.

    ASSIGN wh-txt-fornec    = ?
           wh-fornec        = ?
           wh-txt-res-for   = ?
           wh-res-for       = ?
           wh-txt-per-fixo  = ?
           wh-per-fixo      = ?
           wh-txt-dt-res    = ?
           wh-dt-res        = ?
           wh-txt-lote-mult = ?
           wh-lote-mult     = ?
           wh-txt-lote-min  = ?
           wh-lote-min      = ?
           wh-txt-politica  = ?
           wh-politica      = ?
           wh-txt-sit-item  = ?
           wh-sit-item      = ?
           h-frame          = ?.
END.

IF p-ind-event  = "DISPLAY":U AND
   p-ind-object = "VIEWER":U  THEN DO:

    /* Limpar o campo "wh-sit", porÇm n∆o foi poss°vel alcaná†-lo por estar em um outro Smart Object */
END.

IF p-ind-event  = "VALUE-CHANGED":U AND
   p-ind-object = "BROWSER":U      THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE = "browse":U THEN DO:
            ASSIGN h-frame-br = h-frame:FRAME
                   wh-browse  = h-frame:HANDLE.
            LEAVE.
        END.

        IF h-frame:TYPE = "field-group":U THEN
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        ELSE
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
    END.

    ASSIGN h-frame = h-frame-br:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            IF h-frame:NAME = "wh-sit" THEN DO:
                ASSIGN wh-sit = h-frame.
/*                 LEAVE. */
            END.
            IF h-frame:NAME = "wh-neces" THEN DO:
                ASSIGN wh-neces = h-frame.
/*                 LEAVE. */
            END.

            if  valid-handle(wh-sit)
            and valid-handle(wh-neces)
            then leave.

            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-browse) THEN
        ASSIGN h-tipo = wh-browse:GET-BROWSE-COLUMN(1)
               h-num-ordem = wh-browse:GET-BROWSE-COLUMN(2).

    IF VALID-HANDLE(h-tipo)      AND
       VALID-HANDLE(h-num-ordem) AND
       VALID-HANDLE(wh-sit)      and
       valid-handle(wh-neces) THEN DO:
        ASSIGN wh-neces:screen-value = "":U.

        IF h-tipo:SCREEN-VALUE = "O C":U THEN DO:
            FOR FIRST item NO-LOCK
                WHERE ROWID(item) = gr-item,
                EACH prazo-compra NO-LOCK
                WHERE prazo-compra.it-codigo    = item.it-codigo
                  AND prazo-compra.numero-ordem = INTEGER(ENTRY(1, h-num-ordem:SCREEN-VALUE, "/":U))
                  AND prazo-compra.parcela      = INTEGER(ENTRY(2, h-num-ordem:SCREEN-VALUE, "/":U))
                  AND prazo-compra.situacao     = 2
                  AND prazo-compra.quant-saldo  > 0,
                EACH ordem-compra NO-LOCK
                WHERE ordem-compra.cod-estabel  = c-estab-ini-esccp033
                  AND ordem-compra.numero-ordem = prazo-compra.numero-ordem,
                EACH emitente NO-LOCK
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                BY prazo-compra.data-entrega:

                ASSIGN wh-sit:SCREEN-VALUE = "Ped":U                                            + "-":U   +
                                             STRING(ordem-compra.num-pedido)                    + "-":U   +
                                             SUBSTRING(STRING(prazo-compra.numero-ordem), 1, 6) + "-":U   +
                                             STRING(prazo-compra.parcela)                       + " - ":U +
                                             STRING(prazo-compra.data-entrega, "99/99/99":U)    + " - ":U +
                                             emitente.nome-abrev                                + "-":U   +
                                             SUBSTRING(ordem-compra.narrativa, 1, 7)
                       wh-neces:screen-value = "":U.

                for first int-prazo-compra no-lock
                    where int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                      and int-prazo-compra.parcela      = prazo-compra.parcela:
                    assign wh-neces:screen-value = string(int-prazo-compra.data-necessidade,"99/99/99").
                end. /* for first int-prazo-compra */

                FOR EACH ordens-embarque NO-LOCK
                    WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                      AND ordens-embarque.parcela      = prazo-compra.parcela:
                    RUN pi-busca-posicao.

                    FIND FIRST tt-emb NO-ERROR.

                    IF NOT AVAILABLE tt-emb THEN NEXT.

                    CASE tt-emb.situacao:
                        WHEN 1  THEN ASSIGN c-depos = "Prev":U.
                        WHEN 99 THEN ASSIGN c-depos = "Agt":U.
                        WHEN 2  THEN ASSIGN c-depos = "Embar":U.
                        WHEN 3  THEN ASSIGN c-depos = "Desp":U.
                        WHEN 4  THEN ASSIGN c-depos = "NF":U.
                        WHEN 96  THEN ASSIGN c-depos = "Inst".
                        WHEN 97  THEN ASSIGN c-depos = "Manut".
                    END CASE.

                    IF ordens-embarque.embarque <> tt-emb.conhecimento THEN
                        ASSIGN tt-emb.conhecimento = tt-emb.conhecimento + "-":U + ordens-embarque.embarque.

                    ASSIGN wh-sit:SCREEN-VALUE = c-depos                                            + "-":U +
                                                 STRING(ordem-compra.num-pedido)                    + "-":U +
                                                 SUBSTRING(STRING(prazo-compra.numero-ordem), 1, 6) + "-":U +
                                                 STRING(prazo-compra.parcela)                       + "-":U +
                                                 emitente.nome-abrev                                + "-":U +
                                                 tt-emb.conhecimento                                + "-":U +
                                                 STRING(tt-emb.dt-embarque, "99/99/99":U)           + "-":U +
                                                 STRING(prazo-compra.data-entrega, "99/99/99":U).
                END.
            END.
        END.
        ELSE ASSIGN wh-sit:screen-value = "":U.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:

    IF VALID-HANDLE(wh-cd-ref) THEN
        ASSIGN wh-cd-ref = ?.

    IF VALID-HANDLE(wh-c-descricao-refer) THEN
        ASSIGN wh-c-descricao-refer = ?.

    IF VALID-HANDLE(wh-de-saldo-fat) THEN
        ASSIGN wh-de-saldo-fat = ?.

    IF VALID-HANDLE(wh-bt-mod) THEN
        DELETE WIDGET wh-bt-mod.

    IF VALID-HANDLE(wh-txt-fornec) THEN
        DELETE WIDGET wh-txt-fornec.

    IF VALID-HANDLE(wh-fornec) THEN
        DELETE WIDGET wh-fornec.

    IF VALID-HANDLE(wh-txt-res-for) THEN
        DELETE WIDGET wh-txt-res-for.

    IF VALID-HANDLE(wh-res-for) THEN
        DELETE WIDGET wh-res-for.

    IF VALID-HANDLE(wh-txt-per-fixo) THEN
        DELETE WIDGET wh-txt-per-fixo.

    IF VALID-HANDLE(wh-per-fixo) THEN
        DELETE WIDGET wh-per-fixo.

    IF VALID-HANDLE(wh-txt-dt-res) THEN
        DELETE WIDGET wh-txt-dt-res.

    IF VALID-HANDLE(wh-dt-res) THEN
        DELETE WIDGET wh-dt-res.

    IF VALID-HANDLE(wh-txt-lote-mult) THEN
        DELETE WIDGET wh-txt-lote-mult.

    IF VALID-HANDLE(wh-lote-mult) THEN
        DELETE WIDGET wh-lote-mult.

    IF VALID-HANDLE(wh-txt-lote-min) THEN
        DELETE WIDGET wh-txt-lote-min.

    IF VALID-HANDLE(wh-lote-min) THEN
        DELETE WIDGET wh-lote-min.

    IF VALID-HANDLE(wh-txt-politica) THEN
        DELETE WIDGET wh-txt-politica.

    IF VALID-HANDLE(wh-politica) THEN
        DELETE WIDGET wh-politica.

    IF VALID-HANDLE(wh-txt-sit) THEN
        DELETE WIDGET wh-txt-sit.

    IF VALID-HANDLE(wh-sit) THEN
        DELETE WIDGET wh-sit.

    IF VALID-HANDLE(wh-txt-neces) THEN
        DELETE WIDGET wh-txt-neces.

    IF VALID-HANDLE(wh-neces) THEN
        DELETE WIDGET wh-neces.

    IF VALID-HANDLE (wh-txt-sit-item) THEN
        DELETE WIDGET wh-txt-sit-item.

    IF VALID-HANDLE (wh-sit-item) THEN
        DELETE WIDGET wh-sit-item.

    ASSIGN wh-bt-mod        = ?
           wh-txt-fornec    = ?
           wh-fornec        = ?
           wh-txt-res-for   = ?
           wh-res-for       = ?
           wh-txt-per-fixo  = ?
           wh-per-fixo      = ?
           wh-txt-dt-res    = ?
           wh-dt-res        = ?
           wh-txt-lote-mult = ?
           wh-lote-mult     = ?
           wh-txt-lote-min  = ?
           wh-lote-min      = ?
           wh-txt-politica  = ?
           wh-politica      = ?
           wh-txt-sit       = ?
           wh-sit           = ?
           wh-txt-neces     = ?
           wh-neces         = ?
           wh-txt-sit-item  = ?
           wh-sit-item      = ?.
END.
           
PROCEDURE pi-choose-bt :
    RUN cdp/cd1112.w.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-value-changed-browse :
    IF VALID-HANDLE(wh-browse) THEN
        APPLY "VALUE-CHANGED":U TO wh-browse.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-busca-posicao :
    
    FOR EACH embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1
          AND embarque-imp.cod-estabel = c-estab-ini-esccp033
          AND embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}
    END.
END PROCEDURE.

PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-obj):
        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto " wgh-obj:NAME SKIP
                    "Type do Objeto " wgh-obj:TYPE skip
                    "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF wgh-obj:TYPE = pObjType AND 
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.

