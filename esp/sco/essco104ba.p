/*****************************************************************************
** Programa..............: esp/sco/essco104ba.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 15/10/2008
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

/************************** Buffer Definition Begin *************************/

def buffer b_ext_admdra_cartao_cr_comis
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
def var v_cod_dat_type
    as character
    format "x(8)"
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
def var v_cod_final
    as character
    format "x(8)"
    initial ?
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
    label "Grupo Usu†rios"
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
def var v_rec_table_child
    as recid
    format ">>>>>>9"
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9"
    no-undo.
def new global shared var v_rec_admdra_cartao_cr
    as recid
    format ">>>>>>9"
    initial ?
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

def query qr_bac_ext_admdra_cartao_cr_comis
    for ext_admdra_cartao_cr_comis
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_bac_ext_admdra_cartao_cr_comis query qr_bac_ext_admdra_cartao_cr_comis display 
    ext_admdra_cartao_cr_comis.num_faixa
    width-chars 04.00
        column-label "Faixa"
    ext_admdra_cartao_cr_comis.num_parc_ini
    width-chars 10.00
        column-label "Parcela Inicial"
    ext_admdra_cartao_cr_comis.num_parc_fim
    width-chars 10.00
        column-label "Parcela Final"
    ext_admdra_cartao_cr_comis.val_perc_comis
    width-chars 05.00
        column-label "%Comis"
    with no-box separators single 
         size 80.86 by 07.00
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_cxcl
    size 1 by 1
    edge-pixels 2.
def rectangle rt_key
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
def button bt_era3
    label "Elimina"
    tooltip "Elimina"
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
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_bac_ext_admdra_cartao_cr
    as character
    initial "Por Faixa"
    view-as radio-set Horizontal
    radio-buttons "Por Faixa", "Por Faixa"
     /*l_por_faixa*/ /*l_por_faixa*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_bac_03_ext_admdra_cartao_cr_comis
    rt_key
         at row 01.21 col 02.00
    rt_cxcf
         at row 13.75 col 02.00 bgcolor 7 
    rt_cxcl
         at row 03.54 col 02.00 bgcolor 15 
    admdra_cartao_cr.cod_admdra_cartao_cr
         at row 02 col 23.00 colon-aligned label "Administradora"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    admdra_cartao_cr.nom_abrev
         at row 02 col 35.00 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    rs_bac_ext_admdra_cartao_cr
         at row 03.75 col 03.00
         help "" no-label
    br_bac_ext_admdra_cartao_cr_comis
         at row 04.88 col 02.00
    bt_add2
         at row 12.25 col 02.00 font ?
         help "Inclui"
    bt_mod2
         at row 12.25 col 14.00 font ?
         help "Modifica"
    bt_era3
         at row 12.25 col 26.00 font ?
         help "Elimina"
    bt_ok
         at row 13.96 col 03.00 font ?
         help "OK"
    bt_can
         at row 13.96 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 84.29 by 15.58 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Comiss∆o Administradora por Faixa".
    /* adjust size of objects in this frame */
    assign bt_add2:width-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 10.00
           bt_add2:height-chars in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.00
           bt_can:width-chars   in frame f_bac_03_ext_admdra_cartao_cr_comis = 10.00
           bt_can:height-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.00
           bt_era3:width-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 10.00
           bt_era3:height-chars in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.00
           bt_mod2:width-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 10.00
           bt_mod2:height-chars in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.00
           bt_ok:width-chars    in frame f_bac_03_ext_admdra_cartao_cr_comis = 10.00
           bt_ok:height-chars   in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.00
           rt_cxcf:width-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 80.86
           rt_cxcf:height-chars in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.42
           rt_cxcl:width-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 80.86
           rt_cxcl:height-chars in frame f_bac_03_ext_admdra_cartao_cr_comis = 01.21
           rt_key:width-chars   in frame f_bac_03_ext_admdra_cartao_cr_comis = 80.86
           rt_key:height-chars  in frame f_bac_03_ext_admdra_cartao_cr_comis = 02.21.
    /* set private-data for the help system */
    assign admdra_cartao_cr.cod_admdra_cartao_cr:private-data in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000019077":U
           admdra_cartao_cr.nom_abrev:private-data in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000019069":U
           rs_bac_ext_admdra_cartao_cr:private-data                       in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000019044":U
           br_bac_ext_admdra_cartao_cr_comis:private-data                       in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000019044":U
           bt_add2:private-data                                             in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000010825":U
           bt_mod2:private-data                                             in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000010827":U
           bt_era3:private-data                                             in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000010802":U
           bt_ok:private-data                                               in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000010721":U
           bt_can:private-data                                              in frame f_bac_03_ext_admdra_cartao_cr_comis = "HLP=000011050":U
           frame f_bac_03_ext_admdra_cartao_cr_comis:private-data                                                        = "HLP=000019044".



{include/i_fclfrm.i f_bac_03_ext_admdra_cartao_cr_comis }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON DEL OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  bt_era3:sensitive in frame f_bac_03_ext_admdra_cartao_cr_comis
    then do:
        apply "choose" to bt_era3 in frame f_bac_03_ext_admdra_cartao_cr_comis.
    end /* if */.

END. /* ON DEL OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON INS OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  bt_add2:sensitive in frame f_bac_03_ext_admdra_cartao_cr_comis
    then do:
        apply "choose" to bt_add2 in frame f_bac_03_ext_admdra_cartao_cr_comis.
    end /* if */.

END. /* ON INS OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON VALUE-CHANGED OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  avail ext_admdra_cartao_cr_comis
    then do:
        find first b_ext_admdra_cartao_cr_comis
            where b_ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr = ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr
            and   b_ext_admdra_cartao_cr_comis.num_faixa       = ext_admdra_cartao_cr_comis.num_faixa + 1
            no-lock no-error.
        if  avail b_ext_admdra_cartao_cr_comis
        then do:
            disable bt_era3
                    with frame f_bac_03_ext_admdra_cartao_cr_comis.    
        end /* if */.
        else do:
            enable bt_era3
                   with frame f_bac_03_ext_admdra_cartao_cr_comis.
        end /* else */.
    end /* if */.
END. /* ON VALUE-CHANGED OF br_bac_ext_admdra_cartao_cr_comis IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_add2 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    assign v_rec_admdra_cartao_cr = recid(admdra_cartao_cr)
           v_rec_ext_admdra_cartao_cr_comis        = recid(ext_admdra_cartao_cr_comis).
    if  search("esp/sco/essco104da.r") = ? and search("esp/sco/essco104da.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "esp/sco/essco104da.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run esp/sco/essco104da.p /*prg_add_ext_admdra_cartao_cr_comis*/.
    if  v_rec_ext_admdra_cartao_cr_comis <> ?
    then do:
        run pi_open_bac_ext_admdra_cartao_cr_comis /*pi_open_bac_ext_admdra_cartao_cr_comis*/.
        reposition qr_bac_ext_admdra_cartao_cr_comis to recid v_rec_ext_admdra_cartao_cr_comis no-error.
    end /* if */.

END. /* ON CHOOSE OF bt_add2 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_can IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_era3 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  avail ext_admdra_cartao_cr_comis
    then do:
        assign v_rec_ext_admdra_cartao_cr_comis = recid(ext_admdra_cartao_cr_comis).
        if  search("esp/sco/essco104ha.r") = ? and search("esp/sco/essco104ha.p") = ? then do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "esp/sco/essco104ha.p"
                   view-as alert-box error buttons ok.
            return.
        end.
        else
            run esp/sco/essco104ha.p.
        if  v_rec_ext_admdra_cartao_cr_comis = ?
        then do:
            get next qr_bac_ext_admdra_cartao_cr_comis no-lock.
            assign v_rec_ext_admdra_cartao_cr_comis = recid(ext_admdra_cartao_cr_comis).
            run pi_open_bac_ext_admdra_cartao_cr_comis /*pi_open_bac_ext_admdra_cartao_cr_comis*/.
            if  v_rec_ext_admdra_cartao_cr_comis <> ?
            then do:
                reposition qr_bac_ext_admdra_cartao_cr_comis to recid v_rec_ext_admdra_cartao_cr_comis.
            end /* if */.
            disable bt_era3
                    with frame f_bac_03_ext_admdra_cartao_cr_comis.    

        end /* if */.
    end /* if */.

END. /* ON CHOOSE OF bt_era3 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_mod2 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  avail ext_admdra_cartao_cr_comis
    then do:
        assign v_rec_ext_admdra_cartao_cr_comis    = recid(ext_admdra_cartao_cr_comis)
               v_rec_table_child = recid(ext_admdra_cartao_cr_comis).
        if  search("esp/sco/essco104fa.r") = ? and search("esp/sco/essco104fa.p") = ? then do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "esp/sco/essco104fa.p"
                   view-as alert-box error buttons ok.
            return.
        end.
        else
            run esp/sco/essco104fa.p /*prg_mod_ext_admdra_cartao_cr_comis*/.
        run pi_open_bac_ext_admdra_cartao_cr_comis /*pi_open_bac_ext_admdra_cartao_cr_comis*/.
        if  v_rec_ext_admdra_cartao_cr_comis = ?
        then do:
            reposition qr_bac_ext_admdra_cartao_cr_comis to recid v_rec_table_child no-error.
        end /* if */.
        else do:
            reposition qr_bac_ext_admdra_cartao_cr_comis to recid v_rec_ext_admdra_cartao_cr_comis no-error.
        end /* else */.
    end /* if */.
END. /* ON CHOOSE OF bt_mod2 IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON CHOOSE OF bt_ok IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    if  avail admdra_cartao_cr
    then do:
        assign v_rec_admdra_cartao_cr = recid(admdra_cartao_cr).
    end /* if */.
    if  avail ext_admdra_cartao_cr_comis
    then do:
        assign v_rec_ext_admdra_cartao_cr_comis = recid(ext_admdra_cartao_cr_comis).
    end /* if */.

END. /* ON CHOOSE OF bt_ok IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON VALUE-CHANGED OF rs_bac_ext_admdra_cartao_cr IN FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    assign v_cod_dat_type = "integer"
           v_cod_format   = ">,>>9":U
           v_nom_attrib   = "Faixa Imposto Retido"
           v_cod_initial  = string(0)
           v_cod_final  = string(9999).

    run pi_open_bac_ext_admdra_cartao_cr_comis /*pi_open_bac_ext_admdra_cartao_cr_comis*/.

END. /* ON VALUE-CHANGED OF rs_bac_ext_admdra_cartao_cr IN FRAME f_bac_03_ext_admdra_cartao_cr_comis */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON ENTRY OF FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    apply "value-changed" to rs_bac_ext_admdra_cartao_cr in frame f_bac_03_ext_admdra_cartao_cr_comis.
    apply "value-changed" to br_bac_ext_admdra_cartao_cr_comis in frame f_bac_03_ext_admdra_cartao_cr_comis.

END. /* ON ENTRY OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON ENDKEY OF FRAME f_bac_03_ext_admdra_cartao_cr_comis
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

END. /* ON ENDKEY OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON END-ERROR OF FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    assign v_rec_admdra_cartao_cr = ?
           v_rec_ext_admdra_cartao_cr_comis        = ?.

END. /* ON END-ERROR OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON HELP OF FRAME f_bac_03_ext_admdra_cartao_cr_comis ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON RIGHT-MOUSE-DOWN OF FRAME f_bac_03_ext_admdra_cartao_cr_comis ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON RIGHT-MOUSE-UP OF FRAME f_bac_03_ext_admdra_cartao_cr_comis ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */

ON WINDOW-CLOSE OF FRAME f_bac_03_ext_admdra_cartao_cr_comis
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_bac_03_ext_admdra_cartao_cr_comis */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/



/* tratamento do titulo e vers∆o */
assign frame f_bac_03_ext_admdra_cartao_cr_comis:title = frame f_bac_03_ext_admdra_cartao_cr_comis:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

assign br_bac_ext_admdra_cartao_cr_comis:num-locked-columns in frame f_bac_03_ext_admdra_cartao_cr_comis = 0.

pause 0 before-hide.

/* ix_p02_bas_ext_admdra_cartao_cr_comis */

view frame f_bac_03_ext_admdra_cartao_cr_comis.

assign v_rec_table    = v_rec_admdra_cartao_cr
       v_log_repeat   = yes.

find admdra_cartao_cr where recid(admdra_cartao_cr) = v_rec_table no-lock no-error.
if  not avail admdra_cartao_cr
then do:
    find first admdra_cartao_cr no-lock no-error.
end /* if */.
if  not avail admdra_cartao_cr
then do:
    message "N∆o existem ocorràncias na tabela." /*l_no_record*/ 
           view-as alert-box warning buttons ok.
    return.
end /* if */.
else do:
    assign v_rec_table = recid(admdra_cartao_cr).
end /* else */.
/* ix_p05_bas_ext_admdra_cartao_cr_comis */

main_block:
repeat while v_log_repeat on error undo main_block, retry main_block:
    /* ix_p10_bas_ext_admdra_cartao_cr_comis */
    assign v_log_repeat = no.
    find admdra_cartao_cr where recid(admdra_cartao_cr) = v_rec_table no-lock.

    display admdra_cartao_cr.cod_admdra_cartao_cr
            admdra_cartao_cr.nom_abrev
            rs_bac_ext_admdra_cartao_cr
            with frame f_bac_03_ext_admdra_cartao_cr_comis.

    enable rs_bac_ext_admdra_cartao_cr
           br_bac_ext_admdra_cartao_cr_comis
           bt_add2
           bt_mod2
           bt_era3
           bt_ok
           bt_can
           with frame f_bac_03_ext_admdra_cartao_cr_comis.

    b_habilita:
    do with frame f_bac_03_ext_admdra_cartao_cr_comis:
       if  index(program-name(2), "esp/sco/essco104da.p") <> 0
       then do:
            assign bt_add2:sensitive = no
                   bt_mod2:sensitive = no
                   bt_era3:sensitive = no.
        end /* if */.
    end /* do b_habilita */.

    wait-for go of frame f_bac_03_ext_admdra_cartao_cr_comis.
    /* ix_p25_bas_ext_admdra_cartao_cr_comis */
end /* repeat main_block */.
/* ix_p30_bas_ext_admdra_cartao_cr_comis */
hide frame f_bac_03_ext_admdra_cartao_cr_comis.
/* ix_p40_bas_ext_admdra_cartao_cr_comis */

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_bac_ext_admdra_cartao_cr_comis
** Descricao.............: pi_open_bac_ext_admdra_cartao_cr_comis
** Criado por............: rafael
** Criado em.............: 30/07/1996 10:48:24
** Alterado por..........: Rafael
** Alterado em...........: 05/06/1997 14:25:31
** Gerado por............: rovina
*****************************************************************************/
PROCEDURE pi_open_bac_ext_admdra_cartao_cr_comis:

    open query qr_bac_ext_admdra_cartao_cr_comis for
        each ext_admdra_cartao_cr_comis no-lock
        where ext_admdra_cartao_cr_comis.cod_admdra_cartao_cr = admdra_cartao_cr.cod_admdra_cartao_cr
        and   ext_admdra_cartao_cr_comis.num_faixa      >= integer(v_cod_initial)
        and   ext_admdra_cartao_cr_comis.num_faixa      <= integer(v_cod_final).


END PROCEDURE. /* pi_open_bac_ext_admdra_cartao_cr_comis */

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
/********************  End of bas_ext_admdra_cartao_cr_comis ********************/
