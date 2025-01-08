/*------------------------------------------------------------------------
    File        : GK0006RP1.P
    Purpose     : Gerar t°tulos no Contas Ö Pagar.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/es0018.i}
{esp/cms/apb900zg.i} /* Definiá∆o das temp-tables da API de implantaá∆o */

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
          ttv_rec_tit_ap                   ascending.

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
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
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
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
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
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.
  
define temp-table tt_integr_apb_impto_impl_pend5 no-undo
  field ttv_rec_integr_apb_item_lote   as recid format ">>>>>>9"
  field ttv_rec_antecip_pef_pend       as recid format ">>>>>>9"
  field tta_cod_pais                   as character format "x(3)" label "Pa°s" column-label "Pa°s"
  field tta_cod_unid_federac           as character format "x(3)" label "Estado" column-label "UF"
  field tta_cod_imposto                as character format "x(5)" label "Imposto" column-label "Imp"
  field tta_cod_classif_impto          as character format "x(05)" initial "00000" label "Classificaá∆o Imposto" column-label "Classif Imposto"
  field tta_ind_clas_impto             as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
  field tta_cod_plano_cta_ctbl         as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
  field tta_cod_cta_ctbl               as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
  field tta_cod_espec_docto            as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
  field tta_cod_ser_docto              as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
  field tta_cod_tit_ap                 as character format "x(10)" label "T°tulo" column-label "T°tulo"
  field tta_cod_parcela                as character format "x(02)" label "Parcela" column-label "Parcela"
  field tta_val_rendto_tribut          as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
  field tta_val_deduc_inss             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Inss" column-label "Deduá∆o Inss"
  field tta_val_deduc_depend           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Dependentes" column-label "Deduá∆o Dependentes"
  field tta_val_deduc_pensao           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deduá∆o Pens∆o" column-label "Deduá∆o Pens∆o"
  field tta_val_outras_deduc_impto     as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Deduá‰es" column-label "Outras Deduá‰es"
  field tta_val_base_liq_impto         as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L°quida Imposto" column-label "Base L°quida Imposto"
  field tta_val_aliq_impto             as decimal format ">9.9999" decimals 4 initial 0.00 label "Al°quota" column-label "Aliq"
  field tta_val_impto_ja_recolhid      as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J† Recolhido" column-label "Imposto J† Recolhido"
  field tta_val_imposto                as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
  field tta_dat_vencto_tit_ap          as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
  field tta_cod_indic_econ             as character format "x(8)" label "Moeda" column-label "Moeda"
  field tta_val_impto_indic_econ_impto as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
  field tta_des_text_histor            as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
  field tta_cdn_fornec_favorec         as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
  field tta_val_deduc_faixa_impto      as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Deduá∆o"
  field tta_num_id_tit_ap              as integer format "999999999" initial 0 label "Token T°t AP" column-label "Token T°t AP"
  field tta_num_id_movto_tit_ap        as integer format "9999999999" initial 0 label "Token Movto T°t AP" column-label "Id T°t AP"
  field tta_num_id_movto_cta_corren    as integer format "999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
  field tta_cod_pais_ext               as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
  field tta_cod_cta_ctbl_ext           as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
  field tta_cod_sub_cta_ctbl_ext       as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
  field ttv_cod_tip_fluxo_financ_ext   as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
  field tta_val_alimen_deduc_inss      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Aliment Ded INSS" column-label "Vl Alim INSS"
  field tta_val_eqpto_deduc_inss       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Equipto Ded INSS" column-label "Vl Eqto INSS"
  field tta_val_transp_deduc_inss      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Transp Ded INSS" column-label "Vl Trsp INSS"
  field tta_val_nao_retid              as decimal format ">>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor N∆o Retido" column-label "Vl N∆o Retid"
  field tta_cod_process_judic          as character format "x(21)" label "Nr Processo Judicial" column-label "Nr Proc Judic"
  field ttv_rec_integr_apb_impto_pend  as recid format ">>>>>>9"
  index tt_impto_impl_pend_ap_integr    is primary unique
        ttv_rec_integr_apb_item_lote    ascending
        tta_cod_pais                    ascending
        tta_cod_unid_federac            ascending
        tta_cod_imposto                 ascending
        tta_cod_classif_impto           ascending
  index tt_impto_impl_pend_ap_integr_ant is unique
        ttv_rec_antecip_pef_pend        ascending
        tta_cod_pais                    ascending
        tta_cod_unid_federac            ascending
        tta_cod_imposto                 ascending
        tta_cod_classif_impto           ascending
  .
  
define temp-table tt_params_generic_api no-undo
  field ttv_rec_id           as recid format ">>>>>>9"
  field ttv_cod_tabela       as character format "x(28)" label "Tabela" column-label "Tabela"
  field ttv_cod_campo        as character format "x(25)" label "Campo" column-label "Campo"
  field ttv_cod_valor        as character format "x(8)" label "Valor" column-label "Valor"
  index tt_idx_param_generic is primary unique
        ttv_cod_tabela       ascending
        ttv_rec_id           ascending
        ttv_cod_campo        ascending
  .

/* Global Variable Definitions ---                                      */

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_log_atualiza_refer_apb AS LOGICAL     NO-UNDO
    FORMAT "Sim/N∆o":U
    LABEL "Atualiza Referància":U
    COLUMN-LABEL "Atualiza Referància":U
    INITIAL YES
    VIEW-AS TOGGLE-BOX.

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_custo_frete NO-UNDO
    FIELD tta_cod_transp      AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD tta_serie           AS CHARACTER FORMAT "x(5)":U
    FIELD tta_nr_fatura       AS CHARACTER FORMAT "x(16)":U
    FIELD tta_dt_emissao      AS DATE      FORMAT "99/99/9999":U     INITIAL 01/01/1800
    FIELD ttv_dt_vencimento   AS DATE      FORMAT "99/99/9999":U     INITIAL 01/01/1800
    FIELD ttv_cod_estabel     AS CHARACTER FORMAT "x(3)":U
    FIELD ttv_cta_ctbl        AS CHARACTER FORMAT "x(17)":U          INITIAL "":U
    FIELD ttv_val_custo_frete AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD ttv_val_iss         AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD ttv_base_iss        AS DECIMAL   FORMAT ">>>,>>>,>>9.99":U INITIAL 0
    FIELD IDDOC               AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U
    INDEX id_codigo IS PRIMARY UNIQUE
        tta_cod_transp
        tta_serie
        tta_nr_fatura
        tta_dt_emissao.

DEFINE TEMP-TABLE tt-conh-frete NO-UNDO
    FIELD IDDOC            AS INTEGER   FORMAT ">>>>>>>>>>>>>>>9":U
    FIELD cod-transp       AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD serie            AS CHARACTER FORMAT "x(5)":U
    FIELD nr-fatura        AS CHARACTER FORMAT "x(16)":U
    FIELD cod-estabel      AS CHARACTER FORMAT "x(3)":U
    FIELD chave-cte        AS CHARACTER FORMAT "x(50)":U.

DEFINE TEMP-TABLE tt_log_erros NO-UNDO
    FIELD tta_cod_transp    AS INTEGER   FORMAT ">>>>>>>>9":U                     LABEL "Transportadora":U COLUMN-LABEL "Transp":U
    FIELD tta_serie         AS CHARACTER FORMAT "x(5)":U                          LABEL "SÇrie":U          COLUMN-LABEL "Ser":U
    FIELD tta_nr_fatura     AS CHARACTER FORMAT "x(16)":U                         LABEL "Num Fatura":U     COLUMN-LABEL "Fatura":U
    FIELD tta_dt_emissao    AS DATE      FORMAT "99/99/9999":U INITIAL 01/01/1800 LABEL "Dt Emiss∆o":U     COLUMN-LABEL "Dt Emis":U
    FIELD ttv_num_mensagem  AS INTEGER   FORMAT ">>>>,>>9":U                      LABEL "N£mero":U         COLUMN-LABEL "N£mero":U
    FIELD ttv_des_msg_erro  AS CHARACTER FORMAT "x(60)":U                         LABEL "Mensagem":U       COLUMN-LABEL "Mensagem":U
    FIELD ttv_des_msg_ajuda AS CHARACTER FORMAT "x(40)":U                         LABEL "Ajuda":U          COLUMN-LABEL "Ajuda":U.


/* Local Variable Definitions ---                                       */

DEF VAR v_log_refer_uni AS LOG                                  NO-UNDO.
DEF VAR v_cod_refer     AS CHAR                                 NO-UNDO.
DEF VAR v_data          AS DATE INIT TODAY                      NO-UNDO .
DEF VAR v_num_ano_refer AS INT                                  NO-UNDO.
DEF VAR v_num_mes_refer AS INT                                  NO-UNDO.
DEF VAR v_hdl_aux       AS HANDLE                               NO-UNDO.
DEF VAR v_cod_parcela   AS INT                                  NO-UNDO.
DEF VAR v_refer         LIKE tit_ap.cod_refer                   NO-UNDO.
DEF VAR v_cta_ava       LIKE aprop_ctbl_ap.cod_cta_ctbl         NO-UNDO.
DEF VAR v_sdo_df        LIKE tt_custo_frete.ttv_val_custo_frete NO-UNDO.
DEF VAR v_cod_cte       AS CHAR                                 NO-UNDO.

def var v_cod_pais_fornec_clien
    as character
    format "x(8)":U
    no-undo.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER TABLE FOR tt_custo_frete.
DEFINE INPUT  PARAMETER TABLE FOR tt-conh-frete.
DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros.


/* ***************************  Main Block  *************************** */

RUN esp/es0018p.p (INPUT "gk0006", /* Nome do programa  */
                   INPUT 2,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

IF  AVAIL tt-prog-ponto THEN
    ASSIGN v_cta_ava = TRIM(tt-prog-ponto.conteudo).

/* Limpa temp-table de erros */
EMPTY TEMP-TABLE tt_log_erros.

ASSIGN v_log_atualiza_refer_apb = YES /* Atualiza lote (Sim/N∆o)? */
       v_log_refer_uni          = NO
       v_cod_parcela            = 1.

bk-custo-frete:
DO TRANSACTION ON STOP UNDO bk-custo-frete, RETURN "NOK":U:
    FOR EACH tt_custo_frete:
        EMPTY TEMP-TABLE tt_integr_apb_lote_impl.
        EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
        EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
        EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
        EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend.

        FIND FIRST estabelecimento
            WHERE estabelecimento.cod_estab = tt_custo_frete.ttv_cod_estabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelecimento THEN DO:
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                   tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                   tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                   tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                   tt_log_erros.ttv_num_mensagem  = 0
                   tt_log_erros.ttv_des_msg_erro  = "Estabelecimento n∆o encontrado!":U
                   tt_log_erros.ttv_des_msg_ajuda = "Estab: ":U + tt_custo_frete.ttv_cod_estabel.

            RETURN.
        END.

        IF  NOT CAN-FIND(FIRST tt-conh-frete 
            WHERE tt-conh-frete.IDDOC = tt_custo_frete.IDDOC) THEN DO:
            
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                   tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                   tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                   tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                   tt_log_erros.ttv_num_mensagem  = 0
                   tt_log_erros.ttv_des_msg_erro  = "N∆o localizada CTE para o frete.":U
                   tt_log_erros.ttv_des_msg_ajuda = "N∆o localizada CTE para o frete: ":U + tt_custo_frete.tta_nr_fatura.

            RETURN.
        END.

        ASSIGN v_sdo_df = 0
               v_cod_cte = "".

        FOR EACH tt-conh-frete
            WHERE tt-conh-frete.IDDOC      = tt_custo_frete.IDDOC
            AND   tt-conh-frete.chave-cte <> "":
    
            FOR FIRST tit_ap NO-LOCK USE-INDEX titap_id
                WHERE tit_ap.cod_estab          = estabelecimento.cod_estab
                AND   tit_ap.cdn_fornecedor     = tt-conh-frete.cod-transp
                AND   tit_ap.cod_espec_docto    = "DF"
                AND   tit_ap.cod_ser_docto      = tt-conh-frete.serie
                AND   tit_ap.cod_tit_ap         = tt-conh-frete.nr-fatura
                AND   tit_ap.val_sdo_tit_ap     > 0
                AND   tit_ap.log_tit_ap_estordo = NO:

                ASSIGN v_sdo_df  = v_sdo_df  + tit_ap.val_sdo_tit_ap
                       v_cod_cte = v_cod_cte + " / " + tt-conh-frete.nr-fatura.
            END.
        END.

        IF  v_sdo_df  > 0
        AND v_sdo_df <> tt_custo_frete.ttv_val_custo_frete THEN DO:
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                   tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                   tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                   tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                   tt_log_erros.ttv_num_mensagem  = 0
                   tt_log_erros.ttv_des_msg_erro  = "Valor total das CTEÔs n∆o bate com o valor do frete.":U
                   tt_log_erros.ttv_des_msg_ajuda = "Valor total das CTEÔs " + v_cod_cte + " n∆o bate com o valor do frete. Valor CTEÔs: ":U + STRING(v_sdo_df) + " Valor Frete: ":U + STRING(tt_custo_frete.ttv_val_custo_frete).

            RETURN.
        END.

        ASSIGN v_log_refer_uni = NO.

        /* ** Gera Referància V†lida ***/
        REPEAT WHILE NOT v_log_refer_uni:
            RUN pi_retorna_sugestao_referencia (INPUT  "F":U,
                                                INPUT  v_data,
                                                OUTPUT v_cod_refer).

            RUN pi_verifica_refer_unica_apb (INPUT  estabelecimento.cod_estab,
                                             INPUT  v_cod_refer,
                                             INPUT  "lote_impl_tit_ap":U,
                                             INPUT  ?,
                                             OUTPUT v_log_refer_uni).
        END.

        /* ** Criaá∆o do Lote ***/
        CREATE tt_integr_apb_lote_impl.
        ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = estabelecimento.cod_estab
               tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer
               tt_integr_apb_lote_impl.tta_cod_espec_docto   = "":U
               tt_integr_apb_lote_impl.tta_dat_transacao     = v_data
               tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB":U
               tt_integr_apb_lote_impl.tta_cod_empresa       = estabelecimento.cod_empresa.

        RELEASE tt_integr_apb_lote_impl.
        FIND FIRST tt_integr_apb_lote_impl NO-ERROR.

        /* ** T°tulo de Provis∆o ***/
        CREATE tt_integr_apb_item_lote_impl_3.
        ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
               tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = 1
               tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = tt_custo_frete.tta_cod_transp
               tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = "DG":U
               tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = tt_custo_frete.tta_serie
               tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = tt_custo_frete.tta_nr_fatura
               tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = TRIM(STRING(v_cod_parcela, ">9":U))
               tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = tt_custo_frete.tta_dt_emissao
               tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = tt_custo_frete.ttv_dt_vencimento
               tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = tt_custo_frete.ttv_dt_vencimento
               tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = "20":U
               tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = "Real":U
               tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               = tt_custo_frete.ttv_val_custo_frete
               tt_integr_apb_item_lote_impl_3.tta_cod_portador             = "999":U
               tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 1.

        RELEASE tt_integr_apb_item_lote_impl_3.
        FIND FIRST tt_integr_apb_item_lote_impl_3 NO-ERROR.

        /* ** Apropriaá‰es do T°tulo ***/
        CREATE tt_integr_apb_aprop_ctbl_pend.
        ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = "ADM":U
               tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "203":U
               tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = tt_custo_frete.ttv_val_custo_frete
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
               tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = tt_custo_frete.ttv_cta_ctbl.

        RELEASE tt_integr_apb_aprop_ctbl_pend.
        FIND FIRST tt_integr_apb_aprop_ctbl_pend NO-ERROR.

        IF  tt_custo_frete.ttv_val_iss > 0 THEN
            RUN pi_imposto.

        /* ** Transfere o t°tulo para a nova temp-table da API ***/
        CREATE tt_integr_apb_item_lote_impl3v.
        BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.

        RELEASE tt_integr_apb_item_lote_impl3v.
        FIND FIRST tt_integr_apb_item_lote_impl3v NO-ERROR.

        /* ** Chamada da API ***/ 
        RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.

        RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                          INPUT "EMS":U,
                                                          INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl3v).

        DELETE PROCEDURE v_hdl_aux.

        /* ** Retorna erros da API ***/
        FOR EACH tt_log_erros_atualiz :
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                   tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                   tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                   tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                   tt_log_erros.ttv_num_mensagem  = tt_log_erros_atualiz.ttv_num_mensagem
                   tt_log_erros.ttv_des_msg_erro  = tt_log_erros_atualiz.ttv_des_msg_erro
                   tt_log_erros.ttv_des_msg_ajuda = tt_log_erros_atualiz.ttv_des_msg_ajuda. 
        END.

        IF NOT CAN-FIND(FIRST tt_log_erros) THEN DO:
            FIND FIRST tit_ap
                WHERE tit_ap.cod_estab   = estabelecimento.cod_estab
                  AND tit_ap.cdn_fornec  = tt_custo_frete.tta_cod_transp
                  AND tit_ap.cod_espec   = "DG":U
                  AND tit_ap.cod_ser     = tt_custo_frete.tta_serie
                  AND tit_ap.cod_tit_ap  = tt_custo_frete.tta_nr_fatura
                  AND tit_ap.cod_parcela = TRIM(STRING(v_cod_parcela, ">9":U)) NO-LOCK NO-ERROR.

            IF NOT AVAILABLE tit_ap THEN DO:
                CREATE tt_log_erros.
                ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                       tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                       tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                       tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                       tt_log_erros.ttv_num_mensagem  = 0
                       tt_log_erros.ttv_des_msg_erro  = "T°tulo n∆o gerado no contas a pagar !":U
                       tt_log_erros.ttv_des_msg_ajuda = "Estab/Transp/Ser/Tit/Parc/Emis: ":U + estabelecimento.cod_estab + " / ":U + STRING(tt_custo_frete.tta_cod_transp) + " / ":U + tt_custo_frete.tta_serie + "/":U + tt_custo_frete.tta_nr_fatura + " / ":U + TRIM(STRING(v_cod_parcela, ">9":U)) + "/":U + STRING(tt_custo_frete.tta_dt_emissao, "99/99/99":U).
            END.
        END.

        RUN pi_baixa_sdo_conhec.
    END.
    IF CAN-FIND(FIRST tt_log_erros) THEN DO:
       STOP.
    END.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi_baixa_sdo_conhec:

    DEF VAR v_num_pessoa       AS INT NO-UNDO.
    DEF VAR v_num_fatura       AS INT NO-UNDO.
    DEF VAR v_seq_ref          AS INT NO-UNDO.

    DEF BUFFER b-tit_ap FOR tit_ap.

    FIND FIRST emscad.fornecedor 
        WHERE fornecedor.cod_empresa = estabelecimento.cod_empresa
        AND   fornecedor.cdn_fornecedor = tt_custo_frete.tta_cod_transp NO-LOCK NO-ERROR.

    IF  AVAIL fornecedor THEN
        ASSIGN v_num_pessoa = fornecedor.num_pessoa.
    ELSE
        ASSIGN v_num_pessoa = 0.

    FOR EACH tt-conh-frete 
        WHERE tt-conh-frete.IDDOC = tt_custo_frete.IDDOC:

        EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
        EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
        EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

        FOR FIRST b-tit_ap NO-LOCK USE-INDEX titap_id
           WHERE b-tit_ap.cod_estab          = estabelecimento.cod_estab
           AND   b-tit_ap.cdn_fornecedor     = tt-conh-frete.cod-transp
           AND   b-tit_ap.cod_espec_docto    = "DF"
           AND   b-tit_ap.cod_ser_docto      = tt-conh-frete.serie
           AND   b-tit_ap.cod_tit_ap         = tt-conh-frete.nr-fatura
           AND   b-tit_ap.val_sdo_tit_ap     > 0
           AND   b-tit_ap.log_tit_ap_estordo = NO:
        END.
        
        IF  NOT AVAIL b-tit_ap THEN
            NEXT.
        
        /* ** Gera Referància V†lida ***/
        REPEAT WHILE NOT v_log_refer_uni:
            RUN pi_retorna_sugestao_referencia (INPUT  "GKOe":U,
                                                INPUT  TODAY,
                                                OUTPUT v_refer).

            RUN pi_verifica_refer_unica_apb (INPUT  b-tit_ap.cod_estab,
                                             INPUT  v_refer,
                                             INPUT  "":U,
                                             INPUT  ?,
                                             OUTPUT v_log_refer_uni).
        END.

        CREATE tt_tit_ap_alteracao_base_aux_1.
        ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = b-tit_ap.cod_empresa
               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = b-tit_ap.cod_estab
               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = b-tit_ap.num_id_tit_ap
               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(b-tit_ap)
               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = TODAY
               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_refer
               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = 0
               tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = 1
               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Baixa"
               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = b-tit_ap.ind_sit_tit_ap
               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = b-tit_ap.dat_emis_docto
               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = b-tit_ap.dat_vencto_tit_ap
               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = b-tit_ap.dat_vencto_tit_ap
               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = b-tit_ap.dat_prev_pagto
               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = b-tit_ap.num_dias_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = b-tit_ap.val_perc_multa_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = b-tit_ap.val_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = b-tit_ap.val_perc_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = b-tit_ap.dat_desconto
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = b-tit_ap.val_perc_desc
               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = b-tit_ap.val_desconto
               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = b-tit_ap.cod_indic_econ.
        VALIDATE tt_tit_ap_alteracao_base_aux_1.

        CREATE tt_tit_ap_alteracao_rateio.
        ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = RECID(b-tit_ap)
               tt_tit_ap_alteracao_rateio.tta_cod_estab             = b-tit_ap.cod_estab
               tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = b-tit_ap.num_id_tit_ap
               tt_tit_ap_alteracao_rateio.tta_cod_refer             = v_refer
               tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = 1
               tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = "PADRAO"
               tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = v_cta_ava /* es0018 - prog: gk0006 - ponto: 2 */
               tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
               tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor"
               tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl        = b-tit_ap.val_sdo_tit_ap.
        VALIDATE tt_tit_ap_alteracao_rateio.

        IF  CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) THEN 
            RUN prgfin/apb/apb767ze.py(INPUT 1,
                                       INPUT "",
                                       INPUT "",
                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                       OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

        IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao) THEN DO:
            
            FOR EACH tt_log_erros_tit_ap_alteracao:
                CREATE tt_log_erros.
                ASSIGN tt_log_erros.tta_cod_transp    = tt_custo_frete.tta_cod_transp
                       tt_log_erros.tta_serie         = tt_custo_frete.tta_serie     
                       tt_log_erros.tta_nr_fatura     = tt_custo_frete.tta_nr_fatura 
                       tt_log_erros.tta_dt_emissao    = tt_custo_frete.tta_dt_emissao
                       tt_log_erros.ttv_num_mensagem  = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                       tt_log_erros.ttv_des_msg_erro  = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                       tt_log_erros.ttv_des_msg_ajuda = tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda_1. 
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_ind_tip_atualiz AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_dat_refer       AS DATE        NO-UNDO FORMAT "99/99/9999":U.
    DEFINE OUTPUT PARAMETER p_cod_refer       AS CHARACTER   NO-UNDO FORMAT "x(10)":U.

    DEFINE VARIABLE v_des_dat   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_aux   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_aux_2 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_cont  AS INTEGER     NO-UNDO.

    ASSIGN v_des_dat   = STRING(p_dat_refer, "99999999":U)
           p_cod_refer = SUBSTRING(v_des_dat, 7, 2) + SUBSTRING(v_des_dat, 3, 2) + SUBSTRING(v_des_dat, 1, 2) + SUBSTRING(p_ind_tip_atualiz, 1, 1)
           v_num_aux_2 = INTEGER(THIS-PROCEDURE:HANDLE).

    DO v_num_cont = 1 TO 3:
        ASSIGN v_num_aux   = (RANDOM(0, v_num_aux_2) MODULO 26) + 97
               p_cod_refer = p_cod_refer + CHR(v_num_aux).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_cod_estab        AS CHARACTER   NO-UNDO FORMAT "x(3)":U.
    DEFINE INPUT  PARAMETER p_cod_refer        AS CHARACTER   NO-UNDO FORMAT "x(10)":U.
    DEFINE INPUT  PARAMETER p_cod_table        AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_rec_movto_tit_ap AS RECID       NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_log_refer_uni    AS LOGICAL     NO-UNDO FORMAT "Sim/N∆o":U.

    DEFINE BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEFINE BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEFINE BUFFER b_lote_pagto       FOR lote_pagto.
    DEFINE BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    IF p_cod_table <> "antecip_pef_pend":U THEN
        FIND FIRST b_antecip_pef_pend
            WHERE b_antecip_pef_pend.cod_estab = p_cod_estab
              AND b_antecip_pef_pend.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

    IF AVAILABLE b_antecip_pef_pend THEN
        ASSIGN p_log_refer_uni = NO.
    ELSE DO:
        IF p_cod_table <> "lote_impl_tit_ap":U THEN
            FIND FIRST b_lote_impl_tit_ap
                WHERE b_lote_impl_tit_ap.cod_estab = p_cod_estab
                  AND b_lote_impl_tit_ap.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_impl_tit_ap THEN
            ASSIGN p_log_refer_uni = NO.
        ELSE DO:
            IF p_cod_table <> "lote_pagto":U THEN
                FIND FIRST b_lote_pagto
                    WHERE b_lote_pagto.cod_estab_refer = p_cod_estab
                      AND b_lote_pagto.cod_refer       = p_cod_refer NO-LOCK NO-ERROR.

            IF AVAILABLE b_lote_pagto THEN
                ASSIGN p_log_refer_uni = NO.
            ELSE DO:
                FIND FIRST b_movto_tit_ap
                    WHERE b_movto_tit_ap.cod_estab = p_cod_estab
                      AND b_movto_tit_ap.cod_refer = p_cod_refer
                      AND RECID(b_movto_tit_ap)   <> p_rec_movto_tit_ap NO-LOCK NO-ERROR.

                IF AVAILABLE b_movto_tit_ap THEN
                    ASSIGN p_log_refer_uni = NO.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_imposto:
    FIND FIRST fornec_financ
        WHERE fornec_financ.cod_empresa    = tt_integr_apb_lote_impl.tta_cod_empresa
          AND fornec_financ.cdn_fornecedor = tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor NO-LOCK NO-ERROR.

    IF AVAIL fornec_financ THEN DO:
        FIND FIRST impto_vincul_fornec
            WHERE impto_vincul_fornec.cod_empresa       = fornec_financ.cod_empresa
              AND impto_vincul_fornec.cdn_fornecedor    = fornec_financ.cdn_fornecedor
              AND impto_vincul_fornec.cod_classif_impto = "0001":U /* ISS */ NO-LOCK NO-ERROR.

        IF AVAILABLE impto_vincul_fornec THEN DO:
            FIND FIRST imposto
                WHERE imposto.cod_pais         = impto_vincul_fornec.cod_pais
                  AND imposto.cod_unid_federac = impto_vincul_fornec.cod_unid_federac
                  AND imposto.cod_imposto      = impto_vincul_fornec.cod_imposto NO-LOCK NO-ERROR.

            IF AVAILABLE imposto THEN DO:
                FIND FIRST classif_impto
                    WHERE classif_impto.cod_pais         = imposto.cod_pais
                      AND classif_impto.cod_unid_federac = imposto.cod_unid_federac
                      AND classif_impto.cod_imposto      = imposto.cod_imposto NO-LOCK NO-ERROR.

                IF AVAILABLE classif_impto THEN DO:
                    FIND FIRST impto_vincul_empres
                        WHERE impto_vincul_empres.cod_pais         = imposto.cod_pais
                          AND impto_vincul_empres.cod_unid_federac = imposto.cod_unid_federac
                          AND impto_vincul_empres.cod_imposto      = imposto.cod_imposto
                          AND impto_vincul_empres.cod_empresa      = impto_vincul_fornec.cod_empresa NO-LOCK NO-ERROR.

                    IF AVAILABLE impto_vincul_empres THEN DO:
                        FIND FIRST histor_impto_empres
                            WHERE histor_impto_empres.cod_pais         = impto_vincul_empres.cod_pais
                              AND histor_impto_empres.cod_unid_federac = impto_vincul_empres.cod_unid_federac
                              AND histor_impto_empres.cod_imposto      = impto_vincul_empres.cod_imposto
                              AND histor_impto_empres.cod_empresa      = impto_vincul_empres.cod_empresa NO-LOCK NO-ERROR.

                        IF AVAILABLE histor_impto_empres THEN DO:
                            CREATE tt_integr_apb_impto_impl_pend.
                            ASSIGN tt_integr_apb_impto_impl_pend.ttv_rec_integr_apb_item_lote   = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote
                                   tt_integr_apb_impto_impl_pend.ttv_rec_antecip_pef_pend       = ?
                                   tt_integr_apb_impto_impl_pend.tta_cod_pais                   = impto_vincul_fornec.cod_pais
                                   tt_integr_apb_impto_impl_pend.tta_cod_unid_federac           = impto_vincul_fornec.cod_unid_federac
                                   tt_integr_apb_impto_impl_pend.tta_cod_imposto                = impto_vincul_fornec.cod_imposto
                                   tt_integr_apb_impto_impl_pend.tta_cod_classif_impto          = impto_vincul_fornec.cod_classif_impto
                                   tt_integr_apb_impto_impl_pend.tta_cod_espec_docto            = imposto.cod_espec_docto_impto
                                   tt_integr_apb_impto_impl_pend.tta_cod_ser_docto              = imposto.cod_ser_docto_impto
                                   tt_integr_apb_impto_impl_pend.tta_cod_tit_ap                 = tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap
                                   tt_integr_apb_impto_impl_pend.tta_cod_parcela                = tt_integr_apb_item_lote_impl_3.tta_cod_parcela
                                   tt_integr_apb_impto_impl_pend.tta_ind_clas_impto             = imposto.ind_clas_impto
                                   tt_integr_apb_impto_impl_pend.tta_cod_plano_cta_ctbl         = histor_impto_empres.cod_plano_cta_ctbl
                                   tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl               = histor_impto_empres.cod_cta_ctbl_db
                                   tt_integr_apb_impto_impl_pend.tta_val_rendto_tribut          = tt_custo_frete.ttv_base_iss
                                   tt_integr_apb_impto_impl_pend.tta_val_deduc_inss             = 0
                                   tt_integr_apb_impto_impl_pend.tta_val_deduc_depend           = 0
                                   tt_integr_apb_impto_impl_pend.tta_val_deduc_pensao           = 0
                                   tt_integr_apb_impto_impl_pend.tta_val_outras_deduc_impto     = 0
                                   tt_integr_apb_impto_impl_pend.tta_val_base_liq_impto         = tt_custo_frete.ttv_base_iss
                                   tt_integr_apb_impto_impl_pend.tta_val_aliq_impto             = classif_impto.val_aliq_impto
                                   tt_integr_apb_impto_impl_pend.tta_val_impto_ja_recolhid      = 0
                                   tt_integr_apb_impto_impl_pend.tta_val_imposto                = tt_custo_frete.ttv_val_iss
                                   tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap          = ?
                                   tt_integr_apb_impto_impl_pend.tta_cod_indic_econ             = histor_impto_empres.cod_finalid_econ
                                   tt_integr_apb_impto_impl_pend.tta_val_impto_indic_econ_impto = 0
                                   tt_integr_apb_impto_impl_pend.tta_des_text_histor            = "":U
                                   tt_integr_apb_impto_impl_pend.tta_cdn_fornec_favorec         = histor_impto_empres.cdn_fornec_favorec
                                   tt_integr_apb_impto_impl_pend.tta_val_deduc_faixa_impto      = 0
                                   tt_integr_apb_impto_impl_pend.tta_num_id_tit_ap              = ?
                                   tt_integr_apb_impto_impl_pend.tta_num_id_movto_tit_ap        = ?
                                   tt_integr_apb_impto_impl_pend.tta_num_id_movto_cta_corren    = ?
                                   tt_integr_apb_impto_impl_pend.tta_cod_pais_ext               = "":U
                                   tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl_ext           = "":U
                                   tt_integr_apb_impto_impl_pend.tta_cod_sub_cta_ctbl_ext       = "":U
                                   tt_integr_apb_impto_impl_pend.ttv_cod_tip_fluxo_financ_ext   = "":U.

                            if  imposto.ind_tip_impto <> "Imposto Sobre Valor Agregado" then
                                run pi_calcular_data_vencimento_impto (Input tt_integr_apb_lote_impl.tta_cod_estab,
                                                                       Input tt_integr_apb_lote_impl.tta_dat_transacao,
                                                                       Input tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto,
                                                                       Input tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap).


                        END.
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_calcular_data_vencimento_impto:

    def Input param p_cod_estab         as char format "x(5)"       no-undo.
    def Input param p_dat_transacao     as date format "99/99/9999" no-undo.
    def Input param p_dat_emis_docto    as date format "99/99/9999" no-undo.
    def Input param p_dat_vencto_tit_ap as date format "99/99/9999" no-undo.

    def var v_dat_return as date format "99/99/9999":U no-undo.

    if  not avail tt_integr_apb_impto_impl_pend then
        return error.

    assign v_dat_return = tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap.

    run pi_calcular_data_vencimento_impto_1 (Input p_cod_estab,
                                             Input p_dat_transacao,
                                             Input p_dat_emis_docto,
                                             Input p_dat_vencto_tit_ap,
                                             input tt_integr_apb_impto_impl_pend.tta_cdn_fornec_favorec,
                                             Input tt_integr_apb_impto_impl_pend.tta_cod_pais,
                                             input-output v_dat_return).

    assign tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap = v_dat_return.

    /*
    if  GetEntryField(1, return-value, ',') <> "OK" /*l_ok*/ then do:
        case GetEntryField(1, return-value, ','):
            when "3896" then

                /* Calend†rio p/ &1 Inexistente ! */
                run pi_messages (input "show",
                                 input 3896,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "Aplicativo Financeiro" /*l_aplicativo_financeiro*/)).

            when "3897" then

                /* Data &1 inexistente no calend†rio &2 ! */
                run pi_messages (input "show",
                                 input 3897,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    GetEntryField(2, return-value, ','), GetEntryField(3, return-value, ','))).

        end.
        return error.
    end.
    */
END PROCEDURE.

PROCEDURE pi_calcular_data_vencimento_impto_1:

    def input param p_cod_estab                       as char format "x(5)"        no-undo.
    def input param p_dat_transacao                   as date format "99/99/9999"  no-undo.
    def input param p_dat_emis_docto                  as date format "99/99/9999"  no-undo.
    def input param p_dat_vencto_tit_ap               as date format "99/99/9999"  no-undo.
    def input param p_cdn_fornec_favorec              as int  format ">>>,>>>,>>9" no-undo.
    def input param p_cod_pais                        as char format "x(3)"        no-undo.
    def input-output param p_dat_vencto_tit_ap_return as date format "99/99/9999"  no-undo.
    
    def var v_cod_return      as char format "x(40)":U                       no-undo.
    def var v_dat_impto       as date format "99/99/9999":U                  no-undo.
    def var v_dat_return      as date format "99/99/9999":U                  no-undo.
    def var v_log_fer         as log  format "Sim/N∆o" init no               no-undo.
    def var v_num_ano         as int  format "9999":U  init 0001 label "Ano" no-undo.
    def var v_num_mes         as int  format "99":U    init 01   label "Màs" no-undo.
    def var v_num_ult_dia_mes as int  format ">>>>,>>9":U                    no-undo.

    /* Calculo Dt Vencto */
    case imposto.ind_base_vencto_impto:
        when "Emiss∆o" then
            assign p_dat_vencto_tit_ap_return = p_dat_emis_docto.
        when "Transaá∆o" then
            assign p_dat_vencto_tit_ap_return = p_dat_transacao.
        when "Implantaá∆o" then
            assign p_dat_vencto_tit_ap_return = p_dat_transacao.
        when "Vencto" then
            assign p_dat_vencto_tit_ap_return = p_dat_vencto_tit_ap.
        when "Pagto" then
            assign p_dat_vencto_tit_ap_return = p_dat_vencto_tit_ap.
    end.

    case imposto.ind_vencto_impto:
        when "Semana" then
            assign p_dat_vencto_tit_ap_return = p_dat_vencto_tit_ap_return + (7 - weekday(p_dat_vencto_tit_ap_return)).
        when "Quinzena" then
            quinzena:
            do:
                if  day(p_dat_vencto_tit_ap_return) < 16 then do:
                   assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), 15, year(p_dat_vencto_tit_ap_return)).
                end.
                else do:
                    run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                                   output v_num_ult_dia_mes).
                    assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
                end.
            end.
        when "Màs" then
            mes:
            do:
                run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                               output v_num_ult_dia_mes).
                assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
            end.
        when "Bimestre" or
        when "Trimestre" then
            bimestre_trimestre:
            do:
                case imposto.nom_mes_inic_period_impto:
                    when "Janeiro" then   assign v_num_mes = 1.
                    when "Fevereiro" then assign v_num_mes = 2.
                    when "Maráo" then     assign v_num_mes = 3.
                    when "Abril" then     assign v_num_mes = 4.
                    when "Maio" then      assign v_num_mes = 5.
                    when "Junho" then     assign v_num_mes = 6.
                    when "Julho" then     assign v_num_mes = 7.
                    when "Agosto" then    assign v_num_mes = 8.
                    when "Setembro" then  assign v_num_mes = 9.
                    when "Outubro" then   assign v_num_mes = 10.
                    when "Novembro" then  assign v_num_mes = 11.
                    when "Dezembro" then  assign v_num_mes = 12.
                end.
                if  imposto.ind_vencto_impto = "Bimestre" then do:
                    if  (v_num_mes modulo 2) = (month(p_dat_vencto_tit_ap_return) modulo 2) then do:
                        assign v_num_mes = month(p_dat_vencto_tit_ap_return) + 1
                               v_num_ano = year(p_dat_vencto_tit_ap_return).
                        
                        if  v_num_mes = 13 then do:
                            assign v_num_mes = 1
                                   v_num_ano = v_num_ano + 1.
                        end.
                        
                        assign p_dat_vencto_tit_ap_return = date(v_num_mes, 1, v_num_ano).
                        
                        run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                                       output v_num_ult_dia_mes).
                        assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
                    end.
                    else do:
                        run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                                       output v_num_ult_dia_mes).
                        assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
                    end.
                end.
                else do:
                    case v_num_mes:
                        when 01 or
                        when 04 or
                        when 07 or
                        when 10 then
                            case month(p_dat_vencto_tit_ap_return):
                                when 01 or
                                when 02 or
                                when 03 then assign p_dat_vencto_tit_ap_return = date(03, 01, year(p_dat_vencto_tit_ap_return)).
                                when 04 or
                                when 05 or
                                when 06 then assign p_dat_vencto_tit_ap_return = date(06, 01, year(p_dat_vencto_tit_ap_return)).
                                when 07 or
                                when 08 or
                                when 09 then assign p_dat_vencto_tit_ap_return = date(09, 01, year(p_dat_vencto_tit_ap_return)).
                                when 10 or
                                when 11 or
                                when 12 then assign p_dat_vencto_tit_ap_return = date(12, 01, year(p_dat_vencto_tit_ap_return)).
                             end.
                        when 02 or
                        when 05 or
                        when 08 or
                        when 11 then
                            case month(p_dat_vencto_tit_ap_return):
                                when 02 or
                                when 03 or
                                when 04 then assign p_dat_vencto_tit_ap_return = date(04, 01, year(p_dat_vencto_tit_ap_return)).
                                when 05 or
                                when 06 or
                                when 07 then assign p_dat_vencto_tit_ap_return = date(07, 01, year(p_dat_vencto_tit_ap_return)).
                                when 08 or
                                when 09 or
                                when 10 then assign p_dat_vencto_tit_ap_return = date(10, 01, year(p_dat_vencto_tit_ap_return)).
                                when 11 or
                                when 12 then assign p_dat_vencto_tit_ap_return = date(01, 01, year(p_dat_vencto_tit_ap_return) + 1).
                                when 01 then assign p_dat_vencto_tit_ap_return = date(01, 01, year(p_dat_vencto_tit_ap_return)).
                             end.
                        when 03 or
                        when 06 or
                        when 09 or
                        when 12 then
                            case month(p_dat_vencto_tit_ap_return):
                                when 12 then assign p_dat_vencto_tit_ap_return = date(02, 01, year(p_dat_vencto_tit_ap_return) + 1).
                                when 01 or
                                when 02 then assign p_dat_vencto_tit_ap_return = date(02, 01, year(p_dat_vencto_tit_ap_return)).
                                when 03 or
                                when 04 or
                                when 05 then assign p_dat_vencto_tit_ap_return = date(05, 01, year(p_dat_vencto_tit_ap_return)).
                                when 06 or
                                when 07 or
                                when 08 then assign p_dat_vencto_tit_ap_return = date(08, 01, year(p_dat_vencto_tit_ap_return)).
                                when 09 or
                                when 10 or
                                when 11 then assign p_dat_vencto_tit_ap_return = date(11, 01, year(p_dat_vencto_tit_ap_return)).
                             end.
                    end.
                    
                    run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                                   output v_num_ult_dia_mes).
                    assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
                end.
            end.
        when "Decàndio" then
            decendio:
            do:
                if  day(p_dat_vencto_tit_ap_return) < 11 then
                    assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), 10, year(p_dat_vencto_tit_ap_return)).
                else do:
                    if  day(p_dat_vencto_tit_ap_return) < 21 then
                        assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), 20, year(p_dat_vencto_tit_ap_return)).
                    else do:
                        run pi_retorna_ultimo_dia_mes (Input p_dat_vencto_tit_ap_return,
                                                       output v_num_ult_dia_mes).
                        assign p_dat_vencto_tit_ap_return = date(month(p_dat_vencto_tit_ap_return), v_num_ult_dia_mes, year(p_dat_vencto_tit_ap_return)).
                    end.
                end.
            end.
    end.
    if  imposto.ind_tip_dia_calc_vencto = "Dias Corridos" then do:
        assign p_dat_vencto_tit_ap_return = p_dat_vencto_tit_ap_return + imposto.num_dias_vencto_impto.
    end.
    else do:
        run pi_atualiza_cod_pais (Input v_cod_empres_usuar,
                                  Input p_cdn_fornec_favorec).

        run pi_retornar_dia_util (Input p_cod_estab,
                                  Input "Respons†vel Financeiro",
                                  Input imposto.num_dias_vencto_impto,
                                  Input p_dat_vencto_tit_ap_return,
                                  output v_dat_return,
                                  output v_cod_return).
        /*
        if  v_cod_return = ? or GetEntryField(1, v_cod_return, ',') <> "OK" /*l_ok*/ 
        then do:
            return v_cod_return.
        end.
        else do:
            assign p_dat_vencto_tit_ap_return = v_dat_return.
        end /* else */.
        */
    end.

    run pi_retornar_data_pagto_impto (Input p_dat_vencto_tit_ap_return,
                                      Input p_cod_estab,
                                      output v_dat_impto,
                                      Input p_cdn_fornec_favorec,
                                      Input p_cod_pais).
    if  v_dat_impto <> ? then do:   
        find fornec_financ
            where fornec_financ.cod_empresa    = v_cod_empres_usuar
            and   fornec_financ.cdn_fornecedor = p_cdn_fornec_favorec
            no-lock no-error.
       
        if  avail fornec_financ then do:
            for each fer_nac no-lock
                where fer_nac.cod_pais     = p_cod_pais
                and   fer_nac.dat_fer_nac    = p_dat_vencto_tit_ap_return:
                assign v_log_fer = yes.
            end.
           
            if  weekday(p_dat_vencto_tit_ap_return) = 1
            or  weekday(p_dat_vencto_tit_ap_return) = 7
            or  v_log_fer then do:
                assign p_dat_vencto_tit_ap_return = v_dat_impto.
            end.
        end.
    end.
    
    return "OK".

END PROCEDURE.

PROCEDURE pi_retornar_dia_util:

    def input  param p_cod_estab      as char format "x(5)"       no-undo.
    def input  param p_ind_tip_calend as char format "X(08)"      no-undo.
    def input  param p_num_dias       as int  format ">>>>,>>9"   no-undo.
    def input  param p_dat_base       as date format "99/99/9999" no-undo.
    def output param p_dat_return     as date format "99/99/9999" no-undo.
    def output param p_cod_return     as char format "x(40)"      no-undo.

    def var v_log_fer as log format "Sim/N∆o" initial no                             no-undo.
    def var v_num_seq as int format ">>>,>>9":U label "SeqÅància" column-label "Seq" no-undo.

    assign p_cod_return = "OK".

    find estabelecimento
        where estabelecimento.cod_estab = p_cod_estab no-lock no-error.
    case p_ind_tip_calend:
        when "Respons†vel Financeiro" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                no-lock no-error.
        when "Materiais" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_mater
                no-lock no-error.
        when "R.H." then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_rh
                no-lock no-error.
        when "Manufatura" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                no-lock no-error.
        when "Distribuiá∆o" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                no-lock no-error.
    end.
    if  not avail calend_glob then do:
        assign p_cod_return = "3896".
        return.
    end.

    assign p_dat_return = p_dat_base.

    if  p_num_dias = 0 then do:
        acha_dia_util:
        repeat:
            find dia_calend_glob
                where dia_calend_glob.cod_calend = calend_glob.cod_calend
                and   dia_calend_glob.dat_calend = p_dat_return
                no-lock no-error.
            if  not avail dia_calend_glob then do:
                assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                return.
            end.

            if  dia_calend_glob.log_dia_util = yes then do:
                assign v_log_fer = no.
                for each fer_nac no-lock
                    where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      assign v_log_fer = yes.
                end.
                if  not v_log_fer then
                    leave acha_dia_util.
                else 
                    assign p_dat_return = p_dat_return + 1.
            end.

            else do:
                assign p_dat_return = p_dat_return + 1.
            end.
        end.
    end.
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            assign p_dat_return = p_dat_return + 1.
            acha_dia_util:
            repeat:
                find dia_calend_glob
                    where dia_calend_glob.cod_calend = calend_glob.cod_calend
                    and   dia_calend_glob.dat_calend = p_dat_return
                    no-lock no-error.
                if  not avail dia_calend_glob then do:
                    assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                    return.
                end.

                if  dia_calend_glob.log_dia_util = yes then do:
                    assign v_log_fer = no.
                    for each fer_nac no-lock
                        where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          assign v_log_fer = yes.
                    end.
                    if  not v_log_fer then
                        leave acha_dia_util.
                    else 
                        assign p_dat_return = p_dat_return + 1.
                end.

                else do:
                    assign p_dat_return = p_dat_return + 1.
                end.
            end.
        end.
    end.

END PROCEDURE.

PROCEDURE pi_retorna_ultimo_dia_mes:

    def input  param p_dat_transacao   as date format "99/99/9999" no-undo.
    def output param p_num_ult_dia_mes as int  format ">>>>,>>9"   no-undo.

    def var v_num_ano as int no-undo.
    def var v_num_mes as int no-undo.

    assign v_num_mes = month(p_dat_transacao) + 1
           v_num_ano = year(p_dat_transacao).

    if  v_num_mes = 13 then do:
        assign v_num_mes = 1
               v_num_ano = v_num_ano + 1.
    end.

    assign p_num_ult_dia_mes = day(date(v_num_mes, 01, v_num_ano) - 1).

END PROCEDURE.

PROCEDURE pi_retornar_data_pagto_impto:

    def input  param p_dat_vencto_tit_ap  as date format "99/99/9999"  no-undo.
    def input  param p_cod_estab          as char format "x(5)"        no-undo.
    def output param p_dat_prev_pagto     as date format "99/99/9999"  no-undo.
    def input  param p_cdn_fornec_favorec as int  format ">>>,>>>,>>9" no-undo.
    def input  param p_cod_pais           as char format "x(3)"        no-undo.

    def var v_cod_return as char format "x(40)":U         no-undo.
    def var v_dat_return as date format "99/99/9999":U    no-undo.
    def var v_log_fer    as log  format "Sim/N∆o" init no no-undo.

    find fornec_financ
        where fornec_financ.cod_empresa    = v_cod_empres_usuar
        and   fornec_financ.cdn_fornecedor = p_cdn_fornec_favorec
        no-lock no-error.
    
    if  avail fornec_financ then do:
        run pi_atualiza_cod_pais (Input v_cod_empres_usuar,
                                  Input p_cdn_fornec_favorec).
        for each fer_nac no-lock
            where fer_nac.cod_pais     = p_cod_pais
              and fer_nac.dat_fer_nac  = p_dat_vencto_tit_ap:
              assign v_log_fer = yes.
        end.
        if  v_log_fer then do:
            if  fornec_financ.ind_tratam_vencto_fer = "Adianta" then do:
                run pi_retornar_dia_util_anterior (Input p_cod_estab,
                                                   Input "Respons†vel Financeiro",
                                                   Input 0,
                                                   Input p_dat_vencto_tit_ap,
                                                   output v_dat_return,
                                                   output v_cod_return).
                if  v_cod_return = "OK" then
                    assign p_dat_prev_pagto = v_dat_return.
            end.
            if  fornec_financ.ind_tratam_vencto_fer = "Prorroga" then do:
                run pi_retornar_dia_util (Input p_cod_estab,
                                          Input "Respons†vel Financeiro",
                                          Input 0,
                                          Input p_dat_vencto_tit_ap,
                                          output v_dat_return,
                                          output v_cod_return).

                if  v_cod_return = "OK" then
                    assign p_dat_prev_pagto = v_dat_return.
            end.
        end.
        if  weekday(p_dat_vencto_tit_ap) = 1 then do:
            if  fornec_financ.ind_tratam_vencto_dom = "Adianta" then do:
                run pi_retornar_dia_util_anterior (Input p_cod_estab,
                                                   Input "Respons†vel Financeiro",
                                                   Input 0,
                                                   Input p_dat_vencto_tit_ap,
                                                   output v_dat_return,
                                                   output v_cod_return).
                if  v_cod_return = "OK" then
                    assign p_dat_prev_pagto = v_dat_return.
            end.
            if  fornec_financ.ind_tratam_vencto_dom = "Prorroga" then do:
                run pi_retornar_dia_util (Input p_cod_estab,
                                          Input "Respons†vel Financeiro",
                                          Input 0,
                                          Input p_dat_vencto_tit_ap,
                                          output v_dat_return,
                                          output v_cod_return).

                if  v_cod_return = "OK" then
                    assign p_dat_prev_pagto = v_dat_return.
            end.
        end.
        else do:
            if  weekday(p_dat_vencto_tit_ap) = 7 then do:
                if  fornec_financ.ind_tratam_vencto_sab = "Adianta" then do:
                    run pi_retornar_dia_util_anterior (Input p_cod_estab,
                                                       Input "Respons†vel Financeiro",
                                                       Input 0,
                                                       Input p_dat_vencto_tit_ap,
                                                       output v_dat_return,
                                                       output v_cod_return).
                    if  v_cod_return = "OK" then
                        assign p_dat_prev_pagto = v_dat_return.
                end.
                if  fornec_financ.ind_tratam_vencto_sab = "Prorroga" then do:
                    run pi_retornar_dia_util (Input p_cod_estab,
                                              Input "Respons†vel Financeiro",
                                              Input 0,
                                              Input p_dat_vencto_tit_ap,
                                              output v_dat_return,
                                              output v_cod_return).

                    if  v_cod_return = "OK" then
                        assign p_dat_prev_pagto = v_dat_return.
                end.
            end.
            else do:
                find calend_glob
                    where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                    no-lock no-error.
                if  avail calend_glob then do:
                    find dia_calend_glob
                        where dia_calend_glob.cod_calend = calend_glob.cod_calend
                        and   dia_calend_glob.dat_calend = p_dat_vencto_tit_ap
                        no-lock no-error.
                    if  avail dia_calend_glob then do:
                        find clas_dia_calend
                            where clas_dia_calend.cod_clas_dia_calend = dia_calend_glob.cod_clas_dia_calend
                            no-lock no-error.
                        if  clas_dia_calend.ind_tip_dia_calend = "Feriado"
                        and clas_dia_calend.ind_tip_dia_calend = "Feriado Banc†rio" then do:
                            if  fornec_financ.ind_tratam_vencto_fer = "Adianta" then do:
                                run pi_retornar_dia_util_anterior (Input p_cod_estab,
                                                                   Input "Respons†vel Financeiro",
                                                                   Input 0,
                                                                   Input p_dat_vencto_tit_ap,
                                                                   output v_dat_return,
                                                                   output v_cod_return).
                                if  v_cod_return = "OK" then
                                    assign p_dat_prev_pagto = v_dat_return.
                            end.
                            if  fornec_financ.ind_tratam_vencto_fer = "Prorroga" then do:
                                run pi_retornar_dia_util (Input p_cod_estab,
                                                          Input "Respons†vel Financeiro",
                                                          Input 0,
                                                          Input p_dat_vencto_tit_ap,
                                                          output v_dat_return,
                                                          output v_cod_return).

                                if  v_cod_return = "OK" then
                                    assign p_dat_prev_pagto = v_dat_return.
                            end.
                        end.
                    end.
                end.
            end.
        end.
    end.

END PROCEDURE.

PROCEDURE pi_retornar_dia_util_anterior:

    def input  param p_cod_estab      as char format "x(5)"       no-undo.
    def input  param p_ind_tip_calend as char format "X(08)"      no-undo.
    def input  param p_num_dias       as int  format ">>>>,>>9"   no-undo.
    def input  param p_dat_base       as date format "99/99/9999" no-undo.
    def output param p_dat_return     as date format "99/99/9999" no-undo.
    def output param p_cod_return     as char format "x(40)"      no-undo.

    def var v_log_fer as log format "Sim/N∆o" init                                   no no-undo.
    def var v_num_seq as int format ">>>,>>9":U label "SeqÅància" column-label "Seq" no-undo.

    assign p_cod_return = "OK".

    find estabelecimento
        where estabelecimento.cod_estab = p_cod_estab no-lock no-error.

    case p_ind_tip_calend:
        when "Respons†vel Financeiro" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                no-lock no-error.
        when "Materiais" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_mater
                no-lock no-error.
        when "R.H." then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_rh
                no-lock no-error.
        when "Manufatura" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                no-lock no-error.
        when "Distribuiá∆o" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                no-lock no-error.
    end.
    if  not avail calend_glob
    then do:
        assign p_cod_return = "3896".
    end.

    assign p_dat_return = p_dat_base.

    if  p_num_dias = 0 then do:
        acha_dia_util:
        repeat:
            find dia_calend_glob
                where dia_calend_glob.cod_calend = calend_glob.cod_calend
                and   dia_calend_glob.dat_calend = p_dat_return
                no-lock no-error.
            if  not avail dia_calend_glob then do:
                assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                return.
            end.

            if  dia_calend_glob.log_dia_util = yes then do:
            assign v_log_fer = no.
                for each fer_nac no-lock
                    where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      assign v_log_fer = yes.
                end.
                
                if  not v_log_fer then
                    leave acha_dia_util.
                else 
                    assign p_dat_return = p_dat_return - 1.
            end.

            else do:
                assign p_dat_return = p_dat_return - 1.
            end.
        end.
    end.
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            assign p_dat_return = p_dat_return - 1.
            acha_dia_util:
            repeat:
                find dia_calend_glob
                    where dia_calend_glob.cod_calend = calend_glob.cod_calend
                    and   dia_calend_glob.dat_calend = p_dat_return
                    no-lock no-error.
                if  not avail dia_calend_glob then do:
                    assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                    return.
                end.

                if  dia_calend_glob.log_dia_util = yes then do:
                    assign v_log_fer = no.

                    for each fer_nac no-lock
                        where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          assign v_log_fer = yes.
                    end.

                    if  not v_log_fer then
                        leave acha_dia_util.
                    else 
                        assign p_dat_return = p_dat_return - 1.
                end.
                else do:
                    assign p_dat_return = p_dat_return - 1.
                end.
            end.
        end.
    end.

END PROCEDURE.

PROCEDURE pi_atualiza_cod_pais:

    def Input param p_cod_empres_usuar   as character format "x(3)"      no-undo.
    def Input param p_cdn_fornec_favorec as Integer format ">>>,>>>,>>9" no-undo.

    def buffer b_fornecedor for emscad.fornecedor.

    if  not avail fornec_financ then
        find fornec_financ
             where fornec_financ.cod_empresa    = p_cod_empres_usuar
             and   fornec_financ.cdn_fornecedor = p_cdn_fornec_favorec no-lock no-error.

    if avail fornec_financ then do:
        if  avail emscad.fornecedor then
            assign v_cod_pais_fornec_clien = emscad.fornecedor.cod_pais.
        else do:
            find b_fornecedor 
                 where b_fornecedor.cod_empresa    = fornec_financ.cod_empresa    
                   and b_fornecedor.cdn_fornecedor = fornec_financ.cdn_fornecedor no-lock no-error.
            if  avail b_fornecedor then
                assign v_cod_pais_fornec_clien = b_fornecedor.cod_pais.
        end.
    end.
END PROCEDURE.
