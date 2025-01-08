/*****************************************************************************
** Nome Externo..........: esp/acr/esacr066.p
** Descricao.............: Controle Juros - Contas a Receber
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 04/04/2016
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=37":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_datas_faixa no-undo
    field ttv_dat_table                    as date format "99/99/9999"
    index tt_data                          is primary
          ttv_dat_table                    ascending
    .

def temp-table tt_empresa no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_id                           
          tta_cod_empresa                  ascending
    .

def temp-table tt_espec_docto_faixa no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    index tt_codigo                        is primary
          tta_cod_espec_docto              ascending
    .

def temp-table tt_estabelecimento_empresa no-undo like estabelecimento
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_nom_razao_social             as character format "x(40)" label "Raz∆o Social" column-label "Raz∆o Social"
    field ttv_log_selec                    as logical format "Sim/N∆o" initial no column-label "Gera"
    index tt_cod_estab                     is primary unique
          tta_cod_estab                    ascending
    .

def temp-table tt_rpt_movto_tit_acr_contr_juro no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field ttv_nom_pessoa_cli               as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field ttv_nom_pessoa_rep               as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_nom_pessoa_portad            as character format "x(24)"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaá∆o" column-label "Liquidaá∆o"
    field ttv_num_dias_atraso_juros        as integer format "-9999" label "Atraso" column-label "Atraso"
    field ttv_cod_finalid_econ_liq         as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquidaá∆o" column-label "Vl Liquidaá∆o"
    field ttv_val_juros_inf                as decimal format ">>>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Juros Inform"
    field ttv_val_juros_cal                as decimal format ">>>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Juros Calc"
    field ttv_val_juros_dif                as decimal format "(>>>>,>>>,>>9.99)" decimals 3 label "Valor Juros" column-label "Diferenáa"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field ttv_cod_dwb_field_rpt            as character extent 9 format "x(32)" label "Conjunto" column-label "Conjunto"
    field tta_log_gera_avdeb               as logical format "Sim/N∆o" initial no label "Gera Aviso DÇbito" column-label "Gera Aviso DÇbito"
    FIELD tta_cod_grp_cob                  LIKE int-emitente.cod-gr-cob
    index tt_prim_unic                     is primary unique
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_num_id_movto_tit_acr         ascending
    .

def temp-table tt_usuar_grp_usuar no-undo like usuar_grp_usuar
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

&if "{&emsuni_version}" >= "1.00" &then
def buffer b_finalid_econ
    for finalid_econ.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_finalid_unid_organ
    for finalid_unid_organ.
&endif
&if "{&emsbas_version}" >= "1.00" &then
def buffer b_ped_exec_style
    for ped_exec.
&endif
&if "{&emsbas_version}" >= "1.00" &then
def buffer b_servid_exec_style
    for servid_exec.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def new shared var v_cdn_cliente_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "Cliente Final"
    no-undo.
def new shared var v_cdn_cliente_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente"
    column-label "Cliente Inicial"
    no-undo.
def new shared var v_cdn_repres_fim
    as Integer
    format ">>>,>>9":U
    initial 999999
    label "atÇ"
    column-label "Repres Final"
    no-undo.
def new shared var v_cdn_repres_ini
    as Integer
    format ">>>,>>9":U
    initial 0
    label "Representante"
    column-label "Repres Inicial"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new shared var v_cod_cart_bcia_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Carteira"
    no-undo.
def new shared var v_cod_cart_bcia_ini
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_cod_dwb_parameters
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_print_layout
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_proced
    as character
    format "x(8)":U
    no-undo.
def new shared var v_cod_dwb_program
    as character
    format "x(32)":U
    label "Programa"
    column-label "Programa"
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
def new shared var v_cod_espec_docto_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "C¢digo Final"
    no-undo.
def new shared var v_cod_espec_docto_ini
    as character
    format "x(3)":U
    label "EspÇcie"
    column-label "C¢digo Inicial"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
    no-undo.
def var v_cod_finalid_econ_apres
    as character
    format "x(10)":U
    initial "Corrente" /*l_corrente*/
    label "Finalid Apresentaá∆o"
    column-label "Finalid Apresentaá∆o"
    no-undo.
def var v_cod_finalid_econ_aux
    as character
    format "x(10)":U
    label "Finalidade"
    column-label "Finalidade"
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
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new shared var v_cod_indic_econ_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def new shared var v_cod_indic_econ_ini
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Inicial"
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
def new shared var v_cod_order_rpt
    as character
    format "x(80)":U
    label "Ordem Relat"
    column-label "Ordem Relat"
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
def new shared var v_cod_portador_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Portador Final"
    no-undo.
def new shared var v_cod_portador_ini
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador Inicial"
    no-undo.
def new shared var v_cod_refer_fim
    as character
    format "x(10)":U
    initial "ZZZZZZZZZZ"
    label "atÇ"
    column-label "Referància Final"
    no-undo.
def new shared var v_cod_refer_ini
    as character
    format "x(10)":U
    label "Referància"
    column-label "Referància"
    no-undo.
def new shared var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_ult_obj_procesdo
    as character
    format "x(32)":U
    no-undo.
def new shared var v_cod_unid_negoc_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def new shared var v_cod_unid_negoc_ini
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Inicial"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
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
def var v_dat_conver
    as date
    format "99/99/9999":U
    initial today
    label "Data Convers∆o"
    column-label "Data Convers∆o"
    no-undo.
def var v_dat_cotac_indic_econ
    as date
    format "99/99/9999":U
    initial today
    label "Data Cotaá∆o"
    column-label "Data Cotaá∆o"
    no-undo.
def new shared var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_execution_end
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_fim_period
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    no-undo.
def new shared var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def var v_dat_juros
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_transacao_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Final"
    no-undo.
def new shared var v_dat_transacao_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Transaá∆o"
    column-label "Data Transaá∆o"
    no-undo.

def new shared var v-cod-gr-cob-fim
    LIKE int-emitente.cod-gr-cob
    initial 99
    label "Final"
    column-label "Final"
    no-undo.
def new shared var v-cod-gr-cob-ini
    LIKE int-emitente.cod-gr-cob
    INITIAL 0
    label "Grupo Cobranáa"
    column-label "Grupo Cobranáa"
    no-undo.

def new shared var v_des_estab_select
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Selecionados"
    column-label "Selecionados"
    no-undo.
def new shared var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def new shared var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
    no-undo.
def var v_ind_apres_tit_avdeb
    as character
    format "X(15)":U
    initial "Todos" /*l_todos*/
    view-as radio-set Horizontal
    radio-buttons "Todos", "Todos", "Geraram AD", "Geraram AD", "N∆o Geraram AD", "N∆o Geraram AD"
     /*l_todos*/ /*l_todos*/ /*l_geraram_ad*/ /*l_geraram_ad*/ /*l_nao_geraram_ad*/ /*l_nao_geraram_ad*/
    bgcolor 8 
    label "Imprimir T°tulos"
    column-label "Imprimir T°tulos"
    no-undo.
def new shared var v_ind_classif
    as character
    format "X(35)":U
    initial "Por T°tulo" /*l_por_titulo*/
    no-undo.
def var v_ind_dwb_run_mode
    as character
    format "X(07)":U
    initial "On-Line" /*l_online*/
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line", "Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    label "Run Mode"
    column-label "Run Mode"
    no-undo.
def var v_ind_especie
    as character
    format "X(25)":U
    initial "Normal e Nota DB" /*l_normal_Nota_DB*/
    view-as radio-set Vertical
    radio-buttons "Normal e Nota DB", "Normal e Nota DB", "Cheque", "Cheque"
     /*l_normal_Nota_DB*/ /*l_normal_Nota_DB*/ /*l_cheque*/ /*l_cheque*/
    bgcolor 8 
    label "Tipo EspÇcie"
    column-label "Tipo EspÇcie"
    no-undo.
def var v_ind_tip_calc_juros
    as character
    format "X(10)":U
    initial "Simples" /*l_simples*/
    view-as combo-box
    list-items "Simples","Compostos"
     /*l_simples*/ /*l_compostos*/
    inner-lines 2
    bgcolor 15 font 2
    label "Tipo C†lculo Juros"
    column-label "Tipo C†lculo Juros"
    no-undo.
def var v_ind_visualiz_tit_acr_vert
    as character
    format "X(20)":U
    initial "Por Estabelecimento" /*l_por_estabelecimento*/
    view-as radio-set Vertical
    radio-buttons "Por Estabelecimento", "Por Estabelecimento", "Por Unidade Neg¢cio", "Por Unidade Neg¢cio"
     /*l_por_estabelecimento*/ /*l_por_estabelecimento*/ /*l_por_unid_negoc*/ /*l_por_unid_negoc*/
    bgcolor 8 
    label "Visualiza T°tulo"
    column-label "Visualiza T°tulo"
    no-undo.
def var v_log_control_terc_acr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_execution
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_funcao_tip_calc_juros
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_gera_avdeb
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Aviso de DÇbito"
    column-label "Gera Aviso de DÇbito"
    no-undo.
def var v_log_impr_avdeb
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Aviso de DÇbito"
    column-label "Aviso de DÇbito"
    no-undo.
def var v_log_impr_cheq_acr
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheque"
    column-label "Cheque"
    no-undo.
def var v_log_impr_normal
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Normal"
    column-label "Normal"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_modul_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_mostra_docto_vendor
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Vendor"
    column-label "Vendor"
    no-undo.
def var v_log_mostra_docto_vendor_repac
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Vendor Repactuado"
    column-label "Vendor Repactuado"
    no-undo.
def var v_log_movto_estordo
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_ok
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_print
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_print_par
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_tip_espec_docto_cheq_terc
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheques Terceiros"
    column-label "Cheques Terceiros"
    no-undo.
def var v_log_tip_espec_docto_terc
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Dupl. Terceiros"
    column-label "Dupl. Terceiros"
    no-undo.
def var v_nom_dwb_printer
    as character
    format "x(30)":U
    no-undo.
def var v_nom_dwb_print_file
    as character
    format "x(100)":U
    label "Arquivo Impress∆o"
    column-label "Arq Impr"
    no-undo.
def new shared var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_nom_integer
    as character
    format "x(30)":U
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
def new shared var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def new shared var v_nom_report_title
    as character
    format "x(40)":U
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
def var v_num_dias_atraso
    as integer
    format "->>>>,>>9":U
    column-label "Dias/Atraso"
    no-undo.
def new shared var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
    no-undo.
def var v_num_idx
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_ocorrencia
    as integer
    format ">>>>,>>9":U
    no-undo.
def new shared var v_num_page_number
    as integer
    format ">>>>>9":U
    label "P†gina"
    column-label "P†gina"
    no-undo.
def var v_num_ped_exec
    as integer
    format ">>>>9":U
    label "Pedido"
    column-label "Pedido"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq
    as integer
    format ">>>,>>9":U
    label "SeqÅància"
    column-label "Seq"
    no-undo.
def var v_qtd_bottom
    as decimal
    format ">>9":U
    decimals 0
    no-undo.
def var v_qtd_column
    as decimal
    format ">>9":U
    decimals 0
    label "Colunas"
    column-label "Colunas"
    no-undo.
def var v_qtd_dias_atraso
    as decimal
    format ">,>>9.9999":U
    decimals 4
    no-undo.
def var v_qtd_line
    as decimal
    format ">>9":U
    decimals 0
    label "Linhas"
    column-label "Linhas"
    no-undo.
def var v_qtd_line_ant
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    no-undo.
def new global shared var v_rec_clien_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_finalid_econ
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_movto_tit_acr
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_cotac_indic_econ
    as decimal
    format "->>,>>>,>>>,>>9.9999999999":U
    decimals 10
    label "Cotaá∆o"
    column-label "Cotaá∆o"
    no-undo.
def var v_val_difer_juros
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_aux
    as decimal
    format ">>>>,>>>,>>9.99":U
    decimals 2
    label "Valor"
    column-label "Valor"
    no-undo.
def var v_val_juros_calc
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor Juros Calc"
    column-label "Juros Calc"
    no-undo.
def var v_val_juros_inf_apres
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_liquidac_apres
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_difer_clien
    as decimal
    format "(>>,>>>,>>>,>>9.99)":U
    decimals 3
    no-undo.
def var v_val_tot_difer_geral
    as decimal
    format "(>>>>,>>>,>>>,>>9.99)":U
    decimals 3
    no-undo.
def var v_val_tot_difer_portad
    as decimal
    format "(>>,>>>,>>>,>>9.99)":U
    decimals 3
    no-undo.
def var v_val_tot_difer_repres
    as decimal
    format "(>>,>>>,>>>,>>9.99)":U
    decimals 3
    no-undo.
def var v_val_tot_juros_calcul_clien
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_calcul_geral
    as decimal
    format "->>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_calcul_portad
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_calcul_repres
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_infor
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_infor_clien
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_infor_geral
    as decimal
    format "->>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_infor_portad
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_juros_infor_repres
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_liquidac
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total Liquidaá∆o"
    no-undo.
def var v_val_tot_liquidac_clien
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_liquidac_geral
    as decimal
    format "->>>>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total Liquidaá∆o"
    no-undo.
def var v_val_tot_liquidac_portad
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_liquidac_repres
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_004
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
def rectangle rt_009
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_dimensions
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_run
    size 1 by 1
    edge-pixels 2.
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
def button bt_close
    label "&Fecha"
    tooltip "Fecha"
    size 1 by 1
    auto-go.
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
def button bt_ran2
    label "Faixa"
    tooltip "Faixa"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
&endif
    size 1 by 1.
def button bt_set_printer
    label "Define Impressora e Layout"
    tooltip "Define Impressora e Layout de Impress∆o"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-setpr.bmp"
    image-insensitive file "image/ii-setpr"
&endif
    size 1 by 1.
def button bt_todos_img
    label "Todos"
    tooltip "Seleciona Todos"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran_a.bmp"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_197554
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_197555
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_197563
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_197564
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


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
    initial "Terminal"
    view-as radio-set Horizontal
    radio-buttons "Terminal", "Terminal", "Arquivo", "Arquivo", "Impressora", "Impressora"
     /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
    bgcolor 8 
    no-undo.
def var rs_controle_juros_classif
    as character
    initial "Por Cliente"
    view-as radio-set Horizontal
    radio-buttons "Por Cliente", "Por Cliente", "Por Repres./Cliente", "Por Repres./Cliente", "Por Portador/Cliente", "Por Portador/Cliente"
     /*l_por_cliente*/ /*l_por_cliente*/ /*l_por_represcliente*/ /*l_por_represcliente*/ /*l_por_portadorcliente*/ /*l_por_portadorcliente*/
    bgcolor 8 
    no-undo.
def var rs_ind_run_mode
    as character
    initial "On-Line"
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line", "Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 172.
def new shared var v_rpt_s_1_bottom as integer initial 65.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "Controle Juros - Contas a Receber".
def frame f_rpt_s_1_header_period header
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    "P†gina:" at 160
    (page-number (s_1) + v_rpt_s_1_page) at 167 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    v_nom_report_title at 132 format "x(40)" skip
    "Per°odo: " at 1
    v_dat_inic_period at 10 format "99/99/9999"
    "A" at 21
    v_dat_fim_period at 23 format "99/99/9999"
    "------------------------------------------------------------------------------------------------------------------------" at 34
    v_dat_execution at 155 format "99/99/9999" "- "
    v_hra_execution at 168 format "99:99" skip (1)
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    'P†gina:' at 160
    (page-number (s_1) + v_rpt_s_1_page) at 167 format '>>>>>9' skip
    v_nom_enterprise at 1 format 'x(40)'
    v_nom_report_title at 133 format 'x(40)' skip
    '---------------------------------------------------------------------------------------------------------------------------------------------------------' at 1
    v_dat_execution at 155 format '99/99/9999' '- '
    v_hra_execution at 168 format "99:99" skip (1)
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    "Èltima p†gina " at 1
    "--------------------------------------------------------------------------------------------------------------------------------------" at 15
    v_nom_prog_ext at 150 format "x(08)" "- "
    v_cod_release at 161 format "x(12)" skip
    with no-box no-labels width 172 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    "---------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    "- " at 148
    v_nom_prog_ext at 150 format "x(08)" "- "
    v_cod_release at 161 format "x(12)" skip
    with no-box no-labels width 172 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    "P†gina ParÉmetros " at 1
    "----------------------------------------------------------------------------------------------------------------------------------" at 19
    v_nom_prog_ext at 150 format "x(08)" "- "
    v_cod_release at 161 format "x(12)" skip
    with no-box no-labels width 172 page-bottom stream-io.
def frame f_rpt_s_1_Grp_cab_complem_Lay_compl_cab header skip skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_cab_finalid_Lay_finalid header
    "Per°odo:" at 1
    v_dat_transacao_ini at 11 format "99/99/9999" view-as text
    "atÇ: " at 22
    v_dat_transacao_fim at 27 format "99/99/9999" view-as text
    skip (1)
    "Finalidade: " at 1
    v_cod_finalid_econ at 13 format "x(10)" view-as text
    "Apresentaá∆o: " at 29
    v_cod_finalid_econ_apres at 43 format "x(10)" view-as text
    "Data Cotaá∆o: " at 59
    v_dat_cotac_indic_econ at 73 format "99/99/9999" view-as text skip (1)
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_cab_princip_Lay_cab_aux header
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    "Estab" at 1
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    "Estab" at 1
&ENDIF
    "Esp" at 7
    "SÇrie" at 11
    "T°tulo" at 17
    "/P" at 34
    "Un N" at 37
    "Port" at 42
    "Cart" at 48
    "Vencimento" at 53
    "Liquidaá∆o" at 64
    "AD" at 75
    "ATRS" to 83
    "Liquidaáao" at 85
    "Vl Liquidaá∆o" to 109
    "Juros Inform" to 130
    "Juros Calc" to 151
    "Diferenáa" to 172 skip
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    "-----" at 1
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    "-----" at 1
&ENDIF
    "---" at 7
    "-----" at 11
    "----------------" at 17
    "--" at 34
    "----" at 37
    "-----" at 42
    "----" at 48
    "----------" at 53
    "----------" at 64
    "---" at 75
    "-----" to 83
    "----------" at 85
    "--------------" to 109
    "---------------" to 130
    "---------------" to 151
    "-----------------" to 172 skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_cab_princip_Lay_cab_princip header
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    "Estab" at 1
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    "Estab" at 1
&ENDIF
    "Esp" at 7
    "SÇrie" at 11
    "T°tulo" at 17
    "/P" at 34
    "Un N" at 37
    "Port" at 42
    "Cart" at 48
    "Vencimento" at 53
    "Liquidaá∆o" at 64
    "ATRS" to 79
    "Liquidaáao" at 81
    "Vl Liquidaá∆o" to 109
    "Juros Inform" to 130
    "Juros Calc" to 151
    "Diferenáa" to 172 skip
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    "-----" at 1
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    "-----" at 1
&ENDIF
    "---" at 7
    "-----" at 11
    "----------------" at 17
    "--" at 34
    "----" at 37
    "-----" at 42
    "----" at 48
    "----------" at 53
    "----------" at 64
    "-----" to 79
    "----------" at 81
    "--------------" to 109
    "---------------" to 130
    "---------------" to 151
    "-----------------" to 172 skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_1 header
    "---------------------------------------------" at 33
    "Visualizaá∆o" at 79
    "---------------------------------------------" at 93
    skip (1)
    "  Visualiza: " at 74
    v_ind_visualiz_tit_acr_vert at 87 format "X(20)" view-as text skip
    v_ind_classif at 87 format "X(35)" view-as text skip
    "Liquidaá‰es Estornadas:     " at 63
    v_log_movto_estordo at 91 format "Sim/N∆o" view-as text
    skip (1)
    "---------------------------------------------" at 33
    "Apresentaá∆o  " at 79
    "---------------------------------------------" at 93
    skip (1)
    "    Finalidade Econìmica: " at 61
    v_cod_finalid_econ at 87 format "x(10)" view-as text skip
    "Finalid Apresentaá∆o: " at 65
    v_cod_finalid_econ_apres at 87 format "x(10)" view-as text skip
    "Data Cotaá∆o: " at 73
    v_dat_cotac_indic_econ at 87 format "99/99/9999" view-as text
    skip (1)
    "---------------------------------------------" at 34
    "Imprimir" at 83
    "---------------------------------------------" at 95
    skip (1)
    "  T°tulos: " at 77
    v_ind_apres_tit_avdeb at 88 format "X(15)" view-as text
    skip (1)
    "---------------------------------------------" at 33
    "Tipo EspÇcie  " at 79
    "---------------------------------------------" at 94
    skip (1)
    "  Normal: " at 77
    v_log_impr_normal at 87 format "Sim/N∆o" view-as text skip
    "   Aviso de DÇbito: " at 67
    v_log_impr_avdeb at 87 format "Sim/N∆o" view-as text skip
    "Cheque: " at 79
    v_log_impr_cheq_acr at 87 format "Sim/N∆o" view-as text skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_2 header
    "  Dupl. Terceiros: " at 68
    v_log_tip_espec_docto_terc at 87 format "Sim/N∆o" view-as text skip
    "    Cheques Terceiros: " at 64
    v_log_tip_espec_docto_cheq_terc at 87 format "Sim/N∆o" view-as text skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_vdr header
    "  Vendor: " at 77
    v_log_mostra_docto_vendor at 87 format "Sim/N∆o" view-as text skip
    "    Vendor Repactuado: " at 64
    v_log_mostra_docto_vendor_repac at 87 format "Sim/N∆o" view-as text skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_rep_cli_port_Lay_tit_cliente header skip skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_rep_cli_port_Lay_tit_portador header skip skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_rep_cli_port_Lay_tit_repres header skip skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_totais_Lay_cliente header skip (1) skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_totais_Lay_geral header skip skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_totais_Lay_portador header skip (1) skip
    with no-box no-labels width 172 page-top stream-io.
def frame f_rpt_s_1_Grp_totais_Lay_repres header skip (1) skip
    with no-box no-labels width 172 page-top stream-io.


/*************************** Report Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_ran_01_movto_tit_acr_contr_juros
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 13.04 col 02.00 bgcolor 7 
    v_des_estab_select
         at row 01.46 col 20.00 colon-aligned label "Estab Selec"
         help "Estabelecimentos selecionados"
         view-as editor max-chars 2000 no-word-wrap
         size 30 by 1
         bgcolor 15 font 2
    bt_todos_img
         at row 01.46 col 52.14 font ?
         help "Seleciona Todos"
    v_cod_unid_negoc_ini
         at row 02.58 col 20.00 colon-aligned label "Unid Neg¢cio"
         help "Unidade de Neg¢cio Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_unid_negoc_fim
         at row 02.58 col 39.00 colon-aligned label "atÇ"
         help "Unidade de Neg¢cio Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_ini
         at row 03.58 col 20.00 colon-aligned label "EspÇcie"
         help "C¢digo Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_fim
         at row 03.58 col 39.00 colon-aligned label "atÇ"
         help "C¢digo Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_cliente_ini
         at row 04.58 col 20.00 colon-aligned label "Cliente"
         help "C¢digo do Cliente Inicial"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_197564
         at row 04.58 col 34.14
    v_cdn_cliente_fim
         at row 04.58 col 39.00 colon-aligned label "atÇ"
         help "C¢digo do Cliente Final"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_197563
         at row 04.58 col 53.14
    v_cdn_repres_ini
         at row 05.58 col 20.00 colon-aligned label "Representante"
         help "C¢digo Representante"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_repres_fim
         at row 05.58 col 39.00 colon-aligned label "atÇ"
         help "C¢digo Representante"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portador_ini
         at row 06.58 col 20.00 colon-aligned label "Portador"
         help "C¢digo Portador Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portador_fim
         at row 06.58 col 39.00 colon-aligned label "atÇ"
         help "C¢digo Portador"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_ini
         at row 07.58 col 20.00 colon-aligned label "Carteira"
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_fim
         at row 07.58 col 39.00 colon-aligned label "atÇ"
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_refer_ini
         at row 08.58 col 20.00 colon-aligned label "Referància"
         help "C¢digo Referància"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_refer_fim
         at row 08.58 col 39.00 colon-aligned label "atÇ"
         help "C¢digo Referància"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_indic_econ_ini
         at row 09.58 col 20.00 colon-aligned label "Moeda"
         help "Indicador Econìmico Inicial"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_indic_econ_fim
         at row 09.58 col 39.00 colon-aligned label "atÇ"
         help "Indicador Econìmico Final"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_ini
         at row 10.58 col 20.00 colon-aligned label "Data Transaá∆o"
         help "Data de Transaá∆o Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_fim
         at row 10.58 col 39.00 colon-aligned label "atÇ"
         help "Data de Transaá∆o Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v-cod-gr-cob-ini
        at row 11.58 col 20.00 colon-aligned label "Grupo Cobranáa"
        help "Grupo Cobranáa Inicial"
        view-as fill-in
        size-chars 03.14 by .88
        fgcolor ? bgcolor 15 font 2
    v-cod-gr-cob-fim
        at row 11.58 col 39.00 colon-aligned label "atÇ"
        help "Grupo Cobranáa Final"
        view-as fill-in
        size-chars 03.14 by .88
        fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 13.25 col 03.00 font ?
         help "OK"
    bt_can
         at row 13.25 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 13.25 col 47.14 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 59.57 by 14.88 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - Complemento do Movimento".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars        in frame f_ran_01_movto_tit_acr_contr_juros = 10.00
           bt_can:height-chars       in frame f_ran_01_movto_tit_acr_contr_juros = 01.00
           bt_hel2:width-chars       in frame f_ran_01_movto_tit_acr_contr_juros = 10.00
           bt_hel2:height-chars      in frame f_ran_01_movto_tit_acr_contr_juros = 01.00
           bt_ok:width-chars         in frame f_ran_01_movto_tit_acr_contr_juros = 10.00
           bt_ok:height-chars        in frame f_ran_01_movto_tit_acr_contr_juros = 01.00
           bt_todos_img:width-chars  in frame f_ran_01_movto_tit_acr_contr_juros = 04.00
           bt_todos_img:height-chars in frame f_ran_01_movto_tit_acr_contr_juros = 01.13
           rt_cxcf:width-chars       in frame f_ran_01_movto_tit_acr_contr_juros = 56.14
           rt_cxcf:height-chars      in frame f_ran_01_movto_tit_acr_contr_juros = 01.42
           rt_mold:width-chars       in frame f_ran_01_movto_tit_acr_contr_juros = 56.14
           rt_mold:height-chars      in frame f_ran_01_movto_tit_acr_contr_juros = 11.67.
    /* set return-inserted = yes for editors */
    assign v_des_estab_select:return-inserted in frame f_ran_01_movto_tit_acr_contr_juros = yes.
    /* set private-data for the help system */
    assign v_des_estab_select:private-data    in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000018127":U
           bt_todos_img:private-data          in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000021504":U
           v_cod_unid_negoc_ini:private-data  in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000019459":U
           v_cod_unid_negoc_fim:private-data  in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000019460":U
           v_cod_espec_docto_ini:private-data in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000016628":U
           v_cod_espec_docto_fim:private-data in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000016629":U
           bt_zoo_197564:private-data         in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000009431":U
           v_cdn_cliente_ini:private-data     in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022353":U
           bt_zoo_197563:private-data         in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000009431":U
           v_cdn_cliente_fim:private-data     in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022352":U
           v_cdn_repres_ini:private-data      in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000023776":U
           v_cdn_repres_fim:private-data      in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000023777":U
           v_cod_portador_ini:private-data    in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000014638":U
           v_cod_portador_fim:private-data    in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000014647":U
           v_cod_cart_bcia_ini:private-data   in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000023778":U
           v_cod_cart_bcia_fim:private-data   in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000016642":U
           v_cod_refer_ini:private-data       in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022432":U
           v_cod_refer_fim:private-data       in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022435":U
           v_cod_indic_econ_ini:private-data  in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000018872":U
           v_cod_indic_econ_fim:private-data  in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000018873":U
           v_dat_transacao_ini:private-data   in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022343":U
           v_dat_transacao_fim:private-data   in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000022341":U
           bt_ok:private-data                 in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000010721":U
           bt_can:private-data                in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000011050":U
           bt_hel2:private-data               in frame f_ran_01_movto_tit_acr_contr_juros = "HLP=000011326":U
           frame f_ran_01_movto_tit_acr_contr_juros:private-data                          = "HLP=000018127".
    /* enable function buttons */
    assign bt_zoo_197564:sensitive in frame f_ran_01_movto_tit_acr_contr_juros = yes
           bt_zoo_197563:sensitive in frame f_ran_01_movto_tit_acr_contr_juros = yes.
    /* move buttons to top */
    bt_zoo_197564:move-to-top().
    bt_zoo_197563:move-to-top().

def frame f_rpt_41_movto_tit_acr_contr_juros
    rt_008
         at row 05.50 col 02.00
    " Tipo EspÇcie " view-as text
         at row 05.20 col 04.00 bgcolor 8 
    rt_004
         at row 01.50 col 27.14
    " Apresentaá∆o " view-as text
         at row 01.20 col 29.14 bgcolor 8 
    rt_002
         at row 01.50 col 02.00
    " Visualizaá∆o " view-as text
         at row 01.20 col 04.00 bgcolor 8 
    rt_006
         at row 01.50 col 73.29 bgcolor 8 
    rt_009
         at row 09.50 col 27.00
    " Imprimir T°tulos " view-as text
         at row 09.20 col 29.00 bgcolor 8 
    rt_007
         at row 05.50 col 26.86
    " Classificaá∆o " view-as text
         at row 05.20 col 28.86 bgcolor 8 
    rt_target
         at row 13.38 col 02.00
    " Destino " view-as text
         at row 13.08 col 04.00 bgcolor 8 
    rt_run
         at row 13.38 col 48.00
    " Execuá∆o " view-as text
         at row 13.08 col 50.00
    rt_dimensions
         at row 13.38 col 72.72
    " Dimens‰es " view-as text
         at row 13.08 col 74.72
    rt_cxcf
         at row 16.88 col 02.00 bgcolor 7 
    v_ind_visualiz_tit_acr_vert
         at row 02.00 col 03.00 no-label
         help "Visualiza T°tulos por Estabelecimento ou UN"
         view-as radio-set Vertical
         radio-buttons "Por Estabelecimento", "Por Estabelecimento", "Por Unidade Neg¢cio", "Por Unidade Neg¢cio"
          /*l_por_estabelecimento*/ /*l_por_estabelecimento*/ /*l_por_unid_negoc*/ /*l_por_unid_negoc*/
         bgcolor 8 
    v_log_movto_estordo
         at row 04.00 col 03.00 label "Liquidac Estornadas"
         view-as toggle-box
    v_cod_finalid_econ
         at row 02.04 col 45.57 colon-aligned label "Finalidade"
         help "Finalidade Econìmica"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_197554
         at row 02.04 col 58.71
    v_cod_finalid_econ_apres
         at row 03.04 col 45.57 colon-aligned label "Apresentaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_197555
         at row 03.04 col 58.71
    v_dat_cotac_indic_econ
         at row 04.04 col 45.57 colon-aligned label "Data Cotaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ran2
         at row 02.88 col 78.86 font ?
         help "Faixa"
    v_log_impr_normal
         at row 06.00 col 03.00 label "Normal"
         help "Imprime T°tulos Normais"
         view-as toggle-box
    v_log_impr_avdeb
         at row 07.00 col 03.00 label "Aviso de DÇbito"
         help "Imprime T°tulos Aviso DÇbito"
         view-as toggle-box
    v_log_impr_cheq_acr
         at row 08.00 col 03.00 label "Cheque"
         help "Imprime T°tulos Cheques Recebidos"
         view-as toggle-box
    v_log_mostra_docto_vendor
         at row 09.00 col 03.00 label "Vendor"
         help "T°tulos de EspÇcie Vendor"
         view-as toggle-box
    v_log_mostra_docto_vendor_repac
         at row 10.00 col 03.00 label "Vendor Repactuado"
         help "T°tulos com EspÇcie Vendor Repactuado"
         view-as toggle-box
    v_log_tip_espec_docto_terc
         at row 11.00 col 03.00 label "Dup. Terceiros"
         view-as toggle-box
    v_log_tip_espec_docto_cheq_terc
         at row 12.00 col 03.00 label "Cheques Terceiros"
         view-as toggle-box
    rs_controle_juros_classif
         at row 06.75 col 28.00
         help "" no-label
    v_ind_apres_tit_avdeb
         at row 11.00 col 28.14 no-label
         help "Imprimir T°tulos"
         view-as radio-set Horizontal
         radio-buttons "Todos", "Todos", "Geraram AD", "Geraram AD", "N∆o Geraram AD", "N∆o Geraram AD"
          /*l_todos*/ /*l_todos*/ /*l_geraram_ad*/ /*l_geraram_ad*/ /*l_nao_geraram_ad*/ /*l_nao_geraram_ad*/
         bgcolor 8 
    rs_cod_dwb_output
         at row 14.08 col 03.00
         help "" no-label
    ed_1x40
         at row 15.04 col 03.00
         help "" no-label
    bt_get_file
         at row 15.04 col 42.00 font ?
         help "Pesquisa Arquivo"
    bt_set_printer
         at row 15.04 col 42.00 font ?
         help "Define Impressora e Layout de Impress∆o"
    rs_ind_run_mode
         at row 14.08 col 49.00
         help "" no-label
    v_log_print_par
         at row 15.08 col 49.00 label "Imprime ParÉmetros"
         view-as toggle-box
    v_qtd_line
         at row 14.08 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_qtd_column
         at row 15.08 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_close
         at row 17.08 col 03.00 font ?
         help "Fecha"
    bt_print
         at row 17.08 col 14.00 font ?
         help "Imprime"
    bt_can
         at row 17.08 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 17.08 col 77.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 18.71
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relatorio Controle Juros - ESACR066".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 10.00
           bt_can:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 01.00
           bt_close:width-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 10.00
           bt_close:height-chars       in frame f_rpt_41_movto_tit_acr_contr_juros = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_movto_tit_acr_contr_juros = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_movto_tit_acr_contr_juros = 01.08
           bt_hel2:width-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 10.00
           bt_hel2:height-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 01.00
           bt_print:width-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 10.00
           bt_print:height-chars       in frame f_rpt_41_movto_tit_acr_contr_juros = 01.00
           bt_ran2:width-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 04.00
           bt_ran2:height-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 01.13
           bt_set_printer:width-chars  in frame f_rpt_41_movto_tit_acr_contr_juros = 04.00
           bt_set_printer:height-chars in frame f_rpt_41_movto_tit_acr_contr_juros = 01.08
           ed_1x40:width-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 38.00
           ed_1x40:height-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 01.00
           rt_002:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 24.43
           rt_002:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.67
           rt_004:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 45.00
           rt_004:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.67
           rt_006:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 15.14
           rt_006:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.63
           rt_007:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 61.57
           rt_007:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.13
           rt_008:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 24.43
           rt_008:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 07.50
           rt_009:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 61.29
           rt_009:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.38
           rt_cxcf:width-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 86.57
           rt_cxcf:height-chars        in frame f_rpt_41_movto_tit_acr_contr_juros = 01.42
           rt_dimensions:width-chars   in frame f_rpt_41_movto_tit_acr_contr_juros = 15.72
           rt_dimensions:height-chars  in frame f_rpt_41_movto_tit_acr_contr_juros = 03.00
           rt_run:width-chars          in frame f_rpt_41_movto_tit_acr_contr_juros = 23.86
           rt_run:height-chars         in frame f_rpt_41_movto_tit_acr_contr_juros = 03.00
           rt_target:width-chars       in frame f_rpt_41_movto_tit_acr_contr_juros = 45.00
           rt_target:height-chars      in frame f_rpt_41_movto_tit_acr_contr_juros = 03.00.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_rpt_41_movto_tit_acr_contr_juros = yes.
    /* set private-data for the help system */
    assign v_ind_visualiz_tit_acr_vert:private-data     in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023756":U
           v_log_movto_estordo:private-data             in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023879":U
           bt_zoo_197554:private-data                   in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000009431":U
           v_cod_finalid_econ:private-data              in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000014662":U
           bt_zoo_197555:private-data                   in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000009431":U
           v_cod_finalid_econ_apres:private-data        in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000014663":U
           v_dat_cotac_indic_econ:private-data          in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000012264":U
           bt_ran2:private-data                         in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000008773":U
           v_log_impr_normal:private-data               in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023878":U
           v_log_impr_avdeb:private-data                in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023876":U
           v_log_impr_cheq_acr:private-data             in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023877":U
           v_log_mostra_docto_vendor:private-data       in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           v_log_mostra_docto_vendor_repac:private-data in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           v_log_tip_espec_docto_terc:private-data      in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           v_log_tip_espec_docto_cheq_terc:private-data in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           rs_controle_juros_classif:private-data       in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           v_ind_apres_tit_avdeb:private-data           in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000023875":U
           rs_cod_dwb_output:private-data               in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           ed_1x40:private-data                         in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           bt_get_file:private-data                     in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000008782":U
           bt_set_printer:private-data                  in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000008785":U
           rs_ind_run_mode:private-data                 in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000018127":U
           v_log_print_par:private-data                 in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000024662":U
           v_qtd_line:private-data                      in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000024737":U
           v_qtd_column:private-data                    in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000024669":U
           bt_close:private-data                        in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000009420":U
           bt_print:private-data                        in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000010815":U
           bt_can:private-data                          in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000011050":U
           bt_hel2:private-data                         in frame f_rpt_41_movto_tit_acr_contr_juros = "HLP=000011326":U
           frame f_rpt_41_movto_tit_acr_contr_juros:private-data                                    = "HLP=000018127".
    /* enable function buttons */
    assign bt_zoo_197554:sensitive in frame f_rpt_41_movto_tit_acr_contr_juros = yes
           bt_zoo_197555:sensitive in frame f_rpt_41_movto_tit_acr_contr_juros = yes.
    /* move buttons to top */
    bt_zoo_197554:move-to-top().
    bt_zoo_197555:move-to-top().



{include/i_fclfrm.i f_ran_01_movto_tit_acr_contr_juros f_rpt_41_movto_tit_acr_contr_juros }
/*************************** Frame Definition End ***************************/

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
def var v_prog_filtro_pdf as handle no-undo.

function getCodTipoRelat returns character in v_prog_filtro_pdf.

run prgtec/btb/btb920aa.py persistent set v_prog_filtro_pdf.

run pi_define_objetos in v_prog_filtro_pdf (frame f_rpt_41_movto_tit_acr_contr_juros:handle,
                       rs_cod_dwb_output:handle in frame f_rpt_41_movto_tit_acr_contr_juros,
                       bt_get_file:row in frame f_rpt_41_movto_tit_acr_contr_juros,
                       bt_get_file:col in frame f_rpt_41_movto_tit_acr_contr_juros).

&endif
/* tech38629 - Fim da alteraá∆o */


/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_movto_tit_acr_contr_juros
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_todos_img IN FRAME f_ran_01_movto_tit_acr_contr_juros
DO:

    assign input frame f_ran_01_movto_tit_acr_contr_juros v_des_estab_select.
    if  search('prgint/utb/utb071za.r') = ? and search('prgint/utb/utb071za.p') = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return 'Programa execut†vel n∆o foi encontrado:' /* l_programa_nao_encontrado*/  + 'prgint/utb/utb071za.p'.
        else do:
            message 'Programa execut†vel n∆o foi encontrado:' /* l_programa_nao_encontrado*/  'prgint/utb/utb071za.p'
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb071za.p (Input "ACR" /*l_acr*/ ) /* prg_fnc_estabelecimento_selec_espec*/.

    display v_des_estab_select with frame f_ran_01_movto_tit_acr_contr_juros.
END. /* ON CHOOSE OF bt_todos_img IN FRAME f_ran_01_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign dwb_rpt_param.cod_dwb_file             = v_cod_dwb_file
               ed_1x40:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_hel2 IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_print IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    print_block:
    do on error undo print_block, return no-apply:
        if  v_log_ok = no
        then do:
            /* A classificaá∆o do relat¢rio dever† ser atualizada. */
            run pi_messages (input "show",
                             input 2717,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2717*/.
            undo print_block, return no-apply.
        end /* if */.

        run pi_vld_valores_apres_apb_acr (Input input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ,
                                          Input input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ_apres,
                                          Input input frame f_rpt_41_movto_tit_acr_contr_juros v_dat_cotac_indic_econ,
                                          output v_dat_conver,
                                          output v_val_cotac_indic_econ) /*pi_vld_valores_apres_apb_acr*/.

        assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_normal
               input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_cheq_acr
               input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_avdeb.

        if  v_log_control_terc_acr then
            assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_terc
                   input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_cheq_terc.

        /* ==> MODULO VENDOR <== */
        if  v_log_modul_vendor then
            assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor
                   input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor_repac.



        if  v_log_impr_normal   = no
        and  v_log_impr_cheq_acr = no
        and  v_log_impr_avdeb    = no
        and  v_log_tip_espec_docto_terc = no /* controle terceiros */
        and  v_log_tip_espec_docto_cheq_terc = no /* controle terceiros */ 
        and  v_log_mostra_docto_vendor       = no
        and  v_log_mostra_docto_vendor_repac = no
        then do: 
            /* Tipo EspÇcie deve ser informado. */
            run pi_messages (input "show",
                             input 4320,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_4320*/.
            return no-apply. 
        end.


do:
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
    run pi_restricoes in v_prog_filtro_pdf (input rs_cod_dwb_output:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros).
    if return-value = 'nok' then 
        return no-apply.
&endif
/* tech38629 - Fim da alteraá∆o */
        assign v_log_print = yes.
end.
    end /* do print_block */.
END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_ran2 IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    view frame f_ran_01_movto_tit_acr_contr_juros.

    main_block:
    do on endkey undo main_block, leave main_block on error undo main_block, retry main_block:

        if  not retry then do:
            display bt_can
                    bt_hel2
                    bt_ok
                    bt_todos_img
                    v_cdn_cliente_fim
                    v_cdn_cliente_ini
                    v_cdn_repres_fim
                    v_cdn_repres_ini
                    v_cod_cart_bcia_fim
                    v_cod_cart_bcia_ini
                    v_cod_espec_docto_fim
                    v_cod_espec_docto_ini
                    v_cod_indic_econ_fim
                    v_cod_indic_econ_ini
                    v_cod_portador_fim
                    v_cod_portador_ini
                    v_cod_refer_fim
                    v_cod_refer_ini
                    v_cod_unid_negoc_fim
                    v_cod_unid_negoc_ini
                    v_dat_transacao_fim
                    v_dat_transacao_ini
                    v-cod-gr-cob-ini
                    v-cod-gr-cob-fim
                    v_des_estab_select
                    with frame f_ran_01_movto_tit_acr_contr_juros.
            enable all with frame f_ran_01_movto_tit_acr_contr_juros.
            disable v_des_estab_select
                    with frame f_ran_01_movto_tit_acr_contr_juros.
        end.

        if  valid-handle( v_wgh_focus ) then do:
            wait-for go of frame f_ran_01_movto_tit_acr_contr_juros focus v_wgh_focus.
        end.
        else do:
            wait-for go of frame f_ran_01_movto_tit_acr_contr_juros.
        end.

        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_fim then do:
            assign v_wgh_focus = v_cod_unid_negoc_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Unid Neg¢cio")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_fim          then do:
            assign v_wgh_focus = v_cod_espec_docto_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "EspÇcie")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_fim              then do:
            assign v_wgh_focus = v_cdn_cliente_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Cliente")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_fim             then do:
            assign v_wgh_focus = v_cod_portador_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Portador")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_fim            then do:
            assign v_wgh_focus = v_cod_cart_bcia_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Carteira")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_fim               then do:
            assign v_wgh_focus = v_cdn_repres_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Representante")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_fim       then do:
            assign v_wgh_focus = v_dat_transacao_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Data Transaá∆o")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-ini > input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-fim       then do:
            assign v_wgh_focus = v-cod-gr-cob-ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Grupo Cobranáa")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_fim then do:
            assign v_wgh_focus = v_cod_indic_econ_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Moeda")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.
        if  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_ini > input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_fim then do:
            assign v_wgh_focus = v_cod_refer_ini:handle in frame f_ran_01_movto_tit_acr_contr_juros.
            /* &1 Inicial deve ser menor ou igual a &1 Final ! */
            run pi_messages (input "show",
                             input 5123,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Referància")) /*msg_5123*/.
            undo main_block, retry main_block.
        end.

        if input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_fim                 <> v_cdn_cliente_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_ini              <> v_cdn_cliente_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_fim               <> v_cdn_repres_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_ini               <> v_cdn_repres_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_fim            <> v_cod_cart_bcia_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_ini            <> v_cod_cart_bcia_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_fim          <> v_cod_espec_docto_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_ini          <> v_cod_espec_docto_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_des_estab_select             <> v_des_estab_select
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_fim             <> v_cod_portador_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_ini             <> v_cod_portador_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_fim           <> v_cod_unid_negoc_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_ini           <> v_cod_unid_negoc_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_ini            <> v_dat_transacao_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_fim            <> v_dat_transacao_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_ini           <> v_cod_indic_econ_ini
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_fim           <> v_cod_indic_econ_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_fim                <> v_cod_refer_fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_ini                <> v_cod_refer_ini 
        or input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-fim               <> v-cod-gr-cob-fim
        or input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-ini               <> v-cod-gr-cob-ini 
        then do:
           assign input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_cliente_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cdn_repres_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_cart_bcia_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_espec_docto_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_indic_econ_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_portador_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_refer_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_cod_unid_negoc_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v_dat_transacao_ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-fim
                  input frame f_ran_01_movto_tit_acr_contr_juros v-cod-gr-cob-ini
                  input frame f_ran_01_movto_tit_acr_contr_juros v_des_estab_select.
        end.

    end /* do main_block */.

    hide frame f_ran_01_movto_tit_acr_contr_juros.




    /* view frame f_ran_01_movto_tit_acr_contr_juros.

    @do(range_block) @on_error(range_block, retry, range_block)
                    @on_endkey(range_block, leave, range_block):
        @if(not retry)
            @display(f_ran_01_movto_tit_acr_contr_juros).
            @enable(f_ran_01_movto_tit_acr_contr_juros).

            @if(v_ind_visualiz_tit_acr_vert = @%(l_por_estabelecimento))
                @disable(f_ran_01_movto_tit_acr_contr_juros, v_cod_unid_negoc_ini, v_cod_unid_negoc_fim).
            @end_if().
        @end_if().

        wait-for go of frame f_ran_01_movto_tit_acr_contr_juros.

        @cx_assign(f_ran_01_movto_tit_acr_contr_juros, v_des_estab_select,
                                                      v_cod_unid_negoc_fim, v_cod_unid_negoc_ini,
                                                      v_cod_espec_docto_fim, v_cod_espec_docto_ini,
                                                      v_cdn_cliente_ini, v_cdn_cliente_fim,
                                                      v_cdn_repres_ini, v_cdn_repres_fim,
                                                      v_cod_portador_ini, v_cod_portador_fim,
                                                      v_cod_cart_bcia_ini, v_cod_cart_bcia_fim,
                                                      v_cod_refer_ini, v_cod_refer_fim,
                                                      v_cod_indic_econ_fim, v_cod_indic_econ_ini,
                                                      v_dat_transacao_ini, v_dat_transacao_fim).
    @end_do(range_block).

    hide frame f_ran_01_movto_tit_acr_contr_juros no-pause.

    */
END. /* ON CHOOSE OF bt_ran2 IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign v_nom_dwb_printer      = ""
           v_cod_dwb_print_layout = "".

    &if '{&emsbas_version}' <= '1.00' &then
    if  search("prgtec/btb/btb036nb.r") = ? and search("prgtec/btb/btb036nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb036nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036nb.p (output v_nom_dwb_printer,
                               output v_cod_dwb_print_layout) /*prg_see_layout_impres_imprsor*/.
    &else
    if  search("prgtec/btb/btb036zb.r") = ? and search("prgtec/btb/btb036zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036zb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb036zb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036zb.p (input-output v_nom_dwb_printer,
                               input-output v_cod_dwb_print_layout,
                               input-output v_nom_dwb_print_file) /*prg_fnc_layout_impres_imprsor*/.
    &endif

    if  v_nom_dwb_printer <> ""
    and  v_cod_dwb_print_layout <> ""
    then do:
        assign dwb_rpt_param.nom_dwb_printer      = v_nom_dwb_printer
               dwb_rpt_param.cod_dwb_print_layout = v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then           
    &if '{&emsbas_version}' >= '5.03' &then           
               dwb_rpt_param.nom_dwb_print_file        = v_nom_dwb_print_file
    &else
               dwb_rpt_param.cod_livre_1               = v_nom_dwb_print_file
    &endif
    &endif
               ed_1x40:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros = v_nom_dwb_printer
                                                       + ":"
                                                       + v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then
                                                       + (if v_nom_dwb_print_file <> "" then ":" + v_nom_dwb_print_file
                                                          else "")
    &endif
    .
        find layout_impres no-lock
             where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
               and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
        assign v_qtd_line               = layout_impres.num_lin_pag.
        display v_qtd_line
                with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.

END. /* ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_movto_tit_acr_contr_juros:
        if  rs_cod_dwb_output:screen-value = "Arquivo" /*l_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
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
            end /* if */.

            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            assign dwb_rpt_param.cod_dwb_file = ed_1x40:screen-value.
        end /* if */.
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    initout:
    do with frame f_rpt_41_movto_tit_acr_contr_juros:
        /* block: */
        case self:screen-value:
            when "Terminal" /*l_terminal*/ then ter:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_movto_tit_acr_contr_juros v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame f_rpt_41_movto_tit_acr_contr_juros.
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = no
                       bt_get_file:visible    = no
                       bt_set_printer:visible = no.
            end /* do ter */.
            when "Arquivo" /*l_file*/ then fil:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_movto_tit_acr_contr_juros v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame f_rpt_41_movto_tit_acr_contr_juros.
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = yes
                       bt_set_printer:visible = no
                       bt_get_file:visible    = yes.

                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index srmstr_id
    &endif
                      /*cl_current_user of usuar_mestre*/ no-error.
                do  transaction:                
                    find dwb_rpt_param
                        where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                        and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                        exclusive-lock no-error.

                    assign dwb_rpt_param.cod_dwb_file = "".

                    if  rs_ind_run_mode:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros <> "Batch" /*l_batch*/ 
                    then do:
                        if  usuar_mestre.nom_dir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = usuar_mestre.nom_dir_spool
                                                              + "~/".
                        end /* if */.
                        if  usuar_mestre.nom_subdir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                              + usuar_mestre.nom_subdir_spool
                                                              + "~/".
                        end /* if */.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file.
                    end /* else */.
                    if  v_cod_dwb_file_temp = ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + caps("esacr066":U)
                                                          + '.csv'.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + v_cod_dwb_file_temp.
                    end /* else */.
                    assign ed_1x40:screen-value               = dwb_rpt_param.cod_dwb_file
                           dwb_rpt_param.cod_dwb_print_layout = ""
                           v_qtd_line                         = (if v_qtd_line_ant > 0 then v_qtd_line_ant
                                                                 else v_rpt_s_1_lines)
    &if '{&emsbas_version}' > '1.00' &then
                           v_nom_dwb_print_file               = ""
    &endif
    .
                end.     
            end /* do fil */.
            when "Impressora" /*l_printer*/ then prn:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/  /* and rs_ind_run_mode <> "Batch" /*l_batch*/  */
                then do: 
                    assign v_qtd_line_ant = input frame f_rpt_41_movto_tit_acr_contr_juros v_qtd_line.
                end /* if */.

                assign ed_1x40:sensitive        = no
                       bt_get_file:visible      = no
                       bt_set_printer:visible   = yes
                       bt_set_printer:sensitive = yes.

                /* define layout default */
                if  dwb_rpt_param.nom_dwb_printer = ""
                or  dwb_rpt_param.cod_dwb_print_layout = ""
                then do:
                    run pi_set_print_layout_default /*pi_set_print_layout_default*/.
                end /* if */.
                else do:
                    assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                                + ":"
                                                + dwb_rpt_param.cod_dwb_print_layout.
                end /* else */.
                find layout_impres no-lock
                     where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                       and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                if  avail layout_impres
                then do:
                    assign v_qtd_line               = layout_impres.num_lin_pag.
                end /* if */.
                display v_qtd_line
                        with frame f_rpt_41_movto_tit_acr_contr_juros.
            end /* do prn */.
        end /* case block */.

        assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
        if  index(v_cod_dwb_file_temp, "~/") <> 0
        then do:
            assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
        end /* if */.
        else do:
            assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
        end /* else */.
    end /* do initout */.

    if  self:screen-value = "Impressora" /*l_printer*/ 
    then do:
        disable v_qtd_line
                with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.
    else do:
        enable v_qtd_line
               with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* else */.
    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF rs_controle_juros_classif IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign v_ind_classif = input frame f_rpt_41_movto_tit_acr_contr_juros rs_controle_juros_classif.
    assign input frame f_rpt_41_movto_tit_acr_contr_juros rs_controle_juros_classif.
END. /* ON VALUE-CHANGED OF rs_controle_juros_classif IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    do  transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.ind_dwb_run_mode = input frame f_rpt_41_movto_tit_acr_contr_juros rs_ind_run_mode.

        if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            if  rs_cod_dwb_output:disable("Terminal" /*l_terminal*/ ) in frame f_rpt_41_movto_tit_acr_contr_juros
            then do:
            end /* if */.
        end /* if */.
        else do:
            if  rs_cod_dwb_output:enable("Terminal" /*l_terminal*/ ) in frame f_rpt_41_movto_tit_acr_contr_juros
            then do:
            end /* if */.
        end /* else */.
        if  rs_ind_run_mode = "Batch" /*l_batch*/ 
        then do:
           assign v_qtd_line = v_qtd_line_ant.
           display v_qtd_line
                   with frame f_rpt_41_movto_tit_acr_contr_juros.
        end /* if */.
        assign rs_ind_run_mode.
        apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_movto_tit_acr_contr_juros.
    end.    

END. /* ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON LEAVE OF v_cod_finalid_econ IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    if  v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros = " "
    then do:
        assign v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros = input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ.
    end /* if */.

    apply "leave" to v_cod_finalid_econ_apres in frame f_rpt_41_movto_tit_acr_contr_juros.
END. /* ON LEAVE OF v_cod_finalid_econ IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON LEAVE OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    if  input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ_apres = input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ
    then do:
        disable v_dat_cotac_indic_econ
                with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.
    else do:
        enable v_dat_cotac_indic_econ
               with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* else */.
END. /* ON LEAVE OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_ind_apres_tit_avdeb IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_ind_apres_tit_avdeb.
END. /* ON VALUE-CHANGED OF v_ind_apres_tit_avdeb IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON LEAVE OF v_ind_visualiz_tit_acr_vert IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_ind_visualiz_tit_acr_vert.

    assign v_cod_unid_negoc_ini = "" /*l_null*/ 
           v_cod_unid_negoc_fim = "ZZZ" /*l_zzz*/ .
END. /* ON LEAVE OF v_ind_visualiz_tit_acr_vert IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_impr_avdeb IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_avdeb.

END. /* ON VALUE-CHANGED OF v_log_impr_avdeb IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_impr_cheq_acr IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_cheq_acr.
END. /* ON VALUE-CHANGED OF v_log_impr_cheq_acr IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_impr_normal IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_normal.
END. /* ON VALUE-CHANGED OF v_log_impr_normal IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_mostra_docto_vendor IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor.
END. /* ON VALUE-CHANGED OF v_log_mostra_docto_vendor IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_mostra_docto_vendor_repac IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor_repac.
END. /* ON VALUE-CHANGED OF v_log_mostra_docto_vendor_repac IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_movto_estordo IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_movto_estordo.
END. /* ON VALUE-CHANGED OF v_log_movto_estordo IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_tip_espec_docto_cheq_terc IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_cheq_terc.
END. /* ON VALUE-CHANGED OF v_log_tip_espec_docto_cheq_terc IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON VALUE-CHANGED OF v_log_tip_espec_docto_terc IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_terc.
END. /* ON VALUE-CHANGED OF v_log_tip_espec_docto_terc IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON CHOOSE OF v_qtd_line IN FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:


END. /* ON CHOOSE OF v_qtd_line IN FRAME f_rpt_41_movto_tit_acr_contr_juros */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_197554 IN FRAME f_rpt_41_movto_tit_acr_contr_juros
OR F5 OF v_cod_finalid_econ IN FRAME f_rpt_41_movto_tit_acr_contr_juros DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb077nb.r") = ? and search("prgint/utb/utb077nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb077nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb077nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb077nb.p (Input v_cod_empres_usuar,
                               Input yes,
                               Input yes,
                               Input yes,
                               Input yes,
                               Input yes) /*prg_see_finalid_econ_unid_organ*/.
    if  v_rec_finalid_econ <> ?
    then do:
        find finalid_econ where recid(finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign v_cod_finalid_econ:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros =
               string(finalid_econ.cod_finalid_econ).

        apply "entry" to v_cod_finalid_econ in frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_197554 IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON  CHOOSE OF bt_zoo_197555 IN FRAME f_rpt_41_movto_tit_acr_contr_juros
OR F5 OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_movto_tit_acr_contr_juros DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb077ka.r") = ? and search("prgint/utb/utb077ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb077ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb077ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb077ka.p /*prg_sea_finalid_econ*/.
    if  v_rec_finalid_econ <> ?
    then do:
        find finalid_econ where recid(finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros =
               string(finalid_econ.cod_finalid_econ).

        apply "entry" to v_cod_finalid_econ_apres in frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_197555 IN FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON  CHOOSE OF bt_zoo_197563 IN FRAME f_ran_01_movto_tit_acr_contr_juros
OR F5 OF v_cdn_cliente_fim IN FRAME f_ran_01_movto_tit_acr_contr_juros DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/ufn/ufn011ka.r") = ? and search("prgint/ufn/ufn011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn011ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/ufn/ufn011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/ufn/ufn011ka.p /*prg_sea_clien_financ*/.
    if  v_rec_clien_financ <> ?
    then do:
        find clien_financ where recid(clien_financ) = v_rec_clien_financ no-lock no-error.
        assign v_cdn_cliente_fim:screen-value in frame f_ran_01_movto_tit_acr_contr_juros =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_fim in frame f_ran_01_movto_tit_acr_contr_juros.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_197563 IN FRAME f_ran_01_movto_tit_acr_contr_juros */

ON  CHOOSE OF bt_zoo_197564 IN FRAME f_ran_01_movto_tit_acr_contr_juros
OR F5 OF v_cdn_cliente_ini IN FRAME f_ran_01_movto_tit_acr_contr_juros DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/ufn/ufn011ka.r") = ? and search("prgint/ufn/ufn011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn011ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/ufn/ufn011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/ufn/ufn011ka.p /*prg_sea_clien_financ*/.
    if  v_rec_clien_financ <> ?
    then do:
        find clien_financ where recid(clien_financ) = v_rec_clien_financ no-lock no-error.
        assign v_cdn_cliente_ini:screen-value in frame f_ran_01_movto_tit_acr_contr_juros =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_ini in frame f_ran_01_movto_tit_acr_contr_juros.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_197564 IN FRAME f_ran_01_movto_tit_acr_contr_juros */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_ran_01_movto_tit_acr_contr_juros ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_ran_01_movto_tit_acr_contr_juros */

ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_movto_tit_acr_contr_juros ANYWHERE
DO:

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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_movto_tit_acr_contr_juros */

ON RIGHT-MOUSE-UP OF FRAME f_ran_01_movto_tit_acr_contr_juros ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_ran_01_movto_tit_acr_contr_juros */

ON WINDOW-CLOSE OF FRAME f_ran_01_movto_tit_acr_contr_juros
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_ran_01_movto_tit_acr_contr_juros */

ON ENTRY OF FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    if v_cod_finalid_econ = "" then do:
        run pi_retornar_finalid_econ_corren_estab (Input v_cod_estab_usuar,
                                                   output v_cod_finalid_econ) /*pi_retornar_finalid_econ_corren_estab*/.                                       
        disp v_cod_finalid_econ 
             v_cod_finalid_econ_apres
             with frame f_rpt_41_movto_tit_acr_contr_juros.
    end.
    if v_cod_finalid_econ_apres = "" then do:
        assign v_cod_finalid_econ_apres = v_cod_finalid_econ.
        disp v_cod_finalid_econ 
             v_cod_finalid_econ_apres
             with frame f_rpt_41_movto_tit_acr_contr_juros.
    end.

END. /* ON ENTRY OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON GO OF FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    assign dwb_rpt_param.cod_dwb_output   = rs_cod_dwb_output:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros.
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
        run pi_filename_validation (Input dwb_rpt_param.cod_dwb_file) /*pi_filename_validation*/.
        if  return-value = "NOK" /*l_nok*/ 
        then do:
            /* Nome do arquivo incorreto ! */
            run pi_messages (input "show",
                             input 1064,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
            return no-apply.
        end /* if */.
    end /* if */.
    else do:
        if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
        then do:
            if  dwb_rpt_param.nom_dwb_printer = ""
            or   dwb_rpt_param.cod_dwb_print_layout = ""
            then do:
                /* Impressora destino e layout de impress∆o n∆o definidos ! */
                run pi_messages (input "show",
                                 input 2052,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2052*/.
                return no-apply.
            end /* if */.
        end /* if */.
    end /* else */.

    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ
           input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ_apres
           input frame f_rpt_41_movto_tit_acr_contr_juros v_dat_cotac_indic_econ
           input frame f_rpt_41_movto_tit_acr_contr_juros v_ind_visualiz_tit_acr_vert
           input frame f_rpt_41_movto_tit_acr_contr_juros v_log_movto_estordo.

END. /* ON GO OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON ENDKEY OF FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_upc) (input 'CANCEL',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_appc) (input 'CANCEL',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_dpc) (input 'CANCEL',
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

END. /* ON ENDKEY OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON HELP OF FRAME f_rpt_41_movto_tit_acr_contr_juros ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_movto_tit_acr_contr_juros ANYWHERE
DO:

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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_movto_tit_acr_contr_juros ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_movto_tit_acr_contr_juros */

ON WINDOW-CLOSE OF FRAME f_rpt_41_movto_tit_acr_contr_juros
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_movto_tit_acr_contr_juros */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_rpt_41_movto_tit_acr_contr_juros.





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


        assign v_nom_prog     = substring(frame f_rpt_41_movto_tit_acr_contr_juros:title, 1, max(1, length(frame f_rpt_41_movto_tit_acr_contr_juros:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "esacr066":U.




    assign v_nom_prog_ext = "esp/acr/esacr066.p":U
           v_cod_release  = trim(" 1.00.00.000":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/

run pi_return_user (output v_cod_dwb_user) /*pi_return_user*/.

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.
if (v_cod_dwb_user = "") then
   assign v_cod_dwb_user = v_cod_usuar_corren.


/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'esacr066') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esacr066')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esacr066')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'esacr066' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'esacr066'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_permissoes in v_prog_filtro_pdf (input 'esacr066':U).
&endif
/* tech38629 - Fim da alteraá∆o */




/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "esacr066":U
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


assign v_wgh_frame_epc = frame f_rpt_41_movto_tit_acr_contr_juros:handle.



assign v_nom_table_epc = 'movto_tit_acr':U
       v_rec_table_epc = recid(movto_tit_acr).

&endif

/* End_Include: i_verify_program_epc */


/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_movto_tit_acr_contr_juros:title = frame f_rpt_41_movto_tit_acr_contr_juros:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_rpt_41_movto_tit_acr_contr_juros = menu m_help:handle.


/* End_Include: i_std_dialog_box */
{include/title5.i f_rpt_41_movto_tit_acr_contr_juros FRAME}


/* inicializa vari†veis */
find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.
find dwb_rpt_param
     where dwb_rpt_param.cod_dwb_program = "esacr066":U
       and dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user
       no-lock no-error.
if  avail dwb_rpt_param then do:
&if '{&emsbas_version}' > '1.00' &then
&if '{&emsbas_version}' >= '5.03' &then
    assign v_nom_dwb_print_file = dwb_rpt_param.nom_dwb_print_file.
&else
    assign v_nom_dwb_print_file = dwb_rpt_param.cod_livre_1.
&endif
&endif
    if  dwb_rpt_param.qtd_dwb_line <> 0 then
        assign v_qtd_line = dwb_rpt_param.qtd_dwb_line.
    else
        assign v_qtd_line = v_rpt_s_1_lines.
end.
assign v_cod_dwb_proced   = "esacr066":U
       v_cod_dwb_program  = "esacr066":U
       v_cod_release      = trim(" 1.00.00.000":U)
       v_ind_dwb_run_mode = "On-Line" /*l_online*/ 
       v_qtd_column       = v_rpt_s_1_columns
       v_qtd_bottom       = v_rpt_s_1_bottom.
if (avail empresa) then
    assign v_nom_enterprise   = empresa.nom_razao_social.
else
    assign v_nom_enterprise   = 'DATASUL'.


/* Begin_Include: ix_p00_rpt_movto_tit_acr_contr_juros */
/* Funá∆o para Controle Terceiros */

/* Begin_Include: i_verifica_controle_terceiros_acr */
assign v_log_control_terc_acr = no.
find emscad.histor_exec_especial no-lock
     where emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
     and   emscad.histor_exec_especial.cod_prog_dtsul  = 'SPP_CONTROLE_TERCEIROS_ACR':u
     no-error.
if avail emscad.histor_exec_especial then
   assign v_log_control_terc_acr = yes.


if v_log_control_terc_acr = no then
    assign v_log_tip_espec_docto_terc      = no
           v_log_tip_espec_docto_cheq_terc = no.

/* ==> MODULO VENDOR <== */
run pi_verifica_vendor /*pi_verifica_vendor*/.
assign v_log_mostra_docto_vendor       = no
       v_log_mostra_docto_vendor_repac = no.
/* End_Include: i_funcao_extract */


if  v_cod_dwb_user begins 'es_'
then do:
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if (not avail dwb_rpt_param) then
        return "ParÉmetros para o relat¢rio n∆o encontrado." /*1993*/ + " (" + "1993" + ")" + chr(10) + "N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio corrente." /*1993*/.
    if index( dwb_rpt_param.cod_dwb_file ,'~\') <> 0 then
        assign file-info:file-name = replace(dwb_rpt_param.cod_dwb_file, '~\', '~/').
    else
        assign file-info:file-name = dwb_rpt_param.cod_dwb_file.

    assign file-info:file-name = substring(file-info:file-name, 1,
                                           r-index(file-info:file-name, '~/') - 1).
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
       if file-info:file-type = ? then
          return "Diret¢rio Inexistente:" /*l_directory*/  + dwb_rpt_param.cod_dwb_file.
    end /* if */.

    find ped_exec no-lock
         where ped_exec.num_ped_exec = v_num_ped_exec_corren /*cl_le_ped_exec_global of ped_exec*/ no-error.
    if (ped_exec.cod_release_prog_dtsul <> trim(" 1.00.00.000":U)) then
        return "Vers‰es do programa diferente." /*1994*/ + " (" + "1994" + ")" + chr(10)
                                     + substitute("A vers∆o do programa (&3) que gerou o pedido de execuá∆o batch (&1) Ç diferente da vers∆o do programa que deveria executar o pedido batch (&2)." /*1994*/,ped_exec.cod_release_prog_dtsul,
                                                  trim(" 1.00.00.000":U),
                                                  "esp/acr/esacr066.p":U).
    assign v_nom_prog_ext     = caps("esacr066":U)
           v_dat_execution    = today
           v_hra_execution    = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           v_cod_dwb_file     = dwb_rpt_param.cod_dwb_file
           v_nom_report_title = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_ind_dwb_run_mode = "Batch" /*l_batch*/ .


    /* Begin_Include: ix_p02_rpt_movto_tit_acr_contr_juros */
    assign v_ind_visualiz_tit_acr_vert = entry(1,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_log_movto_estordo         = (entry(2,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
           v_cod_finalid_econ          = entry(3,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_finalid_econ_apres    = entry(4,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_dat_cotac_indic_econ      = date(entry(5,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           rs_controle_juros_classif   = entry(6,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_unid_negoc_ini        = entry(9,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_unid_negoc_fim        = entry(10,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_espec_docto_ini       = entry(11,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_espec_docto_fim       = entry(12,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cdn_cliente_ini           = integer(entry(13,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cdn_cliente_fim           = integer(entry(14,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cdn_repres_ini            = integer(entry(15,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cdn_repres_fim            = integer(entry(16,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cod_portador_ini          = entry(17,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_portador_fim          = entry(18,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_cart_bcia_ini         = entry(19,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_cart_bcia_fim         = entry(20,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_refer_ini             = entry(21,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_refer_fim             = entry(22,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_indic_econ_ini        = entry(23,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_indic_econ_fim        = entry(24,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_dat_transacao_ini         = date(entry(25,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_dat_transacao_fim         = date(entry(26,dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_ind_classif               = entry(27,dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_log_impr_normal           = (entry(28,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
           v_log_impr_avdeb            = (entry(29,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
           v_log_impr_cheq_acr         = (entry(30,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
           v_ind_apres_tit_avdeb       = entry(31,dwb_rpt_param.cod_dwb_parameters, chr(10)).

    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 32 
    and v_log_control_terc_acr then
        assign v_log_tip_espec_docto_terc      = (entry(32,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_tip_espec_docto_cheq_terc = (entry(33,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ) no-error.

    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 34
    and v_log_modul_vendor then     
        assign v_log_mostra_docto_vendor       = (entry(34,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_mostra_docto_vendor_repac = (entry(35,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ) no-error.

    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 36 then do:
        assign v_des_estab_select = entry(36,dwb_rpt_param.cod_dwb_parameters, chr(10)).
    end.

    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 37 then do:
        assign v-cod-gr-cob-ini = int(entry(37,dwb_rpt_param.cod_dwb_parameters, chr(10))).
    end.

    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 38 then do:
        assign v-cod-gr-cob-fim = int(entry(38,dwb_rpt_param.cod_dwb_parameters, chr(10))).
    end.

    run pi_vld_valores_apres_apb_acr (Input v_cod_finalid_econ,
                                      Input v_cod_finalid_econ_apres,
                                      Input v_dat_cotac_indic_econ,
                                      output v_dat_conver,
                                      output v_val_cotac_indic_econ).
    /* End_Include: ix_p02_rpt_movto_tit_acr_contr_juros */


    /* configura e define destino de impress∆o */
    if (dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ ) then
        assign v_qtd_line_ant = v_qtd_line.

    run pi_output_reports /*pi_output_reports*/.

    if  dwb_rpt_param.log_dwb_print_parameters = yes
    then do:

        /* ix_p29_rpt_movto_tit_acr_contr_juros */


        /* End_Include: ix_p30_rpt_movto_tit_acr_contr_juros */


    end /* if */.

    output stream s_1 close.

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input yes,
                                                 input dwb_rpt_param.cod_dwb_output,
                                                 input dwb_rpt_param.nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U &then
    if ((dwb_rpt_param.cod_dwb_output = 'Impressora':U or dwb_rpt_param.cod_dwb_output = 'Impresora':U or dwb_rpt_param.cod_dwb_output = 'printer':U) and getCodTipoRelat() = 'PDF':U) then do:
        if dwb_rpt_param.nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input yes).
    end.
&endif
    return "OK" /*l_ok*/ .

end /* if */.

pause 0 before-hide.
view frame f_rpt_41_movto_tit_acr_contr_juros.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(movto_tit_acr).    
    run value(v_nom_prog_upc) (input 'INITIALIZE',
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
    assign v_rec_table_epc = recid(movto_tit_acr).    
    run value(v_nom_prog_appc) (input 'INITIALIZE',
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
    assign v_rec_table_epc = recid(movto_tit_acr).    
    run value(v_nom_prog_dpc) (input 'INITIALIZE',
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


super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    param_block:
    do transaction:

        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
        if  not available dwb_rpt_param
        then do:
            create dwb_rpt_param.
            assign dwb_rpt_param.cod_dwb_program         = v_cod_dwb_program
                   dwb_rpt_param.cod_dwb_user            = v_cod_dwb_user
                   dwb_rpt_param.cod_dwb_parameters      = v_cod_dwb_parameters
                   dwb_rpt_param.cod_dwb_output          = "Terminal" /*l_terminal*/ 
                   dwb_rpt_param.ind_dwb_run_mode        = "On-Line" /*l_online*/ 
                   dwb_rpt_param.cod_dwb_file            = ""
                   dwb_rpt_param.nom_dwb_printer         = ""
                   dwb_rpt_param.cod_dwb_print_layout    = ""
                   v_cod_dwb_file_temp                   = "".
        end /* if */.
        assign v_qtd_line = (if dwb_rpt_param.qtd_dwb_line <> 0 then dwb_rpt_param.qtd_dwb_line else v_rpt_s_1_lines).
    end /* do param_block */.

    init:
    do with frame f_rpt_41_movto_tit_acr_contr_juros:
        assign rs_cod_dwb_output:screen-value   = dwb_rpt_param.cod_dwb_output
               rs_ind_run_mode:screen-value     = dwb_rpt_param.ind_dwb_run_mode.

        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
            assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
            if (index(v_cod_dwb_file_temp, "~/") <> 0) then
                assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
            else
                assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
            assign ed_1x40:screen-value = v_cod_dwb_file_temp.
        end /* if */.

        if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
        then do:
            if (not can-find(imprsor_usuar
                            where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                              and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                            use-index imprsrsr_id
&endif
                             /*cl_get_printer of imprsor_usuar*/)
            or   not can-find(layout_impres
                             where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                               and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/)) then
                run pi_set_print_layout_default /*pi_set_print_layout_default*/.
            assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                        + ":"
                                        + dwb_rpt_param.cod_dwb_print_layout.
        end /* if */.
        assign v_log_print_par = dwb_rpt_param.log_dwb_print_parameters.
        display v_log_print_par
                with frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* do init */.

    display v_qtd_column
            v_qtd_line
            with frame f_rpt_41_movto_tit_acr_contr_juros.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_upc) (input 'DISPLAY',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_appc) (input 'DISPLAY',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_dpc) (input 'DISPLAY',
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


    enable rs_cod_dwb_output
           v_log_print_par
           bt_get_file
           bt_set_printer
           bt_close
           bt_print
           bt_can
           bt_hel2
           v_ind_visualiz_tit_acr_vert
           v_log_movto_estordo
           v_cod_finalid_econ
           v_cod_finalid_econ_apres
           v_dat_cotac_indic_econ
           rs_controle_juros_classif
           bt_ran2
           v_log_impr_normal
           v_log_impr_avdeb
           v_log_impr_cheq_acr
           v_ind_apres_tit_avdeb
           v_log_tip_espec_docto_terc
           v_log_tip_espec_docto_cheq_terc
           with frame f_rpt_41_movto_tit_acr_contr_juros.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_upc) (input 'ENABLE',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_appc) (input 'ENABLE',
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
        assign v_rec_table_epc = recid(movto_tit_acr).    
        run value(v_nom_prog_dpc) (input 'ENABLE',
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


/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
    run pi_posiciona_dwb_rpt_param in v_prog_filtro_pdf (input rowid(dwb_rpt_param)).
    run pi_load_params in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */



    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_movto_tit_acr_contr_juros.


    if  yes = yes
    then do:
       enable rs_ind_run_mode
              with frame f_rpt_41_movto_tit_acr_contr_juros.
       apply "value-changed" to rs_ind_run_mode in frame f_rpt_41_movto_tit_acr_contr_juros.
    end /* if */.



    /* Begin_Include: ix_p10_rpt_movto_tit_acr_contr_juros */
    if  dwb_rpt_param.cod_dwb_parameters <> ""
    and (num-entries(dwb_rpt_param.cod_dwb_parameters,chr(10)) = 31
    or  num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 32)
    then do:
        assign v_ind_visualiz_tit_acr_vert = entry(1,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_log_movto_estordo         = (entry(2,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_cod_finalid_econ          = entry(3,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_finalid_econ_apres    = entry(4,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_cotac_indic_econ      = date(entry(5,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               rs_controle_juros_classif   = entry(6,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_unid_negoc_ini        = entry(9,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_unid_negoc_fim        = entry(10,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_ini       = entry(11,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_fim       = entry(12,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cdn_cliente_ini           = integer(entry(13,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cdn_cliente_fim           = integer(entry(14,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cdn_repres_ini            = integer(entry(15,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cdn_repres_fim            = integer(entry(16,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cod_portador_ini          = entry(17,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_portador_fim          = entry(18,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_cart_bcia_ini         = entry(19,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_cart_bcia_fim         = entry(20,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_refer_ini             = entry(21,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_refer_fim             = entry(22,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_indic_econ_ini        = entry(23,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_indic_econ_fim        = entry(24,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_transacao_ini         = date(entry(25,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_transacao_fim         = date(entry(26,dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_ind_classif               = entry(27,dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_log_impr_normal           = (entry(28,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_impr_avdeb            = (entry(29,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_impr_cheq_acr         = (entry(30,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_ind_apres_tit_avdeb       = entry(31,dwb_rpt_param.cod_dwb_parameters, chr(10)).

        if  num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 32 
        and v_log_control_terc_acr then
            assign v_log_tip_espec_docto_terc      = (entry(32,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_tip_espec_docto_cheq_terc = (entry(33,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ) no-error.

        if  num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 34
        and v_log_modul_vendor then     
            assign v_log_mostra_docto_vendor       = (entry(34,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
                   v_log_mostra_docto_vendor_repac = (entry(35,dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ) no-error.

        if num-entries(dwb_rpt_param.cod_dwb_parameters , chr(10)) >= 36 then do:
            if entry(36, dwb_rpt_param.cod_dwb_parameters, chr(10)) <> "" then do:
                assign v_des_estab_select = entry(36, dwb_rpt_param.cod_dwb_parameters, chr(10)).
                run pi_vld_estab_select (input "ACR" /*l_acr*/ ).
            end.
            else do:
               assign v_des_estab_select = "".
               run pi_vld_permissao_usuar_estab_empres (Input "ACR" /*l_acr*/ ).
            end.
        end.

        if  dwb_rpt_param.cod_dwb_parameters <> ""
        and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 37 then do:
            assign v-cod-gr-cob-ini = int(entry(37,dwb_rpt_param.cod_dwb_parameters, chr(10))).
        end.

        if  dwb_rpt_param.cod_dwb_parameters <> ""
        and num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) >= 38 then do:
            assign v-cod-gr-cob-fim = int(entry(38,dwb_rpt_param.cod_dwb_parameters, chr(10))).
        end.

    end.
    else do:    
        assign v_dat_cotac_indic_econ    = today
               rs_controle_juros_classif = "Por Cliente" /*l_por_cliente*/ 
               v_ind_classif             = "Por Cliente" /*l_por_cliente*/ 
               v_ind_especie             = "Normal e Nota DB" /*l_normal_Nota_DB*/  
               v_dat_transacao_fim       = today
               v_dat_transacao_ini       = date(month(today),01,year(today)).
    end.

    assign v_log_mostra_docto_vendor      :sensitive in frame f_rpt_41_movto_tit_acr_contr_juros = v_log_modul_vendor
           v_log_mostra_docto_vendor_repac:sensitive in frame f_rpt_41_movto_tit_acr_contr_juros = v_log_modul_vendor.

    display bt_can
            bt_close
            bt_hel2
            bt_print
            bt_ran2
            ed_1x40
            rs_cod_dwb_output
            rs_controle_juros_classif
            rs_ind_run_mode
            v_cod_finalid_econ
            v_cod_finalid_econ_apres
            v_dat_cotac_indic_econ
            v_ind_apres_tit_avdeb
            v_ind_visualiz_tit_acr_vert
            v_log_impr_avdeb
            v_log_impr_cheq_acr
            v_log_impr_normal
            v_log_mostra_docto_vendor
            v_log_mostra_docto_vendor_repac
            v_log_movto_estordo
            v_log_print_par
            v_log_tip_espec_docto_cheq_terc
            v_log_tip_espec_docto_terc
            v_qtd_column
            v_qtd_line
            with frame f_rpt_41_movto_tit_acr_contr_juros.


    if  v_log_control_terc_acr = no then
        assign v_log_tip_espec_docto_terc     :visible in frame f_rpt_41_movto_tit_acr_contr_juros = no
               v_log_tip_espec_docto_cheq_terc:visible in frame f_rpt_41_movto_tit_acr_contr_juros = no.


    /* End_Include: ix_p10_rpt_movto_tit_acr_contr_juros */


    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_movto_tit_acr_contr_juros:

            if (retry) then
                output stream s_1 close.
            assign v_log_print = no.
            if  valid-handle(v_wgh_focus) then
                wait-for go of frame f_rpt_41_movto_tit_acr_contr_juros focus v_wgh_focus.
            else
                wait-for go of frame f_rpt_41_movto_tit_acr_contr_juros.

            param_block:
            do transaction:

                /* Begin_Include: ix_p15_rpt_movto_tit_acr_contr_juros */
                assign input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_cod_finalid_econ_apres
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_dat_cotac_indic_econ
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_ind_apres_tit_avdeb
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_ind_visualiz_tit_acr_vert
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_avdeb
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_cheq_acr
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_impr_normal
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_movto_estordo
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_print_par.
                if v_log_control_terc_acr = yes then do:
                    assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_cheq_terc
                           input frame f_rpt_41_movto_tit_acr_contr_juros v_log_tip_espec_docto_terc.
                end.
                else do:
                    assign v_log_tip_espec_docto_cheq_terc = no
                           v_log_tip_espec_docto_terc      = no.
                end.

                assign input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_log_mostra_docto_vendor_repac.

                assign dwb_rpt_param.cod_dwb_parameters = v_ind_visualiz_tit_acr_vert    + chr(10) +
                                                          string(v_log_movto_estordo)    + chr(10) +
                                                          v_cod_finalid_econ             + chr(10) +
                                                          v_cod_finalid_econ_apres       + chr(10) +
                                                          string(v_dat_cotac_indic_econ) + chr(10) +
                                                          rs_controle_juros_classif      + chr(10) +
                                                          ""                             + chr(10) +
                                                          ""                             + chr(10) +
                                                          v_cod_unid_negoc_ini           + chr(10) +
                                                          v_cod_unid_negoc_fim           + chr(10) +
                                                          v_cod_espec_docto_ini          + chr(10) +
                                                          v_cod_espec_docto_fim          + chr(10) +
                                                          string(v_cdn_cliente_ini)      + chr(10) +
                                                          string(v_cdn_cliente_fim)      + chr(10) +
                                                          string(v_cdn_repres_ini)       + chr(10) +            
                                                          string(v_cdn_repres_fim)       + chr(10) +            
                                                          v_cod_portador_ini             + chr(10) +
                                                          v_cod_portador_fim             + chr(10) +
                                                          v_cod_cart_bcia_ini            + chr(10) +
                                                          v_cod_cart_bcia_fim            + chr(10) +
                                                          v_cod_refer_ini                + chr(10) +
                                                          v_cod_refer_fim                + chr(10) +
                                                          v_cod_indic_econ_ini           + chr(10) +
                                                          v_cod_indic_econ_fim           + chr(10) +
                                                          string(v_dat_transacao_ini)    + chr(10) +
                                                          string(v_dat_transacao_fim)    + chr(10) +
                                                          v_ind_classif                  + chr(10) + 
                                                          string(v_log_impr_normal)      + chr(10) + 
                                                          string(v_log_impr_avdeb)       + chr(10) + 
                                                          string(v_log_impr_cheq_acr)    + chr(10) + 
                                                          v_ind_apres_tit_avdeb          .
                /* Func∆o Controle Terceiros */

                assign dwb_rpt_param.cod_dwb_parameters = if v_log_control_terc_acr = yes then dwb_rpt_param.cod_dwb_parameters + chr(10) + string(v_log_tip_espec_docto_terc) + chr(10) + string(v_log_tip_espec_docto_cheq_terc)
                                                          else dwb_rpt_param.cod_dwb_parameters + chr(10) + "" + chr(10) + "".
                /* ==> MODULO VENDOR <== */
                assign dwb_rpt_param.cod_dwb_parameters = if v_log_modul_vendor = yes then dwb_rpt_param.cod_dwb_parameters + chr(10) + string(v_log_mostra_docto_vendor) + chr(10) + string(v_log_mostra_docto_vendor_repac)
                                                          else dwb_rpt_param.cod_dwb_parameters + chr(10) + "" + chr(10) + "".

                /* Estabelecimento Seleá∆o */
                assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + v_des_estab_select.
                /* End_Include: ix_p15_rpt_movto_tit_acr_contr_juros */

                /* Tratamento grupo cobranáa */
                assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + string(v-cod-gr-cob-ini, '99') + chr(10) + string(v-cod-gr-cob-fim, '99').

                assign dwb_rpt_param.log_dwb_print_parameters = input frame f_rpt_41_movto_tit_acr_contr_juros v_log_print_par
                       dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_41_movto_tit_acr_contr_juros rs_ind_run_mode
                       input frame f_rpt_41_movto_tit_acr_contr_juros v_qtd_line.

                /* ix_p20_rpt_movto_tit_acr_contr_juros */
            end /* do param_block */.

            if  v_log_print = yes
            then do:
                if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
                then do:
                   if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
                   then do:
                       assign v_cod_dwb_file = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/")
                              v_nom_integer = v_cod_dwb_file.
                       if  index(v_cod_dwb_file, ":") <> 0
                       then do:
                           /* Nome de arquivo com problemas. */
                           run pi_messages (input "show",
                                            input 1979,
                                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                           next main_block.
                       end /* if */.

                       file_1:
                       do
                          while index(v_cod_dwb_file,"~/") <> 0:
                          assign v_cod_dwb_file = substring(v_cod_dwb_file,(index(v_cod_dwb_file,"~/" ) + 1)).
                       end /* do file_1 */.

                       /* valname: */
                       case num-entries(v_cod_dwb_file,"."):
                           when 1 then
                               if  length(v_cod_dwb_file) > 8
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           when 2 then
                               if  length(entry(1, v_cod_dwb_file, ".")) > 8
                               or length(entry(2, v_cod_dwb_file, ".")) > 3
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           otherwise other:
                                     do:
                               /* Nome de arquivo com problemas. */
                               run pi_messages (input "show",
                                                input 1979,
                                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                               next main_block.
                           end /* do other */.
                       end /* case valname */.
                   end /* if */.
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
                    run pi_filename_batch in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */


                   assign v_cod_dwb_file = v_nom_integer.
                   if  search("prgtec/btb/btb911za.r") = ? and search("prgtec/btb/btb911za.p") = ? then do:
                       if  v_cod_dwb_user begins 'es_' then
                           return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb911za.p".
                       else do:
                           message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb911za.p"
                                  view-as alert-box error buttons ok.
                           return.
                       end.
                   end.
                   else
                       run prgtec/btb/btb911za.p (Input v_cod_dwb_program,
                                              Input v_cod_release,
                                              Input 41,
                                              Input recid(dwb_rpt_param),
                                              output v_num_ped_exec) /*prg_fnc_criac_ped_exec*/.
                   if (v_num_ped_exec <> 0) then
                       leave main_block.
                   else
                       next main_block.
                end /* if */.
                else do:
                    assign v_log_method = session:set-wait-state('general')
                           v_nom_report_title = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name.
                    /* out_def: */
&if '{&emsbas_version}':U >= '5.05':U &then
/*                    case dwb_rpt_param.cod_dwb_output:*/
&else
                    case dwb_rpt_param.cod_dwb_output:
&endif
&if '{&emsbas_version}':U >= '5.05':U &then
/*                        when "Terminal" /*l_terminal*/ then out_term:*/
                        if dwb_rpt_param.cod_dwb_output = 'Terminal' then
&else
                        when "Terminal" /*l_terminal*/ then out_term:
&endif
                         do:
                            assign v_cod_dwb_file   = session:temp-directory + "esacr066.csv"
                                   v_rpt_s_1_bottom = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).
                            output stream s_1 to value(v_cod_dwb_file) paged page-size value(v_qtd_line) convert target 'iso8859-1'.
                        end /* do out_term */.
&if '{&emsbas_version}':U >= '5.05':U &then
/*                        when "Impressora" /*l_printer*/ then out_print:*/
                        if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() <> 'PDF':U and getCodTipoRelat() <> 'RTF':U then
&else
                        when "Impressora" /*l_printer*/ then out_print:
&endif
                         do:
                            find imprsor_usuar no-lock
                                 where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                                   and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                                 use-index imprsrsr_id
&endif
                                  /*cl_get_printer of imprsor_usuar*/ no-error.
                            find impressora no-lock
                                 where impressora.nom_impressora = imprsor_usuar.nom_impressora
                                  no-error.
                            find tip_imprsor no-lock
                                 where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                                  no-error.
                            find layout_impres no-lock
                                 where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                                   and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                            assign v_rpt_s_1_bottom = layout_impres.num_lin_pag - (v_rpt_s_1_lines - v_qtd_bottom).
&if '{&emsbas_version}' > '1.00' &then
                            if  v_nom_dwb_print_file <> "" then
                                if  layout_impres.num_lin_pag = 0 then
                                    output stream s_1 to value(lc(v_nom_dwb_print_file))
                                           page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                                else
                                    output stream s_1 to value(lc(v_nom_dwb_print_file))
                                           paged page-size value(layout_impres.num_lin_pag) convert target  tip_imprsor.cod_pag_carac_conver.
                            else
&endif
                                if  layout_impres.num_lin_pag = 0 then
                                    output stream s_1 to value(imprsor_usuar.nom_disposit_so)
                                           page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                                else
                                    output stream s_1 to value(imprsor_usuar.nom_disposit_so)
                                           paged page-size value(layout_impres.num_lin_pag) convert target  tip_imprsor.cod_pag_carac_conver.

                            setting:
                            for
                                each configur_layout_impres no-lock
                                where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres

                                by configur_layout_impres.num_ord_funcao_imprsor:
                                find configur_tip_imprsor no-lock
                                     where configur_tip_imprsor.cod_tip_imprsor = layout_impres.cod_tip_imprsor
                                       and configur_tip_imprsor.cod_funcao_imprsor = configur_layout_impres.cod_funcao_imprsor
                                       and configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
&if "{&emsbas_version}" >= "5.01" &then
                                     use-index cnfgrtpm_id
&endif
                                      /*cl_get_print_command of configur_tip_imprsor*/ no-error.
                                bloco_1:
                                do
                                    v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                                    /* configur_tip_imprsor: */
                                    case configur_tip_imprsor.num_carac_configur[v_num_count]:
                                         when 0 then put  stream s_1 control null.
                                         when ? then leave.
                                         otherwise 
                                             /* Convers∆o interna do OUTPUT TARGET */
                                             put stream s_1 control codepage-convert ( chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                                       session:cpinternal,
                                                                                       tip_imprsor.cod_pag_carac_conver).
                                    end /* case configur_tip_imprsor */.
                                end /* do bloco_1 */.   
                            end /* for setting */.
                        end /* do out_print */.
&if '{&emsbas_version}':U >= '5.05':U &then
/*                        when "Arquivo" /*l_file*/ then out_file:*/
                        if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U then do:
                            run pi_config_output_print_pdf in v_prog_filtro_pdf (input v_qtd_line, input-output v_cod_dwb_file, input dwb_rpt_param.cod_dwb_user, input no).
                        end.
                        if dwb_rpt_param.cod_dwb_output = 'Arquivo' then
&else
                        when "Arquivo" /*l_file*/ then out_file:
&endif
                         do:
                            assign v_cod_dwb_file   = dwb_rpt_param.cod_dwb_file
                                   v_rpt_s_1_bottom = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_rename_file in v_prog_filtro_pdf (input-output v_cod_dwb_file).
&endif
/* tech38629 - Fim da alteraá∆o */



                            output stream s_1 to value(v_cod_dwb_file)
                                   paged page-size value(v_qtd_line) convert target 'iso8859-1'.
                        end /* do out_file */.
&if '{&emsbas_version}':U >= '5.05':U &then
/*                    end /* case out_def */.*/
&else
                    end /* case out_def */.
&endif
                    assign v_nom_prog_ext  = "esacr066"
                           v_cod_release   = trim(" 1.00.00.000":U)
                           v_dat_execution = today
                           v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
                    run pi_rpt_movto_tit_acr_contr_juros /*pi_rpt_movto_tit_acr_contr_juros*/.
                end /* else */.
                if  dwb_rpt_param.log_dwb_print_parameters = yes
                then do:
/*                     if (page-number (s_1) > 0) then                                      */
/*                         page stream s_1.                                                 */
/*                     /* ix_p29_rpt_movto_tit_acr_contr_juros */                           */
/*                     hide stream s_1 frame f_rpt_s_1_header_period.                       */
/*                     view stream s_1 frame f_rpt_s_1_header_unique.                       */
/*                     hide stream s_1 frame f_rpt_s_1_footer_last_page.                    */
/*                     hide stream s_1 frame f_rpt_s_1_footer_normal.                       */
/*                     view stream s_1 frame f_rpt_s_1_footer_param_page.                   */
/*                     if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then                   */
/*                         page stream s_1.                                                 */
/*                     put stream s_1 unformatted                                           */
/*                         skip (1)                                                         */
/*                         "Usu†rio: " at 1                                                 */
/*                         v_cod_usuar_corren at 10 format "x(12)" skip (1).                */
/*                                                                                          */
/*                     /* Begin_Include: ix_p30_rpt_movto_tit_acr_contr_juros */            */
/*                     if (line-counter(s_1) + 21) > v_rpt_s_1_bottom then                  */
/*                         page stream s_1.                                                 */
/*                     put stream s_1 unformatted                                           */
/*                         "---------------------------------------------" at 33            */
/*                         "Visualizaá∆o" at 79                                             */
/*                         "---------------------------------------------" at 93            */
/*                         skip (1)                                                         */
/*                         "  Visualiza: " at 74                                            */
/*                         v_ind_visualiz_tit_acr_vert at 87 format "X(20)" skip            */
/*                         v_ind_classif at 87 format "X(35)" skip.                         */
/*                     put stream s_1 unformatted                                           */
/*                         "Liquidaá‰es Estornadas:     " at 63                             */
/*                         v_log_movto_estordo at 91 format "Sim/N∆o"                       */
/*                         skip (1)                                                         */
/*                         "---------------------------------------------" at 33            */
/*                         "Apresentaá∆o  " at 79                                           */
/*                         "---------------------------------------------" at 93            */
/*                         skip (1)                                                         */
/*                         "    Finalidade Econìmica: " at 61                               */
/*                         v_cod_finalid_econ at 87 format "x(10)" skip                     */
/*                         "Finalid Apresentaá∆o: " at 65.                                  */
/*                     put stream s_1 unformatted                                           */
/*                         v_cod_finalid_econ_apres at 87 format "x(10)" skip               */
/*                         "Data Cotaá∆o: " at 73                                           */
/*                         v_dat_cotac_indic_econ at 87 format "99/99/9999"                 */
/*                         skip (1)                                                         */
/*                         "---------------------------------------------" at 34            */
/*                         "Imprimir" at 83                                                 */
/*                         "---------------------------------------------" at 95            */
/*                         skip (1)                                                         */
/*                         "  T°tulos: " at 77                                              */
/*                         v_ind_apres_tit_avdeb at 88 format "X(15)".                      */
/*                     put stream s_1 unformatted                                           */
/*                         skip (1)                                                         */
/*                         "---------------------------------------------" at 33            */
/*                         "Tipo EspÇcie  " at 79                                           */
/*                         "---------------------------------------------" at 94            */
/*                         skip (1)                                                         */
/*                         "  Normal: " at 77                                               */
/*                         v_log_impr_normal at 87 format "Sim/N∆o" skip                    */
/*                         "   Aviso de DÇbito: " at 67                                     */
/*                         v_log_impr_avdeb at 87 format "Sim/N∆o" skip                     */
/*                         "Cheque: " at 79.                                                */
/*                     put stream s_1 unformatted                                           */
/*                         v_log_impr_cheq_acr at 87 format "Sim/N∆o" skip.                 */
/*                     if v_log_control_terc_acr = yes then do:                             */
/*                         if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then               */
/*                             page stream s_1.                                             */
/*                         put stream s_1 unformatted                                       */
/*                             "  Dupl. Terceiros: " at 68                                  */
/*                             v_log_tip_espec_docto_terc at 87 format "Sim/N∆o" skip       */
/*                             "    Cheques Terceiros: " at 64                              */
/*                             v_log_tip_espec_docto_cheq_terc at 87 format "Sim/N∆o" skip. */
/*                     end.                                                                 */
/*                                                                                          */
/*                     /* ==> MODULO VENDOR <== */                                          */
/*                     if  v_log_modul_vendor then do:                                      */
/*                         if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then               */
/*                             page stream s_1.                                             */
/*                         put stream s_1 unformatted                                       */
/*                             "  Vendor: " at 77                                           */
/*                             v_log_mostra_docto_vendor at 87 format "Sim/N∆o" skip        */
/*                             "    Vendor Repactuado: " at 64                              */
/*                             v_log_mostra_docto_vendor_repac at 87 format "Sim/N∆o" skip. */
/*                     end.                                                                 */
                    /* End_Include: ix_p30_rpt_movto_tit_acr_contr_juros */

                end /* if */.
                output stream s_1 close.

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input no,
                                                 input rs_cod_dwb_output:screen-value in frame f_rpt_41_movto_tit_acr_contr_juros,
                                                 input v_nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U &then
    if ((dwb_rpt_param.cod_dwb_output = 'Impressora':U or dwb_rpt_param.cod_dwb_output = 'Impresora':U or dwb_rpt_param.cod_dwb_output = 'printer':U) and getCodTipoRelat() = 'PDF':U) then do:
        if v_nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input no).
    end.
&endif
                assign v_log_method = session:set-wait-state("").
                if (dwb_rpt_param.cod_dwb_output = "Terminal" /*l_terminal*/ ) then do:
                /* tech38629 - Alteraá∆o efetuada via filtro */
                &if '{&emsbas_version}':U >= '5.05':U &then
                    if  getCodTipoRelat() = 'PDF':U and OPSYS = 'WIN32':U
                    then do:
                        run pi_open_pdf_file in v_prog_filtro_pdf.
                    end.
                    else if getCodTipoRelat() = 'Texto' then do:
                &endif
                /* tech38629 - Fim da alteraá∆o */
                    run pi_show_report_2 (Input v_cod_dwb_file) /*pi_show_report_2*/.
                /* tech38629 - Alteraá∆o efetuada via filtro */
                &if '{&emsbas_version}':U >= '5.05':U &then
                    end.
                &endif
                /* tech38629 - Fim da alteraá∆o */
                end.

                leave main_block.

            end /* if */.
            else do:
                leave super_block.
            end /* else */.

        end /* repeat main_block */.

        /* ix_p32_rpt_movto_tit_acr_contr_juros */

        if  v_num_ped_exec <> 0
        then do:
            /* Criado pedido &1 para execuá∆o batch. */
            run pi_messages (input "show",
                             input 3556,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_ped_exec)) /*msg_3556*/.
            assign v_num_ped_exec = 0.
        end /* if */.

        /* ix_p35_rpt_movto_tit_acr_contr_juros */

    end /* repeat block1 */.
end /* repeat super_block */.

/* ix_p40_rpt_movto_tit_acr_contr_juros */

hide frame f_rpt_41_movto_tit_acr_contr_juros.

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


if  this-procedure:persistent then
    delete procedure this-procedure.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_return_user
** Descricao.............: pi_return_user
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: vladimir
** Alterado em...........: 12/02/1996 10:16:42
*****************************************************************************/
PROCEDURE pi_return_user:

    /************************ Parameter Definition Begin ************************/

    def output param p_nom_user
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_nom_user = v_cod_usuar_corren.

    if  v_cod_usuar_corren begins 'es_'
    then do:
       assign v_cod_usuar_corren = entry(2,v_cod_usuar_corren,"_").
    end /* if */.

END PROCEDURE. /* pi_return_user */
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre18856
** Alterado em...........: 07/12/2004 11:17:57
*****************************************************************************/
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
            if  length(v_cod_2) > 8
            then do:
                return "NOK" /*l_nok*/ .
            end /* if */.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).
    if  length(v_cod_2) > 8
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_filename_validation */
/*****************************************************************************
** Procedure Interna.....: pi_set_print_layout_default
** Descricao.............: pi_set_print_layout_default
** Criado por............: Gilsinei
** Criado em.............: 04/03/1996 09:22:54
** Alterado por..........: bre19127
** Alterado em...........: 16/09/2002 08:39:04
*****************************************************************************/
PROCEDURE pi_set_print_layout_default:

    dflt:
    do with frame f_rpt_41_movto_tit_acr_contr_juros:

        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = v_cod_dwb_user
               and layout_impres_padr.cod_proced = v_cod_dwb_proced
    &if "{&emsbas_version}" >= "5.01" &then
             use-index lytmprsp_id
    &endif
              /*cl_default_procedure_user of layout_impres_padr*/ no-error.
        if  not avail layout_impres_padr
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = "*"
                   and layout_impres_padr.cod_proced = v_cod_dwb_proced
    &if "{&emsbas_version}" >= "5.01" &then
                 use-index lytmprsp_id
    &endif
                  /*cl_default_procedure of layout_impres_padr*/ no-error.
            if  avail layout_impres_padr
            then do:
                find imprsor_usuar no-lock
                     where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                       and imprsor_usuar.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index imprsrsr_id
    &endif
                      /*cl_layout_current_user of imprsor_usuar*/ no-error.
            end /* if */.
            if  not avail imprsor_usuar
            then do:
                find layout_impres_padr no-lock
                     where layout_impres_padr.cod_usuario = v_cod_dwb_user
                       and layout_impres_padr.cod_proced = "*"
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index lytmprsp_id
    &endif
                      /*cl_default_user of layout_impres_padr*/ no-error.
            end /* if */.
        end /* if */.
        do transaction:
            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            if  avail layout_impres_padr
            then do:
                assign dwb_rpt_param.nom_dwb_printer      = layout_impres_padr.nom_impressora
                       dwb_rpt_param.cod_dwb_print_layout = layout_impres_padr.cod_layout_impres
                       ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                            + ":"
                                            + dwb_rpt_param.cod_dwb_print_layout.
            end /* if */.
            else do:
                assign dwb_rpt_param.nom_dwb_printer       = ""
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       ed_1x40:screen-value = "".
            end /* else */.
        end.
    end /* do dflt */.
END PROCEDURE. /* pi_set_print_layout_default */
/*****************************************************************************
** Procedure Interna.....: pi_show_report_2
** Descricao.............: pi_show_report_2
** Criado por............: Gilsinei
** Criado em.............: 07/03/1996 14:42:50
** Alterado por..........: bre19127
** Alterado em...........: 21/05/2002 10:16:34
*****************************************************************************/
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

    DOS SILENT START excel VALUE(p_cod_dwb_file).
    /*run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).*/

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE. /* pi_show_report_2 */
/*****************************************************************************
** Procedure Interna.....: pi_output_reports
** Descricao.............: pi_output_reports
** Criado por............: glauco
** Criado em.............: 21/03/1997 09:26:29
** Alterado por..........: bre18856
** Alterado em...........: 16/03/2001 16:38:44
*****************************************************************************/
PROCEDURE pi_output_reports:

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
    run pi_posiciona_dwb_rpt_param in v_prog_filtro_pdf (input rowid(dwb_rpt_param)).
    run pi_load_params in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */




    assign v_log_method       = session:set-wait-state('general')
           v_nom_report_title = fill(" ",40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_rpt_s_1_bottom   = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).

    /* block: */
&if '{&emsbas_version}':U >= '5.05':U &then
/*    case dwb_rpt_param.cod_dwb_output:*/
&else
    case dwb_rpt_param.cod_dwb_output:
&endif
&if '{&emsbas_version}':U >= '5.05':U &then
/*            when "Arquivo" /*l_file*/ then*/
            if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U then do:
                run pi_config_output_print_pdf in v_prog_filtro_pdf (input v_qtd_line, input-output v_cod_dwb_file, input v_cod_usuar_corren, input yes).
            end.
            if dwb_rpt_param.cod_dwb_output = 'Arquivo' then
&else
            when "Arquivo" /*l_file*/ then
&endif
            block1:
            do:
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_rename_file in v_prog_filtro_pdf (input-output v_cod_dwb_file).
&endif
/* tech38629 - Fim da alteraá∆o */



               output stream s_1 to value(v_cod_dwb_file)
               paged page-size value(v_qtd_line) convert target 'iso8859-1'.
            end /* do block1 */.
&if '{&emsbas_version}':U >= '5.05':U &then
/*            when "Impressora" /*l_printer*/ then*/
            if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() <> 'PDF':U and getCodTipoRelat() <> 'RTF':U then
&else
            when "Impressora" /*l_printer*/ then
&endif
               block2:
               do:
                  find imprsor_usuar use-index imprsrsr_id no-lock
                      where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                      and   imprsor_usuar.cod_usuario    = v_cod_usuar_corren no-error.
                  find impressora no-lock
                       where impressora.nom_impressora = imprsor_usuar.nom_impressora
                        no-error.
                  find tip_imprsor no-lock
                       where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                        no-error.
                  find layout_impres no-lock
                       where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                  find b_ped_exec_style
                      where b_ped_exec_style.num_ped_exec = v_num_ped_exec_corren no-lock no-error.
                  find servid_exec_imprsor no-lock
                       where servid_exec_imprsor.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and servid_exec_imprsor.cod_servid_exec = b_ped_exec_style.cod_servid_exec no-error.

                  find b_servid_exec_style no-lock
                       where b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec
                       no-error.

                  if  avail layout_impres
                  then do:
                     assign v_rpt_s_1_bottom = layout_impres.num_lin_pag - (v_rpt_s_1_lines - v_qtd_bottom).
                  end /* if */.

                  if  available b_servid_exec_style
                  and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
                  then do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* if */.
                  else do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* else */.

                  setting:
                  for
                      each configur_layout_impres no-lock
                      where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres

                      by configur_layout_impres.num_ord_funcao_imprsor:

                      find configur_tip_imprsor no-lock
                           where configur_tip_imprsor.cod_tip_imprsor = layout_impres.cod_tip_imprsor
                             and configur_tip_imprsor.cod_funcao_imprsor = configur_layout_impres.cod_funcao_imprsor
                             and configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
    &if "{&emsbas_version}" >= "5.01" &then
                           use-index cnfgrtpm_id
    &endif
                            /*cl_get_print_command of configur_tip_imprsor*/ no-error.

                      bloco_1:
                      do
                          v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                          /* configur_tip_imprsor: */
                          case configur_tip_imprsor.num_carac_configur[v_num_count]:
                              when 0 then put  stream s_1 control null.
                              when ? then leave.
                              otherwise 
                                  /* Convers∆o interna do OUTPUT TARGET */
                                  put stream s_1 control codepage-convert ( chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                            session:cpinternal,
                                                                            tip_imprsor.cod_pag_carac_conver).
                          end /* case configur_tip_imprsor */.
                      end /* do bloco_1 */.
                 end /* for setting */.
            end /* do block2 */.
&if '{&emsbas_version}':U >= '5.05':U &then
/*    end /* case block */.*/
&else
    end /* case block */.
&endif

    run pi_rpt_movto_tit_acr_contr_juros /*pi_rpt_movto_tit_acr_contr_juros*/.
END PROCEDURE. /* pi_output_reports */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_tt_faixa_datas
** Descricao.............: pi_carrega_tt_faixa_datas
** Criado por............: Amarildo
** Criado em.............: 13/03/1997 07:56:39
** Alterado por..........: Klug
** Alterado em...........: 30/04/1998 16:46:09
*****************************************************************************/
PROCEDURE pi_carrega_tt_faixa_datas:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_inic
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_table
        as date
        format "99/99/9999":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* ** CARREGA TEMPORµRIA COM AS DATAS COMPREENDIDAS EM UMA DETERMINADA FAIXA *********/
    /* ** Dever† ser relacionada aos objetos do programa uma tab-temp (tt_datas_faixa) ***/

    assign v_dat_table = p_dat_inic.
    data:
    repeat while v_dat_table <= p_dat_fim:
       create tt_datas_faixa.
       assign tt_datas_faixa.ttv_dat_table = v_dat_table
              v_dat_table                  = v_dat_table + 1.
    end /* repeat data */.

    /* ***********************************************************************************/
END PROCEDURE. /* pi_carrega_tt_faixa_datas */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: claudia
** Alterado em...........: 26/08/1996 11:54:50
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ
    then do:
           assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.
    end /* if */.

END PROCEDURE. /* pi_retornar_finalid_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_finalid
** Descricao.............: pi_retornar_indic_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:21:29
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ
** Descricao.............: pi_achar_cotac_indic_econ
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut1309
** Alterado em...........: 11/05/2005 14:04:02
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
    &if "{&emsuni_version}" >= "5.01" &then
                     use-index ctcprd_id
    &endif
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
    &if "{&emsuni_version}" >= "5.01" &then
                         use-index prdndccn_id
    &endif
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: bre17752
** Alterado em...........: 30/07/2003 12:46:24
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di†ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_tt_rpt_movto_tit_acr_contr_juros
** Descricao.............: pi_carrega_tt_rpt_movto_tit_acr_contr_juros
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:35:02
** Alterado por..........: fut41675
** Alterado em...........: 16/02/2011 09:54:10
*****************************************************************************/
PROCEDURE pi_carrega_tt_rpt_movto_tit_acr_contr_juros:

    run pi_inicializ_tabs_temps_contr_juros /*pi_inicializ_tabs_temps_contr_juros*/.
    run pi_zera_variaveis_contr_juros /*pi_zera_variaveis_contr_juros*/.

    /* Begin_Include: i_verifica_funcao_tip_calc_juros */
    &if defined(bf_fin_tip_calc_juros) &then
        assign v_log_funcao_tip_calc_juros = yes.
    &else
        find emscad.histor_exec_especial no-lock
            where emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
              and emscad.histor_exec_especial.cod_prog_dtsul  = "spp_tip_calc_juros" /*l_spp_tip_cal_juros*/  no-error.
        if  avail emscad.histor_exec_especial then
            assign v_log_funcao_tip_calc_juros = yes.

    &endif
    /* End_Include: i_funcao_extract */


    estab_block:
    for each estabelecimento fields(cod_estab cod_empresa cod_pais cod_calend_financ) no-lock
        where estabelecimento.cod_empresa = v_cod_empres_usuar
        and   lookup(estabelecimento.cod_estab, v_des_estab_select) > 0:

        tt_datas_transacao:
        for each tt_datas_faixa no-lock:

            if not can-find(first movto_tit_acr
                where movto_tit_acr.cod_estab = estabelecimento.cod_estab
                  and movto_tit_acr.dat_transacao = tt_datas_faixa.ttv_dat_table
                  and movto_tit_acr.cod_espec_docto >= v_cod_espec_docto_ini
                  and movto_tit_acr.cod_espec_docto <= v_cod_espec_docto_fim)
            then
                next.

            tt_especies:
            for each tt_espec_docto_faixa no-lock:

                movto_block:
                for each movto_tit_acr no-lock
                    where movto_tit_acr.cod_estab                   = estabelecimento.cod_estab
                    and   movto_tit_acr.dat_transacao               = tt_datas_faixa.ttv_dat_table
                    and   movto_tit_acr.cod_espec_docto             = tt_espec_docto_faixa.tta_cod_espec_docto
                    and   movto_tit_acr.ind_trans_acr_abrev         = "LIQ" /*l_liq*/ 
                    and   movto_tit_acr.log_liquidac_contra_antecip = no
                    use-index mvtttcr_estab_dat_trans.

                    if  (movto_tit_acr.log_movto_estordo  = no
                    or   (movto_tit_acr.log_movto_estordo  = yes
                    and   v_log_movto_estordo              = yes  ))
                    and  (movto_tit_acr.cdn_cliente       >= v_cdn_cliente_ini
                    and   movto_tit_acr.cdn_cliente       <= v_cdn_cliente_fim)
                    and  (movto_tit_acr.cod_refer         >= v_cod_refer_ini
                    and   movto_tit_acr.cod_refer         <= v_cod_refer_fim)
                    and  (movto_tit_acr.cod_portador      >= v_cod_portador_ini
                    and   movto_tit_acr.cod_portador      <= v_cod_portador_fim)
                    and  (movto_tit_acr.cod_cart_bcia     >= v_cod_cart_bcia_ini
                    and   movto_tit_acr.cod_cart_bcia     <= v_cod_cart_bcia_fim)
                    then do:

                        find tit_acr no-lock
                             where tit_acr.cod_estab = movto_tit_acr.cod_estab
                               and tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr
                              no-error.
                        if  available tit_acr
                        then do:

                            FIND int-emitente no-lock
                                WHERE int-emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
                            IF NOT AVAIL int-emitente
                            OR int-emitente.cod-gr-cob < v-cod-gr-cob-ini
                            OR int-emitente.cod-gr-cob > v-cod-gr-cob-fim
                               THEN NEXT.

                            if  tit_acr.cdn_repres >= v_cdn_repres_ini
                            and tit_acr.cdn_repres <= v_cdn_repres_fim
                            then do:

                                run pi_verificar_titulo_gera_avdeb /*pi_verificar_titulo_gera_avdeb*/.

                                if  return-value = "AVDB" /*l_avdb*/  then do:
                                    if  v_ind_apres_tit_avdeb = "N∆o Geraram AD" /*l_nao_geraram_ad*/  then
                                        next movto_block.
                                    assign v_log_gera_avdeb = yes.
                                end.
                                else do:
                                    if  v_ind_apres_tit_avdeb = "Geraram AD" /*l_geraram_ad*/  then
                                        next movto_block.
                                    assign v_log_gera_avdeb = no.
                                end.

                                find compl_movto_tit_acr no-lock
                                     where compl_movto_tit_acr.cod_estab = movto_tit_acr.cod_estab
                                       and compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                      no-error.
                                if  available compl_movto_tit_acr
                                then do:
                                    if  v_ind_classif = "Por Cliente" /*l_por_cliente*/ 
                                    or  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
                                    or  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
                                    then do:
                                        find emscad.cliente no-lock
                                            where cliente.cod_empresa = v_cod_empres_usuar
                                            and   cliente.cdn_cliente = movto_tit_acr.cdn_cliente no-error.
                                    end /* if */.

                                    if  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
                                    then do:
                                        find representante no-lock
                                            where representante.cod_empresa = v_cod_empres_usuar
                                            and   representante.cdn_repres  = tit_acr.cdn_repres no-error.
                                    end /* if */.

                                    if  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
                                    then do:
                                        find emscad.portador no-lock
                                            where portador.cod_portador = movto_tit_acr.cod_portador no-error.
                                    end /* if */.

                                    if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                                    then do:
                                        assign v_val_liquidac_apres  = 0
                                               v_val_juros_inf_apres = 0
                                               v_val_difer_juros     = 0
                                               v_val_tot_liquidac    = 0
                                               v_val_juros_calc      = 0
                                               v_val_tot_juros_infor = 0.
                                       /* *******************************/
                                       run pi_zera_variaveis_contr_juros /*pi_zera_variaveis_contr_juros*/.

                                       val_block:
                                       for each val_movto_tit_acr no-lock
                                           where val_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                           and   val_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                           and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                                           and   val_movto_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                                           and   val_movto_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                                           break by val_movto_tit_acr.cod_unid_negoc:

                                           run pi_soma_liquidac_juros_inf /*pi_soma_liquidac_juros_inf*/.

                                           if  last-of(val_movto_tit_acr.cod_unid_negoc)
                                           then do:

                                               assign v_val_liquidac_apres  = v_val_tot_liquidac    / v_val_cotac_indic_econ
                                                      v_val_juros_inf_apres = v_val_tot_juros_infor / v_val_cotac_indic_econ.

                                               /* --- Valor do Juros ---*/
                                               assign v_dat_juros           = tit_acr.dat_vencto_tit_acr + tit_acr.qtd_dias_carenc_juros_acr.
                                               run pi_atualizar_data_fluxo (Input tit_acr.cod_estab,
                                                                            input-output v_dat_juros) /*pi_atualizar_data_fluxo*/.

                                               if  v_dat_juros < compl_movto_tit_acr.dat_liquidac_movto_tit_acr
                                               then do:
                                                   assign v_val_juros_calc = (v_val_liquidac_apres * tit_acr.val_perc_juros_dia_atraso) / 100 *
                                                                             (compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr).
                                                   /* juros compostos */                                                
                                                   if  v_log_funcao_tip_calc_juros then do:                                                      
                                                       &if '{&emsfin_version}' >= "5.05" &then
                                                           assign v_ind_tip_calc_juros = tit_acr.ind_tip_calc_juros.                                                
                                                       &else
                                                           assign v_ind_tip_calc_juros = entry(3, tit_acr.cod_livre_1, chr(24)).
                                                       &endif    
                                                       assign v_num_dias_atraso = compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr.
                                                       run pi_retorna_juros_compostos (Input v_ind_tip_calc_juros,
                                                                                       Input tit_acr.val_perc_juros_dia_atraso,
                                                                                       Input v_val_liquidac_apres,
                                                                                       Input v_num_dias_atraso,
                                                                                       output v_val_juros_aux) /*pi_retorna_juros_compostos*/.
                                                       if  v_val_juros_aux <> ? then
                                                           assign v_val_juros_calc = v_val_juros_aux.
                                                   end.                          
                                               end /* if */.

                                               assign v_val_difer_juros = v_val_juros_calc - v_val_juros_inf_apres.

/*                                                if  v_val_difer_juros <> 0  */
/*                                                then do:                    */
                                                   run pi_cria_registro_tt_rpt_tit_acr_contr_juros (Input val_movto_tit_acr.cod_unid_negoc,
                                                                                                    Input movto_tit_acr.num_id_movto_tit_acr) /*pi_cria_registro_tt_rpt_tit_acr_contr_juros*/.
                                                   assign tt_rpt_movto_tit_acr_contr_juro.ttv_num_dias_atraso_juros  = compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr
                                                          tt_rpt_movto_tit_acr_contr_juro.ttv_cod_finalid_econ_liq   = compl_movto_tit_acr.cod_finalid_econ
                                                          tt_rpt_movto_tit_acr_contr_juro.tta_val_liquidac_tit_acr   = v_val_liquidac_apres
                                                          tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_inf          = v_val_juros_inf_apres
                                                          tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_cal          = v_val_juros_calc
                                                          tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_dif          = v_val_difer_juros.

                                                   run pi_classifica_movto_tit_acr_contr_juros /*pi_classifica_movto_tit_acr_contr_juros*/.
/*                                                end /* if */.  */
                                               assign v_val_tot_liquidac    = 0
                                                      v_val_tot_juros_infor = 0.
                                           end /* if */.
                                       end /* for val_block */.
                                   end /* if */.
                                   else do:
                                       assign v_val_liquidac_apres  = 0
                                              v_val_juros_inf_apres = 0
                                              v_val_difer_juros     = 0
                                              v_val_tot_liquidac    = 0
                                              v_val_juros_calc      = 0
                                              v_val_tot_juros_infor = 0.
                                       /* *******************************/
                                       run pi_zera_variaveis_contr_juros /*pi_zera_variaveis_contr_juros*/.

                                       val_block:
                                       for each val_movto_tit_acr of movto_tit_acr no-lock:
                                            if  val_movto_tit_acr.cod_finalid_econ = v_cod_finalid_econ
                                            then do:
                                                run pi_soma_liquidac_juros_inf /*pi_soma_liquidac_juros_inf*/.
                                            end /* if */.
                                       end /* for val_block */.

                                       assign v_val_liquidac_apres  = v_val_tot_liquidac    / v_val_cotac_indic_econ
                                              v_val_juros_inf_apres = v_val_tot_juros_infor / v_val_cotac_indic_econ.

                                       /* --- Valor do Juros ---*/
                                       assign v_dat_juros = tit_acr.dat_vencto_tit_acr + tit_acr.qtd_dias_carenc_juros_acr.
                                       run pi_atualizar_data_fluxo (Input tit_acr.cod_estab,
                                                                    input-output v_dat_juros) /*pi_atualizar_data_fluxo*/.

                                       if  v_dat_juros < compl_movto_tit_acr.dat_liquidac_movto_tit_acr
                                       then do:
                                           assign v_val_juros_calc = (v_val_liquidac_apres * tit_acr.val_perc_juros_dia_atraso) / 100 *
                                                                     (compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr).
                                           /* juros compostos */  
                                           if  v_log_funcao_tip_calc_juros then do:                                                      
                                               &if '{&emsfin_version}' >= "5.05" &then
                                                   assign v_ind_tip_calc_juros = tit_acr.ind_tip_calc_juros.                                                
                                               &else
                                                   assign v_ind_tip_calc_juros = entry(3, tit_acr.cod_livre_1, chr(24)).
                                               &endif    
                                               assign v_num_dias_atraso = compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr.
                                               run pi_retorna_juros_compostos (Input v_ind_tip_calc_juros,
                                                                               Input tit_acr.val_perc_juros_dia_atraso,
                                                                               Input v_val_liquidac_apres,
                                                                               Input v_num_dias_atraso,
                                                                               output v_val_juros_aux) /*pi_retorna_juros_compostos*/.
                                               if  v_val_juros_aux <> ? then
                                                   assign v_val_juros_calc = v_val_juros_aux.
                                           end.                          
                                       end /* if */.

                                       assign v_val_difer_juros = v_val_juros_calc - v_val_juros_inf_apres.

/*                                        if  v_val_difer_juros <> 0  */
/*                                        then do:                    */
                                           run pi_cria_registro_tt_rpt_tit_acr_contr_juros (Input "" /*l_null*/,
                                                                                            Input movto_tit_acr.num_id_movto_tit_acr) /*pi_cria_registro_tt_rpt_tit_acr_contr_juros*/.
                                           assign tt_rpt_movto_tit_acr_contr_juro.ttv_num_dias_atraso_juros  = compl_movto_tit_acr.dat_liquidac_movto_tit_acr - tit_acr.dat_vencto_tit_acr
                                                  tt_rpt_movto_tit_acr_contr_juro.ttv_cod_finalid_econ_liq   = compl_movto_tit_acr.cod_finalid_econ
                                                  tt_rpt_movto_tit_acr_contr_juro.tta_val_liquidac_tit_acr   = v_val_liquidac_apres
                                                  tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_inf          = v_val_juros_inf_apres
                                                  tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_cal          = v_val_juros_calc
                                                  tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_dif          = v_val_difer_juros.

                                           run pi_classifica_movto_tit_acr_contr_juros /*pi_classifica_movto_tit_acr_contr_juros*/.
/*                                        end /* if */.  */
                                       assign v_val_tot_liquidac    = 0
                                              v_val_tot_juros_infor = 0.
                                   end /* else */.

                                   if  available cliente 
                                   /*AND v_val_difer_juros <> 0*/
                                   then do:
                                       assign tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_cli    = cliente.nom_pessoa.
                                   end /* if */.
                                   if  available representante
                                   /*and v_val_difer_juros <> 0*/
                                   then do:
                                       assign tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_rep    = representante.nom_pessoa.
                                   end /* if */.
                                   if  available portador
                                   /* and v_val_difer_juros <> 0*/
                                   then do:
                                       assign tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_portad = portador.nom_pessoa.
                                   end /* if */.
                               end /* if */.
                           end /* if */.
                        end /* if */.
                    end /* if */.
                end /* for movto_block */.
            end /* for tt_especies */.
        end /* for tt_datas_transacao */.
    end /* for estab_block */.
END PROCEDURE. /* pi_carrega_tt_rpt_movto_tit_acr_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_classifica_movto_tit_acr_contr_juros
** Descricao.............: pi_classifica_movto_tit_acr_contr_juros
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:35:45
** Alterado por..........: Amarildo
** Alterado em...........: 31/03/1997 15:24:33
*****************************************************************************/
PROCEDURE pi_classifica_movto_tit_acr_contr_juros:

    /* class_block: */
    case v_ind_classif:
        when "Por Cliente" /*l_por_cliente*/ then
            assign tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 1] = string(tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente, ">>>,>>>,>>9":U)
                   tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 2] = tt_rpt_movto_tit_acr_contr_juro.tta_cod_tit_acr.

        when "Por Repres./Cliente" /*l_por_represcliente*/ then
            assign tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 1] = string(tt_rpt_movto_tit_acr_contr_juro.tta_cdn_repres, ">>>,>>9":U)
                   tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 2] = string(tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente, ">>>,>>>,>>9":U).

        when "Por Portador/Cliente" /*l_por_portadorcliente*/ then
            assign tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 1] = tt_rpt_movto_tit_acr_contr_juro.tta_cod_portador
                   tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[v_num_idx + 2] = string(tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente, ">>>,>>>,>>9":U).
    end /* case class_block */.

    if  v_ind_dwb_run_mode = "Batch" /*l_batch*/ 
    then do:
        assign v_cod_ult_obj_procesdo = string(tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente, ">>>,>>>,>>9":U).
        run prgtec/btb/btb908ze.py (Input 1,
                                    Input v_cod_ult_obj_procesdo) /*prg_api_atualizar_ult_obj*/.
    end /* if */.
END PROCEDURE. /* pi_classifica_movto_tit_acr_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_movto_tit_acr_contr_juros
** Descricao.............: pi_rpt_movto_tit_acr_contr_juros
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:36:17
** Alterado por..........: Klug
** Alterado em...........: 11/11/1998 14:51:07
*****************************************************************************/
PROCEDURE pi_rpt_movto_tit_acr_contr_juros:

    assign v_num_idx = 0.

    run pi_carrega_tt_rpt_movto_tit_acr_contr_juros /*pi_carrega_tt_rpt_movto_tit_acr_contr_juros*/.
    /* ******************************************************************************/
/*     hide stream s_1 frame f_rpt_s_1_header_period.                        */
/*     view stream s_1 frame f_rpt_s_1_header_unique.                        */
/*     hide stream s_1 frame f_rpt_s_1_footer_last_page.                     */
/*     hide stream s_1 frame f_rpt_s_1_footer_param_page.                    */
/*     view stream s_1 frame f_rpt_s_1_footer_normal.                        */
/*     view stream s_1 frame f_rpt_s_1_Grp_cab_finalid_Lay_finalid.          */
/*     view stream s_1 frame f_rpt_s_1_Grp_cab_complem_Lay_compl_cab.        */
/*     if  v_ind_apres_tit_avdeb = "Todos" /*l_todos*/  then do:             */
/*         hide stream s_1 frame f_rpt_s_1_Grp_cab_princip_Lay_cab_princip.  */
/*         view stream s_1 frame f_rpt_s_1_Grp_cab_princip_Lay_cab_aux.      */
/*     end.                                                                  */
/*     else do:                                                              */
/*         hide stream s_1 frame f_rpt_s_1_Grp_cab_princip_Lay_cab_aux.      */
/*         view stream s_1 frame f_rpt_s_1_Grp_cab_princip_Lay_cab_princip.  */
/*     end.                                                                  */
    find last param_geral_ems no-lock no-error.
    PUT STREAM s_1  "Cliente"       ";"
                    "Nome"          ";"
                    "Gr Cobranáa"   ";"
                    "Estab"         ";"
                    "EspÇcie"       ";"
                    "SÇrie"         ";"
                    "T°tulo"        ";"
                    "/P"            ";"
                    "Un N"          ";"
                    "Port"          ";"
                    "Cart"          ";"
                    "Vencimento"    ";"
                    "Liquidaá∆o"    ";"
                    "AD"            ";"
                    "ATRS"          ";"
                    "Liquidaáao"    ";"
                    "Vl Liquidaá∆o" ";"
                    "Juros Inform"  ";"
                    "Juros Calc"    ";"
                    "Diferenáa" skip.


    grp_block:
    for each tt_rpt_movto_tit_acr_contr_juro no-lock
        break by tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[1]
              by tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[2]
              by tt_rpt_movto_tit_acr_contr_juro.ttv_cod_dwb_field_rpt[3]:

        if  v_ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            run prgtec/btb/btb908ze.py (Input 1,
                                        Input tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab                    + "/" +                                      tt_rpt_movto_tit_acr_contr_juro.tta_cod_unid_negoc               + "/" +                                      string(tt_rpt_movto_tit_acr_contr_juro.tta_num_id_movto_tit_acr)) /*prg_api_atualizar_ult_obj*/.
        end /* if */.
        /* ************************ TESTA QUEBRAS FIRST************************************/

        /* ***********************  LINHA PRINCIPAL DO RELAT‡RIO *****************************/
        if  v_ind_apres_tit_avdeb = "Todos" /*l_todos*/  then do:
            
            put stream s_1 unformatted                                                                       
                        tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente                                      ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_cli                                   ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_grp_cob                                      ";".
            put stream s_1 unformatted
                        &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
                                    tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab  format "x(3)"             ";"
                        &ENDIF                                                                               
                        &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN            
                                    tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab  format "x(5)"             ";".
                        &ENDIF                                                                               
            put stream s_1 unformatted            
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_espec_docto        format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_ser_docto          format "x(5)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_tit_acr            format "x(16)"            ";"
                        "/" String(tt_rpt_movto_tit_acr_contr_juro.tta_cod_parcela,"99")                     ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_unid_negoc         format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_portador           format "x(5)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_cart_bcia          format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_dat_vencto_tit_acr     format "99/99/9999"       ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_dat_liquidac_tit_acr   format "99/99/9999"       ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_log_gera_avdeb         format "Sim/N∆o"          ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_num_dias_atraso_juros  format "-9999"            ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_cod_finalid_econ_liq   format "x(10)"            ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_val_liquidac_tit_acr   format ">>>,>>>,>>9.99"   ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_inf          format ">>>>,>>>,>>9.99"  ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_cal          format ">>>>,>>>,>>9.99"  ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_dif          format "(>>>>,>>>,>>9.99)" skip.
        end.
        else do:

            put stream s_1 unformatted                                                                       
                        tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente                                      ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_cli                                   ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_grp_cob                                      ";".
            put stream s_1 unformatted
                        &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
                                    tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab  FORMAT "x(3)"             ";"
                        &ENDIF                                                                                           
                        &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN                       
                                    tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab  format "x(5)"             ";".
                        &ENDIF                                                                                   
            put stream s_1 unformatted                                
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_espec_docto        format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_ser_docto          format "x(5)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_tit_acr            format "x(16)"            ";"
                        "/" String(tt_rpt_movto_tit_acr_contr_juro.tta_cod_parcela,"99")                     ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_unid_negoc         format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_portador           format "x(5)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_cod_cart_bcia          format "x(3)"             ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_dat_vencto_tit_acr     format "99/99/9999"       ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_dat_liquidac_tit_acr   format "99/99/9999"       ";".

            put stream s_1 unformatted                                                                       ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_num_dias_atraso_juros  format "-9999"            ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_cod_finalid_econ_liq   format "x(10)"            ";"
                        tt_rpt_movto_tit_acr_contr_juro.tta_val_liquidac_tit_acr   format ">>>,>>>,>>9.99"   ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_inf          format ">>>>,>>>,>>9.99"  ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_cal          format ">>>>,>>>,>>9.99"  ";"
                        tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_dif          format "(>>>>,>>>,>>9.99)"   skip.
        end.

        delete tt_rpt_movto_tit_acr_contr_juro.
    end /* for grp_block */.

END PROCEDURE. /* pi_rpt_movto_tit_acr_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_testa_quebras_contr_juros
** Descricao.............: pi_testa_quebras_contr_juros
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:37:03
** Alterado por..........: Klug
** Alterado em...........: 11/11/1998 09:46:07
*****************************************************************************/
PROCEDURE pi_testa_quebras_contr_juros:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_ocorrencia
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* quebra: */
    case p_num_ocorrencia:
        when 1 then quebr:
         do:
            if  v_ind_classif = "Por Cliente" /*l_por_cliente*/ 
            then do:
               if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                   page stream s_1.
               put stream s_1 unformatted 
                   "Total Cliente:" at 73
                   v_val_tot_liquidac_clien to 109 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_infor_clien to 130 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_calcul_clien to 151 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_difer_clien to 172 format "(>>,>>>,>>>,>>9.99)" skip (1).
               assign v_val_tot_liquidac_clien     = 0
                      v_val_tot_juros_infor_clien  = 0
                      v_val_tot_juros_calcul_clien = 0
                      v_val_tot_difer_clien        = 0.
            end /* if */.

            if  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
            then do:
               if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                   page stream s_1.
               put stream s_1 unformatted 
                   "Total Representante:" at 67
                   v_val_tot_liquidac_repres to 109 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_infor_repres to 130 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_calcul_repres to 151 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_difer_repres to 172 format "(>>,>>>,>>>,>>9.99)" skip (1).
               assign v_val_tot_liquidac_repres     = 0
                      v_val_tot_juros_infor_repres  = 0
                      v_val_tot_juros_calcul_repres = 0
                      v_val_tot_difer_repres        = 0.
            end /* if */.

            if  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
            then do:
               if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                   page stream s_1.
               put stream s_1 unformatted 
                   "Total Portador:   " at 69
                   v_val_tot_liquidac_portad to 109 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_infor_portad to 130 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_juros_calcul_portad to 151 format "->>,>>>,>>>,>>9.99"
                   v_val_tot_difer_portad to 172 format "(>>,>>>,>>>,>>9.99)" skip (1).
               assign v_val_tot_liquidac_portad     = 0
                      v_val_tot_juros_infor_portad  = 0
                      v_val_tot_juros_calcul_portad = 0
                      v_val_tot_difer_portad        = 0.
            end /* if */.

        end /* do quebr */.

        when 2 then
            if  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
            or  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
            then do:
                if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Total Cliente:" at 73
                    v_val_tot_liquidac_clien to 109 format "->>,>>>,>>>,>>9.99"
                    v_val_tot_juros_infor_clien to 130 format "->>,>>>,>>>,>>9.99"
                    v_val_tot_juros_calcul_clien to 151 format "->>,>>>,>>>,>>9.99"
                    v_val_tot_difer_clien to 172 format "(>>,>>>,>>>,>>9.99)" skip (1).
                assign v_val_tot_liquidac_clien     = 0
                       v_val_tot_juros_infor_clien  = 0
                       v_val_tot_juros_calcul_clien = 0
                       v_val_tot_difer_clien        = 0.
            end /* if */.
    end /* case quebra */.
END PROCEDURE. /* pi_testa_quebras_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_testa_quebras_contr_juros_1
** Descricao.............: pi_testa_quebras_contr_juros_1
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:37:30
** Alterado por..........: Klug
** Alterado em...........: 11/11/1998 09:46:37
*****************************************************************************/
PROCEDURE pi_testa_quebras_contr_juros_1:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_ocorrencia
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* quebra: */
    case p_num_ocorrencia:
        when 1 then ocorr_1:
         do:
            if  v_ind_classif = "Por Cliente" /*l_por_cliente*/ 
            then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "  Cliente: " at 7
                    tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente to 28 format ">>>,>>>,>>9"
                    tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_cli at 30 format "x(40)" skip.
            end /* if */.

            if  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
            then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "   Representante: " at 1
                    tt_rpt_movto_tit_acr_contr_juro.tta_cdn_repres to 25 format ">>>,>>9"
                    tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_rep at 27 format "x(40)" skip.
            end /* if */.

            if  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
            then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Portador: " at 5
                    tt_rpt_movto_tit_acr_contr_juro.tta_cod_portador at 15 format "x(5)"
                    tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_portad at 21 format "x(24)" skip.
            end /* if */.
        end /* do ocorr_1 */.

        when 2 then
            if  v_ind_classif = "Por Repres./Cliente" /*l_por_represcliente*/ 
            or  v_ind_classif = "Por Portador/Cliente" /*l_por_portadorcliente*/ 
            then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "  Cliente: " at 7
                    tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente to 28 format ">>>,>>>,>>9"
                    tt_rpt_movto_tit_acr_contr_juro.ttv_nom_pessoa_cli at 30 format "x(40)" skip.
            end /* if */.
    end /* case quebra */.
END PROCEDURE. /* pi_testa_quebras_contr_juros_1 */
/*****************************************************************************
** Procedure Interna.....: pi_acumula_totais_contr_juros
** Descricao.............: pi_acumula_totais_contr_juros
** Criado por............: Amarildo
** Criado em.............: 27/03/1997 17:55:07
** Alterado por..........: Amarildo
** Alterado em...........: 31/03/1997 10:36:34
*****************************************************************************/
PROCEDURE pi_acumula_totais_contr_juros:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_tot_liquidac_tit_acr
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def input-output param p_val_tot_juros_infor
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def input-output param p_val_tot_juros_calcul
        as decimal
        format "->>,>>>,>>9.99"
        decimals 2
        no-undo.
    def input-output param p_val_tot_difer_rpt
        as decimal
        format "->>>>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_val_tot_liquidac_tit_acr     = p_val_tot_liquidac_tit_acr     + tt_rpt_movto_tit_acr_contr_juro.tta_val_liquidac_tit_acr
           p_val_tot_juros_infor  = p_val_tot_juros_infor  + tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_inf
           p_val_tot_juros_calcul = p_val_tot_juros_calcul + tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_cal
           p_val_tot_difer_rpt    = p_val_tot_difer_rpt    + tt_rpt_movto_tit_acr_contr_juro.ttv_val_juros_dif.
END PROCEDURE. /* pi_acumula_totais_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_inicializ_tabs_temps_contr_juros
** Descricao.............: pi_inicializ_tabs_temps_contr_juros
** Criado por............: Amarildo
** Criado em.............: 31/03/1997 08:13:01
** Alterado por..........: Amarildo
** Alterado em...........: 31/03/1997 15:57:37
*****************************************************************************/
PROCEDURE pi_inicializ_tabs_temps_contr_juros:

    tt_rpt:
    for each tt_rpt_movto_tit_acr_contr_juro no-lock.
       delete tt_rpt_movto_tit_acr_contr_juro.
    end /* for tt_rpt */.

    data_trans:
    for each tt_datas_faixa no-lock.
       delete tt_datas_faixa.
    end /* for data_trans */.

    run pi_carrega_tt_faixa_datas (Input v_dat_transacao_ini,
                                   Input v_dat_transacao_fim) /*pi_carrega_tt_faixa_datas*/.

    espec_docto_faixa:
    for each tt_espec_docto_faixa no-lock.
       delete tt_espec_docto_faixa.
    end /* for espec_docto_faixa */.
    run pi_carrega_espec_docto_contr_juros (Input v_cod_espec_docto_ini,
                                            Input v_cod_espec_docto_fim) /*pi_carrega_espec_docto_contr_juros*/.
END PROCEDURE. /* pi_inicializ_tabs_temps_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_espec_docto_contr_juros
** Descricao.............: pi_carrega_espec_docto_contr_juros
** Criado por............: Amarildo
** Criado em.............: 31/03/1997 08:22:12
** Alterado por..........: bre19062
** Alterado em...........: 02/11/2002 21:02:08
*****************************************************************************/
PROCEDURE pi_carrega_espec_docto_contr_juros:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_espec_docto_ini
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_espec_docto_fim
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    especie:
    for each espec_docto_financ_acr no-lock
         where espec_docto_financ_acr.cod_espec_docto >= p_cod_espec_docto_ini
         and   espec_docto_financ_acr.cod_espec_docto <= p_cod_espec_docto_fim.

         find espec_docto of espec_docto_financ_acr no-lock no-error.

         if  available espec_docto
         then do:
             if  espec_docto.ind_tip_espec_docto = "Normal" /*l_normal*/             and v_log_impr_normal               = yes
             or  espec_docto.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/       and v_log_impr_avdeb                = yes
             or  espec_docto.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/  and v_log_impr_cheq_acr             = yes
             or  espec_docto.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/          and v_log_tip_espec_docto_terc      = yes /* controle terceiros */
             or  espec_docto.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/          and v_log_tip_espec_docto_cheq_terc = yes /* controle terceiros */
             or  espec_docto.ind_tip_espec_docto = "Vendor" /*l_Vendor*/             and v_log_mostra_docto_vendor       = yes /* MODULO VENDOR      */
             or  espec_docto.ind_tip_espec_docto = "Vendor Repactuado" /*l_Vendor_Repac*/       and v_log_mostra_docto_vendor_repac = yes then do:

                 create tt_espec_docto_faixa.
                 assign tt_espec_docto_faixa.tta_cod_espec_docto     = espec_docto_financ_acr.cod_espec_docto
                        tt_espec_docto_faixa.tta_ind_tip_espec_docto = espec_docto.ind_tip_espec_docto .
             end /* if */.
         end /* if */.
    end /* for especie */.
END PROCEDURE. /* pi_carrega_espec_docto_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_zera_variaveis_contr_juros
** Descricao.............: pi_zera_variaveis_contr_juros
** Criado por............: Amarildo
** Criado em.............: 31/03/1997 08:32:14
** Alterado por..........: Amarildo
** Alterado em...........: 31/03/1997 08:35:56
*****************************************************************************/
PROCEDURE pi_zera_variaveis_contr_juros:

    assign v_val_tot_liquidac_clien      = 0
           v_val_tot_juros_infor_clien   = 0
           v_val_tot_juros_calcul_clien  = 0
           v_val_tot_difer_clien         = 0
           v_val_tot_liquidac_repres     = 0
           v_val_tot_juros_infor_repres  = 0
           v_val_tot_juros_calcul_repres = 0
           v_val_tot_difer_repres        = 0
           v_val_tot_liquidac_portad     = 0
           v_val_tot_juros_infor_portad  = 0
           v_val_tot_juros_calcul_portad = 0
           v_val_tot_difer_portad        = 0
           v_val_tot_liquidac_geral      = 0
           v_val_tot_juros_infor_geral   = 0
           v_val_tot_juros_calcul_geral  = 0
           v_val_tot_difer_geral         = 0.
END PROCEDURE. /* pi_zera_variaveis_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_soma_liquidac_juros_inf
** Descricao.............: pi_soma_liquidac_juros_inf
** Criado por............: Amarildo
** Criado em.............: 31/03/1997 09:49:12
** Alterado por..........: Amarildo
** Alterado em...........: 31/03/1997 08:07:35
*****************************************************************************/
PROCEDURE pi_soma_liquidac_juros_inf:

    assign v_val_tot_liquidac    = v_val_tot_liquidac    + val_movto_tit_acr.val_liquidac_tit_ac
           v_val_tot_juros_infor = v_val_tot_juros_infor + val_movto_tit_acr.val_juros.
END PROCEDURE. /* pi_soma_liquidac_juros_inf */
/*****************************************************************************
** Procedure Interna.....: pi_cria_registro_tt_rpt_tit_acr_contr_juros
** Descricao.............: pi_cria_registro_tt_rpt_tit_acr_contr_juros
** Criado por............: Amarildo
** Criado em.............: 31/03/1997 10:23:49
** Alterado por..........: fut965
** Alterado em...........: 01/04/2002 10:10:01
*****************************************************************************/
PROCEDURE pi_cria_registro_tt_rpt_tit_acr_contr_juros:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_num_id_movto_tit_acr
        as integer
        format "9999999999"
        no-undo.


    /************************* Parameter Definition End *************************/

    create tt_rpt_movto_tit_acr_contr_juro.
    assign tt_rpt_movto_tit_acr_contr_juro.tta_cod_unid_negoc           = p_cod_unid_negoc
           tt_rpt_movto_tit_acr_contr_juro.tta_num_id_movto_tit_acr     = p_num_id_movto_tit_acr
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_estab                = tit_acr.cod_estab
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_espec_docto          = tit_acr.cod_espec_docto
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_ser_docto            = tit_acr.cod_ser_docto
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_tit_acr              = tit_acr.cod_tit_acr
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_parcela              = tit_acr.cod_parcela
           tt_rpt_movto_tit_acr_contr_juro.tta_cdn_cliente              = tit_acr.cdn_cliente
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_grp_cob              = int-emitente.cod-gr-cob
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_portador             = movto_tit_acr.cod_portador
           tt_rpt_movto_tit_acr_contr_juro.tta_cdn_repres               = tit_acr.cdn_repres
           tt_rpt_movto_tit_acr_contr_juro.tta_cod_cart_bcia            = movto_tit_acr.cod_cart_bcia
           tt_rpt_movto_tit_acr_contr_juro.tta_dat_vencto_tit_acr       = movto_tit_acr.dat_vencto_tit_acr
           tt_rpt_movto_tit_acr_contr_juro.tta_dat_liquidac_tit_acr     = compl_movto_tit_acr.dat_liquidac_movto_tit_acr
           tt_rpt_movto_tit_acr_contr_juro.ttv_num_dias_atraso_juros    = v_qtd_dias_atraso
           tt_rpt_movto_tit_acr_contr_juro.tta_log_gera_avdeb           = v_log_gera_avdeb.
END PROCEDURE. /* pi_cria_registro_tt_rpt_tit_acr_contr_juros */
/*****************************************************************************
** Procedure Interna.....: pi_vld_valores_apres_apb_acr
** Descricao.............: pi_vld_valores_apres_apb_acr
** Criado por............: Uno
** Criado em.............: 19/07/1996 15:44:37
** Alterado por..........: Emerson
** Alterado em...........: 03/12/1997 14:18:28
*****************************************************************************/
PROCEDURE pi_vld_valores_apres_apb_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_finalid_econ_apres
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_conver
        as date
        format "99/99/9999"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_indic_econ_base
        as character
        format "x(8)":U
        label "Moeda Base"
        column-label "Moeda Base"
        no-undo.
    def var v_cod_indic_econ_idx
        as character
        format "x(8)":U
        label "Moeda ÷ndice"
        column-label "Moeda ÷ndice"
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    find finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = p_cod_finalid_econ
         no-error.
    if  not avail finalid_econ
    then do:
        /* Finalidade Econìmica inexistente ! */
        run pi_messages (input "show",
                         input 1652,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1652*/.
        return error.
    end /* if */.

    if  finalid_econ.ind_armaz_val <> "M¢dulos" /*l_modulos*/ 
    then do:
        /* Finalidade Econìmica n∆o armazena valores no M¢dulo ! */
        run pi_messages (input "show",
                         input 1389,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            p_cod_finalid_econ)) /*msg_1389*/.
        return error.
    end /* if */.

    find finalid_unid_organ no-lock
         where finalid_unid_organ.cod_unid_organ   = v_cod_empres_usuar
         and   finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ
         no-error.
    if  not avail finalid_unid_organ
    then do:
        /* Finalidade n∆o liberada para Empresa do Usu†rio ! */
        run pi_messages (input "show",
                         input 2655,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2655*/.
        return error.
    end /* if */.



    run pi_retornar_indic_econ_finalid (Input p_cod_finalid_econ,
                                        Input p_dat_conver,
                                        output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
    if  v_cod_indic_econ_base = ? or v_cod_indic_econ_base = " "
    then do:
        /* Hist¢rico da Finalidade Inexistente para Data Convers∆o ! */
        run pi_messages (input "show",
                         input 2452,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2452*/.
        return error.
    end /* if */.

    find b_finalid_econ no-lock
         where b_finalid_econ.cod_finalid_econ = p_cod_finalid_econ_apres
         no-error.
    if  not avail b_finalid_econ
    then do:
        /* Finalidade Econìmica de Apresentaá∆o Inexistente ! */
        run pi_messages (input "show",
                         input 2450,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2450*/.
        return error.
    end /* if */.

    find b_finalid_unid_organ no-lock
         where b_finalid_unid_organ.cod_unid_organ   = v_cod_empres_usuar
         and   b_finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ_apres
         no-error.
    if  not avail b_finalid_unid_organ
    then do:
        /* Finalidade Apresentaá∆o n∆o liberada p/ Empresa do Usu†rio ! */
        run pi_messages (input "show",
                         input 2656,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2656*/.
        return error.
    end /* if */.

    run pi_retornar_indic_econ_finalid (Input p_cod_finalid_econ_apres,
                                        Input p_dat_conver,
                                        output v_cod_indic_econ_idx) /*pi_retornar_indic_econ_finalid*/.
    if  v_cod_indic_econ_idx = ? or v_cod_indic_econ_idx = " "
    then do:
        /* Hist¢rico Finalid. Apresent. Inexistente p/ Data Convers∆o ! */
        run pi_messages (input "show",
                         input 2453,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2453*/.
        return error.
    end /* if */.

    run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                   Input v_cod_indic_econ_idx,
                                   Input p_dat_conver,
                                   Input "Real" /*l_real*/,
                                   output p_dat_cotac_indic_econ,
                                   output p_val_cotac_indic_econ,
                                   output v_cod_return) /*pi_achar_cotac_indic_econ*/.
    if  v_cod_return <> "OK" /*l_ok*/ 
    then do:
        /* Cotaá∆o entre Indicadores Econìmicos n∆o encontrada ! */
        run pi_messages (input "show",
                         input 358,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            entry(2,v_cod_return), entry(3,v_cod_return), entry(4,v_cod_return), entry(5,v_cod_return))) /*msg_358*/.
        return error.
    end /* if */.
END PROCEDURE. /* pi_vld_valores_apres_apb_acr */
/*****************************************************************************
** Procedure Interna.....: pi_atualizar_data_fluxo
** Descricao.............: pi_atualizar_data_fluxo
** Criado por............: Alexsandra
** Criado em.............: 18/09/1996 09:50:09
** Alterado por..........: Menna
** Alterado em...........: 10/11/1998 16:57:59
*****************************************************************************/
PROCEDURE pi_atualizar_data_fluxo:

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
    def input-output param p_dat_fluxo
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    if not avail estabelecimento
    or  estabelecimento.cod_estab <> p_cod_estab then
        find estabelecimento no-lock
            where estabelecimento.cod_estab = p_cod_estab no-error.

    if  not avail pais
    or  emscad.pais.cod_pais <> estabelecimento.cod_pais then
        find pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais no-error.

    if  not avail calend_glob
    or  calend_glob.cod_calend <> estabelecimento.cod_calend_financ then
        find calend_glob no-lock
            where calend_glob.cod_calend = estabelecimento.cod_calend_financ no-error.

    block:
    repeat:
        find dia_calend_glob no-lock
            where dia_calend_glob.cod_calend = calend_glob.cod_calend
              and dia_calend_glob.dat_calend = p_dat_fluxo
              use-index dclndglb_id no-error.
        if  not avail dia_calend_glob
        then do:
            find fer_nac no-lock
                where fer_nac.cod_pais    = pais.cod_pais
                  and fer_nac.dat_fer_nac = p_dat_fluxo no-error.
            if  avail fer_nac then
                assign p_dat_fluxo = p_dat_fluxo + 1.
            else 
                undo block, leave block.
        end /* if */.
        else do:
            if  dia_calend_glob.log_dia_util = no then
                assign p_dat_fluxo = p_dat_fluxo + 1.
            else do:
                find fer_nac no-lock
                    where fer_nac.cod_pais    = pais.cod_pais
                      and fer_nac.dat_fer_nac = p_dat_fluxo no-error.
                if  avail fer_nac then
                    assign p_dat_fluxo = p_dat_fluxo + 1.
                else
                    undo block, leave block.
            end /* else */.
        end /* else */.
    end /* repeat block */.
END PROCEDURE. /* pi_atualizar_data_fluxo */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_econ_corren_estab
** Descricao.............: pi_retornar_finalid_econ_corren_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41061
** Alterado em...........: 27/04/2009 08:43:48
*****************************************************************************/
PROCEDURE pi_retornar_finalid_econ_corren_estab:

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
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab
         use-index stblcmnt_id no-error.
    if  avail estabelecimento
    then do:
       find emscad.pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais
             no-error.
       assign p_cod_finalid_econ = pais.cod_finalid_econ_pais.
    end.
END PROCEDURE. /* pi_retornar_finalid_econ_corren_estab */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_titulo_gera_avdeb
** Descricao.............: pi_verificar_titulo_gera_avdeb
** Criado por............: Klug
** Criado em.............: 11/11/1998 10:36:31
** Alterado por..........: Klug
** Alterado em...........: 12/11/1998 09:31:31
*****************************************************************************/
PROCEDURE pi_verificar_titulo_gera_avdeb:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_tit_acr
        for tit_acr.
    &endif


    /*************************** Buffer Definition End **************************/

    /* --- Procura os Avisos de dÇbito do movimento ---*/
    block1:
    for each relacto_tit_acr no-lock
        where relacto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
        and   relacto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr:

        find b_tit_acr no-lock
            where b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
            and   b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr no-error.
        if  avail b_tit_acr
        and b_tit_acr.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/ 
        then do:
            return "AVDB" /*l_avdb*/ .
        end /* if */.
    end /* for block1 */.

    return "NOK" /*l_nok*/ .

END PROCEDURE. /* pi_verificar_titulo_gera_avdeb */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_juros_compostos
** Descricao.............: pi_retorna_juros_compostos
** Criado por............: bre18490
** Criado em.............: 12/01/2001 21:09:04
** Alterado por..........: bre18490
** Alterado em...........: 21/05/2001 11:27:35
*****************************************************************************/
PROCEDURE pi_retorna_juros_compostos:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_calc_juros
        as character
        format "X(10)"
        no-undo.
    def Input param p_val_perc_juros_acr
        as decimal
        format ">>9.99"
        decimals 2
        no-undo.
    def Input param p_val_principal
        as decimal
        format ">>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_num_dias_atraso
        as integer
        format ">9"
        no-undo.
    def output param p_val_juros_aux
        as decimal
        format ">>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_cont
        as integer
        format ">,>>9":U
        initial 0
        no-undo.
    def var v_val_juros_calc_aux
        as decimal
        format "->>,>>>,>>9.999999":U
        decimals 6
        no-undo.


    /************************** Variable Definition End *************************/

    if  p_ind_tip_calc_juros <> "Compostos" /*l_compostos*/  then do:
        assign p_val_juros_aux = ?.
        return.
    end.

    do  v_num_cont = 1 to p_num_dias_atraso:
        assign v_val_juros_calc_aux = v_val_juros_calc_aux + ((p_val_principal + v_val_juros_calc_aux) * p_val_perc_juros_acr / 100 ).
    end.

    assign p_val_juros_aux = v_val_juros_calc_aux.

END PROCEDURE. /* pi_retorna_juros_compostos */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_vendor
** Descricao.............: pi_verifica_vendor
** Criado por............: bre19062
** Criado em.............: 15/09/2002 17:37:36
** Alterado por..........: bre19062
** Alterado em...........: 15/09/2002 17:38:53
*****************************************************************************/
PROCEDURE pi_verifica_vendor:


    /* Begin_Include: i_vrf_modul_vendor */
    /* ==> MODULO VENDOR <== */

    /* ** Verifica se o m¢dulo de vendor por ser utilizado ***/
    /* VALIDAÄ«O DE LICENÄA DO M‡DULO VENDOR */
    assign v_log_modul_vendor = no.
    &IF  "{&emsfin_version}" /*l_{&emsfin_version}*/  >= '5.05' &THEN 
        run prgfin/acr/acr930za.py (output v_log_modul_vendor) /*prg_fnc_verifica_liberacao_vendor*/.
    &ENDIF
    /* End_Include: i_vrf_modul_vendor */

END PROCEDURE. /* pi_verifica_vendor */
/*****************************************************************************
** Procedure Interna.....: pi_vld_permissao_usuar_estab_empres
** Descricao.............: pi_vld_permissao_usuar_estab_empres
** Criado por............: bre18732
** Criado em.............: 21/06/2002 16:19:21
** Alterado por..........: fut42625
** Alterado em...........: 28/01/2011 14:51:30
*****************************************************************************/
PROCEDURE pi_vld_permissao_usuar_estab_empres:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_reg_corporat
        as logical
        format "Sim/N∆o"
        initial no
        view-as toggle-box
        label "Registro Corporativo"
        column-label "Registro Corporativo"
        no-undo.
    def var v_log_restric_estab
        as logical
        format "Sim/N∆o"
        initial no
        view-as toggle-box
        label "Usa Segur Estab"
        column-label "Usa Segur Estab"
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_vld_permissao_usuar_estab_empres */
    find last param_geral_apb no-lock no-error.
    if avail param_geral_apb then 
        assign v_log_reg_corporat = param_geral_apb.log_reg_corporat.

    assign v_log_restric_estab = no.
    &IF DEFINED(BF_FIN_SEGUR_ESTABELEC) &THEN
        case p_cod_modul_dtsul:
            when "ACR" /*l_acr*/  then do:
                find last param_geral_acr no-lock no-error.
                if avail param_geral_acr then
                    assign v_log_restric_estab = param_geral_acr.log_restric_estab.
            end.
            when "APB" /*l_apb*/  then do:
                find last param_geral_apb no-lock no-error.
                if avail param_geral_apb then
                    assign v_log_restric_estab = param_geral_apb.log_restric_estab.
            end.
            otherwise
                assign v_log_restric_estab = no.
        end case.
    &ELSE
        if v_log_reg_corporat then
            assign v_log_restric_estab = yes.
    &ENDIF
    /* End_Include: i_vld_permissao_usuar_estab_empres */


    for each tt_usuar_grp_usuar.
        delete tt_usuar_grp_usuar.
    end.

    /* Cria TT com os grupos de usu†rios */
    for each usuar_grp_usuar where 
             usuar_grp_usuar.cod_usuario = v_cod_usuar_corren no-lock:
        find first tt_usuar_grp_usuar where 
                   tt_usuar_grp_usuar.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar
               and tt_usuar_grp_usuar.cod_usuario   = usuar_grp_usuar.cod_usuario no-lock no-error.
        if not avail tt_usuar_grp_usuar then do:
            create tt_usuar_grp_usuar.
            buffer-copy usuar_grp_usuar to tt_usuar_grp_usuar.
        end.
    end.
    /* Cria Grupo '*' */
    find first tt_usuar_grp_usuar where 
               tt_usuar_grp_usuar.cod_grp_usuar = "*"
           and tt_usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren no-lock no-error.
    if not avail tt_usuar_grp_usuar then do:
        create tt_usuar_grp_usuar.
        assign tt_usuar_grp_usuar.cod_grp_usuar = "*"
               tt_usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren.
    end.

    for each tt_empresa:
        delete tt_empresa.

    end.

    if v_log_reg_corporat = yes then do:
        for each emscad.empresa no-lock:
            for each tt_usuar_grp_usuar:
                /* Verifica se o Usu†rio tem permiss∆o na Empresa */
                if not can-find(first segur_unid_organ where
                                      segur_unid_organ.cod_unid_organ = empresa.cod_empresa 
                                 and (segur_unid_organ.cod_grp_usuar  = tt_usuar_grp_usuar.cod_grp_usuar
                                  or  segur_unid_organ.cod_grp_usuar  = "*")) then 
                   next.

                create tt_empresa.
                assign tt_empresa.tta_cod_empresa = empresa.cod_empresa.
                leave.
            end.
        end.
    end.
    else do:
        create tt_empresa.
        assign tt_empresa.tta_cod_empresa = v_cod_empres_usuar.
    end.

    for each tt_estabelecimento_empresa:
        delete tt_estabelecimento_empresa.
    end.

    for each tt_empresa no-lock:
        for each estabelecimento where 
                 estabelecimento.cod_empresa = tt_empresa.tta_cod_empresa no-lock:
            if v_log_restric_estab then do:
                for each tt_usuar_grp_usuar:
                   /* Verifica se o Usu†rio tem permiss∆o no Estabelecimento */
                    if not can-find(first segur_unid_organ where
                                            segur_unid_organ.cod_unid_organ = estabelecimento.cod_estab
                                       and (segur_unid_organ.cod_grp_usuar  = tt_usuar_grp_usuar.cod_grp_usuar
                                         or segur_unid_organ.cod_grp_usuar  = "*")) then 
                        next.

                    create tt_estabelecimento_empresa. 
                    assign tt_estabelecimento_empresa.tta_cod_estab   = estabelecimento.cod_estab
                           tt_estabelecimento_empresa.tta_nom_pessoa  = estabelecimento.nom_pessoa
                           tt_estabelecimento_empresa.tta_cod_empresa = estabelecimento.cod_empresa. 
                    leave.
                end.
            end.
            else do:
                create tt_estabelecimento_empresa. 
                assign tt_estabelecimento_empresa.tta_cod_estab   = estabelecimento.cod_estab
                       tt_estabelecimento_empresa.tta_nom_pessoa  = estabelecimento.nom_pessoa
                       tt_estabelecimento_empresa.tta_cod_empresa = estabelecimento.cod_empresa. 
            end.
        end.
    end.

    assign v_des_estab_select = "".
    for each tt_estabelecimento_empresa:
        if v_des_estab_select = "" then
            assign v_des_estab_select = tt_estabelecimento_empresa.tta_cod_estab.
        else
            assign v_des_estab_select = v_des_estab_select + "," + tt_estabelecimento_empresa.tta_cod_estab.
    end.
END PROCEDURE. /* pi_vld_permissao_usuar_estab_empres */
/*****************************************************************************
** Procedure Interna.....: pi_vld_estab_select
** Descricao.............: pi_vld_estab_select
** Criado por............: fut42625_3
** Criado em.............: 14/02/2011 14:06:27
** Alterado por..........: fut42625_3
** Alterado em...........: 14/02/2011 15:41:29
*****************************************************************************/
PROCEDURE pi_vld_estab_select:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_modul
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_estab_select_aux
        as character
        format "x(2000)":U
        view-as editor max-chars 2000 no-word-wrap
        size 30 by 1
        bgcolor 15 font 2
        no-undo.
    def var v_num_cont_2
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* ===  Verificar se o usu†rio possui permiss∆o nos estabelecintos selecionados  === */
    assign v_des_estab_select_aux = v_des_estab_select.

    run pi_vld_permissao_usuar_estab_empres (Input p_cod_modul).
    assign v_des_estab_select = "" /*l_null*/ .

    do v_num_cont_2 = 1 to num-entries(v_des_estab_select_aux):
        find first estabelecimento no-lock
           where estabelecimento.cod_estab = entry(v_num_cont_2, v_des_estab_select_aux) no-error.
        if avail estabelecimento then do:
            if can-find(first tt_estabelecimento_empresa 
                where tt_estabelecimento_empresa.tta_cod_estab = estabelecimento.cod_estab) then do:
                if v_des_estab_select = "" then
                    assign v_des_estab_select = estabelecimento.cod_estab.
                else
                    assign v_des_estab_select = v_des_estab_select + "," + estabelecimento.cod_estab.
            end.
        end.
    end.
END PROCEDURE. /* pi_vld_estab_select */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_print_editor
**  Descricao........: Imprime editores nos relat¢rios
*****************************************************************************/
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
END PROCEDURE.  /* pi_print_editor */

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
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*******************  End of rpt_movto_tit_acr_contr_juros ******************/
