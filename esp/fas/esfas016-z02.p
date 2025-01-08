/*****************************************************************************
** Programa: esp/fas/esfas016-z02.p
** Data: 08/09/2020
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.014":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.014[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

/*{include/i_fcldef.i}*/
define new global shared variable h_facelift as handle no-undo. 
if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.

define new global shared variable h-facelift as handle no-undo. 
if not valid-handle(h-facelift) then run prgtec/btb/btb901zo.py persistent set h-facelift no-error.

{include/i_trddef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i sea_bem_pat FAS}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=2":U.
/*************************************  *************************************/

&if "{&emsfin_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSFIN")) /*msg_5884*/.
&elseif "{&emsfin_version}" < "1.00" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "SEA_BEM_PAT","~~EMSFIN", "~~{~&emsfin_version}", "~~1.00")) /*msg_5009*/.
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
def var v_cod_dat_type
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
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def var v_cod_format
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
def var v_cod_initial
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
def var v_cod_release
    as character
    format "x(12)":U
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
def var v_dat_alter
    as date
    format "99/99/9999":U
    label "Data Alteraá∆o"
    column-label "Alteraá∆o"
    no-undo.
def var v_des_bem_pat_palavra
    as character
    format "x(40)":U
    label "ContÇm"
    no-undo.
def var v_log_bem_pat_alugdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Alugado"
    no-undo.
def var v_log_bem_pat_aquis
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Aquisiá∆o"
    no-undo.
def var v_log_bem_pat_bxado
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Consid. Bem baixado"
    no-undo.
def var v_log_bem_pat_desmembr
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Desmembramento"
    no-undo.
def var v_log_bem_pat_hipotdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Hipotecado"
    no-undo.
def var v_log_bem_pat_imobdo
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Imobilizado"
    no-undo.
def var v_log_bem_pat_migrac
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Migraá∆o"
    no-undo.
def var v_log_bem_pat_normal
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Normal"
    no-undo.
def var v_log_bem_pat_quebrado
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Quebrado"
    no-undo.
def var v_log_bem_pat_vendido
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Vendido"
    no-undo.
def var v_nom_attrib
    as character
    format "x(30)":U
    no-undo.
def var v_nom_prog
    as character
    format "x(8)":U
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
def var v_nom_prog_ext
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
def new global shared var v_rec_bem_pat
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

/************************** Query Definition Begin **************************/

def query qr_sea_bem_pat
    for bem_pat
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_sea_bem_pat query qr_sea_bem_pat display 
    bem_pat.cod_cta_pat
    width-chars 18.00
        column-label "Conta Pat"
    bem_pat.num_bem_pat
    width-chars 09.00
        column-label "Bem Pat"
    bem_pat.num_seq_bem_pat
    width-chars 05.00
        column-label "Seq"
    bem_pat.des_bem_pat
    width-chars 40.00
        column-label "Descriá∆o"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    bem_pat.cod_estab
    width-chars 03.00
        column-label "Est"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    bem_pat.cod_estab
    width-chars 05.00
        column-label "Est"
&ENDIF
    bem_pat.cb3_ident_visual
    width-chars 20.00
        column-label "N£mero Plaqueta"
    bem_pat.dat_aquis_bem_pat
    width-chars 10.00
        column-label "Dat Aquis"
    bem_pat.cod_grp_calc
    width-chars 09.57
        column-label "Grupo C†lculo"
    bem_pat.cod_localiz
    width-chars 12.00
        column-label "Localizaá∆o"
    bem_pat.cod_espec_bem
    width-chars 06.00
        column-label "EspÇcie"
    bem_pat.cod_marca
    width-chars 06.00
        column-label "Marca"
    bem_pat.cod_modelo
    width-chars 08.00
        column-label "Modelo"
    bem_pat.cod_licenc_uso
    width-chars 12.00
        column-label "Licen Uso"
    bem_pat.cod_especif_tec
    width-chars 15.57
        column-label "Especificaá∆o TÇcnica"
    bem_pat.cod_arrendador
    width-chars 07.43
        column-label "Arrendador"
    bem_pat.cod_contrat_leas
    width-chars 12.00
        column-label "Contr Leas"
    bem_pat.cod_estado_fisic_bem_pat
    width-chars 09.29
        column-label "Estado F°sico"
    bem_pat.cdn_fornecedor
    width-chars 09.00
        column-label "Fornecedor"
    getStrTrans(bem_pat.ind_sit_bem_pat, "FAS") @ bem_pat.ind_sit_bem_pat
    width-chars 12.00
        column-label "Situaá∆o Bem"
    bem_pat.dat_lim_utiliz
    width-chars 10.00
        column-label "Lim Utiliz"
    with no-box separators single 
         size 88.57 by 09.00
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
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_cxcl
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_add2
    label "Inclui"
    tooltip "Inclui"
    size 1 by 1.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_det2
    label "Detalhe"
    tooltip "Detalhe"
    size 1 by 1.
def button bt_fil
    label "Filtro"
    tooltip "Filtro"
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_mod2
    label "Modifica"
    tooltip "Modifica"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_ran
    label "Faixa"
    tooltip "Faixa"
    size 1 by 1.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_sea_bem_pat
    as character
    initial "Por Conta"
    view-as radio-set Horizontal
    radio-buttons "Por Conta", "Por Conta","Por Bem", "Por Bem","Por Descriá∆o", "Por Descriá∆o","Por Estab", "Por Estab","Por Plaqueta", "Por Plaqueta"
     /*l_por_conta*/ /*l_por_conta*/ /*l_por_bem*/ /*l_por_bem*/ /*l_por_descricao*/ /*l_por_descricao*/ /*l_por_estab*/ /*l_por_estab*/ /*l_por_plaqueta*/ /*l_por_plaqueta*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_fil_01_bem_pat
    rt_001
         at row 01.38 col 02.14
    " Situaá∆o " view-as text
         at row 01.08 col 04.14 bgcolor 8 
    rt_002
         at row 06.00 col 02.14
    " Origem " view-as text
         at row 05.70 col 04.14 bgcolor 8 
    rt_003
         at row 09.58 col 02.14
    " Palavra " view-as text
         at row 09.28 col 04.14 bgcolor 8 
    rt_cxcf
         at row 12.46 col 02.00 bgcolor 7 
    v_log_bem_pat_alugdo
         at row 02.17 col 08.00 label "Alugado"
         view-as toggle-box
    v_log_bem_pat_quebrado
         at row 02.17 col 30.00 label "Quebrado"
         view-as toggle-box
    v_log_bem_pat_hipotdo
         at row 03.17 col 08.00 label "Hipotecado"
         view-as toggle-box
    v_log_bem_pat_vendido
         at row 03.17 col 30.00 label "Vendido"
         view-as toggle-box
    v_log_bem_pat_normal
         at row 04.17 col 08.00 label "Normal"
         view-as toggle-box
    v_log_bem_pat_bxado
         at row 04.17 col 30.00 label "Consid. Bem baixado"
         view-as toggle-box
    v_log_bem_pat_aquis
         at row 06.71 col 08.00 label "Aquisiá∆o"
         view-as toggle-box
    v_log_bem_pat_imobdo
         at row 06.71 col 30.00 label "Imobilizado"
         view-as toggle-box
    v_log_bem_pat_desmembr
         at row 07.71 col 08.00 label "Desmembramento"
         view-as toggle-box
    v_log_bem_pat_migrac
         at row 07.71 col 30.00 label "Migraá∆o"
         view-as toggle-box
    v_des_bem_pat_palavra
         at row 10.13 col 09.86 colon-aligned label "ContÇm"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 12.67 col 03.00 font ?
         help "OK"
    bt_can
         at row 12.67 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 12.67 col 42.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 55.00 by 14.29 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Filtro Bem".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_fil_01_bem_pat = 10.00
           bt_can:height-chars  in frame f_fil_01_bem_pat = 01.00
           bt_hel2:width-chars  in frame f_fil_01_bem_pat = 10.00
           bt_hel2:height-chars in frame f_fil_01_bem_pat = 01.00
           bt_ok:width-chars    in frame f_fil_01_bem_pat = 10.00
           bt_ok:height-chars   in frame f_fil_01_bem_pat = 01.00
           rt_001:width-chars   in frame f_fil_01_bem_pat = 52.14
           rt_001:height-chars  in frame f_fil_01_bem_pat = 04.13
           rt_002:width-chars   in frame f_fil_01_bem_pat = 52.14
           rt_002:height-chars  in frame f_fil_01_bem_pat = 03.13
           rt_003:width-chars   in frame f_fil_01_bem_pat = 52.14
           rt_003:height-chars  in frame f_fil_01_bem_pat = 02.00
           rt_cxcf:width-chars  in frame f_fil_01_bem_pat = 51.57
           rt_cxcf:height-chars in frame f_fil_01_bem_pat = 01.42.
    /* set private-data for the help system */
    assign v_log_bem_pat_alugdo:private-data   in frame f_fil_01_bem_pat = "HLP=000022717":U
           v_log_bem_pat_quebrado:private-data in frame f_fil_01_bem_pat = "HLP=000022719":U
           v_log_bem_pat_hipotdo:private-data  in frame f_fil_01_bem_pat = "HLP=000022720":U
           v_log_bem_pat_vendido:private-data  in frame f_fil_01_bem_pat = "HLP=000022722":U
           v_log_bem_pat_normal:private-data   in frame f_fil_01_bem_pat = "HLP=000022723":U
           v_log_bem_pat_bxado:private-data    in frame f_fil_01_bem_pat = "HLP=000022724":U
           v_log_bem_pat_aquis:private-data    in frame f_fil_01_bem_pat = "HLP=000022725":U
           v_log_bem_pat_imobdo:private-data   in frame f_fil_01_bem_pat = "HLP=000011208":U
           v_log_bem_pat_desmembr:private-data in frame f_fil_01_bem_pat = "HLP=000022727":U
           v_log_bem_pat_migrac:private-data   in frame f_fil_01_bem_pat = "HLP=000022728":U
           v_des_bem_pat_palavra:private-data  in frame f_fil_01_bem_pat = "HLP=000022715":U
           bt_ok:private-data                  in frame f_fil_01_bem_pat = "HLP=000010721":U
           bt_can:private-data                 in frame f_fil_01_bem_pat = "HLP=000011050":U
           bt_hel2:private-data                in frame f_fil_01_bem_pat = "HLP=000011326":U
           frame f_fil_01_bem_pat:private-data                           = "HLP=000002989".

def frame f_sea_02_bem_pat
    rt_cxcf
         at row 13.25 col 02.00 bgcolor 7 
    rt_cxcl
         at row 01.00 col 01.00 bgcolor 15 
    rs_sea_bem_pat
         at row 01.21 col 03.00
         help "" no-label
    br_sea_bem_pat
         at row 02.25 col 01.00
    bt_add2
         at row 11.75 col 02.00 font ?
         help "Inclui"
    bt_mod2
         at row 11.75 col 14.00 font ?
         help "Modifica"
    bt_det2
         at row 11.75 col 26.00 font ?
         help "Detalhe"
    bt_ran
         at row 11.75 col 38.00 font ?
         help "Faixa"
    bt_fil
         at row 11.75 col 50.00 font ?
         help "Filtro"
    bt_ok
         at row 13.46 col 03.00 font ?
         help "OK"
    bt_can
         at row 13.46 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 13.46 col 77.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 15.08 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Pesquisa Bens".
    /* adjust size of objects in this frame */
    assign bt_add2:width-chars  in frame f_sea_02_bem_pat = 10.00
           bt_add2:height-chars in frame f_sea_02_bem_pat = 01.00
           bt_can:width-chars   in frame f_sea_02_bem_pat = 10.00
           bt_can:height-chars  in frame f_sea_02_bem_pat = 01.00
           bt_det2:width-chars  in frame f_sea_02_bem_pat = 10.00
           bt_det2:height-chars in frame f_sea_02_bem_pat = 01.00
           bt_fil:width-chars   in frame f_sea_02_bem_pat = 10.00
           bt_fil:height-chars  in frame f_sea_02_bem_pat = 01.00
           bt_hel2:width-chars  in frame f_sea_02_bem_pat = 10.00
           bt_hel2:height-chars in frame f_sea_02_bem_pat = 01.00
           bt_mod2:width-chars  in frame f_sea_02_bem_pat = 10.00
           bt_mod2:height-chars in frame f_sea_02_bem_pat = 01.00
           bt_ok:width-chars    in frame f_sea_02_bem_pat = 10.00
           bt_ok:height-chars   in frame f_sea_02_bem_pat = 01.00
           bt_ran:width-chars   in frame f_sea_02_bem_pat = 10.00
           bt_ran:height-chars  in frame f_sea_02_bem_pat = 01.00
           rt_cxcf:width-chars  in frame f_sea_02_bem_pat = 86.57
           rt_cxcf:height-chars in frame f_sea_02_bem_pat = 01.42
           rt_cxcl:width-chars  in frame f_sea_02_bem_pat = 88.43
           rt_cxcl:height-chars in frame f_sea_02_bem_pat = 01.25.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_sea_bem_pat:ALLOW-COLUMN-SEARCHING in frame f_sea_02_bem_pat = no
       br_sea_bem_pat:COLUMN-MOVABLE in frame f_sea_02_bem_pat = no.
end.
&endif
    /* set private-data for the help system */
    assign rs_sea_bem_pat:private-data in frame f_sea_02_bem_pat = "HLP=000002989":U
           br_sea_bem_pat:private-data in frame f_sea_02_bem_pat = "HLP=000002989":U
           bt_add2:private-data        in frame f_sea_02_bem_pat = "HLP=000010825":U
           bt_mod2:private-data        in frame f_sea_02_bem_pat = "HLP=000010827":U
           bt_det2:private-data        in frame f_sea_02_bem_pat = "HLP=000010805":U
           bt_ran:private-data         in frame f_sea_02_bem_pat = "HLP=000008967":U
           bt_fil:private-data         in frame f_sea_02_bem_pat = "HLP=000008966":U
           bt_ok:private-data          in frame f_sea_02_bem_pat = "HLP=000010721":U
           bt_can:private-data         in frame f_sea_02_bem_pat = "HLP=000011050":U
           bt_hel2:private-data        in frame f_sea_02_bem_pat = "HLP=000011326":U
           frame f_sea_02_bem_pat:private-data                   = "HLP=000002989".



{include/i_fclfrm.i f_fil_01_bem_pat f_sea_02_bem_pat }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_fil_01_bem_pat
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_fil_01_bem_pat */

ON INS OF br_sea_bem_pat IN FRAME f_sea_02_bem_pat
DO:

    if  bt_add2:sensitive in frame f_sea_02_bem_pat
    then do:
        apply "choose" to bt_add2 in frame f_sea_02_bem_pat.
    end /* if */.


END. /* ON INS OF br_sea_bem_pat IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_add2 IN FRAME f_sea_02_bem_pat
DO:

    assign v_rec_bem_pat = v_rec_table.
    if  search("prgfin/fas/fas701ca.r") = ? and search("prgfin/fas/fas701ca.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas701ca.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas701ca.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fas/fas701ca.p /*prg_add_bem_pat*/.
    assign v_rec_table = v_rec_bem_pat.
    run pi_open_sea_bem_pat /*pi_open_sea_bem_pat*/.
    reposition qr_sea_bem_pat to recid v_rec_table no-error.

END. /* ON CHOOSE OF bt_add2 IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_can IN FRAME f_sea_02_bem_pat
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_det2 IN FRAME f_sea_02_bem_pat
DO:

    if  avail bem_pat
    then do:
        assign v_rec_bem_pat = recid(bem_pat).
        if  search("prgfin/fas/fas701ia.r") = ? and search("prgfin/fas/fas701ia.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas701ia.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas701ia.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fas/fas701ia.p /*prg_det_bem_pat*/.
        if  v_rec_bem_pat <> ?
        then do:
            assign v_rec_table = v_rec_bem_pat.
            reposition qr_sea_bem_pat to recid v_rec_table no-error.
        end /* if */.
    end /* if */.
END. /* ON CHOOSE OF bt_det2 IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_fil IN FRAME f_sea_02_bem_pat
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

    /* @i(i_sea_filter &frame=f_fil_01_bem_pat
                  &bas_fields=v_log_bem_pat_alugdo, v_log_bem_pat_aquis,
                                v_log_bem_pat_desmembr, v_log_bem_pat_bxado,
                                v_log_bem_pat_hipotdo, v_log_bem_pat_imobdo,
                                v_log_bem_pat_normal, v_log_bem_pat_migrac,
                                v_log_bem_pat_quebrado, v_log_bem_pat_vendido
                  &table=@&(table)  &program=@&(program))
    */



    define var wgh_popup_menu         as widget-handle no-undo.
    define var wgh_popup_menu_content as widget-handle no-undo.
    define var wgh_popup_menu_about   as widget-handle no-undo.
    define var wgh_popup_menu_rule    as widget-handle no-undo.

    create menu wgh_popup_menu 
           assign popup-only = yes.

    create menu-item wgh_popup_menu_content
           assign label   = "Conte£do" /*l_conteudo*/ 
                  parent  = wgh_popup_menu
           triggers :
                  on choose persistent
                     run prgtec/men/men900za.py (Input bt_hel2:frame in frame f_fil_01_bem_pat,
                                                 Input this-procedure:handle) /*prg_fnc_chamar_help_context*/. /* fnc_chamar_help_context*/
           end triggers.


    create menu-item wgh_popup_menu_about
           assign label   = "Sobre" /*l_sobre*/ 
                  parent  = wgh_popup_menu
           triggers :
                 on choose do:

                    /* Begin_Include: i_about_call */
                    assign v_nom_prog     = substring(current-window:title, 1, max(1, length(current-window:title) - 10))
                                          + chr(10)
                                          + "sea_bem_pat":U
                           v_nom_prog_ext = "esp/fas/esfas016-z02.p":U
                           v_cod_release  = trim(" 1.00.00.014":U).
/*                    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                                               Input v_nom_prog_ext,
                                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
                    /* End_Include: i_about_call */

                 end.
           end triggers.

    assign bt_hel2:POPUP-MENU IN FRAME f_fil_01_bem_pat = wgh_popup_menu.



    view frame f_fil_01_bem_pat.

    filter_block:
    do on error undo filter_block, retry filter_block:
        update v_log_bem_pat_alugdo
               v_log_bem_pat_aquis
               v_log_bem_pat_desmembr
               v_log_bem_pat_bxado
               v_log_bem_pat_hipotdo
               v_log_bem_pat_imobdo
               v_log_bem_pat_normal
               v_log_bem_pat_migrac
               v_log_bem_pat_quebrado
               v_log_bem_pat_vendido
               &if '{&emsfin_version}' > '5.00' &then
                   v_des_bem_pat_palavra
               &endif
               bt_ok
               bt_can
               bt_hel2
               with frame f_fil_01_bem_pat.
        assign input frame f_fil_01_bem_pat v_des_bem_pat_palavra
               input frame f_fil_01_bem_pat v_log_bem_pat_alugdo
               input frame f_fil_01_bem_pat v_log_bem_pat_aquis
               input frame f_fil_01_bem_pat v_log_bem_pat_bxado
               input frame f_fil_01_bem_pat v_log_bem_pat_desmembr
               input frame f_fil_01_bem_pat v_log_bem_pat_hipotdo
               input frame f_fil_01_bem_pat v_log_bem_pat_imobdo
               input frame f_fil_01_bem_pat v_log_bem_pat_migrac
               input frame f_fil_01_bem_pat v_log_bem_pat_normal
               input frame f_fil_01_bem_pat v_log_bem_pat_quebrado
               input frame f_fil_01_bem_pat v_log_bem_pat_vendido.
        run pi_open_sea_bem_pat /*pi_open_sea_bem_pat*/.
    end /* do filter_block */.

    hide frame f_fil_01_bem_pat.
END. /* ON CHOOSE OF bt_fil IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_hel2 IN FRAME f_sea_02_bem_pat
DO:

    /* @i(i_context_help_frame)
    */
END. /* ON CHOOSE OF bt_hel2 IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_mod2 IN FRAME f_sea_02_bem_pat
DO:

    if  avail bem_pat
    then do:
        assign v_rec_bem_pat = recid(bem_pat)
               v_rec_table    = recid(bem_pat).
        if  search("prgfin/fas/fas701ea.r") = ? and search("prgfin/fas/fas701ea.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas701ea.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas701ea.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fas/fas701ea.p /*prg_mod_bem_pat*/.
        if  v_rec_bem_pat <> ?
        then do:
            assign v_rec_table = v_rec_bem_pat.
        end /* if */.
        run pi_open_sea_bem_pat /*pi_open_sea_bem_pat*/.
        reposition qr_sea_bem_pat to recid v_rec_table no-error.
    end /* if */.

END. /* ON CHOOSE OF bt_mod2 IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_ok IN FRAME f_sea_02_bem_pat
DO:

    if  avail bem_pat
    then do:
        assign v_rec_bem_pat = recid(bem_pat).
    end /* if */.
END. /* ON CHOOSE OF bt_ok IN FRAME f_sea_02_bem_pat */

ON CHOOSE OF bt_ran IN FRAME f_sea_02_bem_pat
DO:

    if  search("prgtec/btb/btb901za.r") = ? and search("prgtec/btb/btb901za.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb901za.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/btb/btb901za.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb901za.p (Input v_cod_dat_type,
                               Input v_cod_format,
                               Input v_nom_attrib,
                               input-output v_cod_initial,
                               input-output v_cod_final) /*prg_fnc_generic_range*/.

    run pi_open_sea_bem_pat /*pi_open_sea_bem_pat*/.



END. /* ON CHOOSE OF bt_ran IN FRAME f_sea_02_bem_pat */

ON VALUE-CHANGED OF rs_sea_bem_pat IN FRAME f_sea_02_bem_pat
DO:

    /* case_block: */
    case input frame f_sea_02_bem_pat rs_sea_bem_pat:
        when "Por Conta" /*l_por_conta*/ then
            code_block:
            do:
                assign v_cod_dat_type = "character"
                       v_cod_format   = "x(18)":U
                       v_nom_attrib   = "Conta Patrimonial"
                       v_cod_initial  = "":U
                       v_cod_final    = "ZZZZZZZZZZZZZZZZZZ":U.
            end /* do code_block */.
        when "Por Bem" /*l_por_bem*/ then
            code_block:
            do:
                assign v_cod_dat_type = "integer"
                       v_cod_format   = ">>>>>>>>9":U
                       v_nom_attrib   = "Bem Patrimonial"
                       v_cod_initial  = string(0)
                       v_cod_final    = string(999999999).
            end /* do code_block */.
        when "Por Descriá∆o" /*l_por_descricao*/ then
            code_block:
            do:
                assign v_cod_dat_type = "character"
                       v_cod_format   = "x(40)":U
                       v_nom_attrib   = "Descriá∆o Bem Pat"
                       v_cod_initial  = "":U
                       v_cod_final    = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":U.
            end /* do code_block */.
        when "Por Data Aquisiá∆o" /*l_por_data_aquisicao*/ then
            code_block:
            do:
                assign v_cod_dat_type = "date"
                       v_cod_format   = "99/99/9999":U
                       v_nom_attrib   = "Data Aquisiá∆o"
                       v_cod_initial  = &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF
                       v_dat_alter    = 12/31/9999
                       v_cod_final    = string(v_dat_alter).
            end /* do code_block */.
        when "Por Estab" /*l_por_estab*/ then
            code_block:
            do:
                assign v_cod_dat_type = &IF '{&emsfin_version}' >= '5.01' AND '{&emsfin_version}' <= '5.07' &THEN "character" &ELSE "Character" &ENDIF
                       v_cod_format   = &IF '{&emsfin_version}' >= '5.01' AND '{&emsfin_version}' <= '5.07' &THEN "x(3)":U &ELSE "x(5)":U &ENDIF
                       v_nom_attrib   = &IF '{&emsfin_version}' >= '5.01' AND '{&emsfin_version}' <= '5.07' &THEN "Estabelecimento" &ELSE "Estabelecimento" &ENDIF
                       v_cod_initial  = &IF '{&emsfin_version}' >= '5.01' AND '{&emsfin_version}' <= '5.07' &THEN "":U &ELSE "":U &ENDIF
                       v_cod_final    = &IF '{&emsfin_version}' >= '5.01' AND '{&emsfin_version}' <= '5.07' &THEN "ZZZ":U &ELSE "ZZZZZ":U &ENDIF.
            end /* do code_block */.
        when "Por Plaqueta" /*l_por_plaqueta*/ then
            code_block:
            do:
                assign v_cod_dat_type = "Character"
                       v_cod_format   = "x(20)":U
                       v_nom_attrib   = "N£mero Plaqueta"
                       v_cod_initial  = "":U
                       v_cod_final    = "ZZZZZZZZZZZZZZZZZZZZ":U.
            end /* do code_block */.
    end /* case case_block */.

    run pi_open_sea_bem_pat /*pi_open_sea_bem_pat*/.
END. /* ON VALUE-CHANGED OF rs_sea_bem_pat IN FRAME f_sea_02_bem_pat */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_fil_01_bem_pat ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_fil_01_bem_pat */

ON RIGHT-MOUSE-DOWN OF FRAME f_fil_01_bem_pat ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_fil_01_bem_pat */

ON RIGHT-MOUSE-UP OF FRAME f_fil_01_bem_pat ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_fil_01_bem_pat */

ON WINDOW-CLOSE OF FRAME f_fil_01_bem_pat
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_fil_01_bem_pat */

ON ENDKEY OF FRAME f_sea_02_bem_pat
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(bem_pat).    
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
        assign v_rec_table_epc = recid(bem_pat).    
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
        assign v_rec_table_epc = recid(bem_pat).    
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

END. /* ON ENDKEY OF FRAME f_sea_02_bem_pat */

ON END-ERROR OF FRAME f_sea_02_bem_pat
DO:

    assign v_rec_bem_pat = ?.
END. /* ON END-ERROR OF FRAME f_sea_02_bem_pat */

ON ENTRY OF FRAME f_sea_02_bem_pat
DO:

    apply "value-changed" to rs_sea_bem_pat in frame f_sea_02_bem_pat.

END. /* ON ENTRY OF FRAME f_sea_02_bem_pat */

ON HELP OF FRAME f_sea_02_bem_pat ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_sea_02_bem_pat */

ON RIGHT-MOUSE-DOWN OF FRAME f_sea_02_bem_pat ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_sea_02_bem_pat */

ON RIGHT-MOUSE-UP OF FRAME f_sea_02_bem_pat ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_sea_02_bem_pat */

ON WINDOW-CLOSE OF FRAME f_sea_02_bem_pat
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_sea_02_bem_pat */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_sea_02_bem_pat.





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


        assign v_nom_prog     = substring(frame f_sea_02_bem_pat:title, 1, max(1, length(frame f_sea_02_bem_pat:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "sea_bem_pat":U.




    assign v_nom_prog_ext = "esp/fas/esfas016-z02.p":U
           v_cod_release  = trim(" 1.00.00.014":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i sea_bem_pat}


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
    run pi_version_extract ('sea_bem_pat':U, 'esp/fas/esfas016-z02.p':U, '1.00.00.014':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
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
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'sea_bem_pat') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'sea_bem_pat')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'sea_bem_pat')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'sea_bem_pat' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'sea_bem_pat'
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
    where prog_dtsul.cod_prog_dtsul = "sea_bem_pat":U
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


assign v_wgh_frame_epc = frame f_sea_02_bem_pat:handle.



assign v_nom_table_epc = 'bem_pat':U
       v_rec_table_epc = recid(bem_pat).

&endif

/* End_Include: i_verify_program_epc */


/* ix_p00_sea_bem_pat */

/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_sea_02_bem_pat:title = frame f_sea_02_bem_pat:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.014":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_sea_02_bem_pat = menu m_help:handle.


/* End_Include: i_std_dialog_box */
{include/title5.i f_sea_02_bem_pat FRAME}


assign br_sea_bem_pat:num-locked-columns in frame f_sea_02_bem_pat = 3
.

pause 0 before-hide.
view frame f_sea_02_bem_pat.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(bem_pat).    
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
    assign v_rec_table_epc = recid(bem_pat).    
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
    assign v_rec_table_epc = recid(bem_pat).    
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


assign v_rec_table    = v_rec_bem_pat.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

    /* Begin_Include: ix_p10_sea_bem_pat */
    assign v_log_bem_pat_imobdo = yes.

    /* End_Include: ix_p10_sea_bem_pat */

    enable rs_sea_bem_pat
           br_sea_bem_pat
           bt_add2
           bt_mod2
           bt_det2
           bt_ran
           bt_fil
           bt_ok
           bt_can
           bt_hel2
           with frame f_sea_02_bem_pat.

    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(bem_pat).    
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
        assign v_rec_table_epc = recid(bem_pat).    
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
        assign v_rec_table_epc = recid(bem_pat).    
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

    assign bt_fil:sensitive in frame f_sea_02_bem_pat = no.
    /* ix_p20_sea_bem_pat */

/* **************
    @do(security_block) with frame @&(frame):
        @i(i_verify_security_button_sea &table=@&(table) &program_complement=@&(program_complement))
    @end_do(security_block).
***************/

    /* ix_p30_sea_bem_pat */

    wait-for go of frame f_sea_02_bem_pat
          or default-action of br_sea_bem_pat
          or mouse-select-dblclick of br_sea_bem_pat focus browse br_sea_bem_pat.
    if  avail bem_pat
    then do:
        /* ix_35_sea_bem_pat */.
        assign v_rec_bem_pat = recid(bem_pat).
    end /* if */.
    else do:
        assign v_rec_bem_pat = ?.
    end /* else */.
end /* do main_block */.

hide frame f_sea_02_bem_pat.

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
** Procedure Interna.....: pi_open_sea_bem_pat
** Descricao.............: pi_open_sea_bem_pat
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: log348825
** Alterado em...........: 12/07/2010 20:37:09
*****************************************************************************/
PROCEDURE pi_open_sea_bem_pat:

    /* case_block: */
    case input frame f_sea_02_bem_pat rs_sea_bem_pat:
        when "Por Conta" /*l_por_conta*/ then
            code_block:
            do:
                open query qr_sea_bem_pat for
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.cod_cta_pat >= v_cod_initial
                           and bem_pat.cod_cta_pat <= v_cod_final
                           and bem_pat.val_perc_bxa < 100
    /* and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.cod_cta_pat.
            end /* do code_block */.
        when "Por Bem" /*l_por_bem*/ then
            code_block:
            do:
                open query qr_sea_bem_pat for
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.num_bem_pat >= integer(v_cod_initial)
                           and bem_pat.num_bem_pat <= integer(v_cod_final)
                           and bem_pat.val_perc_bxa < 100
    /* and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.num_bem_pat
                    by bem_pat.num_seq_bem_pat.

            end /* do code_block */.
        when "Por Descriá∆o" /*l_por_descricao*/ then
            code_block:
            do:
                open query qr_sea_bem_pat for
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.des_bem_pat >= v_cod_initial
                           and bem_pat.des_bem_pat <= v_cod_final
                           and bem_pat.val_perc_bxa < 100
    /* and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.des_bem_pat.
            end /* do code_block */.
        /* comentado pois n∆o existe opá∆o em tela por data de aquisiá∆o
          @when(@%(l_por_data_aquisicao))
            @do(code_block):
                @open_query(qr_sea_@&(table))
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.dat_aquis_bem_pat >= date(v_cod_initial)
                           and bem_pat.dat_aquis_bem_pat <= date(v_cod_final)
    /*
                           and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.dat_aquis_bem_pat.
            @end_do(code_block).*/
        when "Por Estab" /*l_por_estab*/ then
            code_block:
            do:
                open query qr_sea_bem_pat for
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.cod_estab >= v_cod_initial
                           and bem_pat.cod_estab <= v_cod_final
                           and bem_pat.val_perc_bxa < 100
    /* and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.cod_estab.
            end /* do code_block */.
        when "Por Plaqueta" /*l_por_plaqueta*/ then
            code_block:
            do:
                open query qr_sea_bem_pat for
                    each bem_pat no-lock
                         where bem_pat.cod_empresa = v_cod_empres_usuar
                           and bem_pat.cb3_ident_visual >= v_cod_initial
                           and bem_pat.cb3_ident_visual <= v_cod_final
                           and bem_pat.val_perc_bxa < 100
    /* and ((v_log_bem_pat_alugdo   = yes and bem_pat.ind_sit_bem_pat = @%(l_alugado)) or
                                (v_log_bem_pat_hipotdo  = yes and bem_pat.ind_sit_bem_pat = @%(l_hipotecado)) or
                                (v_log_bem_pat_normal   = yes and bem_pat.ind_sit_bem_pat = @%(l_normal)) or
                                (v_log_bem_pat_quebrado = yes and bem_pat.ind_sit_bem_pat = @%(l_quebrado)) or
                                (v_log_bem_pat_vendido  = yes and bem_pat.ind_sit_bem_pat = @%(l_vendido)) or
                                (v_log_bem_pat_bxado    = no  and bem_pat.val_perc_bxa    < 100.00) or
                                (v_log_bem_pat_aquis    = yes and bem_pat.ind_orig_bem    = @%(l_aquisicao)) or
                                (v_log_bem_pat_desmembr = yes and bem_pat.ind_orig_bem    = @%(l_desmembramento)) or
                                (v_log_bem_pat_imobdo   = yes and bem_pat.ind_orig_bem    = @%(l_imobilizado)) or
                                (v_log_bem_pat_migrac   = yes and bem_pat.ind_orig_bem    = @%(l_migracao)))
                       &if '{&emsfin_version}' > '5.00' &then
                           and (bem_pat.des_bem_pat contains v_des_bem_pat_palavra 
                           or   v_des_bem_pat_palavra = "")
                       &endif
    */
                    by bem_pat.cb3_ident_visual.
            end /* do code_block */.
    end /* case case_block */.

END PROCEDURE. /* pi_open_sea_bem_pat */
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
        message getStrTrans("Mensagem nr. ", "FAS") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "FAS") c_prg_msg getStrTrans("n∆o encontrado.", "FAS")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/****************************  End of sea_bem_pat ***************************/
