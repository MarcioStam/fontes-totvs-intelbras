/**************************************************************************************************
** PROGRAMA...: ft0904-upc.p - UPC do FT0904
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 19/03/2012
/**ATUALIZACAO: 20/03/2012**/
**************************************************************************************************/

DEF INPUT PARAMETER p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-wgh-objeto AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAMETER p-wgh-frame  AS HANDLE        NO-UNDO.
DEF INPUT PARAMETER p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEF VAR c-objeto         AS CHAR          NO-UNDO.
DEF VAR h-objeto         AS HANDLE        NO-UNDO.
DEF VAR i-objeto         AS INT           NO-UNDO.
DEF VAR c-folder         AS CHAR          NO-UNDO.
DEF VAR h-query          AS HANDLE        NO-UNDO.
DEF VAR h_upc-ft0904-b01 AS HANDLE        NO-UNDO.
DEF VAR c-handle-obj     AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-folder          AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-nr-el_ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-ve_ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-proc_ft0904    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-canc_ft0904    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-1_ft0904    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-2_ft0904    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-cont_ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-sea_ft0904     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-url_ft0904     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-nota-fiscal_ft0502 AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-handle  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-handle2 AS WIDGET-HANDLE NO-UNDO.

{cdp/cdcfgdis.i}
{upc/ft0904-upc.i}

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-objeto:PRIVATE-DATA, "~/"), p-wgh-objeto:PRIVATE-DATA, "~/").


IF  p-ind-event  = "INITIALIZE" AND
    p-ind-object = "CONTAINER" THEN DO:
    
    /** Novo Folder **/
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-objeto,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).

    ASSIGN h-folder = WIDGET-HANDLE(c-folder) NO-ERROR.

    IF  VALID-HANDLE(h-folder) THEN DO:

        RUN set-attribute-list  IN h-folder ("folder-tab-type = 3":U).
        RUN create-folder-page  IN h-folder (INPUT 9, INPUT "NFS-e":U).
        RUN create-folder-label IN h-folder (INPUT 9, INPUT "NFS-e":U).

        RUN select-page         IN p-wgh-objeto (INPUT 9).
        RUN init-object         IN p-wgh-objeto (INPUT  'upc/ft0904b01-upc.w':U,
                                                 INPUT  p-wgh-frame,
                                                 INPUT  'Layout = ':U,
                                                 OUTPUT h_upc-ft0904-b01).
        
        RUN set-position    IN h_upc-ft0904-b01 (7.80,2.50) NO-ERROR.
        RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-objeto,
                                               INPUT "CONTAINER-TARGET":U,
                                               OUTPUT c-objeto).

        RUN dispatch IN h_upc-ft0904-b01 ("initialize":U).

        DO  i-objeto = 1 TO NUM-ENTRIES(c-objeto):
            ASSIGN h-objeto = WIDGET-HANDLE(ENTRY(i-objeto, c-objeto)).

            IF  h-objeto:FILE-NAME = "diqry/q01di135.w" THEN
                ASSIGN h-query = h-objeto.
        END.

        RUN add-link IN adm-broker-hdl (INPUT h-query,
                                        INPUT 'RECORD':U,
                                        INPUT h_upc-ft0904-b01).
        
        RUN dispatch    IN h_upc-ft0904-b01 ("initialize":U).
        RUN select-page IN p-wgh-objeto (INPUT 1).
    END.
END.


IF  c-objeto = "v02di135.w":U      AND
    p-ind-event = "BEFORE-DISPLAY" THEN DO:

    IF  VALID-HANDLE(wh-nr-el_ft0904)   AND
        VALID-HANDLE(wh-nr-ve_ft0904)   AND
        VALID-HANDLE(wh-tg-proc_ft0904) AND 
        VALID-HANDLE(wh-tg-canc_ft0904) THEN DO:

        ASSIGN wh-nr-el_ft0904:SCREEN-VALUE  = ""
               wh-nr-ve_ft0904:SCREEN-VALUE  = ""
               wh-tg-proc_ft0904:CHECKED     = NO
               wh-tg-canc_ft0904:CHECKED     = NO.

        FOR FIRST nota-fiscal
            WHERE ROWID(nota-fiscal) = p-row-table NO-LOCK:

            ASSIGN r-nota-fiscal_ft0502 = ROWID(nota-fiscal).

            FOR FIRST esp-ext-nota-fiscal NO-LOCK
                WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                  AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                  AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis: 
            
                ASSIGN wh-nr-el_ft0904:SCREEN-VALUE  = esp-ext-nota-fiscal.nr-nota-el
                       wh-nr-ve_ft0904:SCREEN-VALUE  = esp-ext-nota-fiscal.cod-autentic-nfe
                       wh-tg-proc_ft0904:CHECKED     = esp-ext-nota-fiscal.processada
                       wh-tg-canc_ft0904:CHECKED     = esp-ext-nota-fiscal.int-1 = 3.
            END.
        END.
    END.
END.

IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "CONTAINER"    THEN DO:

    ASSIGN c-handle-obj = fc-handle-obj("bt-sea",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).

    CREATE BUTTON wh-bt-sea_ft0904
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-bt-sea_ft0904"
           WIDTH     = h-handle:WIDTH
           HEIGHT    = h-handle:HEIGHT
           TOOLTIP   = "Pesquisa NFS-e"
           ROW       = h-handle:ROW + 0.13
           COL       = h-handle:COL + 20
           FONT      = h-handle:FONT
           VISIBLE   = h-handle:VISIBLE
           SENSITIVE = h-handle:SENSITIVE.

    wh-bt-sea_ft0904:LOAD-IMAGE-UP("image\bt-cw.png").
    wh-bt-sea_ft0904:LOAD-IMAGE-INSENSITIVE("image\bt-cw.png").
    wh-bt-sea_ft0904:MOVE-TO-TOP().

    ON 'choose':U OF wh-bt-sea_ft0904 PERSISTENT RUN upc/ft0904z01-upc.p.


    CREATE BUTTON wh-bt-url_ft0904
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-bt-url_ft0904"
           WIDTH     = h-handle:WIDTH
           HEIGHT    = h-handle:HEIGHT
           TOOLTIP   = "Link NFS-e"
           ROW       = h-handle:ROW + 0.13
           COL       = h-handle:COL + 24
           FONT      = h-handle:FONT
           VISIBLE   = h-handle:VISIBLE
           SENSITIVE = h-handle:SENSITIVE.

    wh-bt-url_ft0904:LOAD-IMAGE-UP("image\bt-ie.png").
    wh-bt-url_ft0904:LOAD-IMAGE-INSENSITIVE("image\bt-cw.png").
    wh-bt-url_ft0904:MOVE-TO-TOP().

    ON 'choose':U OF wh-bt-url_ft0904 PERSISTENT RUN rpp/espnfse2060b.p.
END.


IF  c-objeto = "v02di135.w":U  AND
    p-ind-event = "INITIALIZE" THEN DO:

    ASSIGN c-handle-obj = fc-handle-obj("c-desc-sit",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).

    IF  VALID-HANDLE(h-handle) THEN
        h-handle:WIDTH = h-handle:WIDTH - 1.1.

    CREATE TOGGLE-BOX wh-tg-proc_ft0904
    ASSIGN FRAME     = p-wgh-frame
           WIDTH     = 15
           HEIGHT    = 1
           ROW       = 1.15
           LABEL     = "RPS Processado"
           COL       = 74
           FGCOLOR   = 12
           VISIBLE   = YES
           SENSITIVE = NO.

    CREATE TOGGLE-BOX wh-tg-canc_ft0904
    ASSIGN FRAME     = p-wgh-frame
           WIDTH     = 15
           HEIGHT    = 1
           ROW       = 2.15
           LABEL     = "NFS-e Cancelada"
           COL       = 74
           FGCOLOR   = 12
           VISIBLE   = YES
           SENSITIVE = NO.

    CREATE TEXT tx-label-1_ft0904
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "X(7)"
           VISIBLE      = yes
           ROW          = 2.15
           COL          = 26.5
           WIDTH        = 7
           HEIGHT       = 0.79
           FONT         = 1
           SCREEN-VALUE = "Cd Ve:".

    CREATE FILL-IN wh-nr-ve_ft0904
    ASSIGN FRAME     = p-wgh-frame
           format    = "x(12)"
           WIDTH     = 16
           HEIGHT    = 0.88
           ROW       = 2.15
           COL       = 31.5
           FGCOLOR   = 12
           SIDE-LABEL-HANDLE = tx-label-1_ft0904:HANDLE
           VISIBLE   = YES
           SENSITIVE = NO.

    CREATE TEXT tx-label-2_ft0904
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "X(6)"
           VISIBLE      = yes
           ROW          = 1.15
           COL          = 26.5
           WIDTH        = 5
           HEIGHT       = 0.79
           FONT         = 1
           SCREEN-VALUE = "NFS-e:".

    CREATE FILL-IN wh-nr-el_ft0904
    ASSIGN FRAME     = p-wgh-frame
           FORMAT    = "x(18)"
           WIDTH     = 16
           HEIGHT    = 0.88
           ROW       = 1.15
           COL       = 31.5
           SIDE-LABEL-HANDLE = tx-label-2_ft0904:HANDLE
           FGCOLOR   = 12
           VISIBLE   = YES
           SENSITIVE = NO.



    /*Reposicionar campos para 206 em diante*/
    
    /*Estabelecimento da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("cod-estabel",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Serie da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("serie",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Numero da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("nr-nota-fis",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Situacao nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("c-desc-sit",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Data emissao nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("dt-emis-nota",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Codigo do cliente*/
    ASSIGN c-handle-obj = fc-handle-obj("i-cod-emitente",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Nome do cliente*/
    ASSIGN c-handle-obj = fc-handle-obj("nome-ab-cli",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8.

END.


RETURN "OK":U.
