/***********************************************************************************
** SCM CONCEPT Tecnologia da Informacao
** 
** Programa: CE0830A-UPC - UPC no CE0830 - Chamada para a consulta WM0402.
** Data    : 22 de Junho de 2016
** Autor   : Luciano Mahl
**
***********************************************************************************/
{include/i-prgvrs.i CE0830A-UPC 2.00.00.000}  /*** 010000 ***/
/**********************************************************************************/
/*************************** Global Variable Definitions **************************/
DEFINE NEW GLOBAL SHARED VARIABLE gr-wm-saldo-estoque    AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-ce0830    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-ce0830  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-dep-ce0830      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bloqueado-ce0830    AS WIDGET-HANDLE NO-UNDO.

FOR FIRST wm-saldo-estoq 
    WHERE wm-saldo-estoq.cod-estabel = wh-cod-estabel-ce0830:SCREEN-VALUE AND
          wm-saldo-estoq.cod-local   = wh-cod-dep-ce0830    :SCREEN-VALUE AND
          wm-saldo-estoq.cod-item    = wh-it-codigo-ce0830  :SCREEN-VALUE NO-LOCK.
END.
ASSIGN gr-wm-saldo-estoque = IF AVAIL wm-saldo-estoq THEN ROWID(wm-saldo-estoq) ELSE ?.

IF gr-wm-saldo-estoque <> ? THEN
    RUN wmp/wm0402.r.
/* Fim - ce0830a-upc.p */
