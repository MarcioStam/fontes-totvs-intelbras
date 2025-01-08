/***********************************************************************
**  Programa..: UPC\CC0312-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Impedir cadastramento de itens na tabela para itens nao 
**              relacionados com o fornecedor ou que nao estejam ativos
**  Versão....: 001 23/12/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
def var i-num-casa-dec as dec.
def var de-fator-conver as dec.
DEF VAR l-all AS LOG                 NO-UNDO INIT NO.
{upc/btb910za-upc.i}

DEFINE VARIABLE vDtLimite  AS DATE    FORMAT "99/99/9999":U NO-UNDO.
DEFINE VARIABLE vDeCotacao AS DECIMAL FORMAT ">>>9.9999":U  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-estabel-cc0312             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-moeda-cc0312               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-tab-cc0312              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-num-dias-libera-fft-cc0312 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cond-pag-cc0312        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-descricao-cc0312           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-inicio-cc0312           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-cond-pag-new-cc0312    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-num-dias-libera-fft-cc0312 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cc0312-upc                  AS WIDGET-HANDLE NO-UNDO.

def buffer b-prazo-compra for prazo-compra.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/********************************************************/
/*Functions*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
       
        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.

/********************************************************/

IF  c-objeto    = "v03in425.w"
AND p-ind-event = "INITIALIZE" THEN DO:
      ASSIGN wh-dt-inicio-cc0312 = getObject(p-wgh-frame,"dt-inicio":U).
END.

IF  c-objeto    = "v02in425.w"
AND p-ind-event = "INITIALIZE" THEN DO:
    ASSIGN wh-nr-tab-cc0312 = getObject(p-wgh-frame,"nr-tab":U)
           wh-cod-cond-pag-cc0312 = getObject(p-wgh-frame,"cod-cond-pag":U)
           wh-descricao-cc0312 = getObject(p-wgh-frame,"descricao":U).

    RUN upc/cc0312-upc.p PERSISTENT SET h-cc0312-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  

    CREATE TEXT tx-num-dias-libera-fft-cc0312 
    ASSIGN NAME         = 'tx-num-dias-libera-fft-cc0312':U
           ROW          = 2.27
           COLUMN       = 73.36
           WIDTH        = 7.8
           DATA-TYPE    = "character"
           FORMAT       = "x(11)"
           FRAME        = p-wgh-frame
           VISIBLE      = YES
           SCREEN-VALUE = "Libera FFT:".

    CREATE FILL-IN wh-num-dias-libera-fft-cc0312
    ASSIGN NAME       = 'wh-num-dias-libera-fft-cc0312':U
           FRAME      = p-wgh-frame
           ROW        = wh-nr-tab-cc0312:ROW + 1
           COLUMN     = wh-nr-tab-cc0312:COLUMN + 9.4
           HEIGHT     = 0.88
           WIDTH      = 5
           DATA-TYPE  = "integer"
           FORMAT     = ">>>9"
           TOOLTIP    = "Libera FFT"
           HELP       = "Libera FFT"
           VISIBLE    = TRUE
           SIDE-LABEL-HANDLE = tx-num-dias-libera-fft-cc0312
           SENSITIVE  = NO.

    CREATE FILL-IN wh-cod-cond-pag-new-cc0312
    ASSIGN NAME       = wh-cod-cond-pag-cc0312:NAME
           FRAME      = wh-cod-cond-pag-cc0312:FRAME
           ROW        = wh-cod-cond-pag-cc0312:ROW
           COLUMN     = wh-cod-cond-pag-cc0312:COLUMN
           HEIGHT     = wh-cod-cond-pag-cc0312:HEIGHT
           WIDTH      = wh-cod-cond-pag-cc0312:WIDTH
           DATA-TYPE  = wh-cod-cond-pag-cc0312:DATA-TYPE
           FORMAT     = wh-cod-cond-pag-cc0312:FORMAT
           TOOLTIP    = wh-cod-cond-pag-cc0312:TOOLTIP
           HELP       = wh-cod-cond-pag-cc0312:HELP
           VISIBLE    = wh-cod-cond-pag-cc0312:VISIBLE
           SENSITIVE  = wh-cod-cond-pag-cc0312:SENSITIVE.

    ON "LEAVE":U OF wh-cod-cond-pag-new-cc0312 PERSISTENT RUN pi-leave-cod-cond-pag IN h-cc0312-upc.

    wh-cod-cond-pag-new-cc0312:MOVE-AFTER-TAB-ITEM(wh-nr-tab-cc0312).
    wh-num-dias-libera-fft-cc0312:MOVE-AFTER-TAB-ITEM(wh-cod-cond-pag-new-cc0312).
    wh-descricao-cc0312:MOVE-AFTER-TAB-ITEM(wh-num-dias-libera-fft-cc0312).
END.

IF  c-objeto    = "v02in425.w"
AND p-ind-event = "DISPLAY" THEN DO:
    IF VALID-HANDLE (wh-cod-cond-pag-new-cc0312) THEN
        ASSIGN wh-cod-cond-pag-new-cc0312:SCREEN-VALUE = wh-cod-cond-pag-cc0312:SCREEN-VALUE.

    FIND tb-pr-cc NO-LOCK
        WHERE ROWID(tb-pr-cc) = p-row-table NO-ERROR.

    IF AVAIL tb-pr-cc THEN DO:

        FIND FIRST int-tb-pr-cc EXCLUSIVE-LOCK 
             WHERE int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente 
               AND int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
               AND int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab      
               AND int-tb-pr-cc.dt-inicio    = tb-pr-cc.dt-inicio    NO-ERROR.

        IF AVAIL int-tb-pr-cc THEN DO:
            ASSIGN wh-num-dias-libera-fft-cc0312:SCREEN-VALUE = STRING(int-tb-pr-cc.num-dias-libera-fft).
        END.
        ELSE DO:
            ASSIGN wh-num-dias-libera-fft-cc0312:SCREEN-VALUE = "0".
        END.
    END.
END.

IF  c-objeto    = "v03in425.w"
AND p-ind-event = "AFTER-ENABLE" THEN DO:

    ASSIGN wh-cod-cond-pag-new-cc0312:SENSITIVE = wh-cod-cond-pag-cc0312:SENSITIVE
           wh-cod-cond-pag-new-cc0312:SCREEN-VALUE = wh-cod-cond-pag-cc0312:SCREEN-VALUE.
     
    CREATE TEXT tx-num-dias-libera-fft-cc0312 
    ASSIGN NAME         = 'tx-num-dias-libera-fft-cc0312':U
           ROW          = 2.27   
           COLUMN       = 73.36  
           WIDTH        = 7.8
           DATA-TYPE    = "character"
           FORMAT       = "x(11)"
           FRAME        = wh-num-dias-libera-fft-cc0312:FRAME
           VISIBLE      = YES
           SCREEN-VALUE = "Libera FFT:".

    ASSIGN wh-num-dias-libera-fft-cc0312:SIDE-LABEL-HANDLE = tx-num-dias-libera-fft-cc0312
           wh-num-dias-libera-fft-cc0312:SENSITIVE = YES.

    APPLY "leave" TO wh-cod-cond-pag-new-cc0312.

    IF wh-cod-cond-pag-cc0312:SCREEN-VALUE <> "0" THEN
       APPLY 'LEAVE' TO wh-cod-cond-pag-cc0312.
END.

IF  c-objeto    = "v02in425.w"
AND p-ind-event = "DISABLE" THEN DO:

    ASSIGN wh-cod-cond-pag-new-cc0312:SENSITIVE    =NO
           wh-cod-cond-pag-new-cc0312:SCREEN-VALUE = wh-cod-cond-pag-cc0312:SCREEN-VALUE.
    ASSIGN wh-num-dias-libera-fft-cc0312:SENSITIVE = NO.
END.

IF  c-objeto    = "v02in425.w"
AND p-ind-event = "ASSIGN" THEN DO:

    find tb-pr-cc where ROWID(tb-pr-cc) = p-row-table.

    FIND FIRST int-tb-pr-cc EXCLUSIVE-LOCK 
         WHERE int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente 
           AND int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
           AND int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab      
           AND int-tb-pr-cc.dt-inicio    = date(wh-dt-inicio-cc0312:SCREEN-VALUE)    NO-ERROR.

    IF NOT AVAIL int-tb-pr-cc THEN DO:
        CREATE int-tb-pr-cc.
        ASSIGN int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente
               int-tb-pr-cc.dt-inicio    = date(wh-dt-inicio-cc0312:SCREEN-VALUE)
               int-tb-pr-cc.nome-abrev   = tb-pr-cc.nome-abrev  
               int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
               int-tb-pr-cc.mo-codigo    = tb-pr-cc.mo-codigo
               int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab.
    END.

    ASSIGN int-tb-pr-cc.num-dias-libera-fft = INT (wh-num-dias-libera-fft-cc0312:SCREEN-VALUE).

    RELEASE int-tb-pr-cc.

END.

/********************************************************/

IF (p-ind-event  = "AFTER-ENABLE" OR
    p-ind-event  = "INITIALIZE")  AND c-objeto = 'v02in425.w' THEN DO:

    ASSIGN wh-estabel-cc0312 = getObject(p-wgh-frame,"cod-estabel":U)
           wh-moeda-cc0312   = getObject(p-wgh-frame,"mo-codigo":U).
  
    IF  VALID-HANDLE (wh-estabel-cc0312) 
    AND VALID-HANDLE (wh-moeda-cc0312) THEN
        ASSIGN wh-estabel-cc0312:READ-ONLY = YES.
    
END.
/******************************************************************************/

PROCEDURE pi-leave-cod-cond-pag:
    ASSIGN wh-cod-cond-pag-cc0312:SCREEN-VALUE = wh-cod-cond-pag-new-cc0312:SCREEN-VALUE.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag =  INT(wh-cod-cond-pag-cc0312:SCREEN-VALUE) NO-ERROR.

    IF NOT AVAIL cond-pagto THEN
        RETURN NO-APPLY.

    APPLY "leave" TO wh-cod-cond-pag-cc0312.

    FIND FIRST int-cond-pagto NO-LOCK
         WHERE int-cond-pagto.cod-cond-pag = INT(wh-cod-cond-pag-cc0312:SCREEN-VALUE) NO-ERROR.

    IF  AVAIL int-cond-pagto 
    AND int-cond-pagto.log-controla-fft THEN
        ASSIGN wh-num-dias-libera-fft-cc0312:SENSITIVE = YES.
    ELSE 
        ASSIGN wh-num-dias-libera-fft-cc0312:SENSITIVE = NO.

END PROCEDURE.
