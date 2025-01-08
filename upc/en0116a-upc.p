/***********************************************************************
**  Programa..: upc\en0116a-upc.p
**  Autor.....: Graziely Lima - iDBA
**  Data......: MARÄO/2022 - Desenvolvimento
**  Descricao.: UPC para criaá∆o da flag "N∆o considera para APS"
**  Vers∆o....: 001 
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-frame                     AS HANDLE        NO-UNDO.
DEFINE VARIABLE adm-current-page            AS INTEGER       NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vRowEstrutura  AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-folder     AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-tg-consid-aps  AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-folder AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event = "INITIALIZE" and p-ind-object = "CONTAINER" THEN 
DO:
    CREATE TOGGLE-BOX wh-tg-consid-aps
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 20
           HEIGHT       = 0.88
           ROW          = 6.9
           LABEL        = "N∆o considera para APS"
           COLUMN       = 59.5
           SENSITIVE    = YES
           VISIBLE      = YES.

END.

IF p-ind-event = "ASSIGN" THEN DO:

    FIND FIRST alternativo WHERE ROWID(alternativo) = p-row-table NO-LOCK NO-ERROR.
    
    IF AVAIL alternativo THEN DO:
        IF  VALID-HANDLE(wh-tg-consid-aps) THEN
            ASSIGN alternativo.log-1 = wh-tg-consid-aps:CHECKED.
    END.

END.

IF p-ind-event = "DISPLAY" then do:
    FIND FIRST alternativo
        WHERE ROWID(alternativo) = p-row-table NO-LOCK NO-ERROR.

    IF AVAIL alternativo THEN DO:
        IF  VALID-HANDLE(wh-tg-consid-aps) THEN
            ASSIGN wh-tg-consid-aps:CHECKED = alternativo.log-1.
    END.
END.

