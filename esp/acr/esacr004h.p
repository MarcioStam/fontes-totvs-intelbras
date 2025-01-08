/*****************************************************************************
** Programa..............: esp/acr/esacr004h.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 09/12/2008
*****************************************************************************/

/************************ Parameter Definition Begin ************************/

def Input param p_numero
    as integer
    format ">>>>>9"
    no-undo.
def Input param p_dat_transacao
    as date
    format "99/99/9999"
    no-undo.
def Input param p_val_tit_ap
    as decimal
    format "->>>,>>>,>>9.99"
    decimals 2
    no-undo.

/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

def buffer b_fedex-rateio
    for fedex-rateio.
def buffer b_fedex-rateio_mod
    for fedex-rateio.

/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

DEF VAR v_log_save AS LOG NO-UNDO.
DEF VAR v_log_answer AS LOG NO-UNDO.
def var v_cdn_cont
    as Integer
    format ">>>,>>9":U
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_ccusto_000
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_2
    as character
    format "x(8)":U
    no-undo.
def var v_cod_ccusto_aux
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cta_ctbl_2
    as character
    format "x(8)":U
    no-undo.
def var v_cod_cta_ctbl_3
    as character
    format "x(17)":U
    no-undo.
def var v_cod_cta_ctbl_lin
    as character
    format "x(20)":U
    label "Conta Lista Ini"
    column-label "Conta Lista Ini"
    no-undo.
def new global shared var v_cod_cta_ctbl_mutuo
    as character
    format "x(8)":U
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
def var v_cod_estab_param
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def var v_cod_format_1
    as character
    format "x(8)":U
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
def var v_cod_parameters
    as character
    format "x(256)":U
    no-undo.
def new global shared var v_cod_param_msg_erro_valid
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_plano_ccusto_old
    as character
    format "x(8)":U
    label "Plano CCusto Antigo"
    column-label "Plano Centros Custo"
    no-undo.
def var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
def var v_cod_plano_cta_ctbl_old
    as character
    format "x(8)":U
    label "Plano antigo"
    column-label "Plano antigo"
    no-undo.
def var v_cod_refer_param
    as character
    format "x(10)":U
    no-undo.
def var v_cod_unid_negoc
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Un Neg"
    no-undo.
def var v_cod_unid_negoc_2
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Un Neg"
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
def var v_dat_trans
    as date
    format "99/99/9999":U
    initial ?
    no-undo.
def var v_dat_transacao
    as date
    format "99/99/9999":U
    label "Data Transaá∆o"
    column-label "Data Transaá∆o"
    no-undo.
def var v_dat_trans_param
    as date
    format "99/99/9999":U
    no-undo.
def var v_ind_criter_distrib_ccusto
    as character
    format "X(15)":U
    initial "Utiliza Todos" /*l_utiliza_todos*/
    view-as combo-box
    list-items "N∆o Utiliza","Utiliza Todos","Definidos"
     /*l_nao_utiliza*/ /*l_utiliza_todos*/ /*l_definidos*/
    inner-lines 5
    bgcolor 15 font 2
    label "CritÇrio Dist CCusto"
    column-label "CritÇrio Dist CCusto"
    no-undo.
def var v_ind_fluxo_movto_financ
    as character
    format "X(7)":U
    view-as combo-box
    list-items "Entrada","Sa°da"
     /*l_entrada*/ /*l_saida*/
    inner-lines 3
    bgcolor 15 font 2
    label "Fluxo Movimento"
    column-label "Fluxo Movimento"
    no-undo.
def var v_log_erro_lote
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_mutuo
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_plano_cta_ctbl
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_repeat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_save_ok
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_sul_america
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_mensagem
    as integer
    format ">>>>,>>9":U
    label "N£mero"
    column-label "N£mero Mensagem"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_refer_param
    as integer
    format ">>>9":U
    no-undo.
def new global shared var v_rec_fedex-rateio
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_cta_ctbl_integr
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_impto_impl_pend_param
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_ccusto
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_cta_ctbl
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
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_val_abat_prov
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_sdo_rat_tit_ap
    as decimal
    format ">>9.99":U
    decimals 2
    label "Saldo % a Ratear"
    column-label "Saldo % a Ratear"
    no-undo.
def var v_val_tit_ap_param
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_rat
    as decimal
    format ">>9.99":U
    decimals 2
    label "Total % Rateio"
    column-label "Total % Rateio"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_cod_format_ccusto              as character       no-undo. /*local*/
def var v_cod_format_cta_ctbl            as character       no-undo. /*local*/
def var v_log_return_cta                 as logical         no-undo. /*local*/


/************************** Variable Definition End *************************/

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
def button bt_zoo
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo2
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_67471
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_67475
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_mop_01_fedex-rateio
    rt_mold
         at row 01.58 col 02.00
    rt_001
         at row 7.13 col 02.00
    " Total " view-as text
         at row 6.83 col 04.00 bgcolor 8 
    rt_cxcf
         at row 9.25 col 02.00 bgcolor 7 
    fedex-rateio.cod_cta_ctbl
         at row 02 col 18.00 colon-aligned label "Conta Cont†bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    cta_ctbl.des_tit_ctbl
         at row 2 col 45.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo2
         at row 2 col 41.29 font ?
         help "Zoom"
    fedex-rateio.cod_unid_negoc
         at row 3 col 18.00 colon-aligned label "Unid Neg¢cio"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_67475
         at row 3 col 24.14
    unid_negoc.des_unid_negoc
         at row 3 col 28.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    fedex-rateio.cod_ccusto
         at row 4 col 18.00 colon-aligned label "Centro Custo"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo
         at row 4 col 32.29 font ?
         help "Zoom"
    emscad.ccusto.des_tit_ctbl
         at row 4 col 36.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    fedex-rateio.perc_aprop_ctbl
         at row 5 col 18.00 colon-aligned label "% Rateio"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_rat_tit_ap
         at row 7.5 col 17.86 colon-aligned label "Saldo % a Ratear"
         help "Saldo do T°tulo que n∆o foi rateado"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_tot_rat
         at row 7.5 col 62.00 colon-aligned label "Total % Rateio"
         help "Total do Rateio"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 9.46 col 03.00 font ?
         help "OK"
    bt_sav
         at row 9.46 col 14.00 font ?
         help "Salva"
    bt_can
         at row 9.46 col 25.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 11.08 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Modifica Rateio Valores".

    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_mop_01_fedex-rateio = 10.00
           bt_can:height-chars  in frame f_mop_01_fedex-rateio = 01.00
           bt_ok:width-chars    in frame f_mop_01_fedex-rateio = 10.00
           bt_ok:height-chars   in frame f_mop_01_fedex-rateio = 01.00
           bt_sav:width-chars   in frame f_mop_01_fedex-rateio = 10.00
           bt_sav:height-chars  in frame f_mop_01_fedex-rateio = 01.00
           bt_zoo:width-chars   in frame f_mop_01_fedex-rateio = 04.00
           bt_zoo:height-chars  in frame f_mop_01_fedex-rateio = 00.88
           bt_zoo2:width-chars  in frame f_mop_01_fedex-rateio = 04.00
           bt_zoo2:height-chars in frame f_mop_01_fedex-rateio = 00.88
           rt_001:width-chars   in frame f_mop_01_fedex-rateio = 86.57
           rt_001:height-chars  in frame f_mop_01_fedex-rateio = 01.63
           rt_cxcf:width-chars  in frame f_mop_01_fedex-rateio = 86.57
           rt_cxcf:height-chars in frame f_mop_01_fedex-rateio = 01.42
           rt_mold:width-chars  in frame f_mop_01_fedex-rateio = 86.57
           rt_mold:height-chars in frame f_mop_01_fedex-rateio = 05.
    /* set private-data for the help system */
    assign fedex-rateio.cod_cta_ctbl:private-data         in frame f_mop_01_fedex-rateio = "HLP=000010613":U
           cta_ctbl.des_tit_ctbl:private-data                   in frame f_mop_01_fedex-rateio = "HLP=000025188":U
           bt_zoo2:private-data                                 in frame f_mop_01_fedex-rateio = "HLP=000009432":U
           bt_zoo_67475:private-data                            in frame f_mop_01_fedex-rateio = "HLP=000009431":U
           fedex-rateio.cod_unid_negoc:private-data       in frame f_mop_01_fedex-rateio = "HLP=000010622":U
           unid_negoc.des_unid_negoc:private-data               in frame f_mop_01_fedex-rateio = "HLP=000025189":U
           fedex-rateio.cod_ccusto:private-data           in frame f_mop_01_fedex-rateio = "HLP=000010612":U
           bt_zoo:private-data                                  in frame f_mop_01_fedex-rateio = "HLP=000009431":U
           emscad.ccusto.des_tit_ctbl:private-data                     in frame f_mop_01_fedex-rateio = "HLP=000025191":U
           fedex-rateio.perc_aprop_ctbl:private-data       in frame f_mop_01_fedex-rateio = "HLP=000010628":U
           v_val_sdo_rat_tit_ap:private-data                    in frame f_mop_01_fedex-rateio = "HLP=000010894":U
           v_val_tot_rat:private-data                           in frame f_mop_01_fedex-rateio = "HLP=000010897":U
           bt_ok:private-data                                   in frame f_mop_01_fedex-rateio = "HLP=000010721":U
           bt_sav:private-data                                  in frame f_mop_01_fedex-rateio = "HLP=000011048":U
           bt_can:private-data                                  in frame f_mop_01_fedex-rateio = "HLP=000011050":U
           frame f_mop_01_fedex-rateio:private-data                                            = "HLP=000010611".
    /* enable function buttons */
    assign bt_zoo_67475:sensitive in frame f_mop_01_fedex-rateio = yes.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can IN FRAME f_mop_01_fedex-rateio
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_mop_01_fedex-rateio */

ON CHOOSE OF bt_ok IN FRAME f_mop_01_fedex-rateio
DO:

    assign v_log_repeat = no.
    /* ix_g20_add_fedex-rateio */

END. /* ON CHOOSE OF bt_ok IN FRAME f_mop_01_fedex-rateio */

ON CHOOSE OF bt_sav IN FRAME f_mop_01_fedex-rateio
DO:

    assign v_log_repeat = yes.
    /* ix_g30_add_fedex-rateio */

END. /* ON CHOOSE OF bt_sav IN FRAME f_mop_01_fedex-rateio */

ON CHOOSE OF bt_zoo IN FRAME f_mop_01_fedex-rateio
DO:

    if input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc <> "" then do:
            run esp/acr/esacr004n.p (Input input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc,
                                     Input "PADRAO") /*prg_see_ccusto_unid_negoc*/.
    end.
    if v_rec_ccusto <> ? then do:
        find emscad.ccusto where recid(ccusto) = v_rec_ccusto no-lock no-error.
        assign fedex-rateio.cod_ccusto:screen-value in frame f_mop_01_fedex-rateio = string(ccusto.cod_ccusto).

        display ccusto.des_tit_ctbl
                with frame f_mop_01_fedex-rateio.
    end.
    apply "Entry" /*l_entry*/  to fedex-rateio.cod_ccusto in frame f_mop_01_fedex-rateio.
END. /* ON CHOOSE OF bt_zoo IN FRAME f_mop_01_fedex-rateio */

ON CHOOSE OF bt_zoo2 IN FRAME f_mop_01_fedex-rateio
DO:

    find plano_cta_ctbl no-lock
         where plano_cta_ctbl.cod_plano_cta_ctbl = "PADRAO" no-error.

    run esp/acr/esacr004l.p (Input "APB" /*l_apb*/,
                             Input plano_cta_ctbl.cod_plano_cta_ctbl,
                             Input "Conta Movimento" /*l_conta_movimento*/) /*prg_see_cta_ctbl_integr*/.
    if  v_rec_cta_ctbl_integr <> ?
    then do:
       find cta_ctbl_integr where recid(cta_ctbl_integr) = v_rec_cta_ctbl_integr no-lock no-error.
       assign fedex-rateio.cod_cta_ctbl:screen-value in frame f_mop_01_fedex-rateio =
              string(cta_ctbl_integr.cod_cta_ctbl).
       find cta_ctbl no-lock
            where cta_ctbl.cod_cta_ctbl = cta_ctbl_integr.cod_cta_ctbl
            and cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl
            no-error.
       display cta_ctbl.des_tit_ctbl
               with frame f_mop_01_fedex-rateio.
       apply "entry" to fedex-rateio.cod_cta_ctbl in frame f_mop_01_fedex-rateio.
    end /* if */.

END. /* ON CHOOSE OF bt_zoo2 IN FRAME f_mop_01_fedex-rateio */

ON ENTRY OF fedex-rateio.cod_ccusto IN FRAME f_mop_01_fedex-rateio
DO:

    if avail plano_ccusto then
       assign fedex-rateio.cod_ccusto:format in frame f_mop_01_fedex-rateio = plano_ccusto.cod_format_ccusto.
    else
       assign fedex-rateio.cod_ccusto:format in frame f_mop_01_fedex-rateio = 'x(11)'.
END. /* ON ENTRY OF fedex-rateio.cod_ccusto IN FRAME f_mop_01_fedex-rateio */

ON LEAVE OF fedex-rateio.cod_ccusto IN FRAME f_mop_01_fedex-rateio
DO:

    run pi_leave_cod_ccusto /*pi_leave_cod_ccusto*/.

    if  return-value <> "OK" /*l_ok*/ 
    then do:
        return no-apply.
    end /* if */.
END. /* ON LEAVE OF fedex-rateio.cod_ccusto IN FRAME f_mop_01_fedex-rateio */

ON ENTRY OF fedex-rateio.cod_cta_ctbl IN FRAME f_mop_01_fedex-rateio
DO:

    assign fedex-rateio.cod_cta_ctbl:format in frame f_mop_01_fedex-rateio = "x(20)" /*l_x20*/ .
END. /* ON ENTRY OF fedex-rateio.cod_cta_ctbl IN FRAME f_mop_01_fedex-rateio */

ON LEAVE OF fedex-rateio.cod_cta_ctbl IN FRAME f_mop_01_fedex-rateio
DO:

    run pi_leave_cod_cta_ctbl (Input p_dat_transacao) /*pi_leave_cod_cta_ctbl*/.

END. /* ON LEAVE OF fedex-rateio.cod_cta_ctbl IN FRAME f_mop_01_fedex-rateio */

ON LEAVE OF fedex-rateio.cod_unid_negoc IN FRAME f_mop_01_fedex-rateio
DO:

    /* Possibilita a utilizaá∆o do n£mero da UN */

    find unid_negoc no-lock
         where unid_negoc.cod_unid_negoc = input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
         use-index ndngc_id
          /*cl_frame of unid_negoc*/ no-error.
    if not avail unid_negoc then do:
        find unid_negoc no-lock
             where unid_negoc.cdn_unid_negoc = int(input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc)
             use-index ndngc_cdn no-error.
        if avail unid_negoc then
            assign fedex-rateio.cod_unid_negoc:screen-value in frame f_mop_01_fedex-rateio = unid_negoc.cod_unid_negoc.
    end.
    display unid_negoc.des_unid_negoc when avail unid_negoc
            "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
            with frame f_mop_01_fedex-rateio.
END. /* ON LEAVE OF fedex-rateio.cod_unid_negoc IN FRAME f_mop_01_fedex-rateio */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/

ON  CHOOSE OF bt_zoo_67475 IN FRAME f_mop_01_fedex-rateio
OR F5 OF fedex-rateio.cod_unid_negoc IN FRAME f_mop_01_fedex-rateio DO:

    /* fn_generic_zoom */
    run esp/acr/esacr004m.p.
    if  v_rec_unid_negoc <> ?
    then do:
        find unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign fedex-rateio.cod_unid_negoc:screen-value in frame f_mop_01_fedex-rateio =
               string(unid_negoc.cod_unid_negoc).

        display unid_negoc.des_unid_negoc
                with frame f_mop_01_fedex-rateio.

    end /* if */.
    apply "entry" to fedex-rateio.cod_unid_negoc in frame f_mop_01_fedex-rateio.
end. /* ON  CHOOSE OF bt_zoo_67475 IN FRAME f_mop_01_fedex-rateio */

/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_mop_01_fedex-rateio
DO:

    assign v_rec_fedex-rateio = v_rec_table_sav.
END. /* ON END-ERROR OF FRAME f_mop_01_fedex-rateio */

ON WINDOW-CLOSE OF FRAME f_mop_01_fedex-rateio
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_mop_01_fedex-rateio */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* Begin_Include: ix_p00_add_fedex-rateio */
/* **
 Controla se o erro deve ser enviado ao monitor ou a uma Temp Table.
 Os testes em tela da pi_vld s∆o feitos agora num vari†vel hadle.
***/
assign v_wgh_frame           = frame f_mop_01_fedex-rateio:handle
       v_dat_transacao       = p_dat_transacao.

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

assign v_ind_fluxo_movto_financ = "Sa°da" /*l_saida*/ .

/* tratamento do titulo e vers∆o */
assign frame f_mop_01_fedex-rateio:title = frame f_mop_01_fedex-rateio:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).

pause 0 before-hide.
view frame f_mop_01_fedex-rateio.

assign v_log_repeat   = yes
       v_rec_table    = v_rec_fedex-rateio.

main_block:
repeat while v_log_repeat:
    
    assign v_log_repeat  = no
           v_log_save_ok = no.

    find fedex-rateio where recid(fedex-rateio) = v_rec_table exclusive-lock no-error.

    FIND fedex NO-LOCK
        WHERE fedex.numero = fedex-rateio.numero.

    find estabelecimento no-lock
         where estabelecimento.cod_estab = fedex.cod_estab
          no-error.
    find plano_cta_ctbl no-lock
         where plano_cta_ctbl.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl
          no-error.
    find cta_ctbl no-lock
         where cta_ctbl.cod_cta_ctbl       = fedex-rateio.cod_cta_ctbl
           and cta_ctbl.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl
          no-error.
    find plano_ccusto no-lock
         where plano_ccusto.cod_empresa      = estabelecimento.cod_empresa
           and plano_ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto
          no-error.
    find ccusto no-lock
         where ccusto.cod_ccusto       = fedex-rateio.cod_ccusto
           and ccusto.cod_empresa      = estabelecimento.cod_empresa
           and ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto
          no-error.
    find unid_negoc no-lock
         where unid_negoc.cod_unid_negoc = fedex-rateio.cod_unid_negoc
          no-error.
    
    if  avail plano_ccusto
    then do:
        disp "" @ fedex-rateio.cod_ccusto with frame f_mop_01_fedex-rateio.
        assign fedex-rateio.cod_ccusto:format = plano_ccusto.cod_format_ccusto.
    end.

    if  not retry
    then do:
        display fedex-rateio.cod_cta_ctbl
                fedex-rateio.cod_unid_negoc
                fedex-rateio.cod_ccusto
                fedex-rateio.perc_aprop_ctbl
                with frame f_mop_01_fedex-rateio.
        display ccusto.des_tit_ctbl when avail ccusto
                "" when not avail ccusto @ ccusto.des_tit_ctbl
                cta_ctbl.des_tit_ctbl when avail cta_ctbl
                "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                unid_negoc.des_unid_negoc when avail unid_negoc
                "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
                with frame f_mop_01_fedex-rateio.
    end.
    enable fedex-rateio.cod_cta_ctbl
           fedex-rateio.cod_unid_negoc
           fedex-rateio.cod_ccusto
           fedex-rateio.perc_aprop_ctbl
           bt_ok
           bt_sav
           bt_can
           bt_zoo2
           with frame f_mop_01_fedex-rateio.

    assign v_val_tot_rat        = p_val_tit_ap
           v_val_sdo_rat_tit_ap = p_val_tit_ap.

    calculo_valores:
    for each b_fedex-rateio no-lock
        where b_fedex-rateio.numero = p_numero:
        assign v_val_sdo_rat_tit_ap = v_val_sdo_rat_tit_ap - b_fedex-rateio.perc_aprop_ctbl.
    end.

    display v_val_sdo_rat_tit_ap
            v_val_tot_rat
            with frame f_mop_01_fedex-rateio.

    run pi_ix_p20_mod_fedex-rateio.

    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        assign v_log_save = no
               v_rec_table = recid(fedex-rateio).
        find b_fedex-rateio_mod where recid(b_fedex-rateio_mod) = v_rec_table no-lock no-error.
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_mop_01_fedex-rateio focus v_wgh_focus.
        end.
        else do:
            wait-for go of frame f_mop_01_fedex-rateio.
        end.
        if  v_log_save = no
        then do:
            if  (fedex-rateio.cod_cta_ctbl:visible           in frame f_mop_01_fedex-rateio and
             fedex-rateio.cod_cta_ctbl:sensitive         in frame f_mop_01_fedex-rateio and
             input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl         <> fedex-rateio.cod_cta_ctbl        ) or
            (fedex-rateio.cod_unid_negoc:visible         in frame f_mop_01_fedex-rateio and
             fedex-rateio.cod_unid_negoc:sensitive       in frame f_mop_01_fedex-rateio and
             input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc       <> fedex-rateio.cod_unid_negoc      ) or
            (fedex-rateio.cod_ccusto:visible             in frame f_mop_01_fedex-rateio and
             fedex-rateio.cod_ccusto:sensitive           in frame f_mop_01_fedex-rateio and
             input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto           <> fedex-rateio.cod_ccusto          ) or
            (fedex-rateio.perc_aprop_ctbl:visible         in frame f_mop_01_fedex-rateio and
             fedex-rateio.perc_aprop_ctbl:sensitive       in frame f_mop_01_fedex-rateio and
             input frame f_mop_01_fedex-rateio fedex-rateio.perc_aprop_ctbl       <> fedex-rateio.perc_aprop_ctbl      )
            then do:
                message substitute("&1 sofreu alteraá‰es. Deseja salv†-las ?" /*l_mod_save*/ , "Apropriaá∆o Cont†bil Pendente")
                       view-as alert-box question buttons yes-no-cancel title substitute("&1", "1.00.00.000") update v_log_answer.
                assign v_log_save = v_log_answer.
            end.
        end.
        if  v_log_save = yes
        then do:
            save_block:
            do on error undo save_block, leave save_block:

                find cta_ctbl no-lock
                    where cta_ctbl.cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
                    and   cta_ctbl.cod_altern_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.

                if avail cta_ctbl then
                    assign fedex-rateio.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl.

                find b_fedex-rateio_mod no-lock
                     where b_fedex-rateio_mod.numero = p_numero
                       and b_fedex-rateio_mod.cod_plano_cta_ctbl = "PADRAO"
                       and b_fedex-rateio_mod.cod_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl
                       and b_fedex-rateio_mod.cod_unid_negoc = input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
                       and b_fedex-rateio_mod.cod_plano_ccusto = "PADRAO"
                       and b_fedex-rateio_mod.cod_ccusto = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto no-error.
                if  avail b_fedex-rateio_mod
                then do:
                    if  recid(b_fedex-rateio_mod) <> recid(fedex-rateio)
                    then do:
                        /* &1 j† existente ! */
                        run pi_messages (input "show",
                                         input 1,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            "Apropriaá∆o Cont†bil Pendente")).
                        apply "error" to self.
                    end.
                end.

                assign v_cdn_cont = 1.

                run pi_save_fields.
                run pi_vld_fedex-rateio.

                assign v_log_save_ok = yes.
            end.
        end.
        if  v_log_save = no
        then do:
            assign v_log_save_ok = yes.
        end.
    end.
end.

hide frame f_mop_01_fedex-rateio.

PROCEDURE pi_save_fields:

    assign_block:
    do on error undo assign_block, return error:
        do with frame f_mop_01_fedex-rateio:
        end.
        assign input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl
               input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
               input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto
               input frame f_mop_01_fedex-rateio fedex-rateio.perc_aprop_ctbl.
        assign v_wgh_focus = ?.
    end /* do assign_block */.

    /* Foráar a criaá∆o do registro com bases Oracle */
    if recid(fedex-rateio) <> ?  then.
END PROCEDURE.

PROCEDURE pi_vld_fedex-rateio:

    vld_block:
    do on error undo vld_block, return error:
        /* **  Verifica se foi informado algum valor para a Apropriaá∆o ***/
        if  fedex-rateio.perc_aprop_ctbl <= 0
        then do:

            assign v_num_mensagem   = 103 /* msg_103*/
                   v_cod_parameters = "Valor da Apropriaá∆o Cont†bil" /*l_valor_da_apropriacao_contabil*/ .
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "val_aprop_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input v_num_mensagem,
                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
        end /* if */.

        if  fedex-rateio.cod_plano_cta_ctbl = ""
        then do:
            assign v_num_mensagem   = 105 /* msg_105*/
                   v_cod_parameters = "Plano de Contas Cont†beis" /*l_plano_de_contas_contabeis*/ .
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_cta_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input v_num_mensagem,
                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
        end /* if */.
        if  fedex-rateio.cod_cta_ctbl = ""
        then do:
            assign v_num_mensagem   = 105 /* msg_105*/
                   v_cod_parameters = "Conta Cont†bil" /*l_conta_contabil*/ .
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input v_num_mensagem,
                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
        end.

        IF fedex-rateio.cod_ccusto <> "" 
        THEN DO:
             IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                             WHERE cc_uni_estab.cod_ccusto     = fedex-rateio.cod_ccusto
                               AND cc_uni_estab.cod_unid_negoc = fedex-rateio.cod_unid_negoc
                               AND cc_uni_estab.cod_estab      = fedex.cod_estab)
             THEN DO:
                  ASSIGN v_num_mensagem   = 524
                         v_cod_parameters = "Lanáamento n∆o Permitido,Relacionamento entre o Estabelecimento x CCusto x Unidade de Neg¢cio Inexistente!".
                  RUN pi_integr_apb_cria_msg_erro (INPUT "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                   INPUT fedex.cod_estab,
                                                   INPUT "Apropriaá∆o",
                                                   INPUT 0,
                                                   INPUT v_num_mensagem,
                                                   INPUT v_cod_parameters).
             END.
        END.

        /* **
         Esta chamada com parÉmetros Ç necess†ria para o programa de integraá∆o do APB
        ***/
        run pi_validar_rateio_ctbl_ap (Input p_dat_transacao,
                                       Input fedex.cod_estab,
                                       Input "",
                                       Input 0,
                                       Input p_val_tit_ap,
                                       Input NO) /*pi_validar_rateio_ctbl_ap*/.

    end /* do vld_block */.
END PROCEDURE. /* pi_vld_fedex-rateio */

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
        find b_fedex-rateio_mod no-lock
             where b_fedex-rateio_mod.numero = p_numero
               and b_fedex-rateio_mod.cod_plano_cta_ctbl = "PADRAO"
               and b_fedex-rateio_mod.cod_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl
               and b_fedex-rateio_mod.cod_unid_negoc = input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
               and b_fedex-rateio_mod.cod_plano_ccusto = "PADRAO"
               and b_fedex-rateio_mod.cod_ccusto = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto no-error.
        if  avail b_fedex-rateio_mod
        then do:
            if  recid(b_fedex-rateio_mod) <> recid(fedex-rateio)
            then do:
                /* &1 j† existente ! */
                run pi_messages (input "show",
                                 input 1,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "Apropriaá∆o Cont†bil Pendente")) /*msg_1*/.
                undo assign_block, return error.
            end /* if */.
        end /* if */.
        else do:
            do with frame f_mop_01_fedex-rateio:
            end.
            assign input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl
                   input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
                   input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto no-error.
        end /* else */.
    end /* do assign_block */.

END PROCEDURE. /* pi_save_key */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_plano_cta_ctbl_prim
** Descricao.............: pi_retornar_plano_cta_ctbl_prim
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre17230
** Alterado em...........: 04/10/2000 17:10:08
*****************************************************************************/
PROCEDURE pi_retornar_plano_cta_ctbl_prim:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_organ
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def output param p_log_plano_cta_ctbl_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    calcula_block:
    for each plano_cta_unid_organ no-lock
     where plano_cta_unid_organ.cod_unid_organ = p_cod_unid_organ
       and plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio" /*cl_retorna_plano_cta_ctbl_prim of plano_cta_unid_organ*/:
        if  p_dat_refer_ent = ?
        or (plano_cta_unid_organ.dat_inic_valid <= p_dat_refer_ent
        and plano_cta_unid_organ.dat_fim_valid >= p_dat_refer_ent)
        then do:
            assign v_cod_return         = v_cod_return + "," + plano_cta_unid_organ.cod_plano_cta_ctbl
                   p_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.
        end /* if */.
    end /* for calcula_block */.

    if  num-entries(v_cod_return) = 2
    then do:
        assign p_log_plano_cta_ctbl_uni = yes.
    end /* if */.
    else do:
        assign p_log_plano_cta_ctbl_uni = no.
    end /* else */.
END PROCEDURE. /* pi_retornar_plano_cta_ctbl_prim */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_unid_negoc_unico
** Descricao.............: pi_verificar_unid_negoc_unico
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre17205
** Alterado em...........: 24/10/2000 10:17:33
*****************************************************************************/
PROCEDURE pi_verificar_unid_negoc_unico:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def output param p_log_unid_negoc_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_cod_unid_negoc     = ""
           p_log_unid_negoc_uni = yes.
    calcula_block:
    for each estab_unid_negoc no-lock
        where estab_unid_negoc.cod_estab = estabelecimento.cod_estab:
        if  p_dat_refer_ent = ?
        or (estab_unid_negoc.dat_inic_valid <= p_dat_refer_ent
        and estab_unid_negoc.dat_fim_valid >= p_dat_refer_ent)
        then do:
            If v_cod_return = "" then
               assign v_cod_return         = estab_unid_negoc.cod_unid_negoc.
            else 
                assign v_cod_return         = v_cod_return + "," + estab_unid_negoc.cod_unid_negoc.
            assign p_cod_unid_negoc     = estab_unid_negoc.cod_unid_negoc.
        end /* if */.
    end /* for calcula_block */.
    if  num-entries(v_cod_return) >= 2
    then do:
        assign p_log_unid_negoc_uni = no.
    end /* if */.

END PROCEDURE. /* pi_verificar_unid_negoc_unico */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_inic_zero
** Descricao.............: pi_retornar_inic_zero
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut35059
** Alterado em...........: 30/01/2006 14:29:38
*****************************************************************************/
PROCEDURE pi_retornar_inic_zero:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_attrib
        as widget-handle
        format ">>>>>>9"
        no-undo.
    def Input param p_cod_format_cta_ctbl
        as character
        format "x(20)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cta_ctbl_000
        as character
        format "x(20)":U
        label "Conta Cont†bil"
        column-label "Conta Cont†bil"
        no-undo.
    def var v_num_count_cta
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count_cta = 1.
           v_cod_cta_ctbl_000 = "".

    contador:
    do while v_num_count_cta <= length(p_cod_format_cta_ctbl):
        if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) <> "-"
        and substring(p_cod_format_cta_ctbl,v_num_count_cta,1) <> "."
        then do:
            if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "!"
            then do:
                assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "9"
                then do:
                    assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "0".
                end /* if */.
                else do:
                    if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "x" /*l_x*/ 
                    then do:
                        assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "A" /*l_A*/ .
                    end /* if */.
                    else do:
                        assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + keylabel(32).
                    end /* else */.
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count_cta = v_num_count_cta + 1.
    end /* do contador */.

    assign p_wgh_attrib:format       = 'x(50)'
           p_wgh_attrib:screen-value = v_cod_cta_ctbl_000
           p_wgh_attrib:format       = p_cod_format_cta_ctbl.
END PROCEDURE. /* pi_retornar_inic_zero */
/*****************************************************************************
** Procedure Interna.....: pi_validar_rateio_ctbl_ap
** Descricao.............: pi_validar_rateio_ctbl_ap
** Criado por............: Creuz
** Criado em.............: 26/07/1996 14:14:40
** Alterado por..........: fut12161
** Alterado em...........: 29/05/2007 16:46:12
*****************************************************************************/
PROCEDURE pi_validar_rateio_ctbl_ap:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_num_seq_refer
        as integer
        format ">>>9"
        no-undo.
    def Input param p_val_tit_ap
        as decimal
        format "->>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_rec_impto_impl_pend_ap
        as recid
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_log_abat_prov
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_log_answer
        as logical
        format "Sim/N∆o"
        initial yes
        view-as toggle-box
        no-undo.
    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_log_tip_recta_despes_empres
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_num_mensagem
        as integer
        format ">>>>,>>9":U
        label "N£mero"
        column-label "N£mero Mensagem"
        no-undo.
    def var v_rec_fedex-rateio
        as recid
        format ">>>>>>9":U
        initial ?
        no-undo.
    DEF VAR v_val_sdo_rat_tit_ap AS DEC NO-UNDO.

    /************************** Variable Definition End *************************/

    /* verificar se existe provis∆o no mesmo valor do t°tulo*/

    assign v_log_abat_prov = no
           v_val_abat_prov = 0.

    validar_block:
    do on error undo validar_block, return error:

        /* ** Valida Conta Cont†bil de Integraá∆o ***/
        if not v_log_abat_prov then do:
                run prgint/utb/utb719za.py (input fedex-rateio.cod_plano_cta_ctbl,
                                            input fedex-rateio.cod_cta_ctbl,
                                            input "APB" /*l_apb*/ ,
                                            input "Conta Movimento" /*l_conta_movimento*/ ,
                                            input p_dat_transacao,
                                            input p_dat_transacao,
                                            input estabelecimento.cod_empresa,
                                            output v_log_return).

                if v_log_return = no then do:
                    case GetEntryField(1,v_cod_param_msg_erro_valid,chr(10)):
                        when '954' then do:
                            assign v_num_mensagem = 954
                                   v_cod_parameters = GetEntryField(2,v_cod_param_msg_erro_valid,chr(10)) + ", APB, " + GetEntryField(3,v_cod_param_msg_erro_valid,chr(10)).
                        end.
                        when '18544' then do:                                                                           
                            assign v_num_mensagem = 18544
                                   v_cod_parameters = GetEntryField(2,v_cod_param_msg_erro_valid,chr(10)).
                        end.
                        when '18545' then do:
                            assign v_num_mensagem = 18545
                                   v_cod_parameters = GetEntryField(2,v_cod_param_msg_erro_valid,chr(10)).
                        end.
                        when '18546' then do:                                                                           
                            assign v_num_mensagem = 18546
                                   v_cod_parameters = GetEntryField(2,v_cod_param_msg_erro_valid,chr(10)).
                        end.
                        when '18547' then do:                                                                            
                            assign v_num_mensagem = 18547
                                   v_cod_parameters = GetEntryField(2,v_cod_param_msg_erro_valid,chr(10)) + "," + GetEntryField(3,v_cod_param_msg_erro_valid,chr(10)).
                        end.
                    end.

                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input v_num_mensagem,
                                                     Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                end.
        end.

        /* ** Valida Unidade de Neg¢cio ***/
            if  not can-find( first unid_negoc
                              where unid_negoc.cod_unid_negoc = fedex-rateio.cod_unid_negoc) then do:

                assign v_num_mensagem   = 8433 /* msg_8433 */
                       v_cod_parameters = 'Unidade de Neg¢cio' + "," + 'Unidades de Neg¢cio' + "," + fedex-rateio.cod_unid_negoc.
                run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_unid_negoc",
                                                 Input fedex.cod_estab,
                                                 Input "Apropriaá∆o" /*l_apropriacao*/,
                                                 Input 0,
                                                 Input v_num_mensagem,
                                                 Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
            end.
            else do:
                    find first unid_negoc no-lock
                         where unid_negoc.cod_unid_negoc = fedex-rateio.cod_unid_negoc no-error.
                    if avail unid_negoc then do:
                        if unid_negoc.ind_espec_unid_negoc = "SintÇtica" /*l_sintetica*/  then do:
                            assign v_num_mensagem   = 10839 /* msg_10839 */
                                   v_cod_parameters = "".
                            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_unid_negoc",
                                                             Input fedex.cod_estab,
                                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                                             Input 0,
                                                             Input v_num_mensagem,
                                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                        end.
                    end.

                run pi_validar_unid_negoc (Input fedex.cod_estab,
                                           Input fedex-rateio.cod_unid_negoc,
                                           Input p_dat_transacao,
                                           output v_cod_return) /*pi_validar_unid_negoc*/.
                 if  v_cod_return <> "" then do:
                    if  v_cod_return = "Estabelecimento" /*l_estabelecimento*/  then
                        assign v_num_mensagem   = 8450 /* msg_8450 */
                               v_cod_parameters = fedex.cod_estab + "," + fedex-rateio.cod_unid_negoc.
                    if  v_cod_return = "Data" /*l_data*/  then
                        assign v_num_mensagem   = 8451 /* msg_8451 */
                               v_cod_parameters = fedex-rateio.cod_unid_negoc + "," + fedex.cod_estab + "," + string(estab_unid_negoc.dat_inic_valid) + "," + string(estab_unid_negoc.dat_fim_valid).
                    if  v_cod_return = "Usu†rio" /*l_usuario*/  then
                        assign v_num_mensagem   = 8452 /* msg_8452 */
                               v_cod_parameters = fedex-rateio.cod_unid_negoc.

                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_unid_negoc",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input v_num_mensagem,
                                                     Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                end.
            end.
        if v_log_abat_prov = no then do:
        /* ** Valida Plano de Centro de Custos ***/
            if  v_ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/  then do:
                if  fedex-rateio.cod_plano_ccusto <> "" 
                or  fedex-rateio.cod_ccusto <> "" then do:
                    assign v_num_mensagem   = 9091
                           v_cod_parameters = ''.

                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_ccusto",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input v_num_mensagem,
                                                     Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                end.
            end.    
            ELSE DO:
                if  not can-find( first plano_ccusto
                                  where plano_ccusto.cod_empresa      = estabelecimento.cod_empresa
                                    and plano_ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto) then do:
                    if  fedex-rateio.cod_plano_ccusto = "" then do:
                        assign v_num_mensagem   = 5455 /* msg_5455 */
                               v_cod_parameters = fedex-rateio.cod_cta_ctbl.

                        run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_ccusto",
                                                         Input fedex.cod_estab,
                                                         Input "Apropriaá∆o" /*l_apropriacao*/,
                                                         Input 0,
                                                         Input v_num_mensagem,
                                                         Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                    end.
                    else do:
                        assign v_num_mensagem   = 8433 /* msg_8433 */
                               v_cod_parameters = "Plano Centros Custo" + "," + "Planos Centros Custo" + "," + fedex-rateio.cod_plano_ccusto.

                        run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_ccusto",
                                                         Input fedex.cod_estab,
                                                         Input "Apropriaá∆o" /*l_apropriacao*/,
                                                         Input 0,
                                                         Input v_num_mensagem,
                                                         Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                    end.
                end.
                else do:
                    run pi_validar_plano_ccusto (Input estabelecimento.cod_empresa,
                                                 Input fedex-rateio.cod_plano_ccusto,
                                                 Input p_dat_transacao,
                                                 output v_log_return) /*pi_validar_plano_ccusto*/.
                    if  v_log_return = no then do:
                        assign v_num_mensagem   = 8455 /* msg_8455 */
                               v_cod_parameters = fedex-rateio.cod_plano_ccusto.
                        run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_ccusto",
                                                         Input fedex.cod_estab,
                                                         Input "Apropriaá∆o" /*l_apropriacao*/,
                                                         Input 0,
                                                         Input v_num_mensagem,
                                                         Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                    end.
                    /* ** Valida CCusto ***/
                    if  not can-find( first emscad.ccusto
                                      where ccusto.cod_empresa      = estabelecimento.cod_empresa
                                        and ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto
                                        and ccusto.cod_ccusto       = fedex-rateio.cod_ccusto) then do:
                        if  fedex-rateio.cod_ccusto = "" then do:

                            assign v_num_mensagem   = 5455 /* msg_5455 */
                                   v_cod_parameters = fedex-rateio.cod_cta_ctbl.
                            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_plano_ccusto",
                                                             Input fedex.cod_estab,
                                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                                             Input 0,
                                                             Input v_num_mensagem,
                                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                        end.
                        else do:

                            assign v_num_mensagem   = 8433 /* msg_8433 */
                                   v_cod_parameters = "Centro Custo" + "," + "Centros Custo" + "," + fedex-rateio.cod_ccusto.
                            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_ccusto",
                                                             Input fedex.cod_estab,
                                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                                             Input 0,
                                                             Input v_num_mensagem,
                                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                        end.
                    end.
                    else do:
                        run pi_validar_ccusto (Input estabelecimento.cod_empresa,
                                               Input fedex-rateio.cod_plano_ccusto,
                                               Input fedex-rateio.cod_ccusto,
                                               Input p_dat_transacao,
                                               Input p_dat_transacao,
                                               output v_log_return) /*pi_validar_ccusto*/.
                        if  v_log_return = no then do:

                            assign v_num_mensagem   = 8433 /* msg_8433 */.
                                   v_cod_parameters = "Centro Custo" + "," + "Centros Custo" + "," + fedex-rateio.cod_ccusto.                     
                            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_ccusto",
                                                             Input fedex.cod_estab,
                                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                                             Input 0,
                                                             Input v_num_mensagem,
                                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                        end.
                        run pi_validar_ccusto_unid_negoc_estab (Input estabelecimento.cod_empresa,
                                                                Input fedex-rateio.cod_plano_ccusto,
                                                                Input fedex-rateio.cod_ccusto,
                                                                Input fedex-rateio.cod_unid_negoc,
                                                                Input fedex.cod_estab,
                                                                output v_num_mensagem) /*pi_validar_ccusto_unid_negoc_estab*/.
                        if  v_num_mensagem <> 0 then do:
                            /* case_block: */
                            case v_num_mensagem:
                                when 950 then assign v_num_mensagem   = 950 /* msg_950 */
                                                     v_cod_parameters = fedex-rateio.cod_unid_negoc + "," + fedex.cod_estab.
                                when 1253 then assign v_num_mensagem   = 2230 /* msg_2230 */
                                                     v_cod_parameters = fedex-rateio.cod_ccusto + "," + fedex-rateio.cod_plano_ccusto + "," + fedex-rateio.cod_unid_negoc.
                                when 1388 then assign v_num_mensagem   = 8456 /* msg_8456 */
                                                     v_cod_parameters = fedex.cod_estab + "," + fedex-rateio.cod_ccusto.
                            end /* case case_block */.

                            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_ccusto",
                                                             Input fedex.cod_estab,
                                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                                             Input 0,
                                                             Input v_num_mensagem,
                                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                        end.
                    end.
                end.
            END.

            /* ** Outras validaá‰es da Conta Cont†bil. ***/
            if (fedex-rateio.cod_plano_cta_ctbl <> ""
            or  fedex-rateio.cod_cta_ctbl <> "") then
                run pi_verifica_outras_valid_cta_ctbl_rateio_apb (Input p_dat_transacao) /*pi_verifica_outras_valid_cta_ctbl_rateio_apb*/.
        end. /* provis∆o*/


        ASSIGN v_val_sdo_rat_tit_ap = p_val_tit_ap.

        for each b_fedex-rateio no-lock
            where b_fedex-rateio.numero = p_numero:
            assign v_val_sdo_rat_tit_ap = v_val_sdo_rat_tit_ap - b_fedex-rateio.perc_aprop_ctbl.
        end.
        
        if  v_val_sdo_rat_tit_ap < 0
        then do:
            assign v_num_mensagem   = 799 /* msg_799 */.
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "val_aprop_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input v_num_mensagem,
                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
        end.

       /* N∆o valida conta de Saldo se a especie n∆o contabilizar ou for um PEF via API, se for PEF on-line apresenta mensagem de question
         nos outros casos ir†ˇ apresentar error */
        find first cta_ctbl no-lock
             where cta_ctbl.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl
               and cta_ctbl.cod_cta_ctbl       = fedex-rateio.cod_cta_ctbl no-error.
        if  avail cta_ctbl
        then do:
            find first cta_grp_fornec no-lock
                 where cta_grp_fornec.cod_empresa        = v_cod_empres_usuar
                   and cta_grp_fornec.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl 
                   and cta_grp_fornec.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                   and cta_grp_fornec.ind_finalid_ctbl   = "Saldo" /*l_saldo*/ 
                   and cta_grp_fornec.dat_inic_valid    <= p_dat_transacao
                   and cta_grp_fornec.dat_fim_valid     >= p_dat_transacao no-error.
            if  avail cta_grp_fornec
            then do:
                find first antecip_pef_pend no-lock
                     where antecip_pef_pend.cod_estab = p_cod_estab
                     and   antecip_pef_pend.cod_refer = p_cod_refer no-error.                   
                if not (avail antecip_pef_pend and antecip_pef_pend.ind_tip_refer = "Pagto Extra Fornecedor" /*l_pagto_extra_fornecedor*/ ) then do:
                    assign v_num_mensagem   = 13779
                           v_cod_parameters = cta_grp_fornec.cod_empresa + "," + "Normal" + "," + cta_grp_fornec.cod_espec_docto + "," + cta_grp_fornec.cod_grp_fornec + "," + cta_grp_fornec.cod_finalid_econ.
                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "val_aprop_ctbl",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input v_num_mensagem,
                                                     Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                end.
            end /* if */.
        end /* if */.
    end /* do validar_block */.
END PROCEDURE. /* pi_validar_rateio_ctbl_ap */
/*****************************************************************************
** Procedure Interna.....: pi_validar_unid_negoc
** Descricao.............: pi_validar_unid_negoc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: lucas
** Alterado em...........: 01/12/1999 15:27:57
*****************************************************************************/
PROCEDURE pi_validar_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return                     as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign p_cod_return = "".
    find first param_utiliz_produt no-lock
         where param_utiliz_produt.cod_empresa = estabelecimento.cod_empresa
           and param_utiliz_produt.cod_modul_dtsul = ''
           and param_utiliz_produt.cod_funcao_negoc = 'BU' /*cl_verifica_unid_negoc of param_utiliz_produt*/ no-error.
    if  avail param_utiliz_produt
    then do:
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  avail estab_unid_negoc
        then do:
            if  p_dat_refer_ent <> ? and
               (estab_unid_negoc.dat_inic_valid > p_dat_refer_ent or
                estab_unid_negoc.dat_fim_valid  < p_dat_refer_ent)
            then do:
                 assign p_cod_return = "Data" /*l_data*/ .
                 return.
            end /* if */.
            
            assign p_cod_return = "".
            return.

        end /* if */.
        else do:
            assign p_cod_return = "Estabelecimento" /*l_estabelecimento*/ .
        end /* else */.
    end /* if */.

END PROCEDURE. /* pi_validar_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto
** Descricao.............: pi_validar_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Puccini
** Alterado em...........: 16/10/1998 10:09:15
*****************************************************************************/
PROCEDURE pi_validar_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_inic_valid
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim_valid
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    p_log_return = no.
    find first emscad.ccusto no-lock
         where ccusto.cod_empresa      = p_cod_empresa
           and ccusto.cod_plano_ccusto = p_cod_plano_ccusto
           and ccusto.cod_ccusto       = p_cod_ccusto no-error.
    if  not avail ccusto
    then do:
        return.
    end /* if */.
    find first plano_ccusto no-lock
         where plano_ccusto.cod_empresa = ccusto.cod_empresa
           and plano_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
          no-error.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid <> ?
    then do:
        if  not(ccusto.dat_inic_valid <= p_dat_inic_valid
        and ccusto.dat_fim_valid  >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
        if  not(plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        and plano_ccusto.dat_fim_valid >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid = ?
    then do:
        if  not ccusto.dat_inic_valid <= p_dat_inic_valid
        or  not ccusto.dat_fim_valid >= p_dat_inic_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid = ? and p_dat_fim_valid <> ?
    then do:
        if  not ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    assign p_log_return = yes.
END PROCEDURE. /* pi_validar_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto_unid_negoc_estab
** Descricao.............: pi_validar_ccusto_unid_negoc_estab
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: Rafael
** Alterado em...........: 21/08/1997 15:17:43
*****************************************************************************/
PROCEDURE pi_validar_ccusto_unid_negoc_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def output param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.


    /************************** Variable Definition End *************************/

    if  p_cod_estab <> "" and
        p_cod_unid_negoc <> ""
    then do:
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  not avail estab_unid_negoc
        then do:
            assign p_num_mensagem = 950.
            return.
        end /* if */.
    end /* if */.
    if  avail plano_ccusto and
        plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto and
        plano_ccusto.cod_empresa = p_cod_empresa
    then do:
        run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                     output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
        if  p_cod_plano_ccusto <> ""
        then do:
           find plano_ccusto no-lock
                where plano_ccusto.cod_empresa = p_cod_empresa
                  and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
           if  avail plano_ccusto
           then do:
              run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                           output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
           end /* if */.
           else do:
              assign v_cod_ccusto_000 = "".
           end /* else */.
        end /* if */.
        else do:
           assign v_cod_ccusto_000 = "".
        end /* else */.
    end /* else */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_unid_negoc   <> ""
    then do:
        find ccusto_unid_negoc no-lock
             where ccusto_unid_negoc.cod_empresa = p_cod_empresa
               and ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto
               and ccusto_unid_negoc.cod_ccusto = p_cod_ccusto
               and ccusto_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_validar_ccusto_unid_negoc_estab of ccusto_unid_negoc*/ no-error.
        if  not avail ccusto_unid_negoc
        then do:
            assign p_num_mensagem = 1253.
            return.
        end /* if */.
    end /* if */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_estab        <> ""
    then do:
        find restric_ccusto no-lock
             where restric_ccusto.cod_empresa = p_cod_empresa
               and restric_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and restric_ccusto.cod_ccusto = p_cod_ccusto
               and restric_ccusto.cod_estab = p_cod_estab /*cl_validar_ccusto_unid_negoc_estab of restric_ccusto*/ no-error.
        if  avail restric_ccusto
        then do:
            assign p_num_mensagem = 1388.
            return.
        end /* if */.
    end /* if */.
    assign p_num_mensagem = 0.
END PROCEDURE. /* pi_validar_ccusto_unid_negoc_estab */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_ccusto_inic
** Descricao.............: pi_retornar_ccusto_inic
** Criado por............: pasold
** Criado em.............: 26/08/1996 14:12:15
** Alterado por..........: bre18473
** Alterado em...........: 17/02/2000 09:58:41
*****************************************************************************/
PROCEDURE pi_retornar_ccusto_inic:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format_ccusto
        as character
        format "x(11)"
        no-undo.
    def output param p_cod_ccusto_000
        as Character
        format "x(11)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count = 1.
           v_cod_ccusto_000 = "".

    contador:
    do while v_num_count <= length(p_cod_format_ccusto):
        if  substring(p_cod_format_ccusto,v_num_count,1) <> "-"
        and substring(p_cod_format_ccusto,v_num_count,1) <> ","
        and substring(p_cod_format_ccusto,v_num_count,1) <> "."
        then do:
            if  substring(p_cod_format_ccusto,v_num_count,1) = "!"
            then do:
                assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_ccusto,v_num_count,1) = "9"
                or  substring(p_cod_format_ccusto,v_num_count,1) = "x" /*l_X*/ 
                then do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + "0".
                end /* if */.
                else do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(32).
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
    assign p_cod_ccusto_000 = v_cod_ccusto_000.
END PROCEDURE. /* pi_retornar_ccusto_inic */
/*****************************************************************************
** Procedure Interna.....: pi_validar_plano_ccusto
** Descricao.............: pi_validar_plano_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 24/06/1995 16:32:19
*****************************************************************************/
PROCEDURE pi_validar_plano_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_plano_ccusto_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    find plano_ccusto no-lock
         where plano_ccusto.cod_empresa = p_cod_empresa
           and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
    if  avail plano_ccusto
    then do:
        if  p_dat_refer_ent = ? or
           (plano_ccusto.dat_inic_valid <= p_dat_refer_ent and
            plano_ccusto.dat_fim_valid  >= p_dat_refer_ent)
        then do:
               assign p_log_plano_ccusto_val = yes.
        end /* if */.
        else do:
            assign p_log_plano_ccusto_val = no.
        end /* else */.
    end /* if */.
    else do:
        assign p_log_plano_ccusto_val = no.
    end /* else */.


END PROCEDURE. /* pi_validar_plano_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_outras_valid_cta_ctbl_rateio_apb
** Descricao.............: pi_verifica_outras_valid_cta_ctbl_rateio_apb
** Criado por............: Rafael
** Criado em.............: 08/08/1997 10:13:17
** Alterado por..........: fut1090_2
** Alterado em...........: 29/10/2004 16:25:45
*****************************************************************************/
PROCEDURE pi_verifica_outras_valid_cta_ctbl_rateio_apb:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_ccusto_val                 as logical         no-undo. /*local*/
    def var v_log_plano_ccusto_val           as logical         no-undo. /*local*/
    def var v_log_plano_cta_ctbl_val         as logical         no-undo. /*local*/
    def var v_log_return                     as logical         no-undo. /*local*/
    def var v_log_valid                      as logical         no-undo. /*local*/
    def var v_num_cont_1                     as integer         no-undo. /*local*/
    

    /************************** Variable Definition End *************************/

    /* --- IMPORTANTE: AO ALTERAR ESTA PI, DEVE-SE ALTERAR TAMBêM A 
    PI_VERIFICA_INCONS_APROP_APB ---*/

    vld_block:
    do on error undo vld_block, return error:

        /* ** Valida a conta cont†bil ***/
        run pi_valida_cta_ctbl (Input fedex-rateio.cod_plano_cta_ctbl,
                                Input fedex-rateio.cod_cta_ctbl,
                                Input p_dat_transacao,
                                output v_log_return) /*pi_valida_cta_ctbl*/. 
        if  v_log_return = no then do:
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input 1131,
                                             Input "") /*pi_integr_apb_cria_msg_erro*/.
        end.

        /* ** Valida o plano de contas ***/
        run pi_validar_plano_cta_ctbl (Input fedex-rateio.cod_plano_cta_ctbl,
                                       Input estabelecimento.cod_empresa,
                                       Input p_dat_transacao,
                                       output v_log_plano_cta_ctbl_val) /*pi_validar_plano_cta_ctbl*/. 
        if  v_log_plano_cta_ctbl_val = no then do:
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input 1122,
                                             Input "") /*pi_integr_apb_cria_msg_erro*/.
        end.

        /* ** Verifica se o Estabelecimento Ç v†lido para a Conta Cont†bil ***/
        if  can-find(cta_restric_estab where
                     cta_restric_estab.cod_unid_organ     = estabelecimento.cod_empresa and
                     cta_restric_estab.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl and
                     cta_restric_estab.cod_cta_ctbl       = fedex-rateio.cod_cta_ctbl and
                     cta_restric_estab.cod_estab          = fedex.cod_estab) then do:
            assign v_num_mensagem   = 8489 /* msg_8489 */
                   v_cod_parameters = "Estabelecimento" /*l_estabelecimento*/  + "," + fedex-rateio.cod_cta_ctbl + "," + fedex.cod_estab + "," + "no" /*l_no*/ .
            run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                             Input fedex.cod_estab,
                                             Input "Apropriaá∆o" /*l_apropriacao*/,
                                             Input 0,
                                             Input v_num_mensagem,
                                             Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
        end.
        if avail cta_grp_fornec
        then do:
            if  fedex-rateio.cod_plano_cta_ctbl = cta_grp_fornec.cod_plano_cta_ctbl
            and fedex-rateio.cod_cta_ctbl       = cta_grp_fornec.cod_cta_ctbl
            then do:
                assign v_num_mensagem   = 13202 /* msg_13202*/
                       v_cod_parameters = string(fedex-rateio.cod_cta_ctbl).
                run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                 Input fedex.cod_estab,
                                                 Input "Apropriaá∆o" /*l_apropriacao*/,
                                                 Input 0,
                                                 Input v_num_mensagem,
                                                 Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
            end.
        end.
            /* ** Verifica se a Unidade de Neg¢cio Ç v†lida para a Conta Cont†bil ***/
            if  can-find(cta_restric_unid_negoc where
                         cta_restric_unid_negoc.cod_unid_organ     = estabelecimento.cod_empresa and
                         cta_restric_unid_negoc.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl and
                         cta_restric_unid_negoc.cod_cta_ctbl       = fedex-rateio.cod_cta_ctbl and
                         cta_restric_unid_negoc.cod_unid_negoc     = fedex-rateio.cod_unid_negoc) then do:
                assign v_num_mensagem   = 8489 /* msg_8489 */
                           v_cod_parameters = "Unidade de Neg¢cio" /*l_unidade_de_negocio*/  + "," + fedex-rateio.cod_cta_ctbl + "," + fedex-rateio.cod_unid_negoc + "," + "na" /*l_na*/ .
                run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                 Input fedex.cod_estab,
                                                 Input "Apropriaá∆o" /*l_apropriacao*/,
                                                 Input 0,
                                                 Input v_num_mensagem,
                                                 Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
            end.
            /* ** Posiciona CritÇrio de Distribuiá∆o e Conta Cont†bil ***/
            find cta_ctbl no-lock
                 where cta_ctbl.cod_cta_ctbl = fedex-rateio.cod_cta_ctbl
                   and cta_ctbl.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl
                  no-error.
            find criter_distrib_cta_ctbl no-lock
                 where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = fedex-rateio.cod_plano_cta_ctbl
                   and criter_distrib_cta_ctbl.cod_cta_ctbl       = fedex-rateio.cod_cta_ctbl
                   and criter_distrib_cta_ctbl.cod_estab          = fedex.cod_estab
                   and criter_distrib_cta_ctbl.dat_inic_valid    <= p_dat_transacao
                   and criter_distrib_cta_ctbl.dat_fim_valid     >  p_dat_transacao
                 no-error.
            if  avail criter_distrib_cta_ctbl
            and criter_distrib_cta_ctbl.ind_criter_distrib_ccusto <> "N∆o Utiliza" /*l_nao_utiliza*/  then do:

                /* ** Valida o plano de centro de custo ***/
                run pi_validar_plano_ccusto (Input estabelecimento.cod_empresa,
                                             Input fedex-rateio.cod_plano_ccusto,
                                             Input p_dat_transacao,
                                             output v_log_plano_ccusto_val) /*pi_validar_plano_ccusto*/. 
                if  v_log_plano_ccusto_val = no then do:
                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input 852,
                                                     Input "") /*pi_integr_apb_cria_msg_erro*/.
                end.

                /* ** Valida o centro de custo ***/
                run pi_validar_ccusto (Input estabelecimento.cod_empresa,
                                       Input fedex-rateio.cod_plano_ccusto,
                                       Input fedex-rateio.cod_ccusto,
                                       Input p_dat_transacao,
                                       Input p_dat_transacao,
                                       output v_log_ccusto_val) /*pi_validar_ccusto*/.
                if  v_log_ccusto_val = no then do:
                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input 1136,
                                                     Input "") /*pi_integr_apb_cria_msg_erro*/.
                end.

                if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
                then do:
                    find item_lista_ccusto no-lock where
                         item_lista_ccusto.cod_estab = fedex.cod_estab and
                         item_lista_ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto and
                         item_lista_ccusto.cod_ccusto = fedex-rateio.cod_ccusto and
                         item_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto no-error.
                    if  not avail item_lista_ccusto
                    then do:
                        assign v_num_mensagem   = 5503
                               v_cod_parameters = fedex-rateio.cod_ccusto + "," + fedex-rateio.cod_cta_ctbl + "," + string( p_dat_transacao ).
                        run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                         Input fedex.cod_estab,
                                                         Input "Apropriaá∆o" /*l_apropriacao*/,
                                                         Input 0,
                                                         Input v_num_mensagem,
                                                         Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                    end.
                end.
                if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Autom†tico" /*l_automatico*/ then do:
                    find item_distrib_ccusto no-lock where
                         item_distrib_ccusto.cod_estab = fedex.cod_estab and
                         item_distrib_ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto and
                         item_distrib_ccusto.cod_ccusto = fedex-rateio.cod_ccusto and
                         item_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto no-error.
                    if  not avail item_distrib_ccusto
                    then do:
                        assign v_num_mensagem   = 5503
                               v_cod_parameters = fedex-rateio.cod_ccusto + "," + fedex-rateio.cod_cta_ctbl + "," + string( p_dat_transacao ).
                        run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_cta_ctbl",
                                                         Input fedex.cod_estab,
                                                         Input "Apropriaá∆o" /*l_apropriacao*/,
                                                         Input 0,
                                                         Input v_num_mensagem,
                                                         Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                    end.
                end.

                /* Verifica restriá‰es de Estabelecimento para o Centro de Custo */
                if  can-find(restric_ccusto where
                             restric_ccusto.cod_empresa      = estabelecimento.cod_empresa and
                             restric_ccusto.cod_plano_ccusto = fedex-rateio.cod_plano_ccusto and
                             restric_ccusto.cod_ccusto       = fedex-rateio.cod_ccusto and
                             restric_ccusto.cod_estab        = fedex.cod_estab) then do:
                    assign v_num_mensagem   = 35
                           v_cod_parameters = fedex.cod_estab + "," + fedex-rateio.cod_ccusto.
                    run pi_integr_apb_cria_msg_erro (Input "fedex-rateio":U + "." + "cod_ccusto",
                                                     Input fedex.cod_estab,
                                                     Input "Apropriaá∆o" /*l_apropriacao*/,
                                                     Input 0,
                                                     Input v_num_mensagem,
                                                     Input v_cod_parameters) /*pi_integr_apb_cria_msg_erro*/.
                end.

        end.
    end.

END PROCEDURE. /* pi_verifica_outras_valid_cta_ctbl_rateio_apb */
/*****************************************************************************
** Procedure Interna.....: pi_integr_apb_cria_msg_erro
** Descricao.............: pi_integr_apb_cria_msg_erro
** Criado por............: Roberto
** Criado em.............: 07/05/1997 08:13:38
** Alterado por..........: bre18490
** Alterado em...........: 15/04/1999 17:49:40
*****************************************************************************/
PROCEDURE pi_integr_apb_cria_msg_erro:

    /************************ Parameter Definition Begin ************************/

    def Input param p_nom_attrib
        as character
        format "x(30)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_ind_tip_relacto
        as character
        format "X(15)"
        no-undo.
    def Input param p_num_relacto
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_parameters
        as character
        format "x(256)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_ajuda
        as character
        format "x(50)":U
        view-as editor max-chars 2000 scrollbar-vertical
        size 50 by 3
        bgcolor 15 font 2
        label "Ajuda"
        column-label "Ajuda"
        no-undo.
    def var v_des_mensagem
        as character
        format "x(50)":U
        view-as editor max-chars 2000 scrollbar-vertical
        size 50 by 4
        bgcolor 15 font 2
        label "Mensagem"
        column-label "Mensagem"
        no-undo.
    def var v_num_mensagem
        as integer
        format ">>>>,>>9":U
        label "N£mero"
        column-label "N£mero Mensagem"
        no-undo.
    def var v_wgh_attrib
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_num_count                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_mensagem = p_num_mensagem. 

    if valid-handle( v_wgh_frame ) then do: 
        assign v_wgh_attrib = v_wgh_frame:first-child 
               v_wgh_attrib = v_wgh_attrib:first-child. 

        proc_atrib_block: 
        do while valid-handle( v_wgh_attrib ): 
            if  v_wgh_attrib:table <> ? then do:
                if  v_wgh_attrib:table + "." + v_wgh_attrib:name = p_nom_attrib then do: 
                    leave proc_atrib_block. 
                end. 
            end.
            else do:
                if  v_wgh_attrib:name = p_nom_attrib then do: 
                    leave proc_atrib_block. 
                end.
            end.     
            assign v_wgh_attrib = v_wgh_attrib:next-sibling. 
        end /* do proc_atrib_block */. 
    end. 

    do  v_num_count = num-entries( p_cod_parameters ) to 9: 
        assign p_cod_parameters = p_cod_parameters + ",". 
    end. 

    run pi_messages (input "show",
                     input v_num_mensagem,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                        entry( 1, p_cod_parameters ),                                  entry( 2, p_cod_parameters ),                                  entry( 3, p_cod_parameters ),                                  entry( 4, p_cod_parameters ),                                  entry( 5, p_cod_parameters ),                                  entry( 6, p_cod_parameters ),                                  entry( 7, p_cod_parameters ),                                  entry( 8, p_cod_parameters ),                                  entry( 9, p_cod_parameters ))). 
    assign v_wgh_focus = v_wgh_attrib. 
    return error. 

END PROCEDURE. /* pi_integr_apb_cria_msg_erro */
/*****************************************************************************
** Procedure Interna.....: pi_leave_cod_cta_ctbl
** Descricao.............: pi_leave_cod_cta_ctbl
** Criado por............: bre17230
** Criado em.............: 09/10/1998 15:15:04
** Alterado por..........: src531
** Alterado em...........: 18/03/2004 19:13:24
*****************************************************************************/
PROCEDURE pi_leave_cod_cta_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cta_ctbl                   as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find cta_ctbl no-lock
        where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
        and   cta_ctbl.cod_cta_ctbl       = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.

    if  avail cta_ctbl
    then do:
        assign v_cod_cta_ctbl = cta_ctbl.cod_cta_ctbl.
        assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
               fedex-rateio.cod_cta_ctbl:format in frame f_mop_01_fedex-rateio = plano_cta_ctbl.cod_format_cta_ctbl
               v_cod_format = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.
        if  error-status:error
        then do:
            /* Formato &2 Inv†lido ! */
            run pi_messages (input "show",
                             input 4488,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               v_cod_format_cta_ctbl)) /*msg_4488*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        display cta_ctbl.des_tit_ctbl
                with frame f_mop_01_fedex-rateio.

        find criter_distrib_cta_ctbl no-lock
            where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
            and   criter_distrib_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl
            and   criter_distrib_cta_ctbl.cod_estab          = fedex.cod_estab
            and   criter_distrib_cta_ctbl.dat_inic_valid    <= p_dat_transacao
            and   criter_distrib_cta_ctbl.dat_fim_valid      > p_dat_transacao no-error.

        if  not avail criter_distrib_cta_ctbl
        or criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ 
        then do:
             assign fedex-rateio.cod_plano_ccusto = ""
                    fedex-rateio.cod_ccusto:screen-value       in frame f_mop_01_fedex-rateio = ""
                    emscad.ccusto.des_tit_ctbl:screen-value      in frame f_mop_01_fedex-rateio = "".
             disable fedex-rateio.cod_ccusto
                     bt_zoo
                     with frame f_mop_01_fedex-rateio.
            assign v_ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ .
        end /* if */.
        else do:
             ASSIGN fedex-rateio.cod_plano_ccusto = "PADRAO".
             enable fedex-rateio.cod_ccusto
                    bt_zoo
                    with frame f_mop_01_fedex-rateio.
            assign v_ind_criter_distrib_ccusto = "Utiliza" /*l_utiliza*/ .
        end /* else */.
    end /* if */.
    else do:
        find cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
            and   cta_ctbl.cod_altern_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.
        if  avail cta_ctbl
        then do:
            assign v_cod_cta_ctbl = cta_ctbl.cod_cta_ctbl.
            find criter_distrib_cta_ctbl no-lock
                where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
                and   criter_distrib_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl
                and   criter_distrib_cta_ctbl.cod_estab          = fedex.cod_estab
                and   criter_distrib_cta_ctbl.dat_inic_valid    <= p_dat_transacao
                and   criter_distrib_cta_ctbl.dat_fim_valid      > p_dat_transacao no-error.

            if  not avail criter_distrib_cta_ctbl
            or criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ 
            then do:
                assign fedex-rateio.cod_plano_ccusto = ""
                       fedex-rateio.cod_ccusto:screen-value       in frame f_mop_01_fedex-rateio = ""
                       ccusto.des_tit_ctbl:screen-value                 in frame f_mop_01_fedex-rateio = "".
                disable fedex-rateio.cod_ccusto
                        bt_zoo
                        with frame f_mop_01_fedex-rateio.
                assign v_ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ .
            end /* if */.
            else do:
                ASSIGN fedex-rateio.cod_plano_ccusto = "PADRAO".
                enable fedex-rateio.cod_ccusto
                       bt_zoo
                       with frame f_mop_01_fedex-rateio.
                assign v_ind_criter_distrib_ccusto = "Utiliza" /*l_utiliza*/ .
            end /* else */.

            assign fedex-rateio.cod_cta_ctbl:format in frame f_mop_01_fedex-rateio = "x(20)" /*l_x20*/ .

            run pi_retornar_inic_zero (Input fedex-rateio.cod_cta_ctbl:handle in frame f_mop_01_fedex-rateio,
                                       Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_retornar_inic_zero*/.
            assign fedex-rateio.cod_cta_ctbl:screen-value in frame f_mop_01_fedex-rateio = cta_ctbl.cod_cta_ctbl.
            display cta_ctbl.des_tit_ctbl when avail cta_ctbl
                    "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                    with frame f_mop_01_fedex-rateio.
        end /* if */.
        else do:
             assign cta_ctbl.des_tit_ctbl:screen-value in frame f_mop_01_fedex-rateio = "".
             disable fedex-rateio.cod_ccusto
                     bt_zoo
                     with frame f_mop_01_fedex-rateio.
        end /* else */.
    end /* else */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_leave_cod_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_leave_cod_ccusto
** Descricao.............: pi_leave_cod_ccusto
** Criado por............: bre17230
** Criado em.............: 09/10/1998 15:16:15
** Alterado por..........: src531
** Alterado em...........: 18/03/2004 19:16:34
*****************************************************************************/
PROCEDURE pi_leave_cod_ccusto:

    if avail plano_ccusto then do:
       assign v_cod_format_1 = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto no-error.
       if error-status:error or index (string(v_cod_format_1, plano_ccusto.cod_format_ccusto), chr(32)) <> 0 then do:
          /* Formato &2 Inv†lido ! */
          run pi_messages (input "show",
                           input 4488,
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                             plano_ccusto.cod_format_ccusto)) /*msg_4488*/.
          return "NOK" /*l_nok*/ .
       end.
    end.

    if  avail plano_ccusto 
    and input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto <> "" then do:
        assign v_cod_format_1 = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto
               fedex-rateio.cod_ccusto:format in frame f_mop_01_fedex-rateio = plano_ccusto.cod_format_ccusto
               v_cod_format_ccusto = plano_ccusto.cod_format_ccusto no-error.
        if  error-status:error
        then do:
            /* Formato &2 Inv†lido ! */
            run pi_messages (input "show",
                             input 4488,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               v_cod_format_ccusto)) /*msg_4488*/.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end.

    find emscad.ccusto no-lock
        where ccusto.cod_empresa = estabelecimento.cod_empresa
        and   ccusto.cod_plano_ccusto = "PADRAO"
        and   ccusto.cod_ccusto = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto
            use-index ccusto_id no-error.

    display ccusto.des_tit_ctbl when avail ccusto
            "" when not avail ccusto @ ccusto.des_tit_ctbl
            with frame f_mop_01_fedex-rateio.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_leave_cod_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p20_mod_fedex-rateio
** Descricao.............: pi_ix_p20_mod_fedex-rateio
** Criado por............: bre17230
** Criado em.............: 10/10/1998 16:19:07
** Alterado por..........: fut35183
** Alterado em...........: 24/09/2007 09:31:26
*****************************************************************************/
PROCEDURE pi_ix_p20_mod_fedex-rateio:

    /************************* Variable Definition Begin ************************/

    def var v_cod_finalid_econ
        as character
        format "x(10)":U
        label "Finalidade Econìmica"
        column-label "Finalidade Econìmica"
        no-undo.
    def var v_cod_format
        as character
        format "x(8)":U
        label "Formato"
        column-label "Formato"
        no-undo.
    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_wgh_focus = fedex-rateio.cod_cta_ctbl:handle in frame f_mop_01_fedex-rateio.

    assign v_cod_plano_cta_ctbl_old = ""
           v_cod_plano_ccusto_old = "".

    assign v_rec_estabelecimento = recid(estabelecimento).
        
    assign v_val_tot_rat        = p_val_tit_ap
           v_val_sdo_rat_tit_ap = p_val_tit_ap.

    calculo_valores:
    for each b_fedex-rateio no-lock
        where b_fedex-rateio.numero = p_numero:
        assign v_val_sdo_rat_tit_ap = v_val_sdo_rat_tit_ap - b_fedex-rateio.perc_aprop_ctbl.
    end /* for calculo_valores */.

    display v_val_sdo_rat_tit_ap
            v_val_tot_rat
            with frame f_mop_01_fedex-rateio.

    /* Begin_Include: i_p20_add_fedex-rateio */
    assign v_log_plano_cta_ctbl = no.
    run pi_retornar_plano_cta_ctbl_prim (Input estabelecimento.cod_empresa,
                                         Input p_dat_transacao,
                                         output v_cod_plano_cta_ctbl,
                                         output v_log_return_cta) /*pi_retornar_plano_cta_ctbl_prim*/.
    /* End_Include: i_p20_add_fedex-rateio */

    run pi_verificar_unid_negoc_unico (Input estabelecimento.cod_estab,
                                       Input p_dat_transacao,
                                       output v_cod_unid_negoc,
                                       output v_log_return) /*pi_verificar_unid_negoc_unico*/.
    if  v_cod_unid_negoc <>""
    and v_log_return = no then do:
        find estab_unid_negoc no-lock
            where estab_unid_negoc.cod_estab =  estabelecimento.cod_estab
            and estab_unid_negoc.cod_unid_negoc =  V_cod_unid_negoc_usuar
            and estab_unid_negoc.dat_inic_valid <= p_dat_transacao
            and estab_unid_negoc.dat_fim_valid >= p_dat_transacao no-error.
        if avail estab_unid_negoc then
           assign v_cod_unid_negoc = v_cod_unid_negoc_usuar.
    end.
        if  v_cod_unid_negoc = ""
        then do:
            if  v_log_return = yes then
                disable fedex-rateio.cod_unid_negoc
                        bt_zoo_67475
                        with frame f_mop_01_fedex-rateio.
            else do:
                find first param_utiliz_produt no-lock
                     where param_utiliz_produt.cod_empresa = estabelecimento.cod_empresa
                       and param_utiliz_produt.cod_modul_dtsul = ''
                       and param_utiliz_produt.cod_funcao_negoc = 'BU' /*cl_verifica_unid_negoc of param_utiliz_produt*/ no-error.
                if not avail param_utiliz_produt then do:
                    /* ParÉmetros de utilizaá∆o do produto n∆o encontrado. */
                    run pi_messages (input "show",
                                     input 10407,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10407*/.
                    disable fedex-rateio.cod_unid_negoc
                            bt_zoo_67475
                            with frame f_mop_01_fedex-rateio.
                end.
                else
                    enable fedex-rateio.cod_unid_negoc
                           bt_zoo_67475
                           with frame f_mop_01_fedex-rateio.
            end /* else */.
        end /* if */.
        else do:
            if  v_log_return = yes
            then do:
                assign fedex-rateio.cod_unid_negoc:screen-value in frame f_mop_01_fedex-rateio = v_cod_unid_negoc.
                disable fedex-rateio.cod_unid_negoc
                        bt_zoo_67475
                        with frame f_mop_01_fedex-rateio.
            end /* if */.
            else do:
                find first param_utiliz_produt no-lock
                     where param_utiliz_produt.cod_empresa = estabelecimento.cod_empresa
                       and param_utiliz_produt.cod_modul_dtsul = ''
                       and param_utiliz_produt.cod_funcao_negoc = 'BU' /*cl_verifica_unid_negoc of param_utiliz_produt*/ no-error.
                if not avail param_utiliz_produt then do:
                    /* ParÉmetros de utilizaá∆o do produto n∆o encontrado. */
                    run pi_messages (input "show",
                                     input 10407,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10407*/.
                    disable fedex-rateio.cod_unid_negoc
                            bt_zoo_67475
                            with frame f_mop_01_fedex-rateio.
                end.
                else do:
                    DISP fedex-rateio.cod_unid_negoc with frame f_mop_01_fedex-rateio.
                    enable fedex-rateio.cod_unid_negoc
                           bt_zoo_67475
                           with frame f_mop_01_fedex-rateio.
                end.
            end /* else */.
        end /* else */.
        if v_cod_unid_negoc_2 <> "" then
            assign fedex-rateio.cod_unid_negoc:screen-value in frame f_mop_01_fedex-rateio = "".
        find unid_negoc no-lock
             where unid_negoc.cod_unid_negoc = input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc
             use-index ndngc_id
              /*cl_frame of unid_negoc*/ no-error.
        display unid_negoc.des_unid_negoc when avail unid_negoc
                "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
                with frame f_mop_01_fedex-rateio.

        apply "leave" to fedex-rateio.cod_ccusto in frame f_mop_01_fedex-rateio.
        apply "leave" to fedex-rateio.cod_cta_ctbl in frame f_mop_01_fedex-rateio.

        assign v_cod_cta_ctbl_3 = string (replace(v_cod_format_cta_ctbl,"9","0")).
        assign v_cod_cta_ctbl_3 = string (replace(v_cod_cta_ctbl_3,"x" /*l_x*/ ,"0")).
        format_block: 
        do v_num_count = 1 to length(v_cod_cta_ctbl_3): 
            if  substring(v_cod_cta_ctbl_3, v_num_count,1) = "0" 
            or  substring(v_cod_cta_ctbl_3, v_num_count,1) = 'X' 
            or  substring(v_cod_cta_ctbl_3, v_num_count,1) = '!' then
                assign v_cod_format = v_cod_format + substring(v_cod_cta_ctbl_3, v_num_count,1). 
        end /* do format_block */. 
        assign v_cod_cta_ctbl_3 = v_cod_format.

        if v_cod_cta_ctbl_2 <> "" 
        and (input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl = ""
        or   input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl = v_cod_cta_ctbl_3) then do:
            assign fedex-rateio.cod_cta_ctbl = v_cod_cta_ctbl_2.
            display fedex-rateio.cod_cta_ctbl
                    with frame f_mop_01_fedex-rateio.
            apply "leave" to fedex-rateio.cod_cta_ctbl in frame f_mop_01_fedex-rateio.
        end.
        assign v_cod_format = "".
        assign v_cod_ccusto_aux = string (replace(v_cod_format_ccusto, "9","0")).
        assign v_cod_ccusto_aux = string (replace(v_cod_ccusto_aux,"x" /*l_x*/ ,"0")).
        format_block: 
        do v_num_count = 1 to length(v_cod_ccusto_aux): 
            if  substring(v_cod_ccusto_aux, v_num_count,1) = "0" 
            or  substring(v_cod_ccusto_aux, v_num_count,1) = 'X' 
            or  substring(v_cod_ccusto_aux, v_num_count,1) = '!' then do: 
                assign v_cod_format = v_cod_format + substring(v_cod_ccusto_aux, v_num_count,1). 
            end. 
        end /* do format_block */. 

        assign v_cod_ccusto_aux = v_cod_format.

        if v_cod_ccusto_2 <> "" 
        and (input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto = "" 
        or   input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto = v_cod_ccusto_aux) then do:
            assign fedex-rateio.cod_ccusto = v_cod_ccusto_2.
            display fedex-rateio.cod_ccusto
                    with frame f_mop_01_fedex-rateio.
            apply "leave" to fedex-rateio.cod_ccusto in frame f_mop_01_fedex-rateio.
        end.

        if  v_cod_unid_negoc_2 <> "" /*l_*/  and input frame f_mop_01_fedex-rateio fedex-rateio.cod_unid_negoc = "" /*l_*/ 
        then do:
            assign fedex-rateio.cod_unid_negoc:screen-value in frame f_mop_01_fedex-rateio = v_cod_unid_negoc_2.
            apply "leave" to fedex-rateio.cod_unid_negoc in frame f_mop_01_fedex-rateio.
        end /* if */.
        find cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
            and   cta_ctbl.cod_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.
        find emscad.ccusto no-lock
            where ccusto.cod_empresa = estabelecimento.cod_empresa
            and   ccusto.cod_plano_ccusto = "PADRAO"
            and   ccusto.cod_ccusto = input frame f_mop_01_fedex-rateio fedex-rateio.cod_ccusto
                use-index ccusto_id no-error.
        display cta_ctbl.des_tit_ctbl when avail cta_ctbl
                "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                ccusto.des_tit_ctbl when avail ccusto
                "" when not avail ccusto @ ccusto.des_tit_ctbl
                unid_negoc.des_unid_negoc when avail unid_negoc
                "" when not avail unid_negoc @ unid_negoc.des_unid_negoc
                with frame f_mop_01_fedex-rateio.

        apply "entry" to fedex-rateio.cod_cta_ctbl in frame f_mop_01_fedex-rateio.
    
END PROCEDURE. /* pi_ix_p20_mod_fedex-rateio */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p27_add_fedex-rateio
** Descricao.............: pi_ix_p27_add_fedex-rateio
** Criado por............: bre17230
** Criado em.............: 10/10/1998 16:19:23
** Alterado por..........: bre17906
** Alterado em...........: 31/03/2001 16:49:10
*****************************************************************************/
PROCEDURE pi_ix_p27_add_fedex-rateio:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

        find cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
            and   cta_ctbl.cod_altern_cta_ctbl = input frame f_mop_01_fedex-rateio fedex-rateio.cod_cta_ctbl no-error.

        if fedex-rateio.cod_cta_ctbl:sensitive = true then do:
            if avail cta_ctbl then
                assign fedex-rateio.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl.
        end.

    assign v_dat_trans            = p_dat_transacao
           v_cod_ccusto_2         = fedex-rateio.cod_ccusto
           v_cod_cta_ctbl_2       = fedex-rateio.cod_cta_ctbl
           v_cod_unid_negoc_2     = fedex-rateio.cod_unid_negoc.
END PROCEDURE. /* pi_ix_p27_add_fedex-rateio */
/*****************************************************************************
** Procedure Interna.....: pi_valida_cta_ctbl
** Descricao.............: pi_valida_cta_ctbl
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: veber
** Alterado em...........: 01/08/1997 14:33:24
*****************************************************************************/
PROCEDURE pi_valida_cta_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_cta_ctbl_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_cta_ctbl_val = no.
    find cta_ctbl no-lock
         where cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
           and cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl /*cl_valida_cta_ctbl of cta_ctbl*/ no-error.
    if  avail cta_ctbl
    then do:
        find plano_cta_ctbl no-lock
             where plano_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
              no-error.
        if  avail plano_cta_ctbl
        then do:
            if  p_dat_refer = ? or (plano_cta_ctbl.dat_inic_valid <= p_dat_refer and
                plano_cta_ctbl.dat_fim_valid  > p_dat_refer and
                cta_ctbl.dat_inic_valid <= p_dat_refer and
                cta_ctbl.dat_fim_valid  >  p_dat_refer)
            then do:
                assign p_log_cta_ctbl_val = yes.
            end /* if */.
        end /* if */.
    end /* if */.
END PROCEDURE. /* pi_valida_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_validar_plano_cta_ctbl
** Descricao.............: pi_validar_plano_cta_ctbl
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 07/07/1995 14:47:58
*****************************************************************************/
PROCEDURE pi_validar_plano_cta_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_plano_cta_ctbl_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    find plano_cta_unid_organ no-lock
         where plano_cta_unid_organ.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
           and plano_cta_unid_organ.cod_unid_organ = p_cod_unid_organ /*cl_retorna_plano_cta_validos of plano_cta_unid_organ*/ no-error.
    if  avail plano_cta_unid_organ
    then do:
        if  p_dat_refer_ent = ? or
           (plano_cta_unid_organ.dat_inic_valid <= p_dat_refer_ent and
            plano_cta_unid_organ.dat_fim_valid  >= p_dat_refer_ent)
        then do:
               assign p_log_plano_cta_ctbl_val = yes.
        end /* if */.
        else do:
            assign p_log_plano_cta_ctbl_val = no.
        end /* else */.
    end /* if */.
    else do:
        assign p_log_plano_cta_ctbl_val = no.
    end /* else */.
END PROCEDURE. /* pi_validar_plano_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: claudia
** Alterado em...........: 26/08/1996 11:54:50
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ
    then do:
       assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.
    end /* if */.

END PROCEDURE. /* pi_retornar_finalid_indic_econ */

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
/**********************  End of add_fedex-rateio **********************/
