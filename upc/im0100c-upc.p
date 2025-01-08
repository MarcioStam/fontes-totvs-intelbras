def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
 
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo AS WIDGET-HANDLE   NO-UNDO.
DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-class-fiscal AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-seq-adicao   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-adicao       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-seq-adicao-buff   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-adicao-buff       AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-adicao       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-adicao   AS INTEGER     NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-browse-im0100c    AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-query-im0100c     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-buffer-im0100c    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btConfirm-im0100c AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-im0100c        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-sugere-im0100c    AS WIDGET-HANDLE NO-UNDO.


DEFINE TEMP-TABLE tt-classif-count NO-UNDO
    FIELD class-fiscal AS CHAR
    FIELD adicao       AS INT
    FIELD seq-adicao   AS INT.

DEFINE BUFFER b-tt-classif-count FOR tt-classif-count.

 
assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.*/

/****************************  Variaveis    ****************************/

CASE p-ind-event:
    WHEN "AFTER-DESTROY-INTERFACE" THEN DO:
        DELETE PROCEDURE h-upc-im0100c.
        
    END.
    WHEN "AFTER-INITIALIZE" THEN DO:
        IF NOT VALID-HANDLE (h-upc-im0100c) THEN
            RUN upc/im0100c-upc.p PERSISTENT SET h-upc-im0100c (INPUT "",
                                                                INPUT "",
                                                                INPUT p-wgh-object,
                                                                INPUT p-wgh-frame,
                                                                INPUT "",
                                                                INPUT p-row-table).
        
        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "btConfirm",
                         OUTPUT wh-btConfirm-im0100c).

        CREATE BUTTON wh-sugere-im0100c
        ASSIGN FRAME       = wh-btConfirm-im0100c:FRAME
               WIDTH       = wh-btConfirm-im0100c:WIDTH
               HEIGHT      = wh-btConfirm-im0100c:HEIGHT
               LABEL       = wh-btConfirm-im0100c:LABEL
               ROW         = wh-btConfirm-im0100c:ROW
               COL         = wh-btConfirm-im0100c:COL + 30
               FLAT-BUTTON = wh-btConfirm-im0100c:FLAT-BUTTON
               TOOLTIP     = "Preencher Adicoes"
               VISIBLE     = YES
               SENSITIVE   = YES.
        ON "CHOOSE" OF wh-sugere-im0100c PERSISTENT RUN pi-sugere IN h-upc-im0100c.

        wh-sugere-im0100c:LOAD-IMAGE ( 'image/im-brows.bmp' ).

        ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.
        
        DO WHILE VALID-HANDLE(wgh-grupo) :
           CASE wgh-grupo:TYPE:
                 WHEN "browse" THEN DO:
    
                     ASSIGN wh-browse-im0100c = wgh-grupo:HANDLE
                            wh-query-im0100c  = wh-browse-im0100c:QUERY
                            wh-buffer-im0100c = wh-query-im0100c:GET-BUFFER-HANDLE(1).
                     LEAVE.
                 END.   
           END CASE.
                           
           IF  wgh-grupo:TYPE = "field-group" THEN
               ASSIGN wgh-grupo = wgh-grupo:FIRST-CHILD.
           ELSE
               ASSIGN wgh-grupo = wgh-grupo:NEXT-SIBLING. 
        END.
    END.
END CASE.

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
        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

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

PROCEDURE pi-sugere:
    EMPTY TEMP-TABLE tt-classif-count.
    
    /*wh-browse-im0100c:Select-row(1). */
    ASSIGN i-adicao = 1.

    wh-query-im0100c:query-prepare('for each tt-ordens-desemb BREAK BY tt-ordens-desemb.c-class-fiscal').
    wh-query-im0100c:query-open().

    do while not wh-query-im0100c:query-off-end:
        ASSIGN h-class-fiscal = wh-buffer-im0100c:BUFFER-FIELD("c-class-fiscal")
               h-seq-adicao   = wh-browse-im0100c:GET-BROWSE-COLUMN(wh-browse-im0100c:NUM-COLUMNS)
               h-adicao       = wh-browse-im0100c:GET-BROWSE-COLUMN(wh-browse-im0100c:NUM-COLUMNS - 1)
               h-adicao-buff  = wh-buffer-im0100c:BUFFER-FIELD("cdn-adicao")
               h-seq-adicao-buff = wh-buffer-im0100c:BUFFER-FIELD("seq-item"). 

        FIND LAST tt-classif-count
            WHERE tt-classif-count.class-fiscal = h-class-fiscal:BUFFER-VALUE NO-ERROR.

        IF NOT AVAIL tt-classif-count THEN DO:
            CREATE tt-classif-count.
            ASSIGN tt-classif-count.class-fiscal = h-class-fiscal:BUFFER-VALUE
                   tt-classif-count.adicao       = i-adicao
                   tt-classif-count.seq-adicao   = 1.

            ASSIGN /*h-adicao:SCREEN-VALUE      = STRING(tt-classif-count.adicao)
                   h-seq-adicao:SCREEN-VALUE  = STRING(tt-classif-count.seq-adicao)*/
                   h-adicao-buff:BUFFER-VALUE      = STRING(tt-classif-count.adicao)     
                   h-seq-adicao-buff:BUFFER-VALUE = STRING(tt-classif-count.seq-adicao).

            ASSIGN i-adicao = i-adicao + 1.
        END.
        ELSE DO:
            CREATE b-tt-classif-count.
            ASSIGN b-tt-classif-count.class-fiscal = h-class-fiscal:BUFFER-VALUE
                   b-tt-classif-count.adicao       = tt-classif-count.adicao
                   b-tt-classif-count.seq-adicao   = tt-classif-count.seq-adicao + 1.

            ASSIGN /*h-adicao:SCREEN-VALUE      = STRING(b-tt-classif-count.adicao)
                   h-seq-adicao:SCREEN-VALUE  = STRING(b-tt-classif-count.seq-adicao)*/
                   h-adicao-buff:BUFFER-VALUE      = STRING(b-tt-classif-count.adicao)     
                   h-seq-adicao-buff:BUFFER-VALUE = STRING(b-tt-classif-count.seq-adicao).
        END.

        wh-query-im0100c:get-next().
        /*wh-browse-im0100c:Select-next-row().*/
    END.
    wh-query-im0100c:query-open().
END PROCEDURE.
 
return "ok".
