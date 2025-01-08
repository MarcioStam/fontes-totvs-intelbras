/*****************************************************************************
** Programa..............: esp/fgl/esfgl001.p
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

def buffer b_cc_uni_estab
    for cc_uni_estab.

/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_rec_cc_uni_estab
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def var v_log_repeat                     as logical         no-undo. /*local*/

/************************** Variable Definition End *************************/

/************************** Query Definition Begin **************************/

def query qr_cc_uni_estab
    for cc_uni_estab, unid_negoc
    scrolling.

/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_cc_uni_estab query qr_cc_uni_estab display 
    cc_uni_estab.cod_estab      format "x(03)" column-label "Estab."
    cc_uni_estab.cod_unid_negoc width-chars 09.00 column-label "Unid.Negoc."
    unid_negoc.des_unid_negoc   width-chars 26.00 column-label "Descriá∆o"
    with separators single 
         size 55 by 06.65
         font 4
         bgcolor 15
         title "Estabelecimento X Unidade Neg¢cio".

/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_add
    label "Inclui"
    tooltip "Inclui"
    size 1 by 1.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_del
    label "Elimina"
    tooltip "Elimina"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_bac_01_cc_uni_estab
    emscad.ccusto.cod_ccusto
         at row 01.50 col 4.00 
         help "Centro Custo"
         view-as fill-in
         size-chars 7 by .88
         fgcolor ? bgcolor 15 font 2
    emscad.ccusto.des_tit_ctbl
         at row 1.50 col 21.00 no-label
         view-as fill-in
         size-chars 30 by .88
         fgcolor ? bgcolor 15 font 2

    br_cc_uni_estab
         at row 02.83 col 02.00
         help "Estabelecimento X Unidade Neg¢cio"
    rt_cxcf
         at row 11.21 col 02.00 bgcolor 7
    bt_add
         at row 9.71 col 02.00 font ?
         help "Inclui"
    bt_del
         at row 9.71 col 12.00 font ?
         help "Elimina"
    bt_ok
         at row 11.42 col 02.50 font ?
         help "OK"
    bt_can
         at row 11.42 col 13.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 58 by 13 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "ESFGL001 - Centro Custo x Unidade x Estabelecimento".
    /* adjust size of objects in this frame */
    assign /*c_cod_ccusto:width-chars  in frame f_bac_01_cc_uni_estab = 10.00
           emscad.ccusto.des_tit_ctbl:width-chars  in frame f_bac_01_cc_uni_estab = 10.00*/
           bt_add:width-chars       in frame f_bac_01_cc_uni_estab = 10.00
           bt_add:height-chars      in frame f_bac_01_cc_uni_estab = 01.00
           bt_can:width-chars        in frame f_bac_01_cc_uni_estab = 10.00
           bt_can:height-chars       in frame f_bac_01_cc_uni_estab = 01.00
           bt_del:width-chars       in frame f_bac_01_cc_uni_estab = 10.00
           bt_del:height-chars      in frame f_bac_01_cc_uni_estab = 01.00
           bt_ok:width-chars         in frame f_bac_01_cc_uni_estab = 10.00
           bt_ok:height-chars        in frame f_bac_01_cc_uni_estab = 01.00
           rt_cxcf:width-chars       in frame f_bac_01_cc_uni_estab = 55
           rt_cxcf:height-chars      in frame f_bac_01_cc_uni_estab = 01.42.

    /* set private-data for the help system */
    assign br_cc_uni_estab:private-data in frame f_bac_01_cc_uni_estab = "HLP=000017220":U
           bt_add:private-data                    in frame f_bac_01_cc_uni_estab = "HLP=000010825":U
           bt_del:private-data                    in frame f_bac_01_cc_uni_estab = "HLP=000010802":U
           bt_ok:private-data                      in frame f_bac_01_cc_uni_estab = "HLP=000010721":U
           bt_can:private-data                     in frame f_bac_01_cc_uni_estab = "HLP=000011050":U
           frame f_bac_01_cc_uni_estab:private-data                               = "HLP=000017220".

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_add IN FRAME f_bac_01_cc_uni_estab
DO:

    run esp/fgl/esfgl001a.p.

    RUN pi-open-query-cc-uni-estab.

END. /* ON CHOOSE OF bt_add IN FRAME f_bac_01_cc_uni_estab */


ON CHOOSE OF bt_can IN FRAME f_bac_01_cc_uni_estab
DO:

    RETURN "NOK" /*l_nok*/ .

END. /* ON CHOOSE OF bt_can IN FRAME f_bac_01_cc_uni_estab */

ON CHOOSE OF bt_del IN FRAME f_bac_01_cc_uni_estab
DO:

    /************************* Variable Definition Begin ************************/

    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.


    /************************** Variable Definition End *************************/

    FIND CURRENT cc_uni_estab EXCLUSIVE-LOCK NO-ERROR.
    if  avail cc_uni_estab
    then do:
         DELETE cc_uni_estab.
         assign v_log_method = br_cc_uni_estab:delete-current-row().
    end.

END. /* ON CHOOSE OF bt_del IN FRAME f_bac_01_cc_uni_estab */

ON CHOOSE OF bt_ok IN FRAME f_bac_01_cc_uni_estab
DO:

    v_rec_cc_uni_estab = ?.
    if  avail cc_uni_estab
    then do:
        assign v_rec_cc_uni_estab = recid(cc_uni_estab).
    end /* if */.

END. /* ON CHOOSE OF bt_ok IN FRAME f_bac_01_cc_uni_estab */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bac_01_cc_uni_estab
DO:
    RETURN "NOK" /*l_nok*/ .
END. /* ON END-ERROR OF FRAME f_bac_01_cc_uni_estab */

/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
assign frame f_bac_01_cc_uni_estab:title = frame f_bac_01_cc_uni_estab:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

assign br_cc_uni_estab:num-locked-columns in frame f_bac_01_cc_uni_estab = 0.

pause 0 before-hide.
view frame f_bac_01_cc_uni_estab.

assign v_log_repeat   = yes.

main_block:
repeat while v_log_repeat on error undo main_block, retry main_block transaction:
    FIND FIRST emscad.ccusto NO-LOCK 
         WHERE RECID(emscad.ccusto) = v_rec_ccusto_upc
               /*emscad.ccusto.cod_ccusto = c_cod_ccusto*/ NO-ERROR.
    IF NOT AVAIL emscad.ccusto THEN DO:
        MESSAGE "Centro de custo n∆o localizado !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.
            
    
    DISP emscad.ccusto.cod_ccusto
         emscad.ccusto.des_tit_ctbl
          with frame f_bac_01_cc_uni_estab.

    enable br_cc_uni_estab
           bt_add
           bt_del
           bt_ok
           bt_can
           with frame f_bac_01_cc_uni_estab.

    RUN pi-open-query-cc-uni-estab.

    assign v_log_repeat = no.

    if  not can-find( first cc_uni_estab
                      where cc_uni_estab.cod_ccusto = emscad.ccusto.cod_ccusto /*c_cod_ccusto*/ ) 
    then do:
         apply "choose" to bt_add in frame f_bac_01_cc_uni_estab.
    end.

    wait-for go of frame f_bac_01_cc_uni_estab.
end /* repeat main_block */.

hide frame f_bac_01_cc_uni_estab.

/******************************* Main Code End ******************************/

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
END PROCEDURE.


PROCEDURE pi-open-query-cc-uni-estab:

    open query qr_cc_uni_estab 
        FOR EACH cc_uni_estab EXCLUSIVE-LOCK 
           WHERE cc_uni_estab.cod_ccusto = emscad.ccusto.cod_ccusto /*c_cod_ccusto*/ ,
           FIRST unid_negoc WHERE unid_negoc.cod_unid_negoc = cc_uni_estab.cod_unid_negoc
        BY cc_uni_estab.cod_estab.

END PROCEDURE.
