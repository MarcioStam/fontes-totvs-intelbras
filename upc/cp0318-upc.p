/***********************************************************************
**  Programa..: UPC\CP0301-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 29/12/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{utp\ut-glob.i}

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vNrOrdProdu LIKE ord-prod.nr-ord-produ NO-UNDO.
/*DEFINE VARIABLE h-lib-upc       AS HANDLE             NO-UNDO.
DEFINE VARIABLE lbloqueia       AS LOGICAL            NO-UNDO.
DEFINE VARIABLE i-sequencia     AS INTEGER            NO-UNDO.
DEFINE VARIABLE wh-bt-mod       AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-fPage1       AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-fi-nro-docto AS WIDGET-HANDLE      NO-UNDO.*/

IF valid-handle(p-wgh-object) THEN
    assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                            p-wgh-object:file-name,"~/").

/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

/****************************  Variaveis    ****************************/

/*IF  p-ind-event  = "AFTER-CHANGE-PAGE" AND p-ind-object = "CONTAINER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fPage1",
                     OUTPUT wh-fPage1).

    IF VALID-HANDLE(wh-fPage1) THEN DO:
        RUN busca-handle(INPUT wh-fPage1,
                         INPUT "fi-nro-docto",
                         OUTPUT wh-fi-nro-docto).

        IF VALID-HANDLE(wh-fi-nro-docto) THEN DO:
            IF wh-fi-nro-docto:SCREEN-VALUE = "" THEN
                ASSIGN wh-fi-nro-docto:SCREEN-VALUE = STRING(DAY(TODAY) + MONTH(TODAY) + INTEGER(SUBSTRING(STRING(YEAR(TODAY)),3,2)) + TIME).
        END.
    END.
END.

IF  p-ind-event  = "AFTER-INITIALIZE" AND p-ind-object = "CONTAINER"   THEN DO:

    RUN upc/lib-upc.p PERSISTENT SET h-lib-upc.

    RUN piBloqueiaRequis IN h-lib-upc (OUTPUT lbloqueia).

    IF lbloqueia THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Programa bloqueado~~O programa est  temporariamente bloqueado para fins de fechamento. D£vidas entrar em contato com a Controladoria.").

        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-mod",
                         OUTPUT wh-bt-mod).

        IF VALID-HANDLE(h-lib-upc) THEN
            DELETE PROCEDURE h-lib-upc.
        
        IF VALID-HANDLE(wh-bt-mod) THEN
            ASSIGN wh-bt-mod:SENSITIVE = NO.

        RETURN "NOK".
    END.

    IF VALID-HANDLE(h-lib-upc) THEN
        DELETE PROCEDURE h-lib-upc.
END.*/

IF p-ind-event  = "AFTER-INITIALIZE"  AND
   p-ind-object = "CONTAINER"          AND 
   c-objeto     = "cp0318.w"      THEN DO: 
    
    MESSAGE "Desmarcar parƒmetro - Valor de retorno"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/*PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.

            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.*/
