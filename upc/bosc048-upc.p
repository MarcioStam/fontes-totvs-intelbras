/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
*******************************************************************************/

{include/i-epc200.i1}

def input param  p-ind-event as char no-undo.
def input-output param table for tt-epc.

FIND FIRST tt-epc. 

CASE p-ind-event:
    WHEN "getLocalDeposito" THEN DO:
        for first tt-epc 
            where tt-epc.cod-event = p-ind-event
              AND tt-epc.val-parameter = "cod-depos":

        END.
    END.
END.

/* Fim do programa EPC */


