/***********************************************************************
**  Programa..: upc\ce0106-upc.p
**  Autor.....: Raphael Matei Paini
**  Data......: Julho/2009 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 - 28/07/2009
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR h-object   AS HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-txt-consumo-prev-ce0106 AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-consumo-prev-ce0106     AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-ind-cons-prv-ce0106     AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-fpage3-ce0106           AS WIDGET-HANDLE NO-UNDO. 


assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").

/*MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage3*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage3",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage3-ce0106).


    /*ind-cons-prv*/
    RUN tela-upc (INPUT wh-fpage3-ce0106,
                  INPUT p-ind-Event,
                  INPUT "fill-in",   /*** Type ***/
                  INPUT "ind-cons-prv", /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-ind-cons-prv-ce0106).


    CREATE TEXT wh-txt-consumo-prev-ce0106
    ASSIGN FRAME        = wh-fpage3-ce0106
           FORMAT       = "x(17)"
           WIDTH        = 20
           SCREEN-VALUE = "Consumo Previsto:"
           ROW          = wh-ind-cons-prv-ce0106:ROW - 1.88
           COL          = wh-ind-cons-prv-ce0106:COL - 13
           VISIBLE      = YES.

    CREATE FILL-IN wh-consumo-prev-ce0106
    ASSIGN FRAME       = wh-fpage3-ce0106
           DATA-TYPE   = "decimal"
           FORMAT      = ">>>>,>>9.9999"
           WIDTH       = 13.00
           HEIGHT      = 0.88
           ROW         = wh-ind-cons-prv-ce0106:ROW - 2
           COL         = wh-ind-cons-prv-ce0106:COL
           VISIBLE     = YES
           SENSITIVE   = NO
           HELP        = "Consumo Previsto".
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "after-enable" THEN DO:
    ASSIGN /*wh-txt-consumo-prev-ce0106:SENSITIVE = TRUE*/
           wh-consumo-prev-ce0106:SENSITIVE    = TRUE. 
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "after-disable" THEN DO:
    ASSIGN /*wh-txt-consumo-prev-ce0106:SENSITIVE = FALSE*/
           wh-consumo-prev-ce0106:SENSITIVE    = FALSE.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "after-display" THEN DO:

    ASSIGN /*wh-txt-consumo-prev-ce0106:SCREEN-VALUE = "Consumo Previsto"*/
           wh-consumo-prev-ce0106:SCREEN-VALUE     = "".

    FIND FIRST ITEM NO-LOCK
         WHERE ROWID(ITEM) = p-row-table NO-ERROR.
    IF AVAIL ITEM THEN DO:
        ASSIGN wh-consumo-prev-ce0106:SCREEN-VALUE = STRING(ITEM.consumo-prev,">>>>,>>9.9999").
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "after-assign" THEN DO:

    FIND FIRST ITEM EXCLUSIVE-LOCK
         WHERE ROWID(item) = p-row-table NO-ERROR.
    IF AVAIL ITEM THEN DO:
        ASSIGN ITEM.consumo-prev = DEC(wh-consumo-prev-ce0106:SCREEN-VALUE).
    END.
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

