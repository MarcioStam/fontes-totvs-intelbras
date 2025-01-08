/*****************************************************************************
** Programa..............: rpt_tit_ap_impl_period
** Descricao.............: Base Demonstrativo T°tulo do Contas a Pa
** Versao................:  1.00.00.001
** Procedimento..........: rel_tit_ap_impl_period
** Nome Externo..........: esp/apb/esapb015.p
*****************************************************************************/
DEFINE BUFFER histor_exec_especial FOR emscad.histor_exec_especial.

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_empresa_selec no-undo like emscad.empresa
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_cod_empresa                   is primary unique
          tta_cod_empresa                  ascending
    .

def temp-table tt_espec_docto no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    index tt_espec_docto                  
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

def temp-table tt_tit_ap_impl_period no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_origin_tit_ap            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field ttv_val_orig_tit_ap_apres        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Original Apres" column-label "Valor Original Apres"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_dttrans                      
          tta_dat_transacao                ascending
    index tt_emis                         
          tta_dat_emis_docto               ascending
    index tt_estab                         is primary
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_forn                         
          tta_cdn_fornecedor               ascending
    index tt_titulo                       
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_trans                        
          tta_cod_estab                    ascending
          tta_dat_transacao                ascending
    index tt_venc                         
          tta_dat_vencto_tit_ap            ascending
    .

def temp-table tt_tot_tit_ap_impl_period no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field ttv_val_tot_movto                as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Total" column-label "Valor Total"
    field ttv_num_ord_reg                  as integer format ">>9" label "Ordem Registro" column-label "Ordem Registro"
    index tt_estab                         is primary
          tta_cod_estab                    ascending
          tta_dat_transacao                ascending
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
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_segur_unid_organ
    for segur_unid_organ.
&endif
&if "{&emsbas_version}" >= "1.00" &then
def buffer b_servid_exec_style
    for servid_exec.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_unid_organ
    for unid_organ.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

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
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
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
def var v_cod_espec_docto_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "C¢digo Final"
    no-undo.
def var v_cod_espec_docto_ini
    as character
    format "x(3)":U
    label "EspÇcie"
    column-label "C¢digo Inicial"
    no-undo.
def var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
def var v_cod_estab_ini
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
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
def var v_cod_indic_econ_base
    as character
    format "x(8)":U
    label "Moeda Base"
    column-label "Moeda Base"
    no-undo.
def var v_cod_indic_econ_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def var v_cod_indic_econ_ini
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
def var v_cod_origem
    as character
    format "x(8)":U
    initial "Tudo" /*l_tudo*/
    label "Origem"
    column-label "Origem"
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
def new shared var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_tit_ap_final
    as character
    format "x(10)":U
    initial "ZZZZZZZZZZ"
    label "atÇ"
    no-undo.
def var v_cod_tit_ap_inicial
    as character
    format "x(10)":U
    label "T°tulo"
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
def var v_dat_emis_docto_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_dat_emis_docto_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Emiss∆o"
    column-label "Emiss∆o"
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
def var v_dat_impl_tit_ap
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def var v_dat_transacao_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Final"
    no-undo.
def var v_dat_transacao_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Transaá∆o"
    column-label "Data Transaá∆o"
    no-undo.
def var v_dat_vencto_final
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Final"
    no-undo.
def var v_dat_vencto_inicial
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Vencimento"
    column-label "Data Vencimento"
    no-undo.
def var v_des_erro_aux
    as character
    format "x(200)":U
    label "Erro RPC AUX"
    column-label "Erro"
    no-undo.
def var v_des_erro_rpc
    as character
    format "x(200)":U
    label "Erro RPC"
    column-label "Erro RPC"
    no-undo.
def new shared var v_des_estab_select
    as character
    format "x(2000)":U
    view-as editor max-chars 2000
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
def var v_ind_classif_tit_ap_impl_period
    as character
    format "X(08)":U
    initial "Por Estabelecimento/Implantaá∆o" /*l_por_estabelecimentoimplantacao*/
    view-as radio-set vertical
    radio-buttons "Por Estabelecimento/Implantaá∆o", "Por Estabelecimento/Implantaá∆o","Por Implantaá∆o/Estabelecimento", "Por Implantaá∆o/Estabelecimento"
     /*l_por_estabelecimentoimplantacao*/ /*l_por_estabelecimentoimplantacao*/ /*l_por_implantacao_estabeleciment*/ /*l_por_implantacao_estabeleciment*/
    bgcolor 8 
    no-undo.
def var v_ind_dwb_run_mode
    as character
    format "X(07)":U
    initial "On-Line" /*l_online*/
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line","Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    label "Run Mode"
    column-label "Run Mode"
    no-undo.
def var v_log_criac_reg
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def new global shared var v_log_execution
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_habilita_con_corporat
    as logical
    format "Sim/N∆o"
    initial no
    label "Habilita Consulta"
    column-label "Habilita Consulta"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_mostra_docto_apb_antecip
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Antecipaá∆o"
    column-label "Antecipaá∆o"
    no-undo.
def var v_log_mostra_docto_apb_impto
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Imposto Retido"
    column-label "Imposto Retido"
    no-undo.
def var v_log_mostra_docto_apb_nf
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Nota Fiscal"
    column-label "Nota Fiscal"
    no-undo.
def var v_log_mostra_docto_apb_normal
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Normal"
    column-label "Normal"
    no-undo.
def var v_log_mostra_docto_apb_prev
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Previs∆o"
    column-label "Previs∆o"
    no-undo.
def var v_log_mostra_docto_apb_provis
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Provis∆o"
    column-label "Provis∆o"
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
def var v_log_quebra_fornec
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    label "Por Fornecedor"
    no-undo.
def var v_log_rpc
    as logical
    format "Sim/N∆o"
    initial no
    label "RPC"
    column-label "RPC"
    no-undo.
def var v_log_tit_fornec_cartcred
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_tit_fornec_compra
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_nom_abrev
    as character
    format "x(15)":U
    label "Nome Abreviado"
    column-label "Nome Abrev"
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
def var v_num_cont_aux
    as integer
    format ">9":U
    no-undo.
def var v_num_count
    as integer
    format ">>>>,>>9":U
    no-undo.
def new shared var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
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
def new global shared var v_rec_finalid_econ
    as recid
    format ">>>>>>9":U
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
def var v_val_cotac_indic_econ
    as decimal
    format "->>,>>>,>>>,>>9.9999999999":U
    decimals 10
    label "Cotaá∆o"
    column-label "Cotaá∆o"
    no-undo.
def var v_val_tot
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Total Geral"
    column-label "Total Geral"
    no-undo.
def var v_val_tot_dat_impl_tit_ap
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
def var v_wgh_servid_rpc
    as widget-handle
    format ">>>>>>9":U
    label "Handle RPC"
    column-label "Handle RPC"
    no-undo.
def var v_val_tot_estab                  as decimal         no-undo. /*local*/


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

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
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_dimensions
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
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
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
def button bt_zoo_208298
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_208299
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_208304
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_208305
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

/************************ Combo-Box Definition Begin ************************/

def var cb_origem
    as character
    format "x(5)"
    initial "Tudo"
    view-as combo-box
    list-items "Tudo","APB","ACR","EEC","EXP","PED","REC"
     /*l_tudo*/ /*l_apb*/ /*l_acr*/ /*l_eec*/ /*l_exp*/ /*l_ped*/ /*l_rec*/
    inner-lines 7
    bgcolor 15 font 2
    no-undo.


/************************* Combo-Box Definition End *************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_cod_dwb_output
    as character
    initial "Terminal"
    view-as radio-set Horizontal
    radio-buttons "Terminal", "Terminal","Arquivo", "Arquivo","Impressora", "Impressora"
     /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
    bgcolor 8 
    no-undo.
def var rs_ind_run_mode
    as character
    initial "On-Line"
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line","Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 172.
def new shared var v_rpt_s_1_bottom as integer initial 65.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "T°tulos Implantados Per°odo - Somente APB".
def frame f_rpt_s_1_header_period header
    "----------------------------------------------------------------------------------------------------------------------------" at 1
    "P†gina:" at 126
    (page-number (s_1) + v_rpt_s_1_page) at 133 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    v_nom_report_title at 98 format "x(40)" skip
    "Per°odo: " at 1
    v_dat_inic_period at 10 format "99/99/9999"
    "A" at 21
    v_dat_fim_period at 23 format "99/99/9999"
    "--------------------------------------------------------------------------------------" at 34
    v_dat_execution at 121 format "99/99/9999" "- "
    v_hra_execution at 134 format "99:99" skip (1)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "----------------------------------------------------------------------------------------------------------------------------" at 1
    'P†gina:' at 126
    (page-number (s_1) + v_rpt_s_1_page) at 133 format '>>>>>9' skip
    v_nom_enterprise at 1 format 'x(40)'
    v_nom_report_title at 99 format 'x(40)' skip
    '-----------------------------------------------------------------------------------------------------------------------' at 1
    v_dat_execution at 121 format '99/99/9999' '- '
    v_hra_execution at 134 format "99:99" skip (1)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    "Èltima p†gina " at 1
    "----------------------------------------------------------------------------------------------------" at 15
    v_nom_prog_ext at 116 format "x(08)" "- "
    v_cod_release at 127 format "x(12)" skip
    with no-box no-labels width 138 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    "-----------------------------------------------------------------------------------------------------------------" at 1
    "- " at 114
    v_nom_prog_ext at 116 format "x(08)" "- "
    v_cod_release at 127 format "x(12)" skip
    with no-box no-labels width 138 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    "P†gina ParÉmetros " at 1
    "------------------------------------------------------------------------------------------------" at 19
    v_nom_prog_ext at 116 format "x(08)" "- "
    v_cod_release at 127 format "x(12)" skip
    with no-box no-labels width 138 page-bottom stream-io.
def frame f_rpt_s_1_Grp_brancos_Lay_branco header skip (1)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_detalhe_lay_data header
    "Dat Transac" at 1
    "Est" at 13
    "Esp" at 17
    "Ser" at 21
    "Fornec" to 35
    "Nome Abrev" at 37
    "T°tulo" at 53
    "/P" at 64
    "Emiss∆o" at 67
    "Vencto" at 78
    "Moeda" at 89
    "Vl Original" to 117
    "Valor Original Apres" to 138 skip
    "-----------" at 1
    "---" at 13
    "---" at 17
    "---" at 21
    "-----------" to 35
    "---------------" at 37
    "----------" at 53
    "--" at 64
    "----------" at 67
    "----------" at 78
    "--------" at 89
    "--------------------" to 117
    "--------------------" to 138 skip
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_detalhe_Lay_estab header
    "Est" at 1
    "Esp" at 5
    "Ser" at 9
    "Fornecedor" to 23
    "Nome Abrev" at 25
    "T°tulo" at 41
    "/P" at 52
    "Emiss∆o" at 55
    "Dat Transac" at 66
    "Vencto" at 78
    "Moeda" at 89
    "Valor Original" to 117
    "Valor Original Apres" to 138 skip
    "---" at 1
    "---" at 5
    "---" at 9
    "-----------" to 23
    "---------------" at 25
    "----------" at 41
    "--" at 52
    "----------" at 55
    "-----------" at 66
    "----------" at 78
    "--------" at 89
    "--------------------" to 117
    "--------------------" to 138 skip
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_Grp_det_forn_Lay_data_forn header
    /* Atributo tt_tit_ap_impl_period.tta_dat_transacao ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_estab ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_espec_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_ser_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_parcela ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_dat_emis_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_dat_vencto_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_indic_econ ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_val_origin_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres ignorado */ skip (1)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_Grp_det_forn_Lay_estab header
    /* Atributo tt_tit_ap_impl_period.tta_cod_estab ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_espec_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_ser_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_parcela ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_dat_emis_docto ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_dat_transacao ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_dat_vencto_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_cod_indic_econ ignorado */
    /* Atributo tt_tit_ap_impl_period.tta_val_origin_tit_ap ignorado */
    /* Atributo tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres ignorado */ skip (1)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_param_lay_param header
    skip (1)
    "-----------------------------" at 30
    "Visualizaá∆o" at 60
    "-----------------------------" at 73
    skip (1)
    "    Finalidade Econìmica: " at 42
    v_cod_finalid_econ at 68 format "x(10)" view-as text skip
    "Finalid Apresentaá∆o: " at 46
    v_cod_finalid_econ_apres at 68 format "x(10)" view-as text skip
    "Data Cotaá∆o: " at 54
    v_dat_cotac_indic_econ at 68 format "99/99/9999" view-as text
    skip (1)
    "-----------------------------" at 28
    "EspÇcie Documento" at 58
    "-----------------------------" at 76
    skip (1)
    "  Normal: " at 58
    v_log_mostra_docto_apb_normal at 68 format "Sim/N∆o" view-as text skip
    "   Nota Fiscal: " at 52
    v_log_mostra_docto_apb_nf at 68 format "Sim/N∆o" view-as text skip
    "   Imposto Retido: " at 49
    v_log_mostra_docto_apb_impto at 68 format "Sim/N∆o" view-as text skip
    "  Previs∆o: " at 56
    v_log_mostra_docto_apb_prev at 68 format "Sim/N∆o" view-as text skip
    "  Provis∆o: " at 56
    v_log_mostra_docto_apb_provis at 68 format "Sim/N∆o" view-as text skip
    "   Antecipaá∆o: " at 52
    v_log_mostra_docto_apb_antecip at 68 format "Sim/N∆o" view-as text
    skip (1)
    "-----------------------------" at 33
    "Seleá∆o" at 63
    "-----------------------------" at 71
    skip (1)
    "Estabelecimento: " at 45
    v_cod_estab_ini at 62 format "x(3)" view-as text
    "atÇ: " at 77
    v_cod_estab_fim at 82 format "x(3)" view-as text skip
    "  EspÇcie: " at 51
    v_cod_espec_docto_ini at 62 format "x(3)" view-as text
    "atÇ: " at 77
    v_cod_espec_docto_fim at 82 format "x(3)" view-as text skip
    "  Fornecedor: " at 48
    v_cdn_fornecedor_ini to 72 format ">>>,>>>,>>9" view-as text
    "atÇ: " at 77
    v_cdn_fornecedor_fim to 92 format ">>>,>>>,>>9" view-as text skip
    "Data Transaá∆o: " at 46
    v_dat_transacao_ini at 62 format "99/99/9999" view-as text
    "atÇ: " at 77
    v_dat_transacao_fim at 82 format "99/99/9999" view-as text skip
    "  Emiss∆o: " at 51
    v_dat_emis_docto_ini at 62 format "99/99/9999" view-as text
    "atÇ: " at 77
    v_dat_emis_docto_fim at 82 format "99/99/9999" view-as text skip
    " Data Vencimento: " at 44
    v_dat_vencto_inicial at 62 format "99/99/9999" view-as text
    "atÇ: " at 77
    v_dat_vencto_final at 82 format "99/99/9999" view-as text skip
    "  Moeda: " at 53
    v_cod_indic_econ_ini at 62 format "x(8)" view-as text
    "atÇ: " at 77
    v_cod_indic_econ_fim at 82 format "x(8)" view-as text skip
    "  Origem: " at 52
    v_cod_origem at 62 format "x(8)" view-as text skip (4)
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_totais_lay_dat_impl header
    "Total do Dia   " at 84
    v_dat_impl_tit_ap at 100 format "99/99/9999" view-as text
    ":" at 110
    v_val_tot_dat_impl_tit_ap to 132 format ">,>>>,>>>,>>>,>>9.99" view-as text skip
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_totais_lay_estabelec header
    "Total do Estabelecimento:" at 85
    ":" at 110
    /* Vari†vel v_val_tot_estab ignorada. N∆o esta definida no programa */ skip
    with no-box no-labels width 138 page-top stream-io.
def frame f_rpt_s_1_grp_totais_lay_geral header
    "Total Geral:" at 99
    v_val_tot to 132 format ">,>>>,>>>,>>>,>>9.99" view-as text skip
    with no-box no-labels width 138 page-top stream-io.


/*************************** Report Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_rpt_41_tit_ap_impl_period
    rt_003
         at row 01.38 col 34.00
    " Seleá∆o " view-as text
         at row 01.08 col 36.00 bgcolor 8 
    rt_002
         at row 01.38 col 02.00
    " Apresentaá∆o " view-as text
         at row 01.08 col 04.00 bgcolor 8 
    rt_001
         at row 05.75 col 02.00
    " Tipo EspÇcie " view-as text
         at row 05.45 col 04.00 bgcolor 8 
    rt_target
         at row 13.04 col 02.00
    " Destino " view-as text
         at row 12.74 col 04.00 bgcolor 8 
    rt_run
         at row 13.04 col 48.00
    " Execuá∆o " view-as text
         at row 12.74 col 50.00
    rt_dimensions
         at row 13.04 col 72.72
    " Dimens‰es " view-as text
         at row 12.74 col 74.72
    rt_004
         at row 09.75 col 28.00
    " Classificaá∆o " view-as text
         at row 09.45 col 30.00 bgcolor 8 
    rt_005
         at row 09.75 col 02.00
    " Compras Cart∆o CrÇdito " view-as text
         at row 09.45 col 04.00 bgcolor 8 
    rt_006
         at row 09.75 col 70.72
    " Origem " view-as text
         at row 09.45 col 72.72 bgcolor 8 
    rt_cxcf
         at row 16.54 col 02.00 bgcolor 7 
    v_cod_finalid_econ
         at row 02.13 col 15.00 colon-aligned label "Finalidade"
         help "Finalidade Econìmica"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_208304
         at row 02.13 col 28.14
    v_cod_finalid_econ_apres
         at row 03.13 col 15.00 colon-aligned label "Apresentaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_208305
         at row 03.13 col 28.14
    v_dat_cotac_indic_econ
         at row 04.13 col 15.00 colon-aligned label "Data Cotaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_mostra_docto_apb_normal
         at row 06.25 col 03.14 label "Normal"
         help "Considera Documentos Normais"
         view-as toggle-box
    v_log_mostra_docto_apb_nf
         at row 07.25 col 03.14 label "Nota Fiscal"
         help "Considera Notas Fiscais"
         view-as toggle-box
    v_log_mostra_docto_apb_impto
         at row 08.25 col 03.14 label "Impto Retido"
         help "Considera Impostos Retidos"
         view-as toggle-box
    v_log_mostra_docto_apb_prev
         at row 06.25 col 19.00 label "Previs∆o"
         help "Considera Previs‰es"
         view-as toggle-box
    v_log_mostra_docto_apb_provis
         at row 07.25 col 19.00 label "Provis∆o"
         help "Considera Provis‰es"
         view-as toggle-box
    v_log_mostra_docto_apb_antecip
         at row 08.25 col 19.00 label "Antecipaá∆o"
         help "Considera Antecipaá‰es"
         view-as toggle-box
    v_cod_estab_ini
         at row 02.25 col 49.57 colon-aligned label "Estabelecimento"
         help "Codigo Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         at row 02.25 col 69.57 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_ini
         at row 03.25 col 49.57 colon-aligned label "EspÇcie"
         help "C¢digo Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_fim
         at row 03.25 col 69.57 colon-aligned label "atÇ"
         help "C¢digo Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_fornecedor_ini
         at row 04.25 col 49.57 colon-aligned label "Fornecedor"
         help "C¢digo Fornecedor"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_208299
         at row 04.25 col 63.71
    v_cdn_fornecedor_fim
         at row 04.25 col 69.57 colon-aligned label "atÇ"
         help "C¢digo Fornecedor"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_208298
         at row 04.25 col 83.71
    v_dat_transacao_ini
         at row 05.25 col 49.57 colon-aligned label "Data Transaá∆o"
         help "Data de Transaá∆o Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_fim
         at row 05.25 col 69.57 colon-aligned label "atÇ"
         help "Data de Transaá∆o Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_docto_ini
         at row 06.25 col 49.57 colon-aligned label "Emiss∆o"
         help "Data Emiss∆o Documento"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_docto_fim
         at row 06.25 col 69.57 colon-aligned label "atÇ"
         help "Data Emiss∆o Documento"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_inicial
         at row 07.25 col 49.57 colon-aligned label "Vencto"
         help "Data de Vencimento Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_final
         at row 07.25 col 69.57 colon-aligned label "atÇ"
         help "Data de Vencimento Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_indic_econ_ini
         at row 08.25 col 49.57 colon-aligned label "Moeda"
         help "Indicador Econìmico Inicial"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_indic_econ_fim
         at row 08.25 col 69.57 colon-aligned label "atÇ"
         help "Indicador Econìmico Final"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_tit_fornec_compra
         at row 10.25 col 03.14 label "T°tulo Fornecedor Compra"
         view-as toggle-box
    v_log_tit_fornec_cartcred
         at row 11.25 col 03.14 label "T°tulo Fornecedor Cart∆o"
         view-as toggle-box
    v_ind_classif_tit_ap_impl_period
         at row 10.38 col 31.43 no-label
         view-as radio-set vertical
         radio-buttons "Por Estabelecimento/Implantaá∆o", "Por Estabelecimento/Implantaá∆o","Por Implantaá∆o/Estabelecimento", "Por Implantaá∆o/Estabelecimento"
          /*l_por_estabelecimentoimplantacao*/ /*l_por_estabelecimentoimplantacao*/ /*l_por_implantacao_estabeleciment*/ /*l_por_implantacao_estabeleciment*/
         bgcolor 8 
    cb_origem
         at row 10.67 col 75.43
         help "" no-label
    rs_cod_dwb_output
         at row 13.75 col 03.00
         help "" no-label
    rs_ind_run_mode
         at row 13.75 col 49.00
         help "" no-label
    v_qtd_line
         at row 13.75 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    ed_1x40
         at row 14.71 col 03.00
         help "" no-label
    bt_get_file
         at row 14.71 col 42.00 font ?
         help "Pesquisa Arquivo"
    bt_set_printer
         at row 14.71 col 42.00 font ?
         help "Define Impressora e Layout de Impress∆o"
    v_log_print_par
         at row 14.75 col 49.00 label "Imprime ParÉmetros"
         view-as toggle-box
    v_qtd_column
         at row 14.75 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_close
         at row 16.75 col 03.00 font ?
         help "Fecha"
    bt_print
         at row 16.75 col 14.00 font ?
         help "Imprime"
    bt_can
         at row 16.75 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 16.75 col 77.57 font ?
         help "Ajuda"
    v_des_estab_select
         at row 02.25 col 49.57 colon-aligned label "Estab Selec"
         help "Estabelecimentos selecionados"
         view-as editor max-chars 2000
         size 30 by 1
         bgcolor 15 font 2
    bt_todos_img
         at row 02.17 col 81.86 font ?
         help "Seleciona Todos"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 18.38
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "esapb015 - T°tulos Implantados Per°odo - Somente APB".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_tit_ap_impl_period = 10.00
           bt_can:height-chars         in frame f_rpt_41_tit_ap_impl_period = 01.00
           bt_close:width-chars        in frame f_rpt_41_tit_ap_impl_period = 10.00
           bt_close:height-chars       in frame f_rpt_41_tit_ap_impl_period = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_tit_ap_impl_period = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_tit_ap_impl_period = 01.08
           bt_hel2:width-chars         in frame f_rpt_41_tit_ap_impl_period = 10.00
           bt_hel2:height-chars        in frame f_rpt_41_tit_ap_impl_period = 01.00
           bt_print:width-chars        in frame f_rpt_41_tit_ap_impl_period = 10.00
           bt_print:height-chars       in frame f_rpt_41_tit_ap_impl_period = 01.00
           bt_set_printer:width-chars  in frame f_rpt_41_tit_ap_impl_period = 04.00
           bt_set_printer:height-chars in frame f_rpt_41_tit_ap_impl_period = 01.08
           bt_todos_img:width-chars    in frame f_rpt_41_tit_ap_impl_period = 04.00
           bt_todos_img:height-chars   in frame f_rpt_41_tit_ap_impl_period = 01.13
           ed_1x40:width-chars         in frame f_rpt_41_tit_ap_impl_period = 38.00
           ed_1x40:height-chars        in frame f_rpt_41_tit_ap_impl_period = 01.00
           rt_001:width-chars          in frame f_rpt_41_tit_ap_impl_period = 32.00
           rt_001:height-chars         in frame f_rpt_41_tit_ap_impl_period = 03.63
           rt_002:width-chars          in frame f_rpt_41_tit_ap_impl_period = 32.00
           rt_002:height-chars         in frame f_rpt_41_tit_ap_impl_period = 04.00
           rt_003:width-chars          in frame f_rpt_41_tit_ap_impl_period = 55.00
           rt_003:height-chars         in frame f_rpt_41_tit_ap_impl_period = 08.00
           rt_004:width-chars          in frame f_rpt_41_tit_ap_impl_period = 39.00
           rt_004:height-chars         in frame f_rpt_41_tit_ap_impl_period = 02.75
           rt_005:width-chars          in frame f_rpt_41_tit_ap_impl_period = 22.72
           rt_005:height-chars         in frame f_rpt_41_tit_ap_impl_period = 02.75
           rt_006:width-chars          in frame f_rpt_41_tit_ap_impl_period = 18.00
           rt_006:height-chars         in frame f_rpt_41_tit_ap_impl_period = 02.75
           rt_cxcf:width-chars         in frame f_rpt_41_tit_ap_impl_period = 86.57
           rt_cxcf:height-chars        in frame f_rpt_41_tit_ap_impl_period = 01.42
           rt_dimensions:width-chars   in frame f_rpt_41_tit_ap_impl_period = 15.72
           rt_dimensions:height-chars  in frame f_rpt_41_tit_ap_impl_period = 03.00
           rt_run:width-chars          in frame f_rpt_41_tit_ap_impl_period = 23.86
           rt_run:height-chars         in frame f_rpt_41_tit_ap_impl_period = 03.00
           rt_target:width-chars       in frame f_rpt_41_tit_ap_impl_period = 45.00
           rt_target:height-chars      in frame f_rpt_41_tit_ap_impl_period = 03.00.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted            in frame f_rpt_41_tit_ap_impl_period = yes
           v_des_estab_select:return-inserted in frame f_rpt_41_tit_ap_impl_period = yes.
    /* set private-data for the help system */
    assign bt_zoo_208304:private-data                    in frame f_rpt_41_tit_ap_impl_period = "HLP=000009431":U
           v_cod_finalid_econ:private-data               in frame f_rpt_41_tit_ap_impl_period = "HLP=000014662":U
           bt_zoo_208305:private-data                    in frame f_rpt_41_tit_ap_impl_period = "HLP=000009431":U
           v_cod_finalid_econ_apres:private-data         in frame f_rpt_41_tit_ap_impl_period = "HLP=000014663":U
           v_dat_cotac_indic_econ:private-data           in frame f_rpt_41_tit_ap_impl_period = "HLP=000012264":U
           v_log_mostra_docto_apb_normal:private-data    in frame f_rpt_41_tit_ap_impl_period = "HLP=000014654":U
           v_log_mostra_docto_apb_nf:private-data        in frame f_rpt_41_tit_ap_impl_period = "HLP=000014655":U
           v_log_mostra_docto_apb_impto:private-data     in frame f_rpt_41_tit_ap_impl_period = "HLP=000014656":U
           v_log_mostra_docto_apb_prev:private-data      in frame f_rpt_41_tit_ap_impl_period = "HLP=000014657":U
           v_log_mostra_docto_apb_provis:private-data    in frame f_rpt_41_tit_ap_impl_period = "HLP=000014658":U
           v_log_mostra_docto_apb_antecip:private-data   in frame f_rpt_41_tit_ap_impl_period = "HLP=000014659":U
           v_cod_estab_ini:private-data                  in frame f_rpt_41_tit_ap_impl_period = "HLP=000016633":U
           v_cod_estab_fim:private-data                  in frame f_rpt_41_tit_ap_impl_period = "HLP=000016634":U
           v_cod_espec_docto_ini:private-data            in frame f_rpt_41_tit_ap_impl_period = "HLP=000016628":U
           v_cod_espec_docto_fim:private-data            in frame f_rpt_41_tit_ap_impl_period = "HLP=000016629":U
           bt_zoo_208299:private-data                    in frame f_rpt_41_tit_ap_impl_period = "HLP=000009431":U
           v_cdn_fornecedor_ini:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000018870":U
           bt_zoo_208298:private-data                    in frame f_rpt_41_tit_ap_impl_period = "HLP=000009431":U
           v_cdn_fornecedor_fim:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000018871":U
           v_dat_transacao_ini:private-data              in frame f_rpt_41_tit_ap_impl_period = "HLP=000022343":U
           v_dat_transacao_fim:private-data              in frame f_rpt_41_tit_ap_impl_period = "HLP=000022341":U
           v_dat_emis_docto_ini:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000014636":U
           v_dat_emis_docto_fim:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000014637":U
           v_dat_vencto_inicial:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000022406":U
           v_dat_vencto_final:private-data               in frame f_rpt_41_tit_ap_impl_period = "HLP=000022407":U
           v_cod_indic_econ_ini:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000018872":U
           v_cod_indic_econ_fim:private-data             in frame f_rpt_41_tit_ap_impl_period = "HLP=000018873":U
           v_log_tit_fornec_compra:private-data          in frame f_rpt_41_tit_ap_impl_period = "HLP=000022410":U
           v_log_tit_fornec_cartcred:private-data        in frame f_rpt_41_tit_ap_impl_period = "HLP=000022411":U
           v_ind_classif_tit_ap_impl_period:private-data in frame f_rpt_41_tit_ap_impl_period = "HLP=000022409":U
           cb_origem:private-data                        in frame f_rpt_41_tit_ap_impl_period = "HLP=000020107":U
           rs_cod_dwb_output:private-data                in frame f_rpt_41_tit_ap_impl_period = "HLP=000020107":U
           rs_ind_run_mode:private-data                  in frame f_rpt_41_tit_ap_impl_period = "HLP=000020107":U
           v_qtd_line:private-data                       in frame f_rpt_41_tit_ap_impl_period = "HLP=000024737":U
           ed_1x40:private-data                          in frame f_rpt_41_tit_ap_impl_period = "HLP=000020107":U
           bt_get_file:private-data                      in frame f_rpt_41_tit_ap_impl_period = "HLP=000008782":U
           bt_set_printer:private-data                   in frame f_rpt_41_tit_ap_impl_period = "HLP=000008785":U
           v_log_print_par:private-data                  in frame f_rpt_41_tit_ap_impl_period = "HLP=000024662":U
           v_qtd_column:private-data                     in frame f_rpt_41_tit_ap_impl_period = "HLP=000024669":U
           bt_close:private-data                         in frame f_rpt_41_tit_ap_impl_period = "HLP=000009420":U
           bt_print:private-data                         in frame f_rpt_41_tit_ap_impl_period = "HLP=000010815":U
           bt_can:private-data                           in frame f_rpt_41_tit_ap_impl_period = "HLP=000011050":U
           bt_hel2:private-data                          in frame f_rpt_41_tit_ap_impl_period = "HLP=000011326":U
           v_des_estab_select:private-data               in frame f_rpt_41_tit_ap_impl_period = "HLP=000020107":U
           bt_todos_img:private-data                     in frame f_rpt_41_tit_ap_impl_period = "HLP=000021504":U
           frame f_rpt_41_tit_ap_impl_period:private-data                                     = "HLP=000020107".
    /* enable function buttons */
    assign bt_zoo_208304:sensitive in frame f_rpt_41_tit_ap_impl_period = yes
           bt_zoo_208305:sensitive in frame f_rpt_41_tit_ap_impl_period = yes
           bt_zoo_208299:sensitive in frame f_rpt_41_tit_ap_impl_period = yes
           bt_zoo_208298:sensitive in frame f_rpt_41_tit_ap_impl_period = yes.




{include/i_fclfrm.i f_rpt_41_tit_ap_impl_period }
/*************************** Frame Definition End ***************************/

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
def var v_prog_filtro_pdf as handle no-undo.

function getCodTipoRelat returns character in v_prog_filtro_pdf.

run prgtec/btb/btb920aa.py persistent set v_prog_filtro_pdf.

run pi_define_objetos in v_prog_filtro_pdf (frame f_rpt_41_tit_ap_impl_period:handle,
                       rs_cod_dwb_output:handle in frame f_rpt_41_tit_ap_impl_period,
                       bt_get_file:row in frame f_rpt_41_tit_ap_impl_period,
                       bt_get_file:col in frame f_rpt_41_tit_ap_impl_period).

&endif
/* tech38629 - Fim da alteraá∆o */


/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign dwb_rpt_param.cod_dwb_file             = v_cod_dwb_file
               ed_1x40:screen-value in frame f_rpt_41_tit_ap_impl_period = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_impl_period */

ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    if  input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_normal = no and
        input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_nf = no and
        input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_impto = no and
        input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_prev = no and
        input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_provis = no and
        input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_antecip = no
    then do:
        /* Tipo EspÇcie deve ser informado. */
        run pi_messages (input "show",
                         input 4320,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_4320*/.
        return no-apply.
    end.

    if v_log_habilita_con_corporat = yes 
    and v_des_estab_select = "" then do:

       /* Estabelecimento deve ser informado ! */
       run pi_messages (input "show",
                        input 12,
                        input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_12*/.
       assign v_wgh_focus = bt_todos_img:handle in frame f_rpt_41_tit_ap_impl_period.
       apply "entry" to bt_todos_img in frame f_rpt_41_tit_ap_impl_period.
       return no-apply.
    end.

do:
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
    run pi_restricoes in v_prog_filtro_pdf (input rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_ap_impl_period).
    if return-value = 'nok' then 
        return no-apply.
&endif
/* tech38629 - Fim da alteraá∆o */
    assign v_log_print = yes.
end.
END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_ap_impl_period */

ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_tit_ap_impl_period
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
               ed_1x40:screen-value in frame f_rpt_41_tit_ap_impl_period = v_nom_dwb_printer
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
                with frame f_rpt_41_tit_ap_impl_period.
    end /* if */.

END. /* ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_tit_ap_impl_period */

ON CHOOSE OF bt_todos_img IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    assign input frame f_rpt_41_tit_ap_impl_period v_des_estab_select.
    if  search("prgint/utb/utb071za.r") = ? and search("prgint/utb/utb071za.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb071za.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb071za.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb071za.p /*prg_fnc_estabelecimento_selec_espec*/.
    display v_des_estab_select with frame f_rpt_41_tit_ap_impl_period.
END. /* ON CHOOSE OF bt_todos_img IN FRAME f_rpt_41_tit_ap_impl_period */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_tit_ap_impl_period:
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

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_impl_period */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    initout:
    do with frame f_rpt_41_tit_ap_impl_period:
        /* block: */
        case self:screen-value:
            when "Terminal" /*l_terminal*/ then ter:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_ap_impl_period v_qtd_line.
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
                        with frame f_rpt_41_tit_ap_impl_period.
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = no
                       bt_get_file:visible    = no
                       bt_set_printer:visible = no.
            end /* do ter */.
            when "Arquivo" /*l_file*/ then fil:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_ap_impl_period v_qtd_line.
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
                        with frame f_rpt_41_tit_ap_impl_period.
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

                    if  rs_ind_run_mode:screen-value in frame f_rpt_41_tit_ap_impl_period <> "Batch" /*l_batch*/ 
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
                                                          + caps("esapb015":U)
                                                          + '.rpt'.
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
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_ap_impl_period v_qtd_line.
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
                        with frame f_rpt_41_tit_ap_impl_period.
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
                with frame f_rpt_41_tit_ap_impl_period.
    end /* if */.
    else do:
        enable v_qtd_line
               with frame f_rpt_41_tit_ap_impl_period.
    end /* else */.
    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_impl_period */

ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    do  transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.ind_dwb_run_mode = input frame f_rpt_41_tit_ap_impl_period rs_ind_run_mode.

        if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            if  rs_cod_dwb_output:disable("Terminal" /*l_terminal*/ ) in frame f_rpt_41_tit_ap_impl_period
            then do:
            end /* if */.
        end /* if */.
        else do:
            if  rs_cod_dwb_output:enable("Terminal" /*l_terminal*/ ) in frame f_rpt_41_tit_ap_impl_period
            then do:
            end /* if */.
        end /* else */.
        if  rs_ind_run_mode = "Batch" /*l_batch*/ 
        then do:
           assign v_qtd_line = v_qtd_line_ant.
           display v_qtd_line
                   with frame f_rpt_41_tit_ap_impl_period.
        end /* if */.
        assign rs_ind_run_mode.
        apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_ap_impl_period.
    end.    

END. /* ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_ap_impl_period */

ON LEAVE OF v_cod_finalid_econ IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    if  v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_tit_ap_impl_period = " "
    then do:
        assign v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_tit_ap_impl_period = input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ.
    end /* if */.

    if  input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ_apres = input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ
    then do:
        disable v_dat_cotac_indic_econ
                with frame f_rpt_41_tit_ap_impl_period.
    end /* if */.
    else do:
        enable v_dat_cotac_indic_econ
               with frame f_rpt_41_tit_ap_impl_period.
    end /* else */.
END. /* ON LEAVE OF v_cod_finalid_econ IN FRAME f_rpt_41_tit_ap_impl_period */

ON LEAVE OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_tit_ap_impl_period
DO:

    if  input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ_apres = input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ
    then do:
        disable v_dat_cotac_indic_econ
                with frame f_rpt_41_tit_ap_impl_period.
    end /* if */.
    else do:
        enable v_dat_cotac_indic_econ
               with frame f_rpt_41_tit_ap_impl_period.
    end /* else */.
END. /* ON LEAVE OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_tit_ap_impl_period */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_208298 IN FRAME f_rpt_41_tit_ap_impl_period
OR F5 OF v_cdn_fornecedor_fim IN FRAME f_rpt_41_tit_ap_impl_period DO:

    if v_log_habilita_con_corporat = yes then
        if  search("prgint/utb/utb031na.r") = ? and search("prgint/utb/utb031na.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb031na.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb031na.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb031na.p (Input '') /*prg_see_fornecedor_999*/.
    else
        if  search("prgint/ufn/ufn003nb.r") = ? and search("prgint/ufn/ufn003nb.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn003nb.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/ufn/ufn003nb.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/ufn/ufn003nb.p (Input v_cod_empres_usuar) /*prg_see_fornecedor_financ_empresa*/.

    if  v_rec_fornecedor <> ?
    then do:
        find emscad.fornecedor where recid(fornecedor) = v_rec_fornecedor no-lock no-error.
        assign v_cdn_fornecedor_fim:screen-value in frame f_rpt_41_tit_ap_impl_period =
               string(fornecedor.cdn_fornecedor).

        apply "entry" to v_cdn_fornecedor_fim in frame f_rpt_41_tit_ap_impl_period.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_208298 IN FRAME f_rpt_41_tit_ap_impl_period */

ON  CHOOSE OF bt_zoo_208299 IN FRAME f_rpt_41_tit_ap_impl_period
OR F5 OF v_cdn_fornecedor_ini IN FRAME f_rpt_41_tit_ap_impl_period DO:

    if v_log_habilita_con_corporat = yes then
        if  search("prgint/utb/utb031na.r") = ? and search("prgint/utb/utb031na.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb031na.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb031na.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb031na.p (Input '') /*prg_see_fornecedor_999*/.
    else
        if  search("prgint/ufn/ufn003nb.r") = ? and search("prgint/ufn/ufn003nb.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn003nb.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/ufn/ufn003nb.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/ufn/ufn003nb.p (Input v_cod_empres_usuar) /*prg_see_fornecedor_financ_empresa*/.

    if  v_rec_fornecedor <> ?
    then do:
        find emscad.fornecedor where recid(fornecedor) = v_rec_fornecedor no-lock no-error.
        assign v_cdn_fornecedor_ini:screen-value in frame f_rpt_41_tit_ap_impl_period =
               string(fornecedor.cdn_fornecedor).

        apply "entry" to v_cdn_fornecedor_ini in frame f_rpt_41_tit_ap_impl_period.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_208299 IN FRAME f_rpt_41_tit_ap_impl_period */

ON  CHOOSE OF bt_zoo_208304 IN FRAME f_rpt_41_tit_ap_impl_period
OR F5 OF v_cod_finalid_econ IN FRAME f_rpt_41_tit_ap_impl_period DO:

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
        assign v_cod_finalid_econ:screen-value in frame f_rpt_41_tit_ap_impl_period =
               string(finalid_econ.cod_finalid_econ).

        apply "entry" to v_cod_finalid_econ in frame f_rpt_41_tit_ap_impl_period.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_208304 IN FRAME f_rpt_41_tit_ap_impl_period */

ON  CHOOSE OF bt_zoo_208305 IN FRAME f_rpt_41_tit_ap_impl_period
OR F5 OF v_cod_finalid_econ_apres IN FRAME f_rpt_41_tit_ap_impl_period DO:

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
        find b_finalid_econ where recid(b_finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign v_cod_finalid_econ_apres:screen-value in frame f_rpt_41_tit_ap_impl_period =
               string(b_finalid_econ.cod_finalid_econ).

        apply "entry" to v_cod_finalid_econ_apres in frame f_rpt_41_tit_ap_impl_period.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_208305 IN FRAME f_rpt_41_tit_ap_impl_period */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON GO OF FRAME f_rpt_41_tit_ap_impl_period
DO:

    valida_block:
    do on error undo valida_block, return no-apply:
        assign input frame f_rpt_41_tit_ap_impl_period v_cdn_fornecedor_fim
               input frame f_rpt_41_tit_ap_impl_period v_cdn_fornecedor_ini
               input frame f_rpt_41_tit_ap_impl_period v_cod_espec_docto_fim
               input frame f_rpt_41_tit_ap_impl_period v_cod_espec_docto_ini
               input frame f_rpt_41_tit_ap_impl_period v_cod_estab_fim
               input frame f_rpt_41_tit_ap_impl_period v_cod_estab_ini
               input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ
               input frame f_rpt_41_tit_ap_impl_period v_cod_finalid_econ_apres
               input frame f_rpt_41_tit_ap_impl_period v_cod_indic_econ_fim
               input frame f_rpt_41_tit_ap_impl_period v_cod_indic_econ_ini
               input frame f_rpt_41_tit_ap_impl_period v_dat_cotac_indic_econ
               input frame f_rpt_41_tit_ap_impl_period v_dat_emis_docto_fim
               input frame f_rpt_41_tit_ap_impl_period v_dat_emis_docto_ini
               input frame f_rpt_41_tit_ap_impl_period v_dat_transacao_fim
               input frame f_rpt_41_tit_ap_impl_period v_dat_transacao_ini
               input frame f_rpt_41_tit_ap_impl_period v_dat_vencto_final
               input frame f_rpt_41_tit_ap_impl_period v_dat_vencto_inicial
               input frame f_rpt_41_tit_ap_impl_period v_ind_classif_tit_ap_impl_period
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_antecip
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_impto
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_nf
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_normal
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_prev
               input frame f_rpt_41_tit_ap_impl_period v_log_mostra_docto_apb_provis
               input frame f_rpt_41_tit_ap_impl_period v_log_tit_fornec_compra
               input frame f_rpt_41_tit_ap_impl_period v_log_tit_fornec_cartcred
               input frame f_rpt_41_tit_ap_impl_period v_des_estab_select.
            assign v_cod_origem = cb_origem:screen-value in frame f_rpt_41_tit_ap_impl_period.

            run pi_vld_valores_apres_apb (Input v_cod_finalid_econ,
                                          Input v_cod_finalid_econ_apres,
                                          Input v_dat_cotac_indic_econ,
                                          output v_dat_conver,
                                          output v_val_cotac_indic_econ) /*pi_vld_valores_apres_apb*/.
        if  v_cod_estab_ini       > v_cod_estab_fim
        or  v_cod_espec_docto_ini > v_cod_espec_docto_fim
        or  v_cdn_fornecedor_ini  > v_cdn_fornecedor_fim
        or  v_dat_transacao_ini   > v_dat_transacao_fim
        or  v_dat_emis_docto_ini  > v_dat_emis_docto_fim
        or  v_dat_vencto_inicial  > v_dat_vencto_final
        or  v_cod_indic_econ_ini  > v_cod_indic_econ_fim
        then do:
            /* Seleá∆o Informada Inv†lida ! */
            run pi_messages (input "show",
                             input 4657,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_4657*/.
            return no-apply.
        end /* if */.

        assign dwb_rpt_param.cod_dwb_output   = rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_ap_impl_period.
        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
             run pi_filename_validation (Input dwb_rpt_param.cod_dwb_file) /*pi_filename_validation*/.
             if  dwb_rpt_param.ind_dwb_run_mode <> "Batch" /*l_batch*/ 
             then do:
                 if  index  ( dwb_rpt_param.cod_dwb_file ,'~\') <> 0
                 then do:
                      assign file-info:file-name= substring( dwb_rpt_param.cod_dwb_file ,
                                                             1,
                                                             r-index  ( dwb_rpt_param.cod_dwb_file ,'~\') - 1
                                                            ).
                 end /* if */.
                 else do:
                      assign file-info:file-name= substring( dwb_rpt_param.cod_dwb_file ,
                                                             1,
                                                             r-index  ( dwb_rpt_param.cod_dwb_file ,'/') - 1
                                                            ).
                 end /* else */.

                 if  (  file-info:file-type = ? )
                 and    (  index  ( dwb_rpt_param.cod_dwb_file ,'~\') <> 0
                              or
                           index  ( dwb_rpt_param.cod_dwb_file ,'/')  <> 0
                              or
                           index  ( dwb_rpt_param.cod_dwb_file ,':')  <> 0
                         )
                 then do:
                     /* O diret¢rio &1 n∆o existe ! */
                     run pi_messages (input "show",
                                      input 4354,
                                      input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                         file-info:file-name)) /*msg_4354*/.
                     return no-apply.
                  end /* if */.
             end /* if */.


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
                if  not avail layout_impres
                then do:
                   /* Layout de impress∆o inexistente ! */
                   run pi_messages (input "show",
                                    input 4366,
                                    input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_4366*/.
                   return no-apply.
                end /* if */.
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
    end /* do valida_block */.
END. /* ON GO OF FRAME f_rpt_41_tit_ap_impl_period */

ON ENDKEY OF FRAME f_rpt_41_tit_ap_impl_period
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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

END. /* ON ENDKEY OF FRAME f_rpt_41_tit_ap_impl_period */

ON HELP OF FRAME f_rpt_41_tit_ap_impl_period ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_rpt_41_tit_ap_impl_period */

ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_tit_ap_impl_period ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_tit_ap_impl_period */

ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_tit_ap_impl_period ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_tit_ap_impl_period */

ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_impl_period
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_impl_period */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/



/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
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
    run pi_version_extract ('rpt_tit_ap_impl_period':U, 'esp/apb/esapb015.p':U, '1.00.00.001':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

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
    run prgtec/men/men901za.py (Input 'rpt_tit_ap_impl_period') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_ap_impl_period')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_ap_impl_period')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

/* End_Include: i_log_exec_prog_dtsul_ini */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_permissoes in v_prog_filtro_pdf (input 'rpt_tit_ap_impl_period':U).
&endif
/* tech38629 - Fim da alteraá∆o */




/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "rpt_tit_ap_impl_period":U
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


assign v_wgh_frame_epc = frame f_rpt_41_tit_ap_impl_period:handle.

assign v_nom_table_epc = 'tit_ap':U
       v_rec_table_epc = recid(tit_ap).

&endif

/* End_Include: i_verify_program_epc */


/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_tit_ap_impl_period:title = frame f_rpt_41_tit_ap_impl_period:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).

/* inicializa vari†veis */
find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.
find dwb_rpt_param
     where dwb_rpt_param.cod_dwb_program = "rel_tit_ap_impl_period":U
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
assign v_cod_dwb_proced   = "rel_tit_ap_impl_period":U
       v_cod_dwb_program  = "rel_tit_ap_impl_period":U
       v_cod_release      = trim(" 1.00.00.001":U)
       v_ind_dwb_run_mode = "On-Line" /*l_online*/ 
       v_qtd_column       = v_rpt_s_1_columns
       v_qtd_bottom       = v_rpt_s_1_bottom.
if (avail empresa) then
    assign v_nom_enterprise   = empresa.nom_razao_social.
else
    assign v_nom_enterprise   = 'INTELBRAS'.


/* Begin_Include: ix_p00_rpt_tit_ap_impl_period */
assign v_log_habilita_con_corporat = no.

find first emscad.histor_exec_especial no-lock
    where emscad.histor_exec_especial.cod_modul_dtsul = 'APB'
    and   emscad.histor_exec_especial.cod_prog_dtsul  = "spp_habilita_consulta_relatorio_corp":U
    no-error.
if avail emscad.histor_exec_especial then
    assign v_log_habilita_con_corporat = yes.

find last param_geral_apb no-lock no-error.
if  avail param_geral_apb then 
    Assign v_log_habilita_con_corporat = param_geral_apb.log_reg_corporat.
Else
    Assign v_log_habilita_con_corporat = no.

if v_cod_finalid_econ = '' then 
   assign v_cod_finalid_econ = "Corrente" /*l_corrente*/ .
/* End_Include: ix_p00_rpt_tit_ap_impl_period */

pause 0 before-hide.
view frame f_rpt_41_tit_ap_impl_period.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(tit_ap).    
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
    assign v_rec_table_epc = recid(tit_ap).    
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
    assign v_rec_table_epc = recid(tit_ap).    
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
    do with frame f_rpt_41_tit_ap_impl_period:
        assign rs_cod_dwb_output:screen-value   = dwb_rpt_param.cod_dwb_output
               rs_ind_run_mode:screen-value     = 'On-line'.

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
                with frame f_rpt_41_tit_ap_impl_period.
    end /* do init */.

    display v_qtd_column
            v_qtd_line
            with frame f_rpt_41_tit_ap_impl_period.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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
           with frame f_rpt_41_tit_ap_impl_period.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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
        assign v_rec_table_epc = recid(tit_ap).    
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


    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_ap_impl_period.
    apply "value-changed" to rs_ind_run_mode in frame f_rpt_41_tit_ap_impl_period.


    /* Begin_Include: ix_p10_rpt_tit_ap_impl_period */
    if  num-entries(dwb_rpt_param.cod_dwb_parameters, chr(10)) = 29 then do:
        assign v_cod_finalid_econ               = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_finalid_econ_apres         = entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_cotac_indic_econ           = date(entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_log_mostra_docto_apb_normal    = if  entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_log_mostra_docto_apb_nf        = if  entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                       no
               v_log_mostra_docto_apb_impto     = if  entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_log_mostra_docto_apb_prev      = if  entry(7, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_log_mostra_docto_apb_provis    = if  entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_log_mostra_docto_apb_antecip   = if  entry(9, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_cod_estab_ini                  = entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_estab_fim                  = entry(11, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_ini            = entry(12, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_fim            = entry(13, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cdn_fornecedor_ini             = integer(entry(14, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cdn_fornecedor_fim             = integer(entry(15, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_transacao_ini              = date(entry(16, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_transacao_fim              = date(entry(17, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_emis_docto_ini             = date(entry(18, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_emis_docto_fim             = date(entry(19, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_vencto_inicial             = date(entry(20, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_vencto_final               = date(entry(21, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cod_indic_econ_ini             = entry(22, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_indic_econ_fim             = entry(23, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_ind_classif_tit_ap_impl_period = entry(24, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_log_tit_fornec_compra          = if  entry(26, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_log_tit_fornec_cartcred        = if  entry(27, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/  then
                                                      yes
                                                  else
                                                      no
               v_des_estab_select               = entry(28, dwb_rpt_param.cod_dwb_parameters, chr(10))
               cb_origem                        = 'APB'.
    end.

    enable v_cdn_fornecedor_fim
           v_cdn_fornecedor_ini
           v_cod_espec_docto_fim
           v_cod_espec_docto_ini
           v_cod_estab_fim
           v_cod_estab_ini
           v_cod_finalid_econ
           bt_zoo_208304
           v_cod_finalid_econ_apres
           bt_zoo_208305
           v_cod_indic_econ_fim
           v_cod_indic_econ_ini
           v_dat_cotac_indic_econ
           v_dat_emis_docto_fim
           v_dat_emis_docto_ini
           v_dat_transacao_fim
           v_dat_transacao_ini
           v_dat_vencto_final
           v_dat_vencto_inicial
           v_ind_classif_tit_ap_impl_period
           v_log_mostra_docto_apb_antecip
           v_log_mostra_docto_apb_impto
           v_log_mostra_docto_apb_nf
           v_log_mostra_docto_apb_normal
           v_log_mostra_docto_apb_prev
           v_log_mostra_docto_apb_provis
           v_log_tit_fornec_compra
           v_log_tit_fornec_cartcred
           v_des_estab_select
           bt_todos_img
           with frame f_rpt_41_tit_ap_impl_period.

    display v_cdn_fornecedor_fim
            v_cdn_fornecedor_ini
            v_cod_espec_docto_fim
            v_cod_espec_docto_ini
            v_cod_estab_fim
            v_cod_estab_ini
            v_cod_finalid_econ
            v_cod_finalid_econ_apres
            v_cod_indic_econ_fim
            v_cod_indic_econ_ini
            v_dat_cotac_indic_econ
            v_dat_emis_docto_fim
            v_dat_emis_docto_ini
            v_dat_transacao_fim
            v_dat_transacao_ini
            v_dat_vencto_final
            v_dat_vencto_inicial
            v_ind_classif_tit_ap_impl_period
            v_log_mostra_docto_apb_antecip
            v_log_mostra_docto_apb_impto
            v_log_mostra_docto_apb_nf
            v_log_mostra_docto_apb_normal
            v_log_mostra_docto_apb_prev
            v_log_mostra_docto_apb_provis
            v_log_tit_fornec_compra
            v_log_tit_fornec_cartcred
            v_des_estab_select
            bt_todos_img
            cb_origem
            with frame f_rpt_41_tit_ap_impl_period.

     if v_log_habilita_con_corporat = yes then do:
        assign v_cod_estab_ini:visible in frame f_rpt_41_tit_ap_impl_period = no
               v_cod_estab_fim:visible in frame f_rpt_41_tit_ap_impl_period = no.
        view frame f_rpt_41_tit_ap_impl_period.
        if v_des_estab_select = " " then do:
           /* O programa procura todos os estabelecimentos da empresa para mostrar 
            registros dos estabelecimentos corporativos por solicitaá∆o principal da
            OESP / d£vidas procurar a AndrÇia ou Deise */   
            run pi_vld_permissao_usuar_estab_empres.
        end.    
        display v_des_estab_select
                with frame f_rpt_41_tit_ap_impl_period.
        disable v_des_estab_select
                v_cod_estab_ini
                v_cod_estab_fim
                with frame f_rpt_41_tit_ap_impl_period.
        enable bt_todos_img
               with frame f_rpt_41_tit_ap_impl_period.            
        apply 'entry' to v_des_estab_select.
     end.    
     else do:
        assign v_des_estab_select:visible in frame f_rpt_41_tit_ap_impl_period = no
               bt_todos_img:visible       in frame f_rpt_41_tit_ap_impl_period = no.
        view frame f_rpt_41_tit_ap_impl_period.
        disable v_des_estab_select
                bt_todos_img
                with frame f_rpt_41_tit_ap_impl_period.            
     end.                                                    
    /* End_Include: ix_p10_rpt_tit_ap_impl_period */


    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_tit_ap_impl_period:

            if (retry) then
                output stream s_1 close.
            assign v_log_print = no.
            if  valid-handle(v_wgh_focus) then
                wait-for go of frame f_rpt_41_tit_ap_impl_period focus v_wgh_focus.
            else
                wait-for go of frame f_rpt_41_tit_ap_impl_period.

            param_block:
            do transaction:
                /* ix_p15_rpt_tit_ap_impl_period */
                assign dwb_rpt_param.log_dwb_print_parameters = input frame f_rpt_41_tit_ap_impl_period v_log_print_par
                       dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_41_tit_ap_impl_period rs_ind_run_mode
                       input frame f_rpt_41_tit_ap_impl_period v_qtd_line.

                assign dwb_rpt_param.cod_dwb_parameters = v_cod_finalid_econ                     + chr(10) +
v_cod_finalid_econ_apres               + chr(10) +
string(v_dat_cotac_indic_econ)         + chr(10) +
string(v_log_mostra_docto_apb_normal)  + chr(10) +
string(v_log_mostra_docto_apb_nf)      + chr(10) +
string(v_log_mostra_docto_apb_impto)   + chr(10) +
string(v_log_mostra_docto_apb_prev)    + chr(10) +
string(v_log_mostra_docto_apb_provis)  + chr(10) +
string(v_log_mostra_docto_apb_antecip) + chr(10) +
v_cod_estab_ini                        + chr(10) +
v_cod_estab_fim                        + chr(10) +
v_cod_espec_docto_ini                  + chr(10) +
v_cod_espec_docto_fim                  + chr(10) +
string(v_cdn_fornecedor_ini)           + chr(10) +
string(v_cdn_fornecedor_fim)           + chr(10) +
string(v_dat_transacao_ini)            + chr(10) +
string(v_dat_transacao_fim)            + chr(10) +
string(v_dat_emis_docto_ini)           + chr(10) +
string(v_dat_emis_docto_fim)           + chr(10) +
string(v_dat_vencto_inicial)           + chr(10) +
string(v_dat_vencto_final)             + chr(10) +
v_cod_indic_econ_ini                   + chr(10) +
v_cod_indic_econ_fim                   + chr(10) +
v_ind_classif_tit_ap_impl_period       + chr(10) +
string(v_val_cotac_indic_econ)         + chr(10) +
string(v_log_tit_fornec_compra)        + chr(10) +
string(v_log_tit_fornec_cartcred)      + chr(10) +
v_des_estab_select                     + chr(10) +
v_cod_origem.

                /* ix_p20_rpt_tit_ap_impl_period */
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
                            assign v_cod_dwb_file   = session:temp-directory + "esapb015.tmp"
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
                    assign v_nom_prog_ext  = caps(substring("esp/apb/esapb015.p",9,8))
                           v_cod_release   = trim(" 1.00.00.001":U)
                           v_dat_execution = today
                           v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
                    run pi_rpt_tit_ap_impl_period /*pi_rpt_tit_ap_impl_period*/.
                end /* else */.
                if  dwb_rpt_param.log_dwb_print_parameters = yes
                then do:
                    if (page-number (s_1) > 0) then
                        page stream s_1.
                    /* ix_p29_rpt_tit_ap_impl_period */    
                    hide stream s_1 frame f_rpt_s_1_header_period.
                    view stream s_1 frame f_rpt_s_1_header_unique.
                    hide stream s_1 frame f_rpt_s_1_footer_last_page.
                    hide stream s_1 frame f_rpt_s_1_footer_normal.
                    view stream s_1 frame f_rpt_s_1_footer_param_page.
                    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        skip (1)
                        "Usu†rio: " at 1
                        v_cod_usuar_corren at 10 format "x(12)" skip (1).

                    /* Begin_Include: ix_p30_rpt_tit_ap_impl_period */
                    if (line-counter(s_1) + 30) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        skip (1)
                        "-----------------------------" at 30
                        "Visualizaá∆o" at 60
                        "-----------------------------" at 73
                        skip (1)
                        "    Finalidade Econìmica: " at 42
                        v_cod_finalid_econ at 68 format "x(10)" skip
                        "Finalid Apresentaá∆o: " at 46
                        v_cod_finalid_econ_apres at 68 format "x(10)" skip
                        "Data Cotaá∆o: " at 54
                        v_dat_cotac_indic_econ at 68 format "99/99/9999"
                        skip (1)
                        "-----------------------------" at 28
                        "EspÇcie Documento" at 58
                        "-----------------------------" at 76
                        skip (1)
                        "  Normal: " at 58
                        v_log_mostra_docto_apb_normal at 68 format "Sim/N∆o" skip
                        "   Nota Fiscal: " at 52
                        v_log_mostra_docto_apb_nf at 68 format "Sim/N∆o" skip
                        "   Imposto Retido: " at 49
                        v_log_mostra_docto_apb_impto at 68 format "Sim/N∆o" skip
                        "  Previs∆o: " at 56
                        v_log_mostra_docto_apb_prev at 68 format "Sim/N∆o" skip
                        "  Provis∆o: " at 56
                        v_log_mostra_docto_apb_provis at 68 format "Sim/N∆o" skip
                        "   Antecipaá∆o: " at 52
                        v_log_mostra_docto_apb_antecip at 68 format "Sim/N∆o"
                        skip (1)
                        "-----------------------------" at 33
                        "Seleá∆o" at 63
                        "-----------------------------" at 71
                        skip (1)
                        "Estabelecimento: " at 45
                        v_cod_estab_ini at 62 format "x(3)"
                        "atÇ: " at 77
                        v_cod_estab_fim at 82 format "x(3)" skip
                        "  EspÇcie: " at 51
                        v_cod_espec_docto_ini at 62 format "x(3)"
                        "atÇ: " at 77
                        v_cod_espec_docto_fim at 82 format "x(3)" skip
                        "  Fornecedor: " at 48
                        v_cdn_fornecedor_ini to 72 format ">>>,>>>,>>9"
                        "atÇ: " at 77
                        v_cdn_fornecedor_fim to 92 format ">>>,>>>,>>9" skip
                        "Data Transaá∆o: " at 46
                        v_dat_transacao_ini at 62 format "99/99/9999"
                        "atÇ: " at 77
                        v_dat_transacao_fim at 82 format "99/99/9999" skip
                        "  Emiss∆o: " at 51
                        v_dat_emis_docto_ini at 62 format "99/99/9999"
                        "atÇ: " at 77
                        v_dat_emis_docto_fim at 82 format "99/99/9999" skip
                        " Data Vencimento: " at 44
                        v_dat_vencto_inicial at 62 format "99/99/9999"
                        "atÇ: " at 77
                        v_dat_vencto_final at 82 format "99/99/9999" skip
                        "  Moeda: " at 53
                        v_cod_indic_econ_ini at 62 format "x(8)"
                        "atÇ: " at 77
                        v_cod_indic_econ_fim at 82 format "x(8)" skip
                        "  Origem: " at 52
                        v_cod_origem at 62 format "x(8)" skip (4).

                    /* End_Include: ix_p30_rpt_tit_ap_impl_period */

                end /* if */.
                output stream s_1 close.

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input no,
                                                 input rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_ap_impl_period,
                                                 input v_nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U &then
    if ((dwb_rpt_param.cod_dwb_output = 'Impressora' or dwb_rpt_param.cod_dwb_output = 'Impresora' or dwb_rpt_param.cod_dwb_output = 'printer') and getCodTipoRelat() = 'PDF':U) then do:
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

        /* ix_p32_rpt_tit_ap_impl_period */

        if  v_num_ped_exec <> 0
        then do:
            /* Criado pedido &1 para execuá∆o batch. */
            run pi_messages (input "show",
                             input 3556,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_ped_exec)) /*msg_3556*/.
            assign v_num_ped_exec = 0.
        end /* if */.

        /* ix_p35_rpt_tit_ap_impl_period */

    end /* repeat block1 */.
end /* repeat super_block */.

/* ix_p40_rpt_tit_ap_impl_period */

hide frame f_rpt_41_tit_ap_impl_period.

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
** Alterado por..........: tech35592
** Alterado em...........: 14/02/2006 07:39:05
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
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

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
    do with frame f_rpt_41_tit_ap_impl_period:

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

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

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
** Alterado por..........: tech38629
** Alterado em...........: 06/10/2006 22:40:15
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

               /* tech38629 - Relatorio PDF e RTF                 */
               /* Renomear arquivo quando extensao for pdf ou rtf */

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

    run pi_rpt_tit_ap_impl_period /*pi_rpt_tit_ap_impl_period*/.
END PROCEDURE. /* pi_output_reports */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_tit_ap_impl_period
** Descricao.............: pi_rpt_tit_ap_impl_period
** Criado por............: Rafael
** Criado em.............: 12/06/1997 10:39:19
** Alterado por..........: fut41162
** Alterado em...........: 24/05/2007 15:09:35
*****************************************************************************/
PROCEDURE pi_rpt_tit_ap_impl_period:

    /************************* Variable Definition Begin ************************/

    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count = 0.

    hide stream s_1 frame f_rpt_s_1_header_period.
    view stream s_1 frame f_rpt_s_1_header_unique.
    hide stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_normal.

    run pi_gera_tt_tit_ap_impl_periodo (Input no,
                                        Input v_des_estab_select,
                                        Input v_log_habilita_con_corporat) /*pi_gera_tt_tit_ap_impl_periodo*/.

    release tt_tit_ap_impl_period.
    assign v_val_tot_dat_impl_tit_ap = 0
           v_val_tot_estab           = 0
           v_val_tot                 = 0.

    if  v_ind_classif_tit_ap_impl_period = "Por Estabelecimento/Implantaá∆o" /*l_por_estabelecimentoimplantacao*/  then do:
        hide stream s_1 frame f_rpt_s_1_grp_detalhe_lay_data.
        view stream s_1 frame f_rpt_s_1_grp_detalhe_Lay_estab.
        for each tt_tit_ap_impl_period
                break by tt_tit_ap_impl_period.tta_cod_estab
                      by tt_tit_ap_impl_period.tta_dat_transacao:

            if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                tt_tit_ap_impl_period.tta_cod_estab at 1 format "x(3)"
                tt_tit_ap_impl_period.tta_cod_espec_docto at 5 format "x(3)"
                tt_tit_ap_impl_period.tta_cod_ser_docto at 9 format "x(3)"
                tt_tit_ap_impl_period.tta_cdn_fornecedor to 23 format ">>>,>>>,>>9"
                tt_tit_ap_impl_period.tta_nom_abrev at 25 format "x(15)"
                tt_tit_ap_impl_period.tta_cod_tit_ap at 41 format "x(10)"
                tt_tit_ap_impl_period.tta_cod_parcela at 52 format "x(02)"
                tt_tit_ap_impl_period.tta_dat_emis_docto at 55 format "99/99/9999"
                tt_tit_ap_impl_period.tta_dat_transacao at 66 format "99/99/9999"
                tt_tit_ap_impl_period.tta_dat_vencto_tit_ap at 78 format "99/99/9999"
                tt_tit_ap_impl_period.tta_cod_indic_econ at 89 format "x(8)"
                tt_tit_ap_impl_period.tta_val_origin_tit_ap to 117 format ">,>>>,>>>,>>>,>>9.99"
                tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres to 138 format ">,>>>,>>>,>>>,>>9.99" skip.                 


            /* Begin_Include: i_epc_imprime_tipo_fluxo */
            &if '{&emsbas_version}' > '5.00' &then
                if  v_nom_prog_upc <> '' then do:
                    assign v_rec_table_epc = tt_tit_ap_impl_period.ttv_rec_tit_ap.
                    run value(v_nom_prog_upc) (input "IMPRIME-FLUXO" /*l_imprime_fluxo*/ ,
                                               input "viewer" /*l_viewer*/ ,
                                               input this-procedure,
                                               input v_wgh_frame_epc,
                                               input v_nom_table_epc,
                                               input v_rec_table_epc).
                    if  return-value = "NOK" /*l_nok*/  then
                        return.
                end.
            &endif
            /* End_Include: i_epc_imprime_tipo_fluxo */


            assign v_val_tot_dat_impl_tit_ap = v_val_tot_dat_impl_tit_ap + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
                   v_val_tot_estab           = v_val_tot_estab + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
                   v_val_tot                 = v_val_tot + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres.
            if  last-of(tt_tit_ap_impl_period.tta_cod_estab) then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Total do Estabelecimento:" at 85
                    ":" at 110
                    v_val_tot_estab to 132 format ">,>>>,>>>,>>>,>>9.99" skip.
                assign v_val_tot_estab = 0.
            end.
            if  last-of(tt_tit_ap_impl_period.tta_dat_transacao) then do:
                assign v_dat_impl_tit_ap = tt_tit_ap_impl_period.tta_dat_transacao.
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Total do Dia   " at 84
                    v_dat_impl_tit_ap at 100 format "99/99/9999"
                    ":" at 110
                    v_val_tot_dat_impl_tit_ap to 132 format ">,>>>,>>>,>>>,>>9.99" skip.
                assign v_val_tot_dat_impl_tit_ap = 0.
            end.
        end.    
    end.
    else do:
        hide stream s_1 frame f_rpt_s_1_grp_detalhe_Lay_estab.
        view stream s_1 frame f_rpt_s_1_grp_detalhe_lay_data.
        for each tt_tit_ap_impl_period
            break by tt_tit_ap_impl_period.tta_dat_transacao
                  by tt_tit_ap_impl_period.tta_cod_estab:
            if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                tt_tit_ap_impl_period.tta_dat_transacao at 1 format "99/99/9999"
                tt_tit_ap_impl_period.tta_cod_estab at 13 format "x(3)"
                tt_tit_ap_impl_period.tta_cod_espec_docto at 17 format "x(3)"
                tt_tit_ap_impl_period.tta_cod_ser_docto at 21 format "x(3)"
                tt_tit_ap_impl_period.tta_cdn_fornecedor to 35 format ">>>,>>>,>>9"
                tt_tit_ap_impl_period.tta_nom_abrev at 37 format "x(15)"
                tt_tit_ap_impl_period.tta_cod_tit_ap at 53 format "x(10)"
                tt_tit_ap_impl_period.tta_cod_parcela at 64 format "x(02)"
                tt_tit_ap_impl_period.tta_dat_emis_docto at 67 format "99/99/9999"
                tt_tit_ap_impl_period.tta_dat_vencto_tit_ap at 78 format "99/99/9999"
                tt_tit_ap_impl_period.tta_cod_indic_econ at 89 format "x(8)"
                tt_tit_ap_impl_period.tta_val_origin_tit_ap to 117 format ">,>>>,>>>,>>>,>>9.99"
                tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres to 138 format ">,>>>,>>>,>>>,>>9.99" skip.


            /* Begin_Include: i_epc_imprime_tipo_fluxo */
            &if '{&emsbas_version}' > '5.00' &then
                if  v_nom_prog_upc <> '' then do:
                    assign v_rec_table_epc = tt_tit_ap_impl_period.ttv_rec_tit_ap.
                    run value(v_nom_prog_upc) (input "IMPRIME-FLUXO" /*l_imprime_fluxo*/ ,
                                               input "viewer" /*l_viewer*/ ,
                                               input this-procedure,
                                               input v_wgh_frame_epc,
                                               input v_nom_table_epc,
                                               input v_rec_table_epc).
                    if  return-value = "NOK" /*l_nok*/  then
                        return.
                end.
            &endif
            /* End_Include: i_epc_imprime_tipo_fluxo */


            assign v_val_tot_dat_impl_tit_ap = v_val_tot_dat_impl_tit_ap + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
                   v_val_tot_estab           = v_val_tot_estab + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
                   v_val_tot                 = v_val_tot + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres.
            if  last-of(tt_tit_ap_impl_period.tta_cod_estab) then do:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Total do Estabelecimento:" at 85
                    ":" at 110
                    v_val_tot_estab to 132 format ">,>>>,>>>,>>>,>>9.99" skip.
                assign v_val_tot_estab = 0.
            end.
            if  last-of(tt_tit_ap_impl_period.tta_dat_transacao) then do:
                assign v_dat_impl_tit_ap = tt_tit_ap_impl_period.tta_dat_transacao.
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Total do Dia   " at 84
                    v_dat_impl_tit_ap at 100 format "99/99/9999"
                    ":" at 110
                    v_val_tot_dat_impl_tit_ap to 132 format ">,>>>,>>>,>>>,>>9.99" skip.
                assign v_val_tot_dat_impl_tit_ap = 0.
            end.
        end.
    end.

    if  v_ind_classif_tit_ap_impl_period = "Por Estabelecimento/Implantaá∆o" /*l_por_estabelecimentoimplantacao*/  then do:
        hide stream s_1 frame f_rpt_s_1_grp_detalhe_Lay_estab.
    end.
    else do:
        hide stream s_1 frame f_rpt_s_1_grp_detalhe_lay_data.
    end.
    if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        "Total Geral:" at 99
        v_val_tot to 132 format ">,>>>,>>>,>>>,>>9.99" skip.

    hide stream s_1 frame f_rpt_s_1_footer_normal.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_last_page.
END PROCEDURE. /* pi_rpt_tit_ap_impl_period */
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
** Alterado por..........: fut1309_4
** Alterado em...........: 08/02/2006 16:12:34
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

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

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
** Procedure Interna.....: pi_gera_tt_tit_ap_impl_periodo
** Descricao.............: pi_gera_tt_tit_ap_impl_periodo
** Criado por............: Rafael
** Criado em.............: 10/06/1997 18:56:29
** Alterado por..........: fut1236
** Alterado em...........: 03/03/2006 15:18:28
*****************************************************************************/
PROCEDURE pi_gera_tt_tit_ap_impl_periodo:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_gera_tot_impl_period
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param p_des_estab_select
        as character
        format "x(2000)"
        no-undo.
    def Input param p_log_habilita_con_corporat
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    elimina:
    for each tt_tit_ap_impl_period:
        delete tt_tit_ap_impl_period.
    end /* for elimina */.

    del_tt:
    for each tt_espec_docto:
        delete tt_espec_docto.
    end /* for del_tt */.

    espec_block:
    for each espec_docto 
        fields (cod_espec_docto ind_tip_espec_docto) 
        no-lock
        where espec_docto.cod_espec_docto >= v_cod_espec_docto_ini
        and   espec_docto.cod_espec_docto <= v_cod_espec_docto_fim:

        if  (espec_docto.ind_tip_espec_docto     = "Normal" /*l_normal*/ 
        and  v_log_mostra_docto_apb_normal       = no)
        or  (espec_docto.ind_tip_espec_docto     = "Nota Fiscal" /*l_nota_fiscal*/ 
        and  v_log_mostra_docto_apb_nf           = no)
        or  (espec_docto.ind_tip_espec_docto     = "Imposto Retido" /*l_imposto_retido*/ 
        and  v_log_mostra_docto_apb_impto        = no)
        or  (espec_docto.ind_tip_espec_docto     = "Imposto Taxado" /*l_imposto_taxado*/ 
        and  v_log_mostra_docto_apb_impto        = no)
        or  (espec_docto.ind_tip_espec_docto     = "Antecipaá∆o" /*l_antecipacao*/ 
        and  v_log_mostra_docto_apb_antecip      = no)
        or  (espec_docto.ind_tip_espec_docto     = "Previs∆o" /*l_previsao*/ 
        and  v_log_mostra_docto_apb_prev         = no)
        or  (espec_docto.ind_tip_espec_docto     = "Provis∆o" /*l_provisao*/ 
        and  v_log_mostra_docto_apb_provis       = no) then
            next espec_block.
        create tt_espec_docto.
        assign tt_espec_docto.tta_cod_espec_docto = espec_docto.cod_espec_docto.
    end /* for espec_block */.

    run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ,
                                        Input v_dat_cotac_indic_econ,
                                        output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.

    if p_log_habilita_con_corporat = no then do:
       assign p_des_estab_select = ''.
       estab_block_esp:
       for each estabelecimento no-lock
          where estabelecimento.cod_empresa = v_cod_empres_usuar
          and   estabelecimento.cod_estab  >= v_cod_estab_ini
          and   estabelecimento.cod_estab  <= v_cod_estab_fim:
          if p_des_estab_select = " " then
             assign p_des_estab_select = estabelecimento.cod_estab.
          else
             assign p_des_estab_select = p_des_estab_select + "," + estabelecimento.cod_estab.
       end /* for estab_block_esp */.
    end.

    des_estab_block:
    do v_num_cont_aux = 1 to num-entries(p_des_estab_select):
    estab_block:
      for each estabelecimento no-lock
         where estabelecimento.cod_estab  = entry(v_num_cont_aux, p_des_estab_select):

        if  v_cdn_fornecedor_ini = v_cdn_fornecedor_fim
        then do:
            titulos:
            for each tit_ap 
                fields (cod_empresa cod_estab num_id_tit_ap cod_espec_docto
                        cod_ser_docto cdn_fornecedor cod_tit_ap
                        cod_parcela dat_emis_docto dat_transacao
                        dat_vencto_tit_ap cod_indic_econ val_origin_tit_ap
                        log_pagto_cartcred log_tit_ap_estordo cod_empresa ind_origin_tit_ap) no-lock
                where tit_ap.cod_estab         = estabelecimento.cod_estab
                and   tit_ap.cod_espec_docto   >= v_cod_espec_docto_ini
                and   tit_ap.cod_espec_docto   <= v_cod_espec_docto_fim
                and   tit_ap.cdn_fornecedor    >= v_cdn_fornecedor_ini
                and   tit_ap.cdn_fornecedor    <= v_cdn_fornecedor_fim
                and   tit_ap.dat_transacao     >= v_dat_transacao_ini
                and   tit_ap.dat_transacao     <= v_dat_transacao_fim
                and   tit_ap.dat_emis_docto    >= v_dat_emis_docto_ini
                and   tit_ap.dat_emis_docto    <= v_dat_emis_docto_fim
                and   tit_ap.dat_vencto_tit_ap >= v_dat_vencto_inicial
                and   tit_ap.dat_vencto_tit_ap <= v_dat_vencto_final
                and   tit_ap.cod_tit_ap        >= v_cod_tit_ap_inicial
                and   tit_ap.cod_tit_ap        <= v_cod_tit_ap_final
                and   tit_ap.cod_indic_econ    >= v_cod_indic_econ_ini
                and   tit_ap.cod_indic_econ    <= v_cod_indic_econ_fim :

                find first tt_tit_ap_impl_period no-lock
                     where tt_tit_ap_impl_period.tta_cdn_fornecedor = tit_ap.cdn_fornecedor
                     no-error.
                if not avail tt_tit_ap_impl_period then do:
                   find first emscad.fornecedor no-lock
                        where fornecedor.cod_empresa     = tit_ap.cod_empresa
                        and   fornecedor.cdn_fornecedor  = tit_ap.cdn_fornecedor no-error.                    
                   if not avail fornecedor then do:                                        
                      next titulos.
                   end.
                   assign v_nom_abrev = fornecedor.nom_abrev.
                end.
                else do:
                   assign v_nom_abrev = tt_tit_ap_impl_period.tta_nom_abrev.
                end.

                if  not can-find(tt_espec_docto
                    where tt_espec_docto.tta_cod_espec_docto = tit_ap.cod_espec_docto) then
                    next.

                if  v_cod_origem <> "Tudo" /*l_tudo*/ 
                and v_cod_origem <> tit_ap.ind_origin_tit_ap then
                    next.

                if not can-find (movto_tit_ap of tit_ap no-lock
                                 where movto_tit_ap.ind_trans_ap_abrev = 'IMPL')
                   then next.

                run pi_cria_registro_tt_tit_ap_impl_period /*pi_cria_registro_tt_tit_ap_impl_period*/.

            end /* for titulos */.
        end /* if */.
        else do:
            titulos:
            for each tit_ap
                fields (cod_empresa cod_estab num_id_tit_ap cod_espec_docto
                        cod_ser_docto cdn_fornecedor cod_tit_ap
                        cod_parcela dat_emis_docto dat_transacao
                        dat_vencto_tit_ap cod_indic_econ val_origin_tit_ap
                        log_pagto_cartcred log_tit_ap_estordo cod_empresa ind_origin_tit_ap)
                use-index titap_estab_trans_espec no-lock
                where tit_ap.cod_estab         = estabelecimento.cod_estab
                and   tit_ap.dat_transacao     >= v_dat_transacao_ini
                and   tit_ap.dat_transacao     <= v_dat_transacao_fim
                and   tit_ap.cod_espec_docto   >= v_cod_espec_docto_ini
                and   tit_ap.cod_espec_docto   <= v_cod_espec_docto_fim
                and   tit_ap.cdn_fornecedor    >= v_cdn_fornecedor_ini
                and   tit_ap.cdn_fornecedor    <= v_cdn_fornecedor_fim
                and   tit_ap.dat_emis_docto    >= v_dat_emis_docto_ini
                and   tit_ap.dat_emis_docto    <= v_dat_emis_docto_fim
                and   tit_ap.dat_vencto_tit_ap >= v_dat_vencto_inicial
                and   tit_ap.dat_vencto_tit_ap <= v_dat_vencto_final
                and   tit_ap.cod_tit_ap        >= v_cod_tit_ap_inicial
                and   tit_ap.cod_tit_ap        <= v_cod_tit_ap_final
                and   tit_ap.cod_indic_econ    >= v_cod_indic_econ_ini
                and   tit_ap.cod_indic_econ    <= v_cod_indic_econ_fim :

                find first tt_tit_ap_impl_period no-lock
                     where tt_tit_ap_impl_period.tta_cdn_fornecedor = tit_ap.cdn_fornecedor
                     no-error.
                if not avail tt_tit_ap_impl_period then do:
                   find first fornecedor no-lock
                        where fornecedor.cod_empresa     = tit_ap.cod_empresa
                        and   fornecedor.cdn_fornecedor  = tit_ap.cdn_fornecedor no-error.                    
                   if not avail fornecedor then do:                                        
                      next titulos.
                   end.
                   assign v_nom_abrev = fornecedor.nom_abrev.
                end.
                else do:
                   assign v_nom_abrev = tt_tit_ap_impl_period.tta_nom_abrev.
                end.

                if  not can-find(tt_espec_docto
                    where tt_espec_docto.tta_cod_espec_docto = tit_ap.cod_espec_docto) then
                    next.

                if  v_cod_origem <> "Tudo" /*l_tudo*/ 
                and v_cod_origem <> tit_ap.ind_origin_tit_ap then
                    next.                

                if not can-find (movto_tit_ap of tit_ap no-lock
                                 where movto_tit_ap.ind_trans_ap_abrev = 'IMPL')
                   then next.

                run pi_cria_registro_tt_tit_ap_impl_period /*pi_cria_registro_tt_tit_ap_impl_period*/.

            end /* for titulos */.
        end /* else */.
    end /* for estab */.
    end /* do des_estab_block */.

    if  p_log_gera_tot_impl_period = yes then
        run pi_gerar_totais_tit_ap_impl_period /*pi_gerar_totais_tit_ap_impl_period*/.

END PROCEDURE. /* pi_gera_tt_tit_ap_impl_periodo */
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
            today                    at 84 
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
** Procedure Interna.....: pi_cria_registro_tt_tit_ap_impl_period
** Descricao.............: pi_cria_registro_tt_tit_ap_impl_period
** Criado por............: Menna
** Criado em.............: 11/09/1998 11:44:26
** Alterado por..........: src12115
** Alterado em...........: 07/05/2003 11:25:58
*****************************************************************************/
PROCEDURE pi_cria_registro_tt_tit_ap_impl_period:

    /* ** N«O DEVE PROCESSAR T÷TULOS IMPLANTADOS POR TRANSFER“NCIA ESTABELECIMENTO (Barth) ***/
    if  tit_ap.val_origin_tit_ap = 0 then
        return.

    if  (tit_ap.log_pagto_cartcred = yes
    and  v_log_tit_fornec_compra   = no) then
        return.

    if  v_log_tit_fornec_cartcred = no then
        if  can-find(compl_pagto_cartcred
            where compl_pagto_cartcred.cod_estab     = tit_ap.cod_estab
            and   compl_pagto_cartcred.num_id_tit_ap = tit_ap.num_id_tit_ap) then 
            return.

    &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_upc <> '' then do:
            assign v_rec_table_epc = recid(tit_ap).
            run value(v_nom_prog_upc) (input "VALIDA-FLUXO" /*l_VALIDA_FLUXO*/ ,
                                        input "viewer" /*l_viewer*/ ,
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  return-value = "NOK" /*l_nok*/  then
                return.
        end.
    &endif

    create tt_tit_ap_impl_period.
    assign tt_tit_ap_impl_period.tta_cod_estab         = tit_ap.cod_estab
           tt_tit_ap_impl_period.tta_cod_empresa       = tit_ap.cod_empresa
           tt_tit_ap_impl_period.tta_num_id_tit_ap     = tit_ap.num_id_tit_ap
           tt_tit_ap_impl_period.tta_cod_espec_docto   = tit_ap.cod_espec_docto
           tt_tit_ap_impl_period.tta_cod_ser_docto     = tit_ap.cod_ser_docto
           tt_tit_ap_impl_period.tta_cdn_fornecedor    = tit_ap.cdn_fornecedor
           tt_tit_ap_impl_period.tta_nom_abrev         = v_nom_abrev
           tt_tit_ap_impl_period.tta_cod_tit_ap        = tit_ap.cod_tit_ap
           tt_tit_ap_impl_period.tta_cod_parcela       = tit_ap.cod_parcela
           tt_tit_ap_impl_period.tta_dat_emis_docto    = tit_ap.dat_emis_docto
           tt_tit_ap_impl_period.tta_dat_transacao     = tit_ap.dat_transacao
           tt_tit_ap_impl_period.tta_dat_vencto_tit_ap = tit_ap.dat_vencto_tit_ap
           tt_tit_ap_impl_period.tta_cod_indic_econ    = tit_ap.cod_indic_econ
           tt_tit_ap_impl_period.tta_val_origin_tit_ap = tit_ap.val_origin_tit_ap
           tt_tit_ap_impl_period.ttv_rec_tit_ap        = recid(tit_ap).

    if  tit_ap.log_tit_ap_estordo <> yes then
        if  tit_ap.cod_indic_econ <> v_cod_indic_econ_base then
            valores:
            for each val_tit_ap 
                fields (cod_estab num_id_tit_ap cod_finalid_econ val_origin_tit_ap) 
                no-lock
                where val_tit_ap.cod_estab        = tit_ap.cod_estab
                and   val_tit_ap.num_id_tit_ap    = tit_ap.num_id_tit_ap
                and   val_tit_ap.cod_finalid_econ = v_cod_finalid_econ:
                assign tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres = tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
                                                                       + val_tit_ap.val_origin_tit_ap.
            end /* for valores */.
        else 
            assign tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres = tit_ap.val_origin_tit_ap.

    assign tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres = tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres 
                                                           / v_val_cotac_indic_econ.

END PROCEDURE. /* pi_cria_registro_tt_tit_ap_impl_period */
/*****************************************************************************
** Procedure Interna.....: pi_gerar_totais_tit_ap_impl_period
** Descricao.............: pi_gerar_totais_tit_ap_impl_period
** Criado por............: Rafael
** Criado em.............: 10/06/1997 20:45:11
** Alterado por..........: Menna
** Alterado em...........: 12/09/1998 17:33:10
*****************************************************************************/
PROCEDURE pi_gerar_totais_tit_ap_impl_period:

    /************************* Variable Definition Begin ************************/

    def var v_num_seq                        as integer         no-undo. /*local*/
    def var v_val_acum_tit_praz_estab        as decimal         no-undo. /*local*/
    def var v_val_acum_tit_praz_geral        as decimal         no-undo. /*local*/
    def var v_val_tot_dat_trans              as decimal         no-undo. /*local*/
    def var v_val_tot_estab                  as decimal         no-undo. /*local*/
    def var v_val_tot_geral                  as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    eliminacao:
    for each tt_tot_tit_ap_impl_period:
        delete tt_tot_tit_ap_impl_period.
    end /* for eliminacao */.

    assign v_num_seq                 = 1
           v_val_tot_dat_trans       = 0
           v_val_acum_tit_praz_estab = 0
           v_val_tot_estab           = 0
           v_val_acum_tit_praz_geral = 0
           v_val_tot_geral           = 0.

    titulos_selecionados:
    for each tt_tit_ap_impl_period use-index tt_trans
        break by tt_tit_ap_impl_period.tta_cod_estab
              by tt_tit_ap_impl_period.tta_dat_transacao:
        if  first-of(tt_tit_ap_impl_period.tta_cod_estab)
        then do:
            create tt_tot_tit_ap_impl_period.
            find estabelecimento
                where estabelecimento.cod_estab = tt_tit_ap_impl_period.tta_cod_estab
                no-lock no-error.

            assign tt_tot_tit_ap_impl_period.tta_cod_estab     = tt_tit_ap_impl_period.tta_cod_estab
                   tt_tot_tit_ap_impl_period.tta_nom_pessoa    = estabelecimento.nom_pessoa
                   tt_tot_tit_ap_impl_period.tta_dat_transacao = ?
                   tt_tot_tit_ap_impl_period.ttv_val_tot_movto = 0
                   tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq
                   v_num_seq                                   = v_num_seq + 1.
        end /* if */.

        assign v_val_tot_dat_trans       = v_val_tot_dat_trans + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
               v_val_tot_estab           = v_val_tot_estab + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
               v_val_tot_geral           = v_val_tot_geral + tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres
               v_val_acum_tit_praz_estab = v_val_acum_tit_praz_estab + (tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres 
                                         * (tt_tit_ap_impl_period.tta_dat_vencto_tit_ap - tt_tit_ap_impl_period.tta_dat_emis_docto))
               v_val_acum_tit_praz_geral = v_val_acum_tit_praz_geral + (tt_tit_ap_impl_period.ttv_val_orig_tit_ap_apres 
                                         * (tt_tit_ap_impl_period.tta_dat_vencto_tit_ap - tt_tit_ap_impl_period.tta_dat_emis_docto)).

        if  last-of(tt_tit_ap_impl_period.tta_dat_transacao)
        then do:
            create tt_tot_tit_ap_impl_period.
            assign tt_tot_tit_ap_impl_period.tta_cod_estab     = ""
                   tt_tot_tit_ap_impl_period.tta_nom_pessoa    = ""
                   tt_tot_tit_ap_impl_period.tta_dat_transacao = tt_tit_ap_impl_period.tta_dat_transacao
                   tt_tot_tit_ap_impl_period.ttv_val_tot_movto = v_val_tot_dat_trans
                   tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq
                   v_num_seq                                   = v_num_seq + 1
                   v_val_tot_dat_trans                         = 0.
        end /* if */.
        if  last-of(tt_tit_ap_impl_period.tta_cod_estab)
        then do:
            create tt_tot_tit_ap_impl_period.
            assign tt_tot_tit_ap_impl_period.tta_cod_estab     = ""
                   tt_tot_tit_ap_impl_period.tta_nom_pessoa    = "Total do Estabelecimento:" /*l_total_estabelecimento*/ 
                   tt_tot_tit_ap_impl_period.tta_dat_transacao = ?
                   tt_tot_tit_ap_impl_period.ttv_val_tot_movto = v_val_tot_estab
                   tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq
                   v_num_seq                                   = v_num_seq + 1.

            create tt_tot_tit_ap_impl_period.
            assign tt_tot_tit_ap_impl_period.tta_cod_estab     = ""
                   tt_tot_tit_ap_impl_period.tta_nom_pessoa    = "Prazo MÇdio Vencto Estabelecimento" /*l_prazo_medio_vencto_estab*/ 
                   tt_tot_tit_ap_impl_period.tta_dat_transacao = ?
                   tt_tot_tit_ap_impl_period.ttv_val_tot_movto = v_val_acum_tit_praz_estab / v_val_tot_estab
                   tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq
                   v_num_seq                                   = v_num_seq + 1
                   v_val_tot_estab                             = 0
                   v_val_acum_tit_praz_estab                   = 0.

        end /* if */.
    end /* for titulos_selecionados */.
    create tt_tot_tit_ap_impl_period.
    assign tt_tot_tit_ap_impl_period.tta_cod_estab     = ""
           tt_tot_tit_ap_impl_period.tta_nom_pessoa    = "Total Geral" /*l_total_geral*/ 
           tt_tot_tit_ap_impl_period.tta_dat_transacao = ?
           tt_tot_tit_ap_impl_period.ttv_val_tot_movto = v_val_tot_geral
           tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq
           v_num_seq                                   = v_num_seq + 1.

    create tt_tot_tit_ap_impl_period.
    assign tt_tot_tit_ap_impl_period.tta_cod_estab     = ""
           tt_tot_tit_ap_impl_period.tta_nom_pessoa    = "Prazo MÇdio Vencto" /*l_prazo_medio_vencto*/ 
           tt_tot_tit_ap_impl_period.tta_dat_transacao = ?
           tt_tot_tit_ap_impl_period.ttv_val_tot_movto = v_val_acum_tit_praz_geral / v_val_tot_geral
           tt_tot_tit_ap_impl_period.ttv_num_ord_reg   = v_num_seq.

END PROCEDURE. /* pi_gerar_totais_tit_ap_impl_period */
/*****************************************************************************
** Procedure Interna.....: pi_vld_valores_apres_apb
** Descricao.............: pi_vld_valores_apres_apb
** Criado por............: bre18490
** Criado em.............: 24/06/1999 15:27:38
** Alterado por..........: bre17191
** Alterado em...........: 01/09/1999 14:59:45
*****************************************************************************/
PROCEDURE pi_vld_valores_apres_apb:

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

    def var v_cod_empresa
        as character
        format "x(3)":U
        label "Empresa"
        column-label "Empresa"
        no-undo.
    def var v_cod_empresa_2
        as character
        format "x(3)":U
        label "Empresa"
        column-label "Empresa"
        no-undo.
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
    def var v_des_empres_select
        as character
        format "x(2000)":U
        view-as editor max-chars 2000
        size 30 by 1
        bgcolor 15 font 2
        no-undo.
    def var v_num_cont_2
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_cont_3
        as integer
        format ">>>>,>>9":U
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

    for each tt_empresa_selec:
        delete tt_empresa_selec.
    end.    

    assign v_des_empres_select = " ".
    do v_num_cont_2 = 1 to num-entries(v_des_estab_select):
        find estabelecimento no-lock
            where estabelecimento.cod_estab = entry(v_num_cont_2, v_des_estab_select) no-error.
        if avail estabelecimento then do:    
            find tt_empresa_selec no-lock
                where tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa no-error.
            if not avail tt_empresa_selec then do:
                create tt_empresa_selec.
                assign tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa.        
                find finalid_unid_organ no-lock
                     where finalid_unid_organ.cod_unid_organ   = estabelecimento.cod_empresa
                     and   finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ
                     no-error.
                if  not avail finalid_unid_organ
                then do:
                    if v_des_empres_select = " " then
                        assign v_des_empres_select = estabelecimento.cod_empresa.
                    else     
                        assign v_des_empres_select = v_des_empres_select + ", " + estabelecimento.cod_empresa.
                end /* if */.
            end.    
        end.    
    end.    

    if v_des_empres_select <> " " then do:
        /* Finalidade Econìmica n∆o liberada para Empresa ! */
        run pi_messages (input "show",
                         input 8751,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_des_empres_select)) /*msg_8751*/.
        return error.
    end.    

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

    for each tt_empresa_selec:
        delete tt_empresa_selec.
    end.    

    assign v_des_empres_select = " ".
    do v_num_cont_3 = 1 to num-entries(v_des_estab_select):
        find estabelecimento no-lock
            where estabelecimento.cod_estab = entry(v_num_cont_3, v_des_estab_select) no-error.
        if avail estabelecimento then do:    
            find tt_empresa_selec no-lock
                where tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa no-error.
            if not avail tt_empresa_selec then do:
                create tt_empresa_selec.
                assign tt_empresa_selec.tta_cod_empresa = estabelecimento.cod_empresa.        
                find b_finalid_unid_organ no-lock
                     where b_finalid_unid_organ.cod_unid_organ   = estabelecimento.cod_empresa
                     and   b_finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ_apres
                     no-error.
                if  not avail b_finalid_unid_organ
                then do:
                    if v_des_empres_select = " " then
                        assign v_des_empres_select = estabelecimento.cod_empresa.
                    else     
                        assign v_des_empres_select = v_des_empres_select + ", " + estabelecimento.cod_empresa.        
                end /* if */.
            end.    
        end.    
    end.

    if v_des_empres_select <> " " then do:
        /* Finalidade Econìmica Apresentaá∆o n∆o liberada para Empresa ! */
        run pi_messages (input "show",
                         input 8752,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_des_empres_select)) /*msg_8752*/.
        return error.
    end.    

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
        assign p_val_cotac_indic_econ = 1.
        /* Cotaá∆o entre Indicadores Econìmicos n∆o encontrada ! */
        run pi_messages (input "show",
                         input 358,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            entry(2,v_cod_return), entry(3,v_cod_return), entry(4,v_cod_return), entry(5,v_cod_return))) /*msg_358*/.
        return error.
    end /* if */.
END PROCEDURE. /* pi_vld_valores_apres_apb */
/*****************************************************************************
** Procedure Interna.....: pi_vld_permissao_usuar_estab_empres
** Descricao.............: pi_vld_permissao_usuar_estab_empres
** Criado por............: bre18732
** Criado em.............: 21/06/2002 16:19:21
** Alterado por..........: fut930
** Alterado em...........: 30/05/2003 15:06:13
*****************************************************************************/
PROCEDURE pi_vld_permissao_usuar_estab_empres:

    for each tt_usuar_grp_usuar.
        delete tt_usuar_grp_usuar.
    end.
    for each usuar_grp_usuar no-lock
        where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
        find first tt_usuar_grp_usuar
            where tt_usuar_grp_usuar.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar
            and   tt_usuar_grp_usuar.cod_usuario   = usuar_grp_usuar.cod_usuario no-lock no-error.
        if not avail tt_usuar_grp_usuar then do:
            create tt_usuar_grp_usuar.
            buffer-copy usuar_grp_usuar to tt_usuar_grp_usuar.
         end.
    end.
    find first tt_usuar_grp_usuar
        where tt_usuar_grp_usuar.cod_grp_usuar = "*"
        and   tt_usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren no-lock no-error.
    if not avail tt_usuar_grp_usuar then do:
        create tt_usuar_grp_usuar.
        assign tt_usuar_grp_usuar.cod_grp_usuar = "*"
               tt_usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren.
    end.

    /* Transfere os grupos de usu†rios para uma temp-table, porque o grupo "*" n∆o tem a tabela
       usuar_grp_usuar criada, ent∆o pode n∆o trazer algumas unidades organizacionais por causa do "*"
       Se o usu†rio n∆o estivesse cadastrado em nenhum grupo exeto o "*" n∆o trazia nenhuma unidade organizacional - Marisa (07/04/2003) */

    if v_log_habilita_con_corporat = yes then do:
        for each tt_usuar_grp_usuar.
            for each segur_unid_organ no-lock
                where segur_unid_organ.cod_grp_usuar = tt_usuar_grp_usuar.cod_grp_usuar
                or segur_unid_organ.cod_grp_usuar = "*":                      
                for each unid_organ no-lock
                    where unid_organ.cod_unid_organ = segur_unid_organ.cod_unid_organ:
                    find tip_unid_organ no-lock
                         where tip_unid_organ.cod_tip_unid_organ = unid_organ.cod_tip_unid_organ no-error.
                    if avail tip_unid_organ then do: 
                       if tip_unid_organ.num_niv_unid_organ = 998 then do:
                          for each estabelecimento no-lock
                              where estabelecimento.cod_empresa = unid_organ.cod_unid_organ:
                              find b_unid_organ no-lock  
                                   where b_unid_organ.cod_unid_organ = estabelecimento.cod_estab no-error.
                              if avail b_unid_organ then do:
                                 find first b_segur_unid_organ no-lock  
                                      where b_segur_unid_organ.cod_unid_organ = b_unid_organ.cod_unid_organ
                                      and  (b_segur_unid_organ.cod_grp_usuar  = tt_usuar_grp_usuar.cod_grp_usuar
                                      or    b_segur_unid_organ.cod_grp_usuar  = "*") no-error.
                                 if avail  b_segur_unid_organ then do:
                                    find tt_estabelecimento_empresa no-lock
                                         where tt_estabelecimento_empresa.tta_cod_estab = estabelecimento.cod_estab no-error.
                                    if not avail tt_estabelecimento_empresa then do:        
                                       create tt_estabelecimento_empresa.
                                       assign tt_estabelecimento_empresa.tta_cod_estab        = estabelecimento.cod_estab.
                                    end.    
                                 end.
                              end.     
                          end. 
                       end. 
                    end.
                end.
            end.
        end.
    end.    
    else do:
        for each estabelecimento no-lock
            where estabelecimento.cod_empresa = v_cod_empres_usuar:
            find tt_estabelecimento_empresa no-lock 
                 where tt_estabelecimento_empresa.tta_cod_estab = estabelecimento.cod_estab no-error. 
             if not avail tt_estabelecimento_empresa then do:         
                create tt_estabelecimento_empresa. 
                assign tt_estabelecimento_empresa.tta_cod_estab = estabelecimento.cod_estab. 
             end. 
        end.
    end.

    for each tt_estabelecimento_empresa:
        if v_des_estab_select = " " then
           assign v_des_estab_select = tt_estabelecimento_empresa.tta_cod_estab.
        else
           assign v_des_estab_select = v_des_estab_select + "," + tt_estabelecimento_empresa.tta_cod_estab.
    end.
END PROCEDURE. /* pi_vld_permissao_usuar_estab_empres */


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
/**********************  End of rpt_tit_ap_impl_period **********************/
