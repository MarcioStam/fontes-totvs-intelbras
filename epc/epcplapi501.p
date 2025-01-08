/********************************************************************************
**  Programa:epc\epcplapi501.p                                                **
**  Data....: Setembro de 2011                                                 **
**  Autor...: Paulo Cesar Demiciano - ACTVS                                    **
**  Objetivo: Fazer com que o planejamento considere apenas os pedidos         **
**            de venda da Moveleira dentro da Industria                        **
********************************************************************************/

{include/i-epc200.i1} /* Defini»’o tt-EPC */

DEFINE INPUT        PARAM p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE r-ped-venda AS ROWID NO-UNDO.

CASE p-ind-event:
    WHEN "Ped-Exibe" THEN DO:
        FIND FIRST tt-epc NO-LOCK
             WHERE tt-epc.cod-event     = "Ped-Exibe"
               AND tt-epc.cod-parameter = "ped-venda-rowid" NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            ASSIGN r-ped-venda = TO-ROWID(tt-epc.val-parameter).

            FIND FIRST ped-venda NO-LOCK 
                 WHERE ROWID(ped-venda) = r-ped-venda NO-ERROR.
            IF AVAIL ped-venda 
                 AND ped-venda.nome-abrev  <> "INTELBRASSC" THEN
                RETURN "YES":U.
            ELSE
                RETURN "NO":U. 
        END.
    END.
END CASE.

RETURN "ok":u.

   

    
