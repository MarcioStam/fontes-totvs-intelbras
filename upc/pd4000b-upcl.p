/***********************************************************************
**  Programa..: UPC\PD4000B-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Parƒmetros do Pedido Venda
**  VersÆo....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

PROCEDURE pi-choose-btdeleteorder:
     MESSAGE "NÆo ‚ Permitido Eliminar Pedidos de Venda!!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
 END PROCEDURE.
