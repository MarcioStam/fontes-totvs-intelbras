/***********************************************************************
**  Programa..: upc\re1001b1-upcc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF INPUT PARAM p-acao AS INT NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-cod-depos      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-classific-fisc AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-deposito       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-classific      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-depos     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-class     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ord-produ      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-ord-produ   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-localiz    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fifo           AS WIDGET-HANDLE NO-UNDO.
def new global shared var gs-re1001b1-fifo  as logical       no-undo.
def new global shared var wh-un             as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-num-pedido     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo      AS WIDGET-HANDLE NO-UNDO.

def new global shared var c-it-codigo-old  as CHARACTER no-undo.

if valid-handle(wh-fifo) then wh-fifo:checked = gs-re1001b1-fifo.
if valid-handle(wh-un) then wh-un:hidden = no.

CASE p-acao:
    WHEN 1 THEN DO: 
        ASSIGN wh-deposito:SCREEN-VALUE     = wh-cod-depos:SCREEN-VALUE.
        FIND FIRST deposito NO-LOCK
            WHERE deposito.cod-depos = wh-cod-depos:SCREEN-VALUE NO-ERROR.
        ASSIGN wh-desc-depos:SCREEN-VALUE = IF AVAIL deposito THEN deposito.nome ELSE "".
    END.
    WHEN 2 THEN DO: 
        ASSIGN wh-cod-depos:SCREEN-VALUE      = wh-deposito:SCREEN-VALUE.
    END.
    WHEN 3 THEN DO:
        IF wh-classific-fisc:SCREEN-VALUE = "    .  .  " THEN
            ASSIGN wh-classific-fisc:FORMAT = "x(8)"
                   wh-classific:FORMAT    = "x(8)". 
        ELSE
            ASSIGN wh-classific-fisc:FORMAT = "XXXX.XX.XX"
                   wh-classific:FORMAT    = "XXXX.XX.XX". 
        ASSIGN wh-classific:SCREEN-VALUE      = wh-classific-fisc:SCREEN-VALUE.
    END.
    WHEN 4 THEN DO: 
        IF wh-classific:SCREEN-VALUE = "    .  .  " THEN
            ASSIGN wh-classific-fisc:FORMAT = "x(8)"
                   wh-classific:FORMAT    = "x(8)". 
        ELSE
            ASSIGN wh-classific-fisc:FORMAT = "XXXX.XX.XX"
                   wh-classific:FORMAT    = "XXXX.XX.XX". 
        ASSIGN wh-classific-fisc:SCREEN-VALUE   = wh-classific:SCREEN-VALUE.
    END.
    WHEN 7 THEN ASSIGN wh-classific-fisc:FORMAT  = "XXXX.XX.XX"
                       wh-classific:FORMAT       = "XXXX.XX.XX". 
    WHEN 8 THEN DO:
        IF INDEX(PROGRAM-NAME(2),"inzoom/z01in046.w") = 0 AND 
           c-it-codigo-old <> wh-it-codigo:SCREEN-VALUE THEN DO:
            FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = wh-it-codigo:SCREEN-VALUE NO-ERROR.
            IF AVAIL ITEM THEN
                ASSIGN wh-classific-fisc:SCREEN-VALUE   = STRING(item.class-fiscal)
                       wh-classific:SCREEN-VALUE        = STRING(item.class-fiscal).
        END.

        ASSIGN wh-classific-fisc:FORMAT  = "XXXX.XX.XX"
               wh-classific:FORMAT       = "XXXX.XX.XX"
               c-it-codigo-old           = wh-it-codigo:SCREEN-VALUE. 
    END.
    WHEN 11 THEN ASSIGN wh-ord-produ:SCREEN-VALUE    = wh-nr-ord-produ:SCREEN-VALUE.
    WHEN 12 THEN ASSIGN wh-nr-ord-produ:SCREEN-VALUE = wh-ord-produ:SCREEN-VALUE.
    
END CASE.

IF valid-handle(wh-fifo) AND valid-handle(wh-num-pedido)
and int(wh-num-pedido:SCREEN-VALUE) NE 0 THEN wh-fifo:checked = NO.   

