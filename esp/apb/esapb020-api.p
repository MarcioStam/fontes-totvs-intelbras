/******************************************************************************
** Programa..............: esp/apb/esapb020.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 26/02/2010
** Transformar em API....: 16/12/2015 - Hoepers
******************************************************************************/

/*************************** Definition Begin - API Pagamento ********************/
def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

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
          ttv_rec_table_child              ascending.

def temp-table tt_integr_apb_abat_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

def temp-table tt_integr_apb_abat_prev no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

def temp-table tt_integr_apb_bord_lote_pagto no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_bord_refer         as character format "x(8)"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_refer_antecip_pef        as character format "x(10)" label "Ref Antec PEF Pend" column-label "Ref Antec PEF Pend"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_val_pagto                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagamento" column-label "Valor Pagto"
    field tta_val_multa_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_ap                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre‡Æo Monet" column-label "Val Corr Monet"
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
    field tta_ind_sit_item_bord_ap         as character format "X(9)" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_log_critic_atualiz_ok        as logical format "Sim/NÆo" initial no label "Cr¡tica OK" column-label "Cr¡tica OK"
    field tta_cod_estab_cheq               as character format "x(3)" label "Estabelec Cheque" column-label "Estabelec Cheque"
    field tta_num_seq_item_cheq            as integer format ">>>9" initial 0 label "Sequˆncia Item Cheq" column-label "Seq"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_ind_sit_item_lote_bxa_ap     as character format "X(9)" initial "Gerado" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field ttv_ind_forma_pagto              as character format "X(18)" initial "Assume do T¡tulo"
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending.

def temp-table tt_integr_apb_impto_impl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu‡Æo Inss" column-label "Dedu‡Æo Inss"
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu‡Æo Dependentes" column-label "Dedu‡Æo Dependentes"
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao PensÆo" column-label "Deducao PensÆo"
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Dedu‡äes" column-label "Outras Dedu‡äes"
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L¡quida Imposto" column-label "Base L¡quida Imposto"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Dedu‡Æo"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
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

def temp-table tt_integr_apb_pagto no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_estab_bord               as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_tot_lote_pagto_efetd     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Pagamento" column-label "Total Pagamento"
    field tta_val_tot_lote_pagto_infor     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_usuar_pagto              as character format "x(12)" label "Usuar Pagamento" column-label "Usu rio Pagto"
    field tta_log_enctro_cta               as logical format "Sim/NÆo" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_val_tot_liquidac_tit_acr     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Liquida‡Æo" column-label "Total Liquida‡Æo"
    field tta_num_bord_ap                  as integer format ">>>>>9" initial 0 label "N£mero Border“" column-label "Border“"
    field tta_cod_msg_inic                 as character format "x(2)" label "Mensagem In¡cio" column-label "Msg Fim"
    field tta_cod_msg_fim                  as character format "x(2)" label "Mensagem Fim" column-label "Msg Fim"
    field tta_log_bord_ap_escrit           as logical format "Sim/NÆo" initial no label "Bordero Escritural" column-label "Escritural"
    field tta_log_bord_ap_escrit_envdo     as logical format "Sim/NÆo" initial no label "Enviado" column-label "Enviado"
    field tta_ind_tip_bord_ap              as character format "X(17)" initial "Normal" label "Tipo Border“" column-label "Tipo Border“"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
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
    field ttv_log_atualiz_refer            as logical format "Sim/NÆo" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/NÆo" initial no
    field ttv_ind_tip_atualiz              as character format "X(08)"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_log_vinc_impto_auto          as logical initial NO /* Luiz */
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

def temp-table tt_integr_apb_pagto_aux no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_log_bxa_estab_tit_ap         as logical format "Sim/NÆo" initial no label "Baixa Estabelec" column-label "Baixa Estabelec".

def temp-table tt_integr_apb_bord_lote_pg_a no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/NÆo" initial no.

/*************************** Definition Begin - API Altera‡Æo ********************/

def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field ttv_ind_tip_rat                  as character format "X(08)"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_aprop_ctbl_ap         as integer format "9999999999" initial 0 label "Id Aprop Ctbl AP" column-label "Id Aprop Ctbl AP"
    index tt_aprpctba_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
          ttv_rec_tit_ap                   ascending.

def temp-table tt_tit_ap_alteracao_base no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transa‡Æo" column-label "Data Transa‡Æo"
    field ttv_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Altera‡Æo" label "Motivo Altera‡Æo" column-label "Motivo Altera‡Æo"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/NÆo" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_histor_padr              as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo Hist¢rico PadrÆo"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.


def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".


def temp-table tt_tit_ap_alteracao_base_aux_1 no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transa‡Æo" column-label "Data Transa‡Æo"
    field ttv_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Altera‡Æo" label "Motivo Altera‡Æo" column-label "Motivo Altera‡Æo"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/NÆo" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_histor_padr              as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo Hist¢rico PadrÆo"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(50)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

/*************************** Temp-Table Definition Begin ********************/

DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD num_id_tt_concil      AS INT
    FIELD cod_tip_reg           AS INT
    FIELD cod_estab             LIKE tit_ap.cod_estab     
    FIELD cdn_fornec            LIKE tit_ap.cdn_fornec    
    FIELD cod_espec             LIKE tit_ap.cod_espec     
    FIELD cod_ser               LIKE tit_ap.cod_ser      
    FIELD cod_tit_ap            LIKE tit_ap.cod_tit_ap
    FIELD cod_parcela           LIKE tit_ap.cod_parcela
    FIELD dat_transacao         LIKE tit_ap.dat_transacao
    FIELD cod_indic_econ        LIKE tit_ap.cod_indic_econ
    FIELD val_sdo               LIKE tit_ap.val_sdo
    FIELD log_conf              AS LOG LABEL "Status" FORMAT "Sim/NÆo" 
    FIELD des_status            AS CHAR LABEL "Op‡Æo" FORMAT "x(30)"
  INDEX tt_concil
        num_id_tt_concil        ASCENDING
        cod_tip_reg             ASCENDING
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING
  INDEX tt_concil_tit
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING.

/*************************** Temp-Table Definition Begin ********************/

DEF BUFFER b_tit_ap          FOR tit_ap.
DEF BUFFER btt_concil        FOR tt_concil.
DEF BUFFER b_estabelecimento FOR estabelecimento.

/************************** Variable Definition Begin ***********************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar       AS CHAR NO-UNDO.

DEF VAR v_ind_tipo_concil AS INT                          NO-UNDO.
DEF VAR v_dat_transacao   LIKE lote_pagto.dat_transacao   NO-UNDO. /* today                          */
DEF VAR v_val_ava         LIKE movto_tit_ap.val_movto_ap  NO-UNDO. /* 40,00      parametrizar ES0018 */
DEF VAR v_cod_cta_ctbl    LIKE aprop_ctbl_ap.cod_cta_ctbl NO-UNDO. /* 333.700.10 parametrizar ES0018 */
DEF VAR v_val_min_parcial LIKE movto_tit_ap.val_movto_ap  NO-UNDO. /* 5000,00    parametrizar ES0018 */
DEF VAR v_especie         LIKE tit_ap.cod_espec           NO-UNDO.
DEF VAR v_empresa         LIKE v_cod_empres_usuar         NO-UNDO.
DEF VAR v_estabelecimento LIKE v_cod_estab_usuar          NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

def var v_hdl_apb902ze
    as Handle
    format ">>>>>>9":U
    no-undo.


DEFINE VARIABLE v_val_sdo AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_rec_con AS INTEGER     NO-UNDO.

def new global shared var v_des_contdo_prog_valid_dtsul as CHARACTER format "x(40)":U no-undo.
def new global shared var v_log_monit_tab_espec_financ  as LOGICAL initial NO         no-undo.

/*************************** Varable Definition End *************************/


/************************** Main Code Begin *********************************/


PROCEDURE pi-inicializar:

    DEF INPUT PARAM p-empres-usuar       LIKE v_cod_empres_usuar NO-UNDO.
    DEF INPUT PARAM p-estab-usuar        LIKE v_cod_estab_usuar  NO-UNDO.
    DEF INPUT PARAM p-i-tipo-conciliacao AS INT                  NO-UNDO.
    DEF INPUT PARAM p-dt-pagto           AS DATE                 NO-UNDO.
    DEF INPUT PARAM p-de-vl-max-ava      AS DEC                  NO-UNDO.
    DEF INPUT PARAM p-c-conta-ava        AS CHAR                 NO-UNDO.
    DEF INPUT PARAM p-de-vl-min-parcial  AS DEC                  NO-UNDO.

    DEF OUTPUT PARAM TABLE FOR tt_concil.

    ASSIGN v_ind_tipo_concil             = p-i-tipo-conciliacao
           v_dat_transacao               = p-dt-pagto
           v_val_ava                     = p-de-vl-max-ava
           v_cod_cta_ctbl                = p-c-conta-ava
           v_val_min_parcial             = p-de-vl-min-parcial
           v_des_contdo_prog_valid_dtsul = "esapb020-api"
           v_log_monit_tab_espec_financ  = YES
           v_empresa                     = p-empres-usuar
           v_estabelecimento             = p-estab-usuar.

    IF  v_dat_transacao = ?
    THEN
        ASSIGN v_dat_transacao = TODAY.

    EMPTY TEMP-TABLE tt_1099.
    EMPTY TEMP-TABLE tt_integr_cambio_ems5.
    EMPTY TEMP-TABLE tt_integr_apb_abat_antecip.
    EMPTY TEMP-TABLE tt_integr_apb_abat_prev.
    EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pagto.
    EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend.
    EMPTY TEMP-TABLE tt_integr_apb_pagto.
    EMPTY TEMP-TABLE tt_log_erros_atualiz.
    EMPTY TEMP-TABLE tt_integr_apb_pagto_aux.
    EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pg_a.
    EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base.
    EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
    EMPTY TEMP-TABLE tt_concil.

    CASE v_ind_tipo_concil:
        WHEN(1) THEN RUN pi_import_imposto.
        WHEN(2) THEN RUN pi_import_importacao.
        WHEN(3) THEN RUN pi_import_nacional.
        WHEN(4) THEN RUN pi_import_verba.
        WHEN(5)
        THEN DO:
            RUN pi_import_imposto.
            RUN pi_import_importacao.
            RUN pi_import_nacional.
            RUN pi_import_verba.
        END.
    END CASE.

END PROCEDURE.

RETURN "OK".


PROCEDURE pi_import_imposto:
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_empresa:
        FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab = estabelecimento.cod_estab
              AND tit_ap.cod_espec  = "AT"
              AND tit_ap.log_sdo_tit_ap:
    
            ASSIGN v_especie = "DI".

            RUN pi_concilia.    
        END.
    END.
END PROCEDURE.

PROCEDURE pi_import_importacao:

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_empresa:
        FOR EACH tit_ap NO-LOCK
            WHERE  tit_ap.cod_estab = estabelecimento.cod_estab
              AND (tit_ap.cod_espec = "AI"
              OR   tit_ap.cod_espec = "AC"
              OR   tit_ap.cod_espec = "AM")
              AND  tit_ap.log_sdo_tit_ap:
            FIND emscad.fornecedor NO-LOCK
                WHERE emscad.fornecedor.cod_empresa = estabelecimento.cod_empresa
                  AND emscad.fornecedor.cdn_fornec  = tit_ap.cdn_fornec NO-ERROR.
            IF NOT AVAIL emscad.fornecedor
            OR (emscad.fornecedor.cod_grp_fornec <> "90" AND
                emscad.fornecedor.cod_grp_fornec <> "91" AND
                emscad.fornecedor.cod_grp_fornec <> "92")
               THEN NEXT.

            ASSIGN v_especie = "DI".
            
            RUN pi_concil_importacao. /* usa esta procedure para nao gerar abatientos caso tenha diferen‡as */
        END.
    END.
END PROCEDURE.

PROCEDURE pi_import_nacional:

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_empresa:
        FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab = estabelecimento.cod_estab
              AND tit_ap.cod_espec  = "AR"
              AND tit_ap.log_sdo_tit_ap:
            FIND emscad.fornecedor NO-LOCK
                WHERE emscad.fornecedor.cod_empresa = estabelecimento.cod_empresa
                  AND emscad.fornecedor.cdn_fornec  = tit_ap.cdn_fornec NO-ERROR.
            IF NOT AVAIL emscad.fornecedor
            OR (emscad.fornecedor.cod_grp_fornec <> "03" AND
                emscad.fornecedor.cod_grp_fornec <> "07" AND
                emscad.fornecedor.cod_grp_fornec <> "92" AND
                emscad.fornecedor.cod_grp_fornec <> "52")
               THEN NEXT.

            ASSIGN v_especie = "DP".

            RUN pi_concil_nacional_verba.
        END.
    END.
END PROCEDURE.

PROCEDURE pi_import_verba:

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_empresa:
        FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab  = estabelecimento.cod_estab
              AND tit_ap.cod_espec  = "AR"
              AND tit_ap.log_sdo_tit_ap:
            FIND emscad.fornecedor NO-LOCK
                WHERE emscad.fornecedor.cod_empresa = estabelecimento.cod_empresa
                  AND emscad.fornecedor.cdn_fornec  = tit_ap.cdn_fornec NO-ERROR.
            IF  NOT AVAIL emscad.fornecedor THEN 
                NEXT.

            ASSIGN v_especie = "VM".

            RUN pi_concil_nacional_verba.
        END.
    END.
END PROCEDURE.

PROCEDURE pi_concilia:
    DEFINE VARIABLE v_cod_tit_ap AS CHARACTER   NO-UNDO.

    ASSIGN v_cod_tit_ap = REPLACE(tit_ap.cod_tit_ap, ".", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "-", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "_", "").

    ASSIGN v_val_sdo = 0.

    CREATE tt_concil.
    ASSIGN v_rec_con                   = RECID(tt_concil)
           tt_concil.num_id_tt_concil  = v_rec_con
           tt_concil.cod_tip_reg       = 1
           tt_concil.cod_estab         = tit_ap.cod_estab      
           tt_concil.cdn_fornec        = tit_ap.cdn_fornec     
           tt_concil.cod_espec         = tit_ap.cod_espec      
           tt_concil.cod_ser           = tit_ap.cod_ser        
           tt_concil.cod_tit_ap        = tit_ap.cod_tit_ap     
           tt_concil.cod_parcela       = tit_ap.cod_parcela    
           tt_concil.dat_transacao     = tit_ap.dat_transacao  
           tt_concil.cod_indic_econ    = tit_ap.cod_indic_econ 
           tt_concil.val_sdo           = tit_ap.val_sdo        
           tt_concil.log_conf          = YES
           tt_concil.des_status        = "Seleciona para Abatimento ?".

    FOR EACH b_estabelecimento NO-LOCK
        WHERE b_estabelecimento.cod_empresa = v_empresa:

        FOR EACH b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab  = b_estabelecimento.cod_estab
              AND b_tit_ap.cdn_fornec = tit_ap.cdn_fornec
              AND b_tit_ap.cod_espec  = v_especie /* esp‚cie DI para Importa‡äes/Impostos e DP para Fornecedores Nacionais */
              AND b_tit_ap.log_sdo_tit_ap
              AND b_tit_ap.cod_tit_ap BEGINS v_cod_tit_ap:

            IF LENGTH(b_tit_ap.cod_tit_ap) - LENGTH(v_cod_tit_ap) > 1 
               THEN NEXT.

            IF LENGTH(b_tit_ap.cod_tit_ap) > LENGTH(v_cod_tit_ap) THEN DO: 
                 IF LOOKUP(SUBSTRING(b_tit_ap.cod_tit_ap,LENGTH(b_tit_ap.cod_tit_ap),1),"0,1,2,3,4,5,6,7,8,9") = 0 
                    THEN NEXT.
            END.

            /*** Mais de uma AT, AI ou AR para o mesmo embarque, gera erro no lote de liquida‡Æo pois utilizamos a mesma DI/DP em mais de uma concilia‡Æo ***/
            FIND tt_concil NO-LOCK
                WHERE tt_concil.cod_tip_reg = 2
                  AND tt_concil.cod_estab   = b_tit_ap.cod_estab   
                  AND tt_concil.cdn_fornec  = b_tit_ap.cdn_fornec  
                  AND tt_concil.cod_espec   = b_tit_ap.cod_espec   
                  AND tt_concil.cod_ser     = b_tit_ap.cod_ser     
                  AND tt_concil.cod_tit_ap  = b_tit_ap.cod_tit_ap  
                  AND tt_concil.cod_parcela = b_tit_ap.cod_parcela NO-ERROR.

            IF  AVAIL tt_concil THEN 
                NEXT.

            CREATE tt_concil.
            ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                   tt_concil.cod_tip_reg       = 2
                   tt_concil.dat_transacao     = ?
                   tt_concil.cod_estab         = b_tit_ap.cod_estab      
                   tt_concil.cdn_fornec        = b_tit_ap.cdn_fornec     
                   tt_concil.cod_espec         = b_tit_ap.cod_espec      
                   tt_concil.cod_ser           = b_tit_ap.cod_ser        
                   tt_concil.cod_tit_ap        = b_tit_ap.cod_tit_ap     
                   tt_concil.cod_parcela       = b_tit_ap.cod_parcela    
                   tt_concil.dat_transacao     = b_tit_ap.dat_transacao  
                   tt_concil.cod_indic_econ    = b_tit_ap.cod_indic_econ 
                   tt_concil.val_sdo           = b_tit_ap.val_sdo        
                   tt_concil.log_conf          = YES
                   tt_concil.des_status        = "Seleciona para Abatimento ?".

            ASSIGN v_val_sdo = v_val_sdo + b_tit_ap.val_sdo_tit_ap.
        END.
    END.

    IF CAN-FIND(FIRST tt_concil
                WHERE tt_concil.num_id_tt_concil = v_rec_con
                  AND tt_concil.cod_tip_reg      = 2) 
    THEN DO:
         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 3
                tt_concil.val_sdo           = v_val_sdo - tit_ap.val_sdo
                tt_concil.dat_transacao     = ?
                tt_concil.des_status        = "Gera AVA da Diferen‡a ?".

         IF  tt_concil.val_sdo  = 0         OR 
             tt_concil.val_sdo >= v_val_ava OR 
             tt_concil.val_sdo <= (v_val_ava * -1) 
         THEN 
             ASSIGN tt_concil.log_conf = NO.
         ELSE 
             ASSIGN tt_concil.log_conf = YES.

         IF  tt_concil.val_sdo > v_val_ava AND 
             tt_concil.val_sdo <= v_val_min_parcial
         THEN
            ASSIGN tt_concil.log_conf = NO.

         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 4
                tt_concil.dat_transacao     = ?               
                tt_concil.val_sdo           = 0
                tt_concil.log_conf          = ?.
    END.
    ELSE DO:
         FIND tt_concil
             WHERE tt_concil.num_id_tt_concil = v_rec_con
               AND tt_concil.cod_tip_reg      = 1.
         DELETE tt_concil.
    END.
END PROCEDURE.

PROCEDURE pi_concil_nacional_verba:
    DEFINE VARIABLE v_cod_tit_ap AS CHARACTER   NO-UNDO.

    ASSIGN v_cod_tit_ap = REPLACE(tit_ap.cod_tit_ap, ".", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "-", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "_", "").

    ASSIGN v_val_sdo = 0.

    CREATE tt_concil.
    ASSIGN v_rec_con                   = RECID(tt_concil)
           tt_concil.num_id_tt_concil  = v_rec_con
           tt_concil.cod_tip_reg       = 1
           tt_concil.cod_estab         = tit_ap.cod_estab      
           tt_concil.cdn_fornec        = tit_ap.cdn_fornec     
           tt_concil.cod_espec         = tit_ap.cod_espec      
           tt_concil.cod_ser           = tit_ap.cod_ser        
           tt_concil.cod_tit_ap        = tit_ap.cod_tit_ap     
           tt_concil.cod_parcela       = tit_ap.cod_parcela    
           tt_concil.dat_transacao     = tit_ap.dat_transacao  
           tt_concil.cod_indic_econ    = tit_ap.cod_indic_econ 
           tt_concil.val_sdo           = tit_ap.val_sdo        
           tt_concil.log_conf          = YES
           tt_concil.des_status        = "Seleciona para Abatimento ?".

    FOR EACH b_estabelecimento NO-LOCK
        WHERE b_estabelecimento.cod_empresa = v_empresa:

        FOR EACH b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab  = b_estabelecimento.cod_estab
              AND b_tit_ap.cdn_fornec = tit_ap.cdn_fornec
              AND b_tit_ap.cod_espec  = v_especie /* esp‚cie DI para Importa‡äes/Impostos e DP para Fornecedores Nacionais */
              AND b_tit_ap.log_sdo_tit_ap
              AND b_tit_ap.cod_tit_ap BEGINS v_cod_tit_ap:

            IF LENGTH(b_tit_ap.cod_tit_ap) - LENGTH(v_cod_tit_ap) > 1 
               THEN NEXT.

            IF LENGTH(b_tit_ap.cod_tit_ap) > LENGTH(v_cod_tit_ap) THEN DO: 
                 IF LOOKUP(SUBSTRING(b_tit_ap.cod_tit_ap,LENGTH(b_tit_ap.cod_tit_ap),1),"0,1,2,3,4,5,6,7,8,9") = 0 
                    THEN NEXT.
            END.

            /*** Mais de uma AT, AI ou AR para o mesmo embarque, gera erro no lote de liquida‡Æo pois utilizamos a mesma DI/DP em mais de uma concilia‡Æo ***/
            FIND tt_concil NO-LOCK
                WHERE tt_concil.cod_tip_reg = 2
                  AND tt_concil.cod_estab   = b_tit_ap.cod_estab   
                  AND tt_concil.cdn_fornec  = b_tit_ap.cdn_fornec  
                  AND tt_concil.cod_espec   = b_tit_ap.cod_espec   
                  AND tt_concil.cod_ser     = b_tit_ap.cod_ser     
                  AND tt_concil.cod_tit_ap  = b_tit_ap.cod_tit_ap  
                  AND tt_concil.cod_parcela = b_tit_ap.cod_parcela NO-ERROR.

            IF  AVAIL tt_concil THEN 
                NEXT.

            CREATE tt_concil.
            ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                   tt_concil.cod_tip_reg       = 2
                   tt_concil.dat_transacao     = ?
                   tt_concil.cod_estab         = b_tit_ap.cod_estab      
                   tt_concil.cdn_fornec        = b_tit_ap.cdn_fornec     
                   tt_concil.cod_espec         = b_tit_ap.cod_espec      
                   tt_concil.cod_ser           = b_tit_ap.cod_ser        
                   tt_concil.cod_tit_ap        = b_tit_ap.cod_tit_ap     
                   tt_concil.cod_parcela       = b_tit_ap.cod_parcela    
                   tt_concil.dat_transacao     = b_tit_ap.dat_transacao  
                   tt_concil.cod_indic_econ    = b_tit_ap.cod_indic_econ 
                   tt_concil.val_sdo           = b_tit_ap.val_sdo        
                   tt_concil.log_conf          = YES
                   tt_concil.des_status        = "Seleciona para Abatimento ?".

            ASSIGN v_val_sdo = v_val_sdo + b_tit_ap.val_sdo_tit_ap.
        END.
    END.

    IF CAN-FIND(FIRST tt_concil
                WHERE tt_concil.num_id_tt_concil = v_rec_con
                  AND tt_concil.cod_tip_reg      = 2) THEN DO:

        /*
         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 3
                tt_concil.val_sdo           = v_val_sdo - tit_ap.val_sdo
                tt_concil.dat_transacao     = ?
                tt_concil.des_status        = "Gera AVA da Diferen‡a ?"
                tt_concil.log_conf          = NO.
          */
          
         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 4
                tt_concil.dat_transacao     = ?               
                tt_concil.val_sdo           = 0
                tt_concil.log_conf          = ?.
    END.
    ELSE DO:
         FIND tt_concil
             WHERE tt_concil.num_id_tt_concil = v_rec_con
               AND tt_concil.cod_tip_reg      = 1.
         DELETE tt_concil.
    END.
END PROCEDURE.

PROCEDURE pi_concil_importacao:
    DEFINE VARIABLE v_cod_tit_ap AS CHARACTER   NO-UNDO.

    ASSIGN v_cod_tit_ap = REPLACE(tit_ap.cod_tit_ap, ".", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "-", "").
    ASSIGN v_cod_tit_ap = REPLACE(v_cod_tit_ap, "_", "").

    ASSIGN v_val_sdo = 0.

    CREATE tt_concil.
    ASSIGN v_rec_con                   = RECID(tt_concil)
           tt_concil.num_id_tt_concil  = v_rec_con
           tt_concil.cod_tip_reg       = 1
           tt_concil.cod_estab         = tit_ap.cod_estab      
           tt_concil.cdn_fornec        = tit_ap.cdn_fornec     
           tt_concil.cod_espec         = tit_ap.cod_espec      
           tt_concil.cod_ser           = tit_ap.cod_ser        
           tt_concil.cod_tit_ap        = tit_ap.cod_tit_ap     
           tt_concil.cod_parcela       = tit_ap.cod_parcela    
           tt_concil.dat_transacao     = tit_ap.dat_transacao  
           tt_concil.cod_indic_econ    = tit_ap.cod_indic_econ 
           tt_concil.val_sdo           = tit_ap.val_sdo        
           tt_concil.log_conf          = YES
           tt_concil.des_status        = "Seleciona para Abatimento ?".

    FOR EACH b_estabelecimento NO-LOCK
        WHERE b_estabelecimento.cod_empresa = v_empresa:

        FOR EACH b_tit_ap NO-LOCK
            WHERE b_tit_ap.cod_estab  = b_estabelecimento.cod_estab
              AND b_tit_ap.cdn_fornec = tit_ap.cdn_fornec
              AND b_tit_ap.cod_espec  = v_especie /* esp‚cie DI para Importa‡äes/Impostos e DP para Fornecedores Nacionais */
              AND b_tit_ap.log_sdo_tit_ap
              AND b_tit_ap.cod_tit_ap BEGINS v_cod_tit_ap:

            IF LENGTH(b_tit_ap.cod_tit_ap) - LENGTH(v_cod_tit_ap) > 1 
               THEN NEXT.

            IF LENGTH(b_tit_ap.cod_tit_ap) > LENGTH(v_cod_tit_ap) THEN DO: 
                 IF LOOKUP(SUBSTRING(b_tit_ap.cod_tit_ap,LENGTH(b_tit_ap.cod_tit_ap),1),"0,1,2,3,4,5,6,7,8,9") = 0 
                    THEN NEXT.
            END.

            /*** Mais de uma AT, AI ou AR para o mesmo embarque, gera erro no lote de liquida‡Æo pois utilizamos a mesma DI/DP em mais de uma concilia‡Æo ***/
            FIND tt_concil NO-LOCK
                WHERE tt_concil.cod_tip_reg = 2
                  AND tt_concil.cod_estab   = b_tit_ap.cod_estab   
                  AND tt_concil.cdn_fornec  = b_tit_ap.cdn_fornec  
                  AND tt_concil.cod_espec   = b_tit_ap.cod_espec   
                  AND tt_concil.cod_ser     = b_tit_ap.cod_ser     
                  AND tt_concil.cod_tit_ap  = b_tit_ap.cod_tit_ap  
                  AND tt_concil.cod_parcela = b_tit_ap.cod_parcela NO-ERROR.

            IF  AVAIL tt_concil THEN 
                NEXT.

            CREATE tt_concil.
            ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                   tt_concil.cod_tip_reg       = 2
                   tt_concil.dat_transacao     = ?
                   tt_concil.cod_estab         = b_tit_ap.cod_estab      
                   tt_concil.cdn_fornec        = b_tit_ap.cdn_fornec     
                   tt_concil.cod_espec         = b_tit_ap.cod_espec      
                   tt_concil.cod_ser           = b_tit_ap.cod_ser        
                   tt_concil.cod_tit_ap        = b_tit_ap.cod_tit_ap     
                   tt_concil.cod_parcela       = b_tit_ap.cod_parcela    
                   tt_concil.dat_transacao     = b_tit_ap.dat_transacao  
                   tt_concil.cod_indic_econ    = b_tit_ap.cod_indic_econ 
                   tt_concil.val_sdo           = b_tit_ap.val_sdo        
                   tt_concil.log_conf          = YES
                   tt_concil.des_status        = "Seleciona para Abatimento ?".
            
            ASSIGN v_val_sdo = v_val_sdo + b_tit_ap.val_sdo_tit_ap.

            IF  tit_ap.val_sdo <> b_tit_ap.val_sdo THEN
                ASSIGN tt_concil.log_conf  = NO.
        END.
    END.

    IF CAN-FIND(FIRST tt_concil
                WHERE tt_concil.num_id_tt_concil = v_rec_con
                  AND tt_concil.cod_tip_reg      = 2) THEN DO:

        /*
         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 3
                tt_concil.val_sdo           = v_val_sdo - tit_ap.val_sdo
                tt_concil.dat_transacao     = ?
                tt_concil.des_status        = "Gera AVA da Diferen‡a ?"
                tt_concil.log_conf          = NO.
          */
          
         CREATE tt_concil.
         ASSIGN tt_concil.num_id_tt_concil  = v_rec_con
                tt_concil.cod_tip_reg       = 4
                tt_concil.dat_transacao     = ?               
                tt_concil.val_sdo           = 0
                tt_concil.log_conf          = ?.
    END.
    ELSE DO:
         FIND tt_concil
             WHERE tt_concil.num_id_tt_concil = v_rec_con
               AND tt_concil.cod_tip_reg      = 1.
         DELETE tt_concil.
    END.
END PROCEDURE.


PROCEDURE pi_atualizar:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_count         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_num_seq_refer AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE v_val_cotac_indic_econ LIKE val_movto_ap_correc_val.val_cotac_indic_econ NO-UNDO.
    DEFINE VARIABLE v_val_sdo_base         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_corrente     AS DECIMAL     NO-UNDO.

    FOR EACH  tt_concil
        WHERE tt_concil.cod_tip_reg = 3
          AND tt_concil.log_conf    = NO
          AND tt_concil.val_sdo    <> 0:

        FOR EACH btt_concil
              WHERE btt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil
                AND btt_concil.cod_tip_reg      < 3:
            ASSIGN btt_concil.log_conf = NO.
        END.
    END.

    trans_block:
    DO TRANSACTION:
    
        /* ** API Altera‡Æo ***/
        FOR EACH tt_concil
            WHERE tt_concil.cod_tip_reg = 3
              AND tt_concil.log_conf    = YES
              AND tt_concil.val_sdo    <> 0:
    
            IF tt_concil.val_sdo > 0 
            THEN DO:
                 FIND FIRST btt_concil
                      WHERE btt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil
                        AND btt_concil.cod_tip_reg      = 2 /* ** Localiza DP ***/
                        AND btt_concil.log_conf         = YES
                        AND btt_concil.val_sdo         >= tt_concil.val_sdo.
                 ASSIGN btt_concil.val_sdo = btt_concil.val_sdo - ABS(tt_concil.val_sdo).
            END.
            ELSE DO:
                 FIND btt_concil
                      WHERE btt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil
                        AND btt_concil.cod_tip_reg      = 1 /* ** Localiza AN ***/
                        AND btt_concil.log_conf         = YES.
                 ASSIGN btt_concil.val_sdo = btt_concil.val_sdo - ABS(tt_concil.val_sdo).
            END.
    
            FIND tit_ap NO-LOCK
                WHERE tit_ap.cod_estab   = btt_concil.cod_estab  
                  AND tit_ap.cdn_fornec  = btt_concil.cdn_fornec 
                  AND tit_ap.cod_espec   = btt_concil.cod_espec  
                  AND tit_ap.cod_ser     = btt_concil.cod_ser    
                  AND tit_ap.cod_tit_ap  = btt_concil.cod_tit_ap 
                  AND tit_ap.cod_parcela = btt_concil.cod_parcela NO-ERROR.
    
            ASSIGN v_num_seq_refer = v_num_seq_refer + 1.
    
            ASSIGN v_log_refer_uni = NO.
            REPEAT WHILE v_log_refer_uni = NO:
               RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_refer).
               
               RUN pi_verifica_refer_unica_apb (INPUT v_estabelecimento,
                                                INPUT v_cod_refer,
                                                OUTPUT v_log_refer_uni).
            END.
    
            CREATE tt_tit_ap_alteracao_base_aux_1.
            ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                   tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                   tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = v_dat_transacao
                   tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                   tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap - ABS(tt_concil.val_sdo)
                   tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = v_num_seq_refer
                   tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Baixa"
                   tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = tit_ap.ind_sit_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = tit_ap.dat_emis_docto
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = tit_ap.dat_vencto_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = tit_ap.dat_vencto_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = tit_ap.dat_prev_pagto
                   tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = tit_ap.num_dias_atraso
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = tit_ap.val_perc_multa_atraso
                   tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = tit_ap.val_juros_dia_atraso
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = tit_ap.val_perc_juros_dia_atraso
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = tit_ap.dat_desconto
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = tit_ap.val_perc_desc
                   tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = tit_ap.val_desconto
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ.
            VALIDATE tt_tit_ap_alteracao_base_aux_1.
    
            CREATE tt_tit_ap_alteracao_rateio.
            ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = RECID(tit_ap)
                   tt_tit_ap_alteracao_rateio.tta_cod_estab             = tit_ap.cod_estab
                   tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_rateio.tta_cod_refer             = v_cod_refer
                   tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = v_num_seq_refer
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = "PADRAO"
                   tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = v_cod_cta_ctbl
                   tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
                   tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor"
                   tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl        = ABS(tt_concil.val_sdo).
            VALIDATE tt_tit_ap_alteracao_rateio. 
    
        END.
    
        /* ** API Pagamento ***/
        ASSIGN v_log_refer_uni = NO.
        REPEAT WHILE v_log_refer_uni = NO:
           RUN pi_retorna_sugestao_referencia (INPUT "C",
                                               INPUT TODAY,
                                               OUTPUT v_cod_refer).
           
           RUN pi_verifica_refer_unica_apb (INPUT v_estabelecimento,
                                            INPUT v_cod_refer,
                                            OUTPUT v_log_refer_uni).
        END.
    
        CREATE tt_integr_apb_pagto.
        ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz          = "Lote"
               tt_integr_apb_pagto.ttv_log_atualiz_refer        = YES
               tt_integr_apb_pagto.ttv_log_gera_lote_parcial    = NO
               tt_integr_apb_pagto.tta_cod_empresa              = v_empresa
               tt_integr_apb_pagto.tta_cod_estab_refer          = v_estabelecimento
               tt_integr_apb_pagto.tta_cod_refer                = v_cod_refer
               tt_integr_apb_pagto.tta_dat_transacao            = v_dat_transacao
               tt_integr_apb_pagto.tta_cod_indic_econ           = "Real"
               tt_integr_apb_pagto.tta_cod_usuar_pagto          = v_cod_usuar_corren
               tt_integr_apb_pagto.tta_log_enctro_cta           = NO 
               tt_integr_apb_pagto.tta_val_tot_liquidac_tit_acr = 0 
               tt_integr_apb_pagto.ttv_rec_table_parent         = RECID(tt_integr_apb_pagto)
               tt_integr_apb_pagto.ttv_log_vinc_impto_auto      = NO
               tt_integr_apb_pagto.tta_cod_portador             = '999'.

        CREATE tt_integr_apb_pagto_aux.
        ASSIGN tt_integr_apb_pagto_aux.ttv_rec_table_parent     = tt_integr_apb_pagto.ttv_rec_table_parent
               tt_integr_apb_pagto_aux.tta_log_bxa_estab_tit_ap = YES.
    
        /* ** Leitura das ANs Selecionadas ***/
        FOR EACH tt_concil
            WHERE tt_concil.cod_tip_reg = 1
              AND tt_concil.log_conf    = YES:
    
            FIND b_tit_ap NO-LOCK
                WHERE b_tit_ap.cod_estab   = tt_concil.cod_estab  
                  AND b_tit_ap.cdn_fornec  = tt_concil.cdn_fornec 
                  AND b_tit_ap.cod_espec   = tt_concil.cod_espec  
                  AND b_tit_ap.cod_ser     = tt_concil.cod_ser    
                  AND b_tit_ap.cod_tit_ap  = tt_concil.cod_tit_ap 
                  AND b_tit_ap.cod_parcela = tt_concil.cod_parcela NO-ERROR.
    
            /* ** Leitura das DPs Selecionadas ***/
            FOR EACH btt_concil
                WHERE btt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil
                  AND btt_concil.cod_tip_reg      = 2
                  AND btt_concil.log_conf         = YES:
    
                /* ** Se a diferen‡a por + e nÆo for gerado AVA na DP, abater as DPs at‚ o saldo da AN ***/
                IF tt_concil.val_sdo = 0 
                   THEN NEXT.
                IF btt_concil.val_sdo > tt_concil.val_sdo 
                THEN DO:
                     ASSIGN btt_concil.val_sdo = tt_concil.val_sdo.
    
                END.
                /* ** Atualiza saldo da AN ***/
                ASSIGN tt_concil.val_sdo = tt_concil.val_sdo - btt_concil.val_sdo.
    
                FIND tit_ap NO-LOCK
                    WHERE tit_ap.cod_estab   = btt_concil.cod_estab  
                      AND tit_ap.cdn_fornec  = btt_concil.cdn_fornec 
                      AND tit_ap.cod_espec   = btt_concil.cod_espec  
                      AND tit_ap.cod_ser     = btt_concil.cod_ser    
                      AND tit_ap.cod_tit_ap  = btt_concil.cod_tit_ap 
                      AND tit_ap.cod_parcela = btt_concil.cod_parcela NO-ERROR.

                /* ** Localizar a cota‡Æo da AN para efetuar o pagamento ***/
                ASSIGN v_val_sdo_corrente     = 0
                       v_val_sdo_base         = 0
                       v_val_cotac_indic_econ = 1.

                FIND LAST movto_tit_ap NO-LOCK
                    WHERE  movto_tit_ap.cod_estab         = b_tit_ap.cod_estab
                      AND  movto_tit_ap.num_id_tit_ap     = b_tit_ap.num_id_tit_ap
                      AND  movto_tit_ap.log_movto_estordo = NO
                      AND (movto_tit_ap.ind_trans_ap      = "Corre‡Æo de Valor"
                      OR   movto_tit_ap.ind_trans_ap      = "Transf Estabelecimento"
                      OR   movto_tit_ap.ind_trans_ap      = "Implanta‡Æo"
                      OR   movto_tit_ap.ind_trans_ap      = "Corre‡Æo Valor no Pagto"
                      OR   movto_tit_ap.ind_trans_ap      = "Implanta‡Æo a Cr‚dito"
                      OR   movto_tit_ap.ind_trans_ap      = "Implanta‡Æo a D‚bito"
                      OR   movto_tit_ap.ind_trans_ap      = "Subst Nota por Duplicata") NO-ERROR.
                IF AVAIL movto_tit_ap 
                THEN DO:
                     FIND val_movto_ap_correc_val NO-LOCK
                        WHERE val_movto_ap_correc_val.cod_estab           = movto_tit_ap.cod_estab
                          AND val_movto_ap_correc_val.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                          AND val_movto_ap_correc_val.cod_finalid_econ    = "Corrente"
                          AND val_movto_ap_correc_val.ind_forma_conver    = "Multimoeda" NO-ERROR.
                     IF AVAIL val_movto_ap_correc_val 
                        THEN ASSIGN v_val_cotac_indic_econ = val_movto_ap_correc_val.val_cotac_indic_econ.
                END.
    
                CREATE tt_integr_apb_bord_lote_pagto.
                ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_empresa              = v_empresa
                       tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer     = v_estabelecimento
                       tt_integr_apb_bord_lote_pagto.tta_cod_refer                = v_cod_refer
                       tt_integr_apb_bord_lote_pagto.tta_cod_estab                = tit_ap.cod_estab
                       tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto          = tit_ap.cod_espec
                       tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto            = tit_ap.cod_ser
                       tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor           = tit_ap.cdn_fornecedor
                       tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap               = tit_ap.cod_tit_ap
                       tt_integr_apb_bord_lote_pagto.tta_cod_parcela              = tit_ap.cod_parcela
                       tt_integr_apb_bord_lote_pagto.tta_cod_portador             = "999"
                       tt_integr_apb_bord_lote_pagto.tta_ind_favorec_cheq         = 'Portador'
                       tt_integr_apb_bord_lote_pagto.tta_cod_indic_econ           = "Real"
                       tt_integr_apb_bord_lote_pagto.tta_val_pagto                = btt_concil.val_sdo / v_val_cotac_indic_econ
                       tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ     = v_val_cotac_indic_econ
                       tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_lote_bxa_ap = "Em Aberto"
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent         = tt_integr_apb_pagto.ttv_rec_table_parent
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_child          = recid(tt_integr_apb_bord_lote_pagto).
    
                CREATE tt_integr_apb_abat_antecip.
                ASSIGN tt_integr_apb_abat_antecip.ttv_rec_integr_apb_item_lote = tt_integr_apb_bord_lote_pagto.ttv_rec_table_child
                       tt_integr_apb_abat_antecip.tta_cod_estab                = b_tit_ap.cod_estab    
                       tt_integr_apb_abat_antecip.tta_cod_espec_docto          = b_tit_ap.cod_espec
                       tt_integr_apb_abat_antecip.tta_cod_ser_docto            = b_tit_ap.cod_ser  
                       tt_integr_apb_abat_antecip.tta_cdn_fornecedor           = b_tit_ap.cdn_fornecedor
                       tt_integr_apb_abat_antecip.tta_cod_tit_ap               = b_tit_ap.cod_tit_ap    
                       tt_integr_apb_abat_antecip.tta_cod_parcela              = b_tit_ap.cod_parcela 
                       tt_integr_apb_abat_antecip.tta_val_abat_tit_ap          = btt_concil.val_sdo  / v_val_cotac_indic_econ.
            END.
        END.
    
        /***************** Termino da cria‡Æo da temp_table dos itens do Lote/Bordero ****************/
    
        IF CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) 
           THEN RUN prgfin/apb/apb767ze.py(INPUT 1,
                                           INPUT "",
                                           INPUT "",
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                           OUTPUT TABLE  tt_log_erros_tit_ap_alteracao).
    
        IF NOT CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao)
        AND    CAN-FIND(FIRST tt_integr_apb_bord_lote_pagto)
        THEN DO:
    
             RUN prgfin/apb/apb902ze.py PERSISTENT SET v_hdl_apb902ze.
    
             RUN pi_main_code_api_integr_apb_pagto_4_evo_1 IN v_hdl_apb902ze (INPUT 1,
                                                                              INPUT TABLE tt_integr_apb_pagto,
                                                                              OUTPUT TABLE tt_log_erros_atualiz,
                                                                              INPUT TABLE tt_integr_apb_bord_lote_pagto,
                                                                              INPUT TABLE tt_integr_apb_abat_prev,
                                                                              INPUT TABLE tt_integr_apb_abat_antecip,
                                                                              INPUT TABLE tt_integr_apb_impto_impl_pend,
                                                                              INPUT "",
                                                                              INPUT TABLE tt_integr_cambio_ems5,
                                                                              INPUT TABLE tt_1099,
                                                                              INPUT TABLE tt_integr_apb_pagto_aux,
                                                                              INPUT TABLE tt_integr_apb_bord_lote_pg_a).
             DELETE PROCEDURE v_hdl_apb902ze.
        END.
    
        IF CAN-FIND(FIRST tt_log_erros_atualiz) 
        OR CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao) 
        THEN DO:
             UNDO trans_block, RETURN "Opera‡Æo Cancelada".
        END.
    
        ASSIGN v_des_contdo_prog_valid_dtsul = ""
               v_log_monit_tab_espec_financ  = NO.
        RETURN "OK".
    END.

    ASSIGN v_des_contdo_prog_valid_dtsul = ""
           v_log_monit_tab_espec_financ  = NO.

END PROCEDURE.


PROCEDURE pi_retorna_erros:

    DEF OUTPUT PARAM TABLE FOR tt_log_erros_tit_ap_alteracao.
    DEF OUTPUT PARAM TABLE FOR tt_log_erros_atualiz.

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
        format "Sim/NÆo"
        no-undo.

    /************************* Parameter Definition End *************************/

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
                     FIND FIRST tt_tit_ap_alteracao_base_aux_1 no-lock
                          WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL tt_tit_ap_alteracao_base_aux_1
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.
