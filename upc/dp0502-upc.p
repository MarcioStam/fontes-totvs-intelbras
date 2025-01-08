/***********************************************************************
**  Programa..: UPC\dp0502-UPC.P
**  Autor.....: Emerson 
**  Data......: Abril/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 29/12/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{utp\ut-glob.i}

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEF NEW GLOBAL SHARED VAR vAtualizaNfSeparada   AS LOG NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtExportaUpc       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtExportaTela      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbrowse-dp0502      AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vNrOrdProdu LIKE ord-prod.nr-ord-produ NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/* MESSAGE 'p-ind-event  ' p-ind-event  SKIP        */
/*         'p-ind-object ' p-ind-object SKIP        */
/*         'p-cod-table  ' p-cod-table  SKIP        */
/*         'p-row-table  ' string(p-row-table) SKIP */
/*         'c-objeto     ' c-objeto                 */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.           */

/****************************  Variaveis    ****************************/

IF  p-ind-event   = "AFTER-INITIALIZE" AND
    p-ind-object  = "CONTAINER"  THEN DO:
    
    ASSIGN vAtualizaNfSeparada = YES.

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.
    
    DO  WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "btExporta"        THEN 
                    ASSIGN whBtExportaTela = h-frame.
                WHEN "br-table" THEN
                    ASSIGN whbrowse-dp0502 = h-frame.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
    END.
    
    ASSIGN whBtExportaTela:SENSITIVE = NO.
    
    CREATE BUTTON whBtExportaUpc
    ASSIGN FRAME     = whBtExportaTela:FRAME
           WIDTH     = whBtExportaTela:WIDTH
           HEIGHT    = whBtExportaTela:HEIGHT
           ROW       = whBtExportaTela:ROW
           NAME      = "whBtExportaUpc":U
           LABEL     = "Parametros"
           COL       = whBtExportaTela:COL
           SENSITIVE = YES /* whBtExportaTela:SENSITIVE */
           VISIBLE   = YES /* whBtExportaTela:VISIBLE */
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN upc\dp0502-upc1.p (INPUT whbrowse-dp0502,
                                                    INPUT whBtExportaTela).
    END TRIGGERS.
    
    whBtExportaUpc:LOAD-IMAGE-UP(whBtExportaTela:IMAGE-UP).
    /* whBtExportaUpc:LOAD-IMAGE-INSENSITIVE(whBtExportaTela:IMAGE-INSENSITIVE). */
    whBtExportaUpc:MOVE-TO-TOP().
END.
 
