
/*------------------------------------------------------------------------------------------------
Programa...: epc-reapi325-u01.p
Author.....: JULIANO
Descricao..: EPC Principal
Data.......: MAIO/2023
 

------------------------------------------------------------------------------------------------*/

{include/i-prgvrs.i epc-reapi325-u01 2.04.00.000} 
{utp/ut-glob.i}

{include/i-epc200.i reapi325}
/* Defini‡Æo de parƒmetros de entrada */
DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.


RUN epc/epc-reapi325-u01.p(INPUT p-ind-event,
                           INPUT-OUTPUT TABLE tt-epc).

