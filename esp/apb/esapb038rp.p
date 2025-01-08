/*****************************************************************************
** Programa..............: esp/apb/esapb038rp.p
** Descriá∆o.............: Pagamentos embarques bloomberg
** Autor.................: Andrey M Oliveira
** Criado em.............: 22/12/2021
*****************************************************************************/
{include/i-prgvrs.i esapb038rp 1.00.00.000}

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INT
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INT
    FIELD classifica       AS INT
    FIELD desc-classifica  AS CHAR FORMAT "x(40)":U
    FIELD margem           AS DEC FORMAT ">>9.99".

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE     FOR tt-raw-digita.

DEF BUFFER b_tit_ap  FOR tit_ap.
DEF BUFFER b_tit_ap2 FOR tit_ap.

DEF TEMP-TABLE tt_tit_ap_embarque NO-UNDO
    FIELD cod_estab       LIKE tit_ap.cod_estab      
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    FIELD cod_tit_ap      LIKE tit_ap.cod_tit_ap    
    FIELD cdn_fornec      LIKE tit_ap.cdn_fornecedor
    FIELD cod_portad      LIKE tit_ap.cod_portad
    FIELD val_cotac       LIKE val_tit_ap.val_cotac_indic_econ
    FIELD dat_transacao   LIKE tit_ap.dat_transacao
    FIELD val_baixa       LIKE tit_ap.val_sdo_tit_ap.  

DEF TEMP-TABLE tt_tit_ap_baixa NO-UNDO
    FIELD cod_estab       LIKE tit_ap.cod_estab      
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    FIELD cod_ser_docto   LIKE tit_ap.cod_ser_docto
    FIELD cod_tit_ap      LIKE tit_ap.cod_tit_ap 
    FIELD cod_parcela     LIKE tit_ap.cod_parcela
    FIELD cdn_fornec      LIKE tit_ap.cdn_fornecedor
    FIELD cod_portad      LIKE tit_ap.cod_portad
    FIELD val_cotac       LIKE val_tit_ap.val_cotac_indic_econ
    FIELD dat_transacao   LIKE tit_ap.dat_transacao
    FIELD val_baixa       LIKE tit_ap.val_sdo_tit_ap.

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

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
    field ttv_log_vinc_impto_auto          as logical initial NO
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_integr_apb_pagto_aux no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_log_bxa_estab_tit_ap         as logical format "Sim/N∆o" initial no label "Baixa Estabelec" column-label "Baixa Estabelec".

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
          ttv_rec_table_child              ascending.

def temp-table tt_integr_apb_abat_prev no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

def temp-table tt_integr_apb_abat_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9".

def temp-table tt_integr_apb_impto_impl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Inss" column-label "Deduá∆o Inss"
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Dependentes" column-label "Deduá∆o Dependentes"
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao Pens∆o" column-label "Deducao Pens∆o"
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Deduá‰es" column-label "Outras Deduá‰es"
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L°quida Imposto" column-label "Base L°quida Imposto"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al°quota" column-label "Aliq"
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J† Recolhido" column-label "Imposto J† Recolhido"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Deduá∆o"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
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

def temp-table tt_integr_apb_bord_lote_pg_a no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/N∆o" initial no.

def temp-table tt-erro no-undo
    field i-sequen         as int
    field tipo             as int
    field cod_estab        LIKE tit_ap.cod_estab      
    field cod_espec_docto  LIKE tit_ap.cod_espec_docto
    field cod_ser_docto    LIKE tit_ap.cod_ser_docto  
    field cod_tit_ap       LIKE tit_ap.cod_tit_ap    
    field cod_parcela      LIKE tit_ap.cod_parcela    
    field cdn_fornec       LIKE tit_ap.cdn_fornec
    field cd-erro          as int
    field mensagem         as char format "x(255)".

DEFINE TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nom-arquivo      AS CHARACTER
    FIELD nom-completo     AS CHARACTER
    FIELD ind-tipo-arquivo AS CHARACTER.

{esp/es0018.i}

DEF STREAM s_log.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR                                                      NO-UNDO.

DEF VAR h-acomp            AS HANDLE                      NO-UNDO.
DEF VAR v_dir_import       AS CHAR FORMAT "x(100)"        NO-UNDO.
DEF VAR v_dir_backup       AS CHAR FORMAT "x(100)"        NO-UNDO.
DEF VAR v_dir_log          AS CHAR FORMAT "x(100)"        NO-UNDO.
DEF VAR v_arq_log          AS CHAR FORMAT "x(100)"        NO-UNDO.
DEF VAR c-lin              AS CHAR                        NO-UNDO.
DEF VAR i-seq-erro-aux     AS INT                         NO-UNDO.
DEF VAR v_num_seq_refer    AS INT                         NO-UNDO.
DEF VAR v_num_bord         AS INT                         NO-UNDO.
DEF VAR v_hdl_apb902ze     AS HANDLE                      NO-UNDO.
DEF VAR v_val_sdo_tit_ap   LIKE val_tit_ap.val_sdo_tit_ap NO-UNDO.
DEF VAR v_val_sdo_acum     LIKE val_tit_ap.val_sdo_tit_ap NO-UNDO.
DEF VAR v_time             AS CHAR                        NO-UNDO.

DEFINE STREAM s_import.

EMPTY TEMP-TABLE tt_tit_ap_embarque.
EMPTY TEMP-TABLE tt-param.
EMPTY TEMP-TABLE tt-arquivo.
EMPTY TEMP-TABLE tt-erro.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

RUN esp/es0018p.p (INPUT "esapb038",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto NO-LOCK:
    
    IF  tt-prog-ponto.conteudo                    <> "":U 
    AND NUM-ENTRIES(tt-prog-ponto.conteudo, ";":U) > 1 THEN DO:

        IF  OPSYS = "WIN32":U THEN DO:
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BAIXASWIN":U THEN
                ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPWIN":U THEN
                ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGWIN":U THEN
                ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
        END.
        ELSE DO:
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BAIXASUNIX":U THEN
                ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPUNIX":U THEN
                ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGUNIX":U THEN
                ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
        END.
    END.
END.

ASSIGN v_dir_import   = REPLACE(v_dir_import,  "~\":U, "/":U)
       v_dir_backup   = REPLACE(v_dir_backup, "~\":U, "/":U)
       v_dir_log      = REPLACE(v_dir_log, "~\":U, "/":U)
       i-seq-erro-aux = 0.

FILE-INFO:FILE-NAME = v_dir_import.

IF  FILE-INFO:FULL-PATHNAME           = ?
OR  FILE-INFO:FULL-PATHNAME           = "":U 
OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq-erro-aux
           tt-erro.tipo     = 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = "Diret¢rio de baixas " + v_dir_import + " n∆o localizado.".
END.

FILE-INFO:FILE-NAME = v_dir_backup.

IF  FILE-INFO:FULL-PATHNAME           = ?    
OR  FILE-INFO:FULL-PATHNAME           = "":U 
OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq-erro-aux
           tt-erro.tipo     = 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = "Diret¢rio de backups " + v_dir_backup + " n∆o localizado.".
END.

FILE-INFO:FILE-NAME = v_dir_log.

IF  FILE-INFO:FULL-PATHNAME           = ?    
OR  FILE-INFO:FULL-PATHNAME           = "":U 
OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq-erro-aux
           tt-erro.tipo     = 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = "Diret¢rio de logs " + v_dir_backup + " n∆o localizado.".
END.

IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:

    INPUT STREAM s_import FROM OS-DIR(v_dir_import) NO-ECHO.
    REPEAT:
        CREATE tt-arquivo.
        IMPORT STREAM s_import tt-arquivo.nom-arquivo
                               tt-arquivo.nom-completo
                               tt-arquivo.ind-tipo-arquivo.
    END.
    INPUT STREAM s_import CLOSE.
    
    FOR EACH tt-arquivo:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo)).
    
        IF  NOT tt-arquivo.nom-arquivo BEGINS "bloomberg":U
        OR  tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN
            DELETE tt-arquivo.
    END.
    
    FOR EACH tt-arquivo:

        EMPTY TEMP-TABLE tt_tit_ap_embarque.
        EMPTY TEMP-TABLE tt_tit_ap_baixa.

        bloco_baixas:
        DO TRANSACTION ON ERROR UNDO bloco_baixas,  LEAVE bloco_baixas:
 
            INPUT FROM VALUE(tt-arquivo.nom-completo).
            IMPORT UNFORMATTED c-lin.
            
            REPEAT:
                IMPORT UNFORMATTED c-lin.
            
                CREATE tt_tit_ap_embarque.
                ASSIGN tt_tit_ap_embarque.cod_estab       = TRIM(ENTRY(1,c-lin,";"))
                       tt_tit_ap_embarque.cod_espec_docto = TRIM(ENTRY(4,c-lin,";"))
                       tt_tit_ap_embarque.cod_tit_ap      = TRIM(ENTRY(2,c-lin,";"))
                       tt_tit_ap_embarque.cdn_fornec      = INT(ENTRY(3,c-lin,";"))
                       tt_tit_ap_embarque.cod_portad      = TRIM(ENTRY(5,c-lin,";"))
                       tt_tit_ap_embarque.val_cotac       = DEC(ENTRY(6,c-lin,";"))
                       tt_tit_ap_embarque.dat_transacao   = DATE(ENTRY(7,c-lin,";"))
                       tt_tit_ap_embarque.val_baixa       = DEC(ENTRY(8,c-lin,";")).
            
                RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivo - Embarque: " + STRING(tt_tit_ap_embarque.cod_tit_ap)).
            END.
         
            ASSIGN v_num_seq_refer = 0
                   v_num_bord      = 0.
 
            EMPTY TEMP-TABLE tt_integr_apb_pagto.
            EMPTY TEMP-TABLE tt_log_erros_atualiz.
            EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pagto.
            EMPTY TEMP-TABLE tt_integr_apb_abat_prev.
            EMPTY TEMP-TABLE tt_integr_apb_abat_antecip.
            EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend.
            EMPTY TEMP-TABLE tt_integr_cambio_ems5.
            EMPTY TEMP-TABLE tt_1099.
            EMPTY TEMP-TABLE tt_integr_apb_pagto_aux.
            EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pg_a.

            FOR EACH tt_tit_ap_embarque NO-LOCK:
 
                RUN pi-acompanhar IN h-acomp (INPUT "Gerando borderì - Embarque: " + STRING(tt_tit_ap_embarque.cod_tit_ap)).
             
                FIND FIRST b_tit_ap
                     WHERE b_tit_ap.cod_estab          = tt_tit_ap_embarque.cod_estab
                     AND   b_tit_ap.cod_espec_docto    = tt_tit_ap_embarque.cod_espec_docto
                     AND   b_tit_ap.cdn_fornecedor     = tt_tit_ap_embarque.cdn_fornec
                     AND  (b_tit_ap.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap
                     OR    b_tit_ap.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap + "0")
                     AND   b_tit_ap.val_sdo_tit_ap     > 0   
                     AND   b_tit_ap.log_tit_ap_estordo = NO 
                     NO-LOCK NO-ERROR.

                IF  NOT AVAIL b_tit_ap THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                           tt-erro.tipo            = 2
                           tt-erro.cd-erro         = 17006
                           tt-erro.cod_estab       = tt_tit_ap_embarque.cod_estab           
                           tt-erro.cod_espec_docto = tt_tit_ap_embarque.cod_espec_docto
                           tt-erro.cod_ser_docto   = ""  
                           tt-erro.cod_tit_ap      = tt_tit_ap_embarque.cod_tit_ap     
                           tt-erro.cod_parcela     = ""   
                           tt-erro.cdn_fornec      = tt_tit_ap_embarque.cdn_fornec 
                           tt-erro.mensagem        = "Nao foram localizados titulos para o embarque.".
                END.
                
                FOR EACH tit_ap 
                    WHERE tit_ap.cod_estab       = tt_tit_ap_embarque.cod_estab
                    AND   tit_ap.cod_espec_docto = tt_tit_ap_embarque.cod_espec_docto
                    AND   tit_ap.cdn_fornecedor  = tt_tit_ap_embarque.cdn_fornec
                    AND   tit_ap.cod_tit_ap      = tt_tit_ap_embarque.cod_tit_ap
                      BREAK BY tit_ap.cod_tit_ap
                            BY tit_ap.cdn_fornec:
 
                    IF  tit_ap.val_sdo_tit_ap     = 0 
                    OR  tit_ap.log_tit_ap_estordo = YES THEN
                        NEXT.

                    IF  tit_ap.cod_indic_econ <> "Real" THEN
                        ASSIGN v_val_sdo_acum = v_val_sdo_acum + tit_ap.val_sdo_tit_ap.
                    ELSE
                        ASSIGN v_val_sdo_acum = v_val_sdo_acum + (tit_ap.val_sdo_tit_ap * tt_tit_ap_embarque.val_cotac).

                    IF  LAST-OF(tit_ap.cod_tit_ap)
                    OR  LAST-OF(tit_ap.cdn_fornec) THEN DO:
                        
                        FIND FIRST b_tit_ap 
                            WHERE b_tit_ap.cod_estab          = tt_tit_ap_embarque.cod_estab
                            AND   b_tit_ap.cod_espec_docto    = tt_tit_ap_embarque.cod_espec_docto
                            AND   b_tit_ap.cdn_fornecedor     = tt_tit_ap_embarque.cdn_fornec
                            AND   b_tit_ap.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap + "0"
                            AND   b_tit_ap.val_sdo_tit_ap     > 0   
                            AND   b_tit_ap.log_tit_ap_estordo = NO NO-LOCK NO-ERROR.
                        
                        IF  AVAIL b_tit_ap THEN DO:

                            FOR EACH b_tit_ap2 NO-LOCK
                                WHERE b_tit_ap2.cod_estab          = tt_tit_ap_embarque.cod_estab
                                AND   b_tit_ap2.cod_espec_docto    = tt_tit_ap_embarque.cod_espec_docto
                                AND   b_tit_ap2.cdn_fornecedor     = tt_tit_ap_embarque.cdn_fornec
                                AND   b_tit_ap2.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap + "0"
                                AND   b_tit_ap2.val_sdo_tit_ap     > 0   
                                AND   b_tit_ap2.log_tit_ap_estordo = NO:
                                
                                IF  b_tit_ap2.cod_indic_econ <> "Real" THEN
                                    ASSIGN v_val_sdo_acum = v_val_sdo_acum + b_tit_ap2.val_sdo_tit_ap.
                                ELSE
                                    ASSIGN v_val_sdo_acum = v_val_sdo_acum + (b_tit_ap2.val_sdo_tit_ap * tt_tit_ap_embarque.val_cotac).
                            END.
                        END.

                        IF  tt-param.margem > 0 THEN DO:

                            IF   tt_tit_ap_embarque.val_baixa > v_val_sdo_acum 
                            AND (tt_tit_ap_embarque.val_baixa - v_val_sdo_acum) > tt-param.margem THEN DO:    
                                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                       tt-erro.tipo            = 1
                                       tt-erro.cd-erro         = 17006
                                       tt-erro.cod_estab       = tit_ap.cod_estab           
                                       tt-erro.cod_espec_docto = tit_ap.cod_espec_docto
                                       tt-erro.cod_ser_docto   = tit_ap.cod_ser_docto  
                                       tt-erro.cod_tit_ap      = tit_ap.cod_tit_ap     
                                       tt-erro.cod_parcela     = tit_ap.cod_parcela    
                                       tt-erro.cdn_fornec      = tit_ap.cdn_fornecedor 
                                       tt-erro.mensagem        = "Valor da baixa nao pode ser superior ao saldo dos titulos.(1)".

                                UNDO bloco_baixas, LEAVE bloco_baixas.
                            END.

                            IF  tt_tit_ap_embarque.val_baixa < v_val_sdo_acum
                            AND (v_val_sdo_acum - tt_tit_ap_embarque.val_baixa) > tt-param.margem THEN DO:
                                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                       tt-erro.tipo            = 1
                                       tt-erro.cd-erro         = 17006
                                       tt-erro.cod_estab       = tit_ap.cod_estab           
                                       tt-erro.cod_espec_docto = tit_ap.cod_espec_docto
                                       tt-erro.cod_ser_docto   = tit_ap.cod_ser_docto  
                                       tt-erro.cod_tit_ap      = tit_ap.cod_tit_ap     
                                       tt-erro.cod_parcela     = tit_ap.cod_parcela    
                                       tt-erro.cdn_fornec      = tit_ap.cdn_fornecedor 
                                       tt-erro.mensagem        = "Valor da baixa inferior a margem parametrizada.".
                                
                                UNDO bloco_baixas, LEAVE bloco_baixas.
                            END.
                        END.
                        ELSE DO:
                            IF  tt_tit_ap_embarque.val_baixa > v_val_sdo_acum THEN DO:    
                                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                       tt-erro.tipo            = 1
                                       tt-erro.cd-erro         = 17006
                                       tt-erro.cod_estab       = tit_ap.cod_estab           
                                       tt-erro.cod_espec_docto = tit_ap.cod_espec_docto
                                       tt-erro.cod_ser_docto   = tit_ap.cod_ser_docto  
                                       tt-erro.cod_tit_ap      = tit_ap.cod_tit_ap     
                                       tt-erro.cod_parcela     = tit_ap.cod_parcela    
                                       tt-erro.cdn_fornec      = tit_ap.cdn_fornecedor 
                                       tt-erro.mensagem        = "Valor da baixa nao pode ser superior ao saldo dos titulos.(2)".

                                UNDO bloco_baixas, LEAVE bloco_baixas.
                            END.
                        END.

                        ASSIGN v_val_sdo_acum = 0.
                    END.

                    CREATE tt_tit_ap_baixa.
                    ASSIGN tt_tit_ap_baixa.cod_estab       = tit_ap.cod_estab      
                           tt_tit_ap_baixa.cod_espec_docto = tit_ap.cod_espec_docto
                           tt_tit_ap_baixa.cod_ser_docto   = tit_ap.cod_ser_docto  
                           tt_tit_ap_baixa.cod_tit_ap      = tit_ap.cod_tit_ap     
                           tt_tit_ap_baixa.cod_parcela     = tit_ap.cod_parcela    
                           tt_tit_ap_baixa.cdn_fornec      = tit_ap.cdn_fornec     
                           tt_tit_ap_baixa.cod_portad      = tt_tit_ap_embarque.cod_portad
                           tt_tit_ap_baixa.val_cotac       = tt_tit_ap_embarque.val_cotac
                           tt_tit_ap_baixa.dat_transacao   = tt_tit_ap_embarque.dat_transacao
                           tt_tit_ap_baixa.val_baixa       = IF  tt_tit_ap_embarque.val_baixa > tit_ap.val_sdo_tit_ap THEN 
                                                                 tit_ap.val_sdo_tit_ap 
                                                             ELSE 
                                                                 tit_ap.val_sdo_tit_ap /*tt_tit_ap_embarque.val_baixa*/.

                    FIND FIRST b_tit_ap 
                        WHERE b_tit_ap.cod_estab          = tt_tit_ap_embarque.cod_estab
                        AND   b_tit_ap.cod_espec_docto    = tt_tit_ap_embarque.cod_espec_docto
                        AND   b_tit_ap.cdn_fornecedor     = tt_tit_ap_embarque.cdn_fornec
                        AND   b_tit_ap.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap + "0"
                        AND   b_tit_ap.val_sdo_tit_ap     > 0   
                        AND   b_tit_ap.log_tit_ap_estordo = NO NO-LOCK NO-ERROR.
                    
                    IF  AVAIL b_tit_ap THEN DO:

                        FOR EACH b_tit_ap2 NO-LOCK
                            WHERE b_tit_ap2.cod_estab          = tt_tit_ap_embarque.cod_estab
                            AND   b_tit_ap2.cod_espec_docto    = tt_tit_ap_embarque.cod_espec_docto
                            AND   b_tit_ap2.cdn_fornecedor     = tt_tit_ap_embarque.cdn_fornec
                            AND   b_tit_ap2.cod_tit_ap         = tt_tit_ap_embarque.cod_tit_ap + "0"
                            AND   b_tit_ap2.val_sdo_tit_ap     > 0   
                            AND   b_tit_ap2.log_tit_ap_estordo = NO:
                            
                            FIND FIRST tt_tit_ap_baixa
                                WHERE tt_tit_ap_baixa.cod_estab       = b_tit_ap2.cod_estab      
                                AND   tt_tit_ap_baixa.cod_espec_docto = b_tit_ap2.cod_espec_docto
                                AND   tt_tit_ap_baixa.cod_ser_docto   = b_tit_ap2.cod_ser_docto  
                                AND   tt_tit_ap_baixa.cod_tit_ap      = b_tit_ap2.cod_tit_ap     
                                AND   tt_tit_ap_baixa.cod_parcela     = b_tit_ap2.cod_parcela    
                                AND   tt_tit_ap_baixa.cdn_fornec      = b_tit_ap2.cdn_fornec NO-LOCK NO-ERROR.  

                            IF  NOT AVAIL tt_tit_ap_baixa THEN DO:
                                CREATE tt_tit_ap_baixa.
                                ASSIGN tt_tit_ap_baixa.cod_estab       = b_tit_ap2.cod_estab      
                                       tt_tit_ap_baixa.cod_espec_docto = b_tit_ap2.cod_espec_docto
                                       tt_tit_ap_baixa.cod_ser_docto   = b_tit_ap2.cod_ser_docto  
                                       tt_tit_ap_baixa.cod_tit_ap      = b_tit_ap2.cod_tit_ap     
                                       tt_tit_ap_baixa.cod_parcela     = b_tit_ap2.cod_parcela    
                                       tt_tit_ap_baixa.cdn_fornec      = b_tit_ap2.cdn_fornec     
                                       tt_tit_ap_baixa.cod_portad      = tt_tit_ap_embarque.cod_portad
                                       tt_tit_ap_baixa.val_cotac       = tt_tit_ap_embarque.val_cotac
                                       tt_tit_ap_baixa.dat_transacao   = tt_tit_ap_embarque.dat_transacao
                                       tt_tit_ap_baixa.val_baixa       = IF  tt_tit_ap_embarque.val_baixa > b_tit_ap2.val_sdo_tit_ap THEN 
                                                                             b_tit_ap2.val_sdo_tit_ap 
                                                                         ELSE 
                                                                             b_tit_ap2.val_sdo_tit_ap /*tt_tit_ap_embarque.val_baixa*/.
                            END.
                        END.
                    END.
                END.
            END.

            FOR EACH tt_tit_ap_baixa
                BREAK BY tt_tit_ap_baixa.cod_portad
                      BY tt_tit_ap_baixa.dat_transacao:

                FIND FIRST tit_ap
                    WHERE tit_ap.cod_estab       = tt_tit_ap_baixa.cod_estab      
                    AND   tit_ap.cod_espec_docto = tt_tit_ap_baixa.cod_espec_docto
                    AND   tit_ap.cod_ser_docto   = tt_tit_ap_baixa.cod_ser_docto  
                    AND   tit_ap.cod_tit_ap      = tt_tit_ap_baixa.cod_tit_ap     
                    AND   tit_ap.cod_parcela     = tt_tit_ap_baixa.cod_parcela    
                    AND   tit_ap.cdn_fornec      = tt_tit_ap_baixa.cdn_fornec NO-LOCK NO-ERROR.  

                IF  AVAIL tit_ap THEN DO:

                    ASSIGN v_num_seq_refer = v_num_seq_refer + 1.

                    IF  FIRST-OF(tt_tit_ap_baixa.cod_portad)
                    OR  FIRST-OF(tt_tit_ap_baixa.dat_transacao) THEN DO:

                        /*** Cria Borderì ***/
                        CREATE tt_integr_apb_pagto.
                        ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz       = "bordero"
                               tt_integr_apb_pagto.ttv_log_atualiz_refer     = NO 
                               tt_integr_apb_pagto.ttv_log_gera_lote_parcial = NO.
 
                        IF  v_num_bord = 0 THEN DO:
                            FIND LAST bord_ap
                                WHERE bord_ap.cod_estab_bord = "101"
                                AND   bord_ap.cod_portador   = tt_tit_ap_baixa.cod_portad NO-LOCK NO-ERROR.
 
                            IF  AVAIL bord_ap THEN DO:
                                ASSIGN v_num_bord = bord_ap.num_bord_ap + 1.
                            END.
                            ELSE DO:
                                ASSIGN v_num_bord = 1.
                            END.
                        END.
                        ELSE
                            ASSIGN v_num_bord = v_num_bord + 1.
 
                        ASSIGN tt_integr_apb_pagto.tta_cod_empresa               = v_cod_empres_usuar
                               tt_integr_apb_pagto.tta_cod_estab_bord            = "101" /* ficou definido que ser† sempre gerado no 101 */
                               tt_integr_apb_pagto.tta_cod_portador              = tt_tit_ap_baixa.cod_portad
                               tt_integr_apb_pagto.tta_num_bord_ap               = v_num_bord
                               tt_integr_apb_pagto.tta_log_bord_ap_escrit        = NO
                               tt_integr_apb_pagto.tta_log_bord_ap_escrit_envdo  = NO
                               tt_integr_apb_pagto.tta_ind_tip_bord_ap           = "Normal"
                               tt_integr_apb_pagto.tta_dat_transacao             = tt_tit_ap_baixa.dat_transacao
                               tt_integr_apb_pagto.tta_cod_indic_econ            = "Real"
                               tt_integr_apb_pagto.tta_cod_finalid_econ          = "Corrente"
                               tt_integr_apb_pagto.tta_cod_usuar_pagto           = v_cod_usuar_corren
                               tt_integr_apb_pagto.ttv_rec_table_parent          = recid(tt_integr_apb_pagto)
                               tt_integr_apb_pagto.ttv_log_vinc_impto_auto       = YES.

                        CREATE tt_integr_apb_pagto_aux.
                        ASSIGN tt_integr_apb_pagto_aux.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                               tt_integr_apb_pagto_aux.tta_log_bxa_estab_tit_ap  = NO.

                    END.

                    IF  LAST-OF(tt_tit_ap_baixa.cod_portad) THEN
                        ASSIGN v_num_bord = 0.

                    IF  tit_ap.cod_indic_econ <> "Real" THEN DO:
                        IF  tt_tit_ap_baixa.val_baixa > tit_ap.val_sdo_tit_ap THEN 
                            ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap * tt_tit_ap_baixa.val_cotac.
                        ELSE
                            ASSIGN v_val_sdo_tit_ap = tt_tit_ap_baixa.val_baixa * tt_tit_ap_baixa.val_cotac.
                    END.
                    ELSE DO:
                        IF  tt_tit_ap_baixa.val_baixa > (tit_ap.val_sdo_tit_ap / tt_tit_ap_baixa.val_cotac) THEN 
                            ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap.
                        ELSE
                            ASSIGN v_val_sdo_tit_ap = (tt_tit_ap_baixa.val_baixa * tt_tit_ap_baixa.val_cotac).
                    END.

                    CREATE tt_integr_apb_bord_lote_pagto.
                    ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = v_cod_empres_usuar
                           tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer  = tit_ap.cod_estab  
                           tt_integr_apb_bord_lote_pagto.tta_cod_portador          = tit_ap.cod_portad 
                           tt_integr_apb_bord_lote_pagto.tta_cod_estab             = tit_ap.cod_estab
                           tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto       = tit_ap.cod_espec_docto
                           tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto         = tit_ap.cod_ser_docto
                           tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = tit_ap.cdn_fornec
                           tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap            = tit_ap.cod_tit_ap
                           tt_integr_apb_bord_lote_pagto.tta_cod_parcela           = tit_ap.cod_parcela
                           tt_integr_apb_bord_lote_pagto.tta_val_pagto             = v_val_sdo_tit_ap
                           tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ  = IF tit_ap.cod_indic_econ <> "Real" THEN (1 / tt_tit_ap_baixa.val_cotac) /* cotacao inversa */ ELSE 1
                           tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto       = "70"
                           tt_integr_apb_bord_lote_pagto.tta_cod_indic_econ        = "Real"
                           tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_bord_ap  = "Enviado ao Banco"
                           tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = NO
                           tt_integr_apb_bord_lote_pagto.ttv_ind_forma_pagto       = "Informada"
                           tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                           tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = RECID(tt_integr_apb_bord_lote_pagto).
                END.    
            END.

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

            IF  CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
                FOR EACH tt_log_erros_atualiz:
                    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                           tt-erro.tipo            = 1
                           tt-erro.cd-erro         = tt_log_erros_atualiz.ttv_num_mensagem
                           tt-erro.mensagem        = tt_log_erros_atualiz.ttv_des_msg_erro + tt_log_erros_atualiz.ttv_des_msg_ajuda.

                    UNDO bloco_baixas, LEAVE bloco_baixas.
                END.
            END.
            ELSE DO:
                FOR EACH tt_integr_apb_pagto NO-LOCK:
                    FOR EACH tt_integr_apb_bord_lote_pagto OF tt_integr_apb_pagto:
                        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.

                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                               tt-erro.tipo            = 2
                               tt-erro.cod_estab       = tt_integr_apb_bord_lote_pagto.tta_cod_estab           
                               tt-erro.cod_espec_docto = tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto
                               tt-erro.cod_ser_docto   = tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto  
                               tt-erro.cod_tit_ap      = tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap     
                               tt-erro.cod_parcela     = tt_integr_apb_bord_lote_pagto.tta_cod_parcela    
                               tt-erro.cdn_fornec      = tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor 
                               tt-erro.cd-erro         = 0
                               tt-erro.mensagem        = "Bordero Gerado: " + tt_integr_apb_pagto.tta_cod_estab_bord      + "-" 
                                                                            + tt_integr_apb_pagto.tta_cod_portador        + "-" 
                                                                            + string(tt_integr_apb_pagto.tta_num_bord_ap) + "-" 
                                                                            + string(tt_integr_apb_pagto.tta_dat_transacao).
                    END.
                END.
            END.

            EMPTY TEMP-TABLE tt_integr_apb_pagto.
            EMPTY TEMP-TABLE tt_log_erros_atualiz.
            EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pagto.
            EMPTY TEMP-TABLE tt_integr_apb_abat_prev.
            EMPTY TEMP-TABLE tt_integr_apb_abat_antecip.
            EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend.
            EMPTY TEMP-TABLE tt_integr_cambio_ems5.
            EMPTY TEMP-TABLE tt_1099.
            EMPTY TEMP-TABLE tt_integr_apb_pagto_aux.
            EMPTY TEMP-TABLE tt_integr_apb_bord_lote_pg_a.
        END.
        
        IF  NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
            OS-COPY   VALUE(tt-arquivo.nom-completo) VALUE(v_dir_backup + tt-arquivo.nom-arquivo).
            OS-DELETE VALUE(tt-arquivo.nom-completo) NO-ERROR.
        END.

        ASSIGN v_time = string(TIME,"HH:MM:SS").

        ASSIGN v_arq_log = v_dir_log + "log_" + SUBSTR(v_time,1,2) + SUBSTR(v_time,4,2) + SUBSTR(v_time,7,2) + "_" + tt-arquivo.nom-arquivo.

        OUTPUT STREAM s_log TO VALUE(v_arq_log).

        PUT STREAM s_log UNFORMATTED "Erros;;;;;;" SKIP.
        PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;Titulo;Parc;Fornec;Cod Erro;Mensagem" SKIP.

        FOR EACH tt-erro
            WHERE tt-erro.tipo = 1:

            PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                 tt-erro.cod_espec_docto      ";"
                 tt-erro.cod_ser_docto        ";"
                 tt-erro.cod_tit_ap           ";"
                 tt-erro.cod_parcela          ";"
                 tt-erro.cdn_fornec           ";"
                 tt-erro.cd-erro              ";"
                 tt-erro.mensagem SKIP.
        END.

        PUT STREAM s_log UNFORMATTED SKIP(2) "Bordero Gerado;;;;;" SKIP.
        PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;Titulo;Parc;Fornec;Mensagem" SKIP.
        FOR EACH tt-erro
            WHERE tt-erro.tipo = 2:

            PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                 tt-erro.cod_espec_docto      ";"
                 tt-erro.cod_ser_docto        ";"
                 tt-erro.cod_tit_ap           ";"
                 tt-erro.cod_parcela          ";"
                 tt-erro.cdn_fornec           ";"
                 tt-erro.mensagem SKIP.
        END.
        
        OUTPUT STREAM s_log CLOSE.

        EMPTY TEMP-TABLE tt-erro.
    END.
END.

OS-COMMAND NO-WAIT notepad value(v_arq_log).

RUN pi-finalizar IN h-acomp.

RETURN "OK".
