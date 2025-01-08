/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_tit_ap_bcio_conciliacao
** Descricao.............: Funá‰es T°tulo Banc†rio
** Versao................:  5.04.00.055
** Procedimento..........: tar_varredura_sacado
** Nome Externo..........: prgfin/apb/apb775za.p
** Data Geracao..........: 29/11/2015 - 17:44:55
** Criado por............: bre17230
** Criado em.............: 11/04/2000 10:19:26
** Alterado por..........: jeffersonsil
** Alterado em...........: 29/11/2015 17:40:29
** Gerado por............: jeffersonsil
*****************************************************************************/

DEF BUFFER empresa              FOR emscad.empresa.
DEF BUFFER fornecedor           FOR emscad.fornecedor.
DEF BUFFER histor_exec_especial FOR emscad.histor_exec_especial.
DEF BUFFER banco                FOR emscad.banco.
DEF BUFFER portador             FOR emscad.portador.

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 5.04.00.055":U no-undo.
def var c-versao-rcode as char initial "[[[5.04.00.055[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
/*{include/i_trddef.i}*/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_tit_ap_bcio_conciliacao APB}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/

&if "{&emsfin_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSFIN")) /*msg_5884*/.
&elseif "{&emsfin_version}" < "5.04" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "FNC_TIT_AP_BCIO_CONCILIACAO","~~EMSFIN", "~~{~&emsfin_version}", "~~5.04")) /*msg_5009*/.
&else

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_ajuste_tela_apl no-undo
    field ttv_log_col                      as logical format "Sim/N∆o" initial no
    field ttv_val_pos_col                  as decimal format "->>9.99" decimals 2
    field ttv_log_lin                      as logical format "Sim/N∆o" initial no
    field ttv_val_pos_lin                  as decimal format "->>9.99" decimals 2
    field ttv_log_larg                     as logical format "Sim/N∆o" initial no
    field ttv_val_pos_larg                 as decimal format "->>9.99" decimals 2
    field ttv_log_alt                      as logical format "Sim/N∆o" initial no
    field ttv_val_pos_alt                  as decimal format "->>9.99" decimals 2
    field ttv_hdl_obj                      as Handle format ">>>>>>9"
    field ttv_cod_desc                     as character format "x(20)"
    field ttv_num_cont                     as integer format ">,>>9" initial 0
    .

def new shared temp-table tt_compl_histor_padr_valor        
    field tta_cod_compl_padr               as character format "x(8)" label "Complemento Padr∆o" column-label "Comp Pad"
    field tta_cod_format_compl_padr        as character format "x(20)" label "Formato Complemento" column-label "Formato Complemento"
    field ttv_des_val_compl_padr           as character format "x(20)"
    index tt_id                            is primary unique
          tta_cod_compl_padr               ascending
    .

def temp-table tt_concil_autom no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field tta_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    field tta_dat_vencto                   as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_tit_ap_bcio              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo Bcio" column-label "Valor T°tulo Bcio"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo" column-label "Valor T°tulo"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome Fornec" column-label "Nome Fornec"
    field tta_log_concil                   as logical format "Sim/N∆o" initial no label "Tit Conciliado" column-label "Tit Conciliado"
    field tta_cod_estab_tit_ap             as character format "x(3)" label "Estabel APB" column-label "Estabel APB"
    field ttv_log_descta                   as logical format "Sim/N∆o" initial no
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_cod_data                     as character format "x(10)"
    field ttv_cod_estab_browse             as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_fornec_browse            as character format "x(11)" label "C¢d. Fornec." column-label "C¢d. Fornec."
    field ttv_cod_tit_ap_bco_browse        as character format "x(20)" label "T°tulo Banc†rio" column-label "T°tulo Banc†rio"
    field ttv_log_concil_prim              as logical format "Sim/N∆o" initial no
    field ttv_cdn_matriz_fornec_inic       as Integer format ">>>,>>>,>>9" label "Matriz Inicial" column-label "Matriz Inicial"
    field ttv_num_seq_tit_bco              as integer format ">>>>,>>9" label "Numero da Sequància"
    index tt_display                       is primary unique
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap_bco               ascending
          ttv_num_seq                      ascending
    index tt_tit_ap                       
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_ser_docto                ascending
          tta_cod_espec_docto              ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_empresa_selec no-undo like emscad.empresa
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_cod_empresa                   is primary unique
          tta_cod_empresa                  ascending
    .

def temp-table tt_estab_select no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    .

def temp-table tt_fornecedor_matriz no-undo like emscad.fornecedor
    field ttv_rec_fornecedor               as recid format ">>>>>>9"
    index tt_fornecedor_matriz_id          is primary unique
          ttv_rec_fornecedor               ascending
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
    field ttv_des_msg_ajuda_1              as character format "x(170)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    .

def temp-table tt_movto_tit_ap_bcio_histor no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field tta_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    field ttv_num_seq_tit_bco              as integer format ">>>>,>>9" label "Numero da Sequància"
    field tta_num_seq_movto_bco            as integer format ">>>>,>>9" initial 0 label "Sequància Movto" column-label "Sequància Movto"
    field tta_ind_tip_movto_bco            as character format "X(20)" label "Tipo Movto Banco" column-label "Tipo Movto Banco"
    field tta_dat_gerac_arq                as date format "99/99/9999" initial ? label "Geraá∆o Arquivo" column-label "Geraá∆o Arquivo"
    field tta_num_seq_arq                  as integer format ">>>>,>>9" initial 0 label "Sequància Arquivo" column-label "Sequància Arquivo"
    field tta_dsl_histor_movto_bco         as Character format "x(15000)" label "Hist¢rico Movimento" column-label "Hist¢rico Movimento"
    index tt_histor                        is primary unique
          tta_cod_estab                    ascending
          tta_cod_sist_nac_bcio            ascending
          tta_cod_tit_ap_bco               ascending
          tta_num_seq_movto_bco            ascending
    .

def temp-table tt_tit_ap_alteracao_base_aux_3 no-undo
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
    field ttv_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Carància" column-label "Carància"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Vl Juros"
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
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T°tulo Banco Cobdor" column-label "T°tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field ttv_ind_tip_trans_1099_tt        as character format "X(50)" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/N∆o" initial no
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .

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

def new shared temp-table tt_tit_ap_conciliacao no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_val_origin_tit_ap            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_abrev_fornec             as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_log_concil                   as logical format "Sim/N∆o" initial no label "Tit Conciliado" column-label "Tit Conciliado"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    field tta_val_tit_ap_bcio              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo Bcio" column-label "Valor T°tulo Bcio"
    field ttv_cod_barra_bcio               as character format "x(48)" label "C¢digo Barras" column-label "C¢digo Barras"
    field ttv_num_sel_reg                  as integer format ">>>9" initial 0 label "Idx" column-label "Idx"
    .

def temp-table tt_tit_ap_conciliacao_sel no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_num_sel_reg                  as integer format ">>>9" initial 0 label "Idx" column-label "Idx"
    .

def new shared temp-table tt_tit_ap_em_bco no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field tta_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_fornecedor               as character format "x(30)" label "Fornecedor" column-label "Fornecedor"
    field tta_dat_entr_sist                as date format "99/99/9999" initial today label "Entrada Sistema" column-label "Entrada Sistema"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_dat_emis_tit_bcio            as date format "99/99/9999" initial ? label "Emiss∆o Banco" column-label "Emiss∆o Banco"
    field tta_dat_vencto                   as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_tit_ap_bcio              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo Bcio" column-label "Valor T°tulo Bcio"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_log_concil                   as logical format "Sim/N∆o" initial no label "Tit Conciliado" column-label "Tit Conciliado"
    field tta_log_confer                   as logical format "Sim/N∆o" initial no label "Tit. Conferido" column-label "Tit. Conferido"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field ttv_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_cod_barra_bcio               as character format "x(48)" label "C¢digo Barras" column-label "C¢digo Barras"
    field tta_log_tit_cancel               as logical format "Sim/N∆o" initial no label "Titulo Cancelado" column-label "Tit Cancel"
    field ttv_num_sel_reg                  as integer format ">>>9" initial 0 label "Idx" column-label "Idx"
    field ttv_num_seq_tit_bco              as integer format ">>>>,>>9" label "Numero da Sequància"
    index tt_varred_sacado                 is primary unique
          tta_cod_estab                    ascending
          tta_cod_sist_nac_bcio            ascending
          tta_cod_tit_ap_bco               ascending
          ttv_num_seq_tit_bco              ascending
    .

def temp-table tt_tit_conciliados no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_tit_ap_bco               as character format "x(20)" label "T°tulo  Banco" column-label "T°tulo Banco"
    .

def new shared temp-table tt_xml_output_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

def buffer btt_tit_ap_em_bco
    for tt_tit_ap_em_bco.
&if "{&emsuni_version}" >= "5.01" &then
def buffer b_banco
    for emscad.banco.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_fornecedor
    for emscad.fornecedor.
&endif
&if "{&emsfin_version}" >= "5.01" &then
def buffer b_histor_tit_movto_ap
    for histor_tit_movto_ap.
&endif
&if "{&emsfin_version}" >= "5.04" &then
def buffer b_movto_tit_ap_bcio_histor
    for movto_tit_ap_bcio.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_pessoa_fisic
    for pessoa_fisic.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_pessoa_jurid
    for pessoa_jurid.
&endif
&if "{&emsfin_version}" >= "5.04" &then
def buffer b_tit_ap_bcio
    for tit_ap_bcio.
&endif
&if "{&emsfin_version}" >= "5.01" &then
def buffer b_tit_ap_concil
    for tit_ap.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cdn_fornecedor
    as Integer
    format ">>>,>>>,>>9":U
    label "Fornecedor"
    column-label "Fornecedor"
    no-undo.
def var v_cdn_fornecedor_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "Fornecedor"
    no-undo.
def var v_cdn_fornecedor_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Fornecedor"
    column-label "Fornecedor"
    no-undo.
def var v_cdn_fornec_tit_ap_bcio
    as Integer
    format ">>>,>>>,>>9":U
    label "Fornec."
    column-label "Fornec."
    no-undo.
def var v_cdn_sist_nac_bcio
    as Integer
    format ">>>,>>9":U
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_banco
    as character
    format "x(8)":U
    label "Banco"
    column-label "Banco"
    no-undo.
def var v_cod_banco_atz
    as character
    format "x(8)":U
    label "Banco"
    column-label "Banco"
    no-undo.
def var v_cod_banco_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ" /*l_zzzzzzzz*/
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_banco_ini
    as character
    format "x(8)":U
    label "C¢d. Sist. Banc†rio"
    column-label "C¢d. Sist. Banc†rio"
    no-undo.
def var v_cod_barra
    as character
    format "x(44)":U
    label "C¢d. Barras"
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
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_cod_espec_multi_sel_tela
    as character
    format "x(2000)":U
    view-as editor max-chars 250 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "EspÇcie"
    no-undo.
def var v_cod_estab_apb_fim
    as character
    format "x(3)":U
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_estab_apb_inic
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab_ini
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab_ini
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_forma_pagto
    as character
    format "x(3)":U
    label "Forma Pagamento"
    column-label "F Pagto"
    no-undo.
def new global shared var v_cod_forma_pagto_multi_sel
    as character
    format "x(2000)":U
    view-as editor max-chars 250 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Forma Pagamento"
    column-label "Forma Pagto"
    no-undo.
def var v_cod_forma_pagto_multi_sel_tela
    as character
    format "x(2000)":U
    view-as editor max-chars 250 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Forma Pagamento"
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
def var v_cod_histor_padr
    as character
    format "x(8)":U
    label "Hist¢rico Padr∆o"
    column-label "Hist¢rico Padr∆o"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_id_feder
    as character
    format "x(20)":U
    label "Fornecedor"
    column-label "ID Federal"
    no-undo.
def var v_cod_id_feder_apb_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "atÇ"
    no-undo.
def var v_cod_id_feder_fornec_fim
    as character
    format "x(10)":U
    initial "ZZZZZZZZZZ" /*l_zzzzzzzzzz*/
    label "Id Feder (CGC/CPF)"
    column-label "Id Feder (CGC/CPF)"
    no-undo.
def var v_cod_id_feder_fornec_inic
    as character
    format "x(10)":U
    initial "0000000000"
    label "Id Federal (CGC/CPF)"
    column-label "Id Federal (CGC/CPF)"
    no-undo.
def new global shared var v_cod_matriz_trad_org_ext
    as character
    format "x(8)":U
    label "Matriz UO"
    column-label "Matriz UO"
    no-undo.
def var v_cod_modulo
    as character
    format "x(50)":U
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
def var v_cod_num_bcio
    as character
    format "x(20)":U
    label "N£mero Banc†rio"
    column-label "N£mero Banc†rio"
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
def new global shared var v_cod_portad_multi_sel
    as character
    format "x(2000)":U
    view-as editor max-chars 250 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Portador"
    column-label "Portador"
    no-undo.
def var v_cod_portad_multi_sel_tela
    as character
    format "x(2000)":U
    view-as editor max-chars 250 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Portador"
    column-label "Portador"
    no-undo.
def var v_cod_refer
    as character
    format "x(10)":U
    label "Referància"
    column-label "Referància"
    no-undo.
def var v_cod_tip_faixa
    as character
    format "x(10)":U
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
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
def var v_dat_emis_apb_fim
    as date
    format "99/99/9999":U
    label "atÇ"
    no-undo.
def var v_dat_emis_apb_inic
    as date
    format "99/99/9999":U
    label "Data Emiss∆o"
    no-undo.
def var v_dat_entr_sist_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Entrada Sistema"
    column-label "Entrada Sistema"
    no-undo.
def var v_dat_entr_sist_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Entr. Sist"
    column-label "Data Entr. Sist"
    no-undo.
def var v_dat_vencto_apb_fim
    as date
    format "99/99/9999":U
    label "atÇ"
    no-undo.
def var v_dat_vencto_apb_inic
    as date
    format "99/99/9999":U
    label "Data Vencimento"
    no-undo.
def var v_dat_vencto_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Data Vencimento"
    column-label "Data Vencimento"
    no-undo.
def var v_dat_vencto_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Vencimento"
    column-label "Data Vencimento"
    no-undo.
def var v_dat_vencto_margem_inf
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_vencto_margem_sup
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_des_espec_impto
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Especie Imposto"
    column-label "Especie Imposto"
    no-undo.
def new shared var v_des_espec_normal
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "EspÇcie"
    column-label "EspÇcie"
    no-undo.
def var v_des_text_histor
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 50 by 4
    bgcolor 15 font 2
    label "Hist¢rico"
    column-label "Hist¢rico"
    no-undo.
def var v_hdl_prog
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_atualiz_autom
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_bancario
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "N£mero Banc†rio"
    no-undo.
def var v_log_barra_5
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "C¢digo de Barras"
    no-undo.
def var v_log_browse_order
    as logical
    format "Sim/N∆o"
    initial [no]
    extent 8
    label "Ordenaá∆o Browse"
    no-undo.
def var v_log_concil_autom
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Autom†tica"
    column-label "Autom†tica"
    no-undo.
def var v_log_concil_autom_confir
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_concil_confer
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_concil_nao_confer
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_concil_prim
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_confir_concil
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_cop_cod_barra
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "C¢digo de Barras"
    column-label "Copia C¢digo Barra"
    no-undo.
def var v_log_dat_multa
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_dat_vencto
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Data Vencimento"
    no-undo.
def var v_log_desconto
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Desconto"
    column-label "Desconto"
    no-undo.
def var v_log_faixa_ok
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_forma_pagto_3
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Forma de Pagto"
    no-undo.
def new global shared var v_log_forma_pagto_multi_sel
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_layout_sacad
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_matriz_fornec
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_nao_concil
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_portad_multi_sel
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_pos_num_bcio_cb
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new shared var v_log_sit_alter
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new shared var v_log_sit_eliminac
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_tit_ap_atualiza
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_tit_ap_bcio_atualiza
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_tit_ap_bcio_cancel
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_tit_ap_bcio_habilita
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_tit_ap_faixa_ok
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_tit_ap_habilita
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_utiliza_mbh
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_val_desc
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_val_juros
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_val_multa
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_nom_fornecedor_fim
    as character
    format "x(30)":U
    initial "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" /*l_z_x_30*/
    label "Fornecedor"
    column-label "Fornecedor"
    no-undo.
def var v_nom_fornecedor_ini
    as character
    format "x(30)":U
    label "Nome Fornecedor"
    column-label "Nome Fornecedor"
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_count
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_count_concil
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_dias_aprox
    as integer
    format ">>9":U
    label "Margem Dias Vencto"
    column-label "Margem"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_sel_reg
    as integer
    format ">>>9":U
    initial 0
    label "Idx"
    column-label "Idx"
    no-undo.
def new shared var v_rec_banco
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_forma_pagto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_fornecedor
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_tit_ap_bcio
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_val_origin_apb_fim
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "atÇ"
    no-undo.
def var v_val_origin_apb_inic
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor Original T°t."
    no-undo.
def var v_val_percent_variac_val
    as decimal
    format ">9.99":U
    decimals 2
    label "% Variaá∆o Valor"
    column-label "Perc."
    no-undo.
def var v_val_tit_ap_bcio_fim
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    initial 999999999.99
    label "Valor T°tulo Bcio"
    column-label "Valor T°tulo Bcio"
    no-undo.
def var v_val_tit_ap_bcio_ini
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor T°tulo Bcio"
    column-label "Valor T°tulo Bcio"
    no-undo.
def var v_val_tit_ap_bcio_margem_inf
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tit_ap_bcio_margem_sup
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_wgh_fill_in_fim
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_fill_in_ini
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_label_fim
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_label_ini
    as widget-handle
    format ">>>>>>9":U
    no-undo.

DEF VAR v_val_impto_pis_cofins  LIKE compl_retenc_impto_pagto.val_imposto NO-UNDO.
def var v_cod_return            as char format "x(40)":U                  no-undo.
def var v_dat_return            as date format "99/99/9999":U             no-undo.
def var v_log_fer               as log  format "Sim/N∆o" init no          no-undo.
def var v_cod_pais_fornec_clien as char format "x(8)":U                   no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_tit_ap_bcio_historico
    for tt_movto_tit_ap_bcio_histor
    scrolling.
def query qr_tit_ap_em_bco
    for tt_tit_ap_em_bco
    scrolling.
def query qr_tit_ap_em_bco_bank
    for tt_tit_ap_em_bco
    scrolling.
def query qr_tt_concil_autom
    for tt_concil_autom
    scrolling.
def query qr_tt_tit_ap_conciliacao
    for tt_tit_ap_conciliacao
    scrolling.
def query qr_tt_tit_ap_conciliacao_bank
    for tt_tit_ap_conciliacao
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_tit_ap_bcio_historico query qr_tit_ap_bcio_historico display 
    tt_movto_tit_ap_bcio_histor.tta_num_seq_movto_bco
    width-chars 07.43
        column-label "Seq Movto"
    tt_movto_tit_ap_bcio_histor.tta_ind_tip_movto_bco
    width-chars 20.00
        column-label "Tipo Movto Banco"
    tt_movto_tit_ap_bcio_histor.tta_dat_gerac_arq
    width-chars 10.00
        column-label "Gerac Arq"
    with separators single 
         size 45.00 by 09.00
         font 1
         bgcolor 15
         title "Movimentos T°tulos Banc†rios".
def browse br_tit_ap_em_bco query qr_tit_ap_em_bco display 
    tt_tit_ap_em_bco.ttv_num_sel_reg
    width-chars 04.00
        column-label "Seq"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
    width-chars 03.00
        column-label "Est"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
    width-chars 05.00
        column-label "Est"
&ENDIF
    tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
    width-chars 14.00
        column-label "C¢digo Sist Banc†rio"
    tt_tit_ap_em_bco.tta_cdn_fornecedor
    width-chars 09.00
        column-label "Fornec"
    tt_tit_ap_em_bco.tta_nom_fornecedor
    width-chars 30.00
        column-label "Fornecedor"
    tt_tit_ap_em_bco.tta_dat_vencto
    width-chars 10.00
        column-label "Vencto"
    tt_tit_ap_em_bco.tta_val_tit_ap_bcio
    width-chars 12.00
        column-label "Valor"
    tt_tit_ap_em_bco.tta_cod_tit_ap_bco
    width-chars 20.00
        column-label "T°tulo Banco"
    tt_tit_ap_em_bco.tta_cod_id_feder
    width-chars 20.00
        column-label "ID Federal"
    tt_tit_ap_em_bco.ttv_cod_barra_bcio
    width-chars 0050.00
        column-label "C¢digo Barras"
    with no-box separators single 
         size 80.00 by 07.50
         font 1
         bgcolor 15.
def browse br_tit_ap_em_bco_bank query qr_tit_ap_em_bco_bank display 
    tt_tit_ap_em_bco.ttv_num_sel_reg
    width-chars 04.00
        column-label "Seq"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
    width-chars 03.00
        column-label "Est"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
    width-chars 05.00
        column-label "Est"
&ENDIF
    tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
    width-chars 14.00
        column-label "C¢digo Sist Banc†rio"
    tt_tit_ap_em_bco.tta_cdn_fornecedor
    width-chars 09.00
        column-label "Fornec"
    tt_tit_ap_em_bco.tta_nom_fornecedor
    width-chars 30.00
        column-label "Fornecedor"
    tt_tit_ap_em_bco.tta_dat_vencto
    width-chars 10.00
        column-label "Vencto"
    tt_tit_ap_em_bco.tta_val_tit_ap_bcio
    width-chars 12.00
        column-label "Valor"
    tt_tit_ap_em_bco.ttv_cod_tit_ap_bco
    width-chars 20.00
        column-label "T°tulo Banco"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.06" &THEN
    tt_tit_ap_em_bco.tta_val_desconto
    width-chars 12.00
        column-label "Vl Descto"
&ENDIF
&IF "{&emsfin_version}" >= "5.06" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_em_bco.tta_val_desconto
    width-chars 20.00
        column-label "Vl Descto"
&ENDIF
    tt_tit_ap_em_bco.tta_val_abat_tit_ap
    width-chars 12.00
        column-label "Vl Abat"
    tt_tit_ap_em_bco.tta_val_multa
    width-chars 12.00
        column-label "Vl Multa"
    tt_tit_ap_em_bco.tta_val_juros
    width-chars 13.00
        column-label "Vl Juros"
    tt_tit_ap_em_bco.ttv_cod_barra_bcio
    width-chars 0050.00
        column-label "C¢digo Barras"
    with no-box separators single 
         size 80.00 by 07.50
         font 1
         bgcolor 15.
def browse br_tt_concil_autom query qr_tt_concil_autom display 
    tt_concil_autom.ttv_cod_estab_browse
    width-chars 0005.00
        column-label "Estab"
    tt_concil_autom.ttv_cod_fornec_browse
    width-chars 0011.00
    tt_concil_autom.tta_nom_pessoa
        width-chars 0030.00
    tt_concil_autom.ttv_cod_tit_ap_bco_browse
    width-chars 0018.00
        column-label "T°tulo Banc†rio"
    tt_concil_autom.tta_dat_vencto
    width-chars 10.00
        column-label "Vencimento"
    tt_concil_autom.tta_val_tit_ap_bcio
    width-chars 0014.00
        column-label "Valor T°tulo Bcio"
    tt_concil_autom.tta_dat_vencto_tit_ap
    width-chars 10.00
        column-label "Dt Vencto"
    tt_concil_autom.tta_val_tit_ap
    width-chars 0014.00
        column-label "Valor T°tulo"
    tt_concil_autom.tta_cod_ser_docto
    format "x(5)"
    width-chars 05.00
        column-label "SÇrie"
    tt_concil_autom.tta_cod_espec_docto
    width-chars 03.00
        column-label "Esp"
    tt_concil_autom.tta_cod_tit_ap
    format "x(16)"
    width-chars 16.00
 column-label "T°tulo"
    tt_concil_autom.tta_cod_parcela
    width-chars 02.00
        column-label "/P"
    with no-box separators multiple 
         size 85.29 by 08.58
         font 1
         bgcolor 15.
def browse br_tt_tit_ap_conciliacao query qr_tt_tit_ap_conciliacao display 
    tt_tit_ap_conciliacao.ttv_num_sel_reg
    width-chars 04.00
        column-label "Seq"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_ap_conciliacao.tta_cod_estab
    width-chars 03.00
        column-label "Est"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_conciliacao.tta_cod_estab
    width-chars 05.00
        column-label "Est"
&ENDIF
    tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio
    width-chars 14.00
        column-label "C¢digo Sist Banc†rio"
    tt_tit_ap_conciliacao.tta_cdn_fornecedor
    width-chars 09.00
        column-label "Fornec"
    tt_tit_ap_conciliacao.tta_cod_tit_ap
    format "x(16)"
    width-chars 16.00
 column-label "T°tulo"
    tt_tit_ap_conciliacao.tta_cod_parcela
    width-chars 02.00
        column-label "/P"
    tt_tit_ap_conciliacao.tta_dat_emis_docto
    width-chars 10.00
        column-label "Emiss∆o"
    tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap
    width-chars 10.00
        column-label "Vencto"
    tt_tit_ap_conciliacao.tta_val_origin_tit_ap
    width-chars 12.00
        column-label "Vl Original"
    tt_tit_ap_conciliacao.tta_cod_id_feder
    width-chars 20.00
        column-label "ID Federal"
    tt_tit_ap_conciliacao.tta_nom_abrev_fornec
    width-chars 15.00
        column-label "Nome Abreviado"
    tt_tit_ap_conciliacao.ttv_cod_barra_bcio
    width-chars 0050.00
        column-label "C¢digo Barras"
    with no-box separators single 
         size 80.00 by 06.17
         font 1
         bgcolor 15.
def browse br_tt_tit_ap_conciliacao_bank query qr_tt_tit_ap_conciliacao_bank display 
    tt_tit_ap_conciliacao.ttv_num_sel_reg
    width-chars 04.00
        column-label "Seq"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_ap_conciliacao.tta_cod_estab
    width-chars 03.00
        column-label "Est"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_conciliacao.tta_cod_estab
    width-chars 05.00
        column-label "Est"
&ENDIF
    tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio
    width-chars 14.00
        column-label "C¢digo Sist Banc†rio"
    tt_tit_ap_conciliacao.tta_cdn_fornecedor
    width-chars 09.00
        column-label "Fornec"
    tt_tit_ap_conciliacao.tta_cod_espec_docto
    width-chars 0005.00
        column-label "Esp"
    tt_tit_ap_conciliacao.tta_cod_ser_docto
    format "x(5)"
    width-chars 0005.00
        column-label "SÇrie"
    tt_tit_ap_conciliacao.tta_cod_tit_ap
    format "x(16)"
    width-chars 16.00
 column-label "T°tulo"
    tt_tit_ap_conciliacao.tta_cod_parcela
    width-chars 0004.00
        column-label "/P"
    tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap
    width-chars 10.00
        column-label "Vencto"
    tt_tit_ap_conciliacao.tta_val_tit_ap_bcio
    width-chars 12.00
        column-label "Valor"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.06" &THEN
    tt_tit_ap_conciliacao.tta_val_desconto
    width-chars 12.00
        column-label "Vl Descto"
&ENDIF
&IF "{&emsfin_version}" >= "5.06" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_conciliacao.tta_val_desconto
    width-chars 20.00
        column-label "Vl Descto"
&ENDIF
    tt_tit_ap_conciliacao.tta_val_abat_tit_ap
    width-chars 12.00
        column-label "Vl Abat"
    tt_tit_ap_conciliacao.tta_val_multa
    width-chars 12.00
        column-label "Vl Multa"
    tt_tit_ap_conciliacao.tta_val_juros
    width-chars 13.00
        column-label "Vl Juros"
    tt_tit_ap_conciliacao.ttv_cod_tit_ap_bco
    width-chars 20.00
        column-label "T°tulo Banco"
    tt_tit_ap_conciliacao.ttv_cod_barra_bcio
    width-chars 0050.00
        column-label "C¢digo Barras"
    with no-box separators single 
         size 80.00 by 06.17
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_003
    size 1 by 1
    edge-pixels 2.
def rectangle rt_004
    size 1 by 1
    edge-pixels 2.
def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_006
    size 1 by 1
    edge-pixels 2.
def rectangle rt_007
    size 1 by 1
    edge-pixels 2.
def rectangle rt_008
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_cancelamento
    label "Can"
    tooltip "Cancelamento"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-cance"
    image-insensitive file "image/im-canc1"
&endif
    size 1 by 1.
def button bt_check
    label "Check"
    tooltip ""
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-check.bmp"
    image-insensitive file "image/im-chck1.bmp"
&endif
    size 1 by 1.
def button bt_check7
    label "Check"
    tooltip ""
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-check.bmp"
    image-insensitive file "image/im-chck1.bmp"
&endif
    size 1 by 1.
def button bt_concil_autom_titulos
    label "Conciliaá∆o Automat de T°tulos"
    tooltip "Conciliaá∆o Automat. de T°tulos"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-orcto.bmp"
    image-insensitive file "image/ii-orcto.bmp"
&endif
    size 1 by 1.
def button bt_concil_manual_titulos
    label "Conciliaá∆o Manual de T°tulos"
    tooltip "Conciliaá∆o Manual de T°tulos"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-con-1.bmp"
    image-insensitive file "image/ii-con-1.bmp"
&endif
    size 1 by 1.
def button bt_concil_titulos_1
    label "Conciliaá∆o Manual de T°tulos"
    tooltip "Conciliaá∆o Manual de T°tulos"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-con-1.bmp"
    image-insensitive file "image/ii-con-1.bmp"
&endif
    size 1 by 1.
def button bt_desconcil_1
    label "Desconciliaá∆o Manual T°tulos"
    tooltip "Desconciliaá∆o Manual T°tulos"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-desc1.bmp"
    image-insensitive file "image/im-desc2.bmp"
&endif
    size 1 by 1.
def button bt_det1
    label "Det"
    tooltip "Detalhe"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-det"
    image-insensitive file "image/ii-det"
&endif
    size 1 by 1.
def button bt_det_10
    label "Detalhe"
    tooltip "Detalhe"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-det"
&endif
    size 1 by 1.
def button bt_elimina_image
    label "Elimina"
    tooltip "Elimina"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-era1"
&endif
    size 1 by 1.
def button bt_era1
    label "Eli"
    tooltip "Elimina"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-era1"
    image-insensitive file "image/ii-era1"
&endif
    size 1 by 1.
def button bt_fil2
    label "Fil"
    tooltip "Filtro"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
&endif
    size 1 by 1.
def button bt_fil3
    label "Fil"
    tooltip "Filtro"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_historico_padrao
    label "Hist¢rico"
    tooltip "Hist¢rico do Movimento"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-hist.bmp"
    image-insensitive file "image/ii-hist.bmp"
&endif
    size 1 by 1.
def button bt_legenda
    label "Legenda"
    tooltip "Legenda"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-legen"
&endif
    size 1 by 1.
def button bt_localiza
    label "Localiza"
    tooltip "Localiza"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-local.bmp"
    image-insensitive file "image/ii-local.bmp"
&endif
    size 1 by 1.
def button bt_mod1
    label "Mod"
    tooltip "Modifica"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-mod"
    image-insensitive file "image/ii-mod"
&endif
    size 1 by 1.
def button bt_mod4
    label "Modifica"
    tooltip "Modifica"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-mod"
    image-insensitive file "image/ii-mod"
&endif
    size 1 by 1.
def button bt_mov1
    label "Mov"
    tooltip "Movimentos"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-mov"
    image-insensitive file "image/ii-mov.bmp"
&endif
    size 1 by 1.
def button bt_nenhum
    label "Nenhum"
    tooltip "Desmarca Todas Ocorràncias"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_param1_im
    label "Param"
    tooltip "ParÉmetros"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-apont.bmp"
    image-insensitive file "image/ii-apont.bmp"
&endif
    size 1 by 1.
def button bt_ran2
    label "Faixa"
    tooltip "Faixa"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
&endif
    size 1 by 1.
def button bt_ran6
    label "Faixa"
    tooltip "Faixa"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran"
&endif
    size 1 by 1.
def button bt_select_br_all
    label "Seleciona Todos"
    tooltip "Seleciona Todos"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran_a.bmp"
&endif
    size 1 by 1.
def button bt_todos
    label "Todos"
    tooltip "Marca Todas Ocorràncias"
    size 1 by 1.
def button bt_todos_img_2
    label "Todos"
    tooltip "Seleciona Todos"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran_a.bmp"
&endif
    size 1 by 1.
def button bt_todos_img_3
    label "Todos"
    tooltip "Seleciona Todos"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran_a.bmp"
&endif
    size 1 by 1.
def button bt_zoo2
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo3
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_427364
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_4x60
    as character
    view-as editor scrollbar-vertical
    size 60 by 4
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_regra_concil_autom
    as character
    initial "Fornecedor"
    view-as radio-set Vertical
    radio-buttons "Fornecedor", "Fornecedor", "Fornecedor/Valor", "Fornecedor/Valor", "Fornecedor/Data Vencto", "Fornecedor/Data Vencto", "Fornecedor/Valor/Data Vencto", "Fornecedor/Valor/Data Vencto"
     /*l_fornecedor*/ /*l_fornecedor*/ /*l_fornecedor_valor*/ /*l_fornecedor_valor*/ /*l_fornecedor_vencto*/ /*l_fornecedor_vencto*/ /*l_fornecedor_valor_vencto*/ /*l_fornecedor_valor_vencto*/
    bgcolor 8 
    no-undo.
def var rs_tt_tit_ap_conciliacao
    as character
    initial "T°tulos conciliados"
    view-as radio-set Vertical
    radio-buttons "T°tulos conciliados", "T°tulos conciliados", "T°tulos n∆o conciliados", "T°tulos n∆o conciliados", "Todos", "Todos"
     /*l_titulos_conciliados*/ /*l_titulos_conciliados*/ /*l_titulos_nao_conciliados*/ /*l_titulos_nao_conciliados*/ /*l_todos*/ /*l_todos*/
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_01_concil_autom
    rt_mold
         at row 01.21 col 02.00
    rt_001
         at row 01.63 col 03.29
    " Regras " view-as text
         at row 01.33 col 05.29 bgcolor 8 
    rt_002
         at row 02.46 col 05.57
    " Concilia Por " view-as text
         at row 02.16 col 07.57 bgcolor 8 
    rt_003
         at row 02.46 col 47.00
    " Margens de Variaá∆o " view-as text
         at row 02.16 col 49.00 bgcolor 8 
    rt_cxcf
         at row 08.88 col 02.00 bgcolor 7 
    rs_regra_concil_autom
         at row 02.68 col 06.72
         help "" no-label
    v_num_dias_aprox
         at row 03.29 col 63.72 colon-aligned label "Margem Dias Vencto"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_percent_variac_val
         at row 04.33 col 63.72 colon-aligned label "% Variaá∆o Valor"
         help "Percentual de Variaá∆o do Valor do T°tulo"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_confir_concil
         at row 06.83 col 06.72 label "Confirma toda Conciliaá∆o"
         view-as toggle-box
    bt_ok
         at row 09.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 09.08 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 09.08 col 68.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 81.00 by 10.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Autom†tica".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_concil_autom = 10.00
           bt_can:height-chars  in frame f_dlg_01_concil_autom = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_concil_autom = 10.00
           bt_hel2:height-chars in frame f_dlg_01_concil_autom = 01.00
           bt_ok:width-chars    in frame f_dlg_01_concil_autom = 10.00
           bt_ok:height-chars   in frame f_dlg_01_concil_autom = 01.00
           rt_001:width-chars   in frame f_dlg_01_concil_autom = 74.00
           rt_001:height-chars  in frame f_dlg_01_concil_autom = 06.46
           rt_002:width-chars   in frame f_dlg_01_concil_autom = 40.29
           rt_002:height-chars  in frame f_dlg_01_concil_autom = 03.96
           rt_003:width-chars   in frame f_dlg_01_concil_autom = 28.14
           rt_003:height-chars  in frame f_dlg_01_concil_autom = 03.96
           rt_cxcf:width-chars  in frame f_dlg_01_concil_autom = 77.57
           rt_cxcf:height-chars in frame f_dlg_01_concil_autom = 01.42
           rt_mold:width-chars  in frame f_dlg_01_concil_autom = 77.57
           rt_mold:height-chars in frame f_dlg_01_concil_autom = 07.29.
    /* set private-data for the help system */
    assign rs_regra_concil_autom:private-data    in frame f_dlg_01_concil_autom = "HLP=000000000":U
           v_num_dias_aprox:private-data         in frame f_dlg_01_concil_autom = "HLP=000000000":U
           v_val_percent_variac_val:private-data in frame f_dlg_01_concil_autom = "HLP=000023865":U
           v_log_confir_concil:private-data      in frame f_dlg_01_concil_autom = "HLP=000000000":U
           bt_ok:private-data                    in frame f_dlg_01_concil_autom = "HLP=000010721":U
           bt_can:private-data                   in frame f_dlg_01_concil_autom = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_dlg_01_concil_autom = "HLP=000011326":U
           frame f_dlg_01_concil_autom:private-data                             = "HLP=000000000".

def frame f_dlg_01_concil_autom_confirmacao
    rt_mold
         at row 01.21 col 02.00
    rt_006
         at row 01.50 col 02.57 bgcolor 8 
    rt_003
         at row 12.00 col 02.72 bgcolor 8 
    rt_cxcf
         at row 13.96 col 02.00 bgcolor 7 
    rt_004
         at row 01.92 col 19.00 bgcolor 8 
    rt_005
         at row 01.92 col 44.00 bgcolor 8 
    "T°tulos Banc†rios"
         at row 01.96 col 24.00 font 1
         view-as text /*l_titulos_bancarios*/
    "T°tulos Contas a Pagar (APB)"
         at row 01.96 col 49.00 font 1
         view-as text /*l_titulos_contas_a_pagar_apb*/
    br_tt_concil_autom
         at row 03.25 col 02.72
    bt_todos
         at row 12.21 col 03.86 font ?
         help "Marca Todas Ocorràncias"
    bt_nenhum
         at row 12.21 col 14.72 font ?
         help "Desmarca Todas Ocorràncias"
    bt_concil_titulos_1
         at row 12.21 col 80.00 font ?
         help "Conciliaá∆o Manual de T°tulos"
    v_log_concil_prim
         at row 12.42 col 30.72 label "Concilia Primeiro T°tulo APB"
         view-as toggle-box
    bt_ok
         at row 14.17 col 03.00 font ?
         help "OK"
    bt_can
         at row 14.17 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 14.17 col 77.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 15.79 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Confirmaá∆o Conciliaá∆o".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_dlg_01_concil_autom_confirmacao = 10.00
           bt_can:height-chars              in frame f_dlg_01_concil_autom_confirmacao = 01.00
           bt_concil_titulos_1:width-chars  in frame f_dlg_01_concil_autom_confirmacao = 06.86
           bt_concil_titulos_1:height-chars in frame f_dlg_01_concil_autom_confirmacao = 01.08
           bt_hel2:width-chars              in frame f_dlg_01_concil_autom_confirmacao = 10.00
           bt_hel2:height-chars             in frame f_dlg_01_concil_autom_confirmacao = 01.00
           bt_nenhum:width-chars            in frame f_dlg_01_concil_autom_confirmacao = 10.00
           bt_nenhum:height-chars           in frame f_dlg_01_concil_autom_confirmacao = 01.00
           bt_ok:width-chars                in frame f_dlg_01_concil_autom_confirmacao = 10.00
           bt_ok:height-chars               in frame f_dlg_01_concil_autom_confirmacao = 01.00
           bt_todos:width-chars             in frame f_dlg_01_concil_autom_confirmacao = 10.00
           bt_todos:height-chars            in frame f_dlg_01_concil_autom_confirmacao = 01.00
           rt_003:width-chars               in frame f_dlg_01_concil_autom_confirmacao = 85.29
           rt_003:height-chars              in frame f_dlg_01_concil_autom_confirmacao = 01.46
           rt_004:width-chars               in frame f_dlg_01_concil_autom_confirmacao = 03.00
           rt_004:height-chars              in frame f_dlg_01_concil_autom_confirmacao = 00.71
           rt_005:width-chars               in frame f_dlg_01_concil_autom_confirmacao = 03.00
           rt_005:height-chars              in frame f_dlg_01_concil_autom_confirmacao = 00.71
           rt_006:width-chars               in frame f_dlg_01_concil_autom_confirmacao = 85.43
           rt_006:height-chars              in frame f_dlg_01_concil_autom_confirmacao = 01.50
           rt_cxcf:width-chars              in frame f_dlg_01_concil_autom_confirmacao = 86.57
           rt_cxcf:height-chars             in frame f_dlg_01_concil_autom_confirmacao = 01.42
           rt_mold:width-chars              in frame f_dlg_01_concil_autom_confirmacao = 86.57
           rt_mold:height-chars             in frame f_dlg_01_concil_autom_confirmacao = 12.38.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tt_concil_autom:ALLOW-COLUMN-SEARCHING in frame f_dlg_01_concil_autom_confirmacao = no
       br_tt_concil_autom:COLUMN-MOVABLE in frame f_dlg_01_concil_autom_confirmacao = no.
end.
&endif
    /* set private-data for the help system */
    assign br_tt_concil_autom:private-data  in frame f_dlg_01_concil_autom_confirmacao = "HLP=000000000":U
           bt_todos:private-data            in frame f_dlg_01_concil_autom_confirmacao = "HLP=000013336":U
           bt_nenhum:private-data           in frame f_dlg_01_concil_autom_confirmacao = "HLP=000013335":U
           bt_concil_titulos_1:private-data in frame f_dlg_01_concil_autom_confirmacao = "HLP=000000000":U
           v_log_concil_prim:private-data   in frame f_dlg_01_concil_autom_confirmacao = "HLP=000000000":U
           bt_ok:private-data               in frame f_dlg_01_concil_autom_confirmacao = "HLP=000010721":U
           bt_can:private-data              in frame f_dlg_01_concil_autom_confirmacao = "HLP=000011050":U
           bt_hel2:private-data             in frame f_dlg_01_concil_autom_confirmacao = "HLP=000011326":U
           frame f_dlg_01_concil_autom_confirmacao:private-data                        = "HLP=000000000".

def frame f_dlg_01_movto_tit_ap_bcio_histor
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 05.58 col 02.00 bgcolor 7 
    ed_4x60
         at row 01.25 col 02.14
         help "" no-label
    bt_ok
         at row 05.79 col 03.00 font ?
         help "OK"
    bt_can
         at row 05.79 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 05.79 col 51.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 64.00 by 07.42 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Movimento T°tulo Banc†rio".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_movto_tit_ap_bcio_histor = 10.00
           bt_can:height-chars  in frame f_dlg_01_movto_tit_ap_bcio_histor = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_movto_tit_ap_bcio_histor = 10.00
           bt_hel2:height-chars in frame f_dlg_01_movto_tit_ap_bcio_histor = 01.00
           bt_ok:width-chars    in frame f_dlg_01_movto_tit_ap_bcio_histor = 10.00
           bt_ok:height-chars   in frame f_dlg_01_movto_tit_ap_bcio_histor = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_movto_tit_ap_bcio_histor = 60.57
           rt_cxcf:height-chars in frame f_dlg_01_movto_tit_ap_bcio_histor = 01.42
           rt_mold:width-chars  in frame f_dlg_01_movto_tit_ap_bcio_histor = 60.57
           rt_mold:height-chars in frame f_dlg_01_movto_tit_ap_bcio_histor = 04.00.
    /* set return-inserted = yes for editors */
    assign ed_4x60:return-inserted in frame f_dlg_01_movto_tit_ap_bcio_histor = yes.
    /* set private-data for the help system */
    assign ed_4x60:private-data in frame f_dlg_01_movto_tit_ap_bcio_histor = "HLP=000000000":U
           bt_ok:private-data   in frame f_dlg_01_movto_tit_ap_bcio_histor = "HLP=000010721":U
           bt_can:private-data  in frame f_dlg_01_movto_tit_ap_bcio_histor = "HLP=000011050":U
           bt_hel2:private-data in frame f_dlg_01_movto_tit_ap_bcio_histor = "HLP=000011326":U
           frame f_dlg_01_movto_tit_ap_bcio_histor:private-data            = "HLP=000000000".

def frame f_dlg_01_tit_ap_bcio_faixa
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 10.08 col 02.00 bgcolor 7 
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_ini
         at row 02.00 col 16.00 colon-aligned label "Estabelecimento"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_ini
         at row 02.00 col 16.00 colon-aligned label "Estabelecimento"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_fim
         at row 02.00 col 51.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_fim
         at row 02.00 col 51.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
    v_cod_id_feder
         at row 03.00 col 16.00 colon-aligned label "ID Federal"
         help "C¢digo ou Nome Abreviado ou ID federal do Fornecedor"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_id_feder_apb_fim
         at row 03.00 col 51.00 colon-aligned label "atÇ"
         help "CGC/CPF Fornecedor Final"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_ini
         at row 04.00 col 16.00 colon-aligned label "Data Vencimento"
         help "Data Vencimento Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_fim
         at row 04.00 col 51.00 colon-aligned label "atÇ"
         help "Data Vencimento Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_fornecedor_ini
         at row 05.00 col 16.00 colon-aligned label "Fornecedor"
         help "C¢digo Fornecedor Inicial"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo2
         at row 05.00 col 30.00 font ?
         help "Zoom"
    v_cdn_fornecedor_fim
         at row 05.00 col 51.00 colon-aligned label "atÇ"
         help "C¢digo Fornecedor"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo3
         at row 05.00 col 65.00 font ?
         help "Zoom"
    v_nom_fornecedor_ini
         at row 06.00 col 16.00 colon-aligned label "Nome Fornecedor"
         help "Nome Fornecedor Inicial"
         view-as fill-in
         size-chars 31.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_nom_fornecedor_fim
         at row 06.00 col 51.00 colon-aligned label "atÇ"
         help "Nome Fornecedor Final"
         view-as fill-in
         size-chars 31.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_entr_sist_ini
         at row 07.00 col 16.00 colon-aligned label "Data Entr. Sist"
         help "Data Entrada Sistema Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_entr_sist_fim
         at row 07.00 col 51.00 colon-aligned label "atÇ"
         help "Data Entrada Sistema Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_tit_ap_bcio_ini
         at row 08.00 col 16.00 colon-aligned label "Valor T°tulo Bcio"
         help "Valor T°tulo Banc†rio Inicial"
         view-as fill-in
         size-chars 16.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_tit_ap_bcio_fim
         at row 08.00 col 51.00 colon-aligned label "atÇ"
         help "Valor T°tulo Banc†rio Final"
         view-as fill-in
         size-chars 16.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 10.29 col 03.00 font ?
         help "OK"
    bt_can
         at row 10.29 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 10.29 col 76.14 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 88.57 by 11.92 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa Selec∆o T°tulos Banc†rios".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_bcio_faixa = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_bcio_faixa = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_bcio_faixa = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_bcio_faixa = 01.00
           bt_zoo2:width-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 04.00
           bt_zoo2:height-chars in frame f_dlg_01_tit_ap_bcio_faixa = 00.88
           bt_zoo3:width-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 04.00
           bt_zoo3:height-chars in frame f_dlg_01_tit_ap_bcio_faixa = 00.88
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 85.14
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_bcio_faixa = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_bcio_faixa = 85.14
           rt_mold:height-chars in frame f_dlg_01_tit_ap_bcio_faixa = 08.50.
    /* set private-data for the help system */
    assign v_cod_estab_ini:private-data        in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000016633":U
           v_cod_estab_fim:private-data        in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000016634":U
           v_cod_id_feder:private-data         in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_cod_id_feder_apb_fim:private-data in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_dat_vencto_ini:private-data       in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_dat_vencto_fim:private-data       in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_cdn_fornecedor_ini:private-data   in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000018870":U
           bt_zoo2:private-data                in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000009432":U
           v_cdn_fornecedor_fim:private-data   in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000018871":U
           bt_zoo3:private-data                in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000009433":U
           v_nom_fornecedor_ini:private-data   in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_nom_fornecedor_fim:private-data   in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_dat_entr_sist_ini:private-data    in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_dat_entr_sist_fim:private-data    in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_val_tit_ap_bcio_ini:private-data  in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           v_val_tit_ap_bcio_fim:private-data  in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000000000":U
           bt_ok:private-data                  in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000010721":U
           bt_can:private-data                 in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000011050":U
           bt_hel2:private-data                in frame f_dlg_01_tit_ap_bcio_faixa = "HLP=000011326":U
           frame f_dlg_01_tit_ap_bcio_faixa:private-data                           = "HLP=000000000".

def frame f_dlg_01_tit_ap_bcio_filtro
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 07.54 col 02.00 bgcolor 7 
    v_log_concil_nao_confer
         at row 02.00 col 10.00 label "Conciliados n∆o conferidos"
         view-as toggle-box
    v_log_nao_concil
         at row 03.00 col 10.00 label "N∆o conciliados"
         view-as toggle-box
    v_log_concil_confer
         at row 04.00 col 10.00 label "Conciliados conferidos"
         view-as toggle-box
    v_log_tit_ap_bcio_cancel
         at row 05.00 col 10.00 label "Cancelados"
         view-as toggle-box
    v_log_matriz_fornec
         at row 06.00 col 10.00 label "T°tulos da Matriz e Filial do Fornecedor"
         view-as toggle-box
    bt_ok
         at row 07.75 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.75 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 07.75 col 33.29 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 45.72 by 09.38 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Filtro T°tulos Banc†rios".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_bcio_filtro = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_bcio_filtro = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_bcio_filtro = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_bcio_filtro = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_bcio_filtro = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_bcio_filtro = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_bcio_filtro = 42.29
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_bcio_filtro = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_bcio_filtro = 42.29
           rt_mold:height-chars in frame f_dlg_01_tit_ap_bcio_filtro = 05.96.
    /* set private-data for the help system */
    assign v_log_concil_nao_confer:private-data  in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000000000":U
           v_log_nao_concil:private-data         in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000000000":U
           v_log_concil_confer:private-data      in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000000000":U
           v_log_tit_ap_bcio_cancel:private-data in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000000000":U
           v_log_matriz_fornec:private-data      in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000000000":U
           bt_ok:private-data                    in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000010721":U
           bt_can:private-data                   in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_dlg_01_tit_ap_bcio_filtro = "HLP=000011326":U
           frame f_dlg_01_tit_ap_bcio_filtro:private-data                             = "HLP=000000000".

def frame f_dlg_01_tit_ap_bcio_legenda
    rt_mold
         at row 01.21 col 02.00
    rt_006
         at row 02.00 col 04.57
    " T°tulos Banc†rios " view-as text
         at row 01.70 col 06.57 bgcolor 8 
    rt_007
         at row 07.50 col 04.57
    " T°tulos Contas a Pagar " view-as text
         at row 07.20 col 06.57 bgcolor 8 
    rt_cxcf
         at row 10.88 col 02.00 bgcolor 7 
    rt_001
         at row 02.71 col 08.00 bgcolor 8 
    rt_002
         at row 03.71 col 08.00 bgcolor 8 
    rt_003
         at row 04.71 col 08.00 bgcolor 8 
    rt_004
         at row 08.00 col 08.00 bgcolor 8 
    rt_005
         at row 09.00 col 08.00 bgcolor 8 
    rt_008
         at row 05.71 col 08.00 bgcolor 8 
    "N∆o Conciliados"
         at row 02.71 col 11.00 font 1
         view-as text /*l_nao_conciliados*/
    "Conciliados"
         at row 03.71 col 11.00 font 1
         view-as text /*l_conciliados*/
    "Conciliados e n∆o Conferidos"
         at row 04.71 col 11.00 font 1
         view-as text /*l_conciliados_n_conferidos*/
    "Cancelados"
         at row 05.71 col 11.00 font 1
         view-as text /*l_cancelados*/
    "N∆o Conciliados (APB)"
         at row 08.00 col 11.00 font 1
         view-as text /*l_x_nao_conciliados*/
    "Conciliados (APB)"
         at row 09.00 col 11.00 font 1
         view-as text /*l_conciliados_apb*/
    bt_ok
         at row 11.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 11.08 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 11.08 col 45.86 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 58.29 by 12.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Legenda".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_bcio_legenda = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_bcio_legenda = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 01.00
           rt_001:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_001:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_002:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_002:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_003:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_003:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_004:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_004:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_005:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_005:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_006:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 50.00
           rt_006:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 05.00
           rt_007:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 50.00
           rt_007:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 02.50
           rt_008:width-chars   in frame f_dlg_01_tit_ap_bcio_legenda = 02.00
           rt_008:height-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 00.71
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 54.86
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_bcio_legenda = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_bcio_legenda = 54.86
           rt_mold:height-chars in frame f_dlg_01_tit_ap_bcio_legenda = 09.29.
    /* set private-data for the help system */
    assign bt_ok:private-data   in frame f_dlg_01_tit_ap_bcio_legenda = "HLP=000010721":U
           bt_can:private-data  in frame f_dlg_01_tit_ap_bcio_legenda = "HLP=000011050":U
           bt_hel2:private-data in frame f_dlg_01_tit_ap_bcio_legenda = "HLP=000011326":U
           frame f_dlg_01_tit_ap_bcio_legenda:private-data            = "HLP=000000000".

def frame f_dlg_01_tit_ap_bcio_parametros
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.79 col 02.00 bgcolor 7 
    v_log_cop_cod_barra
         at row 01.88 col 15.43 label "C¢digo de Barras"
         help "Copia C¢digo Barra"
         view-as toggle-box
    bt_ok
         at row 04.00 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.00 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 04.00 col 37.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 50.00 by 05.63 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "ParÉmetros para Conciliaá∆o".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_bcio_parametros = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_bcio_parametros = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_bcio_parametros = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_bcio_parametros = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_bcio_parametros = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros = 46.57
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_bcio_parametros = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros = 46.57
           rt_mold:height-chars in frame f_dlg_01_tit_ap_bcio_parametros = 02.21.
    /* set private-data for the help system */
    assign v_log_cop_cod_barra:private-data in frame f_dlg_01_tit_ap_bcio_parametros = "HLP=000000000":U
           bt_ok:private-data               in frame f_dlg_01_tit_ap_bcio_parametros = "HLP=000010721":U
           bt_can:private-data              in frame f_dlg_01_tit_ap_bcio_parametros = "HLP=000011050":U
           bt_hel2:private-data             in frame f_dlg_01_tit_ap_bcio_parametros = "HLP=000011326":U
           frame f_dlg_01_tit_ap_bcio_parametros:private-data                        = "HLP=000000000".

def frame f_dlg_01_tit_ap_bcio_parametros_bank
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 13.13 col 02.00 bgcolor 7 
    v_log_barra_5
         at row 02.00 col 16.00 label "C¢digo de Barras"
         view-as toggle-box
    v_log_bancario
         at row 03.00 col 16.00 label "N£mero Banc†rio"
         view-as toggle-box
    v_log_dat_vencto
         at row 04.00 col 16.00 label "Data Vencimento"
         view-as toggle-box
    v_log_desconto
         at row 05.00 col 16.00 label "Data Desconto"
         view-as toggle-box
    v_log_val_desc
         at row 06.00 col 16.00 label "Valor Desconto"
         view-as toggle-box
    v_log_dat_multa
         at row 07.00 col 16.00 label "Data Multa"
         view-as toggle-box
    v_log_val_multa
         at row 08.00 col 16.00 label "Valor Multa"
         view-as toggle-box
    v_log_val_juros
         at row 09.00 col 16.00 label "Valor Juros"
         view-as toggle-box
    v_log_forma_pagto_3
         at row 10.00 col 16.00 label "Forma Pagto"
         view-as toggle-box
    v_cod_forma_pagto
         at row 11.00 col 14.00 colon-aligned label "Forma Pagamento"
         help "Forma Pagamento"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_427364
         at row 11.00 col 20.14
    bt_ok
         at row 13.33 col 03.00 font ?
         help "OK"
    bt_can
         at row 13.33 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 13.33 col 37.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 50.00 by 14.96 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "T°tulo Banc†rio".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_bcio_parametros_bank = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_bcio_parametros_bank = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros_bank = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_bcio_parametros_bank = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_bcio_parametros_bank = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_bcio_parametros_bank = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros_bank = 46.57
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_bcio_parametros_bank = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_bcio_parametros_bank = 46.57
           rt_mold:height-chars in frame f_dlg_01_tit_ap_bcio_parametros_bank = 11.54.
    /* set private-data for the help system */
    assign v_log_barra_5:private-data       in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_bancario:private-data      in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_dat_vencto:private-data    in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_desconto:private-data      in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_val_desc:private-data      in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_dat_multa:private-data     in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_val_multa:private-data     in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_val_juros:private-data     in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           v_log_forma_pagto_3:private-data in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000000000":U
           bt_zoo_427364:private-data       in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000009431":U
           v_cod_forma_pagto:private-data   in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000018869":U
           bt_ok:private-data               in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000010721":U
           bt_can:private-data              in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000011050":U
           bt_hel2:private-data             in frame f_dlg_01_tit_ap_bcio_parametros_bank = "HLP=000011326":U
           frame f_dlg_01_tit_ap_bcio_parametros_bank:private-data                        = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_427364:sensitive in frame f_dlg_01_tit_ap_bcio_parametros_bank = yes.
    /* move buttons to top */
    bt_zoo_427364:move-to-top().

def frame f_dlg_01_tit_ap_faixa
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 10.33 col 02.00 bgcolor 7 
    v_cod_estab_apb_inic
         at row 02.00 col 23.00 colon-aligned label "Estabelecimento"
         help "Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_apb_fim
         at row 02.00 col 51.00 colon-aligned label "atÇ"
         help "Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_apb_inic
         at row 03.00 col 23.00 colon-aligned label "Data Vencimento"
         help "Data Vencto Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_apb_fim
         at row 03.00 col 51.00 colon-aligned label "atÇ"
         help "Data Vencto Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_apb_inic
         at row 04.00 col 23.00 colon-aligned label "Data Emiss∆o"
         help "Data Emiss∆o T°tulo Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_apb_fim
         at row 04.00 col 51.00 colon-aligned label "atÇ"
         help "Data Emiss∆o T°tulo Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_origin_apb_inic
         at row 05.00 col 23.00 colon-aligned label "Valor Original T°t."
         help "Valor Original Inicial"
         view-as fill-in
         size-chars 16.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_origin_apb_fim
         at row 05.00 col 51.00 colon-aligned label "atÇ"
         help "Valor Original Final"
         view-as fill-in
         size-chars 16.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_multi_sel_tela
         at row 06.04 col 23.00 colon-aligned label "EspÇcie"
         help "EspÇcies"
         view-as editor max-chars 250 no-word-wrap
         size 30 by 1
         bgcolor 15 font 2
    bt_todos_img_3
         at row 06.00 col 55.00 font ?
         help "Seleciona Todos"
    v_cod_portad_multi_sel_tela
         at row 07.17 col 23.00 colon-aligned label "Portador"
         help "Portadores"
         view-as editor max-chars 250 no-word-wrap
         size 30 by 1
         bgcolor 15 font 2
    bt_select_br_all
         at row 07.13 col 55.00 font ?
         help "Seleciona Todos"
    v_cod_forma_pagto_multi_sel_tela
         at row 08.33 col 23.00 colon-aligned label "Forma Pagamento"
         help "Formas de Pagamento"
         view-as editor max-chars 250 no-word-wrap
         size 30 by 1
         bgcolor 15 font 2
    bt_todos_img_2
         at row 08.29 col 55.00 font ?
         help "Seleciona Todos"
    bt_ok
         at row 10.54 col 03.00 font ?
         help "OK"
    bt_can
         at row 10.54 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 10.54 col 77.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 12.17 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa Seleá∆o T°tulos APB".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars            in frame f_dlg_01_tit_ap_faixa = 10.00
           bt_can:height-chars           in frame f_dlg_01_tit_ap_faixa = 01.00
           bt_hel2:width-chars           in frame f_dlg_01_tit_ap_faixa = 10.00
           bt_hel2:height-chars          in frame f_dlg_01_tit_ap_faixa = 01.00
           bt_ok:width-chars             in frame f_dlg_01_tit_ap_faixa = 10.00
           bt_ok:height-chars            in frame f_dlg_01_tit_ap_faixa = 01.00
           bt_select_br_all:width-chars  in frame f_dlg_01_tit_ap_faixa = 04.00
           bt_select_br_all:height-chars in frame f_dlg_01_tit_ap_faixa = 01.13
           bt_todos_img_2:width-chars    in frame f_dlg_01_tit_ap_faixa = 04.00
           bt_todos_img_2:height-chars   in frame f_dlg_01_tit_ap_faixa = 01.13
           bt_todos_img_3:width-chars    in frame f_dlg_01_tit_ap_faixa = 04.00
           bt_todos_img_3:height-chars   in frame f_dlg_01_tit_ap_faixa = 01.13
           rt_cxcf:width-chars           in frame f_dlg_01_tit_ap_faixa = 86.57
           rt_cxcf:height-chars          in frame f_dlg_01_tit_ap_faixa = 01.42
           rt_mold:width-chars           in frame f_dlg_01_tit_ap_faixa = 86.57
           rt_mold:height-chars          in frame f_dlg_01_tit_ap_faixa = 08.75.
    /* set return-inserted = yes for editors */
    assign v_cod_espec_multi_sel_tela:return-inserted       in frame f_dlg_01_tit_ap_faixa = yes
           v_cod_portad_multi_sel_tela:return-inserted      in frame f_dlg_01_tit_ap_faixa = yes
           v_cod_forma_pagto_multi_sel_tela:return-inserted in frame f_dlg_01_tit_ap_faixa = yes.
    /* set private-data for the help system */
    assign v_cod_estab_apb_inic:private-data             in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_cod_estab_apb_fim:private-data              in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_dat_vencto_apb_inic:private-data            in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_dat_vencto_apb_fim:private-data             in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_dat_emis_apb_inic:private-data              in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_dat_emis_apb_fim:private-data               in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_val_origin_apb_inic:private-data            in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_val_origin_apb_fim:private-data             in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_cod_espec_multi_sel_tela:private-data       in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           bt_todos_img_3:private-data                   in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_cod_portad_multi_sel_tela:private-data      in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           bt_select_br_all:private-data                 in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           v_cod_forma_pagto_multi_sel_tela:private-data in frame f_dlg_01_tit_ap_faixa = "HLP=000000000":U
           bt_todos_img_2:private-data                   in frame f_dlg_01_tit_ap_faixa = "HLP=000021505":U
           bt_ok:private-data                            in frame f_dlg_01_tit_ap_faixa = "HLP=000010721":U
           bt_can:private-data                           in frame f_dlg_01_tit_ap_faixa = "HLP=000011050":U
           bt_hel2:private-data                          in frame f_dlg_01_tit_ap_faixa = "HLP=000011326":U
           frame f_dlg_01_tit_ap_faixa:private-data                                     = "HLP=000000000".

def frame f_dlg_01_tit_ap_filtro
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 05.71 col 02.00 bgcolor 7 
    rs_tt_tit_ap_conciliacao
         at row 02.00 col 10.00
         help "" no-label
    bt_ok
         at row 05.92 col 03.00 font ?
         help "OK"
    bt_can
         at row 05.92 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 05.92 col 30.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 43.00 by 07.54 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Filtro T°tulos APB".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_tit_ap_filtro = 10.00
           bt_can:height-chars  in frame f_dlg_01_tit_ap_filtro = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_tit_ap_filtro = 10.00
           bt_hel2:height-chars in frame f_dlg_01_tit_ap_filtro = 01.00
           bt_ok:width-chars    in frame f_dlg_01_tit_ap_filtro = 10.00
           bt_ok:height-chars   in frame f_dlg_01_tit_ap_filtro = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_tit_ap_filtro = 39.57
           rt_cxcf:height-chars in frame f_dlg_01_tit_ap_filtro = 01.42
           rt_mold:width-chars  in frame f_dlg_01_tit_ap_filtro = 39.57
           rt_mold:height-chars in frame f_dlg_01_tit_ap_filtro = 04.13.
    /* set private-data for the help system */
    assign rs_tt_tit_ap_conciliacao:private-data in frame f_dlg_01_tit_ap_filtro = "HLP=000000000":U
           bt_ok:private-data                    in frame f_dlg_01_tit_ap_filtro = "HLP=000010721":U
           bt_can:private-data                   in frame f_dlg_01_tit_ap_filtro = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_dlg_01_tit_ap_filtro = "HLP=000011326":U
           frame f_dlg_01_tit_ap_filtro:private-data                             = "HLP=000000000".

def frame f_dlg_03_tit_ap_bcio_historico
    rt_001
         at row 01.21 col 01.72 bgcolor 8 
    rt_cxcf
         at row 12.58 col 02.00 bgcolor 7 
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
         at row 01.38 col 08.43 colon-aligned label "Estab"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_ap_em_bco.tta_cod_estab
         at row 01.38 col 08.43 colon-aligned label "Estab"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
    tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
         at row 01.38 col 29.00 colon-aligned label "C¢digo Sist Banc†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_historico_padrao
         at row 01.38 col 41.29 font ?
         help "Hist¢rico do Movimento"
    tt_tit_ap_em_bco.tta_cod_tit_ap_bco
         at row 02.38 col 13.43 colon-aligned label "T°tulo  Banco"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    br_tit_ap_bcio_historico
         at row 03.58 col 01.72
    bt_ok
         at row 12.79 col 03.00 font ?
         help "OK"
    bt_can
         at row 12.79 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 12.79 col 35.14 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 47.57 by 14.50 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Movimentos T°tulos Banc†rios".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_dlg_03_tit_ap_bcio_historico = 10.00
           bt_can:height-chars              in frame f_dlg_03_tit_ap_bcio_historico = 01.00
           bt_hel2:width-chars              in frame f_dlg_03_tit_ap_bcio_historico = 10.00
           bt_hel2:height-chars             in frame f_dlg_03_tit_ap_bcio_historico = 01.00
           bt_historico_padrao:width-chars  in frame f_dlg_03_tit_ap_bcio_historico = 04.00
           bt_historico_padrao:height-chars in frame f_dlg_03_tit_ap_bcio_historico = 01.13
           bt_ok:width-chars                in frame f_dlg_03_tit_ap_bcio_historico = 10.00
           bt_ok:height-chars               in frame f_dlg_03_tit_ap_bcio_historico = 01.00
           rt_001:width-chars               in frame f_dlg_03_tit_ap_bcio_historico = 45.00
           rt_001:height-chars              in frame f_dlg_03_tit_ap_bcio_historico = 02.21
           rt_cxcf:width-chars              in frame f_dlg_03_tit_ap_bcio_historico = 44.14
           rt_cxcf:height-chars             in frame f_dlg_03_tit_ap_bcio_historico = 01.42.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tit_ap_bcio_historico:ALLOW-COLUMN-SEARCHING in frame f_dlg_03_tit_ap_bcio_historico = no
       br_tit_ap_bcio_historico:COLUMN-MOVABLE in frame f_dlg_03_tit_ap_bcio_historico = no.
end.
&endif
    /* set private-data for the help system */
    assign tt_tit_ap_em_bco.tta_cod_estab:private-data         in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000000000":U
           tt_tit_ap_em_bco.tta_cod_sist_nac_bcio:private-data in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000000000":U
           bt_historico_padrao:private-data                    in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000013076":U
           tt_tit_ap_em_bco.tta_cod_tit_ap_bco:private-data    in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000000000":U
           br_tit_ap_bcio_historico:private-data               in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000000000":U
           bt_ok:private-data                                  in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000010721":U
           bt_can:private-data                                 in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000011050":U
           bt_hel2:private-data                                in frame f_dlg_03_tit_ap_bcio_historico = "HLP=000011326":U
           frame f_dlg_03_tit_ap_bcio_historico:private-data                                           = "HLP=000000000".

def frame f_dlg_03_varredura_sacado
    rt_002
         at row 02.88 col 83.86 bgcolor 8 
    rt_003
         at row 02.88 col 02.14
    " Banco " view-as text
         at row 02.58 col 04.14 bgcolor 8 
    rt_004
         at row 11.29 col 02.00
    " Contas a Pagar " view-as text
         at row 10.99 col 04.00 bgcolor 8 
    rt_005
         at row 11.29 col 83.86 bgcolor 8 
    rt_cxcf
         at row 18.08 col 02.00 bgcolor 7 
    rt_001
         at row 01.21 col 02.14 bgcolor 8 
    rt_006
         at row 01.21 col 60.00 bgcolor 8 
    bt_param1_im
         at row 01.33 col 60.57 font ?
         help "ParÉmetros"
    bt_legenda
         at row 01.33 col 64.57 font ?
         help "Legenda"
    bt_concil_autom_titulos
         at row 01.33 col 68.57 font ?
         help "Conciliaá∆o Automat. de T°tulos"
    bt_localiza
         at row 01.33 col 76.14 font ?
         help "Localiza"
    bt_mod4
         at row 01.33 col 80.14 font ?
         help "Modifica"
    bt_era1
         at row 01.33 col 84.14 font ?
         help "Elimina"
    bt_check
         at row 03.00 col 84.29 font ?
    bt_ran2
         at row 04.00 col 84.29 font ?
         help "Faixa"
    bt_fil2
         at row 05.00 col 84.29 font ?
         help "Filtro"
    bt_det1
         at row 06.00 col 84.29 font ?
         help "Detalhe"
    bt_mod1
         at row 07.00 col 84.29 font ?
         help "Modifica"
    bt_mov1
         at row 08.00 col 84.29 font ?
         help "Movimentos"
    bt_elimina_image
         at row 09.00 col 84.29 font ?
         help "Elimina"
    bt_cancelamento
         at row 10.00 col 84.29 font ?
         help "Cancelamento"
    bt_check7
         at row 11.38 col 84.29 font ?
    bt_ran6
         at row 12.38 col 84.29 font ?
         help "Faixa"
    bt_fil3
         at row 13.38 col 84.29 font ?
         help "Filtro"
    bt_det_10
         at row 14.38 col 84.29 font ?
         help "Detalhe"
    bt_concil_manual_titulos
         at row 15.79 col 83.86 font ?
         help "Conciliaá∆o Manual de T°tulos"
    bt_desconcil_1
         at row 16.79 col 83.86 font ?
         help "Desconciliaá∆o Manual T°tulos"
    bt_ok
         at row 18.29 col 03.00 font ?
         help "OK"
    bt_can
         at row 18.29 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 18.29 col 77.57 font ?
         help "Ajuda"
    br_tit_ap_em_bco
         at row 03.21 col 02.72
    br_tt_tit_ap_conciliacao
         at row 11.71 col 02.72
    br_tit_ap_em_bco_bank
         at row 03.21 col 02.72
    br_tt_tit_ap_conciliacao_bank
         at row 11.71 col 02.72
    v_cdn_sist_nac_bcio
         at row 01.42 col 17.29 colon-aligned
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 20.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Varredura de Sacado".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars                    in frame f_dlg_03_varredura_sacado = 10.00
           bt_can:height-chars                   in frame f_dlg_03_varredura_sacado = 01.00
           bt_cancelamento:width-chars           in frame f_dlg_03_varredura_sacado = 04.00
           bt_cancelamento:height-chars          in frame f_dlg_03_varredura_sacado = 01.13
           bt_check:width-chars                  in frame f_dlg_03_varredura_sacado = 04.00
           bt_check:height-chars                 in frame f_dlg_03_varredura_sacado = 01.04
           bt_check7:width-chars                 in frame f_dlg_03_varredura_sacado = 04.00
           bt_check7:height-chars                in frame f_dlg_03_varredura_sacado = 01.04
           bt_concil_autom_titulos:width-chars   in frame f_dlg_03_varredura_sacado = 04.00
           bt_concil_autom_titulos:height-chars  in frame f_dlg_03_varredura_sacado = 01.08
           bt_concil_manual_titulos:width-chars  in frame f_dlg_03_varredura_sacado = 04.86
           bt_concil_manual_titulos:height-chars in frame f_dlg_03_varredura_sacado = 01.04
           bt_desconcil_1:width-chars            in frame f_dlg_03_varredura_sacado = 04.86
           bt_desconcil_1:height-chars           in frame f_dlg_03_varredura_sacado = 01.04
           bt_det1:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_det1:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_det_10:width-chars                 in frame f_dlg_03_varredura_sacado = 04.00
           bt_det_10:height-chars                in frame f_dlg_03_varredura_sacado = 01.04
           bt_elimina_image:width-chars          in frame f_dlg_03_varredura_sacado = 04.00
           bt_elimina_image:height-chars         in frame f_dlg_03_varredura_sacado = 01.08
           bt_era1:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_era1:height-chars                  in frame f_dlg_03_varredura_sacado = 01.08
           bt_fil2:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_fil2:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_fil3:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_fil3:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_hel2:width-chars                   in frame f_dlg_03_varredura_sacado = 10.00
           bt_hel2:height-chars                  in frame f_dlg_03_varredura_sacado = 01.00
           bt_legenda:width-chars                in frame f_dlg_03_varredura_sacado = 04.00
           bt_legenda:height-chars               in frame f_dlg_03_varredura_sacado = 01.08
           bt_localiza:width-chars               in frame f_dlg_03_varredura_sacado = 04.00
           bt_localiza:height-chars              in frame f_dlg_03_varredura_sacado = 01.08
           bt_mod1:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_mod1:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_mod4:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_mod4:height-chars                  in frame f_dlg_03_varredura_sacado = 01.08
           bt_mov1:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_mov1:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_ok:width-chars                     in frame f_dlg_03_varredura_sacado = 10.00
           bt_ok:height-chars                    in frame f_dlg_03_varredura_sacado = 01.00
           bt_param1_im:width-chars              in frame f_dlg_03_varredura_sacado = 04.00
           bt_param1_im:height-chars             in frame f_dlg_03_varredura_sacado = 01.08
           bt_ran2:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_ran2:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           bt_ran6:width-chars                   in frame f_dlg_03_varredura_sacado = 04.00
           bt_ran6:height-chars                  in frame f_dlg_03_varredura_sacado = 01.04
           rt_001:width-chars                    in frame f_dlg_03_varredura_sacado = 57.86
           rt_001:height-chars                   in frame f_dlg_03_varredura_sacado = 01.29
           rt_002:width-chars                    in frame f_dlg_03_varredura_sacado = 04.86
           rt_002:height-chars                   in frame f_dlg_03_varredura_sacado = 08.29
           rt_003:width-chars                    in frame f_dlg_03_varredura_sacado = 81.14
           rt_003:height-chars                   in frame f_dlg_03_varredura_sacado = 08.13
           rt_004:width-chars                    in frame f_dlg_03_varredura_sacado = 81.14
           rt_004:height-chars                   in frame f_dlg_03_varredura_sacado = 06.75
           rt_005:width-chars                    in frame f_dlg_03_varredura_sacado = 04.86
           rt_005:height-chars                   in frame f_dlg_03_varredura_sacado = 04.25
           rt_006:width-chars                    in frame f_dlg_03_varredura_sacado = 28.57
           rt_006:height-chars                   in frame f_dlg_03_varredura_sacado = 01.29
           rt_cxcf:width-chars                   in frame f_dlg_03_varredura_sacado = 86.57
           rt_cxcf:height-chars                  in frame f_dlg_03_varredura_sacado = 01.42.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tit_ap_em_bco:ALLOW-COLUMN-SEARCHING in frame f_dlg_03_varredura_sacado = no
       br_tit_ap_em_bco:COLUMN-MOVABLE in frame f_dlg_03_varredura_sacado = no.
end.
&endif
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tit_ap_em_bco_bank:ALLOW-COLUMN-SEARCHING in frame f_dlg_03_varredura_sacado = no
       br_tit_ap_em_bco_bank:COLUMN-MOVABLE in frame f_dlg_03_varredura_sacado = no.
end.
&endif
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tt_tit_ap_conciliacao:ALLOW-COLUMN-SEARCHING in frame f_dlg_03_varredura_sacado = no
       br_tt_tit_ap_conciliacao:COLUMN-MOVABLE in frame f_dlg_03_varredura_sacado = no.
end.
&endif
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tt_tit_ap_conciliacao_bank:ALLOW-COLUMN-SEARCHING in frame f_dlg_03_varredura_sacado = no
       br_tt_tit_ap_conciliacao_bank:COLUMN-MOVABLE in frame f_dlg_03_varredura_sacado = no.
end.
&endif
    /* set private-data for the help system */
    assign bt_param1_im:private-data                  in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_legenda:private-data                    in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_concil_autom_titulos:private-data       in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_localiza:private-data                   in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_mod4:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000010799":U
           bt_era1:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000011152":U
           bt_check:private-data                      in frame f_dlg_03_varredura_sacado = "HLP=000013370":U
           bt_ran2:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000008773":U
           bt_fil2:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000008766":U
           bt_det1:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000010830":U
           bt_mod1:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000010797":U
           bt_mov1:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000004657":U
           bt_elimina_image:private-data              in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_cancelamento:private-data               in frame f_dlg_03_varredura_sacado = "HLP=000011752":U
           bt_check7:private-data                     in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_ran6:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000019601":U
           bt_fil3:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000021548":U
           bt_det_10:private-data                     in frame f_dlg_03_varredura_sacado = "HLP=000021584":U
           bt_concil_manual_titulos:private-data      in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_desconcil_1:private-data                in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           bt_ok:private-data                         in frame f_dlg_03_varredura_sacado = "HLP=000010721":U
           bt_can:private-data                        in frame f_dlg_03_varredura_sacado = "HLP=000011050":U
           bt_hel2:private-data                       in frame f_dlg_03_varredura_sacado = "HLP=000011326":U
           br_tit_ap_em_bco:private-data              in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           br_tt_tit_ap_conciliacao:private-data      in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           br_tit_ap_em_bco_bank:private-data         in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           br_tt_tit_ap_conciliacao_bank:private-data in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           v_cdn_sist_nac_bcio:private-data           in frame f_dlg_03_varredura_sacado = "HLP=000000000":U
           frame f_dlg_03_varredura_sacado:private-data                                  = "HLP=000000000".



{include/i_fclfrm.i f_dlg_01_concil_autom f_dlg_01_concil_autom_confirmacao f_dlg_01_movto_tit_ap_bcio_histor f_dlg_01_tit_ap_bcio_faixa f_dlg_01_tit_ap_bcio_filtro f_dlg_01_tit_ap_bcio_legenda f_dlg_01_tit_ap_bcio_parametros f_dlg_01_tit_ap_bcio_parametros_bank f_dlg_01_tit_ap_faixa f_dlg_01_tit_ap_filtro f_dlg_03_tit_ap_bcio_historico f_dlg_03_varredura_sacado }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can IN FRAME f_dlg_01_concil_autom
DO:

    assign v_log_concil_autom = yes.
END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_concil_autom */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_concil_autom
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_concil_autom */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_concil_autom
DO:

    assign rs_regra_concil_autom    = input frame f_dlg_01_concil_autom rs_regra_concil_autom
           v_log_confir_concil      = input frame f_dlg_01_concil_autom v_log_confir_concil
           v_num_dias_aprox         = input frame f_dlg_01_concil_autom v_num_dias_aprox
           v_val_percent_variac_val = input frame f_dlg_01_concil_autom v_val_percent_variac_val.

    if  v_log_confir_concil = no
    then do:
        run pi_messages (input "show",
                         input 9793,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
        assign v_log_answer = (if   return-value = "yes" then yes
                               else if return-value = "no" then no
                               else ?) /*msg_9793*/.
        if  v_log_answer <> yes
        then do:
            return no-apply.
        end /* if */.    
    end /* if */.

    run pi_conciliacao_autom_titulos /*pi_conciliacao_autom_titulos*/.
    if  return-value = "NOK" /*l_nok*/ 
    then do:
        assign v_log_concil_autom  = no
               v_log_atualiz_autom = no.
    end /* if */.
    else do:
        assign v_log_concil_autom  = yes
               v_log_atualiz_autom = yes.
    end /* if */.



END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_concil_autom */

ON VALUE-CHANGED OF rs_regra_concil_autom IN FRAME f_dlg_01_concil_autom
DO:

    run pi_value_changed_rs_regra_concil_autom.
END. /* ON VALUE-CHANGED OF rs_regra_concil_autom IN FRAME f_dlg_01_concil_autom */

ON MOUSE-SELECT-CLICK OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    if  browse br_tt_concil_autom:num-selected-rows = 1
    then do:
        enable bt_concil_titulos_1
               with frame f_dlg_01_concil_autom_confirmacao.
    end /* if */.
    else do:
        disable bt_concil_titulos_1
                with frame f_dlg_01_concil_autom_confirmacao.
    end /* else */.
END. /* ON MOUSE-SELECT-CLICK OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao */

ON ROW-DISPLAY OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_atualiza_browse_color_2 /*pi_atualiza_browse_color_2*/.

END. /* ON ROW-DISPLAY OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao */

ON START-SEARCH OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_browse_order (Input browse br_tt_concil_autom:handle,
                         Input 'tt_concil_autom':U,
                         Input 4,
                         Input 'ttv_log_descta = no':U) /*pi_browse_order*/.
END. /* ON START-SEARCH OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao */

ON VALUE-CHANGED OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    if  browse br_tt_concil_autom:num-selected-rows = 1
    then do:
        enable bt_concil_titulos_1
               with frame f_dlg_01_concil_autom_confirmacao.
    end /* if */.
    else do:
        disable bt_concil_titulos_1
                with frame f_dlg_01_concil_autom_confirmacao.
    end /* else */.
END. /* ON VALUE-CHANGED OF br_tt_concil_autom IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_can IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    for each tt_concil_autom:
        delete tt_concil_autom.
    end.

    assign v_log_concil_autom_confir = yes
           v_log_concil_autom        = no.
END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_concil_titulos_1 IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_concil_titulos_1 /*pi_concil_titulos_1*/.
    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.

END. /* ON CHOOSE OF bt_concil_titulos_1 IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_concil_autom_confirmacao
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_nenhum IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    if  br_tt_concil_autom:num-selected-rows > 0
    then do:
        assign v_log_method = browse br_tt_concil_autom:deselect-rows().
    end /* if */.
    enable bt_concil_titulos_1
           with frame f_dlg_01_concil_autom_confirmacao.
END. /* ON CHOOSE OF bt_nenhum IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    if num-results('qr_tt_concil_autom') = 0 then do:
        assign v_log_concil_autom_confir   = yes.
    end.
    else do:
        run pi_concil_autom_confirmacao_bt_ok /*pi_concil_autom_confirmacao_bt_ok*/.

        if  return-value = "NOK" /*l_nok*/ 
        then do:
            assign v_log_concil_autom_confir   = no.        
        end /* if */.
        else do:
            assign v_log_concil_autom_confir   = yes.
        end /* else */.
    end.    

END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_todos IN FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_seleciona_multiplos_titulos /*pi_seleciona_multiplos_titulos*/.
    if return-value = "NOK" /*l_nok*/  then
        return no-apply.
END. /* ON CHOOSE OF bt_todos IN FRAME f_dlg_01_concil_autom_confirmacao */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_movto_tit_ap_bcio_histor
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_movto_tit_ap_bcio_histor */

ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    assign v_log_faixa_ok             = yes
           v_log_tit_ap_bcio_habilita = no.

END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_bcio_faixa */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_faixa
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_faixa */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    run pi_btok_dlg_01_tit_ap_bcio_faixa /*pi_btok_dlg_01_tit_ap_bcio_faixa*/.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_faixa */

ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    run pi_busca_fornecedor(input v_cdn_fornecedor_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa).
END. /* ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_01_tit_ap_bcio_faixa */

ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    run pi_busca_fornecedor(input v_cdn_fornecedor_fim:handle in frame f_dlg_01_tit_ap_bcio_faixa).
END. /* ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_01_tit_ap_bcio_faixa */

ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_bcio_filtro
DO:

    assign v_log_tit_ap_bcio_habilita = no.
END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_bcio_filtro */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_filtro
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_filtro */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_filtro
DO:

    if  input frame f_dlg_01_tit_ap_bcio_filtro v_log_concil_confer      = no and
        input frame f_dlg_01_tit_ap_bcio_filtro v_log_concil_nao_confer  = no and
        input frame f_dlg_01_tit_ap_bcio_filtro v_log_nao_concil         = no and
        input frame f_dlg_01_tit_ap_bcio_filtro v_log_matriz_fornec      = no and
        input frame f_dlg_01_tit_ap_bcio_filtro v_log_tit_ap_bcio_cancel = no
    then do:
        /* Nenhum filtro foi informado ! */
        run pi_messages (input "show",
                         input 9812,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9812*/.
        return no-apply.
    end /* if */.    

    assign v_log_tit_ap_bcio_habilita = yes.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_filtro */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_legenda
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_legenda */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_parametros
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_parametros */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:

    &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
    if string(v_log_forma_pagto_3:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank) = "Sim" /*l_sim*/  then do:
        if v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank <> '' then do:
            find first forma_pagto no-lock
              where forma_pagto.cod_forma_pagto = v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank no-error.
            if not avail forma_pagto then do:
                /* Forma de Pagamento &1 Inexistente ! */
                run pi_messages (input "show",
                                 input 6238,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank)) /*msg_6238*/.
                return no-apply.        
            end.
            else do:
                if forma_pagto.ind_tip_forma_pagto <> "Boleto" /*l_boleto*/  then do:
                    /* Forma de Pagamento deve ser do tipo Boleto ! */
                    run pi_messages (input "show",
                                     input 20132,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_20132*/.
                    return no-apply.
                end.
                else do:
                    assign input v_log_forma_pagto_3
                           input v_cod_forma_pagto.
                end.
            end.
        end.
        else do:
            /* Forma de Pagamento &1 Inexistente ! */
            run pi_messages (input "show",
                             input 6238,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank)) /*msg_6238*/.
            return no-apply.
        end. 
    end.
    &ENDIF
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON VALUE-CHANGED OF v_log_forma_pagto_3 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:

    if string(v_log_forma_pagto_3:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank) = "Sim" /*l_sim*/  then
        assign v_cod_forma_pagto:sensitive in frame f_dlg_01_tit_ap_bcio_parametros_bank = yes
               bt_zoo_427364:sensitive in frame f_dlg_01_tit_ap_bcio_parametros_bank = yes.
    else
        assign v_cod_forma_pagto:sensitive in frame f_dlg_01_tit_ap_bcio_parametros_bank = no
               v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank = ''
               bt_zoo_427364:sensitive in frame f_dlg_01_tit_ap_bcio_parametros_bank = no.
END. /* ON VALUE-CHANGED OF v_log_forma_pagto_3 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_faixa
DO:

    assign v_log_tit_ap_faixa_ok           = yes
           v_log_tit_ap_habilita           = no.        


END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_faixa
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_faixa
DO:

    run pi_btok_dlg_01_tit_ap_faixa /*pi_btok_dlg_01_tit_ap_faixa*/.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_select_br_all IN FRAME f_dlg_01_tit_ap_faixa
DO:

    run pi_filters_dlg_01_tit_ap_faixa (Input 2) /*pi_filters_dlg_01_tit_ap_faixa*/.
END. /* ON CHOOSE OF bt_select_br_all IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_todos_img_2 IN FRAME f_dlg_01_tit_ap_faixa
DO:

    run pi_filters_dlg_01_tit_ap_faixa (Input 3) /*pi_filters_dlg_01_tit_ap_faixa*/.
END. /* ON CHOOSE OF bt_todos_img_2 IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_todos_img_3 IN FRAME f_dlg_01_tit_ap_faixa
DO:

    run pi_filters_dlg_01_tit_ap_faixa (Input 1) /*pi_filters_dlg_01_tit_ap_faixa*/.
END. /* ON CHOOSE OF bt_todos_img_3 IN FRAME f_dlg_01_tit_ap_faixa */

ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_filtro
DO:

    assign v_log_tit_ap_habilita = no.
END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_01_tit_ap_filtro */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_filtro
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_tit_ap_filtro */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_filtro
DO:

    assign v_log_tit_ap_habilita = yes.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_tit_ap_filtro */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_tit_ap_bcio_historico
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_tit_ap_bcio_historico */

ON CHOOSE OF bt_historico_padrao IN FRAME f_dlg_03_tit_ap_bcio_historico
DO:

    view frame f_dlg_01_movto_tit_ap_bcio_histor.
    enable all with frame f_dlg_01_movto_tit_ap_bcio_histor.
    assign ed_4x60:read-only in frame f_dlg_01_movto_tit_ap_bcio_histor = yes
           ed_4x60:screen-value in frame f_dlg_01_movto_tit_ap_bcio_histor = tt_movto_tit_ap_bcio_histor.tta_dsl_histor_movto_bco.
    wait-for go of frame f_dlg_01_movto_tit_ap_bcio_histor or
             endkey of frame f_dlg_01_movto_tit_ap_bcio_histor.
    hide frame f_dlg_01_movto_tit_ap_bcio_histor.
END. /* ON CHOOSE OF bt_historico_padrao IN FRAME f_dlg_03_tit_ap_bcio_historico */

ON ROW-DISPLAY OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_atualiza_browse_color /*pi_atualiza_browse_color*/.

END. /* ON ROW-DISPLAY OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado */

ON ROW-ENTRY OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_row_entry_tit_ap_bcio /*pi_row_entry_tit_ap_bcio*/.
END. /* ON ROW-ENTRY OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado */

ON START-SEARCH OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_browse_order (Input browse br_tit_ap_em_bco:handle,
                         Input 'tt_tit_ap_em_bco':U,
                         Input 3,
                         Input '') /*pi_browse_order*/.

END. /* ON START-SEARCH OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado */

ON VALUE-CHANGED OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado
DO:

    apply "row-entry" /*l_row_entry*/  to browse br_tit_ap_em_bco.
END. /* ON VALUE-CHANGED OF br_tit_ap_em_bco IN FRAME f_dlg_03_varredura_sacado */

ON ROW-DISPLAY OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_atualiza_browse_color /*pi_atualiza_browse_color*/.
END. /* ON ROW-DISPLAY OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado */

ON ROW-ENTRY OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_row_entry_tit_ap_bcio /*pi_row_entry_tit_ap_bcio*/.

END. /* ON ROW-ENTRY OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado */

ON START-SEARCH OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_browse_order (Input browse br_tit_ap_em_bco_bank:handle,
                         Input 'tt_tit_ap_em_bco':U,
                         Input 1,
                         Input '') /*pi_browse_order*/.

END. /* ON START-SEARCH OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado */

ON VALUE-CHANGED OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    apply "row-entry" /*l_row_entry*/  to browse br_tit_ap_em_bco_bank.
END. /* ON VALUE-CHANGED OF br_tit_ap_em_bco_bank IN FRAME f_dlg_03_varredura_sacado */

ON MOUSE-SELECT-DBLCLICK OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_dblclick_br_tt_tit_ap_conciliacao (Input browse br_tt_tit_ap_conciliacao:handle) /*pi_dblclick_br_tt_tit_ap_conciliacao*/.
END. /* ON MOUSE-SELECT-DBLCLICK OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado */

ON ROW-DISPLAY OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_atualiza_browse_color_1 /*pi_atualiza_browse_color_1*/.

END. /* ON ROW-DISPLAY OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado */

ON START-SEARCH OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_browse_order (Input browse br_tt_tit_ap_conciliacao:handle,
                         Input 'tt_tit_ap_conciliacao':U,
                         Input 2,
                         Input '') /*pi_browse_order*/.
END. /* ON START-SEARCH OF br_tt_tit_ap_conciliacao IN FRAME f_dlg_03_varredura_sacado */

ON MOUSE-SELECT-DBLCLICK OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_dblclick_br_tt_tit_ap_conciliacao (Input browse br_tt_tit_ap_conciliacao_bank:handle) /*pi_dblclick_br_tt_tit_ap_conciliacao*/.
END. /* ON MOUSE-SELECT-DBLCLICK OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado */

ON ROW-DISPLAY OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_atualiza_browse_color_1 /*pi_atualiza_browse_color_1*/.
END. /* ON ROW-DISPLAY OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado */

ON VALUE-CHANGED OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    IF  AVAIL tt_tit_ap_conciliacao THEN
        ASSIGN v_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap.

END. /* ON VALUE-CHANGED OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado */

ON ENTRY OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    IF  AVAIL tt_tit_ap_conciliacao THEN
        ASSIGN v_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap.

END. /* ON VALUE-CHANGED OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado */

ON START-SEARCH OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_browse_order (Input browse br_tt_tit_ap_conciliacao_bank:handle,
                         Input 'tt_tit_ap_conciliacao':U,
                         Input 5,
                         Input '') /*pi_browse_order*/.

END. /* ON START-SEARCH OF br_tt_tit_ap_conciliacao_bank IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_cancelamento IN FRAME f_dlg_03_varredura_sacado
DO:

    if avail tt_tit_ap_em_bco then do:
      run pi_cancel_tit_ap_bcio_indiv (Input tt_tit_ap_em_bco.tta_cod_estab,
                                       Input tt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                       Input tt_tit_ap_em_bco.ttv_cod_tit_ap_bco,
                                       Input tt_tit_ap_em_bco.ttv_num_seq_tit_bco) /*pi_cancel_tit_ap_bcio_indiv*/.
    end.                                    


END. /* ON CHOOSE OF bt_cancelamento IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_check IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_choose_bt_check /*pi_choose_bt_check*/.
    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.
END. /* ON CHOOSE OF bt_check IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_check7 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_choose_bt_check7 /*pi_choose_bt_check7*/.
    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.
END. /* ON CHOOSE OF bt_check7 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_concil_autom_titulos IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_concil_autom_titulos /*pi_bt_concil_autom_titulos*/.
    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.
END. /* ON CHOOSE OF bt_concil_autom_titulos IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_concil_manual_titulos IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_concil_manual_titulos /*pi_bt_concil_manual_titulos*/.
    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.
END. /* ON CHOOSE OF bt_concil_manual_titulos IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_desconcil_1 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_botao_desconciliacao_manual_titulos /*pi_botao_desconciliacao_manual_titulos*/.
    if  return-value = "NOK" /*l_nok*/ 
    then do:
        return no-apply.
    end /* if */.

    /* Ap¢s executar a Conciliaá∆o, faz uma atualizaá∆o em ambos os browses */
    run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
    run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.
END. /* ON CHOOSE OF bt_desconcil_1 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_det1 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_det_varredura_sacado /*pi_bt_det_varredura_sacado*/.
END. /* ON CHOOSE OF bt_det1 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_det_10 IN FRAME f_dlg_03_varredura_sacado
DO:

    if avail tt_tit_ap_conciliacao then do:   
        assign v_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap.
        if  search("prgfin/apb/apb002ia.r") = ? and search("prgfin/apb/apb002ia.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb002ia.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb002ia.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/apb/apb002ia.p /*prg_det_tit_ap*/.
    end.        

END. /* ON CHOOSE OF bt_det_10 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_elimina_image IN FRAME f_dlg_03_varredura_sacado
DO:

    if not avail tt_tit_ap_em_bco then
        return.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'BEFORE_DELETE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */

    run pi_eliminar_tit_ap_bcio_indiv (Input tt_tit_ap_em_bco.tta_cod_estab,
                                       Input tt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                       Input tt_tit_ap_em_bco.ttv_cod_tit_ap_bco,
                                       Input tt_tit_ap_em_bco.ttv_num_seq_tit_bco) /*pi_eliminar_tit_ap_bcio_indiv*/.

    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'AFTER_DELETE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */




END. /* ON CHOOSE OF bt_elimina_image IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_era1 IN FRAME f_dlg_03_varredura_sacado
DO:


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'BEFORE_DELETE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */

    run pi_tit_ap_bcio_eliminacao /*pi_tit_ap_bcio_eliminacao*/.

    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'AFTER_DELETE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */

END. /* ON CHOOSE OF bt_era1 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_fil2 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_fil2 /*pi_bt_fil2*/.


END. /* ON CHOOSE OF bt_fil2 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_fil3 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_fil3 /*pi_bt_fil3*/.



END. /* ON CHOOSE OF bt_fil3 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_varredura_sacado
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_legenda IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_conciliacao_legenda /*pi_conciliacao_legenda*/.
END. /* ON CHOOSE OF bt_legenda IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_localiza IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_localiz_fornec.
    if  return-value <> "OK" /*l_ok*/  
    then do:
        return no-apply.
    end.
END. /* ON CHOOSE OF bt_localiza IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_mod1 IN FRAME f_dlg_03_varredura_sacado
DO:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.04" &then
    def buffer b_tit_ap_bcio
        for tit_ap_bcio.
    &endif


    /*************************** Buffer Definition End **************************/

    run pi_bt_mod1 /*pi_bt_mod1*/.

END. /* ON CHOOSE OF bt_mod1 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_mod4 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_mod_tit_ap.
    if  return-value <> "OK" /*l_ok*/  
    then do:
        return no-apply.
    end.
END. /* ON CHOOSE OF bt_mod4 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_mov1 IN FRAME f_dlg_03_varredura_sacado
DO:

    if  avail tt_tit_ap_em_bco
    then do:
        view frame f_dlg_03_tit_ap_bcio_historico.
        enable all with frame f_dlg_03_tit_ap_bcio_historico.
        run pi_open_tt_movto_tit_ap_bcio_histor /*pi_open_tt_movto_tit_ap_bcio_histor*/.
        wait-for go of frame f_dlg_03_tit_ap_bcio_historico or
                 endkey of frame f_dlg_03_tit_ap_bcio_historico.
        hide frame f_dlg_03_tit_ap_bcio_historico.
    end /* if */.    
END. /* ON CHOOSE OF bt_mov1 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_ok IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_grava_params_fnc_tit_ap_bcio_conc /*pi_grava_params_fnc_tit_ap_bcio_conc*/.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_param1_im IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_param1_im_dlg_03_varredura_sacado /*pi_bt_param1_im_dlg_03_varredura_sacado*/.
END. /* ON CHOOSE OF bt_param1_im IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_ran2 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_ran2 /*pi_bt_ran2*/.
END. /* ON CHOOSE OF bt_ran2 IN FRAME f_dlg_03_varredura_sacado */

ON CHOOSE OF bt_ran6 IN FRAME f_dlg_03_varredura_sacado
DO:

    run pi_bt_ran6 /*pi_bt_ran6*/.

END. /* ON CHOOSE OF bt_ran6 IN FRAME f_dlg_03_varredura_sacado */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_427364 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank
OR F5 OF v_cod_forma_pagto IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank DO:

    /* fn_generic_zoom_variable */
    if  search("prgfin/apb/apb005ka.r") = ? and search("prgfin/apb/apb005ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb005ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb005ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/apb/apb005ka.p /*prg_sea_forma_pagto*/.
    if  v_rec_forma_pagto <> ?
    then do:
        find forma_pagto where recid(forma_pagto) = v_rec_forma_pagto no-lock no-error.
        assign v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank =
               string(forma_pagto.cod_forma_pagto).

        apply "entry" to v_cod_forma_pagto in frame f_dlg_01_tit_ap_bcio_parametros_bank.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_427364 IN FRAME f_dlg_01_tit_ap_bcio_parametros_bank */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_concil_autom
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_concil_autom */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_concil_autom
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_concil_autom */

ON HELP OF FRAME f_dlg_01_concil_autom ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_concil_autom */

ON WINDOW-CLOSE OF FRAME f_dlg_01_concil_autom
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_concil_autom */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_concil_autom_confirmacao */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_concil_autom_confirmacao
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_concil_autom_confirmacao */

ON HELP OF FRAME f_dlg_01_concil_autom_confirmacao ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_concil_autom_confirmacao */

ON WINDOW-CLOSE OF FRAME f_dlg_01_concil_autom_confirmacao
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_concil_autom_confirmacao */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_movto_tit_ap_bcio_histor
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_movto_tit_ap_bcio_histor */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_movto_tit_ap_bcio_histor
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_movto_tit_ap_bcio_histor */

ON HELP OF FRAME f_dlg_01_movto_tit_ap_bcio_histor ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_movto_tit_ap_bcio_histor */

ON WINDOW-CLOSE OF FRAME f_dlg_01_movto_tit_ap_bcio_histor
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_movto_tit_ap_bcio_histor */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_faixa */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_faixa */

ON HELP OF FRAME f_dlg_01_tit_ap_bcio_faixa ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_bcio_faixa */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_faixa
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_faixa */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_filtro
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_filtro */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_filtro
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_filtro */

ON HELP OF FRAME f_dlg_01_tit_ap_bcio_filtro ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_bcio_filtro */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_filtro
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_filtro */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_legenda
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_legenda */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_legenda
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_legenda */

ON HELP OF FRAME f_dlg_01_tit_ap_bcio_legenda ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_bcio_legenda */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_legenda
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_legenda */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_parametros
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_parametros */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_parametros
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_parametros */

ON HELP OF FRAME f_dlg_01_tit_ap_bcio_parametros ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_bcio_parametros */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_parametros
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_parametros */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON HELP OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_bcio_parametros_bank */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_faixa
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_faixa */

ON HELP OF FRAME f_dlg_01_tit_ap_faixa ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_faixa */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_faixa ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_faixa */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_faixa
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_faixa */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_filtro
DO:

    run pi_right_mouse_down_dialog_box.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_tit_ap_filtro */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_filtro
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_tit_ap_filtro */

ON HELP OF FRAME f_dlg_01_tit_ap_filtro ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_tit_ap_filtro */

ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_filtro
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_tit_ap_filtro */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_tit_ap_bcio_historico
DO:

    run pi_right_mouse_down_dialog_box.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_tit_ap_bcio_historico */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_tit_ap_bcio_historico
DO:

    run pi_right_mouse_up_dialog_box.
END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_tit_ap_bcio_historico */

ON HELP OF FRAME f_dlg_03_tit_ap_bcio_historico ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_03_tit_ap_bcio_historico */

ON WINDOW-CLOSE OF FRAME f_dlg_03_tit_ap_bcio_historico
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_dlg_03_tit_ap_bcio_historico */

ON ENTRY OF FRAME f_dlg_03_varredura_sacado
DO:

    apply 'entry' to v_cdn_sist_nac_bcio in frame f_dlg_03_varredura_sacado.
END. /* ON ENTRY OF FRAME f_dlg_03_varredura_sacado */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_varredura_sacado
DO:

    run pi_right_mouse_down_dialog_box /*pi_right_mouse_down_dialog_box*/.
END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_varredura_sacado */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_varredura_sacado
DO:

    run pi_right_mouse_up_dialog_box.

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_varredura_sacado */

ON HELP OF FRAME f_dlg_03_varredura_sacado ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_03_varredura_sacado */

ON WINDOW-CLOSE OF FRAME f_dlg_03_varredura_sacado
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_dlg_03_varredura_sacado */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_03_varredura_sacado.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(frame f_dlg_03_varredura_sacado:title, 1, max(1, length(frame f_dlg_03_varredura_sacado:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_tit_ap_bcio_conciliacao":U.




    assign v_nom_prog_ext = "prgfin/apb/apb775za.p":U
           v_cod_release  = trim(" 5.04.00.055":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_tit_ap_bcio_conciliacao}


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('fnc_tit_ap_bcio_conciliacao':U, 'prgfin/apb/apb775za.p':U, '5.04.00.055':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emscad.histor_exec_especial NO-LOCK
         WHERE emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND emscad.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            SPP      at 1 
            v_log_retorno  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */
    .

    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */


/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.


/* End_Include: i_declara_SetEntryField */


&SCOPED-DEFINE validar_tit_ap "yes" /*l_yes*/ 

run pi_main_fnc_tit_ap_bcio_conciliacao /*pi_main_fnc_tit_ap_bcio_conciliacao*/.

if  this-procedure:persistent = yes then
    delete procedure this-procedure.

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_verifica_refer_unica_apb
** Descricao.............: pi_verifica_refer_unica_apb
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut40711
** Alterado em...........: 05/07/2010 13:54:09
*****************************************************************************/
PROCEDURE pi_verifica_refer_unica_apb:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_movto_tit_ap
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_antecip_pef_pend
        for antecip_pef_pend.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_impl_tit_ap
        for lote_impl_tit_ap.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_pagto
        for lote_pagto.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_ap
        for movto_tit_ap.
    &endif


    /*************************** Buffer Definition End **************************/

    assign p_log_refer_uni = yes.



    if  p_cod_table <> "antecip_pef_pend" /*l_antecip_pef_pend*/ 
    then do:
        find first b_antecip_pef_pend no-lock
             where b_antecip_pef_pend.cod_estab = p_cod_estab
               and b_antecip_pef_pend.cod_refer = p_cod_refer /*cl_verifica_refer_uni of b_antecip_pef_pend*/ no-error.
    end /* if */.
    if  avail b_antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
    end /* if */.
    else do:
        if  p_cod_table <> "lote_impl_tit_ap" /*l_lote_impl_tit_ap*/ 
        then do:
            find first b_lote_impl_tit_ap no-lock
                 where b_lote_impl_tit_ap.cod_estab = p_cod_estab
                   and b_lote_impl_tit_ap.cod_refer = p_cod_refer /*cl_verifica_refer_uni of b_lote_impl_tit_ap*/ no-error.
        end /* if */.
        if  avail b_lote_impl_tit_ap
        then do:
            assign p_log_refer_uni = no.
        end /* if */.
        else do:
            if  p_cod_table <> "lote_pagto" /*l_lote_pagto*/ 
            then do:
                find first b_lote_pagto no-lock
                     where b_lote_pagto.cod_estab_refer = p_cod_estab
                       and b_lote_pagto.cod_refer = p_cod_refer /*cl_verifica_refer_uni of b_lote_pagto*/ no-error.
            end /* if */.
            if  avail b_lote_pagto
            then do:
                assign p_log_refer_uni = no.
            end /* if */.
            else do:
                find first b_movto_tit_ap no-lock
                     where b_movto_tit_ap.cod_estab = p_cod_estab
                       and b_movto_tit_ap.cod_refer = p_cod_refer
                       and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap /*cl_verifica_refer_uni_apb of b_movto_tit_ap*/ no-error.
                if  avail b_movto_tit_ap
                then do:
                    assign p_log_refer_uni = no.
                end /* if */.
            end /* else */.
        end /* else */.
    end /* else */.

    &if defined(BF_FIN_BCOS_HISTORICOS) &then
        if  v_log_utiliza_mbh
        and can-find(first his_movto_tit_ap_histor no-lock
                     where his_movto_tit_ap_histor.cod_estab = p_cod_estab
                       and his_movto_tit_ap_histor.cod_refer = p_cod_refer) then
            assign p_log_refer_uni = no.
    &endif
END PROCEDURE. /* pi_verifica_refer_unica_apb */
/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_open_tt_tit_ap_em_bco
** Descricao.............: pi_open_tt_tit_ap_em_bco
** Criado por............: bre17230
** Criado em.............: 11/04/2000 11:06:03
** Alterado por..........: fut40695
** Alterado em...........: 31/01/2010 17:32:10
*****************************************************************************/
PROCEDURE pi_open_tt_tit_ap_em_bco:

    if v_log_layout_sacad = yes then do:

        if  v_cod_banco_ini > v_cod_banco_fim
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input 'show',
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               'Codigo Sistema Banc†rio Inicial','C¢digo Sistema Banc†rio Final')) /* msg_9710*/.
            assign v_wgh_focus = v_wgh_fill_in_ini.
            return "NOK" /*l_nok*/ .
        end.
    end.

    for each tt_tit_ap_em_bco:
        delete tt_tit_ap_em_bco.
    end.

    /* Exclui a tabela que armazena as conciliaá‰es dos t°tulos do contas a pagar*/
    for each tt_tit_ap_conciliacao_sel:
        delete tt_tit_ap_conciliacao_sel.
    end.

    assign v_num_sel_reg = 0.

    if v_log_layout_sacad = yes then do:
        for each estabelecimento no-lock
            where estabelecimento.cod_estab >= v_cod_estab_ini
            and   estabelecimento.cod_estab <= v_cod_estab_fim:
            run pi_open_tt_tit_ap_em_bco_2.
        end.
    end.
    else do:
        for each estabelecimento no-lock
            where estabelecimento.cod_estab >= v_cod_estab_ini
            and   estabelecimento.cod_estab <= v_cod_estab_fim:
            run pi_open_tt_tit_ap_em_bco_2.
        end.
    end.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap_bcio).    
        run value(v_nom_prog_upc) (input 'CREATE',
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    if  v_nom_prog_appc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap_bcio).    
        run value(v_nom_prog_appc) (input 'CREATE',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap_bcio).    
        run value(v_nom_prog_dpc) (input 'CREATE',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.
    &endif
    &endif
    /* End_Include: i_exec_program_epc */


    if v_log_layout_sacad then
        open query qr_tit_ap_em_bco_bank for 
            each tt_tit_ap_em_bco no-lock
            by tt_tit_ap_em_bco.ttv_num_sel_reg.
    else
        open query qr_tit_ap_em_bco for 
            each tt_tit_ap_em_bco no-lock
            by tt_tit_ap_em_bco.ttv_num_sel_reg.

END PROCEDURE. /* pi_open_tt_tit_ap_em_bco */
/*****************************************************************************
** Procedure Interna.....: pi_vld_faixa_informada
** Descricao.............: pi_vld_faixa_informada
** Criado por............: bre17230
** Criado em.............: 11/04/2000 17:55:08
** Alterado por..........: fut35118
** Alterado em...........: 19/07/2007 08:46:08
*****************************************************************************/
PROCEDURE pi_vld_faixa_informada:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_tip_faixa
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  p_cod_tip_faixa = "Tit_ap_bco" /*l_tit_ap_bco*/ 
    then do:
        if  v_cod_estab_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa > v_cod_estab_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "C¢digo Estabelecimento Inicial","C¢digo Estabelecimento Final")) /*msg_9710*/.
            assign v_wgh_focus = v_cod_estab_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.        
            return "NOK" /*l_nok*/ .
        end /* if */.

        if  v_cod_id_feder:screen-value in frame f_dlg_01_tit_ap_bcio_faixa > v_cod_id_feder_apb_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "C¢digo ou Nome Abreviado ou ID federal do Fornecedor","CGC/CPF Fornecedor Final")) /*msg_9710*/.
            assign v_wgh_focus = v_cod_id_feder:handle in frame f_dlg_01_tit_ap_bcio_faixa.
            return "NOK" /*l_nok*/ .    
        end /* if */.

        if  date(v_dat_vencto_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa) > date(v_dat_vencto_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data Vencimento Inicial","Data Vencimento Final")) /*msg_9710*/.
            assign v_wgh_focus = v_dat_vencto_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.
            return "NOK" /*l_nok*/ .            
        end /* if */.

        if  v_nom_fornecedor_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa > v_nom_fornecedor_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Nome Fornecedor Inicial","Nome Fornecedor Final")) /*msg_9710*/.
            assign v_wgh_focus = v_nom_fornecedor_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.        
            return "NOK" /*l_nok*/ .            
        end /* if */.

        if  int(v_cdn_fornecedor_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa) > int(v_cdn_fornecedor_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "C¢digo" /*l_codigo*/  + ' ' + "Fornecedor Inicial" /*l_fornecedor_inicial*/ , "C¢digo Fornecedor Final" /*l_cod_fornec_final*/)) /*msg_9710*/.
            assign v_wgh_focus = v_cdn_fornecedor_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.        
            return "NOK" /*l_nok*/ .            
        end /* if */.

        if  date(v_dat_entr_sist_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa) > date(v_dat_entr_sist_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data Entrada Sistema Inicial","Data Entrada Sistema Final")) /*msg_9710*/.
            assign v_wgh_focus = v_dat_entr_sist_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.
            return "NOK" /*l_nok*/ .        
        end /* if */.

        if  decimal(v_val_tit_ap_bcio_ini:screen-value in frame f_dlg_01_tit_ap_bcio_faixa) > decimal(v_val_tit_ap_bcio_fim:screen-value in frame f_dlg_01_tit_ap_bcio_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Valor T°tulo Banc†rio Inicial","Valor T°tulo Banc†rio Final")) /*msg_9710*/.
            assign v_wgh_focus = v_val_tit_ap_bcio_ini:handle in frame f_dlg_01_tit_ap_bcio_faixa.        
            return "NOK" /*l_nok*/ .
        end /* if */.  
    end /* if */.
    else do:
    &if {&validar_tit_ap} = "yes" /*l_yes*/  &then
        if  v_cod_estab_apb_inic:screen-value in frame f_dlg_01_tit_ap_faixa > v_cod_estab_apb_fim:screen-value in frame f_dlg_01_tit_ap_faixa
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Estabelecimento Inicial","Estabelecimento Final")) /*msg_9710*/.
            assign v_wgh_focus = v_cod_estab_apb_inic:handle in frame f_dlg_01_tit_ap_faixa.        
            return "NOK" /*l_nok*/ .
        end /* if */.

        if  date(v_dat_vencto_apb_inic:screen-value in frame f_dlg_01_tit_ap_faixa) > date(v_dat_vencto_apb_fim:screen-value in frame f_dlg_01_tit_ap_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data Vencto Inicial","Data Vencto Final")) /*msg_9710*/.
            assign v_wgh_focus = v_dat_vencto_apb_inic:handle in frame f_dlg_01_tit_ap_faixa.        
            return "NOK" /*l_nok*/ .        
        end /* if */.

        if  date(v_dat_emis_apb_inic:screen-value in frame f_dlg_01_tit_ap_faixa) > date(v_dat_emis_apb_fim:screen-value in frame f_dlg_01_tit_ap_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data Emiss∆o T°tulo Inicial","Data Emiss∆o T°tulo Final")) /*msg_9710*/.
            assign v_wgh_focus = v_dat_emis_apb_inic:handle in frame f_dlg_01_tit_ap_faixa.        
            return "NOK" /*l_nok*/ .            
        end /* if */.

        if  decimal(v_val_origin_apb_inic:screen-value in frame f_dlg_01_tit_ap_faixa) > decimal(v_val_origin_apb_fim:screen-value in frame f_dlg_01_tit_ap_faixa)
        then do:
            /* &2 inv†lido para faixa informada ! */
            run pi_messages (input "show",
                             input 9710,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Valor Original Inicial","Valor Original Final")) /*msg_9710*/.
            assign v_wgh_focus = v_val_origin_apb_inic:handle in frame f_dlg_01_tit_ap_faixa.
            return "NOK" /*l_nok*/ .
        end /* if */.
    &endif
    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_vld_faixa_informada */
/*****************************************************************************
** Procedure Interna.....: pi_open_tt_movto_tit_ap_bcio_histor
** Descricao.............: pi_open_tt_movto_tit_ap_bcio_histor
** Criado por............: bre17230
** Criado em.............: 13/04/2000 11:53:15
** Alterado por..........: fut43117
** Alterado em...........: 07/08/2010 14:43:56
*****************************************************************************/
PROCEDURE pi_open_tt_movto_tit_ap_bcio_histor:

    if avail tt_tit_ap_em_bco then do:

        for each tt_movto_tit_ap_bcio_histor:
            delete tt_movto_tit_ap_bcio_histor.
        end.

        for each b_movto_tit_ap_bcio_histor no-lock
            where b_movto_tit_ap_bcio_histor.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
            and   b_movto_tit_ap_bcio_histor.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
            and   b_movto_tit_ap_bcio_histor.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco
            and   b_movto_tit_ap_bcio_histor.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco:
            create  tt_movto_tit_ap_bcio_histor.
            assign  tt_movto_tit_ap_bcio_histor.tta_cod_estab            = b_movto_tit_ap_bcio_histor.cod_estab
                    tt_movto_tit_ap_bcio_histor.tta_cod_sist_nac_bcio    = b_movto_tit_ap_bcio_histor.cod_sist_nac_bcio
                    tt_movto_tit_ap_bcio_histor.tta_cod_tit_ap_bco       = b_movto_tit_ap_bcio_histor.cod_tit_ap_bco
                    tt_movto_tit_ap_bcio_histor.ttv_num_seq_tit_bco      = b_movto_tit_ap_bcio_histor.num_seq_tit_bco
                    tt_movto_tit_ap_bcio_histor.tta_num_seq_movto_bco    = b_movto_tit_ap_bcio_histor.num_seq_movto_bco
                    tt_movto_tit_ap_bcio_histor.tta_ind_tip_movto_bco    = b_movto_tit_ap_bcio_histor.ind_tip_movto_bco
                    tt_movto_tit_ap_bcio_histor.tta_dat_gerac_arq        = b_movto_tit_ap_bcio_histor.dat_gerac_arq
                    tt_movto_tit_ap_bcio_histor.tta_num_seq_arq          = b_movto_tit_ap_bcio_histor.num_seq_arq
                    tt_movto_tit_ap_bcio_histor.tta_dsl_histor_movto_bco = b_movto_tit_ap_bcio_histor.dsl_histor_movto_bco
                    .
        end.    

        display tt_tit_ap_em_bco.tta_cod_estab
                tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
                tt_tit_ap_em_bco.tta_cod_tit_ap_bco
                with frame f_dlg_03_tit_ap_bcio_historico.
        disable tt_tit_ap_em_bco.tta_cod_estab
                tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
                tt_tit_ap_em_bco.tta_cod_tit_ap_bco
                with frame f_dlg_03_tit_ap_bcio_historico.

        open query qr_tit_ap_bcio_historico for 
            each tt_movto_tit_ap_bcio_histor no-lock.

    end.
END PROCEDURE. /* pi_open_tt_movto_tit_ap_bcio_histor */
/*****************************************************************************
** Procedure Interna.....: pi_open_tt_tit_ap_conciliacao
** Descricao.............: pi_open_tt_tit_ap_conciliacao
** Criado por............: bre17230
** Criado em.............: 14/04/2000 10:49:55
** Alterado por..........: fut1228
** Alterado em...........: 24/05/2012 13:46:25
*****************************************************************************/
PROCEDURE pi_open_tt_tit_ap_conciliacao:

    /************************* Variable Definition Begin ************************/

    def var v_val_origin_tit_ap
        as decimal
        format "->>>,>>>,>>9.99":U
        decimals 2
        label "Valor Original"
        column-label "Valor Original"
        no-undo.


    /************************** Variable Definition End *************************/

    &if {&validar_tit_ap} = "yes" /*l_yes*/  &then

    for each tt_tit_ap_conciliacao:
        delete tt_tit_ap_conciliacao.
    end.

    for each tt_fornecedor_matriz:
        delete tt_fornecedor_matriz.
    end.

    for each tt_estab_select:
        delete tt_estab_select.
    end.

    for each tt_empresa_selec:
        delete tt_empresa_selec.
    end.

    if not avail tt_tit_ap_em_bco or
       tt_tit_ap_em_bco.tta_log_tit_cancel = yes then do:
        if v_log_layout_sacad then
            open query qr_tt_tit_ap_conciliacao_bank for
                each tt_tit_ap_conciliacao no-lock.
        else
            open query qr_tt_tit_ap_conciliacao for
                each tt_tit_ap_conciliacao no-lock.
        return.
    end.

    for each  estabelecimento no-lock
        where estabelecimento.cod_estab >= v_cod_estab_apb_inic
        and   estabelecimento.cod_estab <= v_cod_estab_apb_fim:

        if not can-find(first tt_empresa_selec
                        where tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa) then do:
            create tt_empresa_selec.
            assign tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa.
        end.

        create tt_estab_select.
        assign tt_estab_select.tta_cod_empresa = estabelecimento.cod_empresa
               tt_estab_select.tta_cod_estab   = estabelecimento.cod_estab.
    end.

    assign v_cdn_fornecedor = tt_tit_ap_em_bco.tta_cdn_fornecedor.

    if not v_log_matriz_fornec then do:
        for each tt_empresa_selec:
            for each  fornecedor no-lock
                where fornecedor.cod_empresa   = tt_empresa_selec.tta_cod_empresa
                and   fornecedor.cdn_fornecedor= v_cdn_fornecedor:

                if can-find(first tt_fornecedor_matriz
                            where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                            and   tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                create tt_fornecedor_matriz.
                assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                       tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                       tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                       tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
            end.
        end.
    end.
    else do:
        run pi_busca_matriz_fornecedor (input v_cdn_fornecedor,
                                        input "",
                                        input no).
    end.

    for each tt_empresa_selec no-lock:
        vld_fornec:
        for each  tt_fornecedor_matriz no-lock
            where tt_fornecedor_matriz.cod_empresa = tt_empresa_selec.tta_cod_empresa:

            for each  tt_estab_select no-lock
                where tt_estab_select.tta_cod_empresa = tt_empresa_selec.tta_cod_empresa:

                vld_titulo:
                for each  tit_ap no-lock
                    where tit_ap.cod_estab      = tt_estab_select.tta_cod_estab
                    and   tit_ap.cdn_fornecedor = tt_fornecedor_matriz.cdn_fornecedor:

                    if lookup(tit_ap.cod_espec_docto,v_cod_espec_multi_sel_tela) = 0 then 
                        next vld_titulo.

                    if lookup(tit_ap.cod_portador, v_cod_portad_multi_sel_tela) = 0 then 
                        next vld_titulo.

                    if tit_ap.cod_forma_pagto <> "" then    
                        if lookup(tit_ap.cod_forma_pagto, v_cod_forma_pagto_multi_sel_tela) = 0 then 
                            next vld_titulo.

                    if tit_ap.dat_vencto_tit_ap < v_dat_vencto_apb_inic or
                       tit_ap.dat_vencto_tit_ap > v_dat_vencto_apb_fim then
                       next vld_titulo.

                    if tit_ap.dat_emis_docto < v_dat_emis_apb_inic or
                       tit_ap.dat_emis_docto > v_dat_emis_apb_fim then
                       next vld_titulo.

                    if tit_ap.val_origin_tit_ap < v_val_origin_apb_inic or
                       tit_ap.val_origin_tit_ap > v_val_origin_apb_fim then
                       next vld_titulo.

                    if tit_ap.val_sdo_tit_ap <= 0 then
                        next vld_titulo.

                    if rs_tt_tit_ap_conciliacao <> "Todos" /*l_todos*/  then do:
                        if rs_tt_tit_ap_conciliacao = "T°tulos conciliados" /*l_titulos_conciliados*/  and tit_ap.log_concil = no then
                            next vld_titulo.

                        if rs_tt_tit_ap_conciliacao = "T°tulos n∆o conciliados" /*l_titulos_nao_conciliados*/  and tit_ap.log_concil = yes then
                            next vld_titulo.
                    end.

                    /* Quando o T°tulo Banc†rio estiver conciliado, somente ser† apresentado no browse os T°tulos apb
                       vinculados a ele. */            
                    if tt_tit_ap_em_bco.tta_log_concil = yes then do:
                        if tit_ap.num_id_tit_ap <> tt_tit_ap_em_bco.tta_num_id_tit_ap then
                            next vld_titulo.            
                    end.

                     /* passa a validar se e ignorar os t°tulos de antecipaá∆o, previs∆o e provis∆o.*/
                    run pi_vld_titulos_prev_prov_antecip (Input tit_ap.cod_espec_docto) /*pi_vld_titulos_prev_prov_antecip*/.
                    if  return-value = "NOK" /*l_nok*/ 
                    then do: 
                        next vld_titulo.
                    end /* if */.

                    run pi_retorna_valor_orig_tit_ap(buffer tit_ap,
                                                     output v_val_origin_tit_ap).

                    create tt_tit_ap_conciliacao.
                    assign tt_tit_ap_conciliacao.tta_cod_estab             = tit_ap.cod_estab
                           tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio     = tit_ap.cod_portador 
                           tt_tit_ap_conciliacao.tta_cdn_fornecedor        = tit_ap.cdn_fornecedor
                           tt_tit_ap_conciliacao.ttv_rec_tit_ap            = recid(tit_ap)
                           tt_tit_ap_conciliacao.tta_cod_ser_docto         = tit_ap.cod_ser_docto
                           tt_tit_ap_conciliacao.tta_cod_espec_docto       = tit_ap.cod_espec_docto
                           tt_tit_ap_conciliacao.tta_cod_tit_ap            = tit_ap.cod_tit_ap
                           tt_tit_ap_conciliacao.tta_cod_parcela           = tit_ap.cod_parcela
                           tt_tit_ap_conciliacao.tta_dat_emis_docto        = tit_ap.dat_emis_docto
                           tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap     = tit_ap.dat_vencto_tit_ap
                           tt_tit_ap_conciliacao.tta_val_origin_tit_ap     = tit_ap.val_origin_tit_ap
                           tt_tit_ap_conciliacao.tta_cod_id_feder          = tt_fornecedor_matriz.cod_id_feder
                           tt_tit_ap_conciliacao.tta_nom_abrev_fornec      = tt_fornecedor_matriz.nom_abrev
                           tt_tit_ap_conciliacao.tta_log_concil            = tit_ap.log_concil
                           tt_tit_ap_conciliacao.ttv_cod_barra_bcio        = tit_ap.cb4_tit_ap_bco_cobdor
                           tt_tit_ap_conciliacao.tta_val_desconto          = tit_ap.val_desconto
                           tt_tit_ap_conciliacao.tta_val_multa             = tit_ap.val_multa
                           tt_tit_ap_conciliacao.tta_val_abat_tit_ap       = tit_ap.val_abat_tit_ap
                           tt_tit_ap_conciliacao.tta_val_juros             = tit_ap.val_juros
                           tt_tit_ap_conciliacao.ttv_cod_tit_ap_bco        = tit_ap.cod_tit_ap_bco_cobdor
                           tt_tit_ap_conciliacao.tta_val_tit_ap_bcio       = v_val_origin_tit_ap.

                    find first tt_tit_ap_conciliacao_sel
                        where tt_tit_ap_conciliacao_sel.ttv_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap no-error.
                    /* Registros selecionados anteriormente */
                    if avail tt_tit_ap_conciliacao_sel then
                        assign tt_tit_ap_conciliacao.ttv_num_sel_reg = tt_tit_ap_conciliacao_sel.ttv_num_sel_reg.

                end.
            end.
        end.    
    end.        


        /* ponto de chamada EPC espec°fica MANGELS */
        /* Begin_Include: i_exec_program_epc_pi_fin */
        if  v_nom_prog_upc <> ''    
        or  v_nom_prog_appc <> ''
        or  v_nom_prog_dpc <> '' then do:
            if  not avail b_tit_ap_bcio then
                find first b_tit_ap_bcio
                    where b_tit_ap_bcio.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
                      and b_tit_ap_bcio.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
                      and b_tit_ap_bcio.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco   
                      and b_tit_ap_bcio.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco no-lock no-error.  
            if  avail b_tit_ap_bcio then
                assign v_rec_table_epc = recid(b_tit_ap_bcio)
                       v_nom_table_epc = 'tit_ap_bcio'. 
            else
                assign v_rec_table_epc = ?
                       v_nom_table_epc = "".
        end.



        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then do:

            run value(v_nom_prog_upc) (input 'Matriz_Fornec_CNPJ_8',
                                       input 'viewer',
                                       input this-procedure,
                                       input frame f_dlg_01_tit_ap_faixa:handle,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).

            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end /* if */.

        if  v_nom_prog_appc <> '' then do:
            run value(v_nom_prog_appc) (input 'Matriz_Fornec_CNPJ_8',
                                        input 'viewer',
                                        input this-procedure,
                                        input frame f_dlg_01_tit_ap_faixa:handle,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.

        end /* if */.

        &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_dpc <> '' then do:
            run value(v_nom_prog_dpc) (input 'Matriz_Fornec_CNPJ_8',
                                        input 'viewer',
                                        input this-procedure,
                                        input frame f_dlg_01_tit_ap_faixa:handle,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.

        end /* if */.
        &endif
        &endif


    if v_log_layout_sacad then
        open query qr_tt_tit_ap_conciliacao_bank for 
            each tt_tit_ap_conciliacao no-lock
            by tt_tit_ap_conciliacao.ttv_num_sel_reg desc.
    else
        open query qr_tt_tit_ap_conciliacao for 
            each tt_tit_ap_conciliacao no-lock
            by tt_tit_ap_conciliacao.ttv_num_sel_reg desc.        
    &endif
END PROCEDURE. /* pi_open_tt_tit_ap_conciliacao */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_manual_titulos
** Descricao.............: pi_conciliacao_manual_titulos
** Criado por............: bre17230
** Criado em.............: 14/04/2000 16:02:49
** Alterado por..........: fut43112
** Alterado em...........: 03/12/2010 12:00:55
*****************************************************************************/
PROCEDURE pi_conciliacao_manual_titulos:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab_bco
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_portador_bco
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_tit_ap_bco_bco
        as character
        format "x(20)"
        no-undo.
    def Input param p_num_seq_tit_bco_bco
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_estab_apb
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cdn_fornecedor_apb
        as Integer
        format ">>>,>>>,>>9"
        no-undo.
    def Input param p_cod_ser_docto_apb
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_espec_docto_apb
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_tit_ap_apb
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_parcela_apb
        as character
        format "x(02)"
        no-undo.
    def Input param p_ind_tip_concil
        as character
        format "X(01)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* Est† procedure interna ser† utilizada em dois pontos:
       - na conciliaá∆o manual;
       - ou, na conciliaá∆o autom†tica quando encontrar apenas um T°tulo APB 
         para um T°tulo Banc†rio e se o log de Confirma Conciliaá∆o 
         da tela de Conciliaá∆o estiver como "no". 
    */

        find tit_ap_bcio exclusive-lock
            where tit_ap_bcio.cod_estab         = p_cod_estab_bco      
            and   tit_ap_bcio.cod_sist_nac_bcio = p_cod_portador_bco   
            and   tit_ap_bcio.cod_tit_ap_bco    = p_cod_tit_ap_bco_bco 
            and   tit_ap_bcio.num_seq_tit_bco   = p_num_seq_tit_bco_bco
            no-error.

        find tit_ap exclusive-lock
            where tit_ap.cod_estab       = p_cod_estab_apb       
            and   tit_ap.cdn_fornecedor  = p_cdn_fornecedor_apb  
            and   tit_ap.cod_ser_docto   = p_cod_ser_docto_apb   
            and   tit_ap.cod_espec_docto = p_cod_espec_docto_apb 
            and   tit_ap.cod_tit_ap      = p_cod_tit_ap_apb      
            and   tit_ap.cod_parcela     = p_cod_parcela_apb     
            no-error.

    if  avail tit_ap_bcio and avail tit_ap
    then do:
        if  tit_ap_bcio.log_concil = yes
        then do:
            /* T°tulo Banc†rio j† est† conciliado ! */
            run pi_messages (input "show",
                             input 9730,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               tit_ap_bcio.cod_estab,tit_ap_bcio.cod_sist_nac_bcio,tit_ap_bcio.cod_tit_ap_bco)) /*msg_9730*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        if  tit_ap.val_sdo_tit_ap <= 0
        then do:
            /* T°tulo APB n∆o possui saldo para conciliar ! */
            run pi_messages (input "show",
                             input 9735,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               tit_ap.cod_estab,tit_ap.cdn_fornecedor,tit_ap.cod_ser_docto,tit_ap.cod_espec_docto,tit_ap.cod_tit_ap,tit_ap.cod_parcela)) /*msg_9735*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        IF  tit_ap_bcio.val_tit_ap_bcio <> tit_ap.val_sdo_tit_ap THEN DO:

            ASSIGN v_val_impto_pis_cofins = 0.

            for each compl_retenc_impto_pagto no-lock
                where compl_retenc_impto_pagto.cod_estab     = tit_ap.cod_estab
                and   compl_retenc_impto_pagto.num_id_tit_ap = tit_ap.num_id_tit_ap:
                
                ASSIGN v_val_impto_pis_cofins = v_val_impto_pis_cofins + compl_retenc_impto_pagto.val_imposto.
            end.

            IF  v_val_impto_pis_cofins > 0 THEN DO:
                IF  (tit_ap.val_sdo_tit_ap - v_val_impto_pis_cofins) <> tit_ap_bcio.val_tit_ap_bcio THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 27100,
                                       INPUT "Valores n∆o conferem. Deseja prosseguir ?" + "~~" + 
                                             "Saldo do t°tulo n∆o confere com valor importado via DDA. Deseja prosseguir ? ").
                     IF  RETURN-VALUE = "no" THEN
                         RETURN "NOK".
                END.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 27100,
                                   INPUT "Valores n∆o conferem. Deseja prosseguir ?" + "~~" + 
                                         "Saldo do t°tulo n∆o confere com valor importado via DDA. Deseja prosseguir ? ").
                 IF  RETURN-VALUE = "no" THEN
                     RETURN "NOK".
            END.
        END.

        IF  tit_ap_bcio.dat_vencto <> tit_ap.dat_vencto_tit_ap THEN DO:

            run pi_atualiza_cod_pais (Input v_cod_empres_usuar,
                                      Input tit_ap.cdn_fornec).

            IF  tit_ap_bcio.dat_vencto < tit_ap.dat_vencto_tit_ap THEN
                run pi_retornar_dia_util (Input tit_ap.cod_estab,
                                          Input "Respons†vel Financeiro",
                                          Input 0,
                                          Input tit_ap_bcio.dat_vencto,
                                          output v_dat_return,
                                          output v_cod_return).
            ELSE
                run pi_retornar_dia_util (Input tit_ap.cod_estab,
                                          Input "Respons†vel Financeiro",
                                          Input 0,
                                          Input tit_ap.dat_vencto_tit_ap,
                                          output v_dat_return,
                                          output v_cod_return).

            if  v_cod_return = "OK" then DO:

                IF  (tit_ap_bcio.dat_vencto < tit_ap.dat_vencto_tit_ap
                AND  v_dat_return <> tit_ap.dat_vencto_tit_ap)
                OR  (tit_ap_bcio.dat_vencto > tit_ap.dat_vencto_tit_ap
                AND  v_dat_return <> tit_ap_bcio.dat_venct) THEN DO:

                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 27100,
                                       INPUT "Vencimentos n∆o conferem. Deseja prosseguir ? " + "~~" + 
                                             "Vencimentos n∆o conferem. Deseja prosseguir ? ").
                     IF  RETURN-VALUE = "no" THEN
                         RETURN "NOK".
                END.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 27100,
                                   INPUT "Vencimentos n∆o conferem. Deseja prosseguir ? " + "~~" + 
                                         "Vencimentos n∆o conferem. Deseja prosseguir ? ").
                 IF  RETURN-VALUE = "no" THEN
                     RETURN "NOK".
            END.
        END.

        if  tit_ap.log_concil = yes
        then do:
            for each item_bord_ap no-lock
                where item_bord_ap.cod_estab       = tit_ap.cod_estab
                and   item_bord_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
                and   item_bord_ap.cod_ser_docto   = tit_ap.cod_ser_docto
                and   item_bord_ap.cod_espec_docto = tit_ap.cod_espec_docto
                and   item_bord_ap.cod_tit_ap      = tit_ap.cod_tit_ap
                and   item_bord_ap.cod_parcela     = tit_ap.cod_parcela:
                find bord_ap no-lock
                    where bord_ap.cod_estab_bord = item_bord_ap.cod_estab_bord
                    and   bord_ap.cod_portador   = item_bord_ap.cod_portador
                    and   bord_ap.num_bord_ap    = item_bord_ap.num_bord_ap
                    no-error.
                if avail bord_ap then do:
                    if  bord_ap.log_bord_ap_escrit = yes
                    then do:
                        /* T°tulo APB n∆o pode ser conciliado ! */
                        run pi_messages (input "show",
                                         input 9736,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                           tit_ap.cod_estab,                                      tit_ap.cdn_fornecedor,                                      tit_ap.cod_ser_docto,                                      tit_ap.cod_espec_docto,                                      tit_ap.cod_tit_ap,                                      tit_ap.cod_parcela,                                      bord_ap.cod_estab_bord,                                      bord_ap.cod_portador,                                      bord_ap.num_bord_ap)) /*msg_9736*/.                    
                        return "NOK" /*l_nok*/ .
                    end /* if */.    
                end.
            end.

            run pi_messages (input "show",
                             input 9731,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign v_log_answer = (if   return-value = "yes" then yes
                                   else if return-value = "no" then no
                                   else ?) /*msg_9731*/.
            if  v_log_answer <> yes
            then do:
                return "NOK" /*l_nok*/ .
            end /* if */.    
        end /* if */.    

        run pi_atualiza_conciliacao (Input p_ind_tip_concil) /*pi_atualiza_conciliacao*/.
        if  return-value = "NOK" /*l_nok*/  then
            return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_conciliacao_manual_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_autom_titulos
** Descricao.............: pi_conciliacao_autom_titulos
** Criado por............: bre17230
** Criado em.............: 18/04/2000 15:13:45
** Alterado por..........: fut40574
** Alterado em...........: 10/05/2011 18:29:51
*****************************************************************************/
PROCEDURE pi_conciliacao_autom_titulos:

    /************************* Variable Definition Begin ************************/

    def var v_rec_id_tit_ap_concil
        as recid
        format ">>>>>>9":U
        no-undo.
    def var v_val_origin_tit_ap
        as decimal
        format "->>>,>>>,>>9.99":U
        decimals 2
        label "Valor Original"
        column-label "Valor Original"
        no-undo.


    /************************** Variable Definition End *************************/

    if v_log_matriz_fornec = yes then do:
        run pi_conciliacao_autom_titulos_matriz.
        if return-value = "NOK" /*l_nok*/  then return "NOK" /*l_nok*/ .
    end.
    else do:
        assign v_num_count_concil = 1.

        for each tt_concil_autom:
            delete tt_concil_autom.
        end.

        /* regra: */
        case input frame f_dlg_01_concil_autom rs_regra_concil_autom:
            when "Fornecedor" /*l_fornecedor*/ then concil_1:
             do:
                Sel_Block:
                for each btt_tit_ap_em_bco
                    where btt_tit_ap_em_bco.tta_log_concil = no:
                    find b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_estab      = btt_tit_ap_em_bco.tta_cod_estab
                        and   b_tit_ap_concil.cdn_fornecedor = btt_tit_ap_em_bco.tta_cdn_fornecedor
                        and   b_tit_ap_concil.log_concil     = no
                        and   b_tit_ap_concil.val_sdo_tit_ap > 0
                        no-error.
                    if  not avail b_tit_ap_concil
                    then do:
                        for each b_tit_ap_concil no-lock
                            where b_tit_ap_concil.cod_empresa    = v_cod_empres_usuar
                            and   b_tit_ap_concil.cdn_fornecedor = btt_tit_ap_em_bco.tta_cdn_fornecedor
                            and   b_tit_ap_concil.log_concil     = no
                            and   b_tit_ap_concil.val_sdo_tit_ap > 0:

                            run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                            if  return-value = "NOK" /*l_nok*/  THEN
                                NEXT.                        

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).

                        end.
                    end /* if */.
                    else do:          
                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT Sel_Block.

                        if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
                        then do:

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end /* if */.
                        else do:
                            /* Concilia os T°tulos usando as mesmas regras da Conciliaá∆o Manual */
                            run pi_conciliacao_manual_titulos (Input btt_tit_ap_em_bco.tta_cod_estab,
                                                               Input btt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                                               Input btt_tit_ap_em_bco.tta_cod_tit_ap_bco,
                                                               Input btt_tit_ap_em_bco.ttv_num_seq_tit_bco,
                                                               Input b_tit_ap_concil.cod_estab,
                                                               Input b_tit_ap_concil.cdn_fornecedor,
                                                               Input b_tit_ap_concil.cod_ser_docto,
                                                               Input b_tit_ap_concil.cod_espec_docto,
                                                               Input b_tit_ap_concil.cod_tit_ap,
                                                               Input b_tit_ap_concil.cod_parcela,
                                                               Input "Autom†tica" /*l_automatica*/) /*pi_conciliacao_manual_titulos*/.
                            if  return-value <> "OK" /*l_ok*/ 
                            then do:
                                return "NOK" /*l_nok*/ .
                            end /* if */.                          
                        end /* if */.
                    end /* else */.
                end.
            end /* do concil_1 */.

            when "Fornecedor/Valor" /*l_fornecedor_valor*/ then concil_2:
             do:
                Sel_Block:
                for each btt_tit_ap_em_bco
                    where btt_tit_ap_em_bco.tta_log_concil = no:

                    assign v_rec_id_tit_ap_concil = ?.
                    concil_block:
                    for each b_tit_ap_concil no-lock
                       where b_tit_ap_concil.cod_estab      = btt_tit_ap_em_bco.tta_cod_estab
                         and b_tit_ap_concil.cdn_fornecedor = btt_tit_ap_em_bco.tta_cdn_fornecedor
                         and b_tit_ap_concil.log_concil     = no
                         and b_tit_ap_concil.val_sdo_tit_ap > 0:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto).
                        if return-value = "NOK" /*l_nok*/  then
                            next concil_block.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                        or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                            next concil_block.

                        /* se achar mais de um titulo normal para conciliar deve entrar no if not avail b_tit_ap_concil */
                        if v_rec_id_tit_ap_concil <> ? then do:
                            assign v_rec_id_tit_ap_concil = ?.
                            leave concil_block.
                        end.

                        assign v_rec_id_tit_ap_concil = recid(b_tit_ap_concil).
                    end.

                    find first b_tit_ap_concil no-lock
                         where recid(b_tit_ap_concil) = v_rec_id_tit_ap_concil no-error.
                    if  not avail b_tit_ap_concil
                    then do:
                        for each b_tit_ap_concil no-lock
                            where b_tit_ap_concil.cod_empresa        = v_cod_empres_usuar
                            and   b_tit_ap_concil.cdn_fornecedor     = btt_tit_ap_em_bco.tta_cdn_fornecedor
                            and   b_tit_ap_concil.log_concil         = no
                            and   b_tit_ap_concil.val_sdo_tit_ap     > 0:

                            run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                            if  return-value = "NOK" /*l_nok*/  THEN
                                NEXT.

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                            or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                                next.

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end.
                    end /* if */.
                    else do:              
                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT Sel_Block.

                        if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
                        then do:

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end /* if */.
                        else do:
                            /* Concilia os T°tulos usando as mesmas regras da Conciliaá∆o Manual */
                            run pi_conciliacao_manual_titulos (Input btt_tit_ap_em_bco.tta_cod_estab,
                                                               Input btt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                                               Input btt_tit_ap_em_bco.tta_cod_tit_ap_bco,
                                                               Input btt_tit_ap_em_bco.ttv_num_seq_tit_bco,
                                                               Input b_tit_ap_concil.cod_estab,
                                                               Input b_tit_ap_concil.cdn_fornecedor,
                                                               Input b_tit_ap_concil.cod_ser_docto,
                                                               Input b_tit_ap_concil.cod_espec_docto,
                                                               Input b_tit_ap_concil.cod_tit_ap,
                                                               Input b_tit_ap_concil.cod_parcela,
                                                               Input "Autom†tica" /*l_automatica*/) /*pi_conciliacao_manual_titulos*/.
                            if  return-value <> "OK" /*l_ok*/ 
                            then do:
                                return "NOK" /*l_nok*/ .
                            end /* if */.                                                        
                        end /* if */.                
                    end /* else */.
                end.    
            end /* do concil_2 */.

            when "Fornecedor/Data Vencto" /*l_fornecedor_vencto*/ then concil_3:
             do:
                Sel_Block:
                for each btt_tit_ap_em_bco
                    where btt_tit_ap_em_bco.tta_log_concil = no:        
                    find b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_estab         = btt_tit_ap_em_bco.tta_cod_estab
                        and   b_tit_ap_concil.cdn_fornecedor    = btt_tit_ap_em_bco.tta_cdn_fornecedor
                        and   b_tit_ap_concil.log_concil        = no
                        and   b_tit_ap_concil.val_sdo_tit_ap    > 0                
                        and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                        and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox
                        no-error.
                    if  not avail b_tit_ap_concil
                    then do:
                        for each b_tit_ap_concil no-lock
                            where b_tit_ap_concil.cod_empresa        = v_cod_empres_usuar
                            and   b_tit_ap_concil.cdn_fornecedor     = btt_tit_ap_em_bco.tta_cdn_fornecedor
                            and   b_tit_ap_concil.log_concil         = no
                            and   b_tit_ap_concil.val_sdo_tit_ap     > 0                    
                            and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                            and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                            run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                            if  return-value = "NOK" /*l_nok*/  THEN
                                NEXT.

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end.
                    end /* if */.
                    else do:   

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT Sel_Block.

                        if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
                        then do:

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end /* if */.
                        else do:
                            /* Concilia os T°tulos usando as mesmas regras da Conciliaá∆o Manual */
                            run pi_conciliacao_manual_titulos (Input btt_tit_ap_em_bco.tta_cod_estab,
                                                               Input btt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                                               Input btt_tit_ap_em_bco.tta_cod_tit_ap_bco,
                                                               Input btt_tit_ap_em_bco.ttv_num_seq_tit_bco,
                                                               Input b_tit_ap_concil.cod_estab,
                                                               Input b_tit_ap_concil.cdn_fornecedor,
                                                               Input b_tit_ap_concil.cod_ser_docto,
                                                               Input b_tit_ap_concil.cod_espec_docto,
                                                               Input b_tit_ap_concil.cod_tit_ap,
                                                               Input b_tit_ap_concil.cod_parcela,
                                                               Input "Autom†tica" /*l_automatica*/) /*pi_conciliacao_manual_titulos*/.
                            if  return-value <> "OK" /*l_ok*/ 
                            then do:
                                return "NOK" /*l_nok*/ .
                            end /* if */.                                                        
                        end /* if */.                
                    end /* else */.
                end.    
            end /* do concil_3 */.

            when "Fornecedor/Valor/Data Vencto" /*l_fornecedor_valor_vencto*/ then concil_4:
             do:
                Sel_Block:
                for each btt_tit_ap_em_bco
                    where btt_tit_ap_em_bco.tta_log_concil = no:        

                    assign v_rec_id_tit_ap_concil = ?.
                    concil_block:
                    for each b_tit_ap_concil no-lock
                       where b_tit_ap_concil.cod_estab         = btt_tit_ap_em_bco.tta_cod_estab
                         and b_tit_ap_concil.cdn_fornecedor    = btt_tit_ap_em_bco.tta_cdn_fornecedor
                         and b_tit_ap_concil.log_concil        = no
                         and b_tit_ap_concil.val_sdo_tit_ap    > 0                
                         and b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                         and b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto).
                        if return-value = "NOK" /*l_nok*/  then
                            next concil_block.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                        or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                            next concil_block.

                        /* se achar mais de um titulo normal para conciliar deve entrar no if not avail b_tit_ap_concil */
                        if v_rec_id_tit_ap_concil <> ? then do:
                            assign v_rec_id_tit_ap_concil = ?.
                            leave concil_block.
                        end.

                        assign v_rec_id_tit_ap_concil = recid(b_tit_ap_concil).
                    end.

                    find first b_tit_ap_concil no-lock
                         where recid(b_tit_ap_concil) = v_rec_id_tit_ap_concil no-error.
                    if  not avail b_tit_ap_concil
                    then do:
                        for each b_tit_ap_concil no-lock
                            where b_tit_ap_concil.cod_empresa        = v_cod_empres_usuar
                            and   b_tit_ap_concil.cdn_fornecedor     = btt_tit_ap_em_bco.tta_cdn_fornecedor
                            and   b_tit_ap_concil.log_concil         = no                    
                            and   b_tit_ap_concil.val_sdo_tit_ap     > 0
                            and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                            and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                            run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                            if  return-value = "NOK" /*l_nok*/  THEN
                                NEXT.

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).

                            if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                            or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                                next.

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end.
                    end /* if */.
                    else do:                
                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT Sel_Block.

                        if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
                        then do:

                            run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                             output v_val_origin_tit_ap).                    

                            run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                        end /* if */.
                        else do:
                            /* Concilia os T°tulos usando as mesmas regras da Conciliaá∆o Manual */
                            run pi_conciliacao_manual_titulos (Input btt_tit_ap_em_bco.tta_cod_estab,
                                                               Input btt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                                               Input btt_tit_ap_em_bco.tta_cod_tit_ap_bco,
                                                               Input btt_tit_ap_em_bco.ttv_num_seq_tit_bco,
                                                               Input b_tit_ap_concil.cod_estab,
                                                               Input b_tit_ap_concil.cdn_fornecedor,
                                                               Input b_tit_ap_concil.cod_ser_docto,
                                                               Input b_tit_ap_concil.cod_espec_docto,
                                                               Input b_tit_ap_concil.cod_tit_ap,
                                                               Input b_tit_ap_concil.cod_parcela,
                                                               Input "Autom†tica" /*l_automatica*/) /*pi_conciliacao_manual_titulos*/.
                            if  return-value <> "OK" /*l_ok*/ 
                            then do:
                                return "NOK" /*l_nok*/ .
                            end /* if */.                                                        
                        end /* if */.                
                    end /* else */.
                end.    
            end /* do concil_4 */.            
        end /* case regra */.

        find first tt_concil_autom no-lock no-error.
        if  avail tt_concil_autom
        then do:
            run pi_conciliacao_autom_titulos_conf /*pi_conciliacao_autom_titulos_conf*/.
        end /* if */.
        else do:
            /* Se o usu†rio escolher n∆o confirmar as conciliaá∆o, n∆o h† necessidade de mostrar mensagem de alerta. */
            if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
            then do:
                /* N∆o existem T°tulos Banc†rios para a Classificaá∆o ! */
                run pi_messages (input "show",
                                 input 9776,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9776*/.
                return "NOK" /*l_nok*/ .
            end /* if */.
        end /* else */.

        return "OK" /*l_ok*/ .
    end /* if */.
END PROCEDURE. /* pi_conciliacao_autom_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_autom_titulos_conf
** Descricao.............: pi_conciliacao_autom_titulos_conf
** Criado por............: bre17230
** Criado em.............: 19/04/2000 11:41:26
** Alterado por..........: bre17230
** Alterado em...........: 04/05/2000 16:53:00
*****************************************************************************/
PROCEDURE pi_conciliacao_autom_titulos_conf:

    /* Esta procedure ser† utilizada:
        - quando for Conciliaá∆o Autom†tica, e for encontrado mais de um T°tulo APB para os
          T°tulos Banc†rios.
    */

    assign v_log_concil_autom_confir = no.

    repeat while v_log_concil_autom_confir = no:

        view frame f_dlg_01_concil_autom_confirmacao.

        /* ************* Trata os retangulos da tela de legenda ****************/
        assign rt_004:bgcolor in frame f_dlg_01_concil_autom_confirmacao = 0.
        assign rt_005:bgcolor in frame f_dlg_01_concil_autom_confirmacao = 9.

        assign rt_004:visible in frame f_dlg_01_concil_autom_confirmacao = yes.
        assign rt_005:visible in frame f_dlg_01_concil_autom_confirmacao = yes.

        /* **********************************************************************/


        enable all with frame f_dlg_01_concil_autom_confirmacao.

        display br_tt_concil_autom
                bt_can
                bt_concil_titulos_1
                bt_hel2
                bt_nenhum
                bt_ok
                bt_todos
                v_log_concil_prim
                with frame f_dlg_01_concil_autom_confirmacao.

        open query qr_tt_concil_autom for 
            each tt_concil_autom no-lock
                where tt_concil_autom.ttv_log_descta = no.

        wait-for go of frame f_dlg_01_concil_autom_confirmacao or
             endkey of frame f_dlg_01_concil_autom_confirmacao.

    end.

    hide frame f_dlg_01_concil_autom_confirmacao.
END PROCEDURE. /* pi_conciliacao_autom_titulos_conf */
/*****************************************************************************
** Procedure Interna.....: pi_cria_tt_concil_autom
** Descricao.............: pi_cria_tt_concil_autom
** Criado por............: bre17230
** Criado em.............: 19/04/2000 10:25:46
** Alterado por..........: fut40574
** Alterado em...........: 22/03/2011 17:19:15
*****************************************************************************/
PROCEDURE pi_cria_tt_concil_autom:

    /************************ Parameter Definition Begin ************************/

    def Input param p_val_origin_tit_ap
        as decimal
        format "->>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_concil_autom_browse
        for tt_concil_autom.


    /*************************** Buffer Definition End **************************/

    /* T°tulos com Saldo menores que zero, n∆o ser∆o conciliados.
    */    

    create tt_concil_autom.
    /* monta o browse com valores em branco, sempre que j† existir um estab, fornecedor e t°tulo, facilitando a 
       vizualizaá∆o do browse.
    */      
    find first btt_concil_autom_browse no-lock
        where btt_concil_autom_browse.tta_cod_estab         = btt_tit_ap_em_bco.tta_cod_estab
        and   btt_concil_autom_browse.tta_cdn_fornecedor    = btt_tit_ap_em_bco.tta_cdn_fornecedor
        and   btt_concil_autom_browse.tta_cod_tit_ap_bco    = btt_tit_ap_em_bco.tta_cod_tit_ap_bco
        no-error.
    if avail btt_concil_autom_browse then
        assign tt_concil_autom.ttv_cod_estab_browse           = ""
               tt_concil_autom.ttv_cod_fornec_browse          = ""
               tt_concil_autom.ttv_cod_tit_ap_bco_browse      = ""
               tt_concil_autom.ttv_log_concil_prim            = no.
    else
        assign tt_concil_autom.ttv_cod_estab_browse           = btt_tit_ap_em_bco.tta_cod_estab
               tt_concil_autom.ttv_cod_fornec_browse          = string(btt_tit_ap_em_bco.tta_cdn_fornecedor,"zzz,zzz,zz9" /*l_zzzzzzzz9*/ )
               tt_concil_autom.ttv_cod_tit_ap_bco_browse      = btt_tit_ap_em_bco.tta_cod_tit_ap_bco
               tt_concil_autom.ttv_log_concil_prim            = yes.

    FIND FIRST fornecedor
         where fornecedor.cod_empresa    = v_cod_empres_usuar
         and   fornecedor.cdn_fornecedor = btt_tit_ap_em_bco.tta_cdn_fornecedor NO-LOCK NO-ERROR.

    assign tt_concil_autom.tta_cod_estab                  = btt_tit_ap_em_bco.tta_cod_estab
           tt_concil_autom.tta_cod_estab_tit_ap           = b_tit_ap_concil.cod_estab
           tt_concil_autom.tta_cdn_fornecedor             = btt_tit_ap_em_bco.tta_cdn_fornecedor
           tt_concil_autom.tta_nom_pessoa                 = fornecedor.nom_pessoa WHEN AVAIL fornecedor
           tt_concil_autom.ttv_num_seq                    = v_num_count_concil
           tt_concil_autom.ttv_num_seq_tit_bco            = btt_tit_ap_em_bco.ttv_num_seq_tit_bco       
           tt_concil_autom.tta_cod_sist_nac_bcio          = btt_tit_ap_em_bco.tta_cod_sist_nac_bcio
           tt_concil_autom.tta_cod_tit_ap_bco             = btt_tit_ap_em_bco.tta_cod_tit_ap_bco
           tt_concil_autom.tta_dat_vencto                 = btt_tit_ap_em_bco.tta_dat_vencto
           tt_concil_autom.tta_val_tit_ap_bcio            = btt_tit_ap_em_bco.tta_val_tit_ap_bcio
           tt_concil_autom.tta_num_id_tit_ap              = b_tit_ap_concil.num_id_tit_ap
           tt_concil_autom.tta_cod_ser_docto              = b_tit_ap_concil.cod_ser_docto
           tt_concil_autom.tta_cod_espec_docto            = b_tit_ap_concil.cod_espec_docto
           tt_concil_autom.tta_cod_tit_ap                 = b_tit_ap_concil.cod_tit_ap
           tt_concil_autom.tta_cod_parcela                = b_tit_ap_concil.cod_parcela
           tt_concil_autom.tta_dat_vencto_tit_ap          = b_tit_ap_concil.dat_vencto_tit_ap
           tt_concil_autom.tta_val_tit_ap                 = p_val_origin_tit_ap
           tt_concil_autom.tta_log_concil                 = no
           tt_concil_autom.ttv_log_descta                 = no.

    if v_log_layout_sacad = yes then
        assign tt_concil_autom.ttv_cdn_matriz_fornec_inic = b_tit_ap_concil.cdn_fornecedor.

    assign v_num_count_concil = v_num_count_concil + 1.



END PROCEDURE. /* pi_cria_tt_concil_autom */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_multiplos_titulos
** Descricao.............: pi_conciliacao_multiplos_titulos
** Criado por............: bre17230
** Criado em.............: 24/04/2000 15:28:16
** Alterado por..........: fut43117
** Alterado em...........: 07/08/2010 15:13:35
*****************************************************************************/
PROCEDURE pi_conciliacao_multiplos_titulos:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_concil_autom_multiplos
        for tt_concil_autom.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_mais_tit_apb
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_count_tit
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_count_tit_apb
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_row
        as integer
        format ">>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  input frame f_dlg_01_concil_autom_confirmacao v_log_concil_prim = yes
    then do:

        multiplos:
        do v_num_row = 1 to browse br_tt_concil_autom:num-selected-rows
            on endkey undo multiplos, leave multiplos
            on error undo multiplos, leave multiplos
            transaction:

            if  v_num_row = 1 then do:
                /* efetiva a atualizaªío do titulos bancˇrios que foram confirmados manualmente.*/
                run pi_efetiva_atualizacao_manual /*pi_efetiva_atualizacao_manual*/.
                if  return-value = "NOK" /*l_nok*/  then 
                    return "NOK" /*l_nok*/ .
            end.

            browse br_tt_concil_autom:fetch-selected-row(v_num_row).

            /* Quando Ç criada a tabela tempor†ria, seta o primeiro registro com yes (verif. estab, fornec, cod. tit.). 
               Na conciliaá∆o multipla, se a opá∆o for para conciliar pelo primeiro registro, verifica se o valor do log Ç yes, 
               se for, atualiza conciliaá∆o. 
            */
            if  tt_concil_autom.ttv_log_concil_prim = yes
            then do:
                find tit_ap_bcio exclusive-lock
                    where tit_ap_bcio.cod_estab         = tt_concil_autom.tta_cod_estab 
                    and   tit_ap_bcio.cod_sist_nac_bcio = tt_concil_autom.tta_cod_sist_nac_bcio 
                    and   tit_ap_bcio.cod_tit_ap_bco    = tt_concil_autom.tta_cod_tit_ap_bco
                    and   tit_ap_bcio.num_seq_tit_bco   = tt_concil_autom.ttv_num_seq_tit_bco
                    no-error.

                if v_log_layout_sacad = yes then do:
                    find tit_ap exclusive-lock
                        where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab_tit_ap
                        and   tit_ap.cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                        and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                        and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                        and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                        and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                        no-error.
                end.
                else do:
                    find tit_ap exclusive-lock
                        where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab_tit_ap
                        and   tit_ap.cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor 
                        and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                        and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                        and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                        and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                        no-error.
                end.
                if  avail tit_ap_bcio and avail tit_ap
                then do:
                    if  tit_ap.log_concil = no
                    then do:
                        run pi_atualiza_conciliacao (Input "Autom†tica" /*l_automatica*/) /*pi_atualiza_conciliacao*/.
                        if  return-value = "NOK" /*l_nok*/  then 
                            return "NOK" /*l_nok*/ .
                        /* Tenta localizar na tabela tempor†ria outros T°tulo Banc†rios que possuam o mesmo T°tulo APB.
                        */

                        if v_log_layout_sacad = yes then do:
                            for each btt_concil_autom_multiplos
                                where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                                and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                                and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                                and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                                and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                                and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela:
                                assign btt_concil_autom_multiplos.tta_log_concil = yes
                                       btt_concil_autom_multiplos.ttv_log_descta = yes.
                            end.
                        end.
                        else do:
                            for each btt_concil_autom_multiplos
                                where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                                and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor 
                                and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                                and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                                and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                                and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela:
                                assign btt_concil_autom_multiplos.tta_log_concil = yes
                                       btt_concil_autom_multiplos.ttv_log_descta = yes.
                            end.
                        end.

                        /* Os t°tulos banc†rios que foram conciliados com àxito, n∆o ser∆o mais apresentados no browse,
                           em caso de algum erro para os demais t°tulos Banc†rios */
                        assign tt_concil_autom.ttv_log_descta = yes.                    
                    end /* if */.
                    else do:
                        /* Caso o registro corrente j† tenha sido conciliado em outra linha,
                           utiliza o pr¢ximo com registro para conciliar autom†ticamente. */
                        find next btt_concil_autom_multiplos
                            where btt_concil_autom_multiplos.tta_cod_estab      = tt_concil_autom.tta_cod_estab 
                            and   btt_concil_autom_multiplos.tta_cdn_fornecedor = tt_concil_autom.tta_cdn_fornecedor 
                            and   btt_concil_autom_multiplos.tta_cod_tit_ap_bco = tt_concil_autom.tta_cod_tit_ap_bco
                            and   btt_concil_autom_multiplos.ttv_num_seq        > tt_concil_autom.ttv_num_seq
                            no-error.
                        if  avail btt_concil_autom_multiplos
                        then do:
                            assign btt_concil_autom_multiplos.ttv_log_concil_prim = yes
                                   tt_concil_autom.ttv_log_concil_prim            = no.
                        end /* if */.
                    end /* else */.    
                end /* if */.
            end /* if */.

        end /* do multiplos */.    

    end /* if */.
    else do:
        assign v_log_mais_tit_apb = no.
        multiplos:
        do v_num_row = 1 to browse br_tt_concil_autom:num-selected-rows
            on endkey undo multiplos, leave multiplos
            on error undo multiplos, leave multiplos
            transaction:

            if  v_num_row = 1 then do:
                /* efetiva a atualizaªío do titulos bancˇrios que foram confirmados manualmente.*/
                run pi_efetiva_atualizacao_manual /*pi_efetiva_atualizacao_manual*/.
                if  return-value = "NOK" /*l_nok*/  then 
                    return "NOK" /*l_nok*/ .
            end.

            browse br_tt_concil_autom:fetch-selected-row(v_num_row).

            assign v_num_count_tit     = 0
                   v_num_count_tit_apb = 0.

            /* Verifica no browse se existem outros t°tulos banc†rios com a mesma chave, caso encontrar, 
               mostra mensagem para que o usu†rio escolha, qual t°tulo banc†rio conciliar. */

            for each btt_concil_autom_multiplos
                where btt_concil_autom_multiplos.tta_cod_estab      = tt_concil_autom.tta_cod_estab
                and   btt_concil_autom_multiplos.tta_cdn_fornecedor = tt_concil_autom.tta_cdn_fornecedor
                and   btt_concil_autom_multiplos.tta_cod_tit_ap_bco = tt_concil_autom.tta_cod_tit_ap_bco
                and   btt_concil_autom_multiplos.ttv_log_descta     = no:
                assign v_num_count_tit = v_num_count_tit + 1.
            end.

            /* Verifica no browse se existem outros t°tulos apb com a mesma chave, 
               caso encontrar, mostra mensagem para que o usu†rio escolha, 
               qual dos t°tulos apb ser† conciliado com o t°tulo banc†rio. */

            if v_log_layout_sacad = yes then do:
                for each btt_concil_autom_multiplos
                    where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                    and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                    and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                    and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                    and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                    and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela 
                    and   btt_concil_autom_multiplos.ttv_log_descta      = no:
                    assign v_num_count_tit_apb = v_num_count_tit_apb + 1.
                end.
            end.
            else do:
                for each btt_concil_autom_multiplos
                    where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                    and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor
                    and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                    and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                    and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                    and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela 
                    and   btt_concil_autom_multiplos.ttv_log_descta      = no:
                    assign v_num_count_tit_apb = v_num_count_tit_apb + 1.
                end.
            end.

            if  v_num_count_tit = 1 and v_num_count_tit_apb = 1
            then do:
                find tit_ap_bcio exclusive-lock
                    where tit_ap_bcio.cod_estab         = tt_concil_autom.tta_cod_estab 
                    and   tit_ap_bcio.cod_sist_nac_bcio = tt_concil_autom.tta_cod_sist_nac_bcio 
                    and   tit_ap_bcio.cod_tit_ap_bco    = tt_concil_autom.tta_cod_tit_ap_bco
                    and   tit_ap_bcio.num_seq_tit_bco   = tt_concil_autom.ttv_num_seq_tit_bco
                    no-error.

                if v_log_layout_sacad = yes then do:
                    find tit_ap exclusive-lock
                        where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab_tit_ap
                        and   tit_ap.cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                        and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                        and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                        and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                        and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                        no-error.            
                end.
                else do:
                    find tit_ap exclusive-lock
                        where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab_tit_ap
                        and   tit_ap.cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor 
                        and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                        and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                        and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                        and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                        no-error.
                end.

                if  avail tit_ap_bcio and avail tit_ap
                then do:
                    if  tit_ap.log_concil = no
                    then do:
                        run pi_atualiza_conciliacao (Input "Autom†tica" /*l_automatica*/) /*pi_atualiza_conciliacao*/.
                        if  return-value = "NOK" /*l_nok*/  then 
                            return "NOK" /*l_nok*/ .
                        /* Tenta localizar na tabela tempor†ria outros T°tulo Banc†rios que possuam o mesmo T°tulo APB.
                        */

                        if v_log_layout_sacad = yes then do:
                            for each btt_concil_autom_multiplos
                                where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                                and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                                and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                                and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                                and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                                and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela:
                                assign btt_concil_autom_multiplos.tta_log_concil = yes.
                            end.
                        end.
                        else do:
                            for each btt_concil_autom_multiplos
                                where btt_concil_autom_multiplos.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
                                and   btt_concil_autom_multiplos.tta_cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor 
                                and   btt_concil_autom_multiplos.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                                and   btt_concil_autom_multiplos.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                                and   btt_concil_autom_multiplos.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                                and   btt_concil_autom_multiplos.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela:
                                assign btt_concil_autom_multiplos.tta_log_concil = yes.
                            end.
                        end.

                        /* Os t°tulos banc†rios que foram conciliados com àxito, n∆o ser∆o mais apresentados no browse */
                        assign tt_concil_autom.ttv_log_descta = yes.                   
                    end /* if */.
                end /* if */.
            end /* if */.
            else do:
                assign v_log_mais_tit_apb = yes.
            end /* else */.
        end /* do multiplos */.

        if  v_log_mais_tit_apb = yes
        then do:
            /* T°tulos Banc†rios n∆o foram conciliados ! */
            run pi_messages (input "show",
                             input 9770,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9770*/.
            return "NOK" /*l_nok*/ .
        end /* if */.        

    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_conciliacao_multiplos_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_seleciona_multiplos_titulos
** Descricao.............: pi_seleciona_multiplos_titulos
** Criado por............: bre17230
** Criado em.............: 24/04/2000 15:30:41
** Alterado por..........: fut40574
** Alterado em...........: 15/03/2007 15:37:37
*****************************************************************************/
PROCEDURE pi_seleciona_multiplos_titulos:

    /************************* Variable Definition Begin ************************/

    def var v_num_cont                       as integer         no-undo. /*local*/
    def var v_num_lin                        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  not can-find(first tt_concil_autom) then
        return "NOK" /*l_nok*/ .

    assign v_log_method = session:set-wait-state('general')
           v_num_lin = br_tt_concil_autom:num-iterations in frame f_dlg_01_concil_autom_confirmacao.
    br_tt_concil_autom:deselect-rows() in frame f_dlg_01_concil_autom_confirmacao.
    apply "home" /*l_home*/  to br_tt_concil_autom in frame f_dlg_01_concil_autom_confirmacao.
    do  v_num_cont = 1 to v_num_lin:
        if  br_tt_concil_autom:is-row-selected(v_num_lin) in frame f_dlg_01_concil_autom_confirmacao then leave.
        if  br_tt_concil_autom:select-row(v_num_cont) in frame f_dlg_01_concil_autom_confirmacao then.
        if  v_num_cont mod v_num_lin = 0 then do:
            apply "page-down" /*l_page_down*/  to br_tt_concil_autom in frame f_dlg_01_concil_autom_confirmacao.
            assign v_num_cont = 0.
        end.  
    end.  
    assign v_log_method = session:set-wait-state('').
    disable bt_concil_titulos_1
            with frame f_dlg_01_concil_autom_confirmacao.
    return "OK" /*l_ok*/ .

END PROCEDURE. /* pi_seleciona_multiplos_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_conciliacao
** Descricao.............: pi_atualiza_conciliacao
** Criado por............: bre17230
** Criado em.............: 24/04/2000 16:33:30
** Alterado por..........: fut43120
** Alterado em...........: 12/06/2012 10:37:55
*****************************************************************************/
PROCEDURE pi_atualiza_conciliacao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_concil
        as character
        format "X(01)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_barra_saida                as character       no-undo. /*local*/
    def var v_num_dias                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    &if defined(BF_FIN_CANCEL_VARREDURA) > 0 &then
    if tit_ap_bcio.log_tit_cancel = yes then do:
        /* T°tulo banc†rio n∆o pode ser conciliado, j† est† cancelado ! */
        run pi_messages (input "show",
                         input 18662,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           tit_ap_bcio.cod_estab, tit_ap_bcio.cod_sist_nac_bcio, tit_ap_bcio.cod_tit_ap_bco)) /*msg_18662*/.
        return "NOK" /*l_nok*/ .
    end.
    &endif   

    if v_log_layout_sacad then do:
        if v_log_bancario
        or v_log_barra_5 
        or v_log_dat_vencto
        or v_log_desconto
        or v_log_val_desc
        or v_log_val_juros
        or v_log_dat_multa
        or v_log_val_multa
        &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
        or v_log_forma_pagto_3
        &ENDIF
        then do:

            run pi_atualizar_tt_tit_ap_alteracao_base_aux_3 /*pi_atualizar_tt_tit_ap_alteracao_base_aux_3*/.

            if tit_ap_bcio.dat_multa > tit_ap_bcio.dat_vencto then
                assign v_num_dias = (tit_ap_bcio.dat_multa - tit_ap_bcio.dat_vencto).
            else
                assign v_num_dias = 0.

            if v_log_bancario then
                assign tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap_bco_cobdor = tit_ap_bcio.cod_tit_ap_bco.
            else
                assign tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap_bco_cobdor = tit_ap.cod_tit_ap_bco_cobdor.

            if v_log_barra_5 then
                assign tt_tit_ap_alteracao_base_aux_3.tta_cb4_tit_ap_bco_cobdor = tit_ap_bcio.cod_barra.
            else
                assign tt_tit_ap_alteracao_base_aux_3.tta_cb4_tit_ap_bco_cobdor = tit_ap.cb4_tit_ap_bco_cobdor.

            if v_log_dat_vencto then do:
                assign tt_tit_ap_alteracao_base_aux_3.tta_dat_vencto_tit_ap = tit_ap_bcio.dat_vencto
                       tt_tit_ap_alteracao_base_aux_3.tta_dat_prev_pagto    = tit_ap_bcio.dat_vencto.
            end.    

            if v_log_desconto then
                assign tt_tit_ap_alteracao_base_aux_3.tta_dat_desconto = tit_ap_bcio.dat_desconto.

            if v_log_val_desc then
                assign tt_tit_ap_alteracao_base_aux_3.tta_val_desconto = tit_ap_bcio.val_desconto
                       tt_tit_ap_alteracao_base_aux_3.tta_val_perc_desc = (tit_ap_bcio.val_desconto * 100) / tit_ap_bcio.val_tit_ap_bcio.

            if v_log_val_juros and v_num_dias > 0 then
                assign tt_tit_ap_alteracao_base_aux_3.tta_val_juros_dia_atraso = tit_ap_bcio.val_juros
                       tt_tit_ap_alteracao_base_aux_3.tta_val_perc_juros_dia_atraso = (tit_ap_bcio.val_juros / tit_ap_bcio.val_tit_ap_bcio) * 100.

            if v_log_dat_multa and v_num_dias > 0 then
                assign tt_tit_ap_alteracao_base_aux_3.tta_num_dias_atraso = v_num_dias
                       tt_tit_ap_alteracao_base_aux_3.tta_val_perc_multa_atraso = (tit_ap_bcio.val_multa * 100) / tit_ap_bcio.val_tit_ap_bcio.

            &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
            if v_log_forma_pagto_3 then do:
                if v_cod_forma_pagto <> '' and v_cod_forma_pagto <> ? then do:
                    find first forma_pagto no-lock
                      where forma_pagto.cod_forma_pagto = v_cod_forma_pagto no-error.
                    if avail forma_pagto then
                        assign tt_tit_ap_alteracao_base_aux_3.tta_cod_forma_pagto = forma_pagto.cod_forma_pagto.
                    else do:
                        /* Forma de Pagamento &1 Inexistente ! */
                        run pi_messages (input "show",
                                         input 6238,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            v_cod_forma_pagto)) /*msg_6238*/.
                        return "NOK" /*l_nok*/ .
                    end.
                end.
                else do:
                    assign tt_tit_ap_alteracao_base_aux_3.tta_cod_forma_pagto = ''.
                end.
            end.
            &ENDIF                   

            run pi_alter_tit_apb /*pi_alter_tit_apb*/.
            if return-value = "NOK" /*l_nok*/  then do:
                assign v_log_concil_autom_confir = no.
                return "NOK" /*l_nok*/ .
            end.
        end.
    end.
    else
       if v_log_cop_cod_barra then
           assign tit_ap.cb4_tit_ap_bco_cobdor = tit_ap_bcio.cod_barra.


        /* T°tulos no Banco */
        assign tit_ap_bcio.num_id_tit_ap = tit_ap.num_id_tit_ap
               tit_ap_bcio.log_concil    = yes
               tit_ap_bcio.log_confer    = yes
               tit_ap_bcio.dat_concil    = today
               &if defined(BF_FIN_CANCEL_VARREDURA) &then
               tit_ap_bcio.ind_tip_concil = p_ind_tip_concil
               &endif .

        &IF '{&emsfin_version}' >= '5.07' &THEN
            assign tit_ap_bcio.cod_estab_tit_ap = tit_ap.cod_estab.
        &ELSE
            assign tit_ap_bcio.cod_livre_1 = tit_ap.cod_estab.
        &ENDIF

        /* T°tulos no APB */       
        assign tit_ap.log_concil = yes.


    assign v_log_pos_num_bcio_cb = &IF DEFINED(BF_FIN_POSIC_NRO_BCIO_CB) &THEN 
                                       YES 
                                   &ELSE 
                                       NO
                                   &ENDIF.

    if  v_log_pos_num_bcio_cb = yes
    then do:
        /* fut36887 - atividade 137953*/    
        if tit_ap.cod_tit_ap_bco_cobdor = '' then
        do:
            assign v_cod_barra_saida = "".
            run pi_verificar_pos_cod_barra (Input tit_ap.cb4_tit_ap_bco_cobdor,
                                            Input "N£mero Banc†rio" /*l_num_bancario*/,
                                            output v_cod_barra_saida,
                                            Input substring(tit_ap.cb4_tit_ap_bco_cobdor, 1, 3)) /*pi_verificar_pos_cod_barra*/.

                assign tit_ap.cod_tit_ap_bco_cobdor = v_cod_barra_saida.
        end.
        /* fut36887 - atividade 137953*/    
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_atualiza_conciliacao */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_pos_cod_barra
** Descricao.............: pi_verificar_pos_cod_barra
** Criado por............: fut36887
** Criado em.............: 25/07/2005 10:58:17
** Alterado por..........: fut43120
** Alterado em...........: 24/02/2009 13:15:59
*****************************************************************************/
PROCEDURE pi_verificar_pos_cod_barra:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_barra_leitura
        as character
        format "x(50)"
        no-undo.
    def Input param p_cod_tip_inform
        as character
        format "x(30)"
        no-undo.
    def output param p_cod_barra_saida
        as character
        format "x(30)"
        no-undo.
    def Input param p_cod_banco
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    &if '{&emsfin_version}' >= '5.06' &then
        find first b_banco no-lock
            where b_banco.cod_sist_nac_bcio = p_cod_banco no-error.
        for each pos_cod_barra no-lock
            where pos_cod_barra.cod_banco =  b_banco.cod_banco
              and pos_cod_barra.cod_tip_inform = p_cod_tip_inform:
              assign p_cod_barra_saida = p_cod_barra_saida + substring(p_cod_barra_leitura, pos_cod_barra.num_pos_inic_cod_barra, pos_cod_barra.num_pos_fim_cod_barra - pos_cod_barra.num_pos_inic_cod_barra + 1).
        end.
    &endif  
END PROCEDURE. /* pi_verificar_pos_cod_barra */
/*****************************************************************************
** Procedure Interna.....: pi_concil_titulos_1
** Descricao.............: pi_concil_titulos_1
** Criado por............: bre17230
** Criado em.............: 24/04/2000 17:37:31
** Alterado por..........: fut43120
** Alterado em...........: 08/02/2012 10:19:47
*****************************************************************************/
PROCEDURE pi_concil_titulos_1:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_concil_autom_descta
        for tt_concil_autom.
    def buffer btt_concil_autom_tit_ap
        for tt_concil_autom.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_fornecedor_con
        as Integer
        format ">>>,>>>,>>9":U
        label "Fornecedor"
        column-label "Fornecedor"
        no-undo.
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_estab_con
        as character
        format "x(3)":U
        label "Estabelecimento"
        column-label "Estab"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_estab_con
        as Character
        format "x(5)":U
        label "Estabelecimento"
        column-label "Estab"
        no-undo.
    &ENDIF
    def var v_cod_tit_ap_bco_con
        as character
        format "x(20)":U
        label "T°tulo  Banco"
        column-label "T°tulo Banco"
        no-undo.
    def var v_log_prim
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_log_retorno
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    if  browse br_tt_concil_autom:num-selected-rows = 0
    then do:
        /* Dever† ser informado pelo menos um T°tulo para Conciliaá∆o ! */
        run pi_messages (input "show",
                         input 9771,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9771*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    main_block:
    do on error undo main_block, leave main_block on endkey undo main_block, leave main_block transaction:
        run pi_conciliacao_manual_titulos (Input tt_concil_autom.tta_cod_estab,
                                           Input tt_concil_autom.tta_cod_sist_nac_bcio,
                                           Input tt_concil_autom.tta_cod_tit_ap_bco,
                                           Input tt_concil_autom.ttv_num_seq_tit_bco,
                                           Input tt_concil_autom.tta_cod_estab_tit_ap,
                                           Input if v_log_layout_sacad then tt_concil_autom.ttv_cdn_matriz_fornec_inic else tt_concil_autom.tta_cdn_fornecedor,
                                           Input tt_concil_autom.tta_cod_ser_docto,
                                           Input tt_concil_autom.tta_cod_espec_docto,
                                           Input tt_concil_autom.tta_cod_tit_ap,
                                           Input tt_concil_autom.tta_cod_parcela,
                                           Input "Manual" /*l_manual*/) /*pi_conciliacao_manual_titulos*/.
        if  return-value <> "OK" /*l_ok*/  then do: 
            return "NOK" /*l_nok*/ .
        end.

        assign v_cod_estab_con      = "" /*l_null*/ 
               v_cdn_fornecedor_con = 0
               v_cod_tit_ap_bco_con = "" /*l_null*/ .

        /* A l¢gica abaixo, Ç utilizada para a seguinte situaá∆o:
            - Quando o estab, fornec e o cod t°tulo forem os mesmos.
            - Caso existam em um browse, um T°tulo Banc†rio e V†rios T°tulos Apb, o primeiro T°tulo Banc†rio estar†
              mostrando o Estab, Fornec e Cod T°tulo, e os demais estar∆o em branco. Serve como quebra do Browse, 
              facilitando a visualizaá∆o. 
            - Quando for selecionada uma linha (T°tulo Banc. e T°tulo Apb) as demais linhas referente ao T°tulo Banc.
              ser∆o eliminadas, e se n∆o tiver a l¢gica abaixo, a linha que ficar, caso n∆o seje a primeira ter† os
              valores zerados para o estab, fornec. e cod. t°tulo, ficando sem sentido.
        */    

        assign tt_concil_autom.tta_log_concil            = yes
               tt_concil_autom.ttv_log_descta            = yes
               tt_concil_autom.ttv_cod_estab_browse      = tt_concil_autom.tta_cod_estab
               tt_concil_autom.ttv_cod_fornec_browse     = string(tt_concil_autom.tta_cdn_fornecedor,"zzz,zzz,zz9" /*l_zzzzzzzz9*/ )
               tt_concil_autom.ttv_cod_tit_ap_bco_browse = tt_concil_autom.tta_cod_tit_ap_bco
               v_cod_estab_con                           = tt_concil_autom.tta_cod_estab
               v_cdn_fornecedor_con                      = tt_concil_autom.tta_cdn_fornecedor
               v_cod_tit_ap_bco_con                      = tt_concil_autom.tta_cod_tit_ap_bco.

        /* le os t°tulos banc†rios relacionados a outros t°tulos apb, e flega o campo ttv_log_descta = yes.*/
        for each btt_concil_autom_descta no-lock
            where btt_concil_autom_descta.tta_cod_estab         = v_cod_estab_con
            and   btt_concil_autom_descta.tta_cdn_fornecedor    = v_cdn_fornecedor_con
            and   btt_concil_autom_descta.tta_cod_tit_ap_bco    = v_cod_tit_ap_bco_con
            and   btt_concil_autom_descta.tta_log_concil        = no:
            assign btt_concil_autom_descta.ttv_log_descta = yes.
        end.    


        /* A l¢gica abaixo, Ç utilizada para a seguinte situaá∆o:
            - Quando o estab, fornec e o cod t°tulo forem diferentes.
            - Na seleá∆o de uma linha, verifica se existem mais de um T°tulo Apb para serem conciliados 
              com os T°tulos Banc., se encontrar mostra uma mensagem solicitando confirmaá∆o e na sequencia
              elimina as demais linhas que possuam o mesmo T°tulo.
              Atená∆o: Neste caso Ç utilizada como chave para procura a chave primar/£nica do T°tulo Apb.

        */      

        assign v_log_prim = yes.

        for each btt_concil_autom_descta no-lock
            where btt_concil_autom_descta.tta_cod_estab_tit_ap = tt_concil_autom.tta_cod_estab_tit_ap
            and   btt_concil_autom_descta.tta_cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto
            and   btt_concil_autom_descta.tta_cod_espec_docto = tt_concil_autom.tta_cod_espec_docto
            and   btt_concil_autom_descta.tta_cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap
            and   btt_concil_autom_descta.tta_cod_parcela     = tt_concil_autom.tta_cod_parcela
            and   btt_concil_autom_descta.tta_log_concil      = no
            and   btt_concil_autom_descta.ttv_log_descta      = no:

            if v_log_layout_sacad = yes then do:
                if btt_concil_autom_descta.tta_cdn_fornecedor <> tt_concil_autom.ttv_cdn_matriz_fornec_inic then
                    next.
            end.
            else do:
                if btt_concil_autom_descta.tta_cdn_fornecedor <> tt_concil_autom.tta_cdn_fornecedor then
                    next.
            end.

            if  v_log_prim = yes
            then do:        
                assign v_log_prim = no.
                run pi_messages (input "show",
                                 input 9775,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign v_log_answer = (if   return-value = "yes" then yes
                                       else if return-value = "no" then no
                                       else ?) /*msg_9775*/.
                if  v_log_answer <> yes
                then do:
                    assign v_log_retorno = yes.

                    assign tt_concil_autom.tta_log_concil = no
                           tt_concil_autom.ttv_log_descta = no.

                    undo main_block, leave main_block.
                end /* if */.
            end /* if */.    

            /* Seta log descarta como yes, com isso n∆o aparece mais no browse, para conciliaá∆o */
            assign btt_concil_autom_descta.ttv_log_descta = yes.

            /* Se foi o primeiro registro criado para o Estab, Fornec, e T°tulo Banc. dever† ser criado um outro com 
               os valores para mostrar no browse */
            if  btt_concil_autom_descta.ttv_log_concil_prim = yes
            then do:
                find first btt_concil_autom_tit_ap
                    where btt_concil_autom_tit_ap.tta_cod_estab         = btt_concil_autom_descta.tta_cod_estab
                    and   btt_concil_autom_tit_ap.tta_cdn_fornecedor    = btt_concil_autom_descta.tta_cdn_fornecedor
                    and   btt_concil_autom_tit_ap.tta_cod_tit_ap_bco    = btt_concil_autom_descta.tta_cod_tit_ap_bco
                    and   btt_concil_autom_tit_ap.ttv_num_seq          <> btt_concil_autom_descta.ttv_num_seq
                    and   btt_concil_autom_tit_ap.ttv_log_descta        = no
                    no-error.
                if avail btt_concil_autom_tit_ap then do:
                    assign btt_concil_autom_tit_ap.ttv_cod_estab_browse      = btt_concil_autom_descta.tta_cod_estab
                           btt_concil_autom_tit_ap.ttv_cod_fornec_browse     = string(btt_concil_autom_descta.tta_cdn_fornecedor,"zzz,zzz,zz9" /*l_zzzzzzzz9*/ )
                           btt_concil_autom_tit_ap.ttv_cod_tit_ap_bco_browse = btt_concil_autom_descta.tta_cod_tit_ap_bco
                           btt_concil_autom_tit_ap.ttv_log_concil_prim       = yes
                           btt_concil_autom_descta.ttv_log_concil_prim       = no.
                end.
            end /* if */.   
        end.

        open query qr_tt_concil_autom for 
            each tt_concil_autom no-lock
                where tt_concil_autom.ttv_log_descta = no.
    end.    

    if v_log_retorno = yes then do:
        for each btt_concil_autom_descta no-lock
            where btt_concil_autom_descta.tta_cod_estab         = v_cod_estab_con
            and   btt_concil_autom_descta.tta_cdn_fornecedor    = v_cdn_fornecedor_con
            and   btt_concil_autom_descta.tta_cod_tit_ap_bco    = v_cod_tit_ap_bco_con
            and   btt_concil_autom_descta.tta_log_concil        = no:
            assign btt_concil_autom_descta.ttv_log_descta = no.
        end.
        return "NOK" /*l_nok*/ .
    end.
    else do:
        return "OK" /*l_ok*/ .
    end.
END PROCEDURE. /* pi_concil_titulos_1 */
/*****************************************************************************
** Procedure Interna.....: pi_concil_autom_confirmacao_bt_ok
** Descricao.............: pi_concil_autom_confirmacao_bt_ok
** Criado por............: bre17230
** Criado em.............: 26/04/2000 10:10:34
** Alterado por..........: fut43120
** Alterado em...........: 18/01/2012 10:36:07
*****************************************************************************/
PROCEDURE pi_concil_autom_confirmacao_bt_ok:

    if  browse br_tt_concil_autom:num-selected-rows = 0
    then do:
        run pi_messages (input "show",
                         input 21075,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
        assign v_log_answer = (if   return-value = "yes" then yes
                               else if return-value = "no" then no
                               else ?) /*msg_21075*/.
        if  v_log_answer <> yes
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.    
    end /* if */.

    /* Se v_log_concil_todos igual a "no" foi utilizada a conciliaá∆o manual, caso contr†rio,
       foram selecionados v†rios t°tulos para conciliar */
    /* @if(v_log_concil_todos = no)
        @if(tt_concil_autom.tta_log_concil = yes)
            /* Conciliacao dos T°tulos */       
            find tit_ap_bcio exclusive-lock
                where tit_ap_bcio.cod_estab         = tt_concil_autom.tta_cod_estab 
                and   tit_ap_bcio.cod_sist_nac_bcio = tt_concil_autom.tta_cod_sist_nac_bcio 
                and   tit_ap_bcio.cod_tit_ap_bco    = tt_concil_autom.tta_cod_tit_ap_bco 
                no-error.
            if v_log_layout_sacad = yes then do:
                find tit_ap exclusive-lock
                    where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab 
                    and   tit_ap.cdn_fornecedor  = tt_concil_autom.ttv_cdn_matriz_fornec_inic
                    and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                    and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                    and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                    and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                    no-error.
            end.
            else do:
                find tit_ap exclusive-lock
                    where tit_ap.cod_estab       = tt_concil_autom.tta_cod_estab 
                    and   tit_ap.cdn_fornecedor  = tt_concil_autom.tta_cdn_fornecedor 
                    and   tit_ap.cod_ser_docto   = tt_concil_autom.tta_cod_ser_docto 
                    and   tit_ap.cod_espec_docto = tt_concil_autom.tta_cod_espec_docto 
                    and   tit_ap.cod_tit_ap      = tt_concil_autom.tta_cod_tit_ap 
                    and   tit_ap.cod_parcela     = tt_concil_autom.tta_cod_parcela 
                    no-error.
            end.
            @if(avail tit_ap_bcio and avail tit_ap)
                @run(pi_atualiza_conciliacao).
                delete tt_concil_autom.
            @end_if().
        @end_if().
        @else()
            @cx_message(9810,tt_concil_autom.tta_cod_estab,tt_concil_autom.tta_cod_sist_nac_bcio,tt_concil_autom.tta_cod_tit_ap_bco).
            return @%(l_nok).        
        @end_if().
    @end_if().*/
    else do:
        run pi_conciliacao_multiplos_titulos /*pi_conciliacao_multiplos_titulos*/.
        if  return-value <> "OK" /*l_ok*/ 
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_concil_autom_confirmacao_bt_ok */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_legenda
** Descricao.............: pi_conciliacao_legenda
** Criado por............: bre17230
** Criado em.............: 24/04/2000 11:53:27
** Alterado por..........: fut35118
** Alterado em...........: 06/08/2007 16:28:17
*****************************************************************************/
PROCEDURE pi_conciliacao_legenda:

    view frame f_dlg_01_tit_ap_bcio_legenda.

    filter_block:
    do on error undo filter_block, retry filter_block
                     on endkey undo filter_block, leave filter_block:

        /* ************* Trata os retangulos da tela de legenda ****************/

        assign rt_001:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 0.
        assign rt_002:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 9.
        assign rt_003:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 12.
        assign rt_004:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 0.
        assign rt_005:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 9.
        assign rt_008:bgcolor in frame f_dlg_01_tit_ap_bcio_legenda = 3.


        assign rt_001:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.
        assign rt_002:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.
        assign rt_003:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.
        assign rt_004:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.
        assign rt_005:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.
        assign rt_008:visible in frame f_dlg_01_tit_ap_bcio_legenda = yes.

        /* **********************************************************************/

        enable all with frame f_dlg_01_tit_ap_bcio_legenda.       

        wait-for go of frame f_dlg_01_tit_ap_bcio_legenda.

    end /* do filter_block */.

    hide frame f_dlg_01_tit_ap_bcio_legenda no-pause.

END PROCEDURE. /* pi_conciliacao_legenda */
/*****************************************************************************
** Procedure Interna.....: pi_tit_ap_bcio_eliminacao
** Descricao.............: pi_tit_ap_bcio_eliminacao
** Criado por............: bre17230
** Criado em.............: 03/05/2000 10:37:45
** Alterado por..........: bre17230
** Alterado em...........: 03/05/2000 10:38:36
*****************************************************************************/
PROCEDURE pi_tit_ap_bcio_eliminacao:

    assign v_log_sit_eliminac = no.
    if  search("prgfin/apb/apb775zb.r") = ? and search("prgfin/apb/apb775zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb775zb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb775zb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/apb/apb775zb.p /*prg_fnc_tit_ap_bcio_eliminacao*/.
    if  v_log_sit_eliminac = yes
    then do:
        run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
        run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.
    end /* if */.

END PROCEDURE. /* pi_tit_ap_bcio_eliminacao */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_browse_color
** Descricao.............: pi_atualiza_browse_color
** Criado por............: bre17230
** Criado em.............: 03/05/2000 10:43:22
** Alterado por..........: fut41675_3
** Alterado em...........: 23/04/2010 16:57:11
*****************************************************************************/
PROCEDURE pi_atualiza_browse_color:

    /************************* Variable Definition Begin ************************/

    def var v_num_color
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if v_log_layout_sacad then do:
        if tt_tit_ap_em_bco.tta_log_tit_cancel = yes then
            assign v_num_color = 3.
        else if tt_tit_ap_em_bco.tta_log_concil = no then
            assign v_num_color = 0.
        else do:
            if  tt_tit_ap_em_bco.tta_log_confer = yes
            then do:
                assign v_num_color = 9.
            end /* if */.
            else do:
                assign v_num_color = 12.
            end /* if */.
        end /* if */.
        assign tt_tit_ap_em_bco.ttv_num_sel_reg:fgcolor       in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_cod_estab:fgcolor         in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_cod_sist_nac_bcio:fgcolor in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_cdn_fornecedor:fgcolor    in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_nom_fornecedor:fgcolor    in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_dat_vencto:fgcolor        in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_val_tit_ap_bcio:fgcolor   in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_val_desconto:fgcolor      in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_val_abat_tit_ap:fgcolor   in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_val_multa:fgcolor         in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.tta_val_juros:fgcolor         in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.ttv_cod_tit_ap_bco:fgcolor    in browse br_tit_ap_em_bco_bank = v_num_color
               tt_tit_ap_em_bco.ttv_cod_barra_bcio:fgcolor    in browse br_tit_ap_em_bco_bank = v_num_color.
    end.
    else do:
        if tt_tit_ap_em_bco.tta_log_tit_cancel = yes then
            assign v_num_color = 3.
        else if tt_tit_ap_em_bco.tta_log_concil = no then
            assign v_num_color = 0.
        else do:
            if  tt_tit_ap_em_bco.tta_log_confer = yes
            then do:
                assign v_num_color = 9.
            end /* if */.
            else do:
                assign v_num_color = 12.
            end /* else */.
        end.
        assign tt_tit_ap_em_bco.ttv_num_sel_reg:fgcolor           in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_cod_estab:fgcolor             in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_cod_sist_nac_bcio:fgcolor     in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_cdn_fornecedor:fgcolor        in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_nom_fornecedor:fgcolor        in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_cod_tit_ap_bco:fgcolor        in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_cod_id_feder:fgcolor          in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_dat_vencto:fgcolor            in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.tta_val_tit_ap_bcio:fgcolor       in browse br_tit_ap_em_bco = v_num_color
               tt_tit_ap_em_bco.ttv_cod_barra_bcio:fgcolor         in browse br_tit_ap_em_bco = v_num_color.
    end.

END PROCEDURE. /* pi_atualiza_browse_color */
/*****************************************************************************
** Procedure Interna.....: pi_desconciliacao_manual_titulos
** Descricao.............: pi_desconciliacao_manual_titulos
** Criado por............: bre17230
** Criado em.............: 18/04/2000 13:34:55
** Alterado por..........: fut41506
** Alterado em...........: 23/11/2007 16:00:29
*****************************************************************************/
PROCEDURE pi_desconciliacao_manual_titulos:

    &IF '{&emsfin_version}' >= '5.07' &THEN
        find first tit_ap exclusive-lock
            where tit_ap.cod_estab     = tit_ap_bcio.cod_estab_tit_ap
            and   tit_ap.num_id_tit_ap = tit_ap_bcio.num_id_tit_ap
            no-error.    
    &ELSE
        find first tit_ap exclusive-lock
            where tit_ap.cod_estab     = tit_ap_bcio.cod_livre_1
            and   tit_ap.num_id_tit_ap = tit_ap_bcio.num_id_tit_ap
            no-error.    
    &ENDIF

    if  avail tit_ap
    then do:
        /* Verifica se o T°tulo APB est† em Pagamento Escritural */
        for each item_bord_ap no-lock
            where item_bord_ap.cod_estab       = tit_ap.cod_estab
            and   item_bord_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
            and   item_bord_ap.cod_ser_docto   = tit_ap.cod_ser_docto
            and   item_bord_ap.cod_espec_docto = tit_ap.cod_espec_docto
            and   item_bord_ap.cod_tit_ap      = tit_ap.cod_tit_ap
            and   item_bord_ap.cod_parcela     = tit_ap.cod_parcela:
            find bord_ap no-lock
                where bord_ap.cod_estab_bord = item_bord_ap.cod_estab_bord
                and   bord_ap.cod_portador   = item_bord_ap.cod_portador
                and   bord_ap.num_bord_ap    = item_bord_ap.num_bord_ap
                no-error.
            if  avail bord_ap
            then do:
                if  bord_ap.log_bord_ap_escrit = yes
                then do:
                    /* T°tulo Banc†rio n∆o pode ser desconciliado ! */
                    run pi_messages (input "show",
                                     input 9743,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                       tit_ap.cod_estab,                                  tit_ap.cdn_fornecedor,                                  tit_ap.cod_ser_docto,                                  tit_ap.cod_espec_docto,                                  tit_ap.cod_tit_ap,                                  tit_ap.cod_parcela,                                  bord_ap.cod_estab_bord,                                  bord_ap.cod_portador,                                  bord_ap.num_bord_ap)) /*msg_9743*/.
                    return "NOK" /*l_nok*/ .
                end /* if */.    
            end /* if */.
        end.    
    end /* if */.

    /* Atualiza a desconciliaá∆o manual de t°tulos */              
    assign tit_ap_bcio.num_id_tit_ap = 0        
           tit_ap_bcio.log_concil    = no
           tit_ap_bcio.log_confer    = no
           tit_ap_bcio.dat_concil    = ?
           &if defined(BF_FIN_CANCEL_VARREDURA) &then
           tit_ap_bcio.ind_tip_concil = "Manual" /*l_manual*/ 
           &endif .

    if  avail tit_ap then
        assign tit_ap.log_concil         = no.    /* T°tulos APB */

    &IF '{&emsfin_version}' >= '5.07' &THEN
        assign tit_ap_bcio.cod_estab_tit_ap = "".
    &ELSE
        assign tit_ap_bcio.cod_livre_1   = "".
    &ENDIF

END PROCEDURE. /* pi_desconciliacao_manual_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_botao_desconciliacao_manual_titulos
** Descricao.............: pi_botao_desconciliacao_manual_titulos
** Criado por............: bre17230
** Criado em.............: 04/05/2000 08:41:47
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:13:02
*****************************************************************************/
PROCEDURE pi_botao_desconciliacao_manual_titulos:

    if  not avail tt_tit_ap_em_bco
    then do:
        /* Nenhum &1 foi informado para conciliaá∆o ! */
        run pi_messages (input "show",
                         input 9734,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulo Banc†rio" /*l_titulo_bancario*/)) /*msg_9734*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    find tit_ap_bcio exclusive-lock
        where tit_ap_bcio.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
        and   tit_ap_bcio.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
        and   tit_ap_bcio.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco
        and   tit_ap_bcio.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco
        no-error.
    if  avail tit_ap_bcio
    then do:
        if  tit_ap_bcio.log_concil = yes
        then do:
            run pi_desconciliacao_manual_titulos /*pi_desconciliacao_manual_titulos*/.
            if  return-value = "NOK" /*l_nok*/ 
            then do:
                return "NOK" /*l_nok*/ .
            end /* if */.
        end /* if */.
        else do:
            /* T°tulo Banc†rio n∆o est† Conciliado ! */
            run pi_messages (input "show",
                             input 9792,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9792*/.
            return "NOK" /*l_nok*/ .        
        end /* else */.    
    end /* if */.    

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_botao_desconciliacao_manual_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_browse_color_2
** Descricao.............: pi_atualiza_browse_color_2
** Criado por............: bre17230
** Criado em.............: 04/05/2000 16:16:41
** Alterado por..........: fut35183_3
** Alterado em...........: 18/12/2007 09:17:28
*****************************************************************************/
PROCEDURE pi_atualiza_browse_color_2:

    /* T°tulos Banc†rios Conciliados, N∆o Conciliados e conferidos atravÇs de legenda.
    */
    if avail tt_concil_autom then
        assign tt_concil_autom.tta_dat_vencto_tit_ap:fgcolor in browse br_tt_concil_autom = 09
               tt_concil_autom.tta_val_tit_ap:fgcolor        in browse br_tt_concil_autom = 09
               tt_concil_autom.tta_cod_ser_docto:fgcolor     in browse br_tt_concil_autom = 09
               tt_concil_autom.tta_cod_espec_docto:fgcolor   in browse br_tt_concil_autom = 09
               tt_concil_autom.tta_cod_tit_ap:fgcolor        in browse br_tt_concil_autom = 09
               tt_concil_autom.tta_cod_parcela:fgcolor       in browse br_tt_concil_autom = 09.        

END PROCEDURE. /* pi_atualiza_browse_color_2 */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_browse_color_1
** Descricao.............: pi_atualiza_browse_color_1
** Criado por............: bre17230
** Criado em.............: 04/05/2000 16:41:40
** Alterado por..........: fut41675_3
** Alterado em...........: 23/04/2010 17:17:34
*****************************************************************************/
PROCEDURE pi_atualiza_browse_color_1:

    /* * Procedure interna que diferencia os T°tulos Contas a Pagar Conciliados e N∆o Conciliados **/

    if v_log_layout_sacad then do:
        if  tt_tit_ap_conciliacao.tta_log_concil = no then
            assign tt_tit_ap_conciliacao.ttv_num_sel_reg:fgcolor        in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_estab:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio:fgcolor  in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cdn_fornecedor:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_espec_docto:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_ser_docto:fgcolor      in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_tit_ap:fgcolor         in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_cod_parcela:fgcolor        in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap:fgcolor  in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_tit_ap_bcio:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_desconto:fgcolor       in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_desconto:fgcolor       in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_abat_tit_ap:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_multa:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.tta_val_juros:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.ttv_cod_tit_ap_bco:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 0
                   tt_tit_ap_conciliacao.ttv_cod_barra_bcio:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 0.
        else
            assign tt_tit_ap_conciliacao.ttv_num_sel_reg:fgcolor        in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_estab:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio:fgcolor  in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cdn_fornecedor:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_espec_docto:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_ser_docto:fgcolor      in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_tit_ap:fgcolor         in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_cod_parcela:fgcolor        in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap:fgcolor  in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_tit_ap_bcio:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_desconto:fgcolor       in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_desconto:fgcolor       in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_abat_tit_ap:fgcolor    in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_multa:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.tta_val_juros:fgcolor          in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.ttv_cod_tit_ap_bco:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 9
                   tt_tit_ap_conciliacao.ttv_cod_barra_bcio:fgcolor     in browse br_tt_tit_ap_conciliacao_bank = 9.

    end.
    else do:
        if  tt_tit_ap_conciliacao.tta_log_concil = no
        then do:
            assign tt_tit_ap_conciliacao.ttv_num_sel_reg:fgcolor           in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_cod_estab:fgcolor             in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio:fgcolor     in browse br_tt_tit_ap_conciliacao = 0 
                   tt_tit_ap_conciliacao.tta_cdn_fornecedor:fgcolor        in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_cod_tit_ap:fgcolor            in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_cod_parcela:fgcolor           in browse br_tt_tit_ap_conciliacao = 0          
                   tt_tit_ap_conciliacao.tta_dat_emis_docto:fgcolor        in browse br_tt_tit_ap_conciliacao = 0           
                   tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap:fgcolor     in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_val_origin_tit_ap:fgcolor     in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_cod_id_feder:fgcolor          in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.tta_nom_abrev:fgcolor             in browse br_tt_tit_ap_conciliacao = 0
                   tt_tit_ap_conciliacao.ttv_cod_barra_bcio:fgcolor        in browse br_tt_tit_ap_conciliacao = 0.
        end /* if */.
        else do:
            assign tt_tit_ap_conciliacao.ttv_num_sel_reg:fgcolor           in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_cod_estab:fgcolor             in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_cod_sist_nac_bcio:fgcolor     in browse br_tt_tit_ap_conciliacao = 9 
                   tt_tit_ap_conciliacao.tta_cdn_fornecedor:fgcolor        in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_cod_tit_ap:fgcolor            in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_cod_parcela:fgcolor           in browse br_tt_tit_ap_conciliacao = 9          
                   tt_tit_ap_conciliacao.tta_dat_emis_docto:fgcolor        in browse br_tt_tit_ap_conciliacao = 9           
                   tt_tit_ap_conciliacao.tta_dat_vencto_tit_ap:fgcolor     in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_val_origin_tit_ap:fgcolor     in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_cod_id_feder:fgcolor          in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.tta_nom_abrev:fgcolor             in browse br_tt_tit_ap_conciliacao = 9
                   tt_tit_ap_conciliacao.ttv_cod_barra_bcio:fgcolor        in browse br_tt_tit_ap_conciliacao = 9.
        end /* if */.
    end.
END PROCEDURE. /* pi_atualiza_browse_color_1 */
/*****************************************************************************
** Procedure Interna.....: pi_choose_bt_check
** Descricao.............: pi_choose_bt_check
** Criado por............: bre17230
** Criado em.............: 09/05/2000 10:14:11
** Alterado por..........: fut40695
** Alterado em...........: 31/01/2010 15:03:59
*****************************************************************************/
PROCEDURE pi_choose_bt_check:

    /* Obriga que o usu†rio antes de atualizar o browse, atualize a faixa e o filtro. */
    if  v_log_tit_ap_bcio_atualiza = yes
    then do:
        if v_log_layout_sacad = no then do:
            if not avail banco then do:
                /* Banco Inexistente ! */
                run pi_messages (input "show",
                                 input 458,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_458*/.
                apply 'entry' to v_cdn_sist_nac_bcio in frame f_dlg_03_varredura_sacado.        
                return "NOK" /*l_nok*/ .
            end.    
            else
                assign v_cod_banco_atz = banco.cod_banco.
        end.
        else do:
            assign v_cod_banco_ini = v_wgh_fill_in_ini:screen-value
                   v_cod_banco_fim = v_wgh_fill_in_fim:screen-value.

            assign v_cod_banco_atz = v_cod_banco_ini.
        end.

        assign v_log_method = session:set-wait-state('general').
        run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
        disable bt_check
                with frame f_dlg_03_varredura_sacado.
        assign v_log_method = session:set-wait-state('').
        apply "row-entry" to br_tit_ap_em_bco in frame f_dlg_03_varredura_sacado.
    end /* if */.
    else do:
        /* Antes de atualizar o browse, escolher a faixa de seleá∆o ! */
        run pi_messages (input "show",
                         input 9726,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulos Banc†rios" /*l_titulos_bancarios*/)) /*msg_9726*/.
        return "NOK" /*l_nok*/ .
    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_choose_bt_check */
/*****************************************************************************
** Procedure Interna.....: pi_choose_bt_check7
** Descricao.............: pi_choose_bt_check7
** Criado por............: bre17230
** Criado em.............: 09/05/2000 10:14:26
** Alterado por..........: fut40695
** Alterado em...........: 31/01/2010 15:04:22
*****************************************************************************/
PROCEDURE pi_choose_bt_check7:

    /* Obriga que o usu†rio antes de atualizar o browse, atualize a faixa e o filtro. */
    if  v_log_tit_ap_atualiza = yes
    then do:
        if v_log_layout_sacad = no then do:
            if not avail banco then do:
                /* Banco Inexistente ! */
                run pi_messages (input "show",
                                 input 458,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_458*/.
                apply 'entry' to v_cdn_sist_nac_bcio in frame f_dlg_03_varredura_sacado.
                return "NOK" /*l_nok*/ .
            end.    
            else
                assign v_cod_banco_atz = banco.cod_banco.
        end.
        else do:
            assign v_cod_banco_ini = v_wgh_fill_in_ini:screen-value
                   v_cod_banco_fim = v_wgh_fill_in_fim:screen-value.

            assign v_cod_banco_atz = v_cod_banco_ini.
        end.

        assign v_log_method = session:set-wait-state('general').
        run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.
        disable bt_check7
                with frame f_dlg_03_varredura_sacado.
        assign v_log_method = session:set-wait-state('').
    end /* if */.
    else do:
        /* Antes de atualizar o browse, escolher a faixa de seleá∆o ! */
        run pi_messages (input "show",
                         input 9726,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulos APB" /*l_titulos_apb*/)) /*msg_9726*/.
        return "NOK" /*l_nok*/ .
    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_choose_bt_check7 */
/*****************************************************************************
** Procedure Interna.....: pi_bt_concil_autom_titulos
** Descricao.............: pi_bt_concil_autom_titulos
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:11:11
** Alterado por..........: fut1236
** Alterado em...........: 28/08/2007 08:35:09
*****************************************************************************/
PROCEDURE pi_bt_concil_autom_titulos:

    find first tt_tit_ap_em_bco no-error.


    if  not avail tt_tit_ap_em_bco
    then do:
        /* Nenhum &1 foi informado para conciliaá∆o ! */
        run pi_messages (input "show",
                         input 9751,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulo Banc†rio" /*l_titulo_bancario*/)) /*msg_9751*/.
        return "NOK" /*l_nok*/ .
    end /* if */.


    assign v_log_confir_concil      = no
           v_num_dias_aprox         = 0
           v_val_percent_variac_val = 0
           v_log_concil_autom       = no.

    if v_log_matriz_fornec = yes then do:
        assign rs_regra_concil_autom:radio-buttons in frame f_dlg_01_concil_autom = 'Matriz/Filial,Matriz/Filial,Matriz/Filial/Valor,Matriz/Filial/Valor,Matriz/Filial/Data Vencto,Matriz/Filial/Data Vencto,Matriz/Filial/Valor/Data Vencto,Matriz/Filial/Valor/Data Vencto,Matriz/Filial/Valor/Data Vencto/T°tulo,Matriz/Filial/Valor/Data Vencto/T°tulo'.
        assign rs_regra_concil_autom = "Matriz/Filial/Valor/Data Vencto/T°tulo".
    end.
    else do:
        assign rs_regra_concil_autom:radio-buttons in frame f_dlg_01_concil_autom = 'Fornecedor,Fornecedor,Fornecedor/Valor,Fornecedor/Valor,Fornecedor/Data Vencto,Fornecedor/Data Vencto,Fornecedor/Valor/Data Vencto,Fornecedor/Valor/Data Vencto'.
        assign rs_regra_concil_autom = "Fornecedor/Valor/Data Vencto" /*l_fornecedor_valor_vencto*/ .
    end.

    repeat while v_log_concil_autom = no:

        view frame f_dlg_01_concil_autom.

        enable all with frame f_dlg_01_concil_autom.
        ASSIGN v_log_confir_concil = YES.
        display bt_can
                bt_hel2
                bt_ok
                rs_regra_concil_autom
                v_log_confir_concil
                v_num_dias_aprox
                v_val_percent_variac_val
                with frame f_dlg_01_concil_autom.

        wait-for go of frame f_dlg_01_concil_autom or
             endkey of frame f_dlg_01_concil_autom.

    end.

    hide frame f_dlg_01_concil_autom.

    if  v_log_atualiz_autom = yes
    then do:
        assign v_log_atualiz_autom = no.
        run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
        run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.

        /* Fut37495 */

        /* Begin_Include: i_exec_program_epc */
        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_upc) (input 'UPC-VARRED-AUTOM',
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        if  v_nom_prog_appc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_appc) (input 'UPC-VARRED-AUTOM',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_dpc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_dpc) (input 'UPC-VARRED-AUTOM',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.
        &endif
        &endif
        /* End_Include: i_exec_program_epc */

        /* Fut37495 */
    end /* if */.            

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_bt_concil_autom_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_bt_concil_manual_titulos
** Descricao.............: pi_bt_concil_manual_titulos
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:14:25
** Alterado por..........: fut43117
** Alterado em...........: 07/08/2010 14:23:26
*****************************************************************************/
PROCEDURE pi_bt_concil_manual_titulos:

    if  not avail tt_tit_ap_em_bco
    then do:
        /* Nenhum &1 foi informado para conciliaá∆o ! */
        run pi_messages (input "show",
                         input 9734,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulo Banc†rio" /*l_titulo_bancario*/)) /*msg_9734*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  not avail tt_tit_ap_conciliacao
    then do:
        /* Nenhum &1 foi informado para conciliaá∆o ! */
        run pi_messages (input "show",
                         input 9734,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "T°tulo APB" /*l_titulo_apb*/)) /*msg_9734*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  not can-find(first tt_tit_ap_conciliacao_sel)
    then do:
        /* Nenhum t°tulo APB selecionado para a &1 manual ! */
        run pi_messages (input "show",
                         input 18659,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "Conciliaá∆o" /*l_conciliacao*/)) /*msg_18659*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    for each tt_tit_ap_conciliacao_sel:
        find first btt_tit_ap_em_bco no-lock
            where btt_tit_ap_em_bco.ttv_num_sel_reg = tt_tit_ap_conciliacao_sel.ttv_num_sel_reg no-error.

        /* Teoricamente, nunca dever† entrar aqui*/
        if not avail btt_tit_ap_em_bco then
            next.    

        run pi_conciliacao_manual_titulos (Input btt_tit_ap_em_bco.tta_cod_estab,
                                           Input btt_tit_ap_em_bco.tta_cod_sist_nac_bcio,
                                           Input btt_tit_ap_em_bco.tta_cod_tit_ap_bco,
                                           Input btt_tit_ap_em_bco.ttv_num_seq_tit_bco,
                                           Input tt_tit_ap_conciliacao_sel.tta_cod_estab,
                                           Input tt_tit_ap_conciliacao_sel.tta_cdn_fornecedor,
                                           Input tt_tit_ap_conciliacao_sel.tta_cod_ser_docto,
                                           Input tt_tit_ap_conciliacao_sel.tta_cod_espec_docto,
                                           Input tt_tit_ap_conciliacao_sel.tta_cod_tit_ap,
                                           Input tt_tit_ap_conciliacao_sel.tta_cod_parcela,
                                           Input "Manual" /*l_manual*/) /*pi_conciliacao_manual_titulos*/.
        if  return-value <> "OK" /*l_ok*/ 
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.                                       

        /* Fut37495 */

        /* Begin_Include: i_exec_program_epc */
        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_upc) (input 'UPC-VARRED-MANUAL',
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        if  v_nom_prog_appc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_appc) (input 'UPC-VARRED-MANUAL',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_dpc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_ap_bcio).    
            run value(v_nom_prog_dpc) (input 'UPC-VARRED-MANUAL',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.
        &endif
        &endif
        /* End_Include: i_exec_program_epc */

        /* Fut37495 */
    end.

    /* Ap¢s executar a Conciliaá∆o, faz uma atualizaá∆o em ambos os browses */
    run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
    run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_bt_concil_manual_titulos */
/*****************************************************************************
** Procedure Interna.....: pi_bt_fil2
** Descricao.............: pi_bt_fil2
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:38:59
** Alterado por..........: fut35118
** Alterado em...........: 23/07/2007 13:57:05
*****************************************************************************/
PROCEDURE pi_bt_fil2:

    view frame f_dlg_01_tit_ap_bcio_filtro.

    filter_block:
    do on error undo filter_block, retry filter_block
                     on endkey undo filter_block, leave filter_block:
        if  not retry
        then do:
            display bt_can
                    bt_hel2
                    bt_ok
                    v_log_concil_confer
                    v_log_concil_nao_confer
                    v_log_matriz_fornec
                    v_log_nao_concil
                    v_log_tit_ap_bcio_cancel
                    with frame f_dlg_01_tit_ap_bcio_filtro.
            enable all with frame f_dlg_01_tit_ap_bcio_filtro.

            if v_log_layout_sacad = no then
                hide v_log_matriz_fornec in frame f_dlg_01_tit_ap_bcio_filtro.

            &if defined(BF_FIN_CANCEL_VARREDURA) = 0 &then            
                hide v_log_tit_ap_bcio_cancel in frame f_dlg_01_tit_ap_bcio_filtro.
                if v_log_layout_sacad = yes then
                    assign v_log_matriz_fornec:row in frame f_dlg_01_tit_ap_bcio_filtro = v_log_tit_ap_bcio_cancel:row in frame f_dlg_01_tit_ap_bcio_filtro.
            &endif

        end /* if */.

        wait-for go of frame f_dlg_01_tit_ap_bcio_filtro.

        assign input frame f_dlg_01_tit_ap_bcio_filtro v_log_concil_confer
               input frame f_dlg_01_tit_ap_bcio_filtro v_log_concil_nao_confer
               input frame f_dlg_01_tit_ap_bcio_filtro v_log_matriz_fornec
               input frame f_dlg_01_tit_ap_bcio_filtro v_log_nao_concil
               input frame f_dlg_01_tit_ap_bcio_filtro v_log_tit_ap_bcio_cancel.

    end /* do filter_block */.


    if  v_log_tit_ap_bcio_habilita = yes
    then do:
        assign v_log_tit_ap_bcio_atualiza = yes.
        enable bt_check
               with frame f_dlg_03_varredura_sacado.
    end /* if */.    

    hide frame f_dlg_01_tit_ap_bcio_filtro no-pause.


END PROCEDURE. /* pi_bt_fil2 */
/*****************************************************************************
** Procedure Interna.....: pi_bt_fil3
** Descricao.............: pi_bt_fil3
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:40:43
** Alterado por..........: bre17230
** Alterado em...........: 26/05/2000 16:40:52
*****************************************************************************/
PROCEDURE pi_bt_fil3:

    view frame f_dlg_01_tit_ap_filtro.

    filter_block:
    do on error undo filter_block, retry filter_block
                     on endkey undo filter_block, leave filter_block:
        if  not retry
        then do:
            display bt_can
                    bt_hel2
                    bt_ok
                    rs_tt_tit_ap_conciliacao
                    with frame f_dlg_01_tit_ap_filtro.
            enable all with frame f_dlg_01_tit_ap_filtro.
        end /* if */.

        wait-for go of frame f_dlg_01_tit_ap_filtro.

        assign input frame f_dlg_01_tit_ap_filtro rs_tt_tit_ap_conciliacao.

    end /* do filter_block */.

    if  v_log_tit_ap_habilita = yes
    then do:
        assign v_log_tit_ap_atualiza = yes.
        enable bt_check7
               with frame f_dlg_03_varredura_sacado.   
    end /* if */.    

    hide frame f_dlg_01_tit_ap_filtro no-pause.


END PROCEDURE. /* pi_bt_fil3 */
/*****************************************************************************
** Procedure Interna.....: pi_bt_mod1
** Descricao.............: pi_bt_mod1
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:42:09
** Alterado por..........: fut43117
** Alterado em...........: 09/08/2010 15:14:33
*****************************************************************************/
PROCEDURE pi_bt_mod1:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.04" &then
    def buffer b_tit_ap_bcio
        for tit_ap_bcio.
    &endif


    /*************************** Buffer Definition End **************************/

    if avail tt_tit_ap_em_bco then do:
        find b_tit_ap_bcio no-lock
            where b_tit_ap_bcio.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
            and   b_tit_ap_bcio.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
            and   b_tit_ap_bcio.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco
            and   b_tit_ap_bcio.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco
            no-error.
        if avail b_tit_ap_bcio then do:
            assign v_rec_tit_ap_bcio = recid(b_tit_ap_bcio).
            assign v_log_sit_alter = no.
            if  search("prgfin/apb/apb775ea.r") = ? and search("prgfin/apb/apb775ea.p") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb775ea.p".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb775ea.p"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/apb/apb775ea.p /*prg_mod_tit_ap_bcio*/.
            if  v_log_sit_alter = yes
            then do:
                run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
                run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.
            end /* if */.
        end.    
    end.        
END PROCEDURE. /* pi_bt_mod1 */
/*****************************************************************************
** Procedure Interna.....: pi_bt_ran2
** Descricao.............: pi_bt_ran2
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:50:03
** Alterado por..........: bre17230
** Alterado em...........: 26/05/2000 16:50:28
*****************************************************************************/
PROCEDURE pi_bt_ran2:

    view frame f_dlg_01_tit_ap_bcio_faixa.

    assign v_log_faixa_ok  = no.

    enable all with frame f_dlg_01_tit_ap_bcio_faixa.

    display bt_can
            bt_hel2
            bt_ok
            bt_zoo2
            bt_zoo3
            v_cdn_fornecedor_fim
            v_cdn_fornecedor_ini
            v_cod_estab_fim
            v_cod_estab_ini
            v_cod_id_feder
            v_cod_id_feder_apb_fim
            v_dat_entr_sist_fim
            v_dat_entr_sist_ini
            v_dat_vencto_fim
            v_dat_vencto_ini
            v_nom_fornecedor_fim
            v_nom_fornecedor_ini
            v_val_tit_ap_bcio_fim
            v_val_tit_ap_bcio_ini
            with frame f_dlg_01_tit_ap_bcio_faixa.

    repeat while v_log_faixa_ok = no:

        if  valid-handle(v_wgh_focus) then
            wait-for go of frame f_dlg_01_tit_ap_bcio_faixa focus v_wgh_focus.
        else
            wait-for go of frame f_dlg_01_tit_ap_bcio_faixa.

    end.    

    if  v_log_tit_ap_bcio_habilita = yes
    then do:
        assign v_log_tit_ap_bcio_atualiza = yes.
        enable bt_check
               with frame f_dlg_03_varredura_sacado.
    end /* if */.

    hide frame f_dlg_01_tit_ap_bcio_faixa.
END PROCEDURE. /* pi_bt_ran2 */
/*****************************************************************************
** Procedure Interna.....: pi_bt_ran6
** Descricao.............: pi_bt_ran6
** Criado por............: bre17230
** Criado em.............: 26/05/2000 16:50:17
** Alterado por..........: fut35118
** Alterado em...........: 10/09/2007 17:15:24
*****************************************************************************/
PROCEDURE pi_bt_ran6:

    view frame f_dlg_01_tit_ap_faixa.

    assign v_log_tit_ap_faixa_ok  = no.

    enable bt_can
           bt_hel2
           bt_ok
           bt_select_br_all
           bt_todos_img_2
           bt_todos_img_3
           v_cod_estab_apb_fim
           v_cod_estab_apb_inic
           v_dat_emis_apb_fim
           v_dat_emis_apb_inic
           v_dat_vencto_apb_fim
           v_dat_vencto_apb_inic
           v_val_origin_apb_fim
           v_val_origin_apb_inic
           with frame f_dlg_01_tit_ap_faixa.

    display bt_can
            bt_hel2
            bt_ok
            bt_select_br_all
            bt_todos_img_2
            bt_todos_img_3
            v_cod_espec_multi_sel_tela
            v_cod_estab_apb_fim
            v_cod_estab_apb_inic
            v_cod_forma_pagto_multi_sel_tela
            v_cod_portad_multi_sel_tela
            v_dat_emis_apb_fim
            v_dat_emis_apb_inic
            v_dat_vencto_apb_fim
            v_dat_vencto_apb_inic
            v_val_origin_apb_fim
            v_val_origin_apb_inic
            with frame f_dlg_01_tit_ap_faixa.

    repeat while v_log_tit_ap_faixa_ok = no:

        if  valid-handle(v_wgh_focus) then
            wait-for go of frame f_dlg_01_tit_ap_faixa focus v_wgh_focus.
        else
            wait-for go of frame f_dlg_01_tit_ap_faixa.          
    end.    

    if  v_log_tit_ap_habilita = yes
    then do:
        assign v_log_tit_ap_atualiza = yes.
        enable bt_check7
               with frame f_dlg_03_varredura_sacado.
    end /* if */.

    hide frame f_dlg_01_tit_ap_faixa.
END PROCEDURE. /* pi_bt_ran6 */
/*****************************************************************************
** Procedure Interna.....: pi_right_mouse_up_dialog_box
** Descricao.............: pi_right_mouse_up_dialog_box
** Criado por............: bre16039
** Criado em.............: 16/04/2001 11:53:59
** Alterado por..........: bre16039
** Alterado em...........: 16/04/2001 14:30:06
*****************************************************************************/
PROCEDURE pi_right_mouse_up_dialog_box:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END PROCEDURE. /* pi_right_mouse_up_dialog_box */
/*****************************************************************************
** Procedure Interna.....: pi_open_tt_tit_ap_em_bco_2
** Descricao.............: pi_open_tt_tit_ap_em_bco_2
** Criado por............: src12151
** Criado em.............: 05/01/2005 15:54:51
** Alterado por..........: fut41675_3
** Alterado em...........: 12/04/2010 14:23:44
*****************************************************************************/
PROCEDURE pi_open_tt_tit_ap_em_bco_2:

    /* Faz duas l¢gicas de For para otimizar a busca dos registros.
    Pois o Progress n∆o consegue gerenciar procuras com Range
    */
    if v_cdn_fornecedor_ini = v_cdn_fornecedor_fim then do:
        cria_tt_1:
        for each tit_ap_bcio no-lock
            where tit_ap_bcio.cod_estab          = estabelecimento.cod_estab
              and tit_ap_bcio.cod_sist_nac_bcio >= v_cod_banco_ini
              and tit_ap_bcio.cod_sist_nac_bcio <= v_cod_banco_fim
              and tit_ap_bcio.cdn_fornecedor     = v_cdn_fornecedor_ini 
              and tit_ap_bcio.dat_vencto        >= v_dat_vencto_ini 
              and tit_ap_bcio.dat_vencto        <= v_dat_vencto_fim:
            run pi_open_tt_tit_ap_em_bco_3.
        end.
    end.
    else do:
    cria_tt_2:
        for each tit_ap_bcio no-lock
            where tit_ap_bcio.cod_estab          = estabelecimento.cod_estab
              and tit_ap_bcio.cod_sist_nac_bcio >= v_cod_banco_ini
              and tit_ap_bcio.cod_sist_nac_bcio <= v_cod_banco_fim
              and tit_ap_bcio.cdn_fornecedor    >= v_cdn_fornecedor_ini 
              and tit_ap_bcio.cdn_fornecedor    <= v_cdn_fornecedor_fim               
              and tit_ap_bcio.dat_vencto        >= v_dat_vencto_ini 
              and tit_ap_bcio.dat_vencto        <= v_dat_vencto_fim:
            run pi_open_tt_tit_ap_em_bco_3.
        end.
    end.


END PROCEDURE. /* pi_open_tt_tit_ap_em_bco_2 */
/*****************************************************************************
** Procedure Interna.....: pi_ajust_object_frame_dlg_03_varredura_sacado
** Descricao.............: pi_ajust_object_frame_dlg_03_varredura_sacado
** Criado por............: src12151
** Criado em.............: 15/05/2005 15:03:24
** Alterado por..........: fut40695
** Alterado em...........: 10/02/2010 17:24:50
*****************************************************************************/
PROCEDURE pi_ajust_object_frame_dlg_03_varredura_sacado:

    /************************* Variable Definition Begin ************************/

    def var v_hdl_col_3
        as Handle
        format ">>>>>>9":U
        no-undo.
    def var v_num_coluna
        as integer
        format ">>>>,>>9":U
        label "Coluna"
        column-label "Coluna"
        no-undo.


    /************************** Variable Definition End *************************/

    /* Criando os objetos dinamicamente */
    if  valid-handle(v_wgh_label_ini)
    then do:
        delete widget v_wgh_label_ini.
    end /* if */.
    if  valid-handle(v_wgh_label_fim)
    then do:
        delete widget v_wgh_label_fim.
    end /* if */.
    if  valid-handle(v_wgh_fill_in_ini)
    then do:
        delete widget v_wgh_fill_in_ini.
    end /* if */.
    if  valid-handle(v_wgh_fill_in_fim)
    then do:
        delete widget v_wgh_fill_in_fim.
    end /* if */.

    create text v_wgh_label_ini
        assign frame        = frame f_dlg_03_varredura_sacado:handle
               format       = 'x(27)':U
               screen-value = "C¢digo do Sistema Banc†rio" /*l_codigo_sistema_bancario*/  + ":" /*l_:*/ 
               visible      = no
               row          = 01.52
               col          = 04.29
               width        = 20.
{include/i_fcldin.i v_wgh_label_ini }

    create text v_wgh_label_fim
        assign frame        = frame f_dlg_03_varredura_sacado:handle
               screen-value = "atÇ:" /*l_ate:*/ 
               visible      = no
               row          = 01.52
               col          = 35.43
               width        = 3.
{include/i_fcldin.i v_wgh_label_fim }

    create fill-in v_wgh_fill_in_ini
        assign frame              = frame f_dlg_03_varredura_sacado:handle
               data-type          = 'character'
               format             = 'x(8)':U
               width              = 9.8
               side-label-handle  = v_wgh_label_ini:handle
               row                = 01.42
               col                = 24.29
               bgcolor            = 15
               font               = 2
               height             = 0.88
               screen-value       = ''
               visible            = yes
               sensitive          = yes.
{include/i_fcldin.i v_wgh_fill_in_ini }

    create fill-in v_wgh_fill_in_fim
        assign frame              = frame f_dlg_03_varredura_sacado:handle
               data-type          = 'character'
               format             = 'x(8)':U
               width              = 9.8
               side-label-handle  = v_wgh_label_fim:handle
               row                = 01.42
               col                = 38.43
               bgcolor            = 15
               font               = 2
               height             = 0.88
               screen-value       = "ZZZZZZZZ" /*l_zzzzzzzz*/ 
               visible            = yes
               sensitive          = yes.
{include/i_fcldin.i v_wgh_fill_in_fim }

    assign v_hdl_col_3       = br_tit_ap_em_bco_bank:get-browse-column(3)
           v_hdl_col_3:label = "Sist. Bcio."
           v_hdl_col_3:width = 8.

    /* Escondendo os objetos n∆o utilizados pela nova funá∆o */
    assign v_cdn_sist_nac_bcio:visible    in frame f_dlg_03_varredura_sacado = no.

    /* Redimensionando tamnho do retÉngulo dos bot‰es superiores */
    assign v_num_coluna = rt_006:col in frame f_dlg_03_varredura_sacado - 50.30
           rt_006:col         in frame f_dlg_03_varredura_sacado = 50.30
           rt_006:width-chars in frame f_dlg_03_varredura_sacado = v_num_coluna + rt_006:width-chars in frame f_dlg_03_varredura_sacado.

    assign bt_concil_autom_titulos:col in frame f_dlg_03_varredura_sacado = bt_localiza:col in frame f_dlg_03_varredura_sacado - bt_param1_im:width-chars in frame f_dlg_03_varredura_sacado
           bt_legenda:col              in frame f_dlg_03_varredura_sacado = bt_localiza:col in frame f_dlg_03_varredura_sacado - (bt_param1_im:width-chars in frame f_dlg_03_varredura_sacado * 2)
           bt_param1_im:col            in frame f_dlg_03_varredura_sacado = bt_localiza:col in frame f_dlg_03_varredura_sacado - (bt_param1_im:width-chars in frame f_dlg_03_varredura_sacado * 3).
END PROCEDURE. /* pi_ajust_object_frame_dlg_03_varredura_sacado */
/*****************************************************************************
** Procedure Interna.....: pi_busca_matriz_fornecedor
** Descricao.............: pi_busca_matriz_fornecedor
** Criado por............: src12151
** Criado em.............: 15/05/2005 15:52:22
** Alterado por..........: jeffersonsil
** Alterado em...........: 30/10/2015 09:33:27
*****************************************************************************/
PROCEDURE pi_busca_matriz_fornecedor:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_fornecedor_apb
        as Integer
        format ">>>,>>>,>>9"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_log_empresa
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    for each tt_fornecedor_matriz:
        delete tt_fornecedor_matriz.
    end.

    if p_log_empresa = yes then do:
        for each tt_estab_select:
            delete tt_estab_select.
        end.

        for each tt_empresa_selec:
            delete tt_empresa_selec.
        end.

        find first estabelecimento no-lock
            where  estabelecimento.cod_estab = p_cod_estab no-error.
        if avail estabelecimento then do:

            if not can-find(first tt_empresa_selec
                            where tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa) then do:
                create tt_empresa_selec.
                assign tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa.
            end.

            create tt_estab_select.
            assign tt_estab_select.tta_cod_empresa = estabelecimento.cod_empresa
                   tt_estab_select.tta_cod_estab   = estabelecimento.cod_estab.
        end.
    end.
    &IF DEFINED(BF_FIN_MATRIZ_PESSOA) &THEN
    find first fornecedor no-lock
        where  fornecedor.cdn_fornecedor = p_cdn_fornecedor_apb no-error.
    if avail fornecedor then do:
        find first b_pessoa_jurid no-lock  
            where  b_pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa no-error. 
        if  avail b_pessoa_jurid then do:
            find first b_fornecedor no-lock 
                where b_fornecedor.cod_empresa = fornecedor.cod_empresa
                  and b_fornecedor.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid_matriz no-error. 
            if  avail b_fornecedor then do:
                run pi_busca_matriz_fornecedor_aux (Input b_fornecedor.num_pessoa) /*pi_busca_matriz_fornecedor_aux*/.
            end.
        end.
        find first b_pessoa_fisic no-lock  
            where  b_pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa no-error. 
        if  avail b_pessoa_fisic then do: 

            find first b_fornecedor no-lock 
                where b_fornecedor.cod_empresa = fornecedor.cod_empresa
                  and b_fornecedor.num_pessoa  = b_pessoa_fisic.num_pessoa_fisic_matriz no-error. 
            if  avail b_fornecedor then do:
                run pi_busca_matriz_fornecedor_aux (Input b_fornecedor.num_pessoa) /*pi_busca_matriz_fornecedor_aux*/.
            end.
        end.
    end.
    &ELSE
    find first fornecedor no-lock
        where  fornecedor.cdn_fornecedor = p_cdn_fornecedor_apb no-error.
    
    if avail fornecedor then do:
        find first b_pessoa_jurid no-lock  
            where  b_pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa no-error. 
        if  avail b_pessoa_jurid then do: 

            find first b_fornecedor no-lock 
                where b_fornecedor.cod_empresa = fornecedor.cod_empresa
                  and b_fornecedor.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid_matriz no-error. 
            if  avail b_fornecedor then do:
                find pessoa_jurid no-lock 
                    where pessoa_jurid.num_pessoa_jurid = b_fornecedor.num_pessoa no-error. 
                if  avail pessoa_jurid then do:
                    for each  pessoa_jurid no-lock
                        where pessoa_jurid.num_pessoa_jurid_matriz = b_pessoa_jurid.num_pessoa_jurid_matriz:
                        for each tt_empresa_selec:
                            for each  fornecedor no-lock
                                where fornecedor.cod_empresa  = tt_empresa_selec.tta_cod_empresa
                                  and fornecedor.num_pessoa   = pessoa_jurid.num_pessoa_jurid 
                                  /*and fornecedor.nom_pessoa   = pessoa_jurid.nom_pessoa*/
                                  and fornecedor.cod_id_feder = pessoa_jurid.cod_id_feder: 

                                if  can-find(first tt_fornecedor_matriz
                                             where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                               and tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                                create tt_fornecedor_matriz.
                                assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                       tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                                       tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                                       tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
                            end.
                        end.
                    end.
                end.
            end.
        end.
    end.
    &ENDIF
END PROCEDURE. /* pi_busca_matriz_fornecedor */
/*****************************************************************************
** Procedure Interna.....: pi_bt_mod_tit_ap
** Descricao.............: pi_bt_mod_tit_ap
** Criado por............: src12151
** Criado em.............: 17/05/2005 19:37:12
** Alterado por..........: fut1236_3
** Alterado em...........: 27/06/2006 08:32:53
*****************************************************************************/
PROCEDURE pi_bt_mod_tit_ap:

    save_block:
    do on error undo save_block, leave save_block:

        if  not avail tt_tit_ap_conciliacao
        then do:
            undo save_block, leave save_block.
        end.

        assign v_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap.

        find first tit_ap no-lock
            where  recid(tit_ap) = v_rec_tit_ap no-error.

        if can-find(first proces_pagto 
              where proces_pagto.cod_estab            = tit_ap.cod_estab
                and proces_pagto.cod_espec_docto      = tit_ap.cod_espec_docto
                and proces_pagto.cod_ser_docto        = tit_ap.cod_ser_docto
                and proces_pagto.cdn_fornecedor       = tit_ap.cdn_fornecedor
                and proces_pagto.cod_tit_ap           = tit_ap.cod_tit_ap
                and proces_pagto.cod_parcela          = tit_ap.cod_parcela
                and proces_pagto.ind_sit_proces_pagto <> "Confirmado" /*l_confirmado*/ )
                and tit_ap.log_pagto_bloqdo = yes then do:
            /* T°tulo &1, parcela &2 est† em Processo de Pagamento ! */
            run pi_messages (input 'show',
                             input 5437,
                             input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                tit_ap.cod_tit_ap, tit_ap.cod_parcela)) /* msg_5437*/.
            undo save_block, leave save_block.
        end.
        if v_log_layout_sacad then
            if  search("prgfin/apb/apb717ec.r") = ? and search("prgfin/apb/apb717ec.p") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb717ec.p".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb717ec.p"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/apb/apb717ec.p /*prg_mod_tit_ap*/.
        else do:    
            assign v_cod_barra    = tit_ap.cb4_tit_ap_bco_cobdor
                   v_cod_num_bcio = "" /*l_null*/ .

            &if '{&emsfin_version}' > '5.01' &then
                assign v_cod_num_bcio = tit_ap.cod_tit_ap_bco_cobdor.
            &endif    

            if  search('prgfin/apb/apb008za.r') = ? and search('prgfin/apb/apb008za.p') = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return 'Programa execut†vel n∆o foi encontrado:' /* l_programa_nao_encontrado*/  + 'prgfin/apb/apb008za.p'.
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb008za.p"
                           view-as alert-box error buttons ok.
                    undo save_block, leave save_block.
                end.
            end.
            else
                run prgfin/apb/apb008za.p (input-output v_cod_barra,
                                           input-output v_cod_num_bcio) /* prg_fnc_codigo_barra*/.


            if  v_cod_barra    = tit_ap.cb4_tit_ap_bco_cobdor 
            and v_cod_num_bcio = tit_ap.cod_tit_ap_bco_cobdor then
                undo save_block, leave save_block.

            run pi_atualizar_tt_tit_ap_alteracao_base_aux_3.

            run pi_alter_tit_apb.
            if return-value = "NOK" /*l_nok*/  then
                undo save_block, leave save_block.

            if  session:set-wait-state('general') then.

            run pi_open_tt_tit_ap_em_bco.
            run pi_open_tt_tit_ap_conciliacao.
        end.

        if session:set-wait-state('') then.
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_bt_mod_tit_ap */
/*****************************************************************************
** Procedure Interna.....: pi_bt_localiz_fornec
** Descricao.............: pi_bt_localiz_fornec
** Criado por............: src12151
** Criado em.............: 17/05/2005 19:33:59
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:16:02
*****************************************************************************/
PROCEDURE pi_bt_localiz_fornec:

    if  not avail tt_tit_ap_em_bco
    then do:        
        return "OK" /*l_ok*/ .
    end.

    if  session:set-wait-state('general') then.

    for each  tt_tit_ap_em_bco no-lock
        where tt_tit_ap_em_bco.tta_cdn_fornecedor = 0:

        /* Localizar o fornecedor, pelo id-feder */
        find first fornecedor exclusive-lock
            where  fornecedor.cod_id_feder = tt_tit_ap_em_bco.tta_cod_id_feder no-error.
        if avail fornecedor then do:
            find first tit_ap_bcio exclusive-lock
                where  tit_ap_bcio.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
                and    tit_ap_bcio.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
                and    tit_ap_bcio.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco 
                and    tit_ap_bcio.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco no-error.
            if avail tit_ap_bcio then
                assign tit_ap_bcio.cdn_fornecedor = fornecedor.cdn_fornecedor
                       tt_tit_ap_em_bco.tta_cdn_fornecedor = fornecedor.cdn_fornecedor.
        end.
    end.

    run pi_open_tt_tit_ap_em_bco.
    run pi_open_tt_tit_ap_conciliacao.

    if  session:set-wait-state('') then.    

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_bt_localiz_fornec */
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao_autom_titulos_matriz
** Descricao.............: pi_conciliacao_autom_titulos_matriz
** Criado por............: src12151
** Criado em.............: 05/01/2005 17:43:20
** Alterado por..........: fut40574
** Alterado em...........: 22/03/2011 17:22:50
*****************************************************************************/
PROCEDURE pi_conciliacao_autom_titulos_matriz:

    /************************* Variable Definition Begin ************************/

    def var v_cdn_fornec
        as Integer
        format ">>9":U
        label "Fornecedor"
        column-label "Fornecedor"
        no-undo.
    def var v_val_origin_tit_ap
        as decimal
        format "->>>,>>>,>>9.99":U
        decimals 2
        label "Valor Original"
        column-label "Valor Original"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count_concil = 1
           v_cdn_fornec       = 0.

    for each tt_concil_autom:
        delete tt_concil_autom.
    end.

    /* regra: */
    case input frame f_dlg_01_concil_autom rs_regra_concil_autom:
        when "Matriz/Filial" /*l_matriz_filial*/  then concil_5:
         do:
            for each  btt_tit_ap_em_bco
                where btt_tit_ap_em_bco.tta_log_concil = no:

                if v_cdn_fornec <> btt_tit_ap_em_bco.tta_cdn_fornecedor then do:
                    assign v_cdn_fornec = btt_tit_ap_em_bco.tta_cdn_fornecedor.
                    run pi_busca_matriz_fornecedor (input btt_tit_ap_em_bco.tta_cdn_fornecedor,
                                                    input btt_tit_ap_em_bco.tta_cod_estab,
                                                    input yes).
                end.

                for each  tt_fornecedor_matriz:
                    for each  b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_empresa    = v_cod_empres_usuar
                        and   b_tit_ap_concil.cdn_fornecedor = tt_fornecedor_matriz.cdn_fornecedor
                        and   b_tit_ap_concil.log_concil     = no
                        and   b_tit_ap_concil.val_sdo_tit_ap > 0:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                    end.
                end.
            end.
        end.

        when "Matriz/Filial/Valor" /*l_matriz_filial_valor*/  then concil_6:
         do:
            for each btt_tit_ap_em_bco
                where btt_tit_ap_em_bco.tta_log_concil = no:

                if v_cdn_fornec <> btt_tit_ap_em_bco.tta_cdn_fornecedor then do:
                    assign v_cdn_fornec = btt_tit_ap_em_bco.tta_cdn_fornecedor.
                    run pi_busca_matriz_fornecedor (input btt_tit_ap_em_bco.tta_cdn_fornecedor,
                                                    input btt_tit_ap_em_bco.tta_cod_estab,
                                                    input yes).
                end.

                for each  tt_fornecedor_matriz:
                    for each  b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_empresa       = v_cod_empres_usuar
                        and   b_tit_ap_concil.cdn_fornecedor    = tt_fornecedor_matriz.cdn_fornecedor
                        and   b_tit_ap_concil.log_concil        = no
                        and   b_tit_ap_concil.val_sdo_tit_ap    > 0:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                        or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                            next.

                        run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                    end.
                end.
            end.    
        end.

        when "Matriz/Filial/Data Vencto" /*l_matriz_filial_dat_vencto*/  then concil_7:
         do:
            for each btt_tit_ap_em_bco
                where btt_tit_ap_em_bco.tta_log_concil = no:        

                if v_cdn_fornec <> btt_tit_ap_em_bco.tta_cdn_fornecedor then do:
                    assign v_cdn_fornec = btt_tit_ap_em_bco.tta_cdn_fornecedor.
                    run pi_busca_matriz_fornecedor (input btt_tit_ap_em_bco.tta_cdn_fornecedor,
                                                    input btt_tit_ap_em_bco.tta_cod_estab,
                                                    input yes).
                end.

                for each  tt_fornecedor_matriz:
                    for each  b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_empresa       = v_cod_empres_usuar
                        and   b_tit_ap_concil.cdn_fornecedor    = tt_fornecedor_matriz.cdn_fornecedor
                        and   b_tit_ap_concil.log_concil        = no
                        and   b_tit_ap_concil.val_sdo_tit_ap    > 0
                        and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                        and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                    end.
                end.
            end.    
        end.

        when "Matriz/Filial/Valor/Data Vencto" /*l_matriz_filial_valor_dat_vencto*/  then concil_8:
         do:
            for each btt_tit_ap_em_bco
                where btt_tit_ap_em_bco.tta_log_concil = no:        

                if v_cdn_fornec <> btt_tit_ap_em_bco.tta_cdn_fornecedor then do:
                    assign v_cdn_fornec = btt_tit_ap_em_bco.tta_cdn_fornecedor.
                    run pi_busca_matriz_fornecedor (input btt_tit_ap_em_bco.tta_cdn_fornecedor,
                                                    input btt_tit_ap_em_bco.tta_cod_estab,
                                                    input yes).
                end.

                for each  tt_fornecedor_matriz:
                    for each  b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_empresa       = v_cod_empres_usuar
                        and   b_tit_ap_concil.cdn_fornecedor    = tt_fornecedor_matriz.cdn_fornecedor
                        and   b_tit_ap_concil.log_concil        = no
                        and   b_tit_ap_concil.val_sdo_tit_ap    > 0
                        and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                        and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                        or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                            next.

                        run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                    end.
                end.
            end.    
        end.
        when "Matriz/Filial/Valor/Data Vencto/T°tulo" /*l_matriz_filial_valor_dat_vencto_T°tulo*/  then concil_8:
         do:
            for each btt_tit_ap_em_bco
                where btt_tit_ap_em_bco.tta_log_concil = no:        

                if v_cdn_fornec <> btt_tit_ap_em_bco.tta_cdn_fornecedor then do:
                    assign v_cdn_fornec = btt_tit_ap_em_bco.tta_cdn_fornecedor.
                    run pi_busca_matriz_fornecedor (input btt_tit_ap_em_bco.tta_cdn_fornecedor,
                                                    input btt_tit_ap_em_bco.tta_cod_estab,
                                                    input yes).
                end.

                for each  tt_fornecedor_matriz:
                    for each  b_tit_ap_concil no-lock
                        where b_tit_ap_concil.cod_empresa       = v_cod_empres_usuar
                        and   b_tit_ap_concil.cdn_fornecedor    = tt_fornecedor_matriz.cdn_fornecedor
                        and   b_tit_ap_concil.log_concil        = no
                        and   b_tit_ap_concil.val_sdo_tit_ap    > 0
                        and   b_tit_ap_concil.dat_vencto_tit_ap >= btt_tit_ap_em_bco.tta_dat_vencto - v_num_dias_aprox
                        and   b_tit_ap_concil.dat_vencto_tit_ap <= btt_tit_ap_em_bco.tta_dat_vencto + v_num_dias_aprox:

                        run pi_vld_titulos_prev_prov_antecip (Input b_tit_ap_concil.cod_espec_docto) /* pi_vld_titulos_prev_prov_antecip*/.
                        if  return-value = "NOK" /*l_nok*/  THEN
                            NEXT.

                        run pi_retorna_valor_orig_tit_ap(buffer b_tit_ap_concil,
                                                         output v_val_origin_tit_ap).

                        if v_val_origin_tit_ap < btt_tit_ap_em_bco.tta_val_tit_ap_bcio - (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100)
                        or v_val_origin_tit_ap > btt_tit_ap_em_bco.tta_val_tit_ap_bcio + (btt_tit_ap_em_bco.tta_val_tit_ap_bcio * v_val_percent_variac_val / 100) then
                            next.

                        IF  b_tit_ap_concil.cod_tit_ap <> btt_tit_ap_em_bco.tta_cod_tit_ap_bco THEN NEXT.

                        run pi_cria_tt_concil_autom(input v_val_origin_tit_ap).
                    end.
                end.
            end.    
         END.
    end.

    find first tt_concil_autom no-lock no-error.
    if  avail tt_concil_autom
    then do:
        run pi_conciliacao_autom_titulos_conf.
    end.
    else do:
        /* Se o usu†rio escolher n∆o confirmar as conciliaá∆o, n∆o h†ˇ necessidade de mostrar mensagem de alerta. */
        if  input frame f_dlg_01_concil_autom v_log_confir_concil = yes
        then do:
            /* N∆o existem T°tulos Banc†rios para a Classificaá∆o ! */
            run pi_messages (input 'show',
                             input 9776,
                             input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_9776*/.
            return "NOK" /*l_nok*/ .
        end.
    end.

    return "OK" /*l_ok*/ .

END PROCEDURE. /* pi_conciliacao_autom_titulos_matriz */
/*****************************************************************************
** Procedure Interna.....: pi_alter_tit_apb
** Descricao.............: pi_alter_tit_apb
** Criado por............: src12151
** Criado em.............: 17/05/2005 20:37:15
** Alterado por..........: danielidk
** Alterado em...........: 18/08/2014 11:13:18
*****************************************************************************/
PROCEDURE pi_alter_tit_apb:

    run prgfin/apb/apb767zf.py persistent set v_hdl_prog.

    if  session:set-wait-state('general') then.

    run pi_main_code_api_integr_ap_alter_tit_ap_4 IN v_hdl_prog (Input 1,
                                                                 Input v_cod_modulo,
                                                                 Input v_cod_matriz_trad_org_ext,
                                                                 input-output table tt_tit_ap_alteracao_base_aux_3,
                                                                 input-output table tt_tit_ap_alteracao_rateio,
                                                                 output table tt_log_erros_tit_ap_alteracao).

    if  session:set-wait-state('') then.

    delete procedure v_hdl_prog.

    for each tt_tit_ap_alteracao_base_aux_3:
        delete tt_tit_ap_alteracao_base_aux_3.
    end.

    /* Mensagens de Pergunta */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb = 'QUESTION' no-error.
    if avail tt_log_erros_tit_ap_alteracao then do:
        run pi_messages (input 'show',
                         input 12913,
                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                           tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro, tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda)).
        assign v_log_answer = (if   return-value = 'yes' then yes
                               else if return-value = 'no' then no
                               else ?).
        if v_log_answer <> yes then do:
           return 'NOK'.
        end.   
    end.

    /* Mensagens de Alerta */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb =  'INFORMATION' no-error.
    if  avail tt_log_erros_tit_ap_alteracao
    and tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6788 then do:
        /* &1 ! */
        run pi_messages (input 'show',
                         input 588,
                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                            tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro, tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda)).
    end.

    /* Mensagens de Alerta de um poss°vel erro */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb = 'WARNING' no-error.
    if avail tt_log_erros_tit_ap_alteracao then
        /* &1 ! */
        run pi_messages (input 'show',
                         input 588,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro, tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda)).

    /* Mensagens de Erro */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb = 'ERROR' no-error.
    if avail tt_log_erros_tit_ap_alteracao then do:
        /* &1 ! */
        run pi_messages (input 'show',
                         input 524,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro, tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda)).
        return 'NOK'.
    end.

    /* Cancelamento da alteraá∆o efetuado por uma aá∆o do usu†rio */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 590
        no-error.
    if  avail tt_log_erros_tit_ap_alteracao
    then do:
        run pi_messages (input 'show',
                         input 590,
                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                            tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro)).
        return 'NOK'.
    end /* if */.    

    /* Erro em branco para quando o apb767ze retorna erro da trigger de movto_tit_ap */
    find first tt_log_erros_tit_ap_alteracao no-lock
        where tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 0 no-error.
    if  avail tt_log_erros_tit_ap_alteracao
    then do:
        return 'NOK'.
    end /* if */.


    return 'OK'.

END PROCEDURE. /* pi_alter_tit_apb */
/*****************************************************************************
** Procedure Interna.....: pi_atualizar_tt_tit_ap_alteracao_base_aux_3
** Descricao.............: pi_atualizar_tt_tit_ap_alteracao_base_aux_3
** Criado por............: src12151
** Criado em.............: 17/05/2005 20:42:31
** Alterado por..........: andrefossile
** Alterado em...........: 03/04/2012 18:00:32
*****************************************************************************/
PROCEDURE pi_atualizar_tt_tit_ap_alteracao_base_aux_3:

    /************************* Variable Definition Begin ************************/

    def var v_log_refer_unico                as logical         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    create tt_tit_ap_alteracao_base_aux_3.
    assign tt_tit_ap_alteracao_base_aux_3.tta_cod_empresa                      = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_3.tta_cod_estab                        = tit_ap.cod_estab 
           tt_tit_ap_alteracao_base_aux_3.tta_cdn_fornecedor                   = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_3.tta_cod_espec_docto                  = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_3.tta_cod_ser_docto                    = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap                       = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_3.tta_cod_parcela                      = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_3.tta_num_id_tit_ap                    = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_3.ttv_dat_transacao                    = today
           tt_tit_ap_alteracao_base_aux_3.tta_val_sdo_tit_ap                   = tit_ap.val_sdo_tit_ap
           tt_tit_ap_alteracao_base_aux_3.tta_cod_portador                     = tit_ap.cod_portador
           tt_tit_ap_alteracao_base_aux_3.tta_dat_emis_docto                   = tit_ap.dat_emis_docto
           tt_tit_ap_alteracao_base_aux_3.tta_dat_vencto_tit_ap                = tit_ap.dat_vencto_tit_ap
           tt_tit_ap_alteracao_base_aux_3.tta_dat_prev_pagto                   = tit_ap.dat_prev_pagto      
           tt_tit_ap_alteracao_base_aux_3.tta_cod_indic_econ                   = tit_ap.cod_indic_econ
           tt_tit_ap_alteracao_base_aux_3.tta_num_dias_atraso                  = tit_ap.num_dias_atraso       
           tt_tit_ap_alteracao_base_aux_3.tta_val_perc_multa_atraso            = tit_ap.val_perc_multa_atraso
           tt_tit_ap_alteracao_base_aux_3.tta_val_juros_dia_atraso             = tit_ap.val_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_3.tta_val_perc_juros_dia_atraso        = tit_ap.val_perc_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_3.tta_dat_desconto                     = tit_ap.dat_desconto
           tt_tit_ap_alteracao_base_aux_3.tta_val_perc_desc                    = tit_ap.val_perc_desc
           tt_tit_ap_alteracao_base_aux_3.tta_val_desconto                     = tit_ap.val_desconto       
           tt_tit_ap_alteracao_base_aux_3.tta_log_pagto_bloqdo                 = tit_ap.log_pagto_bloqdo
           tt_tit_ap_alteracao_base_aux_3.tta_ind_sit_tit_ap                   = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_3.tta_cod_seguradora                   = tit_ap.cod_seguradora
           tt_tit_ap_alteracao_base_aux_3.tta_cod_apol_seguro                  = tit_ap.cod_apol_seguro
           tt_tit_ap_alteracao_base_aux_3.tta_cod_arrendador                   = tit_ap.cod_arrendador
           tt_tit_ap_alteracao_base_aux_3.tta_cod_contrat_leas                 = tit_ap.cod_contrat_leas
           tt_tit_ap_alteracao_base_aux_3.tta_cb4_tit_ap_bco_cobdor            = v_cod_barra
           tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap_bco_cobdor            = v_cod_num_bcio
           tt_tit_ap_alteracao_base_aux_3.tta_cod_forma_pagto                  = tit_ap.cod_forma_pagto
           tt_tit_ap_alteracao_base_aux_3.tta_cod_histor_padr                  = v_cod_histor_padr
           tt_tit_ap_alteracao_base_aux_3.tta_des_histor_padr                  = v_des_text_histor
           tt_tit_ap_alteracao_base_aux_3.tta_num_ord_invest                   = ?
           tt_tit_ap_alteracao_base_aux_3.ttv_num_ped_compra                   = ?
           tt_tit_ap_alteracao_base_aux_3.tta_num_ord_compra                   = ?
           tt_tit_ap_alteracao_base_aux_3.ttv_num_event_invest                 = ?.

    assign v_cod_refer = "".
    refer_unico:
    repeat:
        assign v_num_cont = v_num_cont + 1.
        run pi_retorna_sugestao_referencia (Input "T" /*l_T*/ ,
                                            Input today,
                                            output v_cod_refer).

        run pi_verifica_refer_unica_apb (Input tt_tit_ap_alteracao_base_aux_3.tta_cod_estab,
                                         Input v_cod_refer,
                                         Input "Movimento T°tulos do Contas Ö Pagar" /*l_movto_tit_ap*/ ,
                                         Input 0,
                                         output v_log_refer_unico) /* pi_verifica_refer_unica_apb*/.

        if  v_log_refer_unico then
            leave refer_unico.

    end.    
    assign tt_tit_ap_alteracao_base_aux_3.ttv_cod_refer = v_cod_refer.

END PROCEDURE. /* pi_atualizar_tt_tit_ap_alteracao_base_aux_3 */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
** Criado por............: Barth
** Criado em.............: 21/10/1998 09:14:30
** Alterado por..........: Souza
** Alterado em...........: 18/05/1999 10:12:58
*****************************************************************************/
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
END PROCEDURE. /* pi_retorna_sugestao_referencia */
/*****************************************************************************
** Procedure Interna.....: pi_value_changed_rs_regra_concil_autom
** Descricao.............: pi_value_changed_rs_regra_concil_autom
** Criado por............: fut12151
** Criado em.............: 16/11/2005 17:07:22
** Alterado por..........: fut12151
** Alterado em...........: 16/11/2005 17:08:02
*****************************************************************************/
PROCEDURE pi_value_changed_rs_regra_concil_autom:

    /* rs_regra: */
    case input frame f_dlg_01_concil_autom rs_regra_concil_autom:
        when "Fornecedor" /*l_fornecedor*/      or
        when "Matriz/Filial" /*l_matriz_filial*/ then rs_regra_1:
     do:
            assign v_num_dias_aprox         = 0
                   v_val_percent_variac_val = 0.
            display v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.       
            disable v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.
        end /* do rs_regra_1 */.

        when "Fornecedor/Valor" /*l_fornecedor_valor*/      or
        when "Matriz/Filial/Valor" /*l_matriz_filial_valor*/ then rs_regra_2:
     do:
            assign v_num_dias_aprox         = 0
                   v_val_percent_variac_val = 0.    
            display v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.                          
            enable v_val_percent_variac_val
                   with frame f_dlg_01_concil_autom.
            disable v_num_dias_aprox
                    with frame f_dlg_01_concil_autom.
        end /* do rs_regra_2 */.

        when "Fornecedor/Data Vencto" /*l_fornecedor_vencto*/      or
        when "Matriz/Filial/Data Vencto" /*l_matriz_filial_dat_vencto*/ then rs_regra_3:
     do:
            assign v_num_dias_aprox         = 0
                   v_val_percent_variac_val = 0.    
            display v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.
            enable v_num_dias_aprox
                   with frame f_dlg_01_concil_autom.
            disable v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.
        end /* do rs_regra_3 */.

        when "Fornecedor/Valor/Data Vencto" /*l_fornecedor_valor_vencto*/      or
        when "Matriz/Filial/Valor/Data Vencto" /*l_matriz_filial_valor_dat_vencto*/ then rs_regra_4:
     do:
            assign v_num_dias_aprox         = 0
                   v_val_percent_variac_val = 0.    
            display v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.
            enable v_num_dias_aprox
                   v_val_percent_variac_val
                   with frame f_dlg_01_concil_autom.
        end /* do rs_regra_4 */.            
        when "Matriz/Filial/Valor/Data Vencto/T°tulo" /*l_matriz_filial_valor_dat_vencto_t°tulo*/ then rs_regra_5:
     do:
            assign v_num_dias_aprox         = 0
                   v_val_percent_variac_val = 0.    
            display v_num_dias_aprox
                    v_val_percent_variac_val
                    with frame f_dlg_01_concil_autom.
            enable v_num_dias_aprox
                   v_val_percent_variac_val
                   with frame f_dlg_01_concil_autom.
        end /* do rs_regra_4 */.            

    end /* case rs_regra */.

END PROCEDURE. /* pi_value_changed_rs_regra_concil_autom */
/*****************************************************************************
** Procedure Interna.....: pi_right_mouse_down_dialog_box
** Descricao.............: pi_right_mouse_down_dialog_box
** Criado por............: bre19062
** Criado em.............: 29/10/2002 15:55:42
** Alterado por..........: bre19062
** Alterado em...........: 29/10/2002 16:03:59
*****************************************************************************/
PROCEDURE pi_right_mouse_down_dialog_box:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END PROCEDURE. /* pi_right_mouse_down_dialog_box */
/*****************************************************************************
** Procedure Interna.....: pi_vld_titulos_prev_prov_antecip
** Descricao.............: pi_vld_titulos_prev_prov_antecip
** Criado por............: fut1228_3
** Criado em.............: 25/10/2006 12:08:14
** Alterado por..........: fut35183
** Alterado em...........: 21/02/2007 13:59:31
*****************************************************************************/
PROCEDURE pi_vld_titulos_prev_prov_antecip:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_espec_docto
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find espec_docto no-lock
        where espec_docto.cod_espec_docto = p_cod_espec_docto no-error.
    if  avail espec_docto
    then do:
        if  espec_docto.ind_tip_espec_docto = "Antecipaá∆o" /*l_antecipacao*/ 
        or  espec_docto.ind_tip_espec_docto = "Previs∆o" /*l_previsao*/ 
        or  espec_docto.ind_tip_espec_docto = "Provis∆o" /*l_provisao*/  then
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        return "NOK" /*l_nok*/ .
    end /* else */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_vld_titulos_prev_prov_antecip */
/*****************************************************************************
** Procedure Interna.....: pi_exec_program_epc_FIN
** Descricao.............: pi_exec_program_epc_FIN
** Criado por............: src388
** Criado em.............: 09/09/2003 10:48:55
** Alterado por..........: fut1309
** Alterado em...........: 15/02/2006 09:44:03
*****************************************************************************/
PROCEDURE pi_exec_program_epc_FIN:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_event
        as character
        format "x(100)"
        no-undo.
    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_log_return_epc
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* *******************************************************************************************
    ** Objetivo..............: Substituir o c¢digo gerado pela include i_exec_program_epc,
    **                         muitas vezes repetido, com o intuito de evitar estouro de segmento.
    **
    ** Utilizaá∆o............: A utilizaá∆o desta procedure funciona exatamente como a include
    **                         anteriormente utilizada para este fim, para chamar ela deve ser 
    **                         includa a include i_executa_pi_epc_fin no programa, que ira executar 
    **                         esta pi e fazer tratamento para os retornos. Deve ser declarada a 
    **                         variavel v_log_return_epc (caso o parametro ela seja verdade, Ç 
    **                         porque a EPC retornou "NOK". 
    **
    **                         @i(i_executa_pi_epc_fin &event='INITIALIZE' &return='NO')
    **
    **                         Para se ter uma idÇia de como se usa, favor olhar o fonte do apb008za.p
    **
    **
    *********************************************************************************************/

    assign p_log_return_epc = no.
    /* ix_iz1_fnc_tit_ap_bcio_conciliacao */


    /* Begin_Include: i_exec_program_epc_pi_fin */
    if  v_nom_prog_upc <> ''    
    or  v_nom_prog_appc <> ''
    or  v_nom_prog_dpc <> '' then do:
        &if 'tit_ap_bcio' <> '' &then
            assign v_rec_table_epc = recid(tit_ap_bcio)
                   v_nom_table_epc = 'tit_ap_bcio'.
        &else
            assign v_rec_table_epc = ?
                   v_nom_table_epc = "".
        &endif
    end.
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_upc) (input p_cod_event,
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    if  v_nom_prog_appc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_appc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_dpc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.
    &endif
    &endif

    /* End_Include: i_exec_program_epc_pi_fin */


    /* ix_iz2_fnc_tit_ap_bcio_conciliacao */
END PROCEDURE. /* pi_exec_program_epc_FIN */
/*****************************************************************************
** Procedure Interna.....: pi_efetiva_atualizacao_manual
** Descricao.............: pi_efetiva_atualizacao_manual
** Criado por............: fut1228_2
** Criado em.............: 30/03/2007 09:19:21
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:17:20
*****************************************************************************/
PROCEDURE pi_efetiva_atualizacao_manual:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_concil_autom
        for tt_concil_autom.


    /*************************** Buffer Definition End **************************/

    for each btt_concil_autom
        where btt_concil_autom.tta_log_concil = yes
        and   btt_concil_autom.ttv_log_descta = yes:
        find tit_ap_bcio exclusive-lock
            where tit_ap_bcio.cod_estab         = btt_concil_autom.tta_cod_estab
            and   tit_ap_bcio.cod_sist_nac_bcio = btt_concil_autom.tta_cod_sist_nac_bcio 
            and   tit_ap_bcio.cod_tit_ap_bco    = btt_concil_autom.tta_cod_tit_ap_bco
            and   tit_ap_bcio.num_seq_tit_bco   = btt_concil_autom.ttv_num_seq_tit_bco
            no-error.

        if  v_log_layout_sacad = yes then do:
            find tit_ap exclusive-lock
                where tit_ap.cod_estab       = btt_concil_autom.tta_cod_estab_tit_ap
                and   tit_ap.cdn_fornecedor  = btt_concil_autom.ttv_cdn_matriz_fornec_inic
                and   tit_ap.cod_ser_docto   = btt_concil_autom.tta_cod_ser_docto 
                and   tit_ap.cod_espec_docto = btt_concil_autom.tta_cod_espec_docto 
                and   tit_ap.cod_tit_ap      = btt_concil_autom.tta_cod_tit_ap 
                and   tit_ap.cod_parcela     = btt_concil_autom.tta_cod_parcela 
                no-error.            
        end.
        else do:
            find tit_ap exclusive-lock
                where tit_ap.cod_estab       = btt_concil_autom.tta_cod_estab_tit_ap
                and   tit_ap.cdn_fornecedor  = btt_concil_autom.tta_cdn_fornecedor 
                and   tit_ap.cod_ser_docto   = btt_concil_autom.tta_cod_ser_docto 
                and   tit_ap.cod_espec_docto = btt_concil_autom.tta_cod_espec_docto 
                and   tit_ap.cod_tit_ap      = btt_concil_autom.tta_cod_tit_ap 
                and   tit_ap.cod_parcela     = btt_concil_autom.tta_cod_parcela 
                no-error.
        end.

        if  avail tit_ap_bcio and avail tit_ap then do:
            if  tit_ap.log_concil = no then do:

                run pi_atualiza_conciliacao (Input "Manual" /*l_manual*/) /*pi_atualiza_conciliacao*/.
                if  return-value = "NOK" /*l_nok*/  then
                    return "NOK" /*l_nok*/ .
            end.
        end.
    end.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_efetiva_atualizacao_manual */
/*****************************************************************************
** Procedure Interna.....: pi_bt_det_varredura_sacado
** Descricao.............: pi_bt_det_varredura_sacado
** Criado por............: fut1228_2
** Criado em.............: 03/04/2007 17:16:08
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:18:59
*****************************************************************************/
PROCEDURE pi_bt_det_varredura_sacado:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.04" &then
    def buffer b_tit_ap_bcio
        for tit_ap_bcio.
    &endif


    /*************************** Buffer Definition End **************************/

    if avail tt_tit_ap_em_bco then do:
        find b_tit_ap_bcio no-lock
            where b_tit_ap_bcio.cod_estab         = tt_tit_ap_em_bco.tta_cod_estab
            and   b_tit_ap_bcio.cod_sist_nac_bcio = tt_tit_ap_em_bco.tta_cod_sist_nac_bcio
            and   b_tit_ap_bcio.cod_tit_ap_bco    = tt_tit_ap_em_bco.tta_cod_tit_ap_bco
            and   b_tit_ap_bcio.num_seq_tit_bco   = tt_tit_ap_em_bco.ttv_num_seq_tit_bco
            no-error.
        if avail b_tit_ap_bcio then do:
            assign v_rec_tit_ap_bcio = recid(b_tit_ap_bcio).
            if  search("prgfin/apb/apb775ia.r") = ? and search("prgfin/apb/apb775ia.p") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb775ia.p".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb775ia.p"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/apb/apb775ia.p /*prg_det_tit_ap_bcio*/.
        end.    
    end.        

END PROCEDURE. /* pi_bt_det_varredura_sacado */
/*****************************************************************************
** Procedure Interna.....: pi_bt_param1_im_dlg_03_varredura_sacado
** Descricao.............: pi_bt_param1_im_dlg_03_varredura_sacado
** Criado por............: fut1228_2
** Criado em.............: 27/06/2007 13:47:49
** Alterado por..........: fut40711
** Alterado em...........: 05/10/2009 10:14:28
*****************************************************************************/
PROCEDURE pi_bt_param1_im_dlg_03_varredura_sacado:

    if v_log_layout_sacad then do:
        view frame f_dlg_01_tit_ap_bcio_parametros_bank.

        filter_block:
        do on error undo filter_block, retry filter_block
                         on endkey undo filter_block, leave filter_block:
            if  not retry
            then do:
                display bt_can
                        bt_hel2
                        bt_ok
                        v_log_barra_5
                        v_log_bancario
                        v_log_dat_multa
                        v_log_dat_vencto
                        v_log_desconto
                        v_log_val_desc
                        v_log_val_juros
                        v_log_val_multa                    
                        v_log_forma_pagto_3
                        v_cod_forma_pagto
                        with frame f_dlg_01_tit_ap_bcio_parametros_bank.
                enable all with frame f_dlg_01_tit_ap_bcio_parametros_bank.

                &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
                    if v_log_forma_pagto_3 = no then do:
                        assign v_cod_forma_pagto:screen-value in frame f_dlg_01_tit_ap_bcio_parametros_bank = ''.
                        disable v_cod_forma_pagto
                                with frame f_dlg_01_tit_ap_bcio_parametros_bank.
                        disable bt_zoo_427364 with frame f_dlg_01_tit_ap_bcio_parametros_bank.    
                    end.
                &ELSE
                    hide v_cod_forma_pagto in frame f_dlg_01_tit_ap_bcio_parametros_bank
                         v_log_forma_pagto_3 in frame f_dlg_01_tit_ap_bcio_parametros_bank.
                    hide bt_zoo_427364 in frame f_dlg_01_tit_ap_bcio_parametros_bank.
                &ENDIF
            end /* if */.

            wait-for go of frame f_dlg_01_tit_ap_bcio_parametros_bank.

            assign input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_barra_5
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_bancario
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_dat_multa
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_dat_vencto
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_desconto
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_val_desc
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_val_juros
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_val_multa
                   &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_log_forma_pagto_3
                   input frame f_dlg_01_tit_ap_bcio_parametros_bank v_cod_forma_pagto
                   &ENDIF.

        end /* do filter_block */.

        hide frame f_dlg_01_tit_ap_bcio_parametros_bank no-pause.
    end.
    else do:
        view frame f_dlg_01_tit_ap_bcio_parametros.

        filter_block:
        do on error undo filter_block, retry filter_block
                         on endkey undo filter_block, leave filter_block:
            if  not retry
            then do:
                display bt_can
                        bt_hel2
                        bt_ok
                        v_log_cop_cod_barra
                        with frame f_dlg_01_tit_ap_bcio_parametros.
                enable all with frame f_dlg_01_tit_ap_bcio_parametros.
            end /* if */.

            wait-for go of frame f_dlg_01_tit_ap_bcio_parametros.

            assign input frame f_dlg_01_tit_ap_bcio_parametros v_log_cop_cod_barra.

        end /* do filter_block */.

        hide frame f_dlg_01_tit_ap_bcio_parametros no-pause.
    end.
END PROCEDURE. /* pi_bt_param1_im_dlg_03_varredura_sacado */
/*****************************************************************************
** Procedure Interna.....: pi_busca_fornecedor
** Descricao.............: pi_busca_fornecedor
** Criado por............: fut35118
** Criado em.............: 28/06/2007 14:52:47
** Alterado por..........: fut35118
** Alterado em...........: 02/07/2007 09:06:03
*****************************************************************************/
PROCEDURE pi_busca_fornecedor:

    /************************ Parameter Definition Begin ************************/

    def Input param p_hdl_campo
        as Handle
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* Zoom de Atributo com referencia para o usuario */
    if  search("prgint/utb/utb031nb.r") = ? and search("prgint/utb/utb031nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb031nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgint/utb/utb031nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb031nb.p /*prg_see_fornecedor_usuar_permis*/.
    if  v_rec_fornecedor <> ?
    then do:
        find fornecedor where recid(fornecedor) = v_rec_fornecedor no-lock no-error.
        assign p_hdl_campo:screen-value    = string(fornecedor.cdn_fornecedor).
        apply "entry" to p_hdl_campo.
    end /* if */.

END PROCEDURE. /* pi_busca_fornecedor */
/*****************************************************************************
** Procedure Interna.....: pi_open_tt_tit_ap_em_bco_3
** Descricao.............: pi_open_tt_tit_ap_em_bco_3
** Criado por............: fut35118
** Criado em.............: 02/07/2007 11:41:50
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:21:30
*****************************************************************************/
PROCEDURE pi_open_tt_tit_ap_em_bco_3:

    /* Faixa */
    if tit_ap_bcio.cod_id_feder_fornec_bco < v_cod_id_feder or
       tit_ap_bcio.cod_id_feder_fornec_bco > v_cod_id_feder_apb_fim then
        return.

    if tit_ap_bcio.nom_fornecedor < v_nom_fornecedor_ini or
       tit_ap_bcio.nom_fornecedor > v_nom_fornecedor_fim then
        return.

    if tit_ap_bcio.dat_entr_sist < v_dat_entr_sist_ini or
       tit_ap_bcio.dat_entr_sist > v_dat_entr_sist_fim then
        return.

    if tit_ap_bcio.val_tit_ap_bcio < v_val_tit_ap_bcio_ini or
       tit_ap_bcio.val_tit_ap_bcio > v_val_tit_ap_bcio_fim then
        return.

    &if defined(BF_FIN_CANCEL_VARREDURA) &then
    if v_log_tit_ap_bcio_cancel   = no and 
       tit_ap_bcio.log_tit_cancel = yes then
        return.
    &endif   

    /* Filtro */
    if tit_ap_bcio.log_concil = no and v_log_nao_concil = no then
       &if defined(BF_FIN_CANCEL_VARREDURA) &then
       if tit_ap_bcio.log_tit_cancel <> yes then   /* Os n∆o conciliados somente retorna se n∆o for cancelado */ 
       &endif       
           return.

    if tit_ap_bcio.log_concil = yes and tit_ap_bcio.log_confer = no then do:
        if v_log_concil_nao_confer = no then 
            return.
    end.

    if tit_ap_bcio.log_concil = yes and tit_ap_bcio.log_confer = yes then do:
        if v_log_concil_confer = no then 
            return.
    end.

    /* cria tabela tempor†ria. */
    create tt_tit_ap_em_bco.
    assign tt_tit_ap_em_bco.tta_cod_estab             = tit_ap_bcio.cod_estab
           tt_tit_ap_em_bco.tta_cod_sist_nac_bcio     = tit_ap_bcio.cod_sist_nac_bcio
           tt_tit_ap_em_bco.tta_cod_tit_ap_bco        = tit_ap_bcio.cod_tit_ap_bco
           tt_tit_ap_em_bco.tta_cdn_fornecedor        = tit_ap_bcio.cdn_fornecedor
           tt_tit_ap_em_bco.tta_dat_entr_sist         = tit_ap_bcio.dat_entr_sist
           tt_tit_ap_em_bco.tta_cod_id_feder          = tit_ap_bcio.cod_id_feder_fornec_bco
           tt_tit_ap_em_bco.tta_dat_emis_tit_bcio     = tit_ap_bcio.dat_emis_tit_bcio
           tt_tit_ap_em_bco.tta_dat_vencto            = tit_ap_bcio.dat_vencto
           tt_tit_ap_em_bco.tta_val_tit_ap_bcio       = tit_ap_bcio.val_tit_ap_bcio
           tt_tit_ap_em_bco.tta_log_concil            = tit_ap_bcio.log_concil
           tt_tit_ap_em_bco.tta_log_confer            = tit_ap_bcio.log_confer
           tt_tit_ap_em_bco.ttv_cod_barra_bcio        = tit_ap_bcio.cod_barra
           tt_tit_ap_em_bco.tta_num_id_tit_ap         = tit_ap_bcio.num_id_tit_ap
           tt_tit_ap_em_bco.tta_nom_fornecedor        = tit_ap_bcio.nom_fornecedor
           tt_tit_ap_em_bco.tta_val_desconto          = tit_ap_bcio.val_desconto
           tt_tit_ap_em_bco.tta_val_abat_tit_ap       = tit_ap_bcio.val_abat
           tt_tit_ap_em_bco.tta_val_multa             = tit_ap_bcio.val_multa
           tt_tit_ap_em_bco.ttv_cod_tit_ap_bco        = tit_ap_bcio.cod_tit_ap_bco
           tt_tit_ap_em_bco.tta_val_juros             = tit_ap_bcio.val_juros
           v_num_sel_reg                              = v_num_sel_reg + 1
           tt_tit_ap_em_bco.ttv_num_sel_reg           = v_num_sel_reg
           &if defined(BF_FIN_CANCEL_VARREDURA) &then
           tt_tit_ap_em_bco.tta_log_tit_cancel        = tit_ap_bcio.log_tit_cancel
           &endif
           tt_tit_ap_em_bco.ttv_num_seq_tit_bco       = tit_ap_bcio.num_seq_tit_bco.


END PROCEDURE. /* pi_open_tt_tit_ap_em_bco_3 */
/*****************************************************************************
** Procedure Interna.....: pi_eliminar_tit_ap_bcio_indiv
** Descricao.............: pi_eliminar_tit_ap_bcio_indiv
** Criado por............: fut35118
** Criado em.............: 02/07/2007 16:28:30
** Alterado por..........: fut43117
** Alterado em...........: 22/07/2010 15:26:22
*****************************************************************************/
PROCEDURE pi_eliminar_tit_ap_bcio_indiv:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_tit_ap_bco
        as character
        format "x(20)"
        no-undo.
    def Input param p_num_seq_tit_bco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_answer
        as logical
        format "Sim/N∆o"
        initial yes
        view-as toggle-box
        no-undo.
    def var v_log_elimina
        as logical
        format "Sim/N∆o"
        initial no
        label "Elimina"
        column-label "Elimina"
        no-undo.


    /************************** Variable Definition End *************************/

    run pi_messages (input "show",
                     input 18660,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       "T°tulo Banc†rio" /*l_titulo_bancario*/ , lower("Eliminaá∆o" /*l_eliminacao*/ ), lower("Eliminado" /*l_eliminado*/ ))).
    assign v_log_answer = (if   return-value = "yes" then yes
                           else if return-value = "no" then no
                           else ?) /*msg_18660*/.

    if  v_log_answer <> yes
    then do:
        return.
    end /* if */.

    assign v_log_elimina = no.

    find first tit_ap_bcio exclusive-lock
        where tit_ap_bcio.cod_estab         = p_cod_estab
          and tit_ap_bcio.cod_sist_nac_bcio = p_cod_portador
          and tit_ap_bcio.cod_tit_ap_bco    = p_cod_tit_ap_bco 
          and tit_ap_bcio.num_seq_tit_bco   = p_num_seq_tit_bco no-error.

    if avail tit_ap_bcio then do:

        if  tit_ap_bcio.log_concil = no then do:
            for each movto_tit_ap_bcio exclusive-lock
                where movto_tit_ap_bcio.cod_estab         = tit_ap_bcio.cod_estab
                and   movto_tit_ap_bcio.cod_sist_nac_bcio = tit_ap_bcio.cod_sist_nac_bcio
                and   movto_tit_ap_bcio.cod_tit_ap_bco    = tit_ap_bcio.cod_tit_ap_bco
                and   movto_tit_ap_bcio.num_seq_tit_bco   = tit_ap_bcio.num_seq_tit_bco:
                 delete movto_tit_ap_bcio.
            end.
            delete tit_ap_bcio.
            assign v_log_elimina = yes.
        end.
        else do:
            find tit_ap no-lock
                where tit_ap.cod_estab     = tit_ap_bcio.cod_estab
                and   tit_ap.num_id_tit_ap = tit_ap_bcio.num_id_tit_ap
                no-error.
            if (not avail tit_ap) or 
               (avail tit_ap and tit_ap.val_sdo_tit_ap <= 0) then do:
                for each movto_tit_ap_bcio exclusive-lock
                  where movto_tit_ap_bcio.cod_estab         = tit_ap_bcio.cod_estab
                   and  movto_tit_ap_bcio.cod_sist_nac_bcio = tit_ap_bcio.cod_sist_nac_bcio
                   and  movto_tit_ap_bcio.cod_tit_ap_bco    = tit_ap_bcio.cod_tit_ap_bco
                   and  movto_tit_ap_bcio.num_seq_tit_bco   = tit_ap_bcio.num_seq_tit_bco:
                    delete movto_tit_ap_bcio.
                end.
                delete tit_ap_bcio.   
                assign v_log_elimina = yes.                 
            end.    
            else do:
                /* T°tulo banc†rio selecionado est† conciliado ! */
                run pi_messages (input "show",
                                 input 18661,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_18661*/.
            end.
        end.
        if v_log_elimina = yes then do:
            run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
            run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.    
        end.
    end.    
END PROCEDURE. /* pi_eliminar_tit_ap_bcio_indiv */
/*****************************************************************************
** Procedure Interna.....: pi_cancel_tit_ap_bcio_indiv
** Descricao.............: pi_cancel_tit_ap_bcio_indiv
** Criado por............: fut35118
** Criado em.............: 02/07/2007 16:56:59
** Alterado por..........: fut43117
** Alterado em...........: 23/07/2010 10:02:33
*****************************************************************************/
PROCEDURE pi_cancel_tit_ap_bcio_indiv:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_tit_ap_bco
        as character
        format "x(20)"
        no-undo.
    def Input param p_num_seq_tit_bco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.04" &then
    def buffer b_movto_tit_ap_bcio
        for movto_tit_ap_bcio.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_histor_padr
        as character
        format "x(8)":U
        label "Hist¢rico Padr∆o"
        column-label "Hist¢rico Padr∆o"
        no-undo.
    def var v_des_text_histor
        as character
        format "x(2000)":U
        view-as editor max-chars 2000 scrollbar-vertical
        size 50 by 4
        bgcolor 15 font 2
        label "Hist¢rico"
        column-label "Hist¢rico"
        no-undo.
    def var v_log_answer
        as logical
        format "Sim/N∆o"
        initial yes
        view-as toggle-box
        no-undo.
    def var v_num_seq_movto_bco
        as integer
        format ">>>>,>>9":U
        label "Sequància Movto"
        column-label "Sequància Movto"
        no-undo.


    /************************** Variable Definition End *************************/

    find first tit_ap_bcio exclusive-lock
      where tit_ap_bcio.cod_estab         = p_cod_estab
        and tit_ap_bcio.cod_sist_nac_bcio = p_cod_portador
        and tit_ap_bcio.cod_tit_ap_bco    = p_cod_tit_ap_bco 
        and tit_ap_bcio.num_seq_tit_bco   = p_num_seq_tit_bco no-error.

    if not avail tit_ap_bcio then
        return.

    /* Somente t°tulos n∆o cancelados e n∆o conciliados */
    if tit_ap_bcio.log_concil = yes then do:
        /* T°tulo Banc†rio j† est† conciliado ! */
        run pi_messages (input "show",
                         input 9730,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           tit_ap_bcio.cod_estab,tit_ap_bcio.cod_sist_nac_bcio,tit_ap_bcio.cod_tit_ap_bco)) /*msg_9730*/.
        return.
    end.

    &if defined(BF_FIN_CANCEL_VARREDURA) &then
    if tit_ap_bcio.log_tit_cancel = yes then do:
        /* T°tulo Banc†rio est† cancelado ! */
        run pi_messages (input "show",
                         input 18629,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           tit_ap_bcio.cod_estab,tit_ap_bcio.cod_sist_nac_bcio,tit_ap_bcio.cod_tit_ap_bco,"Cancelar" /*l_cancelar*/)) /*msg_18629*/.
        return.
    end.
    &endif

    run pi_messages (input "show",
                     input 18660,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       "T°tulo Banc†rio" /*l_titulo_bancario*/ , lower("Cancelamento" /*l_cancelamento*/ ), lower("Cancelado" /*l_cancelado*/ ))).
    assign v_log_answer = (if   return-value = "yes" then yes
                           else if return-value = "no" then no
                           else ?) /*msg_18660*/.

    if  v_log_answer <> yes
    then do:
        return.
    end /* if */.

    if  search("prgfin/apb/apb013ta.r") = ? and search("prgfin/apb/apb013ta.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb013ta.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb013ta.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/apb/apb013ta.p (input-output v_cod_histor_padr,
                               input-output v_des_text_histor,
                               Input "Estorno" /*l_estorno*/) /*prg_dlg_histor_tit_movto_ap_informa*/.

    if v_des_text_histor = ? or 
       trim(v_des_text_histor) = '' then do:
        /* Hist¢rico n∆o foi informado ! */
        run pi_messages (input "show",
                         input 11678,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11678*/.
        return.
    end.

    assign v_num_seq_movto_bco = 10.
    for each b_movto_tit_ap_bcio exclusive-lock
        where b_movto_tit_ap_bcio.cod_estab         = tit_ap_bcio.cod_estab
          and b_movto_tit_ap_bcio.cod_sist_nac_bcio = tit_ap_bcio.cod_sist_nac_bcio
          and b_movto_tit_ap_bcio.cod_tit_ap_bco    = tit_ap_bcio.cod_tit_ap_bco
          and b_movto_tit_ap_bcio.num_seq_tit_bco   = tit_ap_bcio.num_seq_tit_bco
        by b_movto_tit_ap_bcio.num_seq_movto_bco desc:
        assign v_num_seq_movto_bco = b_movto_tit_ap_bcio.num_seq_movto_bco + 10.
        leave.
    end.

    create b_movto_tit_ap_bcio.
    assign b_movto_tit_ap_bcio.cod_estab            = tit_ap_bcio.cod_estab
           b_movto_tit_ap_bcio.cod_sist_nac_bcio    = tit_ap_bcio.cod_sist_nac_bcio
           b_movto_tit_ap_bcio.cod_tit_ap_bco       = tit_ap_bcio.cod_tit_ap_bco
           b_movto_tit_ap_bcio.num_seq_tit_bco      = tit_ap_bcio.num_seq_tit_bco
           b_movto_tit_ap_bcio.num_seq_movto_bco    = v_num_seq_movto_bco
           b_movto_tit_ap_bcio.ind_tip_movto_bco    = "Cancelamento t°tulo" /*l_cancel_titulo*/ 
           b_movto_tit_ap_bcio.dat_gerac_arq        = tit_ap_bcio.dat_entr_sist
           b_movto_tit_ap_bcio.dsl_histor_movto_bco = v_des_text_histor.

    &if defined(BF_FIN_CANCEL_VARREDURA) &then
    assign tit_ap_bcio.log_tit_cancel = yes.
    &endif

    run pi_open_tt_tit_ap_em_bco /*pi_open_tt_tit_ap_em_bco*/.
    run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.    


END PROCEDURE. /* pi_cancel_tit_ap_bcio_indiv */
/*****************************************************************************
** Procedure Interna.....: pi_grava_params_fnc_tit_ap_bcio_conc
** Descricao.............: pi_grava_params_fnc_tit_ap_bcio_conc
** Criado por............: fut35118
** Criado em.............: 16/07/2007 08:59:25
** Alterado por..........: fut40695
** Alterado em...........: 31/01/2010 15:06:14
*****************************************************************************/
PROCEDURE pi_grava_params_fnc_tit_ap_bcio_conc:

        find first dwb_rpt_param exclusive-lock
           where dwb_rpt_param.cod_dwb_program = 'tar_varredura_sacado':U
             and dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user no-error.

        if avail dwb_rpt_param then do:
            assign dwb_rpt_param.cod_dwb_parameters = v_cod_estab_apb_inic          + chr(10) +
                                                      v_cod_estab_apb_fim           + chr(10) +
                                                      string(v_dat_vencto_apb_inic) + chr(10) +
                                                      string(v_dat_vencto_apb_fim)  + chr(10) +
                                                      string(v_dat_emis_apb_inic)   + chr(10) +
                                                      string(v_dat_emis_apb_fim)    + chr(10) +
                                                      string(v_val_origin_apb_inic) + chr(10) +
                                                      string(v_val_origin_apb_fim)  + chr(10) + 
                                                      v_cod_portad_multi_sel_tela   + chr(10) +
                                                      v_cod_forma_pagto_multi_sel_tela + chr(10) +
                                                      v_cod_espec_multi_sel_tela    + chr(10) +
                                                      v_cod_estab_ini               + chr(10) +
                                                      v_cod_estab_fim               + chr(10) +
                                                      v_cod_id_feder                + chr(10) +           
                                                      v_cod_id_feder_apb_fim        + chr(10) +   
                                                      string(v_dat_vencto_ini)      + chr(10) +
                                                      string(v_dat_vencto_fim)      + chr(10) +
                                                      string(v_dat_entr_sist_ini)   + chr(10) +
                                                      string(v_dat_entr_sist_fim)   + chr(10) +
                                                      v_nom_fornecedor_ini          + chr(10) +
                                                      v_nom_fornecedor_fim          + chr(10) +
                                                      string(v_cdn_fornecedor_ini)  + chr(10) +     
                                                      string(v_cdn_fornecedor_fim)  + chr(10) +     
                                                      string(v_val_tit_ap_bcio_ini) + chr(10) +
                                                      string(v_val_tit_ap_bcio_fim) + chr(10) +
                                                      string(v_log_concil_nao_confer) + chr(10) +
                                                      string(v_log_nao_concil)      + chr(10) +
                                                      string(v_log_concil_confer)   + chr(10) +
                                                      string(v_log_tit_ap_bcio_cancel) + chr(10) +
                                                      string(v_log_matriz_fornec)   + chr(10) +
                                                      rs_tt_tit_ap_conciliacao      + chr(10) +
                                                      string(v_log_cop_cod_barra).

              if v_log_layout_sacad = no then do:
                 assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters 
                                                           + chr(10) + v_cdn_sist_nac_bcio:screen-value in frame f_dlg_03_varredura_sacado
                                                           + chr(10) + ''.              
              end.
              else
                  assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters 
                                                            + chr(10) + v_wgh_fill_in_ini:screen-value
                                                            + chr(10) + v_wgh_fill_in_fim:screen-value.              

              if v_log_layout_sacad = yes then do:                                                        
                assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters          
                                                          + chr(10) + string(v_log_bancario)
                                                          + chr(10) + string(v_log_dat_vencto)
                                                          + chr(10) + string(v_log_desconto)
                                                          + chr(10) + string(v_log_val_desc)
                                                          + chr(10) + string(v_log_dat_multa)
                                                          + chr(10) + string(v_log_val_multa)
                                                          + chr(10) + string(v_log_val_juros)
                                                          + chr(10) + string(v_log_barra_5)
                                                          + chr(10) + string(v_log_forma_pagto_3)
                                                          + chr(10) + v_cod_forma_pagto.
              end.
        end.                                                  






END PROCEDURE. /* pi_grava_params_fnc_tit_ap_bcio_conc */
/*****************************************************************************
** Procedure Interna.....: pi_ajustar_tela_apl
** Descricao.............: pi_ajustar_tela_apl
** Criado por............: its0098
** Criado em.............: 05/01/2005 09:57:26
** Alterado por..........: its0098
** Alterado em...........: 04/04/2005 08:56:09
*****************************************************************************/
PROCEDURE pi_ajustar_tela_apl:

    /************************ Parameter Definition Begin ************************/

    def Input param table 
        for tt_ajuste_tela_apl.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_hdl_label
        as Handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_ajuste_tela_apl:
        IF tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "FRAME" /*l_frame*/       AND
           tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "window" /*l_window*/      AND
           tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "DIALOG-BOX" /*l_dialog_box*/  AND
           tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "RECTANGLE" /*l_rectangle*/   AND
           tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "Browse" /*l_browse*/      THEN DO:
           ASSIGN tt_ajuste_tela_apl.ttv_hdl_obj:ROW = IF tt_ajuste_tela_apl.ttv_log_lin THEN tt_ajuste_tela_apl.ttv_val_pos_lin + tt_ajuste_tela_apl.ttv_hdl_obj:ROW
                                  ELSE tt_ajuste_tela_apl.ttv_hdl_obj:ROW
                  tt_ajuste_tela_apl.ttv_hdl_obj:COL = IF tt_ajuste_tela_apl.ttv_log_col THEN tt_ajuste_tela_apl.ttv_val_pos_col + tt_ajuste_tela_apl.ttv_hdl_obj:COL
                                  ELSE tt_ajuste_tela_apl.ttv_hdl_obj:COL.
           IF tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "button" /*l_button*/  AND 
              tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "TOGGLE-BOX" /*l_toggle_box*/  THEN
               ASSIGN v_hdl_label     = tt_ajuste_tela_apl.ttv_hdl_obj:SIDE-LABEL-HANDLE
                      v_hdl_label:COL = IF tt_ajuste_tela_apl.ttv_log_col THEN tt_ajuste_tela_apl.ttv_val_pos_col + v_hdl_label:COL
                                        ELSE v_hdl_label:COL
                      v_hdl_label:ROW = IF tt_ajuste_tela_apl.ttv_log_lin THEN tt_ajuste_tela_apl.ttv_val_pos_lin + v_hdl_label:ROW
                                        ELSE v_hdl_label:ROW.
        END.
        IF tt_ajuste_tela_apl.ttv_hdl_obj:TYPE = "RECTANGLE" /*l_rectangle*/  THEN DO:
            ASSIGN tt_ajuste_tela_apl.ttv_hdl_obj:ROW = IF tt_ajuste_tela_apl.ttv_log_lin THEN tt_ajuste_tela_apl.ttv_val_pos_lin + tt_ajuste_tela_apl.ttv_hdl_obj:ROW
                                      ELSE tt_ajuste_tela_apl.ttv_hdl_obj:ROW
                      tt_ajuste_tela_apl.ttv_hdl_obj:COL = IF tt_ajuste_tela_apl.ttv_log_col THEN tt_ajuste_tela_apl.ttv_val_pos_col + tt_ajuste_tela_apl.ttv_hdl_obj:COL
                                      ELSE tt_ajuste_tela_apl.ttv_hdl_obj:COL.
        END.
        ASSIGN tt_ajuste_tela_apl.ttv_hdl_obj:WIDTH-CHARS = IF tt_ajuste_tela_apl.ttv_log_larg THEN tt_ajuste_tela_apl.ttv_val_pos_larg + tt_ajuste_tela_apl.ttv_hdl_obj:WIDTH-CHARS
                                       ELSE tt_ajuste_tela_apl.ttv_hdl_obj:WIDTH-CHARS.
        IF tt_ajuste_tela_apl.ttv_hdl_obj:TYPE <> "combo-box" /*l_como_box*/  THEN
            ASSIGN tt_ajuste_tela_apl.ttv_hdl_obj:HEIGHT-CHARS = IF tt_ajuste_tela_apl.ttv_log_larg THEN tt_ajuste_tela_apl.ttv_val_pos_alt + tt_ajuste_tela_apl.ttv_hdl_obj:HEIGHT-CHARS
                                            ELSE tt_ajuste_tela_apl.ttv_hdl_obj:HEIGHT-CHARS.
    end.
END PROCEDURE. /* pi_ajustar_tela_apl */
/*****************************************************************************
** Procedure Interna.....: pi_fnc_tit_ap_bcio_conciliacao_resize
** Descricao.............: pi_fnc_tit_ap_bcio_conciliacao_resize
** Criado por............: fut35118
** Criado em.............: 16/07/2007 14:23:22
** Alterado por..........: fut35118
** Alterado em...........: 20/07/2007 15:54:31
*****************************************************************************/
PROCEDURE pi_fnc_tit_ap_bcio_conciliacao_resize:

    /************************* Variable Definition Begin ************************/

    def var v_num_tamanho
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_ajuste_tela_apl:
      delete tt_ajuste_tela_apl.
    end.

    assign v_num_tamanho = 20.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = frame f_dlg_03_varredura_sacado:handle.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_check:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_ran6:HANDLE in frame f_dlg_03_varredura_sacado.

    if v_log_layout_sacad then do:
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_col      = yes
               tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = bt_mod4:handle in frame f_dlg_03_varredura_sacado.
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_col      = yes
               tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = bt_localiza:handle in frame f_dlg_03_varredura_sacado.
    end.

    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_ran2:handle in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_era1:handle in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_fil2:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_det1:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_mov1:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_mod1:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_elimina_image:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_cancelamento:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_check7:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_fil3:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_det_10:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_concil_manual_titulos:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_desconcil_1:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_hel2:handle in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_002:handle in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_005:handle in frame f_dlg_03_varredura_sacado.

    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_cxcf:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_003:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_004:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_001:HANDLE in frame f_dlg_03_varredura_sacado.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_006:HANDLE in frame f_dlg_03_varredura_sacado.

    if  v_log_layout_sacad then do:
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_larg     = yes
               tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = br_tit_ap_em_bco_bank:HANDLE in frame f_dlg_03_varredura_sacado.
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_larg     = yes
               tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = br_tt_tit_ap_conciliacao_bank:HANDLE in frame f_dlg_03_varredura_sacado.
    end.
    else do:           
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_larg     = yes
               tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = br_tit_ap_em_bco:HANDLE in frame f_dlg_03_varredura_sacado.
        create tt_ajuste_tela_apl.
        assign tt_ajuste_tela_apl.ttv_log_larg     = yes
               tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
               tt_ajuste_tela_apl.ttv_hdl_obj      = br_tt_tit_ap_conciliacao:HANDLE in frame f_dlg_03_varredura_sacado.
    end.

    run pi_ajustar_tela_apl (Input table tt_ajuste_tela_apl) /*pi_ajustar_tela_apl*/.

END PROCEDURE. /* pi_fnc_tit_ap_bcio_conciliacao_resize */
/*****************************************************************************
** Procedure Interna.....: pi_concil_autom_confirmacao_resize
** Descricao.............: pi_concil_autom_confirmacao_resize
** Criado por............: fut35118
** Criado em.............: 16/07/2007 14:29:31
** Alterado por..........: fut35118
** Alterado em...........: 16/07/2007 15:05:34
*****************************************************************************/
PROCEDURE pi_concil_autom_confirmacao_resize:

    /************************* Variable Definition Begin ************************/

    def var v_num_tamanho
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_ajuste_tela_apl:
        delete tt_ajuste_tela_apl.
    end.

    assign v_num_tamanho = 23.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = frame f_dlg_01_concil_autom_confirmacao:handle.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_hel2:HANDLE in frame f_dlg_01_concil_autom_confirmacao.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_col      = yes
           tt_ajuste_tela_apl.ttv_val_pos_col  = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = bt_concil_titulos_1:HANDLE in frame f_dlg_01_concil_autom_confirmacao.

    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = br_tt_concil_autom:HANDLE in frame f_dlg_01_concil_autom_confirmacao.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_006:HANDLE in frame f_dlg_01_concil_autom_confirmacao.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_003:HANDLE in frame f_dlg_01_concil_autom_confirmacao.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_cxcf:HANDLE in frame f_dlg_01_concil_autom_confirmacao.
    create tt_ajuste_tela_apl.
    assign tt_ajuste_tela_apl.ttv_log_larg     = yes
           tt_ajuste_tela_apl.ttv_val_pos_larg = v_num_tamanho
           tt_ajuste_tela_apl.ttv_hdl_obj      = rt_mold:HANDLE in frame f_dlg_01_concil_autom_confirmacao.

    run pi_ajustar_tela_apl (Input table tt_ajuste_tela_apl) /*pi_ajustar_tela_apl*/.

END PROCEDURE. /* pi_concil_autom_confirmacao_resize */
/*****************************************************************************
** Procedure Interna.....: pi_main_fnc_tit_ap_bcio_conciliacao
** Descricao.............: pi_main_fnc_tit_ap_bcio_conciliacao
** Criado por............: fut35118
** Criado em.............: 23/07/2007 08:15:07
** Alterado por..........: fut41675_3
** Alterado em...........: 12/04/2010 10:43:54
*****************************************************************************/
PROCEDURE pi_main_fnc_tit_ap_bcio_conciliacao:

    if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgtec/btb/btb906za.py"
                   view-as alert-box error buttons ok.
            stop.
        end.
    end.
    else
        run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

    /* Begin_Include: i_verify_security */
    if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgtec/men/men901za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/men/men901za.py (Input 'fnc_tit_ap_bcio_conciliacao') /*prg_fnc_verify_security*/.
    if  return-value = "2014"
    then do:
        /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
        run pi_messages (input "show",
                         input 2014,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           'fnc_tit_ap_bcio_conciliacao')) /*msg_2014*/.
        return.
    end /* if */.
    if  return-value = "2012"
    then do:
        /* Usu†rio sem permiss∆o para acessar o programa. */
        run pi_messages (input "show",
                         input 2012,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           'fnc_tit_ap_bcio_conciliacao')) /*msg_2012*/.
        return.
    end /* if */.
    /* End_Include: i_verify_security */



    /* Begin_Include: i_log_exec_prog_dtsul_ini */
    assign v_rec_log = ?.

    if can-find(prog_dtsul
           where prog_dtsul.cod_prog_dtsul = 'fnc_tit_ap_bcio_conciliacao' 
             and prog_dtsul.log_gera_log_exec = yes) then do transaction:
        create log_exec_prog_dtsul.
        assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_tit_ap_bcio_conciliacao'
               log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
               log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
        assign v_rec_log = recid(log_exec_prog_dtsul).
        release log_exec_prog_dtsul no-error.
    end.


    /* End_Include: i_log_exec_prog_dtsul_ini */



    /* Begin_Include: i_verify_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    assign v_rec_table_epc = ?
           v_wgh_frame_epc = ?.

    find prog_dtsul
        where prog_dtsul.cod_prog_dtsul = "fnc_tit_ap_bcio_conciliacao":U
        no-lock no-error.
    if  avail prog_dtsul then do:
        if  prog_dtsul.nom_prog_upc <> ''
        and prog_dtsul.nom_prog_upc <> ? then
            assign v_nom_prog_upc = prog_dtsul.nom_prog_upc.
        if  prog_dtsul.nom_prog_appc <> ''
        and prog_dtsul.nom_prog_appc <> ? then
            assign v_nom_prog_appc = prog_dtsul.nom_prog_appc.
    &if '{&emsbas_version}' > '5.00' &then
        if  prog_dtsul.nom_prog_dpc <> ''
        and prog_dtsul.nom_prog_dpc <> ? then
            assign v_nom_prog_dpc = prog_dtsul.nom_prog_dpc.
    &endif
    end.


    assign v_wgh_frame_epc = frame f_dlg_03_varredura_sacado:handle.



    assign v_nom_table_epc = 'tit_ap_bcio':U
           v_rec_table_epc = recid(tit_ap_bcio).

    &endif

    /* End_Include: i_verify_program_epc */



    /* Begin_Include: i_std_dialog_box */
    /* tratamento do titulo e vers∆o */
    assign frame f_dlg_03_varredura_sacado:title = frame f_dlg_03_varredura_sacado:title
                                + chr(32)
                                + chr(40)
                                + trim(" 5.04.00.055":U)
                                + chr(41).
    /* menu pop-up de ajuda e sobre */
    assign menu m_help:popup-only = yes
           bt_hel2:popup-menu in frame f_dlg_03_varredura_sacado = menu m_help:handle.


    /* End_Include: i_std_dialog_box */
{include/title5.i f_dlg_03_varredura_sacado FRAME}


    /* Se a vers∆o for 5.04, verifica se foi liberado por func∆o especial. */
    &if '{&emsfin_version}' = '5.04' &then
        find emscad.histor_exec_especial no-lock
            where emscad.histor_exec_especial.cod_modul_dtsul = 'APB'
              and emscad.histor_exec_especial.cod_prog_dtsul = "FNC_VARREDURA_SACADO" /*L_FNC_VARREDURA_SACADO*/ 
            no-error.
        if  not avail emscad.histor_exec_especial
        then do:
            /* Programa n∆o dispon°vel para vers∆o 5.04. */
            run pi_messages (input "show",
                             input 9879,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_9879*/.        
            return.
        end /* if */.
    &endif
    /* Verifica se foi executado o programa de acerto */
    find first emscad.histor_exec_especial no-lock
        where emscad.histor_exec_especial.cod_modul_dtsul = 'APB'
        and   emscad.histor_exec_especial.cod_prog_dtsul  = 'spp_tit_ap_bcio':U
        no-error.
    if  not avail emscad.histor_exec_especial then do:
        /* Acerto de T°tulo Banc†rio. */
        run pi_messages (input "show",
                         input 18520,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_18520*/.
    end.

    if  search("prgfin/apb/apb932za.r") = ? and search("prgfin/apb/apb932za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb932za.py".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb932za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/apb/apb932za.py (Input 3,
                                output v_log_layout_sacad) /*prg_fnc_verifica_varredura_banking*/.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'BEFORE-INITIALIZE',
                                 Input 'no',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    run pi_fnc_tit_ap_bcio_conciliacao_resize /*pi_fnc_tit_ap_bcio_conciliacao_resize*/.
    run pi_concil_autom_confirmacao_resize /*pi_concil_autom_confirmacao_resize*/.

    pause 0 before-hide.
    view frame f_dlg_03_varredura_sacado.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'INITIALIZE',
                                 Input 'no',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    assign bt_check:help     = "Atualiza T°tulos Banc†rios"
           bt_check:tooltip  = "Atualiza T°tulos Banc†rios"
           bt_check7:help    = "Atualiza T°tulos Contas a Pagar"
           bt_check7:tooltip = "Atualiza T°tulos Contas a Pagar"
           bt_elimina_image:tooltip = "Eliminaá∆o Individual"
           bt_era1:tooltip          = "Eliminaá∆o Faixa".


    /* Inicia as vari†veis utilizadas nas faixas de seleá∆o */
    /* Seleá∆o T°tulos banc†rios */

    &if '{&emsbas_version}' > '5.03' &then
        if v_log_layout_sacad then
            assign br_tit_ap_em_bco_bank:allow-column-searching in frame f_dlg_03_varredura_sacado      = yes
                   br_tt_concil_autom:allow-column-searching in frame f_dlg_01_concil_autom_confirmacao = yes
                   br_tt_tit_ap_conciliacao_bank:allow-column-searching in frame f_dlg_03_varredura_sacado = yes.
        else       
            assign br_tit_ap_em_bco:allow-column-searching in frame f_dlg_03_varredura_sacado           = yes
                   br_tt_concil_autom:allow-column-searching in frame f_dlg_01_concil_autom_confirmacao = yes
                   br_tt_tit_ap_conciliacao:allow-column-searching in frame f_dlg_03_varredura_sacado   = yes.

        assign v_log_browse_order[1] = no
               v_log_browse_order[2] = no
               v_log_browse_order[3] = no
               v_log_browse_order[4] = no
               v_log_browse_order[5] = no.
    &endif

    if v_log_layout_sacad = yes then 
        assign v_cod_banco_ini = "" /*l_null*/ 
               v_cod_banco_fim = 'ZZZZZZZZ'.

    do on error undo, return:
        find first dwb_rpt_param no-lock
            where dwb_rpt_param.cod_dwb_program = 'tar_varredura_sacado':U
              and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user no-error.

        if not avail dwb_rpt_param then do:
            create dwb_rpt_param no-error.
            assign dwb_rpt_param.cod_dwb_program = 'tar_varredura_sacado':U
                   dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user.
        end.
    end.

    if avail dwb_rpt_param and 
       num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 32 then do:
       assign  v_cod_estab_apb_inic            = GetEntryField(1, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_estab_apb_fim             = GetEntryField(2, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_vencto_apb_inic           = date(GetEntryField(3, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_vencto_apb_fim            = date(GetEntryField(4, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_emis_apb_inic             = date(GetEntryField(5, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_emis_apb_fim              = date(GetEntryField(6, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_val_origin_apb_inic           = dec(GetEntryField(7, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_val_origin_apb_fim            = dec(GetEntryField(8, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_log_tit_ap_faixa_ok           = yes
               v_log_tit_ap_habilita           = no
               rs_tt_tit_ap_conciliacao        = "T°tulos n∆o conciliados" /*l_titulos_nao_conciliados*/  
               v_cod_portad_multi_sel_tela     = GetEntryField(9, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_forma_pagto_multi_sel_tela = GetEntryField(10, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_multi_sel_tela      = GetEntryField(11, dwb_rpt_param.cod_dwb_parameters, chr(10)).

        assign  v_cod_estab_ini            = GetEntryField(12, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cod_estab_fim            = GetEntryField(13, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cod_id_feder             = GetEntryField(14, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cod_id_feder_apb_fim     = GetEntryField(15, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_dat_vencto_ini           = date(GetEntryField(16, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_dat_vencto_fim           = date(GetEntryField(17, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_dat_entr_sist_ini        = date(GetEntryField(18, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_dat_entr_sist_fim        = date(GetEntryField(19, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_nom_fornecedor_ini       = GetEntryField(20, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_nom_fornecedor_fim       = GetEntryField(21, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cdn_fornecedor_ini       = int(GetEntryField(22, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_cdn_fornecedor_fim       = int(GetEntryField(23, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_val_tit_ap_bcio_ini      = dec(GetEntryField(24, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_val_tit_ap_bcio_fim      = dec(GetEntryField(25, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_log_faixa_ok             = yes
                v_log_tit_ap_bcio_habilita = no.               

        assign v_log_concil_nao_confer   = (GetEntryField(26, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_nao_concil          = (GetEntryField(27, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_concil_confer       = (GetEntryField(28, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_tit_ap_bcio_cancel  = (GetEntryField(29, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_matriz_fornec       = (GetEntryField(30, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )    
               rs_tt_tit_ap_conciliacao  = GetEntryField(31, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_log_cop_cod_barra       = (GetEntryField(32, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ).

        if  v_log_layout_sacad and
            num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 42 then do:               
            assign v_log_bancario   = (GetEntryField(35, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_dat_vencto = (GetEntryField(36, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_desconto   = (GetEntryField(37, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_val_desc   = (GetEntryField(38, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_dat_multa  = (GetEntryField(39, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_val_multa  = (GetEntryField(40, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_val_juros  = (GetEntryField(41, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_barra_5    = (GetEntryField(42, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   &IF DEFINED(BF_FIN_DDA_EMS5) &THEN
                   v_log_forma_pagto_3 = (GetEntryField(43, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_cod_forma_pagto = GetEntryField(44, dwb_rpt_param.cod_dwb_parameters, chr(10))
                   &ENDIF.  
        end.        
    end.
    else do:
        /* Seleá∆o T°tulos do APB */
        assign  v_cod_estab_apb_inic            = "" /*l_null*/ 
                v_cod_estab_apb_fim             = "ZZZ" /*l_zzz*/ 
                v_dat_vencto_apb_inic           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                v_dat_vencto_apb_fim            = 12/31/9999            
                v_dat_emis_apb_inic             = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                v_dat_emis_apb_fim              = 12/31/9999
                v_val_origin_apb_inic           = 0
                v_val_origin_apb_fim            = 999999999.99
                v_log_tit_ap_faixa_ok           = yes
                v_log_tit_ap_habilita           = no
                rs_tt_tit_ap_conciliacao        = "T°tulos n∆o conciliados" /*l_titulos_nao_conciliados*/ 
                v_cod_portad_multi_sel_tela     = "" /*l_null*/ 
                v_cod_forma_pagto_multi_sel_tela = "" /*l_null*/ 
                v_cod_espec_multi_sel_tela      = "" /*l_null*/ .

        assign  v_cod_estab_ini            = "" /*l_null*/ 
                v_cod_estab_fim            = "ZZZ" /*l_zzz*/ 
                v_cod_id_feder             = "" /*l_null*/   
                v_cod_id_feder_apb_fim     = 'ZZZZZZZZZZZZZZZZZZZZ'
                v_dat_vencto_ini           = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                v_dat_vencto_fim           = 12/31/9999            
                v_dat_entr_sist_ini        = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                v_dat_entr_sist_fim        = 12/31/9999
                v_nom_fornecedor_ini       = "" /*l_null*/ 
                v_nom_fornecedor_fim       = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" /*l_z_x_30*/ 
                v_cdn_fornecedor_ini       = 0
                v_cdn_fornecedor_fim       = 999999999
                v_val_tit_ap_bcio_ini      = 0
                v_val_tit_ap_bcio_fim      = 999999999.99
                v_log_faixa_ok             = yes
                v_log_tit_ap_bcio_habilita = no.    

        for each portador FIELDS(cod_portador)  no-lock
            by portador.cod_portador:
            if v_cod_portad_multi_sel_tela = "" then
                assign v_cod_portad_multi_sel_tela = portador.cod_portador.
            else
                assign v_cod_portad_multi_sel_tela = v_cod_portad_multi_sel_tela + ',':U + portador.cod_portador.
        end.

        for each forma_pagto FIELDS(cod_forma_pagto) no-lock
            by forma_pagto.cod_forma_pagto:
            if v_cod_forma_pagto_multi_sel_tela = "" then
                assign v_cod_forma_pagto_multi_sel_tela = forma_pagto.cod_forma_pagto.
            else
                assign v_cod_forma_pagto_multi_sel_tela = v_cod_forma_pagto_multi_sel_tela + ',':U + forma_pagto.cod_forma_pagto.
        end.

        for each espec_docto FIELDS(cod_espec_docto) no-lock
            by espec_docto.cod_espec_docto:
            if v_cod_espec_multi_sel_tela = "" then
                assign v_cod_espec_multi_sel_tela = espec_docto.cod_espec_docto.
            else
                assign v_cod_espec_multi_sel_tela = v_cod_espec_multi_sel_tela + ',':U + espec_docto.cod_espec_docto.
        end.
    end.

    /* Vari†veis para controlar o check do browse dos t°tulos banc†rios e dos t°tulos do apb,
       sempre que for a primeira vez, obriga que o usu†rio atualize a faixa e o filtro */
    assign v_log_tit_ap_bcio_atualiza = no
           v_log_tit_ap_atualiza      = no.


    main_block:
    do on endkey undo main_block, leave main_block
                    on error undo main_block, leave main_block.

        enable all with frame f_dlg_03_varredura_sacado.

        if  v_log_layout_sacad then do:
            assign br_tit_ap_em_bco_bank:visible in frame f_dlg_03_varredura_sacado = yes
                      br_tt_tit_ap_conciliacao_bank:visible in frame f_dlg_03_varredura_sacado = yes
                      br_tit_ap_em_bco:visible in frame f_dlg_03_varredura_sacado = no
                      br_tt_tit_ap_conciliacao:visible in frame f_dlg_03_varredura_sacado = no.
        end.
        else do:
            assign br_tit_ap_em_bco:visible in frame f_dlg_03_varredura_sacado = yes
                      br_tt_tit_ap_conciliacao:visible in frame f_dlg_03_varredura_sacado = yes
                      br_tit_ap_em_bco_bank:visible in frame f_dlg_03_varredura_sacado = no
                      br_tt_tit_ap_conciliacao_bank:visible in frame f_dlg_03_varredura_sacado = no.
        end.

        /* Se a funá∆o n∆o estiver definida*/
        &if defined(BF_FIN_CANCEL_VARREDURA) = 0 &then
        hide bt_cancelamento in frame f_dlg_03_varredura_sacado.
        &endif 


        /* Begin_Include: i_executa_pi_epc_fin */
        run pi_exec_program_epc_FIN (Input 'ENABLE',
                                     Input 'no',
                                     output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
        if v_log_return_epc then /* epc retornou erro*/
            undo, retry.
        /* End_Include: i_executa_pi_epc_fin */



        /* Begin_Include: i_executa_pi_epc_fin */
        run pi_exec_program_epc_FIN (Input 'DISPLAY',
                                     Input 'no',
                                     output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
        if v_log_return_epc then /* epc retornou erro*/
            undo, retry.
        /* End_Include: i_executa_pi_epc_fin */


        if v_log_layout_sacad = yes then do:
            run pi_ajust_object_frame_dlg_03_varredura_sacado /*pi_ajust_object_frame_dlg_03_varredura_sacado*/.
        end.
        else do:
            hide bt_localiza in frame f_dlg_03_varredura_sacado
                 bt_mod4 in frame f_dlg_03_varredura_sacado.
        end.

        if avail dwb_rpt_param and 
           num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 34 then do:
            if v_log_layout_sacad = yes then
                assign v_wgh_fill_in_ini:screen-value = GetEntryField(33, dwb_rpt_param.cod_dwb_parameters, chr(10))
                       v_wgh_fill_in_fim:screen-value = GetEntryField(34, dwb_rpt_param.cod_dwb_parameters, chr(10)).
            else do:           
                assign v_cdn_sist_nac_bcio:screen-value in frame f_dlg_03_varredura_sacado = GetEntryField(33, dwb_rpt_param.cod_dwb_parameters, chr(10)).
                if v_cdn_sist_nac_bcio:screen-value in frame f_dlg_03_varredura_sacado <> '' then
                    apply 'LEAVE' to v_cdn_sist_nac_bcio in frame f_dlg_03_varredura_sacado.
            end.
        end.

        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_03_varredura_sacado focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_dlg_03_varredura_sacado.
        end /* else */.        

    end /* do main_block */.

    hide frame f_dlg_03_varredura_sacado.


    /* Begin_Include: i_log_exec_prog_dtsul_fim */
    if v_rec_log <> ? then do transaction:
        find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
        if  avail log_exec_prog_dtsul
        then do:
            assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
                   log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
        end /* if */.
        release log_exec_prog_dtsul.
    end.

    /* End_Include: i_log_exec_prog_dtsul_fim */


    return.
END PROCEDURE. /* pi_main_fnc_tit_ap_bcio_conciliacao */
/*****************************************************************************
** Procedure Interna.....: pi_browse_order
** Descricao.............: pi_browse_order
** Criado por............: fut35118
** Criado em.............: 23/07/2007 10:42:47
** Alterado por..........: fut35118
** Alterado em...........: 07/08/2007 10:18:39
*****************************************************************************/
PROCEDURE pi_browse_order:

    /************************ Parameter Definition Begin ************************/

    def Input param p_hdl_obj
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_nom_table
        as character
        format "x(30)"
        no-undo.
    def Input param p_num_order
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_des_filtro
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    DEF VAR hTemp1 AS WIDGET-HANDLE NO-UNDO. 
    DEF VAR hTemp2 AS WIDGET-HANDLE NO-UNDO. 

    &if '{&emsbas_version}' > '5.03' &then
        ASSIGN hTemp1 = p_hdl_obj:CURRENT-COLUMN 
               hTemp2 = p_hdl_obj:QUERY. 

        if v_log_browse_order[p_num_order] = no then do:
            if p_des_filtro = '' or p_des_filtro = ? then
                hTemp2:QUERY-PREPARE('for each ' + p_nom_table + ' OUTER-JOIN by ' + hTemp1:NAME). 
            else    
                hTemp2:QUERY-PREPARE('for each ' + p_nom_table + ' where ' + p_des_filtro + ' OUTER-JOIN by ' + hTemp1:NAME). 
        end.
        else do:   
            if p_des_filtro = '' or p_des_filtro = ? then
                hTemp2:QUERY-PREPARE('for each ' + p_nom_table + ' OUTER-JOIN by ' + hTemp1:NAME + ' desc'). 
            else    
                hTemp2:QUERY-PREPARE('for each ' + p_nom_table + ' where ' + p_des_filtro + ' OUTER-JOIN by ' + hTemp1:NAME + ' desc'). 
        end.    

        assign v_log_browse_order[p_num_order] = not v_log_browse_order[p_num_order].

        hTemp2:QUERY-OPEN(). 
    &endif
END PROCEDURE. /* pi_browse_order */
/*****************************************************************************
** Procedure Interna.....: pi_dblclick_br_tt_tit_ap_conciliacao
** Descricao.............: pi_dblclick_br_tt_tit_ap_conciliacao
** Criado por............: fut35118
** Criado em.............: 23/07/2007 11:09:29
** Alterado por..........: rafaelposse
** Alterado em...........: 14/05/2014 11:22:21
*****************************************************************************/
PROCEDURE pi_dblclick_br_tt_tit_ap_conciliacao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_hdl_obj
        as Handle
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_hdl_browse_column              as handle          no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_hdl_browse_column = p_hdl_obj:get-browse-column(1) no-error.

    if valid-handle(v_hdl_browse_column) then do:
       if tt_tit_ap_conciliacao.ttv_num_sel_reg <> 0 then
          assign tt_tit_ap_conciliacao.ttv_num_sel_reg = 0
                 v_hdl_browse_column:screen-value      = '0'.

       find first tt_tit_ap_conciliacao_sel
            where tt_tit_ap_conciliacao_sel.ttv_rec_tit_ap = tt_tit_ap_conciliacao.ttv_rec_tit_ap no-error.
       if avail tt_tit_ap_conciliacao_sel then
          delete tt_tit_ap_conciliacao_sel.
       else do:
          find first tt_tit_ap_conciliacao_sel
               where tt_tit_ap_conciliacao_sel.ttv_num_sel_reg = tt_tit_ap_em_bco.ttv_num_sel_reg no-error.

          if avail tt_tit_ap_conciliacao_sel then do:
             /* O t°tulo banc†rio j† foi conciliado com outro t°tulo APB ! */
             run pi_messages (input "show",
                              input 18653,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_18653*/. 
          end.
          else do:
             assign tt_tit_ap_conciliacao.ttv_num_sel_reg = tt_tit_ap_em_bco.ttv_num_sel_reg
                    v_hdl_browse_column:screen-value = string(tt_tit_ap_em_bco.ttv_num_sel_reg).
             create tt_tit_ap_conciliacao_sel.
             buffer-copy tt_tit_ap_conciliacao to tt_tit_ap_conciliacao_sel.                   
          end.                 
       end.
    end.
END PROCEDURE. /* pi_dblclick_br_tt_tit_ap_conciliacao */
/*****************************************************************************
** Procedure Interna.....: pi_btok_dlg_01_tit_ap_bcio_faixa
** Descricao.............: pi_btok_dlg_01_tit_ap_bcio_faixa
** Criado por............: fut35118
** Criado em.............: 23/07/2007 11:18:49
** Alterado por..........: fut35118
** Alterado em...........: 09/08/2007 13:25:15
*****************************************************************************/
PROCEDURE pi_btok_dlg_01_tit_ap_bcio_faixa:

    assign v_cod_tip_faixa = "Tit_ap_bco" /*l_tit_ap_bco*/ 
           v_log_faixa_ok  = no.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'ASSIGN',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    run pi_vld_faixa_informada (Input v_cod_tip_faixa) /*pi_vld_faixa_informada*/.

    if  return-value = "OK" /*l_ok*/ 
    then do:
        assign v_log_faixa_ok             = yes
               v_log_tit_ap_bcio_habilita = yes.
    end /* if */.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'VALIDATE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    assign v_cod_tip_faixa = "" /*l_null*/ .

    if v_log_faixa_ok = yes then do:
        assign  v_cod_estab_ini            = input frame f_dlg_01_tit_ap_bcio_faixa v_cod_estab_ini
                v_cod_estab_fim            = input frame f_dlg_01_tit_ap_bcio_faixa v_cod_estab_fim
                v_cod_id_feder             = input frame f_dlg_01_tit_ap_bcio_faixa v_cod_id_feder
                v_cod_id_feder_apb_fim     = input frame f_dlg_01_tit_ap_bcio_faixa v_cod_id_feder_apb_fim
                v_dat_vencto_ini           = input frame f_dlg_01_tit_ap_bcio_faixa v_dat_vencto_ini
                v_dat_vencto_fim           = input frame f_dlg_01_tit_ap_bcio_faixa v_dat_vencto_fim
                v_dat_entr_sist_ini        = input frame f_dlg_01_tit_ap_bcio_faixa v_dat_entr_sist_ini
                v_dat_entr_sist_fim        = input frame f_dlg_01_tit_ap_bcio_faixa v_dat_entr_sist_fim
                v_nom_fornecedor_ini       = input frame f_dlg_01_tit_ap_bcio_faixa v_nom_fornecedor_ini
                v_nom_fornecedor_fim       = input frame f_dlg_01_tit_ap_bcio_faixa v_nom_fornecedor_fim
                v_val_tit_ap_bcio_ini      = input frame f_dlg_01_tit_ap_bcio_faixa v_val_tit_ap_bcio_ini
                v_val_tit_ap_bcio_fim      = input frame f_dlg_01_tit_ap_bcio_faixa v_val_tit_ap_bcio_fim
                v_cdn_fornecedor_ini       = input frame f_dlg_01_tit_ap_bcio_faixa v_cdn_fornecedor_ini
                v_cdn_fornecedor_fim       = input frame f_dlg_01_tit_ap_bcio_faixa v_cdn_fornecedor_fim.
    end.


END PROCEDURE. /* pi_btok_dlg_01_tit_ap_bcio_faixa */
/*****************************************************************************
** Procedure Interna.....: pi_filters_dlg_01_tit_ap_faixa
** Descricao.............: pi_filters_dlg_01_tit_ap_faixa
** Criado por............: fut35118
** Criado em.............: 23/07/2007 11:26:05
** Alterado por..........: fut35118
** Alterado em...........: 11/09/2007 08:30:12
*****************************************************************************/
PROCEDURE pi_filters_dlg_01_tit_ap_faixa:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_aux
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* procura: */
    case  p_num_aux:
        when 1 then do:
            assign v_des_espec_normal = v_cod_espec_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa.
            if  search("prgint/utb/utb120za.r") = ? and search("prgint/utb/utb120za.py") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb120za.py".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgint/utb/utb120za.py"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgint/utb/utb120za.py (Input 1) /*prg_fnc_espec_docto_impto*/.
            assign v_cod_espec_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa = v_des_espec_normal.
        end.
        when 2 then do:
            assign v_log_portad_multi_sel = yes
                   v_cod_portad_multi_sel = v_cod_portad_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa.
            if  search("prgint/ufn/ufn008ka.r") = ? and search("prgint/ufn/ufn008ka.p") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn008ka.p".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgint/ufn/ufn008ka.p"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgint/ufn/ufn008ka.p /*prg_sea_portador*/.
            assign v_cod_portad_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa = v_cod_portad_multi_sel.
        end.
        when 3 then do:
            assign v_log_forma_pagto_multi_sel = yes
                   v_cod_forma_pagto_multi_sel = v_cod_forma_pagto_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa.
            if  search("prgfin/apb/apb005ka.r") = ? and search("prgfin/apb/apb005ka.p") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb005ka.p".
                else do:
                    message "Programa execut†vel n∆o foi encontrado:" + "prgfin/apb/apb005ka.p"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/apb/apb005ka.p /*prg_sea_forma_pagto*/.
            assign v_cod_forma_pagto_multi_sel_tela:screen-value in frame f_dlg_01_tit_ap_faixa = v_cod_forma_pagto_multi_sel.
        end.
    end /* case procura */.

END PROCEDURE. /* pi_filters_dlg_01_tit_ap_faixa */
/*****************************************************************************
** Procedure Interna.....: pi_row_entry_tit_ap_bcio
** Descricao.............: pi_row_entry_tit_ap_bcio
** Criado por............: fut35118
** Criado em.............: 08/08/2007 10:55:21
** Alterado por..........: fut35118
** Alterado em...........: 08/08/2007 11:00:08
*****************************************************************************/
PROCEDURE pi_row_entry_tit_ap_bcio:

    if (v_log_nao_concil or 
        v_log_concil_confer or
        v_log_layout_sacad = no) then do:

        if avail tt_tit_ap_em_bco and 
          (tt_tit_ap_em_bco.tta_log_concil = yes or
           tt_tit_ap_em_bco.tta_log_tit_cancel = yes or
           v_cdn_fornec_tit_ap_bcio <> tt_tit_ap_em_bco.tta_cdn_fornecedor) then do:

            /* Zera a vari†vel v_cdn_fornec_tit_ap_bcio para que depois faáa o refresh dos dados */
            if tt_tit_ap_em_bco.tta_log_concil = yes or
               tt_tit_ap_em_bco.tta_log_tit_cancel = yes then
                assign v_cdn_fornec_tit_ap_bcio = 0.
            else    
                assign v_cdn_fornec_tit_ap_bcio = tt_tit_ap_em_bco.tta_cdn_fornecedor.

            assign v_log_method = session:set-wait-state('general').
            run pi_open_tt_tit_ap_conciliacao /*pi_open_tt_tit_ap_conciliacao*/.
            assign v_log_method = session:set-wait-state('').
        end.        
    end.

    if v_log_layout_sacad = no then do:
        disable bt_check7
                with frame f_dlg_03_varredura_sacado.
    end.
END PROCEDURE. /* pi_row_entry_tit_ap_bcio */
/*****************************************************************************
** Procedure Interna.....: pi_btok_dlg_01_tit_ap_faixa
** Descricao.............: pi_btok_dlg_01_tit_ap_faixa
** Criado por............: fut35118
** Criado em.............: 08/08/2007 11:06:45
** Alterado por..........: fut35118
** Alterado em...........: 08/08/2007 11:08:14
*****************************************************************************/
PROCEDURE pi_btok_dlg_01_tit_ap_faixa:

    assign v_cod_tip_faixa = "tit_ap" /*l_tit_ap*/ .

    run pi_vld_faixa_informada (Input v_cod_tip_faixa) /*pi_vld_faixa_informada*/.

    assign v_cod_tip_faixa = "" /*l_null*/ .

    if  return-value <> "OK" /*l_ok*/ 
    then do:
        assign v_log_tit_ap_faixa_ok = no.
    end /* if */.
    else do:
        assign v_log_tit_ap_faixa_ok = yes
               v_log_tit_ap_habilita = yes.
    end /* else */.

    if v_log_tit_ap_faixa_ok = yes then do:
        assign  v_cod_estab_apb_inic            = input frame f_dlg_01_tit_ap_faixa v_cod_estab_apb_inic
                v_cod_estab_apb_fim             = input frame f_dlg_01_tit_ap_faixa v_cod_estab_apb_fim
                v_dat_vencto_apb_inic           = input frame f_dlg_01_tit_ap_faixa v_dat_vencto_apb_inic
                v_dat_vencto_apb_fim            = input frame f_dlg_01_tit_ap_faixa v_dat_vencto_apb_fim            
                v_dat_emis_apb_inic             = input frame f_dlg_01_tit_ap_faixa v_dat_emis_apb_inic
                v_dat_emis_apb_fim              = input frame f_dlg_01_tit_ap_faixa v_dat_emis_apb_fim
                v_val_origin_apb_inic           = input frame f_dlg_01_tit_ap_faixa v_val_origin_apb_inic
                v_val_origin_apb_fim            = input frame f_dlg_01_tit_ap_faixa v_val_origin_apb_fim
                v_cod_portad_multi_sel_tela     = input frame f_dlg_01_tit_ap_faixa v_cod_portad_multi_sel_tela
                v_cod_forma_pagto_multi_sel_tela = input frame f_dlg_01_tit_ap_faixa v_cod_forma_pagto_multi_sel_tela
                v_cod_espec_multi_sel_tela      = input frame f_dlg_01_tit_ap_faixa v_cod_espec_multi_sel_tela.
    end.
END PROCEDURE. /* pi_btok_dlg_01_tit_ap_faixa */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_valor_orig_tit_ap
** Descricao.............: pi_retorna_valor_orig_tit_ap
** Criado por............: fut40574
** Criado em.............: 22/03/2011 16:48:12
** Alterado por..........: fut40574
** Alterado em...........: 22/03/2011 16:56:50
*****************************************************************************/
PROCEDURE pi_retorna_valor_orig_tit_ap:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_tit_ap
        for tit_ap.
    def output param p_val_origin_tit_ap
        as decimal
        format "->>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_ap_avmn
        for movto_tit_ap.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_ap_impl
        for movto_tit_ap.
    &endif


    /*************************** Buffer Definition End **************************/

    assign p_val_origin_tit_ap = p_tit_ap.val_origin_tit_ap.

    find first b_movto_tit_ap_impl no-lock
         where b_movto_tit_ap_impl.cod_estab         = p_tit_ap.cod_estab
           and b_movto_tit_ap_impl.num_id_tit_ap     = p_tit_ap.num_id_tit_ap
           and b_movto_tit_ap_impl.ind_trans_ap      = "Implantaá∆o" /*l_implantacao*/  
           and b_movto_tit_ap_impl.log_movto_estordo = no no-error.
    if avail b_movto_tit_ap_impl then do:
        for each b_movto_tit_ap_avmn no-lock
           where b_movto_tit_ap_avmn.cod_estab         = b_movto_tit_ap_impl.cod_estab
             and b_movto_tit_ap_avmn.num_id_tit_ap     = b_movto_tit_ap_impl.num_id_tit_ap 
             and b_movto_tit_ap_avmn.cod_refer         = b_movto_tit_ap_impl.cod_refer
             and b_movto_tit_ap_avmn.ind_trans_ap      = "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/ 
             and b_movto_tit_ap_avmn.log_movto_estordo = no:

            assign p_val_origin_tit_ap = p_val_origin_tit_ap - b_movto_tit_ap_avmn.val_movto_ap.
        end.
    end.
END PROCEDURE. /* pi_retorna_valor_orig_tit_ap */
/*****************************************************************************
** Procedure Interna.....: pi_busca_matriz_fornecedor_aux
** Descricao.............: pi_busca_matriz_fornecedor_aux
** Criado por............: fut31947
** Criado em.............: 22/11/2012 09:36:13
** Alterado por..........: jeffersonsil
** Alterado em...........: 30/10/2015 13:50:32
*****************************************************************************/
PROCEDURE pi_busca_matriz_fornecedor_aux:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_pessoa_jurid_matriz
        as integer
        format ">>>,>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    &IF DEFINED(BF_FIN_MATRIZ_PESSOA) &THEN
    find pessoa_jurid no-lock 
        where pessoa_jurid.num_pessoa_jurid = b_fornecedor.num_pessoa no-error. 
    if  avail pessoa_jurid then do:

        /* RECEBER PAR∂METRO, PORQUE O NÈMERO PODE VIR TANTO DE PESSOA_FISIC,COMO PESSOA_JURID */
        for each  pessoa_jurid no-lock
            where pessoa_jurid.num_pessoa_jurid_matriz = p_num_pessoa_jurid_matriz: 
            for each tt_empresa_selec:
                for each  fornecedor no-lock
                    where fornecedor.cod_empresa  = tt_empresa_selec.tta_cod_empresa
                      and fornecedor.num_pessoa   = pessoa_jurid.num_pessoa_jurid 
                      /*and fornecedor.nom_pessoa   = pessoa_jurid.nom_pessoa*/
                      and fornecedor.cod_id_feder = pessoa_jurid.cod_id_feder: 

                    if  can-find(first tt_fornecedor_matriz
                                 where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                   and tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                    create tt_fornecedor_matriz.
                    assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                           tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                           tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                           tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
                end.
            end.
        end.

         /* RECEBER PAR∂METRO, PORQUE O NÈMERO PODE VIR TANTO DE PESSOA_FISIC,COMO PESSOA_JURID */
        for each  pessoa_fisic no-lock
            where pessoa_fisic.num_pessoa_fisic_matriz = p_num_pessoa_jurid_matriz:
            for each tt_empresa_selec:
                for each  fornecedor no-lock
                    where fornecedor.cod_empresa  = tt_empresa_selec.tta_cod_empresa
                      and fornecedor.num_pessoa   = pessoa_fisic.num_pessoa_fisic
                      /*and fornecedor.nom_pessoa   = pessoa_fisic.nom_pessoa*/
                      and fornecedor.cod_id_feder = pessoa_fisic.cod_id_feder: 

                    if  can-find(first tt_fornecedor_matriz
                                 where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                   and tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                    create tt_fornecedor_matriz.
                    assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                           tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                           tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                           tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
                end.
            end.
        end.
    end.
    else do:
        find pessoa_fisic no-lock 
            where pessoa_fisic.num_pessoa_fisic = b_fornecedor.num_pessoa no-error. 
        if  avail pessoa_fisic then do:

           /* RECEBER PAR∂METRO, PORQUE O NÈMERO PODE VIR TANTO DE PESSOA_FISIC,COMO PESSOA_JURID */
            for each  pessoa_jurid no-lock
                where pessoa_jurid.num_pessoa_jurid_matriz = p_num_pessoa_jurid_matriz:
                for each tt_empresa_selec:
                    for each  fornecedor no-lock
                        where fornecedor.cod_empresa  = tt_empresa_selec.tta_cod_empresa
                          and fornecedor.num_pessoa   = pessoa_jurid.num_pessoa_jurid 
                          /*and fornecedor.nom_pessoa   = pessoa_jurid.nom_pessoa*/
                          and fornecedor.cod_id_feder = pessoa_jurid.cod_id_feder: 

                        if  can-find(first tt_fornecedor_matriz
                                     where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                       and tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                        create tt_fornecedor_matriz.
                        assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                               tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                               tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                               tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
                    end.
                end.
            end.
            /* RECEBER PAR∂METRO, PORQUE O NÈMERO PODE VIR TANTO DE PESSOA_FISIC,COMO PESSOA_JURID */
            for each  pessoa_fisic no-lock
                where pessoa_fisic.num_pessoa_fisic_matriz = p_num_pessoa_jurid_matriz:
                for each tt_empresa_selec:
                    for each  fornecedor no-lock
                        where fornecedor.cod_empresa  = tt_empresa_selec.tta_cod_empresa
                          and fornecedor.num_pessoa   = pessoa_fisic.num_pessoa_fisic 
                          /*and fornecedor.nom_pessoa   = pessoa_fisic.nom_pessoa*/
                          and fornecedor.cod_id_feder = pessoa_fisic.cod_id_feder: 

                        if  can-find(first tt_fornecedor_matriz
                                     where tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                                       and tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor) then next.

                        create tt_fornecedor_matriz.
                        assign tt_fornecedor_matriz.cod_empresa    = fornecedor.cod_empresa
                               tt_fornecedor_matriz.cdn_fornecedor = fornecedor.cdn_fornecedor
                               tt_fornecedor_matriz.cod_id_feder   = fornecedor.cod_id_feder
                               tt_fornecedor_matriz.nom_abrev      = fornecedor.nom_abrev.
                    end.
                end.
            end.
        end.
    end.
    &ENDIF
END PROCEDURE. /* pi_busca_matriz_fornecedor_aux */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/
&endif

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
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
                "Programa Mensagem " c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/********************  End of fnc_tit_ap_bcio_conciliacao *******************/

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
