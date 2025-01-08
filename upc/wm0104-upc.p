/*
**    Programa: UPC-WM00104.P  
**    Objetivo: UPC Inicial do programa WM0104
** Atualiza‡Æo: 16-12-2015
*/

{include/i-prgvrs.i UPC-WM0104 2.00.00.001}

DEFINE INPUT PARAMETER p-ind-event   AS CHAR.
DEFINE INPUT PARAMETER p-ind-object  AS CHAR.
DEFINE INPUT PARAMETER p-wgh-object  AS HANDLE.
DEFINE INPUT PARAMETER p-wgh-frame   AS WIDGET-HANDLE.
DEFINE INPUT PARAMETER p-cod-table   AS CHAR.
DEFINE INPUT PARAMETER p-row-table   AS ROWID.

RUN upc/wm0104a-upc.p (INPUT p-ind-event,
                       INPUT p-ind-object,
                       INPUT p-wgh-object,
                       INPUT p-wgh-frame,
                       INPUT p-cod-table,
                       INPUT p-row-table).

IF RETURN-VALUE = "NOK":U THEN
  RETURN "NOK":U.

RETURN "ok":U.
