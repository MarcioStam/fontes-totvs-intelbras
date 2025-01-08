/*------------------------------------------------------------------------
    File        : CD0354-UPC.P
    Author      : Carlos Daniel - 11/03/2016
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

{esp/es0018.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

DEFINE VARIABLE wh-cd0354-espec     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0354-filtro    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0354-cons-item AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-aux              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-fPage1-cd0354    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-btAddSon1-cd0354      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-btUpdateSon1-cd0354   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-btCopySon1-cd0354     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-btDeleteSon1-cd0354   AS WIDGET-HANDLE NO-UNDO.

def new global shared var wg-brSon1-cd0354    AS WIDGET-HANDLE NO-UNDO.
def new global shared var wh-query-cd0354     as widget-handle no-undo.
def new global shared var wh-buffer-cd0354    as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cd0354a        AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-aux               AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux               AS INTEGER       NO-UNDO.
DEFINE VARIABLE c-ge-codigo         AS CHARACTER     NO-UNDO.

/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

/*
MESSAGE "EVENTO: ":U   p-ind-event      SKIP
        "OBJETO: ":U   p-ind-object     SKIP
        "NOME OBJ: ":U c-objeto         SKIP
        "FRAME: ":U    p-wgh-frame:NAME SKIP
        "TABELA: ":U   p-cod-table      SKIP
        "ROWID: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF p-ind-event  = "AFTER-DESTROY-INTERFACE" THEN DO: 
    DELETE PROCEDURE h-upc-cd0354a.
    ASSIGN h-upc-cd0354a = ?.
END.
IF p-ind-event  = "AFTER-INITIALIZE" AND p-ind-object = "CONTAINER" THEN DO:

    IF NOT VALID-HANDLE (h-upc-cd0354a) THEN
        RUN upc/cd0354-upc.p PERSISTENT SET h-upc-cd0354a (INPUT "",
                                                           INPUT "",
                                                           INPUT p-wgh-object,
                                                           INPUT p-wgh-frame,
                                                           INPUT "",
                                                           INPUT p-row-table).

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "fPage1",
                      OUTPUT wg-fPage1-cd0354).

    RUN busca-handle (INPUT wg-fPage1-cd0354,
                      INPUT "btAddSon1",
                      OUTPUT wg-btAddSon1-cd0354).

    RUN busca-handle (INPUT wg-fPage1-cd0354,
                      INPUT "btUpdateSon1",
                      OUTPUT wg-btUpdateSon1-cd0354).

    RUN busca-handle (INPUT wg-fPage1-cd0354,
                      INPUT "btCopySon1",
                      OUTPUT wg-btCopySon1-cd0354).

    RUN busca-handle (INPUT wg-fPage1-cd0354,
                      INPUT "btDeleteSon1",
                      OUTPUT wg-btDeleteSon1-cd0354).

    RUN busca-handle (INPUT wg-fPage1-cd0354,
                      INPUT "brSon1",
                      OUTPUT wg-brSon1-cd0354).

    wh-query-cd0354  = wg-brSon1-cd0354:QUERY.
    wh-buffer-cd0354 = wh-query-cd0354:GET-BUFFER-HANDLE(1).

    IF VALID-HANDLE(wg-btAddSon1-cd0354) THEN DO:
        CREATE BUTTON wh-cd0354-filtro
        ASSIGN FRAME     = wg-btAddSon1-cd0354:FRAME
               WIDTH     = wg-btAddSon1-cd0354:WIDTH
               HEIGHT    = wg-btAddSon1-cd0354:HEIGHT
               ROW       = wg-btAddSon1-cd0354:ROW
               COL       = wg-btAddSon1-cd0354:COL + 40
               LABEL     = "Filtrar"
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Importa‡Æo"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN pi-bt-filtro IN h-upc-cd0354a.
               END TRIGGERS.
    END.

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):

        IF h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" then
           LEAVE.

        IF h-frame:TYPE ne "field-group" THEN
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    IF  h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" THEN DO:
        CREATE BUTTON wh-cd0354-espec
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 65.1
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Importa‡Æo"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN esp/cdp/escdp003.w.
               END TRIGGERS.
    
        IF wh-cd0354-espec:LOAD-IMAGE("image/gr-lay.bmp") THEN.
        IF wh-cd0354-espec:LOAD-IMAGE-DOWN("image/gr-lay.bmp") THEN.
    END.

    IF  h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" THEN DO:
        CREATE BUTTON wh-cd0354-cons-item
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 71
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Consulta Item"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN esp/cdp/escdp083.w.
               END TRIGGERS.
    
        IF wh-cd0354-cons-item:LOAD-IMAGE("image/gr-lay.bmp") THEN.
        IF wh-cd0354-cons-item:LOAD-IMAGE-DOWN("image/gr-lay.bmp") THEN.
    END.
END.

IF p-ind-event  = "BEFORE-DELETE" AND p-ind-object = "CONTAINER" THEN DO:
    RUN esp/es0018p.p (INPUT "cd0354":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
        ASSIGN c-ge-codigo = tt-prog-ponto.conteudo.

    FOR FIRST sit-tribut-relacto
        WHERE ROWID(sit-tribut-relacto) = p-row-table NO-LOCK,
        FIRST item
        WHERE item.it-codigo = sit-tribut-relacto.cod-item NO-LOCK:

        IF LOOKUP(STRING(item.ge-codigo),c-ge-codigo) > 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Elimina‡Æo de relacionamento CEST X C¢digo Item inv lido~~" + 
                                     "NÆo ‚ permitido a elimina‡Æo de itens que pertencem ao grupo de estoque " + STRING(item.ge-codigo) + ".").
            RETURN ERROR.
        END.
    END.
END.

IF VALID-HANDLE(wg-btAddSon1-cd0354) THEN 
   ASSIGN wg-btAddSon1-cd0354:SENSITIVE = NO.

IF VALID-HANDLE(wg-btUpdateSon1-cd0354) THEN 
   ASSIGN wg-btUpdateSon1-cd0354:SENSITIVE = NO.

IF VALID-HANDLE(wg-btCopySon1-cd0354) THEN  
   ASSIGN wg-btCopySon1-cd0354:SENSITIVE = NO.

IF VALID-HANDLE(wg-btDeleteSon1-cd0354) THEN  
   ASSIGN wg-btDeleteSon1-cd0354:SENSITIVE = NO.


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

        IF NOT valid-handle(h-aux) AND NOT VALID-HANDLE(h-prox) THEN DO:
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

/*         MESSAGE h-aux:NAME                            */
/*             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
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


PROCEDURE pi-bt-filtro:
    DEFINE VARIABLE c-it-codigo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-movimento   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linha       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-it-codigo   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-movimento   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-achou       AS LOG         NO-UNDO.
    DEFINE VARIABLE c-ultimo-item AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-aux         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-query AS CHARACTER   NO-UNDO.

    ASSIGN l-achou = NO
           i-aux   = 0.
/*     ASSIGN c-it-codigo = "3040182" */
/*            c-movimento = "E".      */

    RUN upc/cd0354-upca.w (OUTPUT c-it-codigo).

    /*Foi necess rio esse bloco para percorrer o grid at‚ o final para retornar todos os registros ao grid, o getbatchrecords da BO nÆo retorna todos de uma vez*/
    APPLY 'END' TO wg-brSon1-cd0354. 

/*     wg-brSon1-cd0354:SELECT-ROW(1). */

/*     REPEAT:                                                                      */
/*         ASSIGN h-it-codigo   = wg-brSon1-cd0354:GET-BROWSE-COLUMN(7)             */
/*                h-movimento   = wg-brSon1-cd0354:GET-BROWSE-COLUMN(1)             */
/*                c-ultimo-item = h-it-codigo:SCREEN-VALUE.                         */
/*                                                                                  */
/*         MESSAGE h-it-codigo:SCREEN-VALUE                                         */
/*                 h-movimento:SCREEN-VALUE                                         */
/*             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                            */
/*                                                                                  */
/*         IF  h-it-codigo:SCREEN-VALUE = c-it-codigo                               */
/*         AND h-movimento:SCREEN-VALUE = c-movimento THEN DO:                      */
/*             MESSAGE h-movimento:SCREEN-VALUE                                     */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                        */
/*             ASSIGN l-achou = YES.                                                */
/*             LEAVE.                                                               */
/*         END.                                                                     */
/*                                                                                  */
/*         wg-brSon1-cd0354:SELECT-NEXT-ROW().                                      */
/*         wg-brSon1-cd0354:SCROLL-TO-CURRENT-ROW().                                */
/*                                                                                  */
/*         /*Solu‡Æo para sair do repeat ao chegar na ultima linha*/                */
/*         IF c-ultimo-item = h-it-codigo:SCREEN-VALUE THEN                         */
/*             ASSIGN i-aux = i-aux + 1.                                            */
/*                                                                                  */
/*         IF i-aux >= 10 THEN                                                      */
/*             LEAVE.                                                               */
/*     END.                                                                         */
/*                                                                                  */
/*     IF NOT l-achou THEN DO:                                                      */
/*         RUN utp/ut-msgs.p(INPUT "show",                                          */
/*                           INPUT 17006,                                           */
/*                           INPUT "NÆo foi poss¡vel localizar o item informado."). */
/*     END.                                                                         */
        
/*         ASSIGN c-query = "for each tt-sit-tribut-relacto WHERE string(tt-sit-tribut-relacto.cod-item) = '" + c-it-codigo + "' NO-LOCK". */
/*         wh-query-cd0354:QUERY-PREPARE(c-query).                                                                                         */
/*         wh-query-cd0354:QUERY-OPEN().                                                                                                   */
        
    IF c-it-codigo <> "" THEN DO:
   
        wh-query-cd0354:QUERY-PREPARE("for each tt-sit-tribut-relacto").
        wh-query-cd0354:QUERY-OPEN().
        DO WHILE NOT wh-query-cd0354:QUERY-OFF-END:

            IF wh-buffer-cd0354:BUFFER-FIELD("cod-item":U):BUFFER-VALUE <> c-it-codigo THEN DO:
               wh-buffer-cd0354:BUFFER-DELETE(). /* Excluindo a Temp-Table */                 
            END.

            wh-query-cd0354:GET-NEXT.
        END.
        wh-query-cd0354:QUERY-OPEN().
    END.
        

/*         ASSIGN wg-brSon1-cd0354:SCROLLBAR-VERTICAL = NO. */
        
/*     END.                                                                                                                                */
/*     ELSE DO:                                                                                                                            */
/*         RUN utp/ut-msgs.p(INPUT "show",                                                                                                 */
/*                           INPUT 17006,                                                                                                  */
/*                           INPUT "NÆo foi poss¡vel localizar o item informado.").                                                        */
/*     END.                                                                                                                                */

    
END PROCEDURE.



/* IF c-objeto    = "b15in055.w":U     AND       */
/*    p-ind-event = "after-open-query" THEN DO:  */
/*                                               */
/*                                               */
/*                                               */
/*     ASSIGN wg-brSon1-cd0354:SCROLLBAR-VERTICAL = NO. */
/*                                               */
/* END.                                          */
/*                                               */
