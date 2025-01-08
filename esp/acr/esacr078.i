DEF VAR v_cod_portador         AS CHAR NO-UNDO.
DEF VAR v_cod_admdra_cartao_cr AS CHAR NO-UNDO.
DEF VAR v_cod_cartao_cr        AS CHAR NO-UNDO.
DEF VAR v_cod_num_cart_cred    AS CHAR NO-UNDO.
DEF VAR v_cod_cart_bcia        AS CHAR NO-UNDO.
DEF VAR v_cod_aux              AS CHAR NO-UNDO.

def temp-table tt_integr_acr_item_lote_impl_9 no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»Æo Cobran»a" column-label "Cond Cobran»a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico PadrÆo" column-label "Hist½rico PadrÆo"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»Æo" column-label "Prev Liquida»Æo"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Bancÿria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Bancÿria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi»Æo Pagamento" column-label "Condi»Æo Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag¼ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»Æo T­tulo" column-label "Situa»Æo T­tulo"
    field tta_log_liquidac_autom           as logical format "Sim/NÆo" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo CartÆo" column-label "C½digo CartÆo"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade CartÆo" column-label "Validade CartÆo"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½d Pr²-Autoriza»Æo" column-label "C½d Pr²-Autoriza»Æo"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concessionÿria" column-label "Concessionÿria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/NÆo" initial no label "D²bito Automÿtico" column-label "D²bito Automÿtico"
    field tta_log_destinac_cobr            as logical format "Sim/NÆo" initial no label "Destin Cobran»a" column-label "Destin Cobran»a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Bancÿria" column-label "Sit Bancÿria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»Æo" column-label "Cota»Æo"
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo Cÿlculo Juros" column-label "Tipo Cÿlculo Juros"
    field ttv_cod_comprov_vda_aux          as character format "x(12)"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_cod_autoriz_bco_emissor      as character format "x(6)" label "Codigo Autoriza»Æo" column-label "Codigo Autoriza»Æo"
    field ttv_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    field ttv_cod_estab_vendor             as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi»Æo Pagto" column-label "Condi»Æo Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/NÆo" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/NÆo" initial no
    field ttv_cod_estab_portad             as character format "x(8)"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta»Æo" column-label "Processo Exporta»Æo"
    field ttv_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito PIS" column-label "Vl Cred PIS/PASEP"
    field ttv_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito COFINS" column-label "Credito COFINS"
    field ttv_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito CSLL" column-label "Credito CSLL"
    field tta_cod_indic_econ_desemb        as character format "x(8)" label "Moeda Desembolso" column-label "Moeda Desembolso"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field ttv_cod_nota_fisc_faturam        as character format "x(16)"
    field tta_cod_band                     as character format "x(10)" label "Bandeira" column-label "Bandeira"
    field tta_cod_tid                      as character format "x(10)" label "TID" column-label "TID"
    field tta_cod_terminal                 as character format "x(8)" label "Nr Terminal" column-label "Nr Terminal"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending
    .

def new shared temp-table tt_integr_acr_aprop_relacto no-undo 
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ? 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl" 
    . 

def temp-table tt_integr_acr_aprop_relacto_2 no-undo
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ?
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    .

def new shared temp-table tt_integr_acr_abat_antecip no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_espec_docto              ascending 
          tta_cod_ser_docto                ascending 
          tta_cod_tit_acr                  ascending 
          tta_cod_parcela                  ascending. 

def new shared temp-table tt_integr_acr_abat_prev no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat" 
    field tta_log_zero_sdo_prev            as logical format "Sim/NÆo" initial no label "Zera Saldo" column-label "Zera Saldo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_espec_docto              ascending 
          tta_cod_ser_docto                ascending 
          tta_cod_tit_acr                  ascending 
          tta_cod_parcela                  ascending. 

def new shared temp-table tt_integr_acr_aprop_ctbl_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa" 
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo" 
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo" 
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»Æo" column-label "UF" 
    field tta_log_impto_val_agreg          as logical format "Sim/NÆo" initial no label "Impto Val Agreg" column-label "Imp Vl Agr" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_plano_cta_ctbl           ascending 
          tta_cod_cta_ctbl                 ascending 
          tta_cod_cta_ctbl_ext             ascending 
          tta_cod_sub_cta_ctbl_ext         ascending 
          tta_cod_unid_negoc               ascending 
          tta_cod_unid_negoc_ext           ascending 
          tta_cod_plano_ccusto             ascending 
          tta_cod_ccusto                   ascending 
          tta_cod_ccusto_ext               ascending 
          tta_cod_tip_fluxo_financ         ascending 
          tta_cod_fluxo_financ_ext         ascending 
          tta_log_impto_val_agreg          ascending. 

def new shared temp-table tt_integr_acr_aprop_desp_rec no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg" 
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria»Æo" column-label "Tipo Apropria»Æo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_cta_ctbl_ext             ascending 
          tta_cod_sub_cta_ctbl_ext         ascending 
          tta_cod_unid_negoc_ext           ascending 
          tta_cod_fluxo_financ_ext         ascending 
          tta_cod_plano_cta_ctbl           ascending 
          tta_cod_cta_ctbl                 ascending 
          tta_cod_unid_negoc               ascending 
          tta_cod_tip_fluxo_financ         ascending 
          tta_ind_tip_aprop_recta_despes   ascending 
          tta_cod_tip_abat                 ascending. 

def new shared temp-table tt_integr_acr_aprop_liq_antec no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T­tulo" column-label "Unid Negoc T­tulo" 
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit" 
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido". 

def new shared temp-table tt_integr_acr_cheq no-undo 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria" 
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente" 
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque" 
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss" 
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep½sito" column-label "Dep½sito" 
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "PrevisÆo Dep½sito" column-label "PrevisÆo Dep½sito" 
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto" 
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc" 
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque" 
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente" 
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal" 
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu»Æo" column-label "Motivo Devolu»Æo" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usuÿrio" column-label "Usuÿrio" 
    field tta_log_pend_cheq_acr            as logical format "Sim/NÆo" initial no label "Cheque Pendente" column-label "Cheque Pendente" 
    field tta_log_cheq_terc                as logical format "Sim/NÆo" initial no label "Cheque Terceiro" column-label "Cheque Terceiro" 
    field tta_log_cheq_acr_renegoc         as logical format "Sim/NÆo" initial no label "Cheque Reneg" column-label "Cheque Reneg" 
    field tta_log_cheq_acr_devolv          as logical format "Sim/NÆo" initial no label "Cheque Devolvido" column-label "Cheque Devolvido" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s" 
    index tt_id                            is primary unique 
          tta_cod_banco                    ascending 
          tta_cod_agenc_bcia               ascending 
          tta_cod_cta_corren               ascending 
          tta_num_cheque                   ascending 
    . 

def new shared temp-table tt_integr_acr_impto_impl_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»Æo" column-label "UF" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq" 
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tributÿvel" column-label "Vl Rendto Tribut" 
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq" 
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»Æo" column-label "Cota»Æo" 
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota»Æo" column-label "Data Cota»Æo" 
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_pais                     ascending 
          tta_cod_pais_ext                 ascending 
          tta_cod_unid_federac             ascending 
          tta_cod_imposto                  ascending 
          tta_cod_classif_impto            ascending 
          tta_num_seq                      ascending. 

def new shared temp-table tt_integr_acr_item_lote_impl no-undo 
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ? 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira" 
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa" 
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»Æo Cobran»a" column-label "Cond Cobran»a" 
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento" 
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico PadrÆo" column-label "Hist½rico PadrÆo" 
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante" 
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento" 
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»Æo" column-label "Prev Liquida»Æo" 
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto" 
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo" 
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor" 
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto" 
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto" 
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia" 
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr" 
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico" 
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria" 
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco" 
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente" 
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Bancÿria 1" column-label "Instr Banc 1" 
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Bancÿria 2" column-label "Instr Banc 2" 
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros" 
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido" 
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie" 
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi»Æo Pagamento" column-label "Condi»Æo Pagamento" 
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag¼ncia" 
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»Æo T­tulo" column-label "Situa»Æo T­tulo" 
    field tta_log_liquidac_autom           as logical format "Sim/NÆo" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica" 
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber" 
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR" 
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta" 
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora" 
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo CartÆo" column-label "C½digo CartÆo" 
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade CartÆo" column-label "Validade CartÆo" 
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½digo Autoriza»Æo" column-label "C½digo Autoriza»Æo" 
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Compra" column-label "Data Compra" 
    field tta_cod_conces_telef             as character format "x(5)" label "Concessionÿria" column-label "Concessionÿria" 
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD" 
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo" 
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar" 
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a" 
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato" 
    field tta_log_db_autom                 as logical format "Sim/NÆo" initial no label "D²bito Automÿtico" column-label "D²bito Automÿtico" 
    field tta_log_destinac_cobr            as logical format "Sim/NÆo" initial no label "Destin Cobran»a" column-label "Destin Cobran»a" 
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Bancÿria" column-label "Sit Bancÿria" 
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco" 
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr" 
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat" 
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento" 
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento" 
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a" 
    index tt_id                            is primary unique 
          ttv_rec_lote_impl_tit_acr        ascending 
          tta_num_seq_refer                ascending 
    . 

def temp-table tt_integr_acr_liquidac_lote no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_cod_usuario                  as character format "x(12)" label "Usuÿrio" column-label "Usuÿrio" 
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira" 
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»Æo" column-label "Dat Transac" 
    field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Gera»Æo" column-label "Data Gera»Æo" 
    field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado" 
    field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto" 
    field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia" 
    field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao" 
    field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digita»Æo" label "Situa»Æo" column-label "Situa»Æo" 
    field tta_nom_arq_movimen_bcia         as character format "x(30)" label "Nom Arq Bancaria" column-label "Nom Arq Bancaria" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_log_enctro_cta               as logical format "Sim/NÆo" initial no label "Encontro de Contas" column-label "Encontro de Contas" 
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1" 
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1" 
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1" 
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1" 
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1" 
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2" 
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2" 
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2" 
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2" 
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2" 
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ? 
    field ttv_log_atualiz_refer            as logical format "Sim/NÆo" initial no 
    field ttv_log_gera_lote_parcial        as logical format "Sim/NÆo" initial no 
    index tt_itlqdccr_id                   is primary unique 
          tta_cod_estab_refer              ascending 
          tta_cod_refer                    ascending. 

def temp-table tt_integr_acr_liq_item_lote no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira" 
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa" 
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data Cr²dito" column-label "Data Cr²dito" 
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada" 
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquida»Æo" column-label "Liquida»Æo" 
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autoriza»Æo Bco" column-label "Autorizacao Bco" 
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor" 
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida»Æo" column-label "Vl Liquida»Æo" 
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc" 
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento" 
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc" 
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa" 
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros" 
    field tta_val_cm_tit_acr               as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM" 
    field tta_val_liquidac_orig            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquid Orig" column-label "Vl Liquid Orig" 
    field tta_val_desc_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Orig" column-label "Vl Desc Orig" 
    field tta_val_abat_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat Orig" column-label "Vl Abat Orig" 
    field tta_val_despes_bcia_orig         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Bcia Orig" column-label "Vl Desp Bcia Orig" 
    field tta_val_multa_tit_acr_origin     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa Orig" column-label "Vl Multa Orig" 
    field tta_val_juros_tit_acr_orig       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Juros Orig" column-label "Vl Juros Orig" 
    field tta_val_cm_tit_acr_orig          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM Orig" column-label "Vl CM Orig" 
    field tta_val_nota_db_orig             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Nota DB" column-label "Valor Nota DB" 
    field tta_log_gera_antecip             as logical format "Sim/NÆo" initial no label "Gera Antecipacao" column-label "Gera Antecipacao" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico" 
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situa»Æo Item Lote" column-label "Situa»Æo Item Lote" 
    field tta_log_gera_avdeb               as logical format "Sim/NÆo" initial no label "Gera Aviso D²bito" column-label "Gera Aviso D²bito" 
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso D²bito" column-label "Moeda Aviso D²bito" 
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD" 
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD" 
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD" 
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito" 
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso D²bito" column-label "Aviso D²bito" 
    field tta_log_movto_comis_estordo      as logical format "Sim/NÆo" initial no label "Estorna ComissÆo" column-label "Estorna ComissÆo" 
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item" 
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ? 
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9" 
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1" 
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2" 
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1" 
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2" 
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1" 
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2" 
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1" 
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2" 
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1" 
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2" 
    index tt_rec_index                     
          ttv_rec_lote_liquidac_acr        ascending. 

def new shared temp-table tt_integr_acr_lote_impl no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field ttv_cod_empresa_ext              as character format "x(3)" label "C½digo Empresa Ext" column-label "C½d Emp Ext" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»Æo" column-label "Dat Transac" 
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie" 
    field tta_ind_orig_tit_acr             as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec" 
    field tta_val_tot_lote_impl_tit_acr    as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Total Movimento" 
    field tta_val_tot_lote_infor_tit_acr   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado" 
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran»a" column-label "Tipo Cobran»a" 
    field ttv_log_lote_impl_ok             as logical format "Sim/NÆo" initial no 
    field tta_log_liquidac_autom           as logical format "Sim/NÆo" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica" 
    index tt_id                            is primary unique 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_refer                    ascending. 

def new shared temp-table tt_integr_acr_ped_vda_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda" 
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres" 
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip" 
    field tta_val_origin_ped_vda           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ped Venda" column-label "Original Ped Venda" 
    field tta_val_sdo_ped_vda              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Pedido Venda" column-label "Saldo Pedido Venda" 
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_ped_vda                  ascending. 

def NEW shared temp-table tt_integr_acr_relacto_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab_tit_acr_pai        as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field ttv_cod_estab_tit_acr_pai_ext    as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field tta_num_id_tit_acr_pai           as integer format "9999999999" initial 0 label "Token" column-label "Token"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_relacto_tit_acr          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Relacto" column-label "Vl Relacto"
    field tta_log_gera_alter_val           as logical format "Sim/NÆo" initial no label "Gera Alter Valor" column-label "Gera Alter Valor"
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera»Æo" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    .
def new shared temp-table tt_integr_acr_relacto_pend_cheq no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria" 
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente" 
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque" 
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado" 
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Salÿrio" column-label "Banco Cheque Salÿrio" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_banco                    ascending 
          tta_cod_agenc_bcia               ascending 
          tta_cod_cta_corren               ascending 
          tta_num_cheque                   ascending. 

def new shared temp-table tt_integr_acr_repres_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante" 
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% ComissÆo" column-label "% ComissÆo" 
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis EmissÆo" column-label "% Comis EmissÆo" 
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento" 
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto" 
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros" 
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa" 
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA" 
    field tta_log_comis_repres_proporc     as logical format "Sim/NÆo" initial no label "Comis Proporcional" column-label "Comis Propor" 
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo ComissÆo" column-label "Tipo ComissÆo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cdn_repres                   ascending 
    . 

def temp-table tt_integr_acr_repres_comis_2 no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo Comis Externo" column-label "Tipo Comis Externo"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext"
    .

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .


def temp-table tt_atualizar_vendor no-undo
    field tta_cod_estab_tit_acr            as character format "x(8)" label "Estab T­tulo ACR" column-label "Estab T­tulo ACR"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_planilha_vendor          as integer format ">>>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_cond_pagto_vendor        as character format "x(3)" label "Condi»Æo Pagto" column-label "Condi»Æo Pagto"
    field tta_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 initial 0 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field tta_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field tta_qti_dias_carenc_fechto       as Integer format "->>9" initial 0 label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_log_compon_planilha          as logical format "Sim/NÆo" initial no label "Compoem Planilha" column-label "Compoem Planilha"
    field tta_val_origin_dupl_vendor       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_cod_refer_planilha_vendor    as character format "x(10)" label "Refer¼ncia Planilha" column-label "Refer¼ncia Planilha"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_ind_tip_reg_dupl_vendor      as character format "x(24)" label "Tipo do Registro" column-label "Tipo do Registro"
    field tta_log_assume_tax_bco           as logical format "Sim/NÆo" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field tta_cod_estab_planilha_antecip   as character format "x(3)" label "Estab Antecip" column-label "Estab Antecip"
    field tta_num_planilha_vendor_antecip  as integer format ">>>>,>>>,>>9" initial 0 label "Planilha Vdr Antecip" column-label "Planilha Vdr Antecip"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran»a" column-label "Tipo Cobran»a"
    field ttv_num_opcao                    as integer format ">>9"
    field ttv_num_tipo                     as integer format ">>9"
    field ttv_num_origem                   as integer format "9" label "Origem" column-label "Origem"
    field ttv_num_tabela                   as integer format ">>9"
    field ttv_log_documen_vendor           as logical format "Sim/NÆo" initial no
    index tt_dplvndr_id                    is primary unique
          tta_cod_estab_tit_acr            ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq                      ascending
    index tt_dplvndr_planilha             
          tta_cod_estab                    ascending
          tta_num_planilha_vendor          ascending
          tta_cod_cond_pagto_vendor        ascending
          tta_dat_base_fechto_vendor       ascending
          tta_cdn_cliente                  ascending
          tta_cdn_repres                   ascending
          tta_val_cotac_tax_vendor_clien   ascending
          tta_cod_portador                 ascending
          tta_cod_indic_econ               ascending
    index tt_dplvndr_planilha_antecip     
          tta_cod_estab_planilha_antecip   ascending
          tta_num_planilha_vendor_antecip  ascending
    index tt_dplvndr_refer                
          tta_cod_estab_refer              ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
    .

def temp-table tt_dados_planilha_vendor no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_num_planilha_vendor          as integer format ">>>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_cotac_tax_vendor_bco     as decimal format ">>9.9999999999" decimals 10 initial 0 label "Taxa Vendor Banco" column-label "Taxa Vendor Banco"
    field tta_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 initial 0 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field tta_log_assume_tax_bco           as logical format "Sim/NÆo" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field tta_dat_fechto_vendor            as date format "99/99/9999" initial ? label "Data Fechamento" column-label "Data Fechamento"
    field tta_val_tot_contrat_vendor       as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Total" column-label "Valor Total"
    field tta_val_aliq_impto_operfin       as decimal format ">9.999999" decimals 6 initial 0 label "Aliq IOF Dia" column-label "Aliq IOF Dia"
    field tta_num_pessoa_fisic_vendor_1    as integer format ">>>,>>>,>>9" initial 0 label "Testemunha 1" column-label "Testemunha 1"
    field tta_num_pessoa_fisic_vendor_2    as integer format ">>>,>>>,>>9" initial 0 label "Testemunha 2" column-label "Testemunha 2"
    field tta_val_perc_repactuac           as decimal format ">>9.999999" decimals 6 initial 0 label "Percent Repactuado" column-label "Percent Repactuado"
    field tta_ind_orig_contrat_vendor      as character format "X(15)" initial "Duplicatas" label "Origem Contr Vendor" column-label "Origem Contr Vendor"
    field tta_ind_equaliz_vencto           as character format "X(10)" initial "Fechamento" label "Equaliz. Vencimento" column-label "Equaliz. Vencimento"
    field tta_ind_dest_impto_operac_cr     as character format "X(17)" initial "Soma nas Parcelas" label "Destino IOF" column-label "Destino IOF"
    field tta_ind_sit_planilha_vendor      as character format "X(12)" initial "Em Digita»Æo" label "Situa»Æo" column-label "Situa»Æo"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_metod_calc_vendor        as character format "x(5)" label "M²todo de Cÿlculo" column-label "M²todo Cÿlculo"
    field tta_cod_atrib_utiliz_usuar_1     as character format "x(20)" label "Atributo Usuÿrio 1" column-label "Atributo Usuÿrio 1"
    field tta_cod_atrib_utiliz_usuar_2     as character format "x(20)" label "Atributo Usuÿrio 2" column-label "Atributo Usuÿrio 2"
    field tta_cod_atrib_utiliz_usuar_3     as character format "x(20)" label "Atributo Usuÿrio 3" column-label "Atributo Usuÿrio 3"
    field tta_cod_atrib_utiliz_usuar_4     as character format "x(20)" label "Atributo Usuÿrio 4" column-label "Atributo Usuÿrio 4"
    field tta_cod_atrib_utiliz_usuar_5     as character format "x(20)" label "Atributo Usuÿrio 5" column-label "Atributo Usuÿrio 5"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_usuario                  as character format "x(12)" label "Usuÿrio" column-label "Usuÿrio"
    field tta_dat_gerac_vendor             as date format "99/99/9999" initial ? label "Dt Gera»Æo Planilha" column-label "Dt Gera»Æo Planilha"
    field tta_hra_gerac_vendor             as Character format "99:99:99" label "Hra Gera»Æo Planilha" column-label "Hra Gera»Æo Planilha"
    index tt_plnlhvnd_cliente             
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_plnlhvnd_dat_fecham          
          tta_dat_fechto_vendor            ascending
          tta_cod_estab                    ascending
          tta_cod_portador                 ascending
          tta_cod_cart_bcia                ascending
          tta_cod_finalid_econ             ascending
    index tt_plnlhvnd_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_planilha_vendor          ascending
    index tt_plnlhvnd_metod_calc          
          tta_cod_metod_calc_vendor        ascending
    index tt_plnlhvnd_repres              
          tta_cod_empresa                  ascending
          tta_cdn_repres                   ascending
    .


def temp-table tt_log_erros_atualiz_vdr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .

def new shared temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending
    .

def new shared temp-table tt_integr_acr_relacto_pend_aux no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_nota_vincul              as logical format "Sim/NÊo" initial yes
    .

def new global shared var v_cod_aplicat_dtsul_corren 
    as character 
    format "x(3)" 
    no-undo. 
def new global shared var v_cod_ccusto_corren 
    as character 
    format "x(11)" 
    label "Centro Custo" 
    column-label "Centro Custo" 
    no-undo. 
def var v_cod_compl_padr_tmp 
    as character 
    format "x(8)" 
    label "Complemento PadrÆo" 
    column-label "Comp Pad" 
    no-undo. 
def new global shared var v_cod_dwb_user 
    as character 
    format "x(21)" 
    label "Usuÿrio" 
    column-label "Usuÿrio" 
    no-undo. 
def new global shared var v_cod_empres_usuar 
    as character 
    format "x(3)" 
    label "Empresa" 
    column-label "Empresa" 
    no-undo. 
def new global shared var v_cod_estab_usuar 
    as character 
    format "x(3)" 
    label "Estabelecimento" 
    column-label "Estab" 
    no-undo. 
def var v_cod_finalid_econ 
    as character 
    format "x(10)" 
    label "Finalidade EconËmica" 
    column-label "Finalidade EconËmica" 
    no-undo. 
def new global shared var v_cod_funcao_negoc_empres 
    as character 
    format "x(50)" 
    no-undo. 
def new global shared var v_cod_grp_usuar_lst 
    as character 
    format "x(3)" 
    label "Grupo Usuÿrios" 
    column-label "Grupo" 
    no-undo. 
def new global shared var v_cod_idiom_usuar 
    as character 
    format "x(8)" 
    label "Idioma" 
    column-label "Idioma" 
    no-undo. 
def var v_cod_indic_econ_usu 
    as character 
    format "x(8)" 
    label "Moeda" 
    column-label "Moeda" 
    no-undo. 
def var v_cod_matriz_trad_fluxo_ext 
    as character 
    format "x(8)" 
    label "Matriz Trad Fluxo" 
    column-label "Matriz Trad Fluxo" 
    no-undo. 
def new global shared var v_cod_modul_dtsul_corren 
    as character 
    format "x(3)" 
    label "M½dulo Corrente" 
    column-label "M½dulo Corrente" 
    no-undo. 
def new global shared var v_cod_modul_dtsul_empres 
    as character 
    format "x(100)" 
    no-undo. 
def new global shared var v_cod_pais_empres_usuar 
    as character 
    format "x(3)" 
    label "Pa­s Empresa Usuÿrio" 
    column-label "Pa­s" 
    no-undo. 
def new global shared var v_cod_plano_ccusto_corren 
    as character 
    format "x(8)" 
    label "Plano CCusto" 
    column-label "Plano CCusto" 
    no-undo. 
def var v_cod_prog 
    as character 
    format "x(35)" 
    label "Arquivo Origem" 
    column-label "Arquivo Origem" 
    no-undo. 
def var v_cod_return 
    as character 
    format "x(40)" 
    no-undo. 
def var v_cod_tip_val 
    as character 
    format "x(8)" 
    initial "C" /*l_letra_C*/ 
    no-undo. 
def new global shared var v_cod_unid_negoc_usuar 
    as character 
    format "x(3)" 
    view-as combo-box 
    list-items "" 
    inner-lines 5 
    bgcolor 15 font 2 
    label "Unidade Neg½cio" 
    column-label "Unid Neg½cio" 
    no-undo. 
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)" 
    label "Usuÿrio Corrente" 
    column-label "Usuÿrio Corrente" 
    no-undo. 
def new global shared var v_cod_usuar_corren_criptog 
    as character 
    format "x(16)" 
    no-undo. 
def var v_dat_cotac_indic_econ 
    as date 
    format "99/99/9999" 
    initial today 
    label "Data Cota»Æo" 
    column-label "Data Cota»Æo" 
    no-undo. 
def var v_dat_prev_desc_cheq_acr 
    as date 
    format "99/99/9999" 
    label "Data Prev Desc" 
    column-label "Data Prev Desc" 
    no-undo. 
def var v_des_text_histor_padr 
    as character 
    format "x(2000)" 
    view-as editor max-chars 2000 scrollbar-vertical 
    size 60 by 4 
    bgcolor 15 font 2 
    label "Texto Hist½rico Padr" 
    column-label "Texto Hist½rico Padr" 
    no-undo. 
def var v_des_text_histor_padr_infor 
    as character 
    format "x(40)" 
    view-as editor max-chars 2000 scrollbar-vertical 
    size 60 by 2 
    bgcolor 15 font 2 
    no-undo. 
def var v_des_text_histor_padr_inic 
    as character 
    format "x(40)" 
    view-as editor max-chars 2000 scrollbar-vertical 
    size 60 by 2 
    bgcolor 15 font 2 
    no-undo. 
def new global shared var v_hdl_api_integr_acr
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_ind_criter_distrib_ccusto 
    as character 
    format "X(15)" 
    initial "Utiliza Todos" /*l_utiliza_todos*/ 
    view-as combo-box 
    list-items "NÆo Utiliza","Utiliza Todos","Definidos" 
     /*l_nao_utiliza*/ /*l_utiliza_todos*/ /*l_definidos*/ 
    inner-lines 5 
    bgcolor 15 font 2 
    label "Crit²rio Dist CCusto" 
    column-label "Crit²rio Dist CCusto" 
    no-undo. 
def var v_ind_modo_impl 
    as character 
    format "X(08)" 
    no-undo. 
def var v_ind_tip_refer_acr 
    as character 
    format "X(30)" 
    no-undo. 
def var v_log_atualiza_refer_acr 
    as logical 
    format "Sim/NÆo" 
    initial yes 
    view-as toggle-box 
    label "Atualiza Refer¼ncia" 
    column-label "Atualiza Refer¼ncia" 
    no-undo. 
def new shared var v_log_rat_difer 
    as logical 
    format "Sim/NÆo" 
    initial no 
    no-undo. 
def var v_log_refer_uni 
    as logical 
    format "Sim/NÆo" 
    initial yes 
    no-undo. 
def new global shared var v_num_ped_exec_corren 
    as integer 
    format ">>>>9" 
    no-undo. 
def var v_num_pessoa 
    as integer 
    format ">>>,>>>,>>9" 
    label "Pessoa" 
    column-label "Pessoa" 
    no-undo. 
def var v_rec_log 
    as recid 
    format ">>>>>>9" 
    no-undo. 
def new global shared var v_rec_lote_impl_tit_acr 
    as recid 
    format ">>>>>>9" 
    initial ? 
    no-undo. 
def var v_val_cheque_ie 
    as decimal 
    format ">>>,>>>,>>9.99" 
    decimals 2 
    label "Valor Cheque" 
    column-label "Valor Cheque" 
    no-undo. 
def var v_val_cotac_indic_econ 
    as decimal 
    format "->>,>>>,>>>,>>9.9999999999" 
    decimals 10 
    label "Cota»Æo" 
    column-label "Cota»Æo" 
    no-undo. 
def var v_val_resto_rat 
    as decimal 
    format "->>,>>>,>>>,>>9.99" 
    decimals 2 
    no-undo. 

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHAR NO-UNDO.

DEF VAR c-referencia AS CHAR.
DEF VAR v-log-primeira-vez AS LOG.
DEF VAR v-rec-lote AS RECID.
def var c-titulo as char no-undo init "20" label "T­tulo" .
