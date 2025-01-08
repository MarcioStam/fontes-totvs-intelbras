/***********************************************************************
**  Programa..: upc\en0105d-upc.p
**  Autor.....: Anderson Silvano
**  Data......: OUTUBRO/2004 - Desenvolvimento
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

DEF NEW GLOBAL SHARED VAR wh-bt-executar        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-button             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-cancela         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-seq-new            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-var-estrutura  AS WIDGET-HANDLE NO-UNDO.

DEF VAR h-frame AS HANDLE   NO-UNDO.

DEF VAR c-objeto       AS CHARACTER               NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-frame:PRIVATE-DATA, "~/"), p-wgh-frame:PRIVATE-DATA, "~/").

/******************************************
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-objeto     SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*******************************************/

IF p-ind-event = "INITIALIZE" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group" THEN DO:
            /*
            MESSAGE h-frame:NAME
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
            CASE h-frame:NAME:
                WHEN 'bt-cancela'           THEN ASSIGN wh-bt-cancela        = h-frame.
                WHEN 'bt-OK'                THEN ASSIGN wh-bt-executar       = h-frame.
                WHEN 'i-seq-new'            THEN ASSIGN wh-seq-new           = h-frame.
                WHEN 'i-num-var-estrutura'  THEN ASSIGN wh-num-var-estrutura = h-frame.
            END CASE.
            
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
END.
   
IF VALID-HANDLE(wh-bt-executar) THEN 
    ON 'choose':U OF wh-bt-executar PERSISTENT RUN upc/en0105d-upca.p.
