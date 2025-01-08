/* ******************************************************************* 
*** Programa: esapb026
*** Descriá∆o: Geraá∆o controle cess∆o de crÇdito fornecedor Citibank
*** Data: 03/05/2011
*********************************************************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Definition Begin - API Alteraá∆o ********************/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
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
          ttv_rec_tit_ap                   ascending
    .

def temp-table tt_tit_ap_alteracao_base no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/N∆o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Ap¢lice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Alteraá∆o" label "Motivo Alteraá∆o" column-label "Motivo Alteraá∆o"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/N∆o" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "HistΩrico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_padr              as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o Hist¢rico Padr∆o"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situaá∆o" column-label "Situaá∆o"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .


def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".


def temp-table tt_tit_ap_alteracao_base_aux_1 no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/N∆o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Ap¢lice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Alteraá∆o" label "Motivo Alteraá∆o" column-label "Motivo Alteraá∆o"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/N∆o" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_padr              as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o Hist¢rico Padr∆o"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situaá∆o" column-label "Situaá∆o"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(50)" label "T°tulo Banco Cobdor" column-label "T°tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transaá∆o 1099" column-label "Tipo Transaá∆o 1099"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .


/*************************************** definiá∆o das temp-tables pagamento ****************************/

def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transaá∆o 1099" column-label "Tipo Transaá∆o 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
    .

def temp-table tt_integr_apb_impto_impl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Inss" column-label "Deduá∆o Inss"
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Dependentes" column-label "Deduá∆o Dependentes"
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Pens∆o" column-label "Deducao Pens∆o"
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Deduá‰es" column-label "Outras Deduá‰es"
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L°quida Imposto" column-label "Base L°quida Imposto"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al°quota" column-label "Aliq"
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deduá∆o" column-label "Valor Deduá∆o"
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

/*************************** Temp-Table Definition Begin ********************/

DEF TEMP-TABLE tt_titulos NO-UNDO
    FIELD v_log_selec          AS LOG                      LABEL "Selec" FORMAT "Sim/N∆o" INITIAL NO
    FIELD v_cod_estab          AS CHAR FORMAT "x(04)"      LABEL "Est"
    FIELD v_cdn_fornec         AS INT                      LABEL "Fornecedor"
    FIELD v_cod_espec          AS CHAR FORMAT "x(03)"      LABEL "Esp"
    FIELD v_cod_ser            AS CHAR FORMAT "x(03)"      LABEL "Ser"
    FIELD v_cod_tit_ap         AS CHAR FORMAT "x(11)"      LABEL "Titulo"
    FIELD v_cod_parc           AS CHAR FORMAT "x(02)"      LABEL "Parc"
    FIELD v_dat_vcto           AS DATE FORMAT "99/99/9999" LABEL "Vencto"
    FIELD v_val_orig           AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Val Original"
    FIELD v_val_sdo            AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Val Saldo"
    FIELD v_moeda_apb          AS CHAR                     LABEL "M Tit"
    FIELD v_num_id_tit_ap      AS INT.

/*************************** Temp-Table Definition End ********************/

/*************************** Query Definition Begin *************************/
DEF QUERY qr_tt_titulos
    FOR tt_titulos
    SCROLLING.

def browse br_tt_titulos query qr_tt_titulos display 
    v_log_selec         
    v_cod_estab         
    v_cdn_fornec        
    v_cod_espec  
    v_cod_ser
    v_cod_tit_ap        
    v_cod_parc          
    v_dat_vcto
    v_val_orig          
    v_val_sdo           
    v_moeda_apb         
  with no-box separators 
         size 72 by 19.25
         font 1
         bgcolor 15 .

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_target
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.

/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_cod_dwb_output
    as character
    initial "Exportar"
    view-as radio-set Horizontal
    radio-buttons "Exportar", "Exportar", "Importar", "Importar"
    bgcolor 8 
    no-undo.

/************************* Radio-Set Definition End *************************/

DEF BUTTON bt_cessao     LABEL "Cess∆o" TOOLTIP "Cess∆o"    SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_can_cessao LABEL "Sair"   TOOLTIP "Sair"      SIZE 1 BY 1 AUTO-ENDKEY.
 
DEF BUTTON bt_elimina_nao_selec LABEL "Elimina n∆o Selecionados"   TOOLTIP "Elimina n∆o Selecionados" SIZE 1 BY 1.
DEF BUTTON bt_elimina_todos     LABEL "Elimina Todos"    TOOLTIP "Elimina Todos"    SIZE 1 BY 1.                     
DEF BUTTON bt_seleciona_todos   LABEL "Seleciona Todos"  TOOLTIP "Seleciona Todos"  SIZE 1 BY 1.                        
DEF BUTTON bt_pesquisa_titulos  LABEL "Pesquisa T°tulos" TOOLTIP "Pesquisa T°tulos" SIZE 1 BY 1.      
                     
                     
/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER FORMAT "x(03)"       INITIAL ""        NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim AS CHARACTER FORMAT "x(03)"       INITIAL "ZZZ"     NO-UNDO.
DEFINE VARIABLE v_cdn_fornec    AS INTEGER   FORMAT ">>>>>>>>>9"                    NO-UNDO.
DEFINE VARIABLE v_dat_vencto    AS DATE      FORMAT "99/99/9999"  INITIAL TODAY     NO-UNDO.
DEFINE VARIABLE v_cod_estab_imp AS CHARACTER FORMAT "x(03)"                         NO-UNDO.

DEFINE VARIABLE v_cod_dwb_file AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_log_method   AS LOGICAL     NO-UNDO.

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

def var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def var v_nom_filename
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    no-undo.
def var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def var v_cod_release
    as character
    format "x(12)":U
    no-undo.

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines   as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 80.
def new shared var v_rpt_s_1_bottom  as integer initial 65.
def new shared var v_rpt_s_1_page    as integer.
def new shared var v_rpt_s_1_name    as character initial "Logs Importaá∆o CITI".

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
def frame f_rpt_s_1_grp_logs_lay_unico header
    "Mensagem" at 4 skip
    "------------------------------------------------------------------------" at 4 skip
    with no-box no-labels width 80 page-top stream-io.


/*************************** Report Definition End **************************/


/************************** Frame Definition Begin **************************/

def frame f_concil

    rt_target
         at row 01.50 col 02.00
    " Transaá∆o " view-as text
         at row 01.30 col 04.00 bgcolor 8 
    rs_cod_dwb_output
         at row 02 col 03.00
         help "" no-label
    ed_1x40
         at row 01.85 col 25.00
         help "" no-label
    bt_get_file
         at row 1.85 col 91.2 font ?
         help "Pesquisa Arquivo"
    rt_cxcf
         at row 23.00 col 02.00 bgcolor 7
    rt_001
         at row 3.5 col 75.00 bgcolor 8
    rt_002
         at ROW 12.5 col 75.00 bgcolor 8
    v_cod_estab_ini
         AT ROW 05 COL 77 LABEL "Estabelec"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         AT ROW 05 COL 88.7 LABEL "atÇ"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_fornec
         AT ROW 06.5 COL 76.22 LABEL "Fornecedor"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto  
         AT ROW 08 COL 76 LABEL "Vencimento"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_imp
         AT ROW 6.5 COL 76 LABEL "Estab Pagto"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2 
    bt_pesquisa_titulos
         at row 10.21 col 76.00 font ?
    bt_elimina_nao_selec
         at row 15 col 76.00 font ?
    bt_elimina_todos
         at row 17 col 76.00 font ?
    bt_seleciona_todos
         at row 19 col 76.00 font ?
    br_tt_titulos
         AT ROW 3.5 COL 2
    bt_cessao
         at row 23.21 col 03.00 font ?
         help "AVA"
    bt_can_cessao
         at row 23.21 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 97.5 by 25 default-button bt_can_cessao
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Cess∆o de CrÇdito Citibank - esapb026".
/* adjust size of objects in this frame */
assign bt_cessao:width-chars       in frame f_concil = 10.00
       bt_cessao:height-chars      in frame f_concil = 01.00
       bt_can_cessao:width-chars   in frame f_concil = 10.00
       bt_can_cessao:height-chars  in frame f_concil = 01.00
       bt_elimina_nao_selec:width-chars  in frame f_concil = 20.00
       bt_elimina_nao_selec:height-chars in frame f_concil = 01.00
       bt_elimina_todos:width-chars      in frame f_concil = 20.00
       bt_elimina_todos:height-chars     in frame f_concil = 01.00
       bt_seleciona_todos:width-chars    in frame f_concil = 20.00
       bt_seleciona_todos:height-chars   in frame f_concil = 01.00
       bt_pesquisa_titulos:width-chars    in frame f_concil = 20.00
       bt_pesquisa_titulos:height-chars   in frame f_concil = 01.00
       rt_cxcf:width-chars         in frame f_concil = 95
       rt_cxcf:height-chars        in frame f_concil = 01.42
       rt_001:width-chars          in frame f_concil = 22
       rt_001:height-chars         in frame f_concil = 8.8
       rt_002:width-chars          in frame f_concil = 22
       rt_002:height-chars         in frame f_concil = 10.2
       bt_get_file:width-chars     in frame f_concil = 04.00
       bt_get_file:height-chars    in frame f_concil = 01.08
       ed_1x40:width-chars         in frame f_concil = 66
       ed_1x40:height-chars        in frame f_concil = 01.00
       rt_target:width-chars       in frame f_concil = 95
       rt_target:height-chars      in frame f_concil = 01.80.
/* set return-inserted = yes for editors */
assign ed_1x40:return-inserted in frame f_concil = yes.
/* set private-data for the help system */

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_cessao IN FRAME f_concil  
DO:

      ASSIGN INPUT FRAME f_concil ed_1x40
             INPUT FRAME f_concil rs_cod_dwb_output
             v_cod_dwb_file = ed_1x40.

      run pi_filename_validation (Input v_cod_dwb_file).
      if  return-value = "NOK" /*l_nok*/ 
      then do:
          /* Nome do arquivo incorreto ! */
          run pi_messages (input "show",
                           input 1064,
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
          return no-apply.
      end /* if */.

      EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
      empty temp-table tt_tit_ap_alteracao_base.
      empty temp-table tt_log_erros_tit_ap_alteracao.
      empty temp-table tt_tit_ap_alteracao_base_aux_1.
      empty temp-table tt_1099.
      empty temp-table tt_integr_apb_impto_impl_pend.
      empty temp-table tt_erros_conexao.
      empty temp-table tt_exec_rpc.
      empty temp-table tt_integr_apb_abat_antecip.
      empty temp-table tt_integr_apb_abat_antecip_vouc.
      empty temp-table tt_integr_apb_abat_prev.
      empty temp-table tt_integr_apb_bord_lote_pagto.
      empty temp-table tt_integr_apb_pagto.
      empty temp-table tt_integr_cambio_ems5.
      empty temp-table tt_log_erros.
      empty temp-table tt_log_erros_import_liquidac.
      empty temp-table tt_pessoa_jurid_matriz.
      empty temp-table tt_xml_input_1.
      empty temp-table tt_xml_output_1.
      empty temp-table tt_xml_output_2.
      empty temp-table tt_relac_erro.
      empty temp-table tt_log_erros_atualiz. 

      IF rs_cod_dwb_output = "Exportar" 
         THEN RUN pi_disponibiliza_titulo.
         ELSE RUN pi_retorna_titulo.

      apply "value-changed" to rs_cod_dwb_output in frame f_concil.

END.

ON CHOOSE OF bt_pesquisa_titulos IN FRAME f_concil 
DO:

    ASSIGN v_cod_estab_ini
           v_cod_estab_fim
           v_cdn_fornec
           v_dat_vencto.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa  = v_cod_empres_usuar
          AND estabelecimento.cod_estab   >= v_cod_estab_ini
          AND estabelecimento.cod_estab   <= v_cod_estab_fim:
        FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab       = estabelecimento.cod_estab
              AND tit_ap.cdn_fornec      = v_cdn_fornec
              AND tit_ap.log_sdo_tit_ap  = YES
              AND tit_ap.ind_tip_espec   = "Normal"
              AND (tit_ap.cod_portador   <> "745"
              AND  tit_ap.cod_portador   <> "341")
              AND tit_ap.dat_vencto     >= v_dat_vencto:
            
            /* Retirado conforme definiá∆o do chamado 106034.
            FIND FIRST proces_pagto OF tit_ap NO-LOCK NO-ERROR.
            IF AVAIL proces_pagto 
               THEN NEXT.
            */

            FIND tt_titulos NO-LOCK
                WHERE tt_titulos.v_cod_estab  = tit_ap.cod_estab   
                  AND tt_titulos.v_cdn_fornec = tit_ap.cdn_fornec  
                  AND tt_titulos.v_cod_espec  = tit_ap.cod_espec   
                  AND tt_titulos.v_cod_ser    = tit_ap.cod_ser     
                  AND tt_titulos.v_cod_tit_ap = tit_ap.cod_tit_ap  
                  AND tt_titulos.v_cod_parc   = tit_ap.cod_parcela NO-ERROR.
            IF AVAIL tt_titulos 
               THEN NEXT.
            CREATE tt_titulos.
            ASSIGN tt_titulos.v_log_selec     = NO
                   tt_titulos.v_cod_estab     = tit_ap.cod_estab
                   tt_titulos.v_cdn_fornec    = tit_ap.cdn_fornec
                   tt_titulos.v_cod_espec     = tit_ap.cod_espec
                   tt_titulos.v_cod_ser       = tit_ap.cod_ser
                   tt_titulos.v_cod_tit_ap    = tit_ap.cod_tit_ap
                   tt_titulos.v_cod_parc      = tit_ap.cod_parcela
                   tt_titulos.v_dat_vcto      = tit_ap.dat_vencto
                   tt_titulos.v_val_orig      = tit_ap.val_origin
                   tt_titulos.v_val_sdo       = tit_ap.val_sdo_tit_ap
                   tt_titulos.v_moeda_apb     = tit_ap.cod_indic_econ
                   tt_titulos.v_num_id_tit_ap = tit_ap.num_id_tit_ap.
        END.
    END.

    OPEN QUERY qr_tt_titulos
       FOR EACH tt_titulos NO-LOCK.

END.

ON CHOOSE OF bt_elimina_nao_selec IN FRAME f_concil
DO:

    FOR EACH tt_titulos EXCLUSIVE-LOCK
        WHERE tt_titulos.v_log_selec = NO:
        DELETE tt_titulos.
    END.

    OPEN QUERY qr_tt_titulos
       FOR EACH tt_titulos NO-LOCK.

END.

ON CHOOSE OF bt_elimina_todos IN FRAME f_concil
DO:

    FOR EACH tt_titulos EXCLUSIVE-LOCK:
        DELETE tt_titulos.
    END.

    OPEN QUERY qr_tt_titulos
       FOR EACH tt_titulos NO-LOCK.

END.
    
ON CHOOSE OF bt_seleciona_todos IN FRAME f_concil
DO:

    FOR EACH tt_titulos EXCLUSIVE-LOCK
        WHERE tt_titulos.v_log_selec = NO:
        ASSIGN tt_titulos.v_log_selec = YES.
    END.

    OPEN QUERY qr_tt_titulos
       FOR EACH tt_titulos NO-LOCK.

END.

ON MOUSE-SELECT-DBLCLICK OF br_tt_titulos IN FRAME f_concil
DO:

    DEF VAR v_rec_control AS RECID NO-UNDO.
    DEF VAR v_val_sdo     AS DEC   NO-UNDO.
    DEF VAR v_log_status  AS LOG   NO-UNDO.

    IF AVAIL tt_titulos 
    THEN DO:
         ASSIGN tt_titulos.v_log_selec = NOT(tt_titulos.v_log_selec).
         ASSIGN v_rec_control = RECID(tt_titulos).
         IF br_tt_titulos:REFRESH() THEN.
         IF v_rec_control <> ? THEN REPOSITION qr_tt_titulos TO RECID v_rec_control.
    END.

END.


ON CHOOSE OF bt_get_file IN FRAME f_concil
DO:

    system-dialog get-file v_cod_dwb_file
        title "Selecionar"
        filters '*.ret' '*.ret',
                "*.*"   "*.*"
      /*  save-as
        create-test-file
        ask-overwrite*/.
        assign ed_1x40:screen-value in frame f_concil = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_concil */

ON LEAVE OF ed_1x40 IN FRAME f_concil
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_concil:
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
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_concil */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_concil
DO:

    FOR EACH tt_titulos:
        DELETE tt_titulos.
    END.

    OPEN QUERY qr_tt_titulos
         FOR EACH tt_titulos NO-LOCK.

    initout:
    do with frame f_concil:
        /* block: */
        case self:screen-value:
            when "Exportar" /*l_file*/ then fil:
             do:

                ASSIGN v_cod_dwb_file = "v:\financeiro\cessao\citi\envio\" + "cit" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + ".txt"
                       v_cod_dwb_file = REPLACE(v_cod_dwb_file, "~/", "~\").

                ASSIGN ed_1x40:SCREEN-VALUE    = v_cod_dwb_file
                       ed_1x40:SENSITIVE       = YES
                       v_cod_estab_ini:VISIBLE = YES
                       v_cod_estab_fim:VISIBLE = YES
                       v_cdn_fornec:VISIBLE    = YES
                       v_dat_vencto:VISIBLE    = YES
                       v_cod_estab_imp:VISIBLE = NO
                       bt_get_file:SENSITIVE   = NO
                       bt_pesquisa_titulos:SENSITIVE  = YES 
                       bt_elimina_nao_selec:SENSITIVE = YES
                       bt_elimina_todos:SENSITIVE     = YES    
                       bt_seleciona_todos:SENSITIVE   = YES.

            end /* do fil */.
            when "Importar" /*l_file*/ then fil:
             do:
                assign ed_1x40:SCREEN-VALUE    = "v:\financeiro\cessao\citi\retorno\"
                       ed_1x40:SENSITIVE       = YES
                       v_cod_estab_ini:VISIBLE = NO
                       v_cod_estab_fim:VISIBLE = NO 
                       v_cdn_fornec:VISIBLE    = NO
                       v_dat_vencto:VISIBLE    = NO
                       v_cod_estab_imp:VISIBLE = YES
                       bt_get_file:SENSITIVE   = YES
                       bt_pesquisa_titulos:SENSITIVE  = NO 
                       bt_elimina_nao_selec:SENSITIVE = NO
                       bt_elimina_todos:SENSITIVE     = NO    
                       bt_seleciona_todos:SENSITIVE   = NO.
            end /* do fil */.
        end /* case block */.

    end /* do initout */.

    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_concil */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON CHOOSE OF bt_can_cessao IN FRAME f_concil
DO:

    run pi_close_program.
END.


ON END-ERROR OF FRAME f_concil
DO:

    run pi_close_program.
END.

ON WINDOW-CLOSE OF FRAME f_concil
DO:

    apply "choose" to bt_can_cessao in frame f_concil.
END.

/***************************** Frame Trigger End ****************************/

def new global shared var v_des_contdo_prog_valid_dtsul
    as character
    format "x(40)":U
    no-undo.

ASSIGN v_des_contdo_prog_valid_dtsul = 'esapb026'.

ASSIGN v_cod_estab_imp = v_cod_estab_usuar
       v_dat_vencto    = TODAY + 7.

/* tratamento do titulo e vers∆o */
assign frame f_concil:title = frame f_concil:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.01.00.003":U)
                            + chr(41).

pause 0 before-hide.
view frame f_concil.

init:
do with frame f_concil:

    assign v_cod_dwb_file = replace(v_cod_dwb_file, "~\", "~/").
    if (index(v_cod_dwb_file, "~/") <> 0) then
        assign v_cod_dwb_file = substring(v_cod_dwb_file, r-index(v_cod_dwb_file, "~/") + 1).

    assign ed_1x40:screen-value = v_cod_dwb_file.

end /* do init */.

ENABLE rs_cod_dwb_output
       bt_get_file
       v_cod_estab_ini
       v_cod_estab_fim
       v_cdn_fornec   
       v_dat_vencto 
       v_cod_estab_imp
       bt_pesquisa_titulos
       bt_elimina_nao_selec
       bt_elimina_todos    
       bt_seleciona_todos  
       br_tt_titulos
       bt_cessao
       bt_can_cessao
       WITH FRAME f_concil.

DISP v_cod_estab_ini    
     v_cod_estab_fim   
     v_cdn_fornec      
     v_dat_vencto      
     v_cod_estab_imp   
     WITH FRAME f_concil.

apply "value-changed" to rs_cod_dwb_output in frame f_concil.

main_bl:
do on endkey undo main_bl, leave main_bl on error undo main_bl, leave main_bl:

    wait-for CHOOSE OF bt_can_cessao in frame f_concil.

end.

hide frame f_concil.


PROCEDURE pi_close_program:

    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END PROCEDURE. /* pi_close_program */

/*selecionar titulos conforme faixa e seleá∆o com portador diferente de 745*/
PROCEDURE pi_disponibiliza_titulo:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_count         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_num_seq_refer AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_bord      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_line      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_des_mensagem  AS CHARACTER   NO-UNDO.

    ASSIGN v_num_line = 0.

    trans_block:
    DO TRANSACTION on error undo trans_block, leave trans_block:
    
        IF SESSION:SET-WAIT-STATE('general') THEN.

        /* ** API Alteraá∆o ***/
        FOR EACH tt_titulos
            WHERE tt_titulos.v_log_selec:
    
            FIND tit_ap NO-LOCK
                WHERE tit_ap.cod_estab   = tt_titulos.v_cod_estab  
                  AND tit_ap.cdn_fornec  = tt_titulos.v_cdn_fornec 
                  AND tit_ap.cod_espec   = tt_titulos.v_cod_espec  
                  AND tit_ap.cod_ser     = tt_titulos.v_cod_ser    
                  AND tit_ap.cod_tit_ap  = tt_titulos.v_cod_tit_ap 
                  AND tit_ap.cod_parcela = tt_titulos.v_cod_parc NO-ERROR.
    
            ASSIGN v_num_seq_refer = v_num_seq_refer + 1.
    
            ASSIGN v_log_refer_uni = NO.
            REPEAT WHILE v_log_refer_uni = NO:
               RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_refer).
               RUN pi_verifica_refer_unica_apb (INPUT tit_ap.cod_estab,
                                                INPUT v_cod_refer,
                                                OUTPUT v_log_refer_uni).
            END.
    
            CREATE tt_tit_ap_alteracao_base_aux_1.
            ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                   tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                   tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = TODAY
                   tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                   tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = v_num_seq_refer
                   tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Alteraá∆o"
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
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                  = "745"
                   tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr               = "Alteraá∆o do portador - esapb026 - Cess∆o CrÇdito Disponibilizado.".
            VALIDATE tt_tit_ap_alteracao_base_aux_1.
    
        END.
    
        IF CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) 
           THEN RUN prgfin/apb/apb767ze.py(INPUT 1,
                                           INPUT "",
                                           INPUT "",
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                           OUTPUT TABLE  tt_log_erros_tit_ap_alteracao).
    
        FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK
            WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542:
            MESSAGE "API Alteraá∆o" SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_estab       SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_parcela     SKIP
                    tt_log_erros_tit_ap_alteracao.ttv_num_mensagem    SKIP
                    tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro    SKIP
                    tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda 
            VIEW-AS ALERT-BOX.
        END.
    
        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao
                    WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542) 
        THEN DO:
             IF SESSION:SET-WAIT-STATE('') THEN.
             MESSAGE "Operaá∆o Cancelada !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
             UNDO trans_block, RETURN ERROR.
        END.

        assign v_nom_prog_ext   = caps("esapb026":U)
               v_cod_release    = " 5.01.00.002":U
               v_dat_execution  = today
               v_hra_execution  = replace(string(time,"hh:mm:ss"),":","")
               v_nom_filename   = SESSION:TEMP-DIRECTORY + "esapb026.txt"
               v_nom_enterprise = 'Intelbras S.A.'.

        ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general').

        output stream s_1 to value(v_nom_filename) paged
            page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.

        VIEW STREAM s_1 FRAME f_rpt_s_1_header_unique.
        VIEW STREAM s_1 FRAME f_rpt_s_1_footer_normal.
        VIEW STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.

        ASSIGN v_num_bord = 0.

        FOR EACH tt_titulos
            WHERE tt_titulos.v_log_selec = YES
            BREAK BY tt_titulos.v_dat_vcto:

            IF FIRST-OF(tt_titulos.v_dat_vcto) THEN DO:
                /* ** Cria Borderì ***/
                CREATE tt_integr_apb_pagto.
                ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz       = "bordero"
                       tt_integr_apb_pagto.ttv_log_atualiz_refer     = NO 
                       tt_integr_apb_pagto.ttv_log_gera_lote_parcial = NO.

                IF v_num_bord = 0 THEN DO:
                    FIND LAST bord_ap
                        WHERE bord_ap.cod_estab_bord = v_cod_estab_imp
                          AND bord_ap.cod_portador   = "745" NO-LOCK NO-ERROR.

                    IF AVAIL bord_ap THEN
                        ASSIGN v_num_bord = bord_ap.num_bord_ap + 1.
                    ELSE
                        ASSIGN v_num_bord = 1.
                END.
                ELSE
                    ASSIGN v_num_bord = v_num_bord + 1.

                ASSIGN tt_integr_apb_pagto.tta_cod_empresa               = v_cod_empres_usuar
                       tt_integr_apb_pagto.tta_cod_estab_bord            = v_cod_estab_imp
                       tt_integr_apb_pagto.tta_cod_portador              = "745"
                       tt_integr_apb_pagto.tta_num_bord_ap               = v_num_bord
                       tt_integr_apb_pagto.tta_log_bord_ap_escrit        = NO
                       tt_integr_apb_pagto.tta_log_bord_ap_escrit_envdo  = NO
                       tt_integr_apb_pagto.tta_ind_tip_bord_ap           = "Normal"
                       tt_integr_apb_pagto.tta_dat_transacao             = tt_titulos.v_dat_vcto
                       tt_integr_apb_pagto.tta_cod_indic_econ            = "Real"
                       tt_integr_apb_pagto.tta_cod_finalid_econ          = "Corrente"
                       tt_integr_apb_pagto.tta_cod_usuar_pagto           = v_cod_usuar_corren
                       tt_integr_apb_pagto.ttv_rec_table_parent          = recid(tt_integr_apb_pagto).
            END.

            CREATE tt_integr_apb_bord_lote_pagto.
            ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = v_cod_empres_usuar
                   tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer  = v_cod_estab_imp
                   tt_integr_apb_bord_lote_pagto.tta_cod_portador          = "745"
                   tt_integr_apb_bord_lote_pagto.tta_cod_estab             = tt_titulos.v_cod_estab
                   tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto       = tt_titulos.v_cod_espec
                   tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto         = tt_titulos.v_cod_ser
                   tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = tt_titulos.v_cdn_fornec
                   tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap            = tt_titulos.v_cod_tit_ap
                   tt_integr_apb_bord_lote_pagto.tta_cod_parcela           = tt_titulos.v_cod_parc
                   tt_integr_apb_bord_lote_pagto.tta_val_pagto             = tt_titulos.v_val_sdo
                   tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ  = 1
                   tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto       = "10"
                   tt_integr_apb_bord_lote_pagto.tta_cod_indic_econ        = "Real"
                   tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_bord_ap  = "Enviado ao Banco"
                   tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = NO
                   tt_integr_apb_bord_lote_pagto.ttv_ind_forma_pagto       = "Informada"
                   tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                   tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = RECID(tt_integr_apb_bord_lote_pagto).
        END.

        RUN prgfin/apb/apb902zc.py (INPUT  1,
                                    INPUT  TABLE tt_integr_apb_pagto,
                                    OUTPUT TABLE tt_log_erros_atualiz,
                                    INPUT  TABLE tt_integr_apb_bord_lote_pagto,
                                    INPUT  TABLE tt_integr_apb_abat_prev,
                                    INPUT  TABLE tt_integr_apb_abat_antecip,
                                    INPUT  TABLE tt_integr_apb_impto_impl_pend,
                                    INPUT  "",
                                    INPUT  TABLE tt_integr_cambio_ems5,
                                    INPUT  TABLE tt_1099).

        FOR EACH tt_log_erros_atualiz:
            FIND tt_relac_erro
                WHERE tt_relac_erro.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.

            IF AVAIL tt_relac_erro THEN
                ASSIGN v_num_line = tt_relac_erro.ttv_num_linha.
            ELSE
                ASSIGN v_num_line = 0.

            ASSIGN v_des_mensagem = "Erro API Borderì: " + tt_log_erros_atualiz.ttv_des_msg_erro + tt_log_erros_atualiz.ttv_des_msg_ajuda.

            RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").

            PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.

            RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").
        END.

        IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
            ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

            HIDE STREAM s_1 FRAME f_rpt_s_1_header_unique.
            HIDE STREAM s_1 FRAME f_rpt_s_1_footer_normal.
            HIDE STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.
    
            VIEW STREAM s_1 FRAME f_rpt_s_1_footer_last_page.
    
            output stream s_1 close.
            run pi_show_report_2 (Input v_nom_filename).

            UNDO trans_block, LEAVE trans_block.
        END.
        ELSE DO:
            FOR EACH tt_integr_apb_pagto:
                ASSIGN v_des_mensagem = "Borderì Gerado: " + tt_integr_apb_pagto.tta_cod_estab_bord + "-" + tt_integr_apb_pagto.tta_cod_portador + "-" + string(tt_integr_apb_pagto.tta_num_bord_ap) + "-" + string(tt_integr_apb_pagto.tta_dat_transacao).

                RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").

                PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.

                RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").

                FOR EACH tt_integr_apb_bord_lote_pagto OF tt_integr_apb_pagto:
                    ASSIGN v_des_mensagem = "Item Borderì: " + tt_integr_apb_bord_lote_pagto.tta_cod_estab      + "/" +
                                                               string(tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor)  + "/" +
                                                               tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto + "/" +
                                                               tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto   + "/" +
                                                               tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap      + "/" +
                                                               tt_integr_apb_bord_lote_pagto.tta_cod_parcela     + "/" +
                                                               string(tt_integr_apb_bord_lote_pagto.tta_val_pagto, "->>>,>>>,>>9.99").

                    RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").

                    PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.

                    RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").
                END.
            END.
        END.

        ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

        HIDE STREAM s_1 FRAME f_rpt_s_1_header_unique.
        HIDE STREAM s_1 FRAME f_rpt_s_1_footer_normal.
        HIDE STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.

        VIEW STREAM s_1 FRAME f_rpt_s_1_footer_last_page.

        output stream s_1 close.
        run pi_show_report_2 (Input v_nom_filename).

        RUN pi_gera_arquivo.

        OPEN QUERY qr_tt_titulos
             FOR EACH tt_titulos NO-LOCK.

        IF SESSION:SET-WAIT-STATE('') THEN.

        MESSAGE "Arquivo Gerado: " v_cod_dwb_file
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

        /*UNDO trans_block, RETURN ERROR.*/

    END.
  
END.

PROCEDURE pi_gera_arquivo:

    DEFINE VARIABLE iseq AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dval AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE ctel       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cformapgto AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cbanco     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cagencia   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cconta     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ccontaciti AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ctipocta   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ctipobenef AS CHARACTER   NO-UNDO.

    
    OUTPUT STREAM s_1 TO VALUE(v_cod_dwb_file) CONVERT TARGET 'iso8859-1'.

    FOR EACH tt_titulos
        WHERE tt_titulos.v_log_selec = YES:
    
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = tt_titulos.v_cdn_fornec NO-ERROR.
    
        ASSIGN iseq = iseq + 1
               dval = dval + tt_titulos.v_val_sdo.
    
        ASSIGN ctel =  emitente.telefone[1]
               ctel = REPLACE(ctel, "(", "")
               ctel = REPLACE(ctel, ")", "")
               ctel = REPLACE(ctel, " ", "")
               ctel = REPLACE(ctel, "-", "")
               ctel = REPLACE(ctel, "/", "").

        FIND fornec_financ NO-LOCK
            WHERE fornec_financ.cod_empres = v_cod_empres_usuar
              AND fornec_financ.cdn_fornec = emitente.cod-emitente NO-ERROR.
        IF fornec_financ.cod_banco = '745' 
           THEN ASSIGN cformapgto = "072"
                       cbanco     = "000"
                       cagencia   = "0000"
                       cconta     = "000000000000000"
                       ccontaciti = STRING(DEC(fornec_financ.cod_cta_corren), "9999999999")
                       ctipocta   = "00"
                       ctipobenef = "01".
           ELSE ASSIGN cformapgto = IF tt_titulos.v_val_sdo < 3000 THEN "071" ELSE "083"
                       cbanco     = STRING(DEC(fornec_financ.cod_banco), "999")
                       cagencia   = STRING(DEC(fornec_financ.cod_agenc_bcia), "9999")
                       cconta     = STRING(STRING(DEC(fornec_financ.cod_cta_corren)) + STRING(DEC(fornec_financ.cod_digito_cta_corren)), "999999999999999")
                       ccontaciti = "0000000000"
                       ctipocta   = "01"
                       ctipobenef = "00".

        PUT STREAM s_1 UNFORMATTED
                "PAY0760067765028"
                STRING(SUBSTRING(STRING(tt_titulos.v_dat_vcto, "99/99/9999"), 9, 2), "99") STRING(SUBSTRING(STRING(tt_titulos.v_dat_vcto, "99/99/9999"), 4, 2), "99") STRING(SUBSTRING(STRING(tt_titulos.v_dat_vcto, "99/99/9999"), 1, 2), "99")
                STRING(cformapgto, "999")
                STRING(TRIM(tt_titulos.v_cod_estab) + TRIM(STRING(tt_titulos.v_num_id_tit_ap)), "x(15)")
                STRING(iseq, "99999999")
                STRING(emitente.cgc, "99999999999999")
                "BRL"
                STRING(tt_titulos.v_cdn_fornec, "9999999999")
                STRING(tt_titulos.v_val_sdo * 100, "999999999999999")
                "000000"
                STRING(tt_titulos.v_cod_tit_ap + "/" + tt_titulos.v_cod_parc, "x(30)")
                STRING("", "x(30)")
                STRING("0000000101")
                STRING(emitente.nome-emit, "x(80)")
                STRING(emitente.endereco, "x(30)")
                STRING(emitente.cidade, "x(15)")   
                STRING(emitente.estado, "x(02)") 
                STRING(DEC(emitente.cep), "99999999") 
                STRING(DEC(ctel), "99999999999")
                STRING(DEC(cbanco), "999")
                STRING(DEC(cagencia), "9999")
                "    "
                STRING(DEC(cconta), "999999999999999")
                " "
                STRING(DEC(ctipocta), "99")
                FILL(" ", 47)
                FILL("0", 10)
                FILL(" ", 35)
                STRING(DEC(ccontaciti), "9999999999")
                STRING(DEC(ctipobenef), "99")
                "010"
                FILL(" ", 152)
            SKIP.

        DELETE tt_titulos.
    
    END.
    
    PUT STREAM s_1 UNFORMATTED
            "TRL"
            STRING(iseq, "999999999999999")
            STRING(dval * 100, "999999999999999")
            FILL("0", 15)
            STRING(iseq, "999999999999999")
            FILL(" ", 37)
        SKIP.

    OUTPUT STREAM s_1 CLOSE.

END.



PROCEDURE pi_retorna_titulo:

    DEFINE VARIABLE v_cod_refer      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_count          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_num_seq_refer  AS INTEGER     NO-UNDO.
/*     DEFINE VARIABLE v_num_bord       AS INTEGER     NO-UNDO. */
/*     DEFINE VARIABLE v_num_line       AS INTEGER     NO-UNDO. */
    DEFINE VARIABLE v_des_mensagem   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_des_reg_import AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v_des_ocor AS CHARACTER   NO-UNDO.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general').

    assign v_nom_prog_ext  = caps("esapb026":U)
           v_cod_release   = " 5.01.00.002":U
           v_dat_execution = today
           v_hra_execution = replace(string(time,"hh:mm:ss"),":","")
           v_nom_filename  = SESSION:TEMP-DIRECTORY + "esapb026.txt".

    output stream s_1 to value(v_nom_filename) paged
           page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.

    ASSIGN v_nom_enterprise   = 'Intelbras S.A.'.
    VIEW STREAM s_1 FRAME f_rpt_s_1_header_unique.
    VIEW STREAM s_1 FRAME f_rpt_s_1_footer_normal.
    VIEW STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.

/*     ASSIGN v_num_line = 0. */

    EMPTY TEMP-TABLE tt_titulos.

    /* ** Importar ***/
    INPUT FROM VALUE(v_cod_dwb_file).

    import_block:
    REPEAT:

        IMPORT UNFORMATTED v_des_reg_import.

        IF SUBSTRING(v_des_reg_import, 49, 1) = "N" THEN ASSIGN v_des_ocor = "Pendente de Autorizaá∆o".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "F" THEN ASSIGN v_des_ocor = "Pendente da Èltima Autorizaá∆o".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "W" THEN ASSIGN v_des_ocor = "Pagamento autorizado aguardando data do pagamento".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "A" THEN ASSIGN v_des_ocor = "Pagamento autorizado".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "H" THEN ASSIGN v_des_ocor = "Pagamento efetuado".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "R" THEN ASSIGN v_des_ocor = "Pagamento Rejeitado".
        IF SUBSTRING(v_des_reg_import, 49, 1) = "O" THEN ASSIGN v_des_ocor = "Pagamento Descontato".

        FIND tit_ap NO-LOCK
            WHERE tit_ap.cod_estab     =          SUBSTRING(v_des_reg_import, 24, 3)
              AND tit_ap.num_id_tit_ap = INT(TRIM(SUBSTRING(v_des_reg_import, 27, 12))) NO-ERROR.
        IF NOT AVAIL tit_ap 
           THEN NEXT.

        ASSIGN v_des_mensagem = "T°tulo Importado: " + tit_ap.cod_estab + "/" + STRING(tit_ap.cdn_fornec) + "/" + tit_ap.cod_espec + "/" + tit_ap.cod_ser + "/" + tit_ap.cod_tit_ap + "/" + tit_ap.cod_parcela + " / Ocorrància: " + v_des_ocor.
        RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").
        PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.
        RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").

        IF  SUBSTRING(v_des_reg_import, 49, 1) <> "O"
        AND SUBSTRING(v_des_reg_import, 49, 1) <> "R"
            THEN NEXT.

        FIND tt_titulos NO-LOCK
            WHERE tt_titulos.v_cod_estab  = tit_ap.cod_estab   
              AND tt_titulos.v_cdn_fornec = tit_ap.cdn_fornec  
              AND tt_titulos.v_cod_espec  = tit_ap.cod_espec   
              AND tt_titulos.v_cod_ser    = tit_ap.cod_ser     
              AND tt_titulos.v_cod_tit_ap = tit_ap.cod_tit_ap  
              AND tt_titulos.v_cod_parc   = tit_ap.cod_parcela NO-ERROR.
        IF AVAIL tt_titulos 
           THEN NEXT.
        CREATE tt_titulos.
        ASSIGN tt_titulos.v_log_selec     = IF SUBSTRING(v_des_reg_import, 49, 1) = "R" THEN NO ELSE YES
               tt_titulos.v_cod_estab     = tit_ap.cod_estab
               tt_titulos.v_cdn_fornec    = tit_ap.cdn_fornec
               tt_titulos.v_cod_espec     = tit_ap.cod_espec
               tt_titulos.v_cod_ser       = tit_ap.cod_ser
               tt_titulos.v_cod_tit_ap    = tit_ap.cod_tit_ap
               tt_titulos.v_cod_parc      = tit_ap.cod_parcela
               tt_titulos.v_dat_vcto      = tit_ap.dat_vencto
               tt_titulos.v_val_orig      = tit_ap.val_origin
               tt_titulos.v_val_sdo       = tit_ap.val_sdo_tit_ap
               tt_titulos.v_moeda_apb     = tit_ap.cod_indic_econ
               tt_titulos.v_num_id_tit_ap = tit_ap.num_id_tit_ap.

    END.

    main_block:
    do on error undo main_block, leave main_block on endkey undo main_block, leave main_block transaction:

        /* ** API Alteraá∆o ***/
        FOR EACH tt_titulos
            WHERE tt_titulos.v_log_selec = NO:
    
            FIND tit_ap NO-LOCK
                WHERE tit_ap.cod_estab   = tt_titulos.v_cod_estab  
                  AND tit_ap.cdn_fornec  = tt_titulos.v_cdn_fornec 
                  AND tit_ap.cod_espec   = tt_titulos.v_cod_espec  
                  AND tit_ap.cod_ser     = tt_titulos.v_cod_ser    
                  AND tit_ap.cod_tit_ap  = tt_titulos.v_cod_tit_ap 
                  AND tit_ap.cod_parcela = tt_titulos.v_cod_parc NO-ERROR.
    
            ASSIGN v_num_seq_refer = v_num_seq_refer + 1.
    
            ASSIGN v_log_refer_uni = NO.
            REPEAT WHILE v_log_refer_uni = NO:
               RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_refer).
               RUN pi_verifica_refer_unica_apb (INPUT tit_ap.cod_estab,
                                                INPUT v_cod_refer,
                                                OUTPUT v_log_refer_uni).
            END.
    
            CREATE tt_tit_ap_alteracao_base_aux_1.
            ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                   tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                   tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = TODAY
                   tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                   tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap
                   tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = v_num_seq_refer
                   tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Alteraá∆o"
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
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                  = "999"
                   tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr               = "Alteraá∆o do portador - esapb026 - Cess∆o CrÇdito Rejeitado.".
            VALIDATE tt_tit_ap_alteracao_base_aux_1.
    
        END.
    
        IF CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) 
           THEN RUN prgfin/apb/apb767ze.py(INPUT 1,
                                           INPUT "",
                                           INPUT "",
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                           INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                           OUTPUT TABLE  tt_log_erros_tit_ap_alteracao).
    
        IF SESSION:SET-WAIT-STATE('') THEN.
    
        FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK
            WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542:

            ASSIGN v_des_mensagem = "Erro API Alteraá∆o: " + tt_log_erros_tit_ap_alteracao.tta_cod_estab        + "/"         
                                                           + string(tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor)   + "/"         
                                                           + tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto  + "/"         
                                                           + tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto    + "/"         
                                                           + tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap       + "/"         
                                                           + tt_log_erros_tit_ap_alteracao.tta_cod_parcela      + " - "         
                                                           + string(tt_log_erros_tit_ap_alteracao.ttv_num_mensagem)     + " - "         
                                                           + tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.         
            
            RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").
            PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.
            RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").            
            
        END.
    
        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao
                    WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542) 
        THEN DO:
             undo main_block, leave main_block.
        END.

/*         ASSIGN v_num_bord = 0.                                                                                                             */
/*                                                                                                                                            */
/*         FOR EACH tt_titulos                                                                                                                */
/*             WHERE tt_titulos.v_log_selec = YES                                                                                             */
/*             BREAK BY tt_titulos.v_dat_vcto:                                                                                                */
/*                                                                                                                                            */
/*             IF FIRST-OF(tt_titulos.v_dat_vcto)                                                                                             */
/*             THEN DO:                                                                                                                       */
/*                                                                                                                                            */
/*                 /* ** Cria Borderì ***/                                                                                                    */
/*                 CREATE tt_integr_apb_pagto.                                                                                                */
/*                 ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz       = "bordero"                                                           */
/*                        tt_integr_apb_pagto.ttv_log_atualiz_refer     = NO                                                                  */
/*                        tt_integr_apb_pagto.ttv_log_gera_lote_parcial = NO.                                                                 */
/*                                                                                                                                            */
/*                 IF v_num_bord = 0                                                                                                          */
/*                 THEN DO:                                                                                                                   */
/*                      FIND LAST bord_ap NO-LOCK                                                                                             */
/*                           WHERE bord_ap.cod_estab_bord = v_cod_estab_imp                                                                   */
/*                             AND bord_ap.cod_portador   = "745" NO-ERROR.                                                                   */
/*                                                                                                                                            */
/*                      IF AVAIL bord_ap                                                                                                      */
/*                         THEN ASSIGN v_num_bord = bord_ap.num_bord_ap + 1.                                                                  */
/*                         ELSE ASSIGN v_num_bord = 1.                                                                                        */
/*                 END.                                                                                                                       */
/*                 ELSE ASSIGN v_num_bord = v_num_bord + 1.                                                                                   */
/*                                                                                                                                            */
/*                 ASSIGN tt_integr_apb_pagto.tta_cod_empresa               = v_cod_empres_usuar                                              */
/*                        tt_integr_apb_pagto.tta_cod_estab_bord            = v_cod_estab_imp                                                 */
/*                        tt_integr_apb_pagto.tta_cod_portador              = "745"                                                           */
/*                        tt_integr_apb_pagto.tta_num_bord_ap               = v_num_bord                                                      */
/*                        tt_integr_apb_pagto.tta_log_bord_ap_escrit        = NO                                                              */
/*                        tt_integr_apb_pagto.tta_log_bord_ap_escrit_envdo  = NO                                                              */
/*                        tt_integr_apb_pagto.tta_ind_tip_bord_ap           = "Normal"                                                        */
/*                        tt_integr_apb_pagto.tta_dat_transacao             = tt_titulos.v_dat_vcto                                           */
/*                        tt_integr_apb_pagto.tta_cod_indic_econ            = "Real"                                                          */
/*                        tt_integr_apb_pagto.tta_cod_finalid_econ          = "Corrente"                                                      */
/*                        tt_integr_apb_pagto.tta_cod_usuar_pagto           = v_cod_usuar_corren                                              */
/*                        tt_integr_apb_pagto.ttv_rec_table_parent          = recid(tt_integr_apb_pagto).                                     */
/*                                                                                                                                            */
/*             END.                                                                                                                           */
/*                                                                                                                                            */
/*             CREATE tt_integr_apb_bord_lote_pagto.                                                                                          */
/*             ASSIGN tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = v_cod_empres_usuar                                            */
/*                    tt_integr_apb_bord_lote_pagto.ttv_cod_estab_bord_refer  = v_cod_estab_imp                                               */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_portador          = "745"                                                         */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_estab             = tt_titulos.v_cod_estab                                        */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto       = tt_titulos.v_cod_espec                                        */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto         = tt_titulos.v_cod_ser                                          */
/*                    tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = tt_titulos.v_cdn_fornec                                       */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap            = tt_titulos.v_cod_tit_ap                                       */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_parcela           = tt_titulos.v_cod_parc                                         */
/*                    tt_integr_apb_bord_lote_pagto.tta_val_pagto             = tt_titulos.v_val_sdo                                          */
/*                    tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ  = 1                                                             */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_forma_pagto       = "10"                                                          */
/*                    tt_integr_apb_bord_lote_pagto.tta_cod_indic_econ         = 'Real'                                                       */
/*                    tt_integr_apb_bord_lote_pagto.tta_ind_sit_item_bord_ap  = "Enviado ao Banco"                                            */
/*                    tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = NO                                                            */
/*                    tt_integr_apb_bord_lote_pagto.ttv_ind_forma_pagto       = "Informada"                                                   */
/*                    tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent                      */
/*                    tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = RECID(tt_integr_apb_bord_lote_pagto).                         */
/*                                                                                                                                            */
/*         END.                                                                                                                               */
/*                                                                                                                                            */
/*         RUN prgfin/apb/apb902zc.py (INPUT 1,                                                                                               */
/*                                     INPUT TABLE tt_integr_apb_pagto,                                                                       */
/*                                     OUTPUT TABLE tt_log_erros_atualiz,                                                                     */
/*                                     INPUT TABLE tt_integr_apb_bord_lote_pagto,                                                             */
/*                                     INPUT TABLE tt_integr_apb_abat_prev,                                                                   */
/*                                     INPUT TABLE tt_integr_apb_abat_antecip,                                                                */
/*                                     INPUT TABLE tt_integr_apb_impto_impl_pend,                                                             */
/*                                     INPUT "",                                                                                              */
/*                                     INPUT TABLE tt_integr_cambio_ems5,                                                                     */
/*                                     INPUT TABLE tt_1099).                                                                                  */
/*                                                                                                                                            */
/*         FOR EACH tt_log_erros_atualiz:                                                                                                     */
/*                                                                                                                                            */
/*             FIND tt_relac_erro                                                                                                             */
/*                 WHERE tt_relac_erro.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer NO-ERROR.                                           */
/*             IF AVAIL tt_relac_erro                                                                                                         */
/*                THEN ASSIGN v_num_line = tt_relac_erro.ttv_num_linha.                                                                       */
/*                ELSE ASSIGN v_num_line = 0.                                                                                                 */
/*                                                                                                                                            */
/*             ASSIGN v_des_mensagem = "Erro API Borderì: " + tt_log_erros_atualiz.ttv_des_msg_erro + tt_log_erros_atualiz.ttv_des_msg_ajuda. */
/*             RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").                                             */
/*             PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.                                          */
/*             RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").                                                       */
/*                                                                                                                                            */
/*         END.                                                                                                                               */
/*                                                                                                                                            */
/*         IF CAN-FIND(FIRST tt_log_erros_atualiz)                                                                                            */
/*         THEN DO:                                                                                                                           */
/*              undo main_block, leave main_block.                                                                                            */
/*         END.                                                                                                                               */
/*         ELSE DO:                                                                                                                           */

             FOR EACH tt_tit_ap_alteracao_base_aux_1:

                 FIND tit_ap NO-LOCK
                     WHERE tit_ap.cod_estab     = tt_tit_ap_alteracao_base_aux_1.tta_cod_estab    
                       AND tit_ap.num_id_tit_ap = tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap NO-ERROR.

                 ASSIGN v_des_mensagem = "T°tulo Rejeitado: " + tit_ap.cod_estab + "/" + STRING(tit_ap.cdn_fornec) + "/" + tit_ap.cod_espec + "/" + tit_ap.cod_ser + "/" + tit_ap.cod_tit_ap + "/" + tit_ap.cod_parcela.
                 RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").
                 PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.
                 RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").

             END.

/*              FOR EACH tt_integr_apb_pagto:                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                              */
/*                  ASSIGN v_des_mensagem = "Borderì Gerado: " + tt_integr_apb_pagto.tta_cod_estab_bord + "-" + tt_integr_apb_pagto.tta_cod_portador + "-" + string(tt_integr_apb_pagto.tta_num_bord_ap) + "-" + string(tt_integr_apb_pagto.tta_dat_transacao). */
/*                  RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").                                                                                                                                                          */
/*                  PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.                                                                                                                                                       */
/*                  RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                              */
/*                  FOR EACH tt_integr_apb_bord_lote_pagto OF tt_integr_apb_pagto:                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                              */
/*                      ASSIGN v_des_mensagem = "Item Borderì: " + tt_integr_apb_bord_lote_pagto.tta_cod_estab      + "/" +                                                                                                                                     */
/*                                                                 string(tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor)  + "/" +                                                                                                                            */
/*                                                                 tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto + "/" +                                                                                                                                    */
/*                                                                 tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto   + "/" +                                                                                                                                    */
/*                                                                 tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap      + "/" +                                                                                                                                    */
/*                                                                 tt_integr_apb_bord_lote_pagto.tta_cod_parcela     + "/" +                                                                                                                                    */
/*                                                                 string(tt_integr_apb_bord_lote_pagto.tta_val_pagto, "->>>,>>>,>>9.99").                                                                                                                      */
/*                      RUN pi_print_editor ("s_1", v_des_mensagem, "     072", "", "     ", "", "     ").                                                                                                                                                      */
/*                      PUT STREAM s_1 UNFORMATTED ENTRY(1, RETURN-VALUE, CHR(255)) AT 4 FORMAT "x(72)" SKIP.                                                                                                                                                   */
/*                      RUN pi_print_editor ("s_1", v_des_mensagem, "at004072", "", "", "", "").                                                                                                                                                                */
/*                                                                                                                                                                                                                                                              */
/*                  END.                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                              */
/*              END.                                                                                                                                                                                                                                            */
/*        END.                                                                                                                                                                                                                                                  */
        
        /*zarpe
        undo main_block, leave main_block.*/

    END.
  
    ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").  
  
    HIDE STREAM s_1 FRAME f_rpt_s_1_header_unique.
    HIDE STREAM s_1 FRAME f_rpt_s_1_footer_normal.
    HIDE STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.

    VIEW STREAM s_1 FRAME f_rpt_s_1_footer_last_page.

    output stream s_1 close.
    run pi_show_report_2 (Input v_nom_filename).

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
        format "Sim/Nío"
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
END PROCEDURE. /* pi_filename_validation */

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
END PROCEDURE.  /* pi_messages */

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
