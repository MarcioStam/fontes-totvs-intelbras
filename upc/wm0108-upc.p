/***********************************************************************
**  Programa..: 
**  Autor.....: 
**  Data......: 
**  Descricao.: 
**  Vers∆o....: 
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

DEFINE NEW GLOBAL SHARED VARIABLE wh-fPage4-wm0108-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cod-barras-wm0108-upc AS WIDGET-HANDLE NO-UNDO.

IF  (p-ind-event  = "AFTER-CHANGE-PAGE" OR p-ind-event  = "AFTER-UPDATE") AND p-ind-object = "CONTAINER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fPage4",
                     OUTPUT wh-fPage4-wm0108-upc).

    IF VALID-HANDLE(wh-fPage4-wm0108-upc) THEN DO:
        RUN busca-handle(INPUT wh-fPage4-wm0108-upc,
                         INPUT "c-cod-barras",
                         OUTPUT wh-c-cod-barras-wm0108-upc).

        /*
        IF VALID-HANDLE(wh-c-cod-barras-wm0108-upc) THEN
            ASSIGN wh-c-cod-barras-wm0108-upc:SENSITIVE = NO.
        */
    END.
END.


PROCEDURE busca-handle:
    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.
