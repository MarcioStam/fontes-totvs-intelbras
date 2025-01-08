/***********************************************************************
**  Programa..: upc\re1001b2-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
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

DEF VAR h-fpage1   AS HANDLE   NO-UNDO.
DEF VAR h-frame1   AS HANDLE   NO-UNDO.
DEF VAR h-fpage2   AS HANDLE   NO-UNDO.
DEF VAR h-frame2   AS HANDLE   NO-UNDO.
DEF VAR h-fpage4   AS HANDLE   NO-UNDO.
DEF VAR h-frame4   AS HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-class-fiscal       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-ord-produ       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-aliquota-ipi       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-aliquota-icm       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btCheck            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-class-fiscal  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-natur-oper         AS ROWID         NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").
/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF  p-ind-event  = "BEFORE-DISPLAY" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'fPage1' THEN 
                ASSIGN h-fpage1 = h-object
                       h-frame1 = h-object.
            IF h-object:NAME = 'fPage2' THEN 
                ASSIGN h-fpage2 = h-object
                       h-frame2 = h-object.
            IF h-object:NAME = 'fPage4' THEN 
                ASSIGN h-fpage4 = h-object
                       h-frame4 = h-object.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.
    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage1):
        IF h-fpage1:TYPE <> "field-group" THEN DO:
            IF h-fpage1:NAME = 'btCheck' THEN DO: 
                ASSIGN wh-btCheck = h-fpage1.
                LEAVE.
            END.
            ASSIGN h-fpage1 = h-fpage1:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage2 = h-fpage2:FIRST-CHILD.
    ASSIGN h-fpage2 = h-fpage2:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage2):
        IF h-fpage2:TYPE <> "field-group" THEN DO:
            IF h-fpage2:NAME = 'nr-ord-produ' THEN DO: 
                ASSIGN wh-nr-ord-produ = h-fpage2.
                LEAVE.
            END.
            ASSIGN h-fpage2 = h-fpage2:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage4 = h-fpage4:FIRST-CHILD.
    ASSIGN h-fpage4 = h-fpage4:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage4):
        IF h-fpage4:TYPE <> "field-group" THEN DO:
            CASE h-fpage4:NAME:
                WHEN 'class-fiscal'         THEN ASSIGN wh-class-fiscal      = h-fpage4.
                WHEN 'aliquota-ipi'         THEN ASSIGN wh-aliquota-ipi      = h-fpage4.
                WHEN 'aliquota-icm'         THEN ASSIGN wh-aliquota-icm      = h-fpage4.
                WHEN 'c-desc-class-fiscal'  THEN ASSIGN wh-desc-class-fiscal = h-fpage4.
            END CASE.
            
            ASSIGN h-fpage4 = h-fpage4:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    FIND FIRST item-doc-est
         WHERE ROWID(item-doc-est) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL item-doc-est THEN DO:
        FIND FIRST classif-fisc NO-LOCK
            WHERE classif-fisc.class-fiscal = item-doc-est.class-fiscal NO-ERROR.
        IF AVAIL classif-fisc THEN 
            ASSIGN item-doc-est.aliquota-ipi = classif-fisc.aliquota-ipi.
        
        FIND FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao NO-ERROR.
        IF AVAIL natur-oper THEN 
            ASSIGN item-doc-est.aliquota-icm = natur-oper.aliquota-icm
                   gr-natur-oper             = ROWID(natur-oper).
    END.
    RELEASE item-doc-est.
END.

IF VALID-HANDLE(wh-class-fiscal) THEN
    ON 'leave':U OF wh-class-fiscal PERSISTENT RUN upc\re1001b2-upca.p.

IF VALID-HANDLE(wh-nr-ord-produ) THEN DO:
    ON 'F5':U OF wh-nr-ord-produ PERSISTENT RUN upc\re1001b2-upcb.p.
    ON 'MOUSE-SELECT-DBLCLICK':U OF wh-nr-ord-produ PERSISTENT RUN upc\re1001b2-upcb.p.
END.
