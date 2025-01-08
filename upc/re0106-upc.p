/***********************************************************************
**  Programa..: upc\re0106-upc.p
**  Autor.....: Gustavo Eduardo Tamanini - SQL WORKS
**  Data......: Junho/2010
**  Descricao.: 
**  Vers∆o....: 001 18/06/2010 - Gustavo Eduardo Tamanini
**                  Desenvolvimento Programa
************************************************************************/
DEF INPUT PARAM p-ind-event        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object       AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object       AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table        AS ROWID         NO-UNDO.

DEF VAR c-objeto    AS CHAR     NO-UNDO.
DEF VAR l-ok        AS LOGICAL  NO-UNDO.
DEF VAR h-frame     AS HANDLE   NO-UNDO.
DEF VAR h-fpage3    AS HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-val-unit-pis-re0106    AS WIDGET-HANDLE NO-UNDO.      
DEF NEW GLOBAL SHARED VAR wh-val-unit-cofins-re0106 AS WIDGET-HANDLE NO-UNDO.      
DEF NEW GLOBAL SHARED VAR wh-vol-pis-imp-re0106     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vol-cofins-imp-re0106  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-unit-pis-re0106        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-unit-cofins-re0106     AS WIDGET-HANDLE NO-UNDO.

/*
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/").
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

MESSAGE "Evento: ":U p-ind-event         SKIP
        "Objeto: ":U p-ind-object        SKIP
        "Tabela: ":U p-cod-table         SKIP
        "Rowid: ":U  STRING(p-row-table) SKIP
        "Objeto: ":U c-objeto            
    VIEW-AS ALERT-BOX.
*/

IF p-ind-event = "BEFORE-INITIALIZE":U AND p-ind-object = "CONTAINER":U THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:           
            CASE h-frame:NAME:
                WHEN "fPage3":U THEN ASSIGN h-fpage3 = h-frame.                
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage3 = h-fpage3:FIRST-CHILD.
    ASSIGN h-fpage3 = h-fpage3:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage3):
        IF h-fpage3:TYPE <> "field-group" THEN DO:
            CASE h-fpage3:NAME:
                WHEN "d-val-unit-pis":U            THEN ASSIGN wh-val-unit-pis-re0106    = h-fpage3.                
                WHEN "d-val-unit-cofins":U         THEN ASSIGN wh-val-unit-cofins-re0106 = h-fpage3.
                WHEN "d-val-unit-vol-pis-imp":U    THEN ASSIGN wh-vol-pis-imp-re0106     = h-fpage3.                
                WHEN "d-val-unit-vol-cofins-imp":U THEN ASSIGN wh-vol-cofins-imp-re0106  = h-fpage3.                
                WHEN "d-unit-pis":U                THEN ASSIGN wh-unit-pis-re0106        = h-fpage3.                
                WHEN "d-unit-confins":U             THEN ASSIGN wh-unit-cofins-re0106     = h-fpage3.                
            END CASE.                                                                    
            ASSIGN h-fpage3 = h-fpage3:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
END.

IF p-ind-event = "AFTER-UPDATE":U AND p-ind-object = "CONTAINER":U THEN DO:
    /* PIS */
    IF  VALID-HANDLE(wh-val-unit-pis-re0106) THEN
        ASSIGN wh-val-unit-pis-re0106:SCREEN-VALUE = "0,00000"
               wh-val-unit-pis-re0106:SENSITIVE    = NO.

    /* COFINS */
    IF  VALID-HANDLE(wh-val-unit-cofins-re0106) THEN
        ASSIGN wh-val-unit-cofins-re0106:SCREEN-VALUE = "0,00000"
               wh-val-unit-cofins-re0106:SENSITIVE    = NO.

    /* PIS Importacao */
    IF  VALID-HANDLE(wh-vol-pis-imp-re0106) THEN
        ASSIGN wh-vol-pis-imp-re0106:SCREEN-VALUE = "0,00000"
               wh-vol-pis-imp-re0106:SENSITIVE    = NO.               

    /* COFINS Importacao */
    IF  VALID-HANDLE(wh-vol-cofins-imp-re0106) THEN
        ASSIGN wh-vol-cofins-imp-re0106:SCREEN-VALUE = "0,00000"
               wh-vol-cofins-imp-re0106:SENSITIVE    = NO.         

/* Base Unit Pis Subst */
    IF  VALID-HANDLE(wh-unit-pis-re0106) THEN
        ASSIGN wh-unit-pis-re0106:SCREEN-VALUE = "0,00000"
               wh-unit-pis-re0106:SENSITIVE    = NO.         

/* Base Unit Cofins Subst */
    IF  VALID-HANDLE(wh-unit-cofins-re0106) THEN
        ASSIGN wh-unit-cofins-re0106:SCREEN-VALUE = "0,00000"
               wh-unit-cofins-re0106:SENSITIVE    = NO.  

END.
