/********************************************************************************
 ** UPC........: wuni003.p - UPC WRITE cota‡Æo de moedas(cotac_pardi)
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de cota‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-cotac_parid      FOR cotac_parid.
DEF PARAM BUFFER b-old-cotac_parid  FOR cotac_parid.

/*    MESSAGE b-cotac_parid.cod_indic_econ_base SKIP
        b-cotac_parid.cod_indic_econ_idx  SKIP
        b-cotac_parid.dat_cotac_indic_econ SKIP
        b-cotac_parid.val_cotac_indic_econ
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */
IF b-cotac_parid.cod_indic_econ_base = "real" and
   (b-cotac_parid.cod_indic_econ_idx  = "dolar" OR
    b-cotac_parid.cod_indic_econ_idx  = "euro"  OR
    b-cotac_parid.cod_indic_econ_idx  = "yen") THEN DO:
   run esp/es0669.p (input "yes", 
                     "cotac_parid", 
                     b-cotac_parid.cod_indic_econ_base,
                     b-cotac_parid.cod_indic_econ_idx,
                     b-cotac_parid.ind_tip_cotac_parid,
                     string(b-cotac_parid.dat_cotac_indic_econ), 
                     "", "", "", "", "").
     
END.

RETURN "OK".
