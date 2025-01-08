/***********************************************************************
**  Programa..: upc/ft0114-epc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
    DEF VAR hShowMsg    AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-gera-faturamento AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-gera-faturamento AS WIDGET-HANDLE NO-UNDO.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.
DEF BUFFER bf-ser-estab FOR ser-estab.

/*DEFINE VARIABLE c-char AS   CHAR.*/
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.
/*assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").*/

/***************************************
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
****************************************/

IF  p-ind-event  = "BEFORE-INITIALIZE" AND
    p-ind-object = "VIEWER" THEN DO:    
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
    
    CREATE TEXT tx-gera-faturamento
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 22
           SCREEN-VALUE = "Gera Faturamento:"
           ROW          = 3.70
           COL          = 58
           VISIBLE      = YES.

    CREATE FILL-IN wh-gera-faturamento
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "logical"
           FORMAT            = "Sim/NÆo" 
           WIDTH             = 4
           HEIGHT            = 0.88
           ROW               = 3.60
           COL               = 70.6
           VISIBLE           = YES
           SENSITIVE         = NO.
    
    IF  VALID-HANDLE(wh-gera-faturamento) AND VALID-HANDLE(tx-gera-faturamento) THEN 
        ASSIGN wh-gera-faturamento:SCREEN-VALUE  = "NÆo". 
END.

IF  p-ind-event = "before-display" AND 
    p-ind-object = "viewer" THEN DO:
    IF VALID-HANDLE(tx-gera-faturamento) THEN
        ASSIGN tx-gera-faturamento:SCREEN-VALUE = "Gera Faturamento:".

    FIND FIRST ser-estab
        WHERE ROWID(ser-estab) = p-row-table NO-ERROR.
    IF  VALID-HANDLE(wh-gera-faturamento) THEN
        ASSIGN wh-gera-faturamento:SCREEN-VALUE = if ser-estab.log-2 = yes then "Sim" else "NÆo" .
END.

IF  p-ind-event  = "AFTER-ENABLE" and
    p-ind-object = "viewer" THEN     
    ASSIGN wh-gera-faturamento:SENSITIVE = YES.
    

IF  p-ind-event  = "AFTER-DISABLE" AND 
    p-ind-object = "viewer" THEN
    ASSIGN wh-gera-faturamento:SENSITIVE = NO.


IF  p-ind-event  = "BEFORE-ASSIGN" AND
    p-ind-object = "VIEWER" THEN DO:

    FIND FIRST ser-estab
        WHERE ROWID(ser-estab) = p-row-table EXCLUSIVE NO-ERROR.
    IF AVAIL ser-estab then DO:
        IF wh-gera-faturamento:SCREEN-VALUE = "Sim" THEN DO:
            FOR EACH bf-ser-estab
               WHERE bf-ser-estab.cod-estabel = ser-estab.cod-estabel NO-LOCK:
                IF bf-ser-estab.serie = ser-estab.serie THEN NEXT.
                IF bf-ser-estab.log-2 THEN DO:
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = 1
                           RowErrors.ErrorNumber      = 17567
                           RowErrors.ErrorDescription = "Existe outra s‚rie marcada para Gerar Faturamento neste estabelecimento"
                           RowErrors.ErrorType        = "ERROR"
                           RowErrors.ErrorHelp        = "Existe outra s‚rie marcada para Gerar Faturamento neste estabelecimento".
                    IF NOT VALID-HANDLE(hShowMsg) or
                       hShowMsg:TYPE <> "PROCEDURE":U or
                       hShowMsg:FILE-NAME <> "utp/ShowMessage.w":U THEN
                            RUN utp/ShowMessage.w PERSISTENT SET hShowMsg.

                    RUN setModal IN hShowMsg (INPUT YES) NO-ERROR.
                    RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

                    RETURN "NOK".
                END.
            END.
        END.
        ASSIGN ser-estab.log-2 = If wh-gera-faturamento:SCREEN-VALUE = "Sim" then yes else No.    
    END.
END.


