/***********************************************************************
**  Programa..: upc/cc0311-upc.p
**  Autor.....: Anderson Hoepers
**  Data......: 15/01/2013 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 15/01/2013
**                  - Gerar flag para criaá∆o autom†tica de embarque
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

{utp/ut-glob.i}

DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-emb-cc0311 AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-log-emb-cc0311 AS LOG              NO-UNDO.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

/**********************************************************************/

IF  p-ind-event  = "initialize" AND 
    p-ind-object = "CONTAINER" 
THEN
    ASSIGN wh-tg-emb-cc0311 = ?
           v-log-emb-cc0311 = YES.

IF  p-ind-event  = "change-page" AND 
    p-ind-object = "CONTAINER" 
THEN DO:
    ASSIGN h-object = p-wgh-frame.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:

            CASE h-object:NAME:
                WHEN 'tg-gera-proc-imp' 
                THEN DO:
                    IF  wh-tg-emb-cc0311 = ?
                    THEN DO:
                        ASSIGN h-object:COL   = 26.

                        CREATE TOGGLE-BOX wh-tg-emb-cc0311
                        ASSIGN FRAME        = p-wgh-frame
                               WIDTH        = 16
                               HEIGHT       = 0.83
                               ROW          = 10.60
                               LABEL        = "Gera Embarque"
                               COLUMN       = 55
                               SENSITIVE    = YES
                               VISIBLE      = YES
                               CHECKED      = YES.
                    END.
                END.
                WHEN 'c-resp'           THEN ASSIGN h-object:SCREEN-VALUE = c-seg-usuario.
                WHEN 'i-condicao'       THEN ASSIGN h-object:SCREEN-VALUE = "1".
                WHEN 'c-importacao'     THEN ASSIGN h-object:COL   = 26.
                WHEN 'rs-frete'         THEN ASSIGN h-object:COL   = 5
                                                    h-object:WIDTH = 18.
                
                WHEN 'rect-12'          THEN ASSIGN h-object:WIDTH = 20.14.
                WHEN 'rect-14'          THEN ASSIGN h-object:COL   = 25
                                                    h-object:WIDTH = 50.
            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE
            ASSIGN h-object = h-object:FIRST-CHILD NO-ERROR.
    END.
END.

RETURN "OK".


