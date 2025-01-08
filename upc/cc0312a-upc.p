/***********************************************************************
**  Programa..: UPC\CC0312a-UPC.P
**  Autor.....: Felipe Petry Vieira
**  Data......: Agosto/2015 - Desenvolvimento
**  Descricao.: Bloquer campos Estab e Moeda
**  Vers∆o....: 001 Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-num-dias-libera-fft-cc0312 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-estabel-cc0312a            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-moeda-cc0312a              AS WIDGET-HANDLE NO-UNDO.
                                                                
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
IF p-ind-event  = "INITIALIZE" THEN DO:

    ASSIGN wh-estabel-cc0312a = getObject(p-wgh-frame,"c-cod-estabel-des":U)
           wh-moeda-cc0312a   = getObject(p-wgh-frame,"i-mo-codigo-des":U).
  
    IF  VALID-HANDLE (wh-estabel-cc0312a) 
    AND VALID-HANDLE (wh-moeda-cc0312a) THEN DO:
        
        ASSIGN wh-estabel-cc0312a:SENSITIVE = NO
               wh-moeda-cc0312a:SENSITIVE = YES.
    END.
    
END.

IF  p-ind-event = "AFTER-PI-EXECUTE" THEN DO:

    IF  NOT VALID-HANDLE(wh-num-dias-libera-fft-cc0312) THEN
        RETURN "OK".

    FIND FIRST tb-pr-cc NO-LOCK
        WHERE ROWID(tb-pr-cc) = p-row-table NO-ERROR.

    IF  AVAIL tb-pr-cc THEN DO TRANS:
        FOR FIRST int-tb-pr-cc EXCLUSIVE-LOCK
            WHERE int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente
              AND int-tb-pr-cc.cod-estabel  = tb-pr-cc.cod-estabel 
              AND int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
              AND int-tb-pr-cc.mo-codigo    = tb-pr-cc.mo-codigo   
              AND int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab      
              AND int-tb-pr-cc.dt-inicio    = tb-pr-cc.dt-inicio:
              ASSIGN int-tb-pr-cc.num-dias-libera-fft = INT(wh-num-dias-libera-fft-cc0312:SCREEN-VALUE).
        END. 

        IF NOT AVAIL int-tb-pr-cc THEN DO:
            CREATE int-tb-pr-cc.
            ASSIGN int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente
                   int-tb-pr-cc.dt-inicio    = tb-pr-cc.dt-inicio
                   int-tb-pr-cc.nome-abrev   = tb-pr-cc.nome-abrev  
                   int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
                   int-tb-pr-cc.mo-codigo    = tb-pr-cc.mo-codigo
                   int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab.
        END.

        ASSIGN int-tb-pr-cc.num-dias-libera-fft = INT (wh-num-dias-libera-fft-cc0312:SCREEN-VALUE).
    
        RELEASE int-tb-pr-cc.

    END.

END.

