DEFINE INPUT  PARAM pcod_estabel     LIKE tit_acr.cod_estab.
DEFINE INPUT  PARAM pcod_espec_docto LIKE tit_acr.cod_espec_docto.
DEFINE INPUT  PARAM pcod_ser_docto   LIKE tit_acr.cod_ser_docto.
DEFINE INPUT  PARAM pcod_documento   LIKE tit_acr.cod_tit_acr.
DEFINE INPUT  PARAM pcod_parcela     LIKE tit_acr.cod_parcela.
DEFINE INPUT-OUTPUT PARAM ptc-nossonumero   LIKE tit_acr.cod_tit_acr_bco.

/* ** Tratamento para a re-impress∆o, para n∆o calcular novo n£mero banc†rio ***/
FIND tit_acr NO-LOCK
    WHERE tit_acr.cod_estab            = pcod_estabel    
      AND tit_acr.cod_espec_docto      = pcod_espec_docto
      AND tit_acr.cod_ser              = pcod_ser_docto  
      AND tit_acr.cod_tit_acr          = pcod_documento  
      AND tit_acr.cod_parcela          = pcod_parcela     NO-ERROR.
IF AVAIL tit_acr
AND tit_acr.cod_tit_acr_bco         <> ""
AND LENGTH(tit_acr.cod_tit_acr_bco)  > 11
    THEN ASSIGN ptc-nossonumero = SUBSTRING(tit_acr.cod_tit_acr_bco, 1, 11).
