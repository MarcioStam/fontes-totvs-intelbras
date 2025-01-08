/***********************************************************************
**  Programa..: UPC\CD1406-UPC.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: Setembro/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 04/10/2005
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*
MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table skip
        "row-table" STRING(p-row-table) VIEW-AS ALERT-BOX. 
*/



/****************************  Variaveis    ****************************/

DEF NEW GLOBAL SHARED VAR whBtEstrut     AS   WIDGET-HANDLE    NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFrame        AS   WIDGET-HANDLE    NO-UNDO.
DEF NEW GLOBAL SHARED VAR whQuery        AS   WIDGET-HANDLE    NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBrowse       AS   HANDLE           NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtEliminar   AS   WIDGET-HANDLE    NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario  AS   CHAR             NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-requisicao  AS   ROWID            NO-UNDO.

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS   HANDLE           NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-link         AS   CHAR             NO-UNDO.

IF  p-ind-object  = "CONTAINER"
AND P-ind-event   = "INITIALIZE"    THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            RUN get-link-handle IN adm-broker-hdl (p-wgh-object, "STATE-SOURCE", OUTPUT c-link).
            ASSIGN whFrame = WIDGET-HANDLE(c-link).
            RUN get-link-handle IN adm-broker-hdl (whFrame, "STATE-TARGET", OUTPUT c-link).
            ASSIGN whQuery = WIDGET-HANDLE(ENTRY(2,c-link)).
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
END.

IF  p-ind-object  = "BROWSER"
AND P-ind-event   = "INITIALIZE"
AND c-objeto      = "cd1406-b01.w"  THEN DO:

    ASSIGN whFrame = p-wgh-frame.

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "bt-eliminar" THEN ASSIGN whBtEliminar = h-frame.
                WHEN "br-table"    THEN ASSIGN whBrowse     = h-frame.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
    
    CREATE BUTTON whBtEstrut
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = whBtEliminar:WIDTH
           HEIGHT       = whBtEliminar:HEIGHT
           ROW          = whBtEliminar:ROW
           LABEL        = "&Estrutura"
           COLUMN       = whBtEliminar:COLUMN + whBtEliminar:WIDTH
           SENSITIVE    = YES
           VISIBLE      = YES
           FONT         = whBtEliminar:FONT
           TOOLTIP      = "Inclus∆o de Estrutura"
           HELP         = "Inclus∆o de Estrutura"
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc/cd1406-upca.p.
           END TRIGGERS.
          
END.


