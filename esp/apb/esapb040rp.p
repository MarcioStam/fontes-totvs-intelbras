
block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
//USING OpenEdge.Core.*. 
USING OpenEdge.Core.String.
//USING OpenEdge.Net.HTTP.*. 
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder. 
USING OpenEdge.Net.URI.
USING com.totvs.framework.api.*.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.

/*Define variaveis*/
def var p_num_vers_integr_api     as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)"   no-undo. 
DEF VAR c-lin                     AS CHAR                      NO-UNDO.
DEF VAR h-acomp                   AS HANDLE                    NO-UNDO.
DEF VAR c-cod-refer               AS CHAR                      NO-UNDO.

DEF TEMP-TABLE ttCC NO-UNDO XML-NODE-NAME 'cc'
    FIELD idm           AS INT XML-NODE-TYPE 'HIDDEN'
	FIELD federalId      AS CHAR  
    FIELD banco          AS CHAR  
    FIELD agencia        AS CHAR  
    FIELD contaCorrente  AS CHAR
    FIELD cod-emitente   LIKE emitente.cod-emitente.

DEFINE VARIABLE httpUrl AS CHARACTER NO-UNDO.

DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
 
DEFINE VARIABLE pJsonInput       AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonArrayRevenda  AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonObjectRevenda AS JsonObject   NO-UNDO. 
DEFINE VARIABLE iContRevenda      AS INT NO-UNDO.
DEFINE VARIABLE dt-ini           AS DATE FORMAT "99/99/9999" INITIAL 01/01/2023 NO-UNDO.

DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.
def new global shared var v_log_atualiza_refer_apb
    as logical
    format "Sim/NÆo"
    initial yes
    view-as toggle-box
    label "Atualiza Referˆncia"
    column-label "Atualiza Referˆncia"
    no-undo.

def NEW shared temp-table tt_integr_apb_abat_antecip_vouc no-undo
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
          tta_cod_parcela                  ascending
    .

def NEW shared temp-table tt_integr_apb_abat_prev_provis no-undo
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
          tta_cod_parcela                  ascending
    .

def NEW shared temp-table tt_integr_apb_aprop_ctbl_pend no-undo
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
          tta_cod_tip_fluxo_financ         ascending
    .

def temp-table tt_integr_apb_aprop_ctbl_pend2 no-undo
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
          tta_cod_tip_fluxo_financ         ascending
    .

def NEW shared temp-table tt_integr_apb_aprop_relacto no-undo
    field ttv_rec_integr_apb_relacto_pend  as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl"
    index tt_integr_apb_aprop_relacto      is primary unique
          ttv_rec_integr_apb_relacto_pend  ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    .

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
          ttv_rec_table_child              ascending
    .

def NEW shared temp-table tt_integr_apb_impto_impl_pend no-undo
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
          tta_cod_classif_impto            ascending
    .

def temp-table tt_integr_apb_impto_impl_pend1 no-undo
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
          tta_cod_classif_impto            ascending
    .

def NEW shared temp-table tt_integr_apb_item_lote_impl no-undo
    field ttv_rec_integr_apb_lote_impl     as recid format ">>>>>>9"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field ttv_qtd_parc_tit_ap              as decimal format ">>9" initial 1 label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_num_dias                     as integer format ">>>>,>>9" label "N£mero de Dias" column-label "N£mero de Dias"
    field ttv_ind_vencto_previs            as character format "X(4)" initial "Mˆs" label "C lculo Vencimento" column-label "C lculo Vencimento"
    field ttv_log_gerad                    as logical format "Sim/NÆo" initial no
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    index tt_item_lote_impl_ap_integr_id   is primary unique
          ttv_rec_integr_apb_lote_impl     ascending
          tta_num_seq_refer                ascending
    .

def NEW shared temp-table tt_integr_apb_lote_impl no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_val_tot_lote_impl_tit_ap     as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total  Movimento" column-label "Total Movto"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    index tt_lote_impl_tit_ap_integr_id    is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_cod_estab_ext                ascending
    .

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
          ttv_rec_table_parent             ascending
    .

def NEW shared temp-table tt_integr_apb_relacto_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field tta_cod_estab_tit_ap_pai         as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field tta_num_id_tit_ap_pai            as integer format "9999999999" initial 0 label "Token" column-label "Token"
    field tta_val_relacto_tit_ap           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera‡Æo" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    index tt_integr_apb_relacto_pend       is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab_tit_ap_pai         ascending
          tta_num_id_tit_ap_pai            ascending
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .

def NEW shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .

def temp-table tt_log_erros_atualiz_1 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .

def temp-table tt_log_erros_atualiz_bkp no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .
      
def temp-table tt_integr_apb_item_lote_impl_3 no-undo
    field ttv_rec_integr_apb_lote_impl     as recid format '>>>>>>9'
    field tta_num_seq_refer                as integer format '>>>9' initial 0 label 'Sequˆncia' column-label 'Seq'
    field tta_cdn_fornecedor               as Integer format '>>>,>>>,>>9' initial 0 label 'Fornecedor' column-label 'Fornecedor'
    field tta_cod_espec_docto              as character format 'x(3)' label 'Esp‚cie Documento' column-label 'Esp‚cie'
    field tta_cod_ser_docto                as character format 'x(3)' label 'S‚rie Documento' column-label 'S‚rie'
    field tta_cod_tit_ap                   as character format 'x(10)' label 'T¡tulo' column-label 'T¡tulo'
    field tta_cod_parcela                  as character format 'x(02)' label 'Parcela' column-label 'Parc'
    field tta_dat_emis_docto               as date format '99/99/9999' initial today label 'Data  EmissÆo' column-label 'Dt EmissÆo'
    field tta_dat_vencto_tit_ap            as date format '99/99/9999' initial today label 'Data Vencimento' column-label 'Dt Vencto'
    field tta_dat_prev_pagto               as date format '99/99/9999' initial today label 'Data Prevista Pgto' column-label 'Dt Prev Pagto'
    field tta_dat_desconto                 as date format '99/99/9999' initial ? label 'Data Desconto' column-label 'Dt Descto'
    field tta_cod_indic_econ               as character format 'x(8)' label 'Moeda' column-label 'Moeda'
    field tta_val_tit_ap                   as decimal format '->>>,>>>,>>9.99' decimals 2 initial 0 label 'Valor T¡tulo' column-label 'Valor T¡tulo'
    field tta_val_desconto                 as decimal format '->>>,>>>,>>9.99' decimals 2 initial 0 label 'Valor Desconto' column-label 'Valor Desconto'
    field tta_val_perc_desc                as decimal format '>9.9999' decimals 4 initial 0 label 'Percentual Desconto' column-label 'Perc Descto'
    field tta_num_dias_atraso              as integer format '>9' initial 0 label 'Dias Atraso' column-label 'Dias Atr'
    field tta_val_juros_dia_atraso         as decimal format '->>>,>>>,>>9.99' decimals 2 initial 0 label 'Valor Juro' column-label 'Vl Juro'
    field tta_val_perc_juros_dia_atraso    as decimal format '>9.999999' decimals 6 initial 00.00 label 'Perc Jur Dia Atraso' column-label 'Perc Dia'
    field tta_val_perc_multa_atraso        as decimal format '>9.99' decimals 2 initial 00.00 label 'Perc Multa Atraso' column-label 'Multa Atr'
    field tta_cod_portador                 as character format 'x(5)' label 'Portador' column-label 'Portador'
    field tta_cod_apol_seguro              as character format 'x(12)' label 'Ap¢lice Seguro' column-label 'Apolice Seguro'
    field tta_cod_seguradora               as character format 'x(8)' label 'Seguradora' column-label 'Seguradora'
    field tta_cod_arrendador               as character format 'x(6)' label 'Arrendador' column-label 'Arrendador'
    field tta_cod_contrat_leas             as character format 'x(12)' label 'Contrato Leasing' column-label 'Contr Leas'
    field tta_des_text_histor              as character format 'x(2000)' label 'Hist¢rico' column-label 'Hist¢rico'
    field tta_num_id_tit_ap                as integer format '9999999999' initial 0 label 'Token Tit AP' column-label 'Token Tit AP'
    field tta_num_id_movto_tit_ap          as integer format '9999999999' initial 0 label 'Token Movto Tit AP' column-label 'Id Tit AP'
    field tta_num_id_movto_cta_corren      as integer format '9999999999' initial 0 label 'ID Movto Conta' column-label 'ID Movto Conta'
    field ttv_qtd_parc_tit_ap              as decimal format '>>9' initial 1 label 'Quantidade Parcelas' column-label 'Quantidade Parcelas'
    field ttv_num_dias                     as integer format '>>>>,>>9' label 'N£mero de Dias' column-label 'N£mero de Dias'
    field ttv_ind_vencto_previs            as character format 'X(4)' initial 'Mˆs' label 'C lculo Vencimento' column-label 'C lculo Vencimento'
    field ttv_log_gerad                    as logical format 'Sim/NÆo' initial no
    field tta_cod_finalid_econ_ext         as character format 'x(8)' label 'Finalid Econ Externa' column-label 'Finalidade Externa'
    field tta_cod_portad_ext               as character format 'x(8)' label 'Portador Externo' column-label 'Portador Externo'
    field tta_cod_modalid_ext              as character format 'x(8)' label 'Modalidade Externa' column-label 'Modalidade Externa'
    field tta_cod_cart_bcia                as character format 'x(3)' label 'Carteira' column-label 'Carteira'
    field tta_cod_forma_pagto              as character format 'x(3)' label 'Forma Pagamento' column-label 'F Pagto'
    field tta_val_cotac_indic_econ         as decimal format '>>>>,>>9.9999999999' decimals 10 initial 0 label 'Cota‡Æo' column-label 'Cota‡Æo'
    field ttv_num_ord_invest               as integer format '>>>>>,>>9' initial 0 label 'Ordem Investimento' column-label 'Ordem Invest'
    field tta_cod_livre_1                  as character format 'x(100)' label 'Livre 1' column-label 'Livre 1'
    field tta_cod_livre_2                  as character format 'x(100)' label 'Livre 2' column-label 'Livre 2'
    field tta_dat_livre_1                  as date format '99/99/9999' initial ? label 'Livre 1' column-label 'Livre 1'
    field tta_dat_livre_2                  as date format '99/99/9999' initial ? label 'Livre 2' column-label 'Livre 2'
    field tta_log_livre_1                  as logical format 'Sim/NÆo' initial no label 'Livre 1' column-label 'Livre 1'
    field tta_log_livre_2                  as logical format 'Sim/NÆo' initial no label 'Livre 2' column-label 'Livre 2'
    field tta_num_livre_1                  as integer format '>>>>>9' initial 0 label 'Livre 1' column-label 'Livre 1'
    field tta_num_livre_2                  as integer format '>>>>>9' initial 0 label 'Livre 2' column-label 'Livre 2'
    field tta_val_livre_1                  as decimal format '>>>,>>>,>>9.9999' decimals 4 initial 0 label 'Livre 1' column-label 'Livre 1'
    field tta_val_livre_2                  as decimal format '>>>,>>>,>>9.9999' decimals 4 initial 0 label 'Livre 2' column-label 'Livre 2'
    field ttv_rec_integr_apb_item_lote     as recid format '>>>>>>9'
    field ttv_val_1099                     as decimal format '->>,>>>,>>>,>>9.99' decimals 2
    field tta_cod_tax_ident_number         as character format 'x(15)' label 'Tax Id Number' column-label 'Tax Id Number'
    field tta_ind_tip_trans_1099           as character format 'X(50)' initial 'Rents' label 'Tipo Transacao 1099' column-label 'Tipo Transacao 1099'
    field ttv_ind_tip_cod_barra            as character format 'X(01)'
    field tta_cb4_tit_ap_bco_cobdor        as Character format 'x(50)' label 'Titulo Bco Cobrador' column-label 'Titulo Bco Cobrador'
    field tta_cod_tit_ap_bco_cobdor        as character format 'x(20)' label 'T¡tulo Banco Cobdor' column-label 'T¡tulo Banco Cobdor'
    index tt_item_lote_impl_ap_integr_id   is primary unique
          ttv_rec_integr_apb_lote_impl     ascending
          tta_num_seq_refer                ascending
    .

DEF TEMP-TABLE ttRepasse NO-UNDO XML-NODE-NAME 'retorno'
    FIELD idm           AS INT XML-NODE-TYPE 'HIDDEN'
	FIELD establishment          AS CHAR  
    FIELD document_type          AS CHAR  
    FIELD document_series        AS CHAR  
    FIELD ctitle                 AS CHAR 
    FIELD allotment              AS CHAR 
    FIELD cnpj                   AS CHAR 
    FIELD transaction_date_timestamp       AS INT    
    FIELD document_issuance_date_timestamp AS INT    
    FIELD due_date_timestamp               AS INT 
    FIELD transaction_date       AS DATE    
    FIELD document_issuance_date AS DATE    
    FIELD due_date               AS DATE 
    FIELD payment_method         AS CHAR 
    FIELD indic_eco              AS CHAR 
    FIELD cvalue                 AS CHAR 
    FIELD carrier                AS CHAR 
    FIELD payment_flow           AS CHAR 
    FIELD accounting_account     AS CHAR 
    FIELD order_history          AS CHAR 
    FIELD cstatus                AS CHAR
    FIELD cod-emitente           LIKE emitente.cod-emitente. 


DEFINE VARIABLE jsonArrayOrders  AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonObjectOrders AS JsonObject   NO-UNDO. 
DEFINE VARIABLE iContOrders      AS INT NO-UNDO.

{include/i-prgvrs.i esapb040rp 2.00.00.001}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-prog-ponto2 LIKE tt-prog-ponto.
DEFINE TEMP-TABLE tt-prog-ponto3 LIKE tt-prog-ponto.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

EMPTY TEMP-TABLE tt-prog-ponto.
    
RUN esp/es0018p.p (INPUT "esapb040":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

EMPTY TEMP-TABLE tt-prog-ponto2.
    
RUN esp/es0018p.p (INPUT "esapb040":U,
                   INPUT 2,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto2).

EMPTY TEMP-TABLE tt-prog-ponto3.
    
RUN esp/es0018p.p (INPUT "esapb040":U,
                   INPUT 2,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto3).

FIND FIRST tt-param NO-ERROR.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

RUN pi-processa-conta-corrente.
RUN pi-processa-repasse-financ.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK".

PROCEDURE pi-processa-repasse-financ:
    
    SESSION:DEBUG-ALERT = TRUE.
    FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
        ASSIGN httpUrl = tt-prog-ponto.conteudo.
    ELSE
        ASSIGN httpUrl = "http://microintegrator-vtex-wso2-homolog.apps.intelbras.com.br/conciliacao/repasse".
    
    oRequest = RequestBuilder:GET(httpUrl)
                             :ContentType("application/json")
                             :AcceptAll()
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest).
    
    /*
    {
        "orders": [
            {
                "establishment": 104,
                "document_type": "DP",
                "document_series": "CF",
                "title": 43345,
                "allotment": 1,
                "cnpj": "12345876000178",
                "transaction_date": "01/12/2023",
                "document_issuance_date": "01/12/2023",
                "due_date": "10/12/2023",
                "payment_method": 50,
                "indic_eco": "real",
                "value": 3464.90,
                "carrier": 341,
                "payment_flow": 216,
                "accounting_account": 21210017,
                "order_history": "1234987-01",
                "status": "PAYMENT_RELEASED"
            }
        ]
    }
    */
    
    IF  oResponse:StatusCode = 200
    AND oResponse:ContentType = "application/json" THEN DO:
        ASSIGN pJsonInput = CAST(oResponse:Entity, JsonObject).
        ASSIGN jsonArrayOrders = pJsonInput:getJsonArray("orders").
    
        DO iContOrders = 1 TO jsonArrayOrders:LENGTH: 
            ASSIGN jsonObjectOrders = jsonArrayOrders:GetJsonObject(iContOrders).
            
            CREATE ttRepasse.
            ASSIGN ttRepasse.idm                    = iContOrders.
                   ttRepasse.establishment          = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "establishment")                                         .
                   ttRepasse.document_type          = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "document_type")                                         .
                   ttRepasse.document_series        = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "document_series")                                       .
                   ttRepasse.ctitle                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "title")                                                .
                   ttRepasse.allotment              = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "allotment")                                             .
                   ttRepasse.cnpj                   = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "cnpj")                                                  .
                   ttRepasse.transaction_date_timestamp       = INT(SUBSTRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "transaction_date"),1,10))       .
                   ttRepasse.document_issuance_date_timestamp = INT(SUBSTRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "document_issuance_date"),1,10)) .
                   ttRepasse.due_date_timestamp               = INT(SUBSTRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "due_date"),1,10))               .
                   ttRepasse.payment_method         = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "payment_method")                                        .
                   ttRepasse.indic_eco              = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "indic_eco")                                             .
                   ttRepasse.cvalue                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "value")                                                .
                   ttRepasse.carrier                = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "carrier")                                               .
                   ttRepasse.payment_flow           = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "payment_flow")                                          .
                   ttRepasse.accounting_account     = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "accounting_account")                                    .
                   ttRepasse.order_history          = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "order_history")                                         .
                   ttRepasse.cstatus                = JsonAPIUtils:getPropertyJsonObject(jsonObjectOrders, "status")                                               .
    
            ASSIGN ttRepasse.transaction_date       = dt-ini + ((ttRepasse.transaction_date_timestamp       - 1672531200) / 86400) - 1                              .
                   ttRepasse.document_issuance_date = dt-ini + ((ttRepasse.document_issuance_date_timestamp - 1672531200) / 86400) - 1                              .
                   ttRepasse.due_date               = dt-ini + ((ttRepasse.due_date_timestamp               - 1672531200) / 86400) - 1                              .
    
            FIND FIRST emitente
                 WHERE emitente.cgc = ttRepasse.cnpj NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN
                ASSIGN ttRepasse.cod-emitente = emitente.cod-emitente.
         /*            
            MESSAGE 
                ttRepasse.idm                    SKIP
                ttRepasse.establishment          SKIP
                ttRepasse.document_type          SKIP
                ttRepasse.document_series        SKIP
                ttRepasse.ctitle                 SKIP
                ttRepasse.allotment              SKIP
                ttRepasse.cnpj                   SKIP
                ttRepasse.transaction_date_timestamp       SKIP
                ttRepasse.document_issuance_date_timestamp SKIP
                ttRepasse.due_date_timestamp               SKIP
                ttRepasse.transaction_date       SKIP
                ttRepasse.document_issuance_date SKIP
                ttRepasse.due_date               SKIP
                ttRepasse.payment_method         SKIP
                ttRepasse.indic_eco              SKIP
                ttRepasse.cvalue                 SKIP
                ttRepasse.carrier                SKIP
                ttRepasse.payment_flow           SKIP
                ttRepasse.accounting_account     SKIP
                ttRepasse.order_history          SKIP
                ttRepasse.cstatus                SKIP
                ttRepasse.cod-emitente
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
               */
        END.
    END.
    
    IF CAN-FIND(FIRST ttRepasse) THEN DO:
        RUN pi-processa-repasse.
        RUN pi-processa-retorno-repasse.
    END.

END PROCEDURE.

PROCEDURE pi-processa-retorno-repasse:

    DEFINE VARIABLE arrayJson         AS jsonArray     NO-UNDO.
    DEFINE VARIABLE objPayment        AS JsonObject    NO-UNDO.
    DEFINE VARIABLE objJson           AS JsonObject    NO-UNDO.
    DEFINE VARIABLE l-retorna         AS LOGICAL       NO-UNDO.

    ASSIGN objJson     = NEW JsonObject().  
    ASSIGN arrayJson   = NEW JsonArray().

    FOR EACH ttRepasse:

        IF NOT CAN-FIND(FIRST tit_ap NO-LOCK
                        where tit_ap.cod_estab           = ttRepasse.establishment
                          and tit_ap.cod_espec_docto     = ttRepasse.document_type
                          and tit_ap.cod_ser_docto       = ttRepasse.document_series 
                          and tit_ap.cdn_fornecedor      = ttRepasse.cod-emitente
                          and tit_ap.cod_tit_ap          = ttRepasse.ctitle
                          and tit_ap.cod_parcela         = ttRepasse.allotment) THEN NEXT.

        FOR FIRST tit_ap NO-LOCK
            where tit_ap.cod_estab           = ttRepasse.establishment
              and tit_ap.cod_espec_docto     = ttRepasse.document_type
              and tit_ap.cod_ser_docto       = ttRepasse.document_series 
              and tit_ap.cdn_fornecedor      = ttRepasse.cod-emitente
              and tit_ap.cod_tit_ap          = ttRepasse.ctitle
              and tit_ap.cod_parcela         = ttRepasse.allotment,
            FIRST proces_pagto NO-LOCK
            where proces_pagto.cod_estab            = tit_ap.cod_estab
              and proces_pagto.cod_espec_docto      = tit_ap.cod_espec_docto
              and proces_pagto.cod_ser_docto        = tit_ap.cod_ser_docto
              and proces_pagto.cdn_fornecedor       = tit_ap.cdn_fornecedor
              and proces_pagto.cod_tit_ap           = tit_ap.cod_tit_ap
              and proces_pagto.cod_parcela          = tit_ap.cod_parcela
              and proces_pagto.ind_sit_proces_pagto = "Confirmado"
              and proces_pagto.dat_pagto            <> ?,
            FIRST histor_tit_movto_ap NO-LOCK
            WHERE histor_tit_movto_ap.cod_estab     = tit_ap.cod_estab
              and histor_tit_movto_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
              and histor_tit_movto_ap.ind_orig_histor_ap <> "Erro":
            
           ASSIGN objPayment  = NEW JsonObject().  
                  //objPayment:ADD("orderId"        , histor_tit_movto_ap.des_text_histor).     
                  objPayment:ADD("orderId"        , tit_ap.cod_tit_ap).     
                  objPayment:ADD("paymentDate"    , STRING(proces_pagto.dat_pagto,"99/99/9999")).
                  arrayJson:ADD(objPayment).
           
           ASSIGN l-retorna = YES.
           
        END.

        
        //HOMOLOGACAO
        FOR FIRST tit_ap NO-LOCK
            where tit_ap.cod_estab           = ttRepasse.establishment
              and tit_ap.cod_espec_docto     = ttRepasse.document_type
              and tit_ap.cod_ser_docto       = ttRepasse.document_series 
              and tit_ap.cdn_fornecedor      = ttRepasse.cod-emitente
              and tit_ap.cod_tit_ap          = ttRepasse.ctitle
              and tit_ap.cod_parcela         = ttRepasse.allotment:
            
           ASSIGN objPayment  = NEW JsonObject().  
                  //objPayment:ADD("orderId"        , histor_tit_movto_ap.des_text_histor).     
                  objPayment:ADD("orderId"        , ttRepasse.ctitle).     
                  objPayment:ADD("paymentDate"    , STRING(TODAY,"99/99/9999")).
                  arrayJson:ADD(objPayment).
           
           ASSIGN l-retorna = YES.
           
        END.
	    //HOMOLOGACAO
        

    END.

    IF l-retorna THEN DO:
        objJson:ADD("payment"         , arrayJson).
        
        /*
        MESSAGE STRING(objJson:getJsonText())
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            */

        FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.
        IF AVAIL tt-prog-ponto THEN
            ASSIGN httpUrl = tt-prog-ponto.conteudo.
        ELSE
            ASSIGN httpUrl = "http://microintegrator-vtex-wso2-homolog.apps.intelbras.com.br/conciliacao/repasse".

        oRequest = RequestBuilder:PUT(httpUrl, objJson)
                                 :ContentType("application/json")
                                 :AcceptAll()
                                 :Request.
        oResponse = ClientBuilder:Build():Client:Execute(oRequest).

        /*
        MESSAGE oResponse:StatusCode
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            */


       
    END.

END PROCEDURE.

PROCEDURE pi-processa-repasse:

    DEF VAR c-arquivo AS CHAR NO-UNDO.

    FIND FIRST tt-prog-ponto3 NO-LOCK NO-ERROR.
    IF AVAIL tt-prog-ponto3 THEN
        ASSIGN c-arquivo = tt-prog-ponto3.conteudo + "log-repasse.txt".
    ELSE
        ASSIGN c-arquivo = "\\soo-rpaloja-01\SHARED\LOG\log-repasse.txt".

    OUTPUT TO c-arquivo APPEND.
    
    FOR EACH ttRepasse:

        IF CAN-FIND(FIRST tit_ap NO-LOCK
                    where tit_ap.cod_estab           = ttRepasse.establishment
                      and tit_ap.cod_espec_docto     = ttRepasse.document_type
                      and tit_ap.cod_ser_docto       = ttRepasse.document_series 
                      and tit_ap.cdn_fornecedor      = ttRepasse.cod-emitente
                      and tit_ap.cod_tit_ap          = ttRepasse.ctitle
                      and tit_ap.cod_parcela         = ttRepasse.allotment) THEN NEXT.

        
        //MESSAGE ttRepasse.cnpj
            //VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        

        FIND FIRST emitente
             WHERE emitente.cgc = ttRepasse.cnpj NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.
        
        /* Atualiza lote sim ou nÆo */
        assign v_log_atualiza_refer_apb = YES.
         
        EMPTY TEMP-TABLE tt_integr_apb_lote_impl.
        EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
        EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
        EMPTY TEMP-TABLE tt_log_erros_atualiz.
        
        ASSIGN c-cod-refer = "".
        
        RUN pi-busca-referencia-apb (INPUT  "CFA",
                                     INPUT  ttRepasse.establishment,
                                     OUTPUT c-cod-refer).
        
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp(INPUT "Gerando t¡tulo APB ...." + STRING(c-cod-refer)).
        
        CREATE tt_integr_apb_lote_impl.
        ASSIGN tt_integr_apb_lote_impl.tta_cod_estab = ttRepasse.establishment
               tt_integr_apb_lote_impl.tta_cod_refer = c-cod-refer.
        
        ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = TODAY /*tt-titulo.dat_transacao*/
               tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                        
               tt_integr_apb_lote_impl.tta_cod_empresa       = "1".
        
        VALIDATE tt_integr_apb_lote_impl.
        
        CREATE tt_integr_apb_item_lote_impl_3.
        ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = RECID(tt_integr_apb_lote_impl)       
               tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = 1                                    
               tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = ttRepasse.cod-emitente                    
               tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = ttRepasse.document_type              
               tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = ttRepasse.document_series            
               tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = ttRepasse.ctitle                     
               tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = ttRepasse.allotment                  
               tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = DATE(ttRepasse.transaction_date)     
               tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = DATE(ttRepasse.due_date)             
               tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = DATE(ttRepasse.transaction_date)   //DATE(ttRepasse.document_issuance_date)
               tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = ttRepasse.payment_method             
               tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = ttRepasse.indic_eco                  
               tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = DEC(ttRepasse.cvalue)                
               tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = ttRepasse.carrier                    
               tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1                                    
               tt_integr_apb_item_lote_impl_3.tta_des_text_histor              = ttRepasse.order_history.
        
        VALIDATE tt_integr_apb_item_lote_impl_3.
        
        CREATE tt_integr_apb_aprop_ctbl_pend.
        ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3) 
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?                                     
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?                                     
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = "ADM"                                 
               tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = ttRepasse.payment_flow                
               tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = DEC(ttRepasse.cvalue)                 
               tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""                                    
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""                                    
               tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""                                    
               tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""                                    
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"                              
               tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = ttRepasse.accounting_account          
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = "PADRAO"
               tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = "".
        
        VALIDATE tt_integr_apb_aprop_ctbl_pend.
        
        assign p_num_vers_integr_api     = 3
               v_cod_matriz_trad_org_ext = "ems2".
        
        /*chamada da api*/ 
        run prgfin/apb/apb900zg.py persistent set v_hdl_aux.
        
        run pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (Input 5,
                                             Input v_cod_matriz_trad_org_ext,
                                             input-output table tt_integr_apb_item_lote_impl_3).
        
        IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
            PUT UNFORMATTED SKIP(2).
            PUT UNFORMATTED ";;;;;;;;;ERROS IMPLANTA€ÇO APB" SKIP.
            PUT UNFORMATTED "Estab;Esp;Ser;Titulo;Parcela;Fornec;Referˆncia;Num MSG;Erro;Ajuda" SKIP.
    
            FOR EACH tt_log_erros_atualiz:
                PUT UNFORMATTED ttRepasse.establishment                 ";"
                                ttRepasse.document_type                 ";"
                                ttRepasse.document_series               ";"
                                ttRepasse.ctitle                        ";"
                                ttRepasse.allotment                     ";"
                                ttRepasse.cnpj                          ";"
                                tt_log_erros_atualiz.tta_cod_refer      ";"
                                tt_log_erros_atualiz.ttv_num_mensagem   ";"
                                tt_log_erros_atualiz.ttv_des_msg_erro   ";"
                                tt_log_erros_atualiz.ttv_des_msg_ajuda  ";"
                                SKIP.
            END.
        END.

        delete procedure v_hdl_aux.
    END.
    
    OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-busca-referencia-apb:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/NÆo" INITIAL YES NO-UNDO.
    def var v_cod_refer     AS CHARACTER format "x(10)" NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia-apb (INPUT  p-sigla,
                                                OUTPUT v_cod_refer).

        run pi_verifica_refer_unica_apb (INPUT  p-cod-estabel,
                                         INPUT  v_cod_refer,
                                         INPUT  "lote_impl_tit_ap",
                                         INPUT  ?,
                                         OUTPUT v_log_refer_uni).
    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia-apb:
    DEF INPUT  param p_ind_tip_atualiz AS CHARACTER format "X(08)" NO-UNDO.
    DEF OUTPUT param p_cod_refer       AS CHARACTER format "x(10)" NO-UNDO.

    DEF VAR v_num_aux   AS INTEGER NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER NO-UNDO. 

    ASSIGN p_cod_refer = SUBSTRING(p_ind_tip_atualiz,1,4)
           v_num_aux_2 = INTEGER(this-procedure:handle).

    DO  v_num_cont = 1 TO 6:
        ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    END.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:
    DEF INPUT  PARAM p_cod_estab        AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer        AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table        AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_movto_tit_ap AS RECID     FORMAT ">>>>>>>>>>9" NO-UNDO. 
    DEF OUTPUT PARAM p_log_refer_uni    AS LOGICAL   FORMAT "Sim/NÆo" NO-UNDO.

    DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEF BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEF BUFFER b_lote_pagto       FOR lote_pagto.
    DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    find first b_antecip_pef_pend no-lock
         where b_antecip_pef_pend.cod_estab = p_cod_estab
           and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail b_antecip_pef_pend then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_impl_tit_ap no-lock
         where b_lote_impl_tit_ap.cod_estab = p_cod_estab
           and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
    if  avail b_lote_impl_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_pagto no-lock
         where b_lote_pagto.cod_estab_refer = p_cod_estab
           and b_lote_pagto.cod_refer = p_cod_refer no-error.
    if  avail b_lote_pagto then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_movto_tit_ap NO-LOCK where b_movto_tit_ap.cod_estab = p_cod_estab
           and b_movto_tit_ap.cod_refer = p_cod_refer
           and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
    if  avail b_movto_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.

END PROCEDURE.

PROCEDURE pi-processa-conta-corrente:
    
    SESSION:DEBUG-ALERT = TRUE.

    FIND FIRST tt-prog-ponto2 NO-LOCK NO-ERROR.
    IF AVAIL tt-prog-ponto2 THEN
        ASSIGN httpUrl = tt-prog-ponto2.conteudo.
    ELSE
        ASSIGN httpUrl = "http://microintegrator-vtex-wso2-homolog.apps.intelbras.com.br/conciliacao/contacorrente".
    
    oRequest = RequestBuilder:GET(httpUrl)
                             :ContentType("application/json")
                             :AcceptAll()
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest).
    
    /*
    {
        "revenda": [
            {
                "federalId": "82901000000127",
                "banco": 2,
                "agencia": "1235677",
                "contaCorrente": "9788877-7"
            },
            {
                "federalId": "97.211.155/0001-09",
                "banco": 25,
                "agencia": "4948-x",
                "contaCorrente": "2451110-0"
            }
        ]
    }
    */
    
    IF  oResponse:StatusCode = 200
    AND oResponse:ContentType = "application/json" THEN DO:
        ASSIGN pJsonInput = CAST(oResponse:Entity, JsonObject).
        ASSIGN jsonArrayRevenda = pJsonInput:getJsonArray("revenda").
    
        DO iContRevenda = 1 TO jsonArrayRevenda:LENGTH: 
            ASSIGN jsonObjectRevenda = jsonArrayRevenda:GetJsonObject(iContRevenda).
            
            CREATE ttCC.
            ASSIGN ttCC.idm            = iContRevenda
                   ttCC.federalId      = JsonAPIUtils:getPropertyJsonObject(jsonObjectRevenda, "federalId")      
                   ttCC.federalId      = REPLACE(REPLACE(REPLACE(ttCC.federalId,".",""),"-",""),"/","")          
                   ttCC.banco          = JsonAPIUtils:getPropertyJsonObject(jsonObjectRevenda, "banco")          
                   ttCC.agencia        = JsonAPIUtils:getPropertyJsonObject(jsonObjectRevenda, "agencia")        
                   ttCC.contaCorrente  = JsonAPIUtils:getPropertyJsonObject(jsonObjectRevenda, "contaCorrente").
    
            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp(INPUT "CNPJ: " + STRING(ttCC.federalId)).
    
            FIND FIRST emitente
                 WHERE emitente.cgc = ttCC.federalId NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN
                ASSIGN ttCC.cod-emitente = emitente.cod-emitente.
                     
            /*
            MESSAGE 
                ttCC.idm                    SKIP
                ttCC.federalId          SKIP
                ttCC.banco          SKIP
                ttCC.agencia        SKIP
                ttCC.contaCorrente              SKIP
                ttCC.cod-emitente
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                */
        END.
    END.
    
    IF CAN-FIND(FIRST ttCC) THEN DO:
        RUN pi-altera-conta.
        RUN pi-processa-retorno-conta.
    END.

END PROCEDURE.

PROCEDURE pi-processa-retorno-conta:

    DEFINE VARIABLE arrayJson         AS jsonArray     NO-UNDO.
    DEFINE VARIABLE objRetorno        AS JsonObject    NO-UNDO.
    DEFINE VARIABLE objJson           AS JsonObject    NO-UNDO.
    DEFINE VARIABLE l-retorna         AS LOGICAL       NO-UNDO.

    ASSIGN objJson     = NEW JsonObject().  
    ASSIGN arrayJson   = NEW JsonArray().

    FOR EACH ttCC:
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = ttCC.cod-emitente:
            IF emitente.cod-banco    = int(ttCC.banco)        
            OR emitente.agencia      = ttCC.agencia      
            OR emitente.conta-corren = ttCC.contaCorrente THEN DO:

                /*ASSIGN objRetorno  = NEW JsonObject().  
                        objRetorno:ADD("federalId"        , ttCC.federalId).     */
                arrayJson:ADD(ttCC.federalId).

                ASSIGN l-retorna = YES.

            END.
        END.
    END.

    IF l-retorna THEN DO:
        /*objJson:ADD('',arrayJson).
        MESSAGE STRING(objJson:getJsonText())
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

        FIND FIRST tt-prog-ponto2 NO-LOCK NO-ERROR.
        IF AVAIL tt-prog-ponto2 THEN
            ASSIGN httpUrl = tt-prog-ponto2.conteudo.
        ELSE
            ASSIGN httpUrl = "http://microintegrator-vtex-wso2-homolog.apps.intelbras.com.br/conciliacao/contacorrente".
        
        oRequest = RequestBuilder:PUT(httpUrl, arrayJson)
                                 :ContentType("application/json")
                                 :AcceptAll()
                                 :Request.
        oResponse = ClientBuilder:Build():Client:Execute(oRequest).

        /*
        MESSAGE oResponse:StatusCode
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            */
    END.

END PROCEDURE.

PROCEDURE pi-altera-conta:

    DEF VAR c-arquivo AS CHAR NO-UNDO.

    FIND FIRST tt-prog-ponto3 NO-LOCK NO-ERROR.
    IF AVAIL tt-prog-ponto3 THEN
        ASSIGN c-arquivo = tt-prog-ponto3.conteudo + "log-revenda-conta-corrente.txt".
    ELSE
        ASSIGN c-arquivo = "\\soo-rpaloja-01\SHARED\LOG\log-revenda-conta-corrente.txt".

    OUTPUT TO c-arquivo APPEND.
    
    FOR EACH ttCC:

        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = ttCC.cod-emitente:
            IF emitente.cod-banco    <> int(ttCC.banco)        
            OR emitente.agencia      <> ttCC.agencia      
            OR emitente.conta-corren <> ttCC.contaCorrente THEN DO:
                FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente.cod-banco    = int(ttCC.banco)
                       emitente.agencia      = ttCC.agencia
                       emitente.conta-corren = ttCC.contaCorrente.
                FIND CURRENT emitente NO-LOCK NO-ERROR.
    
                if  can-find(funcao where funcao.cd-funcao = "adm-cdc-ems-5.00"
                    and funcao.ativo = yes
                    and funcao.log-1 = yes) then do:
                    find first param-global NO-LOCK no-error.
                    if  param-global.log-2 = yes THEN DO: 
                        validate emitente no-error.
                        run cdp/cd1608.p (input emitente.cod-emitente,
                                          input emitente.cod-emitente,
                                          input emitente.identific,
                                          input yes,
                                          input 1,
                                          input 0,
                                          input "utb765zb.tmp",
                                          input "Arquivo":U,
                                          input "").
            
                    END.
                END.
            END.
        END.
    END.
    
    OUTPUT CLOSE.

END PROCEDURE.

