/*****************************************************************************
** Programa..............: frm_seg_ccusto_user
** Versao................:  1.00.00.000
** Nome Externo..........: esp/es0513.p
** Criado por............: Fabiano
** Criado em.............: 18/03/2008
*****************************************************************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_grp_usuar 
    as character 
    format "x(10)":U 
    label "Grupo Usu†rios" 
    column-label "Grupo Usu†rios" 
    no-undo. 
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)"
    no-undo.
def var v_num_row_a
    as integer
    format ">>>,>>9"
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9"
    no-undo.
def var v_rec_table as recid.
def var v_cod_grp_usuar like v_cod_grp_usuar no-undo.
def new global shared var v_rec_grp_usuar
    as recid
    format ">>>>>>9":U
    no-undo.

/*********************** Temp-Table Definition Begin ************************/
def temp-table tt_ccusto like emscad.ccusto.

/************************** Query Definition Begin **************************/

def query qr_ccusto
    for tt_ccusto
    scrolling.

def query qr_segur_ccusto
    for segur_ccusto, emscad.ccusto
    scrolling.

/************************** Browse Definition Begin *************************/

def browse br_ccusto query qr_ccusto display 
    tt_ccusto.cod_ccusto
    width-chars 10.00
        column-label "CCusto"
    tt_ccusto.des_tit_ctbl
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "CCustos Dispon°veis".

def browse br_segur_ccusto query qr_segur_ccusto display 
    segur_ccusto.cod_ccusto
    width-chars 10.00
        column-label "CCusto"
    ccusto.des_tit_ctbl
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "CCusto Com Permiss∆o".

/************************ Rectangle Definition Begin ************************/

def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
        tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_ins_frm
    label ">"
        tooltip "Insere Linha"
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
    size 1 by 1.
def button bt_ok
    label "OK"
        tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_outdent
    label "<"
        tooltip ""
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
    size 1 by 1.
def button bt_ent_30681
    label "Loc"
    tooltip "Entra"
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
    size 4 by .88.
def button bt_zoo_30681
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_atualizar_grupos_seguranca
    rt_cxcf
         at row 13.17 col 02.00 bgcolor 7 
    emscad.empresa.cod_empresa
         at row 01.67 col 18.00 colon-aligned label "Empresa"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    emscad.empresa.nom_razao_social
         at row 01.67 col 23.00 colon-aligned no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_grp_usuar
         at row 02.67 col 18.00 colon-aligned label "Grupo Usu†rio"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30681
         at row 02.67 col 33.14
    bt_ent_30681
         at row 02.67 col 37.14
    grp_usuar.des_grp_usuar
         at row 02.67 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    br_ccusto
         at row 04.50 col 02.00
         help "CCustos Dispon°veis"
    br_segur_ccusto
         at row 04.50 col 49.00
         help "CCustos com Permiss∆o"
    bt_ins_frm
         at row 06.50 col 43.00 font ?
         help "Insere Linha"
    bt_outdent
         at row 09.50 col 43.00 font ?
    bt_ok
         at row 13.38 col 03.00 font ?
         help "OK"
    bt_can
         at row 13.38 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 15.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relaciona Usu†rio ao CCusto - ES0513".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars      in frame f_dlg_03_atualizar_grupos_seguranca = 10.00
           bt_can:height-chars     in frame f_dlg_03_atualizar_grupos_seguranca = 01.00
           bt_ins_frm:width-chars  in frame f_dlg_03_atualizar_grupos_seguranca = 04.00
           bt_ins_frm:height-chars in frame f_dlg_03_atualizar_grupos_seguranca = 01.13
           bt_ok:width-chars       in frame f_dlg_03_atualizar_grupos_seguranca = 10.00
           bt_ok:height-chars      in frame f_dlg_03_atualizar_grupos_seguranca = 01.00
           bt_outdent:width-chars  in frame f_dlg_03_atualizar_grupos_seguranca = 04.00
           bt_outdent:height-chars in frame f_dlg_03_atualizar_grupos_seguranca = 01.13
           rt_cxcf:width-chars     in frame f_dlg_03_atualizar_grupos_seguranca = 86.57
           rt_cxcf:height-chars    in frame f_dlg_03_atualizar_grupos_seguranca = 01.42.
    /* set private-data for the help system */
    assign br_segur_ccusto:private-data in frame f_dlg_03_atualizar_grupos_seguranca          = "HLP=000000000":U
           br_ccusto:private-data    in frame f_dlg_03_atualizar_grupos_seguranca        = "HLP=000000000":U
           bt_ins_frm:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009353":U
           bt_outdent:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009731":U
           bt_ok:private-data                     in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000010721":U
           bt_can:private-data                    in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000011050":U
           frame f_dlg_03_atualizar_grupos_seguranca:private-data                              = "HLP=000000000".

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_ins_frm IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find first grp_usuar no-lock
        where  grp_usuar.cod_grp_usuar = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar no-error.
    if not avail grp_usuar then return no-apply.

    table_src_a:
    do v_num_row_a = 1 to browse br_ccusto:num-selected-rows:
        assign v_log_method = browse br_ccusto:fetch-selected-row(v_num_row_a).

        find emscad.ccusto no-lock
            where ccusto.cod_empresa      = tt_ccusto.cod_empresa
              and ccusto.cod_plano_ccusto = tt_ccusto.cod_plano_ccusto
              and ccusto.cod_ccusto       = tt_ccusto.cod_ccusto no-error.

        find segur_ccusto no-lock
             where segur_ccusto.cod_empresa      = ccusto.cod_empresa
               and segur_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
               and segur_ccusto.cod_ccusto       = ccusto.cod_ccusto
               and segur_ccusto.cod_grp_usuar    = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar no-error.
        if  not avail segur_ccusto
        then do:
            create segur_ccusto.
            assign segur_ccusto.cod_empresa      = ccusto.cod_empresa
                   segur_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
                   segur_ccusto.cod_ccusto       = ccusto.cod_ccusto
                   segur_ccusto.cod_grp_usuar    = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar.
        end.

        assign v_log_method = browse br_ccusto:deselect-selected-row(v_num_row_a).
               v_num_row_a  = v_num_row_a - 1.

    end.

    run pi_open_atualizar_grupos_seguranca.

END.

ON CHOOSE OF bt_outdent IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    do v_num_row_a = 1 to browse br_segur_ccusto:num-selected-rows:

        assign v_log_method = browse br_segur_ccusto:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(segur_ccusto).

        find segur_ccusto where recid(segur_ccusto) = v_rec_table exclusive-lock no-error.   
        if  avail segur_ccusto
        then do:
            delete segur_ccusto.
        end.

    end.

    run pi_open_atualizar_grupos_seguranca.

END.


/************************ User Interface Trigger End ************************/

ON WINDOW-CLOSE OF FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    apply "end-error" to self.

END.

ON  CHOOSE OF bt_zoo_30681 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR F5 OF v_cod_grp_usuar IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    run esp/es0512kd.p.
    if  v_rec_grp_usuar <> ? then do:
        find grp_usuar where recid(grp_usuar) = v_rec_grp_usuar no-lock no-error.
        assign v_cod_grp_usuar:screen-value in frame f_dlg_03_atualizar_grupos_seguranca = string(grp_usuar.cod_grp_usuar).

        display grp_usuar.des_grp_usuar
                with frame f_dlg_03_atualizar_grupos_seguranca.

    end.
    apply "entry" to v_cod_grp_usuar in frame f_dlg_03_atualizar_grupos_seguranca.

    run pi_open_atualizar_grupos_seguranca.

end.

ON  CHOOSE OF bt_ent_30681 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR ENTER OF v_cod_grp_usuar IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    find first grp_usuar no-lock
        where  grp_usuar.cod_grp_usuar = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar no-error.
    if  avail  grp_usuar then do:
         display grp_usuar.des_grp_usuar
                 with frame f_dlg_03_atualizar_grupos_seguranca.
    end.
    else do:
        message substitute("&1 inexistente." ,"Grupo de Usu†rio Inexistente")
               view-as alert-box warning buttons ok.
    end.

    run pi_open_atualizar_grupos_seguranca.
    
end.

ON LEAVE OF v_cod_grp_usuar IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:
    find first grp_usuar no-lock
        where  grp_usuar.cod_grp_usuar = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar no-error.
    display grp_usuar.des_grp_usuar when avail grp_usuar
            "" when not avail grp_usuar @ grp_usuar.des_grp_usuar
            with frame f_dlg_03_atualizar_grupos_seguranca.

    run pi_open_atualizar_grupos_seguranca.
END.

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
assign frame f_dlg_03_atualizar_grupos_seguranca:title = frame f_dlg_03_atualizar_grupos_seguranca:title.

find emscad.empresa no-lock
    where empresa.cod_empresa = v_cod_empres_usuar no-error.

pause 0 before-hide.
view frame f_dlg_03_atualizar_grupos_seguranca.
enable all with frame f_dlg_03_atualizar_grupos_seguranca.

disp emscad.empresa.cod_empresa emscad.empresa.nom_razao_social with frame f_dlg_03_atualizar_grupos_seguranca.
disable emscad.empresa.cod_empresa emscad.empresa.nom_razao_social with frame f_dlg_03_atualizar_grupos_seguranca.

for each ccusto no-lock
   where ccusto.cod_empresa      = v_cod_empres_usuar
     and ccusto.cod_plano_ccusto = 'padrao':
   
   if can-find (first estrut_ccusto
                where estrut_ccusto.cod_empresa      = ccusto.cod_empresa
                  and estrut_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
                  and estrut_ccusto.cod_ccusto_pai   = ccusto.cod_ccusto)
   then next.
   else do:
        create tt_ccusto.
        buffer-copy ccusto to tt_ccusto.
   end.
end.

open query qr_ccusto for
     each tt_ccusto no-lock.

main_block:
do transaction on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

    enable br_segur_ccusto
           with frame f_dlg_03_atualizar_grupos_seguranca.
    wait-for go of frame f_dlg_03_atualizar_grupos_seguranca.

end.

hide frame f_dlg_03_atualizar_grupos_seguranca.

return.

/******************************* Main Code End ******************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_atualizar_grupos_seguranca
*****************************************************************************/
PROCEDURE pi_open_atualizar_grupos_seguranca:

        close query qr_segur_ccusto.
        open query qr_segur_ccusto for
            each segur_ccusto no-lock
            where segur_ccusto.cod_empresa      = v_cod_empres_usuar
              and segur_ccusto.cod_plano_ccusto = 'Padrao'
              and segur_ccusto.cod_grp_usuar    = input frame f_dlg_03_atualizar_grupos_seguranca v_cod_grp_usuar,
            first emscad.ccusto 
            where emscad.ccusto.cod_empresa      = segur_ccusto.cod_empresa
              and emscad.ccusto.cod_plano_ccusto = segur_ccusto.cod_plano_ccusto
              and emscad.ccusto.cod_ccusto       = segur_ccusto.cod_ccusto.

END PROCEDURE.
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
/******************  End of fnc_atualizar_grupos_seguranca ******************/
