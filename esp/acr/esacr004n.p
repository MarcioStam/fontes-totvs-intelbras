/*****************************************************************************
** Nome Externo..........: esp/acr/esacr004n.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 12/01/2009
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

&if "{&emsuni_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSUNI")) /*msg_5884*/.
&elseif "{&emsuni_version}" < "1.00" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "SEE_CCUSTO_UNID_NEGOC","~~EMSUNI", "~~{~&emsuni_version}", "~~1.00")) /*msg_5009*/.
&else

/************************ Parameter Definition Begin ************************/

def Input param p_cod_unid_negoc
    as character
    format "x(3)"
    no-undo.
def Input param p_cod_plano_ccusto
    as character
    format "x(8)"
    no-undo.


/************************* Parameter Definition End *************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)"
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_dat_type
    as character
    format "x(8)"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)"
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_final
    as character
    format "x(8)"
    initial ?
    label "Final"
    no-undo.
def var v_cod_format
    as character
    format "x(8)"
    label "Formato"
    column-label "Formato"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)"
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)"
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)"
    initial ?
    label "Inicial"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)"
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)"
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)"
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)"
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)"
    no-undo.
def var v_nom_attrib
    as character
    format "x(30)"
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)"
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)"
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)"
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)"
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9"
    no-undo.
def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9"
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9"
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9"
    no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_see_ccusto_unid_negoc
    for ccusto_unid_negoc,
        emscad.ccusto
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_see_ccusto_unid_negoc query qr_see_ccusto_unid_negoc display 
    ccusto_unid_negoc.cod_plano_ccusto
    width-chars 12.00
        column-label "Plano CCusto"
    ccusto_unid_negoc.cod_ccusto
    width-chars 11.00
        column-label "CCusto"
    ccusto.des_tit_ctbl
    width-chars 40.00
        column-label "T¡tulo Cont bil"
    ccusto.dat_inic_valid
    width-chars 10.00
        column-label "Inic Valid"
    ccusto.dat_fim_valid
    width-chars 10.00
        column-label "Fim Valid"
    with no-box separators single 
         size 87.57 by 07.00
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
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

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
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

def var rs_see_ccusto_unid_negoc
    as character
    initial "Por Centro de Custo"
    view-as radio-set Horizontal
    radio-buttons "Por Centro de Custo", "Por Centro de Custo"
     /*l_por_centro_custo*/ /*l_por_centro_custo*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_see_01_ccusto_unid_negoc
    rt_001
         at row 01.25 col 01.00 bgcolor 8 
    rt_cxcf
         at row 13.92 col 02.00 bgcolor 7 
    rt_cxcl
         at row 03.63 col 01.00 bgcolor 15 
    p_cod_unid_negoc
         at row 01.46 col 23.00 colon-aligned label "Unid Neg¢cio"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    unid_negoc.des_unid_negoc
         at row 01.46 col 30.00 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    p_cod_plano_ccusto
         at row 02.46 col 23.00 colon-aligned label "Plano Centros Custo"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    plano_ccusto.des_tit_ctbl
         at row 02.46 col 35.00 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    rs_see_ccusto_unid_negoc
         at row 03.83 col 03.00
         help "" no-label
    br_see_ccusto_unid_negoc
         at row 04.88 col 01.00
    bt_ran
         at row 12.42 col 03.00 font ?
         help "Faixa"
    bt_ok
         at row 14.13 col 03.00 font ?
         help "OK"
    bt_can
         at row 14.13 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 15.75 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Pesquisa Centro Custo".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_see_01_ccusto_unid_negoc = 10.00
           bt_can:height-chars  in frame f_see_01_ccusto_unid_negoc = 01.00
           bt_ok:width-chars    in frame f_see_01_ccusto_unid_negoc = 10.00
           bt_ok:height-chars   in frame f_see_01_ccusto_unid_negoc = 01.00
           bt_ran:width-chars   in frame f_see_01_ccusto_unid_negoc = 10.00
           bt_ran:height-chars  in frame f_see_01_ccusto_unid_negoc = 01.00
           rt_001:width-chars   in frame f_see_01_ccusto_unid_negoc = 87.57
           rt_001:height-chars  in frame f_see_01_ccusto_unid_negoc = 02.25
           rt_cxcf:width-chars  in frame f_see_01_ccusto_unid_negoc = 86.57
           rt_cxcf:height-chars in frame f_see_01_ccusto_unid_negoc = 01.42
           rt_cxcl:width-chars  in frame f_see_01_ccusto_unid_negoc = 87.57
           rt_cxcl:height-chars in frame f_see_01_ccusto_unid_negoc = 01.25.
    /* set private-data for the help system */
    assign p_cod_unid_negoc:private-data          in frame f_see_01_ccusto_unid_negoc = "HLP=000022218":U
           unid_negoc.des_unid_negoc:private-data in frame f_see_01_ccusto_unid_negoc = "HLP=000025189":U
           p_cod_plano_ccusto:private-data        in frame f_see_01_ccusto_unid_negoc = "HLP=000022217":U
           plano_ccusto.des_tit_ctbl:private-data in frame f_see_01_ccusto_unid_negoc = "HLP=000025190":U
           rs_see_ccusto_unid_negoc:private-data  in frame f_see_01_ccusto_unid_negoc = "HLP=000023488":U
           br_see_ccusto_unid_negoc:private-data  in frame f_see_01_ccusto_unid_negoc = "HLP=000023488":U
           bt_ran:private-data                    in frame f_see_01_ccusto_unid_negoc = "HLP=000008967":U
           bt_ok:private-data                     in frame f_see_01_ccusto_unid_negoc = "HLP=000010721":U
           bt_can:private-data                    in frame f_see_01_ccusto_unid_negoc = "HLP=000011050":U
           frame f_see_01_ccusto_unid_negoc:private-data                              = "HLP=000023488".

{include/i_fclfrm.i f_see_01_ccusto_unid_negoc }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_can IN FRAME f_see_01_ccusto_unid_negoc
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_see_01_ccusto_unid_negoc */

ON CHOOSE OF bt_ok IN FRAME f_see_01_ccusto_unid_negoc
DO:

    if  avail emscad.ccusto
    then do:
        assign v_rec_ccusto = recid(ccusto).
    end /* if */.
END. /* ON CHOOSE OF bt_ok IN FRAME f_see_01_ccusto_unid_negoc */

ON CHOOSE OF bt_ran IN FRAME f_see_01_ccusto_unid_negoc
DO:

    run prgtec/btb/btb901za.p (Input v_cod_dat_type,
                               Input v_cod_format,
                               Input v_nom_attrib,
                               input-output v_cod_initial,
                               input-output v_cod_final) /*prg_fnc_generic_range*/.

    run pi_open_see_ccusto_unid_negoc /*pi_open_see_ccusto_unid_negoc*/.


END. /* ON CHOOSE OF bt_ran IN FRAME f_see_01_ccusto_unid_negoc */

ON VALUE-CHANGED OF rs_see_ccusto_unid_negoc IN FRAME f_see_01_ccusto_unid_negoc
DO:

    /* inifim: */
    case input frame f_see_01_ccusto_unid_negoc  rs_see_ccusto_unid_negoc:
        when "Por Centro de Custo" /*l_por_centro_custo*/ then block_1:
         do:
            assign v_cod_dat_type = "Character"
                   v_cod_format   = "x(11)":U
                   v_nom_attrib   = "Centro Custo"
                   v_cod_initial  = string("":U)
                   v_cod_final    = string("ZZZZZZZZZZZ":U).
        end /* do block_1 */.
    end /* case inifim */.
    run pi_open_see_ccusto_unid_negoc /*pi_open_see_ccusto_unid_negoc*/.

END. /* ON VALUE-CHANGED OF rs_see_ccusto_unid_negoc IN FRAME f_see_01_ccusto_unid_negoc */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_see_01_ccusto_unid_negoc
DO:

    assign v_rec_ccusto = ?.
END. /* ON END-ERROR OF FRAME f_see_01_ccusto_unid_negoc */

ON ENTRY OF FRAME f_see_01_ccusto_unid_negoc
DO:

    apply "value-changed" to rs_see_ccusto_unid_negoc in frame f_see_01_ccusto_unid_negoc.

END. /* ON ENTRY OF FRAME f_see_01_ccusto_unid_negoc */

/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* Begin_Include: ix_p00_see_ccusto_unid_negoc */
find unid_negoc
    where unid_negoc.cod_unid_negoc = p_cod_unid_negoc
    no-lock no-error.
display unid_negoc.des_unid_negoc when avail unid_negoc
        "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
        with frame f_see_01_ccusto_unid_negoc.

find plano_ccusto
    where plano_ccusto.cod_empresa      = v_cod_empres_usuar
    and   plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
    no-lock no-error.
display plano_ccusto.des_tit_ctbl when avail plano_ccusto
        "" when not avail plano_ccusto @ plano_ccusto.des_tit_ctbl
        with frame f_see_01_ccusto_unid_negoc.

display p_cod_unid_negoc
        p_cod_plano_ccusto
        with frame f_see_01_ccusto_unid_negoc.


/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e versÆo */
assign frame f_see_01_ccusto_unid_negoc:title = frame f_see_01_ccusto_unid_negoc:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).

assign br_see_ccusto_unid_negoc:num-locked-columns in frame f_see_01_ccusto_unid_negoc = 0.

pause 0 before-hide.
view frame f_see_01_ccusto_unid_negoc.

assign v_rec_table    = v_rec_ccusto.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.
    display rs_see_ccusto_unid_negoc
            with frame f_see_01_ccusto_unid_negoc.

    enable rs_see_ccusto_unid_negoc
           br_see_ccusto_unid_negoc
           bt_ran
           bt_ok
           bt_can
           with frame f_see_01_ccusto_unid_negoc.

    wait-for go of frame f_see_01_ccusto_unid_negoc
          or default-action of br_see_ccusto_unid_negoc
          or mouse-select-dblclick of br_see_ccusto_unid_negoc.
    if  avail ccusto
    then do:
        assign v_rec_ccusto = recid(ccusto).
    end /* if */.
    /* ix_p20_see_ccusto_unid_negoc */
end /* do main_block */.

hide frame f_see_01_ccusto_unid_negoc.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_see_ccusto_unid_negoc
** Descricao.............: pi_open_see_ccusto_unid_negoc
** Criado por............: Rafael
** Criado em.............: 07/02/1997 15:50:15
** Alterado por..........: bre14621
** Alterado em...........: 02/08/2000 15:13:35
*****************************************************************************/
PROCEDURE pi_open_see_ccusto_unid_negoc:

    /* case_block: */
    case input frame f_see_01_ccusto_unid_negoc rs_see_ccusto_unid_negoc:
        when "Por Centro de Custo" /*l_por_centro_custo*/ then
            code_block:
            do:
                open query qr_see_ccusto_unid_negoc for
                    each ccusto_unid_negoc no-lock
                    where ccusto_unid_negoc.cod_empresa      = v_cod_empres_usuar
                    and   ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto
                    and   ccusto_unid_negoc.cod_unid_negoc   = p_cod_unid_negoc
                    and   ccusto_unid_negoc.cod_ccusto       >= v_cod_initial
                    and   ccusto_unid_negoc.cod_ccusto       <= v_cod_final,
                    first emscad.ccusto no-lock
                    where ccusto.cod_plano_ccusto = p_cod_plano_ccusto
                    and   ccusto.cod_ccusto       = ccusto_unid_negoc.cod_ccusto.
            end /* do code_block */.
    end /* case case_block */.

END PROCEDURE. /* pi_open_see_ccusto_unid_negoc */

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

    assign c_prg_msg = "messages/"
                     + string(trunc(i_msg / 1000,0),"99")
                     + "/msg"
                     + string(i_msg, "99999").

    if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do:
        message "Mensagem nr. " i_msg "!!!" skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p") (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of see_ccusto_unid_negoc **********************/
