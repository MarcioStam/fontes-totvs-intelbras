/*****************************************************************************
** Programa: epc\epc_valida_titulo.p
** VersÆo..: 1.00
** Data....: 26/01/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: EPC para validar a faixa de Grupo de Cobran‡a.
             Chamado atrav‚s dos programas: - epc\acr240aa_epc.p
                                            - epc\acr303aa_epc.
*****************************************************************************/


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-rec-tit-acr      AS RECID       NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-grp-cobr-ini AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-grp-cobr-fim AS INTEGER     NO-UNDO.



/*--- Bloco Principal ---*/
FIND FIRST tit_acr NO-LOCK
    WHERE RECID(tit_acr) = p-rec-tit-acr NO-ERROR.
IF  NOT AVAIL tit_acr THEN
    RETURN "NOK":U.


FIND FIRST int-emitente NO-LOCK
    WHERE  int-emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
IF  NOT AVAIL int-emitente                         OR
   (int-emitente.cod-gr-cob >= p-cod-grp-cobr-ini  AND
    int-emitente.cod-gr-cob <= p-cod-grp-cobr-fim) THEN
    RETURN "OK":U.
ELSE
    RETURN "NOK":U.

