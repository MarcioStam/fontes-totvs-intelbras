/*****************************************************************************
** Nome Externo..........: esp/apb/esapb025.p
** Descricao.............: Listar diferenáa Embarque x Provis∆o
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 01/04/2010
*****************************************************************************/

def var c-versao-prg as char initial " 5.01.00.001":U no-undo.

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def new shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_nom_integer
    as character
    format "x(30)":U
    no-undo.
def var v_num_ped_exec
    as integer
    format ">>>>9":U
    label "Pedido"
    column-label "Pedido"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.

DEFINE VARIABLE v_dat_transacao AS DATE FORMAT "99/99/9999"  INITIAL TODAY     NO-UNDO.

DEF BUFFER b_tit_ap          FOR tit_ap.
DEF BUFFER b_estabelecimento FOR estabelecimento.

def new global shared var v_rec_tit_ap as RECID format ">>>>>>9":U initial ? no-undo.

/************************** Variable Definition End *************************/

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
          tta_cod_parcela                  ascending
    .

/*************************** Temp-Table Definition Begin ********************/

DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD v_log_selec          AS LOG                  LABEL "Selec" FORMAT "Sim/N∆o" INITIAL NO
    FIELD v_cod_estab          AS CHAR FORMAT "x(04)"  LABEL "Est"
    FIELD v_cdn_fornec         AS INT                  LABEL "Fornecedor"
    FIELD v_cod_espec          AS CHAR FORMAT "x(03)"  LABEL "Esp"
    FIELD v_cod_ser            AS CHAR FORMAT "x(03)"  LABEL "Ser"
    FIELD v_cod_tit_ap         AS CHAR FORMAT "x(11)"  LABEL "Titulo"
    FIELD v_cod_parc           AS CHAR FORMAT "x(02)"  LABEL "Parc"
    FIELD v_val_orig           AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Val Original"
    FIELD v_val_sdo            AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Val Saldo"
    FIELD v_moeda_apb          AS CHAR                 LABEL "M Tit"
    FIELD v_val_embarque       AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Val Embarque"
    FIELD v_moeda_embarque     AS CHAR                 LABEL "M Emb"
    FIELD v_val_dif            AS DEC  FORMAT "->,>>>,>>9.99"                LABEL "Diferenáa"
    FIELD v_dat_entr_intelbras AS DATE                 LABEL "Dt Entr"
    FIELD v_nom_comprador      AS CHAR FORMAT "x(40)"  LABEL "Comprador"
    FIELD v_des_validacao      AS CHAR FORMAT "x(200)" LABEL "Validaá∆o"
    FIELD v_dat_emis_docto     AS DATE FORMAT "99/99/9999"                   LABEL "Dt Emissao".

/*************************** Temp-Table Definition End ********************/

/*************************** Query Definition Begin *************************/
DEF QUERY qr_tt_concil
    FOR tt_concil
    SCROLLING.

def browse br_tt_concil query qr_tt_concil display 
    v_log_selec         
    v_cod_estab         
    v_cdn_fornec        
    v_cod_espec         
    v_cod_tit_ap        
    v_cod_parc          
    v_val_orig          
    v_val_sdo
    v_dat_emis_docto
    v_moeda_apb         
    v_val_embarque      
    v_moeda_embarque    
    v_val_dif           
    v_nom_comprador     
    v_dat_entr_intelbras
    v_des_validacao
    ENABLE v_val_dif
  with no-box separators 
         size 154 by 21.3
         font 1
         bgcolor 15 .

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
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

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
def button bt_apb
    label "&T°tulo APB"
    tooltip "T°tulo APB"
    size 1 by 1.
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
    initial "Arquivo"
    view-as radio-set Horizontal
    radio-buttons "Arquivo", "Arquivo", "Tela", "Tela"
    bgcolor 8 
    no-undo.

/************************* Radio-Set Definition End *************************/

DEF BUTTON bt_ava     LABEL "Gera AVA"  TOOLTIP "AVA"       SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_can_ava LABEL "Cancela"   TOOLTIP "Cancela"   SIZE 1 BY 1 AUTO-ENDKEY.

/************************** Frame Definition Begin **************************/

def frame f_concil
    rt_cxcf
         at row 23.00 col 02.00 bgcolor 7 
    br_tt_concil
         AT ROW 1.21 COL 2
    bt_ava
         at row 23.21 col 03.00 font ?
         help "AVA"
    bt_can_ava
         at row 23.21 col 14.00 font ?
         help "Cancela"
    bt_apb
         at row 23.21 col 25.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 157 by 25 default-button bt_can_ava
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conciliaá∆o Embarque".
/* adjust size of objects in this frame */
assign bt_ava:width-chars           in frame f_concil = 10.00
       bt_ava:height-chars          in frame f_concil = 01.00
       bt_can_ava:width-chars       in frame f_concil = 10.00
       bt_can_ava:height-chars      in frame f_concil = 01.00
       bt_apb:width-chars           in frame f_concil = 10.00
       bt_apb:height-chars          in frame f_concil = 01.00
       rt_cxcf:width-chars          in frame f_concil = 154
       rt_cxcf:height-chars         in frame f_concil = 01.42.


def frame f_rpt_41_tit_ap_consistencia
    rt_target
         at row 01.50 col 02.00
    " Destino " view-as text
         at row 01.30 col 04.00 bgcolor 8 
    rt_cxcf
         at row 4.7 col 02.00 bgcolor 7 
    rs_cod_dwb_output
         at row 02 col 03.00
         help "" no-label
    v_dat_transacao
         AT ROW 03 COL 4 LABEL "Data AVA:"
    view-as fill-in
    size-chars 11.14 by .88
    fgcolor ? bgcolor 15 font 2
    ed_1x40
         at row 03 col 03.00
         help "" no-label
    bt_get_file
         at row 03 col 57 font ?
         help "Pesquisa Arquivo"
    bt_print
         at row 5 col 03.00 font ?
         help "Imprime"
    bt_can
         at row 5 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 63.00 by 6.5
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Listar diferenáa Embarque x Provis∆o - esapb025".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_tit_ap_consistencia = 10.00
           bt_can:height-chars         in frame f_rpt_41_tit_ap_consistencia = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_tit_ap_consistencia = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_tit_ap_consistencia = 01.08
           bt_print:width-chars        in frame f_rpt_41_tit_ap_consistencia = 10.00
           bt_print:height-chars       in frame f_rpt_41_tit_ap_consistencia = 01.00
           ed_1x40:width-chars         in frame f_rpt_41_tit_ap_consistencia = 53.50
           ed_1x40:height-chars        in frame f_rpt_41_tit_ap_consistencia = 01.00
           rt_cxcf:width-chars         in frame f_rpt_41_tit_ap_consistencia = 59.57
           rt_cxcf:height-chars        in frame f_rpt_41_tit_ap_consistencia = 01.42
           rt_target:width-chars       in frame f_rpt_41_tit_ap_consistencia = 59.5
           rt_target:height-chars      in frame f_rpt_41_tit_ap_consistencia = 03.00.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_rpt_41_tit_ap_consistencia = yes.
    /* set private-data for the help system */
    assign rs_cod_dwb_output:private-data    in frame f_rpt_41_tit_ap_consistencia = "HLP=000023462":U
           ed_1x40:private-data              in frame f_rpt_41_tit_ap_consistencia = "HLP=000023462":U
           bt_get_file:private-data          in frame f_rpt_41_tit_ap_consistencia = "HLP=000008782":U
           bt_print:private-data             in frame f_rpt_41_tit_ap_consistencia = "HLP=000010815":U
           bt_can:private-data               in frame f_rpt_41_tit_ap_consistencia = "HLP=000011050":U
           frame f_rpt_41_tit_ap_consistencia:private-data                         = "HLP=000023462".

/*********************** User Interface Trigger Begin ***********************/

ON MOUSE-SELECT-DBLCLICK OF br_tt_concil IN FRAME f_concil
DO:

    DEF VAR v_rec_control AS RECID NO-UNDO.
    DEF VAR v_val_sdo     AS DEC   NO-UNDO.
    DEF VAR v_log_status  AS LOG   NO-UNDO.

    IF AVAIL tt_concil 
    THEN DO:
         ASSIGN tt_concil.v_log_selec = NOT(tt_concil.v_log_selec).
         ASSIGN v_rec_control = RECID(tt_concil).
         IF br_tt_concil:REFRESH() THEN.
         IF v_rec_control <> ? THEN REPOSITION qr_tt_concil TO RECID v_rec_control.
    END.

END.


ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign ed_1x40:screen-value in frame f_rpt_41_tit_ap_consistencia = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_consistencia */

ON CHOOSE OF bt_apb IN FRAME f_concil
DO:


    /************************* Variable Definition Begin ************************/

    def var v_wgh_child
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_current_menu
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_current_window
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_cod_name                       as character       no-undo. /*local*/
    def var v_wgh_child_2                    as widget-handle   no-undo. /*local*/


    /************************** Variable Definition End *************************/






























    ASSIGN v_rec_tit_ap = ?.

    IF AVAIL tt_concil 
    THEN DO:
        FIND tit_ap NO-LOCK
            WHERE tit_ap.cod_estab   = tt_concil.v_cod_estab  
              AND tit_ap.cdn_fornec  = tt_concil.v_cdn_fornec 
              AND tit_ap.cod_espec   = tt_concil.v_cod_espec  
              AND tit_ap.cod_ser     = tt_concil.v_cod_ser    
              AND tit_ap.cod_tit_ap  = tt_concil.v_cod_tit_ap 
              AND tit_ap.cod_parcela = tt_concil.v_cod_parc NO-ERROR.
        IF AVAIL tit_ap THEN DO:
            ASSIGN v_rec_tit_ap = RECID(tit_ap).

            assign v_wgh_current_window        = current-window
                   v_wgh_current_menu          = current-window:menubar
                   current-window:window-state = 2
                   v_wgh_child                 = current-window:first-child
                   current-window:visible      = NO.
            if  v_wgh_current_menu <> ?
            then do:
                assign v_wgh_current_menu:sensitive = no.
            end /* if */.

            assign v_wgh_child_2 = v_wgh_child
                   v_cod_name = (if v_wgh_child_2 <> ? then v_wgh_child_2:name else "").

            desab:
            do while v_wgh_child_2 <> ?:
                assign v_wgh_child_2 = v_wgh_child_2:next-sibling.
                if  v_wgh_child_2 <> ?
                and v_wgh_child_2:name = v_cod_name then
                    assign v_wgh_child = v_wgh_child_2.
            end /* do desab */.

            if  v_wgh_child <> ? then
                assign v_wgh_child:sensitive = no.

            run prgfin/apb/apb222aa.p.

            assign current-window              = v_wgh_current_window.
            assign v_wgh_child                 = current-window:first-child
                   current-window:window-state = 3
                   current-window:visible      = yes.
            if  v_wgh_current_menu <> ?
            then do:
                assign v_wgh_current_menu:sensitive = yes.
            end /* if */.

            assign v_wgh_child_2 = v_wgh_child
                   v_cod_name = (if v_wgh_child_2 <> ? then v_wgh_child_2:name else "").

            habil:
            do while v_wgh_child_2 <> ?:
                assign v_wgh_child_2 = v_wgh_child_2:next-sibling.
                if  v_wgh_child_2 <> ?
                and v_wgh_child_2:name = v_cod_name then
                    assign v_wgh_child = v_wgh_child_2.
            end /* do habil */.

            if  v_wgh_child <> ? then
                assign v_wgh_child:sensitive = yes.

        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum t°tulo para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_consistencia */


ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_tit_ap_consistencia:
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

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_consistencia */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    initout:
    do with frame f_rpt_41_tit_ap_consistencia:
        /* block: */
        case self:screen-value:
            when "Arquivo" /*l_file*/ then fil:
             do:
                assign ed_1x40:screen-value    = ""
                       ed_1x40:VISIBLE         = yes
                       bt_get_file:VISIBLE     = yes
                       ed_1x40:SENSITIVE       = yes
                       bt_get_file:SENSITIVE   = yes
                       v_dat_transacao:VISIBLE = NO.

                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
                     use-index srmstr_id
                      /*cl_current_user of usuar_mestre*/ no-error.
                do  transaction:                

                    if  usuar_mestre.nom_dir_spool <> ""
                    then do:
                        assign v_cod_dwb_file_temp = usuar_mestre.nom_dir_spool
                                                          + "~/".
                    end /* if */.

                    if  usuar_mestre.nom_subdir_spool <> ""
                    then do:
                        assign v_cod_dwb_file_temp = v_cod_dwb_file_temp
                                                     + usuar_mestre.nom_subdir_spool
                                                     + "~/".
                    end /* if */.

                    if  v_cod_dwb_file_temp = ""
                    then do:
                        assign v_cod_dwb_file_temp = SESSION:TEMP-DIRECTORY + caps("esapb025.txt").
                    end /* if */.
                    else do:
                        assign v_cod_dwb_file_temp = v_cod_dwb_file_temp + caps("esapb025.txt").
                    end /* else */.

                    assign v_cod_dwb_file_temp = replace(v_cod_dwb_file_temp, "~/", "~\").

                    assign ed_1x40:screen-value               = v_cod_dwb_file_temp.
                end.     
            end /* do fil */.
            when "Tela" /*l_file*/ then fil:
             do:
                assign ed_1x40:screen-value    = ""
                       ed_1x40:VISIBLE         = NO
                       bt_get_file:VISIBLE     = NO
                       v_dat_transacao:VISIBLE = YES
                       v_dat_transacao:SENSITIVE = YES.
                DISP v_dat_transacao WITH FRAME f_rpt_41_tit_ap_consistencia.
            end /* do fil */.
        end /* case block */.

    end /* do initout */.

    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_consistencia */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON GO OF FRAME f_rpt_41_tit_ap_consistencia
DO:

    do transaction:

         assign input frame f_rpt_41_tit_ap_consistencia ed_1x40
                input frame f_rpt_41_tit_ap_consistencia rs_cod_dwb_output
                input frame f_rpt_41_tit_ap_consistencia v_dat_transacao
                v_cod_dwb_file      = ed_1x40
                v_cod_dwb_file_temp = ed_1x40.

         IF rs_cod_dwb_output = "Arquivo" 
         THEN DO:
              run pi_filename_validation (Input v_cod_dwb_file_temp) /*pi_filename_validation*/.
              if  return-value = "NOK" /*l_nok*/ 
              then do:
                  /* Nome do arquivo incorreto ! */
                  run pi_messages (input "show",
                                   input 1064,
                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
                  return no-apply.
              end /* if */.
         END.

    end.    

END. /* ON GO OF FRAME f_rpt_41_tit_ap_consistencia */

ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_consistencia
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_consistencia */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.
if (v_cod_dwb_user = "") then
   assign v_cod_dwb_user = v_cod_usuar_corren.

run prgtec/men/men901za.py (Input 'esapb025') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb025')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb025')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */

/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_tit_ap_consistencia:title = frame f_rpt_41_tit_ap_consistencia:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.01.00.001":U)
                            + chr(41).

pause 0 before-hide.
view frame f_rpt_41_tit_ap_consistencia.

super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    init:
    do with frame f_rpt_41_tit_ap_consistencia:

        assign v_cod_dwb_file_temp = replace(v_cod_dwb_file_temp, "~\", "~/").
        if (index(v_cod_dwb_file_temp, "~/") <> 0) then
            assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).

        assign ed_1x40:screen-value = v_cod_dwb_file_temp.

    end /* do init */.

    enable rs_cod_dwb_output
           bt_get_file
           bt_print
           bt_can
           with frame f_rpt_41_tit_ap_consistencia.

    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_ap_consistencia.

    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_tit_ap_consistencia:

            if (retry) then
                output stream s_1 close.

            wait-for go of frame f_rpt_41_tit_ap_consistencia.

            IF rs_cod_dwb_output = "Arquivo"
               THEN OUTPUT STREAM s_1 TO VALUE(v_cod_dwb_file) CONVERT TARGET 'iso8859-1'.

            ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general').
            RUN pi_rpt_tit_ap_consistencia.
            ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

            IF rs_cod_dwb_output = "Arquivo"
               THEN OUTPUT STREAM s_1 CLOSE.
               ELSE RUN pi_tela_concil.

        end.
    end.
end.

hide frame f_rpt_41_tit_ap_consistencia.

if  this-procedure:persistent then
    delete procedure this-procedure.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_tela_concil:


     VIEW FRAME f_concil.

     concil_block:
     DO ON ERROR UNDO concil_block, RETRY concil_block
                      ON ENDKEY UNDO concil_block, LEAVE concil_block:

          ENABLE ALL WITH FRAME f_concil.

          OPEN QUERY qr_tt_concil
               FOR EACH tt_concil NO-LOCK.

          WAIT-FOR GO OF FRAME f_concil.

          RUN pi_atualiza.

     END.

     HIDE FRAME f_concil.


END.



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

PROCEDURE pi_rpt_tit_ap_consistencia:

    DEFINE VARIABLE v_tot_embarque AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_tit      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_cod_moeda    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-unit        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_comprador    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_tot_tit_ap   AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt_concil.

    IF rs_cod_dwb_output = "Arquivo" 
       THEN PUT STREAM s_1 UNFORMATTED "Estab;Fornec;Espec;Ser;Titulo;Parc;Valor Original;Valor Saldo;Dt Emissao;Moeda APB;Valor Embarque;Moeda Embarque;Diferenca;Entrada Intelbras;Obs;Comprador" SKIP.
    
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:
    
        FIND FIRST param-imp NO-LOCK
             WHERE param-imp.cod-estabel = estabelecimento.cod_estab NO-ERROR.
    
        blk_tit:
        FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab          = estabelecimento.cod_estab
              AND tit_ap.cod_espec          = param-imp.esp-tit-transit
              AND tit_ap.log_sdo_tit_ap     = YES
              AND tit_ap.log_tit_ap_estordo = NO:
    

            FOR EACH b_estabelecimento NO-LOCK
                WHERE b_estabelecimento.cod_empresa = estabelecimento.cod_empresa:
                FIND FIRST b_tit_ap NO-LOCK
                     WHERE b_tit_ap.cod_estab          = b_estabelecimento.cod_estab 
                       AND b_tit_ap.cdn_fornec         = tit_ap.cdn_fornec
                       AND b_tit_ap.cod_espec          = "DI"
                       AND b_tit_ap.cod_tit_ap         = tit_ap.cod_tit_ap
                       AND b_tit_ap.log_sdo_tit_ap     = YES
                       AND b_tit_ap.log_tit_ap_estordo = NO NO-ERROR.
                IF AVAIL b_tit_ap 
                THEN DO:
                     FIND embarque-imp NO-LOCK
                        WHERE embarque-imp.cod-estabel = tit_ap.cod_estab
                          AND embarque-imp.embarque    = tit_ap.cod_tit_ap NO-ERROR.
                     IF AVAIL embarque-imp 
                     THEN DO:
                          FIND historico-embarque OF embarque-imp NO-LOCK
                              WHERE (historico-embarque.cod-pto-contr = 44 OR 
                                     historico-embarque.cod-pto-contr = 246) NO-ERROR.
                     END.
                     IF rs_cod_dwb_output = "Arquivo" 
                     THEN DO:
                          PUT STREAM s_1 UNFORMATTED tit_ap.cod_estab ";" 
                                                     tit_ap.cdn_fornec ";" 
                                                     tit_ap.cod_espec ";" 
                                                     tit_ap.cod_ser ";" 
                                                     tit_ap.cod_tit_ap ";" 
                                                     tit_ap.cod_parcela ";" 
                                                     tit_ap.val_origin_tit_ap ";" 
                                                     tit_ap.val_sdo_tit_ap ";"
                                                     tit_ap.dat_emis_docto ";"
                                                     tit_ap.cod_indic_econ ";" v_tot_embarque ";" v_cod_moeda ";" (tit_ap.val_origin_tit_ap - v_tot_embarque) ";" IF AVAIL historico-embarque THEN STRING(historico-embarque.dt-efetiva) ELSE "" ";;" v_comprador SKIP.
                          PUT STREAM s_1 UNFORMATTED b_tit_ap.cod_estab ";" 
                                                     b_tit_ap.cdn_fornec ";" 
                                                     b_tit_ap.cod_espec ";" 
                                                     b_tit_ap.cod_ser ";" 
                                                     b_tit_ap.cod_tit_ap ";" 
                                                     b_tit_ap.cod_parcela ";" 
                                                     b_tit_ap.val_origin_tit_ap ";" 
                                                     b_tit_ap.val_sdo_tit_ap ";" 
                                                     b_tit_ap.dat_emis_docto ";"
                                                     b_tit_ap.cod_indic_econ ";" v_tot_embarque ";" v_cod_moeda ";" (tit_ap.val_origin_tit_ap - v_tot_embarque) ";" IF AVAIL historico-embarque THEN STRING(historico-embarque.dt-efetiva) ELSE "" ";DI nao baixou IT;" v_comprador SKIP.
                     END.
                     ELSE DO:
                          CREATE tt_concil.
                          ASSIGN tt_concil.v_log_selec          = NO
                                 tt_concil.v_cod_estab          = tit_ap.cod_estab
                                 tt_concil.v_cdn_fornec         = tit_ap.cdn_fornec
                                 tt_concil.v_cod_espec          = tit_ap.cod_espec
                                 tt_concil.v_cod_ser            = tit_ap.cod_ser
                                 tt_concil.v_cod_tit_ap         = tit_ap.cod_tit_ap
                                 tt_concil.v_cod_parc           = tit_ap.cod_parcela
                                 tt_concil.v_val_orig           = tit_ap.val_origin_tit_ap
                                 tt_concil.v_val_sdo            = tit_ap.val_sdo_tit_ap
                                 tt_concil.v_moeda_apb          = tit_ap.cod_indic_econ
                                 tt_concil.v_val_embarque       = v_tot_embarque
                                 tt_concil.v_moeda_embarque     = STRING(v_cod_moeda)
                                 tt_concil.v_val_dif            = tit_ap.val_sdo_tit_ap
                                 tt_concil.v_dat_entr_intelbras = IF AVAIL historico-embarque THEN historico-embarque.dt-efetiva ELSE ?
                                 tt_concil.v_nom_comprador      = v_comprador
                                 tt_concil.v_des_validacao      = "DI nao baixou totalmente a IT."
                                 tt_concil.v_dat_emis_docto     = tit_ap.dat_emis_docto.
                     END.
                     NEXT blk_tit.
                END.
            END.

            ASSIGN v_tot_embarque = 0
                   v_cod_moeda    = 0.
    
            ASSIGN de-unit     = 0
                   v_comprador = "".

            FIND embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = tit_ap.cod_estab
                  AND embarque-imp.embarque    = tit_ap.cod_tit_ap NO-ERROR.
            IF AVAIL embarque-imp 
            THEN DO:

                 FOR EACH ordens-embarque FIELDS(numero-ordem quantidade qt-do-forn)
                     WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                       AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:

                     ASSIGN de-unit     = 0
                            v_comprador = "".

                     FOR FIRST ordem-compra
                         WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                         FIND cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                               AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
                         IF AVAIL cotacao-item 
                            THEN ASSIGN de-unit     = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)
                                        v_cod_moeda = cotacao-item.mo-codigo.
                            ELSE ASSIGN v_cod_moeda = ordem-compra.mo-codigo.

                         FIND pedido-compr NO-LOCK 
                              WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.    
                         IF AVAIL pedido-compr
                         THEN DO:
                              ASSIGN v_comprador = v_comprador + pedido-compr.responsavel.
                              FIND FIRST usuar_mestre NO-LOCK 
                                   WHERE usuar_mestre.cod_usuario = pedido-compr.responsavel NO-ERROR.
                              IF AVAIL usuar_mestre
                                  THEN ASSIGN v_comprador = v_comprador + " - " + usuar_mestre.nom_usuario + ". ".
                         END.
                        
                     END.
                     ASSIGN v_tot_embarque = v_tot_embarque + (ordens-embarque.qt-do-forn * de-unit).

                 END.

                 FIND historico-embarque OF embarque-imp NO-LOCK
                     WHERE (historico-embarque.cod-pto-contr = 44 OR 
                            historico-embarque.cod-pto-contr = 246) NO-ERROR.

                 IF AVAIL historico-embarque
                 AND historico-embarque.dt-efetiva <> ?
                 AND rs_cod_dwb_output = "Arquivo" 
                 THEN DO:
                      PUT STREAM s_1 UNFORMATTED tit_ap.cod_estab ";" 
                                                 tit_ap.cdn_fornec ";" 
                                                 tit_ap.cod_espec ";" 
                                                 tit_ap.cod_ser ";" 
                                                 tit_ap.cod_tit_ap ";" 
                                                 tit_ap.cod_parcela ";" 
                                                 tit_ap.val_origin_tit_ap ";" 
                                                 tit_ap.val_sdo_tit_ap ";" 
                                                 tit_ap.dat_emis_docto ";"
                                                 tit_ap.cod_indic_econ ";" v_tot_embarque ";" v_cod_moeda ";" (tit_ap.val_origin_tit_ap - v_tot_embarque) ";" IF AVAIL historico-embarque THEN STRING(historico-embarque.dt-efetiva) ELSE "" ";Data Efetiva Entrada NF confirmada com IT em aberto;" v_comprador SKIP.
                 END.
            END.

            ASSIGN v_tot_tit_ap = 0.
            FOR EACH b_tit_ap NO-LOCK
                WHERE b_tit_ap.cod_estab          = tit_ap.cod_estab 
                  AND b_tit_ap.cdn_fornec         = tit_ap.cdn_fornec
                  AND b_tit_ap.cod_espec          = tit_ap.cod_espec 
                  AND b_tit_ap.cod_ser            = tit_ap.cod_ser   
                  AND b_tit_ap.cod_tit_ap         = tit_ap.cod_tit_ap
                  AND b_tit_ap.log_sdo_tit_ap     = YES
                  AND b_tit_ap.log_tit_ap_estordo = NO:
                ASSIGN v_tot_tit_ap = v_tot_tit_ap + b_tit_ap.val_sdo_tit_ap.
            END.
    
            IF /* (tit_ap.val_origin_tit_ap <> ROUND(v_tot_embarque, 2)
            AND  ABS(tit_ap.val_origin_tit_ap - v_tot_embarque) > 5) 
             OR */ (v_tot_tit_ap <> ROUND(v_tot_embarque, 2))
            /*AND  ABS(v_tot_tit_ap - v_tot_embarque) > 5)*/
            THEN DO:
                 FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.
                 FIND itinerario NO-LOCK
                     WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
                 FIND historico-embarque OF embarque-imp NO-LOCK
                     WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.
                 IF rs_cod_dwb_output = "Arquivo"
                    THEN PUT STREAM s_1 UNFORMATTED tit_ap.cod_estab ";" 
                                                    tit_ap.cdn_fornec ";" 
                                                    tit_ap.cod_espec ";" 
                                                    tit_ap.cod_ser ";" 
                                                    tit_ap.cod_tit_ap ";" 
                                                    tit_ap.cod_parcela ";" 
                                                    tit_ap.val_origin_tit_ap ";" 
                                                    tit_ap.val_sdo_tit_ap ";" 
                                                    tit_ap.dat_emis_docto ";"
                                                    tit_ap.cod_indic_econ ";" v_tot_embarque ";" v_cod_moeda ";" (tit_ap.val_origin_tit_ap - v_tot_embarque) ";" IF AVAIL historico-embarque THEN STRING(historico-embarque.dt-efetiva) ELSE "" ";;" v_comprador SKIP.

                    ELSE DO:
                         CREATE tt_concil.
                         ASSIGN tt_concil.v_log_selec          = NO
                                tt_concil.v_cod_estab          = tit_ap.cod_estab
                                tt_concil.v_cdn_fornec         = tit_ap.cdn_fornec
                                tt_concil.v_cod_espec          = tit_ap.cod_espec
                                tt_concil.v_cod_ser            = tit_ap.cod_ser
                                tt_concil.v_cod_tit_ap         = tit_ap.cod_tit_ap
                                tt_concil.v_cod_parc           = tit_ap.cod_parcela
                                tt_concil.v_val_orig           = tit_ap.val_origin_tit_ap
                                tt_concil.v_val_sdo            = tit_ap.val_sdo_tit_ap
                                tt_concil.v_moeda_apb          = tit_ap.cod_indic_econ
                                tt_concil.v_val_embarque       = v_tot_embarque
                                tt_concil.v_moeda_embarque     = STRING(v_cod_moeda)
                                tt_concil.v_val_dif            = (tit_ap.val_sdo_tit_ap - v_tot_embarque)
                                tt_concil.v_dat_entr_intelbras = IF AVAIL historico-embarque THEN historico-embarque.dt-efetiva ELSE ?
                                tt_concil.v_nom_comprador      = v_comprador
                                tt_concil.v_des_validacao      = "Valor do embarque diferente da IT."
                                tt_concil.v_dat_emis_docto     = tit_ap.dat_emis_docto.
                    END.

            END.
    
        END.
    END.

END PROCEDURE.

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
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/**********************  End of rpt_tit_ap_consistencia *********************/


PROCEDURE pi_atualiza:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_count         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_num_seq_refer AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.

    trans_block:
    DO TRANSACTION:
    
        IF SESSION:SET-WAIT-STATE('general') THEN.
    
        /* ** API Alteraá∆o ***/
        FOR EACH tt_concil
            WHERE tt_concil.v_log_selec:
    
            FIND tit_ap NO-LOCK
                WHERE tit_ap.cod_estab   = tt_concil.v_cod_estab  
                  AND tit_ap.cdn_fornec  = tt_concil.v_cdn_fornec 
                  AND tit_ap.cod_espec   = tt_concil.v_cod_espec  
                  AND tit_ap.cod_ser     = tt_concil.v_cod_ser    
                  AND tit_ap.cod_tit_ap  = tt_concil.v_cod_tit_ap 
                  AND tit_ap.cod_parcela = tt_concil.v_cod_parc NO-ERROR.
    
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
                   tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = v_dat_transacao
                   tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                   tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap - tt_concil.v_val_dif
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
                   tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr               = "Acerto de Valor gerado pelo programa esapb025 - Conciliaá∆o Embarque x IT.".
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
            MESSAGE "API Alteraá∆o" SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_estab SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto SKIP
                    tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto    SKIP
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
             MESSAGE "Operaá∆o Cancelada !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
             UNDO trans_block, RETURN ERROR.
        END.
    
        MESSAGE "AVA Gerado !" VIEW-AS ALERT-BOX.
    
        /*UNDO trans_block, RETURN ERROR. */

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
        format "Sim/N∆o"
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
