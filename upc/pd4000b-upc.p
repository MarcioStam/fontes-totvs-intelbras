/***********************************************************************
**  Programa..: UPC\PD4000B-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: ParÉmetros do Pedido Venda
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto    AS CHAR            NO-UNDO.
DEF VAR h-frame     AS HANDLE          NO-UNDO.
DEF VAR h-frame-1   AS HANDLE          NO-UNDO.
DEF VAR whrsTbPreco AS HANDLE          NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
/****************************  Variaveis    ****************************/
DEF NEW GLOBAL SHARED VAR whTgLimpaDesc     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtOkOrder       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtOK            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalOK       AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR vLogLimpaDesc     AS LOGICAL       NO-UNDO.
/*    RUN piMessage.*/
IF  p-ind-object  = "CONTAINER"         AND 
    c-objeto      = "PD4000B.W"         THEN DO:

    IF  p-ind-event   = "BEFORE-INITIALIZE" THEN DO:

        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-frame = h-frame:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(h-frame):
            IF  h-frame:TYPE <> "field-group" THEN DO:
                CASE h-frame:NAME:
                    WHEN "btOk"        THEN 
                        ASSIGN whBtOk = h-frame.
                    WHEN "fPage2"        THEN 
                    DO:
                        ASSIGN h-frame-1 = h-frame:FIRST-CHILD.
                        ASSIGN h-frame-1 = h-frame-1:FIRST-CHILD.
                        DO  WHILE VALID-HANDLE(h-frame-1):
                            IF  h-frame-1:TYPE <> "field-group" THEN DO:
                                CASE h-frame-1:NAME:
                                    WHEN "rs-tp-exp-tb-preco" THEN 
                                        ASSIGN whrsTbPreco = h-frame-1.
                                END.
                                ASSIGN h-frame-1 = h-frame-1:NEXT-SIBLING NO-ERROR.
                            END.
                            ELSE LEAVE.
                        END.
                    END.
                END.
                ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        IF  VALID-HANDLE(whrsTbPreco) THEN DO:
            CREATE TOGGLE-BOX whTgLimpaDesc
            ASSIGN FRAME         = whrsTbPreco:FRAME
                   WIDTH         = 15
                   HEIGHT        = 0.88
                   COL           = 32.5
                   ROW           = 11
                   VISIBLE       = YES
                   SENSITIVE     = NO
                   SCREEN-VALUE  = "YES"
                   HELP          = "Limpa Desconto Pedidos".
        END.
        
        /* Cria Bot∆o OK */
        IF  VALID-HANDLE(whBtOk) THEN DO:
            CREATE BUTTON whBtLocalOk
            ASSIGN FRAME     = whBtOk:FRAME
                   WIDTH     = whBtOk:WIDTH
                   HEIGHT    = whBtOk:HEIGHT
                   ROW       = whBtOk:ROW
                   LABEL     = whBtOk:LABEL
                   COL       = whBtOk:COL
                   SENSITIVE = whBtOk:SENSITIVE
                   VISIBLE   = whBtOk:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000b-upc1.p.
            END TRIGGERS.
        END.

        ASSIGN whTgLimpaDesc:CHECKED = vLogLimpaDesc.
    END.
    IF VALID-HANDLE(whTgLimpaDesc)  THEN
        ASSIGN whTgLimpaDesc:HIDDEN    = NO
               whTgLimpaDesc:SENSITIVE = YES
               whTgLimpaDesc:LABEL     = "Limpa Descontos".
    IF VALID-HANDLE(whBtLocalOk)  THEN
        ASSIGN whBtLocalOk:HIDDEN    = NO
               whBtLocalOk:SENSITIVE = YES.
END.

PROCEDURE piMessage:
    MESSAGE 'p-ind-event  ' p-ind-event  SKIP
            'p-ind-object ' p-ind-object SKIP
            'p-cod-table  ' p-cod-table  SKIP
            'p-row-table  ' string(p-row-table) SKIP
             c-objeto
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.
