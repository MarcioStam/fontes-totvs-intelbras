/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa

compile \\tsclient\c\fontes\upc\cd0204-upc.p save into c:\temp\upc.
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

DEFINE new global shared VARIABLE wgh-objeto           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-Fornec-cc0105a            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fpage1-cc0105a            AS WIDGET-HANDLE NO-UNDO.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-cc0105a     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-bt-ok-cc0105a AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cc0105a        AS WIDGET-HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


if  p-ind-event  = "AFTER-DESTROY" THEN
    DELETE PROCEDURE h-upc-cc0105a.

if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:


    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btok",
                     OUTPUT wh-bt-ok-cc0105a).

    IF VALID-HANDLE(wh-bt-ok-cc0105a) THEN DO:

        IF NOT VALID-HANDLE (h-upc-cc0105a) THEN
            RUN upc/cc0105-upca-1.p PERSISTENT SET h-upc-cc0105a (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p-wgh-object,
                                                                  INPUT p-wgh-frame,
                                                                  INPUT "",
                                                                  INPUT p-row-table).

        CREATE BUTTON wh-new-bt-ok-cc0105a
        ASSIGN FRAME       = wh-bt-ok-cc0105a:FRAME
               WIDTH       = wh-bt-ok-cc0105a:WIDTH
               HEIGHT      = wh-bt-ok-cc0105a:HEIGHT
               LABEL       = wh-bt-ok-cc0105a:LABEL
               ROW         = wh-bt-ok-cc0105a:ROW
               COL         = wh-bt-ok-cc0105a:COL 
               TOOLTIP     = wh-bt-ok-cc0105a:TOOLTIP
               FLAT-BUTTON = wh-bt-ok-cc0105a:FLAT-BUTTON
               VISIBLE     = wh-bt-ok-cc0105a:VISIBLE
               SENSITIVE   = wh-bt-ok-cc0105a:SENSITIVE.
        ON "CHOOSE" OF wh-new-bt-ok-cc0105a PERSISTENT RUN pi-bt-ok IN h-upc-cc0105a.

        wh-bt-ok-cc0105a:VISIBLE = NO.
    END.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fpage1",
                     OUTPUT wh-fpage1-cc0105a).

    RUN busca-handle(INPUT wh-fpage1-cc0105a,
                     INPUT "item-do-forn",
                     OUTPUT wh-Fornec-cc0105a).

END.

PROCEDURE pi-bt-ok:

    IF  wh-Fornec-cc0105a:SCREEN-VALUE <> "0"
    AND NOT CAN-FIND(FIRST fabricante
                        WHERE fabricante.cod-fabric = INT(wh-Fornec-cc0105a:SCREEN-VALUE)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante n∆o cadastrado" + "~~" + "O Fabricante informado n∆o existe no cadastro es0007").

        RETURN "OK":U.
    END.

    APPLY "CHOOSE" TO wh-bt-ok-cc0105a.

END.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.
