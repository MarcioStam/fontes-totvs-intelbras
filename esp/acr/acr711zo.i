def temp-table tt_alter_tit_acr_base_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T­tulo" column-label "Saldo T­tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»’o" column-label "Prev Liquida»’o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»’o Cobran»a" column-label "Cond Cobran»a"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N’o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran»a" column-label "Tipo Cobran»a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Bancÿria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Bancÿria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N’o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Sequ¼ncia"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi»’o Pagto" column-label "Condi»’o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N’o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N’o" initial no
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending
    .

def temp-table tt_alter_tit_acr_rateio no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_ind_tip_rat_tit_acr          as character format "X(12)" label "Tipo Rateio" column-label "Tipo Rateio"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/N’o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
    .

def temp-table tt_alter_tit_acr_ped_vda no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_ped_vda                  ascending
    .
def temp-table tt_alter_tit_acr_comis no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss’o" column-label "% Comiss’o"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss’o" column-label "% Comis Emiss’o"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/N’o" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss’o" column-label "Tipo Comiss’o"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
    .

def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss’o" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "Previs’o Apresent" column-label "Previs’o Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "Previs’o Cr²dito" column-label "Previs’o Cr²dito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/N’o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usuÿrio" column-label "Usuÿrio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep½sito" label "Destino Cheque" column-label "Destino Cheque"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren_bco           ascending
          tta_num_cheque                   ascending
    .

def temp-table tt_alter_tit_acr_iva no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tributÿvel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending
    .

def temp-table tt_alter_tit_acr_impto_retid_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tributÿvel" column-label "Vl Rendto Tribut"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_impto_refer_tit_acr      ascending
    .


def temp-table tt_alter_tit_acr_cobr_espec_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Sequ¼ncia"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo Cart’o" column-label "C½digo Cart’o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½d Pr²-Autoriza»’o" column-label "C½d Pr²-Autoriza»’o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart’o" column-label "Validade Cart’o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/N’o" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_val_tot_sdo_tit_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Val Total Parcelas" column-label "Val Total Parcelas"
    field tta_cod_autoriz_bco_emissor      as character format "x(6)" label "Autorizacao Venda" column-label "Autorizacao Venda"
    field tta_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq_tit_acr              ascending
    .
def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria»’o" column-label "Tipo Apropria»’o"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropria»’o" column-label "Id Apropria»’o"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    index tt_aprpdspa_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_num_id_aprop_despes_recta    ascending
    index tt_aprpdspa_token                is unique
          tta_cod_estab                    ascending
          tta_num_id_aprop_despes_recta    ascending
    .

def temp-table tt_log_erros_alter_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          ttv_num_mensagem                 ascending
    .

