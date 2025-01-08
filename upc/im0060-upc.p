/***********************************************************************
**  Programa..: upc\im0060-upc.p
**  Autor.....: Raphael Matei Paini
**  Data......: Novembro/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 10/11/2009
**                  Desenvolvimento Programa
**              002 - 23/04/2012
**                  Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
**                  Inclus∆o dos campos NVE e EX Tarifario
************************************************************************/
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE VARIABLE wh-numero-ordem     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-emitente     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-it-codigo        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-seq-cotac        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-mapa-cotacao     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-incoterm     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-pto-contr    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-descricao        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-fabricante   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-nome-abrev2      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cdn-pais-orig    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-desc-pais-orig   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-desc-class-fisc  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-regime-import    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-desc-regime      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aliq-ii          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aliq-ipi         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-itiner       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-itinerario       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-gerac-autom-desp AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-upc-im0060               AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-class-fiscal-im0060     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-li-im0060            AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-destaque-im0060     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-destaque-im0060         AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-gatt-im0060          AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-percGatt-im0060     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-percGatt-im0060         AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-nve-im0060          AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nve-im0060              AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-ex-tarifario-im0060 AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ex-tarifario-im0060     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ordem-im0060            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-incoterm-im0060         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ponto-im0060            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-itiner-im0060           AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-objeto        AS CHARACTER   NO-UNDO.

DEF BUFFER b-ordem-compra FOR ordem-compra.

/* OUTPUT TO c:\temp\eventos-im0060.txt APPEND NO-CONVERT.                                               */
/* ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/":U), p-wgh-object:FILE-NAME, "~/":U). */
/* PUT UNFORMATTED                                                                                       */
/*         "Evento " p-ind-event  SKIP                                                                   */
/*         "Objeto " p-ind-object SKIP                                                                   */
/*         "Tabela " p-cod-table  SKIP                                                                   */
/*         "Rowid  " STRING(p-row-table) SKIP                                                            */
/*         "Objeto " c-objeto     SKIP(1).                                                               */
/* OUTPUT CLOSE.                                                                                         */


IF p-ind-object = "CONTAINER"        AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/im0060-upc.p PERSISTENT SET h-upc-im0060(INPUT "":U,
                                                     INPUT "":U,
                                                     INPUT p-wgh-object,
                                                     INPUT p-wgh-frame,
                                                     INPUT "":U,
                                                     INPUT p-row-table).
    /* i-mapa-cotacao */
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-mapa-cotacao", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-mapa-cotacao).

    /*c-cod-incoterm*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-cod-incoterm", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-incoterm).

    /*i-cod-pto-contr*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-cod-pto-contr", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-pto-contr).

    /*c-descricao*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-descricao", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-descricao).

    /*i-cod-fabricante*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-cod-fabricante", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-fabricante).

    /*c-nome-abrev2*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-nome-abrev2", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-nome-abrev2).

    /*i-cdn-pais-orig*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-cdn-pais-orig", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cdn-pais-orig).

    /*c-desc-cdn-pais-orig*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-desc-cdn-pais-orig", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-desc-pais-orig).

    /*c-class-fiscal*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-class-fiscal", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-class-fiscal-im0060).

    /*c-desc-class-fiscal*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-desc-class-fiscal", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-desc-class-fisc).

    /*i-regime-import*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-regime-import", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-regime-import).

    /*c-desc-regime*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-desc-regime", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-desc-regime).

    /*de-aliq-ii*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "de-aliq-ii", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-aliq-ii).

    /*de-aliq-ipi*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "de-aliq-ipi", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-aliq-ipi).

    /*i-cod-itiner*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "i-cod-itiner", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-itiner).

    /*c-itinerario*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "c-itinerario", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-itinerario).

    /*log-gerac-autom-despes*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "toggle-box", /*** Type ***/
                  INPUT "log-gerac-autom-despes", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-gerac-autom-desp).

    ASSIGN wh-mapa-cotacao:COLUMN        = wh-mapa-cotacao:COLUMN        - 20.50
           wh-cod-incoterm:COLUMN        = wh-cod-incoterm:COLUMN        - 20.50
           wh-cod-pto-contr:COLUMN       = wh-cod-pto-contr:COLUMN       - 20.50
           wh-descricao:COLUMN           = wh-descricao:COLUMN           - 20.50
           wh-cod-fabricante:COLUMN      = wh-cod-fabricante:COLUMN      - 20.50
           wh-nome-abrev2:COLUMN         = wh-nome-abrev2:COLUMN         - 20.50
           wh-cdn-pais-orig:COLUMN       = wh-cdn-pais-orig:COLUMN       - 20.50
           wh-desc-pais-orig:COLUMN      = wh-desc-pais-orig:COLUMN      - 20.50
           wh-class-fiscal-im0060:COLUMN = wh-class-fiscal-im0060:COLUMN - 20.50
           wh-desc-class-fisc:COLUMN     = wh-desc-class-fisc:COLUMN     - 20.50
           wh-regime-import:COLUMN       = wh-regime-import:COLUMN       - 20.50
           wh-desc-regime:COLUMN         = wh-desc-regime:COLUMN         - 20.50
           wh-aliq-ii:COLUMN             = wh-aliq-ii:COLUMN             - 20.50
           wh-aliq-ipi:COLUMN            = wh-aliq-ipi:COLUMN            - 20.50
           wh-cod-itiner:COLUMN          = wh-cod-itiner:COLUMN          - 20.50
           wh-itinerario:COLUMN          = wh-itinerario:COLUMN          - 20.50
           wh-gerac-autom-desp:COLUMN    = wh-gerac-autom-desp:COLUMN    - 20.50.

    ASSIGN wh-aliq-ii:SIDE-LABEL-HANDLE:SCREEN-VALUE = "Al°quota II":U.

    ASSIGN wh-mapa-cotacao:SIDE-LABEL-HANDLE:COLUMN        = wh-mapa-cotacao:SIDE-LABEL-HANDLE:COLUMN        - 20.50
           wh-cod-incoterm:SIDE-LABEL-HANDLE:COLUMN        = wh-cod-incoterm:SIDE-LABEL-HANDLE:COLUMN        - 20.50
           wh-cod-pto-contr:SIDE-LABEL-HANDLE:COLUMN       = wh-cod-pto-contr:SIDE-LABEL-HANDLE:COLUMN       - 20.50
           wh-cod-fabricante:SIDE-LABEL-HANDLE:COLUMN      = wh-cod-fabricante:SIDE-LABEL-HANDLE:COLUMN      - 20.50
           wh-cdn-pais-orig:SIDE-LABEL-HANDLE:COLUMN       = wh-cdn-pais-orig:SIDE-LABEL-HANDLE:COLUMN       - 20.50
           wh-class-fiscal-im0060:SIDE-LABEL-HANDLE:COLUMN = wh-class-fiscal-im0060:SIDE-LABEL-HANDLE:COLUMN - 20.50
           wh-regime-import:SIDE-LABEL-HANDLE:COLUMN       = wh-regime-import:SIDE-LABEL-HANDLE:COLUMN       - 20.50
           wh-aliq-ii:SIDE-LABEL-HANDLE:COLUMN             = wh-aliq-ii:SIDE-LABEL-HANDLE:COLUMN             - 20.50
           wh-aliq-ipi:SIDE-LABEL-HANDLE:COLUMN            = wh-aliq-ipi:SIDE-LABEL-HANDLE:COLUMN            - 20.50
           wh-cod-itiner:SIDE-LABEL-HANDLE:COLUMN          = wh-cod-itiner:SIDE-LABEL-HANDLE:COLUMN          - 20.50.

    ASSIGN wh-desc-class-fisc:WIDTH = wh-desc-class-fisc:WIDTH - 16.50
           wh-desc-regime:WIDTH     = wh-desc-regime:WIDTH     - 16.50
           wh-itinerario:WIDTH      = wh-itinerario:WIDTH      - 11.50.

    CREATE TEXT wh-txt-nve-im0060
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(4)":U
           WIDTH        = 5
           SCREEN-VALUE = "NVE:":U
           ROW          = wh-cdn-pais-orig:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 60.64
           VISIBLE      = YES.

    CREATE FILL-IN wh-nve-im0060
    ASSIGN NAME              = "wh-nve-im0060":U
           FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = wh-txt-nve-im0060:HANDLE
           DATA-TYPE         = "CHARACTER":U
           FORMAT            = "x(50)":U
           WIDTH             = 25
           HEIGHT            = 0.88
           ROW               = wh-txt-nve-im0060:ROW - 0.15
           COL               = 64.64
           LABEL             = "NVE:":U
           VISIBLE           = YES
           SENSITIVE         = NO
           HELP              = "NVE":U.

    CREATE TEXT wh-txt-ex-tarifario-im0060
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(13)":U
           WIDTH        = 14
           SCREEN-VALUE = "EX Tarifario:":U
           ROW          = wh-class-fiscal-im0060:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 55.89
           VISIBLE      = YES.

    CREATE FILL-IN wh-ex-tarifario-im0060
    ASSIGN NAME              = "wh-ex-tarifario-im0060":U
           FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = wh-txt-ex-tarifario-im0060:HANDLE
           DATA-TYPE         = "CHARACTER":U
           FORMAT            = "x(8)":U
           WIDTH             = 6.86
           HEIGHT            = 0.88
           ROW               = wh-txt-ex-tarifario-im0060:ROW - 0.15
           COL               = 64.64
           LABEL             = "EX Tarifario:":U
           VISIBLE           = YES
           SENSITIVE         = NO
           HELP              = "EX Tarifario":U.

    CREATE TOGGLE-BOX wh-tg-li-im0060
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 13
           HEIGHT       = 0.88
           LABEL        = "Necessita LI?"
           ROW          = wh-regime-import:ROW
           COLUMN       = 64.64
           SENSITIVE    = NO
           VISIBLE      = YES
           HELP         = "Necessita de Licenáa de Importaá∆o":U.

    CREATE TEXT wh-txt-destaque-im0060
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 20
           SCREEN-VALUE = "Destaque NCM:"
           ROW          = wh-aliq-ii:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 53.50
           VISIBLE      = YES.

    CREATE FILL-IN wh-destaque-im0060
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = wh-txt-destaque-im0060:HANDLE
           DATA-TYPE         = "INTEGER":U
           FORMAT            = "999":U
           WIDTH             = 4.00
           HEIGHT            = 0.88
           ROW               = wh-txt-destaque-im0060:ROW - 0.15
           COL               = 64.64
           VISIBLE           = YES
           SENSITIVE         = NO
           HELP              = "Destaque NCM":U
           TRIGGERS:
                ON LEAVE PERSISTENT RUN pi-leave-destaque IN h-upc-im0060.
           END TRIGGERS.


    CREATE TOGGLE-BOX wh-tg-gatt-im0060
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 8
           HEIGHT       = 0.88
           LABEL        = "GATT":U
           ROW          = wh-aliq-ipi:ROW
           COLUMN       = 64.64
           SENSITIVE    = NO
           VISIBLE      = YES.


    CREATE TEXT wh-txt-percGatt-im0060
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 20
           SCREEN-VALUE = "Percentual GATT:":U
           ROW          = wh-cod-itiner:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 52.10
           VISIBLE      = YES.
    
    CREATE FILL-IN wh-percGatt-im0060
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = wh-txt-percGatt-im0060:HANDLE
           DATA-TYPE         = "DECIMAL":U
           FORMAT            = ">>9.99":U
           WIDTH             = 6.00
           HEIGHT            = 0.88
           ROW               = wh-txt-percGatt-im0060:ROW - 0.15
           COL               = 64.64
           VISIBLE           = YES
           SENSITIVE         = NO
           HELP              = "Percentual GATT":U
           TRIGGERS:
                ON LEAVE PERSISTENT RUN pi-leave-perc-gatt IN h-upc-im0060.
           END TRIGGERS.

    wh-nve-im0060:MOVE-AFTER-TAB-ITEM(wh-cod-itiner:HANDLE).
    wh-ex-tarifario-im0060:MOVE-BEFORE-TAB-ITEM(wh-tg-li-im0060:HANDLE).

    ASSIGN wh-mapa-cotacao     = ?
           wh-cod-incoterm     = ?
           wh-cod-pto-contr    = ?
           wh-descricao        = ?
           wh-cod-fabricante   = ?
           wh-nome-abrev2      = ?
           wh-cdn-pais-orig    = ?
           wh-desc-pais-orig   = ?
           wh-desc-class-fisc  = ?
           wh-regime-import    = ?
           wh-desc-regime      = ?
           wh-aliq-ii          = ?
           wh-aliq-ipi         = ?
           wh-cod-itiner       = ?
           wh-itinerario       = ?
           wh-gerac-autom-desp = ?.
END.

IF p-ind-object = "CONTAINER"        AND
   p-ind-event = "AFTER-INITIALIZE" 
THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "numero-ordem", /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-ordem-im0060).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",        /*** Type ***/
                  INPUT "c-cod-incoterm", /*** Name ***/
                  INPUT NO,               /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-incoterm-im0060).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",         /*** Type ***/
                  INPUT "i-cod-pto-contr", /*** Name ***/
                  INPUT NO,                /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                 /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-ponto-im0060).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "i-cod-itiner",  /*** Name ***/
                  INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-itiner-im0060).
END.

IF p-ind-event  = "AFTER-ENABLE-FIELDS":U AND
   p-ind-object = "CONTAINER":U           THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "it-codigo", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-it-codigo).

    IF  VALID-HANDLE(wh-it-codigo) THEN DO:
        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = wh-it-codigo:SCREEN-VALUE NO-ERROR.
        IF  NOT AVAIL item OR
            item.ge-codigo <> 0 /* DÇbito Direto */ THEN DO:

            IF VALID-HANDLE(wh-txt-nve-im0060)          THEN DELETE WIDGET wh-txt-nve-im0060.
            IF VALID-HANDLE(wh-nve-im0060)              THEN DELETE WIDGET wh-nve-im0060.
            IF VALID-HANDLE(wh-txt-ex-tarifario-im0060) THEN DELETE WIDGET wh-txt-ex-tarifario-im0060.
            IF VALID-HANDLE(wh-ex-tarifario-im0060)     THEN DELETE WIDGET wh-ex-tarifario-im0060.
    
            ASSIGN wh-txt-nve-im0060          = ?
                   wh-nve-im0060              = ?
                   wh-txt-ex-tarifario-im0060 = ?
                   wh-ex-tarifario-im0060     = ?.
        END.
    END.

    IF VALID-HANDLE(wh-destaque-im0060)     THEN ASSIGN wh-destaque-im0060:SENSITIVE     = YES.
    IF VALID-HANDLE(wh-tg-li-im0060)        THEN ASSIGN wh-tg-li-im0060:SENSITIVE        = YES.
    IF VALID-HANDLE(wh-tg-gatt-im0060)      THEN ASSIGN wh-tg-gatt-im0060:SENSITIVE      = YES.
    IF VALID-HANDLE(wh-percGatt-im0060)     THEN ASSIGN wh-percGatt-im0060:SENSITIVE     = YES.
    IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN wh-nve-im0060:SENSITIVE          = YES.
    IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN wh-ex-tarifario-im0060:SENSITIVE = YES.

    ASSIGN wh-it-codigo = ?.

    IF  VALID-HANDLE(wh-ordem-im0060)
    THEN DO:
        FIND FIRST ordens-embarque NO-LOCK
            WHERE  ordens-embarque.numero-ordem = INT(wh-ordem-im0060:SCREEN-VALUE) NO-ERROR.

        IF  AVAIL ordens-embarque
        THEN DO:
            IF VALID-HANDLE(wh-incoterm-im0060) THEN ASSIGN wh-incoterm-im0060:SENSITIVE = NO.
            IF VALID-HANDLE(wh-ponto-im0060)    THEN ASSIGN wh-ponto-im0060:SENSITIVE    = NO.
            IF VALID-HANDLE(wh-itiner-im0060)   THEN ASSIGN wh-itiner-im0060:SENSITIVE   = NO.
        END.
        ELSE DO:
            FIND FIRST ordem-compra NO-LOCK
                WHERE  ordem-compra.numero-ordem = INT(wh-ordem-im0060:SCREEN-VALUE) NO-ERROR.
    
            IF  AVAIL ordem-compra
            THEN DO:
                bloco-ordens:
                FOR EACH  b-ordem-compra NO-LOCK
                    WHERE b-ordem-compra.num-pedido = ordem-compra.num-pedido:
    
                    FIND FIRST ordens-embarque NO-LOCK
                        WHERE  ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem NO-ERROR.
            
                    IF  AVAIL ordens-embarque
                    THEN DO:
                        IF VALID-HANDLE(wh-incoterm-im0060) THEN ASSIGN wh-incoterm-im0060:SENSITIVE = NO.
                        LEAVE bloco-ordens.
                    END.
                END.
            END.
        END.

        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = INTEGER(wh-ordem-im0060:SCREEN-VALUE) NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra THEN DO:
            FIND FIRST b-ordem-compra
                WHERE b-ordem-compra.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

            IF AVAILABLE b-ordem-compra THEN DO:
                FIND FIRST cotacao-item
                    WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK NO-ERROR.

                IF AVAILABLE cotacao-item THEN
                    IF VALID-HANDLE(wh-incoterm-im0060) THEN ASSIGN wh-incoterm-im0060:SCREEN-VALUE = TRIM(SUBSTRING(cotacao-item.char-1, 21, 20)).
            END.
        END.
    END.
END. /* IF p-ind-event  = "AFTER-ENABLE-FIELDS":U AND */

IF p-ind-event  = "AFTER-SAVE-FIELDS":U AND
   p-ind-object = "CONTAINER":U         
THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "numero-ordem", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-numero-ordem).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "cod-emitente", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-emitente).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "it-codigo", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-it-codigo).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "seq-cotac", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-seq-cotac).
    
    FIND FIRST cotacao-item
        WHERE ROWID(cotacao-item) = p-row-table NO-LOCK NO-ERROR.

    IF NOT AVAILABLE cotacao-item THEN
        FIND FIRST cotacao-item NO-LOCK
            WHERE  cotacao-item.numero-ordem = wh-numero-ordem:INPUT-VALUE
            AND    cotacao-item.cod-emitente = wh-cod-emitente:INPUT-VALUE
            AND    cotacao-item.it-codigo    = wh-it-codigo:INPUT-VALUE
            AND    cotacao-item.seq-cotac    = wh-seq-cotac:INPUT-VALUE NO-ERROR.
    IF  NOT AVAILABLE cotacao-item THEN DO:
        CREATE int-cotacao-item.
        ASSIGN int-cotacao-item.numero-ordem = wh-numero-ordem:INPUT-VALUE
               int-cotacao-item.cod-emitente = wh-cod-emitente:INPUT-VALUE
               int-cotacao-item.it-codigo    = wh-it-codigo:INPUT-VALUE
               int-cotacao-item.seq-cotac    = wh-seq-cotac:INPUT-VALUE.
    END.
    ELSE DO:
        FIND FIRST int-cotacao-item OF cotacao-item EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL int-cotacao-item THEN DO:
            CREATE int-cotacao-item.
            ASSIGN int-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                   int-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                   int-cotacao-item.it-codigo    = cotacao-item.it-codigo
                   int-cotacao-item.seq-cotac    = cotacao-item.seq-cotac.
        END.
    END.

    IF valid-handle(wh-destaque-im0060)     THEN assign int-cotacao-item.destaque         = wh-destaque-im0060:INPUT-VALUE.
    IF valid-handle(wh-tg-li-im0060)        THEN assign int-cotacao-item.log-necessita-li = wh-tg-li-im0060:CHECKED.
    IF valid-handle(wh-tg-gatt-im0060)      THEN assign int-cotacao-item.log-gatt         = wh-tg-gatt-im0060:CHECKED.
    IF valid-handle(wh-percGatt-im0060)     THEN assign int-cotacao-item.perc-gatt        = wh-percGatt-im0060:INPUT-VALUE.
    IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN int-cotacao-item.nve              = wh-nve-im0060:INPUT-VALUE.
    IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN int-cotacao-item.ex-tarifario     = wh-ex-tarifario-im0060:INPUT-VALUE.

    IF valid-handle(wh-destaque-im0060)     THEN ASSIGN wh-destaque-im0060:SENSITIVE = NO.
    IF valid-handle(wh-tg-li-im0060)        THEN ASSIGN wh-tg-li-im0060:SENSITIVE = NO.
    IF valid-handle(wh-tg-gatt-im0060)      THEN ASSIGN wh-tg-gatt-im0060:SENSITIVE = NO.
    IF valid-handle(wh-percGatt-im0060)     THEN ASSIGN wh-percGatt-im0060:SENSITIVE = NO.
    IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN wh-nve-im0060:SENSITIVE = NO.
    IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN wh-ex-tarifario-im0060:SENSITIVE = NO.

END. /* IF p-ind-event  = "AFTER-SAVE-FIELDS":U ... */

IF p-ind-event  = "AFTER-DISPLAY":U AND
   p-ind-object = "CONTAINER":U     THEN DO:
     
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in", /*** Type ***/
                  INPUT "it-codigo", /*** Name ***/
                  INPUT NO, /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1, /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-it-codigo).
     
    IF  VALID-HANDLE(wh-it-codigo) THEN DO:
        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = wh-it-codigo:SCREEN-VALUE NO-ERROR.
        IF  NOT AVAIL item OR item.ge-codigo <> 0 /* DÇbito Direto */ THEN DO:
     
            IF VALID-HANDLE(wh-txt-nve-im0060)          THEN DELETE WIDGET wh-txt-nve-im0060.
            IF VALID-HANDLE(wh-nve-im0060)              THEN DELETE WIDGET wh-nve-im0060.
            IF VALID-HANDLE(wh-txt-ex-tarifario-im0060) THEN DELETE WIDGET wh-txt-ex-tarifario-im0060.
            IF VALID-HANDLE(wh-ex-tarifario-im0060)     THEN DELETE WIDGET wh-ex-tarifario-im0060.
     
            ASSIGN wh-txt-nve-im0060          = ?
                   wh-nve-im0060              = ?
                   wh-txt-ex-tarifario-im0060 = ?
                   wh-ex-tarifario-im0060     = ?.
        END.
    END.
     
    IF VALID-HANDLE(wh-destaque-im0060)     THEN ASSIGN wh-destaque-im0060:SENSITIVE    = NO
                                                        wh-destaque-im0060:SCREEN-VALUE = "999":U.
     
    IF VALID-HANDLE(wh-tg-li-im0060)        THEN ASSIGN wh-tg-li-im0060:SENSITIVE       = NO
                                                        wh-tg-li-im0060:CHECKED         = NO.
     
    IF VALID-HANDLE(wh-tg-gatt-im0060)      THEN ASSIGN wh-tg-gatt-im0060:SENSITIVE     = NO
                                                        wh-tg-gatt-im0060:CHECKED       = NO.
     
    IF VALID-HANDLE(wh-percGatt-im0060)     THEN ASSIGN wh-percGatt-im0060:SENSITIVE    = NO
                                                        wh-percGatt-im0060:SCREEN-VALUE = "0,00":U.
     
    IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN wh-nve-im0060:SENSITIVE         = NO
                                                        wh-nve-im0060:SCREEN-VALUE      = "":U.
     
    IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN wh-ex-tarifario-im0060:SENSITIVE = NO
                                                        wh-ex-tarifario-im0060:SCREEN-VALUE = "":U.
     
    FIND FIRST cotacao-item NO-LOCK
         WHERE ROWID(cotacao-item) = p-row-table NO-ERROR.
    IF  AVAIL cotacao-item THEN DO:
        FIND FIRST int-cotacao-item OF cotacao-item NO-LOCK NO-ERROR.
        IF  AVAIL int-cotacao-item THEN DO:
            IF VALID-HANDLE(wh-destaque-im0060)     THEN ASSIGN wh-destaque-im0060:SCREEN-VALUE = TRIM(STRING(int-cotacao-item.destaque, "999":U)).
            IF VALID-HANDLE(wh-tg-li-im0060)        THEN ASSIGN wh-tg-li-im0060:CHECKED         = int-cotacao-item.log-necessita-li.
            IF VALID-HANDLE(wh-tg-gatt-im0060)      THEN ASSIGN wh-tg-gatt-im0060:CHECKED       = int-cotacao-item.log-gatt.
            IF VALID-HANDLE(wh-percGatt-im0060)     THEN ASSIGN wh-percGatt-im0060:SCREEN-VALUE = TRIM(STRING(int-cotacao-item.perc-gatt, ">>9.99":U)).
            IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN wh-nve-im0060:SCREEN-VALUE          = int-cotacao-item.nve.
            IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN wh-ex-tarifario-im0060:SCREEN-VALUE = int-cotacao-item.ex-tarifario.
        END.
        ELSE DO:
            FIND FIRST item
                WHERE item.it-codigo = cotacao-item.it-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE item THEN DO:
                FIND FIRST int-item
                    WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
                IF  AVAILABLE int-item THEN DO:
                    IF VALID-HANDLE(wh-destaque-im0060)     THEN ASSIGN wh-destaque-im0060:SCREEN-VALUE     = TRIM(STRING(int-item.destaque, "999":U)).
                    IF VALID-HANDLE(wh-tg-li-im0060)        THEN ASSIGN wh-tg-li-im0060:CHECKED             = item.log-necessita-li.
                    IF VALID-HANDLE(wh-tg-gatt-im0060)      THEN ASSIGN wh-tg-gatt-im0060:CHECKED           = int-item.log-gatt.
                    IF VALID-HANDLE(wh-percGatt-im0060)     THEN ASSIGN wh-percGatt-im0060:SCREEN-VALUE     = TRIM(STRING(int-item.perc-gatt, ">>9.99":U)).
                    IF VALID-HANDLE(wh-nve-im0060)          THEN ASSIGN wh-nve-im0060:SCREEN-VALUE          = int-item.nve.
                    IF VALID-HANDLE(wh-ex-tarifario-im0060) THEN ASSIGN wh-ex-tarifario-im0060:SCREEN-VALUE = int-item.ex-tarifario.
                END.
            END.
        END.
    END.
     
    ASSIGN wh-it-codigo = ?.
END. 
     
     
PROCEDURE pi-leave-destaque :
    IF  wh-destaque-im0060:SCREEN-VALUE <> "999":U THEN DO:
        IF  wh-destaque-im0060:SCREEN-VALUE = "000":U THEN DO:
            MESSAGE "Destaque da Classificaá∆o Fiscal deve ser informada!":U VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.
            RETURN NO-APPLY.
        END.

        FIND FIRST destaque-classif-fisc
            WHERE destaque-classif-fisc.class-fiscal = wh-class-fiscal-im0060:SCREEN-VALUE
              AND destaque-classif-fisc.destaque     = INTEGER(wh-destaque-im0060:SCREEN-VALUE) NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE destaque-classif-fisc THEN DO:
            MESSAGE "Destaque n∆o cadastrado para essa Classificaá∆o Fiscal":U VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.
            RETURN NO-APPLY.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-leave-perc-gatt :
    IF  wh-tg-gatt-im0060:SCREEN-VALUE = "YES":U THEN DO:
        IF  wh-percGatt-im0060:SCREEN-VALUE = "0,00":U OR
            wh-percGatt-im0060:SCREEN-VALUE = ?        THEN DO:
            MESSAGE "Percentual deve ser informado, pois campo GATT est† marcado!":U VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        IF  wh-percGatt-im0060:SCREEN-VALUE <> "0,00":U THEN DO:
            MESSAGE "Percentual n∆o deve ser informado, para informar percentual deve ser marcado campo GATT":U VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.
            RETURN NO-APPLY.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE tela-upc :
    DEFINE INPUT  PARAMETER  pWghFrame AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux      AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj     AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):
        IF pApresMsg THEN
            MESSAGE "Nome do Objeto":U wgh-obj:NAME SKIP
                    "Type do Objeto":U wgh-obj:TYPE SKIP
                    "P-Ind-Event":U    pIndEvent
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.

        IF wgh-obj:TYPE = "field-group":U THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    RETURN "OK":U.

END PROCEDURE.

