/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: mod_ext_banco
** Descricao.............: Modifica Extensao Banco
** Versao................:  1.00.00.000
** Procedimento..........: man_ext_banco
** Nome Externo..........: epc/epc001aa.p
** Data Geracao..........: 07/01/2000 - 17:20:02
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre18805
** Alterado em...........: 07/01/2000 17:18:15
** Gerado por............: bre18805
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

&if "{&emsuni_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSUNI")) /*msg_5884*/.
&elseif "{&emsuni_version}" < "5.01" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "MOD_EXT_BANCO","~~EMSUNI", "~~{~&emsuni_version}", "~~5.01")) /*msg_5009*/.
&else

/************************** Buffer Definition Begin *************************/

def buffer b_banco_sist_nac_bcio
    for emscad.banco.


/*************************** Buffer Definition End **************************/

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
def new global shared var v_cod_dwb_user
    as character
    format "x(21)"
    label "Usu†rio"
    column-label "Usu†rio"
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
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)"
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)"
    label "Idioma"
    column-label "Idioma"
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
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
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
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)"
    no-undo.
def var v_des_percent_complete
    as character
    format "x(06)"
    no-undo.
def var v_des_percent_complete_fnd
    as character
    format "x(08)"
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_erro_gerad
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_param_utiliz_produt_val
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_repeat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_cancel
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_save
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_save_ok
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_utiliz_mrh
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_nom_base_dados_ext
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
def var v_num_return
    as integer
    format ">>>>,>>9"
    no-undo.
def var v_num_seq
    as integer
    format ">>>,>>9"
    label "SeqÅància"
    column-label "Seq"
    no-undo.
def new global shared var v_rec_banco
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
def var v_val_current_value
    as decimal
    format "->>,>>>,>>>,>>9.99"
    decimals 2
    no-undo.
def var v_wgh_focus
    as widget-handle
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

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_key
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_can2
    label "Cancela"
    tooltip "Cancela"
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

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_02_percent_update
    rt_001
         at row 01.29 col 02.00
    " Percentual Completo " view-as text
         at row 01.00 col 04.00
    v_des_percent_complete_fnd
         at row 02.04 col 03.00 no-label
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_percent_complete
         at row 02.04 col 03.00 no-label
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_can2
         at row 03.50 col 20.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 50.00 by 05.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "".
    /* adjust size of objects in this frame */
    assign bt_can2:width-chars  in frame f_dlg_02_percent_update = 10.00
           bt_can2:height-chars in frame f_dlg_02_percent_update = 01.00
           rt_001:width-chars   in frame f_dlg_02_percent_update = 46.72
           rt_001:height-chars  in frame f_dlg_02_percent_update = 01.92.
    /* set private-data for the help system */
    assign v_des_percent_complete_fnd:private-data in frame f_dlg_02_percent_update = "HLP=000022169":U
           v_des_percent_complete:private-data     in frame f_dlg_02_percent_update = "HLP=000022167":U
           bt_can2:private-data                    in frame f_dlg_02_percent_update = "HLP=000011451":U
           frame f_dlg_02_percent_update:private-data                               = "HLP=000010975".

def frame f_mop_03_ext_banco
    rt_mold
         at row 02.54 col 02.00
    rt_cxcf
         at row 5.79 col 02.00 bgcolor 7 
    rt_key
         at row 01.21 col 02.00
    ext_banco.cod_sist_nac_bcio
         at row 01.38 col 26.00 colon-aligned label "C¢digo Sist Banc†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_banco.num_pos_ini_cod_tit_bco[1]
         at row 02.71 col 26.00 colon-aligned label "Nosso N£mero Boleto"
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_banco.num_pos_fin_cod_tit_bco[1]
         at row 02.71 col 36.00 colon-aligned no-label
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_banco.num_pos_ini_cod_tit_bco[2]
         at row 03.71 col 26.00 colon-aligned label "D°gito Verificador Nosso N£mero"
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_banco.num_pos_fin_cod_tit_bco[2]
         at row 03.71 col 36.00 colon-aligned no-label
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 6.00 col 03.00 font ?
         help "OK"
    bt_can
         at row 6.00 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 6.00 col 73.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 86.00 by 7.63 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Informa Posiá‰es C¢digo de Barras".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_mop_03_ext_banco = 10.00
           bt_can:height-chars  in frame f_mop_03_ext_banco = 01.00
           bt_hel2:width-chars  in frame f_mop_03_ext_banco = 10.00
           bt_hel2:height-chars in frame f_mop_03_ext_banco = 01.00
           bt_ok:width-chars    in frame f_mop_03_ext_banco = 10.00
           bt_ok:height-chars   in frame f_mop_03_ext_banco = 01.00
           rt_cxcf:width-chars  in frame f_mop_03_ext_banco = 82.57
           rt_cxcf:height-chars in frame f_mop_03_ext_banco = 01.42
           rt_key:width-chars   in frame f_mop_03_ext_banco = 82.57
           rt_key:height-chars  in frame f_mop_03_ext_banco = 01.25
           rt_mold:width-chars  in frame f_mop_03_ext_banco = 82.57
           rt_mold:height-chars in frame f_mop_03_ext_banco = 03.21.
    /* set private-data for the help system */
    assign ext_banco.cod_sist_nac_bcio:private-data               in frame f_mop_03_ext_banco = "HLP=000014928":U
           ext_banco.num_pos_ini_cod_tit_bco[1]:private-data      in frame f_mop_03_ext_banco = "HLP=000014914":U
           ext_banco.num_pos_fin_cod_tit_bco[1]:private-data      in frame f_mop_03_ext_banco = "HLP=000014918":U
           ext_banco.num_pos_ini_cod_tit_bco[2]:private-data      in frame f_mop_03_ext_banco = "HLP=000015579":U
           ext_banco.num_pos_fin_cod_tit_bco[2]:private-data      in frame f_mop_03_ext_banco = "HLP=000016788":U
           bt_ok:private-data                                     in frame f_mop_03_ext_banco = "HLP=000010721":U
           bt_can:private-data                                    in frame f_mop_03_ext_banco = "HLP=000011050":U
           bt_hel2:private-data                                   in frame f_mop_03_ext_banco = "HLP=000011326":U
           frame f_mop_03_ext_banco:private-data                                              = "HLP=000007912".



/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_percent_update
DO:

    hide frame f_dlg_02_percent_update.
    stop.
END. /* ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_percent_update */

ON CHOOSE OF bt_can IN FRAME f_mop_03_ext_banco
DO:
    assign v_log_cancel = yes.
    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_mop_03_ext_banco */

ON CHOOSE OF bt_hel2 IN FRAME f_mop_03_ext_banco
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_mop_03_ext_banco */

ON CHOOSE OF bt_ok IN FRAME f_mop_03_ext_banco
DO:

    assign v_log_repeat   = no
           v_log_save     = yes
           v_rec_banco    = v_rec_table.
END. /* ON CHOOSE OF bt_ok IN FRAME f_mop_03_banco */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_02_percent_update ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_02_percent_update */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_percent_update ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9"
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_percent_update */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_percent_update ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9"
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_percent_update */

ON WINDOW-CLOSE OF FRAME f_dlg_02_percent_update
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_02_percent_update */

ON ENDKEY OF FRAME f_mop_03_ext_banco
DO:


END. /* ON ENDKEY OF FRAME f_mop_03_ext_banco */

ON END-ERROR OF FRAME f_mop_03_ext_banco
DO:
    if  not v_log_cancel then
        assign v_rec_banco = ?.
END. /* ON END-ERROR OF FRAME f_mop_03_ext_banco */

ON HELP OF FRAME f_mop_03_ext_banco ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_mop_03_ext_banco */

ON RIGHT-MOUSE-DOWN OF FRAME f_mop_03_ext_banco ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9"
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_mop_03_ext_banco */

ON RIGHT-MOUSE-UP OF FRAME f_mop_03_ext_banco ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9"
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_mop_03_ext_banco */

ON WINDOW-CLOSE OF FRAME f_mop_03_ext_banco
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_mop_03_ext_banco */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_mop_03_ext_banco.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)"
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)"
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)"
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(frame f_mop_03_ext_banco:title, 1, max(1, length(frame f_mop_03_ext_banco:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "mod_ext_banco":U.




    assign v_nom_prog_ext = "epc/epc001aa.p":U
           v_cod_release  = trim(" 1.00.00.000":U).
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
    run pi_version_extract ('mod_ext_banco', 'epc/epc001aa.p', '1.00.00.000', 'pro').
end /* if */.
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
    run prgtec/men/men901za.py (Input 'mod_ext_banco') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'mod_ext_banco')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'mod_ext_banco')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'mod_ext_banco' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'mod_ext_banco'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "mod_ext_banco":U
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


assign v_wgh_frame_epc = frame f_mop_03_ext_banco:handle.



assign v_nom_table_epc = 'banco'
       v_rec_table_epc = recid(emscad.banco).

&endif

/* End_Include: i_verify_program_epc */



/* Begin_Include: ix_p00_mod_banco */
run pi_verifica_utiliz_modulo (Input v_cod_empres_usuar,
                               Input 'UHR',
                               output v_log_param_utiliz_produt_val) /*pi_verifica_utiliz_modulo*/.
if  v_log_param_utiliz_produt_val = yes
then do:

   /* Begin_Include: i_verifica_base_dados_ext_conectada */
   if  v_log_utiliz_mrh
   then do:
      if  not connected(v_nom_base_dados_ext)
      then do:
         /* Banco de Dados MAGNUS-RH n∆o est† conectado. */
         run pi_messages (input "show",
                          input 3861,
                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_3861*/.
         return.
      end /* if */.
   end /* if */.

   /* End_Include: i_verifica_base_dados_ext_conectada */

end /* if */.

/* End_Include: i_verifica_base_dados_ext_conectada */



/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_mop_03_ext_banco:title = frame f_mop_03_ext_banco:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_mop_03_ext_banco = menu m_help:handle.


/* End_Include: i_std_dialog_box */


pause 0 before-hide.
view frame f_mop_03_ext_banco.

assign v_log_repeat   = yes
       v_rec_table    = v_rec_banco.

main_block:
repeat while v_log_repeat:
    /* ix_p10_mod_banco */
    assign v_log_repeat  = no
           v_log_save_ok = no
           v_log_cancel  = no.

    find banco where recid(banco) = v_rec_table no-lock no-error.
    if  not avail banco then do:
        message "Registro Extens∆o Banco n∆o est† dispon°vel." skip(1)
                "Selecione o Banco desejado no programa principal e tente novamente!"
               view-as alert-box error buttons ok title "ERRO".
        return.
    end.

    find ext_banco where ext_banco.cod_sist_nac_bcio = banco.cod_sist_nac_bcio exclusive-lock no-error.
    if  not avail ext_banco then do:
        create ext_banco.
        assign ext_banco.cod_sist_nac_bcio = banco.cod_sist_nac_bcio.
    end.

    if  not retry
    then do:
        display ext_banco.cod_sist_nac_bcio
                ext_banco.num_pos_ini_cod_tit_bco[1]
                ext_banco.num_pos_fin_cod_tit_bco[1]
                ext_banco.num_pos_ini_cod_tit_bco[2]
                ext_banco.num_pos_fin_cod_tit_bco[2]
                with frame f_mop_03_ext_banco.
    end /* if */.

    enable ext_banco.num_pos_ini_cod_tit_bco[1]
           ext_banco.num_pos_fin_cod_tit_bco[1]
           ext_banco.num_pos_ini_cod_tit_bco[2]
           ext_banco.num_pos_fin_cod_tit_bco[2]
           bt_ok
           bt_can
           bt_hel2
           with frame f_mop_03_ext_banco.


    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        assign v_log_save = no
               v_rec_table = recid(banco).

        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_mop_03_ext_banco focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_mop_03_ext_banco.
        end /* else */.
        if  v_log_save = no
        then do:
            if  (ext_banco.cod_sist_nac_bcio:visible          in frame f_mop_03_ext_banco and
             ext_banco.cod_sist_nac_bcio:sensitive        in frame f_mop_03_ext_banco and
             input frame f_mop_03_ext_banco ext_banco.cod_sist_nac_bcio           <> ext_banco.cod_sist_nac_bcio       ) or
            (ext_banco.num_pos_ini_cod_tit_bco[1]:visible      in frame f_mop_03_ext_banco and
             ext_banco.num_pos_ini_cod_tit_bco[1]:sensitive    in frame f_mop_03_ext_banco and
             input frame f_mop_03_ext_banco ext_banco.num_pos_ini_cod_tit_bco[1]  <> ext_banco.num_pos_ini_cod_tit_bco[1]   ) or
            (ext_banco.num_pos_fin_cod_tit_bco[1]:visible      in frame f_mop_03_ext_banco and
             ext_banco.num_pos_fin_cod_tit_bco[1]:sensitive    in frame f_mop_03_ext_banco and
             input frame f_mop_03_ext_banco ext_banco.num_pos_fin_cod_tit_bco[1]  <> ext_banco.num_pos_fin_cod_tit_bco[1]   ) or
            (ext_banco.num_pos_ini_cod_tit_bco[2]:visible      in frame f_mop_03_ext_banco and
             ext_banco.num_pos_ini_cod_tit_bco[2]:sensitive    in frame f_mop_03_ext_banco and
             input frame f_mop_03_ext_banco ext_banco.num_pos_ini_cod_tit_bco[2]  <> ext_banco.num_pos_ini_cod_tit_bco[2]   ) or
            (ext_banco.num_pos_fin_cod_tit_bco[2]:visible      in frame f_mop_03_ext_banco and
             ext_banco.num_pos_fin_cod_tit_bco[2]:sensitive    in frame f_mop_03_ext_banco and
             input frame f_mop_03_ext_banco ext_banco.num_pos_fin_cod_tit_bco[2]  <> ext_banco.num_pos_fin_cod_tit_bco[2]   )
            then do:
                message substitute("&1 sofreu alteraá‰es. Deseja salv†-las ?" /*l_mod_save*/ , "Banco")
                       view-as alert-box question buttons yes-no-cancel title substitute("&1", c-versao-prg) update v_log_answer.
                assign v_log_save = v_log_answer.
            end /* if */.
        end /* if */.
        if  v_log_save = yes
        then do:
            save_block:
            do on error undo save_block, leave save_block:

                run pi_save_fields /*pi_save_fields*/.

                /* Begin_Include: ix_p30_mod_banco */
                if  v_log_param_utiliz_produt_val = yes and v_log_utiliz_mrh = yes
                then do:
                   if  search("prgint/dch/dch710zk.r") = ? and search("prgint/dch/dch710zk.py") = ? then do:
                       if  v_cod_dwb_user begins 'es_' then
                           return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/dch/dch710zk.py".
                       else do:
                           message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/dch/dch710zk.py"
                                  view-as alert-box error buttons ok.
                           return.
                       end.
                   end.
                   else
                       run prgint/dch/dch710zk.py /*prg_fnc_banco_mrh*/.
                end /* if */.

                /* End_Include: ix_p30_mod_banco */

                assign v_log_save_ok = yes.
            end /* do save_block */.
        end /* if */.
        if  v_log_save = no
        then do:
            assign v_log_save_ok = yes.
        end /* if */.
    end /* repeat wait_block */.
end /* repeat main_block */.

/* ix_p40_mod_banco */

hide frame f_mop_03_ext_banco.

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



/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_save_fields
** Descricao.............: pi_save_fields
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 25/10/1994 15:14:34
*****************************************************************************/
PROCEDURE pi_save_fields:

    assign_block:
    do on error undo assign_block, return error:
        assign input frame f_mop_03_ext_banco ext_banco.cod_sist_nac_bcio
               input frame f_mop_03_ext_banco ext_banco.num_pos_ini_cod_tit_bco[1]
               input frame f_mop_03_ext_banco ext_banco.num_pos_fin_cod_tit_bco[1]
               input frame f_mop_03_ext_banco ext_banco.num_pos_ini_cod_tit_bco[2]
               input frame f_mop_03_ext_banco ext_banco.num_pos_fin_cod_tit_bco[2].
        assign v_wgh_focus = ?.
    end /* do assign_block */.
END PROCEDURE. /* pi_save_fields */
/*****************************************************************************
** Procedure Interna.....: pi_percent_update
** Descricao.............: pi_percent_update
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: vladimir
** Alterado em...........: 15/10/1996 09:46:31
*****************************************************************************/
PROCEDURE pi_percent_update:

    /************************ Parameter Definition Begin ************************/

    def Input param p_val_maximum
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_val_current_value
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_nom_frame_title
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  p_val_maximum = 0
    then do:
       assign p_val_maximum = 1.
    end /* if */.

    assign v_des_percent_complete     = string(integer(p_val_current_value * 100 / p_val_maximum))
                                      + chr(32) + chr(37)
           v_des_percent_complete_fnd = v_des_percent_complete.

    if  not v_cod_dwb_user begins 'es_'
    then do:
        if  p_val_current_value = 0
        then do:
            assign v_des_percent_complete:width-pixels     in frame f_dlg_02_percent_update = 1
                   v_des_percent_complete:bgcolor          in frame f_dlg_02_percent_update = 1
                   v_des_percent_complete:fgcolor          in frame f_dlg_02_percent_update = 15
                   v_des_percent_complete:font             in frame f_dlg_02_percent_update = 1
                   rt_001:bgcolor                          in frame f_dlg_02_percent_update = 8
                   v_des_percent_complete_fnd:width-pixels in frame f_dlg_02_percent_update = 315
                   v_des_percent_complete_fnd:font         in frame f_dlg_02_percent_update = 1.
            if  p_nom_frame_title <> ""
            then do:
                assign frame f_dlg_02_percent_update:title = p_nom_frame_title.
            end /* if */.
            else do:
                assign frame f_dlg_02_percent_update:title = "Aguarde, em processamento..." /*l_aguarde_em_processamento*/ .
            end /* else */.
            view frame f_dlg_02_percent_update.
        end /* if */.
        else do:
            assign v_des_percent_complete:width-pixels = max(((315 * p_val_current_value)
                                                       / p_val_maximum), 1).
        end /* else */.
        display v_des_percent_complete
                v_des_percent_complete_fnd
                with frame f_dlg_02_percent_update.
        enable all with frame f_dlg_02_percent_update.
        process events.
    end /* if */.
    else do:
        run prgtec/btb/btb908ze.py (Input 1,
                                    Input v_des_percent_complete) /*prg_api_atualizar_ult_obj*/.
    end /* else */.



END PROCEDURE. /* pi_percent_update */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_utiliz_modulo
** Descricao.............: pi_verifica_utiliz_modulo
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:32:29
*****************************************************************************/
PROCEDURE pi_verifica_utiliz_modulo:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.
    def output param p_log_param_utiliz_produt_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  p_cod_empresa = "" then
        assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                       where param_utiliz_produt.cod_modul_dtsul = p_cod_modul_dtsul /*cl_verifica_modulo of param_utiliz_produt*/).
    else do:
       if  p_cod_empresa = v_cod_empres_usuar then
           assign p_log_param_utiliz_produt_val = can-do(v_cod_modul_dtsul_empres,p_cod_modul_dtsul).
       else
           assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                          where param_utiliz_produt.cod_empresa = p_cod_empresa
                                                            and param_utiliz_produt.cod_modul_dtsul = p_cod_modul_dtsul
    &if "{&emsuni_version}" >= "5.01" &then
                                                          use-index prmtlzcm_modulo
    &endif
                                                           /*cl_verifica_utiliz_modul of param_utiliz_produt*/).
    end.

END PROCEDURE. /* pi_verifica_utiliz_modulo */
/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: Gilmar
** Alterado em...........: 29/01/1999 13:50:32
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(8)"
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
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = p_cod_program 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' then
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

    assign c_prg_msg = "messages/"
                     + string(trunc(i_msg / 1000,0),"99")
                     + "/msg"
                     + string(i_msg, "99999").

    if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do:
        message "Mensagem nr. " i_msg "!!!" skip
                "Programa Mensagem" c_prg_msg "nío encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p") (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*****************************  End of mod_banco ****************************/
