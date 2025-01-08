/*****************************************************************************
** Descricao.............: Importaá∆o - PINHO
** Versao................:  5.00.00.000
** Nome Externo..........: esp/apb/esapb021rp.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 01/03/2010
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

/***************************** Define Temp-Table ****************************/

{esp/es0018.i}

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE tt_an_pef NO-UNDO
    FIELD tta_cod_tip_tit   AS CHAR
    FIELD tta_cod_tit_ap    AS CHAR
    FIELD tta_cod_parcela   AS CHAR
    FIELD tta_cod_refer     AS CHAR
    FIELD tta_val_tit_ap    AS DEC
    FIELD tta_cod_histor    AS CHAR
    INDEX tt_an_pef_id      IS PRIMARY 
          tta_cod_tip_tit   ascending
          tta_cod_tit_ap    ascending
          tta_cod_parcela   ascending.

/*************************************** definiá∆o das temp-tables AN/PEF ****************************/
DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.

def temp-table tt_integr_apb_antecip_pef_p1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon†rio Cheques" column-label "Talon†rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo" column-label "Valor T°tulo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Referància" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Cont†bil" column-label "Natureza Cont†bil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_ind_tip_cod_barra            as character format "X(01)"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T°tulo Banco Cobdor" column-label "T°tulo Banco Cobdor"
    index tt_antcppfp_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_antcppfp_tip_refer           
          tta_cod_empresa                  ascending
          tta_ind_tip_refer                ascending
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_recid                        
          ttv_rec_antecip_pef_pend         ascending.

def temp-table tt_integr_apb_antecip_pef_p2 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon†rio Cheques" column-label "Talon†rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo" column-label "Valor T°tulo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Referància" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Cont†bil" column-label "Natureza Cont†bil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_ind_tip_cod_barra            as character format "X(01)"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T°tulo Banco Cobdor" column-label "T°tulo Banco Cobdor"
    FIELD tta_ind_modo_pagto               as CHARACTER format "X(10)" label "Modo Pagto"          column-label "Modo Pagto"
    FIELD tta_cod_forma_pagto              as CHARACTER format "X(03)" label "Forma Pagto"          column-label "Forma Pagto"    
    index tt_antcppfp_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_antcppfp_tip_refer           
          tta_cod_empresa                  ascending
          tta_ind_tip_refer                ascending
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_recid                        
          ttv_rec_antecip_pef_pend         ascending.

def temp-table tt_integr_apb_abat_prev_provis no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp≤cie Documento" column-label "Esp≤cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S≤rie Documento" column-label "S≤rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T≠tulo" column-label "T≠tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_prev          is unique
          ttv_rec_antecip_pef_pend         ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_integr_apb_abat_prev_provis   is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

def temp-table tt_integr_apb_impto_impl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa≠s" column-label "Pa≠s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaªío" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp≤cie Documento" column-label "Esp≤cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S≤rie Documento" column-label "S≤rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T≠tulo" column-label "T≠tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduªío Inss" column-label "Deduªío Inss"
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduªío Dependentes" column-label "Deduªío Dependentes"
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao Pensío" column-label "Deducao Pensío"
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras DeduªÑes" column-label "Outras DeduªÑes"
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L≠quida Imposto" column-label "Base L≠quida Imposto"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al≠quota" column-label "Aliq"
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    field tta_des_text_histor              as character format "x(2000)" label "HistΩrico" column-label "HistΩrico"
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Deduªío"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa≠s Externo" column-label "Pa≠s Externo"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    index tt_impto_impl_pend_ap_integr     is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
    index tt_impto_impl_pend_ap_integr_ant is unique
          ttv_rec_antecip_pef_pend         ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending.

def temp-table tt_integr_apb_aprop_ctbl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field ttv_rec_integr_apb_impto_pend    as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid NegΩcio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_cod_pais                     as character format "x(3)" label "Pa≠s" column-label "Pa≠s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaªío" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid NegΩcio Externa" column-label "Unid NegΩcio Externa"
    index tt_aprop_ctbl_pend_ap_integr_ant
          ttv_rec_antecip_pef_pend         ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
    index tt_aprop_ctbl_pend_ap_integr_id 
          ttv_rec_integr_apb_item_lote     ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending.

def temp-table tt_log_erros_atualiz_an no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Referºncia" column-label "Referºncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequºncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Número" column-label "Número Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia" 
    field ttv_des_msg_ajuda                as character format "x(200)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento" . 

def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_ord_compra_tit_ap_pend_1 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_ord_compra               as character format "x(8)" label "Ordem Compra" column-label "Ordem Compra"
    field tta_val_perc_ord_compra          as decimal format ">>9.99" decimals 2 initial 0 label "Perc Ordem Compra" column-label "Perc Ordem Compra"
    field tta_val_origin_ord_compra        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ordem Compr" column-label "Original Ordem Compr"
    field tta_val_sdo_ord_compra           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Ordem Compra" column-label "Saldo Ordem Compra"
    index tt_codigo                        is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_ord_compra               ascending.

/*************************************** definiá∆o das temp-tables pagamento ****************************/
/*
def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
    .
*/
def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    .

def temp-table tt_exec_rpc no-undo
    field ttv_cod_aplicat_dtsul_corren     as character format "x(3)"
    field ttv_cod_ccusto_corren            as character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_dwb_user                 as character format "x(21)" label "Usu†rio" column-label "Usu†rio"
    field ttv_cod_empres_usuar             as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_usuar              as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_funcao_negoc_empres      as character format "x(50)"
    field ttv_cod_grp_usuar_lst            as character format "x(3)" label "Grupo Usu†rios" column-label "Grupo"
    field ttv_cod_idiom_usuar              as character format "x(8)" label "Idioma" column-label "Idioma"
    field ttv_cod_modul_dtsul_corren       as character format "x(3)" label "M¢dulo Corrente" column-label "M¢dulo Corrente"
    field ttv_cod_modul_dtsul_empres       as character format "x(100)"
    field ttv_cod_pais_empres_usuar        as character format "x(3)" label "Pa°s Empresa Usu†rio" column-label "Pa°s"
    field ttv_cod_plano_ccusto_corren      as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_unid_negoc_usuar         as character format "x(3)" label "Unidade Neg¢cio" column-label "Unid Neg¢cio"
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field ttv_cod_usuar_corren_criptog     as character format "x(16)"
    field ttv_num_ped_exec_corren          as integer format ">>>>9"
    field ttv_cod_livre                    as character format "x(2000)"
    .

def temp-table tt_integr_apb_abat_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    .

def temp-table tt_integr_apb_abat_antecip_vouc no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_antecip_vouc  is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_apb_abat_prev no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    .

def temp-table tt_integr_apb_bord_lote_pagto no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_bord_refer         as character format "x(8)"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_refer_antecip_pef        as character format "x(10)" label "Ref Antec PEF Pend" column-label "Ref Antec PEF Pend"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_pagto                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagamento" column-label "Valor Pagto"
    field tta_val_multa_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_ap                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Correá∆o Monet" column-label "Val Corr Monet"
    field tta_val_desc_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Vl Desconto"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_forma_pagto_altern       as character format "x(3)" label "Forma Pagamento" column-label "F Pagto Alt"
    field tta_val_pagto_inic               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagto Inic" column-label "Vl Pagto Inic"
    field tta_val_desc_tit_ap_inic         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Inic" column-label "Vl Desc Inic"
    field tta_val_pagto_orig_inic          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagto Orig Inic" column-label "Vl Pagto Orig Inic"
    field tta_val_desc_tit_ap_orig_inic    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Orig Descto" column-label "Vl orig Descto"
    field tta_cod_docto_bco_pagto          as character format "x(20)" label "Tit Bco Pagto" column-label "Tit Bco Pagto"
    field tta_ind_sit_item_bord_ap         as character format "X(9)" label "Situaá∆o" column-label "Situaá∆o"
    field tta_log_critic_atualiz_ok        as logical format "Sim/N∆o" initial no label "Cr°tica OK" column-label "Cr°tica OK"
    field tta_cod_estab_cheq               as character format "x(3)" label "Estabelec Cheque" column-label "Estabelec Cheque"
    field tta_num_seq_item_cheq            as integer format ">>>9" initial 0 label "Sequància Item Cheq" column-label "Seq"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon†rio Cheques" column-label "Talon†rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_ind_sit_item_lote_bxa_ap     as character format "X(9)" initial "Gerado" label "Situaá∆o" column-label "Situaá∆o"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field ttv_ind_forma_pagto              as character format "X(18)" initial "Assume do T°tulo"
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending
    .

def temp-table tt_integr_apb_pagto no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_estab_bord               as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_tot_lote_pagto_efetd     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Pagamento" column-label "Total Pagamento"
    field tta_val_tot_lote_pagto_infor     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_usuar_pagto              as character format "x(12)" label "Usuar Pagamento" column-label "Usu†rio Pagto"
    field tta_log_enctro_cta               as logical format "Sim/N∆o" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_val_tot_liquidac_tit_acr     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Liquidaá∆o" column-label "Total Liquidaá∆o"
    field tta_num_bord_ap                  as integer format ">>>>>9" initial 0 label "N£mero Borderì" column-label "Borderì"
    field tta_cod_msg_inic                 as character format "x(2)" label "Mensagem In°cio" column-label "Msg Fim"
    field tta_cod_msg_fim                  as character format "x(2)" label "Mensagem Fim" column-label "Msg Fim"
    field tta_log_bord_ap_escrit           as logical format "Sim/N∆o" initial no label "Bordero Escritural" column-label "Escritural"
    field tta_log_bord_ap_escrit_envdo     as logical format "Sim/N∆o" initial no label "Enviado" column-label "Enviado"
    field tta_ind_tip_bord_ap              as character format "X(17)" initial "Normal" label "Tipo Borderì" column-label "Tipo Borderì"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
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
    field ttv_log_atualiz_refer            as logical format "Sim/N∆o" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/N∆o" initial no
    field ttv_ind_tip_atualiz              as character format "X(08)"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
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

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
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

def temp-table tt_pessoa_jurid_matriz no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    .

def temp-table tt_xml_input_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_xml_output_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_xml_output_2 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_relac_erro no-undo
    field tta_cod_refer                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_num_linha                    as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    index tt_refer                    
          tta_cod_refer                    ascending.

def new shared temp-table tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 

/********************** Temporary Table Definition End **********************/

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD embarque  AS CHARACTER
    FIELD numero    AS CHARACTER
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER
    FIELD processo  AS CHARACTER
    INDEX id_principal AS PRIMARY UNIQUE
        embarque
        descricao.

/* Definiá∆o das Temp-Tables "tt_processo_embarque" e "tt_mensagem" */
{esp/apb/esapb028.i}

/* Variaveis de TT dinamica */
DEFINE VARIABLE bItem              AS HANDLE     NO-UNDO.

DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRetorno           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hListarNovosResult AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCampos AS HANDLE     NO-UNDO.
DEFINE VARIABLE hclsEmbarqueList   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRegistro          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hValor             AS HANDLE     NO-UNDO.

DEFINE VARIABLE iNumRecords        AS INTEGER    NO-UNDO.
DEFINE VARIABLE Cont1              AS INTEGER    NO-UNDO.
DEFINE VARIABLE Cont2              AS INTEGER    NO-UNDO.
DEFINE VARIABLE Cont3              AS INTEGER    NO-UNDO.
DEFINE VARIABLE Cont4              AS INTEGER    NO-UNDO.
DEFINE VARIABLE v_embarque         AS CHARACTER  NO-UNDO.

/************************** Stream Definition Begin *************************/

def stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_tip_reg
    as character
    format "x(03)":U
    label "Tipo Registro"
    column-label "Tipo Registro"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empresa_imp
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_matriz_trad_pais_ext
    as character
    format "x(8)":U
    label "Matriz Traduá∆o Pa°s"
    column-label "Matriz Traduá∆o Pa°s"
    no-undo.
def new global shared var v_cod_matriz_trad_portad_ext
    as character
    format "x(8)":U
    label "Matriz Trad Portador"
    column-label "Matriz Trad Portador"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def var v_des_filespec
    as character
    format "x(10)":U
    extent 10
    no-undo.
def var v_des_mensagem
    as character
    format "x(50)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 50 by 4
    bgcolor 15 font 2
    label "Mensagem"
    column-label "Mensagem"
    no-undo.
def new global shared var v_des_program_estrut
    as character
    format "x(65)":U
    label "Estrutura"
    column-label "Estrutura"
    no-undo.
def var v_des_reg_import
    as character
    format "x(40)":U
    no-undo.
def var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
    no-undo.
def var v_ind_message_output
    as character
    format "X(10)":U
    initial "Em Arquivo" /*l_on_Screen*/
    view-as radio-set Horizontal
    radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo"
    bgcolor 8 
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_eai_habilit
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_historico
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Hist¢rico"
    column-label "Hist¢rico"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_view_file
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Visualiza Arquivo"
    column-label "Visualiza Arquivo"
    no-undo.
def var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_nom_filename
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    no-undo.
def var v_nom_name
    as character
    format "x(20)":U
    extent 10
    no-undo.
def var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_line
    as integer
    format ">>,>>9":U
    label "Linha"
    column-label "Linha"
    no-undo.
def var v_num_page_number
    as integer
    format ">>>>>9":U
    label "P†gina"
    column-label "P†gina"
    no-undo.
def var v_num_seq
    as integer
    format ">>>,>>9":U
    label "SeqÅància"
    column-label "Seq"
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.

def new global shared var v_nom_filename_import
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_estab_imp
    as character
    format "x(03)":U
    VIEW-AS FILL-IN
    size 4 by 1
    bgcolor 15 font 2
    label "Estab"
    column-label "Estab"
    no-undo.
def new global shared var v_num_fatura_imp
    as INT
    FORMAT ">>>>>>>>>9"
    VIEW-AS FILL-IN
    size 11 by 1
    bgcolor 15 font 2
    label "Fatura"
    column-label "Fatura"
    no-undo.
def new global shared var v_dat_fatura_imp
    as DATE
    format "99/99/9999":U
    VIEW-AS FILL-IN
    size 11 by 1
    bgcolor 15 font 2
    label "Data Fatura"
    column-label "Data Fatura"
    no-undo.
def new global shared var v_cod_portador_imp
    as character
    format "x(05)":U
    VIEW-AS FILL-IN
    size 06 by 1
    bgcolor 15 font 2
    label "Portador Borderì"
    column-label "Portador Borderì"
    no-undo.
def new global shared var v_dat_bordero_imp
    as DATE
    format "99/99/9999":U
    VIEW-AS FILL-IN
    size 11 by 1
    bgcolor 15 font 2
    label "Data Borderì"
    column-label "Data Borderì"
    no-undo.
def new global shared var v_val_bordero_imp
    as DEC
    FORMAT ">>>>,>>>,>>9.99"
    VIEW-AS FILL-IN
    size 16.14 by 1
    bgcolor 15 font 2
    label "Valor Borderì"
    column-label "Valor Borderì"
    no-undo.
def new global shared var v_val_outros_imp
    as DEC
    FORMAT ">>>>,>>>,>>9.99"
    VIEW-AS FILL-IN
    size 16.14 by 1
    bgcolor 15 font 2
    label "Valor Outros"
    column-label "Valor Outros"
    no-undo.
def new global shared var v_log_reproces
    as LOG
    FORMAT "Sim/N∆o"
    INITIAL NO
    label "Reprocessamento"
    column-label "Reprocessamento"
    no-undo.
def new global shared var v_num_reproces
    as INT
    INITIAL 1
    no-undo.
def new global shared var v_process
    as INT
    INITIAL 3
    VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "CSV", 1, "XML", 2, "WS", 3
    size 20 by 0.88
    no-undo.
def new global shared var v_remessa
    as INT
    FORMAT ">>>>,>>>,>>9"
    VIEW-AS FILL-IN
    size 16.14 by 0.88
    bgcolor 15 font 2
    label "Remessa"
    column-label "Remessa"
    no-undo.
def new global shared var v_cdn_fornec_esapb021
    as INT
    FORMAT ">>>,>>>,>>9"
    VIEW-AS FILL-IN
    size 16.14 by 0.88
    bgcolor 15 font 2
    label "Fornecedor"
    column-label "Fornecedor"
    no-undo.

/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_messages
    size 1 by 1
    edge-pixels 2.
def rectangle rt_run
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_can2
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1.
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_12x85
    as character
    view-as editor scrollbar-horizontal scrollbar-vertical no-word-wrap
    size 85 by 12
    bgcolor 15 font 2
    no-undo.
def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_ind_message_output
    as character
    initial "Em Arquivo"
    view-as radio-set Horizontal
    radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo"
    bgcolor 8 
    no-undo.
def var rs_ind_run_mode
    as character
    initial "On-Line"
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line","Batch", "Batch"
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 80.
def new shared var v_rpt_s_1_bottom as integer initial 65.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "Logs Importaá∆o SISCOMEX".
def frame f_rpt_s_1_header_period header
    "------------------------------------------------------------" at 1
    "-----" at 61
    "P†gina: " at 67
    (page-number (s_1) + v_rpt_s_1_page) to 80 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 80 format "x(40)" skip
    "--------------------" at 34
    "--------" at 54
    v_dat_execution at 63 format "99/99/9999"
    "-" at 74
    v_hra_execution at 76 format "99:99" skip (1)
    with no-box no-labels width 80 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "------------------------------------------------------------" at 1
    "-----" at 61
    "P†gina: " at 67
    (page-number (s_1) + v_rpt_s_1_page) to 80 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 80 format "x(40)" skip
    "------------------------------------------------------------" at 1
    "-" at 61
    v_dat_execution at 63 format "99/99/9999"
    "-" at 74
    v_hra_execution at 76 format "99:99" skip (1)
    with no-box no-labels width 80 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    skip (1)
    "Èltima p†gina" at 1
    "------------------------------------" at 16
    "-----" at 52
    v_nom_prog_ext at 58 format "x(8)"
    "-" at 67
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    skip (1)
    "------------------------------------------------" at 1
    "---------" at 49
    v_nom_prog_ext at 59 format "x(8)"
    "-" at 68
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    skip (1)
    "P†gina ParÉmetros" at 1
    "---------------------------------------" at 19
    v_nom_prog_ext at 59 format "x(8)"
    "-" at 68
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_grp_logs_lay_unico header
    "Linha" to 19
    "Mensagem" at 21 skip
    "------" to 19
    "--------------------------------------------------" at 21 skip
    with no-box no-labels width 80 page-top stream-io.
def frame f_rpt_s_1_Grp_Logs_Lay_unico header
    "Linha" to 27
    "Mensagem" at 31 skip
    "------" to 27
    "--------------------------------------------------" at 31 skip
    with no-box no-labels width 80 page-top stream-io.


/*************************** Report Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_02_wait_processing
    rt_001
         at row 01.29 col 02.00
    " Processando... " view-as text
         at row 01.00 col 04.00
    ed_1x40
         at row 02.04 col 03.00
         help "" no-label
    bt_can2
         at row 03.50 col 27.86 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 65.72 by 05.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "".
    /* adjust size of objects in this frame */
    assign bt_can2:width-chars  in frame f_dlg_02_wait_processing = 10.00
           bt_can2:height-chars in frame f_dlg_02_wait_processing = 01.00
           rt_001:width-chars   in frame f_dlg_02_wait_processing = 62.43
           rt_001:height-chars  in frame f_dlg_02_wait_processing = 01.92.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_dlg_02_wait_processing = yes.
    /* set private-data for the help system */
    assign ed_1x40:private-data in frame f_dlg_02_wait_processing = "HLP=000023694":U
           bt_can2:private-data in frame f_dlg_02_wait_processing = "HLP=000011451":U
           frame f_dlg_02_wait_processing:private-data            = "HLP=000023694".

def frame f_rnl_31_histor_fornec_importar_ems
    rt_messages
         at row 01.30 col 02.00
    " Mensagens " view-as text
         at row 01.00 col 04.00
    rt_run
         at row 05.18 col 02.00
    " Execuá∆o " view-as text
         at row 04.88 col 04.00
    rt_cxcf
         at row 07.18 col 02.00 bgcolor 7 
    rs_ind_message_output
         at row 01.68 col 03.00
         help "" no-label
    bt_get_file
         at row 02.64 col 43.00 font ?
         help "Pesquisa Arquivo"
    ed_1x40
         at row 02.68 col 03.00
         help "" no-label
    v_log_view_file
         at row 03.80 col 03.00 label "Visualiza Arquivo"
         help "Visualiza Arquivo"
         view-as toggle-box
    rs_ind_run_mode
         at row 05.68 col 03.00
         help "" no-label
    bt_ok
         at row 07.38 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.38 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 56.43 by 09.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Executa Importaá∆o SISCOMEX".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars       in frame f_rnl_31_histor_fornec_importar_ems = 10.00
           bt_can:height-chars      in frame f_rnl_31_histor_fornec_importar_ems = 01.00
           bt_get_file:width-chars  in frame f_rnl_31_histor_fornec_importar_ems = 04.00
           bt_get_file:height-chars in frame f_rnl_31_histor_fornec_importar_ems = 01.08
           bt_ok:width-chars        in frame f_rnl_31_histor_fornec_importar_ems = 10.00
           bt_ok:height-chars       in frame f_rnl_31_histor_fornec_importar_ems = 01.00
           ed_1x40:width-chars      in frame f_rnl_31_histor_fornec_importar_ems = 40.00
           ed_1x40:height-chars     in frame f_rnl_31_histor_fornec_importar_ems = 01.00
           rt_cxcf:width-chars      in frame f_rnl_31_histor_fornec_importar_ems = 52.99
           rt_cxcf:height-chars     in frame f_rnl_31_histor_fornec_importar_ems = 01.42
           rt_messages:width-chars  in frame f_rnl_31_histor_fornec_importar_ems = 53.00
           rt_messages:height-chars in frame f_rnl_31_histor_fornec_importar_ems = 03.50
           rt_run:width-chars       in frame f_rnl_31_histor_fornec_importar_ems = 53.00
           rt_run:height-chars      in frame f_rnl_31_histor_fornec_importar_ems = 01.50.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_rnl_31_histor_fornec_importar_ems = yes.
    /* set private-data for the help system */
    assign rs_ind_message_output:private-data in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000023695":U
           bt_get_file:private-data           in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000008782":U
           ed_1x40:private-data               in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000023695":U
           v_log_view_file:private-data       in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000011183":U
           rs_ind_run_mode:private-data       in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000023695":U
           bt_ok:private-data                 in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000010721":U
           bt_can:private-data                in frame f_rnl_31_histor_fornec_importar_ems = "HLP=000011050":U
           frame f_rnl_31_histor_fornec_importar_ems:private-data                          = "HLP=000023695".



/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_wait_processing
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_prog_dtsul
        as character
        format "x(50)":U
        label "Programa"
        column-label "Programa"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_prog_dtsul = program-name(1).

    if  index(v_cod_prog_dtsul, 'men903za') <> 0
    then do:
        run pi_messages (input 'show',
                         input 4289,
                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.

    if  index(v_cod_prog_dtsul, 'men903za') = 0
    then do:
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.

END.

ON CHOOSE OF bt_can IN FRAME f_rnl_31_histor_fornec_importar_ems
DO:


END.

ON CHOOSE OF bt_get_file IN FRAME f_rnl_31_histor_fornec_importar_ems
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite
        update v_log_answer.

    if  v_log_answer = yes
    then do:
        assign ed_1x40:screen-value in frame f_rnl_31_histor_fornec_importar_ems = v_cod_dwb_file.
    end /* if */.
END.

ON LEAVE OF ed_1x40 IN FRAME f_rnl_31_histor_fornec_importar_ems
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rnl_31_histor_fornec_importar_ems:
        if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
                if  ed_1x40:screen-value <> ""
                then do:
                    assign ed_1x40:screen-value   = replace(ed_1x40:screen-value, '~\', '/')
                           v_cod_filename_initial = entry(num-entries(ed_1x40:screen-value, '/'), ed_1x40:screen-value, '/')
                           v_cod_filename_final   = substring(ed_1x40:screen-value, 1,
                                                              length(ed_1x40:screen-value) - length(v_cod_filename_initial) - 1)
                           file-info:file-name    = v_cod_filename_final.
                    if  file-info:file-type = ?
                    then do:
                         /* O diret¢rio &1 n∆o existe ! */
                         run pi_messages (input "show",
                                          input 4354,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                             v_cod_filename_final)) /*msg_4354*/.
                         return no-apply.
                    end /* if */.
                end /* if */.
            end /* if */.
        end /* if */.
    end /* do block */.

END.

ON VALUE-CHANGED OF rs_ind_message_output IN FRAME f_rnl_31_histor_fornec_importar_ems
DO:

    block:
    do with frame f_rnl_31_histor_fornec_importar_ems:

        if  self:screen-value = "Na Tela" /*l_on_screen*/ 
        then do:
            disable ed_1x40
                    bt_get_file
                    v_log_view_file
                    with frame f_rnl_31_histor_fornec_importar_ems.
        end /* if */.
        else do:
            enable ed_1x40
                   bt_get_file
                   v_log_view_file
                   with frame f_rnl_31_histor_fornec_importar_ems.
        end /* else */.

    end /* do block */.

END.

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON WINDOW-CLOSE OF FRAME f_dlg_02_wait_processing
DO:

    apply "end-error" to self.
END.

ON WINDOW-CLOSE OF FRAME f_rnl_31_histor_fornec_importar_ems
DO:

    apply "end-error" to self.
END.


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

DEFINE VARIABLE v_cdn_fornec   AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_cod_espec    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_ser      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_hdl_apb925za AS HANDLE      NO-UNDO.

def new global shared var v_des_contdo_prog_valid_dtsul
    as character
    format "x(40)":U
    no-undo.

ASSIGN v_des_contdo_prog_valid_dtsul = 'esapb021rp'.

/* tratamento do titulo e vers∆o */
assign frame f_rnl_31_histor_fornec_importar_ems:title = frame f_rnl_31_histor_fornec_importar_ems:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.00.00.000":U)
                            + chr(41).

pause 0 before-hide.
view frame f_rnl_31_histor_fornec_importar_ems.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").

    IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
        ASSIGN c-dir-saida = c-dir-saida + "~\".

END.

ASSIGN ed_1x40 = c-dir-saida + 'esapb021.txt'.

DISP ed_1x40
     v_log_view_file
     rs_ind_message_output
     rs_ind_run_mode
     with frame f_rnl_31_histor_fornec_importar_ems.


enable bt_can
       bt_get_file
       bt_ok
       ed_1x40
       v_log_view_file
       with frame f_rnl_31_histor_fornec_importar_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    wait-for go of frame f_rnl_31_histor_fornec_importar_ems.

    assign input frame f_rnl_31_histor_fornec_importar_ems v_log_view_file.
    assign v_nom_filename = ed_1x40:screen-value
           v_ind_message_output = rs_ind_message_output:screen-value.


    if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ 
    then do:

        run pi_filename_validation (Input v_nom_filename) /*pi_filename_validation*/.
        if  return-value = "NOK" /*l_nok*/ 
        then do:
            /* Nome do arquivo incorreto ! */
            run pi_messages (input "show",
                             input 1064,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
            undo main_block, retry main_block.
        end /* if */.
    end /* if */.

    if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ 
    then do:
        assign v_nom_prog_ext  = caps("esapb021":U)
               v_dat_execution = today
               v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
               v_nom_filename = lc(v_nom_filename).
        output stream s_1 to value(v_nom_filename) paged
               page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
    end.

    run pi_rnl_histor_fornec_importar_ems.

    if  rs_ind_message_output:screen-value = "Em Arquivo"
    then do:
        output stream s_1 close.
        if  v_log_view_file = yes
        then do:
            run pi_show_report_2 (Input v_nom_filename).
        end.
    end.
end.

hide frame f_rnl_31_histor_fornec_importar_ems.

ASSIGN v_des_contdo_prog_valid_dtsul = ''.

/******************************* Main Code End ******************************/

PROCEDURE pi_rnl_histor_fornec_importar_ems:

    DEF VAR v_num_bord      AS INT         NO-UNDO.
    DEF VAR v_log_avail_tit AS LOG INIT NO NO-UNDO.
    DEF VAR v_cod_refer     AS CHAR        NO-UNDO.
    DEF VAR v_log_refer_uni AS LOG INIT NO NO-UNDO.
    DEF VAR v_qtd_emb       AS INTEGER     NO-UNDO.
    DEF VAR v_tot_emb       AS DECIMAL     NO-UNDO.
    DEF VAR v_num_count     AS INT         NO-UNDO.
    DEF VAR v_cod_embarque  AS CHAR        NO-UNDO.
    DEF VAR v_cod_embarque_aux AS CHAR     NO-UNDO.
    DEF VAR v_cod_portador  AS CHAR        NO-UNDO.
    DEF VAR v_qtd_bloco     AS INT         NO-UNDO.
    DEF VAR v_tot_bloco     AS DEC         NO-UNDO.

    ASSIGN v_nom_prog_ext  = CAPS("esapb021":U)
           v_cod_release   = " 5.00.00.000":U
           v_dat_execution = TODAY 
           v_hra_execution = REPLACE(STRING(TIME,"hh:mm:ss"),":","").

    ASSIGN v_nom_enterprise   = 'Intelbras S.A.'.
    HIDE STREAM s_1 FRAME f_rpt_s_1_header_period.
    VIEW STREAM s_1 FRAME f_rpt_s_1_header_unique.
    HIDE STREAM s_1 FRAME f_rpt_s_1_footer_last_page.
    HIDE STREAM s_1 FRAME f_rpt_s_1_footer_param_page.
    VIEW STREAM s_1 FRAME f_rpt_s_1_footer_normal.
    VIEW STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.
    RUN pi_wait_processing (INPUT "Importando arquivo SISCOMEX...",
                            INPUT "Importaá∆o SISCOMEX").

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general') 
           v_num_line = 0.

    /* ** Zarpe - Valores Fixos ***/
    ASSIGN v_cod_ser    = 'U'.

    IF v_process = 1 THEN DO:
        ASSIGN v_cod_espec  = 'AT'
               v_cdn_fornec = v_cdn_fornec_esapb021.

        /* ** Importar CSV ***/
        INPUT FROM VALUE(v_nom_filename_import).

        import_block:
        REPEAT TRANSACTION:
            IMPORT UNFORMATTED v_des_reg_import.

            ASSIGN v_num_line = v_num_line + 1.

            IF NUM-ENTRIES(v_des_reg_import, ";") < 13 THEN
                NEXT.

            IF TRIM(ENTRY(13, v_des_reg_import, ";")) = "TOTAL"
            OR TRIM(ENTRY(13, v_des_reg_import, ";")) = ""     
            OR TRIM(ENTRY(01, v_des_reg_import, ";")) = "" 
               THEN NEXT.

            ASSIGN v_cod_embarque = TRIM(ENTRY(1, v_des_reg_import, ";")).

            FIND tt_an_pef NO-LOCK
                WHERE tt_an_pef.tta_cod_tip_tit = (IF TRIM(ENTRY(6, v_des_reg_import, ";")) BEGINS "Retifica" THEN "PEF" ELSE "AN")
                  AND tt_an_pef.tta_cod_tit_ap  = v_cod_embarque
                  AND tt_an_pef.tta_cod_parcela = IF v_log_reproces THEN STRING((1 + v_num_reproces)) ELSE "1" NO-ERROR.
                      
            IF NOT AVAIL tt_an_pef THEN DO:
                CREATE tt_an_pef.
                ASSIGN tt_an_pef.tta_cod_tip_tit = (IF TRIM(ENTRY(6, v_des_reg_import, ";")) BEGINS "Retifica" THEN "PEF" ELSE "AN")
                       tt_an_pef.tta_cod_tit_ap  = v_cod_embarque
                       tt_an_pef.tta_cod_parcela = IF v_log_reproces THEN STRING((1 + v_num_reproces)) ELSE "1"
                       tt_an_pef.tta_val_tit_ap  = DEC(REPLACE(ENTRY(13, v_des_reg_import, ";"), "R$", ""))
                       v_tot_emb                 = v_tot_emb + tt_an_pef.tta_val_tit_ap
                       tt_an_pef.tta_cod_histor  = "AT Importada - esapb021 - " + v_nom_filename_import.
            END.
        END.
    END.
    ELSE IF v_process = 2 THEN DO:
        ASSIGN v_cod_espec  = 'AN'
               v_cdn_fornec = 5949.

        /* ** Importa XML ***/
        CREATE X-DOCUMENT hRetorno.
        CREATE X-NODEREF  hListarNovosResult.
        CREATE X-NODEREF  hCampos.
        CREATE X-NODEREF  hclsEmbarqueList.
        CREATE X-NODEREF  hRegistro.
        CREATE X-NODEREF  hValor.

        EMPTY TEMP-TABLE tt-item.

        CREATE BUFFER bItem FOR TABLE "tt-item".

        hRetorno:LOAD("FILE",v_nom_filename_import,NO).
        hRetorno:GET-DOCUMENT-ELEMENT(hListarNovosResult).

        repeat cont1 = 1 to hListarNovosResult:num-children:
            hListarNovosResult:get-child(hRegistro,cont1).

            if (hRegistro:name = "solicitacao") then do:
                bItem:buffer-create().

                repeat Cont2 = 1 to hRegistro:num-children:
                    hRegistro:get-child(hCampos, Cont2).

                    if (hCampos:subtype ne 'ELEMENT':U) then next.

                    if (hCampos:num-children < 1) then next.

                    hField = bItem:buffer-field(hCampos:name) no-error.

                    if (hField = ?) then next.

                    hCampos:get-child(hValor, 1).

                    hField:buffer-value = trim(hValor:node-value) no-error.
                END.
            END.
        END.

        if (valid-handle(bItem)) then
            delete widget bItem.

        IF VALID-HANDLE(hListarNovosResult) THEN DELETE OBJECT hListarNovosResult.
        IF VALID-HANDLE(hCampos) THEN DELETE OBJECT hCampos.
        IF VALID-HANDLE(hclsEmbarqueList)   THEN DELETE OBJECT hclsEmbarqueList.
        IF VALID-HANDLE(hRegistro)          THEN DELETE OBJECT hRegistro.
        IF VALID-HANDLE(hValor)             THEN DELETE OBJECT hValor.
        IF VALID-HANDLE(hRetorno)           THEN DELETE OBJECT hRetorno.

        FOR EACH tt-item:
            FIND tt_an_pef NO-LOCK
                WHERE tt_an_pef.tta_cod_tip_tit = "AN"
                  AND tt_an_pef.tta_cod_tit_ap  = tt-item.embarque
                  AND tt_an_pef.tta_cod_parcela = STRING(INT(tt-item.numero)) NO-ERROR.

            IF NOT AVAIL tt_an_pef THEN DO:
                CREATE tt_an_pef.
                ASSIGN tt_an_pef.tta_cod_tip_tit = "AN"
                       tt_an_pef.tta_cod_tit_ap  = tt-item.embarque
                       tt_an_pef.tta_cod_parcela = STRING(INT(tt-item.numero)).
            END.

            tt-item.valor = REPLACE(tt-item.valor, ",", "").
            tt-item.valor = REPLACE(tt-item.valor, ".", ",").

            ASSIGN tt_an_pef.tta_val_tit_ap  = tt_an_pef.tta_val_tit_ap + DEC(tt-item.valor)
                   v_tot_emb                 = v_tot_emb + tt_an_pef.tta_val_tit_ap
                   tt_an_pef.tta_cod_histor  = "Processo: " + tt-item.processo + CHR(10) + CHR(10) + " - AN Importada - esapb021 - " + v_nom_filename_import.
        END.
    END.
    ELSE IF v_process = 3 THEN DO:
        ASSIGN v_cod_espec  = 'AN':U
               v_cdn_fornec = 5949.

        RUN esp/apb/esapb028.p (INPUT  v_remessa,
                                OUTPUT TABLE tt_processo_embarque,
                                OUTPUT TABLE tt_mensagem).

        IF CAN-FIND(FIRST tt_mensagem) THEN DO:
            FOR EACH tt_mensagem:
                ASSIGN v_des_mensagem = tt_mensagem.descricao.
                RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
                PUT STREAM s_1 UNFORMATTED
                    v_num_line TO 27 FORMAT  ">>,>>9":U
                    ENTRY(1, RETURN-VALUE, CHR(255)) AT 31 FORMAT "x(50)" SKIP.
                RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").
            END.
        END.
        ELSE DO:
            FOR EACH tt_processo_embarque:
                FIND FIRST tt_an_pef
                    WHERE tt_an_pef.tta_cod_tip_tit = "AN":U
                      AND tt_an_pef.tta_cod_tit_ap  = tt_processo_embarque.processo_embarque
                      AND tt_an_pef.tta_cod_parcela = (IF v_log_reproces THEN STRING((1 + v_num_reproces)) ELSE "1":U) NO-LOCK NO-ERROR.

                IF NOT AVAILABLE tt_an_pef THEN DO:
                    CREATE tt_an_pef.
                    ASSIGN tt_an_pef.tta_cod_tip_tit = "AN":U
                           tt_an_pef.tta_cod_tit_ap  = tt_processo_embarque.processo_embarque
                           tt_an_pef.tta_cod_parcela = IF v_log_reproces THEN STRING((1 + v_num_reproces)) ELSE "1":U.
                END.

                ASSIGN tt_an_pef.tta_val_tit_ap  = tt_an_pef.tta_val_tit_ap + tt_processo_embarque.valor_embarque
                       v_tot_emb                 = v_tot_emb + tt_an_pef.tta_val_tit_ap
                       tt_an_pef.tta_cod_histor  = "AN Importada - esapb021 - WebService - Data/Hora: " + TRIM(STRING(TODAY, "99/99/9999":U)) + " " + TRIM(STRING(TIME, "hh:mm:ss":U)) + CHR(10) + "#Remessa:":U + TRIM(STRING(v_remessa)) + "#":U + CHR(10).
            END.
        END.
    END.

    IF v_process <> 3                                    OR
       (v_process = 3 AND NOT CAN-FIND(FIRST tt_mensagem)) THEN DO:
        IF ROUND(v_tot_emb,2) <> v_val_bordero_imp
        THEN DO:
             ASSIGN v_des_mensagem = SUBSTITUTE("Valor Total dos Embarques (&1) difere do Valor do Borderì (&2) !", TRIM(STRING(ROUND(v_tot_emb,2), ">>>,>>>,>>9.99")), TRIM(STRING(v_val_bordero_imp, ">>>,>>>,>>9.99"))).
             RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
             PUT STREAM s_1 UNFORMATTED  
                 v_num_line TO 27 FORMAT  ">>,>>9"
                 ENTRY(1, RETURN-VALUE, CHR(255)) AT 31 FORMAT "x(50)" SKIP.
             RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").
             ASSIGN v_log_avail_tit = NO.
             FOR EACH tt_an_pef:
                 DELETE tt_an_pef.
             END.
        END.
    END.

    IF CAN-FIND(FIRST tt_an_pef) 
    THEN DO:

        cria_bord:
        DO TRANSACTION:
    
            RUN pi_wait_processing (INPUT "Gerando AN/PEF...",
                                    INPUT "Importaá∆o SISCOMEX").

            FIND estabelecimento NO-LOCK
                WHERE estabelecimento.cod_estab = v_cod_estab_imp NO-ERROR.

            FOR EACH tt_an_pef:

                ASSIGN v_log_refer_uni = NO.
      
                REPEAT WHILE v_log_refer_uni = NO:
                   RUN pi_retorna_sugestao_referencia (INPUT "P",
                                                       INPUT TODAY,
                                                       OUTPUT v_cod_refer).
                   RUN pi_verifica_refer_unica_apb (INPUT v_cod_estab_imp,
                                                    INPUT v_cod_refer,
                                                    OUTPUT v_log_refer_uni).
                END.
    
                ASSIGN tt_an_pef.tta_cod_refer = v_cod_refer.

                /* ** Popula Temp-Table ***/
                IF tt_an_pef.tta_cod_tip_tit = "AN"
                THEN DO:
                     CREATE tt_integr_apb_antecip_pef_p1.
                     ASSIGN tt_integr_apb_antecip_pef_p1.tta_cod_empresa           = estabelecimento.cod_empresa           
                            tt_integr_apb_antecip_pef_p1.tta_cod_estab             = v_cod_estab_imp
                            tt_integr_apb_antecip_pef_p1.tta_cod_refer             = v_cod_refer
                            tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto       = v_cod_espec
                            tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto         = v_cod_ser 
                            tt_integr_apb_antecip_pef_p1.tta_cdn_fornecedor        = v_cdn_fornec
                            tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap            = tt_an_pef.tta_cod_tit_ap
                            /* ** Alterado a parcela para o reprocessamento ***/
                            tt_integr_apb_antecip_pef_p1.tta_cod_parcela           = tt_an_pef.tta_cod_parcela
                            tt_integr_apb_antecip_pef_p1.tta_cod_portador          = v_cod_portador_imp
                            tt_integr_apb_antecip_pef_p1.tta_cod_indic_econ        = "real"
                            tt_integr_apb_antecip_pef_p1.tta_val_tit_ap            = tt_an_pef.tta_val_tit_ap
                            tt_integr_apb_antecip_pef_p1.tta_val_cotac_indic_econ  = 1.000
                            tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto        = v_dat_bordero_imp
                            tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap     = v_dat_bordero_imp
                            tt_integr_apb_antecip_pef_p1.tta_ind_tip_refer         = "Antecipaá∆o"
                            tt_integr_apb_antecip_pef_p1.tta_des_text_histor       = tt_an_pef.tta_cod_histor
                            tt_integr_apb_antecip_pef_p1.tta_ind_natur_cta_ctbl    = "1"
                            tt_integr_apb_antecip_pef_p1.tta_cod_usuar_gerac_movto = v_cod_usuar_corren   
                            tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend  = RECID(tt_integr_apb_antecip_pef_p1)  
                            tt_integr_apb_antecip_pef_p1.tta_ind_origin_tit_ap     = "APB".
                     CREATE tt_integr_apb_aprop_ctbl_pend.
                     ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend           = tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl             = ""
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                   = ""
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc                 = "ADM"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto               = ""
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                     = ""
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ           = if v_cod_espec = "AT" then "236" else "202"
                            tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl                 = tt_an_pef.tta_val_tit_ap.
                END.
                ELSE DO:
                     CREATE tt_integr_apb_antecip_pef_p1.
                     ASSIGN tt_integr_apb_antecip_pef_p1.tta_cod_empresa           = estabelecimento.cod_empresa           
                            tt_integr_apb_antecip_pef_p1.tta_cod_estab             = v_cod_estab_imp
                            tt_integr_apb_antecip_pef_p1.tta_cod_refer             = v_cod_refer
                            tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto       = ""
                            tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto         = ""
                            tt_integr_apb_antecip_pef_p1.tta_cdn_fornecedor        = v_cdn_fornec
                            tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap            = tt_an_pef.tta_cod_tit_ap
                            tt_integr_apb_antecip_pef_p1.tta_cod_parcela           = ""
                            tt_integr_apb_antecip_pef_p1.tta_cod_portador          = v_cod_portador_imp
                            tt_integr_apb_antecip_pef_p1.tta_cod_indic_econ        = "real"
                            tt_integr_apb_antecip_pef_p1.tta_val_tit_ap            = tt_an_pef.tta_val_tit_ap
                            tt_integr_apb_antecip_pef_p1.tta_val_cotac_indic_econ  = 1
                            tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto        = v_dat_bordero_imp
                            tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap     = v_dat_bordero_imp
                            tt_integr_apb_antecip_pef_p1.tta_ind_tip_refer         = "Pagto Extra Fornecedor"
                            tt_integr_apb_antecip_pef_p1.tta_des_text_histor       = "Multa - PEF Importado - esapb021 - " + v_nom_filename_import
                            tt_integr_apb_antecip_pef_p1.tta_ind_natur_cta_ctbl    = "1"
                            tt_integr_apb_antecip_pef_p1.tta_cod_usuar_gerac_movto = v_cod_usuar_corren   
                            tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend  = RECID(tt_integr_apb_antecip_pef_p1)  
                            tt_integr_apb_antecip_pef_p1.tta_ind_origin_tit_ap     = "APB".
                     CREATE tt_integr_apb_aprop_ctbl_pend.
                     ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend           = tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl             = "PADRAO"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                   = "41640005"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc                 = "ADM"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto               = "PADRAO"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                     = "42100"
                            tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ           = "202"
                            tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl                 = tt_an_pef.tta_val_tit_ap.
                END.
            END.

            /* ** Executa API ***/
            RUN prgfin/apb/apb905zd.py PERSISTENT SET v_hdl_aux.

            RUN pi_main_block_antecip_pef_pend_2 IN v_hdl_aux (INPUT 3,
                                                               INPUT  "",
                                                               INPUT-OUTPUT TABLE tt_integr_apb_antecip_pef_p1,
                                                               INPUT TABLE tt_integr_apb_aprop_ctbl_pend,
                                                               INPUT TABLE tt_integr_apb_impto_impl_pend,
                                                               INPUT TABLE tt_integr_apb_abat_prev_provis,
                                                               OUTPUT TABLE tt_log_erros_atualiz_an,
                                                               INPUT TABLE tt_1099,
                                                               INPUT TABLE tt_ord_compra_tit_ap_pend_1).
        
            /* ** Elimina Instanciamento ***/
            DELETE PROCEDURE v_hdl_aux.

            /* ** Apresenta Erros ***/
            FOR EACH tt_log_erros_atualiz_an:
                ASSIGN v_des_mensagem = "Erro API AN/PEF: " + tt_log_erros_atualiz_an.ttv_des_msg_erro.
                RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
                PUT STREAM s_1 UNFORMATTED  
                    v_num_line TO 27 FORMAT  ">>,>>9"
                    ENTRY(1, RETURN-VALUE, CHR(255)) AT 31 FORMAT "x(50)" SKIP.
                RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").
            END.
            IF CAN-FIND(FIRST tt_log_erros_atualiz_an) 
            THEN DO: 
                 ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").
                 MESSAGE "Erro ao incluir a AN/PEF !"
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 UNDO cria_bord, LEAVE cria_bord.
            END.

            RUN pi_wait_processing (INPUT "Gerando Borderì...",
                                    INPUT "Importaá∆o SISCOMEX").

            /* ** Cria Borderì ***/
            CREATE tt_integr_apb_pagto.
            ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz       = "bordero"
                   tt_integr_apb_pagto.ttv_log_atualiz_refer     = NO 
                   tt_integr_apb_pagto.ttv_log_gera_lote_parcial = NO.
    
            FIND LAST bord_ap NO-LOCK
                 WHERE bord_ap.cod_estab_bord = v_cod_estab_imp
                   AND bord_ap.cod_portador   = v_cod_portador_imp NO-ERROR.
    
            IF AVAIL bord_ap 
               THEN ASSIGN v_num_bord = bord_ap.num_bord_ap + 1.
               ELSE ASSIGN v_num_bord = 1.
    
            ASSIGN tt_integr_apb_pagto.tta_cod_empresa               = v_cod_empres_usuar
                   tt_integr_apb_pagto.tta_cod_estab_bord            = v_cod_estab_imp
                   tt_integr_apb_pagto.tta_cod_portador              = v_cod_portador_imp
                   tt_integr_apb_pagto.tta_num_bord_ap               = v_num_bord
                   tt_integr_apb_pagto.tta_log_bord_ap_escrit        = IF (v_process = 2 OR v_process = 3) THEN YES ELSE NO
                   tt_integr_apb_pagto.tta_log_bord_ap_escrit_envdo  = no
                   tt_integr_apb_pagto.tta_ind_tip_bord_ap           = "Normal"
                   tt_integr_apb_pagto.tta_dat_transacao             = v_dat_bordero_imp
                   tt_integr_apb_pagto.tta_cod_indic_econ            = "Real"
                   tt_integr_apb_pagto.tta_cod_finalid_econ          = "Corrente"
                   tt_integr_apb_pagto.tta_cod_usuar_pagto           = v_cod_usuar_corren
                   tt_integr_apb_pagto.ttv_rec_table_parent          = recid(tt_integr_apb_pagto).
    
            
            FOR EACH tt_an_pef:
                CREATE tt_integr_apb_bord_lote_pagto.
                ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = estabelecimento.cod_empresa
                       tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer  = v_cod_estab_imp
                       tt_integr_apb_bord_lote_pagto.tta_cod_portador          = v_cod_portador_imp
                       tt_integr_apb_bord_lote_pagto.tta_cod_estab             = v_cod_estab_imp
                       tt_integr_apb_bord_lote_pagto.tta_cod_refer_antecip_pef = tt_an_pef.tta_cod_refer
                       tt_integr_apb_bord_lote_pagto.tta_val_pagto             = tt_an_pef.tta_val_tit
                       tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_bord_ap  = ""
                       tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = NO 
                       tt_integr_apb_bord_lote_pagto.ttv_ind_forma_pagto       = "Informada"
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = RECID(tt_integr_apb_bord_lote_pagto)
                       tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ  = 1
                       tt_integr_apb_bord_lote_pagto.tta_cod_indic_econ        = "Real"
                       tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = v_cdn_fornec.
                IF v_process = 2 
                OR v_process = 3
                THEN DO:
                     ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto = "50". /* ** Escritural TED ***/
                END.
                ELSE DO:
                     ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto = "40".
                END.

            END.

            RUN prgfin/apb/apb902zc.py (INPUT 1,
                                        INPUT TABLE tt_integr_apb_pagto,
                                        OUTPUT TABLE tt_log_erros_atualiz,
                                        INPUT TABLE tt_integr_apb_bord_lote_pagto,
                                        INPUT TABLE tt_integr_apb_abat_prev,
                                        INPUT TABLE tt_integr_apb_abat_antecip,
                                        INPUT TABLE tt_integr_apb_impto_impl_pend,
                                        INPUT "",
                                        INPUT TABLE tt_integr_cambio_ems5,
                                        INPUT TABLE tt_1099).
    
            FOR EACH tt_log_erros_atualiz:
    
                FIND tt_relac_erro 
                    WHERE tt_relac_erro.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.
                IF AVAIL tt_relac_erro 
                   THEN ASSIGN v_num_line = tt_relac_erro.ttv_num_linha.
                   ELSE ASSIGN v_num_line = 0.

                ASSIGN v_des_mensagem = "Erro API Borderì: " + tt_log_erros_atualiz.ttv_des_msg_erro.
                RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
                PUT STREAM s_1 UNFORMATTED  
                    v_num_line TO 27 FORMAT  ">>,>>9"
                    ENTRY(1, RETURN-VALUE, CHR(255)) AT 31 FORMAT "x(50)" SKIP.
                RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").
    
            END.
    
            IF CAN-FIND(FIRST tt_log_erros_atualiz) 
            THEN DO: 
                 ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").
                 MESSAGE "Erro ao incluir o Borderì !"
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 UNDO cria_bord, LEAVE cria_bord.
            END.
            
            ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").
    
            MESSAGE "Importaá∆o conclu°da, borderì n£mero: " v_num_bord VIEW-AS ALERT-BOX.
    
            /*zarpe
            UNDO cria_bord, LEAVE cria_bord.*/

        END.

    END.


    IF v_ind_message_output = "Em Arquivo"
    THEN DO:
         HIDE STREAM s_1 FRAME f_rpt_s_1_footer_normal.
         HIDE STREAM s_1 FRAME f_rpt_s_1_footer_param_page.
         VIEW STREAM s_1 FRAME f_rpt_s_1_footer_last_page.
         HIDE FRAME f_dlg_02_wait_processing.
    END.

END PROCEDURE.

PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE.
PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_filename
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "."
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0
        then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK" /*l_ok*/ .
END PROCEDURE.
PROCEDURE pi_wait_processing:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_message
        as character
        format "x(40)"
        no-undo.
    def Input param p_nom_frame_title
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  p_nom_frame_title <> ? or
       frame f_dlg_02_wait_processing:visible = no
    then do:
        if  p_nom_frame_title <> ""
        then do:
            assign frame f_dlg_02_wait_processing:title = p_nom_frame_title.
        end /* if */.
        else do:
            assign frame f_dlg_02_wait_processing:title = "Aguarde, em processamento..." /*l_aguarde_em_processamento*/ .
        end /* else */.
        assign ed_1x40:width-chars in frame f_dlg_02_wait_processing = 60.
    end /* if */.
    assign ed_1x40:screen-value in frame f_dlg_02_wait_processing = p_des_message.
    enable all with frame f_dlg_02_wait_processing.
    process events.
END PROCEDURE.
PROCEDURE pi_system_dialog_get_file:

    system-dialog get-file v_nom_filename
        title v_nom_title
        filters v_nom_name[1]  v_des_filespec[1] ,
                v_nom_name[2]  v_des_filespec[2] ,
                v_nom_name[3]  v_des_filespec[3] ,
                v_nom_name[4]  v_des_filespec[4] ,
                v_nom_name[5]  v_des_filespec[5] ,
                v_nom_name[6]  v_des_filespec[6] ,
                v_nom_name[7]  v_des_filespec[7] ,
                v_nom_name[8]  v_des_filespec[8] ,
                v_nom_name[9]  v_des_filespec[9] ,
                v_nom_name[10] v_des_filespec[10]
        must-exist
        initial-dir v_nom_filename
        use-filename
        update v_log_answer.

END PROCEDURE.
PROCEDURE pi_print_editor:

    def input param p_stream    as char    no-undo.
    def input param p1_editor   as char    no-undo.
    def input param p1_pos      as char    no-undo.
    def input param p2_editor   as char    no-undo.
    def input param p2_pos      as char    no-undo.
    def input param p3_editor   as char    no-undo.
    def input param p3_pos      as char    no-undo.

    def var c_editor as char    extent 5             no-undo.
    def var l_first  as logical extent 5 initial yes no-undo.
    def var c_at     as char    extent 5             no-undo.
    def var i_pos    as integer extent 5             no-undo.
    def var i_len    as integer extent 5             no-undo.

    def var c_aux    as char               no-undo.
    def var i_aux    as integer            no-undo.
    def var c_ret    as char               no-undo.
    def var i_ind    as integer            no-undo.

    assign c_editor [1] = p1_editor
           c_at  [1]    =         substr(p1_pos,1,2)
           i_pos [1]    = integer(substr(p1_pos,3,3))
           i_len [1]    = integer(substr(p1_pos,6,3)) - 4
           c_editor [2] = p2_editor
           c_at  [2]    =         substr(p2_pos,1,2)
           i_pos [2]    = integer(substr(p2_pos,3,3))
           i_len [2]    = integer(substr(p2_pos,6,3)) - 4
           c_editor [3] = p3_editor
           c_at  [3]    =         substr(p3_pos,1,2)
           i_pos [3]    = integer(substr(p3_pos,3,3))
           i_len [3]    = integer(substr(p3_pos,6,3)) - 4
           c_ret        = chr(255) + chr(255).

    do while c_editor [1] <> "" or c_editor [2] <> "" or c_editor [3] <> "":
        do i_ind = 1 to 3:
            if c_editor[i_ind] <> "" then do:
                assign i_aux = index(c_editor[i_ind], chr(10)).
                if i_aux > i_len[i_ind] or (i_aux = 0 and length(c_editor[i_ind]) > i_len[i_ind]) then
                    assign i_aux = r-index(c_editor[i_ind], " ", i_len[i_ind] + 1).
                if i_aux = 0 then
                    assign c_aux = substr(c_editor[i_ind], 1, i_len[i_ind])
                           c_editor[i_ind] = substr(c_editor[i_ind], i_len[i_ind] + 1).
                else
                    assign c_aux = substr(c_editor[i_ind], 1, i_aux - 1)
                           c_editor[i_ind] = substr(c_editor[i_ind], i_aux + 1).
                if i_pos[1] = 0 then
                    assign entry(i_ind, c_ret, chr(255)) = c_aux.
                else
                    if l_first[i_ind] then
                        assign l_first[i_ind] = no.
                    else
                        case p_stream:
                            when "s_1" then
                                if c_at[i_ind] = "at" then
                                    put stream s_1 unformatted c_aux at i_pos[i_ind].
                                else
                                    put stream s_1 unformatted c_aux to i_pos[i_ind].
                        end.
            end.
        end.
        case p_stream:
        when "s_1" then
            put stream s_1 unformatted skip.
        end.
        if i_pos[1] = 0 then
            return c_ret.
    end.
    return c_ret.
END PROCEDURE.
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
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
PROCEDURE pi_verifica_refer_unica_apb:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.

    /************************* Parameter Definition End *************************/

    DEF BUFFER b_tt_an_pef FOR tt_an_pef.

    assign p_log_refer_uni = yes.

    find first antecip_pef_pend no-lock
         where antecip_pef_pend.cod_estab = p_cod_estab
           and antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
    end.
    else do:
        find first lote_impl_tit_ap no-lock
             where lote_impl_tit_ap.cod_estab = p_cod_estab
               and lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
        if  avail lote_impl_tit_ap
        then do:
            assign p_log_refer_uni = no.
        end.
        else do:
            find first lote_pagto no-lock
                 where lote_pagto.cod_estab_refer = p_cod_estab
                   and lote_pagto.cod_refer       = p_cod_refer no-error.
            if  avail lote_pagto
            then do:
                assign p_log_refer_uni = no.
            end.
            else do:
                find first movto_tit_ap no-lock
                     where movto_tit_ap.cod_estab = p_cod_estab
                       and movto_tit_ap.cod_refer = p_cod_refer no-error.
                if  avail movto_tit_ap
                then do:
                    assign p_log_refer_uni = no.
                end.
                ELSE DO:
                     FIND FIRST b_tt_an_pef no-lock
                          WHERE b_tt_an_pef.tta_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL b_tt_an_pef 
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.
