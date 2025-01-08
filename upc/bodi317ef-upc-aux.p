/*******************************************************************************

*******************************************************************************/
{include/i-prgvrs.i BODI317EF-UPC-AUX 2.00.00.00}
/*******************************************************************************
**
** IM3100-UPC - Permitir que a nota fiscal principal de importa»’o n’o atualize o m½dulo de compras
**
*******************************************************************************/
{cdp/cdcfgdis.i}
{include/i-epc200.i1}

DEF INPUT        PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

RUN gtupc/bodi317ef-upc.p (INPUT p-ind-event,
                           INPUT-OUTPUT TABLE tt-epc).

RUN upc/bodi317ef-upc.p (INPUT p-ind-event,
                         INPUT-OUTPUT TABLE tt-epc).
