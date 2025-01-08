/*****************************************************************************
** Programa..............: Seleá∆o de Estabelecimento
** Nome Externo..........: esp/acr/esacr028a.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 10/12/2009
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_estabelecimento_empresa no-undo like estabelecimento
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_nom_razao_social             as character format "x(40)" label "Raz∆o Social" column-label "Raz∆o Social"
    field ttv_log_selec                    as logical format "Sim/N∆o" initial no column-label "Gera"
    index tt_cod_estab                     is primary unique
          tta_cod_estab                    ascending.

/********************** Temporary Table Definition End **********************/

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
def shared var c_cod_estab_selec
    as character
    format "x(2000)":U
    view-as editor max-chars 2000
    size 30 by 1
    bgcolor 15 font 2
    label "Selecionados"
    column-label "Selecionados"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_cont
    as integer
    format ">,>>9":U
    initial 0
    no-undo.
def var v_num_contador
    as integer
    format ">>>>,>>9":U
    initial 0
    no-undo.
def var v_num_lin
    as integer
    format ">>>>,>>9":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_row_a
    as integer
    format ">>>,>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_num_select_row                 as integer         no-undo. /*local*/


/************************** Variable Definition End *************************/

/************************** Query Definition Begin **************************/

def query qr_estabelecimento_selec_espec
    for tt_estabelecimento_empresa
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_estabelecimento_selec_espec query qr_estabelecimento_selec_espec display 
    tt_estabelecimento_empresa.tta_cod_estab
    width-chars 03.00
        column-label "Est"
    tt_estabelecimento_empresa.tta_nom_pessoa
    width-chars 40.00
        column-label "Nome"
    tt_estabelecimento_empresa.tta_cod_empresa
    width-chars 03.00
        column-label "Emp"
    tt_estabelecimento_empresa.tta_nom_razao_social
    width-chars 40.00
        column-label "Raz∆o Social"
    with separators multiple 
         size 66.29 by 07.00
         font 1
         bgcolor 15
         title "Estabelecimentos".


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
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
def button bt_nenhum
    label "Nenhum"
    tooltip "Desmarca Todas Ocorràncias"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_todos
    label "Todos"
    tooltip "Marca Todas Ocorràncias"
    size 1 by 1.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_estabelecimento_selec_espec
    as character
    initial "Por Estabelecimento"
    view-as radio-set Horizontal
    radio-buttons "Por Estabelecimento", "Por Estabelecimento","Por Raz∆o Social", "Por Raz∆o Social","Por Empresa", "Por Empresa"
     /*l_por_estabelecimento*/ /*l_por_estabelecimento*/ /*l_por_razao_social*/ /*l_por_razao_social*/ /*l_por_empresa*/ /*l_por_empresa*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_01_estabelecimento_selec_espec
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 11.08 col 02.00 bgcolor 7 
    rt_001
         at row 01.21 col 02.00 bgcolor 15 
    rs_estabelecimento_selec_espec
         at row 01.38 col 04.00
         help "" no-label
    br_estabelecimento_selec_espec
         at row 02.33 col 02.00
    bt_todos
         at row 09.50 col 03.57 font ?
         help "Marca Todas Ocorràncias"
    bt_nenhum
         at row 09.50 col 15.57 font ?
         help "Desmarca Todas Ocorràncias"
    bt_ok
         at row 11.29 col 03.00 font ?
         help "OK"
    bt_can
         at row 11.29 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 69.72 by 12.92 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Seleá∆o de Estabelecimentos".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars       in frame f_dlg_01_estabelecimento_selec_espec = 10.00
           bt_can:height-chars      in frame f_dlg_01_estabelecimento_selec_espec = 01.00
           bt_nenhum:width-chars    in frame f_dlg_01_estabelecimento_selec_espec = 10.00
           bt_nenhum:height-chars   in frame f_dlg_01_estabelecimento_selec_espec = 01.00
           bt_ok:width-chars        in frame f_dlg_01_estabelecimento_selec_espec = 10.00
           bt_ok:height-chars       in frame f_dlg_01_estabelecimento_selec_espec = 01.00
           bt_todos:width-chars     in frame f_dlg_01_estabelecimento_selec_espec = 10.00
           bt_todos:height-chars    in frame f_dlg_01_estabelecimento_selec_espec = 01.00
           rt_001:width-chars       in frame f_dlg_01_estabelecimento_selec_espec = 66.29
           rt_001:height-chars      in frame f_dlg_01_estabelecimento_selec_espec = 01.13
           rt_cxcf:width-chars      in frame f_dlg_01_estabelecimento_selec_espec = 66.29
           rt_cxcf:height-chars     in frame f_dlg_01_estabelecimento_selec_espec = 01.42
           rt_mold:width-chars      in frame f_dlg_01_estabelecimento_selec_espec = 66.29
           rt_mold:height-chars     in frame f_dlg_01_estabelecimento_selec_espec = 09.50.
    /* set private-data for the help system */
    assign rs_estabelecimento_selec_espec:private-data in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000000000":U
           br_estabelecimento_selec_espec:private-data in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000000000":U
           bt_todos:private-data                       in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000013336":U
           bt_nenhum:private-data                      in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000013335":U
           bt_ok:private-data                          in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000010721":U
           bt_can:private-data                         in frame f_dlg_01_estabelecimento_selec_espec = "HLP=000011050":U
           frame f_dlg_01_estabelecimento_selec_espec:private-data                                   = "HLP=000000000".

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_nenhum IN FRAME f_dlg_01_estabelecimento_selec_espec
DO:

    if  can-find( first tt_estabelecimento_empresa )
    and br_estabelecimento_selec_espec:num-selected-rows > 0 then do:
        assign v_log_method = browse br_estabelecimento_selec_espec:deselect-rows().
    end.


END. /* ON CHOOSE OF bt_nenhum IN FRAME f_dlg_01_estabelecimento_selec_espec */

ON CHOOSE OF bt_todos IN FRAME f_dlg_01_estabelecimento_selec_espec
DO:

    if  not can-find(first tt_estabelecimento_empresa ) then
        return no-apply. 

    assign v_log_method = session:set-wait-state('general')
           v_num_lin = br_estabelecimento_selec_espec:num-iterations.
    br_estabelecimento_selec_espec:deselect-rows().
    apply "home" to br_estabelecimento_selec_espec in frame f_dlg_01_estabelecimento_selec_espec.
    do  v_num_cont = 1 to v_num_lin:
        if  br_estabelecimento_selec_espec:is-row-selected(v_num_lin) then leave.
        if  br_estabelecimento_selec_espec:select-row(v_num_cont) then.
        if  v_num_cont mod v_num_lin = 0 then do:
            apply "page-down" to br_estabelecimento_selec_espec in frame f_dlg_01_estabelecimento_selec_espec.
            assign v_num_cont = 0.
        end.  
    end.  
    assign v_log_method = session:set-wait-state('').

END. /* ON CHOOSE OF bt_todos IN FRAME f_dlg_01_estabelecimento_selec_espec */

ON VALUE-CHANGED OF rs_estabelecimento_selec_espec IN FRAME f_dlg_01_estabelecimento_selec_espec
DO:

    run pi_open_estabelecimento_selec_espec.
END. /* ON VALUE-CHANGED OF rs_estabelecimento_selec_espec IN FRAME f_dlg_01_estabelecimento_selec_espec */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON WINDOW-CLOSE OF FRAME f_dlg_01_estabelecimento_selec_espec
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_estabelecimento_selec_espec */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
assign frame f_dlg_01_estabelecimento_selec_espec:title = frame f_dlg_01_estabelecimento_selec_espec:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */

pause 0 before-hide.
view frame f_dlg_01_estabelecimento_selec_espec.

main_block:
do on endkey undo main_block, leave main_block
                on error undo main_block, leave main_block.

    /* ix_p10_fnc_estabelecimento_selec_espec */
    enable rs_estabelecimento_selec_espec
           br_estabelecimento_selec_espec
           bt_ok
           bt_can
           bt_todos
           bt_nenhum
           with frame f_dlg_01_estabelecimento_selec_espec.

    if not retry 
    then do:
        for each tt_estabelecimento_empresa:
            delete tt_estabelecimento_empresa.
        end.    

        for each estabelecimento no-lock
            where estabelecimento.cod_empresa = v_cod_empres_usuar:
            find tt_estabelecimento_empresa no-lock 
                  where tt_estabelecimento_empresa.tta_cod_estab = estabelecimento.cod_estab no-error. 
            if not avail tt_estabelecimento_empresa then do:         
                create tt_estabelecimento_empresa.
                assign tt_estabelecimento_empresa.tta_cod_estab        = estabelecimento.cod_estab    
                       tt_estabelecimento_empresa.tta_nom_pessoa       = estabelecimento.nom_pessoa
                       tt_estabelecimento_empresa.tta_cod_empresa      = estabelecimento.cod_empresa.
            end. 

            find emscad.empresa no-lock
                 where empresa.cod_empresa = estabelecimento.cod_empresa no-error.
            if avail empresa then          
               assign tt_estabelecimento_empresa.tta_nom_razao_social = empresa.nom_razao_social.

        end.

        run pi_open_estabelecimento_selec_espec.      

        if c_cod_estab_selec = " "
        or c_cod_estab_selec = ? then
            apply "choose" to bt_todos in frame f_dlg_01_estabelecimento_selec_espec.
        else do:
            do v_num_contador = 1 to num-entries(c_cod_estab_selec):
                find tt_estabelecimento_empresa no-lock
                    where tt_estabelecimento_empresa.tta_cod_estab = entry(v_num_contador, c_cod_estab_selec) no-error.
                reposition qr_estabelecimento_selec_espec to recid(recid(tt_estabelecimento_empresa)) no-error.

                if avail tt_estabelecimento_empresa then do:
                   if  br_estabelecimento_selec_espec:select-focused-row() then.
                end.
            end.
            find first tt_estabelecimento_empresa no-lock no-error.
            reposition qr_estabelecimento_selec_espec to recid(recid(tt_estabelecimento_empresa)) no-error.    
        end.
    end.            

    wait-for go of frame f_dlg_01_estabelecimento_selec_espec.

    assign v_num_select_row = browse br_estabelecimento_selec_espec:num-selected-rows.

    if  v_num_select_row <> 0 then do:
        assign c_cod_estab_selec = " ".
        do v_num_row_a = 1 to v_num_select_row:
            assign v_log_method = browse br_estabelecimento_selec_espec:fetch-selected-row(v_num_row_a).
            if c_cod_estab_selec = " " then
                assign c_cod_estab_selec = tt_estabelecimento_empresa.tta_cod_estab.
            else       
                assign c_cod_estab_selec = c_cod_estab_selec + "," + tt_estabelecimento_empresa.tta_cod_estab.                
        end.        
    end.
    else do:
       assign c_cod_estab_selec = " ".
    end.

    assign v_log_method = session:set-wait-state('').

end /* do main_block */.

hide frame f_dlg_01_estabelecimento_selec_espec.

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_estabelecimento_selec_espec
** Descricao.............: pi_open_estabelecimento_selec_espec
** Criado por............: bre18490
** Criado em.............: 21/06/1999 14:14:20
** Alterado por..........: bre18490
** Alterado em...........: 28/06/1999 09:32:49
*****************************************************************************/
PROCEDURE pi_open_estabelecimento_selec_espec:

    /************************* Variable Definition Begin ************************/

    def var c_cod_estab_selec_aux
        as character
        format "x(2000)":U
        view-as editor max-chars 2000
        size 30 by 1
        bgcolor 15 font 2
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_select_row = browse br_estabelecimento_selec_espec:num-selected-rows.

    if  v_num_select_row <> 0 then do:
        assign c_cod_estab_selec_aux = " ".
        do v_num_row_a = 1 to v_num_select_row:
            assign v_log_method = browse br_estabelecimento_selec_espec:fetch-selected-row(v_num_row_a).
            if c_cod_estab_selec_aux = " " then
                assign c_cod_estab_selec_aux = tt_estabelecimento_empresa.tta_cod_estab.
            else       
                assign c_cod_estab_selec_aux = c_cod_estab_selec_aux + "," + tt_estabelecimento_empresa.tta_cod_estab.                
        end.        
    end.
    else
        assign c_cod_estab_selec_aux = " ".
    assign v_log_method = session:set-wait-state('').

    /* case_block: */
    case input frame f_dlg_01_estabelecimento_selec_espec rs_estabelecimento_selec_espec:
        when "Por Estabelecimento" /*l_por_estabelecimento*/  then
            cod_estab_block:
            do:
                open query qr_estabelecimento_selec_espec
                    for each tt_estabelecimento_empresa
                        by tt_estabelecimento_empresa.tta_cod_estab.
            end /* do cod_estab_block */.
        when "Por Raz∆o Social" /*l_por_razao_social*/  then
            des_estab_block:
            do:
                open query qr_estabelecimento_selec_espec
                    for each tt_estabelecimento_empresa
                        by tt_estabelecimento_empresa.tta_nom_razao_social.
            end /* do des_estab_block */.
        when "Por Empresa" /*l_por_empresa*/  then
            empresa_block:
            do:
                open query qr_estabelecimento_selec_espec
                    for each tt_estabelecimento_empresa
                        by tt_estabelecimento_empresa.tta_cod_empresa.
            end /* do empresa_block */.
    end /* case case_block */.

    if c_cod_estab_selec_aux <> " " then do:
        do v_num_contador = 1 to num-entries(c_cod_estab_selec_aux):
            find tt_estabelecimento_empresa no-lock
                 where tt_estabelecimento_empresa.tta_cod_estab = entry(v_num_contador, c_cod_estab_selec_aux) no-error.
            reposition qr_estabelecimento_selec_espec to recid(recid(tt_estabelecimento_empresa)) no-error.
            if  br_estabelecimento_selec_espec:select-focused-row() then.
        end.
    end.
END PROCEDURE. /* pi_open_estabelecimento_selec_espec */

/************************** Internal Procedure End **************************/

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
/******************  End of fnc_estabelecimento_selec_espec *****************/
