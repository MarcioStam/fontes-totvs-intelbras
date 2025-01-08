
/*Temp-table 1: Conter  as informa‡äes referentes a abatimentos de Antecipa‡äes.*/

def new shared temp-table tt_integr_apb_abat_antecip_vouc no-undo 
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo" 
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


/*Temp-table 2: Conter  as informa‡äes referentes a abatimentos de Previsäes  ou Provisäes.*/

def new shared temp-table tt_integr_apb_abat_prev_provis no-undo 
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9" 
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo" 
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
          tta_cod_parcela                  ascending .



/*Temp-table 3: Conter  as informa‡äes referentes a apropria‡äes cont beis dos t¡tulos.*/

def new shared temp-table tt_integr_apb_aprop_ctbl_pend no-undo 
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9" 
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9" 
    field ttv_rec_integr_apb_impto_pend    as recid format ">>>>>>9" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg" 
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo" 
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa" 
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


/*Temp-table 4: Conter  as informa‡äes das apropria‡äes cont beis referentes a notas de cr‚dito e notas de d‚bito.*/

def new shared temp-table tt_integr_apb_aprop_relacto no-undo 
    field ttv_rec_integr_apb_relacto_pend  as recid format ">>>>>>9" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_ind_tip_aprop_ctbl           as character format "x(19)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl" 
    index tt_integr_apb_aprop_relacto      is primary unique 
          ttv_rec_integr_apb_relacto_pend  ascending 
          tta_cod_plano_cta_ctbl           ascending 
          tta_cod_cta_ctbl                 ascending.



/*Temp-table 5: Conter  as informa‡äes referentes aos Impostos vinculados aos t¡tulos importados.*/

def new shared temp-table tt_integr_apb_impto_impl_pend no-undo 
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9" 
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9" 
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut" 
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu»’o Inss" column-label "Dedu»’o Inss" 
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu»’o Dependentes" column-label "Dedu»’o Dependentes" 
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao Pens’o" column-label "Deducao Pens’o" 
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Dedu»„es" column-label "Outras Dedu»„es" 
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L­quida Imposto" column-label "Base L­quida Imposto" 
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq" 
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido" 
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto" 
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico" 
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido" 
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Dedu»’o" 
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP" 
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP" 
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo" 
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




/*Temp-table 6: Conter  as informa‡äes dos itens dos lote de implanta‡Æo a serem criados no Datasul- Esta temp-table nÆo deve ser criada, ela deve ser apenas definida no programa. A nova temp-table a ser criada est  especificada mais abaixo, no item Temp-Table 10.*/

def new shared temp-table tt_integr_apb_item_lote_impl no-undo 
    field ttv_rec_integr_apb_lote_impl     as recid format ">>>>>>9" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie" 
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o" 
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto" 
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto" 
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T­tulo" column-label "Valor T­tulo" 
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto" 
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto" 
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr" 
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro" 
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia" 
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap½lice Seguro" column-label "Apolice Seguro" 
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora" 
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador" 
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico" 
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP" 
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP" 
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta" 
    field ttv_qtd_parc_tit_ap              as decimal format ">>9" initial 1 label "Quantidade Parcelas" column-label "Quantidade Parcelas" 
    field ttv_num_dias                     as integer format ">>>>,>>9" label "Nœmero de Dias" column-label "Nœmero de Dias" 
    field ttv_ind_vencto_previs            as character format "X(4)" initial "M¼s" label "C lculo Vencimento" column-label "C lculo Vencimento" 
    field ttv_log_gerad                    as logical format "Sim/N’o" initial no 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa" 
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira" 
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto" 
    index tt_item_lote_impl_ap_integr_id   is primary unique 
          ttv_rec_integr_apb_lote_impl     ascending 
          tta_num_seq_refer                ascending.




/*Temp-table 7: Conter  as informa‡äes dos lotes de implanta‡Æo, necess rios para a vincula‡Æo dos itens.*/

def new shared temp-table tt_integr_apb_lote_impl no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie" 
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac" 
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_val_tot_lote_impl_tit_ap     as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total  Movimento" column-label "Total Movto" 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field ttv_cod_empresa_ext              as character format "x(3)" label "C½digo Empresa Ext" column-label "C½d Emp Ext" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    index tt_lote_impl_tit_ap_integr_id    is primary unique 
          tta_cod_estab                    ascending 
          tta_cod_refer                    ascending 
          tta_cod_estab_ext                ascending.




/*Temp-table 8: Conter  as informa‡äes referentes …s Notas de D‚bito e Notas de Cr‚dito.*/


def new shared temp-table tt_integr_apb_relacto_pend no-undo 
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9" 
    field tta_cod_estab_tit_ap_pai         as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai" 
    field tta_num_id_tit_ap_pai            as integer format "9999999999" initial 0 label "Token" column-label "Token" 
    field tta_val_relacto_tit_ap           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor" 
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera»’o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor" 
    index tt_integr_apb_relacto_pend       is primary unique 
          ttv_rec_integr_apb_item_lote     ascending 
          tta_cod_estab_tit_ap_pai         ascending 
          tta_num_id_tit_ap_pai            ascending.




/*Temp-table 9: Conter  as informa‡äes referentes aos erros encontrados durante as valida‡äes para a cria‡Æo dos t¡tulos.*/

def new shared temp-table tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 


/*Temp-table 10: Conter  as informa‡äes dos itens dos lote de implanta‡Æo a serem criados no Datasul-*/

def temp-table tt_integr_apb_item_lote_impl_2  no-undo
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
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_num_ord_invest               as integer format ">>>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Invest"
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
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    index tt_item_lote_impl_ap_integr_id   is primary unique
          ttv_rec_integr_apb_lote_impl     ascending
          tta_num_seq_refer                ascending
    .



