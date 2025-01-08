/*****************************************************************************
** Programa..............: frm_seg_ccusto_user_unidade
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512ze-2.p
** Criado por............: Fabiano
** Criado em.............: 03/09/2007
*****************************************************************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
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
def var v_rec_table
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_cod-usuario like usuario-cc-orc.cod-usuario no-undo.
def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9":U
    no-undo.

/*********************** Temp-Table Definition Begin ************************/

def temp-table tt_centro-custo 
    field cc-codigo as char format "x(08)" label "Centro Custo" column-label "Centro Custo"
    field descricao as char format "x(32)" label "Descriá∆o" column-label "Descriá∆o"
    index tt_id is primary unique
          cc-codigo ascending.

/************************** Query Definition Begin **************************/

def buffer b_usuar_mestre_enter for usuar_mestre.

def query qr_tt_centro-custo
    for tt_centro-custo
    scrolling.

def query qr_usuario-cc-orc
    for usuario-cc-orc, tt_centro-custo
    scrolling.

/************************** Browse Definition Begin *************************/

def browse br_tt_centro-custo query qr_tt_centro-custo display 
    tt_centro-custo.cc-codigo
    width-chars 10.00
        column-label "Unidade"
    tt_centro-custo.descricao
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "Unidades Dispon°veis".

def browse br_usuario-cc-orc query qr_usuario-cc-orc display 
    usuario-cc-orc.cod-ccusto
    width-chars 10.00
        column-label "Unidade"
    tt_centro-custo.descricao
    width-chars 25.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "Unidades Com Permiss∆o".

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
         at row 12.17 col 02.00 bgcolor 7 
    v_cod-usuario
         at row 01.67 col 18.00 colon-aligned label "Usu†rio"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30681
         at row 01.67 col 33.14
    bt_ent_30681
         at row 01.67 col 37.14
    usuar_mestre.nom_usuario
         at row 01.67 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    br_tt_centro-custo
         at row 03.50 col 02.00
         help "CCustos Dispon°veis"
    br_usuario-cc-orc
         at row 03.50 col 49.00
         help "CCustos com Permiss∆o"
    bt_ins_frm
         at row 05.50 col 43.00 font ?
         help "Insere Linha"
    bt_outdent
         at row 08.50 col 43.00 font ?
    bt_ok
         at row 12.38 col 03.00 font ?
         help "OK"
    bt_can
         at row 12.38 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 14.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relaciona Usu†rio a Unidade - ES0512ZE-2 - 1.00.00.001".
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
    assign br_usuario-cc-orc:private-data in frame f_dlg_03_atualizar_grupos_seguranca         = "HLP=000000000":U
           br_tt_centro-custo:private-data    in frame f_dlg_03_atualizar_grupos_seguranca     = "HLP=000000000":U
           bt_ins_frm:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009353":U
           bt_outdent:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009731":U
           bt_ok:private-data                     in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000010721":U
           bt_can:private-data                    in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000011050":U
           frame f_dlg_03_atualizar_grupos_seguranca:private-data                              = "HLP=000000000".

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_ins_frm IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find b_usuar_mestre_enter no-lock
         where b_usuar_mestre_enter.cod_usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario no-error.
    if not avail b_usuar_mestre_enter then return no-apply.


    retira_block:
    do v_num_row_a = 1 to browse br_tt_centro-custo:num-selected-rows:

        assign v_log_method = browse br_tt_centro-custo:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(tt_centro-custo).

        find tt_centro-custo where recid(tt_centro-custo) = v_rec_table no-lock no-error.

        find usuario-cc-orc no-lock
             where usuario-cc-orc.cod-usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario
               and usuario-cc-orc.cod-ccusto  = tt_centro-custo.cc-codigo no-error.
        if not avail usuario-cc-orc
        then do:
            create usuario-cc-orc.
            assign usuario-cc-orc.cod-usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario
                   usuario-cc-orc.cod-ccusto  = tt_centro-custo.cc-codigo.
        end.
                
    end.

    run pi_open_atualizar_grupos_seguranca.

END.

ON CHOOSE OF bt_outdent IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    do v_num_row_a = 1 to browse br_usuario-cc-orc:num-selected-rows:

        assign v_log_method = browse br_usuario-cc-orc:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(usuario-cc-orc).

        find usuario-cc-orc where recid(usuario-cc-orc) = v_rec_table exclusive-lock no-error.   
        if  avail usuario-cc-orc
        then do:
            delete usuario-cc-orc.
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
OR F5 OF v_cod-usuario IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    run esp/es0512ka-2.p.
    if  v_rec_usuar_mestre <> ?
    then do:
        find usuar_mestre where recid(usuar_mestre) = v_rec_usuar_mestre no-lock no-error.
        assign v_cod-usuario:screen-value in frame f_dlg_03_atualizar_grupos_seguranca = string(usuar_mestre.cod_usuario).

        display usuar_mestre.nom_usuar
                with frame f_dlg_03_atualizar_grupos_seguranca.

    end.
    apply "entry" to v_cod-usuario in frame f_dlg_03_atualizar_grupos_seguranca.

    run pi_open_atualizar_grupos_seguranca.

end.

ON  CHOOSE OF bt_ent_30681 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR ENTER OF v_cod-usuario IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    find b_usuar_mestre_enter no-lock
         where b_usuar_mestre_enter.cod_usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario no-error.
    if  avail b_usuar_mestre_enter
    then do:
         display usuar_mestre.nom_usuar
                 with frame f_dlg_03_atualizar_grupos_seguranca.

    end.
    else do:
        message substitute("&1 inexistente." ,"Usu†rio Inexistente")
               view-as alert-box warning buttons ok.
    end.

    run pi_open_atualizar_grupos_seguranca.
    
end.

ON LEAVE OF v_cod-usuario IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario no-error.
    display usuar_mestre.nom_usuar when avail usuar_mestre
            "" when not avail usuar_mestre @ usuar_mestre.nom_usuar
            with frame f_dlg_03_atualizar_grupos_seguranca.

    run pi_open_atualizar_grupos_seguranca.

END.

/****************************** Main Code Begin *****************************/

if not can-find(first mgesp.rel-grup-use
                 where mgesp.rel-grup-use.cd-grup = 'ES0396'
                   and mgesp.rel-grup-use.usuario = v_cod_usuar_corren)
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'ES0396')).
    return.
end.

/* tratamento do titulo e vers∆o */
assign frame f_dlg_03_atualizar_grupos_seguranca:title = frame f_dlg_03_atualizar_grupos_seguranca:title.

pause 0 before-hide.
view frame f_dlg_03_atualizar_grupos_seguranca.
enable all with frame f_dlg_03_atualizar_grupos_seguranca.
disable usuar_mestre.nom_usuario with frame f_dlg_03_atualizar_grupos_seguranca.

run pi_cria_tt_centro-custo.

open query qr_tt_centro-custo for
   each tt_centro-custo no-lock.

main_block:
do transaction on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

    enable br_usuario-cc-orc
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
*****************************************************************************/
PROCEDURE pi_open_atualizar_grupos_seguranca:

        close query qr_usuario-cc-orc.
        open query qr_usuario-cc-orc for
            each usuario-cc-orc no-lock
            where usuario-cc-orc.cod-usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario,
            first tt_centro-custo where tt_centro-custo.cc-codigo = usuario-cc-orc.cod-ccusto.

END PROCEDURE.
/*****************************************************************************
** Procedure Interna.....: pi_cria_tt_centro-custo
** Descricao.............: pi_cria_tt_centro-custo
*****************************************************************************/
PROCEDURE pi_cria_tt_centro-custo:

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'Empresa'
               tt_centro-custo.descricao = 'Intelbras'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'IAF'
               tt_centro-custo.descricao = 'Unidade IAF'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'IAFCC'
               tt_centro-custo.descricao = 'Divis∆o IAF CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'IAFID'
               tt_centro-custo.descricao = 'Divis∆o IAF ID'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICON'
               tt_centro-custo.descricao = 'Unidade ICON'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICONCC'
               tt_centro-custo.descricao = 'Divis∆o ICON CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICONGP'
               tt_centro-custo.descricao = 'Divis∆o ICON GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICORP'
               tt_centro-custo.descricao = 'Unidade ICORP'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICORPCC'
               tt_centro-custo.descricao = 'Divis∆o ICORP CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICORPGP'
               tt_centro-custo.descricao = 'Divis∆o ICORP GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'IND'
               tt_centro-custo.descricao = 'Unidade IND'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'INDCC'
               tt_centro-custo.descricao = 'Divis∆o IND CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'INDGP'
               tt_centro-custo.descricao = 'Divis∆o IND GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'INET'
               tt_centro-custo.descricao = 'Unidade INET'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'INETCC'
               tt_centro-custo.descricao = 'Divis∆o INET CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'INETGP'
               tt_centro-custo.descricao = 'Divis∆o INET GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ISEC'
               tt_centro-custo.descricao = 'Unidade ISEC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ISECCC'
               tt_centro-custo.descricao = 'Divis∆o ISEC CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ISECGP'
               tt_centro-custo.descricao = 'Divis∆o ISEC GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICEL'
               tt_centro-custo.descricao = 'Unidade ICEL'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICELCC'
               tt_centro-custo.descricao = 'Divis∆o ICEL CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICELGP'
               tt_centro-custo.descricao = 'Divis∆o ICEL GP'.

        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICOMP'
               tt_centro-custo.descricao = 'Unidade ICOMP'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICOMPCC'
               tt_centro-custo.descricao = 'Divis∆o ICOMP CC'.
        create tt_centro-custo.
        assign tt_centro-custo.cc-codigo = 'ICOMPGP'
               tt_centro-custo.descricao = 'Divis∆o ICOMP GP'.

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
