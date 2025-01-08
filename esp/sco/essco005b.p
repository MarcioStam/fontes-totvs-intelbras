/*****************************************************************************
** Programa..............: esp/essco005b.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 10/08/2009
*****************************************************************************/

DISABLE TRIGGERS FOR LOAD OF tit_acr_cobr_especial.

/*************************** Temp-Table Definition Begin ********************/
DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD dat_transacao         LIKE tit_acr.dat_transacao
    FIELD cod_resumo            AS CHAR FORMAT "x(12)"
    FIELD cod_tip_reg           AS INT
    FIELD cod_nsu               AS CHAR
    FIELD num_ped_EMS           LIKE ped-venda.nr-pedido  
    FIELD num_ped_parceiro      LIKE ped-venda.nr-pedcli
    FIELD cdn_cliente_orig      LIKE tit_acr.cdn_cliente
    FIELD cdn_cliente_adm       LIKE tit_acr.cdn_cliente
    FIELD cod_estab             LIKE tit_acr.cod_estab
    FIELD cod_espec             LIKE tit_acr.cod_espec
    FIELD cod_ser               LIKE tit_acr.cod_ser
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela           AS CHAR LABEL "Parcela"
    FIELD val_tit_acr_EMS       LIKE tit_acr.val_origin_tit_acr
    FIELD val_bruto_pago        LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD val_perc_adm_rv       LIKE tit_acr_cobr_especial.val_perc_remun_portad
    FIELD val_desc_tx_adm       LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD val_liquido_pago      LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD val_bruto_pago_lote   LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD val_desc_tx_adm_lote  LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD val_liquido_pago_lote LIKE tit_acr.val_origin_tit_acr FORMAT "->>>,>>>,>>9.99"
    FIELD cod_refer_liquidac    LIKE lote_liquidac_acr.cod_refer
    FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco
    FIELD des_status            AS CHAR
    FIELD rec_tit_acr           AS RECID
    FIELD rec_lote_liquidac_acr AS RECID
    FIELD LOG_an_gerada         AS LOG FORMAT "Sim/N∆o" INITIAL NO
    FIELD ind_pedido            AS CHAR LABEL "Status Pedido"
    FIELD ind_nf                AS CHAR LABEL "Status NF"
    FIELD num_parceiro          AS INT  LABEL "Parceiro"
    FIELD val_ipi               AS DECIMAL FORMAT ">>>,>>9.99"
  INDEX tt_concil
        dat_transacao           ASCENDING
        cod_resumo              ASCENDING
        cod_tip_reg             ASCENDING
        cod_nsu                 ASCENDING
        num_ped_EMS             ASCENDING.

def temp-table tt_integr_acr_liq_item_lote_3 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data CrÇdito" column-label "Data CrÇdito"
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaá∆o" column-label "Liquidaá∆o"
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autorizaá∆o Bco" column-label "Autorizacao Bco"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquidaá∆o" column-label "Vl Liquidaá∆o"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_acr               as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field tta_val_liquidac_orig            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquid Orig" column-label "Vl Liquid Orig"
    field tta_val_desc_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Orig" column-label "Vl Desc Orig"
    field tta_val_abat_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat Orig" column-label "Vl Abat Orig"
    field tta_val_despes_bcia_orig         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Bcia Orig" column-label "Vl Desp Bcia Orig"
    field tta_val_multa_tit_acr_origin     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa Orig" column-label "Vl Multa Orig"
    field tta_val_juros_tit_acr_orig       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Juros Orig" column-label "Vl Juros Orig"
    field tta_val_cm_tit_acr_orig          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM Orig" column-label "Vl CM Orig"
    field tta_val_nota_db_orig             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Nota DB" column-label "Valor Nota DB"
    field tta_log_gera_antecip             as logical format "Sim/N∆o" initial no label "Gera Antecipacao" column-label "Gera Antecipacao"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situaá∆o Item Lote" column-label "Situaá∆o Item Lote"
    field tta_log_gera_avdeb               as logical format "Sim/N∆o" initial no label "Gera Aviso DÇbito" column-label "Gera Aviso DÇbito"
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso DÇbito" column-label "Moeda Aviso DÇbito"
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso DÇbito" column-label "Aviso DÇbito"
    field tta_log_movto_comis_estordo      as logical format "Sim/N∆o" initial no label "Estorna Comiss∆o" column-label "Estorna Comiss∆o"
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C†lculo Juros" column-label "Tipo C†lculo Juros"
    field tta_log_retenc_impto_liq         as logical format "Sim/N∆o" initial no label "RetÇm na Liquidaá∆o" column-label "Ret na Liq"
    field tta_val_retenc_pis               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor PIS" column-label "PIS"
    field tta_val_retenc_cofins            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor COFINS" column-label "COFINS"
    field tta_val_retenc_csll              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CSLL" column-label "CSLL"
    index tt_rec_index                    
          ttv_rec_lote_liquidac_acr        ascending
    .

def temp-table tt_integr_acr_liquidac_lote        
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Geraá∆o" column-label "Data Geraá∆o"
    field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto"
    field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia"
    field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao"
    field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digitaá∆o" label "Situaá∆o" column-label "Situaá∆o"
    field tta_nom_arq_movimen_bcia         as character format "x(30)" label "Nom Arq Bancaria" column-label "Nom Arq Bancaria"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_log_enctro_cta               as logical format "Sim/N∆o" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_atualiz_refer            as logical format "Sim/N∆o" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/N∆o" initial no
    index tt_itlqdccr_id                   is primary unique
          tta_cod_estab_refer              ascending
          tta_cod_refer                    ascending
    .

def temp-table tt_integr_acr_abat_antecip        
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_abat_prev        
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/N∆o" initial no label "Zera Saldo" column-label "Zera Saldo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_cheq        
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss∆o" column-label "Dt Emiss"
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep¢sito" column-label "Dep¢sito"
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs∆o Dep¢sito" column-label "Previs∆o Dep¢sito"
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devoluá∆o" column-label "Motivo Devoluá∆o"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field tta_log_pend_cheq_acr            as logical format "Sim/N∆o" initial no label "Cheque Pendente" column-label "Cheque Pendente"
    field tta_log_cheq_terc                as logical format "Sim/N∆o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N∆o" initial no label "Cheque Reneg" column-label "Cheque Reneg"
    field tta_log_cheq_acr_devolv          as logical format "Sim/N∆o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    index tt_id                            is primary unique
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending
    .

def temp-table tt_integr_acr_liquidac_impto_2 no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_val_retid_indic_impto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE Imposto" column-label "Vl Retido IE Imposto"
    field tta_val_retid_indic_tit_acr      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE T°tulo" column-label "Vl Retido IE T°tulo"
    field tta_val_retid_indic_pagto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Retido Indicador Pag" column-label "Retido Indicador Pag"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_dat_cotac_indic_econ_pagto   as date format "99/99/9999" initial ? label "Dat Cotac IE Pagto" column-label "Dat Cotac IE Pagto"
    field tta_val_cotac_indic_econ_pagto   as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Val Cotac IE Pagto" column-label "Val Cotac IE Pagto"
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
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    .

def temp-table tt_integr_acr_rel_pend_cheq no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal†rio" column-label "Banco Cheque Sal†rio"
    .

def temp-table tt_integr_acr_liq_aprop_ctbl        
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    index tt_integr_acr_liq_aprop_ctbl_id  is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_integr_acr_liq_desp_rec        
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropriaá∆o" column-label "Tipo Apropriaá∆o"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    index tt_integr_acr_liq_des_rec_id     is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_cta_ctbl_ext             ascending
          tta_cod_sub_cta_ctbl_ext         ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_unid_negoc_ext           ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_ind_tip_aprop_recta_despes   ascending
    .

def temp-table tt_integr_acr_aprop_liq_antec        
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)" label "Fuxo Tit Ext" column-label "Fuxo Tit Ext"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T°tulo" column-label "Unid Negoc T°tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido"
    .

def temp-table tt_log_erros_import_liquidac        
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

def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància".


/*************************** Temp-Table Definition Begin ********************/

/*************************** Query Definition Begin *************************/
DEF QUERY qr_tt_concil_adm
    FOR tt_concil
    SCROLLING.

DEF QUERY qr_tt_concil_bol
    FOR tt_concil
    SCROLLING.

/*************************** Query Definition End ***************************/

DEF BUFFER b_tit_acr_an       FOR tit_acr.
DEF BUFFER b_tit_acr          FOR tit_acr.
DEF BUFFER b_int_concil_b2    FOR int_concil_b2.
DEF BUFFER b_int_concil_b2_12 FOR int_concil_b2.
DEF BUFFER btt_concil FOR tt_concil.
/************************** Browse Definition Begin *************************/
def browse br_tt_concil_adm query qr_tt_concil_adm display 
    tt_concil.dat_transacao         FORMAT "99/99/99" COLUMN-LABEL "Data"  
    tt_concil.cod_resumo            FORMAT "x(11)" COLUMN-LABEL "Resumo"  
    tt_concil.des_status            FORMAT "x(22)" COLUMN-LABEL "Status"
    tt_concil.cod_nsu               FORMAT "x(15)" COLUMN-LABEL "NSU / Autoriz"  
    tt_concil.num_ped_EMS           COLUMN-LABEL "Ped EMS" 
    tt_concil.num_ped_parceiro      COLUMN-LABEL "Ped Parc"
    tt_concil.cod_tit_acr           COLUMN-LABEL "T°tulo"
    tt_concil.cod_parcela           COLUMN-LABEL "Parcela" 
    tt_concil.cod_refer_liquidac    COLUMN-LABEL "Refer Liquidac"
    tt_concil.val_tit_acr_ems       COLUMN-LABEL "Vl EMS"
    tt_concil.val_bruto_pago        COLUMN-LABEL "Vl Bruto ADM"
    tt_concil.val_desc_tx_adm       COLUMN-LABEL "Vl Taxa ADM"
    tt_concil.val_liquido_pago      COLUMN-LABEL "Vl Liquido ADM"  
    tt_concil.log_an_gerada         COLUMN-LABEL "AN ?"  
    tt_concil.val_bruto_pago_lote   COLUMN-LABEL "Vl Bruto Lote"
    tt_concil.val_desc_tx_adm_lote  COLUMN-LABEL "Vl Taxa Lote"
    tt_concil.val_liquido_pago_lote COLUMN-LABEL "Vl Liquido Lote"  
    tt_concil.cdn_cliente_orig      COLUMN-LABEL "Cliente"  
    tt_concil.cod_estab             COLUMN-LABEL "Estab" 
    tt_concil.cod_espec             COLUMN-LABEL "Esp" 
    tt_concil.cod_ser               COLUMN-LABEL "Ser" 
    tt_concil.cod_tit_acr_bco       COLUMN-LABEL "Nr. Cart∆o"
    tt_concil.ind_pedido            COLUMN-LABEL "Status Pedido"
    tt_concil.ind_nf                COLUMN-LABEL "Status NF"
  with no-box separators MULTIPLE 
         size 148 by 20
         font 1
         bgcolor 15.

def browse br_tt_concil_bol query qr_tt_concil_bol display 
    tt_concil.dat_transacao      FORMAT "99/99/99" COLUMN-LABEL "Data"  
    tt_concil.num_parceiro       COLUMN-LABEL "Parceiro"
    tt_concil.num_ped_EMS        COLUMN-LABEL "Ped EMS" 
    tt_concil.num_ped_parceiro   COLUMN-LABEL "Ped Parc"
    tt_concil.cod_tit_acr        COLUMN-LABEL "T°tulo"
    tt_concil.cod_refer_liquidac COLUMN-LABEL "Refer Liquidac"
    tt_concil.val_tit_acr_ems    COLUMN-LABEL "Vl EMS"
    tt_concil.val_ipi            COLUMN-LABEL "Vl IPI"
    tt_concil.val_liquido_pago   COLUMN-LABEL "Vl Parceiro" 
    tt_concil.log_an_gerada      COLUMN-LABEL "AN ?"
    tt_concil.des_status         FORMAT "x(35)" COLUMN-LABEL "Status"
    tt_concil.cdn_cliente_orig   FORMAT ">>>>,>>>" COLUMN-LABEL "Cliente"  
    tt_concil.cod_estab          COLUMN-LABEL "Estab" 
    tt_concil.cod_espec          COLUMN-LABEL "Esp" 
    tt_concil.cod_ser            COLUMN-LABEL "Ser" 
    tt_concil.cod_tit_acr_bco    COLUMN-LABEL "N£mero Boleto"
  with no-box separators MULTIPLE 
         size 148 by 20
         font 1
         bgcolor 15.

/*************************** Browse Definition End **************************/

/************************** Variable Definition Begin ***********************/

def var v_hdl_aux
    as Handle
    format ">>>>>>9":U
    no-undo.
DEF VAR v_hld_handle         AS HANDLE NO-UNDO.
DEF VAR rs_opcao         AS CHARACTER INITIAL "Boleto" VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "Boleto", "Boleto","VisaNet/Cielo", "VisaNet","RedeCard", "RedeCard", "HiperCard", "HiperCard", "Debito Direto", "Debito Direto" BGCOLOR 15 NO-UNDO.
DEF VAR v_log_method     AS LOGICAL            NO-UNDO.
DEF VAR v_dat_ini        AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.
DEF VAR v_dat_fim        AS DATE    INIT TODAY FORMAT "99/99/9999" NO-UNDO.
DEF VAR v_sit_lote       AS CHAR NO-UNDO.
DEF VAR v_cod_portador   AS CHAR NO-UNDO.

def var v_rec_lote
    as recid
    format ">>>>>>9":U
    no-undo.

DEFINE VARIABLE v_cod_refer   AS CHARACTER  FORMAT "x(10)"      NO-UNDO.
DEFINE VARIABLE v_cod_estab   AS CHARACTER  FORMAT "x(05)"      NO-UNDO.
DEFINE VARIABLE v_data_base   AS DATE       FORMAT "99/99/9999" NO-UNDO.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_tit_acr           AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_lote_liquidac_acr AS RECID NO-UNDO.

DEFINE VARIABLE v_tot_val_bruto   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_tot_val_desc    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_tot_val_liquido AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_tot_ger_val_bruto   AS DECIMAL FORMAT "->>>,>>>,>>9.99" LABEL "Total Bruto"    NO-UNDO.
DEFINE VARIABLE v_tot_ger_val_desc    AS DECIMAL FORMAT "->>>,>>>,>>9.99" LABEL "Total Comiss∆o" NO-UNDO.
DEFINE VARIABLE v_tot_ger_val_liquido AS DECIMAL FORMAT "->>>,>>>,>>9.99" LABEL "Total Liquido"  NO-UNDO.

DEFINE VARIABLE v_pedidocodigo_aux AS INTEGER             NO-UNDO.
DEFINE VARIABLE v_log_answer       AS LOGICAL  INITIAL NO NO-UNDO.

DEFINE VARIABLE v_val_abat AS DECIMAL     NO-UNDO.

DEF RECTANGLE rt_mold SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECTANGLE rt_cxcf SIZE 1 BY 1 FGCOLOR 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok LABEL "OK" TOOLTIP "OK" SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_can LABEL "Cancela" TOOLTIP "Cancela" SIZE 1 BY 1 AUTO-ENDKEY.

DEF BUTTON bt_ret_lote LABEL "Retira Lote" TOOLTIP "Retira t°tulos do Lote"    SIZE 10 BY 1.
DEF BUTTON bt_ger_lote LABEL "Gera Lote"   TOOLTIP "Gera novo Lote"            SIZE 10 BY 1.

DEF BUTTON bt_ace_lote LABEL "Acessa Lote" TOOLTIP "Acessa lote de liquidaá∆o" SIZE 10 BY 1.

DEF BUTTON bt_apr_ped LABEL "Aprova"  TOOLTIP "Aprova Pedido"      SIZE 10 BY 1.
DEF BUTTON bt_ger_an  LABEL "Gera AN" TOOLTIP "Gera AN"            SIZE 10 BY 1.
DEF BUTTON bt_liq_bol LABEL "Liquida" TOOLTIP "Liquida Boleto"     SIZE 10 BY 1.

DEFINE VARIABLE v_val_bruto_pago_lote   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_desc_tx_adm_lote  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_liquido_pago_lote AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_val_bruto_pago_lote_tot   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_desc_tx_adm_lote_tot  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_val_liquido_pago_lote_tot AS DECIMAL     NO-UNDO.

/*************************** Varable Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_import
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 8.75 col 02.00 bgcolor 7 
    rs_opcao
         at row 02.2 col 12 colon-aligned label "Extrato"
         help "Extrato"
         fgcolor ? bgcolor ? font 2
    v_dat_ini
         at row 06.5 col 12 colon-aligned label "Per°odo"
         help "Data Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_fim
         at row 06.5 col 27 colon-aligned label "AtÇ"
         help "Data Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 08.96 col 03.00 font ?
         help "OK"
    bt_can
         at row 08.96 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 48.14 by 10.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Extrato - B2x".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_import = 10.00
           bt_can:height-chars              in frame f_import = 01.00
           bt_ok:width-chars                in frame f_import = 10.00
           bt_ok:height-chars               in frame f_import = 01.00
           rt_cxcf:width-chars              in frame f_import = 44.72
           rt_cxcf:height-chars             in frame f_import = 01.42
           rt_mold:width-chars              in frame f_import = 44.72
           rt_mold:height-chars             in frame f_import = 07.17.

def frame f_comiss_det
    rt_cxcf
         at row 23.00 col 02.00 bgcolor 7 
    br_tt_concil_bol
         AT ROW 1.21 COL 2
    br_tt_concil_adm
         AT ROW 1.21 COL 2
    v_tot_ger_val_bruto  
         AT ROW 21.8 COL 5
    v_tot_ger_val_desc   
         AT ROW 21.8 COL 28
    v_tot_ger_val_liquido
         AT ROW 21.8 COL 55
    bt_ok
         at row 23.21 col 03.00 font ?
         help "OK"
    bt_ret_lote
         at row 23.21 col 35.00 font ?
    bt_ger_lote
         at row 23.21 col 46.00 font ?
    bt_ace_lote
         at row 23.21 col 57.00 font ?
    bt_apr_ped
         at row 23.21 col 68.00 font ?
    bt_ger_an 
         at row 23.21 col 79.00 font ?
    bt_liq_bol
         at row 23.21 col 90.00 font ?
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 151 by 25 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Extrato B2x  - Detalhado".
/* adjust size of objects in this frame */
assign bt_ok:width-chars            in frame f_comiss_det = 10.00
       bt_ok:height-chars           in frame f_comiss_det = 01.00
       bt_ret_lote:width-chars      in frame f_comiss_det = 10.00
       bt_ger_lote:width-chars      in frame f_comiss_det = 10.00
       bt_ace_lote:width-chars      in frame f_comiss_det = 10.00
       bt_ret_lote:height-chars     in frame f_comiss_det = 01.00
       bt_ger_lote:height-chars     in frame f_comiss_det = 01.00
       bt_ace_lote:height-chars     in frame f_comiss_det = 01.00
       rt_cxcf:width-chars          in frame f_comiss_det = 139
       rt_cxcf:height-chars         in frame f_comiss_det = 01.42.

/*************************** Frame Definition End ***************************/

/*************************** Trigger Definition Begins **********************/

ON ROW-DISPLAY OF br_tt_concil_bol IN FRAME f_comiss_det
DO:

    IF tt_concil.val_tit_acr_EMS <> tt_concil.val_liquido_pago
    THEN DO:
         ASSIGN tt_concil.val_tit_acr_EMS:BGCOLOR IN BROWSE br_tt_concil_bol = 12
                tt_concil.val_liquido_pago:BGCOLOR     IN BROWSE br_tt_concil_bol = 12.
    END.

END.

ON ROW-DISPLAY OF br_tt_concil_adm IN FRAME f_comiss_det
DO:

    IF  tt_concil.val_tit_acr_EMS <> tt_concil.val_bruto_pago
    AND tt_concil.cod_tip_reg      = 2
    THEN DO:
         ASSIGN tt_concil.val_tit_acr_EMS:BGCOLOR IN BROWSE br_tt_concil_adm = 12
                tt_concil.val_bruto_pago:BGCOLOR     IN BROWSE br_tt_concil_adm = 12.
    END.

    IF tt_concil.cod_tip_reg = 4
    THEN DO:
         ASSIGN tt_concil.dat_transacao:BGCOLOR IN BROWSE br_tt_concil_adm = 10     
                tt_concil.cod_resumo:BGCOLOR IN BROWSE br_tt_concil_adm = 10        
                tt_concil.des_status:BGCOLOR IN BROWSE br_tt_concil_adm = 10        
                tt_concil.cod_nsu:BGCOLOR IN BROWSE br_tt_concil_adm = 10
                tt_concil.num_ped_EMS:BGCOLOR IN BROWSE br_tt_concil_adm = 10       
                tt_concil.num_ped_parceiro:BGCOLOR IN BROWSE br_tt_concil_adm = 10  
                tt_concil.cod_tit_acr:BGCOLOR IN BROWSE br_tt_concil_adm = 10
                tt_concil.cod_parcela:BGCOLOR IN BROWSE br_tt_concil_adm = 10       
                tt_concil.cod_refer_liquidac:BGCOLOR IN BROWSE br_tt_concil_adm = 10
                tt_concil.val_tit_acr_ems:BGCOLOR IN BROWSE br_tt_concil_adm = 10   
                tt_concil.val_bruto_pago:BGCOLOR IN BROWSE br_tt_concil_adm = 10    
                tt_concil.val_desc_tx_adm:BGCOLOR IN BROWSE br_tt_concil_adm = 10   
                tt_concil.val_liquido_pago:BGCOLOR IN BROWSE br_tt_concil_adm = 10  
                tt_concil.log_an_gerada:BGCOLOR IN BROWSE br_tt_concil_adm = 10  
                tt_concil.cdn_cliente_orig:BGCOLOR IN BROWSE br_tt_concil_adm = 10  
                tt_concil.cod_estab:BGCOLOR IN BROWSE br_tt_concil_adm = 10         
                tt_concil.cod_espec:BGCOLOR IN BROWSE br_tt_concil_adm = 10         
                tt_concil.cod_ser:BGCOLOR IN BROWSE br_tt_concil_adm = 10           
                tt_concil.cod_tit_acr_bco:BGCOLOR IN BROWSE br_tt_concil_adm = 10   
                tt_concil.ind_pedido:BGCOLOR IN BROWSE br_tt_concil_adm = 10
                tt_concil.ind_nf:BGCOLOR IN BROWSE br_tt_concil_adm = 10
                tt_concil.val_bruto_pago_lote:BGCOLOR IN BROWSE br_tt_concil_adm = 10  
                tt_concil.val_desc_tx_adm_lote:BGCOLOR IN BROWSE br_tt_concil_adm = 10 
                tt_concil.val_liquido_pago_lote:BGCOLOR IN BROWSE br_tt_concil_adm = 10.    
    END.


END.

ON CHOOSE OF bt_ger_lote IN FRAME f_comiss_det
DO:

  DEFINE VARIABLE v_num_row_a   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE v_log_method  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE v_log_method2 AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE v_rec_table   AS RECID       NO-UNDO.

  DEF BUTTON bt_ok  LABEL "OK" TOOLTIP "OK"           SIZE 10 BY 1 AUTO-GO.
  DEF BUTTON bt_can LABEL "Cancela" TOOLTIP "Cancela" SIZE 10 BY 1 AUTO-ENDKEY.

  DEF FRAME f_impl_lote
      rt_mold
           at row 01.21 col 02.00
      rt_cxcf
           at row 6.75 col 02.00 bgcolor 7 
      v_cod_estab
           at row 02.50 col 15 colon-aligned label "Estabelecimento"
           help "Estabelecimento"
           view-as fill-in
           size-chars 06.14 by .88
           fgcolor ? bgcolor 15 font 2
      v_cod_refer
           at row 03.50 col 15 colon-aligned label "Referància"
           help "Referància"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
      v_data_base
           at row 04.50 col 15 colon-aligned label "Data Transaá∆o"
           help "Data Transaá∆o"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
      bt_ok
           at row 06.96 col 03.00 font ?
           help "OK"
      bt_can
           at row 06.96 col 14.00 font ?
           help "Cancela"
      with 1 down side-labels no-validate keep-tab-order three-d
           size-char 48.14 by 08.58
           view-as dialog-box
           font 1 fgcolor ? bgcolor 8
           title "Implantaá∆o Lote".
      assign rt_cxcf:width-chars              in frame f_impl_lote = 44.72
             rt_cxcf:height-chars             in frame f_impl_lote = 01.42
             rt_mold:width-chars              in frame f_impl_lote = 44.72
             rt_mold:height-chars             in frame f_impl_lote = 05.17.


      ASSIGN v_cod_estab = "104"
             v_data_base = TODAY
             v_cod_refer = TRIM(SUBSTRING(rs_opcao,1,4))
                           + STRING(DAY(TODAY),'99')
                           + STRING(MONTH(TODAY),'99')
                           + STRING(77, "99"). 

      VIEW FRAME f_impl_lote.

      filter_block:
      DO ON ERROR UNDO filter_block, RETRY filter_block
                       ON ENDKEY UNDO filter_block, LEAVE filter_block:
          DISPLAY bt_can
                  bt_ok
                  v_cod_estab
                  v_cod_refer
                  v_data_base
                  WITH FRAME f_impl_lote.
          ENABLE ALL WITH FRAME f_impl_lote.

          WAIT-FOR GO OF FRAME f_impl_lote.

          ASSIGN INPUT FRAME f_impl_lote v_cod_estab v_cod_refer v_data_base.

          IF CAN-FIND (lote_liquidac_acr
                       WHERE lote_liquidac_acr.cod_estab = v_cod_estab
                         AND lote_liquidac_acr.cod_refer = v_cod_refer) 
          THEN DO:
               MESSAGE "Lote informado j† existe, informar outra referància !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
               HIDE FRAME f_impl_lote.
               RETURN NO-APPLY.
          END.

          MESSAGE "Confirma geraá∆o do Lote ?"    SKIP
                  "Estabelecimento: " v_cod_estab SKIP
                  "Referància: " v_cod_refer      SKIP
                  "Data   : " v_data_base
                VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o Lote" UPDATE choice AS LOGICAL.
        
          IF CHOICE = NO 
          THEN DO: 
               HIDE FRAME f_impl_lote.
               RETURN NO-APPLY.
          END.

          IF AVAIL tt_concil
          THEN DO:

               ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("General").

               FOR EACH tt_integr_acr_liquidac_lote:
                   DELETE tt_integr_acr_liquidac_lote.
               END.
               FOR EACH tt_integr_acr_liq_item_lote_3:
                   DELETE tt_integr_acr_liq_item_lote_3.
               END.

               delete_block:
               DO ON ERROR UNDO delete_block, LEAVE delete_block TRANSACTION:
                  DO v_num_row_a = 1 TO BROWSE br_tt_concil_adm:NUM-SELECTED-ROWS:
    
                      ASSIGN v_log_method = BROWSE br_tt_concil_adm:FETCH-SELECTED-ROW(v_num_row_a).
                      ASSIGN v_rec_table  = RECID(tt_concil).
    
                      FIND tt_concil 
                          WHERE RECID(tt_concil) = v_rec_table NO-ERROR.

                      RUN pi_elimina_item_lote.
                      RUN pi_cria_lote_novo.

                   END.

                   FIND FIRST tt_integr_acr_liq_item_lote_3 NO-ERROR.
                   IF AVAIL tt_integr_acr_liq_item_lote_3 
                   THEN DO:
                        RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hdl_aux.
                        RUN pi_main_code_api_integr_acr_liquidac_4 IN v_hdl_aux (INPUT 1,
                                                                                 INPUT TABLE tt_integr_acr_liquidac_lote,
                                                                                 Input TABLE tt_integr_acr_liq_item_lote_3,
                                                                                 INPUT TABLE tt_integr_acr_abat_antecip,
                                                                                 INPUT TABLE tt_integr_acr_abat_prev,
                                                                                 INPUT TABLE tt_integr_acr_cheq,
                                                                                 INPUT TABLE tt_integr_acr_liquidac_impto_2,
                                                                                 INPUT TABLE tt_integr_acr_rel_pend_cheq,
                                                                                 INPUT TABLE tt_integr_acr_liq_aprop_ctbl,
                                                                                 INPUT TABLE tt_integr_acr_liq_desp_rec,
                                                                                 INPUT TABLE tt_integr_acr_aprop_liq_antec,
                                                                                 INPUT "",
                                                                                 OUTPUT TABLE tt_log_erros_import_liquidac,
                                                                                 INPUT TABLE tt_integr_cambio_ems5).
                        DELETE PROCEDURE v_hdl_aux.    
                        IF CAN-FIND(FIRST tt_log_erros_import_liquidac) 
                        THEN DO:
                             FOR EACH tt_log_erros_import_liquidac:

                                 MESSAGE entry(1,tt_log_erros_import_liquidac.ttv_des_msg_erro,chr(10)) SKIP
                                         entry(2,tt_log_erros_import_liquidac.ttv_des_msg_erro,chr(10))
                                   VIEW-AS ALERT-BOX INFO BUTTONS OK.

                             END.
                             UNDO delete_block, LEAVE delete_block.
                        END.
                   END.

               END.

               ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("").

               IF NOT CAN-FIND(FIRST tt_log_erros_import_liquidac) 
               THEN DO:

                    MESSAGE "Geraá∆o Finalizada !" VIEW-AS ALERT-BOX.
  
                    RUN pi_import.
  
                    OPEN QUERY qr_tt_concil_adm
                         FOR EACH tt_concil NO-LOCK.
  
                    DISPLAY v_tot_ger_val_bruto  
                            v_tot_ger_val_desc   
                            v_tot_ger_val_liquido WITH FRAME f_comiss_det.

               END.

          END.
          ELSE DO:
               MESSAGE "Item n∆o selecionado !" VIEW-AS ALERT-BOX.
               RETURN NO-APPLY.
          END.

      END.

      HIDE FRAME f_impl_lote.

END.


ON CHOOSE OF bt_ret_lote IN FRAME f_comiss_det
DO:

  DEFINE VARIABLE v_num_row_a   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE v_log_method  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE v_log_method2 AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE v_rec_table   AS RECID       NO-UNDO.

  IF AVAIL tt_concil
  THEN DO:

       MESSAGE "Confirma a Retirada do(s) Item(ns) do Lote de Liquidaá∆o ?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.

       IF v_log_answer <> YES 
          THEN RETURN NO-APPLY.

       ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("General").

       DO v_num_row_a = 1 TO BROWSE br_tt_concil_adm:NUM-SELECTED-ROWS:

           ASSIGN v_log_method = BROWSE br_tt_concil_adm:FETCH-SELECTED-ROW(v_num_row_a).
           ASSIGN v_rec_table  = RECID(tt_concil).

           FIND tt_concil 
               WHERE RECID(tt_concil) = v_rec_table NO-ERROR.

           delete_block:
           DO ON ERROR UNDO delete_block, LEAVE delete_block TRANSACTION:

              RUN pi_elimina_item_lote.

           END.

       END.

       ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("").

       MESSAGE "Item(ns) Desvinculado(s) !" VIEW-AS ALERT-BOX.

       RUN pi_import.

       OPEN QUERY qr_tt_concil_adm
            FOR EACH tt_concil NO-LOCK.

       DISPLAY v_tot_ger_val_bruto  
               v_tot_ger_val_desc   
               v_tot_ger_val_liquido WITH FRAME f_comiss_det.

  END.
  ELSE DO:
       MESSAGE "Item n∆o selecionado !" VIEW-AS ALERT-BOX.
       RETURN NO-APPLY.
  END.

END.

ON CHOOSE OF bt_ger_an IN FRAME f_comiss_det
DO:

  def button bt_ok
      label "OK"
      tooltip "OK"
      size 1 by 1
      auto-go.
  def button bt_can
      label "Cancela"
      tooltip "Cancela"
      size 1 by 1
      auto-endkey.
  DEFINE VARIABLE i AS INTEGER     NO-UNDO.

  def frame f_impl_an
      rt_mold
           at row 01.21 col 02.00
      rt_cxcf
           at row 5.75 col 02.00 bgcolor 7 
      v_data_base
           at row 02.75 col 15 colon-aligned label "Data Implantaá∆o"
           help "Data Implantaá∆o AN"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
      bt_ok
           at row 05.96 col 03.00 font ?
           help "OK"
      bt_can
           at row 05.96 col 14.00 font ?
           help "Cancela"
      with 1 down side-labels no-validate keep-tab-order three-d
           size-char 48.14 by 07.58
           view-as dialog-box
           font 1 fgcolor ? bgcolor 8
           title "Implantaá∆o AN".
      /* adjust size of objects in this frame */
      assign bt_can:width-chars               in frame f_impl_an = 10.00
             bt_can:height-chars              in frame f_impl_an = 01.00
             bt_ok:width-chars                in frame f_impl_an = 10.00
             bt_ok:height-chars               in frame f_impl_an = 01.00
             rt_cxcf:width-chars              in frame f_impl_an = 44.72
             rt_cxcf:height-chars             in frame f_impl_an = 01.42
             rt_mold:width-chars              in frame f_impl_an = 44.72
             rt_mold:height-chars             in frame f_impl_an = 04.17.

      ASSIGN v_data_base = TODAY.
      VIEW FRAME f_impl_an.

      display bt_can
              bt_ok
              v_data_base
              with frame f_impl_an.
      enable all with frame f_impl_an.

      wait-for go of frame f_impl_an.

      assign input frame f_impl_an v_data_base.

      MESSAGE "Confirma geraá∆o das Antecipaá‰es?"
           VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AN" UPDATE choice AS LOGICAL.
      
      IF CHOICE = NO 
      THEN DO: 
           HIDE FRAME f_impl_an.
           RETURN NO-APPLY.
      END.
      
      pedidos_block:
      DO i = 1 TO br_tt_concil_bol:NUM-SELECTED-ROWS:
          
          br_tt_concil_bol:FETCH-SELECTED-ROW(i).

          IF rs_opcao = "Boleto" THEN DO:

              FIND ped-venda NO-LOCK
                  WHERE ped-venda.nr-pedido = tt_concil.num_ped_EMS NO-ERROR.
        
              IF NOT AVAIL ped-venda 
              THEN DO:
                   MESSAGE "Pedido " + STRING(tt_concil.num_ped_EMS) + " n∆o localizado!" SKIP
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   NEXT pedidos_block.
              END.
        
              IF ped-venda.cod-sit-aval <> 3  
              THEN DO:
                   MESSAGE "Pedido " + STRING(ped-venda.nr-pedido) + " n∆o Aprovado !" SKIP
                           "Efetuar a aprovaá∆o do pedido antes de gerar a AN."
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   NEXT pedidos_block.
              END.
    
         END.

         IF  tt_concil.rec_tit_acr <> ?
         AND rs_opcao = "Boleto"
         THEN DO:
              MESSAGE "T°tulo j† integrado com o ACR !" SKIP
                      "Pode ser Liquidado sem gerar AN." SKIP
                      tt_concil.cod_estab "/" tt_concil.cod_espec "/" tt_concil.cod_ser "/" tt_concil.cod_tit_acr "/" tt_concil.cod_parcela
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
              NEXT pedidos_block.
         END.

         IF  tt_concil.rec_tit_acr = ?
         AND rs_opcao <> "Boleto"
         THEN DO:
              MESSAGE "T°tulo n∆o integrado com o ACR !" SKIP
                      tt_concil.cod_estab "/" tt_concil.cod_espec "/" tt_concil.cod_ser "/" tt_concil.cod_tit_acr "/" tt_concil.cod_parcela
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              NEXT pedidos_block.
         END.

         FIND b_tit_acr NO-LOCK 
            WHERE b_tit_acr.cod_estab           = "101"
              AND b_tit_acr.cod_espec           = "AN"
              AND b_tit_acr.cod_ser             = "5"
              AND b_tit_acr.cod_tit_acr         = "B2" + STRING(tt_concil.num_ped_ems)
              AND b_tit_acr.cod_parcela         = IF rs_opcao = "Boleto" THEN "01" ELSE SUBSTRING(tt_concil.cod_parcela, 1, 2) NO-ERROR.
         IF AVAIL b_tit_acr 
         THEN DO:
              MESSAGE "AN j† existente !" SKIP
                  b_tit_acr.cod_estab "/" b_tit_acr.cod_espec "/" b_tit_acr.cod_ser "/" b_tit_acr.cod_tit_acr "/" b_tit_acr.cod_parcela
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
              NEXT pedidos_block.
         END.

         ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
         RUN esp/sco/essco005a.p(INPUT "101",
                                 INPUT v_data_base,
                                 INPUT tt_concil.val_tit_acr_EMS,
                                 INPUT STRING(tt_concil.num_ped_ems),
                                 INPUT IF rs_opcao = "Boleto" THEN tt_concil.cdn_cliente_orig ELSE tt_concil.cdn_cliente_adm,
                                 INPUT IF rs_opcao = "Boleto" THEN "01" ELSE SUBSTRING(tt_concil.cod_parcela, 1, 2)).
         ASSIGN v_log_method = session:SET-WAIT-STATE("").

     END.

     RUN pi_import.

     IF rs_opcao = "Boleto" 
        THEN OPEN QUERY qr_tt_concil_bol
                  FOR EACH tt_concil NO-LOCK.
        ELSE OPEN QUERY qr_tt_concil_adm
                  FOR EACH tt_concil NO-LOCK.

     DISPLAY v_tot_ger_val_bruto  
             v_tot_ger_val_desc   
             v_tot_ger_val_liquido WITH FRAME f_comiss_det.

     HIDE FRAME f_impl_an.

END.

ON CHOOSE OF bt_liq_bol IN FRAME f_comiss_det
DO:

    def button bt_ok
        label "OK"
        tooltip "OK"
        size 1 by 1
        auto-go.
    def button bt_can
        label "Cancela"
        tooltip "Cancela"
        size 1 by 1
        auto-endkey.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    def frame f_liq_bol
        rt_mold at row 01.21 col 02.00
        rt_cxcf at row 5.75 col 02.00 bgcolor 7 
        v_data_base
           at row 02.75 col 15 colon-aligned label "Data Liquidaá∆o"
           help "Data Liquidaá∆o"
           view-as fill-in
           size-chars 11.14 by .88
           fgcolor ? bgcolor 15 font 2
        bt_ok
           at row 05.96 col 03.00 font ?
           help "OK"
        bt_can
           at row 05.96 col 14.00 font ?
           help "Cancela"
        with 1 down side-labels no-validate keep-tab-order three-d
           size-char 48.14 by 07.58
           view-as dialog-box
           font 1 fgcolor ? bgcolor 8
           title "Liquidaá∆o T°tulo".
        /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_liq_bol = 10.00
            bt_can:height-chars              in frame f_liq_bol = 01.00
            bt_ok:width-chars                in frame f_liq_bol = 10.00
            bt_ok:height-chars               in frame f_liq_bol = 01.00
            rt_cxcf:width-chars              in frame f_liq_bol = 44.72
            rt_cxcf:height-chars             in frame f_liq_bol = 01.42
            rt_mold:width-chars              in frame f_liq_bol = 44.72
            rt_mold:height-chars             in frame f_liq_bol = 04.17.

    ASSIGN v_data_base = TODAY.
    VIEW FRAME f_liq_bol.

    display bt_can
            bt_ok
            v_data_base
        with frame f_liq_bol.
    
    enable all with frame f_liq_bol.
    wait-for go of frame f_liq_bol.

    assign INPUT frame f_liq_bol v_data_base.
    
    MESSAGE "Confirma Liquidaá∆o DOS T°tulos em: " v_data_base " ?" 
        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Liquidaá∆o T°tulo" UPDATE choice2 AS LOGICAL.
    
    IF CHOICE2 = NO THEN DO: 
        HIDE FRAME f_liq_bol.
        RETURN NO-APPLY.
    END.

    pedidos_block:
    DO i = 1 TO br_tt_concil_bol:NUM-SELECTED-ROWS:

        br_tt_concil_bol:FETCH-SELECTED-ROW(i).

        IF  AVAIL tt_concil
        AND tt_concil.cod_refer_liquidac = "Pendente" 
        THEN DO:

            FIND b_tit_acr NO-LOCK 
                WHERE b_tit_acr.cod_estab           = "101"
                  AND b_tit_acr.cod_espec           = "AN"
                  AND b_tit_acr.cod_ser             = "5"
                  AND b_tit_acr.cod_tit_acr         = "B2" + STRING(tt_concil.num_ped_ems)
                  AND b_tit_acr.cod_parcela         = "01"
                  AND b_tit_acr.val_sdo_tit_acr     > 0
                  AND b_tit_acr.log_tit_acr_estordo = NO NO-ERROR.
              
            IF AVAIL b_tit_acr 
                THEN ASSIGN v_val_abat = b_tit_acr.val_sdo_tit_acr.
                ELSE ASSIGN v_val_abat = 0.
            IF v_val_abat > tt_concil.val_tit_acr_EMS 
                THEN v_val_abat = tt_concil.val_tit_acr_EMS.

            IF v_val_abat <> 0 
            THEN DO:
                MESSAGE "Cliente possui AN gerada para o pedido " STRING(tt_concil.num_ped_ems) SKIP 
                        "Deseja utilizar nesta liquidaá∆o ? " SKIP
                        "Valor AN: " STRING(v_val_abat, ">>>>,>>9.99")
                    VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Abater AN" UPDATE choice AS LOGICAL.
                IF CHOICE = NO 
                    THEN ASSIGN v_val_abat = 0.
            END.

            ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
            RUN pi_liquidac_bol.  
            ASSIGN v_log_method = session:SET-WAIT-STATE("").

        END.
        ELSE DO:
            MESSAGE "T°tulo n∆o Localizado ou j† Liquidado !"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    RUN pi_import.

    OPEN QUERY qr_tt_concil_bol
        FOR EACH tt_concil NO-LOCK.

    DISPLAY v_tot_ger_val_bruto  
            v_tot_ger_val_desc   
            v_tot_ger_val_liquido WITH FRAME f_comiss_det.

    HIDE FRAME f_liq_bol.

END.


ON CHOOSE OF bt_ace_lote IN FRAME f_comiss_det
DO:

   DEF VAR v_wgh_current_window AS WIDGET-HANDLE FORMAT ">>>>>>9":U NO-UNDO.

   IF  AVAIL tt_concil
   AND tt_concil.rec_lote_liquidac_acr <> ?
   THEN DO:

        ASSIGN v_rec_lote_liquidac_acr = tt_concil.rec_lote_liquidac_acr.

        ASSIGN v_wgh_current_window        = CURRENT-WINDOW 
               CURRENT-WINDOW:WINDOW-STATE = 2
               CURRENT-WINDOW:VISIBLE      = NO.
      
        RUN prgfin/acr/acr726aa.p.
      
        ASSIGN CURRENT-WINDOW              = v_wgh_current_window
               CURRENT-WINDOW:WINDOW-STATE = 3
               CURRENT-WINDOW:VISIBLE      = YES.

        RUN pi_import.

        OPEN QUERY qr_tt_concil_bol
             FOR EACH tt_concil NO-LOCK.

        DISPLAY v_tot_ger_val_bruto  
                v_tot_ger_val_desc   
                v_tot_ger_val_liquido WITH FRAME f_comiss_det.
      
   END.
   ELSE DO:
        MESSAGE "Lote de Liquidaá∆o n∆o Localizada ou j† Atualizado !"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
   END.

END.

ON MOUSE-SELECT-DBLCLICK OF br_tt_concil_bol IN FRAME f_comiss_det
OR MOUSE-SELECT-DBLCLICK OF br_tt_concil_adm IN FRAME f_comiss_det
DO:

   DEF VAR v_wgh_current_window AS WIDGET-HANDLE FORMAT ">>>>>>9":U NO-UNDO.

   IF  AVAIL tt_concil
   AND tt_concil.rec_tit_acr <> ?
   THEN DO:

        ASSIGN v_rec_tit_acr = tt_concil.rec_tit_acr.

        ASSIGN v_wgh_current_window        = CURRENT-WINDOW 
               CURRENT-WINDOW:WINDOW-STATE = 2
               CURRENT-WINDOW:VISIBLE      = NO.
      
        RUN prgfin/acr/acr212aa.p.
      
        ASSIGN CURRENT-WINDOW              = v_wgh_current_window
               CURRENT-WINDOW:WINDOW-STATE = 3
               CURRENT-WINDOW:VISIBLE      = YES.
      
    END.
    ELSE DO:
         MESSAGE "T°tulo n∆o Localizado !"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END.

ON CHOOSE OF bt_apr_ped IN FRAME f_comiss_det
DO:

    DEFINE VARIABLE v_num_row_a   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_method  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_log_method2 AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_rec_table   AS RECID       NO-UNDO.

    IF AVAIL tt_concil
    THEN DO:

         MESSAGE "Confirma a Aprovaá∆o do(s) Pedido(s) Selecionado(s) ?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.
   
         IF v_log_answer <> YES 
            THEN RETURN NO-APPLY.

         ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("General").

         DO v_num_row_a = 1 TO BROWSE br_tt_concil_bol:NUM-SELECTED-ROWS:
    
             ASSIGN v_log_method = BROWSE br_tt_concil_bol:FETCH-SELECTED-ROW(v_num_row_a).
             ASSIGN v_rec_table  = RECID(tt_concil).
      
             FIND tt_concil 
                 WHERE RECID(tt_concil) = v_rec_table NO-ERROR.
      
             FIND ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedido = tt_concil.num_ped_EMS NO-ERROR.
             IF NOT AVAIL ped-venda 
                THEN NEXT.

             IF ped-venda.cod-sit-aval = 3
                THEN NEXT.   
      
             aprov_block:
             DO ON ERROR UNDO aprov_block, LEAVE aprov_block TRANSACTION:
  
                  /* V†rios pedidos no EMS para cada pedido da IKEDA/PAR */
                  FOR EACH int-ped-venda NO-LOCK
                      WHERE int-ped-venda.pedidocodigo = INT(ENTRY(1, tt_concil.num_ped_parceiro, "/")):
  
                      FIND ped-venda EXCLUSIVE-LOCK 
                          WHERE ped-venda.nr-pedido  = int-ped-venda.nr-pedido NO-ERROR.
  
                      IF NOT AVAIL ped-venda 
                         THEN NEXT.
  
                      IF  AVAIL ped-venda 
                      AND ped-venda.cod-sit-aval <> 3
                         THEN ASSIGN ped-venda.cod-sit-aval       = 3 /* Aprovado */
                                     ped-venda.desc-bloq-cr       = ""
                                     ped-venda.dsp-pre-fat        = YES 
                                     ped-venda.cod-message-alerta = 0
                                     ped-venda.dt-mensagem        = ?
                                     ped-venda.nome-prog          = ""
                                     ped-venda.dt-apr-cred        = TODAY
                                     ped-venda.quem-aprovou       = v_cod_usuar_corren.
  
                  END.
             END.

         END.

         ASSIGN v_log_method2 = SESSION:SET-WAIT-STATE("").

         MESSAGE "Pedido(s) Aprovado(s) !" VIEW-AS ALERT-BOX.

         RUN pi_import.

         OPEN QUERY qr_tt_concil_bol
              FOR EACH tt_concil NO-LOCK.

         DISPLAY v_tot_ger_val_bruto  
                 v_tot_ger_val_desc   
                 v_tot_ger_val_liquido WITH FRAME f_comiss_det.

    END.
    ELSE DO:
         MESSAGE "Pedido n∆o selecionado !" VIEW-AS ALERT-BOX.
         RETURN NO-APPLY.
    END.

END.


/*************************** Trigger Definition End *************************/

/************************** Main Code Begin *********************************/

VIEW FRAME f_import.

filter_block:
DO ON ERROR UNDO filter_block, RETRY filter_block
                 ON ENDKEY UNDO filter_block, LEAVE filter_block:

     DISPLAY bt_can
             bt_ok
             rs_opcao
             v_dat_ini
             v_dat_fim
             WITH FRAME f_import.

     ENABLE ALL WITH FRAME f_import.

     WAIT-FOR GO OF FRAME f_import.

     ASSIGN INPUT FRAME f_import rs_opcao v_dat_ini v_dat_fim.

     RUN pi_import.  

     HIDE FRAME f_import.

     VIEW FRAME f_comiss_det.

     concil_block:
     DO ON ERROR UNDO concil_block, RETRY concil_block
                      ON ENDKEY UNDO concil_block, LEAVE concil_block:

          ENABLE ALL WITH FRAME f_comiss_det.

          DISABLE v_tot_ger_val_bruto  
                  v_tot_ger_val_desc   
                  v_tot_ger_val_liquido WITH FRAME f_comiss_det.

          IF rs_opcao = "VisaNet"
          OR rs_opcao = "RedeCard"
          OR rs_opcao = "HiperCard"
          THEN DO:

               DISABLE bt_apr_ped 
                       bt_liq_bol WITH FRAME f_comiss_det.

               ASSIGN br_tt_concil_bol:VISIBLE = NO
                      br_tt_concil_adm:VISIBLE = YES.
               OPEN QUERY qr_tt_concil_adm
                    FOR EACH tt_concil NO-LOCK.

          END.
          ELSE DO:

               DISABLE bt_ret_lote
                       bt_ger_lote WITH FRAME f_comiss_det.

               ASSIGN br_tt_concil_adm:VISIBLE = NO
                      br_tt_concil_bol:VISIBLE = YES.
               OPEN QUERY qr_tt_concil_bol
                    FOR EACH tt_concil NO-LOCK.
          END.

          DISPLAY v_tot_ger_val_bruto  
                  v_tot_ger_val_desc   
                  v_tot_ger_val_liquido WITH FRAME f_comiss_det.
          
          WAIT-FOR GO OF FRAME f_comiss_det.

     END.

     HIDE FRAME f_comiss_det.


END.

/************************** Main Code End ***********************************/

PROCEDURE pi_import:

    DEFINE VARIABLE v_dat_aux      AS DATE        NO-UNDO.
    DEFINE VARIABLE v_cod_parc_aux AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_cv_nsu   AS CHARACTER   NO-UNDO.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

    FOR EACH btt_concil:
        DELETE btt_concil.
    END.

    ASSIGN v_tot_val_bruto       = 0
           v_tot_val_desc        = 0
           v_tot_val_liquido     = 0
           v_tot_ger_val_bruto   = 0
           v_tot_ger_val_desc    = 0
           v_tot_ger_val_liquido = 0.

    DO v_dat_aux = v_dat_ini TO v_dat_fim:

        IF rs_opcao = "VisaNet"
        THEN DO:

             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = rs_opcao
                 BREAK BY int_concil_b2.cod_reg
                       BY int_concil_b2.cod_rv:

                 /* ** Resume de Venda ***/
                 IF int_concil_b2.cod_reg = "1"
                 THEN DO:

                      IF FIRST-OF (int_concil_b2.cod_rv) 
                         THEN ASSIGN v_tot_val_bruto   = 0
                                     v_tot_val_desc    = 0
                                     v_tot_val_liquido = 0.

                      CREATE btt_concil.
                      ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                             btt_concil.cod_resumo            = int_concil_b2.cod_rv
                             btt_concil.cod_tip_reg           = 1
                             btt_concil.val_bruto_pago        = int_concil_b2.val_bruto
                             btt_concil.val_desc_tx_adm       = int_concil_b2.val_desc_tx_adm
                             btt_concil.val_liquido_pago      = int_concil_b2.val_liquido
                             btt_concil.des_status            = int_concil_b2.des_ocor
                             v_tot_val_bruto                 = v_tot_val_bruto   + int_concil_b2.val_bruto      
                             v_tot_val_desc                  = v_tot_val_desc    + int_concil_b2.val_desc_tx_adm
                             v_tot_val_liquido               = v_tot_val_liquido + int_concil_b2.val_liquido
                             v_tot_ger_val_bruto             = v_tot_ger_val_bruto   + int_concil_b2.val_bruto      
                             v_tot_ger_val_desc              = v_tot_ger_val_desc    + int_concil_b2.val_desc_tx_adm
                             v_tot_ger_val_liquido           = v_tot_ger_val_liquido + int_concil_b2.val_liquido.

                      IF LAST-OF (int_concil_b2.cod_rv) 
                      THEN DO:
                           CREATE btt_concil.
                           ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                  btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                  btt_concil.cod_tip_reg           = 4
                                  btt_concil.val_bruto_pago        = v_tot_val_bruto
                                  btt_concil.val_desc_tx_adm       = v_tot_val_desc
                                  btt_concil.val_liquido_pago      = v_tot_val_liquido
                                  btt_concil.val_perc_adm_rv       = (btt_concil.val_desc_tx_adm * 100 / btt_concil.val_bruto_pago) * -1
                                  btt_concil.des_status            = "TOTAL RV".
                      END.

                 END.
                 /* ** Detalhe Resumo de Venda ***/
                 ELSE DO:

                  /*
                      IF int_concil_b2.cod_rv = '4090915' 
                      THEN DO:
                        MESSAGE int_concil_b2.cod_cv_nsu SKIP int_concil_b2.cod_autoriz
                          VIEW-AS ALERT-BOX INFO BUTTONS OK.
                      END.
                  */                            

                       ASSIGN v_cod_cv_nsu = IF LENGTH(int_concil_b2.cod_cv_nsu) > 9 
                                                THEN STRING(INT(SUBSTRING(int_concil_b2.cod_cv_nsu, LENGTH(int_concil_b2.cod_cv_nsu) - 8, 9))) 
                                                ELSE STRING(INT(int_concil_b2.cod_cv_nsu)). /* ** STRING(INT(int_concil_b2.cod_cv_nsu)) ***/

                       IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                        WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                          AND tit_acr_cobr_especial.cod_portador    = '9910'
                                          /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                          AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/ ***/
                                          AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu)
                       THEN DO:

                            /*
                            FIND gateway-ikeda NO-LOCK
                                 WHERE gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz  NO-ERROR.*/

                            FOR FIRST gateway-ikeda NO-LOCK
                                 WHERE gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz,
                                 FIRST int-ped-venda NO-LOCK
                                 WHERE int-ped-venda.pedidocodigo = gateway-ikeda.pedidocodigo
                                   AND int-ped-venda.Cartid       = int_concil_b2.cod_cv_nsu: 
                            END.

                            IF  NOT AVAIL gateway-ikeda 
                            OR  NOT AVAIL int-ped-venda
                            THEN DO:
                                 CREATE btt_concil.
                                 ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                        btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                        btt_concil.cod_tip_reg      = 2
                                        btt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                        btt_concil.des_status       = "Verificar Autorizaá∆o"
                                        btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                        btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                        btt_concil.LOG_an_gerada    = NO.
                                 NEXT.
                            END.
                            ELSE DO:
                                 FIND FIRST int-ped-venda NO-LOCK
                                      WHERE int-ped-venda.PedidoCodigo = gateway-ikeda.pedido NO-ERROR.
                                 IF AVAIL int-ped-venda 
                                 THEN DO:


                                      /* zarpe - verificar por que localizar pelo int-ped-venda 
                                      ASSIGN v_cod_cv_nsu = IF LENGTH(INT-ped-venda.cartid) > 9 
                                                               THEN STRING(INT(SUBSTRING(INT-ped-venda.cartid, LENGTH(INT-ped-venda.cartid) - 8, 9))) 
                                                               ELSE STRING(INT(INT-ped-venda.cartid)). /* ** STRING(INT(INT-ped-venda.cartid)) ***/ */



                                      IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                       WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                                         AND tit_acr_cobr_especial.cod_portador    = '9910'
                                                         /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu)
                                                         AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) ***/
                                                         AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu)

                                      AND NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                       WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                                         AND tit_acr_cobr_especial.cod_portador    = '9911' /*zarpe Cielo*/
                                                         /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu)
                                                         AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) ***/
                                                         AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu)
                                      THEN DO: 

                                           FIND ped-venda NO-LOCK
                                               WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

                                           CREATE btt_concil.
                                           ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                                  btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                                  btt_concil.cod_tip_reg      = 2
                                                  btt_concil.cod_nsu          = v_cod_cv_nsu
                                                  btt_concil.des_status       = "Resumo Ajuste DB/CR"
                                                  btt_concil.num_ped_EMS      = int-ped-venda.nr-pedido
                                                  btt_concil.num_ped_parceiro = STRING(int-ped-venda.PedidoCodigo)
                                                  btt_concil.cdn_cliente_orig = IF AVAIL ped-venda THEN ped-venda.cod-emitente ELSE 0
                                                  btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                                  btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                                  btt_concil.LOG_an_gerada    = NO.

                                      END.
                                 END.
                                 ELSE DO:
                                      CREATE btt_concil.
                                      ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                             btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                             btt_concil.cod_tip_reg      = 2
                                             btt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                             btt_concil.des_status       = "Verificar Autorizaá∆o"
                                             btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                             btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                             btt_concil.LOG_an_gerada    = NO.
                                      NEXT.
                                 END.
                            END.
                       END.

                       FOR EACH tit_acr_cobr_especial NO-LOCK
                           WHERE tit_acr_cobr_especial.cod_empresa                    = v_cod_empres_usuar

                             AND (tit_acr_cobr_especial.cod_portador                   = '9910' OR /*zarpe Cielo*/
                                  tit_acr_cobr_especial.cod_portador                   = '9911')

                             /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/:
                             AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/ ***/
                             AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu:
    
                             FIND tit_acr NO-LOCK
                                 WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                   AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                             IF NOT AVAIL tit_acr 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                             IF NOT AVAIL ped_vda_tit_acr 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND emscad.cliente NO-LOCK
                                 WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                   AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
    
                             FIND ped-venda NO-LOCK
                                 WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                   AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                             IF NOT AVAIL ped-venda 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.
    
                             FIND int-ped-venda NO-LOCK
                                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                             IF NOT AVAIL int-ped-venda 
                             THEN DO:
                                  RUN pi_cria_sem_parcela.
                                  NEXT.
                             END.



                             /* zarpe - conciliaá∆o visa sem gateway-ikeda */
                             IF int_concil_b2.cod_cv_nsu <> int-ped-venda.cartid 
                                THEN NEXT.


/*
                             FIND gateway-ikeda NO-LOCK
                                 WHERE gateway-ikeda.PedidoCodigo      = int-ped-venda.PedidoCodigo
                                   AND gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz NO-ERROR.
                             IF NOT AVAIL gateway-ikeda 
                             THEN DO:
                                  NEXT.
                             END.
  */  



                             ASSIGN v_cod_parc_aux = '01/01'.
    
                             /* ** 505
                             FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                                  WHERE tab_livre_emsfin.cod_modul_dtsul      = "SCO"
                                    AND tab_livre_emsfin.cod_tab_dic_dtsul    = "RELAC_PARC_CARTCRED"
                                    AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                                    AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                             IF AVAIL tab_livre_emsfin 
                                THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
                             ***/

                             FIND FIRST relac_parc_cartcred NO-LOCK
                                  WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                                    AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                             IF AVAIL relac_parc_cartcred 
                                THEN ASSIGN v_cod_parc_aux = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + "/" + STRING(relac_parc_cartcred.num_parc_cartcred, "99").
    
                             IF int_concil_b2.cod_parcela <> v_cod_parc_aux
                             THEN DO:
                                  IF int_concil_b2.cod_parcela <> '01/01' 
                                     THEN NEXT.
/*
                                  IF int_concil_b2.cod_parcela = '01/01' 
                                     THEN RUN pi_cria_sem_parcela.
                                  NEXT.
*/                                  
                             END.

                             ASSIGN v_val_bruto_pago_lote   = 0
                                    v_val_desc_tx_adm_lote  = 0
                                    v_val_liquido_pago_lote = 0.

                             FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                             IF AVAIL ITEM_lote_liquidac_acr
                             THEN DO:
                                  RUN pi_calc_val_comis_retid_admdra_cartao_cr (OUTPUT v_val_bruto_pago_lote,
                                                                                OUTPUT v_val_desc_tx_adm_lote).
                                  /*zarpe*/
                                  ASSIGN v_sit_lote              = item_lote_liquidac_acr.cod_refer
                                         v_val_liquido_pago_lote = v_val_bruto_pago_lote - v_val_desc_tx_adm_lote.

                                  ASSIGN v_val_bruto_pago_lote_tot   = v_val_bruto_pago_lote_tot   + v_val_bruto_pago_lote  
                                         v_val_desc_tx_adm_lote_tot  = v_val_desc_tx_adm_lote_tot  + v_val_desc_tx_adm_lote 
                                         v_val_liquido_pago_lote_tot = v_val_liquido_pago_lote_tot + v_val_liquido_pago_lote.

                             END.
                             ELSE DO:
                                  IF tit_acr.val_sdo_tit_acr = 0
                                     THEN ASSIGN v_sit_lote = "Liquidado".
                                     ELSE ASSIGN v_sit_lote = "Pendente".
                             END.
    
                             FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
    
                             CREATE btt_concil.
                             ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                    btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                    btt_concil.cod_tip_reg           = 2
                                    btt_concil.cod_nsu               = v_cod_cv_nsu /*int_concil_b2.cod_cv_nsu*/
                                    btt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                    btt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                                    btt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                    btt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                                    btt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                                    btt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                                    btt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                                    btt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                                    btt_concil.cod_parcela           = v_cod_parc_aux
                                    btt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                                    btt_concil.val_bruto_pago        = int_concil_b2.val_bruto
                                    btt_concil.cod_refer_liquidac    = v_sit_lote
                                    btt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                    btt_concil.des_status            = "Detalhe Resumo"
                                    btt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                                    btt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                                    btt_concil.LOG_an_gerada         = NO
                                    btt_concil.val_bruto_pago_lote   = v_val_bruto_pago_lote                                         
                                    btt_concil.val_desc_tx_adm_lote  = v_val_desc_tx_adm_lote * (-1)
                                    btt_concil.val_liquido_pago_lote = v_val_liquido_pago_lote.

                             FIND b_tit_acr_an NO-LOCK 
                                WHERE b_tit_acr_an.cod_estab           = "101"
                                  AND b_tit_acr_an.cod_espec           = "AN"
                                  AND b_tit_acr_an.cod_ser             = "5"
                                  AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_EMS)
                                  AND b_tit_acr_an.cod_parcela         = SUBSTRING(btt_concil.cod_parcela, 1, 2) NO-ERROR.
                             IF AVAIL b_tit_acr_an 
                                THEN ASSIGN btt_concil.log_an_gerada = YES.
    
                       END.

                 END.
             END.
        END.

        IF rs_opcao = "RedeCard"
        THEN DO:

/*
             ASSIGN v_tot_val_bruto       = 0
                    v_tot_val_desc        = 0
                    v_tot_val_liquido     = 0
                    v_tot_ger_val_bruto   = 0
                    v_tot_ger_val_desc    = 0
                    v_tot_ger_val_liquido = 0.
*/                    
             
             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = rs_opcao
                   AND (int_concil_b2.cod_reg = "034" OR
                        int_concil_b2.cod_reg = "035")
                 BREAK BY int_concil_b2.cod_rv 
                       BY int_concil_b2.cod_reg DESC:

                /* ** Resume de Venda ***/
  
                 IF FIRST-OF (int_concil_b2.cod_rv) 
                    THEN ASSIGN v_tot_val_bruto   = 0
                                v_tot_val_desc    = 0
                                v_tot_val_liquido = 0.

                 IF int_concil_b2.cod_reg = "034"  
                 THEN DO: 
                      ASSIGN /*v_tot_val_bruto                 = v_tot_val_bruto       + int_concil_b2.val_liquido + int_concil_b2.val_desc_tx_adm      
                             v_tot_val_desc                  = v_tot_val_desc        + int_concil_b2.val_desc_tx_adm*/
                             v_tot_val_liquido               = v_tot_val_liquido     + int_concil_b2.val_liquido
                             /*v_tot_ger_val_bruto             = v_tot_ger_val_bruto   + int_concil_b2.val_liquido + int_concil_b2.val_desc_tx_adm      
                             v_tot_ger_val_desc              = v_tot_ger_val_desc    + int_concil_b2.val_desc_tx_adm*/
                             v_tot_ger_val_liquido           = v_tot_ger_val_liquido + int_concil_b2.val_liquido.

                      CREATE btt_concil.
                      ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                             btt_concil.cod_resumo            = int_concil_b2.cod_rv
                             btt_concil.cod_tip_reg           = 1
                             btt_concil.val_bruto_pago        = int_concil_b2.val_bruto
                             btt_concil.val_desc_tx_adm       = int_concil_b2.val_desc_tx_adm * (-1)
                             btt_concil.val_liquido_pago      = int_concil_b2.val_liquido
                             btt_concil.des_status            = int_concil_b2.des_ocor.

                 END.
                 ELSE DO: /* ** 035 - Contestaá‰es e Cancelamentos ***/

                     ASSIGN v_cod_portador = "".

                     IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                  WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                    AND tit_acr_cobr_especial.cod_portador    = '9911'
                                    /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu)))
                                    AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                    AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(int_concil_b2.cod_cv_nsu)))
                     THEN ASSIGN v_cod_portador = "9911".
                     IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                  WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                    AND tit_acr_cobr_especial.cod_portador    = '9910'
                                    /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu)))
                                    AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                    AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(int_concil_b2.cod_cv_nsu)))
                     THEN ASSIGN v_cod_portador = "9910".

                     IF v_cod_portador = "" 
                     THEN DO: 
                          RUN pi_cria_sem_parcela.
                          NEXT.
                     END.

  
                     blk_35:
                     FOR EACH tit_acr_cobr_especial EXCLUSIVE-LOCK
                         WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                           AND tit_acr_cobr_especial.cod_portador    = v_cod_portador
                           /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(int_concil_b2.cod_cv_nsu)):
                           AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(int_concil_b2.cod_cv_nsu)) ***/
                           AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(int_concil_b2.cod_cv_nsu)):
  
                           FIND tit_acr NO-LOCK
                               WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                 AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                           IF NOT AVAIL tit_acr 
                           THEN DO:
                                RUN pi_cria_sem_parcela.
                                LEAVE blk_35.
                           END.
  
                           FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                           IF NOT AVAIL ped_vda_tit_acr 
                           THEN DO:
                                RUN pi_cria_sem_parcela.
                                LEAVE blk_35.
                           END.
  
                           FIND emscad.cliente NO-LOCK
                               WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                 AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
  
                           FIND ped-venda NO-LOCK
                               WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                 AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                           IF NOT AVAIL ped-venda 
                           THEN DO:
                                RUN pi_cria_sem_parcela.
                                LEAVE blk_35.
                           END.
  
                           FIND int-ped-venda NO-LOCK
                              WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                           IF NOT AVAIL int-ped-venda 
                           THEN DO:
                                RUN pi_cria_sem_parcela.
                                LEAVE blk_35.
                           END.
  
                           ASSIGN v_val_bruto_pago_lote   = 0
                                  v_val_desc_tx_adm_lote  = 0
                                  v_val_liquido_pago_lote = 0.

                           FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                           IF AVAIL ITEM_lote_liquidac_acr
                           THEN DO:

                                /* zarpe 
                                MESSAGE "35" SKIP ROUND((int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto, 2) SKIP tit_acr_cobr_especial.val_perc_remun_portad
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                                ASSIGN tit_acr_cobr_especial.val_perc_remun_portad = (int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto.

                                RUN pi_calc_val_comis_retid_admdra_cartao_cr (OUTPUT v_val_bruto_pago_lote,
                                                                              OUTPUT v_val_desc_tx_adm_lote).
                                /*zarpe*/
                                ASSIGN v_sit_lote              = item_lote_liquidac_acr.cod_refer
                                       v_val_liquido_pago_lote = v_val_bruto_pago_lote - v_val_desc_tx_adm_lote.

                                ASSIGN v_val_bruto_pago_lote_tot   = v_val_bruto_pago_lote_tot   + v_val_bruto_pago_lote  
                                       v_val_desc_tx_adm_lote_tot  = v_val_desc_tx_adm_lote_tot  + v_val_desc_tx_adm_lote 
                                       v_val_liquido_pago_lote_tot = v_val_liquido_pago_lote_tot + v_val_liquido_pago_lote.

                           END.
                           ELSE DO:
                                IF tit_acr.val_sdo_tit_acr = 0
                                   THEN ASSIGN v_sit_lote = "Liquidado".
                                   ELSE ASSIGN v_sit_lote = "Pendente".
                           END.
  
                           FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
  
                           CREATE btt_concil.
                           ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                  btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                  btt_concil.cod_tip_reg           = 3
                                  btt_concil.cod_nsu               = int_concil_b2.cod_cv_nsu
                                  btt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                  btt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                                  btt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                  btt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                                  btt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                                  btt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                                  btt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                                  btt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                                  btt_concil.cod_parcela           = IF AVAIL tit_acr THEN tit_acr.cod_parcela        ELSE ""
                                  btt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                                  btt_concil.val_bruto_pago        = int_concil_b2.val_bruto   * (-1)
                                  btt_concil.val_desc_tx_adm       = int_concil_b2.val_desc_tx_adm
                                  btt_concil.val_liquido_pago      = int_concil_b2.val_liquido * (-1)
                                  btt_concil.cod_refer_liquidac    = v_sit_lote
                                  btt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                  btt_concil.des_status            = int_concil_b2.des_ocor
                                  btt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                                  btt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                                  btt_concil.LOG_an_gerada         = NO
                                  btt_concil.val_bruto_pago_lote   = v_val_bruto_pago_lote                                         
                                  btt_concil.val_desc_tx_adm_lote  = v_val_desc_tx_adm_lote * (-1)
                                  btt_concil.val_liquido_pago_lote = v_val_liquido_pago_lote.

                           FIND b_tit_acr_an NO-LOCK 
                              WHERE b_tit_acr_an.cod_estab           = "101"
                                AND b_tit_acr_an.cod_espec           = "AN"
                                AND b_tit_acr_an.cod_ser             = "5"
                                AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_EMS)
                                AND b_tit_acr_an.cod_parcela         = SUBSTRING(btt_concil.cod_parcela, 1, 2) NO-ERROR.
                           IF AVAIL b_tit_acr_an 
                              THEN ASSIGN btt_concil.log_an_gerada = YES.
  
                     END.

                 END.

                 IF LAST-OF (int_concil_b2.cod_rv) 
                 THEN DO:
                      CREATE btt_concil.
                      ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                             btt_concil.cod_resumo            = int_concil_b2.cod_rv
                             btt_concil.cod_tip_reg           = 4
                             btt_concil.val_bruto_pago        = v_tot_val_bruto
                             btt_concil.val_desc_tx_adm       = v_tot_val_desc
                             btt_concil.val_liquido_pago      = v_tot_val_liquido
                             btt_concil.des_status            = "TOTAL RV".


                      FOR EACH b_int_concil_b2 NO-LOCK
                          WHERE /*b_int_concil_b2.dat_credito = v_dat_aux
                            AND*/ b_int_concil_b2.cod_adm_bco = rs_opcao
                            AND b_int_concil_b2.cod_rv      = int_concil_b2.cod_rv:
                          
                          IF ABS(b_int_concil_b2.dat_credito - v_dat_aux) > 10 THEN NEXT.

                          IF b_int_concil_b2.cod_reg = "034"
                          OR b_int_concil_b2.cod_reg = "035"
                          OR b_int_concil_b2.cod_reg = "006"
                          OR b_int_concil_b2.cod_reg = "012"
                             THEN NEXT.

                          IF b_int_concil_b2.cod_reg = "014" 
                          THEN DO:

                               FIND FIRST b_int_concil_b2_12 NO-LOCK                             
                                    WHERE b_int_concil_b2_12.cod_adm_bco = rs_opcao             
                                      AND b_int_concil_b2_12.cod_rv      = int_concil_b2.cod_rv
                                      AND b_int_concil_b2_12.cod_reg     = "012" NO-ERROR.
                               IF NOT AVAIL b_int_concil_b2_12 
                               THEN DO:
                                    RUN pi_cria_sem_parcela2.
                                    NEXT.
                               END.

                               FOR EACH b_int_concil_b2_12 NO-LOCK                             
                                   WHERE b_int_concil_b2_12.cod_adm_bco = rs_opcao             
                                     AND b_int_concil_b2_12.cod_rv      = int_concil_b2.cod_rv
                                     AND b_int_concil_b2_12.cod_reg     = "012":


                                   ASSIGN v_cod_portador = "".
                
                                   IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                                  AND tit_acr_cobr_especial.cod_portador    = '9911'
                                                  /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)))
                                                  AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2_12.cod_cv_nsu))) ***/
                                                  AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)))
                                   THEN ASSIGN v_cod_portador = "9911".
                                   IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                                  AND tit_acr_cobr_especial.cod_portador    = '9910'
                                                  /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)))
                                                  AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2_12.cod_cv_nsu))) ***/
                                                  AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)))
                                   THEN ASSIGN v_cod_portador = "9910".
                
                                   IF v_cod_portador = "" 
                                   THEN DO: 
                                        RUN pi_cria_sem_parcela3.
                                        NEXT.
                                   END.

                                   FOR EACH tit_acr_cobr_especial EXCLUSIVE-LOCK
                                       WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                         AND tit_acr_cobr_especial.cod_portador    = v_cod_portador
                                         /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)):
                                         AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)) ***/
                                         AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2_12.cod_cv_nsu)):

                                        /* ** Tratamento para ignorar os casos de NSUs repetidos em RV diferentes, referente a vendas distintas ***/
                                         IF ABS(b_int_concil_b2_12.dat_rv_cv_nsu - tit_acr_cobr_especial.dat_emis) > 10 THEN NEXT.

                                         FIND tit_acr NO-LOCK
                                             WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                               AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                                         IF NOT AVAIL tit_acr 
                                         THEN DO:
                                              RUN pi_cria_sem_parcela3.
                                              NEXT.
                                         END.

                                         FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                                         IF NOT AVAIL ped_vda_tit_acr 
                                         THEN DO:
                                              RUN pi_cria_sem_parcela3.
                                              NEXT.
                                         END.

                                         FIND emscad.cliente NO-LOCK
                                             WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                               AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.

                                         FIND ped-venda NO-LOCK
                                             WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                               AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                                         IF NOT AVAIL ped-venda 
                                         THEN DO:
                                              RUN pi_cria_sem_parcela3.
                                              NEXT.
                                         END.

                                         FIND int-ped-venda NO-LOCK
                                            WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                                         IF NOT AVAIL int-ped-venda 
                                         THEN DO:
                                              RUN pi_cria_sem_parcela3.
                                              NEXT.
                                         END.

                                         ASSIGN v_cod_parc_aux = '01/01'.

                                         /* ** 505
                                         FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                                              WHERE tab_livre_emsfin.cod_modul_dtsul      = "SCO"
                                                AND tab_livre_emsfin.cod_tab_dic_dtsul    = "RELAC_PARC_CARTCRED"
                                                AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                                                AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                                         IF AVAIL tab_livre_emsfin 
                                            THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
                                         ***/

                                         FIND FIRST relac_parc_cartcred NO-LOCK
                                              WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                                                AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                                         IF AVAIL relac_parc_cartcred 
                                            THEN ASSIGN v_cod_parc_aux = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + "/" + STRING(relac_parc_cartcred.num_parc_cartcred, "99").

/*
                                         IF  int_concil_b2.cod_rv = '094749372' THEN
                                         MESSAGE SUBSTRING(int_concil_b2.cod_parcela, 1, 2) <> SUBSTRING(v_cod_parc_aux, 1, 2) SKIP(2)
                                           int_concil_b2.cod_reg "int_concil " int_concil_b2.cod_parcela SUBSTRING(int_concil_b2.cod_parcela, 1, 2) " variavel" SUBSTRING(v_cod_parc_aux, 1, 2) SKIP (2)
                                           SKIP(2)
"tabela " int_concil_b2.cod_parcela " buffer " b_int_concil_b2.cod_parcela " buffer 12 " b_int_concil_b2_12.cod_parcela
                                           SKIP(2)
                                           "12 " SKIP b_int_concil_b2_12.cod_cv_nsu SKIP  SKIP v_cod_parc_aux "parcela"
                                           SKIP int_concil_b2.cod_parcela "tabela" int_concil_b2.cod_reg SKIP b_int_concil_b2.cod_parcela "buffer" b_int_concil_b2.cod_reg SKIP b_int_concil_b2_12.cod_parcela "buffer12" b_int_concil_b2_12.cod_reg

                   SKIP


b_int_concil_b2_12.val_bruto       / INT(b_int_concil_b2_12.cod_parcela) SKIP
b_int_concil_b2_12.val_desc_tx_adm / INT(b_int_concil_b2_12.cod_parcela)     SKIP
b_int_concil_b2_12.val_liquido     / INT(b_int_concil_b2_12.cod_parcela) 

                                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */



                                         IF SUBSTRING(int_concil_b2.cod_parcela, 1, 2) <> SUBSTRING(v_cod_parc_aux, 1, 2)
                                         THEN DO:

                                              IF b_int_concil_b2_12.cod_parcela = '01/01' 
                                                 THEN RUN pi_cria_sem_parcela3.
                                              NEXT.
                                         END.

  /*
                                         IF  int_concil_b2.cod_rv = '075049985' THEN
                                         MESSAGE "Passou ! " v_cod_parc_aux "parcela"
                                           SKIP int_concil_b2.cod_parcela "tabela" int_concil_b2.cod_reg SKIP b_int_concil_b2.cod_parcela "buffer" b_int_concil_b2.cod_reg SKIP b_int_concil_b2_12.cod_parcela "buffer12" b_int_concil_b2_12.cod_reg

                   SKIP
b_int_concil_b2_12.cod_cv_nsu SKIP 

b_int_concil_b2_12.val_bruto       / INT(b_int_concil_b2_12.cod_parcela) SKIP
b_int_concil_b2_12.val_desc_tx_adm / INT(b_int_concil_b2_12.cod_parcela)     SKIP
b_int_concil_b2_12.val_liquido     / INT(b_int_concil_b2_12.cod_parcela) 

                                           VIEW-AS ALERT-BOX INFO BUTTONS OK.

    */
                                         
                                         ASSIGN v_val_bruto_pago_lote   = 0
                                                v_val_desc_tx_adm_lote  = 0
                                                v_val_liquido_pago_lote = 0.

                                         FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                                         IF AVAIL ITEM_lote_liquidac_acr
                                         THEN DO:

                                              /* zarpe 
                                              MESSAGE "12" SKIP ROUND((int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto, 2) SKIP tit_acr_cobr_especial.val_perc_remun_portad
                                                  VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                                              ASSIGN tit_acr_cobr_especial.val_perc_remun_portad = (int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto.

                                              RUN pi_calc_val_comis_retid_admdra_cartao_cr (OUTPUT v_val_bruto_pago_lote,
                                                                                            OUTPUT v_val_desc_tx_adm_lote).
                                              /*zarpe*/
                                              ASSIGN v_sit_lote              = item_lote_liquidac_acr.cod_refer
                                                     v_val_liquido_pago_lote = v_val_bruto_pago_lote - v_val_desc_tx_adm_lote.

                                              ASSIGN v_val_bruto_pago_lote_tot   = v_val_bruto_pago_lote_tot   + v_val_bruto_pago_lote  
                                                     v_val_desc_tx_adm_lote_tot  = v_val_desc_tx_adm_lote_tot  + v_val_desc_tx_adm_lote 
                                                     v_val_liquido_pago_lote_tot = v_val_liquido_pago_lote_tot + v_val_liquido_pago_lote.

                                         END.
                                         ELSE DO:
                                              IF tit_acr.val_sdo_tit_acr = 0
                                                 THEN ASSIGN v_sit_lote = "Liquidado".
                                                 ELSE ASSIGN v_sit_lote = "Pendente".
                                         END.

                                         FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                                         IF AVAIL tit_acr 
                                         THEN DO:
                                              /*zarpe*/
                                              FIND btt_concil NO-LOCK
                                                  WHERE btt_concil.dat_transacao = int_concil_b2.dat_credito    
                                                    AND btt_concil.cod_resumo    = int_concil_b2.cod_rv         
                                                    AND btt_concil.cod_tip_reg   = 3                            
                                                    AND btt_concil.cod_nsu       = b_int_concil_b2_12.cod_cv_nsu
                                                    AND btt_concil.num_ped_EMS   = ped-venda.nr-pedido          
                                                    AND btt_concil.cod_estab     = tit_acr.cod_estab  
                                                    AND btt_concil.cod_espec     = tit_acr.cod_espec  
                                                    AND btt_concil.cod_ser       = tit_acr.cod_ser    
                                                    AND btt_concil.cod_tit_acr   = tit_acr.cod_tit_acr
                                                    AND btt_concil.cod_parcela   = v_cod_parc_aux NO-ERROR.
                                              IF AVAIL btt_concil 
                                                 THEN NEXT.
                                         END.

                                         CREATE btt_concil.
                                         ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                                btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                                btt_concil.cod_tip_reg           = 3
                                                btt_concil.cod_nsu               = b_int_concil_b2_12.cod_cv_nsu
                                                btt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                                btt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                                                btt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                                btt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                                                btt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                                                btt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                                                btt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                                                btt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                                                btt_concil.cod_parcela           = v_cod_parc_aux
                                                btt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                                                btt_concil.val_bruto_pago        = b_int_concil_b2_12.val_bruto       / INT(b_int_concil_b2_12.cod_parcela)
                                                btt_concil.val_desc_tx_adm       = (b_int_concil_b2_12.val_desc_tx_adm / INT(b_int_concil_b2_12.cod_parcela))  * (-1)
                                                btt_concil.val_liquido_pago      = b_int_concil_b2_12.val_liquido     / INT(b_int_concil_b2_12.cod_parcela)
                                                btt_concil.cod_refer_liquidac    = v_sit_lote
                                                btt_concil.cod_tit_acr_bco       = SUBSTRING(b_int_concil_b2_12.cod_cart_cred,1,6) + '******' + SUBSTRING(b_int_concil_b2_12.cod_cart_cred,13,4) 
                                                btt_concil.des_status            = "Detalhe Resumo"
                                                btt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                                                btt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                                                btt_concil.LOG_an_gerada         = NO
                                                btt_concil.val_bruto_pago_lote   = v_val_bruto_pago_lote                                         
                                                btt_concil.val_desc_tx_adm_lote  = v_val_desc_tx_adm_lote * (-1)
                                                btt_concil.val_liquido_pago_lote = v_val_liquido_pago_lote.

                                         FIND b_tit_acr_an NO-LOCK 
                                            WHERE b_tit_acr_an.cod_estab           = "101"
                                              AND b_tit_acr_an.cod_espec           = "AN"
                                              AND b_tit_acr_an.cod_ser             = "5"
                                              AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_EMS)
                                              AND b_tit_acr_an.cod_parcela         = SUBSTRING(btt_concil.cod_parcela, 1, 2) NO-ERROR.
                                         IF AVAIL b_tit_acr_an 
                                            THEN ASSIGN btt_concil.log_an_gerada = YES.

                                   END.


                               END.


                          END.
                          ELSE DO:  /* ** 008 ***/

                              ASSIGN v_cod_portador = "".
            
                              IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                           WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                             AND tit_acr_cobr_especial.cod_portador    = '9911'
                                             /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2.cod_cv_nsu)))
                                             AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2.cod_cv_nsu))) ***/
                                             AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2.cod_cv_nsu)))
                              THEN ASSIGN v_cod_portador = "9911".
                              IF CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                           WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                             AND tit_acr_cobr_especial.cod_portador    = '9910'
                                             /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2.cod_cv_nsu)))
                                             AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2.cod_cv_nsu))) ***/
                                             AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2.cod_cv_nsu)))
                              THEN ASSIGN v_cod_portador = "9910".
            
                              IF v_cod_portador = "" 
                              THEN DO: 
                                   RUN pi_cria_sem_parcela2.
                                   NEXT.
                              END.

                              FOR EACH tit_acr_cobr_especial EXCLUSIVE-LOCK
                                  WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                    AND tit_acr_cobr_especial.cod_portador    = v_cod_portador
                                    /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = STRING(INT(b_int_concil_b2.cod_cv_nsu)):
                                    AND tit_acr_cobr_especial.cod_comprov_vda = STRING(INT(b_int_concil_b2.cod_cv_nsu)): ***/
                                    AND tit_acr_cobr_especial.cod_contrat     = STRING(INT(b_int_concil_b2.cod_cv_nsu)):
  
                                    FIND tit_acr NO-LOCK
                                        WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                          AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                                    IF NOT AVAIL tit_acr 
                                    THEN DO:
                                         RUN pi_cria_sem_parcela2.
                                         NEXT.
                                    END.
  
                                    FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                                    IF NOT AVAIL ped_vda_tit_acr 
                                    THEN DO:
                                         RUN pi_cria_sem_parcela2.
                                         NEXT.
                                    END.
  
                                    FIND emscad.cliente NO-LOCK
                                        WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                          AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.
  
                                    FIND ped-venda NO-LOCK
                                        WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                          AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                                    IF NOT AVAIL ped-venda 
                                    THEN DO:
                                         RUN pi_cria_sem_parcela2.
                                         NEXT.
                                    END.
  
                                    FIND int-ped-venda NO-LOCK
                                       WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                                    IF NOT AVAIL int-ped-venda 
                                    THEN DO:
                                         RUN pi_cria_sem_parcela2.
                                         NEXT.
                                    END.
  
                                    ASSIGN v_cod_parc_aux = '01/01'.
/*  
                                    FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                                         WHERE tab_livre_emsfin.cod_modul_dtsul      = "SCO"
                                           AND tab_livre_emsfin.cod_tab_dic_dtsul    = "RELAC_PARC_CARTCRED"
                                           AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                                           AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                                    IF AVAIL tab_livre_emsfin 
                                       THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
  
                                    IF b_int_concil_b2_12.cod_parcela <> v_cod_parc_aux
                                    THEN DO:
                                         IF b_int_concil_b2.cod_parcela = '01/01' 
                                            THEN RUN pi_cria_sem_parcela2.
                                         NEXT.
                                    END.
  */


                                    ASSIGN v_val_bruto_pago_lote   = 0
                                           v_val_desc_tx_adm_lote  = 0
                                           v_val_liquido_pago_lote = 0.

                                    FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                                    IF AVAIL ITEM_lote_liquidac_acr
                                    THEN DO:

                                         /* zarpe 
                                         MESSAGE "8" SKIP ROUND((int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto, 2) SKIP tit_acr_cobr_especial.val_perc_remun_portad
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                                         ASSIGN tit_acr_cobr_especial.val_perc_remun_portad = (int_concil_b2.val_desc_tx_adm * 100) / int_concil_b2.val_bruto.

                                         RUN pi_calc_val_comis_retid_admdra_cartao_cr (OUTPUT v_val_bruto_pago_lote,
                                                                                       OUTPUT v_val_desc_tx_adm_lote).
                                         /*zarpe*/
                                         ASSIGN v_sit_lote              = item_lote_liquidac_acr.cod_refer
                                                v_val_liquido_pago_lote = v_val_bruto_pago_lote - v_val_desc_tx_adm_lote.

                                         ASSIGN v_val_bruto_pago_lote_tot   = v_val_bruto_pago_lote_tot   + v_val_bruto_pago_lote  
                                                v_val_desc_tx_adm_lote_tot  = v_val_desc_tx_adm_lote_tot  + v_val_desc_tx_adm_lote 
                                                v_val_liquido_pago_lote_tot = v_val_liquido_pago_lote_tot + v_val_liquido_pago_lote.

                                    END.
                                    ELSE DO:
                                         IF tit_acr.val_sdo_tit_acr = 0
                                            THEN ASSIGN v_sit_lote = "Liquidado".
                                            ELSE ASSIGN v_sit_lote = "Pendente".
                                    END.
  
                                    FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
  
                                    CREATE btt_concil.
                                    ASSIGN btt_concil.dat_transacao         = b_int_concil_b2.dat_credito
                                           btt_concil.cod_resumo            = b_int_concil_b2.cod_rv
                                           btt_concil.cod_tip_reg           = 3
                                           btt_concil.cod_nsu               = b_int_concil_b2.cod_cv_nsu
                                           btt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                           btt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                                           btt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                           btt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                                           btt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                                           btt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                                           btt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                                           btt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                                           btt_concil.cod_parcela           = v_cod_parc_aux
                                           btt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                                           btt_concil.val_bruto_pago        = b_int_concil_b2.val_bruto
                                           btt_concil.val_desc_tx_adm       = b_int_concil_b2.val_desc_tx_adm * (-1)
                                           btt_concil.val_liquido_pago      = b_int_concil_b2.val_liquido
                                           btt_concil.cod_refer_liquidac    = v_sit_lote
                                           btt_concil.cod_tit_acr_bco       = SUBSTRING(b_int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(b_int_concil_b2.cod_cart_cred,13,4) 
                                           btt_concil.des_status            = "Detalhe Resumo"
                                           btt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                                           btt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                                           btt_concil.LOG_an_gerada         = NO
                                           btt_concil.val_bruto_pago_lote   = v_val_bruto_pago_lote                                         
                                           btt_concil.val_desc_tx_adm_lote  = v_val_desc_tx_adm_lote * (-1)
                                           btt_concil.val_liquido_pago_lote = v_val_liquido_pago_lote.

                                    FIND b_tit_acr_an NO-LOCK 
                                       WHERE b_tit_acr_an.cod_estab           = "101"
                                         AND b_tit_acr_an.cod_espec           = "AN"
                                         AND b_tit_acr_an.cod_ser             = "5"
                                         AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_EMS)
                                         AND b_tit_acr_an.cod_parcela         = SUBSTRING(btt_concil.cod_parcela, 1, 2) NO-ERROR.
                                    IF AVAIL b_tit_acr_an 
                                       THEN ASSIGN btt_concil.log_an_gerada = YES.
  
                              END.

                          END.

                      END.
  
                 END.

            END.
        END.
            
        IF rs_opcao = "HiperCard" 
        THEN DO:

            FOR EACH int_concil_b2 NO-LOCK
                WHERE int_concil_b2.dat_credito = v_dat_aux
                  AND int_concil_b2.cod_adm_bco = rs_opcao
                BREAK BY int_concil_b2.cod_reg
                      BY int_concil_b2.cod_rv:

                /* ** Resume de Venda ***/
                IF int_concil_b2.cod_reg = "1"
                THEN DO:

                     IF FIRST-OF (int_concil_b2.cod_rv) 
                        THEN ASSIGN v_tot_val_bruto   = 0
                                    v_tot_val_desc    = 0
                                    v_tot_val_liquido = 0.

                     CREATE btt_concil.
                     ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                            btt_concil.cod_resumo            = int_concil_b2.cod_rv
                            btt_concil.cod_tip_reg           = 1
                            btt_concil.val_bruto_pago        = int_concil_b2.val_bruto
                            btt_concil.val_desc_tx_adm       = int_concil_b2.val_desc_tx_adm
                            btt_concil.val_liquido_pago      = int_concil_b2.val_liquido
                            btt_concil.des_status            = int_concil_b2.des_ocor
                            v_tot_val_bruto                 = v_tot_val_bruto   + int_concil_b2.val_bruto      
                            v_tot_val_desc                  = v_tot_val_desc    + int_concil_b2.val_desc_tx_adm
                            v_tot_val_liquido               = v_tot_val_liquido + int_concil_b2.val_liquido
                            v_tot_ger_val_bruto             = v_tot_ger_val_bruto   + int_concil_b2.val_bruto      
                            v_tot_ger_val_desc              = v_tot_ger_val_desc    + int_concil_b2.val_desc_tx_adm
                            v_tot_ger_val_liquido           = v_tot_ger_val_liquido + int_concil_b2.val_liquido.

                     IF LAST-OF (int_concil_b2.cod_rv) 
                     THEN DO:
                          CREATE btt_concil.
                          ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                 btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                 btt_concil.cod_tip_reg           = 4
                                 btt_concil.val_bruto_pago        = v_tot_val_bruto
                                 btt_concil.val_desc_tx_adm       = v_tot_val_desc
                                 btt_concil.val_liquido_pago      = v_tot_val_liquido
                                 btt_concil.des_status            = "TOTAL RV".
                     END.

                END.
                /* ** Detalhe Resumo de Venda ***/
                ELSE DO:

                      ASSIGN v_cod_cv_nsu = STRING(INT(int_concil_b2.cod_cv_nsu)).

                      IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                       WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                         AND tit_acr_cobr_especial.cod_portador    = '9914'
                                         /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/
                                         AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) /* ** STRING(INT(int_concil_b2.cod_cv_nsu))) ***/ ***/
                                         AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu)
                      THEN DO:
                           FIND gateway-ikeda NO-LOCK
                                WHERE gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz  NO-ERROR.
                           IF NOT AVAIL gateway-ikeda 
                           THEN DO:
                                CREATE btt_concil.
                                ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                       btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                       btt_concil.cod_tip_reg      = 2
                                       btt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                       btt_concil.des_status       = "Verificar Autorizaá∆o"
                                       btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                       btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                       btt_concil.LOG_an_gerada    = NO.
                                NEXT.
                           END.
                           ELSE DO:
                                FIND FIRST int-ped-venda NO-LOCK
                                     WHERE int-ped-venda.PedidoCodigo = gateway-ikeda.pedido NO-ERROR.
                                IF AVAIL int-ped-venda 
                                THEN DO:
                                     ASSIGN v_cod_cv_nsu = STRING(INT(INT-ped-venda.cartid)).
                                     IF NOT CAN-FIND (FIRST tit_acr_cobr_especial NO-LOCK
                                                      WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                                                        AND tit_acr_cobr_especial.cod_portador    = '9914'
                                                        /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu)
                                                        AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu) ***/
                                                        AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu)
                                     THEN DO: 

                                          FIND ped-venda NO-LOCK
                                              WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

                                          CREATE btt_concil.
                                          ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                                 btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                                 btt_concil.cod_tip_reg      = 2
                                                 btt_concil.cod_nsu          = v_cod_cv_nsu
                                                 btt_concil.des_status       = "Resumo Ajuste DB/CR"
                                                 btt_concil.num_ped_EMS      = int-ped-venda.nr-pedido
                                                 btt_concil.num_ped_parceiro = STRING(int-ped-venda.PedidoCodigo)
                                                 btt_concil.cdn_cliente_orig = IF AVAIL ped-venda THEN ped-venda.cod-emitente ELSE 0
                                                 btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                                 btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                                 btt_concil.LOG_an_gerada    = NO.

                                     END.
                                END.
                                ELSE DO:
                                     CREATE btt_concil.
                                     ASSIGN btt_concil.dat_transacao    = int_concil_b2.dat_credito
                                            btt_concil.cod_resumo       = int_concil_b2.cod_rv
                                            btt_concil.cod_tip_reg      = 2
                                            btt_concil.cod_nsu          = int_concil_b2.cod_autoriz
                                            btt_concil.des_status       = "Verificar Autorizaá∆o"
                                            btt_concil.val_bruto_pago   = int_concil_b2.val_bruto
                                            btt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                            btt_concil.LOG_an_gerada    = NO.
                                     NEXT.
                                END.
                           END.
                      END.

                      FOR EACH tit_acr_cobr_especial NO-LOCK
                          WHERE tit_acr_cobr_especial.cod_empresa     = v_cod_empres_usuar
                            AND tit_acr_cobr_especial.cod_portador    = '9914'
                            /* ** 505 AND ENTRY(3, tit_acr_cobr_especial.cod_livre_1, CHR(10)) = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/:
                            AND tit_acr_cobr_especial.cod_comprov_vda = v_cod_cv_nsu /*STRING(INT(int_concil_b2.cod_cv_nsu))*/ ***/
                            AND tit_acr_cobr_especial.cod_contrat     = v_cod_cv_nsu:

                            FIND tit_acr NO-LOCK
                                WHERE tit_acr.cod_estab      = tit_acr_cobr_especial.cod_estab
                                  AND tit_acr.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                            IF NOT AVAIL tit_acr 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 NEXT.
                            END.

                            FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
                            IF NOT AVAIL ped_vda_tit_acr 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 NEXT.
                            END.

                            FIND emscad.cliente NO-LOCK
                                WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                                  AND emscad.cliente.cdn_cliente = tit_acr_cobr_especial.cdn_cliente NO-ERROR.

                            FIND ped-venda NO-LOCK
                                WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
                                  AND ped-venda.nome-abrev = emscad.cliente.nom_abrev NO-ERROR.
                            IF NOT AVAIL ped-venda 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 NEXT.
                            END.

                            FIND int-ped-venda NO-LOCK
                               WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                            IF NOT AVAIL int-ped-venda 
                            THEN DO:
                                 RUN pi_cria_sem_parcela.
                                 NEXT.
                            END.

                            /*
                            FIND gateway-ikeda NO-LOCK
                                WHERE gateway-ikeda.PedidoCodigo      = int-ped-venda.PedidoCodigo
                                  AND gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz NO-ERROR.
                            IF NOT AVAIL gateway-ikeda 
                            THEN DO:
                                 NEXT.
                            END.*/

                            ASSIGN v_cod_parc_aux = '01/01'.

                            /* ** 505
                            FIND FIRST tab_livre_emsfin NO-LOCK USE-INDEX tblvrmsf_id
                                 WHERE tab_livre_emsfin.cod_modul_dtsul      = "SCO"
                                   AND tab_livre_emsfin.cod_tab_dic_dtsul    = "RELAC_PARC_CARTCRED"
                                   AND tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr_cobr_especial.cod_estab + CHR(24) + ENTRY(5,tit_acr.cod_livre_1,CHR(24))
                                   AND tab_livre_emsfin.cod_compon_2_idx_tab = STRING(tit_acr_cobr_especial.num_id_tit_acr) NO-ERROR.
                            IF AVAIL tab_livre_emsfin 
                               THEN ASSIGN v_cod_parc_aux = STRING(tab_livre_emsfin.num_livre_1,'99') + "/" + STRING(tab_livre_emsfin.num_livre_2,'99').
                            ***/
                                     
                            FIND FIRST relac_parc_cartcred NO-LOCK
                                 WHERE relac_parc_cartcred.cod_estab      = tit_acr_cobr_especial.cod_estab
                                   AND relac_parc_cartcred.num_id_tit_acr = tit_acr_cobr_especial.num_id_tit_acr NO-ERROR.
                            IF AVAIL relac_parc_cartcred 
                               THEN ASSIGN v_cod_parc_aux = STRING(relac_parc_cartcred.num_parc_tit_cobr_especial, "99") + "/" + STRING(relac_parc_cartcred.num_parc_cartcred, "99").

                            IF int_concil_b2.cod_parcela <> v_cod_parc_aux
                            THEN DO:
                                 IF int_concil_b2.cod_parcela <> '01/01' 
                                    THEN NEXT.
/*
                                 IF int_concil_b2.cod_parcela = '01/01' 
                                    THEN RUN pi_cria_sem_parcela.
                                 NEXT.
*/                                  
                            END.

                            ASSIGN v_val_bruto_pago_lote   = 0
                                   v_val_desc_tx_adm_lote  = 0
                                   v_val_liquido_pago_lote = 0.

                            FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
                            IF AVAIL ITEM_lote_liquidac_acr
                            THEN DO:
                                 RUN pi_calc_val_comis_retid_admdra_cartao_cr (OUTPUT v_val_bruto_pago_lote,
                                                                               OUTPUT v_val_desc_tx_adm_lote).
                                 /*zarpe*/
                                 ASSIGN v_sit_lote              = item_lote_liquidac_acr.cod_refer
                                        v_val_liquido_pago_lote = v_val_bruto_pago_lote - v_val_desc_tx_adm_lote.

                                 ASSIGN v_val_bruto_pago_lote_tot   = v_val_bruto_pago_lote_tot   + v_val_bruto_pago_lote  
                                        v_val_desc_tx_adm_lote_tot  = v_val_desc_tx_adm_lote_tot  + v_val_desc_tx_adm_lote 
                                        v_val_liquido_pago_lote_tot = v_val_liquido_pago_lote_tot + v_val_liquido_pago_lote.

                            END.
                            ELSE DO:
                                 IF tit_acr.val_sdo_tit_acr = 0
                                    THEN ASSIGN v_sit_lote = "Liquidado".
                                    ELSE ASSIGN v_sit_lote = "Pendente".
                            END.

                            FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.

                            CREATE btt_concil.
                            ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                                   btt_concil.cod_resumo            = int_concil_b2.cod_rv
                                   btt_concil.cod_tip_reg           = 2
                                   btt_concil.cod_nsu               = v_cod_cv_nsu /*int_concil_b2.cod_cv_nsu*/
                                   btt_concil.num_ped_EMS           = ped-venda.nr-pedido
                                   btt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
                                   btt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
                                   btt_concil.cdn_cliente_adm       = IF AVAIL tit_acr THEN tit_acr.cdn_cliente        ELSE 0
                                   btt_concil.cod_estab             = IF AVAIL tit_acr THEN tit_acr.cod_estab          ELSE ""
                                   btt_concil.cod_espec             = IF AVAIL tit_acr THEN tit_acr.cod_espec          ELSE ""
                                   btt_concil.cod_ser               = IF AVAIL tit_acr THEN tit_acr.cod_ser            ELSE ""
                                   btt_concil.cod_tit_acr           = IF AVAIL tit_acr THEN tit_acr.cod_tit_acr        ELSE ""
                                   btt_concil.cod_parcela           = v_cod_parc_aux
                                   btt_concil.val_tit_acr_EMS       = IF AVAIL tit_acr THEN tit_acr.val_origin_tit_acr ELSE 0
                                   btt_concil.val_bruto_pago        = int_concil_b2.val_bruto
                                   btt_concil.cod_refer_liquidac    = v_sit_lote
                                   btt_concil.cod_tit_acr_bco       = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4) 
                                   btt_concil.des_status            = "Detalhe Resumo"
                                   btt_concil.rec_tit_acr           = IF AVAIL tit_acr           THEN RECID(tit_acr)           ELSE ?
                                   btt_concil.rec_lote_liquidac_acr = IF AVAIL lote_liquidac_acr THEN RECID(lote_liquidac_acr) ELSE ?
                                   btt_concil.LOG_an_gerada         = NO
                                   btt_concil.val_bruto_pago_lote   = v_val_bruto_pago_lote                                         
                                   btt_concil.val_desc_tx_adm_lote  = v_val_desc_tx_adm_lote * (-1)
                                   btt_concil.val_liquido_pago_lote = v_val_liquido_pago_lote.

                            FIND b_tit_acr_an NO-LOCK 
                               WHERE b_tit_acr_an.cod_estab           = "101"
                                 AND b_tit_acr_an.cod_espec           = "AN"
                                 AND b_tit_acr_an.cod_ser             = "5"
                                 AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_EMS)
                                 AND b_tit_acr_an.cod_parcela         = SUBSTRING(btt_concil.cod_parcela, 1, 2) NO-ERROR.
                            IF AVAIL b_tit_acr_an 
                               THEN ASSIGN btt_concil.log_an_gerada = YES.

                      END.
                END.
            END.
        END.

        IF rs_opcao = "Debito Direto" 
        THEN DO:



        END.

        IF rs_opcao = "Boleto" 
        THEN DO:

/*
             ASSIGN v_tot_val_bruto       = 0
                    v_tot_val_desc        = 0
                    v_tot_val_liquido     = 0
                    v_tot_ger_val_bruto   = 0
                    v_tot_ger_val_desc    = 0
                    v_tot_ger_val_liquido = 0.
*/                    

             FOR EACH int_concil_b2 NO-LOCK
                 WHERE int_concil_b2.dat_credito = v_dat_aux
                   AND int_concil_b2.cod_adm_bco = rs_opcao:


                 ASSIGN v_pedidocodigo_aux = INT(SUBSTRING(int_concil_b2.cod_tit_acr_bco, 3, 9)).

                 IF  NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "101"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "102"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "103"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "104"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "105"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "106"))
                 AND NOT CAN-FIND(FIRST tit_acr NO-LOCK
                                  WHERE tit_acr.cod_portador    = '237'
                                    AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "107"))
                 THEN DO:

                      CREATE btt_concil.
                      ASSIGN btt_concil.dat_transacao         = int_concil_b2.dat_credito
                             btt_concil.val_liquido_pago      = int_concil_b2.val_liquido
                             btt_concil.log_an_gerada         = NO
                             v_tot_ger_val_bruto             = v_tot_ger_val_bruto   + int_concil_b2.val_liquido
                             v_tot_ger_val_liquido           = v_tot_ger_val_liquido + int_concil_b2.val_liquido.
    
                      IF NOT CAN-FIND(FIRST int-ped-venda NO-LOCK
                          WHERE int-ped-venda.PedidoCodigo = v_pedidocodigo_aux) 
                      THEN DO:
                           ASSIGN btt_concil.num_ped_parceiro = STRING(v_pedidocodigo_aux)
                                  btt_concil.des_status       = "Erro Integraá∆o IKEDA/PAR/EMS".
                      END.
                      ELSE DO:
    
                           FOR EACH int-ped-venda NO-LOCK
                               WHERE int-ped-venda.PedidoCodigo = v_pedidocodigo_aux:
                               
                               ASSIGN btt_concil.num_ped_parceiro = STRING(int-ped-venda.PedidoCodigo)
                                      btt_concil.num_parceiro     = int-ped-venda.parceirocodigo.
    
                               FIND b_tit_acr_an NO-LOCK 
                                  WHERE b_tit_acr_an.cod_estab           = "101"
                                    AND b_tit_acr_an.cod_espec           = "AN"
                                    AND b_tit_acr_an.cod_ser             = "5"
                                    AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_ems)
                                    AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                               IF AVAIL b_tit_acr_an 
                                  THEN ASSIGN btt_concil.log_an_gerada = YES.
    
                               FIND ped-venda NO-LOCK
                                   WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
    
                               IF NOT AVAIL ped-venda 
                               THEN DO: 
                                    ASSIGN btt_concil.des_status = "Pedido EMS n∆o Localizado.".
                                    NEXT.
                               END.
        
                               ASSIGN btt_concil.num_ped_EMS      = ped-venda.nr-pedido
                                      btt_concil.cdn_cliente_orig = ped-venda.cod-emitente
                                      btt_concil.val_tit_acr_EMS  = btt_concil.val_tit_acr_EMS + ped-venda.vl-tot-ped /*+ int-ped-venda.vl-frete*/.
    
                               IF ped-venda.cod-sit-aval <> 3 /* Aprovado */ 
                                  THEN ASSIGN btt_concil.des_status = "Pedido EMS n∆o Aprovado.".
                                  ELSE ASSIGN btt_concil.des_status = "Pedido EMS n∆o Faturado.".

                               /* C†lcula o valor Total do IPI do pedido */
                               FOR EACH ped-item OF ped-venda NO-LOCK:
                                   ASSIGN btt_concil.val_ipi = btt_concil.val_ipi + (ped-item.vl-liq-it * ped-item.aliquota-ipi / 100).
                               END.
        
                           END.                  
    
                      END.
    
                      FIND b_tit_acr_an NO-LOCK 
                         WHERE b_tit_acr_an.cod_estab           = "101"
                           AND b_tit_acr_an.cod_espec           = "AN"
                           AND b_tit_acr_an.cod_ser             = "5"
                           AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(btt_concil.num_ped_ems)
                           AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
                      IF AVAIL b_tit_acr_an 
                         THEN ASSIGN btt_concil.LOG_an_gerada = YES.
    
                 END.
                 ELSE DO:
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "101") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "102") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "103") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "104") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "105") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "106") :
                          RUN pi_cria_boleto.
                      END.
                      FOR EACH tit_acr NO-LOCK
                          WHERE tit_acr.cod_portador    = '237'
                            AND tit_acr.cod_tit_acr_bco = (int_concil_b2.cod_tit_acr_bco + "107") :
                          RUN pi_cria_boleto.
                      END.
                 END.
             END.
        END.
    END.

    FOR EACH btt_concil:
           
        IF btt_concil.num_ped_EMS = 0
           THEN NEXT.

        FIND ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = btt_concil.num_ped_EMS NO-ERROR.
        IF NOT AVAIL ped-venda 
        THEN DO: 
             ASSIGN btt_concil.ind_pedido = "NOK"
                    btt_concil.ind_nf     = "NOK".
             NEXT.
        END.

        ASSIGN btt_concil.ind_pedido = "Implantado".
        IF ped-venda.cod-sit-aval = 3 /* Aprovado */ 
           THEN ASSIGN btt_concil.ind_pedido = "Aprovado".
        IF ped-venda.dt-cancela <> ? 
           THEN ASSIGN btt_concil.ind_pedido = "Cancelado".

        ASSIGN btt_concil.ind_nf = "Pendente".
        FIND nota-fiscal NO-LOCK
            WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
              AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL nota-fiscal 
        THEN DO:

             IF nota-fiscal.emite-duplic = YES 
                THEN ASSIGN btt_concil.ind_nf = "Faturada".

             IF nota-fiscal.dt-cancela <> ?
                THEN ASSIGN btt_concil.ind_nf = "Cancelada".

             FIND natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
          
             IF AVAIL natur-oper 
             THEN DO:
                  IF natur-oper.tipo = 1 
                  THEN DO:
          
                       FIND FIRST devol-cli USE-INDEX ch-nfe 
                            WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel 
                              AND devol-cli.serie-docto  = nota-fiscal.serie       
                              AND devol-cli.nro-docto    = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                       IF AVAIL devol-cli 
                          THEN ASSIGN btt_concil.ind_nf = "Devolvida".
                  END.
                  ELSE DO:
                       IF natur-oper.tipo = 2 
                       OR natur-oper.tipo = 3 
                       THEN DO:
                            FIND FIRST devol-cli USE-INDEX ch-nfs 
                                 WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel 
                                   AND devol-cli.serie        = nota-fiscal.serie       
                                   AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                            IF AVAIL devol-cli 
                               THEN ASSIGN btt_concil.ind_nf = "Devolvida".
                       END.
                  END.
             END.
        END.
    END.

    ASSIGN v_log_method = session:SET-WAIT-STATE("").

END.


PROCEDURE pi_cria_sem_parcela:

    DEF VAR v_cod_pedido AS CHAR FORMAT "X(25)".

    FOR FIRST gateway-ikeda NO-LOCK
         WHERE gateway-ikeda.CodigoAutorizacao = int_concil_b2.cod_autoriz,
         FIRST int-ped-venda NO-LOCK
         WHERE int-ped-venda.pedidocodigo = gateway-ikeda.pedidocodigo
           AND int-ped-venda.Cartid       = int_concil_b2.cod_cv_nsu: 
    END.
    IF AVAIL gateway-ikeda
    AND AVAIL int-ped-venda 
        THEN ASSIGN v_cod_pedido = ". Pedido: " + int-ped-venda.cod-estabel + "/" + string(gateway-ikeda.pedidocodigo).

    CREATE tt_concil.
    ASSIGN tt_concil.dat_transacao    = int_concil_b2.dat_credito
           tt_concil.cod_resumo       = int_concil_b2.cod_rv
           tt_concil.cod_tip_reg      = 2
           tt_concil.cod_nsu          = int_concil_b2.cod_cv_nsu
           tt_concil.des_status       = "Verificar NSU *" + int_concil_b2.des_ocor + v_cod_pedido
           tt_concil.val_bruto_pago   = int_concil_b2.val_bruto
           tt_concil.val_desc_tx_adm  = int_concil_b2.val_desc_tx_adm
           tt_concil.val_liquido_pago = int_concil_b2.val_liquido
           tt_concil.cod_tit_acr_bco  = SUBSTRING(int_concil_b2.cod_cart_cred,1,6) + '******' + SUBSTRING(int_concil_b2.cod_cart_cred,13,4).
END.

PROCEDURE pi_cria_sem_parcela2:

    DEF VAR v_cod_pedido AS CHAR FORMAT "X(25)".

    FOR FIRST gateway-ikeda NO-LOCK
         WHERE gateway-ikeda.CodigoAutorizacao = b_int_concil_b2.cod_autoriz,
         FIRST int-ped-venda NO-LOCK
         WHERE int-ped-venda.pedidocodigo = gateway-ikeda.pedidocodigo
           AND int-ped-venda.Cartid       = b_int_concil_b2.cod_cv_nsu: 
    END.
    IF AVAIL gateway-ikeda
    AND AVAIL int-ped-venda 
        THEN ASSIGN v_cod_pedido = ". Pedido: " + int-ped-venda.cod-estabel + "/" + string(gateway-ikeda.pedidocodigo).

    CREATE tt_concil.
    ASSIGN tt_concil.dat_transacao = b_int_concil_b2.dat_credito
           tt_concil.cod_resumo    = b_int_concil_b2.cod_rv
           tt_concil.cod_tip_reg   = 2
           tt_concil.cod_nsu       = b_int_concil_b2.cod_cv_nsu
           tt_concil.des_status    = "Verificar NSU *" + v_cod_pedido.
END.

PROCEDURE pi_cria_sem_parcela3:

    DEF VAR v_cod_pedido AS CHAR FORMAT "X(25)".

    FOR FIRST gateway-ikeda NO-LOCK
         WHERE gateway-ikeda.CodigoAutorizacao = b_int_concil_b2_12.cod_autoriz,
         FIRST int-ped-venda NO-LOCK
         WHERE int-ped-venda.pedidocodigo = gateway-ikeda.pedidocodigo
           AND int-ped-venda.Cartid       = b_int_concil_b2_12.cod_cv_nsu: 
    END.
    IF AVAIL gateway-ikeda
    AND AVAIL int-ped-venda 
        THEN ASSIGN v_cod_pedido = ". Pedido: " + int-ped-venda.cod-estabel + "/" + string(gateway-ikeda.pedidocodigo).

    CREATE tt_concil.
    ASSIGN tt_concil.dat_transacao = b_int_concil_b2.dat_credito
           tt_concil.cod_resumo    = b_int_concil_b2_12.cod_rv
           tt_concil.cod_tip_reg   = 2
           tt_concil.cod_nsu       = b_int_concil_b2_12.cod_cv_nsu
           tt_concil.des_status    = "Verificar NSU *" + v_cod_pedido.
END.


PROCEDURE pi_cria_boleto:

    IF  tit_acr.cod_cart_bcia <> "71"
    AND tit_acr.cod_cart_bcia <> "72"
        THEN RETURN.
    
    FIND ITEM_lote_liquidac_acr NO-LOCK OF tit_acr NO-ERROR.
    IF AVAIL ITEM_lote_liquidac_acr
    THEN DO:
         ASSIGN v_sit_lote = ITEM_lote_liquidac.cod_refer.
    END.
    ELSE DO:
         IF tit_acr.val_sdo_tit_acr = 0
            THEN ASSIGN v_sit_lote = "Liquidado".
            ELSE ASSIGN v_sit_lote = "Pendente".
    END.
    
    FIND lote_liquidac_acr OF ITEM_lote_liquidac_acr NO-LOCK NO-ERROR.
    
    FIND ped_vda_tit_acr NO-LOCK OF tit_acr NO-ERROR.
    
    FIND ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = ped_vda_tit_acr.cod_ped_vda
          AND ped-venda.nome-abrev = tit_acr.nom_abrev NO-ERROR.
    IF NOT AVAIL ped-venda 
       THEN RETURN.
    
    FIND int-ped-venda NO-LOCK
      WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF NOT AVAIL int-ped-venda 
       THEN RETURN.

    CREATE tt_concil.
    ASSIGN tt_concil.dat_transacao         = int_concil_b2.dat_credito
           tt_concil.num_ped_EMS           = ped-venda.nr-pedido
           tt_concil.num_ped_parceiro      = ped-venda.nr-pedcli
           tt_concil.cdn_cliente_orig      = ped-venda.cod-emitente
           tt_concil.cdn_cliente_adm       = tit_acr.cdn_cliente
           tt_concil.cod_estab             = tit_acr.cod_estab  
           tt_concil.cod_espec             = tit_acr.cod_espec  
           tt_concil.cod_ser               = tit_acr.cod_ser    
           tt_concil.cod_tit_acr           = tit_acr.cod_tit_acr
           tt_concil.cod_parcela           = "01/01"
           tt_concil.val_tit_acr_EMS       = tit_acr.val_origin_tit_acr
           tt_concil.val_liquido_pago      = int_concil_b2.val_liquido
           tt_concil.cod_refer_liquidac    = v_sit_lote
           tt_concil.cod_tit_acr_bco       = tit_acr.cod_tit_acr_bco
           tt_concil.des_status            = ""
           tt_concil.rec_tit_acr           = RECID(tit_acr)          
           tt_concil.rec_lote_liquidac_acr = RECID(lote_liquidac_acr)
           tt_concil.log_an_gerada         = NO
           tt_concil.num_parceiro          = int-ped-venda.parceirocodigo
           v_tot_ger_val_bruto             = v_tot_ger_val_bruto   + int_concil_b2.val_liquido
           v_tot_ger_val_desc              = 0
           v_tot_ger_val_liquido           = v_tot_ger_val_liquido + int_concil_b2.val_liquido.
    
    IF tt_concil.val_tit_acr_EMS <> tt_concil.val_liquido_pago
       THEN ASSIGN tt_concil.des_status = "Conferir Valor.".
    IF tit_acr.val_sdo_tit_acr <> 0 
       THEN ASSIGN tt_concil.des_status = tt_concil.des_status + "Falta Liquidar.".
    IF tt_concil.des_status = "" 
       THEN ASSIGN tt_concil.des_status = "OK.".
    
    FIND b_tit_acr_an NO-LOCK 
       WHERE b_tit_acr_an.cod_estab           = "101"
         AND b_tit_acr_an.cod_espec           = "AN"
         AND b_tit_acr_an.cod_ser             = "5"
         AND b_tit_acr_an.cod_tit_acr         = "B2" + STRING(tt_concil.num_ped_ems)
         AND b_tit_acr_an.cod_parcela         = "01" NO-ERROR.
    IF AVAIL b_tit_acr_an 
       THEN ASSIGN tt_concil.LOG_an_gerada = YES.

END.

PROCEDURE pi_elimina_item_lote:

    FIND tit_acr NO-LOCK 
       WHERE RECID(tit_acr) = tt_concil.rec_tit_acr NO-ERROR.
  
    IF  AVAIL tit_acr 
    AND tit_acr.ind_tip_cobr_acr = "Especial" 
    THEN DO:
  
         FIND item_lote_liquidac_acr OF tit_acr EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL item_lote_liquidac_acr 
            THEN NEXT.
  
         FIND tit_acr_cobr_especial EXCLUSIVE-LOCK 
            WHERE tit_acr_cobr_especial.cod_estab      = tit_acr.cod_estab
              AND tit_acr_cobr_especial.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
         IF AVAIL tit_acr_cobr_especial 
            THEN ASSIGN tit_acr_cobr_especial.cod_refer_liquidac = "".
  
         /* ** Elimina relacionamento em cascata  ***/
         FOR EACH abat_antecip_acr EXCLUSIVE-LOCK 
             WHERE abat_antecip_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
               AND abat_antecip_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
               AND abat_antecip_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
             DELETE abat_antecip_acr.
         END. 
         FOR EACH abat_prev_acr EXCLUSIVE-LOCK 
             WHERE abat_prev_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
               AND abat_prev_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
               AND abat_prev_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
             DELETE abat_prev_acr.
         END. 
         FOR EACH aprop_ctbl_pend_acr EXCLUSIVE-LOCK 
             WHERE aprop_ctbl_pend_acr.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
               AND aprop_ctbl_pend_acr.cod_refer     = item_lote_liquidac_acr.cod_refer
               AND aprop_ctbl_pend_acr.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
             DELETE aprop_ctbl_pend_acr.
         END. 
         FOR EACH aprop_despes_recta_pend EXCLUSIVE-LOCK 
             WHERE aprop_despes_recta_pend.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
               AND aprop_despes_recta_pend.cod_refer     = item_lote_liquidac_acr.cod_refer
               AND aprop_despes_recta_pend.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
             DELETE aprop_despes_recta_pend.
         END. 
         FOR EACH impto_liquidac_tit_acr EXCLUSIVE-LOCK 
             WHERE impto_liquidac_tit_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
               AND impto_liquidac_tit_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
               AND impto_liquidac_tit_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
             DELETE impto_liquidac_tit_acr.
         END. 
  
         FIND lote_liquidac_acr EXCLUSIVE-LOCK 
            WHERE lote_liquidac_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
              AND lote_liquidac_acr.cod_refer       = item_lote_liquidac_acr.cod_refer NO-ERROR.
         ASSIGN lote_liquidac_acr.val_tot_lote_liquidac_infor = lote_liquidac_acr.val_tot_lote_liquidac_infor - item_lote_liquidac_acr.val_liquidac_tit_acr.
  
         DELETE item_lote_liquidac_acr.
  
         FIND FIRST item_lote_liquidac_acr OF lote_liquidac_acr NO-LOCK NO-ERROR.
         IF NOT AVAIL item_lote_liquidac_acr 
            THEN DELETE lote_liquidac_acr.
  
    END.

END.

PROCEDURE pi_cria_lote_novo:

    DEF BUFFER b_tt_concil FOR tt_concil.

    FIND tit_acr NO-LOCK 
       WHERE RECID(tit_acr) = tt_concil.rec_tit_acr NO-ERROR.
  
    IF  AVAIL tit_acr 
    AND tit_acr.ind_tip_cobr_acr = "Especial" 
    THEN DO:
  
         /* ** zarpe - localizar tit_acr_cobr_especial e alterar o percentual de comiss∆o para a Visanet - Tratamento CIELO ***/
         IF rs_opcao = "VisaNet"
         THEN DO:
              FIND tit_acr_cobr_especial EXCLUSIVE-LOCK 
                  WHERE tit_acr_cobr_especial.cod_estab      = tit_acr.cod_estab
                    AND tit_acr_cobr_especial.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
              IF AVAIL tit_acr_cobr_especial 
              THEN DO:
                   FIND b_tt_concil NO-LOCK
                       WHERE b_tt_concil.dat_transacao = tt_concil.dat_transacao                                         
                         AND b_tt_concil.cod_resumo    = tt_concil.cod_resumo                                              
                         AND b_tt_concil.cod_tip_reg   = 4 NO-ERROR.
                   IF AVAIL b_tt_concil 
                      THEN ASSIGN tit_acr_cobr_especial.val_perc_remun_portad = b_tt_concil.val_perc_adm_rv.
              END.
         END.

         FIND FIRST tt_integr_acr_liquidac_lote
              WHERE tt_integr_acr_liquidac_lote.tta_cod_estab_refer = v_cod_estab 
                AND tt_integr_acr_liquidac_lote.tta_cod_refer       = v_cod_refer NO-ERROR.
      
         IF NOT AVAIL tt_integr_acr_liquidac_lote 
         THEN DO:
              CREATE tt_integr_acr_liquidac_lote.
              ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = '1'
                     tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = v_cod_estab
                     tt_integr_acr_liquidac_lote.tta_cod_refer                   = v_cod_refer
                     tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren           
                     tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = v_data_base
                     tt_integr_acr_liquidac_lote.tta_dat_transacao               = v_data_base
                     tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "Lote"
                     tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em Digitaá∆o"
                     tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO   
                     tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = NO 
                     tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = YES 
                     tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote).
         END.
         ASSIGN v_rec_lote = RECID(tt_integr_acr_liquidac_lote).
      
         CREATE tt_integr_acr_liq_item_lote_3.
         ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr.cod_empresa
                tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr.cod_estab
                tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr.cod_espec_docto
                tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
                tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
                tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr.cod_parcela
                tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr.cdn_cliente
                tt_integr_acr_liq_item_lote_3.tta_cod_portador               = tit_acr.cod_portador
                tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = tit_acr.cod_cart_bcia
                tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
                tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
                tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_liq_tit_acr
                tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tit_acr.val_sdo_tit_acr
                tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = v_data_base
                tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = v_data_base
                tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = v_data_base
                tt_integr_acr_liq_item_lote_3.tta_val_abat_tit_acr           = 0
                tt_integr_acr_liq_item_lote_3.tta_val_despes_bcia            = 0
                tt_integr_acr_liq_item_lote_3.tta_val_multa_tit_acr          = 0
                tt_integr_acr_liq_item_lote_3.tta_val_juros                  = 0
                tt_integr_acr_liq_item_lote_3.tta_val_cm_tit_acr             = 0
                tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = NO 
                tt_integr_acr_liq_item_lote_3.tta_des_text_histor            = "T°tulo liquidado automaticamente pela implantaá∆o cobranáa"
                tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = NO 
                tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = NO 
                tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
                tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = v_rec_lote
                tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = RECID(tt_integr_acr_liq_item_lote_3).

    END.

END PROCEDURE.


PROCEDURE pi_liquidac_bol:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.

    FOR EACH tt_integr_acr_liquidac_lote:
        DELETE tt_integr_acr_liquidac_lote.
    END.
    FOR EACH tt_integr_acr_liq_item_lote_3:
        DELETE tt_integr_acr_liq_item_lote_3.
    END.
    FOR EACH tt_integr_acr_abat_antecip:
        DELETE tt_integr_acr_abat_antecip.
    END.
    FOR EACH tt_integr_acr_abat_prev:
        DELETE tt_integr_acr_abat_prev.
    END.
    FOR EACH tt_integr_acr_cheq:
        DELETE tt_integr_acr_cheq.
    END.
    FOR EACH tt_integr_acr_liquidac_impto_2:
        DELETE tt_integr_acr_liquidac_impto_2.
    END.
    FOR EACH tt_integr_acr_rel_pend_cheq:
        DELETE tt_integr_acr_rel_pend_cheq.
    END.
    FOR EACH tt_integr_acr_liq_aprop_ctbl:
        DELETE tt_integr_acr_liq_aprop_ctbl.
    END.
    FOR EACH tt_integr_acr_liq_desp_rec:
        DELETE tt_integr_acr_liq_desp_rec.
    END.
    FOR EACH tt_integr_acr_aprop_liq_antec: 
        DELETE tt_integr_acr_aprop_liq_antec.
    END.
    FOR EACH tt_log_erros_import_liquidac:
        DELETE tt_log_erros_import_liquidac.
    END.
    FOR EACH tt_integr_cambio_ems5:
        DELETE tt_integr_cambio_
    END.

    FIND tit_acr NO-LOCK
         WHERE RECID(tit_acr) = tt_concil.rec_tit_acr NO-ERROR.

    ASSIGN v_log_refer_uni = NO.

    /* ** Gera Referància V†lida ***/
    REPEAT WHILE NOT v_log_refer_uni:
        RUN pi_retorna_sugestao_referencia (INPUT "B",
                                            INPUT TODAY,
                                            OUTPUT v_cod_refer).
    
        /* --- Verifica Referància Ènica ---*/
        RUN pi_verifica_refer_unica_acr (INPUT tit_acr.cod_estab,
                                         INPUT v_cod_refer,
                                         INPUT "lote_liquidac_acr",
                                         INPUT ?,
                                         OUTPUT v_log_refer_uni).
    END.

    CREATE tt_integr_acr_liquidac_lote.
    ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = tit_acr.cod_empresa
           tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = tit_acr.cod_estab
           tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren
           tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = v_data_base
           tt_integr_acr_liquidac_lote.tta_dat_transacao               = v_data_base
           tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
           tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digitaá∆o"
           tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO    
           tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES
           tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO 
           tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
           tt_integr_acr_liquidac_lote.tta_cod_refer                   = v_cod_refer.

    CREATE tt_integr_acr_liq_item_lote_3.
    ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr.cod_empresa
           tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr.cod_estab
           tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr.cod_espec_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr.cod_parcela
           tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr.cdn_cliente
           tt_integr_acr_liq_item_lote_3.tta_cod_portador               = tit_acr.cod_portador
           tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = tit_acr.cod_cart_bcia
           tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
           tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
           tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tit_acr.val_sdo_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = v_data_base
           tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = no
           tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = no
           tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
           tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = no
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Compostos"
           tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
           tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = recid(tt_integr_acr_liq_item_lote_3).

    IF v_val_abat <> 0 
    THEN DO:
         CREATE tt_integr_acr_abat_antecip.
         ASSIGN tt_integr_acr_abat_antecip.ttv_rec_item_lote_impl_tit_acr = tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr
                tt_integr_acr_abat_antecip.ttv_rec_abat_antecip_acr       = recid(tt_integr_acr_abat_antecip)
                tt_integr_acr_abat_antecip.tta_cod_estab                  = b_tit_acr.cod_estab
                tt_integr_acr_abat_antecip.tta_cod_espec_docto            = b_tit_acr.cod_espec
                tt_integr_acr_abat_antecip.tta_cod_ser_docto              = b_tit_acr.cod_ser
                tt_integr_acr_abat_antecip.tta_cod_tit_acr                = b_tit_acr.cod_tit_acr
                tt_integr_acr_abat_antecip.tta_cod_parcela                = b_tit_acr.cod_parcela
                tt_integr_acr_abat_antecip.tta_val_abtdo_antecip_tit_abat = v_val_abat.
    END.

    RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hld_handle.

    RUN pi_main_code_api_integr_acr_liquidac_4 IN v_hld_handle (Input 1,
                                                                Input table tt_integr_acr_liquidac_lote,
                                                                Input table tt_integr_acr_liq_item_lote_3,
                                                                Input table tt_integr_acr_abat_antecip,
                                                                Input table tt_integr_acr_abat_prev,
                                                                Input table tt_integr_acr_cheq,
                                                                Input table tt_integr_acr_liquidac_impto_2,
                                                                Input table tt_integr_acr_rel_pend_cheq,
                                                                Input table tt_integr_acr_liq_aprop_ctbl,
                                                                Input table tt_integr_acr_liq_desp_rec,
                                                                Input table tt_integr_acr_aprop_liq_antec,
                                                                Input "",
                                                                output table tt_log_erros_import_liquidac,
                                                                Input table tt_integr_cambio_ems5).

    DELETE PROCEDURE v_hld_handle.

    FOR EACH tt_log_erros_import_liquidac:
        MESSAGE "Erro: "     tt_log_erros_import_liquidac.ttv_num_erro_log SKIP
                "Mensagem: " tt_log_erros_import_liquidac.ttv_des_msg_erro 
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

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


PROCEDURE pi_verifica_refer_unica_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
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


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    def buffer b_renegoc_acr
        for renegoc_acr.

    /*************************** Buffer Definition End **************************/

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

PROCEDURE pi_calc_val_comis_retid_admdra_cartao_cr:

    /************************ Parameter Definition Begin ************************/

    def output param p_val_base_comis
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def output param p_val_comis_retid
        as decimal
        format ">>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_admdra_cartao_cr for admdra_cartao_cr.

    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_calc_dat_cr_parc
        as character
        format "X(20)":U
        view-as radio-set Vertical
        radio-buttons "Regra Amex", "Regra Amex","Regra Redcard", "Regra Redcard","Regra Visanet", "Regra Visanet"
         /*l_regra_amex*/ /*l_regra_amex*/ /*l_regra_redcard*/ /*l_regra_redcard*/ /*l_regra_visa*/ /*l_regra_visa*/
        bgcolor 8 
        label "Regra Calc Parcelas"
        column-label "Regra Calc Parcelas"
        no-undo.
    def var v_val_perc_remun_portad
        as decimal
        format ">>9.99":U
        decimals 2
        label "Perc Remuneraá∆o"
        column-label "Perc Remuneraá∆o"
        no-undo.
    def var v_val_tot_comis_retid
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        label "Comiss∆o Retida"
        column-label "Comiss∆o Retida"
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_val_base_comis  = 0
           p_val_comis_retid = 0.

    assign v_val_perc_remun_portad = tit_acr_cobr_especial.val_perc_remun_portad.

    /* Caso n∆o seja uma venda parcelada, utilizar o mesmo processo do retorno da cobranáa escritural */
    /* ** 505
    if not can-find(first tab_livre_emsfin no-lock
                    where tab_livre_emsfin.cod_modul_dtsul      = 'SCO'
                    and   tab_livre_emsfin.cod_tab_dic_dtsul    = 'relac_parc_cartcred'
                    and   tab_livre_emsfin.cod_compon_1_idx_tab =  tit_acr.cod_estab + chr(24) + entry(5,tit_acr.cod_livre_1,chr(24))
                    and   tab_livre_emsfin.cod_compon_2_idx_tab = string(tit_acr.num_id_tit_acr))
    ***/
    IF NOT CAN-FIND(FIRST relac_parc_cartcred NO-LOCK
                    WHERE relac_parc_cartcred.cod_estab      = tit_acr.cod_estab
                      AND relac_parc_cartcred.num_id_tit_acr = tit_acr.num_id_tit_acr)
    then do:
         assign p_val_base_comis  = tit_acr_cobr_especial.val_tit_acr
                p_val_comis_retid = round((tit_acr_cobr_especial.val_tit_acr * v_val_perc_remun_portad) / 100,2).
         return.
    end.

    find b_admdra_cartao_cr no-lock
        where  b_admdra_cartao_cr.cod_admdra_cartao_cr = tit_acr_cobr_especial.cod_admdra_cartao_cr no-error.
    assign v_ind_calc_dat_cr_parc = b_admdra_cartao_cr.ind_calc_dat_cr_parc /* ** 505 entry(3, b_admdra_cartao_cr.cod_livre_1, chr(24)) ***/.

   

    /* ** 505
    find first tab_livre_emsfin no-lock
         where tab_livre_emsfin.cod_modul_dtsul      = 'SCO'
         and   tab_livre_emsfin.cod_tab_dic_dtsul    = 'relac_parc_cartcred'
         and   tab_livre_emsfin.cod_compon_1_idx_tab = tit_acr.cod_estab + chr(24) + entry(5,tit_acr.cod_livre_1,chr(24))
         and   tab_livre_emsfin.cod_compon_2_idx_tab = string(tit_acr.num_id_tit_acr) no-error.
    ***/

    FIND FIRST relac_parc_cartcred NO-LOCK
         WHERE relac_parc_cartcred.cod_estab      = tit_acr.cod_estab
           AND relac_parc_cartcred.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.

    case v_ind_calc_dat_cr_parc:
        when "Regra Redcard" then do:
            assign p_val_base_comis = tit_acr_cobr_especial.val_tit_acr.
                
            /* ** 505
            assign v_val_tot_comis_retid = (tab_livre_emsfin.val_livre_2 * v_val_perc_remun_portad / 100)
                   p_val_comis_retid     = truncate((v_val_tot_comis_retid / tab_livre_emsfin.num_livre_2),2).
            ***/
            assign v_val_tot_comis_retid = (relac_parc_cartcred.val_tot_parc_cartcred * v_val_perc_remun_portad / 100)
                   p_val_comis_retid     = truncate((v_val_tot_comis_retid / relac_parc_cartcred.num_parc_cartcred),2).

            /* ** 505
            if  tab_livre_emsfin.num_livre_1 = 1 then
                assign p_val_comis_retid = (v_val_tot_comis_retid - (p_val_comis_retid * (tab_livre_emsfin.num_livre_2 - 1))).
            ***/

            if  relac_parc_cartcred.num_parc_tit_cobr_especial = 1 then
                assign p_val_comis_retid = (v_val_tot_comis_retid - (p_val_comis_retid * (relac_parc_cartcred.num_parc_cartcred - 1))).

        end.

        when "Regra Amex" or 
        when "Regra Visanet" then do:
            /* Para estas admdras desconta-se o valor estornado via AVA a menor para o calculo da comissao */
            if  tit_acr.val_sdo_tit_acr > (tit_acr_cobr_especial.val_tit_acr - tit_acr_cobr_especial.val_tit_acr_estordo) then
                assign p_val_base_comis  = tit_acr_cobr_especial.val_tit_acr
                       p_val_comis_retid = round((tit_acr_cobr_especial.val_tit_acr * v_val_perc_remun_portad) / 100,2).
            else
                assign p_val_base_comis  = tit_acr_cobr_especial.val_tit_acr - tit_acr_cobr_especial.val_tit_acr_estordo
                       p_val_comis_retid = round(((tit_acr_cobr_especial.val_tit_acr - tit_acr_cobr_especial.val_tit_acr_estordo) * v_val_perc_remun_portad) / 100,2).

            /* Tratamento de diferencas de centavos entre o saldo do titulo e o valor base da comissao em virtude de arredondamento */
                if  tit_acr.val_sdo_tit_acr >= (p_val_base_comis - (0.01 * (relac_parc_cartcred.num_parc_cartcred /* ** 505 tab_livre_emsfin.num_livre_2 ***/ - 1)))
                and tit_acr.val_sdo_tit_acr <= (p_val_base_comis + (0.01 * (relac_parc_cartcred.num_parc_cartcred /* ** 505 tab_livre_emsfin.num_livre_2 ***/ - 1))) then
                    assign p_val_base_comis = tit_acr.val_sdo_tit_acr.
        end.
    end case.

END PROCEDURE.
