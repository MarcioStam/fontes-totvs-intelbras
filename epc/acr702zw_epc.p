/*****************************************************************************
** Programa..............: epc_acr702zw
** Versao................:  1.00.00.000
** Nome Externo..........: esp/epc/epc_acr702zw.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 25/09/2008
*****************************************************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_epc_estrategico no-undo
    field ttv_cod_epc_event                as character format "x(12)"
    field ttv_cod_epc_parameters           as character format "x(32)"
    field ttv_cod_epc_msg                  as character format "x(54)"
    index tt_id_epc                        is primary
          ttv_cod_epc_parameters           ascending
          ttv_cod_epc_event                ascending.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_cod_evento
    as character
    format "x(1)"
    no-undo.
def input-output param table 
    for tt_epc_estrategico.

/************************* Parameter Definition End *************************/

/****************************** Main Code Begin *****************************/

DEF BUFFER b_tit_acr                FOR tit_acr.
DEF BUFFER b_tit_acr_cobr_especial  FOR tit_acr_cobr_espec.
DEF BUFFER b_item_lote_impl_tit_acr FOR ITEM_lote_impl_tit_acr.

DEF VAR v_cod_estab      AS CHAR.
DEF VAR v_num_id_tit_acr AS INT.

IF p_cod_evento <> "Percentual" 
   THEN RETURN "OK".

FIND tt_epc_estrategico NO-LOCK
    WHERE tt_epc_estrategico.ttv_cod_epc_parameters = "Agente Cobran‡a"
      AND tt_epc_estrategico.ttv_cod_epc_event      = "Percentual" NO-ERROR.
IF NOT AVAIL tt_epc_estrategico
   THEN RETURN "OK".

IF  tt_epc_estrategico.ttv_cod_epc_msg <> "VISA"
AND tt_epc_estrategico.ttv_cod_epc_msg <> "AMEX"
AND tt_epc_estrategico.ttv_cod_epc_msg <> "REDCA"
    THEN RETURN "OK".

FIND tt_epc_estrategico NO-LOCK
    WHERE tt_epc_estrategico.ttv_cod_epc_parameters = "Estabelecimento"
      AND tt_epc_estrategico.ttv_cod_epc_event      = "Percentual" NO-ERROR.
IF NOT AVAIL tt_epc_estrategico
   THEN RETURN "OK".
ASSIGN v_cod_estab = tt_epc_estrategico.ttv_cod_epc_msg.

FIND tt_epc_estrategico NO-LOCK
    WHERE tt_epc_estrategico.ttv_cod_epc_parameters = "Num Id Titulo"
      AND tt_epc_estrategico.ttv_cod_epc_event      = "Percentual" NO-ERROR.
IF NOT AVAIL tt_epc_estrategico
   THEN RETURN "OK".
ASSIGN v_num_id_tit_acr = INT(tt_epc_estrategico.ttv_cod_epc_msg).

FIND b_tit_acr NO-LOCK
    WHERE b_tit_acr.cod_estab      = v_cod_estab
      AND b_tit_acr.num_id_tit_acr = v_num_id_tit_acr NO-ERROR.
IF NOT AVAIL b_tit_acr 
   THEN RETURN "OK".

FIND b_item_lote_impl_tit_acr NO-LOCK
    WHERE b_item_lote_impl_tit_acr.cod_estab   = b_tit_acr.cod_estab
      AND b_item_lote_impl_tit_acr.cod_espec   = b_tit_acr.cod_espec
      AND b_item_lote_impl_tit_acr.cod_ser     = b_tit_acr.cod_ser
      AND b_item_lote_impl_tit_acr.cod_tit_acr = b_tit_acr.cod_tit_acr
      AND b_item_lote_impl_tit_acr.cod_parcela = b_tit_acr.cod_parcela NO-ERROR.
IF NOT AVAIL b_item_lote_impl_tit_acr 
   THEN RETURN "OK".

/* ** Localizar % conforme Administradora e qtde de parcelas. ***/
FIND ext_admdra_cartao_cr_comis NO-LOCK
    WHERE ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr  = tt_epc_estrategico.ttv_cod_epc_msg
      AND ext_admdra_cartao_cr_comis.num_parc_ini         <= b_item_lote_impl_tit_acr.num_parc_cartcred /* ** 505 - integer(entry(4,b_item_lote_impl_tit_acr.cod_livre_1,chr(24))) */
      AND ext_admdra_cartao_cr_comis.num_parc_fim         >= b_item_lote_impl_tit_acr.num_parc_cartcred /* ** 505 - integer(entry(4,b_item_lote_impl_tit_acr.cod_livre_1,chr(24))) */ NO-ERROR.
IF NOT AVAIL ext_admdra_cartao_cr_comis
   THEN RETURN "OK".

CREATE tt_epc_estrategico.
ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "Retorno Cliente"
       tt_epc_estrategico.ttv_cod_epc_parameters = "Percentual Comissao"
       tt_epc_estrategico.ttv_cod_epc_msg        = string(ext_admdra_cartao_cr_comis.val_perc_comis) /* ** Retorna % cfme parcela e administradora ***/.

RETURN "OK".

/******************************* Main Code End ******************************/

