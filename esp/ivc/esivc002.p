/*****************************************************************************
**     Programa.........: esp/ivc/esivc002.p
**     Descricao .......: Consulta Controle de Inadimplància
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 18/01/2016
*******************************************************************************/

def var c-versao-prg as char initial " 5.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=0":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_tit_inadimp_abert no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cdn_clien_matriz             as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Matriz" column-label "Cliente Matriz"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T°tulo" column-label "Vl Original T°tulo"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field tta_dat_agenda                   as date format "99/99/9999" initial today label "Data Agenda" column-label "Data Agenda"
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    FIELD tta_ind_sit_item_agenda_inadimp  LIKE ind_sit_item_agenda_inadimp
    index tt_codigo                       
          tta_cdn_cliente                  ascending
          tta_dat_vencto_tit_acr           ascending
    .



/********************** Temporary Table Definition End **********************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
&if '{&emsbas_version}' >= '5.06' &then
         resize               = no
&else
         resize               = yes
&endif
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.

{include/i_fclwin.i wh_w_program }
/*************************** Window Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cdn_cliente_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "Cliente Final"
    no-undo.
def var v_cdn_cliente_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente"
    column-label "Cliente Inicial"
    no-undo.
def var v_cdn_clien_matriz_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cdn_clien_matriz_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente Matriz"
    column-label "Cliente Matriz"
    no-undo.
def var v_cdn_repres_fim
    as Integer
    format ">>>,>>9":U
    initial 999999
    label "atÇ"
    column-label "Repres Final"
    no-undo.
def var v_cdn_repres_ini
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
def var v_cod_cart_bcia_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_ini
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
def var v_cod_grp_clien_fim
    as character
    format "x(4)":U
    initial "ZZZZ"
    label "atÇ"
    column-label "Grupo Cliente"
    no-undo.
def var v_cod_grp_clien_ini
    as character
    format "x(4)":U
    label "Grupo Cliente"
    column-label "Grupo Cliente"
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
def var v_cod_portador_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Portador Final"
    no-undo.
def var v_cod_portador_ini
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador Inicial"
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
def var v_cod_usuario_ini
    as character
    format "x(12)":U
    label "Usu†rio Inicial"
    column-label "Usu†rio Inicial"
    no-undo.
def var v_cod_usuar_ate
    as character
    format "x(12)":U
    label "atÇ"
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
def var v_dat_vencto_tit_acr_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "atÇ"
    column-label "Vencto Final"
    no-undo.
def var v_dat_vencto_tit_acr_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Vencimento"
    column-label "Vencto Inicial"
    no-undo.
def var v_des_col_ord_browse
    as character
    format "x(40)":U
    extent 10
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
def var v_des_estab_select_aux
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    no-undo.
def var v_log_col_ord_browse_ascend
    as logical
    format "Sim/N∆o"
    initial [no]
    extent 10
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
def var v_num_tot_tit
    as integer
    format ">>>>,>>9":U
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def new global shared var v_rec_clien_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_acr
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_inadimp
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_tot_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Valor Total"
    column-label "Valor Total"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.


&if '{&emsbas_version}' >= '5.06' &then
def temp-table tt_maximizacao no-undo
    field hdl-widget             as widget-handle
    field tipo-widget            as character 
    field row-original           as decimal
    field col-original           as decimal
    field width-original         as decimal
    field height-original        as decimal
    field log-posiciona-row      as logical
    field log-posiciona-col      as logical
    field log-calcula-width      as logical
    field log-calcula-height     as logical
    field log-button-right       as logical
    field frame-width-original   as decimal
    field frame-height-original  as decimal
    field window-width-original  as decimal
    field window-height-original as decimal.
&endif
/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/


def sub-menu  mi_table
    menu-item mi_exi               label "Sair".

def sub-menu  mi_hel
    menu-item mi_contents          label "Conte£do"
    RULE
    menu-item mi_about             label "Sobre".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Tabela"
    sub-menu  mi_hel                label "Ajuda".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_tit_inadimp_abert
    for tt_tit_inadimp_abert
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_tit_inadimp_abert query qr_tit_inadimp_abert display 
    tt_tit_inadimp_abert.tta_cdn_cliente
    width-chars 09.00
        column-label "Cliente"
    tt_tit_inadimp_abert.tta_cod_empresa
    width-chars 05.86
        column-label "Empresa"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    tt_tit_inadimp_abert.tta_cod_estab
    width-chars 03.86
        column-label "Estab"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    tt_tit_inadimp_abert.tta_cod_estab
    width-chars 05.00
        column-label "Estab"
&ENDIF
    tt_tit_inadimp_abert.tta_cod_espec_docto
    width-chars 05.43
        column-label "EspÇcie"
    tt_tit_inadimp_abert.tta_cod_ser_docto
    format "x(5)"
    width-chars 5.00
 column-label "SÇrie"
    tt_tit_inadimp_abert.tta_cod_tit_acr
    format "x(16)"
    width-chars 16.00
 column-label "T°tulo"
    tt_tit_inadimp_abert.tta_cod_parcela
    width-chars 03.14
        column-label "Parc"
    tt_tit_inadimp_abert.tta_dat_vencto_tit_acr
    width-chars 10.00
        column-label "Vencimento"
    tt_tit_inadimp_abert.tta_val_sdo_tit_acr
    width-chars 12.00
        column-label "Saldo T°tulo"
    tt_tit_inadimp_abert.tta_val_origin_tit_acr
    width-chars 12.00
        column-label "Vl Original T°tulo"
    tt_tit_inadimp_abert.tta_cod_usuario
    width-chars 12.00
        column-label "Usu†rio"
    tt_tit_inadimp_abert.tta_dat_agenda
    width-chars 10.00
        column-label "Data Agenda"
    tt_tit_inadimp_abert.tta_cod_grp_clien
    width-chars 09.14
        column-label "Grupo Cliente"
    tt_tit_inadimp_abert.tta_cdn_clien_matriz
    width-chars 09.00
        column-label "Cliente Matriz"
    tt_tit_inadimp_abert.tta_cdn_repres
    width-chars 10.00
        column-label "Representante"
    tt_tit_inadimp_abert.tta_cod_portador
    width-chars 05.72
        column-label "Portador"
    tt_tit_inadimp_abert.tta_cod_cart_bcia
    width-chars 05.14
        column-label "Carteira"
    tt_tit_inadimp_abert.tta_dat_emis_docto
    width-chars 10.00
        column-label "Dt Emiss∆o"
    tt_tit_inadimp_abert.tta_ind_sit_item_agenda_inadimp
    width-chars 15.00
        column-label "Situaá∆o"
    with separators single 
         size 86.43 by 11.79
         font 1
         bgcolor 15
         title "T°tulos em Aberto Controle Inadimplància".


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
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_atz2
    label "Atualiza"
    tooltip "Atualiza"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-tick.bmp"
&endif
    size 1 by 1.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_det1
    label "Det"
    tooltip "Detalhe"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-det"
    image-insensitive file "image/ii-det"
&endif
    size 1 by 1.
def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
&endif
    size 1 by 1.
def button bt_hel1
    label " ?"
    tooltip "Ajuda"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-hel"
    image-insensitive file "image/ii-hel"
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
def button bt_planilha_excel
    label "Planilha"
    tooltip "Planilha do Excel"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-exel.bmp"
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
def button bt_todos_img
    label "Todos"
    tooltip "Seleciona Todos"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-ran_a.bmp"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_414372
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_414373
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_tit_inadimp_abert
    rt_mold
         at row 02.50 col 02.00
    rt_002
         at row 15.33 col 18.00
    " Valor Total de T°tulos " view-as text
         at row 15.03 col 20.00
    rt_001
         at row 15.33 col 02.00
    " Num de T°tulos " view-as text
         at row 15.03 col 04.00 bgcolor 8 
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    bt_ran2
         at row 01.08 col 01.72 font ?
         help "Faixa"
    bt_det1
         at row 01.08 col 06.14 font ?
         help "Detalhe"
    bt_planilha_excel
         at row 01.08 col 10.57 font ?
         help "Planilha do Excel"
    bt_atz2
         at row 01.08 col 16.29 font ?
         help "Atualiza"
    bt_exi
         at row 01.08 col 82.57 font ?
         help "Sa°da"
    bt_hel1
         at row 01.08 col 86.57 font ?
         help "Ajuda"
    br_tit_inadimp_abert
         at row 02.83 col 02.86
    v_num_tot_tit
         at row 15.71 col 06.57 no-label
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_tot_2
         at row 15.75 col 19.00 no-label
         help "Valor Total"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 17.00
         at row 01.50 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "ESIVC002 - Consulta T°tulos em Aberto Controle Inadimplància".
    /* adjust size of objects in this frame */
    assign bt_atz2:width-chars            in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_atz2:height-chars           in frame f_bas_10_tit_inadimp_abert = 01.13
           bt_det1:width-chars            in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_det1:height-chars           in frame f_bas_10_tit_inadimp_abert = 01.13
           bt_exi:width-chars             in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_exi:height-chars            in frame f_bas_10_tit_inadimp_abert = 01.13
           bt_hel1:width-chars            in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_hel1:height-chars           in frame f_bas_10_tit_inadimp_abert = 01.13
           bt_planilha_excel:width-chars  in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_planilha_excel:height-chars in frame f_bas_10_tit_inadimp_abert = 01.13
           bt_ran2:width-chars            in frame f_bas_10_tit_inadimp_abert = 04.00
           bt_ran2:height-chars           in frame f_bas_10_tit_inadimp_abert = 01.13
           rt_001:width-chars             in frame f_bas_10_tit_inadimp_abert = 14.72
           rt_001:height-chars            in frame f_bas_10_tit_inadimp_abert = 01.50
           rt_002:width-chars             in frame f_bas_10_tit_inadimp_abert = 21.00
           rt_002:height-chars            in frame f_bas_10_tit_inadimp_abert = 01.50
           rt_mold:width-chars            in frame f_bas_10_tit_inadimp_abert = 88.29
           rt_mold:height-chars           in frame f_bas_10_tit_inadimp_abert = 12.42
           rt_rgf:width-chars             in frame f_bas_10_tit_inadimp_abert = 89.72
           rt_rgf:height-chars            in frame f_bas_10_tit_inadimp_abert = 01.29.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_tit_inadimp_abert:ALLOW-COLUMN-SEARCHING in frame f_bas_10_tit_inadimp_abert = no
       br_tit_inadimp_abert:COLUMN-MOVABLE in frame f_bas_10_tit_inadimp_abert = no.
end.
&endif
    /* set private-data for the help system */
    assign bt_ran2:private-data              in frame f_bas_10_tit_inadimp_abert = "HLP=000008773":U
           bt_det1:private-data              in frame f_bas_10_tit_inadimp_abert = "HLP=000010830":U
           bt_planilha_excel:private-data    in frame f_bas_10_tit_inadimp_abert = "HLP=000000000":U
           bt_atz2:private-data              in frame f_bas_10_tit_inadimp_abert = "HLP=000000000":U
           bt_exi:private-data               in frame f_bas_10_tit_inadimp_abert = "HLP=000004665":U
           bt_hel1:private-data              in frame f_bas_10_tit_inadimp_abert = "HLP=000004666":U
           br_tit_inadimp_abert:private-data in frame f_bas_10_tit_inadimp_abert = "HLP=000000000":U
           v_num_tot_tit:private-data        in frame f_bas_10_tit_inadimp_abert = "HLP=000000000":U
           v_val_tot_2:private-data          in frame f_bas_10_tit_inadimp_abert = "HLP=000000000":U
           frame f_bas_10_tit_inadimp_abert:private-data                         = "HLP=000000000".

def frame f_ran_01_tit_inadimp_abert_faixa
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 12.04 col 02.00 bgcolor 7 
    bt_todos_img
         at row 01.46 col 52.14 font ?
         help "Seleciona Todos"
    v_des_estab_select
         at row 01.50 col 20.00 colon-aligned label "Estab Selec"
         help "Estabelecimentos selecionados"
         view-as editor max-chars 2000 no-word-wrap
         size 30 by 1
         bgcolor 15 font 2
    v_cod_espec_docto_ini
         at row 02.50 col 19.86 colon-aligned label "EspÇcie"
         help "C¢digo Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_fim
         at row 02.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_cliente_ini
         at row 03.50 col 19.86 colon-aligned label "Cliente"
         help "C¢digo do Cliente Inicial"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_414373
         at row 03.50 col 34.00
    v_cdn_cliente_fim
         at row 03.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo do Cliente Final"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_414372
         at row 03.50 col 57.00
    v_cod_grp_clien_ini
         at row 04.50 col 19.86 colon-aligned label "Grupo Cliente"
         help "C¢digo Grupo Cliente"
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_grp_clien_fim
         at row 04.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo Grupo Cliente"
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_clien_matriz_ini
         at row 05.50 col 19.86 colon-aligned label "Matriz"
         help "C¢digo - NumÇrico Cliente Matriz"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_clien_matriz_fim
         at row 05.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo - NumÇrico Cliente Matriz"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portador_ini
         at row 06.50 col 19.86 colon-aligned label "Portador"
         help "C¢digo Portador Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portador_fim
         at row 06.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo Portador"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_ini
         at row 07.50 col 19.86 colon-aligned label "Carteira"
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_fim
         at row 07.50 col 42.86 colon-aligned label "atÇ"
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_repres_ini
         at row 08.50 col 19.86 colon-aligned label "Representante"
         help "C¢digo Representante"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_repres_fim
         at row 08.50 col 42.86 colon-aligned label "atÇ"
         help "C¢digo Representante"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_tit_acr_ini
         at row 09.50 col 19.86 colon-aligned label "Vencimento"
         help "Data Vencimento T°tulo"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_tit_acr_fim
         at row 09.50 col 42.86 colon-aligned label "atÇ"
         help "Data Vencimento T°tulo"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_usuario_ini
         at row 10.50 col 19.86 colon-aligned label "Usu†rio Inicial"
         help "Usu†rio Inicial"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_usuar_ate
         at row 10.50 col 42.86 colon-aligned label "atÇ"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 12.25 col 03.00 font ?
         help "OK"
    bt_can
         at row 12.25 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 12.25 col 55.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 68.00 by 13.88 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - T°tulo Controle de Inadi".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars        in frame f_ran_01_tit_inadimp_abert_faixa = 10.00
           bt_can:height-chars       in frame f_ran_01_tit_inadimp_abert_faixa = 01.00
           bt_hel2:width-chars       in frame f_ran_01_tit_inadimp_abert_faixa = 10.00
           bt_hel2:height-chars      in frame f_ran_01_tit_inadimp_abert_faixa = 01.00
           bt_ok:width-chars         in frame f_ran_01_tit_inadimp_abert_faixa = 10.00
           bt_ok:height-chars        in frame f_ran_01_tit_inadimp_abert_faixa = 01.00
           bt_todos_img:width-chars  in frame f_ran_01_tit_inadimp_abert_faixa = 04.00
           bt_todos_img:height-chars in frame f_ran_01_tit_inadimp_abert_faixa = 01.13
           rt_cxcf:width-chars       in frame f_ran_01_tit_inadimp_abert_faixa = 64.57
           rt_cxcf:height-chars      in frame f_ran_01_tit_inadimp_abert_faixa = 01.42
           rt_mold:width-chars       in frame f_ran_01_tit_inadimp_abert_faixa = 64.57
           rt_mold:height-chars      in frame f_ran_01_tit_inadimp_abert_faixa = 10.58.
    /* set return-inserted = yes for editors */
    assign v_des_estab_select:return-inserted in frame f_ran_01_tit_inadimp_abert_faixa = yes.
    /* set private-data for the help system */
    assign bt_todos_img:private-data             in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000021504":U
           v_des_estab_select:private-data       in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000000000":U
           v_cod_espec_docto_ini:private-data    in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000016628":U
           v_cod_espec_docto_fim:private-data    in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000016629":U
           bt_zoo_414373:private-data            in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000009431":U
           v_cdn_cliente_ini:private-data        in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000022353":U
           bt_zoo_414372:private-data            in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000009431":U
           v_cdn_cliente_fim:private-data        in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000022352":U
           v_cod_grp_clien_ini:private-data      in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023781":U
           v_cod_grp_clien_fim:private-data      in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023782":U
           v_cdn_clien_matriz_ini:private-data   in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000000000":U
           v_cdn_clien_matriz_fim:private-data   in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000000000":U
           v_cod_portador_ini:private-data       in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000014638":U
           v_cod_portador_fim:private-data       in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000014647":U
           v_cod_cart_bcia_ini:private-data      in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023778":U
           v_cod_cart_bcia_fim:private-data      in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000016642":U
           v_cdn_repres_ini:private-data         in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023776":U
           v_cdn_repres_fim:private-data         in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023777":U
           v_dat_vencto_tit_acr_ini:private-data in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023783":U
           v_dat_vencto_tit_acr_fim:private-data in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000023784":U
           v_cod_usuario_ini:private-data        in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000014389":U
           v_cod_usuar_ate:private-data          in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000000000":U
           bt_ok:private-data                    in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000010721":U
           bt_can:private-data                   in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_ran_01_tit_inadimp_abert_faixa = "HLP=000011326":U
           frame f_ran_01_tit_inadimp_abert_faixa:private-data                             = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_414373:sensitive in frame f_ran_01_tit_inadimp_abert_faixa = yes
           bt_zoo_414372:sensitive in frame f_ran_01_tit_inadimp_abert_faixa = yes.
    /* move buttons to top */
    bt_zoo_414373:move-to-top().
    bt_zoo_414372:move-to-top().



{include/i_fclfrm.i f_bas_10_tit_inadimp_abert f_ran_01_tit_inadimp_abert_faixa }
/*************************** Frame Definition End ***************************/
&if '{&emsbas_version}' >= '5.06' &then
ON WINDOW-MAXIMIZED OF wh_w_program
DO:
def var v_whd_widget as widget-handle no-undo.
assign frame f_bas_10_tit_inadimp_abert:width-chars  = wh_w_program:width-chars
       frame f_bas_10_tit_inadimp_abert:height-chars = wh_w_program:height-chars no-error.

for each tt_maximizacao:
    assign v_whd_widget = tt_maximizacao.hdl-widget.

    if tt_maximizacao.log-posiciona-row = yes then do:
        assign v_whd_widget:row = wh_w_program:height - (tt_maximizacao.window-height-original - tt_maximizacao.row-original).
    end.
    if tt_maximizacao.log-calcula-width = yes then do:
        assign v_whd_widget:width = wh_w_program:width - ( tt_maximizacao.window-width-original - tt_maximizacao.width-original ).
    end.
    if tt_maximizacao.log-calcula-height = yes then do:
        assign v_whd_widget:height = wh_w_program:height - ( tt_maximizacao.window-height-original - tt_maximizacao.height-original ).
    end.
    if tt_maximizacao.log-posiciona-col = yes then do:
        assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
    end.
    if tt_maximizacao.tipo-widget = 'button'
    and tt_maximizacao.log-button-right = yes then do:
        assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
    end.
end.

end. /* ON WINDOW-MAXIMIZED OF wh_w_program */
&endif
&if '{&emsbas_version}' >= '5.06' &then
ON WINDOW-RESTORED OF wh_w_program
DO:
def var v_whd_widget as widget-handle no-undo.

for each tt_maximizacao:
    assign v_whd_widget = tt_maximizacao.hdl-widget.

    if can-query(v_whd_widget,'row') then
        assign v_whd_widget:row    = tt_maximizacao.row-original    no-error.

    if can-query(v_whd_widget,'col') then
        assign v_whd_widget:col    = tt_maximizacao.col-original    no-error.

    if can-query(v_whd_widget,'width') then
        assign v_whd_widget:width  = tt_maximizacao.width-original  no-error.

    if can-query(v_whd_widget,'height') then
        assign v_whd_widget:height = tt_maximizacao.height-original no-error.
end.

end. /* ON WINDOW-RESTORED OF wh_w_program */
&endif

/*********************** User Interface Trigger Begin ***********************/


ON START-SEARCH OF br_tit_inadimp_abert IN FRAME f_bas_10_tit_inadimp_abert
DO:

    define variable v_hdl_coluna as widget-handle no-undo.

    assign v_hdl_coluna = br_tit_inadimp_abert:current-column.

    if v_des_col_ord_browse[1] = v_hdl_coluna:name then
        assign v_log_col_ord_browse_ascend[1] = not v_log_col_ord_browse_ascend[1].
    else
        assign v_log_col_ord_browse_ascend[1] = yes.

    if v_hdl_coluna:name = 'tta_cdn_cliente' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_cliente.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_cliente desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_empresa' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_empresa.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_empresa desc.        
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_estab' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_estab.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_estab desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_espec_docto' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_espec_docto.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_espec_docto desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_ser_docto' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_ser_docto.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_ser_docto desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_tit_acr' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_tit_acr.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_tit_acr desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_parcela' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_parcela.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_parcela desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_dat_vencto_tit_acr' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_vencto_tit_acr.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_vencto_tit_acr desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_val_sdo_tit_acr' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_val_sdo_tit_acr.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_val_sdo_tit_acr DESC.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_val_origin_tit_acr' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_val_origin_tit_acr.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_val_origin_tit_acr desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_usuario' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_usuario.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_usuario desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_dat_agenda' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_agenda.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_agenda desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_grp_clien' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_grp_clien.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_grp_clien desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cdn_clien_matriz' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_clien_matriz.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_clien_matriz desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cdn_repres' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_repres.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cdn_repres desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_portador' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_portador.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_portador desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_cod_cart_bcia' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_cart_bcia.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_cod_cart_bcia desc.
        end.
    end.
    else if v_hdl_coluna:name = 'tta_dat_emis_docto' then do:
        if v_log_col_ord_browse_ascend[1] then do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_emis_docto.
        end.
        else do:
            open query qr_tit_inadimp_abert
                for each tt_tit_inadimp_abert by tt_tit_inadimp_abert.tta_dat_emis_docto desc.
        end.
    end.

    assign v_des_col_ord_browse[1] = v_hdl_coluna:name.

END. /* ON START-SEARCH OF br_tit_inadimp_abert IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_atz2 IN FRAME f_bas_10_tit_inadimp_abert
DO:

    run pi_gera_tt_tit_inadimp_abert /*pi_gera_tt_tit_inadimp_abert*/.
    assign bt_atz2:sensitive in frame f_bas_10_tit_inadimp_abert = no.
END. /* ON CHOOSE OF bt_atz2 IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_det1 IN FRAME f_bas_10_tit_inadimp_abert
DO:

    if  avail tt_tit_inadimp_abert then do:
        find first tit_acr no-lock
            where tit_acr.cod_estab       = tt_tit_inadimp_abert.tta_cod_estab
            and   tit_acr.cod_espec_docto = tt_tit_inadimp_abert.tta_cod_espec_docto
            and   tit_acr.cod_ser_docto   = tt_tit_inadimp_abert.tta_cod_ser_docto
            and   tit_acr.cod_tit_acr     = tt_tit_inadimp_abert.tta_cod_tit_acr
            and   tit_acr.cod_parcela     = tt_tit_inadimp_abert.tta_cod_parcela no-error.
        assign v_rec_tit_acr = recid(tit_acr).
        run prgfin/acr/acr212aa.p /*prg_bas_tit_acr_fin*/.
    end.
END. /* ON CHOOSE OF bt_det1 IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_exi IN FRAME f_bas_10_tit_inadimp_abert
DO:

    run pi_close_program /*pi_close_program*/.
END. /* ON CHOOSE OF bt_exi IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_tit_inadimp_abert
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_planilha_excel IN FRAME f_bas_10_tit_inadimp_abert
DO:

    run pi_gera_tit_inadimp_excel /*pi_gera_tit_inadimp_excel*/.
END. /* ON CHOOSE OF bt_planilha_excel IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_ran2 IN FRAME f_bas_10_tit_inadimp_abert
DO:

    run pi_tit_inadimp_abert_faixa /*pi_tit_inadimp_abert_faixa*/.
END. /* ON CHOOSE OF bt_ran2 IN FRAME f_bas_10_tit_inadimp_abert */

ON CHOOSE OF bt_can IN FRAME f_ran_01_tit_inadimp_abert_faixa
DO:


END. /* ON CHOOSE OF bt_can IN FRAME f_ran_01_tit_inadimp_abert_faixa */

ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_tit_inadimp_abert_faixa
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_tit_inadimp_abert_faixa */

ON CHOOSE OF bt_todos_img IN FRAME f_ran_01_tit_inadimp_abert_faixa
DO:

    assign input frame f_ran_01_tit_inadimp_abert_faixa v_des_estab_select.
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
        run prgint/utb/utb071za.p (Input "ivc" /*l_ivc*/ ) /* prg_fnc_estabelecimento_selec_espec*/.
    display v_des_estab_select with frame f_ran_01_tit_inadimp_abert_faixa.

END. /* ON CHOOSE OF bt_todos_img IN FRAME f_ran_01_tit_inadimp_abert_faixa */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_414372 IN FRAME f_ran_01_tit_inadimp_abert_faixa
OR F5 OF v_cdn_cliente_fim IN FRAME f_ran_01_tit_inadimp_abert_faixa DO:

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
        assign v_cdn_cliente_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_fim in frame f_ran_01_tit_inadimp_abert_faixa.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_414372 IN FRAME f_ran_01_tit_inadimp_abert_faixa */

ON  CHOOSE OF bt_zoo_414373 IN FRAME f_ran_01_tit_inadimp_abert_faixa
OR F5 OF v_cdn_cliente_ini IN FRAME f_ran_01_tit_inadimp_abert_faixa DO:

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
        assign v_cdn_cliente_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_ini in frame f_ran_01_tit_inadimp_abert_faixa.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_414373 IN FRAME f_ran_01_tit_inadimp_abert_faixa */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON ENDKEY OF FRAME f_bas_10_tit_inadimp_abert
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_inadimp).    
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
        assign v_rec_table_epc = recid(tit_inadimp).    
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
        assign v_rec_table_epc = recid(tit_inadimp).    
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

END. /* ON ENDKEY OF FRAME f_bas_10_tit_inadimp_abert */

ON END-ERROR OF FRAME f_bas_10_tit_inadimp_abert
DO:

    run pi_close_program /*pi_close_program*/.
END. /* ON END-ERROR OF FRAME f_bas_10_tit_inadimp_abert */

ON HELP OF FRAME f_bas_10_tit_inadimp_abert ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_bas_10_tit_inadimp_abert */

ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_tit_inadimp_abert ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_window */
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

        assign v_nom_title_aux       = current-window:title
               current-window:title  = self:help.
    end /* if */.

    /* End_Include: i_right_mouse_down_window */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_tit_inadimp_abert */

ON RIGHT-MOUSE-UP OF FRAME f_bas_10_tit_inadimp_abert ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_window */
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

        assign current-window:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_window */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_bas_10_tit_inadimp_abert */

ON HELP OF FRAME f_ran_01_tit_inadimp_abert_faixa ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_ran_01_tit_inadimp_abert_faixa */

ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_tit_inadimp_abert_faixa ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_tit_inadimp_abert_faixa */

ON RIGHT-MOUSE-UP OF FRAME f_ran_01_tit_inadimp_abert_faixa ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_ran_01_tit_inadimp_abert_faixa */

ON WINDOW-CLOSE OF FRAME f_ran_01_tit_inadimp_abert_faixa
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_ran_01_tit_inadimp_abert_faixa */


/***************************** Frame Trigger End ****************************/

/*************************** Window Trigger Begin ***************************/

IF session:window-system <> "TTY" THEN
DO:

ON ENTRY OF wh_w_program
DO:
&if '{&emsbas_version}' >= '5.06' &then
    def var v_whd_field_group   as widget-handle no-undo.
    def var v_whd_widget        as widget-handle no-undo.
    def buffer b_tt_maximizacao for tt_maximizacao.
    find first tt_maximizacao no-error.
    if not avail tt_maximizacao then do:
        assign v_whd_field_group = frame f_bas_10_tit_inadimp_abert:first-child.
        repeat while valid-handle(v_whd_field_group):
            assign v_whd_widget = v_whd_field_group:first-child.
            repeat while valid-handle(v_whd_widget):
                create tt_maximizacao.
                if can-query(v_whd_widget,'handle') then
                    assign tt_maximizacao.hdl-widget            = v_whd_widget:handle no-error.
                if can-query(v_whd_widget,'type') then
                    assign tt_maximizacao.tipo-widget           = v_whd_widget:type no-error.
                if can-query(v_whd_widget,'row') then
                    assign tt_maximizacao.row-original          = v_whd_widget:row no-error.
                if can-query(v_whd_widget,'col') then
                    assign tt_maximizacao.col-original          = v_whd_widget:col no-error.
                if can-query(v_whd_widget,'width') then
                    assign tt_maximizacao.width-original        = v_whd_widget:width no-error.
                if can-query(v_whd_widget,'height') then
                    assign tt_maximizacao.height-original       = v_whd_widget:height no-error.
                assign tt_maximizacao.frame-width-original   = frame f_bas_10_tit_inadimp_abert:width.
                assign tt_maximizacao.frame-height-original  = frame f_bas_10_tit_inadimp_abert:height.
                assign tt_maximizacao.window-width-original  = wh_w_program:width.
                assign tt_maximizacao.window-height-original = wh_w_program:height.
                assign tt_maximizacao.log-posiciona-row  = no.
                assign tt_maximizacao.log-posiciona-col  = no.
                assign tt_maximizacao.log-calcula-width  = no.
                assign tt_maximizacao.log-calcula-height = no.
                assign tt_maximizacao.log-button-right   = no.
                if can-query(v_whd_widget,'flat-button') then do:
                    if v_whd_widget:flat-button = yes then do:
                        assign tt_maximizacao.log-posiciona-col  = no.
                        if v_whd_widget:name = 'bt_exi' or
                           v_whd_widget:name = 'bt_hel1' then do:
                            assign tt_maximizacao.log-button-right   = yes.
                        end.
                    end.
                end.
                if can-query(v_whd_widget,'type') then do:
                    if v_whd_widget:type = 'browse' then 
                        assign tt_maximizacao.log-calcula-height = yes.
                end.
                assign v_whd_widget = v_whd_widget:next-sibling.
            end.
            assign v_whd_field_group = v_whd_field_group:next-sibling.
        end.
    end.
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'browse'
          by tt_maximizacao.row-original:
        find first b_tt_maximizacao
             where b_tt_maximizacao.tipo-widget = 'browse'
               and b_tt_maximizacao.hdl-widget = tt_maximizacao.hdl-widget
            no-error.
        if avail b_tt_maximizacao then do:
            leave.
        end.
    end.
    if avail b_tt_maximizacao then do:
        for each tt_maximizacao
            where tt_maximizacao.row-original >=  b_tt_maximizacao.row-original + 
                                                  b_tt_maximizacao.height-original - 1:
            assign tt_maximizacao.log-calcula-height = no.
            assign tt_maximizacao.log-posiciona-row  = yes.
            assign tt_maximizacao.log-posiciona-col  = no.
        end.
    end.
    for each b_tt_maximizacao
        where b_tt_maximizacao.tipo-widget = 'browse':
        assign b_tt_maximizacao.log-calcula-width = yes.
        for each tt_maximizacao
            where tt_maximizacao.row-original + tt_maximizacao.height-original >= 
                  b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.tipo-widget = 'rectangle'
              and b_tt_maximizacao.log-calcula-height = yes:
            assign tt_maximizacao.log-calcula-height = yes.
        end.
        for each tt_maximizacao
           where tt_maximizacao.tipo-widget <> 'browse'
             and not (    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                      and tt_maximizacao.row-original + tt_maximizacao.height-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original
                      and tt_maximizacao.col-original >= b_tt_maximizacao.col-original
                      and tt_maximizacao.col-original + tt_maximizacao.width-original < b_tt_maximizacao.col-original + b_tt_maximizacao.width-original )
             and ((    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original - 0.5 )
              or (     tt_maximizacao.row-original < b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original + tt_maximizacao.height-original > b_tt_maximizacao.row-original )):
            assign tt_maximizacao.log-posiciona-col = yes.
        end.
    end. 
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'rectangle':
        if tt_maximizacao.frame-width-original - tt_maximizacao.width-original < 4 then do:
            assign tt_maximizacao.log-posiciona-col  = no.
            assign tt_maximizacao.log-calcula-width  = yes.
        end.
    end.
    assign wh_w_program:max-width-chars = 300 
           wh_w_program:max-height-chars = 300.

&endif

    if  valid-handle (wh_w_program)
    then do:
        assign current-window = wh_w_program:handle.
    end /* if */.
END. /* ON ENTRY OF wh_w_program */

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_tit_inadimp_abert.

END. /* ON WINDOW-CLOSE OF wh_w_program */

END.

/**************************** Window Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10
DO:

    apply "choose" to bt_exi in frame f_bas_10_tit_inadimp_abert.

END. /* ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10 */

ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10
DO:

    apply "choose" to bt_hel1 in frame f_bas_10_tit_inadimp_abert.

END. /* ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10 */

ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10
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


    /* Begin_Include: i_about_call */
    assign v_nom_prog     = substring(current-window:title, 1, max(1, length(current-window:title) - 10))
                          + chr(10)
                          + "esivc002":U
           v_nom_prog_ext = "esp/ivc/esivc002.p":U
           v_cod_release  = trim(" 5.00.00.000":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
    /* End_Include: i_about_call */

END. /* ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10 */


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


/* End_Include: i_version_extract */

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
    run prgtec/men/men901za.py (Input 'bas_tit_inadimp_abert') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_tit_inadimp_abert')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_tit_inadimp_abert')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

/* End_Include: i_log_exec_prog_dtsul_ini */


/* redefiniá‰es do menu */
assign sub-menu  mi_table:label in menu m_10 = "Arquivo" /*l_file*/ .

/* redefiniá‰es da window e frame */

/* Begin_Include: i_std_window */
/* tratamento do t°tulo, menu, vers∆o e dimens‰es */
assign wh_w_program:title         = frame f_bas_10_tit_inadimp_abert:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_10_tit_inadimp_abert:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_tit_inadimp_abert:width-chars
       wh_w_program:height-chars  = frame f_bas_10_tit_inadimp_abert:height-chars - 0.85
       frame f_bas_10_tit_inadimp_abert:row         = 1
       frame f_bas_10_tit_inadimp_abert:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

find first modul_dtsul
    where modul_dtsul.cod_modul_dtsul = v_cod_modul_dtsul_corren
    no-lock no-error.
if  avail modul_dtsul
then do:
    if  wh_w_program:load-icon (modul_dtsul.img_icone) = yes
    then do:
        /* Utiliza como °cone sempre o °cone do m¢dulo corrente */
    end /* if */.
end /* if */.

/* End_Include: i_std_window */
{include/title5.i wh_w_program}


run pi_frame_settings (Input frame f_bas_10_tit_inadimp_abert:handle) /*pi_frame_settings*/.


/* Begin_Include: ix_p02_bas_tit_inadimp_abert */

assign v_cdn_clien_matriz_fim   = 999999999
       v_cdn_clien_matriz_ini   = 0
       v_cdn_cliente_fim        = 999999999
       v_cdn_cliente_ini        = 0
       v_cdn_repres_fim         = 999999
       v_cdn_repres_ini         = 0
       v_cod_cart_bcia_fim      = "ZZZ":U
       v_cod_cart_bcia_ini      = "":U
       v_cod_espec_docto_fim    = "ZZZ":U
       v_cod_espec_docto_ini    = "":U
       v_cod_grp_clien_fim      = "ZZZZ":U
       v_cod_grp_clien_ini      = "":U
       v_cod_portador_fim       = "ZZZZZ":U
       v_cod_portador_ini       = "":U
       v_cod_usuar_ate          = "ZZZZZZZZZZZZ":U
       v_cod_usuario_ini        = "":U
       v_dat_vencto_tit_acr_fim = 12/31/9999
       v_dat_vencto_tit_acr_ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
/* End_Include: ix_p02_bas_tit_inadimp_abert */


pause 0 before-hide.

view frame f_bas_10_tit_inadimp_abert.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(tit_inadimp).    
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
    assign v_rec_table_epc = recid(tit_inadimp).    
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
    assign v_rec_table_epc = recid(tit_inadimp).    
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


/* ix_p05_bas_tit_inadimp_abert */
enable bt_exi
       bt_hel1
       bt_ran2
       bt_det1
       br_tit_inadimp_abert
       with frame f_bas_10_tit_inadimp_abert.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(tit_inadimp).    
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
    assign v_rec_table_epc = recid(tit_inadimp).    
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
    assign v_rec_table_epc = recid(tit_inadimp).    
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


main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    /* Begin_Include: ix_p10_bas_tit_inadimp_abert */
    ASSIGN br_tit_inadimp_abert:ALLOW-COLUMN-SEARCHING IN FRAME f_bas_10_tit_inadimp_abert = TRUE.
    /* End_Include: ix_p10_bas_tit_inadimp_abert */

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_tit_inadimp_abert.
    end /* if */.
end /* do main_block */.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_close_program
** Descricao.............: pi_close_program
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: vanei
** Alterado em...........: 14/05/1998 15:13:54
*****************************************************************************/
PROCEDURE pi_close_program:


        if  avail tit_inadimp
        then do:
            assign v_rec_tit_inadimp = recid(tit_inadimp).
        end /* if */.
        else do:
            assign v_rec_tit_inadimp = ?.
        end /* else */.



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


    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end /* if */.
END PROCEDURE. /* pi_close_program */
/*****************************************************************************
** Procedure Interna.....: pi_frame_settings
** Descricao.............: pi_frame_settings
** Criado por............: Gilsinei
** Criado em.............: 27/10/1995 08:24:12
** Alterado por..........: Gilsinei
** Alterado em...........: 27/10/1995 08:49:51
*****************************************************************************/
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
/*****************************************************************************
** Procedure Interna.....: pi_tit_inadimp_abert_faixa
** Descricao.............: pi_tit_inadimp_abert_faixa
** Criado por............: fut12234
** Criado em.............: 25/04/2008 09:39:58
** Alterado por..........: fut12234
** Alterado em...........: 29/04/2008 16:25:02
*****************************************************************************/
PROCEDURE pi_tit_inadimp_abert_faixa:

    param_block:
    repeat on error undo param_block, retry param_block
                     on endkey undo param_block, leave param_block
                     on stop undo param_block, retry param_block
                     with frame f_ran_01_tit_inadimp_abert_faixa:
        if not retry then do:
            view frame f_ran_01_tit_inadimp_abert_faixa.

            enable bt_can
                   bt_hel2
                   bt_ok
                   bt_todos_img
                   v_cdn_clien_matriz_fim
                   v_cdn_clien_matriz_ini
                   v_cdn_cliente_fim
                   v_cdn_cliente_ini
                   v_cdn_repres_fim
                   v_cdn_repres_ini
                   v_cod_cart_bcia_fim
                   v_cod_cart_bcia_ini
                   v_cod_espec_docto_fim
                   v_cod_espec_docto_ini
                   v_cod_grp_clien_fim
                   v_cod_grp_clien_ini
                   v_cod_portador_fim
                   v_cod_portador_ini
                   v_cod_usuar_ate
                   v_cod_usuario_ini
                   v_dat_vencto_tit_acr_fim
                   v_dat_vencto_tit_acr_ini
                   with frame f_ran_01_tit_inadimp_abert_faixa.

            display bt_can
                    bt_hel2
                    bt_ok
                    bt_todos_img
                    v_cdn_cliente_fim
                    v_cdn_cliente_ini
                    v_cdn_clien_matriz_fim
                    v_cdn_clien_matriz_ini
                    v_cdn_repres_fim
                    v_cdn_repres_ini
                    v_cod_cart_bcia_fim
                    v_cod_cart_bcia_ini
                    v_cod_espec_docto_fim
                    v_cod_espec_docto_ini
                    v_cod_grp_clien_fim
                    v_cod_grp_clien_ini
                    v_cod_portador_fim
                    v_cod_portador_ini
                    v_cod_usuario_ini
                    v_cod_usuar_ate
                    v_dat_vencto_tit_acr_fim
                    v_dat_vencto_tit_acr_ini
                    v_des_estab_select
                    with frame f_ran_01_tit_inadimp_abert_faixa.
        end.

        wait-for go of frame f_ran_01_tit_inadimp_abert_faixa.

        if  v_des_estab_select = "" /*l_*/  then do:
            /* Estabelecimento deve ser informado ! */
            run pi_messages (input "show",
                             input 12,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_12*/.
            undo param_block, retry param_block.
        end.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_cliente_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_cliente_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Cliente" /*l_cliente*/)) /*msg_3257*/.
            apply 'entry' to v_cdn_cliente_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cod_espec_docto_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cod_espec_docto_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "EspÇcie" /*l_especie*/)) /*msg_3257*/.
            apply 'entry' to v_cod_espec_docto_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data de Vencimento" /*l_data_de_vencimento*/)) /*msg_3257*/.
            apply 'entry' to v_dat_vencto_tit_acr_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cod_cart_bcia_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cod_cart_bcia_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Carteira Banc†ria" /*l_cart_bcia*/)) /*msg_3257*/.
            apply 'entry' to v_cod_cart_bcia_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_clien_matriz_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_clien_matriz_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Matriz do Cliente" /*l_matriz_cliente*/)) /*msg_3257*/.
            apply 'entry' to v_cdn_clien_matriz_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_repres_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_repres_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Representante" /*l_representante*/)) /*msg_3257*/.
            apply 'entry' to v_cdn_repres_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cod_grp_clien_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cod_grp_clien_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Grupo Cliente" /*l_grupo_cliente*/)) /*msg_3257*/.
            apply 'entry' to v_cod_grp_clien_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cod_portador_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cod_portador_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Portador" /*l_portador*/)) /*msg_3257*/.
            apply 'entry' to v_cod_portador_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_cod_usuario_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_cod_usuar_ate
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Usu†rio" /*l_usuario*/)) /*msg_3257*/.
            apply 'entry' to v_cod_usuario_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_ini > input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_fim
        then do:
            /* &1 Final menor que &1 Inicial ! */
            run pi_messages (input "show",
                             input 3257,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Data Vencimento" /*l_data_vencimento*/)) /*msg_3257*/.
            apply 'entry' to v_dat_vencto_tit_acr_ini in frame f_ran_01_tit_inadimp_abert_faixa.
            undo param_block, retry param_block.
        end /* if */.

        if  v_des_estab_select <> v_des_estab_select_aux
        or  trim(string(v_cdn_clien_matriz_fim,'>>>,>>>,>>9')) <> v_cdn_clien_matriz_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  trim(string(v_cdn_clien_matriz_ini,'>>>,>>>,>>9')) <> v_cdn_clien_matriz_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  trim(string(v_cdn_cliente_fim,'>>>,>>>,>>9')) <> v_cdn_cliente_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  trim(string(v_cdn_cliente_ini,'>>>,>>>,>>9')) <> v_cdn_cliente_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  trim(string(v_cdn_repres_fim,'>>>,>>9')) <> v_cdn_repres_fim :screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  trim(string(v_cdn_repres_ini,'>>>,>>9')) <> v_cdn_repres_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_cart_bcia_fim <> v_cod_cart_bcia_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_cart_bcia_ini <> v_cod_cart_bcia_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_espec_docto_fim <> v_cod_espec_docto_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_espec_docto_ini <> v_cod_espec_docto_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_grp_clien_fim <> v_cod_grp_clien_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_grp_clien_ini <> v_cod_grp_clien_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_portador_fim <> v_cod_portador_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_portador_ini <> v_cod_portador_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_usuar_ate <> v_cod_usuar_ate:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  v_cod_usuario_ini <> v_cod_usuario_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  string(v_dat_vencto_tit_acr_fim,'99/99/9999') <> v_dat_vencto_tit_acr_fim:screen-value in frame f_ran_01_tit_inadimp_abert_faixa
        or  string(v_dat_vencto_tit_acr_ini,'99/99/9999') <> v_dat_vencto_tit_acr_ini:screen-value in frame f_ran_01_tit_inadimp_abert_faixa then
            assign bt_atz2:sensitive in frame f_bas_10_tit_inadimp_abert = yes.
        assign input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_clien_matriz_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_clien_matriz_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_cliente_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_cliente_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_repres_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cdn_repres_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_cart_bcia_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_cart_bcia_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_espec_docto_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_espec_docto_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_grp_clien_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_grp_clien_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_portador_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_portador_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_usuar_ate
               input frame f_ran_01_tit_inadimp_abert_faixa v_cod_usuario_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_fim
               input frame f_ran_01_tit_inadimp_abert_faixa v_dat_vencto_tit_acr_ini
               input frame f_ran_01_tit_inadimp_abert_faixa v_des_estab_select.
        assign v_des_estab_select_aux = v_des_estab_select.

        leave param_block.
    end.
    hide frame f_ran_01_tit_inadimp_abert_faixa.

END PROCEDURE. /* pi_tit_inadimp_abert_faixa */
/*****************************************************************************
** Procedure Interna.....: pi_gera_tt_tit_inadimp_abert
** Descricao.............: pi_gera_tt_tit_inadimp_abert
** Criado por............: fut12234
** Criado em.............: 25/04/2008 10:24:39
** Alterado por..........: fut12234
** Alterado em...........: 02/05/2008 09:20:39
*****************************************************************************/
PROCEDURE pi_gera_tt_tit_inadimp_abert:

    /************************* Variable Definition Begin ************************/

    def var v_dat_vencto_corren              as date            no-undo. /*local*/
    def var v_num_cont_aux                   as integer         no-undo. /*local*/
    def var v_num_reg                        as integer         no-undo. /*local*/
    def var v_val_tot_tit                    as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    empty temp-table tt_tit_inadimp_abert.
    assign v_num_reg     = 0
           v_val_tot_tit = 0.

    des_estab_block:
    do v_num_cont_aux = 1 to num-entries(v_des_estab_select):
        estab_block:
        for each estabelecimento fields(cod_estab) no-lock
            where estabelecimento.cod_estab  = entry(v_num_cont_aux, v_des_estab_select):
            if  not can-find(first tit_inadimp 
                             where tit_inadimp.cod_estab = estabelecimento.cod_estab) 
                then next estab_block.


            for_tit_block:    
            FOR EACH tit_inadimp NO-LOCK
                WHERE tit_inadimp.cod_estab = estabelecimento.cod_estab:

                IF tit_inadimp.dat_vencto_tit_acr < v_dat_vencto_tit_acr_ini
                OR tit_inadimp.dat_vencto_tit_acr > v_dat_vencto_tit_acr_fim
                OR tit_inadimp.cdn_cliente        < v_cdn_cliente_ini
                OR tit_inadimp.cdn_cliente        > v_cdn_cliente_fim
                OR tit_inadimp.cod_cart_bcia      < v_cod_cart_bcia_ini
                OR tit_inadimp.cod_cart_bcia      > v_cod_cart_bcia_fim
                OR tit_inadimp.cod_espec_docto    < v_cod_espec_docto_ini
                OR tit_inadimp.cod_espec_docto    > v_cod_espec_docto_fim
                OR tit_inadimp.cod_portador       < v_cod_portador_ini
                OR tit_inadimp.cod_portador       > v_cod_portador_fim
                OR tit_inadimp.cdn_clien_matriz   < v_cdn_clien_matriz_ini
                OR tit_inadimp.cdn_clien_matriz   > v_cdn_clien_matriz_fim
                OR tit_inadimp.cdn_repres         < v_cdn_repres_ini
                OR tit_inadimp.cdn_repres         > v_cdn_repres_fim
                   THEN NEXT for_tit_block.

                FIND FIRST item_agenda_inadimp NO-LOCK USE-INDEX itmgndnd_titulo
                     WHERE item_agenda_inadimp.cod_estab       = tit_inadimp.cod_estab
                       AND item_agenda_inadimp.cod_espec_docto = tit_inadimp.cod_espec_docto
                       AND item_agenda_inadimp.cod_ser_docto   = tit_inadimp.cod_ser_docto
                       AND item_agenda_inadimp.cod_tit_acr     = tit_inadimp.cod_tit_acr
                       AND item_agenda_inadimp.cod_parcela     = tit_inadimp.cod_parcela NO-ERROR.
                IF NOT AVAIL item_agenda_inadimp
                OR item_agenda_inadimp.ind_sit_item_agenda_inadimp = "Liquidado"
                OR item_agenda_inadimp.cod_usuario < v_cod_usuario_ini
                OR item_agenda_inadimp.cod_usuario > v_cod_usuar_ate 
                   THEN NEXT for_tit_block.

                find first tit_acr no-lock
                    where tit_acr.cod_estab       = tit_inadimp.cod_estab
                    and   tit_acr.cod_espec_docto = tit_inadimp.cod_espec_docto
                    and   tit_acr.cod_ser_docto   = tit_inadimp.cod_ser_docto
                    and   tit_acr.cod_tit_acr     = tit_inadimp.cod_tit_acr
                    and   tit_acr.cod_parcela     = tit_inadimp.cod_parcela no-error.
                if  not avail tit_acr 
                or  tit_acr.val_sdo_tit_acr = 0
                or  tit_acr.log_tit_acr_estordo then
                    next for_tit_block.

                find first emscad.cliente no-lock
                    where cliente.cod_empresa = tit_inadimp.cod_empresa
                    and   cliente.cdn_cliente = tit_inadimp.cdn_cliente no-error.
                if  cliente.cod_grp_clien < v_cod_grp_clien_ini
                or  cliente.cod_grp_clien > v_cod_grp_clien_fim then
                    next for_tit_block.

                create tt_tit_inadimp_abert.
                assign tt_tit_inadimp_abert.tta_cod_empresa        = tit_inadimp.cod_empresa
                       tt_tit_inadimp_abert.tta_cod_estab          = tit_inadimp.cod_estab
                       tt_tit_inadimp_abert.tta_cod_espec_docto    = tit_inadimp.cod_espec_docto
                       tt_tit_inadimp_abert.tta_cod_ser_docto      = tit_inadimp.cod_ser_docto
                       tt_tit_inadimp_abert.tta_cod_tit_acr        = tit_inadimp.cod_tit_acr
                       tt_tit_inadimp_abert.tta_cod_parcela        = tit_inadimp.cod_parcela
                       tt_tit_inadimp_abert.tta_cdn_cliente        = tit_inadimp.cdn_cliente
                       tt_tit_inadimp_abert.tta_cod_grp_clien      = cliente.cod_grp_clien
                       tt_tit_inadimp_abert.tta_cdn_clien_matriz   = tit_inadimp.cdn_clien_matriz
                       tt_tit_inadimp_abert.tta_cdn_repres         = tit_inadimp.cdn_repres
                       tt_tit_inadimp_abert.tta_cod_portador       = tit_inadimp.cod_portador
                       tt_tit_inadimp_abert.tta_cod_cart_bcia      = tit_inadimp.cod_cart_bcia
                       tt_tit_inadimp_abert.tta_dat_emis_docto     = tit_inadimp.dat_emis_docto
                       tt_tit_inadimp_abert.tta_dat_vencto_tit_acr = tit_inadimp.dat_vencto_tit_acr
                       tt_tit_inadimp_abert.tta_val_origin_tit_acr = tit_inadimp.val_origin_tit_acr
                       tt_tit_inadimp_abert.tta_val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                       tt_tit_inadimp_abert.tta_dat_agenda         = if  tit_inadimp.dat_agenda = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF then item_agenda_inadimp.dat_agenda else tit_inadimp.dat_agenda
                       tt_tit_inadimp_abert.tta_cod_usuario        = item_agenda_inadimp.cod_usuario
                       v_num_reg                                   = v_num_reg + 1
                       v_val_tot_tit                               = v_val_tot_tit + tt_tit_inadimp_abert.tta_val_sdo_tit_acr
                       tt_tit_inadimp_abert.tta_ind_sit_item_agenda_inadimp = item_agenda_inadimp.ind_sit_item_agenda_inadimp.

                IF tt_tit_inadimp_abert.tta_dat_agenda = 01/01/0001 
                   THEN ASSIGN tt_tit_inadimp_abert.tta_dat_agenda = TODAY.

            end.
        end.
    end.
    assign v_num_tot_tit = v_num_reg
           v_val_tot_2 = v_val_tot_tit.

    display v_num_tot_tit
            v_val_tot_2
            with frame f_bas_10_tit_inadimp_abert.
    if  temp-table tt_tit_inadimp_abert:has-records then
        assign bt_planilha_excel:sensitive in frame f_bas_10_tit_inadimp_abert = yes.
    else
        assign bt_planilha_excel:sensitive in frame f_bas_10_tit_inadimp_abert = no.

    open query qr_tit_inadimp_abert
        for each tt_tit_inadimp_abert.
END PROCEDURE. /* pi_gera_tt_tit_inadimp_abert */
/*****************************************************************************
** Procedure Interna.....: pi_gera_tit_inadimp_excel
** Descricao.............: pi_gera_tit_inadimp_excel
** Criado por............: fut12234
** Criado em.............: 25/04/2008 16:18:01
** Alterado por..........: fut12234
** Alterado em...........: 30/04/2008 12:12:53
*****************************************************************************/
PROCEDURE pi_gera_tit_inadimp_excel:

    /************************* Variable Definition Begin ************************/

    def var v_cod_show_report_program
        as character
        format "x(40)":U
        view-as editor max-chars 250 no-word-wrap
        size 40 by 1
        bgcolor 15 font 2
        label "Programa"
        column-label "Programa"
        no-undo.
    def var v_cod_worksheet_program
        as character
        format "x(40)":U
        view-as editor max-chars 250 no-word-wrap
        size 40 by 1
        bgcolor 15 font 2
        label "Programa"
        no-undo.
    def var v_cod_get_file                   as character       no-undo. /*local*/
    def var v_des_nom_arquivo                as character       no-undo. /*local*/
    def var v_log_pressed                    as logical         no-undo. /*local*/
    def var v_num_return                     as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    system-dialog get-file v_cod_get_file
        title "Salvar como..." /*l_salvar_como*/ 
        filters '*.csv' '*.csv'
        DEFAULT-EXTENSION '*.csv' 
        save-as
        update v_log_pressed.

    if  v_log_pressed then do:
        RUN CreateFileA (
                INPUT v_cod_get_file,
                INPUT 2031616, /* STANDARD_RIGHTS_ALL */
                INPUT 7,       /* FILE_SHARE_DELETE & FILE_SHARE_READ & FILE_SHARE_WRITE    */
                INPUT 0,       /* No Security attributes, use Default Security Descriptor */
                INPUT 2,       /* CREATE_ALWAYS       */
                INPUT 128,     /* FILE_ATTRIBUTE_NORMAL */
                INPUT 0,       /* No Existing File Template Used */
                OUTPUT v_num_return).
        if  v_num_return <> -1 then do:
            RUN CloseHandle (INPUT v_num_return, OUTPUT v_num_return).
            output to value(v_cod_get_file) convert target 'iso8859-1'.
                put "Empresa" /*l_empresa*/  ';' "Estabelecimento" /*l_estabelecimento*/  ';' "EspÇcie" /*l_especie*/  ';'
                    "SÇrie" /*l_serie*/  ';' "T°tulo" /*l_titulo*/  ';' "Parcela" /*l_parcela*/  ';'
                    "Cliente" /*l_cliente*/  ';' "GrupoCliente" /*l_grupocliente*/  ';' "Matriz" /*l_matriz*/  ';'
                    "Representante" /*l_representante*/  ';' "Portador" /*l_portador*/  ';' "Carteira Bcia" /*l_carteira_bcia*/  ';'
                    "Emiss∆o Documento" /*l_emissao_documento*/  ';' "Data Vencimento" /*l_data_vencimento*/  ';' "Valor Original" /*l_valor_original*/  ';'
                    "Valor Saldo" /*l_valor_saldo*/  ';' "Data Agenda" /*l_data_agenda*/  ';' "C¢digo Usu†rio" /*l_codigo_usuario*/ ';' "Situaá∆o" skip.
                for each tt_tit_inadimp_abert:
                    put unformatted 
                        tt_tit_inadimp_abert.tta_cod_empresa        ';'
                        tt_tit_inadimp_abert.tta_cod_estab          ';'
                        tt_tit_inadimp_abert.tta_cod_espec_docto    ';'
                        tt_tit_inadimp_abert.tta_cod_ser_docto      ';'
                        tt_tit_inadimp_abert.tta_cod_tit_acr        ';'
                        tt_tit_inadimp_abert.tta_cod_parcela        ';'
                        tt_tit_inadimp_abert.tta_cdn_cliente        ';'
                        tt_tit_inadimp_abert.tta_cod_grp_clien      ';'
                        tt_tit_inadimp_abert.tta_cdn_clien_matriz   ';'
                        tt_tit_inadimp_abert.tta_cdn_repres         ';'
                        tt_tit_inadimp_abert.tta_cod_portador       ';'
                        tt_tit_inadimp_abert.tta_cod_cart_bcia      ';' 
                        tt_tit_inadimp_abert.tta_dat_emis_docto     ';'
                        tt_tit_inadimp_abert.tta_dat_vencto_tit_acr ';'
                        tt_tit_inadimp_abert.tta_val_origin_tit_acr ';'
                        tt_tit_inadimp_abert.tta_val_sdo_tit_acr    ';'
                        tt_tit_inadimp_abert.tta_dat_agenda         ';'
                        tt_tit_inadimp_abert.tta_cod_usuario        ';'
                        tt_tit_inadimp_abert.tta_ind_sit_item_agenda_inadimp
                        skip.
                end.
            output close.

            get-key-value section 'EMS' key 'Worksheet-Program' value v_cod_worksheet_program.

            if  search(v_cod_worksheet_program) <> ? then
                os-command no-wait value(chr(34) + v_cod_worksheet_program + chr(34) + ' ' + v_cod_get_file).
            else do:
                /* T°tulos exportados para arquivo. */
                run pi_messages (input "show",
                                 input 19200,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                   v_cod_get_file)) /*msg_19200*/.
            end.
        end.
        else do:
            /* Arquivo .cvs j† esta em uso ! */
            run pi_messages (input "show",
                             input 19221,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               v_cod_get_file)) /*msg_19221*/.
            return "OK" /*l_ok*/ .
        end.    
    end.
    END.
    PROCEDURE CloseHandle EXTERNAL 'kernel32.dll':
        DEFINE INPUT PARAMETER hObject    AS LONG.
        DEFINE RETURN PARAMETER RetResult AS LONG.
    END.

    PROCEDURE CreateFileA EXTERNAL 'kernel32.dll':
        DEFINE INPUT PARAMETER  lpFileName               AS CHAR.
        DEFINE INPUT PARAMETER  dwDesiredAccess          AS LONG.
        DEFINE INPUT PARAMETER  dwShareMode              AS LONG.
        DEFINE INPUT PARAMETER  lpSecurityAttributes     AS LONG.
        DEFINE INPUT PARAMETER  dwCreationDisposition    AS LONG.
        DEFINE INPUT PARAMETER  dwFlagsAndAttributes     AS LONG.
        DEFINE INPUT PARAMETER  hTemplateFile            AS LONG.
        DEFINE RETURN PARAMETER ReturnValues             AS LONG.

END PROCEDURE. /* pi_gera_tit_inadimp_excel */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

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
/***********************  End of bas_tit_inadimp_abert **********************/
