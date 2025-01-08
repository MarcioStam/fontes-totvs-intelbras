/*****************************************************************************
** Programa..............: frm_seg_ccusto_user
** Versao................:  1.00.00.001
** Nome Externo..........: esp/es0512zb.p
** Criado por............: Fabiano
** Criado em.............: 3/08/2007
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
def var v_cod-usuario    like usu-cc-un-orc.cod-usuario no-undo.
def var v_cod-estab      like estabelecimento.cod_estab no-undo.
def var v_cod-unid-negoc like unid_negoc.cod_unid_negoc no-undo.

def new global shared var v_rec_unid_negoc
    as recid              
    format ">>>>>>9":U    
    no-undo.              

def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_estab
    as recid
    format ">>>>>>9":U
    no-undo.

/************************** Query Definition Begin **************************/

def buffer b_usuar_mestre_enter    for usuar_mestre.
def buffer b_estabelecimento_enter for estabelecimento.

DEF TEMP-TABLE tt-ccusto LIKE emscad.ccusto.
DEF TEMP-TABLE tt-usu-cc-un-orc LIKE usu-cc-un-orc
    FIELD des_tit_ctbl LIKE emscad.ccusto.des_tit_ctbl.

def query qr_centro-custo
    for tt-ccusto
    scrolling.

def query qr_usu-cc-un-orc
    for tt-usu-cc-un-orc
    scrolling.

/************************** Browse Definition Begin *************************/

def browse br_centro-custo query qr_centro-custo display 
    tt-ccusto.cod_empresa
    width-chars 3.30
        column-label "Emp"
    tt-ccusto.cod_ccusto
    width-chars 5.00
        column-label "CCusto"
    tt-ccusto.des_tit_ctbl
    width-chars 23.00
    with separators multiple 
         size 39.00 by 08.00
         font 1
         bgcolor 15
         title "CCustos Dispon°veis".

def browse br_usu-cc-un-orc query qr_usu-cc-un-orc display 
    tt-usu-cc-un-orc.cod-empresa
    width-chars 3.30
        column-label "Emp"
    tt-usu-cc-un-orc.cod-estab
    width-chars 3.30
        column-label "Est"
    tt-usu-cc-un-orc.cod-ccusto
    width-chars 7.5
        column-label "CCusto"
    tt-usu-cc-un-orc.des_tit_ctbl
    width-chars 23.70
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
def button bt_zoo_30683
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_30682
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_atualizar_grupos_seguranca
    rt_cxcf
         at row 13.17 col 02.00 bgcolor 7 
    v_cod-estab
         at row 01.27 col 18.00 colon-aligned label "Estabelecimento"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30682
         at row 01.27 col 24.14
    estabelecimento.nom_abrev
         at row 01.27 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod-unid-negoc
         at row 02.27 col 18.00 colon-aligned label "UN"
         view-as fill-in
         size-chars 04.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30683
         at row 02.27 col 24.14
    unid_negoc.des_unid_negoc
         at row 02.27 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod-usuario
         at row 03.27 col 18.00 colon-aligned label "Usu†rio"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_30681
         at row 03.27 col 33.14
    bt_ent_30681
         at row 03.27 col 37.14
    usuar_mestre.nom_usuario
         at row 03.27 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    br_centro-custo
         at row 04.50 col 02.00
         help "CCustos Dispon°veis"
    br_usu-cc-un-orc
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
         title "Relaciona Usu†rio ao CCusto - ES0512ZB - 1.00.00.001".
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
    assign br_usu-cc-un-orc:private-data in frame f_dlg_03_atualizar_grupos_seguranca          = "HLP=000000000":U
           br_centro-custo:private-data    in frame f_dlg_03_atualizar_grupos_seguranca        = "HLP=000000000":U
           bt_ins_frm:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009353":U
           bt_outdent:private-data                in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000009731":U
           bt_ok:private-data                     in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000010721":U
           bt_can:private-data                    in frame f_dlg_03_atualizar_grupos_seguranca = "HLP=000011050":U
           frame f_dlg_03_atualizar_grupos_seguranca:private-data                              = "HLP=000000000".

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_ins_frm IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    retira_block:
    do v_num_row_a = 1 to browse br_centro-custo:num-selected-rows:

        assign v_log_method = browse br_centro-custo:fetch-selected-row(v_num_row_a).

        find usu-cc-un-orc no-lock
             where usu-cc-un-orc.cod-empresa  = tt-ccusto.cod_empresa
               and usu-cc-un-orc.cod-estab    = b_estabelecimento_enter.cod_estab
               and usu-cc-un-orc.cod-usuario  = b_usuar_mestre_enter.cod_usuar
               and usu-cc-un-orc.cod-ccusto   = tt-ccusto.cod_ccusto
               AND usu-cc-un-orc.cod-unid-neg = INPUT FRAME f_dlg_03_atualizar_grupos_seguranca v_cod-unid-negoc
              no-error.

        if not avail usu-cc-un-orc then do:
           create usu-cc-un-orc.
           assign usu-cc-un-orc.cod-empresa  = tt-ccusto.cod_empresa
                  usu-cc-un-orc.cod-estab    = b_estabelecimento_enter.cod_estab
                  usu-cc-un-orc.cod-usuario  = b_usuar_mestre_enter.cod_usuar
                  usu-cc-un-orc.cod-ccusto   = tt-ccusto.cod_ccusto
                  usu-cc-un-orc.cod-unid-neg = INPUT FRAME f_dlg_03_atualizar_grupos_seguranca v_cod-unid-negoc.
        end.
                
    end.

    run pi_open_atualizar_grupos_seguranca.

END.

ON CHOOSE OF bt_outdent IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    do v_num_row_a = 1 to browse br_usu-cc-un-orc:num-selected-rows:

        assign v_log_method = browse br_usu-cc-un-orc:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(tt-usu-cc-un-orc).

        find tt-usu-cc-un-orc where recid(tt-usu-cc-un-orc) = v_rec_table exclusive-lock no-error.   
       

        if  avail tt-usu-cc-un-orc then do:
            FIND usu-cc-un-orc
                WHERE usu-cc-un-orc.cod-empresa  = tt-usu-cc-un-orc.cod-empresa                                           
                AND   usu-cc-un-orc.cod-estab    = tt-usu-cc-un-orc.cod-estab                               
                AND   usu-cc-un-orc.cod-usuario  = tt-usu-cc-un-orc.cod-usuar                                  
                AND   usu-cc-un-orc.cod-ccusto   = tt-usu-cc-un-orc.cod-ccusto                                            
                AND   usu-cc-un-orc.cod-unid-neg = INPUT FRAME f_dlg_03_atualizar_grupos_seguranca v_cod-unid-negoc
                EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL usu-cc-un-orc THEN
                delete usu-cc-un-orc.
        end.
    end.

    run pi_open_atualizar_grupos_seguranca.

END.


/************************ User Interface Trigger End ************************/

ON WINDOW-CLOSE OF FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    apply "end-error" to self.

END.

ON  CHOOSE OF bt_zoo_30683 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR F5 OF v_cod-unid-negoc IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    run esp/es0512ke.p.
    
    if  v_rec_unid_negoc <> ? then do:

        find unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.

        ASSIGN v_cod-unid-negoc:screen-value in frame f_dlg_03_atualizar_grupos_seguranca = string(unid_negoc.cod_unid_negoc, '999').
    
    end.

    apply "LEAVE" to v_cod-unid-negoc in frame f_dlg_03_atualizar_grupos_seguranca.

end.

ON  CHOOSE OF bt_zoo_30681 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR F5 OF v_cod-usuario IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    run esp/es0512ka.p.
    if  v_rec_usuar_mestre <> ?
    then do:
        find usuar_mestre where recid(usuar_mestre) = v_rec_usuar_mestre no-lock no-error.
        assign v_cod-usuario:screen-value in frame f_dlg_03_atualizar_grupos_seguranca = string(usuar_mestre.cod_usuario).

        display usuar_mestre.nom_usuar
                with frame f_dlg_03_atualizar_grupos_seguranca.

    end.
    apply "entry" to v_cod-usuario in frame f_dlg_03_atualizar_grupos_seguranca.

end.

ON  CHOOSE OF bt_ent_30681 IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    find b_usuar_mestre_enter no-lock
         where b_usuar_mestre_enter.cod_usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario no-error.
    if not avail b_usuar_mestre_enter
    then do:
         message substitute("&1 inexistente." ,"Usu†rio Inexistente")
                view-as alert-box warning buttons ok.
         return no-apply.
    end.
    find b_estabelecimento_enter no-lock
         where b_estabelecimento_enter.cod_estab = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-estab no-error.
    if not avail b_estabelecimento_enter
    then do:
         message substitute("&1 inexistente." ,"Estabelecimento")
                view-as alert-box warning buttons ok.
         return no-apply.
    end.

    run pi_open_atualizar_ccusto.
    run pi_open_atualizar_grupos_seguranca.
    enable bt_ins_frm bt_outdent with frame f_dlg_03_atualizar_grupos_seguranca.    
    
end.

ON  CHOOSE OF bt_zoo_30682 IN FRAME f_dlg_03_atualizar_grupos_seguranca
OR F5 OF v_cod-estab IN FRAME f_dlg_03_atualizar_grupos_seguranca DO:

    run esp/es0512zf.p.
    if  v_rec_estab <> ?
    then do:
        find estabelecimento where recid(estabelecimento) = v_rec_estab no-lock no-error.
        assign v_cod-estab:screen-value in frame f_dlg_03_atualizar_grupos_seguranca = string(estabelecimento.cod_estab).

        display estabelecimento.nom_abrev
                with frame f_dlg_03_atualizar_grupos_seguranca.

    end.
    apply "entry" to v_cod-estab in frame f_dlg_03_atualizar_grupos_seguranca.

end.

ON LEAVE OF v_cod-unid-negoc IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find unid_negoc no-lock
        where unid_negoc.cod_unid_negoc = INPUT frame f_dlg_03_atualizar_grupos_seguranca v_cod-unid-negoc
        no-error.
    
    display unid_negoc.des_unid_negoc when avail unid_negoc
            "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
            with frame f_dlg_03_atualizar_grupos_seguranca.

    close query qr_centro-custo.
    close query qr_usu-cc-un-orc.
    disable bt_ins_frm bt_outdent with frame f_dlg_03_atualizar_grupos_seguranca.
    
END.

ON LEAVE OF v_cod-usuario IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-usuario no-error.
    display usuar_mestre.nom_usuar when avail usuar_mestre
            "" when not avail usuar_mestre @ usuar_mestre.nom_usuar
            with frame f_dlg_03_atualizar_grupos_seguranca.

    close query qr_centro-custo.
    close query qr_usu-cc-un-orc.
    disable bt_ins_frm bt_outdent with frame f_dlg_03_atualizar_grupos_seguranca.

END.

ON LEAVE OF v_cod-estab IN FRAME f_dlg_03_atualizar_grupos_seguranca
DO:

    find estabelecimento no-lock
         where estabelecimento.cod_estab = input frame f_dlg_03_atualizar_grupos_seguranca v_cod-estab no-error.
    display estabelecimento.nom_abrev when avail estabelecimento
            "" when not avail estabelecimento @ estabelecimento.nom_abrev
            with frame f_dlg_03_atualizar_grupos_seguranca.

    close query qr_centro-custo.
    close query qr_usu-cc-un-orc.
    disable bt_ins_frm bt_outdent with frame f_dlg_03_atualizar_grupos_seguranca.

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
disable usuar_mestre.nom_usuario estabelecimento.nom_abrev unid_negoc.des_unid_negoc bt_ins_frm bt_outdent with frame f_dlg_03_atualizar_grupos_seguranca.

main_block:
do transaction on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

    enable br_usu-cc-un-orc
           with frame f_dlg_03_atualizar_grupos_seguranca.
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

        close query qr_usu-cc-un-orc.
        EMPTY TEMP-TABLE tt-usu-cc-un-orc.

        FOR EACH usu-cc-un-orc
            where usu-cc-un-orc.cod-empresa  = b_estabelecimento_enter.cod_empresa                             
              and usu-cc-un-orc.cod-estab    = b_estabelecimento_enter.cod_estab                               
              and usu-cc-un-orc.cod-usuario  = b_usuar_mestre_enter.cod_usuario                                
              AND usu-cc-un-orc.cod-unid-neg = INPUT FRAME f_dlg_03_atualizar_grupos_seguranca v_cod-unid-negoc:

            CREATE tt-usu-cc-un-orc.
            BUFFER-COPY usu-cc-un-orc TO tt-usu-cc-un-orc.
            

            IF  tt-usu-cc-un-orc.cod-ccusto = "*" THEN DO:
                ASSIGN tt-usu-cc-un-orc.des_tit_ctbl = "Todos".
            END.
            ELSE DO:
                FIND emscad.ccusto no-lock
                   where emscad.ccusto.cod_empresa     = b_estabelecimento_enter.cod_empresa
                    and emscad.ccusto.cod_plano_ccusto = 'Padrao'
                    and emscad.ccusto.cod_ccusto       = usu-cc-un-orc.cod-ccusto
                    NO-ERROR.

                ASSIGN tt-usu-cc-un-orc.des_tit_ctbl =  ccusto.des_tit_ctbl.
            END.                        
        END.
        open query qr_usu-cc-un-orc for
            each tt-usu-cc-un-orc no-lock
            BY tt-usu-cc-un-orc.cod-empresa
            BY tt-usu-cc-un-orc.cod-estab
            BY tt-usu-cc-un-orc.cod-ccusto.                                              
END PROCEDURE.

/*****************************************************************************
** Procedure Interna.....: pi_open_atualizar_ccusto
** Descricao.............: pi_open_atualizar_ccusto
*****************************************************************************/
PROCEDURE pi_open_atualizar_ccusto:
    close query qr_centro-custo.

    EMPTY TEMP-TABLE tt-ccusto.
    FOR each emscad.ccusto no-lock
       where emscad.ccusto.cod_empresa      = b_estabelecimento_enter.cod_empresa
         and emscad.ccusto.cod_plano_ccusto = 'Padrao':

        CREATE tt-ccusto.
        BUFFER-COPY ccusto TO tt-ccusto.
    END.

    CREATE tt-ccusto.
    ASSIGN tt-ccusto.cod_empresa = "1"
           tt-ccusto.cod_ccusto = "*"
           tt-ccusto.des_tit_ctbl = "Todos".

    open query qr_centro-custo 
        FOR EACH tt-ccusto
       by tt-ccusto.cod_ccusto.

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
