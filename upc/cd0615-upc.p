/***********************************************************************
**  Programa..: upc\cd0615-epc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-cd0615      AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-esp-acr-cd0615 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-cod-esp-apb-cd0615 AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-esp-apb-cd0615 AS WIDGET-HANDLE   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-cons-averb-seg-cd0615  AS WIDGET-HANDLE   NO-UNDO.
/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-cd0615).

    IF VALID-HANDLE(wh-fpage1-cd0615) THEN DO:

        RUN tela-upc (INPUT wh-fpage1-cd0615,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",       /*** Type ***/
                      INPUT "cod-esp",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-esp-acr-cd0615).

        ASSIGN wh-cod-esp-acr-cd0615:LABEL = "Esp‚cie ACR".
    
        CREATE TEXT tx-cod-esp-apb-cd0615
        ASSIGN FRAME        = wh-fpage1-cd0615
               FORMAT       = "x(16)"   
               WIDTH        = 16
               SCREEN-VALUE = "Esp‚cie APB:"
               ROW          = wh-cod-esp-acr-cd0615:ROW + 0.15
               COL          = wh-cod-esp-acr-cd0615:COL + 40.20
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-cod-esp-apb-cd0615
        ASSIGN FRAME             = wh-fpage1-cd0615
               DATA-TYPE         = "character"
               FORMAT            = "x(02)"
               WIDTH             = wh-cod-esp-acr-cd0615:WIDTH-CHARS
               HEIGHT            = wh-cod-esp-acr-cd0615:HEIGHT-CHARS
               ROW               = wh-cod-esp-acr-cd0615:ROW
               COL               = wh-cod-esp-acr-cd0615:COL + 50.20
               VISIBLE           = YES
               SENSITIVE         = NO.

        wh-cod-esp-apb-cd0615:LOAD-MOUSE-POINTER('image/lupa.cur').


        CREATE TOGGLE-BOX wh-tg-cons-averb-seg-cd0615
        ASSIGN FRAME        = wh-fpage1-cd0615
               WIDTH        = 24
               HEIGHT       = 0.83
               ROW          = wh-cod-esp-acr-cd0615:ROW - 7
               LABEL        = "Considera Averba‡Æo Seguro"
               COLUMN       = 57
               SENSITIVE    = NO
               VISIBLE      = YES
               CHECKED      = NO.

    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" THEN DO:

    ASSIGN wh-cod-esp-apb-cd0615:SENSITIVE = YES.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISABLE" THEN DO:

    ASSIGN wh-cod-esp-apb-cd0615:SENSITIVE = NO
           wh-tg-cons-averb-seg-cd0615:SENSITIVE = NO.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" THEN DO:

    IF VALID-HANDLE(wh-cod-esp-apb-cd0615)      AND 
       p-row-table <> ?                         AND 
       p-cod-table = "natur-oper" THEN DO:

        ASSIGN wh-cod-esp-apb-cd0615:SCREEN-VALUE = "".

        FIND FIRST natur-oper NO-LOCK
             WHERE ROWID(natur-oper) = p-row-table NO-ERROR.
        IF AVAIL natur-oper THEN DO:
            FIND FIRST int-natur-oper EXCLUSIVE-LOCK
                 WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
            IF NOT AVAIL int-natur-oper THEN DO:
                CREATE int-natur-oper.
                ASSIGN int-natur-oper.nat-operacao = natur-oper.nat-operacao.
            END.
            ASSIGN wh-cod-esp-apb-cd0615:SCREEN-VALUE = int-natur-oper.cod-esp-apb
                   wh-tg-cons-averb-seg-cd0615:CHECKED = int-natur-oper.cons-averb-seg.
        END.
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
