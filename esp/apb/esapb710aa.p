/*****************************************************************************
** Programa..............: esapb710aa.p - Altera datas
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 17/01/2013
*****************************************************************************/

def input param p_wgh_frame       as handle         no-undo.

define variable h_object          as widget-handle  no-undo.

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

DISABLE TRIGGERS FOR LOAD OF item_bord_ap.
DISABLE TRIGGERS FOR LOAD OF bord_ap.
DISABLE TRIGGERS FOR LOAD OF antecip_pef_pend.

def new global shared var v_rec_bord_ap_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_log_answer    AS LOGICAL     NO-UNDO.

DEF BUFFER b_tt_tit_ap_alteracao_base_aux_1 FOR tt_tit_ap_alteracao_base_aux_1.



MESSAGE "Confirma alteraá∆o da data de vencimento e pagamento de todos os itens do Borderì?"
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.

IF v_log_answer = NO
   THEN RETURN.

/*APPLY CHOOSE NO botao enter para atualizar a pesquisa*/
               
FIND bord_ap NO-LOCK
    WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-ERROR.
IF NOT AVAIL bord_ap 
THEN DO:
     MESSAGE "Borderì n∆o Localizado!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

IF bord_ap.ind_sit_bord_ap <> "Em Digitaá∆o" 
THEN DO:
     MESSAGE "Somente Ç poss°vel alterar borderì com Situaá∆o: Em Digitaá∆o"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

IF bord_ap.log_bord_ap_escrit = NO 
THEN DO:
     MESSAGE "Somente Ç poss°vel alterar borderì do tipo Escritural!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

IF CAN-FIND(FIRST item_bord_ap OF bord_ap NO-LOCK
            WHERE item_bord_ap.ind_sit_item_bord_ap <> "Em Aberto") 
OR NOT CAN-FIND(FIRST item_bord_ap OF bord_ap NO-LOCK)
THEN DO:
     MESSAGE "Situaá∆o dos Itens deve ser: Em Aberto"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

blk_alter:
DO TRANSACTION ON ERROR UNDO blk_alter, LEAVE blk_alter:
    FOR EACH item_bord_ap OF bord_ap EXCLUSIVE:
        ASSIGN item_bord_ap.dat_pagto_tit_ap  = bord_ap.dat_transacao
               item_bord_ap.dat_prev_pagto    = bord_ap.dat_transacao
               item_bord_ap.dat_vencto_tit_ap = bord_ap.dat_transacao.
        FIND tit_ap NO-LOCK
            WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab      
              AND tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor 
              AND tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
              AND tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto  
              AND tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap     
              AND tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-ERROR.
        IF AVAIL tit_ap
        AND tit_ap.dat_vencto_tit_ap <> bord_ap.dat_transacao
        THEN DO:

             ASSIGN v_log_refer_uni = NO.
             REPEAT WHILE v_log_refer_uni = NO:
                 RUN pi_retorna_sugestao_referencia (INPUT "B",
                                                     INPUT TODAY,
                                                     OUTPUT v_cod_refer).
                 RUN pi_verifica_refer_unica_apb (INPUT tit_ap.cod_estab,
                                                  INPUT v_cod_refer,
                                                  OUTPUT v_log_refer_uni).
             END.

             EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
             EMPTY TEMP-TABLE tt_tit_ap_alteracao_base.
             EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
             EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.

             CREATE tt_tit_ap_alteracao_base_aux_1.
             ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                    tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                    tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                    tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                    tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                    tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = TODAY
                    tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                    tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap
                    tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = tit_ap.dat_emis_docto
                    tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = bord_ap.dat_transacao
                    tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = bord_ap.dat_transacao
                    tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = tit_ap.dat_prev_pagto
                    tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = tit_ap.num_dias_atraso
                    tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = tit_ap.val_perc_multa_atraso
                    tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = tit_ap.val_juros_dia_atraso
                    tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = tit_ap.val_perc_juros_dia_atraso
                    tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = tit_ap.dat_desconto
                    tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = tit_ap.val_perc_desc
                    tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = tit_ap.val_desconto
                    tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                  = tit_ap.cod_portador
                    tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto           = tit_ap.ind_tip_espec_docto
                    tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ
                    tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = 1
                    tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Alteraá∆o"
                    tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = tit_ap.ind_sit_tit_ap.
    
             RUN prgfin/apb/apb767ze.py(INPUT 1,
                                        INPUT "",
                                        INPUT "",
                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                        OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

             FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK
                 WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 12912
                   AND tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6540:
                 MESSAGE tt_log_erros_tit_ap_alteracao.tta_cod_estab
                         tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor
                         tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto
                         tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto
                         tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap
                         tt_log_erros_tit_ap_alteracao.tta_cod_parcela
                         tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                         tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                         tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda VIEW-AS ALERT-BOX.
             END.
    
             IF CAN-FIND (FIRST tt_log_erros_tit_ap_alteracao NO-LOCK
                          WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 12912
                            AND tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6540)
             THEN DO:
                  MESSAGE "Alteraá∆o Desfeita!"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  UNDO blk_alter, LEAVE blk_alter.
             END.

         END.
         ELSE DO:
              FIND antecip_pef_pend EXCLUSIVE-LOCK
                  WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                    AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef NO-ERROR.
              IF AVAIL antecip_pef_pend 
                 THEN ASSIGN antecip_pef_pend.dat_prev_pagto    = bord_ap.dat_transacao
                             antecip_pef_pend.dat_vencto_tit_ap = bord_ap.dat_transacao.
         END.
    END.

    ASSIGN h_object = p_wgh_frame:FIRST-CHILD
           h_object = h_object:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h_object):
        IF h_object:TYPE <> "field_group" 
        THEN DO:
             IF h_object:NAME = "bt_enter" 
             THEN DO: 
                  APPLY "CHOOSE" TO h_object.
                  LEAVE.
             END.
             ASSIGN h_object = h_object:NEXT-SIBLING.
        END.
    END.

    MESSAGE "Alteraá∆o Finalizada!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

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
                     FIND b_tt_tit_ap_alteracao_base_aux_1
                         WHERE b_tt_tit_ap_alteracao_base_aux_1.tta_cod_estab = p_cod_estab 
                           AND b_tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL b_tt_tit_ap_alteracao_base_aux_1
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.
