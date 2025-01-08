/*****************************************************************************
** Programa..............: esp/sco/essco104da.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 15/10/2008
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

/************************** Buffer Definition Begin *************************/

def buffer b_ext_admdra_cartao_cr_comis
    for ext_admdra_cartao_cr_comis.
def buffer b_ext_admdra_cartao_cr_comis_add
    for ext_admdra_cartao_cr_comis.
def buffer b_ext_admdra_cartao_cr_comis_cop
    for ext_admdra_cartao_cr_comis.


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
    format "x(12)"
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
def var v_log_repeat
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
def new global shared var v_rec_ext_admdra_cartao_cr_comis
    as recid
    format ">>>>>>9"
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
def var v_rec_table_sav
    as recid
    format ">>>>>>9"
    no-undo.
def new global shared var v_rec_tab_prgssiv_impto_retid
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def new global shared var v_rec_admdra_cartao_cr
    as recid
    format ">>>>>>9"
    initial ?
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

def frame f_adc_03_ext_admdra_cartao_cr_comis
    rt_mold
         at row 02.54 col 02.00
    rt_cxcf
         at row 08.17 col 02.00 bgcolor 7 
    rt_key
         at row 01.21 col 02.00
    ext_admdra_cartao_cr_comis.num_faixa
         at row 01.38 col 28.00 colon-aligned label "Faixa Comiss∆o Administradora"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_admdra_cartao_cr_comis.num_parc_ini
         at row 03.71 col 28.00 colon-aligned label "Parcela Inicial"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_admdra_cartao_cr_comis.num_parc_fim
         at row 04.71 col 28.00 colon-aligned label "Parcela Final"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    ext_admdra_cartao_cr_comis.val_perc_comis
         at row 05.71 col 28.00 colon-aligned label "%Comiss∆o"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 08.38 col 03.00 font ?
         help "OK"
    bt_sav
         at row 08.38 col 14.00 font ?
         help "Salva"
    bt_can
         at row 08.38 col 25.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 82.00 by 10.00 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Inclui Faixa Comiss∆o Administradora".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_adc_03_ext_admdra_cartao_cr_comis = 10.00
           bt_can:height-chars  in frame f_adc_03_ext_admdra_cartao_cr_comis = 01.00
           bt_ok:width-chars    in frame f_adc_03_ext_admdra_cartao_cr_comis = 10.00
           bt_ok:height-chars   in frame f_adc_03_ext_admdra_cartao_cr_comis = 01.00
           bt_sav:width-chars   in frame f_adc_03_ext_admdra_cartao_cr_comis = 10.00
           bt_sav:height-chars  in frame f_adc_03_ext_admdra_cartao_cr_comis = 01.00
           rt_cxcf:width-chars  in frame f_adc_03_ext_admdra_cartao_cr_comis = 78.57
           rt_cxcf:height-chars in frame f_adc_03_ext_admdra_cartao_cr_comis = 01.42
           rt_key:width-chars   in frame f_adc_03_ext_admdra_cartao_cr_comis = 78.57
           rt_key:height-chars  in frame f_adc_03_ext_admdra_cartao_cr_comis = 01.21
           rt_mold:width-chars  in frame f_adc_03_ext_admdra_cartao_cr_comis = 78.57
           rt_mold:height-chars in frame f_adc_03_ext_admdra_cartao_cr_comis = 05.21.
    /* set private-data for the help system */
    assign ext_admdra_cartao_cr_comis.num_faixa:private-data   in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000019046":U
           ext_admdra_cartao_cr_comis.num_parc_ini:private-data in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000019047":U
           ext_admdra_cartao_cr_comis.num_parc_fim:private-data   in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000019048":U
           ext_admdra_cartao_cr_comis.val_perc_comis:private-data          in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000019049":U
           bt_ok:private-data                                          in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000010721":U
           bt_sav:private-data                                         in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000011048":U
           bt_can:private-data                                         in frame f_adc_03_ext_admdra_cartao_cr_comis = "HLP=000011050":U
           frame f_adc_03_ext_admdra_cartao_cr_comis:private-data                                                   = "HLP=000019045".



{include/i_fclfrm.i f_adc_03_ext_admdra_cartao_cr_comis }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can IN FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_ok IN FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:

    assign v_log_repeat = no.
    /* ix_g10_add_ext_admdra_cartao_cr_comis */

END. /* ON CHOOSE OF bt_ok IN FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_sav IN FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:

    assign v_log_repeat = yes.
    /* ix_g20_add_ext_admdra_cartao_cr_comis */

END. /* ON CHOOSE OF bt_sav IN FRAME f_adc_03_ext_admdra_cartao_cr_comis */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON ENDKEY OF FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(ext_admdra_cartao_cr_comis).
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
        assign v_rec_table_epc = recid(ext_admdra_cartao_cr_comis).
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
        assign v_rec_table_epc = recid(ext_admdra_cartao_cr_comis).
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

END. /* ON ENDKEY OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON END-ERROR OF FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:

    assign v_rec_ext_admdra_cartao_cr_comis = v_rec_table_sav.

END. /* ON END-ERROR OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON HELP OF FRAME f_adc_03_ext_admdra_cartao_cr_comis ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON RIGHT-MOUSE-DOWN OF FRAME f_adc_03_ext_admdra_cartao_cr_comis ANYWHERE
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

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON RIGHT-MOUSE-UP OF FRAME f_adc_03_ext_admdra_cartao_cr_comis ANYWHERE
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

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */

ON WINDOW-CLOSE OF FRAME f_adc_03_ext_admdra_cartao_cr_comis
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_adc_03_ext_admdra_cartao_cr_comis */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_adc_03_ext_admdra_cartao_cr_comis:title = frame f_adc_03_ext_admdra_cartao_cr_comis:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

pause 0 before-hide.
view frame f_adc_03_ext_admdra_cartao_cr_comis.

assign v_log_repeat   = yes
       v_rec_table    = v_rec_ext_admdra_cartao_cr_comis.

find admdra_cartao_cr where recid(admdra_cartao_cr) = v_rec_admdra_cartao_cr no-lock no-error.

main_block:
repeat while v_log_repeat:
    /* ix_p10_add_ext_admdra_cartao_cr_comis */
    assign v_log_repeat  = no
           v_log_save_ok = no.
    create ext_admdra_cartao_cr_comis.
    assign ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr = admdra_cartao_cr.cod_admdra_cartao_cr.
    /* ix_p15_add_ext_admdra_cartao_cr_comis */
    if  not retry
    then do:
        assign v_rec_table_sav = v_rec_table.
        /* f_adc_03_ext_admdra_cartao_cr_comis, */.
        display ext_admdra_cartao_cr_comis.num_faixa
                ext_admdra_cartao_cr_comis.num_parc_ini
                ext_admdra_cartao_cr_comis.num_parc_fim
                ext_admdra_cartao_cr_comis.val_perc_comis
                with frame f_adc_03_ext_admdra_cartao_cr_comis.

    end /* if */.
    enable ext_admdra_cartao_cr_comis.num_faixa
           ext_admdra_cartao_cr_comis.num_parc_ini
           ext_admdra_cartao_cr_comis.num_parc_fim
           ext_admdra_cartao_cr_comis.val_perc_comis
           bt_ok
           bt_sav
           bt_can
           with frame f_adc_03_ext_admdra_cartao_cr_comis.

    /* Begin_Include: ix_p20_add_ext_admdra_cartao_cr_comis */
    find last b_ext_admdra_cartao_cr_comis
        where b_ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr = admdra_cartao_cr.cod_admdra_cartao_cr
        no-lock no-error.
    if  not avail b_ext_admdra_cartao_cr_comis
    then do:
        assign ext_admdra_cartao_cr_comis.num_faixa    = 1
               ext_admdra_cartao_cr_comis.num_parc_ini = 1.
    end /* if */.
    else do:
        assign ext_admdra_cartao_cr_comis.num_faixa    = b_ext_admdra_cartao_cr_comis.num_faixa + 1
               ext_admdra_cartao_cr_comis.num_parc_ini = b_ext_admdra_cartao_cr_comis.num_parc_fim + 1.
        if  ext_admdra_cartao_cr_comis.num_parc_ini > 999 then
            assign ext_admdra_cartao_cr_comis.num_parc_ini = 0.
    end /* else */.

    display ext_admdra_cartao_cr_comis.num_faixa
            ext_admdra_cartao_cr_comis.num_parc_ini
            with frame f_adc_03_ext_admdra_cartao_cr_comis.
    disable ext_admdra_cartao_cr_comis.num_faixa
            ext_admdra_cartao_cr_comis.num_parc_ini
            with frame f_adc_03_ext_admdra_cartao_cr_comis.

    /* End_Include: ix_p20_add_ext_admdra_cartao_cr_comis */

    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_adc_03_ext_admdra_cartao_cr_comis focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_adc_03_ext_admdra_cartao_cr_comis.
        end /* else */.
        save_block:
        do on error undo save_block, leave save_block:
            /* ix_p25_add_ext_admdra_cartao_cr_comis */
            run pi_save_key /*pi_save_key*/.
            run pi_save_fields /*pi_save_fields*/.

            /* ix_p27_add_ext_admdra_cartao_cr_comis */
            run pi_vld_ext_admdra_cartao_cr_comis /*pi_vld_ext_admdra_cartao_cr_comis*/.

            /* ix_p30_add_ext_admdra_cartao_cr_comis */
            assign v_log_save_ok = yes.
        end /* do save_block */.
    end /* repeat wait_block */.
    assign v_rec_table    = recid(ext_admdra_cartao_cr_comis)
           v_rec_ext_admdra_cartao_cr_comis = recid(ext_admdra_cartao_cr_comis).
end /* repeat main_block */.

hide frame f_adc_03_ext_admdra_cartao_cr_comis.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_save_key
** Descricao.............: pi_save_key
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: tech493
** Alterado em...........: 23/01/2003 10:24:43
*****************************************************************************/
PROCEDURE pi_save_key:

    assign_block:
    do on error undo assign_block, return error:
        find b_ext_admdra_cartao_cr_comis_add no-lock
             where b_ext_admdra_cartao_cr_comis_add.cod_admdra_cartao_cr = admdra_cartao_cr.cod_admdra_cartao_cr
               and b_ext_admdra_cartao_cr_comis_add.num_faixa = input frame f_adc_03_ext_admdra_cartao_cr_comis ext_admdra_cartao_cr_comis.num_faixa /*cl_key_add of b_ext_admdra_cartao_cr_comis_add*/ no-error.
        if  avail b_ext_admdra_cartao_cr_comis_add
        then do:
            if  recid(b_ext_admdra_cartao_cr_comis_add) <> recid(ext_admdra_cartao_cr_comis)
            then do:
                /* &1 j† existente ! */
                run pi_messages (input "show",
                                 input 1,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "Item Tabela Progressiva Impost")) /*msg_1*/.
                undo assign_block, return error.
            end /* if */.
        end /* if */.
        else do:
            do with frame f_adc_03_ext_admdra_cartao_cr_comis:
            end.
            assign input frame f_adc_03_ext_admdra_cartao_cr_comis ext_admdra_cartao_cr_comis.num_faixa.
        end /* else */.
    end /* do assign_block */.
END PROCEDURE. /* pi_save_key */
/*****************************************************************************
** Procedure Interna.....: pi_save_fields
** Descricao.............: pi_save_fields
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre18856
** Alterado em...........: 18/04/2001 14:10:53
*****************************************************************************/
PROCEDURE pi_save_fields:

    assign_block:
    do on error undo assign_block, return error:
        do with frame f_adc_03_ext_admdra_cartao_cr_comis:
        end.
        assign input frame f_adc_03_ext_admdra_cartao_cr_comis ext_admdra_cartao_cr_comis.num_parc_ini
               input frame f_adc_03_ext_admdra_cartao_cr_comis ext_admdra_cartao_cr_comis.num_parc_fim
               input frame f_adc_03_ext_admdra_cartao_cr_comis ext_admdra_cartao_cr_comis.val_perc_comis.
        assign v_wgh_focus = ?.
    end /* do assign_block */.
END PROCEDURE. /* pi_save_fields */
/*****************************************************************************
** Procedure Interna.....: pi_copy_disp_fields
** Descricao.............: pi_copy_disp_fields
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: gilsinei
** Alterado em...........: 07/11/1996 17:14:10
** Gerado por............: rovina
*****************************************************************************/
PROCEDURE pi_copy_disp_fields:

    find b_ext_admdra_cartao_cr_comis_cop where recid(b_ext_admdra_cartao_cr_comis_cop) = v_rec_table no-lock no-error.
    assign 
           ext_admdra_cartao_cr_comis.num_parc_ini = b_ext_admdra_cartao_cr_comis_cop.num_parc_ini
           ext_admdra_cartao_cr_comis.num_parc_fim   = b_ext_admdra_cartao_cr_comis_cop.num_parc_fim
           ext_admdra_cartao_cr_comis.val_perc_comis          = b_ext_admdra_cartao_cr_comis_cop.val_perc_comis.

    /* ix_i15_add_ext_admdra_cartao_cr_comis */
    display ext_admdra_cartao_cr_comis.num_parc_ini
            ext_admdra_cartao_cr_comis.num_parc_fim
            ext_admdra_cartao_cr_comis.val_perc_comis
            with frame f_adc_03_ext_admdra_cartao_cr_comis.
    display with frame f_adc_03_ext_admdra_cartao_cr_comis.
    /* ix_i20_add_ext_admdra_cartao_cr_comis */
END PROCEDURE. /* pi_copy_disp_fields */
/*****************************************************************************
** Procedure Interna.....: pi_vld_ext_admdra_cartao_cr_comis
** Descricao.............: pi_vld_ext_admdra_cartao_cr_comis
** Criado por............: rafael
** Criado em.............: 30/07/1996 11:04:38
** Alterado por..........: Rafael
** Alterado em...........: 16/05/1997 16:34:35
** Gerado por............: rovina
*****************************************************************************/
PROCEDURE pi_vld_ext_admdra_cartao_cr_comis:

    if  ext_admdra_cartao_cr_comis.num_parc_ini > ext_admdra_cartao_cr_comis.num_parc_fim
    then do:
        /* Valor inicial maior/igual valor final na faixa. */
        run pi_messages (input "show",
                         input 2885,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2885*/.
        assign v_wgh_focus = ext_admdra_cartao_cr_comis.num_parc_ini:handle in frame f_adc_03_ext_admdra_cartao_cr_comis.
        return error.
    end /* if */.

END PROCEDURE. /* pi_vld_ext_admdra_cartao_cr_comis */

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

    assign c_prg_msg = "messages/"
                     + string(trunc(i_msg / 1000,0),"99")
                     + "/msg"
                     + string(i_msg, "99999").

    if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do:
        message "Mensagem nr. " i_msg "!!!" skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p") (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/********************  End of add_ext_admdra_cartao_cr_comis ********************/
