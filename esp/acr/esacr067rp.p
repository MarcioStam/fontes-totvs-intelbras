{include/i-prgvrs.i esacr067RP 2.00.00.000}  


/*-------------------------------------------------*/
/*    D E F I N I € Ç O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
{esp/acr/acr711zo.i}


    def temp-table tt_erros_conexao no-undo
        field ttv_cdn_erro                     as Integer format ">>>,>>9"
        field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia".

    def temp-table tt_integr_acr_abat_antecip no-undo
        field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
        field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
        field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
        field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
        field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
        field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
        field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
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
        field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
        field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
        field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
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
              tta_cod_parcela                  ascending
        .

    def temp-table tt_integr_acr_aprop_liq_antec no-undo
        field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
        field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
        field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
        field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)"
        field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
        field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
        field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T¡tulo" column-label "Unid Negoc T¡tulo"
        field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
        field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido"
        .

    def temp-table tt_integr_acr_cheq no-undo
        field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
        field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
        field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
        field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
        field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss"
        field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep¢sito" column-label "Dep¢sito"
        field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "PrevisÆo Dep¢sito" column-label "PrevisÆo Dep¢sito"
        field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
        field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
        field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
        field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
        field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
        field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
        field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
        field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
        field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu‡Æo" column-label "Motivo Devolu‡Æo"
        field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
        field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
        field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
        field tta_log_pend_cheq_acr            as logical format "Sim/NÆo" initial no label "Cheque Pendente" column-label "Cheque Pendente"
        field tta_log_cheq_terc                as logical format "Sim/NÆo" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
        field tta_log_cheq_acr_renegoc         as logical format "Sim/NÆo" initial no label "Cheque Reneg" column-label "Cheque Reneg"
        field tta_log_cheq_acr_devolv          as logical format "Sim/NÆo" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
        field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
        field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
        index tt_id                            is primary unique
              tta_cod_banco                    ascending
              tta_cod_agenc_bcia               ascending
              tta_cod_cta_corren               ascending
              tta_num_cheque                   ascending
        .

    def temp-table tt_integr_acr_liquidac_impto_2 no-undo
        field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
        field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
        field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
        field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
        field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
        field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
        field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
        field tta_val_retid_indic_impto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE Imposto" column-label "Vl Retido IE Imposto"
        field tta_val_retid_indic_tit_acr      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE T¡tulo" column-label "Vl Retido IE T¡tulo"
        field tta_val_retid_indic_pagto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Retido Indicador Pag" column-label "Retido Indicador Pag"
        field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
        field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
        field tta_dat_cotac_indic_econ_pagto   as date format "99/99/9999" initial ? label "Dat Cotac IE Pagto" column-label "Dat Cotac IE Pagto"
        field tta_val_cotac_indic_econ_pagto   as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Val Cotac IE Pagto" column-label "Val Cotac IE Pagto"
        field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
        field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
        field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
        field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
        field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
        field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
        field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
        field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
        field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
        field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
        field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
        field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
        .

    def temp-table tt_integr_acr_liquidac_lote no-undo
        field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
        field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
        field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
        field tta_cod_usuario                  as character format "x(12)" label "Usu rio" column-label "Usu rio"
        field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
        field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
        field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
        field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
        field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Gera‡Æo" column-label "Data Gera‡Æo"
        field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
        field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto"
        field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia"
        field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao"
        field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digita‡Æo" label "Situa‡Æo" column-label "Situa‡Æo"
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
        field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
        field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
        field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
        field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
        field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria‡Æo" column-label "Tipo Apropria‡Æo"
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
        field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
        field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
        field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
        field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
        field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
        field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
        field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
        field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
        field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
        field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
        field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
        field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
        field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
        field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data Cr‚dito" column-label "Data Cr‚dito"
        field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
        field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquida‡Æo" column-label "Liquida‡Æo"
        field tta_cod_autoriz_bco              as character format "x(8)" label "Autoriza‡Æo Bco" column-label "Autorizacao Bco"
        field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
        field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida‡Æo" column-label "Vl Liquida‡Æo"
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
        field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
        field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situa‡Æo Item Lote" column-label "Situa‡Æo Item Lote"
        field tta_log_gera_avdeb               as logical format "Sim/NÆo" initial no label "Gera Aviso D‚bito" column-label "Gera Aviso D‚bito"
        field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso D‚bito" column-label "Moeda Aviso D‚bito"
        field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
        field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
        field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
        field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
        field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso D‚bito" column-label "Aviso D‚bito"
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
        field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
        field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
        field tta_log_retenc_impto_liq         as logical format "Sim/NÆo" initial no label "Ret‚m na Liquida‡Æo" column-label "Ret na Liq"
        field tta_val_retenc_pis               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor PIS" column-label "PIS"
        field tta_val_retenc_cofins            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor COFINS" column-label "COFINS"
        field tta_val_retenc_csll              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CSLL" column-label "CSLL"
        index tt_rec_index                    
              ttv_rec_lote_liquidac_acr        ascending
        .

    def temp-table tt_integr_acr_rel_pend_cheq no-undo
        field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
        field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
        field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
        field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
        field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
        field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
        field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal rio" column-label "Banco Cheque Sal rio"
        .

    def temp-table tt_log_erros_import_liquidac no-undo
        field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
        field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
        field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
        field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
        field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
        field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
        field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
        field ttv_nom_abrev_clien              as character format "x(12)" label "Cliente" column-label "Cliente"
        field ttv_num_erro_log                 as integer format ">>>>,>>9" label "N£mero Erro" column-label "N£mero Erro"
        field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
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
        FIELD LOG_an_gerada         AS LOG FORMAT "Sim/NÆo" INITIAL NO.

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
        FIELD LOG_an_gerada         AS LOG FORMAT "Sim/NÆo" INITIAL NO
      INDEX tt_concil
            dat_transacao           ASCENDING
            cod_resumo              ASCENDING
            cod_nsu                 ASCENDING
            num_ped_EMS             ASCENDING.




define temp-table tt-param no-undo
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR format "x(35)"
    FIELD usuario      AS CHAR format "x(12)"
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD cod-estab    AS CHAR
    FIELD cod-portador AS CHAR
    FIELD cod-carteira AS CHAR 
    FIELD dt-trans     AS DATE
    FIELD arquivo-imp  AS CHAR.

define temp-table tt-digita 
    FIELD canal-central AS INTEGER .


def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/*************** PAR¶METROS ***************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.


DEF VAR h-acomp AS HANDLE NO-UNDO.
IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      

DEF TEMP-TABLE tt-arquivo
    FIELD Linha           AS INTEGER
    FIELD r-titulo        AS ROWID
    FIELD cod_estab       AS CHAR 
    FIELD cod_espec_docto AS CHAR
    FIELD cod_ser_docto   AS CHAR
    FIELD cod_tit_acr     AS CHAR
    FIELD cod_parcela     AS CHAR
    FIELD vl-liquidacao   AS DEC
    FIELD vl-INSS        AS DEC
    FIELD vl-PIS        AS DEC
    FIELD vl-COFINS        AS DEC
    FIELD vl-CSLL        AS DEC
    FIELD vl-ISS        AS DEC.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-freeac.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{include/tt-edit.i}
{include/pi-edit.i}
{utp/ut-glob.i}

/* bloco principal do programa */
ASSIGN c-programa     = "esesb013"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Contas … Receber"
       c-titulo-relat = "Automatiza‡Æo baixa de t¡tulos/reten‡äes de impostos operadoras".

/*-------------------*/
/*   F U N € å E S   */
/*-------------------*/


/*------------------------------------------------------*/
/*    I N Ö C I O  -   B L O C O   P R I N C I P A L    */
/*------------------------------------------------------*/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Apura‡Æo").
    
DEF VAR c-labels       AS CHAR FORMAT "X(300)" NO-UNDO.
DEF VAR c-conta-INSS   AS CHAR NO-UNDO. 
DEF VAR c-conta-PIS    AS CHAR NO-UNDO.
DEF VAR c-conta-COFINS AS CHAR NO-UNDO.
DEF VAR c-conta-CSLL   AS CHAR NO-UNDO.
DEF VAR c-conta-ISS    AS CHAR NO-UNDO.
DEFINE VARIABLE c-des-dat          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-num-aux          AS INTEGER     NO-UNDO.

DEF STREAM exp-saida.

/* Essa ‚ a PROCEDURE PRINCIPAL do programa, a qual contro a transa‡Æo */                                                                                                                                                                     
RUN PI-PRINCIPAL.                                                                                                                                                                                                                             

/* Retornou erro */
IF  CAN-FIND (FIRST tt-erro) OR RETURN-VALUE <> "OK" THEN DO:
    PUT "Erro       Mensagem" SKIP
        "---------- -------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    FOR EACH tt-erro:
        PUT tt-erro.codigo TO 10
            tt-erro.mensagem  AT 12 SKIP
            tt-erro.ajuda AT 12 SKIP(1).
    END.

    PUT SKIP(3)"    ATEN€ÇO: NÆo foi poss¡vel concluir a importa‡Æo. Entre em contato com a TIC Intelbras.".
END.
ELSE 
    DISP SKIP(2) "    Importa‡Æo conclu¡da com sucesso!".



{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             


PROCEDURE PI-PRINCIPAL:

    RUN pi-inicializar IN h-acomp ("Processando").
    RUN pi-acompanhar IN h-acomp ("Importanto dados do arquivo").

    RUN pi-importa-arquivo.
    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".
 
    RETURN "OK".

END.

PROCEDURE pi-importa-arquivo:

    DEF VAR c-Linha     AS CHAR FORMAT "X(100)".
    DEF VAR i           AS INTEGER INIT 1 NO-UNDO.
    DEF VAR c-canal     AS INT NO-UNDO.
    DEF VAR c-item      AS CHAR NO-UNDO.
    DEF VAR c-unidade   AS CHAR.
    DEF VAR de-valor    AS DEC.
    DEF VAR l-ok        AS LOG INIT NO NO-UNDO.

    INPUT FROM value(tt-param.arquivo-imp).
    
    REPEAT:
        IMPORT UNFORMATTED c-Linha.

        RUN pi-acompanhar IN h-acomp ("Linha: " + STRING(i)).
        
        /* Linha 0 cont‚m as contas cont beis das reten‡äes */
        IF  i = 1 THEN 
            ASSIGN c-conta-INSS   = entry(07, c-Linha, ";")
                   c-conta-PIS    = entry(08, c-Linha, ";")
                   c-conta-COFINS = entry(09, c-Linha, ";")
                   c-conta-CSLL   = entry(10, c-Linha, ";")
                   c-conta-ISS    = entry(11, c-Linha, ";").

        /* Linha 1 contem os labels das colunas */
        IF  i > 2 THEN DO:
        
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.cod_estab       =     entry(01, c-Linha, ";")
                   tt-arquivo.cod_espec_docto =     entry(02, c-Linha, ";")
                   tt-arquivo.cod_ser_docto   =     entry(03, c-Linha, ";")
                   tt-arquivo.cod_tit_acr     =     entry(04, c-Linha, ";")
                   tt-arquivo.cod_parcela     =     entry(05, c-Linha, ";")
                   tt-arquivo.vl-liquidacao   = dec(entry(06, c-Linha, ";"))
                   tt-arquivo.vl-INSS         = DEC(entry(07, c-Linha, ";"))
                   tt-arquivo.vl-PIS          = DEC(entry(08, c-Linha, ";")) 
                   tt-arquivo.vl-COFINS       = DEC(entry(09, c-Linha, ";")) 
                   tt-arquivo.vl-CSLL         = DEC(entry(10, c-Linha, ";"))
                   tt-arquivo.vl-ISS          = DEC(entry(11, c-Linha, ";"))
                   tt-arquivo.Linha           = i.

        END.

        ASSIGN i = i + 1.
    
        IF  c-Linha = "" THEN
            LEAVE.

    END.

    RUN pi-acompanhar IN h-acomp ("Validando dados do arquivo").
    RUN pi-valida-arquivo (OUTPUT l-ok).

    IF  CAN-FIND (FIRST tt-erro) 
    OR  NOT l-ok THEN
        RETURN "NOK".

    /* INÖCIO TRANSA€ÇO */
    blk-principal:
    DO TRANSACTION
    ON ERROR UNDO blk-principal, LEAVE blk-principal
    ON STOP  UNDO blk-principal, LEAVE blk-principal:

        /*  L O T E   D E   L I Q U I D A € Ç O  */
        RUN pi-acompanhar IN h-acomp ("Gerando liquida‡Æo...").
        RUN pi-liquidacao .
        IF  RETURN-VALUE <> "OK"
        OR  NOT l-ok THEN DO:
            UNDO blk-principal, RETURN "NOK".
        END.
        
        /*  A L T E R A   O   T Ö T U L O  */
        RUN pi-acompanhar IN h-acomp ("Gerando AVA para os t¡tulos...").
        RUN pi-gera-ava-titulo (OUTPUT l-ok).
        IF  RETURN-VALUE <> "OK"
        OR  NOT l-ok THEN DO:
            UNDO blk-principal, RETURN "NOK".
        END.

    END.

    ASSIGN l-ok = YES.
    RETURN "OK".
    
END.

PROCEDURE pi-liquidacao:

    
    
    DEF VAR v_hld_handle AS HANDLE NO-UNDO.
    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    /* ** Gera Referˆncia V lida ***/
    REPEAT WHILE NOT v_log_refer_uni:
        RUN pi_retorna_sugestao_referencia (INPUT "B",
                                            INPUT TODAY,
                                            OUTPUT v_cod_refer).
    
        /* --- Verifica Referˆncia énica ---*/
        RUN pi_verifica_refer_unica_acr (INPUT tit_acr.cod_estab,
                                         INPUT v_cod_refer,
                                         INPUT "lote_liquidac_acr",
                                         INPUT ?,
                                         OUTPUT v_log_refer_uni).
    END.
    
    EMPTY TEMP-TABLE tt_integr_acr_liquidac_lote.
    EMPTY TEMP-TABLE tt_integr_acr_liq_item_lote_3.
    EMPTY TEMP-TABLE tt_integr_acr_abat_antecip.
    EMPTY TEMP-TABLE tt_integr_acr_abat_prev.
    EMPTY TEMP-TABLE tt_integr_acr_cheq.
    EMPTY TEMP-TABLE tt_integr_acr_liquidac_impto_2.
    EMPTY TEMP-TABLE tt_integr_acr_rel_pend_cheq.
    EMPTY TEMP-TABLE tt_integr_acr_liq_aprop_ctbl.
    EMPTY TEMP-TABLE tt_integr_acr_liq_desp_rec.
    EMPTY TEMP-TABLE tt_integr_acr_aprop_liq_antec.
    EMPTY TEMP-TABLE tt_log_erros_import_liquidac.
    EMPTY TEMP-TABLE tt_integr_cambio_ems5.

    CREATE tt_integr_acr_liquidac_lote.
    ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = v_cod_empres_usuar
           tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = tt-param.cod-estab
           tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren
           tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = tt-param.dt-trans
           tt_integr_acr_liquidac_lote.tta_dat_transacao               = tt-param.dt-trans
           tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
           tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digita‡Æo"
           tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO    
           tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES
           tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO 
           tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
           tt_integr_acr_liquidac_lote.tta_cod_refer                   = v_cod_refer.

    FOR EACH tt-arquivo:
    
        FIND tit_acr NO-LOCK
             WHERE ROWID(tit_acr) = tt-arquivo.r-titulo NO-ERROR.
    
        CREATE tt_integr_acr_liq_item_lote_3.
        ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr.cod_empresa
               tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr.cod_estab
               tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr.cod_espec_docto
               tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
               tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
               tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr.cod_parcela
               tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr.cdn_cliente
               tt_integr_acr_liq_item_lote_3.tta_cod_portador               = /*tit_acr.cod_portador */  tt-param.cod-portador 
               tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = /*tit_acr.cod_cart_bcia*/ tt-param.cod-carteira 
               tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
               tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
               tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
               tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tt-arquivo.vl-liquidacao
               tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = tt-param.dt-trans
               tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = tt-param.dt-trans
               tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = tt-param.dt-trans
               tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = no
               tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = no
               tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
               tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = no
               tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
               tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Compostos"
               tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
               tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = recid(tt_integr_acr_liq_item_lote_3).

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
        MESSAGE tt_log_erros_import_liquidac.ttv_des_msg_erro
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RUN pi-cria-erro ("17006",
                          tt_log_erros_import_liquidac.ttv_num_erro_log,
                          tt_log_erros_import_liquidac.ttv_des_msg_erro ).
    END.
    
    RETURN "OK".
END.

PROCEDURE pi-valida-arquivo:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
    DEF VAR de-tot-valores AS DEC NO-UNDO.

    IF  NOT CAN-FIND(FIRST tt-arquivo) THEN DO:
        RUN pi-cria-erro ("17006",
                          "Arquivo inv lido.",
                          "Verifique se o arquivo ‚ o correto ou talvez esteja vazio.").
        RETURN "NOK".
    END.
    
    /*********************************/
    /*Validar cada Linha do arquivo. */
    /*********************************/
    FOR EACH tt-arquivo:

        FIND tit_acr NO-LOCK
            WHERE tit_acr.cod_estab        = tt-arquivo.cod_estab      
              AND tit_acr.cod_espec_docto  = tt-arquivo.cod_espec_docto
              AND tit_acr.cod_ser_docto    = tt-arquivo.cod_ser_docto  
              AND tit_acr.cod_tit_acr      = tt-arquivo.cod_tit_acr    
              AND tit_acr.cod_parcela      = tt-arquivo.cod_parcela  NO-ERROR.

        IF  NOT AVAIL tit_acr THEN
            RUN pi-cria-erro ("17006",
                              "T¡tulo inexistente",
                              "Linha.....: " + string(tt-arquivo.Linha)                + chr(10) + 
                              "           Estabelec.: " + tt-arquivo.cod_estab         + chr(10) + 
                              "           Esp‚cie...: " + tt-arquivo.cod_espec_docto   + chr(10) + 
                              "           S‚rie.....: " + tt-arquivo.cod_ser_docto     + chr(10) + 
                              "           Nr T¡tulo.: " + tt-arquivo.cod_tit_acr       + chr(10) + 
                              "           Parcela...: " + tt-arquivo.cod_parcela).
           
        IF  tt-arquivo.vl-liquidacao < 0 THEN
            RUN pi-cria-erro ("17006",
                              "Valor da Liquida‡Æo deve ser maior que zero.",
                              "Linha.....: " + string(tt-arquivo.Linha)                + chr(10) + 
                              "           Estabelec.: " + tt-arquivo.cod_estab         + chr(10) + 
                              "           Esp‚cie...: " + tt-arquivo.cod_espec_docto   + chr(10) + 
                              "           S‚rie.....: " + tt-arquivo.cod_ser_docto     + chr(10) + 
                              "           Nr T¡tulo.: " + tt-arquivo.cod_tit_acr       + chr(10) + 
                              "           Parcela...: " + tt-arquivo.cod_parcela).

        IF  AVAIL tit_acr THEN DO:
            ASSIGN tt-arquivo.r-titulo = ROWID(tit_acr).
            ASSIGN de-tot-valores = tt-arquivo.vl-liquidacao +
                                    tt-arquivo.vl-INSS       +
                                    tt-arquivo.vl-PIS        +
                                    tt-arquivo.vl-COFINS     +
                                    tt-arquivo.vl-CSLL       +
                                    tt-arquivo.vl-ISS.

            IF  tit_acr.val_sdo_tit_acr < de-tot-valores THEN
                RUN pi-cria-erro ("17006",
                                  "Saldo do t¡tulo ‚ insuficiente",
                                  "Linha.............: " + string(tt-arquivo.Linha)                                     + chr(10) + 
                                  "           Estabelec.........: " + tt-arquivo.cod_estab                              + chr(10) + 
                                  "           Esp‚cie...........: " + tt-arquivo.cod_espec_docto                        + chr(10) + 
                                  "           S‚rie.............: " + tt-arquivo.cod_ser_docto                          + chr(10) + 
                                  "           Nr T¡tulo.........: " + tt-arquivo.cod_tit_acr                            + chr(10) + 
                                  "           Parcela...........: " + tt-arquivo.cod_parcela                            + CHR(10) + CHR(10) +
                                  "           Saldo T¡tulo Atual: " + string(tit_acr.val_sdo_tit_acr, ">>>,>>>,>>9.99") + CHR(10) + 
                                  "           Valor a abater....: " + string(de-tot-valores         , ">>>,>>>,>>9.99") ).

        END.


    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-gera-ava-titulo:

    DEFINE OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEFINE VARIABLE l-erro      AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE c-cod-refer AS CHAR     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER  NO-UNDO.
    DEFINE VARIABLE de-vl-total AS DEC      NO-UNDO.

    EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
    EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.

    FOR EACH tt-arquivo:

        FIND tit_acr NO-LOCK
            WHERE rowid(tit_acr) = tt-arquivo.r-titulo NO-ERROR.
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp(INPUT "Gerando AVA...." + STRING(c-cod-refer)).

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).
        ASSIGN i-cont = 0.
        /* INSS - Coluna G */
        IF  tt-arquivo.vl-INSS > 0 THEN DO:
            i-cont = i-cont + 10.
            RUN pi-gera-rateio (INPUT c-cod-refer,
                                INPUT i-cont,
                                INPUT c-conta-INSS,
                                INPUT tt-arquivo.vl-INSS).
        END.
        /* PIS - Coluna H */
        IF  tt-arquivo.vl-PIS > 0 THEN DO:
            i-cont = i-cont + 10.
            RUN pi-gera-rateio (INPUT c-cod-refer,
                                INPUT i-cont,
                                INPUT c-conta-PIS,
                                INPUT tt-arquivo.vl-PIS).
        END.
        /* COFINS - Coluna I */
        IF  tt-arquivo.vl-COFINS > 0 THEN DO:
            i-cont = i-cont + 10.
            RUN pi-gera-rateio (INPUT c-cod-refer,
                                INPUT i-cont,
                                INPUT c-conta-COFINS,
                                INPUT tt-arquivo.vl-COFINS).
        END.
        /* CSLL - Coluna J */
        IF  tt-arquivo.vl-CSLL > 0 THEN DO:
            i-cont = i-cont + 10.
            RUN pi-gera-rateio (INPUT c-cod-refer,
                                INPUT i-cont,
                                INPUT c-conta-CSLL,
                                INPUT tt-arquivo.vl-CSLL).
        END.
        /* ISS - Coluna K */
        IF  tt-arquivo.vl-ISS > 0 THEN DO:
            i-cont = i-cont + 10.
            RUN pi-gera-rateio (INPUT c-cod-refer,
                                INPUT i-cont,
                                INPUT c-conta-ISS,
                                INPUT tt-arquivo.vl-ISS).
        END.
        
        ASSIGN de-vl-total = tt-arquivo.vl-INSS + tt-arquivo.vl-PIS + tt-arquivo.vl-COFINS + tt-arquivo.vl-CSLL + tt-arquivo.vl-ISS.
                             

        CREATE tt_alter_tit_acr_base_2.
        ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab
               tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_base_2.tta_dat_transacao               = tt-param.dt-trans
               tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
               tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = tit_acr.val_sdo_tit_acr - de-vl-total 
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ""
               tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Liquida‡Æo"
               tt_alter_tit_acr_base_2.tta_cod_portador                = tit_acr.cod_portador 
               tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = tit_acr.cod_cart_bcia
               tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
               tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
               tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
               tt_alter_tit_acr_base_2.tta_dat_emis_docto              = 01/01/0001
               tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = 01/01/0001
               tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = 01/01/0001
               tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = 01/01/0001
               tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
               tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
               tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?  
               tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = 01/01/0001
               tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
               tt_alter_tit_acr_base_2.tta_dat_desconto                = 01/01/0001
               tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
               tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
               tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
               tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
               tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
               tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
               tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
               tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Hist¢rico"
               tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = "NORMAL"
               tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
               tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
               tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?.
    
    END.


    RUN prgfin/acr/acr711zo.py (INPUT  4,
                                INPUT  TABLE tt_alter_tit_acr_base_2,
                                INPUT  TABLE tt_alter_tit_acr_rateio,
                                INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                INPUT  TABLE tt_alter_tit_acr_comis,
                                INPUT  TABLE tt_alter_tit_acr_cheq,
                                INPUT  TABLE tt_alter_tit_acr_iva,
                                INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                INPUT  NO).

    ASSIGN l-erro = NO.
    FOR EACH tt_log_erros_alter_tit_acr:
        RUN pi-cria-erro ("17006",
                          "Estab: " + tt_log_erros_alter_tit_acr.tta_cod_estab + " ID T¡tulo: " + STRING(tt_log_erros_alter_tit_acr.tta_num_id_tit_acr),
                          tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda).
        ASSIGN l-erro = YES.
    END.

    IF  l-erro THEN
        RETURN "NOK":U.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.


PROCEDURE pi-gera-rateio:
    DEF INPUT PARAM P-COD-REFER AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-seq-refer AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-conta     AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-valor     AS DEC     NO-UNDO.

    CREATE tt_alter_tit_acr_rateio.
    ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
           tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
           tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Altera‡Æo"
           tt_alter_tit_acr_rateio.tta_cod_refer                   = P-COD-REFER
           tt_alter_tit_acr_rateio.tta_num_seq_refer               = p-seq-refer
           tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao"
           tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = p-conta
           tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = p-seq-refer
           tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = p-valor.

END.


PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

PROCEDURE pi-gera-referencia:
    
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER                  NO-UNDO.
    
    DEF VAR i-cont AS INTEGER NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.
    
    /* Gera o c¢digo da referˆncia */
    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.


    /* Verifica se a referˆncia ‚ £nica */
    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).


    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-refer-unica-acr:
    /************************ Parameter Definition Begin ************************/
    DEF INPUT  PARAM p_cod_estab     AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOGICAL   FORMAT "Sim/NÆo" NO-UNDO.
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/
    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.
    /*************************** Buffer Definition End **************************/

    ASSIGN p_log_refer_uni = YES.

    IF  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  THEN DO:
        FIND FIRST b_lote_impl_tit_acr NO-LOCK
             WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
               AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
               AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
             USE-INDEX ltmplttc_id NO-ERROR.
        IF  AVAIL b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  THEN DO:
        FIND FIRST b_lote_liquidac_acr NO-LOCK
             WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
               AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
             USE-INDEX ltlqdccr_id NO-ERROR.
        IF  AVAIL b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "Opera‡Æo financeira" /*l_operacao_financ*/  THEN DO:
        FIND FIRST b_operac_financ_acr NO-LOCK
             WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
               AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               AND RECID( b_operac_financ_acr )               <> p_rec_tabela
             USE-INDEX oprcfnna_id NO-ERROR.
        IF  AVAIL b_operac_financ_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table = 'cobr_especial_acr' THEN DO:
        FIND FIRST b_cobr_especial_acr NO-LOCK
             WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
               AND b_cobr_especial_acr.cod_refer = p_cod_refer
               AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
             USE-INDEX cbrspclc_id NO-ERROR.
        IF  AVAIL b_cobr_especial_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer
            AND   RECID(b_renegoc_acr)   <> p_rec_tabela
            NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                   AND RECID(b_movto_tit_acr)   <> p_rec_tabela
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.
    END.

END PROCEDURE.

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
        format "Sim/NÆo"
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

    if  p_cod_table <> "Opera‡Æo financeira" /*l_operacao_financ*/  then do:
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
