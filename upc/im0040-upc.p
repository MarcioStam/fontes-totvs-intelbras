/***********************************************************************
**  Programa..: upc\im0040-upc.p
**  Autor.....: Clayton Antunes
**  Data......: outubro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 
**                  Desenvolvimento Programa
************************************************************************/
/*
{utp/ut-glob.i}
*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-via-transp-im0040  AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-estabel-im0040     AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-processo-im0040    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-itinerario-im0040  AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-page1-im0040       AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pedido             AS WIDGET-HANDLE    NO-UNDO. /*pedido cc0300*/

DEF VAR h-object         AS HANDLE        NO-UNDO.
DEF VAR h-campo          AS HANDLE        NO-UNDO.
DEF VAR c-objeto         AS CHAR          NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").

/*                                            */
/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)      */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
  

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-INITIALIZE" 
THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",    /*** Type ***/
                  INPUT "fpage1",  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-page1-im0040).

    /*fPage1*/
    RUN tela-upc (INPUT wh-page1-im0040,
                  INPUT p-ind-Event,
                  INPUT "COMBO-BOX",    /*** Type ***/
                  INPUT "combo-box-1",  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-via-transp-im0040).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",      /*** Type ***/
                  INPUT "cod-estabel",   /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-estabel-im0040).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",      /*** Type ***/
                  INPUT "nr-proc-imp",   /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-processo-im0040).

    RUN tela-upc (INPUT wh-page1-im0040,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",      /*** Type ***/
                  INPUT "cod-itiner",   /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-itinerario-im0040).

END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" 
THEN DO:
    IF  VALID-HANDLE(wh-via-transp-im0040) 
    THEN
        ASSIGN wh-via-transp-im0040:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-itinerario-im0040) AND
        VALID-HANDLE(wh-estabel-im0040)    AND
        VALID-HANDLE(wh-processo-im0040)
    THEN DO:
        FIND FIRST ordens-embarque NO-LOCK
            WHERE  ordens-embarque.cod-estabel = wh-estabel-im0040:SCREEN-VALUE
              AND  ordens-embarque.nr-proc-imp = wh-processo-im0040:SCREEN-VALUE NO-ERROR.

        IF  AVAIL ordens-embarque 
        THEN
            ASSIGN wh-itinerario-im0040:SENSITIVE = NO.
    END.

    /*Sugere o pedido do cc0300*/
    IF  VALID-HANDLE(wh-processo-im0040)
    AND wh-processo-im0040:SENSITIVE
    AND VALID-HANDLE(wh-pedido) THEN DO:
        ASSIGN wh-processo-im0040:SCREEN-VALUE = replace(wh-pedido:SCREEN-VALUE,".","").
    END.
END.

IF p-ind-event  = "after-ASSIGN" 
THEN DO:
   FIND FIRST processo-imp WHERE
              rowid(processo-imp) = p-row-table NO-ERROR.

   FIND FIRST pedido-compr WHERE 
              pedido-compr.num-pedido = processo-imp.num-pedido NO-ERROR.

   ASSIGN pedido-compr.situacao = 1.
    
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DESTROY-INTERFACE" 
THEN DO:
    ASSIGN wh-page1-im0040      = ?
           wh-via-transp-im0040 = ?
           wh-processo-im0040   = ?
           wh-estabel-im0040    = ?
           wh-itinerario-im0040 = ?.
END.


PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.
