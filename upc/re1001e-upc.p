/***********************************************************************
**  Programa..: upc\re1001e-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/
/*
{utp/ut-glob.i}
*/

/* FOI RETIRADO A UPC DO CADASTRO */
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/* Chamada UPC referente ao Importador XML Gati */
IF  SEARCH("gtupc/upc-re1001e.p") <> ? OR
    SEARCH("gtupc/upc-re1001e.r") <> ?
THEN
    RUN gtupc/upc-re1001e.p (INPUT p-ind-event,
                             INPUT p-ind-object,
                             INPUT p-wgh-object,
                             INPUT p-wgh-frame,
                             INPUT p-cod-table,
                             INPUT p-row-table).
RETURN "OK":U.

