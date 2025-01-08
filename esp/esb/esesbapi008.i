def temp-table tt_acum_impto_pagto_api no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_dat_refer                    as date format "99/99/9999" initial ? label "Data Referˆncia" column-label "Data Referˆncia"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_acum_impto_retid_period  as decimal format ">>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Imposto Retido" column-label "Total Imposto Retido"
    index tt_ID                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_dat_refer                    ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending.

def temp-table tt_compl_retenc_impto_pagto_aux no-undo like compl_retenc_impto_pagto
    field ttv_rec_temp_table               as recid format ">>>>>>9"
    field tta_val_origin_tit_ap            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original".

def new shared temp-table tt_converter_finalid_econ no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transa‡Æo" column-label "Transa‡Æo"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma ConversÆo" column-label "Forma ConversÆo"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Corre‡Æo Monet ria" column-label "Corre‡Æo Monet ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".

def temp-table tt_dados_integr_apb_enc_ctas no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_val_tot_lote_pagto_efetd     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Pagamento" column-label "Total Pagamento"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_rec_integr_apb_enctro_cta    as recid format ">>>>>>9"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_log_bxa_estab_tit_ap         as logical format "Sim/NÆo" initial no label "Baixa Estabelec" column-label "Baixa Estabelec"
    field ttv_log_vinc_impto_auto          as logical format "Sim/NÆo" initial no label "PIS/COFINS/CSLL Auto"
    field ttv_rec_table_child              as recid format ">>>>>>9".

def new shared temp-table tt_dat_correc no-undo
    field ttv_dat_correc                   as date format "99/99/9999" initial today label "Data Corre‡Æo" column-label "Data Corre‡Æo".

def new shared temp-table tt_impostos_pis_cofins_csll_an no-undo
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field ttv_val_tot_abat_antecip         as decimal format "->>,>>>,>>>,>>9.99" decimals 2.

def new shared temp-table tt_integr_apb_abat_antecip_vouc no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_antecip_vouc  is primary unique
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

def temp-table tt_item_integr_apb_enc_ctas no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_ind_tit_orig                 as character format "X(08)"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field ttv_cod_tit                      as character format "x(18)"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_pagto                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagamento" column-label "Valor Pagto"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Valor Abatimento"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_rec_integr_apb_enctro_cta    as recid format ">>>>>>9"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_rec_table_child              as recid format ">>>>>>9".

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

def new shared temp-table tt_log_erros_tit_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field ttv_log_atlzdo                   as logical format "Sim/NÆo" initial yes
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_des_msg_erro_1               as character format "x(80)" label "Mensagem de Erro" column-label "Mensagem de Erro"
    field ttv_cod_bord_ap                  as character format "x(6)" label "Border“" column-label "Border“"
    field ttv_cod_seq_cheq                 as character format "x(2)" label "Sequˆncia" column-label "Sequˆncia".

def temp-table tt_log_integr_apb_enc_ctas no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".

def new shared temp-table tt_param_correc_val no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_cotac_fasb_emis          as decimal format ">>>>,>>9.9999999999" decimals 10
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field ttv_val_cotac_fasb_emis_antecip  as decimal format ">>>>,>>9.9999999999" decimals 10
    field ttv_val_cotac_cm_emis_antecip    as decimal format ">>>>,>>9.9999999999" decimals 10
    field ttv_val_movto                    as decimal format "->,>>>,>>>,>>9.99" decimals 2 label "Movimento" column-label "Valor Movto"
    field ttv_val_movto_antecip            as decimal format ">>>>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_base                 as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 label "Saldo Base".

def temp-table tt_pessoa_jurid_matriz no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    index tt_id                           
          tta_num_pessoa_jurid             ascending.

def temp-table tt_tit_acr_info no-undo like tit_acr
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida‡Æo" column-label "Vl Liquida‡Æo"
    field ttv_val_sdo_real                 as decimal format "->>,>>>,>>>,>>9.99" decimals 2.

def temp-table tt_trad_finalid_econ_ext no-undo like trad_finalid_econ_ext.
def temp-table tt_trad_org_ext no-undo like trad_org_ext.
def temp-table tt_trad_portad_ext no-undo like trad_portad_ext.

DEF TEMP-TABLE tt-titulo-acr NO-UNDO
    FIELD cod_estab       AS CHAR
    FIELD cod_espec_docto AS CHAR
    FIELD cod_ser_docto   AS CHAR
    FIELD cod_tit_acr     AS CHAR
    FIELD cod_parcela     AS CHAR
    FIELD canal-filial    AS INTEGER
    FIELD valor           AS DEC.
