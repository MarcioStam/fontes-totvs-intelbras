/*:T*******************************************************************************
**
**  Programa.: upc/cd1112-upc.p
**  Objetivo.: Espec°fico do programa Item X Estabelecimento - CD1112
**  Criaá∆o..: 19/05/2010
**  Vers∆o...: 00001 - 19/05/2010 - Validar campo para que seja inserido o valor
**             do Ressupr Fornec no Horizonte Liber e no Horizonte Fixo. Estes dois
**             £ltimos dever∆o estar dasabilitados na alteraá∆o. - Fabiano Sakae 
**             Ribeiro (Exponencial TI / SQL Works).
**
**             00002 - 19/05/2010 - Incluri campo "Qtde Embalagem" para apenas
**             registrar a quantidade em embalagem de um item. 
**             Foi acertado tambÇm a quest∆o da validaá∆o do EMS para o "Horizonte
**             Liber / Fixo". - Fabiano Sakae Ribeiro (Exponencial TI / SQL Works).
**
**             00003 - 08/11/2011 - Inserir os campos qtd-lote-multiplo,
**             estoque-maximo e estoque planejado, utilizados para o
**             kanban-eletronico. - Anderson Hoepers (Exponencial TI / SQL Works).
**
**             00004 - 16/08/2012 - Manutená∆o para acertar a posiá∆o dos campos
**             para a vers∆o do Datasul EMS 2.06B. - Fabiano Sakae Ribeiro
**             (Exponencial TI / SQL Works).
**
*******************************************************************************/

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v-row-cd1112             AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cd1112-upc              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-frame              AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-cap-est-fabr      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-rt-key            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cb-politica       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cb-demanda        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-lote-multipl      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-lote-minimo       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fator-refugo      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-quant-perda       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-rt-mold           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-lote-economi      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-periodo-fixo      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-c-pto-repos       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-c-tipo-est-seg    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-rt-temp-qt-seg    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-c-liter-estoq     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-rect-33           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-tb-conv-tempo-seg AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cb-reab-estoq     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aps               AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fpage-nova        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-rect              AS WIDGET-HANDLE NO-UNDO.

define variable c-folder         as character    no-undo.
define variable c-objects        as character    no-undo.
define variable i-objects        as integer      no-undo.
define variable h-object         as handle       no-undo.
define variable l-record-1       as logical      no-undo initial no.
define variable l-group-assign-1 as logical      no-undo initial no.
define variable l-state-1        as logical      no-undo initial no.

DEFINE NEW GLOBAL SHARED VARIABLE l-desabilita-cd1112  AS LOGICAL     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tipo-est-seg             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-quant-segur              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tempo-segur              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qtd-estoq-cd1112-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-estoq-cd1112-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-lote-kanban-cd1112-upc   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-lote-kan-cd1112-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qtd-plan-cd1112-upc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-plan-cd1112-upc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qtd-embalagem-cd1112-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-embalagem-cd1112-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qtd-politica-cd1112-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-politica-cd1112-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-res-for-comp-cd1112-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-horiz-lib-cd1112-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-horiz-fixo-cd1112-upc    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-reporte-mob-cd1112-upc   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-reporte-ggf-cd1112-upc   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-viewer-1                  AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-assign                    AS LOGICAL       NO-UNDO.

define new global shared var h-folder       as handle no-undo.
define new global shared var adm-broker-hdl as handle no-undo.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).
{esp/es0018.i}
{utp/ut-glob.i}

/* Exibir mensagens com os eventos da UPC */
/* MESSAGE "Evento: ":U      p-ind-event  SKIP     */
/*         "Objeto: ":U      p-ind-object SKIP     */
/*         "Nome Objeto: ":U c-objeto     SKIP     */
/*         "Frame: ":U       p-wgh-frame  SKIP     */
/*         "Tabela: ":U      p-cod-table  SKIP     */
/*         "Rowid: ":U       STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX TITLE "Eventos da UPC":U. */

/* Imprimir arquivo texto com os eventos da UPC */
/* OUTPUT TO VALUE("C:/temp/eventos-cd1112.txt":U) APPEND CONVERT TARGET SESSION:CHARSET. */
/* PUT UNFORMATTED                                                                        */
/*     "Evento.......: ":U p-ind-event         SKIP                                       */
/*     "Objeto.......: ":U p-ind-object        SKIP                                       */
/*     "Nome Objeto..: ":U c-objeto            SKIP                                       */
/*     "Frame........: ":U p-wgh-frame         SKIP                                       */
/*     "Tabela.......: ":U p-cod-table         SKIP                                       */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                                       */
/*     FILL("-":U, 50)                         SKIP.                                      */
/* OUTPUT CLOSE.                                                                          */

IF p-ind-event = "BEFORE-INITIALIZE":U THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "cap-est-fabr":U      THEN ASSIGN wh-cap-est-fabr            = h-frame.
                WHEN "rt-key":U            THEN ASSIGN wh-rt-key                  = h-frame.
                WHEN "cb-politica":U       THEN ASSIGN wh-cb-politica             = h-frame.
                WHEN "cb-demanda":U        THEN ASSIGN wh-cb-demanda              = h-frame.
                WHEN "lote-multipl":U      THEN ASSIGN wh-lote-multipl            = h-frame.
                WHEN "lote-minimo":U       THEN ASSIGN wh-lote-minimo             = h-frame.
                WHEN "fator-refugo":U      THEN ASSIGN wh-fator-refugo            = h-frame.
                WHEN "quant-perda":U       THEN ASSIGN wh-quant-perda             = h-frame.
                WHEN "rt-mold":U           THEN ASSIGN wh-rt-mold                 = h-frame.
                WHEN "lote-economi":U      THEN ASSIGN wh-lote-economi            = h-frame.
                WHEN "periodo-fixo":U      THEN ASSIGN wh-periodo-fixo            = h-frame.
                WHEN "c-pto-repos":U       THEN ASSIGN wh-c-pto-repos             = h-frame.
                WHEN "c-tipo-est-seg":U    THEN ASSIGN wh-c-tipo-est-seg          = h-frame.
                WHEN "rt-temp-qt-seg":U    THEN ASSIGN wh-rt-temp-qt-seg          = h-frame.
                WHEN "tipo-est-seg":U      THEN ASSIGN wh-tipo-est-seg            = h-frame.
                WHEN "quant-segur":U       THEN ASSIGN wh-quant-segur             = h-frame.
                WHEN "tempo-segur":U       THEN ASSIGN wh-tempo-segur             = h-frame.
                WHEN "c-liter-estoq":U     THEN ASSIGN wh-c-liter-estoq           = h-frame.
                WHEN "rect-33":U           THEN ASSIGN wh-rect-33                 = h-frame.
                WHEN "tb-conv-tempo-seg":U THEN ASSIGN wh-tb-conv-tempo-seg       = h-frame.
                WHEN "cb-reab-estoq":U     THEN ASSIGN wh-cb-reab-estoq           = h-frame.
                WHEN "res-for-comp":U      THEN ASSIGN wh-res-for-comp-cd1112-upc = h-frame.
                WHEN "i-horiz-lib":U       THEN ASSIGN wh-horiz-lib-cd1112-upc    = h-frame.
                WHEN "horiz-fixo":U        THEN ASSIGN wh-horiz-fixo-cd1112-upc   = h-frame.
                WHEN "reporte-mob":U       THEN ASSIGN wh-reporte-mob-cd1112-upc  = h-frame.
                WHEN "reporte-ggf":U       THEN ASSIGN wh-reporte-ggf-cd1112-upc  = h-frame.
            END CASE.

            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    RUN upc/cd1112-upc.p PERSISTENT SET h-upc-cd1112-upc(INPUT "",            
                                                         INPUT "",            
                                                         INPUT p-wgh-object,  
                                                         INPUT p-wgh-frame,   
                                                         INPUT "",            
                                                         INPUT p-row-table).

    IF VALID-HANDLE(wh-rt-key)            AND
       VALID-HANDLE(wh-cb-politica)       AND
       VALID-HANDLE(wh-cb-demanda)        AND
       VALID-HANDLE(wh-lote-multipl)      AND
       VALID-HANDLE(wh-lote-minimo)       AND 
       VALID-HANDLE(wh-fator-refugo)      AND 
       VALID-HANDLE(wh-quant-perda)       AND 
       VALID-HANDLE(wh-rt-mold)           AND 
       VALID-HANDLE(wh-lote-economi)      AND 
       VALID-HANDLE(wh-periodo-fixo)      AND 
       VALID-HANDLE(wh-c-pto-repos)       AND 
       VALID-HANDLE(wh-c-tipo-est-seg)    AND 
       VALID-HANDLE(wh-rt-temp-qt-seg)    AND 
       VALID-HANDLE(wh-tipo-est-seg)      AND 
       VALID-HANDLE(wh-quant-segur)       AND 
       VALID-HANDLE(wh-tempo-segur)       AND 
       VALID-HANDLE(wh-c-liter-estoq)     AND 
       VALID-HANDLE(wh-rect-33)           AND 
       VALID-HANDLE(wh-tb-conv-tempo-seg) AND 
       VALID-HANDLE(wh-cb-reab-estoq)     THEN DO:
        ASSIGN wh-rt-key:WIDTH = 36.00.

        ASSIGN wh-cb-politica:ROW  = 1.50
               wh-cb-demanda:ROW   = wh-cb-politica:ROW  + 1.00
               wh-lote-multipl:ROW = wh-cb-demanda:ROW   + 1.00
               wh-lote-minimo:ROW  = wh-lote-multipl:ROW + 1.00
               wh-fator-refugo:ROW = wh-lote-minimo:ROW  + 1.00
               wh-quant-perda:ROW  = wh-fator-refugo:ROW + 1.00.

        ASSIGN wh-cb-politica:COLUMN  = wh-cb-politica:COLUMN  - 6.15
               wh-cb-demanda:COLUMN   = wh-cb-demanda:COLUMN   - 6.15
               wh-lote-multipl:COLUMN = wh-lote-multipl:COLUMN - 6.15
               wh-lote-minimo:COLUMN  = wh-lote-minimo:COLUMN  - 6.15
               wh-fator-refugo:COLUMN = wh-fator-refugo:COLUMN - 6.15
               wh-quant-perda:COLUMN  = wh-quant-perda:COLUMN  - 6.15.

        ASSIGN wh-cb-politica:SIDE-LABEL-HANDLE:ROW  = 1.50
               wh-cb-demanda:SIDE-LABEL-HANDLE:ROW   = wh-cb-politica:SIDE-LABEL-HANDLE:ROW  + 1.00
               wh-lote-multipl:SIDE-LABEL-HANDLE:ROW = wh-cb-demanda:SIDE-LABEL-HANDLE:ROW   + 1.00
               wh-lote-minimo:SIDE-LABEL-HANDLE:ROW  = wh-lote-multipl:SIDE-LABEL-HANDLE:ROW + 1.00
               wh-fator-refugo:SIDE-LABEL-HANDLE:ROW = wh-lote-minimo:SIDE-LABEL-HANDLE:ROW  + 1.00
               wh-quant-perda:SIDE-LABEL-HANDLE:ROW  = wh-fator-refugo:SIDE-LABEL-HANDLE:ROW + 1.00.

        ASSIGN wh-cb-politica:SIDE-LABEL-HANDLE:COLUMN  = wh-cb-politica:SIDE-LABEL-HANDLE:COLUMN  - 6.15
               wh-cb-demanda:SIDE-LABEL-HANDLE:COLUMN   = wh-cb-demanda:SIDE-LABEL-HANDLE:COLUMN   - 6.15
               wh-lote-multipl:SIDE-LABEL-HANDLE:COLUMN = wh-lote-multipl:SIDE-LABEL-HANDLE:COLUMN - 6.15
               wh-lote-minimo:SIDE-LABEL-HANDLE:COLUMN  = wh-lote-minimo:SIDE-LABEL-HANDLE:COLUMN  - 6.15
               wh-fator-refugo:SIDE-LABEL-HANDLE:COLUMN = wh-fator-refugo:SIDE-LABEL-HANDLE:COLUMN - 6.15
               wh-quant-perda:SIDE-LABEL-HANDLE:COLUMN  = wh-quant-perda:SIDE-LABEL-HANDLE:COLUMN  - 6.15.

        ASSIGN wh-rt-mold:COLUMN = 38.00
               wh-rt-mold:WIDTH  = 47.00.

        ASSIGN wh-lote-economi:COLUMN = wh-lote-economi:COLUMN - 2.00
               wh-periodo-fixo:COLUMN = wh-periodo-fixo:COLUMN - 2.00
               wh-c-pto-repos:COLUMN  = wh-c-pto-repos:COLUMN  - 2.00.

        ASSIGN wh-lote-economi:SIDE-LABEL-HANDLE:COLUMN = wh-lote-economi:SIDE-LABEL-HANDLE:COLUMN - 2.00
               wh-periodo-fixo:SIDE-LABEL-HANDLE:COLUMN = wh-periodo-fixo:SIDE-LABEL-HANDLE:COLUMN - 2.00
               wh-c-pto-repos:SIDE-LABEL-HANDLE:COLUMN  = wh-c-pto-repos:SIDE-LABEL-HANDLE:COLUMN  - 2.00.

        ASSIGN wh-c-tipo-est-seg:COLUMN = 39.29
               wh-c-tipo-est-seg:ROW    =  4.25
               wh-rt-temp-qt-seg:COLUMN = 38.00
               wh-rt-temp-qt-seg:WIDTH  = 47.00
               wh-rt-temp-qt-seg:HEIGHT =  3.35
               wh-rt-temp-qt-seg:ROW    =  4.50.

        ASSIGN wh-tipo-est-seg:COLUMN = 47.43
               wh-tipo-est-seg:ROW    =  4.96
               wh-quant-segur:COLUMN  = wh-quant-segur:COLUMN - 5
               wh-quant-segur:ROW     =  4.79
               wh-tempo-segur:COLUMN  = wh-tempo-segur:COLUMN - 5
               wh-tempo-segur:ROW     =  5.79.

        ASSIGN wh-c-liter-estoq:COLUMN = 39.29
               wh-c-liter-estoq:ROW    =  7.83
               wh-rect-33:COLUMN       = 38.00
               wh-rect-33:WIDTH        = 47.00
               wh-rect-33:HEIGHT       =  1.25
               wh-rect-33:ROW          =  8.17.

        ASSIGN wh-cb-reab-estoq:SIDE-LABEL-HANDLE:SCREEN-VALUE = "Reabastec":U.

        ASSIGN wh-tb-conv-tempo-seg:COLUMN               = 38.86
               wh-tb-conv-tempo-seg:ROW                  =  8.50
               wh-cb-reab-estoq:COLUMN                   = 68.20
               wh-cb-reab-estoq:ROW                      =  8.38
               wh-cb-reab-estoq:SIDE-LABEL-HANDLE:COLUMN = 59.90
               wh-cb-reab-estoq:SIDE-LABEL-HANDLE:ROW    =  8.38.
    END.

    IF VALID-HANDLE(wh-cap-est-fabr) AND
       p-ind-object = "VIEWER":U     AND
       c-objeto     = "v05in684.w":U THEN DO:

        IF NOT VALID-HANDLE(tx-qtd-plan-cd1112-upc) AND
           NOT VALID-HANDLE(wh-qtd-plan-cd1112-upc) THEN DO:
            CREATE TEXT tx-qtd-plan-cd1112-upc
            ASSIGN FRAME        = wh-cap-est-fabr:FRAME
                   FORMAT       = "x(27)":U
                   WIDTH        = 27
                   SCREEN-VALUE = "Estoque Planejado Kanban:":U
                   ROW          = wh-cap-est-fabr:SIDE-LABEL-HANDLE:ROW + 1.15
                   COLUMN       = 12.85
                   VISIBLE      = YES.

            CREATE FILL-IN wh-qtd-plan-cd1112-upc
            ASSIGN FRAME             = wh-cap-est-fabr:FRAME
                   DATA-TYPE         = "DECIMAL":U
                   FORMAT            = ">>>,>>9":U
                   SIDE-LABEL-HANDLE = tx-qtd-plan-cd1112-upc:HANDLE
                   WIDTH             = 8
                   HEIGHT            = 0.88
                   ROW               = wh-cap-est-fabr:ROW + 1
                   COLUMN            = wh-cap-est-fabr:COLUMN
                   HIDDEN            = NO
                   HELP              = "Quantidade m†xima em estoque planejada para controle do kanban eletrìnico":U
                   TOOLTIP           = "Quantidade m†xima em estoque planejada para controle do kanban eletrìnico":U
                   SENSITIVE         = NO
                   VISIBLE           = YES.
        END.

        IF NOT VALID-HANDLE(tx-qtd-estoq-cd1112-upc) AND
           NOT VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN DO:
            CREATE TEXT tx-qtd-estoq-cd1112-upc
            ASSIGN FRAME        = wh-cap-est-fabr:FRAME
                   FORMAT       = "x(27)":U
                   WIDTH        = 27
                   SCREEN-VALUE = "Estoque M†ximo Kanban:":U
                   ROW          = wh-cap-est-fabr:SIDE-LABEL-HANDLE:ROW + 0.15
                   COLUMN       = 54.30
                   VISIBLE      = YES.

            CREATE FILL-IN wh-qtd-estoq-cd1112-upc
            ASSIGN FRAME             = wh-cap-est-fabr:FRAME
                   DATA-TYPE         = "DECIMAL":U
                   FORMAT            = ">>>,>>9":U
                   SIDE-LABEL-HANDLE = tx-qtd-estoq-cd1112-upc:HANDLE
                   WIDTH             = 8
                   HEIGHT            = 0.88
                   ROW               = wh-cap-est-fabr:ROW
                   COLUMN            = 71.8
                   HIDDEN            = NO
                   HELP              = "Quantidade m†xima em estoque para controle do kanban eletrìnico":U
                   TOOLTIP           = "Quantidade m†xima em estoque para controle do kanban eletrìnico":U
                   SENSITIVE         = NO
                   VISIBLE           = YES.
        END.

        IF NOT VALID-HANDLE(tx-lote-kanban-cd1112-upc)  AND
           NOT VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN DO:
            CREATE TEXT tx-lote-kanban-cd1112-upc
            ASSIGN FRAME        = wh-cap-est-fabr:FRAME
                   FORMAT       = "x(27)":U
                   WIDTH        = 27
                   SCREEN-VALUE = "Lote M£ltiplo Kanban:":U
                   ROW          = tx-qtd-plan-cd1112-upc:ROW
                   COLUMN       = 56.90
                   VISIBLE      = YES.
    
            CREATE FILL-IN wh-qtd-lote-kan-cd1112-upc
            ASSIGN FRAME             = wh-cap-est-fabr:FRAME
                   DATA-TYPE         = "DECIMAL":U
                   FORMAT            = ">>>,>>9":U
                   SIDE-LABEL-HANDLE = tx-lote-kanban-cd1112-upc:HANDLE
                   WIDTH             = 8
                   HEIGHT            = 0.88
                   ROW               = wh-qtd-plan-cd1112-upc:ROW
                   COLUMN            = wh-qtd-estoq-cd1112-upc:COLUMN
                   HIDDEN            = NO
                   HELP              = "Quantidade do lote m£ltiplo para controle do kanban eletrìnico":U
                   TOOLTIP           = "Quantidade do lote m£ltiplo para controle do kanban eletrìnico":U
                   SENSITIVE         = NO
                   VISIBLE           = YES.
        END.
    END.

    IF VALID-HANDLE(wh-quant-perda)                  AND
       NOT VALID-HANDLE(tx-qtd-embalagem-cd1112-upc) AND
       NOT VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN DO:

        CREATE TEXT tx-qtd-embalagem-cd1112-upc
        ASSIGN FRAME        = wh-quant-perda:FRAME
               FORMAT       = "x(16)":U
               WIDTH        = 13
               SCREEN-VALUE = "Kanban Injetora:":U
               ROW          = wh-quant-perda:ROW + 1.10
               COLUMN       = wh-quant-perda:COLUMN - 11.6
               VISIBLE      = YES.

        CREATE FILL-IN wh-qtd-embalagem-cd1112-upc
        ASSIGN FRAME             = wh-quant-perda:FRAME
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">,>>>,>>9.9999":U
               WIDTH             = wh-quant-perda:WIDTH
               HEIGHT            = 0.88
               ROW               = wh-quant-perda:ROW + 1
               COLUMN            = wh-quant-perda:COLUMN
               HIDDEN            = NO
               HELP              = "Quantidade Embalagem":U
               TOOLTIP           = "Quantidade Embalagem":U
               SIDE-LABEL-HANDLE = tx-qtd-embalagem-cd1112-upc:HANDLE
               SENSITIVE         = NO
               VISIBLE           = YES.

        wh-qtd-embalagem-cd1112-upc:MOVE-AFTER-TAB-ITEM(wh-quant-perda).
    END.

    IF VALID-HANDLE(wh-tempo-segur)                 AND
       VALID-HANDLE(wh-quant-segur)                 AND
       NOT VALID-HANDLE(tx-qtd-politica-cd1112-upc) AND
       NOT VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN DO:

        CREATE TEXT tx-qtd-politica-cd1112-upc
        ASSIGN FRAME        = wh-periodo-fixo:FRAME
               FORMAT       = "x(14)":U
               WIDTH        = 9.75
               SCREEN-VALUE = "Qtde Pol°tica:":U
               ROW          = wh-tempo-segur:ROW + 1.15
               COLUMN       = 52.90
               VISIBLE      = YES.

        CREATE FILL-IN wh-qtd-politica-cd1112-upc
        ASSIGN FRAME             = wh-periodo-fixo:FRAME
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>>,>>>,>>9.99":U
               WIDTH             = wh-quant-segur:WIDTH
               HEIGHT            = 0.88
               ROW               = wh-tempo-segur:ROW + 1
               COLUMN            = wh-tempo-segur:COLUMN
               HIDDEN            = NO
               HELP              = "Politica Empresa Quantidade":U
               TOOLTIP           = "Politica Empresa Quantidade":U
               SIDE-LABEL-HANDLE = tx-qtd-politica-cd1112-upc:HANDLE
               SENSITIVE         = NO
               VISIBLE           = YES.

        wh-qtd-politica-cd1112-upc:MOVE-AFTER-TAB-ITEM(wh-tempo-segur).
    END.

    RUN esp/es0018p.p (INPUT "cd1112":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    
    ASSIGN l-desabilita-cd1112 = YES.
    FOR EACH tt-prog-ponto:
        IF CAN-FIND (FIRST usuar_grp_usuar
                     WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                       AND usuar_grp_usuar.cod_usuar     = c-seg-usuario) THEN DO:

            ASSIGN l-desabilita-cd1112 = NO.
            LEAVE.
        END.
    END.

    IF l-desabilita-cd1112 THEN DO:
        IF VALID-HANDLE (wh-tempo-segur) THEN
            ASSIGN wh-tempo-segur:READ-ONLY = YES.
        
        IF VALID-HANDLE (wh-quant-segur) THEN
            ASSIGN wh-quant-segur:READ-ONLY = YES.
        
        IF VALID-HANDLE (wh-qtd-politica-cd1112-upc) THEN
            ASSIGN wh-qtd-politica-cd1112-upc:READ-ONLY = YES.
    END.

    IF VALID-HANDLE (wh-tipo-est-seg) THEN DO:
        ON "entry":U OF wh-tipo-est-seg PERSISTENT RUN pi-value-changed IN h-upc-cd1112-upc.
    END.

    ASSIGN h-frame              = ?
           wh-cap-est-fabr      = ?
           wh-rt-key            = ?
           wh-cb-politica       = ?
           wh-cb-demanda        = ?
           wh-lote-multipl      = ?
           wh-lote-minimo       = ?
           wh-fator-refugo      = ?
           wh-quant-perda       = ?
           wh-rt-mold           = ?
           wh-lote-economi      = ?
           wh-periodo-fixo      = ?
           wh-c-pto-repos       = ?
           wh-c-tipo-est-seg    = ?
           wh-rt-temp-qt-seg    = ?
           wh-c-liter-estoq     = ?
           wh-rect-33           = ?
           wh-tb-conv-tempo-seg = ?
           wh-cb-reab-estoq     = ?.
END.

IF p-ind-event  = "AFTER-ENABLE":U AND
   p-ind-object = "VIEWER":U       THEN DO:
    IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
        ASSIGN wh-qtd-embalagem-cd1112-upc:SENSITIVE = YES.
        
    IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
        ASSIGN wh-qtd-politica-cd1112-upc:SENSITIVE = YES.

    IF VALID-HANDLE(wh-horiz-lib-cd1112-upc) THEN
        ASSIGN wh-horiz-lib-cd1112-upc:SENSITIVE = YES.
        
    IF VALID-HANDLE(wh-horiz-fixo-cd1112-upc) THEN
        ASSIGN wh-horiz-fixo-cd1112-upc:SENSITIVE = YES.


    RUN esp/es0018p.p (INPUT "cd1112":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    
    ASSIGN l-desabilita-cd1112 = YES.

    FOR EACH tt-prog-ponto:
        IF CAN-FIND (FIRST usuar_grp_usuar
                     WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                       AND usuar_grp_usuar.cod_usuar     = c-seg-usuario) THEN DO:

            ASSIGN l-desabilita-cd1112 = NO.
            LEAVE.
        END.
    END.

    IF l-desabilita-cd1112 THEN DO:
       IF VALID-HANDLE(wh-reporte-mob-cd1112-upc) THEN
           ASSIGN wh-reporte-mob-cd1112-upc:SENSITIVE = NO.
           
       IF VALID-HANDLE(wh-reporte-ggf-cd1112-upc) THEN
           ASSIGN wh-reporte-ggf-cd1112-upc:SENSITIVE = NO.
    END.

    
END.
IF p-ind-event = "DISPLAY":U THEN DO:
    ASSIGN v-row-cd1112 = p-row-table.
END.

IF c-objeto     = "v05in684.w":U AND
   p-ind-object = "VIEWER":U     THEN DO:

    IF p-ind-event = "DISPLAY":U THEN DO:
        FIND FIRST item-uni-estab
            WHERE ROWID(item-uni-estab) = p-row-table NO-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            FIND FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

            IF AVAILABLE int-item-uni-estab THEN DO:
                IF VALID-HANDLE(wh-qtd-plan-cd1112-upc) THEN
                    ASSIGN wh-qtd-plan-cd1112-upc:SCREEN-VALUE = STRING(int-item-uni-estab.dec-1).

                IF VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN
                    ASSIGN wh-qtd-estoq-cd1112-upc:SCREEN-VALUE = STRING(int-item-uni-estab.qtd-estoq-max).

                IF VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN
                    ASSIGN wh-qtd-lote-kan-cd1112-upc:SCREEN-VALUE = STRING(int-item-uni-estab.qtd-lote-multiplo).
            END.
            ELSE DO:
                IF VALID-HANDLE(wh-qtd-plan-cd1112-upc) THEN
                    ASSIGN wh-qtd-plan-cd1112-upc:SCREEN-VALUE = "0":U.

                IF VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN
                    ASSIGN wh-qtd-estoq-cd1112-upc:SCREEN-VALUE = "0":U.

                IF VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN
                    ASSIGN wh-qtd-lote-kan-cd1112-upc:SCREEN-VALUE = "0,00".
            END.
        END.
    END.

    IF p-ind-event = "AFTER-ENABLE":U THEN DO:
        IF VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN
            ASSIGN wh-qtd-estoq-cd1112-upc:SENSITIVE = YES.

        IF VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN
            ASSIGN wh-qtd-lote-kan-cd1112-upc:SENSITIVE = YES.
    END.

    IF p-ind-event = "AFTER-DISABLE":U THEN DO:
        IF VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN
            ASSIGN wh-qtd-estoq-cd1112-upc:SENSITIVE = NO.

        IF VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN
            ASSIGN wh-qtd-lote-kan-cd1112-upc:SENSITIVE = NO.
    END.

    IF p-ind-event = "AFTER-END-UPDATE":U THEN DO:
        IF DECIMAL(wh-qtd-estoq-cd1112-upc:SCREEN-VALUE) < DECIMAL(wh-qtd-plan-cd1112-upc:SCREEN-VALUE) THEN DO:
            RUN utp\ut-msgs.p (INPUT "SHOW":U,
                               INPUT 27100,
                               INPUT "Estoque m†ximo menor que planejado.~~Confirma a quantidade para o estoque m†ximo, menor que a quantidade para o estoque planejado?":U).

            IF RETURN-VALUE = "NO":U THEN
                RETURN "ADM-ERROR":U.
        END.

        FIND FIRST item-uni-estab
            WHERE ROWID(item-uni-estab) = p-row-table EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            FIND FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE int-item-uni-estab THEN DO:
                IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
                    ASSIGN int-item-uni-estab.qtd-estoq-max = DECIMAL(wh-qtd-estoq-cd1112-upc:SCREEN-VALUE).

                IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
                    ASSIGN int-item-uni-estab.qtd-lote-multiplo = DECIMAL(wh-qtd-lote-kan-cd1112-upc:SCREEN-VALUE).
            END.
            ELSE DO:
                CREATE int-item-uni-estab.
                ASSIGN int-item-uni-estab.cod-estabel       = item-uni-estab.cod-estabel
                       int-item-uni-estab.it-codigo         = item-uni-estab.it-codigo
                       int-item-uni-estab.qtd-estoq-max     = DECIMAL(wh-qtd-estoq-cd1112-upc:SCREEN-VALUE)
                       int-item-uni-estab.qtd-lote-multiplo = DECIMAL(wh-qtd-lote-kan-cd1112-upc:SCREEN-VALUE).
            END.
        END.
    END.
END. /* IF c-objeto = "v05in684.w" AND */


IF p-ind-event  = "END-UPDATE":U AND
   p-ind-object = "VIEWER":U   AND 
   c-objeto     = "v03in684.w" THEN DO:
     FIND FIRST item-uni-estab
         WHERE ROWID(item-uni-estab) = p-row-table no-LOCK NO-ERROR.

     IF AVAIL item-uni-estab THEN
         OVERLAY (item-uni-estab.char-1,129,3) = wh-res-for-comp-cd1112-upc:SCREEN-VALUE.
END.


IF p-ind-event  = "VALIDATE":U AND
   p-ind-object = "VIEWER":U   AND 
   c-objeto     = "v03in684.w" THEN DO:
    IF VALID-HANDLE(wh-res-for-comp-cd1112-upc) AND
       VALID-HANDLE(wh-horiz-lib-cd1112-upc)    AND
       VALID-HANDLE(wh-horiz-fixo-cd1112-upc)   THEN DO:
        FIND FIRST item-uni-estab
            WHERE ROWID(item-uni-estab) = p-row-table no-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            ASSIGN wh-horiz-lib-cd1112-upc:SCREEN-VALUE  = wh-res-for-comp-cd1112-upc:SCREEN-VALUE  /* Usado para que se possa poder passar pela validaá∆o do EMS 2 */
                   wh-horiz-lib-cd1112-upc:SCREEN-VALUE  = wh-res-for-comp-cd1112-upc:SCREEN-VALUE  /* Usado para que se possa poder passar pela validaá∆o do EMS 2 */
                   wh-horiz-fixo-cd1112-upc:SCREEN-VALUE = wh-res-for-comp-cd1112-upc:SCREEN-VALUE. /* Usado para que se possa poder passar pela validaá∆o do EMS 2 */
        END.
    END.
END.

IF c-objeto = "v02in684.w" THEN DO:
    IF p-ind-event  = "AFTER-DISABLE":U AND
       p-ind-object = "VIEWER":U        THEN DO:
        IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
            ASSIGN wh-qtd-embalagem-cd1112-upc:SENSITIVE = NO.

        IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
            ASSIGN wh-qtd-politica-cd1112-upc:SENSITIVE = NO.
    END.

    IF p-ind-event  = "DISPLAY":U AND
       p-ind-object = "VIEWER":U  THEN DO:
        FIND FIRST item-uni-estab
            WHERE ROWID(item-uni-estab) = p-row-table NO-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            FIND FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

            IF AVAILABLE int-item-uni-estab THEN DO:
                IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
                    ASSIGN wh-qtd-embalagem-cd1112-upc:SCREEN-VALUE = STRING(int-item-uni-estab.qtde-embalagem).

                IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
                    ASSIGN wh-qtd-politica-cd1112-upc:SCREEN-VALUE = STRING(int-item-uni-estab.qtd-pol).
            END.
            ELSE DO:
                IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
                    ASSIGN wh-qtd-embalagem-cd1112-upc:SCREEN-VALUE = "0":U.

                IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
                    ASSIGN wh-qtd-politica-cd1112-upc:SCREEN-VALUE = "0,00".
            END.
        END.
    END.

    IF p-ind-event  = "AFTER-END-UPDATE":U AND
       p-ind-object = "VIEWER":U     THEN DO:
        FIND FIRST item-uni-estab
            WHERE ROWID(item-uni-estab) = p-row-table EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            ASSIGN OVERLAY(item-uni-estab.char-1, 129, 3) = STRING(item-uni-estab.res-for-comp)
                   item-uni-estab.horiz-fixo              = item-uni-estab.res-for-comp.

            FIND FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE int-item-uni-estab THEN DO:
                IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN 
                    ASSIGN int-item-uni-estab.qtde-embalagem = DECIMAL(wh-qtd-embalagem-cd1112-upc:SCREEN-VALUE).

                IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN 
                    ASSIGN int-item-uni-estab.qtd-pol = DECIMAL(wh-qtd-politica-cd1112-upc:SCREEN-VALUE).
            END.
            ELSE DO:
                CREATE int-item-uni-estab.
                ASSIGN int-item-uni-estab.cod-estabel    = item-uni-estab.cod-estabel
                       int-item-uni-estab.it-codigo      = item-uni-estab.it-codigo
                       int-item-uni-estab.qtde-embalagem = DECIMAL(wh-qtd-embalagem-cd1112-upc:SCREEN-VALUE)
                       int-item-uni-estab.qtd-pol        = DECIMAL(wh-qtd-politica-cd1112-upc:SCREEN-VALUE).
            END.
        END.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:

    ASSIGN h-upc-cd1112-upc = ?.
    IF VALID-HANDLE(tx-qtd-plan-cd1112-upc) THEN
        DELETE WIDGET tx-qtd-plan-cd1112-upc.

    IF VALID-HANDLE(wh-qtd-plan-cd1112-upc) THEN
        DELETE WIDGET wh-qtd-plan-cd1112-upc.

    ASSIGN tx-qtd-plan-cd1112-upc = ?
           wh-qtd-plan-cd1112-upc = ?.

    IF VALID-HANDLE(tx-qtd-estoq-cd1112-upc) THEN
        DELETE WIDGET tx-qtd-estoq-cd1112-upc.

    IF VALID-HANDLE(wh-qtd-estoq-cd1112-upc) THEN
        DELETE WIDGET wh-qtd-estoq-cd1112-upc.

    ASSIGN tx-qtd-estoq-cd1112-upc = ?
           wh-qtd-estoq-cd1112-upc = ?.

    IF VALID-HANDLE(tx-lote-kanban-cd1112-upc) THEN
        DELETE WIDGET tx-lote-kanban-cd1112-upc.

    IF VALID-HANDLE(wh-qtd-lote-kan-cd1112-upc) THEN
        DELETE WIDGET wh-qtd-lote-kan-cd1112-upc.

    ASSIGN tx-lote-kanban-cd1112-upc  = ?
           wh-qtd-lote-kan-cd1112-upc = ?.

    IF VALID-HANDLE(tx-qtd-embalagem-cd1112-upc) THEN
        DELETE WIDGET tx-qtd-embalagem-cd1112-upc.

    IF VALID-HANDLE(wh-qtd-embalagem-cd1112-upc) THEN
        DELETE WIDGET wh-qtd-embalagem-cd1112-upc.

    ASSIGN tx-qtd-embalagem-cd1112-upc = ?
           wh-qtd-embalagem-cd1112-upc = ?.

    IF VALID-HANDLE(tx-qtd-politica-cd1112-upc) THEN
        DELETE WIDGET tx-qtd-politica-cd1112-upc.
        ASSIGN tx-qtd-politica-cd1112-upc = ?.

    IF VALID-HANDLE(wh-qtd-politica-cd1112-upc) THEN
        DELETE WIDGET wh-qtd-politica-cd1112-upc.

    ASSIGN tx-qtd-politica-cd1112-upc = ?
           wh-qtd-politica-cd1112-upc = ?.

    ASSIGN wh-res-for-comp-cd1112-upc = ?
           wh-horiz-lib-cd1112-upc    = ?
           wh-horiz-fixo-cd1112-upc   = ?
           wh-reporte-mob-cd1112-upc  = ?
           wh-reporte-ggf-cd1112-upc  = ?.

END.

PROCEDURE pi-value-changed:
    IF l-desabilita-cd1112 THEN DO:
        ASSIGN wh-tipo-est-seg:SENSITIVE = NO.
    
        FIND FIRST item-uni-estab NO-LOCK
             WHERE ROWID(item-uni-estab) = v-row-cd1112 NO-ERROR.
        
        IF AVAIL item-uni-estab THEN DO:
            ASSIGN wh-tipo-est-seg:SCREEN-VALUE = string(item-uni-estab.tipo-est-seg).
        END.
    END.
    
END PROCEDURE.

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "CONTAINER":U  THEN DO:
    /* Acertando a p†gina inicial do programa, que devido a mudaáas */
    /* em outra p†gina, a p†gina alterada est† sobrepondo a p†gina  */
    /* inicial na abertura do programa.                             */
    RUN select-page IN p-wgh-object (INPUT 3).
    RUN select-page IN p-wgh-object (INPUT 1).
END.

IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "CONTAINER"  AND 
   c-objeto     = "cd1112.w"   THEN DO:

    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object, INPUT "PAGE-SOURCE":U, OUTPUT c-folder).
    
    ASSIGN h-folder = WIDGET-HANDLE(c-folder) NO-ERROR.

    IF VALID-HANDLE(h-folder) THEN DO:
        run set-attribute-list in h-folder (INPUT "FOLDER-TAB-TYPE=1").
        run initialize-folder in h-folder.

        RUN create-folder-page IN h-folder (INPUT 5, INPUT "APS":U).
        RUN create-folder-label IN h-folder (INPUT 5, INPUT "APS":U).

        RUN select-page IN p-wgh-object (INPUT 5).

        RUN init-object IN p-wgh-object (INPUT "upc/cd1112-upcv.w":U, 
                                         INPUT p-wgh-frame:FRAME,
                                         INPUT "Layout = ":U,
                                         OUTPUT h-viewer-1).

        RUN set-position IN h-viewer-1 ( 7.70, 3.00).
        
        RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                               INPUT "CONTAINER-TARGET":U,
                                               OUTPUT c-objects).

      DO i-objects = 1 TO num-entries(c-objects):
          ASSIGN h-object = widget-handle(entry(i-objects, c-objects)).

          IF INDEX(h-object:private-data, "q01in684") <> 0 AND  /* query principal */
             NOT l-record-1 THEN DO:
             ASSIGN l-record-1 = yes.
         
             RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                             INPUT "Record":U,
                                             INPUT h-viewer-1).
          END.
         
          IF INDEX(h-object:private-data, "v05in684") <> 0 AND /* viewer principal */
             NOT l-group-assign-1 THEN DO:
             ASSIGN l-group-assign-1 = yes.

             RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                             INPUT "Group-Assign":U,
                                             INPUT h-viewer-1).
          END.
         
          IF INDEX(h-object:private-data, "p-cadsi2") <> 0 AND /* botoes comandos */
             NOT l-state-1 THEN DO:
             
              ASSIGN l-state-1 = yes. 
         
             RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                             INPUT "State":U,
                                             INPUT h-viewer-1).
          END. 
      END.  
      RUN dispatch IN h-viewer-1 ("initialize":U).
      RUN init-pages IN THIS-PROCEDURE ('1') NO-ERROR.
      RUN select-page IN p-wgh-object (INPUT 1).
    END.
END.




