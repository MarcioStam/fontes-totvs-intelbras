/*------------------------------------------------------------------------
    File        : PD1001A-UPC.P
    Purpose     : UPC do programa PD1001A.
    Syntax      : <none>
    Description : <none>

    Created     : Maio de 2013
    Notes       : 001 - 28/05/2013 - Chamada do programa ESPDP078
                  (Ocorrˆncias de pedidos originados no Portal ASTEC)
                  (Fabiano Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE h-pd1001a-upc             AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ocor-pd1001a-upc    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nome-abrev-pd1001a-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-pedcli-pd1001a-upc  AS WIDGET-HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-espdp078  AS HANDLE      NO-UNDO.


/* ***************************  Main Block  *************************** */

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/* Mensagem para verificar o ponto UPC do programa */
/* MESSAGE "Evento....: ":U   p-ind-event      SKIP                      */
/*         "Objeto....: ":U   p-ind-object     SKIP                      */
/*         "Nome Obj..: ":U   c-objeto         SKIP                      */
/*         "Frame.....: ":U   p-wgh-frame:NAME SKIP                      */
/*         "Tabela....: ":U   p-cod-table      SKIP                      */
/*         "Rowid.....: ":U   STRING(p-row-table)                        */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do PD1001A":U. */

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U         AND
   c-objeto     = "pd1001a.w":U         THEN DO:
    RUN upc/pd1001a-upc.p PERSISTENT SET h-pd1001a-upc (INPUT "":U,
                                                        INPUT "":U,
                                                        INPUT p-wgh-object,
                                                        INPUT p-wgh-frame,
                                                        INPUT "":U,
                                                        INPUT p-row-table).

    CREATE BUTTON wh-bt-ocor-pd1001a-upc
    ASSIGN NAME          = "wh-bt-cons-ocor":U
           FRAME         = p-wgh-frame
           COLUMN        = 75.75
           ROW           = 1.25
           WIDTH         = 4.00
           HEIGHT        = 1.25
           TOOLTIP       = "Consultar Ocorrˆncias do Pedido da ASTEC":U
           HELP          = "Consultar Ocorrˆncias do Pedido da ASTEC":U
           FLAT-BUTTON   = YES
           NO-FOCUS      = YES
           WIDTH-PIXELS  = 28
           HEIGHT-PIXELS = 27
           VISIBLE       = YES
           SENSITIVE     = YES
           TRIGGERS:
              ON "CHOOSE":U PERSISTENT RUN pi-cons-ocor-astec IN h-pd1001a-upc.
           END TRIGGERS.

    wh-bt-ocor-pd1001a-upc:LOAD-IMAGE-UP("image/toolbar/im-gera.bmp":U).
    wh-bt-ocor-pd1001a-upc:LOAD-IMAGE-DOWN("image/toolbar/im-gera.bmp":U).
    wh-bt-ocor-pd1001a-upc:LOAD-IMAGE-INSENSITIVE("image/toolbar/ii-gera.bmp":U).
END.

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "VIEWER":U            AND
   c-objeto     = "v31di159.w":U        THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE h-frame:NAME:
                WHEN "nome-abrev":U THEN
                    ASSIGN wh-nome-abrev-pd1001a-upc = h-frame.
                WHEN "nr-pedcli":U THEN
                    ASSIGN wh-nr-pedcli-pd1001a-upc = h-frame.
            END CASE.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    ASSIGN h-frame = ?.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U AND
   c-objeto     = "pd1001a.w":U THEN DO:

    IF VALID-HANDLE(h-pd1001a-upc) THEN
        DELETE PROCEDURE h-pd1001a-upc.

    IF VALID-HANDLE(wh-bt-ocor-pd1001a-upc) THEN
        DELETE WIDGET wh-bt-ocor-pd1001a-upc.

    IF VALID-HANDLE(h-espdp078) THEN
        DELETE PROCEDURE h-espdp078.

    ASSIGN h-pd1001a-upc             = ?
           wh-bt-ocor-pd1001a-upc    = ?
           wh-nome-abrev-pd1001a-upc = ?
           wh-nr-pedcli-pd1001a-upc  = ?
           h-espdp078                = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-cons-ocor-astec :
/*------------------------------------------------------------------------------
  Purpose:     Consultar ocorrˆncias de pedidos da ASTEC (ESPDP078).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(wh-nome-abrev-pd1001a-upc) OR
       NOT VALID-HANDLE(wh-nr-pedcli-pd1001a-upc)  THEN
        RETURN "NOK":U.

    IF  NOT VALID-HANDLE(h-espdp078)                    OR
        h-espdp078:TYPE      <> "PROCEDURE":U           OR
       (h-espdp078:FILE-NAME <> "esp/pdp/espdp078.w":U  AND 
        h-espdp078:FILE-NAME <> "esp/pdp/espdp078.r":U) THEN
        RUN esp/pdp/espdp078.w PERSISTENT SET h-espdp078.

    IF VALID-HANDLE(h-espdp078) THEN DO:

        RUN initializeInterface IN h-espdp078.

/*         FIND FIRST ped-venda                                                                            */
/*             WHERE ped-venda.nome-abrev = TRIM(wh-nome-abrev-pd1001a-upc:SCREEN-VALUE)                   */
/*               AND ped-venda.nr-pedcli  = TRIM(wh-nr-pedcli-pd1001a-upc:SCREEN-VALUE) NO-LOCK NO-ERROR.  */
/*                                                                                                         */
/*         IF AVAILABLE ped-venda THEN                                                                     */
/*             RUN repositionRecord IN h-espdp078 (INPUT ROWID(ped-venda)).                                */
    END.
/*     MESSAGE 'b'                            */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*                                            */
/*     IF VALID-HANDLE(h-espdp078) THEN       */
/*         DELETE PROCEDURE h-espdp078.       */
/*                                            */
/*     MESSAGE 'c'                            */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    /*RETURN "OK":U.*/

END PROCEDURE.

