/*****************************************************************************
** Programa..............: esp/fgl/esfgl001a.p
** Criado por............: Raphael Matei Paini
** Criado em.............: 05/05/2009
*****************************************************************************/

/************************ Parameter Definition Begin ************************/

def new global shared var v_rec_ccusto_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/
DEFINE BUFFER b_cc_uni_estab FOR cc_uni_estab.

/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cdn_cont
    as Integer
    format ">>>,>>9":U
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

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def new global shared var v_rec_cc_uni_estab
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_sav
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame
    as widget-handle
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/

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
def button bt_zoom_estab
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoom_unidade
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_adp_01_cc_uni_estab
    rt_mold
         at row 01.58 col 02.00
    rt_cxcf
         at row 6.25 col 02.00 bgcolor 7 
    cc_uni_estab.cod_ccusto
         at row 02 col 18.00 colon-aligned label "Centro Custo"
         view-as fill-in
         size-chars 6.25 by .88
         fgcolor ? bgcolor 15 font 2
    emscad.ccusto.des_tit_ctbl
         at row 2 col 26.75 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    cc_uni_estab.cod_unid_negoc
         at row 3 col 18.00 colon-aligned label "Unid Neg¢cio"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoom_unidade
         at row 3 col 24.25
         help "Zoom"
    unid_negoc.des_unid_negoc
         at row 3 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    cc_uni_estab.cod_estab
         at row 4 col 18.00 colon-aligned label "Estabel"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoom_estab
         at row 4 col 24.25 font ?
         help "Zoom"
    estabelecimento.nom_pessoa
         at row 4 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 6.46 col 03.00 font ?
         help "OK"
    bt_sav
         at row 6.46 col 14.00 font ?
         help "Salva"
    bt_can
         at row 6.46 col 25.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 8.08 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Inclui Relacionamento Centro Custo x Unidade x Estabelecimento".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_adp_01_cc_uni_estab = 10.00
           bt_can:height-chars  in frame f_adp_01_cc_uni_estab = 01.00
           bt_ok:width-chars    in frame f_adp_01_cc_uni_estab = 10.00
           bt_ok:height-chars   in frame f_adp_01_cc_uni_estab = 01.00
           bt_sav:width-chars   in frame f_adp_01_cc_uni_estab = 10.00
           bt_sav:height-chars  in frame f_adp_01_cc_uni_estab = 01.00
           bt_zoom_estab:width-chars   in frame f_adp_01_cc_uni_estab = 04.00
           bt_zoom_estab:height-chars  in frame f_adp_01_cc_uni_estab = 00.88
           bt_zoom_unidade:width-chars   in frame f_adp_01_cc_uni_estab = 04.00
           bt_zoom_unidade:height-chars  in frame f_adp_01_cc_uni_estab = 00.88
           rt_cxcf:width-chars  in frame f_adp_01_cc_uni_estab = 86.57
           rt_cxcf:height-chars in frame f_adp_01_cc_uni_estab = 01.42
           rt_mold:width-chars  in frame f_adp_01_cc_uni_estab = 86.57
           rt_mold:height-chars in frame f_adp_01_cc_uni_estab = 03.75.
    /* set private-data for the help system */
    assign cc_uni_estab.cod_ccusto:private-data                 in frame f_adp_01_cc_uni_estab = "HLP=000010613":U
           emscad.ccusto.des_tit_ctbl:private-data                in frame f_adp_01_cc_uni_estab = "HLP=000025188":U
           cc_uni_estab.cod_unid_negoc:private-data             in frame f_adp_01_cc_uni_estab = "HLP=000010622":U
           bt_zoom_unidade:private-data                         in frame f_adp_01_cc_uni_estab = "HLP=000009431":U
           unid_negoc.des_unid_negoc:private-data               in frame f_adp_01_cc_uni_estab = "HLP=000025189":U
           cc_uni_estab.cod_estab:private-data                  in frame f_adp_01_cc_uni_estab = "HLP=000010612":U
           bt_zoom_estab:private-data                           in frame f_adp_01_cc_uni_estab = "HLP=000009431":U
           estabelecimento.nom_pessoa:private-data              in frame f_adp_01_cc_uni_estab = "HLP=000025191":U
           bt_ok:private-data                                   in frame f_adp_01_cc_uni_estab = "HLP=000010721":U
           bt_sav:private-data                                  in frame f_adp_01_cc_uni_estab = "HLP=000011048":U
           bt_can:private-data                                  in frame f_adp_01_cc_uni_estab = "HLP=000011050":U
           frame f_adp_01_cc_uni_estab:private-data                                            = "HLP=000010611".
    /* enable function buttons */
    assign bt_zoom_unidade:sensitive in frame f_adp_01_cc_uni_estab = yes
           bt_zoom_estab:sensitive   in frame f_adp_01_cc_uni_estab = yes.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can IN FRAME f_adp_01_cc_uni_estab
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_adp_01_cc_uni_estab */

ON CHOOSE OF bt_ok IN FRAME f_adp_01_cc_uni_estab
DO:

    assign v_log_repeat = no.
    /* ix_g20_add_cc_uni_estab */

END. /* ON CHOOSE OF bt_ok IN FRAME f_adp_01_cc_uni_estab */

ON CHOOSE OF bt_sav IN FRAME f_adp_01_cc_uni_estab
DO:

    assign v_log_repeat = yes.
    /* ix_g30_add_cc_uni_estab */

END. /* ON CHOOSE OF bt_sav IN FRAME f_adp_01_cc_uni_estab */

ON LEAVE OF cc_uni_estab.cod_unid_negoc IN FRAME f_adp_01_cc_uni_estab
DO:
    /* Possibilita a utilizaá∆o do n£mero da UN */
    find unid_negoc no-lock
         where unid_negoc.cod_unid_negoc = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc
         use-index ndngc_id
          /*cl_frame of unid_negoc*/ no-error.
    if not avail unid_negoc then do:
        find unid_negoc no-lock
             where unid_negoc.cdn_unid_negoc = int(input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc)
             use-index ndngc_cdn no-error.
        if avail unid_negoc then
            assign cc_uni_estab.cod_unid_negoc:screen-value in frame f_adp_01_cc_uni_estab = unid_negoc.cod_unid_negoc.
    end.
    display unid_negoc.des_unid_negoc when avail unid_negoc
            "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
            with frame f_adp_01_cc_uni_estab.
END. /* ON LEAVE OF cc_uni_estab.cod_unid_negoc IN FRAME f_adp_01_cc_uni_estab */


ON LEAVE OF cc_uni_estab.cod_estab IN FRAME f_adp_01_cc_uni_estab
DO:
    find first estabelecimento no-lock
         where estabelecimento.cod_estab = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_estab no-error.

    display estabelecimento.nom_pessoa when avail estabelecimento
            "" when not avail estabelecimento @ estabelecimento.nom_pessoa
            with frame f_adp_01_cc_uni_estab.
END. /* ON LEAVE OF cc_uni_estab.cod_estab IN FRAME f_adp_01_cc_uni_estab */

/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/

ON CHOOSE OF bt_zoom_estab IN FRAME f_adp_01_cc_uni_estab
OR F5 OF cc_uni_estab.cod_estab IN FRAME f_adp_01_cc_uni_estab DO:

    run prgint/utb/utb071na.p (Input v_cod_empres_usuar) .
    if  v_rec_estabelecimento <> ?
    then do:
        find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
        assign cc_uni_estab.cod_estab:screen-value in frame f_adp_01_cc_uni_estab =
               string(estabelecimento.cod_estab).

        display estabelecimento.nom_pessoa
                with frame f_adp_01_cc_uni_estab.
    end /* if */.
    apply "entry" to cc_uni_estab.cod_estab in frame f_adp_01_cc_uni_estab.
END. /* ON CHOOSE OF bt_zoom_estab IN FRAME f_adp_01_cc_uni_estab */

ON  CHOOSE OF bt_zoom_unidade IN FRAME f_adp_01_cc_uni_estab
OR F5 OF cc_uni_estab.cod_unid_negoc IN FRAME f_adp_01_cc_uni_estab DO:

    run prgint/utb/utb011ka.p.
    if v_rec_unid_negoc <> ?
    then do:
        find first unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign cc_uni_estab.cod_unid_negoc:screen-value in frame f_adp_01_cc_uni_estab =
               string(unid_negoc.cod_unid_negoc).

        display unid_negoc.des_unid_negoc
                with frame f_adp_01_cc_uni_estab.
    end /* if */.
    apply "entry" to cc_uni_estab.cod_unid_negoc in frame f_adp_01_cc_uni_estab.

end. /* ON  CHOOSE OF bt_zoom_unidade IN FRAME f_adp_01_cc_uni_estab */

/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_adp_01_cc_uni_estab
DO:
    assign v_rec_cc_uni_estab = v_rec_table_sav.
END. /* ON END-ERROR OF FRAME f_adp_01_cc_uni_estab */

ON WINDOW-CLOSE OF FRAME f_adp_01_cc_uni_estab
DO:
    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_adp_01_cc_uni_estab */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* Begin_Include: ix_p00_add_cc_uni_estab */
/* **
 Controla se o erro deve ser enviado ao monitor ou a uma Temp Table.
 Os testes em tela da pi_vld s∆o feitos agora num vari†vel hadle.
***/
assign v_wgh_frame           = frame f_adp_01_cc_uni_estab:handle.

/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */

/* tratamento do titulo e vers∆o */
assign frame f_adp_01_cc_uni_estab:title = frame f_adp_01_cc_uni_estab:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

pause 0 before-hide.
view frame f_adp_01_cc_uni_estab.

assign v_log_repeat   = yes
       v_rec_table    = v_rec_cc_uni_estab.

main_block:
repeat while v_log_repeat:
    /* ix_p10_add_cc_uni_estab */
    assign v_log_repeat  = no
           v_log_save_ok = no.

    FIND FIRST emscad.ccusto NO-LOCK
        WHERE RECID(emscad.ccusto) = v_rec_ccusto_upc NO-ERROR.
    IF NOT AVAIL emscad.ccusto
    THEN DO:
         MESSAGE "Centro de custo n∆o localizado !"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN.
    END.

    create cc_uni_estab.
    ASSIGN cc_uni_estab.cod_ccusto = emscad.ccusto.cod_ccusto
           cc_uni_estab.cc_codigo  = emscad.ccusto.cod_ccusto.
    if  not retry
    then do:
        assign v_rec_table_sav = v_rec_table.
        assign ccusto.des_tit_ctbl:screen-value                   in frame f_adp_01_cc_uni_estab = ""
               unid_negoc.des_unid_negoc:screen-value             in frame f_adp_01_cc_uni_estab = "".
        display cc_uni_estab.cod_ccusto
                emscad.ccusto.des_tit_ctbl
                cc_uni_estab.cod_unid_negoc
                cc_uni_estab.cod_estab
                with frame f_adp_01_cc_uni_estab.

    end /* if */.
    enable cc_uni_estab.cod_unid_negoc
           bt_zoom_unidade
           cc_uni_estab.cod_estab
           bt_zoom_estab
           bt_ok
           bt_sav
           bt_can
           with frame f_adp_01_cc_uni_estab.

    /* Begin_Include: ix_p20_add_cc_uni_estab */
    /*run pi_ix_p20_add_cc_uni_estab (Input p_val_tit_ap,
                                    Input p_dat_transacao) /*pi_ix_p20_add_cc_uni_estab*/.*/

    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_adp_01_cc_uni_estab focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_adp_01_cc_uni_estab.
        end /* else */.
        save_block:
        do on error undo save_block, leave save_block:
            /* ix_p25_add_cc_uni_estab */

            run pi_save_key /*pi_save_key*/.
            run pi_save_fields /*pi_save_fields*/.

            /* Begin_Include: ix_p27_add_cc_uni_estab */
            /*run pi_ix_p27_add_cc_uni_estab (Input p_dat_transacao) /*pi_ix_p27_add_cc_uni_estab*/.
            assign v_dat_trans_param           = p_dat_transacao.*/
            assign v_cdn_cont = 1.

            /* L¢gica acreescentada para funcionar corretamente em bases progress inglàs */
            assign v_rec_cc_uni_estab = recid(cc_uni_estab).
            release cc_uni_estab.
            find cc_uni_estab exclusive-lock
                 where recid(cc_uni_estab) = v_rec_cc_uni_estab no-error.
            /* End_Include: ix_p27_add_cc_uni_estab */
            
            assign v_log_save_ok = yes.
        end /* do save_block */.
    end /* repeat wait_block */.
    assign v_rec_table    = recid(cc_uni_estab)
           v_rec_cc_uni_estab = recid(cc_uni_estab).
end /* repeat main_block */.

hide frame f_adp_01_cc_uni_estab.

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

    /************************* Variable Definition Begin ************************/

    def var v_log_msg
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_rec_table_aux
        as recid
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign_block:
    do on error undo assign_block, return error:

        find FIRST unid_negoc no-lock
             where unid_negoc.cod_unid_negoc = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc no-error.
        IF NOT AVAIL unid_negoc THEN DO:
            /* &1 j† existente ! */
            run pi_messages (input "show",
                             input 8433,
                             input substitute ("&1~~&2~~&3","Unidade de Neg¢cio","Unidades de Neg¢cio",STRING(input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc))) /*msg_1*/ .
            APPLY "entry" TO cc_uni_estab.cod_unid_negoc IN FRAME f_adp_01_cc_uni_estab.
            undo assign_block, return error.
        END.

        find FIRST estabelec no-lock
             where estabelec.cod-estabel = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_estab no-error.
        IF NOT AVAIL estabelec THEN DO:
            run pi_messages (input "show",
                             input 8433,
                             input substitute ("&1~~&2~~&3","Estabelecimento","Estabelecimentos",STRING(input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_estab))) /*msg_1*/ .
            APPLY "entry" TO cc_uni_estab.cod_estab IN FRAME f_adp_01_cc_uni_estab.
            undo assign_block, return error.
        END.
        ELSE DO:
            IF estabelecimento.cod_empresa <> v_cod_empres_usuar THEN DO:
                run pi_messages (input "show",
                                 input 8435,
                                 input substitute ("&1~~&2~~&3",estabelecimento.cod_empresa,estabelec.cod-estabel,v_cod_empres_usuar)) /*msg_1*/ .
                APPLY "entry" TO cc_uni_estab.cod_estab IN FRAME f_adp_01_cc_uni_estab.
                undo assign_block, return error.
            END.
        END.

        find b_cc_uni_estab no-lock
             where b_cc_uni_estab.cod_ccusto     = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_ccusto
               and b_cc_uni_estab.cod_unid_negoc = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc
               and b_cc_uni_estab.cod_estab      = input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_estab no-error.
        if  avail b_cc_uni_estab
        then do:
            if  recid(b_cc_uni_estab) <> recid(cc_uni_estab)
            then do:
                /* &1 j† existente ! */
                run pi_messages (input "show",
                                 input 1,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "CC x Unidade x Estabelecimento")) /*msg_1*/.
                undo assign_block, return error.
            end /* if */.
        end /* if */.
        else do:
            do with frame f_adp_01_cc_uni_estab:
            end.
            assign input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_unid_negoc
                   input frame f_adp_01_cc_uni_estab cc_uni_estab.cod_estab no-error.
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
        do with frame f_adp_01_cc_uni_estab:
        end.
        assign v_wgh_focus = ?.
    end /* do assign_block */.

    /* Foráar a criaá∆o do registro com bases Oracle */    if recid(cc_uni_estab) <> ?  then.
END PROCEDURE. /* pi_save_fields */

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
/**********************  End of add_cc_uni_estab **********************/
