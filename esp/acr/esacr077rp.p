/*****************************************************************************
** Programa..............: esp/esacr077rp.p
** Descriá∆o.............: Baixa autom†tica de saldos (reduzir valores de 
**                         impostos)
** Autor.................: Andrey M Oliveira
** Criado em.............: 23/06/2020
*****************************************************************************/
{include/i-prgvrs.i esacr077rp 1.00.00.000}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab       LIKE tit_acr.cod_estab      
    FIELD cod_espec_docto LIKE tit_acr.cod_espec_docto
    FIELD cod_ser_docto   LIKE tit_acr.cod_ser_docto  
    FIELD cod_tit_acr     LIKE tit_acr.cod_tit_acr    
    FIELD cod_parcela     LIKE tit_acr.cod_parcela
    FIELD dat_baixa       LIKE tit_acr.dat_emis_docto
    FIELD val_baixa       LIKE tit_acr.val_sdo_tit_acr
    FIELD cod_conta       LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD cod_portador    LIKE tit_acr.cod_portador
    FIELD cod_cart_bcia   LIKE tit_acr.cod_cart_bcia
    FIELD des_text_histor AS CHAR FORMAT "x(2000)".

def temp-table tt-erro no-undo
    field i-sequen         as int
    field tipo             as int
    field cod_estab        LIKE tit_acr.cod_estab      
    field cod_espec_docto  LIKE tit_acr.cod_espec_docto
    field cod_ser_docto    LIKE tit_acr.cod_ser_docto  
    field cod_tit_acr      LIKE tit_acr.cod_tit_acr    
    field cod_parcela      LIKE tit_acr.cod_parcela    
    field cd-erro          as int
    field mensagem         as char format "x(255)".

DEFINE TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nom-arquivo      AS CHARACTER
    FIELD nom-completo     AS CHARACTER
    FIELD ind-tipo-arquivo AS CHARACTER.

def temp-table tt_alter_tit_acr_base_4 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Alteraá∆o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agància Cobranáa" column-label "Agància Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquidaá∆o" column-label "Prev Liquidaá∆o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situaá∆o T°tulo" column-label "Situaá∆o T°tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condiá∆o Cobranáa" column-label "Cond Cobranáa"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N∆o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobranáa" column-label "Tipo Cobranáa"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L°quido" column-label "Vl L°quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc†ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc†ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N∆o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobranáa" column-label "Obs Cobranáa"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condiá∆o Pagto" column-label "Condiá∆o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carància" column-label "Dias Carància"
    field ttv_log_assume_tax_bco           as logical format "Sim/N∆o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N∆o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N∆o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_base_5 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Alteraá∆o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agància Cobranáa" column-label "Agància Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquidaá∆o" column-label "Prev Liquidaá∆o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situaá∆o T°tulo" column-label "Situaá∆o T°tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condiá∆o Cobranáa" column-label "Cond Cobranáa"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N∆o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobranáa" column-label "Tipo Cobranáa"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L°quido" column-label "Vl L°quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc†ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc†ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N∆o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobranáa" column-label "Obs Cobranáa"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condiá∆o Pagto" column-label "Condiá∆o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carància" column-label "Dias Carància"
    field ttv_log_assume_tax_bco           as logical format "Sim/N∆o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N∆o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N∆o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    field ttv_log_estorn_impto_retid       as logical format "Sim/N∆o" initial yes
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_base_5_old no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Alteraá∆o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agància Cobranáa" column-label "Agància Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquidaá∆o" column-label "Prev Liquidaá∆o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situaá∆o T°tulo" column-label "Situaá∆o T°tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condiá∆o Cobranáa" column-label "Cond Cobranáa"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N∆o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobranáa" column-label "Tipo Cobranáa"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L°quido" column-label "Vl L°quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc†ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc†ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N∆o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobranáa" column-label "Obs Cobranáa"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condiá∆o Pagto" column-label "Condiá∆o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carància" column-label "Dias Carància"
    field ttv_log_assume_tax_bco           as logical format "Sim/N∆o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N∆o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N∆o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_base_5_old_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Alteraá∆o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agància Cobranáa" column-label "Agància Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquidaá∆o" column-label "Prev Liquidaá∆o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situaá∆o T°tulo" column-label "Situaá∆o T°tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condiá∆o Cobranáa" column-label "Cond Cobranáa"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N∆o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobranáa" column-label "Tipo Cobranáa"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L°quido" column-label "Vl L°quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc†ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc†ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N∆o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobranáa" column-label "Obs Cobranáa"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condiá∆o Pagto" column-label "Condiá∆o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Carància" column-label "Dias Carància"
    field ttv_log_assume_tax_bco           as logical format "Sim/N∆o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N∆o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N∆o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss∆o" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "Previs∆o Apresent" column-label "Previs∆o Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "Previs∆o CrÇdito" column-label "Previs∆o CrÇdito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/N∆o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep¢sito" label "Destino Cheque" column-label "Destino Cheque"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren_bco           ascending
          tta_num_cheque                   ascending.

def temp-table tt_alter_tit_acr_cobr_espec_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequància" column-label "Sequància"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C¢digo Cart∆o" column-label "C¢digo Cart∆o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C¢d PrÇ-Autorizaá∆o" column-label "C¢d PrÇ-Autorizaá∆o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart∆o" column-label "Validade Cart∆o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D°gito Cta Corrente" column-label "D°gito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/N∆o" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situaá∆o T°tulo" column-label "Situaá∆o T°tulo"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_val_tot_sdo_tit_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Val Total Parcelas" column-label "Val Total Parcelas"
    field tta_cod_autoriz_bco_emissor      as character format "x(6)" label "Autorizacao Venda" column-label "Autorizacao Venda"
    field tta_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_cobr_esp_2_c no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_band                     as character format "x(10)" label "Bandeira" column-label "Bandeira"
    field tta_cod_tid                      as character format "x(10)" label "TID" column-label "TID"
    field tta_cod_terminal                 as character format "x(8)" label "Nr Terminal" column-label "Nr Terminal".

def temp-table tt_alter_tit_acr_comis no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
&ENDIF
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.08" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
&IF "{&emsfin_version}" >= "5.08" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss∆o" column-label "% Comis Emiss∆o"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/N∆o" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss∆o" column-label "Tipo Comiss∆o"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_comis_1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
&ENDIF
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.08" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
&IF "{&emsfin_version}" >= "5.08" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss∆o" column-label "% Comis Emiss∆o"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/N∆o" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss∆o" column-label "Tipo Comiss∆o"
    field ttv_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo de Comiss∆o" column-label "Tipo de Comiss∆o"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto Comis" column-label "Lib Comis"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_comis_old no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
&ENDIF
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.08" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
&IF "{&emsfin_version}" >= "5.08" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comiss∆o" column-label "% Comiss∆o"
&ENDIF
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss∆o" column-label "% Comis Emiss∆o"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/N∆o" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss∆o" column-label "Tipo Comiss∆o"
    field ttv_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo de Comiss∆o" column-label "Tipo de Comiss∆o"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto Comis" column-label "Lib Comis"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_impto_retid_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al°quota" column-label "Aliq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_impto_refer_tit_acr      ascending.

def temp-table tt_alter_tit_acr_iva no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al°quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending.

def temp-table tt_alter_tit_acr_ped_vda no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Operaá∆o"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_ped_vda                  ascending.

def temp-table tt_alter_tit_acr_rateio no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_ind_tip_rat_tit_acr          as character format "X(12)" label "Tipo Rateio" column-label "Tipo Rateio"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/N∆o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropriaá∆o" column-label "Tipo Apropriaá∆o"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropriaá∆o" column-label "Id Apropriaá∆o"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    index tt_aprpdspa_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_num_id_aprop_despes_recta    ascending
    index tt_aprpdspa_token                is unique
          tta_cod_estab                    ascending
          tta_num_id_aprop_despes_recta    ascending.

def new shared temp-table tt_converter_finalid_econ no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transaá∆o" column-label "Transaá∆o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Projeá∆o" column-label "G/P Projeá∆o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers∆o" column-label "Forma Convers∆o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".


def new shared temp-table tt_dat_correc no-undo
    field ttv_dat_correc                   as date format "99/99/9999" initial today label "Data Correá∆o" column-label "Data Correá∆o".


def temp-table tt_log_erros_alter_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          ttv_num_mensagem                 ascending.

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".


def new shared temp-table tt_lote_impl_tit_cheq_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_erro                     as logical format "Sim/N∆o" initial yes
    index tt_cod_estab                     is primary unique
          tta_cod_estab                    ascending
    index tt_log_erro                     
          ttv_log_erro                     ascending.

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

def temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(35)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending.

{esp/es0018.i}

DEF STREAM s_log.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

DEF VAR v_cod_usuar_corren AS CHAR                  NO-UNDO.
DEF VAR h-acomp            AS HANDLE                NO-UNDO.
DEF VAR raw-tit-acr        AS RAW                   NO-UNDO.
DEF VAR v_dir_import       AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_dir_backup       AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_dir_log          AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_arq_log          AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR c-lin              AS CHAR                  NO-UNDO.
DEF VAR v_parcela          LIKE tit_acr.cod_parcela NO-UNDO.
DEF VAR v_cod_tit_acr      LIKE tit_acr.cod_tit_acr NO-UNDO.
DEF VAR i_cont             AS INT INIT 0            NO-UNDO.
DEF VAR v_tamanho          AS INT INIT 0            NO-UNDO.
DEF VAR v_hdl_program      AS HANDLE                NO-UNDO.
DEF VAR v_log_refer_unica  AS LOG                   NO-UNDO.
DEF VAR v_cod_refer        AS CHAR                  NO-UNDO.
DEF VAR i-seq-erro-aux     AS INT                   NO-UNDO.

DEFINE STREAM s_import.

EMPTY TEMP-TABLE tt_tit_acr.
EMPTY TEMP-TABLE tt-param.
EMPTY TEMP-TABLE tt-arquivo.
EMPTY TEMP-TABLE tt-erro.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

RUN esp/es0018p.p (INPUT "esacr077",
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
    
        IF  NOT tt-arquivo.nom-arquivo BEGINS "BAIXAS":U 
        OR  tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN
            DELETE tt-arquivo.
    END.
    
    run prgfin/acr/acr711zv.py persistent set v_hdl_program.
    
    FOR EACH tt-arquivo:
    
        EMPTY TEMP-TABLE tt_tit_acr.

        bloco_baixas:
        DO TRANSACTION ON ERROR UNDO bloco_baixas,  LEAVE bloco_baixas:

            INPUT FROM VALUE(tt-arquivo.nom-completo).
            IMPORT UNFORMATTED c-lin.
            
            REPEAT:
                IMPORT UNFORMATTED c-lin.
            
                ASSIGN v_cod_tit_acr = trim(ENTRY(4,c-lin,";")).
                
                /*
                ASSIGN v_tamanho = LENGTH(v_cod_tit_acr).
            
                IF  v_tamanho < 7 THEN DO:
                    ASSIGN i_cont = v_tamanho.
            
                    DO  WHILE i_cont < 7:
                        ASSIGN v_cod_tit_acr = "0" + v_cod_tit_acr
                               i_cont        = i_cont + 1.
                    END.
                END.
                */

                ASSIGN v_parcela = trim(ENTRY(5,c-lin,";")).

                /*
                ASSIGN v_tamanho = LENGTH(v_parcela).
            
                IF  v_tamanho < 2 THEN DO:
                    ASSIGN i_cont = v_tamanho.
            
                    DO  WHILE i_cont < 2:
                        ASSIGN v_parcela = "0" + v_parcela
                               i_cont        = i_cont + 1.
                    END.
                END.
                */

                CREATE tt_tit_acr.
                ASSIGN tt_tit_acr.cod_estab       = ENTRY(1,c-lin,";")
                       tt_tit_acr.cod_espec_docto = ENTRY(2,c-lin,";")
                       tt_tit_acr.cod_ser_docto   = ENTRY(3,c-lin,";")
                       tt_tit_acr.cod_tit_acr     = v_cod_tit_acr
                       tt_tit_acr.cod_parcela     = v_parcela
                       tt_tit_acr.dat_baixa       = date(ENTRY(6,c-lin,";"))
                       tt_tit_acr.val_baixa       = dec(ENTRY(7,c-lin,";"))
                       tt_tit_acr.cod_conta       = ENTRY(8,c-lin,";")
                       tt_tit_acr.cod_portador    = ENTRY(9,c-lin,";")
                       tt_tit_acr.des_text_histor = ENTRY(10,c-lin,";").
            
                RUN pi-acompanhar IN h-acomp (INPUT "Importando titulos " + STRING(tt_tit_acr.cod_tit_acr)).
            END.
        
            EMPTY TEMP-TABLE tt_log_erros_alter_tit_acr     NO-ERROR.
            
            FOR EACH tt_tit_acr NO-LOCK:
                RUN pi-acompanhar IN h-acomp (INPUT "Baixando t°tulo: " + STRING(tt_tit_acr.cod_tit_acr)).
            
                EMPTY TEMP-TABLE tt_alter_tit_acr_base_5        NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_rateio        NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_ped_vda       NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_comis_1       NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_cheq          NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_iva           NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_impto_retid_2 NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_cobr_espec_2  NO-ERROR.
                EMPTY TEMP-TABLE tt_alter_tit_acr_rat_desp_rec  NO-ERROR.
                
                FIND FIRST tit_acr
                     WHERE tit_acr.cod_estab       = tt_tit_acr.cod_estab      
                     AND   tit_acr.cod_espec_docto = tt_tit_acr.cod_espec_docto
                     AND   tit_acr.cod_ser_docto   = tt_tit_acr.cod_ser_docto  
                     AND   tit_acr.cod_tit_acr     = tt_tit_acr.cod_tit_acr    
                     AND   tit_acr.cod_parcela     = tt_tit_acr.cod_parcela NO-LOCK NO-ERROR.
            
                IF  NOT AVAIL tit_acr THEN DO:
                    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
            
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                           tt-erro.tipo            = 1
                           tt-erro.cod_estab       = tt_tit_acr.cod_estab      
                           tt-erro.cod_espec_docto = tt_tit_acr.cod_espec_docto
                           tt-erro.cod_ser_docto   = tt_tit_acr.cod_ser_docto  
                           tt-erro.cod_tit_acr     = tt_tit_acr.cod_tit_acr    
                           tt-erro.cod_parcela     = tt_tit_acr.cod_parcela
                           tt-erro.cd-erro         = 17006
                           tt-erro.mensagem        = "T°tulo n∆o localizado para a chave informada.".

                    /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                END.
                ELSE DO:
            
                    ASSIGN v_log_refer_unica = NO.
                
                    DO WHILE NOT v_log_refer_unica:
                        run pi_retorna_sugestao_referencia (Input "B", 
                                                            Input TODAY, 
                                                            Output v_cod_refer).
                
                        run pi_verifica_refer_unica_acr    (Input tit_acr.cod_estab,
                                                            Input v_cod_refer, 
                                                            Input "tit_acr", 
                                                            Input ?, 
                                                            OUTPUT v_log_refer_unica).
                    END.
                
                    CREATE tt_alter_tit_acr_base_5.
                    ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tit_acr.cod_estab
                           tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                           tt_alter_tit_acr_base_5.tta_dat_transacao               = tt_tit_acr.dat_baixa
                           tt_alter_tit_acr_base_5.tta_cod_refer                   = v_cod_refer
                           tt_alter_tit_acr_base_5.ttv_cod_portador_mov            = IF tt_tit_acr.cod_conta <> "" THEN ? ELSE tt_tit_acr.cod_portador
                           tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = tit_acr.val_sdo_tit_acr - tt_tit_acr.val_baixa
                           tt_alter_tit_acr_base_5.tta_cod_histor_padr             = ""
                           tt_alter_tit_acr_base_5.ttv_des_text_histor             = "Baixado pelo programa ESACR077 - Arquivo: " + tt-arquivo.nom-arquivo + " - Hist: " + tt_tit_acr.des_text_histor
                           tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ""
                           tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = 1.
                    
                    ASSIGN tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val      = "Alteraá∆o" /*'Liquidaá∆o'*/
                           tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr           = tit_acr.val_sdo_tit_acr - tt_tit_acr.val_baixa
                           tt_alter_tit_acr_base_5.tta_cod_portador              = tit_acr.cod_portador
                           tt_alter_tit_acr_base_5.tta_cod_cart_bcia             = tit_acr.cod_cart_bcia
                           tt_alter_tit_acr_base_5.tta_dat_emis_docto            = tit_acr.dat_emis_docto
                           tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr        = tit_acr.dat_vencto_tit_acr
                           tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr          = tit_acr.dat_abat_tit_acr
                           tt_alter_tit_acr_base_5.tta_dat_prev_liquidac         = tit_acr.dat_prev_liquidac 
                           tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr         = tit_acr.dat_fluxo_tit_acr 
                           tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr           = tit_acr.ind_sit_tit_acr
                           tt_alter_tit_acr_base_5.tta_cod_cond_cobr             = tit_acr.cod_cond_cobr
                           tt_alter_tit_acr_base_5.tta_val_perc_abat_acr         = tit_acr.val_perc_abat_acr
                           tt_alter_tit_acr_base_5.tta_val_abat_tit_acr          = tit_acr.val_abat_tit_acr_infor
                           tt_alter_tit_acr_base_5.tta_dat_desconto              = tit_acr.dat_desconto
                           tt_alter_tit_acr_base_5.tta_val_perc_desc             = tit_acr.val_perc_desc
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr = tit_acr.qtd_dias_carenc_juros_acr
                           tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso = tit_acr.val_perc_juros_dia_atraso
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr = tit_acr.qtd_dias_carenc_multa_acr
                           tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso     = tit_acr.val_perc_multa_atraso
                           tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo       = tit_acr.log_tit_acr_destndo
                           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco           = tit_acr.cod_tit_acr_bco
                           tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia       = tit_acr.cod_agenc_cobr_bcia
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1        = tit_acr.cod_instruc_bcia_1
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2        = tit_acr.cod_instruc_bcia_2
                           tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor    = ?
                           tt_alter_tit_acr_base_5.tta_cdn_repres                = tit_acr.cdn_repres.
                
                    IF  tt_tit_acr.cod_conta <> "" THEN DO:
                        CREATE tt_alter_tit_acr_rateio.
                        ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
                               tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val
                               tt_alter_tit_acr_rateio.tta_cod_refer                   = tt_alter_tit_acr_base_5.tta_cod_refer
                               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 1
                               tt_alter_tit_acr_rateio.tta_num_seq_refer               = 1
                               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "PADRAO"
                               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = tt_tit_acr.cod_conta
                               tt_alter_tit_acr_rateio.tta_cod_unid_negoc              = ""
                               tt_alter_tit_acr_rateio.tta_cod_tip_fluxo_financ        = ""
                               tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tt_tit_acr.val_baixa
                               tt_alter_tit_acr_rateio.tta_log_impto_val_agreg         = NO
                               tt_alter_tit_acr_rateio.tta_cod_pais                    = ""
                               tt_alter_tit_acr_rateio.tta_cod_unid_federac            = ""
                               tt_alter_tit_acr_rateio.tta_cod_imposto                 = ""
                               tt_alter_tit_acr_rateio.tta_cod_classif_impto           = ""
                               tt_alter_tit_acr_rateio.tta_dat_transacao               = tt_tit_acr.dat_baixa
                               tt_alter_tit_acr_rateio.tta_cod_plano_ccusto            = ""
                               tt_alter_tit_acr_rateio.tta_cod_ccusto                  = "".      
                    END.
                
                    RUN pi_main_code_integr_acr_alter_tit_acr_novo_12 in v_hdl_program (INPUT  12,
                                                                                        INPUT  TABLE tt_alter_tit_acr_base_5,
                                                                                        INPUT  TABLE tt_alter_tit_acr_rateio,
                                                                                        INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                                                                        INPUT  TABLE tt_alter_tit_acr_comis_1,
                                                                                        INPUT  TABLE tt_alter_tit_acr_cheq,
                                                                                        INPUT  TABLE tt_alter_tit_acr_iva,
                                                                                        INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                                                                        INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                                                                        INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                                                                        OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                                                                        INPUT  NO).
                
                    IF  CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
        
                        FOR EACH tt_log_erros_alter_tit_acr:
                            ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                            
                            CREATE tt-erro.
                            ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                   tt-erro.tipo            = 1
                                   tt-erro.cod_estab       = tt_tit_acr.cod_estab      
                                   tt-erro.cod_espec_docto = tt_tit_acr.cod_espec_docto
                                   tt-erro.cod_ser_docto   = tt_tit_acr.cod_ser_docto  
                                   tt-erro.cod_tit_acr     = tt_tit_acr.cod_tit_acr    
                                   tt-erro.cod_parcela     = tt_tit_acr.cod_parcela
                                   tt-erro.cd-erro         = tt_log_erros_alter_tit_acr.ttv_num_mensagem
                                   tt-erro.mensagem        = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda.

                            /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                        END.
                    END.
                    ELSE DO:
                        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
        
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                               tt-erro.tipo            = 2
                               tt-erro.cod_estab       = tt_tit_acr.cod_estab      
                               tt-erro.cod_espec_docto = tt_tit_acr.cod_espec_docto
                               tt-erro.cod_ser_docto   = tt_tit_acr.cod_ser_docto  
                               tt-erro.cod_tit_acr     = tt_tit_acr.cod_tit_acr    
                               tt-erro.cod_parcela     = tt_tit_acr.cod_parcela
                               tt-erro.cd-erro         = 0
                               tt-erro.mensagem        = "Baixa efetuada com sucesso.".
                    END.
                END.
            END.
        END.
        
        IF  NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
            OS-COPY   VALUE(tt-arquivo.nom-completo) VALUE(v_dir_backup + tt-arquivo.nom-arquivo).
            OS-DELETE VALUE(tt-arquivo.nom-completo) NO-ERROR.
        END.

        ASSIGN v_arq_log = v_dir_log + "log_" + tt-arquivo.nom-arquivo.

        OUTPUT STREAM s_log TO VALUE(v_arq_log).

        PUT STREAM s_log UNFORMATTED "Erros;;;;;;" SKIP.
        PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Cod Erro;Mensagem" SKIP.

        FOR EACH tt-erro
            WHERE tt-erro.tipo = 1:

            PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                 tt-erro.cod_espec_docto      ";"
                 tt-erro.cod_ser_docto        ";"
                 tt-erro.cod_tit_acr          ";"
                 tt-erro.cod_parcela          ";"
                 tt-erro.cd-erro              ";"
                 tt-erro.mensagem SKIP.
        END.

        PUT STREAM s_log UNFORMATTED SKIP(2) "Baixas Atualizadas;;;;;" SKIP.
        PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Mensagem" SKIP.
        FOR EACH tt-erro
            WHERE tt-erro.tipo = 2:

            PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                 tt-erro.cod_espec_docto      ";"
                 tt-erro.cod_ser_docto        ";"
                 tt-erro.cod_tit_acr          ";"
                 tt-erro.cod_parcela          ";" 
                 tt-erro.mensagem SKIP.
        END.
        
        OUTPUT STREAM s_log CLOSE.

        EMPTY TEMP-TABLE tt-erro.
    END.
END.

RUN pi-finalizar IN h-acomp.

RETURN "OK".


PROCEDURE pi_retorna_sugestao_referencia:

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

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/

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

PROCEDURE pi_verifica_refer_unica_acr:

    def Input param p_cod_estab
        as Character
        format "x(5)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.

    &if "{&emsfin_version}" >= "5.02" &then
    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_renegoc_acr
        for renegoc_acr.
    &endif

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "Operaá∆o financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.

END PROCEDURE.
