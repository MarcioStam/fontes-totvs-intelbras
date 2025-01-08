/* ----------------------------------------------------------------------------
   Programa..: upc/boin317ef-upc.p
   Data......: Dezembro / 2004.
   Autor.....: Robinson Rafael Koprowski - Datasul Gestech.
   Objetivo..: Alteracao de status da ped-fiscal na efetivacao da NF
---------------------------------------------------------------------------- */


/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc */
{include/i-epc200.i1}
{utp/utapi019.i}
{utp/ut-glob.i}


DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

message p-ind-event view-as alert-box.

IF p-ind-event = 'beforeEfetivaNota' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
    
    /* Rotina utilizada para validar o cart∆o Intelbras */
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "table-rowid":
    END.
END.
