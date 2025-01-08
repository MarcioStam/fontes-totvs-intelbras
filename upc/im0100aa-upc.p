/*------------------------------------------------------------------------
    File        : IM0100AA-UPC.P
    Purpose     : Tipo Nacionaliza‡Æo
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Agosto de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE wh-rs-tp-nacionaliz-im0100aa AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-rs-tp-nacionaliz-im0100aa  AS INTEGER       NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

/* MESSAGE "EVENTO: ":U   p-ind-event      SKIP */
/*         "OBJETO: ":U   p-ind-object     SKIP */
/*         "NOME OBJ: ":U c-objeto         SKIP */
/*         "FRAME: ":U    p-wgh-frame:NAME SKIP */
/*         "TABELA: ":U   p-cod-table      SKIP */
/*         "ROWID: ":U    STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.       */

IF p-ind-event  = "AFTER-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U        THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
            IF h-frame:NAME = "rs-tp-nacionaliz":U THEN DO:
                ASSIGN wh-rs-tp-nacionaliz-im0100aa = h-frame.
                LEAVE.
            END.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.
END.

IF p-ind-event  = "BEFORE-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U                THEN DO:
    ASSIGN i-rs-tp-nacionaliz-im0100aa = INTEGER(wh-rs-tp-nacionaliz-im0100aa:SCREEN-VALUE) NO-ERROR.
END.

