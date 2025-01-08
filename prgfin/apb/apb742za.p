/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_bord_ap_param_impres
** Descricao.............: Funá‰es Bordero do Contas a Paga
** Versao................:  1.00.00.026
** Procedimento..........: tar_emitir_bord_ap
** Nome Externo..........: prgfin/apb/apb742za.p
** Data Geracao..........: 14/08/2014 - 15:01:19
** Criado por............: Ganzen
** Criado em.............: 16/11/1995 09:12:50
** Alterado por..........: jeffersonsil
** Alterado em...........: 14/08/2014 09:42:44
** Gerado por............: jeffersonsil
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.026":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.026[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
/*{include/i_trddef.i}*/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_bord_ap_param_impres APB}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/

&if "{&emsfin_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSFIN")) /*msg_5884*/.
&elseif "{&emsfin_version}" < "5.01" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "FNC_BORD_AP_PARAM_IMPRES","~~EMSFIN", "~~{~&emsfin_version}", "~~5.01")) /*msg_5009*/.
&else

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
def new global shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_dwb_print_layout
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_proced
    as character
    format "x(8)":U
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
def var v_ind_bord_dados_1
    as character
    format "X(15)":U
    view-as radio-set Vertical
    radio-buttons "Borderì", "Borderì", "Guia Previdància Social", "Guia Previdància Social", "Darf", "Darf"
     /*l_bordero*/ /*l_bordero*/ /*l_gps*/ /*l_gps*/ /*l_darf*/ /*l_darf*/
    bgcolor 8 
    no-undo.
def var v_ind_bord_guia
    as character
    format "X(015)":U
    view-as radio-set Vertical
    radio-buttons "Borderì", "Borderì", "Guia Previdància Social", "Guia Previdància Social"
     /*l_bordero*/ /*l_bordero*/ /*l_gps*/ /*l_gps*/
    bgcolor 8 
    no-undo.
def new global shared var v_ind_classif_bord
    as character
    format "x(31)":U
    view-as combo-box
    list-items "Por Valor","Por Fornecedor","Por Data Vencimento","Por Forma de Pagto/Fornecedor","Por Estabelecimento/Fornecedor","Por Estabelecimento/Data Vencto","Por Estabelecimento/Forma Pagto","Por Fornecedor/Documento"
     /*l_por_fornecedor*/ /*l_por_data_vencimento*/ /*l_por_forma_pagto_fornecedor*/ /*l_por_estabelecimentofornecedor*/ /*l_por_estabelecimentodata_vencto*/ /*l_por_estabelecimentoforma_pagto*/ /*l_por_fornecedordocumento*/
    inner-lines 8
    bgcolor 15 font 2
    label "Classificaá∆o"
    column-label "Classificaá∆o"
    no-undo.
def var v_ind_competencia
    as character
    format "X(15)":U
    initial "Vencimento" /*l_vencimento*/
    view-as radio-set Horizontal
    radio-buttons "Vencimento", "Vencimento", "Per°odo Anterior", "Per°odo Anterior"
     /*l_vencimento*/ /*l_vencimento*/ /*l_periodo_anterior*/ /*l_periodo_anterior*/
    bgcolor 8 
    no-undo.
def new global shared var v_ind_dest_bord_ap
    as character
    format "x(10)":U
    view-as radio-set Horizontal
    radio-buttons "Terminal", "Terminal", "Arquivo", "Arquivo", "Impressora", "Impressora"
     /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
    bgcolor 8 
    no-undo.
def new global shared var v_ind_ender_complet
    as character
    format "X(20)":U
    initial "Endereáo" /*l_endereco*/
    view-as radio-set Horizontal
    radio-buttons "Endereáo", "Endereáo", "Endereáo Completo", "Endereáo Completo"
     /*l_endereco*/ /*l_endereco*/ /*l_endereco_completo*/ /*l_endereco_completo*/
    bgcolor 8 
    no-undo.
def new global shared var v_log_cabec_todas_pag
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def shared var v_log_em_digitac
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def shared var v_log_envdo_bco
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def shared var v_log_estordo
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Estornado"
    column-label "Estornado"
    no-undo.
def var v_log_impr_cabec_bco
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_impr_histor_pef
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Impr. Hist¢rico PEF"
    column-label "Impr. Hist¢rico PEF"
    no-undo.
def new global shared var v_log_impr_item_estorn
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Imprime Itens Estorn"
    no-undo.
def new global shared var v_log_impr_sit
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_impr_tot_bord_assin
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_ja_impr
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
def var v_log_pagto_trib
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def shared var v_log_parcte_bxdo
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def new global shared var v_log_salta_lin
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_save_ok
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def shared var v_log_tot_bxdo
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_usa_funcao
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_nom_arq_bord_ap
    as character
    format "x(30)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.
def new global shared var v_nom_dwb_printer
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
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_rec_bord_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var V_REC_LOG
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
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
def rectangle rt_005
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
def rectangle rt_010
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
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
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_02_bord_ap_param_impres
    rt_007
         at row 01.25 col 02.00
    " ParÉmetros " view-as text
         at row 01.00 col 04.00 bgcolor 8 
    rt_005
         at row 06.92 col 41.57
    " Destino " view-as text
         at row 06.62 col 43.57 bgcolor 8 
    rt_009
         at row 09.04 col 03.00
    " Borderì " view-as text
         at row 08.74 col 05.00 bgcolor 8 
    rt_008
         at row 01.25 col 41.43
    " Classificaá∆o " view-as text
         at row 01.00 col 43.43 bgcolor 8 
    rt_010
         at row 04.08 col 41.43
    " Per°odo de Competància " view-as text
         at row 03.78 col 43.43 bgcolor 8 
    rt_002
         at row 13.58 col 01.72 bgcolor 7 
    v_log_cabec_todas_pag
         at row 01.75 col 03.57 label "Cabeáalho em Todas as P†ginas"
         view-as toggle-box
    v_ind_classif_bord
         at row 02.00 col 45.43 no-label
         help "Classificaá∆o do Borderì"
         view-as combo-box
         list-items "Por Valor","Por Fornecedor","Por Data Vencimento","Por Forma de Pagto/Fornecedor","Por Estabelecimento/Fornecedor","Por Estabelecimento/Data Vencto","Por Estabelecimento/Forma Pagto","Por Fornecedor/Documento"
          /*l_por_fornecedor*/ /*l_por_data_vencimento*/ /*l_por_forma_pagto_fornecedor*/ /*l_por_estabelecimentofornecedor*/ /*l_por_estabelecimentodata_vencto*/ /*l_por_estabelecimentoforma_pagto*/ /*l_por_fornecedordocumento*/
         inner-lines 8
         bgcolor 15 font 2
    v_log_salta_lin
         at row 02.75 col 03.57 label "Salta Linha entre T°tulos"
         view-as toggle-box
    v_log_impr_sit
         at row 03.75 col 03.57 label "Imprime Situaá∆o"
         view-as toggle-box
    v_log_impr_item_estorn
         at row 04.75 col 03.57 label "Imprime Itens Estornados"
         help "Imprime itens estornados"
         view-as toggle-box
    v_ind_competencia
         at row 05.00 col 49.00 no-label
         view-as radio-set Horizontal
         radio-buttons "Vencimento", "Vencimento", "Per°odo Anterior", "Per°odo Anterior"
          /*l_vencimento*/ /*l_vencimento*/ /*l_periodo_anterior*/ /*l_periodo_anterior*/
         bgcolor 8 
    v_log_impr_tot_bord_assin
         at row 05.75 col 03.57 label "Total Borderì e Assinatura Mesma P†gina"
         view-as toggle-box
    v_log_impr_histor_pef
         at row 06.75 col 03.57 label "Imprime Hist¢rico PEF/AN"
         view-as toggle-box
    v_log_impr_cabec_bco
         at row 07.75 col 03.57 label "Imprime cabeáalho do Banco"
         view-as toggle-box
    bt_set_printer
         at row 07.33 col 81.86 font ?
         help "Define Impressora e Layout de Impress∆o"
    bt_get_file
         at row 07.33 col 81.86 font ?
         help "Pesquisa Arquivo"
    v_ind_dest_bord_ap
         at row 07.50 col 44.00 no-label
         view-as radio-set Horizontal
         radio-buttons "Terminal", "Terminal", "Arquivo", "Arquivo", "Impressora", "Impressora"
          /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
         bgcolor 8 
    v_ind_bord_dados_1
         at row 09.50 col 04.29 no-label
         view-as radio-set Vertical
         radio-buttons "Borderì", "Borderì", "Guia Previdància Social", "Guia Previdància Social", "Darf", "Darf"
          /*l_bordero*/ /*l_bordero*/ /*l_gps*/ /*l_gps*/ /*l_darf*/ /*l_darf*/
         bgcolor 8 
    v_ind_bord_guia
         at row 09.50 col 04.29 no-label
         view-as radio-set Vertical
         radio-buttons "Borderì", "Borderì", "Guia Previdància Social", "Guia Previdància Social"
          /*l_bordero*/ /*l_bordero*/ /*l_gps*/ /*l_gps*/
         bgcolor 8 
    v_nom_arq_bord_ap
         at row 08.83 col 44.14 no-label
         view-as editor max-chars 250 no-word-wrap
         size 40 by 1
         bgcolor 15 font 2
    v_ind_ender_complet
         at row 12.33 col 03.43 no-label
         view-as radio-set Horizontal
         radio-buttons "Endereáo", "Endereáo", "Endereáo Completo", "Endereáo Completo"
          /*l_endereco*/ /*l_endereco*/ /*l_endereco_completo*/ /*l_endereco_completo*/
         bgcolor 8 
    bt_print
         at row 13.83 col 03.43 font ?
         help "Imprime"
    bt_can
         at row 13.83 col 14.29 font ?
         help "Cancela"
    bt_hel2
         at row 13.83 col 75.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 89.29 by 15.79
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "ParÉmetros Impress∆o Borderì".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_dlg_02_bord_ap_param_impres = 10.00
           bt_can:height-chars         in frame f_dlg_02_bord_ap_param_impres = 01.00
           bt_get_file:width-chars     in frame f_dlg_02_bord_ap_param_impres = 04.00
           bt_get_file:height-chars    in frame f_dlg_02_bord_ap_param_impres = 01.08
           bt_hel2:width-chars         in frame f_dlg_02_bord_ap_param_impres = 10.00
           bt_hel2:height-chars        in frame f_dlg_02_bord_ap_param_impres = 01.00
           bt_print:width-chars        in frame f_dlg_02_bord_ap_param_impres = 10.00
           bt_print:height-chars       in frame f_dlg_02_bord_ap_param_impres = 01.00
           bt_set_printer:width-chars  in frame f_dlg_02_bord_ap_param_impres = 04.00
           bt_set_printer:height-chars in frame f_dlg_02_bord_ap_param_impres = 01.08
           rt_002:width-chars          in frame f_dlg_02_bord_ap_param_impres = 85.86
           rt_002:height-chars         in frame f_dlg_02_bord_ap_param_impres = 01.75
           rt_005:width-chars          in frame f_dlg_02_bord_ap_param_impres = 46.14
           rt_005:height-chars         in frame f_dlg_02_bord_ap_param_impres = 06.29
           rt_007:width-chars          in frame f_dlg_02_bord_ap_param_impres = 38.72
           rt_007:height-chars         in frame f_dlg_02_bord_ap_param_impres = 12.00
           rt_008:width-chars          in frame f_dlg_02_bord_ap_param_impres = 46.14
           rt_008:height-chars         in frame f_dlg_02_bord_ap_param_impres = 02.38
           rt_009:width-chars          in frame f_dlg_02_bord_ap_param_impres = 36.86
           rt_009:height-chars         in frame f_dlg_02_bord_ap_param_impres = 03.17
           rt_010:width-chars          in frame f_dlg_02_bord_ap_param_impres = 46.14
           rt_010:height-chars         in frame f_dlg_02_bord_ap_param_impres = 02.33.
    /* set return-inserted = yes for editors */
    assign v_nom_arq_bord_ap:return-inserted in frame f_dlg_02_bord_ap_param_impres = yes.
    /* set private-data for the help system */
    assign v_log_cabec_todas_pag:private-data     in frame f_dlg_02_bord_ap_param_impres = "HLP=000013784":U
           v_ind_classif_bord:private-data        in frame f_dlg_02_bord_ap_param_impres = "HLP=000013787":U
           v_log_salta_lin:private-data           in frame f_dlg_02_bord_ap_param_impres = "HLP=000024596":U
           v_log_impr_sit:private-data            in frame f_dlg_02_bord_ap_param_impres = "HLP=000013786":U
           v_log_impr_item_estorn:private-data    in frame f_dlg_02_bord_ap_param_impres = "HLP=000022913":U
           v_ind_competencia:private-data         in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           v_log_impr_tot_bord_assin:private-data in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           v_log_impr_histor_pef:private-data     in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           v_log_impr_cabec_bco:private-data      in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           bt_set_printer:private-data            in frame f_dlg_02_bord_ap_param_impres = "HLP=000008785":U
           bt_get_file:private-data               in frame f_dlg_02_bord_ap_param_impres = "HLP=000008782":U
           v_ind_dest_bord_ap:private-data        in frame f_dlg_02_bord_ap_param_impres = "HLP=000013785":U
           v_ind_bord_dados_1:private-data        in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           v_ind_bord_guia:private-data           in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           v_nom_arq_bord_ap:private-data         in frame f_dlg_02_bord_ap_param_impres = "HLP=000013794":U
           v_ind_ender_complet:private-data       in frame f_dlg_02_bord_ap_param_impres = "HLP=000013782":U
           bt_print:private-data                  in frame f_dlg_02_bord_ap_param_impres = "HLP=000010815":U
           bt_can:private-data                    in frame f_dlg_02_bord_ap_param_impres = "HLP=000011050":U
           bt_hel2:private-data                   in frame f_dlg_02_bord_ap_param_impres = "HLP=000011326":U
           frame f_dlg_02_bord_ap_param_impres:private-data                              = "HLP=000013782".



{include/i_fclfrm.i f_dlg_02_bord_ap_param_impres }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_get_file IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite.
    assign v_nom_arq_bord_ap:screen-value in frame f_dlg_02_bord_ap_param_impres = v_cod_dwb_file.


END. /* ON CHOOSE OF bt_get_file IN FRAME f_dlg_02_bord_ap_param_impres */

ON CHOOSE OF bt_print IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_ind_dest_bord_ap   = input frame f_dlg_02_bord_ap_param_impres v_ind_dest_bord_ap
           v_nom_arq_bord_ap    = input frame f_dlg_02_bord_ap_param_impres v_nom_arq_bord_ap
           v_ind_competencia    = input frame f_dlg_02_bord_ap_param_impres v_ind_competencia
           v_log_impr_cabec_bco = input frame f_dlg_02_bord_ap_param_impres v_log_impr_cabec_bco.

    if v_log_usa_funcao = yes then
        assign v_log_impr_histor_pef = input frame f_dlg_02_bord_ap_param_impres v_log_impr_histor_pef.
    else
        assign v_log_impr_histor_pef = no.
    if not v_log_pagto_trib then do:    
        if input frame f_dlg_02_bord_ap_param_impres v_ind_bord_guia = "Borderì" /*l_bordero*/  then do:
            run prgfin/apb/apb742zb.py (Input v_log_impr_histor_pef,
                                        Input v_log_impr_cabec_bco) /*prg_fnc_bord_ap_imprimir*/.
        end.
        else do:
            run prgfin/apb/apb790za.py (Input v_ind_competencia) /*prg_fnc_bord_ap_imprimir_gps*/.
        end.
    end.
    else do:
        if input frame f_dlg_02_bord_ap_param_impres v_ind_bord_dados_1 = "Borderì" /*l_bordero*/  then do:
            run prgfin/apb/apb742zb.py (Input v_log_impr_histor_pef,
                                        Input v_log_impr_cabec_bco) /*prg_fnc_bord_ap_imprimir*/.
        end.
        else do:
            run prgfin/apb/apb790za.py (Input v_ind_competencia) /*prg_fnc_bord_ap_imprimir_gps*/.
        end.

    end.


END. /* ON CHOOSE OF bt_print IN FRAME f_dlg_02_bord_ap_param_impres */

ON CHOOSE OF bt_set_printer IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_nom_dwb_printer      = ""
           v_cod_dwb_print_layout = "".

    if  search("prgtec/btb/btb036nb.r") = ? and search("prgtec/btb/btb036nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036nb.p (output v_nom_dwb_printer,
                               output v_cod_dwb_print_layout) /*prg_see_layout_impres_imprsor*/.
    if  v_nom_dwb_printer <> ""
    and  v_cod_dwb_print_layout <> ""
    then do:
        assign v_nom_arq_bord_ap:screen-value in frame f_dlg_02_bord_ap_param_impres = v_nom_dwb_printer
                                                      + ":"
                                                      + v_cod_dwb_print_layout.

    end /* if */.
END. /* ON CHOOSE OF bt_set_printer IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_ind_bord_dados_1 IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    if v_ind_bord_dados_1:screen-value in frame f_dlg_02_bord_ap_param_impres = "Guia Previdància Social" /*l_gps*/ 
    or v_ind_bord_dados_1:screen-value in frame f_dlg_02_bord_ap_param_impres = "Darf" /*l_darf*/  then do:
        disable v_ind_classif_bord
                v_log_cabec_todas_pag
                v_log_impr_sit
                v_log_salta_lin
                v_log_impr_item_estorn
                v_log_impr_tot_bord_assin
                with frame f_dlg_02_bord_ap_param_impres.
        enable v_ind_competencia
               with frame f_dlg_02_bord_ap_param_impres.
    end.
    else do:
        enable v_ind_classif_bord
               v_log_cabec_todas_pag
               v_log_impr_sit
               v_log_salta_lin
               v_log_impr_item_estorn
               v_log_impr_tot_bord_assin
               with frame f_dlg_02_bord_ap_param_impres.
        assign v_ind_competencia:screen-value in frame f_dlg_02_bord_ap_param_impres = "Vencimento" /*l_vencimento*/ .
        disable v_ind_competencia
                with frame f_dlg_02_bord_ap_param_impres.
    end.

END. /* ON VALUE-CHANGED OF v_ind_bord_dados_1 IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_ind_bord_guia IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    if  v_ind_bord_guia:screen-value in frame f_dlg_02_bord_ap_param_impres = "Guia Previdància Social" /*l_gps*/ 
    then do:
        disable v_ind_classif_bord
                v_log_cabec_todas_pag
                v_log_impr_sit
                v_log_salta_lin
                v_log_impr_item_estorn
                v_log_impr_tot_bord_assin
                with frame f_dlg_02_bord_ap_param_impres.
        enable v_ind_competencia
               with frame f_dlg_02_bord_ap_param_impres.
    end /* if */.
    else do:
        enable v_ind_classif_bord
               v_log_cabec_todas_pag
               v_log_impr_sit
               v_log_salta_lin
               v_log_impr_item_estorn
               v_log_impr_tot_bord_assin
               with frame f_dlg_02_bord_ap_param_impres.
        assign v_ind_competencia:screen-value in frame f_dlg_02_bord_ap_param_impres = "Vencimento" /*l_vencimento*/ .
        disable v_ind_competencia
                with frame f_dlg_02_bord_ap_param_impres.
    end /* if */.

    if v_log_pagto_trib then do:
        if  v_ind_bord_guia:screen-value in frame f_dlg_02_bord_ap_param_impres = "Darf" /*l_darf*/ 
        then do:
            disable v_ind_classif_bord
                    v_log_cabec_todas_pag
                    v_log_impr_sit
                    v_log_salta_lin
                    v_log_impr_item_estorn
                    v_log_impr_tot_bord_assin
                    with frame f_dlg_02_bord_ap_param_impres.
            enable v_ind_competencia
                   with frame f_dlg_02_bord_ap_param_impres.
        end /* if */.
        else do:
            enable v_ind_classif_bord
                   v_log_cabec_todas_pag
                   v_log_impr_sit
                   v_log_salta_lin
                   v_log_impr_item_estorn
                   v_log_impr_tot_bord_assin
                   with frame f_dlg_02_bord_ap_param_impres.
            assign v_ind_competencia:screen-value in frame f_dlg_02_bord_ap_param_impres = "Vencimento" /*l_vencimento*/ .
            disable v_ind_competencia
                    with frame f_dlg_02_bord_ap_param_impres.
        end /* if */.
    end.
END. /* ON VALUE-CHANGED OF v_ind_bord_guia IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_ind_classif_bord IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_ind_classif_bord = input frame f_dlg_02_bord_ap_param_impres v_ind_classif_bord.
END. /* ON VALUE-CHANGED OF v_ind_classif_bord IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_ind_dest_bord_ap IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    /* v_ind_dest_bord_ap: */
    case self:screen-value:
        when "Terminal" /*l_terminal*/ then ter:
         do:
            assign v_nom_arq_bord_ap:sensitive in frame f_dlg_02_bord_ap_param_impres = no
                   bt_get_file:visible in frame f_dlg_02_bord_ap_param_impres = no
                   bt_set_printer:visible in frame f_dlg_02_bord_ap_param_impres = no
                   v_nom_arq_bord_ap:screen-value in frame f_dlg_02_bord_ap_param_impres = "".
        end /* do ter */.
        when "Arquivo" /*l_file*/ then arq:
         do:
            assign v_nom_arq_bord_ap:sensitive in frame f_dlg_02_bord_ap_param_impres = yes
                   bt_set_printer:visible in frame f_dlg_02_bord_ap_param_impres = no.
            assign bt_get_file:visible in frame f_dlg_02_bord_ap_param_impres = yes.
               /* define arquivo default */

                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index srmstr_id
    &endif
                      /*cl_current_user of usuar_mestre*/ no-error.
                assign v_nom_arq_bord_ap = "".
                if  usuar_mestre.nom_dir_spool <> ""
                then do:
                    assign v_nom_arq_bord_ap = usuar_mestre.nom_dir_spool
                                                      + "~/".
                end /* if */.
                if  usuar_mestre.nom_subdir_spool <> ""
                then do:
                    assign v_nom_arq_bord_ap = v_nom_arq_bord_ap
                                                      + usuar_mestre.nom_subdir_spool
                                                      + "~/".
                end /* if */.
                assign v_nom_arq_bord_ap = v_nom_arq_bord_ap
                                           + caps("apb742za":U)
                                           + '.rpt'.

    /* @else()
                    assign v_nom_arq_bord_ap = v_nom_arq_bord_ap
                                                      + v_cod_dwb_file_temp.
                @end_else().

                assign v_nom_arq_bord_ap:screen-value in frame @&(frame_aux) = session:temp-directory +
                                  substring (@fx_prog_ext(@&(program)), 12, 8) + '.rpt'. */
                assign v_nom_arq_bord_ap:screen-value in frame f_dlg_02_bord_ap_param_impres = v_nom_arq_bord_ap.
        end /* do arq */.
        when "Impressora" /*l_printer*/ then prn:
         do:
            assign v_nom_arq_bord_ap:sensitive in frame f_dlg_02_bord_ap_param_impres = no
                   bt_get_file:visible in frame f_dlg_02_bord_ap_param_impres = no
                   v_nom_arq_bord_ap:screen-value in frame f_dlg_02_bord_ap_param_impres = ""
                   bt_set_printer:visible in frame f_dlg_02_bord_ap_param_impres = yes.
                        /* define layout default */

                if  v_nom_dwb_printer = ""
                and  v_cod_dwb_print_layout = ""
                then do:
                    run pi_set_print_layout_bord /*pi_set_print_layout_bord*/.
                end /* if */.
                else do:
                    assign v_nom_arq_bord_ap:screen-value = v_nom_dwb_printer
                                                           + ":"
                                                           + v_cod_dwb_print_layout.
                end /* else */.
        end /* do prn */.
    end /* case v_ind_dest_bord_ap */.

END. /* ON VALUE-CHANGED OF v_ind_dest_bord_ap IN FRAME f_dlg_02_bord_ap_param_impres */

ON LEAVE OF v_ind_ender_complet IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign input frame f_dlg_02_bord_ap_param_impres v_ind_ender_complet.
END. /* ON LEAVE OF v_ind_ender_complet IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_log_cabec_todas_pag IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_log_cabec_todas_pag = input frame f_dlg_02_bord_ap_param_impres v_log_cabec_todas_pag.
END. /* ON VALUE-CHANGED OF v_log_cabec_todas_pag IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_log_impr_item_estorn IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_log_impr_item_estorn = input frame f_dlg_02_bord_ap_param_impres v_log_impr_item_estorn.
END. /* ON VALUE-CHANGED OF v_log_impr_item_estorn IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_log_impr_sit IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_log_impr_sit = input frame f_dlg_02_bord_ap_param_impres v_log_impr_sit.
END. /* ON VALUE-CHANGED OF v_log_impr_sit IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_log_impr_tot_bord_assin IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_log_impr_tot_bord_assin = input frame f_dlg_02_bord_ap_param_impres v_log_impr_tot_bord_assin.

END. /* ON VALUE-CHANGED OF v_log_impr_tot_bord_assin IN FRAME f_dlg_02_bord_ap_param_impres */

ON VALUE-CHANGED OF v_log_salta_lin IN FRAME f_dlg_02_bord_ap_param_impres
DO:

    assign v_log_salta_lin = input frame f_dlg_02_bord_ap_param_impres v_log_salta_lin.
END. /* ON VALUE-CHANGED OF v_log_salta_lin IN FRAME f_dlg_02_bord_ap_param_impres */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_02_bord_ap_param_impres ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_02_bord_ap_param_impres */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_bord_ap_param_impres ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_bord_ap_param_impres */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_bord_ap_param_impres ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_bord_ap_param_impres */

ON WINDOW-CLOSE OF FRAME f_dlg_02_bord_ap_param_impres
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_02_bord_ap_param_impres */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_02_bord_ap_param_impres.



        apply "choose" to bt_hel2 in frame f_dlg_02_bord_ap_param_impres.



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


        assign v_nom_prog     = substring(frame f_dlg_02_bord_ap_param_impres:title, 1, max(1, length(frame f_dlg_02_bord_ap_param_impres:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_bord_ap_param_impres":U.



        assign v_nom_prog     = substring(frame f_dlg_02_bord_ap_param_impres:title, 1, max(1, length(frame f_dlg_02_bord_ap_param_impres:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_bord_ap_param_impres":U.


    assign v_nom_prog_ext = "prgfin/apb/apb742za.p":U
           v_cod_release  = trim(" 1.00.00.026":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract 
{include/i-ctrlrp5.i fnc_bord_ap_param_impres}*/


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
    run pi_version_extract ('fnc_bord_ap_param_impres':U, 'prgfin/apb/apb742za.p':U, '1.00.00.026':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:"
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
        message "Programa execut†vel n∆o foi encontrado:"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_bord_ap_param_impres') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bord_ap_param_impres')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bord_ap_param_impres')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_bord_ap_param_impres' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_bord_ap_param_impres'
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
    where prog_dtsul.cod_prog_dtsul = "fnc_bord_ap_param_impres":U
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


assign v_wgh_frame_epc = frame f_dlg_02_bord_ap_param_impres:handle.



assign v_nom_table_epc = 'bord_ap':U
       v_rec_table_epc = recid(bord_ap).

&endif

/* End_Include: i_verify_program_epc */

/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_dlg_02_bord_ap_param_impres:title = frame f_dlg_02_bord_ap_param_impres:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.026":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_dlg_02_bord_ap_param_impres = menu m_help:handle.


/* End_Include: i_std_dialog_box */
{include/title5.i f_dlg_02_bord_ap_param_impres FRAME}


assign v_cod_dwb_proced = "tar_emitir_bord_ap":U.
pause 0 before-hide.
view frame f_dlg_02_bord_ap_param_impres.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'INITIALIZE',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */

do transaction:
   find bord_ap no-lock where recid(bord_ap) = v_rec_bord_ap no-error.
end.
/* **********Funá∆o Pagamentos de Tributos - DARF******/

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
.
ASSIGN v_log_pagto_trib  = &IF DEFINED (BF_FIN_PGTO_TRIBUT_ESCRIT) &THEN YES &ELSE GetDefinedFunction('SPP_PGTO_TRIBUTO_ESCRIT':U) &ENDIF.
/* ***************************************************/

&if defined(BF_FIN_4LINHAS_END) &then
&else
    hide v_ind_ender_complet in frame f_dlg_02_bord_ap_param_impres.
&endif

assign v_log_usa_funcao = no. 

&if '{&emsfin_version}' >= '5.06' &then
    &if defined(BF_FIN_IMPRIME_HISTORICO_BORDERO) &then
        assign v_log_usa_funcao = yes.
    &endif
&else
    if can-find(first emscad.histor_exec_especial 
        where emscad.histor_exec_especial.cod_prog_dtsul = 'SPP_IMPRIME_HISTORICO_BORDERO') then do:
        assign v_log_usa_funcao = yes.
    end.
&endif

if not can-find(first item_bord_ap
    where item_bord_ap.cod_estab_bord = bord_ap.cod_estab_bord
     and   item_bord_ap.cod_portador = bord_ap.cod_portador
     and   item_bord_ap.num_bord_ap = bord_ap.num_bord_ap
     and   item_bord_ap.cod_refer_antecip_pef <> ''
     and   item_bord_ap.cod_refer_antecip_pef <> ?)
    then do:
    assign v_log_usa_funcao = no.
end.

if v_log_usa_funcao = no then
    hide v_log_impr_histor_pef in frame f_dlg_02_bord_ap_param_impres.

if  bord_ap.ind_tip_bord_ap = "Normal" /*l_normal*/ 
then do:
    assign v_ind_classif_bord = "Por Valor" /*l_por_data_vencimento*/ .
end /* if */.
else do:    
    assign v_log_method = v_ind_classif_bord:delete("Por Valor" /*l_por_fornecedor*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Fornecedor" /*l_por_fornecedor*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Data Vencimento" /*l_por_data_vencimento*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Forma de Pagto/Fornecedor" /*l_por_forma_pagto_fornecedor*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Estabelecimento/Fornecedor" /*l_por_estabelecimentofornecedor*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Estabelecimento/Data Vencto" /*l_por_estabelecimentodata_vencto*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Estabelecimento/Forma Pagto" /*l_por_estabelecimentoforma_pagto*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.
    assign v_log_method = v_ind_classif_bord:delete("Por Fornecedor/Documento" /*l_por_fornecedordocumento*/ ) in frame f_dlg_02_bord_ap_param_impres no-error.

    assign v_log_method = v_ind_classif_bord:insert("Por Favorecido",1)
           v_log_method = v_ind_classif_bord:insert("Por Data Emiss∆o" ,2)
           in frame f_dlg_02_bord_ap_param_impres.
    assign v_ind_classif_bord = "Por Data Emiss∆o" /*l_por_data_emissao*/ .
end /* else */.           

assign v_log_impr_item_estorn = no.

display v_ind_classif_bord
        v_log_cabec_todas_pag
        v_log_impr_sit
        v_log_salta_lin
        v_log_impr_item_estorn
        v_ind_bord_guia
        v_ind_competencia
        v_log_impr_tot_bord_assin
        v_log_impr_cabec_bco
        with frame f_dlg_02_bord_ap_param_impres.

main_block:
do on error undo main_block, retry main_block:
    assign v_log_save_ok  = no
           v_cod_dwb_user = v_cod_usuar_corren.

    enable bt_can
           bt_get_file
           bt_hel2
           bt_print
           bt_set_printer
           v_ind_classif_bord
           v_ind_dest_bord_ap
           v_log_cabec_todas_pag
           v_log_impr_sit
           v_log_salta_lin
           v_log_impr_item_estorn
           v_ind_bord_guia
           v_log_impr_tot_bord_assin
           v_log_impr_cabec_bco
           with frame f_dlg_02_bord_ap_param_impres.
    assign bt_get_file:visible          in frame f_dlg_02_bord_ap_param_impres = no
           bt_set_printer:visible       in frame f_dlg_02_bord_ap_param_impres = no
           v_nom_arq_bord_ap:sensitive  in frame f_dlg_02_bord_ap_param_impres = no.
    /* DARF*/
    if v_log_pagto_trib then do:
        disable v_ind_bord_guia with frame  f_dlg_02_bord_ap_param_impres.
        assign v_ind_bord_guia:visible in frame f_dlg_02_bord_ap_param_impres = no.
    end.
    else do:
        disable v_ind_bord_dados_1 with frame  f_dlg_02_bord_ap_param_impres.
        assign v_ind_bord_dados_1:visible in frame f_dlg_02_bord_ap_param_impres = no.
    end.
    /* ----*/

    assign v_ind_ender_complet = "Endereáo" /*l_endereco*/ .
    &if defined(BF_FIN_4LINHAS_END) &then
        enable v_ind_ender_complet
               with frame f_dlg_02_bord_ap_param_impres.
    &endif
    if v_log_usa_funcao = yes then
        enable v_log_impr_histor_pef
               with frame f_dlg_02_bord_ap_param_impres.

    apply "value-changed" to v_ind_dest_bord_ap.
    apply "value-changed" to v_log_cabec_todas_pag.
    apply "value-changed" to v_log_salta_lin.
    apply "value-changed" to v_log_impr_sit.
    apply "value-changed" to v_log_impr_item_estorn.
    apply "value-changed" to v_ind_classif_bord.
    apply "value-changed" to v_log_impr_tot_bord_assin.
    apply "value-changed" to v_log_impr_cabec_bco.

    if  bord_ap.ind_sit_bord_ap = "Em Digitaá∆o" /*l_em_digitacao*/  or 
        bord_ap.ind_sit_bord_ap = "Ja Impresso" /*l_ja_impresso*/ 
    then do:
        assign v_log_impr_item_estorn = no.
        display v_log_impr_item_estorn
                with frame f_dlg_02_bord_ap_param_impres.
        disable v_log_impr_item_estorn
                with frame f_dlg_02_bord_ap_param_impres.
    end /* if */.
    else do:
        if  bord_ap.ind_sit_bord_ap = "Enviado ao Banco" /*l_enviado_ao_banco*/      or 
            bord_ap.ind_sit_bord_ap = "Parcialmente Baixado" /*l_parcialmente_baixado*/  or
            bord_ap.ind_sit_bord_ap = "Totalmente Baixado" /*l_totalmente_baixado*/ 
        then do:
            enable v_log_impr_item_estorn
                   with frame f_dlg_02_bord_ap_param_impres.
        end /* if */.
        else do:            
            if  bord_ap.ind_sit_bord_ap = "Estornado" /*l_estornado*/ 
            then do:
                assign v_log_impr_item_estorn = yes.
                display v_log_impr_item_estorn
                        with frame f_dlg_02_bord_ap_param_impres.
                disable v_log_impr_item_estorn
                        with frame f_dlg_02_bord_ap_param_impres.
            end /* if */.    
        end /* else */.
    end /* else */.      
    if not v_log_pagto_trib then do:
        &if defined(bf_fin_gps) &then
        if bord_ap.log_bord_gps = yes then do:
        &else
        if (entry(1,bord_ap.cod_livre_1,chr(10)) = 'yes') = yes then do:
        &endif    
            assign v_ind_bord_guia = "Guia Previdància Social" /*l_gps*/ .
            disp v_ind_bord_guia with frame f_dlg_02_bord_ap_param_impres.
            disable v_ind_classif_bord
                    v_log_cabec_todas_pag
                    v_log_impr_sit
                    v_log_salta_lin
                    v_log_impr_item_estorn
                    v_log_impr_tot_bord_assin
                    with frame f_dlg_02_bord_ap_param_impres.
            enable v_ind_competencia
                   with frame f_dlg_02_bord_ap_param_impres.
        end.
        else do:
            assign v_ind_bord_guia = "Borderì" /*l_bordero*/ .
            disp v_ind_bord_guia with frame f_dlg_02_bord_ap_param_impres.
            disable v_ind_bord_guia
                    v_ind_competencia
                    with frame f_dlg_02_bord_ap_param_impres.
        end.
    end.
    else do:
        &if defined(bf_fin_gps) &then
        if bord_ap.log_bord_gps = yes then do:
        &else
        if (entry(1,bord_ap.cod_livre_1,chr(10)) = 'yes') = yes then do:
        &endif    
            assign v_ind_bord_dados_1 = "Guia Previdància Social" /*l_gps*/ .
            disp v_ind_bord_dados_1 with frame f_dlg_02_bord_ap_param_impres.
            disable v_ind_classif_bord
                    v_log_cabec_todas_pag
                    v_log_impr_sit
                    v_log_salta_lin
                    v_log_impr_item_estorn
                    v_log_impr_tot_bord_assin
                    with frame f_dlg_02_bord_ap_param_impres.
            enable v_ind_competencia
                   with frame f_dlg_02_bord_ap_param_impres.
        end.
        else do:
        &if '{&emsfin_version}' >= '5.06' &then 
            if bord_ap.log_bord_darf = yes then do:          
        &else             
            if num-entries(bord_ap.cod_livre_1,chr(10)) > 2
            and entry(3,bord_ap.cod_livre_1,chr(10)) = 'yes' then do:
        &endif
                assign v_ind_bord_dados_1 = "Darf" /*l_darf*/ .
                disp v_ind_bord_dados_1 with frame f_dlg_02_bord_ap_param_impres.
                disable v_ind_classif_bord
                        v_log_cabec_todas_pag
                        v_log_impr_sit
                        v_log_salta_lin
                        v_log_impr_item_estorn
                        v_log_impr_tot_bord_assin
                        with frame f_dlg_02_bord_ap_param_impres.
                enable v_ind_competencia
                       with frame f_dlg_02_bord_ap_param_impres.
           end.
           else do:
               assign v_ind_bord_dados_1 = "Borderì" /*l_bordero*/ .
               disp v_ind_bord_dados_1 with frame f_dlg_02_bord_ap_param_impres.
               disable v_ind_bord_dados_1
                       v_ind_competencia
                       with frame f_dlg_02_bord_ap_param_impres.
           end.    
       end.
    end.     

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

    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_02_bord_ap_param_impres focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_dlg_02_bord_ap_param_impres.
        end /* else */.
        save_block:
        do on error undo save_block, leave save_block:
             if  input frame f_dlg_02_bord_ap_param_impres v_ind_dest_bord_ap = "Arquivo" /*l_file*/ 
             then do:
                 run pi_filename_validation (Input input frame f_dlg_02_bord_ap_param_impres v_nom_arq_bord_ap) /*pi_filename_validation*/.
                 if  return-value = "NOK" /*l_nok*/ 
                 then do:
                     /* Nome do arquivo incorreto ! */
                     run pi_messages (input "show",
                                      input 1064,
                                      input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
                     assign v_wgh_focus = v_nom_arq_bord_ap:handle in frame f_dlg_02_bord_ap_param_impres.
                     leave save_block.
                 end /* if */.
              end /* if */.
        assign v_log_save_ok = yes.
        end /* do save_block */.
    end /* repeat wait_block */.
end /* do main_block */.

hide frame f_dlg_02_bord_ap_param_impres.


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




/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

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
** Procedure Interna.....: pi_set_print_layout_bord
** Descricao.............: pi_set_print_layout_bord
** Criado por............: Ganzen
** Criado em.............: 25/04/1996 08:43:35
** Alterado por..........: Marciop
** Alterado em...........: 01/12/1998 17:52:00
*****************************************************************************/
PROCEDURE pi_set_print_layout_bord:

    dflt:
    do with frame f_dlg_02_bord_ap_param_impres:
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
        if  avail layout_impres_padr
        then do:
            assign v_nom_dwb_printer      = layout_impres_padr.nom_impressora
                   v_cod_dwb_print_layout = layout_impres_padr.cod_layout_impres
                   v_nom_arq_bord_ap:screen-value = v_nom_dwb_printer
                                                   + ":"
                                                   + v_cod_dwb_print_layout.
        end /* if */.
        else do:
            assign v_nom_dwb_printer       = ""
                   v_cod_dwb_print_layout  = ""
                   v_nom_arq_bord_ap:screen-value = "".
        end /* else */.
    end /* do dflt */.
END PROCEDURE. /* pi_set_print_layout_bord */
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
    /* ix_iz1_fnc_bord_ap_param_impres */


    /* Begin_Include: i_exec_program_epc_pi_fin */
    if  v_nom_prog_upc <> ''    
    or  v_nom_prog_appc <> ''
    or  v_nom_prog_dpc <> '' then do:
        &if 'bord_ap' <> '' &then
            assign v_rec_table_epc = recid(bord_ap)
                   v_nom_table_epc = 'bord_ap'.
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


    /* ix_iz2_fnc_bord_ap_param_impres */
END PROCEDURE. /* pi_exec_program_epc_FIN */


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
        message "Mensagem nr. " skip
                "Programa Mensagem"
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*********************  End of fnc_bord_ap_param_impres *********************/
