/*****************************************************************************
** Programa..............: frm_seg_programa
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512zd.p
** Criado por............: Fabiano
** Criado em.............: 30/08/2007
*****************************************************************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def var v_log_method
    as logical
    format "Sim/NÆo"
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
def var v_rec_table
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

/************************** Query Definition Begin **************************/

def query qr_usuar_mestre
    for usuar_mestre
    scrolling.
def query qr_rel-grup-user
    for mgesp.rel-grup-user, usuar_mestre
    scrolling.

/************************** Browse Definition Begin *************************/

def browse br_usuar_mestre query qr_usuar_mestre display 
    usuar_mestre.cod_usuario
    width-chars 10.00
        column-label "Usu rio"
    usuar_mestre.nom_usuar
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "Usu rios Dispon¡veis".

def browse br_rel-grup-user query qr_rel-grup-user display 
    mgesp.rel-grup-user.usuario
    width-chars 10.00
        column-label "Usu rio"
    usuar_mestre.nom_usuar
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "Usu rios Com PermissÆo".

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

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_atualizar_grupos_seguranca
    rt_cxcf
         at row 10.17 col 02.00 bgcolor 7 
    br_usuar_mestre
         at row 01.50 col 02.00
         help "Usu rios Dispon¡veis"
    br_rel-grup-user
         at row 01.50 col 49.00
         help "Usu rios com PermissÆo"
    bt_ins_frm
         at row 03.50 col 43.00 font ?
         help "Insere Linha"
    bt_outdent
         at row 06.50 col 43.00 font ?
    bt_ok
         at row 10.38 col 03.00 font ?
         help "OK"
    bt_can
         at row 10.38 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 12.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Atualiza PermissÆo Or‡amento - ES0512ZD - 1.00.00.001".
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
    assign br_rel-grup-user:private-data in frame f_dlg_03_atualizar_grupos_seguranca          = "HLP=000000000":U
           br_usuar_mestre:private-data    in frame f_dlg_03_atualizar_grupos_seguranca        = "HLP=000000000":U
           bt_ins_frm:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009353":U
           bt_outdent:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009731":U
           bt_ok:private-data                     in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000010721":U
           bt_can:private-data                    in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000011050":U
           frame f_dlg_03_atualizar_grupos_seguranca:private-data                              = "HLP=000000000".

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_ins_frm IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    retira_block:
    do v_num_row_a = 1 to browse br_usuar_mestre:num-selected-rows:

        assign v_log_method = browse br_usuar_mestre:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(usuar_mestre).
        find usuar_mestre where recid(usuar_mestre) = v_rec_table no-lock no-error.

        find mgesp.rel-grup-user no-lock
             where mgesp.rel-grup-use.cd-grupo = 'ES0396'
               and mgesp.rel-grup-use.usuario  = usuar_mestre.cod_usuario no-error.
        if not avail mgesp.rel-grup-user
        then do:
            create mgesp.rel-grup-user.
            assign mgesp.rel-grup-user.cd-grupo = 'ES0396'
                   mgesp.rel-grup-user.usuario  = usuar_mestre.cod_usuario.
        end.
                
    end.

    run pi_open_atualizar_grupos_seguranca.

END.

ON CHOOSE OF bt_outdent IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    do v_num_row_a = 1 to browse br_rel-grup-user:num-selected-rows:
        assign v_log_method = browse br_rel-grup-user:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(mgesp.rel-grup-user).
        find mgesp.rel-grup-user where recid(mgesp.rel-grup-user) = v_rec_table exclusive-lock no-error.   
        if  avail mgesp.rel-grup-user
        then do:
            delete mgesp.rel-grup-user.
        end.
    end.

    run pi_open_atualizar_grupos_seguranca.

END.


/************************ User Interface Trigger End ************************/

ON WINDOW-CLOSE OF FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    apply "end-error" to self.

END.

/****************************** Main Code Begin *****************************/

if not can-find(first mgesp.rel-grup-user
                 where mgesp.rel-grup-user.cd-grup = 'ES0396'
                   and mgesp.rel-grup-user.usuario = v_cod_usuar_corren)
then do:
    /* Usu rio sem permissÆo para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'ES0396')).
    return.
end.

/* tratamento do titulo e versÆo */
assign frame f_dlg_03_atualizar_grupos_seguranca:title = frame f_dlg_03_atualizar_grupos_seguranca:title.

pause 0 before-hide.
view frame f_dlg_03_atualizar_grupos_seguranca.
enable all with frame f_dlg_03_atualizar_grupos_seguranca.

open query qr_usuar_mestre for
   each usuar_mestre no-lock.

main_block:
do transaction on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

    enable br_rel-grup-user
           with frame f_dlg_03_atualizar_grupos_seguranca.
    run pi_open_atualizar_grupos_seguranca.
    wait-for go of frame f_dlg_03_atualizar_grupos_seguranca.

end.

hide frame f_dlg_03_atualizar_grupos_seguranca.

return.

/******************************* Main Code End ******************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_atualizar_grupos_seguranca
** Descricao.............: pi_open_atualizar_grupos_seguranca
** Criado por............: Rodrigo
** Criado em.............: 03/07/1998 10:56:21
** Alterado por..........: Rodrigo
** Alterado em...........: 03/07/1998 10:59:01
** Gerado por............: Humberto
*****************************************************************************/
PROCEDURE pi_open_atualizar_grupos_seguranca:

        close query qr_rel-grup-user.
        open query qr_rel-grup-user for
            each mgesp.rel-grup-user no-lock
            where mgesp.rel-grup-user.cd-grup = 'ES0396',
            first usuar_mestre where usuar_mestre.cod_usuario = mgesp.rel-grup-user.usuario.

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
                "Programa Mensagem" c_prg_msg "n’o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p") (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/******************  End of fnc_atualizar_grupos_seguranca ******************/
