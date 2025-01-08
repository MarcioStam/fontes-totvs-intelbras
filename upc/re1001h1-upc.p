/*------------------------------------------------------------------------
    File        : RE1001H1-UPC.P
    Purpose     : UPC do programa RE1001H1.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Abril de 2013
    Notes       : 001 - 19/04/2013 - Implementa‡Æo da chamada … UPC
                  "gtupc/upc-re1001h1.p" desenvolvida pela Gati
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

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto  AS CHARACTER   NO-UNDO.


/* ***************************  Main Block  *************************** */

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/* Mensagem para verificar o ponto UPC do programa */
/* MESSAGE "Evento: ":U   p-ind-event  SKIP                             */
/*         "Objeto: ":U   p-ind-object SKIP                             */
/*         "Nome Obj: ":U c-objeto     SKIP                             */
/*         "Frame: ":U    p-wgh-frame  SKIP                             */
/*         "Tabela: ":U   p-cod-table  SKIP                             */
/*         "Rowid: ":U    STRING(p-row-table)                           */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do RE1001H1":U. */


/* Chamada UPC referente ao Importador XML Gati */
IF  SEARCH("gtupc/upc-re1001h1.p") <> ? OR
    SEARCH("gtupc/upc-re1001h1.r") <> ?
THEN
    RUN gtupc/upc-re1001h1.p (INPUT p-ind-event,
                              INPUT p-ind-object,
                              INPUT p-wgh-object,
                              INPUT p-wgh-frame,
                              INPUT p-cod-table,
                              INPUT p-row-table).
RETURN "OK":U.

