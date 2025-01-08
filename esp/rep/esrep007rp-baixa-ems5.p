DEF INPUT  PARAM p_cod_estab       LIKE tit_ap.cod_estab           NO-UNDO.
DEF INPUT  PARAM p_cdn_fornecedor  LIKE tit_ap.cdn_fornecedor      NO-UNDO.
DEF INPUT  PARAM p_cod_espec_docto LIKE tit_ap.cod_espec_docto     NO-UNDO.
DEF INPUT  PARAM p_cod_ser_docto   LIKE tit_ap.cod_ser_docto       NO-UNDO.
DEF INPUT  PARAM p_cod_tit_ap      LIKE tit_ap.cod_tit_ap          NO-UNDO.
DEF INPUT  PARAM p_cod_parcela     LIKE tit_ap.cod_parcela         NO-UNDO.
DEF OUTPUT PARAM p_dat_liquidac    LIKE tit_ap.dat_liquidac_tit_ap NO-UNDO.
        
FIND tit_ap NO-LOCK
    WHERE tit_ap.cod_estab       = p_cod_estab     
      AND tit_ap.cdn_fornecedor  = p_cdn_fornecedor
      AND tit_ap.cod_espec_docto = p_cod_espec_docto 
      AND tit_ap.cod_ser_docto   = p_cod_ser_docto 
      AND tit_ap.cod_tit_ap      = p_cod_tit_ap    
      AND tit_ap.cod_parcela     = p_cod_parcela NO-ERROR.

IF  AVAIL tit_ap
THEN
    ASSIGN p_dat_liquidac = tit_ap.dat_liquidac_tit_ap.

RETURN "OK".
