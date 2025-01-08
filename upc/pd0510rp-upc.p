/****************************************************************************
** Programa: pd0510RP-UPC.P
** Autor   : Hoepers
** Data    : 16/01/2013
** Objetivo: EPC deve ser cadastrada para pd0510rp.p
*****************************************************************************/

{include/i-epc200.i1} /* Definicao da temp-table tt-epc */

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

/*****************************************************************************/  

DEF NEW GLOBAL SHARED VAR wh-estab-ini AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estab-fim AS WIDGET-HANDLE NO-UNDO.

IF  p-ind-event = "aloca-desaloca-pedidos"
THEN DO:
   
    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event     = p-ind-event 
          AND tt-epc.cod-parameter = "ped-venda rowid" NO-ERROR.

    IF  AVAIL tt-epc THEN DO:
        FIND ped-venda NO-LOCK
            WHERE ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF  AVAIL ped-venda
        AND ped-venda.cod-estabel >= wh-estab-ini:SCREEN-VALUE 
        AND ped-venda.cod-estabel <= wh-estab-fim:SCREEN-VALUE 
        THEN.
        ELSE
            RETURN "NOK".
    END.
END.

RETURN "OK".
