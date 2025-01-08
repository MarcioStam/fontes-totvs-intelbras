/******************************************************************
** Programa: upc-re0708-u00.p
** Objetivo: Chamador padrao de UPC espec­fica
**    Autor: 
**     Data: abril/2023
*******************************************************************/

/* parametros */
DEF INPUT PARAM p-ind-event  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR           NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE         NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR           NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID          NO-UNDO.

RUN upc/upc-re0708-u01.p (INPUT p-ind-event,
                          INPUT p-ind-object,
                          INPUT p-wgh-object,
                          INPUT p-wgh-frame,
                          INPUT p-cod-table,
                           INPUT p-row-table).

RETURN "OK".
