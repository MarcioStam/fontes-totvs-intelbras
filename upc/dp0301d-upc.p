/***********************************************************************
**  Programa..: UPC\CP0301-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
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

DEF VAR h-object  AS HANDLE          NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-executar        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-button             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-cancela         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-seq-new            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-var-estrutura  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-proces-item        AS ROWID         NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*************************************************
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*************************************************/    

IF p-ind-event  = "BEFORE-INITIALIZE" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            /*
            MESSAGE h-object:NAME
                VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
            CASE h-object:NAME:
                WHEN 'bt-cancela'           THEN ASSIGN wh-bt-cancela        = h-object.
                WHEN 'bt-OK'                THEN ASSIGN wh-bt-executar       = h-object.
                WHEN 'i-seq-new'            THEN ASSIGN wh-seq-new           = h-object.
                WHEN 'i-num-var-estrutura'  THEN ASSIGN wh-num-var-estrutura = h-object.
            END CASE.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
    /*
    IF VALID-HANDLE(wh-bt-executar) THEN DO:

        CREATE BUTTON wh-button
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-bt-executar:WIDTH
               HEIGHT       = wh-bt-executar:HEIGHT
               ROW          = wh-bt-executar:ROW
               LABEL        = wh-bt-executar:LABEL
               COLUMN       = wh-bt-executar:COLUMN
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = wh-bt-executar:TOOLTIP
               HELP         = wh-bt-executar:HELP
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/dp0301d-upca.p.
               END TRIGGERS.
        wh-button:MOVE-TO-TOP().
    END.
    */
END.

IF VALID-HANDLE(wh-bt-executar) THEN 
    ON 'choose':U OF wh-bt-executar PERSISTENT RUN upc/dp0301d-upca.p.

