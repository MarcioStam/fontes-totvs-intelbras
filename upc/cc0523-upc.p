/***********************************************************************
**  Programa..: UPC\CC0523-UPC.P
**  Autor.....: Clayton Antunes
**  Data......: outubro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 04/10/2006
**                  Desenvolvimento Programa
************************************************************************/
DEF input param p-ind-event        as char          no-undo.
DEF input param p-ind-object       as char          no-undo.
DEF input param p-wgh-object       as handle        no-undo.
DEF input param p-wgh-frame        as widget-handle no-undo.
DEF input param p-cod-table        as char          no-undo.
DEF input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo AS WIDGET-HANDLE   NO-UNDO.

def NEW GLOBAL SHARED var wh-browse         as handle        no-undo.
def new global shared var wh-query           as widget-handle no-undo.
def new global shared var h-objeto           as widget-handle no-undo.
def new global shared var wh-buffer          as widget-handle no-undo.

def new global shared var h-it-codigo        as widget-handle no-undo.
def new global shared var wh-qtdisponivel    as widget-handle no-undo.
define variable h-campo as handle  extent 10   no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

DEF VAR i-cont  AS INT NO-UNDO.
DEF VAR achou   AS INT NO-UNDO.

DEF VAR h-objeto-aux AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl       AS HANDLE NO-UNDO.

DEF VAR hquery AS HANDLE NO-UNDO.
DEF VAR hbuffer AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-browser AS HANDLE NO-UNDO.
DEF VAR adcol AS LOG.
DEF VAR h-column       AS HANDLE        NO-UNDO.
DEF VAR h-col          AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-data-ordem           AS HANDLE NO-UNDO.
DEF VAR h-nr-ordem             AS HANDLE NO-UNDO.
DEF VAR i-linha                AS INT NO-UNDO.

DEF VAR dt-entrega AS DATE NO-UNDO.



/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/



IF c-objeto    = "b15in055.w":U         AND
   p-ind-event = "before-initialize":U  THEN DO:
    


    ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-grupo) :
       CASE wgh-grupo:TYPE:
             WHEN "browse" THEN DO:

                 ASSIGN wh-browse = wgh-grupo:HANDLE
                        wh-query  = wh-browse:QUERY
                        wh-buffer = wh-query:GET-BUFFER-HANDLE(1).
                 LEAVE.
             END.   
       END CASE.
                       
       IF  wgh-grupo:TYPE = "field-group" THEN
           ASSIGN wgh-grupo = wgh-grupo:FIRST-CHILD.
       ELSE
           ASSIGN wgh-grupo = wgh-grupo:NEXT-SIBLING. 
    END.

    IF  VALID-HANDLE(wh-browse) THEN 
         wh-browse:ADD-CALC-COLUMN("date", 
                                   "99/99/9999" , 
                                   " ", 
                                   "Data Entrega").
END.



IF c-objeto    = "b15in055.w":U     AND
   p-ind-event = "after-open-query" THEN DO:

    DO i-linha = 1 TO wh-browse:NUM-ITERATIONS - 1 :

        ASSIGN h-nr-ordem   = wh-browse:GET-BROWSE-COLUMN(1).
               h-data-ordem = wh-browse:GET-BROWSE-COLUMN(wh-browse:NUM-COLUMNS). 
        
        FOR FIRST prazo-compra WHERE
                  prazo-compra.numero-ordem = int(h-nr-ordem:SCREEN-VALUE) NO-LOCK:
            ASSIGN h-data-ordem:SCREEN-VALUE = STRING(prazo-compra.data-entrega).
        END.

        wh-browse:Select-next-row(). 

        ASSIGN achou = 1.

    END.

    IF achou = 1 THEN DO:
       wh-browse:Select-row(1). 
       ASSIGN achou = 2.
    END.

    ASSIGN wh-browse:SCROLLBAR-VERTICAL = NO.

END.
    


IF c-objeto    = "b15in055.w":U         AND
   p-ind-event = "After-value-changed"  THEN DO:
       
    ASSIGN h-data-ordem = wh-browse:GET-BROWSE-COLUMN(wh-browse:NUM-COLUMNS). 
    
    FOR FIRST ordem-compra
        WHERE ROWID(ordem-compra) = p-row-table NO-LOCK: 
        FOR FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

             ASSIGN h-data-ordem:SCREEN-VALUE = STRING(prazo-compra.data-entrega).
        END.
    END.
END.

RETURN "ok":u.

