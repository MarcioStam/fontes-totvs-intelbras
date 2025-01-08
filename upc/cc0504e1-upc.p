/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: upc/cc0504e1-upc.p
**  Objetivo.: Espec°fico do programa Consulta Detalhes Entradas Item - CC0504E1
**  Criaá∆o..: 20/05/2010
**  Vers∆o...: 00001 - 20/05/2010 - Inserir campo referànte ao preáo unit†rio do
**             fornecedor. - Fabiano Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

DEFINE NEW GLOBAL SHARED VARIABLE r-rowid-receb-cc0504e-upc   AS ROWID           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-num-ordem-cc0504e1-upc   AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-val-tot-rec-cc0504e1-upc AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-val-unit-cc0504e1-upc    AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-pr-un-forn-cc0504e1-upc  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pr-un-forn-cc0504e1-upc  AS WIDGET-HANDLE   NO-UNDO.

/* Exibir mensagens com os eventos da UPC */
/* MESSAGE "Evento: ":U      p-ind-event  SKIP     */
/*         "Objeto: ":U      p-ind-object SKIP     */
/*         "Nome Objeto: ":U c-objeto     SKIP     */
/*         "Frame: ":U       p-wgh-frame  SKIP     */
/*         "Tabela: ":U      p-cod-table  SKIP     */
/*         "Rowid: ":U       STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX TITLE "Eventos da UPC":U. */

/* Imprimir arquivo texto com os eventos da UPC */
/* OUTPUT TO VALUE("C:/temp/eventos-cc0504e1.txt":U) APPEND CONVERT TARGET SESSION:CHARSET. */
/* PUT UNFORMATTED                                                                          */
/*     "Evento.......: ":U p-ind-event         SKIP                                         */
/*     "Objeto.......: ":U p-ind-object        SKIP                                         */
/*     "Nome Objeto..: ":U c-objeto            SKIP                                         */
/*     "Frame........: ":U p-wgh-frame         SKIP                                         */
/*     "Tabela.......: ":U p-cod-table         SKIP                                         */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                                         */
/*     FILL("-":U, 50)                         SKIP.                                        */
/* OUTPUT CLOSE.                                                                            */

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U         THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "numero-ordem":U     THEN ASSIGN wh-num-ordem-cc0504e1-upc   = h-frame.
                WHEN "de-valor-tot-rec":U THEN ASSIGN wh-val-tot-rec-cc0504e1-upc = h-frame.
                WHEN "de-valor-unit":U    THEN ASSIGN wh-val-unit-cc0504e1-upc    = h-frame.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-val-tot-rec-cc0504e1-upc)    AND
       VALID-HANDLE(wh-val-unit-cc0504e1-upc)       AND
       NOT VALID-HANDLE(tx-pr-un-forn-cc0504e1-upc) AND
       NOT VALID-HANDLE(wh-pr-un-forn-cc0504e1-upc) THEN DO:

        CREATE TEXT tx-pr-un-forn-cc0504e1-upc
        ASSIGN FRAME        = wh-val-unit-cc0504e1-upc:FRAME
               FORMAT       = "x(18)":U
               WIDTH        = 15
               SCREEN-VALUE = "Preáo Unit Fornec:":U
               ROW          = wh-val-unit-cc0504e1-upc:ROW + 0.14
               COLUMN       = wh-val-tot-rec-cc0504e1-upc:COLUMN - 13.2
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-pr-un-forn-cc0504e1-upc
        ASSIGN FRAME             = wh-val-unit-cc0504e1-upc:FRAME
               DATA-TYPE         = "DECIMAL":U
               FORMAT            = ">>>>>,>>>,>>9.99999":U
               WIDTH             = 14
               HEIGHT            = wh-val-unit-cc0504e1-upc:HEIGHT
               ROW               = wh-val-unit-cc0504e1-upc:ROW
               COLUMN            = wh-val-tot-rec-cc0504e1-upc:COLUMN
               HIDDEN            = NO
               SIDE-LABEL-HANDLE = tx-pr-un-forn-cc0504e1-upc:HANDLE
               SENSITIVE         = NO
               VISIBLE           = YES.
    
        wh-pr-un-forn-cc0504e1-upc:MOVE-AFTER-TAB-ITEM(wh-val-unit-cc0504e1-upc).
    END.
END.

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "CONTAINER":U  THEN DO:

    IF VALID-HANDLE(wh-pr-un-forn-cc0504e1-upc) THEN DO:
        FIND FIRST recebimento
            WHERE ROWID(recebimento) = r-rowid-receb-cc0504e-upc NO-LOCK NO-ERROR.
    
        IF AVAILABLE recebimento THEN DO:
            FIND FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = recebimento.numero-ordem NO-LOCK NO-ERROR.

            IF AVAILABLE ordem-compra THEN
                ASSIGN wh-pr-un-forn-cc0504e1-upc:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
            ELSE
                ASSIGN wh-pr-un-forn-cc0504e1-upc:SCREEN-VALUE = "0":U.
        END.
        ELSE
            ASSIGN wh-pr-un-forn-cc0504e1-upc:SCREEN-VALUE = "0":U.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U THEN DO:
    IF VALID-HANDLE(h-frame) THEN
        DELETE OBJECT h-frame.

    IF VALID-HANDLE(wh-num-ordem-cc0504e1-upc) THEN
        ASSIGN wh-num-ordem-cc0504e1-upc = ?.

    IF VALID-HANDLE(wh-val-tot-rec-cc0504e1-upc) THEN
        ASSIGN wh-val-tot-rec-cc0504e1-upc = ?.
    
    IF VALID-HANDLE(wh-val-unit-cc0504e1-upc) THEN
        ASSIGN wh-val-unit-cc0504e1-upc = ?.

    IF VALID-HANDLE(tx-pr-un-forn-cc0504e1-upc) THEN
        ASSIGN tx-pr-un-forn-cc0504e1-upc = ?.

    IF VALID-HANDLE(wh-pr-un-forn-cc0504e1-upc) THEN
        ASSIGN wh-pr-un-forn-cc0504e1-upc = ?.
END.
