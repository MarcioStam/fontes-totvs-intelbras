
/*EPC para o programa: dbapi002 - Considerar lote minimo nos niveis intermediarios*/
{include/i-epc200.i1}


def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.


DEFINE VARIABLE i-plano AS INTEGER   NO-UNDO.


IF p-ind-event = "Before-calc" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event = "Before-calc" 
        AND   tt-epc.cod-parameter = "plan-code":

        ASSIGN i-plano = int(tt-epc.val-parameter).

    END.

    /*IF i-plano = 4 THEN DO:*/

        FOR EACH deposito EXCLUSIVE-LOCK
           WHERE deposito.cod-depos = "EXP"
              OR deposito.cod-depos = "ACA"
              OR deposito.cod-depos = "WEX"
              OR deposito.cod-depos = "CDN"
              OR deposito.cod-depos = "EPE":
    
            ASSIGN deposito.cons-saldo = TRUE.
    
        END.

    /*END.*/

END.

/**/
/**/

IF p-ind-event = "After-Calc" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event = "After-Calc" 
        AND   tt-epc.cod-parameter = "plan-code":

        ASSIGN i-plano = int(tt-epc.val-parameter).

    END.

    /*IF i-plano = 4 THEN DO:*/

        FOR EACH deposito EXCLUSIVE-LOCK
           WHERE deposito.cod-depos = "EXP"
              OR deposito.cod-depos = "ACA"
              OR deposito.cod-depos = "WEX"
              OR deposito.cod-depos = "CDN"
              OR deposito.cod-depos = "EPE":
    
            ASSIGN deposito.cons-saldo = FALSE.
    
        END.

    /*END.*/

END.


RETURN "OK".



