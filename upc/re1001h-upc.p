/***********************************************************************
**  Programa..: upc\re1001-upc.p
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

DEFINE NEW GLOBAL SHARED VARIABLE wh-Page1        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-Page2        AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btItens      AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btAddSon     AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDeleteSon  AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btUpdateSon  AS WIDGET-HANDLE    NO-UNDO.
/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.  */

IF  p-ind-event  = "AFTER-INITIALIZE"
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'fPage1' THEN 
                ASSIGN wh-Page1 = h-object.
            IF h-object:NAME = 'fPage2' THEN 
                ASSIGN wh-Page2 = h-object.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-object = wh-Page1:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = "bt-Itens" THEN DO:
                ASSIGN wh-btItens = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN wh-btItens:LABEL = "&Itens".

    ASSIGN h-object = wh-Page2:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            CASE h-object:NAME:
                WHEN "btUpdateSon2" THEN ASSIGN wh-btUpdateSon  = h-object.
                WHEN "btAddSon2"    THEN ASSIGN wh-btAddSon     = h-object.
                WHEN "btDeleteSon2" THEN ASSIGN wh-btDeleteSon  = h-object.
            END CASE.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN wh-btUpdateSon:LABEL = "&" + wh-btUpdateSon:LABEL
           wh-btAddSon:LABEL    = "&" + wh-btAddSon:LABEL
           wh-btDeleteSon:LABEL = "&" + wh-btDeleteSon:LABEL.
END.
