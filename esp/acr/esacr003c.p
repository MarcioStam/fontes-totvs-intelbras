/***********************************************************************************
**     Programa.........: esp/acr/esacr003c.p
**     Descricao .......: Convers∆o de valores conforme cotaá∆o da moeda informada
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 03/06/2005
*******************************************************************************/
DEF INPUT  PARAM p-cod-indic     LIKE tit_acr.cod_indic_econ.
DEF INPUT  PARAM p-data          AS DATE.
DEF INPUT  PARAM p-valor         LIKE tit_acr.val_sdo_tit_acr.
DEF OUTPUT PARAM p-valor-convert LIKE tit_acr.val_sdo_tit_acr.
            
IF p-cod-indic <> "REAL" THEN DO:
    FIND emsuni.cotac_parid no-lock 
         WHERE emsuni.cotac_parid.cod_indic_econ_base  = "Real"
         AND   emsuni.cotac_parid.cod_indic_econ_idx   = p-cod-indic
         AND   emsuni.cotac_parid.dat_cotac_indic_econ = p-data
         AND   emsuni.cotac_parid.ind_tip_cotac_parid  = "Real" NO-ERROR.
    IF AVAIL emsuni.cotac_parid THEN
         ASSIGN p-valor-convert = p-valor * TRUNCATE(emsuni.cotac_parid.val_cotac_indic_econ,1).
    ELSE ASSIGN p-valor-convert = p-valor.
END.
ELSE ASSIGN p-valor-convert = p-valor.
