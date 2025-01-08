/******************************************************************************************************************************
**
**  Programa..............: CC0313-UPC
**  Nome Externo..........: upc/cc0313-upc.p
**  Descricao.............: Informa a Data de Atualiza‡Æo do Pedido
**  Criado por............: iDBA
**  Criado em.............: 25/10/2022
**
*******************************************************************************************************************************/

/* *** DEFINICAO DE PARAMETROS *** */
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER.
DEFINE INPUT PARAMETER p-row-table  AS ROWID.

DEFINE NEW GLOBAL SHARED VAR wh-log-etiqueta AS WIDGET-HANDLE NO-UNDO.

def new global shared var wgh-grupo        as widget-handle no-undo.
def new global shared var wgh-button       as widget-handle no-undo.
def new global shared var wgh-image        as widget-handle no-undo.
def new global shared var wgh-destino      as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR c-label-destino  AS WIDGET-HANDLE NO-UNDO.
def new global shared var wgh-canal        as widget-handle no-undo.
DEF VAR wh-frame-principal                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR bt-emb           AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR bt-data          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-wt-docto      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-tb-pr-cc      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-item-tab      AS ROWID         NO-UNDO.
def new global shared var wgh-window       as widget-handle no-undo.

/* *** DEFINICOES DE VARIAVEIS LOCAIS *** */

DEF VAR c-objeto  AS CHARACTER     NO-UNDO.
DEF VAR i1        AS INTEGER       NO-UNDO.
 
DEF VAR wgh-child AS WIDGET-HANDLE NO-UNDO.
DEF VAR wgh-frame AS WIDGET-HANDLE NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

assign wgh-window = p-wgh-object.

/*
IF p-ind-object = "BROWSER" THEN
    MESSAGE "   EVENTO " p-ind-event            SKIP
            "   OBJETO " p-ind-object           SKIP
            "FILE-NAME " p-wgh-object:FILE-NAME SKIP
            "    FRAME " p-wgh-frame            SKIP
            "   TABELA " p-cod-table            SKIP
            "    ROWID " STRING(p-row-table)
            VIEW-AS ALERT-BOX.
*/

if  p-ind-object = "BROWSER" 
AND p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    CREATE BUTTON bt-data
    ASSIGN FRAME     = p-wgh-frame 
           ROW       = 7
           COLUMN    = 42.2
           HEIGHT    = 1
           WIDTH     = 10.3
           TOOLTIP   = "Atualiza‡Æo dos Pedidos"
           HELP      = ""
           LABEL     = "Atualiza‡Æo"
           VISIBLE   = TRUE.
    //bt-data:LOAD-IMAGE("image\toolbar\im-calen.bmp").
    //bt-data:LOAD-IMAGE-INSENSITIVE("image\toolbar\ii-calen.bmp").
    bt-data:MOVE-TO-TOP().
    bt-data:SENSITIVE = YES.     
    ON 'choose' OF bt-data PERSISTENT
        RUN esp/ccp/esccp047.w.    

END. 

IF (p-ind-event  = "VALUE-CHANGED" 
OR  p-ind-event  = "AFTER-OPEN-QUERY")
AND p-ind-object = "BROWSER" THEN DO:
    
    IF  p-cod-table = "item-tab"
    AND p-row-table <> ? THEN DO:
        FIND item-tab NO-LOCK
            WHERE ROWID (item-tab) = p-row-table NO-ERROR.
        IF AVAIL item-tab THEN DO:
            FIND tb-pr-cc NO-LOCK
                WHERE ROWID (tb-pr-cc) = gr-tb-pr-cc NO-ERROR.
            IF AVAIL tb-pr-cc AND tb-pr-cc.nr-tab = item-tab.nr-tab THEN
                ASSIGN bt-data:SENSITIVE = YES
                       gr-item-tab = p-row-table.
            ELSE
                ASSIGN bt-data:SENSITIVE = NO
                       gr-item-tab = ?.
        END.        
    END.
    ELSE
        ASSIGN bt-data:SENSITIVE = NO
               gr-item-tab = ?.

END.

IF  p-ind-event  = "DESTROY"
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN gr-item-tab = ?.

END.
