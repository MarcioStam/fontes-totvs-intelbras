/***********************************************************************
**
**  EPC re1001a1
**  
************************************************************************/
{utp\ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/*DEFINE NEW GLOBAL SHARED VARIABLE i-num-autentic  as integer format 999999.*/
DEF NEW GLOBAL SHARED VAR wh-fi-unico     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fi-pma       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fi-pmd       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-unico        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-pma          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-pmd          AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-it-codigo     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-refer     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-inival     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-quant-min     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-preco-min-fob AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-tb-preco     AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-preco-item   AS ROWID NO-UNDO.

DEF VAR h-frame AS HANDLE NO-UNDO.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

/*assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").*/
/*
MESSAGE p-ind-object
        p-ind-event
        STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */

if  p-ind-object = "CONTAINER"   THEN DO:
    IF  p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-object = h-object:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-object):
            IF h-object:TYPE <> "field-group" THEN DO:
                CASE h-object:NAME:
                    WHEN "it-codigo" THEN ASSIGN wh-it-codigo = h-object.
                    WHEN "cod-refer" THEN ASSIGN wh-cod-refer = h-object.
                    WHEN "dt-inival" THEN ASSIGN wh-dt-inival = h-object.
                    WHEN "quant-min" THEN ASSIGN wh-quant-min = h-object.
                    WHEN "preco-min-fob" THEN ASSIGN wh-preco-min-fob = h-object.
                END CASE.
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        CREATE TEXT tx-unico
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(10)"
               WIDTH        = 15
               SCREEN-VALUE = "Pr.Único:"
               ROW          = 7.6
               COL          = 70
               VISIBLE      = YES.
         
        CREATE FILL-IN wh-fi-Unico
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.99" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 7.4
               COL               = 76.5
               VISIBLE           = YES
               SENSITIVE         = YES.

        IF  VALID-HANDLE(wh-fi-unico)   AND VALID-HANDLE(tx-unico) THEN DO:
            ASSIGN wh-fi-unico:SCREEN-VALUE  = "0,00". 
        END.
        
        CREATE TEXT tx-pma
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(10)"
               WIDTH        = 15
               SCREEN-VALUE = "      PMA:"
               ROW          = 8.6
               COL          = 70
               VISIBLE      = YES.
         
        CREATE FILL-IN wh-fi-pma
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.99" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 8.4
               COL               = 76.5
               VISIBLE           = YES
               SENSITIVE         = YES.

        IF  VALID-HANDLE(wh-fi-pma)   AND VALID-HANDLE(tx-pma) THEN DO:
            ASSIGN wh-fi-pma:SCREEN-VALUE  = "0,00". 
        END.
        CREATE TEXT tx-pmd
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(10)"
               WIDTH        = 15
               SCREEN-VALUE = "     PMD:"
               ROW          = 9.6
               COL          = 70
               VISIBLE      = YES.
         
        CREATE FILL-IN wh-fi-pmd
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.99" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 9.4
               COL               = 76.5
               VISIBLE           = YES
               SENSITIVE         = YES.

        IF  VALID-HANDLE(wh-fi-pmd)   AND VALID-HANDLE(tx-pmd) THEN DO:
            ASSIGN wh-fi-pmd:SCREEN-VALUE  = "0,00". 
        END.

        IF VALID-HANDLE(wh-preco-min-fob) THEN
            wh-fi-unico:MOVE-AFTER-TAB-ITEM(wh-preco-min-fob).

        IF VALID-HANDLE(wh-fi-unico) THEN
            wh-fi-pma:MOVE-AFTER-TAB-ITEM(wh-fi-unico).
            
        IF VALID-HANDLE(wh-fi-pma) THEN
            wh-fi-pmd:MOVE-AFTER-TAB-ITEM(wh-fi-pma).
    END.
    ELSE IF p-ind-event = "AFTER-ASSIGN"  THEN DO:
        IF p-row-table = ? THEN DO:  /* Na inclusão o valor da p-row-table está vindo como ? */

            FIND FIRST tb-preco NO-LOCK
                WHERE ROWID(tb-preco) = gr-tb-preco NO-ERROR.
            IF AVAIL tb-preco THEN DO: 

                FIND FIRST int-preco-item OF preco-item 
                    WHERE int-preco-item.it-codigo = wh-it-codigo:SCREEN-VALUE 
                    AND   int-preco-item.cod-refer = wh-cod-refer:SCREEN-VALUE 
                    AND   int-preco-item.nr-tabpre = tb-preco.nr-tabpre
                    AND   int-preco-item.dt-inival = DATE(wh-dt-inival:SCREEN-VALUE)
                    AND   int-preco-item.quant-min = DEC(wh-quant-min:SCREEN-VALUE) EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL int-preco-item THEN DO:
                   CREATE int-preco-item.
                   ASSIGN int-preco-item.it-codigo  = wh-it-codigo:SCREEN-VALUE 
                          int-preco-item.cod-refer  = wh-cod-refer:SCREEN-VALUE
                          int-preco-item.nr-tabpre  = tb-preco.nr-tabpre 
                          int-preco-item.dt-inival  = DATE(wh-dt-inival:SCREEN-VALUE) 
                          int-preco-item.quant-min  = DEC(wh-quant-min:SCREEN-VALUE). 
                END.
                ASSIGN int-preco-item.preco-unico = DEC(wh-fi-unico:SCREEN-VALUE)
                       int-preco-item.pma         = DEC(wh-fi-pma:SCREEN-VALUE)
                       int-preco-item.pmd         = DEC(wh-fi-pmd:SCREEN-VALUE).
            END.
        END.
        ELSE DO:
            FOR FIRST preco-item NO-LOCK
                WHERE ROWID(preco-item) = p-row-table:

                FIND FIRST int-preco-item OF preco-item EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL int-preco-item THEN DO:
                   CREATE int-preco-item.
                   ASSIGN int-preco-item.it-codigo  = preco-item.it-codigo 
                          int-preco-item.cod-refer  = preco-item.cod-refer
                          int-preco-item.nr-tabpre  = preco-item.nr-tabpre 
                          int-preco-item.dt-inival  = preco-item.dt-inival 
                          int-preco-item.quant-min  = preco-item.quant-min. 
                END.

                ASSIGN int-preco-item.preco-unico = DEC(wh-fi-unico:SCREEN-VALUE)
                       int-preco-item.pma         = DEC(wh-fi-pma:SCREEN-VALUE)
                       int-preco-item.pmd         = DEC(wh-fi-pmd:SCREEN-VALUE).
            END.
        END.
   END.
    IF  p-ind-event = "AFTER-DISPLAY" THEN
    DO:
        FOR FIRST preco-item NO-LOCK
            WHERE ROWID(preco-item) = p-row-table:
            FIND FIRST int-preco-item OF preco-item NO-LOCK NO-ERROR.
            IF AVAIL INT-PRECO-ITEM AND VALID-HANDLE(wh-fi-unico) THEN
               ASSIGN wh-fi-unico:SCREEN-VALUE = string(int-preco-item.preco-unico,">>>,>>9.99")
                      wh-fi-pma:SCREEN-VALUE = string(int-preco-item.pma,">>>,>>9.99")
                      wh-fi-pmd:SCREEN-VALUE = string(int-preco-item.pmd,">>>,>>9.99").
        END.
    END.
END.
