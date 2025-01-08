/*****************************************************************************
** Nome Externo..........: esp/apb/esapb099.p
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_rpt_proces_pagto no-undo like proces_pagto
    field ttv_cod_dwb_field_rpt            as character extent 9 format "x(32)" label "Conjunto" column-label "Conjunto"
    field ttv_rec_proces_pagto             as recid format ">>>>>>9" initial ?
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    index tt_rpt_proces_pagto_id           is primary unique
          ttv_rec_proces_pagto             ascending
    .

def temp-table tt_tot_liber_pagto_moeda no-undo
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_val_total                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Total %" column-label "Valor Total"
    field ttv_qtd_liber_pagto_tit          as decimal format ">>>9" decimals 0 label "T°tulos Liberados" column-label "T°tulos Liberados"
    .

def temp-table tt_tot_prepar_pagto_moeda no-undo
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_val_total                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Total %" column-label "Valor Total"
    field ttv_qtd_prepar_pagto_tit         as decimal format ">9" decimals 0 label "T°tulos Preparados" column-label "T°tulos Preparados"
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

def buffer b_ped_exec_style
    for ped_exec.
def buffer b_servid_exec_style
    for servid_exec.


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

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
def new shared var v_cod_dat_type
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_field
    as character
    format "x(32)":U
    no-undo.
def new shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_cod_dwb_file_old
    as character
    format "x(50)":U
    label "Arquivo Externo"
    column-label "Arquivo Externo"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_cod_dwb_order
    as character
    format "x(32)":U
    label "Classificaá∆o"
    column-label "Classificador"
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
def new shared var v_cod_dwb_select
    as character
    format "x(32)":U
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
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new shared var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def new shared var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
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
def new shared var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
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
def var v_cod_order
    as character
    format "x(40)":U
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
def new shared var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def new shared var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
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
def var v_ind_proces_pagto
    as character
    format "X(21)":U
    no-undo.
def var v_ind_sit_proces
    as character
    format "X(25)":U
    initial "Adto Enviado Aprovador" /*l_adto_enviado_aprovacao*/
    view-as combo-box
    list-items "Digitaá∆o Adto","Controle Reserva","Adto Enviado Aprovador","Adto Enviado Financeiro","Adto Preparado Integrar","Digitaá∆o Acto","Acto Enviado Aprovador","Acto Enviado Financeiro","Acto Preparado Integrar","Acto Pendente Liquidaá∆o","Encerrado"
     /*l_digitacao_adto*/ /*l_controle_reserva*/ /*l_adto_enviado_aprovacao*/ /*l_adto_aprovado*/ /*l_adto_integrado_financ*/ /*l_digitacao_acerto*/ /*l_acerto_enviado_aprov*/ /*l_acerto_aprovado*/ /*l_acerto_integrado_financ*/ /*l_acto_pendente_liquidacao*/ /*l_encerrado*/
    inner-lines 9
    bgcolor 15 font 2
    label "Situaá∆o Processo"
    column-label "Situaá∆o Processo"
    no-undo.
def new global shared var v_log_execution
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def new global shared var v_log_liber_pagto
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def new global shared var v_log_pagto
    as logical
    format "Sim/N∆o"
    initial NO
    view-as toggle-box
    label "Em Pagamento"
    column-label "Em Pagamento"
    no-undo.
def new global shared var v_log_conf
    as logical
    format "Sim/N∆o"
    initial NO
    view-as toggle-box
    label "Confirmado"
    column-label "Confirmado"
    no-undo.
def new global shared var v_log_prepar_pagto
    as logical
    format "Sim/N∆o"
    initial NO    view-as toggle-box
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
def new global shared var v_log_proces_pagto
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def var v_log_refer_antecip_pef
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Antecipaá‰es/PEF"
    no-undo.
def var v_log_refer_antecip_pef_tit
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "T°tulos"
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
def var v_qtd_liber_pagto_tit
    as decimal
    format ">>>9":U
    decimals 0
    label "T°tulos Liberados"
    column-label "T°tulos Liberados"
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
def var v_qtd_prepar_pagto_tit
    as decimal
    format ">9":U
    decimals 0
    label "T°tulos Preparados"
    column-label "T°tulos Preparados"
    no-undo.
def new shared var v_rec_dwb_rpt_select
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_proces_pagto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_liber_pagto
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total na Moeda"
    column-label "Total na Moeda"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_impr                       as logical         no-undo. /*local*/

DEF VAR v_cod_banco             LIKE fornec_financ.cod_banco.
DEF VAR v_cod_agenc_bcia        LIKE fornec_financ.cod_agenc_bcia.
DEF VAR v_cod_digito_agenc_bcia LIKE fornec_financ.cod_digito_agenc_bcia.
DEF VAR v_cod_cta_corren_bco    LIKE fornec_financ.cod_cta_corren_bco.
DEF VAR v_cod_digito_cta_corren LIKE fornec_financ.cod_digito_cta_corren.

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

/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_dwb_rpt_select
    for dwb_rpt_select
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_dwb_rpt_select query qr_dwb_rpt_select display 
    if dwb_rpt_select.log_dwb_rule then "Regra" else "Exceá∆o" format "x(8)" column-label "Tipo"
    dwb_rpt_select.cod_dwb_field
    width-chars 32.00
        column-label "Conjunto"
    dwb_rpt_select.cod_dwb_initial
    width-chars 40.00
        column-label "Inicial"
    dwb_rpt_select.cod_dwb_final
    width-chars 40.00
        column-label "Final"
    with no-box separators single 
         size 38.00 by 05.00
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
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_dimensions
    size 1 by 1
    edge-pixels 2.
def rectangle rt_order
    size 1 by 1
    edge-pixels 2.
def rectangle rt_parameters_label
    size 1 by 1
    edge-pixels 2.
def rectangle rt_run
    size 1 by 1
    edge-pixels 2.
def rectangle rt_select
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
def button bt_down
    label "V"
    tooltip "Desce"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-dw"
    image-insensitive file "image/ii-dw"
&endif
    size 1 by 1.
def button bt_edl1
    label "Alt"
    tooltip "Edita Linha"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-edl"
    image-insensitive file "image/ii-edl"
&endif
    size 1 by 1.
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
def button bt_isl1
    label "Ins"
    tooltip "Insere Linha"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-inl"
    image-insensitive file "image/ii-inl"
&endif
    size 1 by 1.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
def button bt_rml1
    label "Ret"
    tooltip "Retira Linha"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-rml"
    image-insensitive file "image/ii-rml"
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
def button bt_up
    label "A"
    tooltip "Sobe"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-up"
    image-insensitive file "image/ii-up"
&endif
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

/********************** Selection List Definition Begin *********************/

def var ls_order
    as character
    view-as selection-list single
    scrollbar-vertical 
    list-items ""
    size 30 by 5
    bgcolor 15 
    no-undo.


/*********************** Selection List Definition End **********************/

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
def new shared var v_rpt_s_1_columns as integer initial 215.
def new shared var v_rpt_s_1_bottom as integer initial 65.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "Relat¢rio Processos de Pagto".
def frame f_rpt_s_1_header_period header
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "------------------" at 181
    "--" at 199
    "P†gina: " at 202
    (page-number (s_1) + v_rpt_s_1_page) to 215 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    v_nom_report_title at 176 format "x(40)" skip
    "Per°odo: " at 1
    v_dat_inic_period at 10 format "99/99/9999"
    "A" at 21
    v_dat_fim_period at 23 format "99/99/9999"
    "------------------------------------------------------------" at 34
    "------------------------------------------------------------" at 94
    "----------------------------------------" at 154
    "---" at 194
    v_dat_execution at 198 format "99/99/9999"
    "-" at 209
    v_hra_execution at 211 format "99:99" skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "------------------" at 181
    "--" at 199
    "P†gina: " at 202
    (page-number (s_1) + v_rpt_s_1_page) to 215 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 215 format "x(40)" skip
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "----------" at 181
    "------" at 191
    v_dat_execution at 198 format "99/99/9999"
    "-" at 209
    v_hra_execution at 211 format "99:99" skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    skip (1)
    "Èltima p†gina" at 1
    "------------------------------------------------------------" at 15
    "---------------------------------------------------------" at 75
    "------------------------------------------------------------" at 132
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    skip (1)
    "---------------------------------------------------------" at 1
    "------------------------------------------------------------" at 58
    "------------------------------------------------------------" at 118
    "----------" at 178
    "----" at 188
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    skip (1)
    "P†gina ParÉmetros" at 1
    "-----------------------------------------------------" at 22
    "------------------------------------------------------------" at 76
    "--------------------------------------------------" at 136
    "------" at 186
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_Grp_processo_Lay_dat_vencto header
    "Vencto" at 5
    "T°tulo" at 16
    "Emp" at 27
    "Est" at 31
    "Esp" at 35
    "Ser" at 39
    "Fornec" to 53
    "Nome" at 55
    "/P" at 71
    "Seq" to 78
    "Port" at 80
    "Prev Pagto" at 86
    "Dt Descto" at 97
    "Prep Pagto" at 108
    "Dat  Liber" at 119
    "Vl Liber" to 144
    "Vl Lib Orig" to 160
    "Data Pagto" at 162
    "Modo Pagto" at 173
    "Ref Ant/PEF" at 184 skip
    "----------" at 5
    "----------" at 16
    "---" at 27
    "---" at 31
    "---" at 35
    "---" at 39
    "-----------" to 53
    "---------------" at 55
    "--" at 71
    "-----" to 78
    "-----" at 80
    "----------" at 86
    "----------" at 97
    "----------" at 108
    "----------" at 119
    "---------------" to 144
    "---------------" to 160
    "----------" at 162
    "----------" at 173
    "-----------" at 184 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_processo_Lay_espec_doct header
    "Esp" at 5
    "Ser" at 9
    "Emp" at 13
    "Est" at 17
    "Fornec" to 31
    "Nome" at 33
    "T°tulo" at 49
    "/P" at 60
    "Seq" to 67
    "Port" at 69
    "Vencto" at 75
    "Prev Pagto" at 86
    "Dt Descto" at 97
    "Prep Pagto" at 108
    "Dat  Liber" at 119
    "Vl Liber" to 144
    "Vl Lib Orig" to 160
    "Data Pagto" at 162
    "Modo Pagto" at 173
    "Ref Ant/PEF" at 184 skip
    "---" at 5
    "---" at 9
    "---" at 13
    "---" at 17
    "-----------" to 31
    "---------------" at 33
    "----------" at 49
    "--" at 60
    "-----" to 67
    "-----" at 69
    "----------" at 75
    "----------" at 86
    "----------" at 97
    "----------" at 108
    "----------" at 119
    "---------------" to 144
    "---------------" to 160
    "----------" at 162
    "----------" at 173
    "-----------" at 184 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_processo_Lay_estab header
    "Est" at 5
    "Emp" at 9
    "Esp" at 13
    "Ser" at 17
    "Fornec" to 31
    "Nome" at 33
    "T°tulo" at 49
    "/P" at 60
    "Seq" to 67
    "Port" at 69
    "Vencto" at 75
    "Prev Pagto" at 86
    "Dt Descto" at 97
    "Prep Pagto" at 108
    "Dat  Liber" at 119
    "Vl Liber" to 144
    "Vl Lib Orig" to 160
    "Data Pagto" at 162
    "Modo Pagto" at 173
    "Ref Ant/PEF" at 184 skip
    "---" at 5
    "---" at 9
    "---" at 13
    "---" at 17
    "-----------" to 31
    "---------------" at 33
    "----------" at 49
    "--" at 60
    "-----" to 67
    "-----" at 69
    "----------" at 75
    "----------" at 86
    "----------" at 97
    "----------" at 108
    "----------" at 119
    "---------------" to 144
    "---------------" to 160
    "----------" at 162
    "----------" at 173
    "-----------" at 184 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_processo_Lay_fonecedor header
    "Fornec" to 15
    "Nome" at 17
    "Emp" at 33
    "Est" at 37
    "Esp" at 41
    "Ser" at 45
    "T°tulo" at 49
    "/P" at 60
    "Seq" to 67
    "Port" at 69
    "Vencto" at 75
    "Prev Pagto" at 86
    "Dt Descto" at 97
    "Prep Pagto" at 108
    "Dat  Liber" at 119
    "Vl Liber" to 144
    "Vl Lib Orig" to 160
    "Data Pagto" at 162
    "Modo Pagto" at 173
    "Ref Ant/PEF" at 184 skip
    "-----------" to 15
    "---------------" at 17
    "---" at 33
    "---" at 37
    "---" at 41
    "---" at 45
    "----------" at 49
    "--" at 60
    "-----" to 67
    "-----" at 69
    "----------" at 75
    "----------" at 86
    "----------" at 97
    "----------" at 108
    "----------" at 119
    "---------------" to 144
    "---------------" to 160
    "----------" at 162
    "----------" at 173
    "-----------" at 184 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebras_Lay_moeda header
    /* Atributo tt_rpt_proces_pagto.cod_indic_econ ignorado */ skip (2)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebras_Lay_tot_moeda header
    "---------------" at 130 skip
    "Total na Moeda: " at 111
    v_val_liber_pagto to 144 format "->>,>>>,>>>,>>9.99" view-as text skip (4)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_resumo_Lay_soma header
    "Moeda" at 89
    "T°tulos Preparados" to 117
    "Valor Total" to 135 skip
    "--------" at 89
    "------------------" to 117
    "---------------" to 135 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_resumo_Lay_soma_liber header
    "Moeda" at 89
    "Quantidade" to 108
    "Total" to 125 skip
    "--------" at 89
    "----------" to 108
    "---------------" to 125 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_situacao_Lay_processo header
    v_ind_proces_pagto at 97 format "X(21)" view-as text skip (2)
    with no-box no-labels width 215 page-top stream-io.


/*************************** Report Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_rpt_40_proces_pagto
    rt_parameters_label
         at row 08.00 col 02.00
    " ParÉmetros " view-as text
         at row 07.70 col 04.00 bgcolor 8 
    rt_select
         at row 01.50 col 42.00
    " Seleá∆o " view-as text
         at row 01.20 col 44.00
    rt_order
         at row 01.50 col 02.00
    " Classificaá∆o " view-as text
         at row 01.20 col 04.00 bgcolor 8 
    rt_001
         at row 09.50 col 03.00
    " Situaá∆o " view-as text
         at row 09.20 col 05.00
    rt_002
         at row 09.50 col 23.57
    " EspÇcie " view-as text
         at row 09.20 col 25.57
    rt_target
         at row 08.00 col 42.00
    " Destino " view-as text
         at row 07.70 col 44.00 bgcolor 8 
    rt_run
         at row 11.50 col 42.00
    " Execuá∆o " view-as text
         at row 11.20 col 44.00
    rt_dimensions
         at row 11.50 col 68.00
    " Dimens‰es " view-as text
         at row 11.20 col 70.00
    rt_cxcf
         at row 15.00 col 02.00 bgcolor 7 
    ls_order
         at row 02.00 col 04.00
         help "" no-label
    br_dwb_rpt_select
         at row 02.00 col 44.00
    bt_isl1
         at row 02.79 col 83.00 font ?
         help "Insere Linha"
    bt_up
         at row 03.42 col 35.00 font ?
         help "Sobe"
    bt_edl1
         at row 04.00 col 83.00 font ?
         help "Edita Linha"
    bt_down
         at row 04.58 col 35.00 font ?
         help "Desce"
    bt_rml1
         at row 05.21 col 83.00 font ?
         help "Retira Linha"
    rs_cod_dwb_output
         at row 08.50 col 44.00
         help "" no-label
    ed_1x40
         at row 09.50 col 44.00
         help "" no-label
    bt_get_file
         at row 09.50 col 83.00 font ?
         help "Pesquisa Arquivo"
    bt_set_printer
         at row 09.50 col 83.00 font ?
         help "Define Impressora e Layout de Impress∆o"
    v_log_prepar_pagto
         at row 10.08 col 04.43 label "Preparados"
         view-as toggle-box
    v_log_refer_antecip_pef
         at row 10.08 col 24.72 label "Antecip/PEF"
         view-as toggle-box
    v_log_liber_pagto
         at row 11.08 col 04.43 label "Liberados"
         view-as toggle-box
    v_log_refer_antecip_pef_tit
         at row 11.08 col 24.72 label "T°tulos"
         view-as toggle-box
    v_log_pagto
         at row 12.08 col 04.43 label "Em Pagamento"
         help "Em Pagamento ?"
         view-as toggle-box
    rs_ind_run_mode
         at row 12.21 col 44.00
         help "" no-label
    v_qtd_line
         at row 12.21 col 79.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_conf
         at row 13.08 col 04.43 label "Confirmado"
         help "Em Pagamento ?"
         view-as TOGGLE-BOX
    v_log_print_par
         at row 13.21 col 44.00 label "Imprime ParÉmetros"
         view-as toggle-box
    v_qtd_column
         at row 13.21 col 79.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_close
         at row 15.25 col 03.00 font ?
         help "Fecha"
    bt_print
         at row 15.25 col 14.00 font ?
         help "Imprime"
    bt_can
         at row 15.25 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 15.25 col 77.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 17.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relat¢rio Processos de Pagto - ESAPB099".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_rpt_40_proces_pagto = 10.00
           bt_can:height-chars              in frame f_rpt_40_proces_pagto = 01.00
           bt_close:width-chars             in frame f_rpt_40_proces_pagto = 10.00
           bt_close:height-chars            in frame f_rpt_40_proces_pagto = 01.00
           bt_down:width-chars              in frame f_rpt_40_proces_pagto = 04.00
           bt_down:height-chars             in frame f_rpt_40_proces_pagto = 01.13
           bt_edl1:width-chars              in frame f_rpt_40_proces_pagto = 04.00
           bt_edl1:height-chars             in frame f_rpt_40_proces_pagto = 01.13
           bt_get_file:width-chars          in frame f_rpt_40_proces_pagto = 04.00
           bt_get_file:height-chars         in frame f_rpt_40_proces_pagto = 01.08
           bt_hel2:width-chars              in frame f_rpt_40_proces_pagto = 10.00
           bt_hel2:height-chars             in frame f_rpt_40_proces_pagto = 01.00
           bt_isl1:width-chars              in frame f_rpt_40_proces_pagto = 04.00
           bt_isl1:height-chars             in frame f_rpt_40_proces_pagto = 01.13
           bt_print:width-chars             in frame f_rpt_40_proces_pagto = 10.00
           bt_print:height-chars            in frame f_rpt_40_proces_pagto = 01.00
           bt_rml1:width-chars              in frame f_rpt_40_proces_pagto = 04.00
           bt_rml1:height-chars             in frame f_rpt_40_proces_pagto = 01.13
           bt_set_printer:width-chars       in frame f_rpt_40_proces_pagto = 04.00
           bt_set_printer:height-chars      in frame f_rpt_40_proces_pagto = 01.08
           bt_up:width-chars                in frame f_rpt_40_proces_pagto = 04.00
           bt_up:height-chars               in frame f_rpt_40_proces_pagto = 01.13
           ed_1x40:width-chars              in frame f_rpt_40_proces_pagto = 38.00
           ed_1x40:height-chars             in frame f_rpt_40_proces_pagto = 01.00
           ls_order:width-chars             in frame f_rpt_40_proces_pagto = 30.00
           ls_order:height-chars            in frame f_rpt_40_proces_pagto = 05.00
           rt_001:width-chars               in frame f_rpt_40_proces_pagto = 20.00
           rt_001:height-chars              in frame f_rpt_40_proces_pagto = 04.83
           rt_002:width-chars               in frame f_rpt_40_proces_pagto = 16.57
           rt_002:height-chars              in frame f_rpt_40_proces_pagto = 04.83
           rt_cxcf:width-chars              in frame f_rpt_40_proces_pagto = 86.57
           rt_cxcf:height-chars             in frame f_rpt_40_proces_pagto = 01.42
           rt_dimensions:width-chars        in frame f_rpt_40_proces_pagto = 20.57
           rt_dimensions:height-chars       in frame f_rpt_40_proces_pagto = 03.00
           rt_order:width-chars             in frame f_rpt_40_proces_pagto = 39.00
           rt_order:height-chars            in frame f_rpt_40_proces_pagto = 06.00
           rt_parameters_label:width-chars  in frame f_rpt_40_proces_pagto = 39.00
           rt_parameters_label:height-chars in frame f_rpt_40_proces_pagto = 06.50
           rt_run:width-chars               in frame f_rpt_40_proces_pagto = 25.00
           rt_run:height-chars              in frame f_rpt_40_proces_pagto = 03.00
           rt_select:width-chars            in frame f_rpt_40_proces_pagto = 46.57
           rt_select:height-chars           in frame f_rpt_40_proces_pagto = 06.00
           rt_target:width-chars            in frame f_rpt_40_proces_pagto = 46.57
           rt_target:height-chars           in frame f_rpt_40_proces_pagto = 03.00.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_rpt_40_proces_pagto = yes.
    /* set private-data for the help system */
    assign ls_order:private-data                    in frame f_rpt_40_proces_pagto = "HLP=000023561":U
           br_dwb_rpt_select:private-data           in frame f_rpt_40_proces_pagto = "HLP=000023561":U
           bt_isl1:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000008786":U
           bt_up:private-data                       in frame f_rpt_40_proces_pagto = "HLP=000009438":U
           bt_edl1:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000008790":U
           bt_down:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000009436":U
           bt_rml1:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000008792":U
           rs_cod_dwb_output:private-data           in frame f_rpt_40_proces_pagto = "HLP=000023561":U
           ed_1x40:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000023561":U
           bt_get_file:private-data                 in frame f_rpt_40_proces_pagto = "HLP=000008782":U
           bt_set_printer:private-data              in frame f_rpt_40_proces_pagto = "HLP=000008785":U
           v_log_prepar_pagto:private-data          in frame f_rpt_40_proces_pagto = "HLP=000022351":U
           v_log_refer_antecip_pef:private-data     in frame f_rpt_40_proces_pagto = "HLP=000013229":U
           v_log_liber_pagto:private-data           in frame f_rpt_40_proces_pagto = "HLP=000022349":U
           v_log_conf:private-data                  in frame f_rpt_40_proces_pagto = "HLP=000022350":U
           v_log_refer_antecip_pef_tit:private-data in frame f_rpt_40_proces_pagto = "HLP=000013231":U
           v_log_pagto:private-data                 in frame f_rpt_40_proces_pagto = "HLP=000022351":U
           rs_ind_run_mode:private-data             in frame f_rpt_40_proces_pagto = "HLP=000023561":U
           v_qtd_line:private-data                  in frame f_rpt_40_proces_pagto = "HLP=000024737":U
           v_log_print_par:private-data             in frame f_rpt_40_proces_pagto = "HLP=000024662":U
           v_qtd_column:private-data                in frame f_rpt_40_proces_pagto = "HLP=000024669":U
           bt_close:private-data                    in frame f_rpt_40_proces_pagto = "HLP=000009420":U
           bt_print:private-data                    in frame f_rpt_40_proces_pagto = "HLP=000010815":U
           bt_can:private-data                      in frame f_rpt_40_proces_pagto = "HLP=000011050":U
           bt_hel2:private-data                     in frame f_rpt_40_proces_pagto = "HLP=000011326":U
           frame f_rpt_40_proces_pagto:private-data                                = "HLP=000023561".



{include/i_fclfrm.i f_rpt_40_proces_pagto }
/*************************** Frame Definition End ***************************/

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
def var v_prog_filtro_pdf as handle no-undo.

function getCodTipoRelat returns character in v_prog_filtro_pdf.

run prgtec/btb/btb920aa.py persistent set v_prog_filtro_pdf.

run pi_define_objetos in v_prog_filtro_pdf (frame f_rpt_40_proces_pagto:handle,
                       rs_cod_dwb_output:handle in frame f_rpt_40_proces_pagto,
                       bt_get_file:row in frame f_rpt_40_proces_pagto,
                       bt_get_file:col in frame f_rpt_40_proces_pagto).

&endif
/* tech38629 - Fim da alteraá∆o */


/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_down IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.
    def var v_cod_dwb_order
        as character
        format "x(32)":U
        label "Classificaá∆o"
        column-label "Classificador"
        no-undo.
    def var v_num_entry
        as integer
        format ">>>>,>>9":U
        label "Ordem"
        column-label "Ordem"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_dwb_field = ls_order:screen-value in frame f_rpt_40_proces_pagto
           v_cod_dwb_order = ls_order:list-items in frame f_rpt_40_proces_pagto
           v_num_entry     = lookup(v_cod_dwb_field, v_cod_dwb_order).

    if  v_num_entry > 0 and v_num_entry < num-entries (v_cod_dwb_order)
    then do:
        assign entry(v_num_entry, v_cod_dwb_order)      = entry(v_num_entry + 1, v_cod_dwb_order)
               entry(v_num_entry + 1, v_cod_dwb_order)  = v_cod_dwb_field
               ls_order:list-items in frame f_rpt_40_proces_pagto   = v_cod_dwb_order
               ls_order:screen-value in frame f_rpt_40_proces_pagto = v_cod_dwb_field.
    end /* if */.
END. /* ON CHOOSE OF bt_down IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_edl1 IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.


    /************************** Variable Definition End *************************/

    if  br_dwb_rpt_select:num-selected-rows in frame f_rpt_40_proces_pagto = 1
    then do:
        assign v_log_method = br_dwb_rpt_select:fetch-selected-row(1) in frame f_rpt_40_proces_pagto.
        run pi_edl_dwb_rpt_select (Input recid(dwb_rpt_select)) /*pi_edl_dwb_rpt_select*/.
        run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.
    end /* if */.
END. /* ON CHOOSE OF bt_edl1 IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_get_file IN FRAME f_rpt_40_proces_pagto
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign dwb_rpt_param.cod_dwb_file              = v_cod_dwb_file
               ed_1x40:screen-value in frame f_rpt_40_proces_pagto = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_hel2 IN FRAME f_rpt_40_proces_pagto
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_isl1 IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.


    /************************** Variable Definition End *************************/

    run pi_isl_dwb_rpt_select /*pi_isl_dwb_rpt_select*/.
    run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.

END. /* ON CHOOSE OF bt_isl1 IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_print IN FRAME f_rpt_40_proces_pagto
DO:

    if  input frame f_rpt_40_proces_pagto v_log_prepar_pagto = no and
        input frame f_rpt_40_proces_pagto v_log_liber_pagto = no and
        input frame f_rpt_40_proces_pagto v_log_pagto = no
    then do:
        /* &1 deve ser informado(a). */
        run pi_messages (input "show",
                         input 9612,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "Situaá∆o" /*l_situacao2*/)) /*msg_9612*/.
        return no-apply.
    end.

    if  input frame f_rpt_40_proces_pagto v_log_refer_antecip_pef_tit = no and
        input frame f_rpt_40_proces_pagto v_log_refer_antecip_pef     = no
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
    run pi_restricoes in v_prog_filtro_pdf (input rs_cod_dwb_output:screen-value in frame f_rpt_40_proces_pagto).
    if return-value = 'nok' then 
        return no-apply.
&endif
/* tech38629 - Fim da alteraá∆o */
    assign v_log_print = yes.
end.
END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_rml1 IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_rec_dwb_rpt_select
        as recid
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  br_dwb_rpt_select:num-selected-rows = 1 and
        br_dwb_rpt_select:fetch-selected-row(1)
    then do:
        assign v_rec_dwb_rpt_select = recid(dwb_rpt_select).
        find dwb_rpt_select exclusive-lock
             where recid(dwb_rpt_select) = v_rec_dwb_rpt_select /*cl_dwb_rpt_select_recid of dwb_rpt_select*/.
        delete dwb_rpt_select.
        run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.
    end /* if */.

END. /* ON CHOOSE OF bt_rml1 IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_set_printer IN FRAME f_rpt_40_proces_pagto
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
               ed_1x40:screen-value in frame f_rpt_40_proces_pagto = v_nom_dwb_printer
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
                with frame f_rpt_40_proces_pagto.
    end /* if */.

END. /* ON CHOOSE OF bt_set_printer IN FRAME f_rpt_40_proces_pagto */

ON CHOOSE OF bt_up IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.
    def var v_cod_dwb_order
        as character
        format "x(32)":U
        label "Classificaá∆o"
        column-label "Classificador"
        no-undo.
    def var v_num_entry
        as integer
        format ">>>>,>>9":U
        label "Ordem"
        column-label "Ordem"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_dwb_field = ls_order:screen-value in frame f_rpt_40_proces_pagto
           v_cod_dwb_order = ls_order:list-items in frame f_rpt_40_proces_pagto
           v_num_entry = lookup(v_cod_dwb_field, v_cod_dwb_order).

    if  v_num_entry > (1 + 0)
    then do:
        assign entry(v_num_entry, v_cod_dwb_order) = entry(v_num_entry - 1, v_cod_dwb_order)
               entry(v_num_entry - 1, v_cod_dwb_order) = v_cod_dwb_field
               ls_order:list-items in frame f_rpt_40_proces_pagto = v_cod_dwb_order
               ls_order:screen-value in frame f_rpt_40_proces_pagto = v_cod_dwb_field.
    end /* if */.
END. /* ON CHOOSE OF bt_up IN FRAME f_rpt_40_proces_pagto */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_40_proces_pagto
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_40_proces_pagto:
        if  rs_cod_dwb_output:screen-value = "Arquivo" /*l_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
                if  ed_1x40:screen-value  <> ""
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
            assign dwb_rpt_param.cod_dwb_file = ed_1x40:screen-value.
        end /* if */.
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_40_proces_pagto */

ON VALUE-CHANGED OF v_log_liber_pagto IN FRAME f_rpt_40_proces_pagto
DO:
    IF  INPUT frame f_rpt_40_proces_pagto v_log_liber_pagto = YES THEN
        ENABLE v_log_conf with FRAME f_rpt_40_proces_pagto.
    ELSE
        DISABLE v_log_conf with FRAME f_rpt_40_proces_pagto.
END.

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_40_proces_pagto
DO:

    initout:
    do with frame f_rpt_40_proces_pagto:
        /* block: */
        case self:screen-value:
            when "Terminal" /*l_terminal*/ then ter:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_40_proces_pagto v_qtd_line.
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
                        with frame f_rpt_40_proces_pagto.

                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = no
                       bt_get_file:visible    = no
                       bt_set_printer:visible = no.
            end /* do ter */.
            when "Arquivo" /*l_file*/ then fil:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_40_proces_pagto v_qtd_line.
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
                        with frame f_rpt_40_proces_pagto.

                assign ed_1x40:screen-value       = ""
                       ed_1x40:sensitive          = yes
                       bt_set_printer:visible     = no
                       bt_get_file:visible        = yes.

                if  dwb_rpt_param.cod_dwb_print_layout <> "" then
                    assign v_cod_dwb_file_old = dwb_rpt_param.cod_dwb_print_layout.

                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index srmstr_id
    &endif
                      /*cl_current_user of usuar_mestre*/ no-error.
                    assign dwb_rpt_param.cod_dwb_file = "".

                if  rs_ind_run_mode:screen-value in frame f_rpt_40_proces_pagto <> "Batch" /*l_batch*/ 
                then do:
                    if  usuar_mestre.nom_dir_spool <> ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = usuar_mestre.nom_dir_spool
                                                          + "~/".
                    end /* if */.
                end /* if */.

                if  usuar_mestre.nom_subdir_spool <> ""
                then do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                      + usuar_mestre.nom_subdir_spool
                                                      + "~/".
                end /* if */.
                if  v_cod_dwb_file_temp = ""
                then do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                      + caps("esapb099":U)
                                                      + '.rpt'.
                end /* if */.
                else do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                      + v_cod_dwb_file_temp.
                end /* else */.
                assign ed_1x40:screen-value                = dwb_rpt_param.cod_dwb_file
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       v_qtd_line                          = (if v_qtd_line_ant > 0 then v_qtd_line_ant
                                                              else v_rpt_s_1_lines)
    &if '{&emsbas_version}' > '1.00' &then
                       v_nom_dwb_print_file                = ""
    &endif
    .
            end /* do fil */.
            when "Impressora" /*l_printer*/ then prn:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/  and rs_ind_run_mode <> "Batch" /*l_batch*/ 
                then do: 
                    assign v_qtd_line_ant = input frame f_rpt_40_proces_pagto v_qtd_line.
                end /* if */.

                assign ed_1x40:sensitive        = no
                       bt_get_file:visible      = no
                       bt_set_printer:visible   = yes
                       bt_set_printer:sensitive = yes.

                /* define layout default */
                if   v_cod_dwb_file_old <> "" then
                     assign dwb_rpt_param.cod_dwb_print_layout = v_cod_dwb_file_old.

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

                if  dwb_rpt_param.cod_dwb_print_layout <> "" then
                    assign v_cod_dwb_file_old = dwb_rpt_param.cod_dwb_print_layout.

                find layout_impres no-lock
                     where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                       and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                if  avail layout_impres
                then do:
                    assign v_qtd_line               = layout_impres.num_lin_pag.
                end /* if */.
                display v_qtd_line
                        with frame f_rpt_40_proces_pagto.

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
                with frame f_rpt_40_proces_pagto.
    end /* if */.
    else do:
        enable v_qtd_line
               with frame f_rpt_40_proces_pagto.
    end /* else */.

    assign rs_cod_dwb_output.
END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_40_proces_pagto */

ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_40_proces_pagto
DO:

    assign dwb_rpt_param.ind_dwb_run_mode = input frame f_rpt_40_proces_pagto rs_ind_run_mode.

    if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
    then do:
        if  rs_cod_dwb_output:disable("Terminal" /*l_terminal*/ ) in frame f_rpt_40_proces_pagto
        then do:
        end /* if */.
    end /* if */.
    else do:
        if  rs_cod_dwb_output:enable("Terminal" /*l_terminal*/ ) in frame f_rpt_40_proces_pagto
        then do:
        end /* if */.
    end /* else */.
    if  rs_ind_run_mode = "Batch" /*l_batch*/ 
    then do:
        assign v_qtd_line = v_qtd_line_ant.
        display v_qtd_line
                with frame f_rpt_40_proces_pagto.
    end /* if */.
    assign rs_ind_run_mode.
    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_40_proces_pagto.
END. /* ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_40_proces_pagto */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON ENDKEY OF FRAME f_rpt_40_proces_pagto
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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

END. /* ON ENDKEY OF FRAME f_rpt_40_proces_pagto */

ON GO OF FRAME f_rpt_40_proces_pagto
DO:

    assign dwb_rpt_param.cod_dwb_output     = rs_cod_dwb_output:screen-value in frame f_rpt_40_proces_pagto
           dwb_rpt_param.qtd_dwb_line       = input frame f_rpt_40_proces_pagto v_qtd_line
    &if '{&emsbas_version}' > '1.00' &then
    &if '{&emsbas_version}' >= '5.03' &then
           dwb_rpt_param.nom_dwb_print_file = v_nom_dwb_print_file
    &else
           dwb_rpt_param.cod_livre_1 = v_nom_dwb_print_file
    &endif
    &endif
    .
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

    find first dwb_rpt_select no-lock
         where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user
           and dwb_rpt_select.log_dwb_rule = yes /*cl_dwb_rpt_select_rule of dwb_rpt_select*/ no-error.
    if  not avail dwb_rpt_select
    then do:
        /* Incluir ao menos uma regra antes de imprimir. */
        run pi_messages (input "show",
                         input 874,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_874*/.
        return no-apply.
    end /* if */.

END. /* ON GO OF FRAME f_rpt_40_proces_pagto */

ON HELP OF FRAME f_rpt_40_proces_pagto ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_rpt_40_proces_pagto */

ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_40_proces_pagto ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_40_proces_pagto */

ON RIGHT-MOUSE-UP OF FRAME f_rpt_40_proces_pagto ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_rpt_40_proces_pagto */

ON WINDOW-CLOSE OF FRAME f_rpt_40_proces_pagto
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_40_proces_pagto */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_rpt_40_proces_pagto.





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


        assign v_nom_prog     = substring(frame f_rpt_40_proces_pagto:title, 1, max(1, length(frame f_rpt_40_proces_pagto:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "rpt_proces_pagto":U.




    assign v_nom_prog_ext = "prgfin/apb/esapb099.py":U
           v_cod_release  = trim(" 1.00.00.001":U).
    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/.
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


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
    run pi_version_extract ('rpt_proces_pagto':U, 'prgfin/apb/esapb099.py':U, '1.00.00.001':U, 'pro':U).
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
if  v_cod_dwb_user = ""
then do:
    assign v_cod_dwb_user = v_cod_usuar_corren.
end /* if */.

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
    run prgtec/men/men901za.py (Input 'rpt_proces_pagto') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_proces_pagto')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_proces_pagto')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'rpt_proces_pagto' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'rpt_proces_pagto'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_permissoes in v_prog_filtro_pdf (input 'rpt_proces_pagto':U).
&endif
/* tech38629 - Fim da alteraá∆o */




/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "rpt_proces_pagto":U
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


assign v_wgh_frame_epc = frame f_rpt_40_proces_pagto:handle.



assign v_nom_table_epc = 'proces_pagto'
       v_rec_table_epc = recid(proces_pagto).

&endif

/* End_Include: i_verify_program_epc */


/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_rpt_40_proces_pagto:title = frame f_rpt_40_proces_pagto:title
                            + ' - ESAPB099 - '
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_rpt_40_proces_pagto = menu m_help:handle.


/* End_Include: i_std_dialog_box */


/* inicializa vari†veis */
run pi_initialize_reports /*pi_initialize_reports*/.

/* ix_p01_rpt_proces_pagto andrey */

if  v_cod_dwb_user begins 'es_'
then do:
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if  not avail dwb_rpt_param
    then do:
        return "ParÉmetros para o relat¢rio n∆o encontrado." /*1993*/ + " (" + "1993" + ")" + chr(10) + "N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio corrente." /*1993*/.
    end /* if */.

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
    if  ped_exec.cod_release_prog_dtsul <> trim(" 1.00.00.001":U)
    then do:
        return "Vers‰es do programa diferente." /*1994*/ + " (" + "1994" + ")" + chr(10)
                                     + substitute("A vers∆o do programa (&3) que gerou o pedido de execuá∆o batch (&1) Ç diferente da vers∆o do programa que deveria executar o pedido batch (&2)." /*1994*/,ped_exec.cod_release_prog_dtsul,
                                                  trim(" 1.00.00.001":U),
                                                  "esp/apb/esapb099.py":U).
    end /* if */.
    assign v_nom_prog_ext     = caps("esapb099":U)
           v_dat_execution    = today
           v_hra_execution    = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           v_cod_dwb_file     = dwb_rpt_param.cod_dwb_file
           v_nom_report_title = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_ind_dwb_run_mode = "Batch" /*l_batch*/ 
           v_cod_dwb_order    = dwb_rpt_param.cod_dwb_order.

    assign v_log_liber_pagto           = (GetEntryField(1 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_pagto                 = (GetEntryField(2 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_prepar_pagto          = (GetEntryField(3 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_conf                  = (GetEntryField(4 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_refer_antecip_pef     = (GetEntryField(5 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_refer_antecip_pef_tit = (GetEntryField(6 , dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes").

    /* ix_p02_rpt_proces_pagto */

    /* configura e define destino de impress∆o */
    if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
    then do:
         assign v_qtd_line_ant = v_qtd_line.
    end /* if */.
    run pi_output_reports /*pi_output_reports*/.

    if  dwb_rpt_param.log_dwb_print_parameters = yes
    then do:
        run pi_print_parameters /*pi_print_parameters*/.
        /* ix_p30_rpt_proces_pagto */
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
    if (dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U) then do:
        if dwb_rpt_param.nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input yes).
    end.
&endif
    return "OK" /*l_ok*/ .

end /* if */.

pause 0 before-hide.
view frame f_rpt_40_proces_pagto.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(proces_pagto).
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
    assign v_rec_table_epc = recid(proces_pagto).
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
    assign v_rec_table_epc = recid(proces_pagto).
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


/* ix_p05_rpt_proces_pagto */

super_block:
repeat:

    run pi_configure_dwb_param /*pi_configure_dwb_param*/.
    assign v_qtd_line = dwb_rpt_param.qtd_dwb_line.

    init:
    do with frame f_rpt_40_proces_pagto:
        assign rs_cod_dwb_output:screen-value  = dwb_rpt_param.cod_dwb_output
               rs_ind_run_mode:screen-value    = "On-line".
        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
            ed_1x40:screen-value = dwb_rpt_param.cod_dwb_file.
        end /* if */.
        if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
        then do:
            if  not can-find(imprsor_usuar
                    where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                      and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                    use-index imprsrsr_id
&endif
                     /*cl_get_printer of imprsor_usuar*/)
            or   not can-find(layout_impres
                            where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                              and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/)
                            then do:
                run pi_set_print_layout_default /*pi_set_print_layout_default*/.
            end /* if */.
            assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                        + ":"
                                        + dwb_rpt_param.cod_dwb_print_layout.
        end /* if */.
        assign v_log_print_par = dwb_rpt_param.log_dwb_print_parameters.
        display v_log_print_par
                with frame f_rpt_40_proces_pagto.
    end /* do init */.

    display v_qtd_column
            v_qtd_line
            with frame f_rpt_40_proces_pagto.

    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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

    enable ls_order
           br_dwb_rpt_select
           rs_cod_dwb_output
           v_log_print_par
           bt_isl1
           bt_up
           bt_edl1
           bt_down
           bt_rml1
           bt_get_file
           bt_set_printer
           bt_close
           bt_print
           bt_can
           bt_hel2
           v_log_liber_pagto
           v_log_pagto
           v_log_prepar_pagto
           v_log_conf
           v_log_refer_antecip_pef
           v_log_refer_antecip_pef_tit
           with frame f_rpt_40_proces_pagto.

    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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
        assign v_rec_table_epc = recid(proces_pagto).
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


    if  num-entries(v_cod_dwb_order) < 2
    then do:
        disable bt_down
                bt_up
                with frame f_rpt_40_proces_pagto.
    end /* if */.

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
    run pi_posiciona_dwb_rpt_param in v_prog_filtro_pdf (input rowid(dwb_rpt_param)).
    run pi_load_params in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */



    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_40_proces_pagto.


    if  yes = yes
    then do:
        enable rs_ind_run_mode
               with frame f_rpt_40_proces_pagto.
        if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            apply "value-changed" to rs_ind_run_mode in frame f_rpt_40_proces_pagto.
        end /* if */.
    end /* if */.



    /* Begin_Include: ix_p10_rpt_proces_pagto */

    assign v_log_refer_antecip_pef     = yes
           v_log_refer_antecip_pef_tit = yes.


    if  v_log_proces_pagto = yes
    then do: 
       assign  frame f_rpt_40_proces_pagto:title = "Relat¢rio Preparaá∆o de Pagamento" /*l_relatorio_prepar_pagto*/ .
       assign  v_log_pagto        = no
               v_log_prepar_pagto = yes
               v_log_liber_pagto  = no
               v_log_conf         = no.
       disable v_log_prepar_pagto
               v_log_pagto 
               v_log_liber_pagto 
               v_log_conf with frame f_rpt_40_proces_pagto.
    end /* if */.
    if  v_log_proces_pagto = no
    then do: 
       assign  frame f_rpt_40_proces_pagto:title = "Relat¢rio Pagamentos Liberados" /*l_relatorio_liber_pagto*/  .       
       assign  v_log_pagto        = no
               v_log_prepar_pagto = no
               v_log_liber_pagto  = yes.
       disable v_log_prepar_pagto
               v_log_pagto 
               v_log_liber_pagto with frame f_rpt_40_proces_pagto.
    end /* if */.

    if  v_log_proces_pagto = ?
    then do: 
       assign  frame f_rpt_40_proces_pagto:title = "Relat¢rio Processo de Pagamentos - ESAPB099" /*l_relat_pagtos*/ .       
       assign v_log_pagto        = yes
              v_log_prepar_pagto = yes
              v_log_liber_pagto  = yes
              v_log_conf         = YES.
    end /* if */.

    if  v_log_prepar_pagto = no and v_log_liber_pagto = no
    then do: 
       assign v_log_pagto        = yes
              v_log_prepar_pagto = yes
              v_log_liber_pagto  = yes
              v_log_conf         = YES.
    end /* if */.

    assign v_log_pagto        = NO
           v_log_prepar_pagto = NO
           v_log_liber_pagto  = yes
           v_log_conf         = YES.

    display v_log_liber_pagto
            v_log_pagto
            v_log_prepar_pagto
            v_log_conf
            v_log_refer_antecip_pef
            v_log_refer_antecip_pef_tit
            with frame f_rpt_40_proces_pagto.

    /* End_Include: ix_p10_rpt_proces_pagto */


    run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.

    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, leave super_block
                            on endkey undo super_block, leave super_block
                            on stop undo super_block, retry super_block
                            with frame f_rpt_40_proces_pagto:

            if  retry
            then do:
                output stream s_1 close.
            end /* if */.

            assign v_log_print = no.
            if  valid-handle( v_wgh_focus )
            then do:
                wait-for go of frame f_rpt_40_proces_pagto focus v_wgh_focus.
            end /* if */.
            else do:
                wait-for go of frame f_rpt_40_proces_pagto.
            end /* else */.

            /* ix_p15_rpt_proces_pagto */

            assign dwb_rpt_param.cod_dwb_order            = ls_order:list-items
                   dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_40_proces_pagto rs_ind_run_mode
                   v_cod_dwb_order                        = ls_order:list-items
                   dwb_rpt_param.log_dwb_print_parameters = input frame f_rpt_40_proces_pagto v_log_print_par
                   input frame f_rpt_40_proces_pagto v_qtd_line.

            /* Begin_Include: ix_p20_rpt_proces_pagto */

            assign frame f_rpt_40_proces_pagto v_log_liber_pagto
                   frame f_rpt_40_proces_pagto v_log_pagto
                   frame f_rpt_40_proces_pagto v_log_prepar_pagto
                   frame f_rpt_40_proces_pagto v_log_conf
                   frame f_rpt_40_proces_pagto v_log_refer_antecip_pef
                   frame f_rpt_40_proces_pagto v_log_refer_antecip_pef_tit.

            assign dwb_rpt_param.cod_dwb_parameters = string(v_log_liber_pagto)           + chr(10) + 
                                                      string(v_log_pagto)                 + chr(10) + 
                                                      string(v_log_prepar_pagto)          + chr(10) +
                                                      string(v_log_conf)                  + chr(10) +
                                                      string(v_log_refer_antecip_pef)     + chr(10) +
                                                      string(v_log_refer_antecip_pef_tit) + chr(10).

            /* End_Include: ix_p20_rpt_proces_pagto */

            if  v_log_print = yes
            then do:

                if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
                then do:
                    assign v_cod_dwb_file = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/")
                           v_nom_integer = v_cod_dwb_file.

                   if dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/  then do:
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
                               or   length(entry(2, v_cod_dwb_file, ".")) > 3
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
                    end.
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
                                               Input 40,
                                               Input recid(dwb_rpt_param),
                                               output v_num_ped_exec) /*prg_fnc_criac_ped_exec*/.

                    if  v_num_ped_exec <> 0
                    then do:
                        leave main_block.
                    end /* if */.
                    else do:
                        next main_block.
                    end /* else */.

                end /* if */.
                else do:
                    assign v_log_method       = session:set-wait-state('general')
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

                            assign v_cod_dwb_file   = session:temp-directory + "esapb099":U + '.tmp'
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
                    assign v_nom_prog_ext = caps(substring("esp/apb/esapb099.py",12,8))
                           v_dat_execution = today
                           v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").

                    run pi_rpt_proces_pagto /*pi_rpt_proces_pagto*/.
                end /* else */.

                if  dwb_rpt_param.log_dwb_print_parameters = yes
                then do:
                    run pi_print_parameters /*pi_print_parameters*/.
                    /* ix_p30_rpt_proces_pagto */
                end /* if */.

                output stream s_1 close.

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input no,
                                                 input rs_cod_dwb_output:screen-value in frame f_rpt_40_proces_pagto,
                                                 input v_nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U &then
    if (dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U) then do:
        if v_nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input no).
    end.
&endif
                assign v_log_method = session:set-wait-state("").
                if  dwb_rpt_param.cod_dwb_output = "Terminal" /*l_terminal*/ 
                then do:
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
                end /* if */.
                leave main_block.

            end /* if */.
            else do:
                leave super_block.
            end /* else */.

        end /* repeat main_block */.

        if  v_num_ped_exec <> 0
        then do:
            /* Criado pedido &1 para execuá∆o batch. */
            run pi_messages (input "show",
                             input 3556,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_ped_exec)) /*msg_3556*/.
            assign v_num_ped_exec = 0.
        end /* if */.

    end /* repeat block1 */.
end /* repeat super_block */.

hide frame f_rpt_40_proces_pagto.

/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
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
** Procedure Interna.....: pi_open_dwb_rpt_select
** Descricao.............: pi_open_dwb_rpt_select
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 25/04/1995 16:13:44
*****************************************************************************/
PROCEDURE pi_open_dwb_rpt_select:

    open query qr_dwb_rpt_select for
        each dwb_rpt_select no-lock
        where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
          and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/
            by dwb_rpt_select.log_dwb_rule descending
            by dwb_rpt_select.num_dwb_order.

END PROCEDURE. /* pi_open_dwb_rpt_select */
/*****************************************************************************
** Procedure Interna.....: pi_isl_dwb_rpt_select
** Descricao.............: pi_isl_dwb_rpt_select
** Criado por............: roger
** Criado em.............: // 
** Alterado por..........: izaura
** Alterado em...........: 21/05/1998 15:47:57
*****************************************************************************/
PROCEDURE pi_isl_dwb_rpt_select:

    /************************* Variable Definition Begin ************************/

    def var v_num_dwb_order
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_wgh_fill_in_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_fill_in_ini
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
    def var v_log_ok                         as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

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


    /************************* Rectangle Definition End *************************/

    /************************** Button Definition Begin *************************/

    def button bt_can
        label "Cancela"
        tooltip "Cancela"
        size 1 by 1
        auto-endkey.
    def button bt_hel2
        label "Ajuda"
        tooltip "Ajuda"
        size 1 by 1.
    def button bt_ok
        label "OK"
        tooltip "OK"
        size 1 by 1
        auto-go.
    def button bt_sav
        label "Salva"
        tooltip "Salva"
        size 1 by 1
        auto-go.
    /****************************** Function Button *****************************/


    /*************************** Button Definition End **************************/

    /************************** Frame Definition Begin **************************/

    def frame f_dlg_04_dwb_rpt_select
        rt_001
             at row 01.25 col 02.00
        rt_002
             at row 02.75 col 03.00
        " Conjunto " view-as text
             at row 02.45 col 05.00
        rt_cxcf
             at row 08.17 col 02.00 bgcolor 7 
        dwb_rpt_select.log_dwb_rule
             at row 01.50 col 03.14 no-label
             view-as radio-set Horizontal
             radio-buttons "Regra", yes,"Exceá∆o", no
              /*l_rule*/ /*l_yes*/ /*l_exception*/ /*l_no*/
             bgcolor 8 
        dwb_rpt_select.cod_dwb_field
             at row 03.21 col 04.29 no-label
             view-as combo-box
             list-items "!"
              /*l_!*/
             inner-lines 5
             bgcolor 15 font 2
        bt_ok
             at row 08.38 col 03.00 font ?
             help "OK"
        bt_sav
             at row 08.38 col 14.00 font ?
             help "Salva"
        bt_can
             at row 08.38 col 25.00 font ?
             help "Cancela"
        bt_hel2
             at row 08.38 col 51.13 font ?
             help "Ajuda"
        with 1 down side-labels no-validate keep-tab-order three-d
             size-char 63.57 by 10.00 default-button bt_sav
             view-as dialog-box
             font 1 fgcolor ? bgcolor 8
             title "Conjunto de Seleá∆o".
        /* adjust size of objects in this frame */
        assign bt_can:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_can:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_hel2:width-chars  in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_hel2:height-chars in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_ok:width-chars    in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_ok:height-chars   in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_sav:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_sav:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               rt_001:width-chars   in frame f_dlg_04_dwb_rpt_select = 60.00
               rt_001:height-chars  in frame f_dlg_04_dwb_rpt_select = 06.75
               rt_002:width-chars   in frame f_dlg_04_dwb_rpt_select = 58.00
               rt_002:height-chars  in frame f_dlg_04_dwb_rpt_select = 05.00
               rt_cxcf:width-chars  in frame f_dlg_04_dwb_rpt_select = 60.13
               rt_cxcf:height-chars in frame f_dlg_04_dwb_rpt_select = 01.42.
        /* set private-data for the help system */
        assign dwb_rpt_select.log_dwb_rule:private-data  in frame f_dlg_04_dwb_rpt_select = "HLP=000000000":U
               dwb_rpt_select.cod_dwb_field:private-data in frame f_dlg_04_dwb_rpt_select = "HLP=000000000":U
               bt_ok:private-data                        in frame f_dlg_04_dwb_rpt_select = "HLP=000010721":U
               bt_sav:private-data                       in frame f_dlg_04_dwb_rpt_select = "HLP=000011048":U
               bt_can:private-data                       in frame f_dlg_04_dwb_rpt_select = "HLP=000011050":U
               bt_hel2:private-data                      in frame f_dlg_04_dwb_rpt_select = "HLP=000011326":U
               frame f_dlg_04_dwb_rpt_select:private-data                                 = "HLP=000000000".



{include/i_fclfrm.i f_dlg_04_dwb_rpt_select }
    /*************************** Frame Definition End ***************************/

    /*********************** User Interface Trigger Begin ***********************/


    ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select
    DO:


        /* Begin_Include: i_context_help_frame */
        run prgtec/men/men900za.py (Input self:frame,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


        /* End_Include: i_context_help_frame */

    END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select */

    ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_log_ok = yes.
    END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_cod_dwb_field = self:screen-value in frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_proces_pagto /*pi_isl_rpt_proces_pagto*/.

        if  v_wgh_label_ini = ?
        then do:
            create text v_wgh_label_ini
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "Inicial:" /*l_Inicial:*/ 
                    visible      = no
                    row          = 5
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_ini }
        end /* if */.

        if  v_wgh_label_fim = ?
        then do:
            create text v_wgh_label_fim
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "  Final:" /*l_bbfinal:*/ 
                    visible      = no
                    row          = 6
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_fim }
        end /* if */.

        if  v_wgh_fill_in_ini <> ?
        then do:
            delete widget v_wgh_fill_in_ini.
        end /* if */.

        create fill-in v_wgh_fill_in_ini
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_ini:handle
                   row                = 5
                   column             = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        if  v_wgh_fill_in_fim <> ?
        then do:
            delete widget v_wgh_fill_in_fim.
        end /* if */.

        create fill-in v_wgh_fill_in_fim
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_fim:handle
                   row                = 6
                   col                = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_final.
{include/i_fcldin.i v_wgh_fill_in_fim }

    END. /* ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        /************************** Buffer Definition Begin *************************/

        def buffer b_dwb_rpt_select
            for dwb_rpt_select.


        /*************************** Buffer Definition End **************************/

        find last b_dwb_rpt_select
            where b_dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
            and   b_dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
            and   b_dwb_rpt_select.log_dwb_rule    = (dwb_rpt_select.log_dwb_rule:screen-value = 'yes')
            no-lock no-error.
        if  not available b_dwb_rpt_select
        then do:
            assign v_num_dwb_order = (if dwb_rpt_select.log_dwb_rule:screen-value = 'yes' then 10 else 500).
        end /* if */.
        else do:
            assign v_num_dwb_order = b_dwb_rpt_select.num_dwb_order + 10.
        end /* else */.
    END. /* ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select */


    /************************ User Interface Trigger End ************************/

    /**************************** Frame Trigger Begin ***************************/


    ON GO OF FRAME f_dlg_04_dwb_rpt_select
    DO:

        if  (v_wgh_fill_in_ini:data-type = 'character' and v_wgh_fill_in_ini:screen-value > v_wgh_fill_in_fim:screen-value) or
             (v_wgh_fill_in_ini:data-type = 'date'      and date(v_wgh_fill_in_ini:screen-value) > date(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = "integer" /*l_integer*/    and integer(v_wgh_fill_in_ini:screen-value) > integer(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = 'Decimal'   and decimal(v_wgh_fill_in_ini:screen-value) > decimal(v_wgh_fill_in_fim:screen-value))
        then do:
            /* Argumento Inicial maior que o Final ! */
            run pi_messages (input "show",
                             input 1085,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1085*/.
            return no-apply.
        end /* if */.

    END. /* ON GO OF FRAME f_dlg_04_dwb_rpt_select */

    ON HELP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:


        /* Begin_Include: i_context_help */
        run prgtec/men/men900za.py (Input self:handle,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
        /* End_Include: i_context_help */

    END. /* ON HELP OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
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

    END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
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

    END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select */


    /***************************** Frame Trigger End ****************************/

    pause 0 before-hide.
    view frame f_dlg_04_dwb_rpt_select.

    assign v_log_ok = no
           frame f_dlg_04_dwb_rpt_select:title = "Inclui" /*l_inclui*/  + " Conjunto de Seleá∆o" /*l_conjunto_selecao*/ .

    main_block:
    repeat while v_log_ok = no
        on endkey undo main_block, leave main_block
        on error undo main_block, leave main_block:

        find last dwb_rpt_select no-lock
             where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/ no-error.
        if  not available dwb_rpt_select
        then do:
            assign v_num_dwb_order = 10.
        end /* if */.
        else do:
            assign v_num_dwb_order = dwb_rpt_select.num_dwb_order + 10.
        end /* else */.

        create dwb_rpt_select.
        assign dwb_rpt_select.log_dwb_rule = yes.

        assign dwb_rpt_select.cod_dwb_field:list-items in frame f_dlg_04_dwb_rpt_select = v_cod_dwb_select
               dwb_rpt_select.cod_dwb_field:screen-value = entry(1,v_cod_dwb_select).

        display dwb_rpt_select.log_dwb_rule
                with frame f_dlg_04_dwb_rpt_select.
        enable dwb_rpt_select.log_dwb_rule
               dwb_rpt_select.cod_dwb_field
               bt_ok
               bt_sav
               bt_can
               with frame f_dlg_04_dwb_rpt_select.
        apply "value-changed" to dwb_rpt_select.cod_dwb_field in frame f_dlg_04_dwb_rpt_select.
        apply "value-changed" to dwb_rpt_select.log_dwb_rule  in frame f_dlg_04_dwb_rpt_select.

        wait-for go of frame f_dlg_04_dwb_rpt_select.

        assign dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
               dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
               dwb_rpt_select.num_dwb_order   = v_num_dwb_order
               dwb_rpt_select.cod_dwb_initial = v_wgh_fill_in_ini:screen-value
               dwb_rpt_select.cod_dwb_final   = v_wgh_fill_in_fim:screen-value
               dwb_rpt_select.log_dwb_rule
               dwb_rpt_select.cod_dwb_field.

    end /* repeat main_block */.

    hide frame f_dlg_04_dwb_rpt_select.
END PROCEDURE. /* pi_isl_dwb_rpt_select */
/*****************************************************************************
** Procedure Interna.....: pi_edl_dwb_rpt_select
** Descricao.............: pi_edl_dwb_rpt_select
** Criado por............: roger
** Criado em.............: // 
** Alterado por..........: izaura
** Alterado em...........: 21/09/1999 10:13:00
*****************************************************************************/
PROCEDURE pi_edl_dwb_rpt_select:

    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_dwb_rpt_select
        as recid
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_dwb_order
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_wgh_fill_in_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_fill_in_ini
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
    def var v_log_ok                         as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

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


    /************************* Rectangle Definition End *************************/

    /************************** Button Definition Begin *************************/

    def button bt_can
        label "Cancela"
        tooltip "Cancela"
        size 1 by 1
        auto-endkey.
    def button bt_hel2
        label "Ajuda"
        tooltip "Ajuda"
        size 1 by 1.
    def button bt_ok
        label "OK"
        tooltip "OK"
        size 1 by 1
        auto-go.
    def button bt_sav
        label "Salva"
        tooltip "Salva"
        size 1 by 1
        auto-go.
    /****************************** Function Button *****************************/


    /*************************** Button Definition End **************************/

    /************************** Frame Definition Begin **************************/

    def frame f_dlg_04_dwb_rpt_select
        rt_001
             at row 01.25 col 02.00
        rt_002
             at row 02.75 col 03.00
        " Conjunto " view-as text
             at row 02.45 col 05.00
        rt_cxcf
             at row 08.17 col 02.00 bgcolor 7 
        dwb_rpt_select.log_dwb_rule
             at row 01.50 col 03.14 no-label
             view-as radio-set Horizontal
             radio-buttons "Regra", yes,"Exceá∆o", no
              /*l_rule*/ /*l_yes*/ /*l_exception*/ /*l_no*/
             bgcolor 8 
        dwb_rpt_select.cod_dwb_field
             at row 03.21 col 04.29 no-label
             view-as combo-box
             list-items "!"
              /*l_!*/
             inner-lines 5
             bgcolor 15 font 2
        bt_ok
             at row 08.38 col 03.00 font ?
             help "OK"
        bt_sav
             at row 08.38 col 14.00 font ?
             help "Salva"
        bt_can
             at row 08.38 col 25.00 font ?
             help "Cancela"
        bt_hel2
             at row 08.38 col 51.13 font ?
             help "Ajuda"
        with 1 down side-labels no-validate keep-tab-order three-d
             size-char 63.57 by 10.00 default-button bt_sav
             view-as dialog-box
             font 1 fgcolor ? bgcolor 8
             title "Conjunto de Seleá∆o".
        /* adjust size of objects in this frame */
        assign bt_can:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_can:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_hel2:width-chars  in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_hel2:height-chars in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_ok:width-chars    in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_ok:height-chars   in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_sav:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_sav:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               rt_001:width-chars   in frame f_dlg_04_dwb_rpt_select = 60.00
               rt_001:height-chars  in frame f_dlg_04_dwb_rpt_select = 06.75
               rt_002:width-chars   in frame f_dlg_04_dwb_rpt_select = 58.00
               rt_002:height-chars  in frame f_dlg_04_dwb_rpt_select = 05.00
               rt_cxcf:width-chars  in frame f_dlg_04_dwb_rpt_select = 60.13
               rt_cxcf:height-chars in frame f_dlg_04_dwb_rpt_select = 01.42.
        /* set private-data for the help system */
        assign dwb_rpt_select.log_dwb_rule:private-data  in frame f_dlg_04_dwb_rpt_select = "HLP=000000000":U
               dwb_rpt_select.cod_dwb_field:private-data in frame f_dlg_04_dwb_rpt_select = "HLP=000000000":U
               bt_ok:private-data                        in frame f_dlg_04_dwb_rpt_select = "HLP=000010721":U
               bt_sav:private-data                       in frame f_dlg_04_dwb_rpt_select = "HLP=000011048":U
               bt_can:private-data                       in frame f_dlg_04_dwb_rpt_select = "HLP=000011050":U
               bt_hel2:private-data                      in frame f_dlg_04_dwb_rpt_select = "HLP=000011326":U
               frame f_dlg_04_dwb_rpt_select:private-data                                 = "HLP=000000000".



{include/i_fclfrm.i f_dlg_04_dwb_rpt_select }
    /*************************** Frame Definition End ***************************/

    /*********************** User Interface Trigger Begin ***********************/


    ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select
    DO:


        /* Begin_Include: i_context_help_frame */
        run prgtec/men/men900za.py (Input self:frame,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


        /* End_Include: i_context_help_frame */

    END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select */

    ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_log_ok = yes.
    END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_cod_dwb_field = self:screen-value in frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_proces_pagto /*pi_isl_rpt_proces_pagto*/.

        if  v_wgh_label_ini = ?
        then do:
            create text v_wgh_label_ini
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "Inicial:" /*l_Inicial:*/ 
                    visible      = no
                    row          = 5
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_ini }
        end /* if */.

        if  v_wgh_label_fim = ?
        then do:
            create text v_wgh_label_fim
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "  Final:" /*l_bbfinal:*/ 
                    visible      = no
                    row          = 6
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_fim }
        end /* if */.

        if  v_wgh_fill_in_ini <> ?
        then do:
            delete widget v_wgh_fill_in_ini.
        end /* if */.

        create fill-in v_wgh_fill_in_ini
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_ini:handle
                   row                = 5
                   column             = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        if  v_wgh_fill_in_fim <> ?
        then do:
            delete widget v_wgh_fill_in_fim.
        end /* if */.

        create fill-in v_wgh_fill_in_fim
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_fim:handle
                   row                = 6
                   col                = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_final.
{include/i_fcldin.i v_wgh_fill_in_fim }

    END. /* ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        /************************** Buffer Definition Begin *************************/

        def buffer b_dwb_rpt_select
            for dwb_rpt_select.


        /*************************** Buffer Definition End **************************/

        find last b_dwb_rpt_select
            where b_dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
            and   b_dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
            and   b_dwb_rpt_select.log_dwb_rule    = (dwb_rpt_select.log_dwb_rule:screen-value = 'yes')
            no-lock no-error.
        if  not available b_dwb_rpt_select
        then do:
            assign v_num_dwb_order = (if dwb_rpt_select.log_dwb_rule:screen-value = 'yes' then 10 else 500).
        end /* if */.
        else do:
            assign v_num_dwb_order = b_dwb_rpt_select.num_dwb_order + 10.
        end /* else */.
    END. /* ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select */


    /************************ User Interface Trigger End ************************/

    /**************************** Frame Trigger Begin ***************************/


    ON GO OF FRAME f_dlg_04_dwb_rpt_select
    DO:

        if  (v_wgh_fill_in_ini:data-type = 'character' and v_wgh_fill_in_ini:screen-value > v_wgh_fill_in_fim:screen-value) or
             (v_wgh_fill_in_ini:data-type = 'date'      and date(v_wgh_fill_in_ini:screen-value) > date(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = "integer" /*l_integer*/    and integer(v_wgh_fill_in_ini:screen-value) > integer(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = 'Decimal'   and decimal(v_wgh_fill_in_ini:screen-value) > decimal(v_wgh_fill_in_fim:screen-value))
        then do:
            /* Argumento Inicial maior que o Final ! */
            run pi_messages (input "show",
                             input 1085,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1085*/.
            return no-apply.
        end /* if */.

    END. /* ON GO OF FRAME f_dlg_04_dwb_rpt_select */

    ON HELP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:


        /* Begin_Include: i_context_help */
        run prgtec/men/men900za.py (Input self:handle,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
        /* End_Include: i_context_help */

    END. /* ON HELP OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
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

    END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
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

    END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select */


    /***************************** Frame Trigger End ****************************/

    pause 0 before-hide.
    view frame f_dlg_04_dwb_rpt_select.

    assign v_log_ok = no
           frame f_dlg_04_dwb_rpt_select:title = "Edita" /*l_edita*/  + " Conjunto de Seleá∆o" /*l_conjunto_selecao*/ .

    main_block:
    repeat while v_log_ok = no
        on endkey undo main_block, leave main_block
        on error undo main_block, leave main_block:

        find dwb_rpt_select where recid(dwb_rpt_select) = p_rec_dwb_rpt_select exclusive-lock.

        assign dwb_rpt_select.cod_dwb_field:list-items in frame f_dlg_04_dwb_rpt_select = v_cod_dwb_select
               v_cod_dwb_field = dwb_rpt_select.cod_dwb_field.

        display dwb_rpt_select.log_dwb_rule
                dwb_rpt_select.cod_dwb_field
                with frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_proces_pagto /*pi_isl_rpt_proces_pagto*/.

        create text v_wgh_label_ini
            assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                screen-value = "Inicial:" /*l_Inicial:*/ 
                visible      = no
                row          = 5
                col          = 12
                width        = 7.
{include/i_fcldin.i v_wgh_label_ini }

        create text v_wgh_label_fim
            assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                screen-value = "  Final:" /*l_bbfinal:*/ 
                visible      = no
                row          = 6
                col          = 12
                width        = 7.
{include/i_fcldin.i v_wgh_label_fim }

        create fill-in v_wgh_fill_in_ini
            assign frame          = frame f_dlg_04_dwb_rpt_select:handle
               font               = 2
               data-type          = v_cod_dat_type
               format             = v_cod_format
               side-label-handle  = v_wgh_label_ini:handle
               row                = 5
               column             = 19
               height             = 0.88
               bgcolor            = 15
               visible            = yes
               sensitive          = yes
               screen-value       = dwb_rpt_select.cod_dwb_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        create fill-in v_wgh_fill_in_fim
            assign frame          = frame f_dlg_04_dwb_rpt_select:handle
               font               = 2
               data-type          = v_cod_dat_type
               format             = v_cod_format
               side-label-handle  = v_wgh_label_fim:handle
               row                = 6
               col                = 19
               height             = 0.88
               bgcolor            = 15
               visible            = yes
               sensitive          = yes
               screen-value       = dwb_rpt_select.cod_dwb_final.
{include/i_fcldin.i v_wgh_fill_in_fim }


        disable dwb_rpt_select.log_dwb_rule
                dwb_rpt_select.cod_dwb_field
                with frame f_dlg_04_dwb_rpt_select.

        enable bt_ok
               bt_can
               with frame f_dlg_04_dwb_rpt_select.

        wait-for go of frame f_dlg_04_dwb_rpt_select.

        assign dwb_rpt_select.cod_dwb_initial = v_wgh_fill_in_ini:screen-value
               dwb_rpt_select.cod_dwb_final   = v_wgh_fill_in_fim:screen-value.

    end /* repeat main_block */.

    hide frame f_dlg_04_dwb_rpt_select.

END PROCEDURE. /* pi_edl_dwb_rpt_select */
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: michelle
** Alterado em...........: 10/02/2000 17:30:59
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

    if  index(v_cod_1, "~/~/") > 0
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
    do with frame f_rpt_40_proces_pagto:

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
** Procedure Interna.....: pi_print_parameters
** Descricao.............: pi_print_parameters
** Criado por............: gilsinei
** Criado em.............: 04/09/1996 10:46:51
** Alterado por..........: gilsinei
** Alterado em...........: 04/09/1996 10:48:34
*****************************************************************************/
PROCEDURE pi_print_parameters:

    if  page-number (s_1) > 0
    then do:
        page stream s_1.
    end /* if */.

    hide stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_footer_normal.
    view stream s_1 frame f_rpt_s_1_footer_param_page.
    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        skip (1)
        "Usu†rio: " at 1
        v_cod_usuar_corren at 10 format "x(12)" skip (1).

    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        "Ordem" to 5
        "Classificador" at 7 skip
        "-----" to 5
        "--------------------------------" at 7 skip.
    1_block:
    repeat v_num_entry = 1 to num-entries (v_cod_dwb_order):
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            V_nuM_entry to 5 format ">>>>9"
            entry(v_num_entry,v_cod_dwb_order) at 7 format "x(32)" skip.
    end /* repeat 1_block */.

    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        skip (1)
        "Tipo" at 1
        "Conjunto" at 9
        "Inicial" at 42
        "Final" at 61 skip
        "-------" at 1
        "--------------------------------" at 9
        "------------------" at 42
        "------------------" at 61 skip.
    ler:
    for each dwb_rpt_select no-lock
     where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
       and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/:
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            dwb_rpt_select.log_dwb_rule at 1 format "Regra/Exceá∆o"
            dwb_rpt_select.cod_dwb_field at 9 format "x(32)"
            dwb_rpt_select.cod_dwb_initial at 42 format "x(18)"
            dwb_rpt_select.cod_dwb_final at 61 format "x(18)" skip.
    end /* for ler */.

END PROCEDURE. /* pi_print_parameters */
/*****************************************************************************
** Procedure Interna.....: pi_initialize_reports
** Descricao.............: pi_initialize_reports
** Criado por............: glauco
** Criado em.............: 21/03/1997 09:22:53
** Alterado por..........: izaura
** Alterado em...........: 06/04/2000 11:05:33
*****************************************************************************/
PROCEDURE pi_initialize_reports:

    /* inicializa vari†veis */
    find emscad.empresa no-lock
         where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.
    find dwb_rpt_param
         where dwb_rpt_param.cod_dwb_program = "esapb099":U
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

    assign v_cod_dwb_proced   = "esapb099":U
           v_cod_dwb_program  = "esapb099":U
           v_cod_dwb_order    = "Estabelecimento,Fornecedor,EspÇcie Documento,Data Vencimento,Data Liberaá∆o"
           v_cod_release      = trim(" 1.00.00.001":U)
           v_cod_dwb_select   = "Estabelecimento,Fornecedor,EspÇcie Documento,Data Vencimento,Data Liberaá∆o"
           v_ind_dwb_run_mode = "On-Line" /*l_online*/ 
           v_qtd_column       = v_rpt_s_1_columns
           v_qtd_bottom       = v_rpt_s_1_bottom.
    if  avail empresa
    then do:
        assign v_nom_enterprise   = empresa.nom_razao_social.
    end /* if */.
    else do:
        assign v_nom_enterprise   = 'DATASUL'.
    end /* else */.
END PROCEDURE. /* pi_initialize_reports */
/*****************************************************************************
** Procedure Interna.....: pi_configure_dwb_param
** Descricao.............: pi_configure_dwb_param
** Criado por............: glauco
** Criado em.............: 21/03/1997 10:15:36
** Alterado por..........: izaura
** Alterado em...........: 21/09/1999 10:15:13
*****************************************************************************/
PROCEDURE pi_configure_dwb_param:

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
                   dwb_rpt_param.cod_dwb_order           = v_cod_dwb_order
                   dwb_rpt_param.ind_dwb_run_mode        = "On-Line" /*l_online*/ 
                   dwb_rpt_param.cod_dwb_file            = ""
                   dwb_rpt_param.nom_dwb_printer         = ""
                   dwb_rpt_param.cod_dwb_print_layout    = ""
                   v_cod_dwb_file_temp                   = ""
                   ls_order:list-items in frame f_rpt_40_proces_pagto = v_cod_dwb_order.
        end /* if */.
        else do:
            assign ls_order:list-items in frame f_rpt_40_proces_pagto = "!".
            if  ls_order:delete(1) in frame f_rpt_40_proces_pagto
            then do:
                order_1:
                repeat v_num_entry = 1 to num-entries (dwb_rpt_param.cod_dwb_order):
                    assign v_cod_dwb_field = entry (v_num_entry, dwb_rpt_param.cod_dwb_order).
                    if  lookup (v_cod_dwb_field, v_cod_dwb_order) > 0 and
                        ls_order:lookup (v_cod_dwb_field) = 0
                    then do:
                        assign v_log_method = ls_order:add-last(v_cod_dwb_field).
                    end /* if */.
                end /* repeat order_1 */.
                order_2:
                repeat v_num_entry = 1 to num-entries (v_cod_dwb_order):
                    assign v_cod_dwb_field = entry (v_num_entry, v_cod_dwb_order).
                    if  ls_order:lookup (v_cod_dwb_field) = 0
                    then do:
                       assign v_log_method = ls_order:add-last(v_cod_dwb_field).
                    end /* if */.
                end /* repeat order_2 */.
            end /* if */.

            assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
            if  index(v_cod_dwb_file_temp, "~/") <> 0
            then do:
                assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
            end /* if */.
            else do:
                assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
            end /* else */.
        end /* else */.
END PROCEDURE. /* pi_configure_dwb_param */
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

    run pi_rpt_proces_pagto /*pi_rpt_proces_pagto*/.
END PROCEDURE. /* pi_output_reports */
/*****************************************************************************
** Procedure Interna.....: pi_isl_rpt_proces_pagto
** Descricao.............: pi_isl_rpt_proces_pagto
** Criado por............: Diocalisto
** Criado em.............: // 
** Alterado por..........: Emerson
** Alterado em...........: 12/12/1997 14:34:14
*****************************************************************************/
PROCEDURE pi_isl_rpt_proces_pagto:

    /* formato: */
    case v_cod_dwb_field:
        when "Estabelecimento" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(3)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZ":U, v_cod_format).
        when "Fornecedor" then
            assign v_cod_dat_type = "Integer"
                   v_cod_format   = ">>>,>>>,>>9":U
                   v_cod_initial  = string(0, v_cod_format)
                   v_cod_final    = string(999999999, v_cod_format).
        when "EspÇcie Documento" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(3)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZ":U, v_cod_format).
        when "Data Vencimento" then
            assign v_cod_dat_type = "date"
                   v_cod_format   = "99/99/9999":U
                   v_cod_initial  = string(01/01/0001, v_cod_format)
                   v_cod_final    = string(12/31/9999, v_cod_format).
        when "Data Liberaá∆o" then
            assign v_cod_dat_type = "date"
                   v_cod_format   = "99/99/9999":U
                   v_cod_initial  = string(01/01/0001, v_cod_format)
                   v_cod_final    = string(12/31/9999, v_cod_format).
    end /* case formato */.
END PROCEDURE. /* pi_isl_rpt_proces_pagto */
/*****************************************************************************
** Procedure Interna.....: pi_ler_tt_rpt_proces_pagto
** Descricao.............: pi_ler_tt_rpt_proces_pagto
** Criado por............: Ganzen
** Criado em.............: // 
** Alterado por..........: fut1090
** Alterado em...........: 06/08/2004 08:38:54
*****************************************************************************/
PROCEDURE pi_ler_tt_rpt_proces_pagto:

    assign v_ind_sit_proces = ''.

    if v_log_prepar_pagto = yes then
       if v_ind_sit_proces <> '' then
          assign v_ind_sit_proces = v_ind_sit_proces + ',' + "Preparado" /*l_preparado*/ .
       else
          assign v_ind_sit_proces = "Preparado" /*l_preparado*/ .
    if v_log_liber_pagto    = yes then
       if v_ind_sit_proces <> '' then
          assign v_ind_sit_proces = v_ind_sit_proces + ',' + "Liberado" /*l_liberado*/ .
       else
          assign v_ind_sit_proces = "Liberado" /*l_liberado*/ .
    if v_log_pagto = yes then
       if v_ind_sit_proces <> '' then
          assign v_ind_sit_proces = v_ind_sit_proces + ',' + "Em Pagamento" /*l_em_pagamento*/ .
       else
          assign v_ind_sit_proces = "Em Pagamento" /*l_em_pagamento*/ .

    if v_log_conf = yes then DO:
       if v_ind_sit_proces <> '' then
          assign v_ind_sit_proces = v_ind_sit_proces + ',' + "Confirmado" /*l_confirmado*/ .
       else
          assign v_ind_sit_proces = "Confirmado" /*l_confirmado*/ .
    END.

    selecao:
    for
        each dwb_rpt_select no-lock
        where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
          and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/ 
        use-index dwbrptsl_id:
        do v_num_cont_aux = 1 to num-entries(v_ind_sit_proces):
            if  dwb_rpt_select.cod_dwb_field = "Estabelecimento"
            then do:
               for each estabelecimento no-lock
                   where estabelecimento.cod_empresa = v_cod_empres_usuar   
                   and   estabelecimento.cod_estab   >= dwb_rpt_select.cod_dwb_initial
                   and   estabelecimento.cod_estab   <= dwb_rpt_select.cod_dwb_final :
                   block:
                   for
                       each proces_pagto no-lock
                       where proces_pagto.cod_estab = estabelecimento.cod_estab
                         and proces_pagto.ind_sit_proces_pagto = entry(v_num_cont_aux, v_ind_sit_proces)
                         and ((proces_pagto.cod_refer_antecip_pef <> "" and v_log_refer_antecip_pef = yes) or (proces_pagto.cod_refer_antecip_pef = "" and v_log_refer_antecip_pef_tit = yes)) /*cl_rpt_proces_pagto_estabelecimento of proces_pagto*/:
                       run pi_tratar_tt_rpt_proces_pagto /*pi_tratar_tt_rpt_proces_pagto*/.
                   end /* for block */.
               end.    
            end /* if */.
            if  dwb_rpt_select.cod_dwb_field = "Fornecedor"
            then do:
                for each estabelecimento no-lock
                    where estabelecimento.cod_empresa = v_cod_empres_usuar:
                   block:
                   for               
                       each proces_pagto no-lock
                       where proces_pagto.cod_estab = estabelecimento.cod_estab
                         and proces_pagto.ind_sit_proces_pagto = entry(v_num_cont_aux, v_ind_sit_proces)
                         and proces_pagto.cdn_fornecedor >= integer(dwb_rpt_select.cod_dwb_initial) and 
    proces_pagto.cdn_fornecedor <= integer(dwb_rpt_select.cod_dwb_final)
                         and ((proces_pagto.cod_refer_antecip_pef <> "" and v_log_refer_antecip_pef = yes) or (proces_pagto.cod_refer_antecip_pef = "" and v_log_refer_antecip_pef_tit = yes)) /*cl_rpt_proces_pagto_fornecedor of proces_pagto*/:
                       run pi_tratar_tt_rpt_proces_pagto /*pi_tratar_tt_rpt_proces_pagto*/.
                   end /* for block */.
                end.
            end /* if */.
            if  dwb_rpt_select.cod_dwb_field = "EspÇcie Documento"
            then do:
                for each estabelecimento no-lock
                    where estabelecimento.cod_empresa = v_cod_empres_usuar:
                    block:
                    for
                       each proces_pagto no-lock
                       where proces_pagto.cod_estab = estabelecimento.cod_estab
                         and proces_pagto.ind_sit_proces_pagto = entry(v_num_cont_aux, v_ind_sit_proces)
                         and proces_pagto.cod_espec_docto >= dwb_rpt_select.cod_dwb_initial
                         and proces_pagto.cod_espec_docto <= dwb_rpt_select.cod_dwb_final
                         and ((proces_pagto.cod_refer_antecip_pef <> "" and v_log_refer_antecip_pef = yes) or (proces_pagto.cod_refer_antecip_pef = "" and v_log_refer_antecip_pef_tit = yes)) /*cl_rpt_proces_pagto_espec_docto of proces_pagto*/:
                       run pi_tratar_tt_rpt_proces_pagto /*pi_tratar_tt_rpt_proces_pagto*/.
                    end /* for block */.
                end.    
            end /* if */.
            if  dwb_rpt_select.cod_dwb_field = "Data Vencimento"
            then do:
                for each estabelecimento no-lock
                    where estabelecimento.cod_empresa = v_cod_empres_usuar:
                    block:
                    for
                       each proces_pagto no-lock
                       where proces_pagto.cod_estab = estabelecimento.cod_estab
                         and proces_pagto.ind_sit_proces_pagto = entry(v_num_cont_aux, v_ind_sit_proces)
                         and proces_pagto.dat_vencto_tit_ap >=  date(dwb_rpt_select.cod_dwb_initial) and proces_pagto.dat_vencto_tit_ap <=  date(dwb_rpt_select.cod_dwb_final)
                         and ((proces_pagto.cod_refer_antecip_pef <> "" and v_log_refer_antecip_pef = yes) or (proces_pagto.cod_refer_antecip_pef = "" and v_log_refer_antecip_pef_tit = yes)) /*cl_rpt_proces_pagto_data_vencto of proces_pagto*/:
                       run pi_tratar_tt_rpt_proces_pagto /*pi_tratar_tt_rpt_proces_pagto*/.
                   end /* for block */.
               end.
            end /* if */.
            if  dwb_rpt_select.cod_dwb_field = "Data Liberaá∆o"
            then do:
                for each estabelecimento no-lock
                    where estabelecimento.cod_empresa = v_cod_empres_usuar:
                    block:
                    for
                       each proces_pagto no-lock
                       where proces_pagto.cod_estab = estabelecimento.cod_estab
                         and proces_pagto.ind_sit_proces_pagto = entry(v_num_cont_aux, v_ind_sit_proces)
                         and proces_pagto.dat_liber_pagto >=  date(dwb_rpt_select.cod_dwb_initial) and proces_pagto.dat_liber_pagto <=  date(dwb_rpt_select.cod_dwb_final)
                         and ((proces_pagto.cod_refer_antecip_pef <> "" and v_log_refer_antecip_pef = yes) or (proces_pagto.cod_refer_antecip_pef = "" and v_log_refer_antecip_pef_tit = yes)) /*cl_rpt_proces_pagto_data_vencto of proces_pagto*/:
                       run pi_tratar_tt_rpt_proces_pagto /*pi_tratar_tt_rpt_proces_pagto*/.
                   end /* for block */.
               end.
            end /* if */.
        end.
    end /* for selecao */.

END PROCEDURE. /* pi_ler_tt_rpt_proces_pagto */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_proces_pagto
** Descricao.............: pi_rpt_proces_pagto
** Criado por............: Ganzen
** Criado em.............: // 
** Alterado por..........: fut1236
** Alterado em...........: 15/07/2004 10:13:29
*****************************************************************************/
PROCEDURE pi_rpt_proces_pagto:

    assign v_cod_order      = v_cod_dwb_order. /* ls_order:list-items in frame @&(frame).*/

    run pi_ler_tt_rpt_proces_pagto /*pi_ler_tt_rpt_proces_pagto*/.

    hide stream s_1 frame f_rpt_s_1_header_period.
    view stream s_1 frame f_rpt_s_1_header_unique.
    hide stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_normal.

    /* @if(ls_order:entry(1) in frame @&(frame) = @fx_objpro(cod_estab, label))
       @cx_rpt_view(rp_proces_pagto,grp_processo,lay_estab).
    @end_if().
    @if(ls_order:entry(1) in frame @&(frame) = @fx_objpro(cdn_fornecedor, label))
       @cx_rpt_view(rp_proces_pagto,grp_processo,lay_fonecedor).
    @end_if().
    @if(ls_order:entry(1) in frame @&(frame) = @fx_objpro(dat_vencto_tit_ap, label))
       @cx_rpt_view(rp_proces_pagto,grp_processo,lay_dat_vencto).
    @end_if().
    @if(ls_order:entry(1) in frame @&(frame) = @fx_objpro(cod_espec_docto, label))
       @cx_rpt_view(rp_proces_pagto,grp_processo,lay_espec_doct).
    @end_if().
    */


    assign v_log_impr = no.
    grp_block:
    for
        each tt_rpt_proces_pagto no-lock
        break by tt_rpt_proces_pagto.ttv_num_seq
        by tt_rpt_proces_pagto.cod_indic_econ
        by tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[1]
        by tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[2]
        by tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[3]
        by tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[4]:

        find first emscad.fornecedor no-lock
             where fornecedor.cdn_fornecedor = tt_rpt_proces_pagto.cdn_fornecedor
             and   fornecedor.cod_empresa    = tt_rpt_proces_pagto.cod_empresa no-error.
        if avail fornecedor 
        THEN DO:
             FIND fornec_financ NO-LOCK 
                 WHERE fornec_financ.cod_empresa    = fornecedor.cod_empresa
                   AND fornec_financ.cdn_fornecedor = fornecedor.cdn_fornecedor NO-ERROR.
             IF AVAIL fornec_financ
             THEN DO:
                  ASSIGN v_cod_banco             = fornec_financ.cod_banco
                         v_cod_agenc_bcia        = fornec_financ.cod_agenc_bcia
                         v_cod_digito_agenc_bcia = fornec_financ.cod_digito_agenc_bcia
                         v_cod_cta_corren_bco    = fornec_financ.cod_cta_corren_bco
                         v_cod_digito_cta_corren = fornec_financ.cod_digito_cta_corren.
             END.        
             assign v_nom_abrev = fornecedor.nom_abrev.
        END.
        else
           assign v_nom_abrev             = ''
                  v_cod_banco             = ''  
                  v_cod_agenc_bcia        = ''
                  v_cod_digito_agenc_bcia = ''
                  v_cod_cta_corren_bco    = ''
                  v_cod_digito_cta_corren = ''.

        if  first-of(tt_rpt_proces_pagto.ttv_num_seq)
        then do:
            for each tt_tot_prepar_pagto_moeda:
                delete tt_tot_prepar_pagto_moeda.
            end.     
            if  v_log_impr = yes
            then do:
                 page stream s_1.
            end /* if */.
            if  tt_rpt_proces_pagto.ttv_num_seq = 1
            then do:
                assign v_ind_proces_pagto = "Pagamentos Preparados" /*l_pagamentos_preparados*/ .
            end /* if */.
            else do:
                if  tt_rpt_proces_pagto.ttv_num_seq = 2
                then do:
                    assign v_ind_proces_pagto = "Pagamentos Liberados" /*l_pagamentos_liberados*/ .
                end /* if */.
                else do:
                    assign v_ind_proces_pagto = "Em Pagamento" /*l_em_pagamento*/ .
                end /* else */.
            end /* else */.

            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                v_ind_proces_pagto at 97 format "X(21)" skip (2).

         assign v_log_impr = yes.
        end /* if */.

        find tt_tot_prepar_pagto_moeda 
             where tt_tot_prepar_pagto_moeda.tta_cod_indic_econ = tt_rpt_proces_pagto.cod_indic_econ no-error.
        if  not avail tt_tot_prepar_pagto_moeda
        then do:
             create tt_tot_prepar_pagto_moeda.
             assign tt_tot_prepar_pagto_moeda.tta_cod_indic_econ = tt_rpt_proces_pagto.cod_indic_econ.
        end /* if */.
        assign tt_tot_prepar_pagto_moeda.ttv_val_total = tt_tot_prepar_pagto_moeda.ttv_val_total + tt_rpt_proces_pagto.val_liberd_pagto
               tt_tot_prepar_pagto_moeda.ttv_qtd_prepar_pagto_tit = tt_tot_prepar_pagto_moeda.ttv_qtd_prepar_pagto_tit + 1 .            

        if  first-of(tt_rpt_proces_pagto.cod_indic_econ)
        then do:
            if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "Moeda: " at 1
                tt_rpt_proces_pagto.cod_indic_econ at 8 format "x(8)" skip (1).
            assign v_val_liber_pagto = 0.
            if  entry(1, v_cod_order) = "Estabelecimento"
            then do:
                if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Est" at 5
                    "Emp" at 9
                    "Esp" at 13
                    "Ser" at 17
                    "Fornec" to 31
                    "Nome" at 33
                    "T°tulo" at 49
                    "/P" at 60
                    "Seq" to 67
                    "Port" at 69
                    "Vencto" at 75
                    "Prev Pagto" at 86
                    "Dt Descto" at 97
                    "Prep Pagto" at 108
                    "Dat  Liber" at 119
                    "Usuar Liber" at 130
                    "Vl Liber" to 157
                    "Vl Lib Orig" to 173
                    "Data Pagto" at 175
                    "Modo Pagto" at 186
                    "Ref Ant/PEF" at 197 skip
                    "---" at 5
                    "---" at 9
                    "---" at 13
                    "---" at 17
                    "-----------" to 31
                    "---------------" at 33
                    "----------" at 49
                    "--" at 60
                    "-----" to 67
                    "-----" at 69
                    "----------" at 75
                    "----------" at 86
                    "----------" at 97
                    "----------" at 108
                    "----------" at 119
                    "------------" AT 130
                    "---------------" to 157
                    "---------------" to 173
                    "----------" at 175
                    "----------" at 186
                    "-----------" at 197 skip.
            end /* if */.
            if  entry(1, v_cod_order) = "Fornecedor"
            then do:
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Fornec" to 15
                  "Nome" at 17
                  "Emp" at 33
                  "Est" at 37
                  "Esp" at 41
                  "Ser" at 45
                  "T°tulo" at 49
                  "/P" at 60
                  "Seq" to 67
                  "Port" at 69
                  "Vencto" at 75
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "-----------" to 15
                  "---------------" at 17
                  "---" at 33
                  "---" at 37
                  "---" at 41
                  "---" at 45
                  "----------" at 49
                  "--" at 60
                  "-----" to 67
                  "-----" at 69
                  "----------" at 75
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
            end /* if */.
            if  entry(1, v_cod_order) = "Data Vencimento"
            OR  entry(1, v_cod_order) = "Data Liberaá∆o"
            then do:
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Vencto" at 5
                  "T°tulo" at 16
                  "Emp" at 27
                  "Est" at 31
                  "Esp" at 35
                  "Ser" at 39
                  "Fornec" to 53
                  "Nome" at 55
                  "/P" at 71
                  "Seq" to 78
                  "Port" at 80
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "----------" at 5
                  "----------" at 16
                  "---" at 27
                  "---" at 31
                  "---" at 35
                  "---" at 39
                  "-----------" to 53
                  "---------------" at 55
                  "--" at 71
                  "-----" to 78
                  "-----" at 80
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
            end /* if */.
            if  entry(1, v_cod_order) = "EspÇcie Documento"
            then do:
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Esp" at 5
                  "Ser" at 9
                  "Emp" at 13
                  "Est" at 17
                  "Fornec" to 31
                  "Nome" at 33
                  "T°tulo" at 49
                  "/P" at 60
                  "Seq" to 67
                  "Port" at 69
                  "Vencto" at 75
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "---" at 5
                  "---" at 9
                  "---" at 13
                  "---" at 17
                  "-----------" to 31
                  "---------------" at 33
                  "----------" at 49
                  "--" at 60
                  "-----" to 67
                  "-----" at 69
                  "----------" at 75
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
            end /* if */.
        end /* if */.

        if  entry(1, v_cod_order) = "Estabelecimento"
        then do:
            /* ** Teste quebra de p†gina para imprimir cabeáalho ***/
             if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then do:
                 page stream s_1.
                 if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                     page stream s_1.
                 put stream s_1 unformatted 
                     "Est" at 5
                     "Emp" at 9
                     "Esp" at 13
                     "Ser" at 17
                     "Fornec" to 31
                     "Nome" at 33
                     "T°tulo" at 49
                     "/P" at 60
                     "Seq" to 67
                     "Port" at 69
                     "Vencto" at 75
                     "Prev Pagto" at 86
                     "Dt Descto" at 97
                     "Prep Pagto" at 108
                     "Dat  Liber" at 119
                     "Usuar Liber" at 130
                     "Vl Liber" to 157
                     "Vl Lib Orig" to 173
                     "Data Pagto" at 175
                     "Modo Pagto" at 186
                     "Ref Ant/PEF" at 197 skip
                     "---" at 5
                     "---" at 9
                     "---" at 13
                     "---" at 17
                     "-----------" to 31
                     "---------------" at 33
                     "----------" at 49
                     "--" at 60
                     "-----" to 67
                     "-----" at 69
                     "----------" at 75
                     "----------" at 86
                     "----------" at 97
                     "----------" at 108
                     "----------" at 119
                     "------------" AT 130
                     "---------------" to 157
                     "---------------" to 173
                     "----------" at 175
                     "----------" at 186
                     "-----------" at 197 skip.
             end.
             if tt_rpt_proces_pagto.ind_sit_proces_pagto = "Em Pagamento" /*l_em_pagamento*/  then do:
                 if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                     page stream s_1.
                 put stream s_1 unformatted 
                     tt_rpt_proces_pagto.cod_estab at 5 format "x(3)"
                     tt_rpt_proces_pagto.cod_empresa at 9 format "x(3)"
                     tt_rpt_proces_pagto.cod_espec_docto at 13 format "x(3)"
                     tt_rpt_proces_pagto.cod_ser_docto at 17 format "x(3)"
                     tt_rpt_proces_pagto.cdn_fornecedor to 31 format ">>>,>>>,>>9"
                     v_nom_abrev at 33 format "x(15)"
                     tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                     tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                     tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                     tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                     tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                     tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                     tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                     tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                     tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                     tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                     tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.
                 
                 PUT STREAM s_1 UNFORMATTED
                     "Banco: "               AT 33         
                     v_cod_banco             AT 40
                     "  Agància: "           AT 47
                     v_cod_agenc_bcia        AT 58
                     " - "                   AT 65 
                     v_cod_digito_agenc_bcia AT 68
                     "  Cta Corrente: "      AT 72
                     v_cod_cta_corren_bco    AT 90
                     " - "                   AT 100
                     v_cod_digito_cta_corren AT 103 SKIP(1).

             end.
             else do:
                 if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                     page stream s_1.
                 put stream s_1 unformatted 
                     tt_rpt_proces_pagto.cod_estab at 5 format "x(3)"
                     tt_rpt_proces_pagto.cod_empresa at 9 format "x(3)"
                     tt_rpt_proces_pagto.cod_espec_docto at 13 format "x(3)"
                     tt_rpt_proces_pagto.cod_ser_docto at 17 format "x(3)"
                     tt_rpt_proces_pagto.cdn_fornecedor to 31 format ">>>,>>>,>>9"
                     v_nom_abrev at 33 format "x(15)"
                     tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                     tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                     tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                     tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                     tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                     tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                     tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                     tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                     tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                     tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                     tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                     tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

                 PUT STREAM s_1 UNFORMATTED
                     "Banco: "               AT 33         
                     v_cod_banco             AT 40
                     "  Agància: "           AT 47
                     v_cod_agenc_bcia        AT 58
                     " - "                   AT 65 
                     v_cod_digito_agenc_bcia AT 68
                     "  Cta Corrente: "      AT 72
                     v_cod_cta_corren_bco    AT 90
                     " - "                   AT 100
                     v_cod_digito_cta_corren AT 103 SKIP(1).

             end.
        end /* if */.
        if  entry(1, v_cod_order) = "Fornecedor"
        then do:
          /* ** Teste quebra de p†gina para imprimir cabeáalho ***/
          if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then do:
              page stream s_1.
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Fornec" to 15
                  "Nome" at 17
                  "Emp" at 33
                  "Est" at 37
                  "Esp" at 41
                  "Ser" at 45
                  "T°tulo" at 49
                  "/P" at 60
                  "Seq" to 67
                  "Port" at 69
                  "Vencto" at 75
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "-----------" to 15
                  "---------------" at 17
                  "---" at 33
                  "---" at 37
                  "---" at 41
                  "---" at 45
                  "----------" at 49
                  "--" at 60
                  "-----" to 67
                  "-----" at 69
                  "----------" at 75
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
          end.
          if tt_rpt_proces_pagto.ind_sit_proces_pagto = "Em Pagamento" /*l_em_pagamento*/  then do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.cdn_fornecedor to 15 format ">>>,>>>,>>9"
                  v_nom_abrev at 17 format "x(15)"
                  tt_rpt_proces_pagto.cod_empresa at 33 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 37 format "x(3)"
                  tt_rpt_proces_pagto.cod_espec_docto at 41 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 45 format "x(3)"
                  tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                  tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
          else do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.cdn_fornecedor to 15 format ">>>,>>>,>>9"
                  v_nom_abrev at 17 format "x(15)"
                  tt_rpt_proces_pagto.cod_empresa at 33 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 37 format "x(3)"
                  tt_rpt_proces_pagto.cod_espec_docto at 41 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 45 format "x(3)"
                  tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                  tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
        end /* if */.
        if  entry(1, v_cod_order) = "Data Vencimento"
        OR  entry(1, v_cod_order) = "Data Liberaá∆o"
        then do:
          /* ** Teste quebra de p†gina para imprimir cabeáalho ***/
          if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then do:
              page stream s_1.
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Vencto" at 5
                  "T°tulo" at 16
                  "Emp" at 27
                  "Est" at 31
                  "Esp" at 35
                  "Ser" at 39
                  "Fornec" to 53
                  "Nome" at 55
                  "/P" at 71
                  "Seq" to 78
                  "Port" at 80
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "----------" at 5
                  "----------" at 16
                  "---" at 27
                  "---" at 31
                  "---" at 35
                  "---" at 39
                  "-----------" to 53
                  "---------------" at 55
                  "--" at 71
                  "-----" to 78
                  "-----" at 80
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
          end.
          if tt_rpt_proces_pagto.ind_sit_proces_pagto = "Em Pagamento" /*l_em_pagamento*/  then do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 5 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_tit_ap at 16 format "x(10)"
                  tt_rpt_proces_pagto.cod_empresa at 27 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 31 format "x(3)"
                  tt_rpt_proces_pagto.cod_espec_docto at 35 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 39 format "x(3)"
                  tt_rpt_proces_pagto.cdn_fornecedor to 53 format ">>>,>>>,>>9"
                  v_nom_abrev at 55 format "x(15)"
                  tt_rpt_proces_pagto.cod_parcela at 71 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 78 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 80 format "x(5)"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
          else do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 5 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_tit_ap at 16 format "x(10)"
                  tt_rpt_proces_pagto.cod_empresa at 27 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 31 format "x(3)"
                  tt_rpt_proces_pagto.cod_espec_docto at 35 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 39 format "x(3)"
                  tt_rpt_proces_pagto.cdn_fornecedor to 53 format ">>>,>>>,>>9"
                  v_nom_abrev at 55 format "x(15)"
                  tt_rpt_proces_pagto.cod_parcela at 71 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 78 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 80 format "x(5)"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
        end /* if */.
        if  entry(1, v_cod_order) = "EspÇcie Documento"
        then do:
          /* ** Teste quebra de p†gina para imprimir cabeáalho ***/
          if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then do:
              page stream s_1.
              if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  "Esp" at 5
                  "Ser" at 9
                  "Emp" at 13
                  "Est" at 17
                  "Fornec" to 31
                  "Nome" at 33
                  "T°tulo" at 49
                  "/P" at 60
                  "Seq" to 67
                  "Port" at 69
                  "Vencto" at 75
                  "Prev Pagto" at 86
                  "Dt Descto" at 97
                  "Prep Pagto" at 108
                  "Dat  Liber" at 119
                  "Usuar Liber" at 130
                  "Vl Liber" to 157
                  "Vl Lib Orig" to 173
                  "Data Pagto" at 175
                  "Modo Pagto" at 186
                  "Ref Ant/PEF" at 197 skip
                  "---" at 5
                  "---" at 9
                  "---" at 13
                  "---" at 17
                  "-----------" to 31
                  "---------------" at 33
                  "----------" at 49
                  "--" at 60
                  "-----" to 67
                  "-----" at 69
                  "----------" at 75
                  "----------" at 86
                  "----------" at 97
                  "----------" at 108
                  "----------" at 119
                  "------------" AT 130
                  "---------------" to 157
                  "---------------" to 173
                  "----------" at 175
                  "----------" at 186
                  "-----------" at 197 skip.
          end.
          if tt_rpt_proces_pagto.ind_sit_proces_pagto = "Em Pagamento" /*l_em_pagamento*/  then do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.cod_espec_docto at 5 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 9 format "x(3)"
                  tt_rpt_proces_pagto.cod_empresa at 13 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 17 format "x(3)"
                  tt_rpt_proces_pagto.cdn_fornecedor to 31 format ">>>,>>>,>>9"
                  v_nom_abrev at 33 format "x(15)"
                  tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                  tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
          else do:
              if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  tt_rpt_proces_pagto.cod_espec_docto at 5 format "x(3)"
                  tt_rpt_proces_pagto.cod_ser_docto at 9 format "x(3)"
                  tt_rpt_proces_pagto.cod_empresa at 13 format "x(3)"
                  tt_rpt_proces_pagto.cod_estab at 17 format "x(3)"
                  tt_rpt_proces_pagto.cdn_fornecedor to 31 format ">>>,>>>,>>9"
                  v_nom_abrev at 33 format "x(15)"
                  tt_rpt_proces_pagto.cod_tit_ap at 49 format "x(10)"
                  tt_rpt_proces_pagto.cod_parcela at 60 format "x(02)"
                  tt_rpt_proces_pagto.num_seq_pagto_tit_ap to 67 format ">,>>9"
                  tt_rpt_proces_pagto.cod_portador at 69 format "x(5)"
                  tt_rpt_proces_pagto.dat_vencto_tit_ap at 75 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prev_pagto at 86 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_desconto at 97 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_prepar_pagto at 108 format "99/99/9999"
                  tt_rpt_proces_pagto.dat_liber_pagto at 119 format "99/99/9999"
                  tt_rpt_proces_pagto.cod_usuar_liber_pagto AT 130 FORMAT "x(12)"
                  tt_rpt_proces_pagto.val_liberd_pagto to 157 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.val_liber_pagto_orig to 173 format "->>>,>>>,>>9.99"
                  tt_rpt_proces_pagto.dat_pagto at 175 format "99/99/9999"
                  tt_rpt_proces_pagto.ind_modo_pagto at 186 format "X(10)"
                  tt_rpt_proces_pagto.cod_refer_antecip_pef at 197 format "x(10)" skip.

              PUT STREAM s_1 UNFORMATTED
                  "Banco: "               AT 33         
                  v_cod_banco             AT 40
                  "  Agància: "           AT 47
                  v_cod_agenc_bcia        AT 58
                  " - "                   AT 65 
                  v_cod_digito_agenc_bcia AT 68
                  "  Cta Corrente: "      AT 72
                  v_cod_cta_corren_bco    AT 90
                  " - "                   AT 100
                  v_cod_digito_cta_corren AT 103 SKIP(1).

          end.
        end /* if */.

        assign v_val_liber_pagto = v_val_liber_pagto + tt_rpt_proces_pagto.val_liberd_pagto.

        if  last-of(tt_rpt_proces_pagto.cod_indic_econ)
        then do:
            if (line-counter(s_1) + 6) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "---------------" at 130 skip
                "Total na Moeda: " at 111
                v_val_liber_pagto to 144 format "->>,>>>,>>>,>>9.99" skip (4).
        end /* if */.

        if  last-of(tt_rpt_proces_pagto.ttv_num_seq)
        then do:
            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "Moeda" at 89
                "T°tulos Preparados" to 117
                "Valor Total" to 135 skip
                "--------" at 89
                "------------------" to 117
                "---------------" to 135 skip.
            for each tt_tot_prepar_pagto_moeda:
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then do:
                    page stream s_1.
                    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "Moeda" at 89
                        "T°tulos Preparados" to 117
                        "Valor Total" to 135 skip
                        "--------" at 89
                        "------------------" to 117
                        "---------------" to 135 skip.       
                end.
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    tt_tot_prepar_pagto_moeda.tta_cod_indic_econ at 89 format "x(8)"
                    tt_tot_prepar_pagto_moeda.ttv_qtd_prepar_pagto_tit to 117 format ">>>>9"
                    tt_tot_prepar_pagto_moeda.ttv_val_total to 135 format "->>>,>>>,>>9.99" skip.       
            end. 
        end /* if */.    
        delete tt_rpt_proces_pagto.
    end /* for grp_block */.

    hide stream s_1 frame f_rpt_s_1_footer_normal.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_grp_processo_lay_estab.
    hide stream s_1 frame f_rpt_s_1_grp_processo_lay_fonecedor.
    hide stream s_1 frame f_rpt_s_1_grp_processo_lay_dat_vencto.
    hide stream s_1 frame f_rpt_s_1_grp_processo_lay_espec_doct.
    hide stream s_1 frame f_rpt_s_1_grp_situacao_lay_processo.


END PROCEDURE. /* pi_rpt_proces_pagto */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tt_rpt_proces_pagto
** Descricao.............: pi_tratar_tt_rpt_proces_pagto
** Criado por............: Ganzen
** Criado em.............: // 
** Alterado por..........: fut12209
** Alterado em...........: 15/09/2003 17:11:13
*****************************************************************************/
PROCEDURE pi_tratar_tt_rpt_proces_pagto:

    find tt_rpt_proces_pagto no-lock
         where tt_rpt_proces_pagto.ttv_rec_proces_pagto = recid(proces_pagto) /*cl_key_recid of tt_rpt_proces_pagto*/ no-error.
    if  dwb_rpt_select.log_dwb_rule = yes
    then do:
        if  not avail tt_rpt_proces_pagto
        then do:
            create tt_rpt_proces_pagto.
            assign tt_rpt_proces_pagto.ttv_rec_proces_pagto = recid(proces_pagto)
                   tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[lookup("Estabelecimento", v_cod_order)] = proces_pagto.cod_estab
                   tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[lookup("Fornecedor", v_cod_order)] = string(proces_pagto.cdn_fornecedor, ">>>,>>>,>>9":U)
                   tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[lookup("EspÇcie Documento", v_cod_order)] = proces_pagto.cod_espec_docto
                   tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[lookup("Data Vencimento", v_cod_order)] = string(year(proces_pagto.dat_vencto_tit_ap),"9999")
                                                                                                     + string(month(proces_pagto.dat_vencto_tit_ap),"99")
                                                                                                     + string(day(proces_pagto.dat_vencto_tit_ap),"99")
                   tt_rpt_proces_pagto.ttv_cod_dwb_field_rpt[lookup("Data Liberaá∆o", v_cod_order)]  = string(year(proces_pagto.dat_liber_pagto),"9999")
                                                                                                     + string(month(proces_pagto.dat_liber_pagto),"99")
                                                                                                     + string(day(proces_pagto.dat_liber_pagto),"99").

            assign 
                   tt_rpt_proces_pagto.cod_estab             = proces_pagto.cod_estab
                   tt_rpt_proces_pagto.cod_espec_docto       = proces_pagto.cod_espec_docto
                   tt_rpt_proces_pagto.cod_ser_docto         = proces_pagto.cod_ser_docto
                   tt_rpt_proces_pagto.cdn_fornecedor        = proces_pagto.cdn_fornecedor
                   tt_rpt_proces_pagto.cod_tit_ap            = proces_pagto.cod_tit_ap
                   tt_rpt_proces_pagto.cod_parcela           = proces_pagto.cod_parcela
                   tt_rpt_proces_pagto.num_seq_pagto_tit_ap  = proces_pagto.num_seq_pagto_tit_ap
                   tt_rpt_proces_pagto.cod_refer_antecip_pef = proces_pagto.cod_refer_antecip_pef.
            assign 
                   tt_rpt_proces_pagto.cod_empresa            = proces_pagto.cod_empresa
                   tt_rpt_proces_pagto.cod_portador           = proces_pagto.cod_portador
                   tt_rpt_proces_pagto.dat_vencto_tit_ap      = proces_pagto.dat_vencto_tit_ap
                   tt_rpt_proces_pagto.dat_prev_pagto         = proces_pagto.dat_prev_pagto
                   tt_rpt_proces_pagto.dat_desconto           = proces_pagto.dat_desconto
                   tt_rpt_proces_pagto.ind_sit_proces_pagto   = proces_pagto.ind_sit_proces_pagto
                   tt_rpt_proces_pagto.cod_usuar_prepar_pagto = proces_pagto.cod_usuar_prepar_pagto
                   tt_rpt_proces_pagto.dat_prepar_pagto       = proces_pagto.dat_prepar_pagto
                   tt_rpt_proces_pagto.cod_usuar_liber_pagto  = proces_pagto.cod_usuar_liber_pagto
                   tt_rpt_proces_pagto.dat_liber_pagto        = proces_pagto.dat_liber_pagto
                   tt_rpt_proces_pagto.val_liberd_pagto       = proces_pagto.val_liberd_pagto
                   tt_rpt_proces_pagto.val_liber_pagto_orig   = proces_pagto.val_liber_pagto_orig
                   tt_rpt_proces_pagto.cod_indic_econ         = proces_pagto.cod_indic_econ
                   tt_rpt_proces_pagto.cod_usuar_pagto        = proces_pagto.cod_usuar_pagto
                   tt_rpt_proces_pagto.dat_pagto              = proces_pagto.dat_pagto
                   tt_rpt_proces_pagto.ind_modo_pagto         = proces_pagto.ind_modo_pagto
    &if '{&emsfin_version}' >= "5.05" &then
                   tt_rpt_proces_pagto.hra_liber_proces_pagto = proces_pagto.hra_liber_proces_pagto
    &endif.
            if  proces_pagto.ind_sit_proces_pagto = "Preparado" /*l_preparado*/ 
            then do:
                assign tt_rpt_proces_pagto.ttv_num_seq = 1.
                find tit_ap no-lock
                     where tit_ap.cdn_fornecedor = proces_pagto.cdn_fornecedor
                       and tit_ap.cod_espec_docto = proces_pagto.cod_espec_docto
                       and tit_ap.cod_estab = proces_pagto.cod_estab
                       and tit_ap.cod_parcela = proces_pagto.cod_parcela
                       and tit_ap.cod_ser_docto = proces_pagto.cod_ser_docto
                       and tit_ap.cod_tit_ap = proces_pagto.cod_tit_ap
                      no-error.
                if  avail tit_ap
                then do:
                    assign tt_rpt_proces_pagto.cod_indic_econ = tit_ap.cod_indic_econ
                           tt_rpt_proces_pagto.val_liberd_pagto = tit_ap.val_sdo_tit_ap
                           tt_rpt_proces_pagto.val_liber_pagto_orig = tit_ap.val_sdo_tit_ap.
                end /* if */. 
                else do:
                    find antecip_pef_pend no-lock
                         where antecip_pef_pend.cod_estab = proces_pagto.cod_estab
                         and antecip_pef_pend.cod_refer = proces_pagto.cod_refer_antecip_pef
                         no-error.
                    if avail antecip_pef_pend then do:
                         assign tt_rpt_proces_pagto.cod_indic_econ = antecip_pef_pend.cod_indic_econ
                                tt_rpt_proces_pagto.val_liberd_pagto = antecip_pef_pend.val_tit_ap
                                tt_rpt_proces_pagto.val_liber_pagto_orig = antecip_pef_pend.val_tit_ap.
                    end.
                end /* else */.             
            end /* if */.
            else do:
                if  proces_pagto.ind_sit_proces_pagto = "Liberado" /*l_liberado*/ 
                then do:
                    assign tt_rpt_proces_pagto.ttv_num_seq = 2 .
                end /* if */.
                else do:
                    assign tt_rpt_proces_pagto.ttv_num_seq = 3.
                end /* else */.
            end /* else */.
        end /* if */.
    end /* if */.
    else do:
       if  avail tt_rpt_proces_pagto
       then do:
          delete tt_rpt_proces_pagto.
       end /* if */.
    end /* else */.
END PROCEDURE. /* pi_tratar_tt_rpt_proces_pagto */
/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: bre19127
** Alterado em...........: 16/09/2002 08:55:44
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
            find emsbas.prog_dtsul 
                where emsbas.prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail emsbas.prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsbas.prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 emsbas.prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  emsbas.prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 emsbas.prog_dtsul.nom_prog_appc at 15 skip.
                if  emsbas.prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 emsbas.prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find emsbas.tab_dic_dtsul 
                where emsbas.tab_dic_dtsul.cod_tab_dic_dtsul = p_cod_program 
                no-lock no-error.
            if  avail emsbas.tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsbas.tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' then
                        put stream s-arq 'DPC-DELETE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  emsbas.tab_dic_dtsul.nom_prog_appc_gat_delete <> '' then
                    put stream s-arq 'APPC-DELETE: ' at 5 emsbas.tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  emsbas.tab_dic_dtsul.nom_prog_upc_gat_delete <> '' then
                    put stream s-arq 'UPC-DELETE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsbas.tab_dic_dtsul.nom_prog_dpc_gat_write <> '' then
                        put stream s-arq 'DPC-WRITE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  emsbas.tab_dic_dtsul.nom_prog_appc_gat_write <> '' then
                    put stream s-arq 'APPC-WRITE: ' at 5 emsbas.tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  emsbas.tab_dic_dtsul.nom_prog_upc_gat_write <> '' then
                    put stream s-arq 'UPC-WRITE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */


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
/*************************  End of rpt_proces_pagto *************************/
