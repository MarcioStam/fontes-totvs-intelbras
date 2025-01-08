/***********************************************************************
**  Programa..: UPC\ft0805-UPC.P
**  Autor.....: Anderson Cenci
**  Data......: Setembro/2008 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 17/09/08
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

def NEW GLOBAL SHARED var wh-browse-ft0805          as handle        no-undo.
def new global shared var wh-query           as widget-handle no-undo.
def new global shared var h-objeto           as widget-handle no-undo.
def new global shared var wh-buffer          as widget-handle no-undo.

def new global shared var h-it-codigo        as widget-handle no-undo.
def new global shared var wh-qtdisponivel    as widget-handle no-undo.
define variable h-campo                      as handle  extent 10   no-undo.
DEFINE VARIABLE de-qtd-devol                 AS DECIMAL     NO-UNDO.
ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

DEF VAR i-cont              AS INT NO-UNDO.
DEF VAR achou               AS INT NO-UNDO.

DEF VAR h-objeto-aux        AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl              AS HANDLE NO-UNDO.

DEF VAR hquery              AS HANDLE NO-UNDO.
DEF VAR hbuffer             AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-browser AS HANDLE NO-UNDO.
DEF VAR adcol AS LOG.
DEF VAR h-column            AS HANDLE        NO-UNDO.
DEF VAR h-col               AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-qtd-a-devolver    AS HANDLE NO-UNDO.
DEF VAR h-nat-operacao      AS HANDLE NO-UNDO.
DEF VAR h-vl-preuni         AS HANDLE NO-UNDO.
DEF VAR h-nr-ordem          AS HANDLE NO-UNDO.
DEF VAR i-linha             AS INT NO-UNDO.
DEFINE VARIABLE h-bodi088na AS HANDLE      NO-UNDO.
DEF VAR dt-entrega          AS DATE NO-UNDO.
def var wh-it-codigo-ft0805 as widget-handle no-undo.
def var wh-page1-ft0805 as widget-handle no-undo.
/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)      */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */


    IF NOT VALID-HANDLE(wh-it-codigo-ft0805) THEN DO:
    
         run pi-busca-handle (input p-wgh-frame,
                              input p-ind-event,
                              input 'fill-in':U,
                              input 'it-codigo':U,
                              input NO,
                              output wh-it-codigo-ft0805).


    END.
IF c-objeto    = "ft0805.w":U         AND
   p-ind-event = "before-initialize":U  THEN DO:    

/*     ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD. */
     run pi-busca-handle (input p-wgh-frame,
                          input p-ind-event,
                          input 'Frame':U,
                          input 'fpage1':U,
                          input NO,
                          output wh-page1-ft0805).
     IF VALID-HANDLE(wh-page1-ft0805) THEN DO:
         run pi-busca-handle (input wh-page1-ft0805,
                           input p-ind-event,
                           input 'browse':U,
                           input 'brson1':U,
                           input NO,
                           output wh-browse-ft0805).
     END.

    IF  VALID-HANDLE(wh-browse-ft0805) THEN DO:
        wh-browse-ft0805:ADD-CALC-COLUMN("decimal", 
                                  "->>>,>>9.99" , 
                                  " ", 
                                  "Vlr Unit").
         wh-browse-ft0805:ADD-CALC-COLUMN("decimal", 
                                   "->>>,>>>,>>9.99" , 
                                   " ", 
                                   "Sdo a Devolver").
         wh-browse-ft0805:ADD-CALC-COLUMN("character", 
                                   "x(07)" , 
                                   " ", 
                                   "Nat.Operacao").

    END.
END.



IF c-objeto    = "ft0805.w":U     AND
   p-ind-event = "after-open-query" AND
   VALID-HANDLE(wh-browse-ft0805) THEN DO:
    IF wh-browse-ft0805:NUM-ITERATIONS > 0 THEN DO:
        DO i-linha = 1 TO wh-browse-ft0805:NUM-ITERATIONS - 1 :
    
            ASSIGN h-vl-preuni      = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS - 2)
                   h-qtd-a-devolver = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS - 1)
                   h-nat-operacao   = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS).
                  

    
           IF NOT VALID-HANDLE(h-bodi088na) THEN
              RUN dibo/bodi088na.p PERSISTENT SET h-bodi088na.    
    
           run ReturnQtDevol in h-bodi088na( input wh-browse-ft0805:GET-BROWSE-COLUMN(3):SCREEN-VALUE,
                                             input wh-browse-ft0805:GET-BROWSE-COLUMN(1):SCREEN-VALUE,
                                             input wh-browse-ft0805:GET-BROWSE-COLUMN(2):SCREEN-VALUE,
                                             input wh-browse-ft0805:GET-BROWSE-COLUMN(4):SCREEN-VALUE,
                                             input wh-it-codigo-ft0805:SCREEN-VALUE,
                                            output de-qtd-devol ).
    
    
    
           ASSIGN h-qtd-a-devolver:SCREEN-VALUE = STRING(dec(wh-browse-ft0805:GET-BROWSE-COLUMN(5):SCREEN-VALUE) - de-qtd-devol).


           FIND it-nota-fisc
                WHERE it-nota-fisc.cod-estabel = string(wh-browse-ft0805:GET-BROWSE-COLUMN(3):SCREEN-VALUE)
                  AND it-nota-fisc.serie       = string(wh-browse-ft0805:GET-BROWSE-COLUMN(2):SCREEN-VALUE)
                  AND it-nota-fisc.nr-nota-fis = string(wh-browse-ft0805:GET-BROWSE-COLUMN(1):SCREEN-VALUE)
                  AND it-nota-fisc.nr-seq-fat  = int(wh-browse-ft0805:GET-BROWSE-COLUMN(4):SCREEN-VALUE) 
                NO-LOCK NO-ERROR.
           IF AVAIL it-nota-fisc THEN
               ASSIGN h-nat-operacao:SCREEN-VALUE = it-nota-fisc.nat-operacao
                      h-vl-preuni:SCREEN-VALUE    = STRING(it-nota-fisc.vl-preuni,">>>,>>9.99") .

           wh-browse-ft0805:Select-next-row(). 
    
           ASSIGN achou = 1.                 
    
           IF VALID-HANDLE(h-bodi088na) THEN
              DELETE PROCEDURE h-bodi088na.

        END.

        IF achou = 1 THEN DO:
           wh-browse-ft0805:Select-row(1). 
           ASSIGN achou = 2.
        END.
    
        ASSIGN wh-browse-ft0805:SCROLLBAR-VERTICAL = NO.
    END.
END.


IF c-objeto    = "ft0805.w":U         AND
   p-ind-event = "After-value-changed"  THEN DO:
   IF wh-browse-ft0805:NUM-ITERATIONS > 0 THEN DO:
       ASSIGN h-vl-preuni      = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS - 2)
              h-qtd-a-devolver = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS - 1)
              h-nat-operacao   = wh-browse-ft0805:GET-BROWSE-COLUMN(wh-browse-ft0805:NUM-COLUMNS).

       IF NOT VALID-HANDLE(h-bodi088na) THEN
          RUN dibo/bodi088na.p PERSISTENT SET h-bodi088na.

       run ReturnQtDevol in h-bodi088na( input wh-browse-ft0805:GET-BROWSE-COLUMN(3):SCREEN-VALUE,
                                         input wh-browse-ft0805:GET-BROWSE-COLUMN(1):SCREEN-VALUE,
                                         input wh-browse-ft0805:GET-BROWSE-COLUMN(2):SCREEN-VALUE,
                                         input wh-browse-ft0805:GET-BROWSE-COLUMN(4):SCREEN-VALUE,
                                         input wh-it-codigo-ft0805:SCREEN-VALUE,
                                        output de-qtd-devol ).
       ASSIGN h-qtd-a-devolver:SCREEN-VALUE = STRING(dec(wh-browse-ft0805:GET-BROWSE-COLUMN(5):SCREEN-VALUE) - de-qtd-devol).
       FIND it-nota-fisc
            WHERE it-nota-fisc.cod-estabel = string(wh-browse-ft0805:GET-BROWSE-COLUMN(3):SCREEN-VALUE)
              AND it-nota-fisc.serie       = string(wh-browse-ft0805:GET-BROWSE-COLUMN(2):SCREEN-VALUE)
              AND it-nota-fisc.nr-nota-fis = string(wh-browse-ft0805:GET-BROWSE-COLUMN(1):SCREEN-VALUE)
              AND it-nota-fisc.nr-seq-fat  = int(wh-browse-ft0805:GET-BROWSE-COLUMN(4):SCREEN-VALUE) 
            NO-LOCK NO-ERROR.
    
       IF AVAIL it-nota-fisc THEN
          ASSIGN h-nat-operacao:SCREEN-VALUE = it-nota-fisc.nat-operacao
                 h-vl-preuni:SCREEN-VALUE    = STRING(it-nota-fisc.vl-preuni,">>>,>>9.99") .

       IF VALID-HANDLE(h-bodi088na) THEN
          DELETE PROCEDURE h-bodi088na.

   END.
END.

RETURN "ok":u.

PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):

        IF  pApresMsg = YES THEN
            MESSAGE
                "Nome do Objeto " wgh-obj:NAME SKIP
                "Type do Objeto " wgh-obj:TYPE skip
                "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE    =   pObjType    AND 
            wgh-obj:NAME    =   pObjName    THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF  wgh-obj:TYPE = "field-group" THEN    
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.           
END PROCEDURE.
