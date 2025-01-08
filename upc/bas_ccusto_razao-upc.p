/* -------------------------------------------------------------------------------------------------------------
Programa : upc/bas_ccusto_razao-upc.p
Funcao   : UPC criada para mostrar os movimentos de estoque
Autor    : Anderson Silvano - Gestech
Data     : 12/2004
Alteraá∆o:
Vers∆o   : 001
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS RECID            NO-UNDO.

DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.

DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod_cta_ctbl AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod_ccusto   AS WIDGET-HANDLE    NO-UNDO.


DEF NEW GLOBAL SHARED VAR d-data-ini AS DATE FORMAT "99/99/9999".
DEF NEW GLOBAL SHARED VAR d-data-fim AS DATE FORMAT "99/99/9999".

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").


IF p-ind-event = "INITIALIZE" AND 
   p-ind-object = "VIEWER" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'cod_cta_ctbl' THEN DO:
                ASSIGN wh-cod_cta_ctbl = h-object.
            END. 
            IF h-object:NAME = 'cod_ccusto' THEN DO:
                ASSIGN wh-cod_ccusto = h-object.
            END. 
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN d-data-ini = DATE(MONTH(TODAY),01,YEAR(TODAY))
           d-data-fim = TODAY + 30
           d-data-fim = d-data-fim - INT(DAY(d-data-fim)).

    CREATE BUTTON wh-button
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 4
           HEIGHT       = 1.13
           ROW          = 1.13
           LABEL        = "Consulta Movimentos de Estoque"
           COLUMN       = 40
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Consulta Movimentos de Estoque"
           HELP         = "Consulta Movimentos de Estoque" 
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc/bas_ccusto_razao-upca.p.
           END TRIGGERS.

    wh-button:LOAD-IMAGE ( 'image/im-brows.bmp' ).
    wh-button:MOVE-TO-TOP().
               
END.

/*
MESSAGE 
p-ind-event  SKIP
p-ind-object SKIP
string(p-wgh-object) SKIP
STRING(p-row-table)  SKIP
STRING(p-wgh-frame)  SKIP
p-cod-table SKIP
c-objeto VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
