/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/
/*
{utp/ut-glob.i}
*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE VARIABLE wgh-f-embarq AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button-im0100             AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-executar-im0100        AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-im0100              AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-docto-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-emitente-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0100        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-fisc-im0100   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-cotacao-im0100       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-di-im0100            AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lbl-data-cotacao-im0100   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lbl-data-di-im0100        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cdesc-tot-im0100          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-icms-diferido-im0100      AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-decl-imp-im0100           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btconferencia-im0100      AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btconferencia-new-im0100  AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-cancelar-im0100        AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btPesosImpostos-im0100    AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-tipo-im0100            AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-rs-tp-nacionaliz-im0100aa  AS INTEGER          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btpesoscubagem-im0100     AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btpesoscubagem-new-im0100 AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btimpostos-im0100         AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ajuda-im0100           AS WIDGET-HANDLE    NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

/* MESSAGE "EVENTO: ":U   p-ind-event  SKIP     */
/*         "OBJETO: ":U   p-ind-object SKIP     */
/*         "NOME OBJ: ":U c-objeto     SKIP     */
/*         "FRAME: ":U    p-wgh-frame:NAME SKIP */
/*         "TABELA: ":U   p-cod-table  SKIP     */
/*         "ROWID: ":U    STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.       */

IF  p-ind-event  = "INITIALIZE"
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'bt-executar' THEN
                ASSIGN wh-bt-executar-im0100 = h-object.
            IF h-object:NAME = 'btconferencia' THEN
                ASSIGN wh-btconferencia-im0100 = h-object.
            IF h-object:NAME = 'bt-cancelar' THEN
                ASSIGN wh-bt-cancelar-im0100 = h-object.
            IF h-object:NAME = 'btPesosImpostos' THEN
                ASSIGN wh-btPesosImpostos-im0100 = h-object.
            IF h-object:NAME = 'bt-tipo' THEN
                ASSIGN wh-bt-tipo-im0100 = h-object.
            IF h-object:NAME = 'btpesoscubagem' THEN
                ASSIGN wh-btpesoscubagem-im0100 = h-object.
            IF h-object:NAME = 'btimpostos' THEN
                ASSIGN wh-btimpostos-im0100 = h-object.
            IF h-object:NAME = 'bt-ajuda' THEN
                ASSIGN wh-bt-ajuda-im0100 = h-object.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-bt-executar-im0100) THEN DO:

        CREATE BUTTON wh-button-im0100
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-bt-executar-im0100:WIDTH
               HEIGHT       = wh-bt-executar-im0100:HEIGHT
               ROW          = wh-bt-executar-im0100:ROW
               LABEL        = wh-bt-executar-im0100:LABEL
               COLUMN       = wh-bt-executar-im0100:COLUMN
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = wh-bt-executar-im0100:TOOLTIP
               HELP         = wh-bt-executar-im0100:HELP 
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/im0100-upca.p.
               END TRIGGERS.

        wh-button-im0100:MOVE-TO-TOP().
        wh-bt-executar-im0100:SENSITIVE = NO.
        wh-bt-executar-im0100:HIDDEN = YES.
        wh-bt-executar-im0100:TAB-STOP = NO.
    END.

    IF VALID-HANDLE(wh-btconferencia-im0100) THEN DO:

        CREATE BUTTON wh-btconferencia-new-im0100
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-btconferencia-im0100:WIDTH
               HEIGHT       = wh-btconferencia-im0100:HEIGHT
               ROW          = wh-btconferencia-im0100:ROW
               LABEL        = wh-btconferencia-im0100:LABEL
               COLUMN       = wh-btconferencia-im0100:COLUMN
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = wh-btconferencia-im0100:TOOLTIP
               HELP         = wh-btconferencia-im0100:HELP 
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/im0100-upcc.p.
               END TRIGGERS.

        wh-btconferencia-new-im0100:MOVE-TO-TOP().
        wh-btconferencia-im0100:SENSITIVE = NO.
        wh-btconferencia-im0100:HIDDEN = YES.
        wh-btconferencia-im0100:TAB-STOP = NO.
    END.

    IF VALID-HANDLE(wh-btpesoscubagem-im0100) THEN DO:

        CREATE BUTTON wh-btpesoscubagem-new-im0100
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-btpesoscubagem-im0100:WIDTH
               HEIGHT       = wh-btpesoscubagem-im0100:HEIGHT
               ROW          = wh-btpesoscubagem-im0100:ROW
               LABEL        = wh-btpesoscubagem-im0100:LABEL
               COLUMN       = wh-btpesoscubagem-im0100:COLUMN
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = wh-btpesoscubagem-im0100:TOOLTIP
               HELP         = wh-btpesoscubagem-im0100:HELP 
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/im0100-upcd.p.
               END TRIGGERS.

        wh-btpesoscubagem-new-im0100:MOVE-TO-TOP().
        wh-btpesoscubagem-im0100:SENSITIVE = NO.
        wh-btpesoscubagem-im0100:HIDDEN = YES.
        wh-btpesoscubagem-im0100:TAB-STOP = NO.
    END.

    wh-button-im0100:PARENT:FIRST-TAB-ITEM = wh-button-im0100.
    wh-bt-cancelar-im0100:MOVE-AFTER-TAB-ITEM(wh-button-im0100).
    wh-btpesoscubagem-new-im0100:MOVE-AFTER-TAB-ITEM(wh-bt-cancelar-im0100).
    wh-btimpostos-im0100:MOVE-AFTER-TAB-ITEM(wh-btpesoscubagem-new-im0100).
    wh-btconferencia-new-im0100:MOVE-AFTER-TAB-ITEM(wh-btimpostos-im0100).
    wh-bt-tipo-im0100:MOVE-AFTER-TAB-ITEM(wh-btconferencia-new-im0100).
    wh-bt-ajuda-im0100:MOVE-AFTER-TAB-ITEM(wh-bt-tipo-im0100).
    wh-bt-ajuda-im0100:PARENT:LAST-TAB-ITEM = wh-bt-ajuda-im0100.
    
END.

IF  p-ind-event  = "AFTER-INITIALIZE"
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-object = p-wgh-frame:PREV-SIBLING.
    ASSIGN h-object = h-object:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "FIELD-GROUP":U THEN DO:
            IF h-object:NAME = "f-embarq":U THEN DO:
                ASSIGN wgh-f-embarq = h-object.
                LEAVE.
            END.

            ASSIGN h-object = h-object:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-object = h-object:FIRST-CHILD.
    END.

    ASSIGN h-object = wgh-f-embarq:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            CASE h-object:NAME:
                WHEN 'cserie'            THEN ASSIGN wh-serie-im0100            = h-object.
                WHEN 'cnr-docto'         THEN ASSIGN wh-nr-docto-im0100         = h-object.
                WHEN 'ccod-emitente'     THEN ASSIGN wh-cod-emitente-im0100     = h-object.
                WHEN 'cnatureza'         THEN ASSIGN wh-natureza-im0100         = h-object.
                WHEN 'cembarque'         THEN ASSIGN wh-embarque-im0100         = h-object.
                WHEN 'ccod-estabel'      THEN ASSIGN wh-cod-estabel-im0100      = h-object.
                WHEN 'ccod-estabel-fisc' THEN ASSIGN wh-cod-estabel-fisc-im0100 = h-object.
                WHEN 'ddata-cotacao'     THEN ASSIGN wh-data-cotacao-im0100     = h-object.
                WHEN 'cdesc-tot'         THEN ASSIGN wh-cdesc-tot-im0100        = h-object.
                WHEN 'ddata-di'          THEN ASSIGN wh-data-di-im0100          = h-object.
                WHEN 'licms-diferido'    THEN ASSIGN wh-icms-diferido-im0100    = h-object.
                WHEN 'ccod-decl-imp'     THEN ASSIGN wh-decl-imp-im0100         = h-object.
            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE 
            ASSIGN h-object = h-object:FIRST-CHILD NO-ERROR.
    END.
    
    wh-data-di-im0100:MOVE-AFTER-TAB-ITEM(wh-cdesc-tot-im0100).
    wh-data-cotacao-im0100:MOVE-AFTER-TAB-ITEM(wh-data-di-im0100).

    ASSIGN wh-lbl-data-di-im0100      = wh-data-di-im0100:SIDE-LABEL-HANDLE 
           wh-lbl-data-cotacao-im0100 = wh-data-cotacao-im0100:SIDE-LABEL-HANDLE.

    ASSIGN wh-data-di-im0100:COL          = 37
           wh-data-cotacao-im0100:COL     = 62
           wh-lbl-data-di-im0100:COL      = 31
           wh-lbl-data-cotacao-im0100:COL = 47.

END.

IF  VALID-HANDLE(wh-data-di-im0100)
AND VALID-HANDLE(wh-data-cotacao-im0100) THEN 
    ON 'leave':U OF wh-data-di-im0100 PERSISTENT RUN upc\im0100-upcb.p (1).

IF  VALID-HANDLE(wh-embarque-im0100) 
AND VALID-HANDLE(wh-nr-docto-im0100) THEN
    ON 'entry':U OF wh-nr-docto-im0100 PERSISTENT RUN upc\im0100-upcb.p (2).

IF  VALID-HANDLE(wh-icms-diferido-im0100) 
AND VALID-HANDLE(wh-natureza-im0100) THEN
    ON 'leave':U OF wh-natureza-im0100 PERSISTENT RUN upc\im0100-upcb.p (3).

IF  VALID-HANDLE(wh-serie-im0100) 
AND VALID-HANDLE(wh-cod-estabel-im0100) THEN DO:
    ON 'leave':U OF wh-cod-estabel-im0100 PERSISTENT RUN upc\im0100-upcb.p (4).
END.






