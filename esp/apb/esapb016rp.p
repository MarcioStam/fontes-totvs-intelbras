{esp/es0018.i}
{utp/ut-glob.i}

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as INTEGER
    FIELD estabelec        AS CHAR
    FIELD portador         AS CHAR
    FIELD unid-negoc       AS CHAR.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

def temp-table tt_integr_apb_abat_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

def temp-table tt_integr_apb_antecip_pef_pend no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Referˆncia" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Cont bil" column-label "Natureza Cont bil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
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

def temp-table tt_relac_erro no-undo
    field tta_cod_refer                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_num_linha                    as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    index tt_refer                    
          tta_cod_refer                    ascending.


def temp-table tt_integr_apb_aprop_ctbl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field ttv_rec_integr_apb_impto_pend    as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
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

def temp-table tt_integr_apb_abat_prev_provis no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
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

def new shared temp-table tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 

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
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

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

def temp-table tt_integr_apb_abat_prev no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

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

def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

DEF TEMP-TABLE tt-arquivo NO-UNDO
    FIELD arquivo                 AS CHARACTER
    FIELD invalido                AS LOGICAL
    FIELD modificacao             AS DATE
    INDEX id arquivo.

DEF BUFFER b_tt_integr_apb_antecip_pef_pend FOR tt_integr_apb_antecip_pef_pend.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DEF VAR h-acomp AS HANDLE NO-UNDO.

def stream s_1.
def stream s_2.
def stream s_3.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE v_num_line            AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_nom_filename_import AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_reg_import      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_tip_reg         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_mensagem        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_nom_filename        AS CHARACTER   NO-UNDO.

def new shared var v_rpt_s_1_lines as integer initial 66.

DEFINE VARIABLE c-arq-importado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-log       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-file   AS CHARACTER NO-UNDO.
DEFINE VARIABLE arq-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-flag   AS CHARACTER NO-UNDO.


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp212_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

/*
OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
PUT STREAM str-excel UNFORMATTED "Origem;Destino;Item;Descricao;%ICMS;Item Faturavel" SKIP.
OUTPUT STREAM str-excel CLOSE.
*/


FOR EACH tt-arquivo: DELETE tt-arquivo. END.

INPUT FROM OS-DIR(tt-param.arq-entrada).    

REPEAT:
    IMPORT c-file arq-name c-flag.
    
    FILE-INFO:FILE-NAME = trim(arq-name).
    
    IF c-flag = "F" AND file-info:FILE-SIZE > 0 /*AND FILE-INFO:FILE-NAME MATCHES "*.txt"*/ THEN 
    DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Listando Arquivos.: " + arq-name).

        CREATE tt-arquivo.
        ASSIGN tt-arquivo.arquivo     = arq-name
               tt-arquivo.modificacao = DATE(FILE-INFO:FILE-MOD-DATE).
    END.   
END.

INPUT CLOSE.

OUTPUT stream s_1 TO value(tt-param.arq-destino) NO-MAP NO-CONVERT.

DEFINE VARIABLE c-status AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-log    AS CHARACTER NO-UNDO.

DEFINE VARIABLE ii AS INTEGER     NO-UNDO.

ii = 3.

FOR EACH tt-arquivo:

    ASSIGN tt-param.arq-entrada = REPLACE(tt-param.arq-entrada,'/','\')
           tt-arquivo.arquivo   = REPLACE(tt-arquivo.arquivo,'/','\').

    IF substring(tt-param.arq-entrada,length(tt-param.arq-entrada),1) <> '\' THEN
       ASSIGN tt-param.arq-entrada = tt-param.arq-entrada + '\'.

    ASSIGN ii = ii + 1.
    
    /*
    run pi_filename_validation (Input tt-arquivo.arquivo).

    IF RETURN-VALUE = 'NOK' THEN
       NEXT.
    */

    INPUT stream s_2 FROM value(tt-arquivo.arquivo) PAGED page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
    
    ASSIGN c-status = ''.

    run pi_rnl_histor_fornec_importar_ems (Input tt-arquivo.arquivo,OUTPUT c-status,OUTPUT c-log).

    INPUT stream s_2 close.         

    ASSIGN c-arq-importado = tt-param.arq-entrada + "importados\".
    ASSIGN c-arq-log       = tt-param.arq-entrada + "log\".

    
    OS-CREATE-DIR VALUE(c-arq-log).
    
    ASSIGN c-arq-log = c-arq-log + entry(NUM-ENTRIES(tt-arquivo.arquivo,'\'),tt-arquivo.arquivo,'\').

    OUTPUT STREAM s_3 TO value(c-arq-log).
    PUT STREAM s_3 UNFORMATTED c-log.
    OUTPUT STREAM s_3 CLOSE.

    IF c-status = 'OK' THEN //SEM ERROS NA IMPORTACAO DO ARQUIVO
    DO:
       OS-CREATE-DIR VALUE(c-arq-importado).
      
       ASSIGN c-arq-importado = c-arq-importado + entry(NUM-ENTRIES(tt-arquivo.arquivo,'\'),tt-arquivo.arquivo,'\').
       
       /*Copiar pasta Backup*/
       DOS SILENT COPY VALUE('"' + tt-arquivo.arquivo + '" "' + c-arq-importado + '"').
       
       /*Deletar arquivo*/
       IF SEARCH(c-arq-importado) <> ? THEN
          OS-DELETE value(tt-arquivo.arquivo).
    END.
END.

OUTPUT STREAM s_1 CLOSE.

RUN pi-finalizar IN h-acomp. 


/*
IF NOT OPSYS = "unix" THEN 
   DOS SILENT START /*excel*/ VALUE(c-arq-excel).
*/

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

/* FIM */


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




PROCEDURE pi_rnl_histor_fornec_importar_ems:       

    DEF INPUT  PARAM p-nome-arquivo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-status       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-log          AS CHAR NO-UNDO.

    DEF VAR v_dat_transacao AS DATE NO-UNDO.
    DEF VAR v_cod_refer     AS CHAR NO-UNDO.
    DEF VAR v_num_bord      AS INT  NO-UNDO.
    DEF VAR v_log_refer_uni AS LOG INIT NO NO-UNDO.
    DEF VAR v_log_avail_for AS LOG INIT NO NO-UNDO.
    DEF VAR v_des_mensagem-aux AS CHAR NO-UNDO.
    
    ASSIGN v_nom_filename_import = p-nome-arquivo.
    
    ASSIGN v_num_line = 0.
    
    INPUT FROM VALUE(v_nom_filename_import).
    
    import_block:
    REPEAT TRANSACTION:
    
        IMPORT UNFORMATTED v_des_reg_import.

        ASSIGN v_cod_tip_reg = SUBSTRING(v_des_reg_import, 42, 01)
               v_num_line    = v_num_line + 1.
    
        /* ** Registro Header e Trailer ***/
        IF SUBSTRING(v_des_reg_import, 01, 01) <> "1" THEN NEXT.
    
        /* ** Registro Movimento ***/
        IF v_cod_tip_reg = "1" THEN NEXT.
    
        /* ** Registro Portador ***/
        IF v_cod_tip_reg = "0" THEN 
        DO:  
             FIND fornec_financ NO-LOCK
                 WHERE fornec_financ.cod_empresa = v_cod_empres_usuar
                   AND fornec_financ.cdn_fornec  = INT(SUBSTRING(v_des_reg_import, 61, 11)) NO-ERROR.

             IF NOT AVAIL fornec_financ THEN 
             DO:
                  ASSIGN v_des_mensagem = SUBSTITUTE("Fornecedor nao localizado !", SUBSTRING(v_des_reg_import, 61, 11)).
                  RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").

                  PUT STREAM s_1 UNFORMATTED  
                      'Linha: 'v_num_line FORMAT  ">>,>>9"
                      ENTRY(1, RETURN-VALUE, CHR(255)) AT 20 FORMAT "x(50)".

                  PUT STREAM s_1 UNFORMATTED  
                      'Arquivo: ' + entry(num-entries(v_nom_filename_import,'\'),v_nom_filename_import,'\') AT 72 FORMAT 'x(50)'  SKIP.

                  RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").
                  ASSIGN v_log_avail_for = NO.

                  ASSIGN p-log = 'Data: '    + STRING(TODAY,'99/99/9999') + CHR(13) + 
                                 'Hora: '    + string(TIME,'HH:MM:SS')    + CHR(13) + 
                                 'Estab: '    + tt-param.estabelec        + CHR(13) +
                                 'Portador: ' + tt-param.portador         + CHR(13) +
                                 'Erro: '    + v_des_mensagem + ' - ' + 'Linha: ' + string(v_num_line). 

                  ASSIGN p-status = 'NOK'.

                  LEAVE IMPORT_block.
             END.
    
             ASSIGN v_log_avail_for = YES
                    v_log_refer_uni = NO.
    
             REPEAT WHILE v_log_refer_uni = NO:
                RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                    INPUT TODAY,
                                                    OUTPUT v_cod_refer).
                RUN pi_verifica_refer_unica_apb (INPUT tt-param.estabelec,
                                                 INPUT v_cod_refer,
                                                 OUTPUT v_log_refer_uni).
             END.
    
             CREATE tt_relac_erro.
             ASSIGN tt_relac_erro.tta_cod_refer = v_cod_refer
                    tt_relac_erro.ttv_num_linha = v_num_line.

             CREATE tt_integr_apb_antecip_pef_pend.
             ASSIGN tt_integr_apb_antecip_pef_pend.tta_cod_empresa           = v_cod_empres_usuar
                    tt_integr_apb_antecip_pef_pend.tta_cod_estab             = tt-param.estabelec
                    tt_integr_apb_antecip_pef_pend.tta_cod_refer             = v_cod_refer
                    tt_integr_apb_antecip_pef_pend.tta_cod_espec_docto       = "AP"
                    tt_integr_apb_antecip_pef_pend.tta_cod_ser_docto         = "U"
                    tt_integr_apb_antecip_pef_pend.tta_cdn_fornecedor        = INT(SUBSTRING(v_des_reg_import, 61, 11))
                    tt_integr_apb_antecip_pef_pend.tta_cod_parcela           = /*string(ii)*/ "1"
                    tt_integr_apb_antecip_pef_pend.tta_cod_indic_econ        = "Real"
                    tt_integr_apb_antecip_pef_pend.tta_cod_portador          = tt-param.portador //IF tt-param.estabelec = "102" THEN "3411" ELSE "341"
                    tt_integr_apb_antecip_pef_pend.tta_ind_tip_refer         = "Antecipa‡Æo"
                    tt_integr_apb_antecip_pef_pend.tta_ind_natur_cta_ctbl    = "DB"
                    tt_integr_apb_antecip_pef_pend.tta_cod_usuar_gerac_movto = v_cod_usuar_corren
                    tt_integr_apb_antecip_pef_pend.ttv_rec_antecip_pef_pend  = RECID(tt_integr_apb_antecip_pef_pend)  
                    tt_integr_apb_antecip_pef_pend.tta_ind_origin_tit_ap     = "APB"
                    tt_integr_apb_antecip_pef_pend.tta_val_cotac_indic_econ  = 1.
    
             CREATE tt_integr_apb_aprop_ctbl_pend.
             ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend = tt_integr_apb_antecip_pef_pend.ttv_rec_antecip_pef_pend
                    tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc       = tt-param.unid-negoc //"ADM"
                    tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ = "216".

             RUN pi-acompanhar IN h-acomp (INPUT 'Arquivo: ' + entry(num-entries(tt-arquivo.arquivo,'\'),tt-arquivo.arquivo,'\') + ' - ' +
                                                 STRING(tt_integr_apb_antecip_pef_pend.tta_cdn_fornecedor) ).
    
        END.
    
        /* ** Registro Resumo Portador ***/
        IF v_cod_tip_reg    = "2" AND 
           v_log_avail_for = YES  THEN 
        DO:
             ASSIGN tt_integr_apb_antecip_pef_pend.tta_cod_tit_ap            = SUBSTRING(v_des_reg_import, 81, 06)
                    tt_integr_apb_antecip_pef_pend.tta_val_tit_ap            = DEC(SUBSTRING(v_des_reg_import, 87, 18)) / 100
                    tt_integr_apb_antecip_pef_pend.tta_dat_emis_docto        = DATE(SUBSTRING(v_des_reg_import, 81, 06))
                    tt_integr_apb_antecip_pef_pend.tta_dat_vencto_tit_ap     = DATE(SUBSTRING(v_des_reg_import, 81, 06))
                    v_dat_transacao                                          = DATE(SUBSTRING(v_des_reg_import, 81, 06))
                    tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl         = tt_integr_apb_antecip_pef_pend.tta_val_tit_ap.
        END.
    END.
    
    IF CAN-FIND(FIRST tt_integr_apb_antecip_pef_pend) AND 
       v_log_avail_for = YES THEN 
    DO:
        cria_docto:
        DO TRANSACTION:

            RUN prgfin/apb/apb905za.py(INPUT 1,
                                       INPUT "",
                                       INPUT-OUTPUT TABLE tt_integr_apb_antecip_pef_pend,
                                       INPUT        TABLE tt_integr_apb_aprop_ctbl_pend,
                                       INPUT        TABLE tt_integr_apb_impto_impl_pend,
                                       INPUT        TABLE tt_integr_apb_abat_prev_provis,
                                       OUTPUT       TABLE tt_log_erros_atualiz).

            ASSIGN v_des_mensagem-aux = ''.
    
            FOR EACH tt_log_erros_atualiz:
    
                FIND tt_relac_erro 
                    WHERE tt_relac_erro.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.
                IF AVAIL tt_relac_erro 
                   THEN ASSIGN v_num_line = tt_relac_erro.ttv_num_linha.
                   ELSE ASSIGN v_num_line = 0.
    
                ASSIGN v_des_mensagem = "Erro API AN: " + tt_log_erros_atualiz.ttv_des_msg_erro.
                RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
                PUT STREAM s_1 UNFORMATTED  
                    'Linha: 'v_num_line FORMAT  ">>,>>9"
                    ENTRY(1, RETURN-VALUE, CHR(255)) AT 20 FORMAT "x(50)" .

                 PUT STREAM s_1 UNFORMATTED  
                     'Arquivo: ' + entry(num-entries(v_nom_filename_import,'\'),v_nom_filename_import,'\') AT 72 FORMAT 'x(50)'  SKIP.

                RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").

                ASSIGN v_des_mensagem-aux = v_des_mensagem-aux + v_des_mensagem + ' - ' + 'Linha: ' + string(v_num_line) + CHR(13).
    
            END.
    
            IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN 
            DO: 
                ASSIGN p-log = 'Data: '    + STRING(TODAY,'99/99/9999') + CHR(13) + 
                               'Hora: '    + string(TIME,'HH:MM:SS')    + CHR(13) + 
                               'Estab: '    + tt-param.estabelec        + CHR(13) +
                               'Portador: ' + tt-param.portador         + CHR(13) +
                               v_des_mensagem-aux. 

                ASSIGN p-status = 'NOK'.
                UNDO cria_docto, LEAVE cria_docto.
            END.
    
            FOR EACH tt_log_erros_atualiz:
                DELETE tt_log_erros_atualiz.
            END.
    
            /* ** Cria Border“ ***/
            CREATE tt_integr_apb_pagto.
            ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz       = "bordero"
                   tt_integr_apb_pagto.ttv_log_atualiz_refer     = NO 
                   tt_integr_apb_pagto.ttv_log_gera_lote_parcial = NO.
    
            FIND LAST bord_ap NO-LOCK
                 WHERE bord_ap.cod_estab_bord = tt-param.estabelec
                   AND bord_ap.cod_portador   = tt-param.portador //IF tt-param.estabelec = "102" THEN "3411" ELSE "341" NO-ERROR.
            NO-ERROR.

            IF AVAIL bord_ap THEN 
               ASSIGN v_num_bord = bord_ap.num_bord_ap + 1.
            ELSE 
               ASSIGN v_num_bord = 1.
    
            ASSIGN tt_integr_apb_pagto.tta_cod_empresa               = v_cod_empres_usuar
                   tt_integr_apb_pagto.tta_cod_estab_bord            = tt-param.estabelec
                   tt_integr_apb_pagto.tta_cod_portador              = tt-param.portador //IF tt-param.estabelec = "102" THEN "3411" ELSE "341"
                   tt_integr_apb_pagto.tta_num_bord_ap               = v_num_bord
                   tt_integr_apb_pagto.tta_log_bord_ap_escrit        = no
                   tt_integr_apb_pagto.tta_log_bord_ap_escrit_envdo  = no
                   tt_integr_apb_pagto.tta_ind_tip_bord_ap           = "Normal"
                   tt_integr_apb_pagto.tta_dat_transacao             = v_dat_transacao
                   tt_integr_apb_pagto.tta_cod_indic_econ            = "Real"
                   tt_integr_apb_pagto.tta_cod_finalid_econ          = "Corrente"
                   tt_integr_apb_pagto.tta_cod_usuar_pagto           = v_cod_usuar_corren
                   tt_integr_apb_pagto.ttv_rec_table_parent          = recid(tt_integr_apb_pagto).
    
            FOR EACH tt_integr_apb_antecip_pef_pend:
    
                create tt_integr_apb_bord_lote_pagto.
                assign tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = tt_integr_apb_antecip_pef_pend.tta_cod_empresa
                       tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer  = tt_integr_apb_antecip_pef_pend.tta_cod_estab
                       tt_integr_apb_bord_lote_pagto.tta_cod_portador          = tt_integr_apb_antecip_pef_pend.tta_cod_portador
                       tt_integr_apb_bord_lote_pagto.tta_cod_estab             = tt_integr_apb_antecip_pef_pend.tta_cod_estab
                       tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto       = tt_integr_apb_antecip_pef_pend.tta_cod_espec_docto
                       tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto         = tt_integr_apb_antecip_pef_pend.tta_cod_ser_docto
                       tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = tt_integr_apb_antecip_pef_pend.tta_cdn_fornecedor
                       tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap            = tt_integr_apb_antecip_pef_pend.tta_cod_tit_ap
                       tt_integr_apb_bord_lote_pagto.tta_cod_parcela           = tt_integr_apb_antecip_pef_pend.tta_cod_parcela
                       tt_integr_apb_bord_lote_pagto.tta_cod_refer_antecip_pef = tt_integr_apb_antecip_pef_pend.tta_cod_refer
                       tt_integr_apb_bord_lote_pagto.tta_val_pagto             = tt_integr_apb_antecip_pef_pend.tta_val_tit_ap
                       tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto       = "10"
                       tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_bord_ap  = ""
                       tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = no
                       tt_integr_apb_bord_lote_pagto.ttv_ind_forma_pagto       = "Informada"
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                       tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = recid(tt_integr_apb_bord_lote_pagto).             
    
            END.
    
            run prgfin/apb/apb902zc.py (Input 1,
                                        Input table tt_integr_apb_pagto,
                                        output table tt_log_erros_atualiz,
                                        Input table tt_integr_apb_bord_lote_pagto,
                                        Input table tt_integr_apb_abat_prev,
                                        Input table tt_integr_apb_abat_antecip,
                                        Input table tt_integr_apb_impto_impl_pend,
                                        Input "",
                                        Input table tt_integr_cambio_ems5,
                                        Input table tt_1099).

             ASSIGN v_des_mensagem-aux = ''.
    
            FOR EACH tt_log_erros_atualiz:
    
                FIND tt_relac_erro 
                    WHERE tt_relac_erro.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.
                IF AVAIL tt_relac_erro 
                   THEN ASSIGN v_num_line = tt_relac_erro.ttv_num_linha.
                   ELSE ASSIGN v_num_line = 0.
    
                ASSIGN v_des_mensagem = "Erro API Border“: " + tt_log_erros_atualiz.ttv_des_msg_erro.
                RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
                PUT STREAM s_1 UNFORMATTED  
                    'Linha: ' v_num_line FORMAT  ">>,>>9"
                    ENTRY(1, RETURN-VALUE, CHR(255)) AT 20 FORMAT "x(50)" .

                PUT STREAM s_1 UNFORMATTED  
                     'Arquivo: ' + entry(num-entries(v_nom_filename_import,'\'),v_nom_filename_import,'\') AT 72 FORMAT 'x(50)' SKIP.

                RUN pi_print_editor ("s_1", v_des_mensagem, "at031050", "", "", "", "").

                ASSIGN v_des_mensagem-aux = v_des_mensagem-aux + v_des_mensagem + ' - ' + 'Linha: ' + string(v_num_line) + CHR(13).
    
            END.
    
            IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN 
            DO: 
                ASSIGN p-log = 'Data: '     + STRING(TODAY,'99/99/9999') + CHR(13) + 
                               'Hora: '     + string(TIME,'HH:MM:SS')    + CHR(13) +
                               'Estab: '    + tt-param.estabelec         + CHR(13) +
                               'Portador: ' + tt-param.portador          + CHR(13) +
                               v_des_mensagem-aux. 

                ASSIGN p-status = 'NOK'.
                UNDO cria_docto, LEAVE cria_docto.
            END.

            IF p-status = 'NOK' THEN LEAVE.

            PUT STREAM s_1 UNFORMATTED  'Bordero gerado com sucesso: N.§ ' + string(v_num_bord) AT 1
                                        'Arquivo: ' + entry(num-entries(v_nom_filename_import,'\'),v_nom_filename_import,'\') AT 50 SKIP.

            ASSIGN p-log = 'Data : '    + STRING(TODAY,'99/99/9999') + CHR(13) + 
                           'Hora : '    + string(TIME,'HH:MM:SS')    + CHR(13) + 
                           'Estab: '    + tt-param.estabelec         + CHR(13) +
                           'Portador: ' + tt-param.portador          + CHR(13) +
                           'Bordero gerado com sucesso: N. ' + string(v_num_bord).

            // Botao Enviar Documento - Manutencao Bordero
            find bord_ap exclusive-lock
                         where bord_ap.cod_estab_bord = tt-param.estabelec 
                           and bord_ap.cod_portador   = tt-param.portador  
                           and bord_ap.num_bord_ap    = v_num_bord no-error.

            IF AVAIL bord_ap THEN
               assign bord_ap.ind_sit_bord_ap = "Enviado ao Banco".

    
            ASSIGN p-status = 'OK'. //SEM ERROS
        END.
    END.

END PROCEDURE.



PROCEDURE WinExec EXTERNAL 'kernel32.dll':
  DEF INPUT  PARAM prg_name   AS CHARACTER.
  DEF INPUT  PARAM prg_style  AS SHORT.
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
                                    put STREAM s_1 unformatted c_aux at i_pos[i_ind].
                                else
                                    put STREAM s_1 unformatted c_aux to i_pos[i_ind].
                        end.
            end.
        end.
        case p_stream:
        when "s_1" then
            put STREAM s_1 unformatted skip.
        end.
        if i_pos[1] = 0 then
            return c_ret.
    end.
    return c_ret.
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
                     FIND b_tt_integr_apb_antecip_pef_pend
                         WHERE b_tt_integr_apb_antecip_pef_pend.tta_cod_estab = p_cod_estab 
                           AND b_tt_integr_apb_antecip_pef_pend.tta_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL b_tt_integr_apb_antecip_pef_pend 
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.



