/* -------------------------------------------------------------------------------------------------------------
Programa : epc\acr212id2_epc.p.p
           det_tit_acr_data
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_cod_estab   AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_ser     AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_tit_acr AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER p_val_subst   AS DECIMAL          NO-UNDO.

FIND nota-fiscal NO-LOCK
    WHERE nota-fiscal.cod-estabel = p_cod_estab
      AND nota-fiscal.serie       = p_cod_ser
      AND nota-fiscal.nr-nota-fis = p_cod_tit_acr NO-ERROR.
IF AVAIL nota-fiscal 
THEN DO:
    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
        ASSIGN p_val_subst = p_val_subst + it-nota-fisc.vl-icmsub-it.
    END.
END.

