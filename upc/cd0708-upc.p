/***********************************************************************
**  Programa..: UPC\CC0523-UPC.P
**  Autor.....: Clayton Antunes
**  Data......: novembro/2006 - Desenvolvimento
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

DEF VAR p-wgh-object-salva       as handle        no-undo.

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

DEF NEW GLOBAL SHARED VAR tx-cod-gerente     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-gerente      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-gerente     AS WIDGET-HANDLE NO-UNDO.


DEF VAR h-objeto-aux AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl       AS HANDLE NO-UNDO.


DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.  


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

DEF VAR inss AS CHAR.
DEF VAR natureza AS CHAR.





/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */


IF p-ind-event = "BEFORE-INITIALIZE":U AND
   c-objeto    = "v05ad229.w":U THEN DO:
   /* Cria campo e texto para centro de custo */
   CREATE TEXT tx-cod-gerente
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(08)"
                       WIDTH        = 08
                       SCREEN-VALUE = "Gerente:"
                       ROW          = 05.90
                       COL          = 60.5
                       VISIBLE      = YES.         
    
   CREATE FILL-IN wh-cod-gerente
                ASSIGN FRAME             = p-wgh-frame
                       FORMAT            = "x(3)"
                       WIDTH             = 4
                       HEIGHT            = 0.80
                       ROW               = 05.9
                       COL               = 67
                       VISIBLE           = YES
                       SENSITIVE         = NO.
   CREATE FILL-IN wh-nome-gerente
                ASSIGN FRAME             = p-wgh-frame
                       FORMAT            = "x(8)"
                       WIDTH             = 8
                       HEIGHT            = 0.80
                       ROW               = 05.9
                       COL               = 71
                       VISIBLE           = YES
                       SENSITIVE         = NO. 
/*    IF VALID-HANDLE(wh-cod-gerente) THEN                   */
/*       wh-cod-gerente:MOVE-AFTER-TAB-ITEM(wh-cod-gerente). */
END. 

/*                                                      */
/* IF p-ind-event = "INITIALIZE" AND                    */
/*    p-ind-object = "CONTAINER" THEN DO:               */
/*                                                      */
/*     ASSIGN p-wgh-object-salva = p-wgh-object.        */
/*     RUN select-page IN p-wgh-object-salva (INPUT 2). */
/*     RUN select-page IN p-wgh-object-salva (INPUT 1). */
/*                                                      */
/* END.                                                 */

IF p-ind-event = "DISPLAY" and
    c-objeto    = "v05ad229.w":U THEN DO:
      
    FIND FIRST repres WHERE
        ROWID(repres) = p-row-table NO-ERROR.
   IF AVAIL repres THEN DO:
       FIND FIRST INT-repres
            WHERE int-repres.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
      IF AVAIL INT-repres THEN
         ASSIGN wh-cod-gerente:SCREEN-VALUE = string(int-repres.cod-gerente).
      ELSE
          ASSIGN wh-cod-gerente:SCREEN-VALUE = "".
      FIND gerente
          WHERE gerente.cod-gerente = int(wh-cod-gerente:SCREEN-VALUE) NO-LOCK NO-ERROR.
      IF avail gerente THEN
         ASSIGN wh-nome-gerente:SCREEN-VALUE = gerente.nome.
      ELSE
         ASSIGN wh-nome-gerente:SCREEN-VALUE = "".

   END.
END.
IF p-ind-event = "ASSIGN" AND
   c-objeto    = "v05ad229.w":U THEN DO:
   FIND FIRST repres WHERE
        ROWID(repres) = p-row-table NO-ERROR.
   IF AVAIL repres THEN DO:
       FIND FIRST INT-repres
            WHERE int-repres.cod-rep = repres.cod-rep EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL INT-repres THEN DO:
          CREATE int-repres.
          ASSIGN INT-REPRES.COD-REP = repres.cod-rep.
      END.
      ASSIGN int-repres.cod-gerente = int(wh-cod-gerente:SCREEN-VALUE).
   END.

END.

IF p-ind-event = "ENABLE" AND
    c-objeto    = "v01ad229.w":U THEN DO:
       ASSIGN wh-cod-gerente:SENSITIVE = YES.
END.
IF p-ind-event = "disable" AND
    c-objeto    = "v01ad229.w":U THEN DO:
       ASSIGN wh-cod-gerente:SENSITIVE = NO.
END.
IF p-ind-event = "validate"     AND
    c-objeto    = "v01ad229.w":U
    THEN DO:
   FIND gerente
        WHERE gerente.cod-gerente = int(wh-cod-gerente:Screen-value)
       NO-LOCK NO-ERROR.
   IF NOT AVAIL gerente  THEN DO:
       MESSAGE "Gerente nao cadastrado" VIEW-AS ALERT-BOX.
       APPLY 'entry' TO wh-cod-gerente.  
       RETURN "NOK".
   END.
END.

