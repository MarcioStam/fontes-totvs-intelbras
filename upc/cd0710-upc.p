/*****************************************************************************
** Programa..............: cd0710-upc.p
** Descricao.............: UPC para listar solicitante
** Criado em.............: 01/07/2019
** Autor.................: Nicolas Martinez
*****************************************************************************/

/* Parameter Definitions ****************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

DEF VAR c-objeto   AS CHAR     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE tx-solicitante-cd0710-upc      AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-solicitante-cd0710-upc      AS WIDGET-HANDLE   NO-UNDO.

DEFINE VARIABLE wh-cod-emitente-cd0710-upc     AS WIDGET-HANDLE   NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").
/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "VIEWER"     AND 
   c-objeto     = "v01in128.w" 
THEN DO:

    /* ** Desabilita CNPJ ***/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "cod-emitente",  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-emitente-cd0710-upc).

    IF NOT VALID-HANDLE(tx-solicitante-cd0710-upc) AND
       NOT VALID-HANDLE(wh-solicitante-cd0710-upc) THEN DO:

        CREATE TEXT tx-solicitante-cd0710-upc
        ASSIGN FRAME        = wh-cod-emitente-cd0710-upc:FRAME
               FORMAT       = "x(27)":U
               WIDTH        = 27
               SCREEN-VALUE = "Solicitante:":U
               ROW          = wh-cod-emitente-cd0710-upc:SIDE-LABEL-HANDLE:ROW + 1.15
               COLUMN       = 12.85
               VISIBLE      = YES.

        CREATE FILL-IN wh-solicitante-cd0710-upc
        ASSIGN FRAME             = wh-cod-emitente-cd0710-upc:FRAME
               DATA-TYPE         = "CHARACTER":U
               FORMAT            = "X(25)":U
               SIDE-LABEL-HANDLE = tx-solicitante-cd0710-upc:HANDLE
               WIDTH             = 22.79
               HEIGHT            = 0.88
               ROW               = wh-cod-emitente-cd0710-upc:ROW + 1
               COLUMN            = wh-cod-emitente-cd0710-upc:COLUMN
               HIDDEN            = NO
               HELP              = "Solicitante da NF de entrada":U
               TOOLTIP           = "Solicitante da NF de entrada":U
               SENSITIVE         = NO
               VISIBLE           = YES.
    END.
END.

IF p-ind-event  = "DISPLAY" AND 
   p-ind-object = "VIEWER"     AND 
   c-objeto     = "v01in128.w" 
THEN DO:

    FIND FIRST movto-estoq WHERE
         ROWID(movto-estoq) = p-row-table 
         NO-LOCK NO-ERROR.

    IF AVAIL movto-estoq
    THEN DO:

        IF movto-estoq.esp-docto = 21 OR /* NFE */
           movto-estoq.esp-docto = 20    /* NFD */
        THEN DO:

            FIND FIRST int-docum-est WHERE
                       int-docum-est.serie-docto  = movto-estoq.serie-docto  AND
                       int-docum-est.nro-docto    = movto-estoq.nro-docto    AND
                       int-docum-est.cod-emitente = movto-estoq.cod-emitente AND
                       int-docum-est.nat-operacao = movto-estoq.nat-operacao
                       NO-LOCK NO-ERROR.

            IF VALID-HANDLE(wh-solicitante-cd0710-upc) AND
               AVAIL int-docum-est
            THEN ASSIGN wh-solicitante-cd0710-upc:SCREEN-VALUE = STRING(int-docum-est.nom-solicitante).

        END.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:

    IF VALID-HANDLE(tx-solicitante-cd0710-upc) THEN
        DELETE WIDGET tx-solicitante-cd0710-upc.

    IF VALID-HANDLE(wh-solicitante-cd0710-upc) THEN
        DELETE WIDGET wh-solicitante-cd0710-upc.

    ASSIGN tx-solicitante-cd0710-upc  = ?
           wh-solicitante-cd0710-upc  = ?.

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
