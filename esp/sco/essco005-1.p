/*****************************************************************************
** Programa..............: esp/essco005-1.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 16/03/2009
*****************************************************************************/

/**************************************************** Initialize **********************************************************/

def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància".

def temp-table tt_integr_acr_abat_antecip no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_abat_prev no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/N∆o" initial no label "Zera Saldo" column-label "Zera Saldo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_aprop_liq_antec no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T°tulo" column-label "Unid Negoc T°tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido"
    .

def temp-table tt_integr_acr_cheq no-undo
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss∆o" column-label "Dt Emiss"
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep¢sito" column-label "Dep¢sito"
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs∆o Dep¢sito" column-label "Previs∆o Dep¢sito"
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devoluá∆o" column-label "Motivo Devoluá∆o"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field tta_log_pend_cheq_acr            as logical format "Sim/N∆o" initial no label "Cheque Pendente" column-label "Cheque Pendente"
    field tta_log_cheq_terc                as logical format "Sim/N∆o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N∆o" initial no label "Cheque Reneg" column-label "Cheque Reneg"
    field tta_log_cheq_acr_devolv          as logical format "Sim/N∆o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    index tt_id                            is primary unique
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending
    .

def temp-table tt_integr_acr_liquidac_impto_2 no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_val_retid_indic_impto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE Imposto" column-label "Vl Retido IE Imposto"
    field tta_val_retid_indic_tit_acr      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE T°tulo" column-label "Vl Retido IE T°tulo"
    field tta_val_retid_indic_pagto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Retido Indicador Pag" column-label "Retido Indicador Pag"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_dat_cotac_indic_econ_pagto   as date format "99/99/9999" initial ? label "Dat Cotac IE Pagto" column-label "Dat Cotac IE Pagto"
    field tta_val_cotac_indic_econ_pagto   as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Val Cotac IE Pagto" column-label "Val Cotac IE Pagto"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    .

def temp-table tt_integr_acr_liquidac_lote no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Geraá∆o" column-label "Data Geraá∆o"
    field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto"
    field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia"
    field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao"
    field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digitaá∆o" label "Situaá∆o" column-label "Situaá∆o"
    field tta_nom_arq_movimen_bcia         as character format "x(30)" label "Nom Arq Bancaria" column-label "Nom Arq Bancaria"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_log_enctro_cta               as logical format "Sim/N∆o" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_atualiz_refer            as logical format "Sim/N∆o" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/N∆o" initial no
    index tt_itlqdccr_id                   is primary unique
          tta_cod_estab_refer              ascending
          tta_cod_refer                    ascending
    .

def temp-table tt_integr_acr_liq_aprop_ctbl no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    index tt_integr_acr_liq_aprop_ctbl_id  is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_integr_acr_liq_desp_rec no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropriaá∆o" column-label "Tipo Apropriaá∆o"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    index tt_integr_acr_liq_des_rec_id     is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_cta_ctbl_ext             ascending
          tta_cod_sub_cta_ctbl_ext         ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_unid_negoc_ext           ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_ind_tip_aprop_recta_despes   ascending
    .

def temp-table tt_integr_acr_liq_item_lote_3 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data CrÇdito" column-label "Data CrÇdito"
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaá∆o" column-label "Liquidaá∆o"
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autorizaá∆o Bco" column-label "Autorizacao Bco"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquidaá∆o" column-label "Vl Liquidaá∆o"
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
    field tta_log_gera_antecip             as logical format "Sim/N∆o" initial no label "Gera Antecipacao" column-label "Gera Antecipacao"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situaá∆o Item Lote" column-label "Situaá∆o Item Lote"
    field tta_log_gera_avdeb               as logical format "Sim/N∆o" initial no label "Gera Aviso DÇbito" column-label "Gera Aviso DÇbito"
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso DÇbito" column-label "Moeda Aviso DÇbito"
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso DÇbito" column-label "Aviso DÇbito"
    field tta_log_movto_comis_estordo      as logical format "Sim/N∆o" initial no label "Estorna Comiss∆o" column-label "Estorna Comiss∆o"
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C†lculo Juros" column-label "Tipo C†lculo Juros"
    field tta_log_retenc_impto_liq         as logical format "Sim/N∆o" initial no label "RetÇm na Liquidaá∆o" column-label "Ret na Liq"
    field tta_val_retenc_pis               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor PIS" column-label "PIS"
    field tta_val_retenc_cofins            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor COFINS" column-label "COFINS"
    field tta_val_retenc_csll              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CSLL" column-label "CSLL"
    index tt_rec_index                    
          ttv_rec_lote_liquidac_acr        ascending
    .

def temp-table tt_integr_acr_rel_pend_cheq no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal†rio" column-label "Banco Cheque Sal†rio"
    .

def temp-table tt_log_erros_import_liquidac no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_nom_abrev_clien              as character format "x(12)" label "Cliente" column-label "Cliente"
    field ttv_num_erro_log                 as integer format ">>>>,>>9" label "N£mero Erro" column-label "N£mero Erro"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    index tt_sequencia                    
          tta_num_seq                      ascending
    .

def temp-table tt_integr_cambio_ems5 no-undo
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_cod_contrat_cambio           as character format "x(15)"
    field ttv_dat_contrat_cambio_import    as date format "99/99/9999"
    field ttv_num_contrat_id_cambio        as integer format "999999999"
    field ttv_cod_estab_contrat_cambio     as character format "x(3)"
    field ttv_cod_refer_contrat_cambio     as character format "x(10)"
    field ttv_dat_refer_contrat_cambio     as date format "99/99/9999"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending
    .

DEF TEMP-TABLE tt_detalhe NO-UNDO
    FIELD cod_estab             LIKE tit_acr.cod_estab
    FIELD cod_espec             LIKE tit_acr.cod_espec
    FIELD cod_ser               LIKE tit_acr.cod_ser
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela           LIKE tit_acr.cod_parcela FORMAT "99/99" LABEL "Parcela"
    FIELD num_ped_EMS           LIKE ped-venda.nr-pedido  
    FIELD num_ped_parceiro      LIKE ped-venda.nr-pedcli
    FIELD val_tit_acr           LIKE tit_acr.val_origin_tit_acr
    FIELD cod_refer_liquidac    LIKE lote_liquidac_acr.cod_refer
    FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco
    FIELD rec_tit_acr           AS RECID
    FIELD rec_lote_liquidac_acr AS RECID
    FIELD LOG_an_gerada         AS LOG FORMAT "Sim/N∆o" INITIAL NO.

DEF TEMP-TABLE tt_ped NO-UNDO
    FIELD ped_EMS           LIKE ped-venda.nr-pedido  
    FIELD ped_parceiro      LIKE ped-venda.nr-pedcli
    FIELD log_cancel        AS LOG.

DEF QUERY qr_tt_detalhe
    FOR tt_detalhe
    SCROLLING.

DEF TEMP-TABLE tt_concil_aux NO-UNDO
    FIELD dat_transacao         LIKE tit_acr.dat_transacao
    FIELD cod_resumo            AS CHAR
    FIELD cod_nsu               AS CHAR
    FIELD cod_autoriz           AS CHAR
    FIELD cod_parcela           AS CHAR LABEL "Parcela"
    FIELD val_tit_acr_pago      LIKE tit_acr.val_origin_tit_acr
    FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco.

DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD dat_transacao         LIKE tit_acr.dat_transacao
    FIELD cod_resumo            AS CHAR
    FIELD cod_nsu               AS CHAR
    FIELD num_ped_EMS           LIKE ped-venda.nr-pedido  
    FIELD num_ped_parceiro      LIKE ped-venda.nr-pedcli
    FIELD cdn_cliente_orig      LIKE tit_acr.cdn_cliente
    FIELD cdn_cliente_adm       LIKE tit_acr.cdn_cliente
    FIELD cod_estab             LIKE tit_acr.cod_estab
    FIELD cod_espec             LIKE tit_acr.cod_espec
    FIELD cod_ser               LIKE tit_acr.cod_ser
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela           AS CHAR LABEL "Parcela"
    FIELD val_tit_acr_EMS       LIKE tit_acr.val_origin_tit_acr
    FIELD val_tit_acr_pago      LIKE tit_acr.val_origin_tit_acr
    FIELD cod_refer_liquidac    LIKE lote_liquidac_acr.cod_refer
    FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco
    FIELD des_status            AS CHAR
    FIELD rec_tit_acr           AS RECID
    FIELD rec_lote_liquidac_acr AS RECID
    FIELD LOG_an_gerada         AS LOG FORMAT "Sim/N∆o" INITIAL NO
  INDEX tt_concil
        dat_transacao           ASCENDING
        cod_resumo              ASCENDING
        cod_nsu                 ASCENDING
        num_ped_EMS             ASCENDING.

DEF QUERY qr_tt_concil_adm
    FOR tt_concil
    SCROLLING.

DEF QUERY qr_tt_concil_bol
    FOR tt_concil
    SCROLLING.

/*************************** Query Definition End ***************************/


/************************** Browse Definition Begin *************************/

def browse br_tt_detalhe query qr_tt_detalhe display 
    tt_detalhe.cod_estab          COLUMN-LABEL "Estab" 
    tt_detalhe.cod_espec          COLUMN-LABEL "Esp" 
    tt_detalhe.cod_ser            COLUMN-LABEL "Ser" 
    tt_detalhe.cod_tit_acr      
    tt_detalhe.cod_parcela        COLUMN-LABEL "Parcela" 
    tt_detalhe.num_ped_EMS        COLUMN-LABEL "Ped EMS" 
    tt_detalhe.num_ped_parceiro 
    tt_detalhe.cod_refer_liquidac COLUMN-LABEL "Refer Liquidac"
    tt_detalhe.val_tit_acr        COLUMN-LABEL "Vl Original"
    tt_detalhe.cod_tit_acr_bco    COLUMN-LABEL "N£mero Boleto"
    tt_detalhe.LOG_an_gerada      COLUMN-LABEL "AN ?"
  with no-box separators single 
         size 87 by 07.08
         font 1
         bgcolor 15.

def browse br_tt_concil_adm query qr_tt_concil_adm display 
    tt_concil.dat_transacao      FORMAT "99/99/99" COLUMN-LABEL "Data"  
    tt_concil.cod_resumo         FORMAT "x(09)" COLUMN-LABEL "Resumo"  
    tt_concil.cod_nsu            FORMAT "x(08)" COLUMN-LABEL "NSU"  
    tt_concil.num_ped_EMS        COLUMN-LABEL "Ped EMS" 
    tt_concil.num_ped_parceiro   COLUMN-LABEL "Ped Parc"
    tt_concil.cod_tit_acr        COLUMN-LABEL "T°tulo"
    tt_concil.cod_parcela        COLUMN-LABEL "Parcela" 
    tt_concil.cod_refer_liquidac COLUMN-LABEL "Refer Liquidac"
    tt_concil.val_tit_acr_ems    COLUMN-LABEL "Vl EMS"
    tt_concil.val_tit_acr_pago   COLUMN-LABEL "Vl Parceiro"  
    tt_concil.cdn_cliente_orig   COLUMN-LABEL "Cliente"  
    tt_concil.cod_estab          COLUMN-LABEL "Estab" 
    tt_concil.cod_espec          COLUMN-LABEL "Esp" 
    tt_concil.cod_ser            COLUMN-LABEL "Ser" 
    tt_concil.cod_tit_acr_bco    COLUMN-LABEL "Nr. Cart∆o"
    tt_concil.des_status         FORMAT "x(30)" COLUMN-LABEL "Status"
  with no-box separators MULTIPLE 
         size 108 by 15.58
         font 1
         bgcolor 15.

def browse br_tt_concil_bol query qr_tt_concil_bol display 
    tt_concil.dat_transacao      FORMAT "99/99/99" COLUMN-LABEL "Data"  
    tt_concil.num_ped_EMS        COLUMN-LABEL "Ped EMS" 
    tt_concil.num_ped_parceiro   COLUMN-LABEL "Ped Parc"
    tt_concil.cod_tit_acr        COLUMN-LABEL "T°tulo"
    tt_concil.cod_refer_liquidac COLUMN-LABEL "Refer Liquidac"
    tt_concil.val_tit_acr_ems    COLUMN-LABEL "Vl EMS"
    tt_concil.val_tit_acr_pago   COLUMN-LABEL "Vl Parceiro"  
    tt_concil.log_an_gerada      COLUMN-LABEL "AN ?"
    tt_concil.des_status         FORMAT "x(30)" COLUMN-LABEL "Status"
    tt_concil.cdn_cliente_orig   COLUMN-LABEL "Cliente"  
    tt_concil.cod_estab          COLUMN-LABEL "Estab" 
    tt_concil.cod_espec          COLUMN-LABEL "Esp" 
    tt_concil.cod_ser            COLUMN-LABEL "Ser" 
    tt_concil.cod_tit_acr_bco    COLUMN-LABEL "N£mero Boleto"
  with no-box separators MULTIPLE 
         size 108 by 15.58
         font 1
         bgcolor 15.


DEF VAR v-nr-ped-ikeda AS CHAR FORMAT "x(20)" LABEL "NSU / BOLETO" NO-UNDO.
DEF VAR cCartao        AS CHAR NO-UNDO label 'Cartao' format 'x(25)'.
DEF VAR v_sit_lote     AS CHAR NO-UNDO.

define variable pcNroCartao         as character    no-undo.
define variable piSeguranca         as integer      no-undo.
define variable piOperadora         as integer      no-undo.
define variable pcTitular           as character    no-undo.
define variable piValidadeMes       as integer      no-undo.
define variable piValidadeAno       as integer      no-undo.
define variable piTipoOrigem        as integer      no-undo.

DEF VAR hesapi014            AS HANDLE NO-UNDO.
DEF VAR v_hld_handle         AS HANDLE NO-UNDO.

DEF VAR rs_opcao AS CHARACTER INITIAL "Boleto" VIEW-AS RADIO-SET VERTICAL
    RADIO-BUTTONS "Boleto", "Boleto","VisaNet", "VisaNet","RedeCard", "RedeCard" BGCOLOR 15 NO-UNDO.
DEFINE VARIABLE v_log_method AS LOGICAL            NO-UNDO.
DEFINE VARIABLE v_dat_ini    AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE v_dat_fim    AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.

DEFINE VARIABLE v_log_ped        AS LOGICAL LABEL "Pedido Localizado ?" FORMAT "Sim/N∆o" INIT "N∆o" NO-UNDO.
DEFINE VARIABLE v_log_ped_aprov  AS LOGICAL LABEL "Pedido Aprovado ?"   FORMAT "Sim/N∆o" INIT "N∆o" NO-UNDO.
DEFINE VARIABLE v_log_acr        AS LOGICAL LABEL "NF Integrada ?"      FORMAT "Sim/N∆o" INIT "N∆o" NO-UNDO.

DEFINE VARIABLE v_log_answer AS LOGICAL  INITIAL NO NO-UNDO.

DEFINE VARIABLE v_cdn_cliente  LIKE tit_acr.cdn_cliente                        NO-UNDO.
DEFINE VARIABLE v_nom_abrev    LIKE tit_acr.nom_abrev                          NO-UNDO.
DEFINE VARIABLE v_cod_admdra   LIKE tit_acr_cobr_especial.cod_admdra_cartao_cr NO-UNDO.
DEFINE VARIABLE v_cod_portador LIKE tit_acr.cod_portador                       NO-UNDO.
DEFINE VARIABLE v_cod_carteira LIKE tit_acr.cod_cart_bcia                      NO-UNDO.
DEFINE VARIABLE v_cod_cartao   LIKE tit_acr_cobr_especial.cod_cartcred         NO-UNDO.
DEFINE VARIABLE v_CarTID       LIKE int-ped-venda.CarTID                NO-UNDO.
DEFINE VARIABLE v_dat_pedido   LIKE ped-venda.dt-emissao                       NO-UNDO.
DEFINE VARIABLE v_val_pedido   LIKE ped-venda.vl-tot-ped                       NO-UNDO.

DEFINE VARIABLE v_val_abat   AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE v_data_base  AS DATE FORMAT "99/99/9999" NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_tit_acr           AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_lote_liquidac_acr AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren      AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.

DEF BUFFER b_tit_acr FOR tit_acr.

DEF STREAM s_1.
DEF STREAM s_2.

def var rs_origem
    as character
    initial "NSU / Boleto"
    view-as radio-set Horizontal
    radio-buttons "NSU / Boleto", "NSU / BOLETO","Pedido Parceiro", "Pedido Parceiro"
    bgcolor 15 
    no-undo.

run esapi/esapi014.p persistent set hesapi014.

def var wh_w_program
    as widget-handle
    no-undo.

create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
         resize               = no
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.

def rectangle rt_key
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

def button bt_exi
    label "Sa°da"
        tooltip "Sa°da"
    image-up file "image/im-exi"
    size 1 by 1.
def button bt_enter
    label "Loc"
        tooltip "Entra"
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
    size 4 by .88.
def button bt_aprova
    label "Aprova Pedido"
        tooltip "Aprova Pedido"
    image-up file "image/im-cotof"
    size 1 by 1.
def button bt_gera_an
    label "Gera Antecipaá∆o"
        tooltip "Gera Antecipaá∆o"
    image-up file "image/im-calc4"
    size 1 by 1.
def button bt_liquidac
    label "Acessa Lote Liquidaá∆o"
        tooltip "Acessa Lote Liquidaá∆o"
    image-up file "image/im-inici"
    size 1 by 1.
def button bt_liq_bol
    label "Liquida Boleto"
        tooltip "Liquida Boleto"
    image-up file "image/im-cmg2"
    size 1 by 1.
def button bt_estorno
    label "Estorno Cobranáa Especial"
        tooltip "Estorno Cobranáa Especial"
    image-up file "image/im-undo2"
    size 1 by 1.
def button bt_lista_ped
    label "Relaá∆o de Pedidos"
        tooltip "Relaá∆o de Pedidos"
    image-up file "image/im-orcto"
    size 1 by 1.
def button bt_import
    label "Importa Nexxera"
        tooltip "Importa Nexxera"
    image-up file "image/im-ascii"
    size 1 by 1.
def button bt_debito
    label "Contestaá‰es/Cancelamentos"
        tooltip "Contestaá‰es/Cancelamentos"
    image-up file "image/im-send"
    size 1 by 1.


def frame f_aprova
    rt_rgf   at row 01.00 col 01.00 bgcolor 7
    rt_key   at row 02.50 col 02.00
    rt_mold  AT ROW 4 COL 2
    rs_origem
         at row 02.67 col 05.00 BGCOLOR 8
         help "" no-label
    v-nr-ped-ikeda
         at row 02.67 col 33 colon-aligned NO-LABEL
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_enter at row 02.67 col 56.5
    bt_aprova
         at row 01.08 col 2.14 font ?
         help "Aprova Pedido"
    bt_gera_an
         at row 01.08 col 6.14 font ?
         help "Gera Antecipaá∆o"
    bt_liq_bol
         at row 01.08 col 10.14 font ?
         help "Liquida Boleto"
    bt_liquidac
         at row 01.08 col 14.14 font ?
         help "Acessa Lote Liquidaá∆o"
    bt_estorno
         at row 01.08 col 18.14 font ?
         help "Estorno Cobranáa Especial"
    bt_lista_ped
         at row 01.08 col 22.14 font ?
         help "Relaá∆o Pedidos"
    bt_import
         at row 01.08 col 26.14 font ?
         help "Importaá∆o Nexxera"
    bt_debito
         at row 01.08 col 30.14 font ?
         help "Contestaá‰es/Cancelamentos"
    bt_exi   at row 01.08 col 84.14 font ?
       help "Sa°da"
    v_log_ped at row 4.2 col 17 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
    v_log_ped_aprov at row 5.1 col 17 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
    v_log_acr  at row 6 col 17 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
    v_cdn_cliente  AT ROW 4.2 COL 30 COLON-ALIGNED LABEL "Cliente"
    v_nom_abrev    AT ROW 4.2 COL 50 COLON-ALIGNED LABEL "Nome Abrev"
    v_cod_admdra   AT ROW 5.1 COL 30 COLON-ALIGNED VIEW-AS FILL-IN size-chars 7.14 by .88 LABEL "ADM" 
    v_cod_portador AT ROW 5.1 COL 50 COLON-ALIGNED LABEL "Port"
    v_cod_carteira AT ROW 5.1 COL 55 COLON-ALIGNED NO-LABEL
    v_cod_cartao   AT ROW 6   COL 30 COLON-ALIGNED LABEL "Cart Cred"
    v_CarTID       AT ROW 6   COL 50 COLON-ALIGNED LABEL "NSU"

    v_dat_pedido AT ROW 4.2 COL 72 COLON-ALIGNED
         view-as fill-in
         size-chars 10 by .88
    v_val_pedido AT ROW 5.1 COL 72 COLON-ALIGNED

    br_tt_detalhe
         AT ROW 7.5 COL 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 89.29 by 15.04
         at row 01.00 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Manutená∆o Informaá‰es B2x - ESSCO005".
/* adjust size of objects in this frame */
assign bt_exi:width-chars     in frame f_aprova = 04.00
       bt_exi:height-chars    in frame f_aprova = 01.13
       bt_aprova:width-chars  in frame f_aprova = 04.00
       bt_aprova:height-chars in frame f_aprova = 01.13
       bt_gera_an:width-chars  in frame f_aprova = 04.00
       bt_gera_an:height-chars in frame f_aprova = 01.13
       bt_liquidac:width-chars  in frame f_aprova = 04.00
       bt_liquidac:height-chars in frame f_aprova = 01.13
       bt_liq_bol:width-chars  in frame f_aprova = 04.00
       bt_liq_bol:height-chars in frame f_aprova = 01.13
       bt_estorno:width-chars  in frame f_aprova = 04.00
       bt_estorno:height-chars in frame f_aprova = 01.13
       bt_lista_ped:width-chars  in frame f_aprova = 04.00
       bt_lista_ped:height-chars in frame f_aprova = 01.13
       bt_import:width-chars  in frame f_aprova = 04.00
       bt_import:height-chars in frame f_aprova = 01.13
       bt_debito:width-chars  in frame f_aprova = 04.00
       bt_debito:height-chars in frame f_aprova = 01.13
       rt_key:width-chars     in frame f_aprova = 86.79
       rt_key:height-chars    in frame f_aprova = 01.21
       rt_rgf:width-chars     in frame f_aprova = 88.29
       rt_rgf:height-chars    in frame f_aprova = 01.29
       rt_mold:width-chars    in frame f_aprova = 86.79
       rt_mold:height-chars   in frame f_aprova = 03.2.


def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.

def frame f_import
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 8.75 col 02.00 bgcolor 7 
    rs_opcao
         at row 02.75 col 12 colon-aligned label "Extrato"
         help "Extrato"
         fgcolor ? bgcolor ? font 2
    v_dat_ini
         at row 05.75 col 12 colon-aligned label "Per°odo"
         help "Data Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_fim
         at row 05.75 col 27 colon-aligned label "AtÇ"
         help "Data Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 08.96 col 03.00 font ?
         help "OK"
    bt_can
         at row 08.96 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 48.14 by 10.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Extrato - B2x".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_import = 10.00
           bt_can:height-chars              in frame f_import = 01.00
           bt_ok:width-chars                in frame f_import = 10.00
           bt_ok:height-chars               in frame f_import = 01.00
           rt_cxcf:width-chars              in frame f_import = 44.72
           rt_cxcf:height-chars             in frame f_import = 01.42
           rt_mold:width-chars              in frame f_import = 44.72
           rt_mold:height-chars             in frame f_import = 07.17.



/** ****/

DEF QUERY qr_ped
  FOR tt_ped
  SCROLLING.

def browse br_ped query qr_ped display 
    ped_EMS        COLUMN-LABEL "Ped EMS" 
    ped_parceiro 
    log_cancel     COLUMN-LABEL "Canc ?"
  with no-box separators single 
         size 26 by 6.08
         font 1
         bgcolor 15.

def frame f_ped
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 8.75 col 02.00 bgcolor 7 
    br_ped
         at row 02 col 5
    bt_ok
         at row 08.96 col 03.00 font ?
         help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 35.14 by 10.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relaá∆o Pedidos".
    /* adjust size of objects in this frame */
    assign bt_ok:width-chars                in frame f_ped = 10.00
           bt_ok:height-chars               in frame f_ped = 01.00
           rt_cxcf:width-chars              in frame f_ped = 32.72
           rt_cxcf:height-chars             in frame f_ped = 01.42
           rt_mold:width-chars              in frame f_ped = 32.72
           rt_mold:height-chars             in frame f_ped = 07.5.

/* ****/

ON CHOOSE OF bt_exi IN FRAME f_aprova
DO:
    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END.

ON MOUSE-SELECT-DBLCLICK OF br_tt_detalhe IN FRAME f_aprova
DO:
  IF AVAIL tt_detalhe 
  THEN DO:
       ASSIGN v_rec_tit_acr = tt_detalhe.rec_tit_acr.
       RUN prgfin/acr/acr212aa.p.
  END.
END.

ON CHOOSE OF bt_gera_an IN FRAME f_aprova
DO:

  def button bt_ok
      label "OK"
      tooltip "OK"
      size 1 by 1
      auto-go.
  def button bt_can
      label "Cancela"
      tooltip "Cancela"
      size 1 by 1
      auto-endkey.

  def frame f_impl_an
      rt_mold
           at row 01.21 col 02.00
      rt_cxcf
           at row 5.75 col 02.00 bgcolor 7 
      v_data_base
           at row 02.75 col 15 colon-aligned label "Data Implantaá∆o"
           help "Data Implantaá∆o AN"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
      bt_ok
           at row 05.96 col 03.00 font ?
           help "OK"
      bt_can
           at row 05.96 col 14.00 font ?
           help "Cancela"
      with 1 down side-labels no-validate keep-tab-order three-d
           size-char 48.14 by 07.58
           view-as dialog-box
           font 1 fgcolor ? bgcolor 8
           title "Implantaá∆o AN".
      /* adjust size of objects in this frame */
      assign bt_can:width-chars               in frame f_impl_an = 10.00
             bt_can:height-chars              in frame f_impl_an = 01.00
             bt_ok:width-chars                in frame f_impl_an = 10.00
             bt_ok:height-chars               in frame f_impl_an = 01.00
             rt_cxcf:width-chars              in frame f_impl_an = 44.72
             rt_cxcf:height-chars             in frame f_impl_an = 01.42
             rt_mold:width-chars              in frame f_impl_an = 44.72
             rt_mold:height-chars             in frame f_impl_an = 04.17.

  IF  v_cod_admdra <> "BOLETO"
  AND v_cod_admdra <> "Boleto - PAR"
  THEN DO:
       MESSAGE "T°tulo selecionado n∆o possui BOLETO !"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
  END.

  IF v_log_ped_aprov = NO 
  THEN DO:
       MESSAGE "Pedido n∆o Aprovado !" SKIP
               "Efetuar a aprovaá∆o do pedido antes de gerar a AN."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
  END.

  IF AVAIL tt_detalhe 
  THEN DO:
       MESSAGE "T°tulo j† integrado com o ACR !" SKIP
               "Pode ser Liquidado sem gerar AN."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  ELSE DO:

      FIND b_tit_acr NO-LOCK 
         WHERE b_tit_acr.cod_estab           = "101"
           AND b_tit_acr.cod_espec           = "AN"
           AND b_tit_acr.cod_ser             = "5"
           AND b_tit_acr.cod_tit_acr         = "B2" + INPUT FRAME f_aprova v-nr-ped-ikeda
           AND b_tit_acr.cod_parcela         = "01" NO-ERROR.
      IF AVAIL b_tit_acr 
      THEN DO:
           MESSAGE "AN j† existente !"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN NO-APPLY.
      END.

      ASSIGN v_data_base = TODAY.

      VIEW FRAME f_impl_an.

      filter_block:
      do on error undo filter_block, retry filter_block
                       on endkey undo filter_block, leave filter_block:
          display bt_can
                  bt_ok
                  v_data_base
                  with frame f_impl_an.
          enable all with frame f_impl_an.

          wait-for go of frame f_impl_an.

          assign input frame f_impl_an v_data_base.

          MESSAGE "Confirma geraá∆o da AN ?" SKIP
                  "Cliente: " v_cdn_cliente  SKIP
                  "Valor  : " STRING(v_val_pedido, ">>>>,>>9.99") SKIP
                  "Data   : " v_data_base
                VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AN" UPDATE choice AS LOGICAL.
        
          IF CHOICE = NO 
          THEN DO: 
               HIDE FRAME f_impl_an.
               RETURN NO-APPLY.
          END.

          ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
          RUN esp/sco/essco005a.p(INPUT "101",
                                  INPUT v_data_base,
                                  INPUT v_val_pedido,
                                  INPUT INPUT FRAME f_aprova v-nr-ped-ikeda,
                                  INPUT v_cdn_cliente).
          ASSIGN v_log_method = session:SET-WAIT-STATE("").

      END.

      HIDE FRAME f_impl_an.

      APPLY "CHOOSE" TO bt_enter IN FRAME f_aprova.

  END.

END.

ON CHOOSE OF bt_liquidac IN FRAME f_aprova
DO:
  IF  AVAIL tt_detalhe
  AND tt_detalhe.rec_lote_liquidac_acr <> ?
  THEN DO:
       ASSIGN v_rec_lote_liquidac_acr = tt_detalhe.rec_lote_liquidac_acr.
       RUN prgfin/acr/acr726aa.p.
       APPLY "CHOOSE" TO bt_enter IN FRAME f_aprova.
  END.
  ELSE DO:
       MESSAGE "Lote de Liquidaá∆o n∆o Localizada ou j† Atualizado !"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
END.

ON CHOOSE OF bt_estorno IN FRAME f_aprova
DO:
   RUN prgfin/acr/acr769aa.p.
   APPLY "CHOOSE" TO bt_enter IN FRAME f_aprova.
END.

ON CHOOSE OF bt_lista_ped IN FRAME f_aprova
DO:

      FOR EACH tt_ped:
          DELETE tt_ped.
      END.

      IF INPUT FRAME f_aprova rs_origem = "NSU / Boleto"
      THEN DO:
           FOR EACH int-ped-venda NO-LOCK
               WHERE int-ped-venda.CarTID = STRING(INT(v-nr-ped-ikeda), "999999999"):
               FIND ped-venda NO-LOCK
                   WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
               IF NOT AVAIL ped-venda 
                  THEN NEXT.
               CREATE tt_ped.
               ASSIGN tt_ped.ped_EMS      = ped-venda.nr-pedido  
                      tt_ped.ped_parceiro = ped-venda.nr-pedcli
                      tt_ped.log_cancel   = IF ped-venda.dt-cancela <> ? THEN YES ELSE NO.
      
          END.
      END.
      ELSE DO:
           FOR EACH int-ped-venda NO-LOCK
               WHERE int-ped-venda.PedidoCodigo = INT(v-nr-ped-ikeda):
               FIND ped-venda NO-LOCK
                   WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
               IF NOT AVAIL ped-venda 
                  THEN NEXT.
               CREATE tt_ped.
               ASSIGN tt_ped.ped_EMS      = ped-venda.nr-pedido  
                      tt_ped.ped_parceiro = ped-venda.nr-pedcli
                      tt_ped.log_cancel   = IF ped-venda.dt-cancela <> ? THEN YES ELSE NO.
          END.
      END.

      VIEW FRAME f_ped.

      OPEN QUERY qr_ped
           FOR EACH  tt_ped NO-LOCK.

     filter_block:
     do on error undo filter_block, retry filter_block
                      on endkey undo filter_block, leave filter_block:
          DISPLAY bt_ok
                  br_ped
                  WITH FRAME f_ped.
    
          ENABLE ALL WITH FRAME f_ped.
          
          WAIT-FOR GO OF FRAME f_ped.
      END.
      HIDE FRAME f_ped.

END.

ON CHOOSE OF bt_liq_bol IN FRAME f_aprova
DO:

  def button bt_ok
      label "OK"
      tooltip "OK"
      size 1 by 1
      auto-go.
  def button bt_can
      label "Cancela"
      tooltip "Cancela"
      size 1 by 1
      auto-endkey.

  def frame f_liq_bol
      rt_mold
           at row 01.21 col 02.00
      rt_cxcf
           at row 5.75 col 02.00 bgcolor 7 
      v_data_base
           at row 02.75 col 15 colon-aligned label "Data Liquidaá∆o"
           help "Data Liquidaá∆o"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
      bt_ok
           at row 05.96 col 03.00 font ?
           help "OK"
      bt_can
           at row 05.96 col 14.00 font ?
           help "Cancela"
      with 1 down side-labels no-validate keep-tab-order three-d
           size-char 48.14 by 07.58
           view-as dialog-box
           font 1 fgcolor ? bgcolor 8
           title "Liquidaá∆o T°tulo".
      /* adjust size of objects in this frame */
      assign bt_can:width-chars               in frame f_liq_bol = 10.00
             bt_can:height-chars              in frame f_liq_bol = 01.00
             bt_ok:width-chars                in frame f_liq_bol = 10.00
             bt_ok:height-chars               in frame f_liq_bol = 01.00
             rt_cxcf:width-chars              in frame f_liq_bol = 44.72
             rt_cxcf:height-chars             in frame f_liq_bol = 01.42
             rt_mold:width-chars              in frame f_liq_bol = 44.72
             rt_mold:height-chars             in frame f_liq_bol = 04.17.

    IF  v_cod_admdra <> "BOLETO"
    AND v_cod_admdra <> "Boleto - PAR"
    THEN DO:
         MESSAGE "T°tulo selecionado n∆o possui BOLETO !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF  AVAIL tt_detalhe
    AND tt_detalhe.cod_refer_liquidac = "Pendente" 
    THEN DO:

         ASSIGN v_data_base = TODAY.
  
         VIEW FRAME f_liq_bol.
  
         filter_block:
         do on error undo filter_block, retry filter_block
                          on endkey undo filter_block, leave filter_block:
             display bt_can
                     bt_ok
                     v_data_base
                     with frame f_liq_bol.
             enable all with frame f_liq_bol.
  
             wait-for go of frame f_liq_bol.
  
             FIND b_tit_acr NO-LOCK 
                WHERE b_tit_acr.cod_estab           = "101"
                  AND b_tit_acr.cod_espec           = "AN"
                  AND b_tit_acr.cod_ser             = "5"
                  AND b_tit_acr.cod_tit_acr         = "B2" + INPUT FRAME f_aprova v-nr-ped-ikeda
                  AND b_tit_acr.cod_parcela         = "01"
                  AND b_tit_acr.val_sdo_tit_acr     > 0
                  AND b_tit_acr.log_tit_acr_estordo = NO NO-ERROR.
              
             IF AVAIL b_tit_acr 
                THEN ASSIGN v_val_abat = b_tit_acr.val_sdo_tit_acr.
                ELSE ASSIGN v_val_abat = 0.

             IF v_val_abat > tt_detalhe.val_tit_acr 
                THEN v_val_abat = tt_detalhe.val_tit_acr.

             IF v_val_abat <> 0 
             THEN DO:
                  MESSAGE "Cliente possui AN gerada para o pedido " INPUT FRAME f_aprova v-nr-ped-ikeda SKIP 
                          "Deseja utilizar nesta liquidaá∆o ? " SKIP
                          "Valor AN: " STRING(v_val_abat, ">>>>,>>9.99")
                        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Abater AN" UPDATE choice AS LOGICAL.
                  IF CHOICE = NO 
                     THEN ASSIGN v_val_abat = 0.
             END.

             assign input frame f_liq_bol v_data_base.
  
             MESSAGE "Confirma Liquidaá∆o do T°tulo em: " v_data_base " ?" 
                   VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Liquidaá∆o T°tulo" UPDATE choice2 AS LOGICAL.
  
             IF CHOICE2 = NO 
             THEN DO: 
                  HIDE FRAME f_liq_bol.
                  RETURN NO-APPLY.
             END.

             ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
             RUN pi_liquidac_bol.  
             ASSIGN v_log_method = session:SET-WAIT-STATE("").

         END.
  
         HIDE FRAME f_liq_bol.

         APPLY "CHOOSE" TO bt_enter IN FRAME f_aprova.

    END.
    ELSE DO:
         MESSAGE "T°tulo n∆o Localizada ou j† Liquidado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END.

ON CHOOSE OF bt_debito IN FRAME f_aprova
DO:

    RUN esp/sco/essco005c.p.

END.

ON CHOOSE OF bt_import IN FRAME f_aprova
DO:

    RUN esp/sco/essco005b.p.

/*

      VIEW FRAME f_import.

      filter_block:
      DO ON ERROR UNDO filter_block, RETRY filter_block
                       ON ENDKEY UNDO filter_block, LEAVE filter_block:

           DISPLAY bt_can
                   bt_ok
                   rs_opcao
                   v_dat_ini
                   v_dat_fim
                   WITH FRAME f_import.

           ENABLE ALL WITH FRAME f_import.

           WAIT-FOR GO OF FRAME f_import.

           ASSIGN INPUT FRAME f_import rs_opcao v_dat_ini v_dat_fim.

           RUN pi_import.  

      END.

      HIDE FRAME f_import.
*/      
      

END.

ON CHOOSE OF bt_aprova IN FRAME f_aprova
DO:

    IF v_log_ped_aprov = YES 
    THEN DO:
         MESSAGE "Pedido j† Aprovado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    MESSAGE "Confirma a Aprovaá∆o do Pedido Parceiro " INT(INPUT FRAME f_aprova v-nr-ped-ikeda) " ?"
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.

    IF v_log_answer = YES 
    THEN DO:
        aprov_block:
        DO ON ERROR UNDO aprov_block, LEAVE aprov_block TRANSACTION:

            /* V†rios pedidos no EMS para cada pedido da IKEDA/PAR */
            FOR EACH int-ped-venda NO-LOCK
                WHERE int-ped-venda.pedidocodigo = INT(INPUT FRAME f_aprova v-nr-ped-ikeda):

                FIND ped-venda EXCLUSIVE-LOCK 
                    WHERE ped-venda.nr-pedido  = int-ped-venda.nr-pedido NO-ERROR.

                IF NOT AVAIL ped-venda 
                   THEN NEXT.

                IF  AVAIL ped-venda 
                AND ped-venda.cod-sit-aval <> 3
                   THEN ASSIGN ped-venda.cod-sit-aval       = 3 /* Aprovado */
                               ped-venda.desc-bloq-cr       = ""
                               ped-venda.dsp-pre-fat        = YES 
                               ped-venda.cod-message-alerta = 0
                               ped-venda.dt-mensagem        = ?
                               ped-venda.nome-prog          = "".

            END.

            MESSAGE "Pedido Parceiro " INT(INPUT FRAME f_aprova v-nr-ped-ikeda) " Aprovado !" VIEW-AS ALERT-BOX.
            DISABLE bt_aprova WITH FRAME f_aprova.
            APPLY "CHOOSE" TO bt_enter IN FRAME f_aprova.

        END.
    END.

END.


ON  CHOOSE OF bt_enter IN FRAME f_aprova
OR ENTER OF v-nr-ped-ikeda IN FRAME f_aprova DO:

    DEF BUFFER b_tit_acr_an FOR tit_acr.

    DISABLE bt_aprova WITH FRAME f_aprova.

    ASSIGN v-nr-ped-ikeda = INPUT FRAME f_aprova v-nr-ped-ikeda.

    IF v-nr-ped-ikeda = ""
       THEN RETURN NO-APPLY.

    FOR EACH tt_detalhe:
        DELETE tt_detalhe.
    END.

    ASSIGN v_log_ped       = NO
           v_log_ped_aprov = NO
           v_log_acr       = NO               
           v_cdn_cliente   = 0
           v_nom_abrev     = ""
           v_cod_admdra    = ""
           v_cod_portador  = ""
           v_cod_carteira  = ""
           v_cod_cartao    = ""
           v_CarTID        = ""
           v_val_pedido    = 0
           v_dat_pedido    = ?.

    IF INPUT FRAME f_aprova rs_origem = "NSU / Boleto"
    THEN DO:

        FOR EACH int-ped-venda NO-LOCK
            WHERE int-ped-venda.CarTID = STRING(INT(v-nr-ped-ikeda), "999999999"):
    
            ASSIGN v_log_ped = YES.

            ASSIGN v_cod_admdra = int-ped-venda.FormaPgto.

            FIND ped-venda NO-LOCK
                WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

            IF NOT AVAIL ped-venda 
               THEN NEXT.

            IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
               THEN ASSIGN v_log_ped_aprov = YES.
    
            ASSIGN v_val_pedido   = v_val_pedido + ped-venda.vl-tot-ped
                   v_dat_pedido   = ped-venda.dt-emissao
                   v_cdn_cliente  = ped-venda.cod-emitente 
                   v_nom_abrev    = ped-venda.nome-abrev.
    
            FOR EACH tit_acr_cobr_especial NO-LOCK
                WHERE tit_acr_cobr_especial.cod_estab       = int-ped-venda.cod-estabel
                  /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = string(INT(int-ped-venda.CarTID)) ***/
                  AND tit_acr_cobr_especial.cod_comprov_vda = string(INT(int-ped-venda.CarTID)):
               
                FIND tit_acr NO-LOCK
                    WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                      AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
    
                FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                IF AVAIL ITEM_lote_liquidac_acr
                THEN DO:
                     ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                END.
                ELSE DO:
                     IF tit_acr.val_sdo_tit_acr = 0
                        THEN ASSIGN v_sit_lote = "Liquidado".
                        ELSE ASSIGN v_sit_lote = "Pendente".
                END.
    
                FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                ASSIGN pcNroCartao   = ''
                       piSeguranca   = 0
                       piOperadora   = 0
                       pcTitular     = ''
                       piValidadeMes = 0
                       piValidadeAno = 0
                       piTipoOrigem  = 0
                       cCartao       = ''.
           
                run consultaCartao in hesapi014(tit_acr_cobr_especial.cdn_cliente,
                                                int-ped-venda.seq-cartao-cred,
                                                output pcNroCartao,
                                                output piSeguranca,
                                                output piOperadora,
                                                output pcTitular,
                                                output piValidadeMes,
                                                output piValidadeAno,
                                                output piTipoOrigem).
           
                if pcNroCartao <> '' then
                   assign cCartao = substr(pcNroCartao,1,6) + '******' + substr(pcNroCartao,13,4).
    
                FIND emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                      AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
    
                ASSIGN v_log_acr      = YES
                       v_cdn_cliente  = tit_acr_cobr_especial.cdn_cliente
                       v_nom_abrev    = emscad.cliente.nom_abrev
                       v_cod_admdra   = tit_acr_cobr_especial.cod_admdra_cartao_cr
                       v_cod_portador = tit_acr.cod_portador
                       v_cod_carteira = tit_acr.cod_cart_bcia
                       v_cod_cartao   = cCartao
                       v_CarTID       = int-ped-venda.CarTID.
    
                CREATE tt_detalhe.
                ASSIGN tt_detalhe.cod_estab          = tit_acr.cod_estab  
                       tt_detalhe.cod_espec          = tit_acr.cod_espec  
                       tt_detalhe.cod_ser            = tit_acr.cod_ser    
                       tt_detalhe.cod_tit_acr        = tit_acr.cod_tit_acr
                       tt_detalhe.cod_parcela        = tit_acr_cobr_especial.cod_parcela
                       tt_detalhe.num_ped_EMS        = ped-venda.nr-pedido  
                       tt_detalhe.num_ped_parceiro   = ped-venda.nr-pedcli  
                       tt_detalhe.val_tit_acr        = tit_acr.val_origin_tit_acr               
                       tt_detalhe.cod_refer_liquidac = v_sit_lote
                       tt_detalhe.cod_tit_acr_bco    = tit_acr.cod_tit_acr_bco
                       tt_detalhe.rec_tit_acr        = RECID(tit_acr)
                       tt_detalhe.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                       tt_detalhe.log_an_gerada         = NO.
    
                assign tt_detalhe.cod_parcela = '0101'.

                /* ** 505
                find first tab_livre_emsfin no-lock use-index tblvrmsf_id
                    where tab_livre_emsfin.cod_modul_dtsul   = "SCO" /* l_sco*/
                    and   tab_livre_emsfin.cod_tab_dic_dtsul = "RELAC_PARC_CARTCRED" /* l_relac_parc_cartcred*/
                    and   tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + chr(24) + entry(5,tit_acr.cod_livre_1,chr(24))
                    and   tab_livre_emsfin.cod_compon_2_idx_tab = string(tit_acr_cobr_especial.num_id_tit_acr) no-error.
                if  avail tab_livre_emsfin then
                    assign tt_detalhe.cod_parcela = string(tab_livre_emsfin.num_livre_1,'99') + string(tab_livre_emsfin.num_livre_2,'99').
                ***/

                FIND FIRST relac_parc_cartcred NO-LOCK
                     WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                       AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                IF AVAIL relac_parc_cartcred 
                   THEN ASSIGN tt_detalhe.cod_parcela = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + STRING(relac_parc_cartcred.num_parc_cartcred, "99").
    
            END.
    
        END.
    
        IF NOT CAN-FIND(FIRST tt_detalhe)
        THEN DO:

            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_portador   = '237'
                  AND tit_acr.cod_tit_acr_bco MATCHES ("*" + string(v-nr-ped-ikeda) + ".10."):
       
                IF  tit_acr.cod_cart_bcia <> "71"
                AND tit_acr.cod_cart_bcia <> "72"
                    THEN NEXT.
       
                FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                IF AVAIL ITEM_lote_liquidac_acr
                THEN DO:
                     ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                END.
                ELSE DO:
                     IF tit_acr.val_sdo_tit_acr = 0
                        THEN ASSIGN v_sit_lote = "Liquidado".
                        ELSE ASSIGN v_sit_lote = "Pendente".
                END.
       
                FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
    
                FIND ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                      AND ped-venda.nome-abrev = tit_acr.nom_abrev NO-ERROR.
    
                IF NOT AVAIL ped-venda 
                   THEN NEXT.

                FIND FIRST int-ped-venda
                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

                IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
                   THEN ASSIGN v_log_ped_aprov = YES.

                ASSIGN v_log_ped      = YES
                       v_log_acr      = YES
                       v_cdn_cliente  = tit_acr.cdn_cliente
                       v_nom_abrev    = tit_acr.nom_abrev
                       v_cod_admdra   = "BOLETO"
                       v_cod_portador = tit_acr.cod_portador
                       v_cod_carteira = tit_acr.cod_cart_bcia
                       v_cod_cartao   = ""
                       v_CarTID       = ""
                       v_val_pedido   = v_val_pedido + ped-venda.vl-tot-ped 
                       v_dat_pedido   = ped-venda.dt-emissao
                       v_cdn_cliente  = ped-venda.cod-emitente 
                       v_nom_abrev    = ped-venda.nome-abrev.
    
                CREATE tt_detalhe.
                ASSIGN tt_detalhe.cod_estab          = tit_acr.cod_estab  
                       tt_detalhe.cod_espec          = tit_acr.cod_espec  
                       tt_detalhe.cod_ser            = tit_acr.cod_ser    
                       tt_detalhe.cod_tit_acr        = tit_acr.cod_tit_acr
                       tt_detalhe.cod_parcela        = "0101"
                       tt_detalhe.num_ped_EMS        = ped-venda.nr-pedido    
                       tt_detalhe.num_ped_parceiro   = ped-venda.nr-pedcli 
                       tt_detalhe.val_tit_acr        = tit_acr.val_origin_tit_acr               
                       tt_detalhe.cod_refer_liquidac = v_sit_lote
                       tt_detalhe.cod_tit_acr_bco    = tit_acr.cod_tit_acr_bco
                       tt_detalhe.rec_tit_acr        = RECID(tit_acr)
                       tt_detalhe.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                       tt_detalhe.log_an_gerada         = NO.

                FIND b_tit_acr_an NO-LOCK 
                   WHERE b_tit_acr_an.cod_estab           = "101"
                     AND b_tit_acr_an.cod_espec           = "AN"
                     AND b_tit_acr_an.cod_ser             = "5"
                     AND b_tit_acr_an.cod_tit_acr         = "B2" + INPUT FRAME f_aprova v-nr-ped-ikeda
                     AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                IF AVAIL b_tit_acr_an 
                   THEN ASSIGN tt_detalhe.log_an_gerada = YES.
       
            END.
    
        END.
    END.
    ELSE DO:

        FOR EACH int-ped-venda NO-LOCK
            WHERE int-ped-venda.PedidoCodigo = INT(v-nr-ped-ikeda):

            ASSIGN v_log_ped = YES.

            ASSIGN v_cod_admdra = int-ped-venda.FormaPgto.

            IF int-ped-venda.FormaPgto = "Boleto" 
            OR int-ped-venda.FormaPgto = "Boleto - PAR"
               THEN ENABLE bt_aprova WITH FRAME f_aprova.

            FIND ped-venda NO-LOCK
                WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
  
            IF NOT AVAIL ped-venda 
               THEN NEXT.

            IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
               THEN ASSIGN v_log_ped_aprov = YES.

            ASSIGN v_val_pedido   = v_val_pedido + ped-venda.vl-tot-ped 
                   v_dat_pedido   = ped-venda.dt-emissao
                   v_cdn_cliente  = ped-venda.cod-emitente 
                   v_nom_abrev    = ped-venda.nome-abrev.
  
            FOR EACH tit_acr_cobr_especial NO-LOCK
                WHERE tit_acr_cobr_especial.cod_estab       = int-ped-venda.cod-estabel
                  /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = string(INT(int-ped-venda.CarTID)) ***/
                  AND tit_acr_cobr_especial.cod_comprov_vda = string(INT(int-ped-venda.CarTID)):
  
                FIND tit_acr NO-LOCK
                    WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                      AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
  
                FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                IF AVAIL ITEM_lote_liquidac_acr
                THEN DO:
                     ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                END.
                ELSE DO:
                     IF tit_acr.val_sdo_tit_acr = 0
                        THEN ASSIGN v_sit_lote = "Liquidado".
                        ELSE ASSIGN v_sit_lote = "Pendente".
                END.
  
                FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                ASSIGN pcNroCartao   = ''
                       piSeguranca   = 0
                       piOperadora   = 0
                       pcTitular     = ''
                       piValidadeMes = 0
                       piValidadeAno = 0
                       piTipoOrigem  = 0
                       cCartao       = ''.
  
                run consultaCartao in hesapi014(tit_acr_cobr_especial.cdn_cliente,
                                                int-ped-venda.seq-cartao-cred,
                                                output pcNroCartao,
                                                output piSeguranca,
                                                output piOperadora,
                                                output pcTitular,
                                                output piValidadeMes,
                                                output piValidadeAno,
                                                output piTipoOrigem).
  
                if pcNroCartao <> '' then
                   assign cCartao = substr(pcNroCartao,1,6) + '******' + substr(pcNroCartao,12,4).
  
                FIND emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                      AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
  
                ASSIGN v_log_acr      = YES
                       v_cdn_cliente  = tit_acr_cobr_especial.cdn_cliente
                       v_nom_abrev    = emscad.cliente.nom_abrev
                       v_cod_admdra   = tit_acr_cobr_especial.cod_admdra_cartao_cr
                       v_cod_portador = tit_acr.cod_portador
                       v_cod_carteira = tit_acr.cod_cart_bcia
                       v_cod_cartao   = cCartao
                       v_CarTID       = int-ped-venda.CarTID.
  
                CREATE tt_detalhe.
                ASSIGN tt_detalhe.cod_estab          = tit_acr.cod_estab  
                       tt_detalhe.cod_espec          = tit_acr.cod_espec  
                       tt_detalhe.cod_ser            = tit_acr.cod_ser    
                       tt_detalhe.cod_tit_acr        = tit_acr.cod_tit_acr
                       tt_detalhe.cod_parcela        = tit_acr_cobr_especial.cod_parcela
                       tt_detalhe.num_ped_EMS        = ped-venda.nr-pedido  
                       tt_detalhe.num_ped_parceiro   = ped-venda.nr-pedcli  
                       tt_detalhe.val_tit_acr        = tit_acr.val_origin_tit_acr               
                       tt_detalhe.cod_refer_liquidac = v_sit_lote
                       tt_detalhe.cod_tit_acr_bco    = tit_acr.cod_tit_acr_bco
                       tt_detalhe.rec_tit_acr        = RECID(tit_acr)
                       tt_detalhe.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                       tt_detalhe.log_an_gerada         = NO.
  
                assign tt_detalhe.cod_parcela = '0101'.

                /* ** 505
                find first tab_livre_emsfin no-lock use-index tblvrmsf_id
                    where tab_livre_emsfin.cod_modul_dtsul   = "SCO" /* l_sco*/
                    and   tab_livre_emsfin.cod_tab_dic_dtsul = "RELAC_PARC_CARTCRED" /* l_relac_parc_cartcred*/
                    and   tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + chr(24) + entry(5,tit_acr.cod_livre_1,chr(24))
                    and   tab_livre_emsfin.cod_compon_2_idx_tab = string(tit_acr_cobr_especial.num_id_tit_acr) no-error.
                if  avail tab_livre_emsfin then
                    assign tt_detalhe.cod_parcela = string(tab_livre_emsfin.num_livre_1,'99') + string(tab_livre_emsfin.num_livre_2,'99').
                ***/
  
                FIND FIRST relac_parc_cartcred NO-LOCK
                     WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                       AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                IF AVAIL relac_parc_cartcred 
                   THEN ASSIGN tt_detalhe.cod_parcela = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + STRING(relac_parc_cartcred.num_parc_cartcred, "99").

            END.
  
        END.
  
        IF NOT CAN-FIND(FIRST tt_detalhe)
        THEN DO:

            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_portador   = '237'
                  AND tit_acr.cod_tit_acr_bco MATCHES ("*" + string(v-nr-ped-ikeda) + ".10."):
  
                IF  tit_acr.cod_cart_bcia <> "71"
                AND tit_acr.cod_cart_bcia <> "72"
                    THEN NEXT.
  
                FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                IF AVAIL ITEM_lote_liquidac_acr
                THEN DO:
                     ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                END.
                ELSE DO:
                     IF tit_acr.val_sdo_tit_acr = 0
                        THEN ASSIGN v_sit_lote = "Liquidado".
                        ELSE ASSIGN v_sit_lote = "Pendente".
                END.
  
                FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
  
                FIND ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                      AND ped-venda.nome-abrev = tit_acr.nom_abrev NO-ERROR.
  
                IF NOT AVAIL ped-venda 
                   THEN NEXT.

                IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
                   THEN ASSIGN v_log_ped_aprov = YES.

                ASSIGN v_log_ped      = YES
                       v_log_acr      = YES
                       v_cdn_cliente  = tit_acr.cdn_cliente
                       v_nom_abrev    = tit_acr.nom_abrev
                       v_cod_admdra   = "BOLETO"
                       v_cod_portador = tit_acr.cod_portador
                       v_cod_carteira = tit_acr.cod_cart_bcia
                       v_cod_cartao   = ""
                       v_CarTID       = "".
  
                CREATE tt_detalhe.
                ASSIGN tt_detalhe.cod_estab          = tit_acr.cod_estab  
                       tt_detalhe.cod_espec          = tit_acr.cod_espec  
                       tt_detalhe.cod_ser            = tit_acr.cod_ser    
                       tt_detalhe.cod_tit_acr        = tit_acr.cod_tit_acr
                       tt_detalhe.cod_parcela        = "0101"
                       tt_detalhe.num_ped_EMS        = ped-venda.nr-pedido    
                       tt_detalhe.num_ped_parceiro   = ped-venda.nr-pedcli 
                       tt_detalhe.val_tit_acr        = tit_acr.val_origin_tit_acr               
                       tt_detalhe.cod_refer_liquidac = v_sit_lote
                       tt_detalhe.cod_tit_acr_bco    = tit_acr.cod_tit_acr_bco
                       tt_detalhe.rec_tit_acr        = RECID(tit_acr)
                       tt_detalhe.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                       tt_detalhe.log_an_gerada         = NO.

                FIND b_tit_acr_an NO-LOCK 
                   WHERE b_tit_acr_an.cod_estab           = "101"
                     AND b_tit_acr_an.cod_espec           = "AN"
                     AND b_tit_acr_an.cod_ser             = "5"
                     AND b_tit_acr_an.cod_tit_acr         = "B2" + INPUT FRAME f_aprova v-nr-ped-ikeda
                     AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                IF AVAIL b_tit_acr_an 
                   THEN ASSIGN tt_detalhe.log_an_gerada = YES.
  
            END.
  
        END.

        IF CAN-FIND(FIRST tt_detalhe) 
           THEN DISABLE bt_aprova WITH FRAME f_aprova.

    END.

    OPEN QUERY qr_tt_detalhe
         FOR EACH  tt_detalhe NO-LOCK.

    DISP v_log_ped
         v_log_ped_aprov
         v_log_acr 
         v_cdn_cliente       
         v_nom_abrev         
         v_cod_admdra        
         v_cod_portador      
         v_cod_carteira      
         v_cod_cartao 
         v_val_pedido
         v_dat_pedido
         v_CarTID WITH FRAME f_aprova.

END.

ON WINDOW-CLOSE OF wh_w_program
DO:

    APPLY "choose" TO bt_exi IN FRAME f_aprova.

END.

/* ** Detalhe Conciliaá∆o ***/

def frame f_comiss_det
    rt_cxcf
         at row 17.00 col 02.00 bgcolor 7 
    br_tt_concil_bol
         AT ROW 1.21 COL 2
    br_tt_concil_adm
         AT ROW 1.21 COL 2
    bt_ok
         at row 17.21 col 03.00 font ?
         help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 111 by 18.83 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Extrato B2x  - Detalhado".
    /* adjust size of objects in this frame */
    assign bt_ok:width-chars            in frame f_comiss_det = 10.00
           bt_ok:height-chars           in frame f_comiss_det = 01.00
           rt_cxcf:width-chars          in frame f_comiss_det = 108
           rt_cxcf:height-chars         in frame f_comiss_det = 01.42.

ON ROW-DISPLAY OF br_tt_concil_bol IN FRAME f_comiss_det
DO:

    IF tt_concil.val_tit_acr_EMS <> tt_concil.val_tit_acr_pago
    THEN DO:
         ASSIGN tt_concil.val_tit_acr_EMS:BGCOLOR  IN BROWSE br_tt_concil_bol = 12
                tt_concil.val_tit_acr_pago:BGCOLOR IN BROWSE br_tt_concil_bol = 12.
    END.

END.

ON ROW-DISPLAY OF br_tt_concil_adm IN FRAME f_comiss_det
DO:

    IF tt_concil.val_tit_acr_EMS <> tt_concil.val_tit_acr_pago
    THEN DO:
         ASSIGN tt_concil.val_tit_acr_EMS:BGCOLOR  IN BROWSE br_tt_concil_adm = 12
                tt_concil.val_tit_acr_pago:BGCOLOR IN BROWSE br_tt_concil_adm = 12.
    END.

END.

/* **  ***/

assign wh_w_program:title         = frame f_aprova:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 1.00.00.000":U)
                                  + chr(41)
       frame f_aprova:title       = ?
       wh_w_program:width-chars   = frame f_aprova:width-chars
       wh_w_program:height-chars  = frame f_aprova:height-chars - 0.85
       frame f_aprova:row         = 1
       frame f_aprova:col         = 1
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.


pause 0 before-hide.
view frame f_aprova.
enable bt_exi
       bt_liq_bol
       bt_gera_an
       bt_liquidac
       bt_estorno
       bt_lista_ped
       bt_import
       bt_debito
       rs_origem
       bt_enter
       v-nr-ped-ikeda
       br_tt_detalhe
       with frame f_aprova.

if  this-procedure:persistent = no
then do:
    wait-for choose of bt_exi in frame f_aprova.
end.

if valid-handle(hesapi014) then
   delete object hesapi014.


PROCEDURE pi_liquidac_bol:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.

    FOR EACH tt_integr_acr_liquidac_lote:
        DELETE tt_integr_acr_liquidac_lote.
    END.
    FOR EACH tt_integr_acr_liq_item_lote_3:
        DELETE tt_integr_acr_liq_item_lote_3.
    END.
    FOR EACH tt_integr_acr_abat_antecip:
        DELETE tt_integr_acr_abat_antecip.
    END.
    FOR EACH tt_integr_acr_abat_prev:
        DELETE tt_integr_acr_abat_prev.
    END.
    FOR EACH tt_integr_acr_cheq:
        DELETE tt_integr_acr_cheq.
    END.
    FOR EACH tt_integr_acr_liquidac_impto_2:
        DELETE tt_integr_acr_liquidac_impto_2.
    END.
    FOR EACH tt_integr_acr_rel_pend_cheq:
        DELETE tt_integr_acr_rel_pend_cheq.
    END.
    FOR EACH tt_integr_acr_liq_aprop_ctbl:
        DELETE tt_integr_acr_liq_aprop_ctbl.
    END.
    FOR EACH tt_integr_acr_liq_desp_rec:
        DELETE tt_integr_acr_liq_desp_rec.
    END.
    FOR EACH tt_integr_acr_aprop_liq_antec: 
        DELETE tt_integr_acr_aprop_liq_antec.
    END.
    FOR EACH tt_log_erros_import_liquidac:
        DELETE tt_log_erros_import_liquidac.
    END.
    FOR EACH tt_integr_cambio_ems5:
        DELETE tt_integr_cambio_
    END.

    FIND tit_acr NO-LOCK
         WHERE RECID(tit_acr) = tt_detalhe.rec_tit_acr NO-ERROR.

    ASSIGN v_log_refer_uni = NO.

    /* ** Gera Referància V†lida ***/
    REPEAT WHILE NOT v_log_refer_uni:
        RUN pi_retorna_sugestao_referencia (INPUT "B",
                                            INPUT TODAY,
                                            OUTPUT v_cod_refer).
    
        /* --- Verifica Referància Ènica ---*/
        RUN pi_verifica_refer_unica_acr (INPUT tit_acr.cod_estab,
                                         INPUT v_cod_refer,
                                         INPUT "lote_liquidac_acr",
                                         INPUT ?,
                                         OUTPUT v_log_refer_uni).
    END.

    CREATE tt_integr_acr_liquidac_lote.
    ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = tit_acr.cod_empresa
           tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = tit_acr.cod_estab
           tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren
           tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = v_data_base
           tt_integr_acr_liquidac_lote.tta_dat_transacao               = v_data_base
           tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
           tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digitaá∆o"
           tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO    
           tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES
           tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO 
           tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
           tt_integr_acr_liquidac_lote.tta_cod_refer                   = v_cod_refer.

    CREATE tt_integr_acr_liq_item_lote_3.
    ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr.cod_empresa
           tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr.cod_estab
           tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr.cod_espec_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr.cod_parcela
           tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr.cdn_cliente
           tt_integr_acr_liq_item_lote_3.tta_cod_portador               = tit_acr.cod_portador
           tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = tit_acr.cod_cart_bcia
           tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
           tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
           tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tit_acr.val_sdo_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = no
           tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = no
           tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
           tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = no
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Compostos"
           tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
           tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = recid(tt_integr_acr_liq_item_lote_3).

    IF v_val_abat <> 0 
    THEN DO:
         CREATE tt_integr_acr_abat_antecip.
         ASSIGN tt_integr_acr_abat_antecip.ttv_rec_item_lote_impl_tit_acr = tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr
                tt_integr_acr_abat_antecip.ttv_rec_abat_antecip_acr       = recid(tt_integr_acr_abat_antecip)
                tt_integr_acr_abat_antecip.tta_cod_estab                  = b_tit_acr.cod_estab
                tt_integr_acr_abat_antecip.tta_cod_espec_docto            = b_tit_acr.cod_espec
                tt_integr_acr_abat_antecip.tta_cod_ser_docto              = b_tit_acr.cod_ser
                tt_integr_acr_abat_antecip.tta_cod_tit_acr                = b_tit_acr.cod_tit_acr
                tt_integr_acr_abat_antecip.tta_cod_parcela                = b_tit_acr.cod_parcela
                tt_integr_acr_abat_antecip.tta_val_abtdo_antecip_tit_abat = v_val_abat.
    END.

    RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hld_handle.

    RUN pi_main_code_api_integr_acr_liquidac_4 IN v_hld_handle (Input 1,
                                                                Input table tt_integr_acr_liquidac_lote,
                                                                Input table tt_integr_acr_liq_item_lote_3,
                                                                Input table tt_integr_acr_abat_antecip,
                                                                Input table tt_integr_acr_abat_prev,
                                                                Input table tt_integr_acr_cheq,
                                                                Input table tt_integr_acr_liquidac_impto_2,
                                                                Input table tt_integr_acr_rel_pend_cheq,
                                                                Input table tt_integr_acr_liq_aprop_ctbl,
                                                                Input table tt_integr_acr_liq_desp_rec,
                                                                Input table tt_integr_acr_aprop_liq_antec,
                                                                Input "",
                                                                output table tt_log_erros_import_liquidac,
                                                                Input table tt_integr_cambio_ems5).

    DELETE PROCEDURE v_hld_handle.

    FOR EACH tt_log_erros_import_liquidac:
        MESSAGE "Erro: "     tt_log_erros_import_liquidac.ttv_num_erro_log SKIP
                "Mensagem: " tt_log_erros_import_liquidac.ttv_des_msg_erro 
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.


PROCEDURE pi_verifica_refer_unica_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    def buffer b_renegoc_acr
        for renegoc_acr.

    /*************************** Buffer Definition End **************************/

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "Operaá∆o financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.

END PROCEDURE.

PROCEDURE pi_import:

    DEFINE VARIABLE v_dat_aux      AS DATE        NO-UNDO.
    DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-linha        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_parc     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_parc_aux AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v_cod_diretorio AS CHARACTER   NO-UNDO.

    DEF VAR v_aux AS CHAR.

    DEF BUFFER b_tit_acr_an FOR tit_acr.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

    FOR EACH tt_concil_aux:
        DELETE tt_concil_aux.
    END.
    FOR EACH tt_concil:
        DELETE tt_concil.
    END.

    IF rs_opcao = "RedeCard"
    THEN DO:
         MESSAGE "Conciliaá∆o da Redecard n∆o liberada !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN.
    END.

    DO v_dat_aux = v_dat_ini TO v_dat_fim:

        ASSIGN v_cod_diretorio = "s:\financeiro\skyline\inbox".

        INPUT STREAM s_1 FROM OS-DIR (v_cod_diretorio).
        REPEAT:

            IMPORT STREAM s_1 v_aux.

            IF v_aux = "." 
            OR v_aux = ".." 
            OR SEARCH(v_cod_diretorio + "~\" + v_aux) = ?
               THEN NEXT.

            ASSIGN c-arquivo = "".

            IF  rs_opcao = "Boleto"
            AND v_aux BEGINS ("COB237" + STRING(DAY(v_dat_aux)  , '99')    
                                       + STRING(MONTH(v_dat_aux), '99')    
                                       + SUBSTRING(STRING(YEAR(TODAY)),3,2)) 
            THEN DO:
                 ASSIGN c-arquivo = "s:\financeiro\skyline\inbox\" + v_aux.
            END.

            IF  rs_opcao = "VisaNet"
            AND v_aux BEGINS ("VISA" + STRING(DAY(v_dat_aux)  , '99')    
                                     + STRING(MONTH(v_dat_aux), '99')    
                                     + STRING(YEAR(v_dat_aux) , '9999') /*
                                     + "01.RET" */ ) 
            THEN DO:
                 ASSIGN c-arquivo = "s:\financeiro\skyline\inbox\" + v_aux.
            END.

            IF  rs_opcao = "RedeCard" 
            AND v_aux BEGINS ("EEFI" + STRING(DAY(v_dat_aux)  , '99')    
                                     + STRING(MONTH(v_dat_aux), '99')    
                                     + STRING(YEAR(v_dat_aux) , '9999')) 
            THEN DO:
                 ASSIGN c-arquivo = "s:\financeiro\skyline\inbox\" + v_aux.
            END.


/*
        IF rs_opcao = "Boleto" 
          THEN ASSIGN c-arquivo = search("s:\financeiro\skyline\inbox\COB237"
                                         + STRING(DAY(v_dat_aux)  , '99')
                                         + STRING(MONTH(v_dat_aux), '99')
                                         + SUBSTRING(STRING(YEAR(TODAY)),3,2)
                                         + "00.RET"). /*00 e 01*/

        IF rs_opcao = "VisaNet" 
           THEN ASSIGN c-arquivo = search("s:\financeiro\skyline\inbox\visa" 
                                          + STRING(DAY(v_dat_aux)  , '99')
                                          + STRING(MONTH(v_dat_aux), '99')
                                          + STRING(YEAR(v_dat_aux) , '9999')
                                          + "01.RET"). 
  
        IF rs_opcao = "RedeCard" 
          THEN ASSIGN c-arquivo = search("s:\financeiro\skyline\inbox\EEFI"
                                         + STRING(DAY(v_dat_aux)  , '99')
                                         + STRING(MONTH(v_dat_aux), '99')
                                         + STRING(YEAR(v_dat_aux) , '9999')
                                         + "00.RET"). /*00 e 01*/
                                         
                                         */
  
            IF c-arquivo <> "" 
            THEN DO:

                 INPUT STREAM s_2 FROM VALUE(c-arquivo). 

                 REPEAT:
                     IMPORT STREAM s_2 UNFORMATTED c-linha.
    
                     IF rs_opcao = "Boleto"
                     THEN DO:
    
                          IF SUBSTRING(c-linha, 1, 2) <> "10"
                             THEN NEXT.
    
                          CREATE tt_concil_aux.
                          ASSIGN tt_concil_aux.dat_transacao    = v_dat_aux
                                 tt_concil_aux.val_tit_acr_pago = (DEC(SUBSTRING(c-linha, 153, 13)) / 100)
                                 tt_concil_aux.cod_tit_acr_bco  = SUBSTRING(c-linha, 73, 9).
    
                     END.
      
                     IF rs_opcao = "VisaNet"
                     THEN DO:
    
                          IF  SUBSTRING(c-linha, 1, 1)  = "0"
                          AND SUBSTRING(c-linha, 53, 1) = "D"
                             THEN LEAVE.

                          IF SUBSTRING(c-linha, 1, 1) <> "2"
                             THEN NEXT.


                          CREATE tt_concil_aux.
                          ASSIGN tt_concil_aux.dat_transacao    = v_dat_aux
                                 tt_concil_aux.cod_resumo       = SUBSTRING(c-linha,  12, 7)
                                 tt_concil_aux.cod_nsu          = SUBSTRING(c-linha, 140, 6)
                                 tt_concil_aux.cod_autoriz      = SUBSTRING(c-linha,  94, 6)
                                 tt_concil_aux.cod_parcela      = STRING(SUBSTRING(c-linha, 60, 4), "99/99")
                                 tt_concil_aux.val_tit_acr_pago = (DEC(SUBSTRING(c-linha, 47, 13)) / 100)
                                 tt_concil_aux.cod_tit_acr_bco  = SUBSTRING(c-linha, 19, 19) /*Nr Cart∆o*/.
                          IF tt_concil_aux.cod_parcela = "00/00" 
                             THEN ASSIGN tt_concil_aux.cod_parcela = "01/01".

                     END.
/*
                     IF rs_opcao = "RedeCard"
                     THEN DO:
    
                          IF  SUBSTRING(c-linha, 1, 3) <> "034" /*Ordem de CrÇdito*/
                          AND SUBSTRING(c-linha, 1, 3) <> "035" /*Ajustes*/
                          AND SUBSTRING(c-linha, 1, 3) <> "038" /*Ajustes a DÇbito*/
                          AND SUBSTRING(c-linha, 1, 3) <> "043" /*Ajustes a CrÇdito*/
                              THEN NEXT.
    

                          zarpe - ligar para o suporte da redecard e solicitas NSU NO detalhamento DO repasse

                          CREATE tt_concil_aux.
                          ASSIGN tt_concil_aux.dat_transacao    = v_dat_aux
                                 tt_concil_aux.cod_resumo       = SUBSTRING(c-linha,  12, 7)
                                 tt_concil_aux.cod_nsu          = SUBSTRING(c-linha, 140, 6)
                                 tt_concil_aux.cod_parcela      = v_cod_parc
                                 tt_concil_aux.val_tit_acr_pago = (DEC(SUBSTRING(c-linha, 47, 13)) / 100)
                                 tt_concil_aux.cod_tit_acr_bco  = SUBSTRING(c-linha, 19, 19) /*Nr Cart∆o*/.
    
                     END.
  */
    
                 END.
                 INPUT CLOSE.
            END.

        END.

    END.
    
    FOR EACH tt_concil_aux:

        IF rs_opcao = "VisaNet"
        OR rs_opcao = "RedeCard"
        THEN DO:

            FOR EACH int-ped-venda NO-LOCK
                WHERE int-ped-venda.CarTID = STRING(INT(tt_concil_aux.cod_nsu), "999999999"),
                EACH gateway-ikeda 
                WHERE gateway-ikeda.PedidoCodigo      = int-ped-venda.PedidoCodigo
                  AND gateway-ikeda.CodigoAutorizacao = tt_concil_aux.cod_autoriz:
        
                FIND ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
        
                FOR EACH tit_acr_cobr_especial NO-LOCK
                    WHERE tit_acr_cobr_especial.cod_estab        = int-ped-venda.cod-estabel
                      /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = string(INT(int-ped-venda.CarTID)) ***/
                      AND tit_acr_cobr_especial.cod_comprov_vda  = string(INT(int-ped-venda.CarTID)):

                    FIND tit_acr NO-LOCK
                        WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                          AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
        
                    ASSIGN v_cod_parc_aux = '01/01'.

                    /* ** 505
                    FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                         WHERE tab_livre_emsfin.cod_modul_dtsul   = "SCO"
                           AND tab_livre_emsfin.cod_tab_dic_dtsul = "RELAC_PARC_CARTCRED"
                           AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                           AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                    IF AVAIL tab_livre_emsfin 
                       THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
                    ***/

                    FIND FIRST relac_parc_cartcred NO-LOCK
                         WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                           AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                    IF AVAIL relac_parc_cartcred 
                       THEN ASSIGN v_cod_parc_aux = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + "/" + STRING(relac_parc_cartcred.num_parc_cartcred, "99").

                    IF tt_concil_aux.cod_parcela <> v_cod_parc_aux
                       THEN NEXT.

                    FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                    IF AVAIL ITEM_lote_liquidac_acr
                    THEN DO:
                         ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                    END.
                    ELSE DO:
                         IF tit_acr.val_sdo_tit_acr = 0
                            THEN ASSIGN v_sit_lote = "Liquidado".
                            ELSE ASSIGN v_sit_lote = "Pendente".
                    END.
        
                    FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
        
                    FIND emscad.cliente NO-LOCK
                        WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                          AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
        
                    CREATE tt_concil.
                    ASSIGN tt_concil.dat_transacao         = tt_concil_aux.dat_transacao
                           tt_concil.cod_resumo            = tt_concil_aux.cod_resumo
                           tt_concil.cod_nsu               = tt_concil_aux.cod_nsu
                           tt_concil.num_ped_EMS           = ped-venda.nr-pedido
                           tt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                           tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                           tt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                           tt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                           tt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                           tt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                           tt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                           tt_concil.cod_parcela           = v_cod_parc_aux
                           tt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                           tt_concil.val_tit_acr_pago      = tt_concil_aux.val_tit_acr_pago
                           tt_concil.cod_refer_liquidac    = v_sit_lote
                           tt_concil.cod_tit_acr_bco       = SUBSTRING(tt_concil_aux.cod_tit_acr_bco,1,6) + '******' + SUBSTRING(tt_concil_aux.cod_tit_acr_bco,13,4) 
                           tt_concil.des_status            = ''
                           tt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                           tt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                           tt_concil.LOG_an_gerada         = NO.
        
                END.
        
            END.
        END.
        ELSE DO: /* ** Boleto ***/
             
             IF NOT CAN-FIND(FIRST tit_acr NO-LOCK
                             WHERE tit_acr.cod_portador   = '237'
                               AND tit_acr.cod_tit_acr_bco MATCHES ("*" + tt_concil_aux.cod_tit_acr_bco + ".10."))
             THEN DO:
                  CREATE tt_concil.
                  ASSIGN tt_concil.dat_transacao         = tt_concil_aux.dat_transacao
                         tt_concil.cod_resumo            = ""
                         tt_concil.cod_nsu               = ""
                         tt_concil.cdn_cliente_adm       = 0
                         tt_concil.cod_estab             = ""
                         tt_concil.cod_espec             = ""
                         tt_concil.cod_ser               = ""
                         tt_concil.cod_tit_acr           = ""
                         tt_concil.cod_parcela           = ""
                         tt_concil.val_tit_acr_pago      = tt_concil_aux.val_tit_acr_pago
                         tt_concil.cod_refer_liquidac    = ""
                         tt_concil.cod_tit_acr_bco       = ""
                         tt_concil.des_status            = ""
                         tt_concil.rec_tit_acr           = ?
                         tt_concil.rec_lote_liquidac_acr = ?
                         tt_concil.log_an_gerada         = NO.

                  
                  IF NOT CAN-FIND(FIRST int-ped-venda NO-LOCK
                      WHERE int-ped-venda.PedidoCodigo = INT(tt_concil_aux.cod_tit_acr_bco)) 
                  THEN DO:
                       ASSIGN tt_concil.num_ped_parceiro = tt_concil_aux.cod_tit_acr_bco
                              tt_concil.des_status       = "Erro Integraá∆o IKEDA/EMS.".
                  END.
                  ELSE DO:

                       FOR EACH int-ped-venda NO-LOCK
                           WHERE int-ped-venda.PedidoCodigo = INT(tt_concil_aux.cod_tit_acr_bco):
                           
                           ASSIGN tt_concil.num_ped_parceiro = STRING(int-ped-venda.PedidoCodigo).

                           FIND b_tit_acr_an NO-LOCK 
                              WHERE b_tit_acr_an.cod_estab           = "101"
                                AND b_tit_acr_an.cod_espec           = "AN"
                                AND b_tit_acr_an.cod_ser             = "5"
                                AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(int-ped-venda.PedidoCodigo)
                                AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                           IF AVAIL b_tit_acr_an 
                              THEN ASSIGN tt_concil.log_an_gerada = YES.

                           FIND ped-venda NO-LOCK
                               WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

                           IF NOT AVAIL ped-venda 
                           THEN DO: 
                                ASSIGN tt_concil.des_status = "Pedido EMS n∆o Localizado.".
                                NEXT.
                           END.
    
                           ASSIGN tt_concil.num_ped_EMS      = ped-venda.nr-pedido
                                  tt_concil.cdn_cliente_orig = ped-venda.cod-emitente
                                  tt_concil.val_tit_acr_EMS  = tt_concil.val_tit_acr_EMS + ped-venda.vl-tot-ped + int-ped-venda.vl-frete.

                           IF ped-venda.cod-sit-aval <> 3 /* Aprovado */ 
                              THEN ASSIGN tt_concil.des_status = "Pedido EMS n∆o Aprovado.".
                              ELSE ASSIGN tt_concil.des_status = "Pedido EMS n∆o Faturado.".
    
                       END.                  

                  END.

                  FIND b_tit_acr_an NO-LOCK 
                     WHERE b_tit_acr_an.cod_estab           = "101"
                       AND b_tit_acr_an.cod_espec           = "AN"
                       AND b_tit_acr_an.cod_ser             = "5"
                       AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(ped-venda.nr-pedido)
                       AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                  IF AVAIL b_tit_acr_an 
                     THEN ASSIGN tt_concil.LOG_an_gerada = YES.

             END.
             ELSE DO:
                 FOR EACH tit_acr NO-LOCK
                     WHERE tit_acr.cod_portador   = '237'
                       AND tit_acr.cod_tit_acr_bco MATCHES ("*" + tt_concil_aux.cod_tit_acr_bco + ".10."):
    
                     IF  tit_acr.cod_cart_bcia <> "71"
                     AND tit_acr.cod_cart_bcia <> "72"
                         THEN NEXT.
    
                     FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                     IF AVAIL ITEM_lote_liquidac_acr
                     THEN DO:
                          ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
                     END.
                     ELSE DO:
                          IF tit_acr.val_sdo_tit_acr = 0
                             THEN ASSIGN v_sit_lote = "Liquidado".
                             ELSE ASSIGN v_sit_lote = "Pendente".
                     END.
          
                     FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
    
                     FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
          
                     FIND ped-venda NO-LOCK
                         WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                           AND ped-venda.nome-abrev = tit_acr.nom_abrev NO-ERROR.
          
                     IF NOT AVAIL ped-venda 
                        THEN NEXT.
          
                     IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
                        THEN ASSIGN v_log_ped_aprov = YES.
          
                     CREATE tt_concil.
                     ASSIGN tt_concil.dat_transacao         = tt_concil_aux.dat_transacao
                            tt_concil.cod_resumo            = tt_concil_aux.cod_resumo
                            tt_concil.cod_nsu               = tt_concil_aux.cod_nsu
                            tt_concil.num_ped_EMS           = ped-venda.nr-pedido
                            tt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                            tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                            tt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                            tt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                            tt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                            tt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                            tt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                            tt_concil.cod_parcela           = "01/01"
                            tt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                            tt_concil.val_tit_acr_pago      = tt_concil_aux.val_tit_acr_pago
                            tt_concil.cod_refer_liquidac    = v_sit_lote
                            tt_concil.cod_tit_acr_bco       = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr_bco    ELSE "" 
                            tt_concil.des_status            = ""
                            tt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                            tt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                            tt_concil.LOG_an_gerada         = NO.
          
                     IF tt_concil.val_tit_acr_EMS <> tt_concil.val_tit_acr_pago
                        THEN ASSIGN tt_concil.des_status = "Conferir Valor.".
                     IF tit_acr.val_sdo_tit_acr <> 0 
                        THEN ASSIGN tt_concil.des_status = tt_concil.des_status + "Falta Liquidar.".
                     IF tt_concil.des_status = "" 
                        THEN ASSIGN tt_concil.des_status = "OK.".
      
                     FIND b_tit_acr_an NO-LOCK 
                        WHERE b_tit_acr_an.cod_estab           = "101"
                          AND b_tit_acr_an.cod_espec           = "AN"
                          AND b_tit_acr_an.cod_ser             = "5"
                          AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(ped-venda.nr-pedido)
                          AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                     IF AVAIL b_tit_acr_an 
                        THEN ASSIGN tt_concil.LOG_an_gerada = YES.
          
                 END.
             END.
        END.
    END.

    IF rs_opcao = "VisaNet"
    OR rs_opcao = "RedeCard"
    THEN DO:
         FOR EACH tt_concil_aux:
             IF NOT CAN-FIND(FIRST tt_concil
                             WHERE tt_concil.dat_transacao = tt_concil_aux.dat_transacao
                               AND tt_concil.cod_resumo    = tt_concil_aux.cod_resumo
                               AND tt_concil.cod_nsu       = tt_concil_aux.cod_nsu) 
             THEN DO:
                  CREATE tt_concil.
                  ASSIGN tt_concil.dat_transacao         = tt_concil_aux.dat_transacao
                         tt_concil.cod_resumo            = tt_concil_aux.cod_resumo
                         tt_concil.cod_nsu               = tt_concil_aux.cod_nsu
                         tt_concil.cod_parcela           = tt_concil_aux.cod_parcela
                         tt_concil.val_tit_acr_pago      = tt_concil_aux.val_tit_acr_pago
                         tt_concil.cod_tit_acr_bco       = SUBSTRING(tt_concil_aux.cod_tit_acr_bco,1,6) + '******' + SUBSTRING(tt_concil_aux.cod_tit_acr_bco,13,4) 
                         tt_concil.des_status            = 'Erro: Parcela n∆o Localizada'
                         tt_concil.LOG_an_gerada         = NO.
             END.
         END.
    END.

    ASSIGN v_log_method = session:SET-WAIT-STATE("").

    VIEW FRAME f_comiss_det.
  
    concil_block:
    DO ON ERROR UNDO concil_block, RETRY concil_block
                     ON ENDKEY UNDO concil_block, LEAVE concil_block:
  
         ENABLE ALL WITH FRAME f_comiss_det.
  
         IF rs_opcao = "VisaNet"
         OR rs_opcao = "RedeCard"
         THEN DO:
              ASSIGN br_tt_concil_bol:VISIBLE = NO
                     br_tt_concil_adm:VISIBLE = YES.
              OPEN QUERY qr_tt_concil_adm
                   FOR EACH tt_concil NO-LOCK.
      
         END.
         ELSE DO:
              ASSIGN br_tt_concil_adm:VISIBLE = NO
                     br_tt_concil_bol:VISIBLE = YES.
              OPEN QUERY qr_tt_concil_bol
                   FOR EACH tt_concil NO-LOCK.
         END.

         WAIT-FOR GO OF FRAME f_comiss_det.
  
    END.
  
    HIDE FRAME f_comiss_det.

END.
