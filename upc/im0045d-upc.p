/***********************************************************************
**  Programa..: upc\im0045d-upc.p
**  Autor.....: Raphael
**  Data......: Fevereiro/2010
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-programa              AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window              AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-im0045d       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-brson1-im0045d       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDeleteSon1-im0045d AS WIDGET-HANDLE NO-UNDO.
/*DEFINE NEW GLOBAL SHARED VARIABLE wh-data-ent-im0045d AS WIDGET-HANDLE NO-UNDO.*/

DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-ci-im0045e    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ci-im0045e       AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE i-nr-pagamento   LIKE pagamento-invoice.nr-pagamento  NO-UNDO.
DEFINE VARIABLE de-valor-invoice LIKE pagamento-invoice.valor         NO-UNDO.

DEFINE VARIABLE h-coluna1            AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-query             AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-buffer            AS HANDLE      NO-UNDO.

DEFINE VARIABLE hColumnnr-embarque   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hColumnnr-nr-invoice AS HANDLE      NO-UNDO.
DEFINE VARIABLE hColumnnr-parcela    AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    CREATE TEXT wh-tx-ci-im0045e
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(4)"   
           WIDTH        = 4
           SCREEN-VALUE = "CI:"
           ROW          = 11.0
           COL          = 37.75
           VISIBLE      = YES.

    CREATE FILL-IN wh-ci-im0045e
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           FORMAT            = "x(40)" 
           WIDTH             = 40
           HEIGHT            = 0.88
           ROW               = 10.9
           COL               = 40
           VISIBLE           = YES
           SENSITIVE         = NO.

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-im0045d).

    IF VALID-HANDLE(wh-fpage1-im0045d) THEN DO:
        RUN tela-upc (INPUT wh-fpage1-im0045d,
                      INPUT p-ind-Event,
                      INPUT "browse",      /*** Type ***/
                      INPUT "brSon1",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-brson1-im0045d).

        RUN tela-upc (INPUT wh-fpage1-im0045d,
                      INPUT p-ind-Event,
                      INPUT "BUTTON",       /*** Type ***/
                      INPUT "btDeleteSon1", /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-btDeleteSon1-im0045d).
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event  = "AFTER-OPEN-QUERY" THEN DO:

    IF VALID-HANDLE(wh-brson1-im0045d) THEN DO:
        ASSIGN h-coluna1 = wh-brson1-im0045d:GET-BROWSE-COLUMN(1).

        ASSIGN wh-query  = wh-brson1-im0045d:QUERY
               wh-buffer = wh-query:GET-BUFFER-HANDLE(1).

        wh-buffer:BUFFER-FIELD("nr-invoice"):FORMAT = "x(20)".
        wh-brson1-im0045d:ADD-LIKE-COLUMN("tt-invoice-emb-imp.nr-invoice", 1).
        h-coluna1:VISIBLE = FALSE.

        ASSIGN hColumnnr-embarque   = wh-buffer:BUFFER-FIELD("embarque":U)
               hColumnnr-nr-invoice = wh-buffer:BUFFER-FIELD("nr-invoice":U)
               hColumnnr-parcela    = wh-buffer:BUFFER-FIELD("parcela":U).

        FIND FIRST pagamento-invoice NO-LOCK
             WHERE pagamento-invoice.embarque   = hColumnnr-embarque:BUFFER-VALUE
               AND pagamento-invoice.nr-invoice = hColumnnr-nr-invoice:BUFFER-VALUE
               AND pagamento-invoice.parcela    = hColumnnr-parcela:BUFFER-VALUE NO-ERROR.

        IF AVAIL pagamento-invoice THEN DO:
            FIND FIRST pagamento
                 WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-LOCK NO-ERROR.
            IF AVAIL pagamento AND pagamento.recebido-ap THEN
                ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = NO.
            ELSE
                ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = YES.
        END.
        ELSE DO:
            ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = YES.
        END.
    END.
END.

IF p-ind-event  = "after-value-changed" AND
   p-ind-object = "CONTAINER"           AND 
   p-cod-table  = "invoice-emb-imp"     THEN DO:
      
    DEFINE VARIABLE c-ci AS CHARACTER   NO-UNDO.
    /*ASSIGN r-rowid-item-fornec-estab-cc0531 = p-row-table.*/

    ASSIGN c-ci = "".
    FIND FIRST invoice-emb-imp NO-LOCK WHERE ROWID(invoice-emb-imp) = p-row-table NO-ERROR.
    IF AVAIL invoice-emb-imp THEN DO:
        FOR EACH pagamento-invoice NO-LOCK
           WHERE pagamento-invoice.embarque   = invoice-emb-imp.embarque
             AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice
             AND pagamento-invoice.parcela    = invoice-emb-imp.parcela:

            IF c-ci = "" THEN
                ASSIGN c-ci = STRING(pagamento-invoice.nr-pagamento).
            ELSE
                ASSIGN c-ci = c-ci + ", " + STRING(pagamento-invoice.nr-pagamento).
        END.
    END.
    ASSIGN wh-ci-im0045e:SCREEN-VALUE = c-ci.

    IF VALID-HANDLE(wh-brson1-im0045d) THEN DO:
        ASSIGN wh-query  = wh-brson1-im0045d:QUERY
               wh-buffer = wh-query:GET-BUFFER-HANDLE(1).

        ASSIGN hColumnnr-embarque   = wh-buffer:BUFFER-FIELD("embarque":U)
               hColumnnr-nr-invoice = wh-buffer:BUFFER-FIELD("nr-invoice":U)
               hColumnnr-parcela    = wh-buffer:BUFFER-FIELD("parcela":U).

        FIND FIRST pagamento-invoice NO-LOCK
             WHERE pagamento-invoice.embarque   = hColumnnr-embarque:BUFFER-VALUE
               AND pagamento-invoice.nr-invoice = hColumnnr-nr-invoice:BUFFER-VALUE
               AND pagamento-invoice.parcela    = hColumnnr-parcela:BUFFER-VALUE NO-ERROR.

        IF AVAIL pagamento-invoice THEN DO:
            FIND FIRST pagamento
                 WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-LOCK NO-ERROR.
            IF AVAIL pagamento AND pagamento.recebido-ap THEN
                ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = NO.
            ELSE
                ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = YES.
        END.
        ELSE DO:
            ASSIGN wh-btDeleteSon1-im0045d:SENSITIVE = YES.
        END.
    END.
END.

IF p-ind-event  = "BEFORE-DELETE" AND
   p-ind-object = "CONTAINER"           AND 
   p-cod-table  = "invoice-emb-imp"  THEN DO:

    FIND FIRST invoice-emb-imp NO-LOCK 
        WHERE ROWID(invoice-emb-imp) = p-row-table NO-ERROR.

    IF AVAIL invoice-emb-imp THEN DO:
        ASSIGN i-nr-pagamento = 0.

        FOR EACH pagamento-invoice EXCLUSIVE-LOCK
           WHERE pagamento-invoice.embarque   = invoice-emb-imp.embarque
             AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice
             AND pagamento-invoice.parcela    = invoice-emb-imp.parcela:

            ASSIGN i-nr-pagamento = pagamento-invoice.nr-pagamento.

            DELETE pagamento-invoice.
        END.

        ASSIGN de-valor-invoice = 0.
        FOR EACH pagamento-invoice NO-LOCK
           WHERE pagamento-invoice.nr-pagamento = i-nr-pagamento:

            ASSIGN de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
        END.

        FIND FIRST pagamento EXCLUSIVE-LOCK
             WHERE pagamento.nr-pagamento = i-nr-pagamento NO-ERROR.
        IF AVAIL pagamento THEN DO:
            ASSIGN pagamento.valor-pag = de-valor-invoice.
            RELEASE pagamento.
        END.
    END.
END.

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.
