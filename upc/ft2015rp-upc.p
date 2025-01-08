/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/* {include/i-prgvrs.i ft2015rp-upc 2.03.00.000}   */

/************************************************************************
**
** ft2015rp-upc.P - 
**
*************************************************************************/


define temp-table tt-epc no-undo
   field cod-event     as char format "x(12)"
   field cod-parameter as char format "x(32)"
   field val-parameter as char format "x(54)"
   index  id is primary cod-parameter cod-event ascending.    

def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.


DEFINE VARIABLE r-rowid        AS ROWID       NO-UNDO.

if  p-ind-event = "ThirdPartOperation" THEN DO:   
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = p-ind-event
           tt-epc.cod-parameter = "Validate"
           tt-epc.val-parameter = "NO".
END.

