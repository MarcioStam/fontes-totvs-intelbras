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
**  Programa.: upc/cc0504e-upc.p
**  Objetivo.: Espec°fico do programa Consulta Entradas Item - CC0504E
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

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

DEFINE NEW GLOBAL SHARED VARIABLE r-rowid-receb-cc0504e-upc AS ROWID   NO-UNDO.

/* Exibir mensagens com os eventos da UPC */
/* MESSAGE "Evento: ":U      p-ind-event  SKIP     */
/*         "Objeto: ":U      p-ind-object SKIP     */
/*         "Nome Objeto: ":U c-objeto     SKIP     */
/*         "Frame: ":U       p-wgh-frame  SKIP     */
/*         "Tabela: ":U      p-cod-table  SKIP     */
/*         "Rowid: ":U       STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX TITLE "Eventos da UPC":U. */

/* Imprimir arquivo texto com os eventos da UPC */
/* OUTPUT TO VALUE("C:/temp/eventos-cc0504e.txt":U) APPEND CONVERT TARGET SESSION:CHARSET. */
/* PUT UNFORMATTED                                                                         */
/*     "Evento.......: ":U p-ind-event         SKIP                                        */
/*     "Objeto.......: ":U p-ind-object        SKIP                                        */
/*     "Nome Objeto..: ":U c-objeto            SKIP                                        */
/*     "Frame........: ":U p-wgh-frame         SKIP                                        */
/*     "Tabela.......: ":U p-cod-table         SKIP                                        */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                                        */
/*     FILL("-":U, 50)                         SKIP.                                       */
/* OUTPUT CLOSE.                                                                           */

IF p-ind-object = "BROWSER":U    AND
   c-objeto     = "b37in172.w":U THEN DO:
    ASSIGN r-rowid-receb-cc0504e-upc = p-row-table.
END.
