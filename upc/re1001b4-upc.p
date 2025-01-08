def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF NEW GLOBAL SHARED VAR wh-browse-re1001b4 AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-re1001b4     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-new-bt-calc-re1001b4 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-calc-re1001b4 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-tx-tot-mo-re1001b4  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tot-mo-re1001b4     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-sel-re1001b4 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-vl-tot               AS HANDLE NO-UNDO.

DEF VAR wh-page1-re1001b4      AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-page0-re1001b4      AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-linha           AS INT NO-UNDO.
DEF VAR h-vl-moeda        AS HANDLE NO-UNDO.
DEF VAR h-nr-ordem        AS HANDLE NO-UNDO.
DEF VAR h-vl-tot          AS HANDLE NO-UNDO.
DEF VAR achou             AS INT NO-UNDO.
DEF VAR de-fator          AS DECIMAL     NO-UNDO.

IF p-ind-event = "AFTER-DESTROY-INTERFACE" THEN
    DELETE PROCEDURE h-upc-re1001b4.

IF p-ind-event = "before-initialize":U  THEN DO:  

    IF NOT VALID-HANDLE (h-upc-re1001b4) THEN
        RUN upc/re1001b4-upc.p PERSISTENT SET h-upc-re1001b4 (INPUT "",
                                                              INPUT "",
                                                              INPUT p-wgh-object,
                                                              INPUT p-wgh-frame,
                                                              INPUT "",
                                                              INPUT p-row-table).

    ASSIGN wh-page0-re1001b4 = p-wgh-frame.

    RUN pi-busca-handle (INPUT p-wgh-frame,
                         INPUT p-ind-event,
                         INPUT 'Frame':U,
                         INPUT 'fpage1':U,
                         INPUT NO,
                         OUTPUT wh-page1-re1001b4).

    RUN pi-busca-handle (INPUT wh-page1-re1001b4,
                         INPUT p-ind-event,
                         INPUT 'text':U,
                         INPUT 'de-tot-sel':U,
                         INPUT NO,
                         OUTPUT wh-de-tot-sel-re1001b4).

    IF VALID-HANDLE(wh-page1-re1001b4) THEN DO:
        CREATE TEXT wh-tx-tot-mo-re1001b4 
        ASSIGN NAME         = 'wh-tx-tot-mo-re1001b4':U
               ROW          = 11
               COLUMN       = 41
               DATA-TYPE    = "character"
               FORMAT       = "x(19)"
               FRAME        = wh-page1-re1001b4
               VISIBLE      = YES
               SCREEN-VALUE = "Tot. Moeda Cota‡Æo:".
    
        CREATE TEXT wh-tot-mo-re1001b4 
        ASSIGN NAME       = 'wh-tot-mo-re1001b4'
               FRAME      = wh-tx-tot-mo-re1001b4:FRAME
               ROW        = wh-tx-tot-mo-re1001b4:ROW - 0.12
               COLUMN     = wh-tx-tot-mo-re1001b4:COLUMN + 15
               HEIGHT     = 0.88
               WIDTH      = 12
               DATA-TYPE  = "decimal"
               FORMAT     = ">>>,>>>,>>9.99"
               TOOLTIP    = "Valor Moeda Cota‡Æo"
               HELP       = "Valor Moeda Cota‡Æo"
               VISIBLE    = TRUE.

        CREATE BUTTON wh-new-bt-calc-re1001b4
        ASSIGN FRAME       = wh-tx-tot-mo-re1001b4:FRAME
               WIDTH       = 7
               HEIGHT      = 1
               LABEL       = "Calcular"
               ROW         = wh-tot-mo-re1001b4:ROW
               COL         = wh-tot-mo-re1001b4:COL + 10
               VISIBLE     = YES
               SENSITIVE   = YES.
        ON "CHOOSE" OF wh-new-bt-calc-re1001b4 PERSISTENT RUN pi-bt-calc IN h-upc-re1001b4.
    
        RUN pi-busca-handle (INPUT wh-page1-re1001b4,
                             INPUT p-ind-event,
                             INPUT 'browse':U,
                             INPUT 'brSemContrato':U,
                             INPUT NO,
                             OUTPUT wh-browse-re1001b4).
    END.
END.

PROCEDURE pi-busca-handle:
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
            MESSAGE
                "Nome do Objeto " wgh-obj:NAME SKIP
                "Type do Objeto " wgh-obj:TYPE skip
                "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE    =   pObjType    AND 
            wgh-obj:NAME    =   pObjName    THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF  wgh-obj:TYPE = "field-group" THEN    
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.           
END PROCEDURE.

PROCEDURE pi-bt-calc:

    IF wh-browse-re1001b4:NUM-ITERATIONS > 0 THEN DO:

        blk_bloco:
        DO i-linha = 1 TO wh-browse-re1001b4:NUM-ITERATIONS:

            wh-browse-re1001b4:Select-row(i-linha).

            ASSIGN h-nr-ordem = wh-browse-re1001b4:GET-BROWSE-COLUMN(4).

            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = int(h-nr-ordem:SCREEN-VALUE) NO-ERROR.

            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

            IF AVAIL cotacao-item THEN 
                LEAVE blk_bloco.
        END.

        IF AVAIL cotacao-item THEN DO:
            IF  cotacao-item.mo-codigo = 0 THEN DO:
                ASSIGN de-fator = 1.
            END.
            ELSE DO:
                FIND FIRST cotacao NO-LOCK
                     WHERE cotacao.mo-codigo   = cotacao-item.mo-codigo
                       AND cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                       AND cotacao.cotacao[int(day(TODAY))] <> 0 NO-ERROR.

                IF  AVAIL cotacao THEN
                    ASSIGN de-fator = cotacao.cotacao[int(day(TODAY))].

            END.

            ASSIGN wh-tot-mo-re1001b4:SCREEN-VALUE = string(DEC(REPLACE(wh-de-tot-sel-re1001b4:SCREEN-VALUE,"R$","")) / de-fator).
        
        END.
    END.
END PROCEDURE.
