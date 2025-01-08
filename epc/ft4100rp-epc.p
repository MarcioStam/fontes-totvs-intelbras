/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT4100RP-EPC 2.00.00.001}  /*** 010001 ***/
/***********************************************************************
**  
**
************************************************************************/

/*--- Defini‡Æo dos Parƒmetros ---*/
{include/i-epc200.i1}

def input parameter p-ind-event as char no-undo.
def input-output param table for tt-epc.

DEF NEW GLOBAL SHARED VAR r-int-ped-venda2 AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_val_dec_1  LIKE int-ped-venda2.dec-2 NO-UNDO.

/*--- Bloco Principal ---*/
CASE p-ind-event:
    WHEN "END-FT4100RP":U THEN DO:

        /*MESSAGE "END-FT4100RP - v_val_dec_1 " v_val_dec_1 VIEW-AS ALERT-BOX.*/

        FIND FIRST int-ped-venda2
            WHERE RECID(int-ped-venda2) = r-int-ped-venda2 EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL int-ped-venda2 THEN DO:
            /*MESSAGE "achou int-ped-venda2 - FT4100RP-epc  - v_val_dec_1 " v_val_dec_1 VIEW-AS ALERT-BOX.*/

            ASSIGN int-ped-venda2.dec-1 = v_val_dec_1.
        END.
    END.
END CASE.

RETURN "OK":U.
