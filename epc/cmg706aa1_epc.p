def input param p_wgh_frame       as widget-handle  no-undo.

{epc/cmg706aa1_epc.i}

def new global shared var v_rec_cta_corren
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
DEFINE VARIABLE wgh-BROWSE-1     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-cta-corren-1 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i-linha          AS INTEGER       NO-UNDO.
DEFINE VARIABLE v_val_tot_di     AS DECIMAL       NO-UNDO.
DEFINE VARIABLE v_dat_di         AS DATE          NO-UNDO.
DEFINE VARIABLE v_cod_cart_di    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v_cod_portad_di  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v_cod_refer      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v_cod_indic_econ AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v_cod_tit_acr    AS CHARACTER     NO-UNDO.

DEFINE VARIABLE v_rec_lote_impl_tit_acr AS RECID       NO-UNDO.
DEFINE VARIABLE v_log_sai               AS LOG INIT NO NO-UNDO.

/************************* Variable Definition Begin ************************/

def var v_cod_clien_infor
    as character
    format "x(20)":U
    label "Cliente"
    column-label "Cliente"
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
def new global shared var v_rec_cliente
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_portador
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_des_param
    as character
    format "x(50)":U
    label "Param"
    column-label "Param"
    no-undo.
def var v_num_mensagem
    as integer
    format ">>>>,>>9":U
    label "N£mero"
    column-label "N£mero Mensagem"
    no-undo.


/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.


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
/****************************** Function Button *****************************/
def button bt_zoo_425326
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_geracao_di_dni
    rt_001
         at row 01.08 col 02.00 bgcolor 8 
    rt_cxcf
         at row 06.08 col 02.00 bgcolor 7 
    v_cod_clien_infor
         at row 01.71 col 08.14 colon-aligned label "Cliente"
         help "C¢digo do Cliente"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_425326
         at row 01.71 col 31.28
    emscad.cliente.nom_pessoa
         at row 01.71 col 36.00 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    cta_corren.cod_estab
         at row 02.71 col 13.00 LABEL "Estabelecimento"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portad_di
         at row 03.71 col 23.00 colon-aligned label "Portador"
         help "C¢digo do Portador"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_di
         at row 03.71 col 32.00 no-label
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_di    
         at row 04.71 col 21.00 LABEL "Data" FORMAT "99/99/9999"
         view-as FILL-IN 
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_tot_di
         at row 04.71 col 37.00 LABEL "Valor DI"
         view-as fill-in
         size-chars 18.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 06.29 col 03.00 font ?
         help "OK"
    bt_can
         at row 06.29 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 82.00 by 08.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Gerar Dep¢sito Identificado".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_03_geracao_di_dni = 10.00
           bt_can:height-chars  in frame f_dlg_03_geracao_di_dni = 01.00
           bt_ok:width-chars    in frame f_dlg_03_geracao_di_dni = 10.00
           bt_ok:height-chars   in frame f_dlg_03_geracao_di_dni = 01.00
           rt_001:width-chars   in frame f_dlg_03_geracao_di_dni = 78.57
           rt_001:height-chars  in frame f_dlg_03_geracao_di_dni = 05.00
           rt_cxcf:width-chars  in frame f_dlg_03_geracao_di_dni = 78.57
           rt_cxcf:height-chars in frame f_dlg_03_geracao_di_dni = 01.42.
    /* set private-data for the help system */
    assign bt_zoo_425326:private-data       in frame f_dlg_03_geracao_di_dni = "HLP=000009431":U
           v_cod_clien_infor:private-data   in frame f_dlg_03_geracao_di_dni = "HLP=000017249":U
           emscad.cliente.nom_pessoa:private-data  in frame f_dlg_03_geracao_di_dni = "HLP=000009765":U
           v_cod_portad_di:private-data  in frame f_dlg_03_geracao_di_dni = "HLP=000000000":U
           v_cod_cart_di:private-data in frame f_dlg_03_geracao_di_dni = "HLP=000009765":U
           bt_ok:private-data               in frame f_dlg_03_geracao_di_dni = "HLP=000010721":U
           bt_can:private-data              in frame f_dlg_03_geracao_di_dni = "HLP=000011050":U
           frame f_dlg_03_geracao_di_dni:private-data                        = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_425326:sensitive in frame f_dlg_03_geracao_di_dni = yes.
    /* move buttons to top */
    bt_zoo_425326:move-to-top().

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_ok IN FRAME f_dlg_03_geracao_di_dni
DO:

    if v_cod_clien_infor:screen-value in frame f_dlg_03_geracao_di_dni = '' then do:
        run pi_messages (input 'show',
                         input 104,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           'Cliente')) .
        apply 'entry' to v_cod_clien_infor in frame f_dlg_03_geracao_di_dni.
       return no-apply.       
    end.                                           

    if v_cod_clien_infor:screen-value in frame f_dlg_03_geracao_di_dni <> '' then do:       
        find emscad.cliente no-lock
               where cliente.cod_empresa = v_cod_empres_usuar
                 and cliente.cdn_cliente = int(input frame f_dlg_03_geracao_di_dni v_cod_clien_infor) no-error.
        if not avail cliente then do:
            run pi_messages (input 'show',
                             input 476,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) .

            apply 'entry' to v_cod_clien_infor in frame f_dlg_03_geracao_di_dni.
            return no-apply.       
        end.
    end.

    return 'ok'.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_03_geracao_di_dni */

ON LEAVE OF v_cod_clien_infor IN FRAME f_dlg_03_geracao_di_dni
DO:

    find emscad.cliente no-lock
         where cliente.cdn_cliente = int(input frame f_dlg_03_geracao_di_dni v_cod_clien_infor)
           and cliente.cod_empresa = v_cod_empres_usuar /* cl_frame of cliente*/ no-error.


    display cliente.nom_pessoa when avail cliente
            "" when not avail cliente @ cliente.nom_pessoa
            with frame f_dlg_03_geracao_di_dni.
END. /* ON LEAVE OF v_cod_clien_infor IN FRAME f_dlg_03_geracao_di_dni */

/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_425326 IN FRAME f_dlg_03_geracao_di_dni
OR F5 OF v_cod_clien_infor IN FRAME f_dlg_03_geracao_di_dni DO:

    /* fn_generic_zoom */
    if  search("prgint/utb/utb107na.r") = ? and search("prgint/utb/utb107na.p") = ? then do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb107na.p"
                   view-as alert-box error buttons ok.
            return.
    end.
    else
        run prgint/utb/utb107na.p (Input v_cod_empres_usuar) /*prg_see_cliente*/.
    if  v_rec_cliente <> ?
    then do:
        find emscad.cliente where recid(cliente) = v_rec_cliente no-lock no-error.
        assign v_cod_clien_infor:screen-value in frame f_dlg_03_geracao_di_dni =
               string(cliente.cdn_cliente).

        display cliente.nom_pessoa
                with frame f_dlg_03_geracao_di_dni.

    end /* if */.
    apply "entry" to v_cod_clien_infor in frame f_dlg_03_geracao_di_dni.
end. /* ON  CHOOSE OF bt_zoo_425326 IN FRAME f_dlg_03_geracao_di_dni */

/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON ENTRY OF FRAME f_dlg_03_geracao_di_dni
DO:

    enable v_cod_clien_infor with frame f_dlg_03_geracao_di_dni.

    disable emscad.cliente.nom_pessoa with frame f_dlg_03_geracao_di_dni.

    assign v_cod_clien_infor:bgcolor in frame f_dlg_03_geracao_di_dni  = 15
           cliente.nom_pessoa:bgcolor in frame f_dlg_03_geracao_di_dni = 8.


END. /* ON ENTRY OF FRAME f_dlg_03_geracao_di_dni */

ON WINDOW-CLOSE OF FRAME f_dlg_03_geracao_di_dni
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_dlg_03_geracao_di_dni */


/***************************** Frame Trigger End ****************************/


/****************************** Main Code Begin *****************************/

RUN piTelaUPC (INPUT  p_wgh_frame,        /*** fPage3 ***/
               INPUT  "FILL-IN":U,        /*** Type ***/
               INPUT  "cod_cta_corren":U, /*** Name ***/
               OUTPUT wgh-cta-corren-1).

IF VALID-HANDLE(wgh-cta-corren-1) 
THEN DO:
     FIND cta_corren NO-LOCK 
         WHERE cta_corren.cod_cta_corren = wgh-cta-corren-1:INPUT-VALUE NO-ERROR.
     IF NOT AVAIL cta_corren 
     THEN DO:
          MESSAGE "Conta Corrente n∆o localizada."
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN "".
     END.
END.
ELSE DO:
     MESSAGE "Conta Corrente n∆o localizada."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN "".
END.

RUN piTelaUPC (INPUT  p_wgh_frame,                            /*** fPage3 ***/
               INPUT  "BROWSE":U,                             /*** Type ***/
               INPUT  "br_bas_movto_concil_cta_corren_bco":U, /*** Name ***/
               OUTPUT wgh-BROWSE-1).

DEF VAR hquery          AS HANDLE NO-UNDO.
DEF VAR hbuffer         AS HANDLE NO-UNDO.
DEF VAR hlin-num-id-lin AS HANDLE NO-UNDO.

ASSIGN v_val_tot_di    = 0
       v_dat_di        = 01/01/0001
       v_cod_cart_di   = ""
       v_cod_portad_di = "".

IF VALID-HANDLE(wgh-BROWSE-1) THEN DO:
    DO i-linha = 1 TO wgh-BROWSE-1:NUM-SELECTED-ROWS:
        wgh-BROWSE-1:FETCH-SELECTED-ROW(i-linha).

        ASSIGN hquery          = wgh-BROWSE-1:QUERY 
               hbuffer         = hquery:GET-BUFFER-HANDLE(2)
               hlin-num-id-lin = hbuffer:BUFFER-FIELD("num_id_lin_extrat_cta").   
    
        FIND lin_extrat_cta_corren NO-LOCK 
            WHERE lin_extrat_cta_corren.num_id_lin_extrat_cta = hlin-num-id-lin:BUFFER-VALUE.

        IF lin_extrat_cta_corren.dat_movto_cta_corren > v_dat_di 
           THEN ASSIGN v_dat_di = lin_extrat_cta_corren.dat_movto_cta_corren.

        IF lin_extrat_cta_corren.ind_fluxo_movto_cta_corren = "ENT"
           THEN ASSIGN v_val_tot_di = v_val_tot_di + lin_extrat_cta_corren.val_lin_extrat_cta_corren.
           ELSE ASSIGN v_val_tot_di = v_val_tot_di - lin_extrat_cta_corren.val_lin_extrat_cta_corren.

    END.
END.

RUN pi_valida_di.
IF RETURN-VALUE = "NOK" 
THEN DO:
     FOR EACH tt_log_erros_atualiz.
         MESSAGE tt_log_erros_atualiz.ttv_num_mensagem
                 tt_log_erros_atualiz.ttv_des_msg_erro
                 tt_log_erros_atualiz.ttv_des_msg_ajuda VIEW-AS ALERT-BOX.
     END.
     RETURN "".
END.

pause 0 before-hide.

view frame f_dlg_03_geracao_di_dni.

ENABLE v_cod_clien_infor 
       bt_zoo_425326
       bt_ok 
       bt_can WITH FRAME f_dlg_03_geracao_di_dni.

DISP cta_corren.cod_estab
     v_cod_portad_di
     v_cod_cart_di
     v_dat_di    
     v_val_tot_di WITH FRAME f_dlg_03_geracao_di_dni.

assign v_log_repeat = yes.

main_block:
repeat while v_log_repeat:
    assign v_log_repeat  = no
           v_log_save_ok = no.

    wait_block:
    repeat on endkey undo main_block, leave main_block while v_log_save_ok = no:
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_03_geracao_di_dni focus v_wgh_focus.
        end.
        else do:
            wait-for go of frame f_dlg_03_geracao_di_dni.
        end.
        save_block:
        do on error undo save_block, leave save_block:

            message "Confirma Geraá∆o do Dep¢sito Identificado no ACR"
                   view-as alert-box question buttons yes-no title "Gerar DI" update v_log_answer.

            if  v_log_answer = no then do:
                undo, retry.
            end.        

            ASSIGN v_cod_clien_infor = v_cod_clien_infor:screen-value in frame f_dlg_03_geracao_di_dni.

            DO TRANSACTION:
                
                RUN pi_main_code_api_gera_dni_1.

                IF RETURN-VALUE = "NOK" 
                   THEN UNDO, LEAVE.

            END.

            assign v_log_save_ok = yes.
        end.
    end.
end.

hide frame f_dlg_03_geracao_di_dni.

/*****************************************************************************
** Procedure Interna.....: pi_valida_di
*****************************************************************************/
PROCEDURE pi_valida_di:

    def var v_num_cont                       as integer         no-undo. /*local*/

    IF v_val_tot_di <= 0 
    THEN DO:
         MESSAGE "Linha do extrato n∆o selecionada ou com valor TOTAL Negativo."
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
    END.

    FIND LAST param_empres_acr NO-LOCK
        WHERE param_empres_acr.cod_empres = cta_corren.cod_empres NO-ERROR.
    IF NOT AVAIL param_empres_acr 
    THEN DO:
         ASSIGN v_des_param = SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",cta_corren.cod_empres) + "~~~~~~~~~~~~~~~~".
         RUN pi_gera_dni_criar_msg_erro (INPUT 3721,
                                        INPUT v_des_param).
         RETURN "NOK".
    END.

    FIND LAST param_estab_acr NO-LOCK
         WHERE param_estab_acr.cod_estab       = cta_corren.cod_estab
           AND param_estab_acr.dat_inic_valid <= v_dat_di 
           AND param_estab_acr.dat_fim_valid  >= v_dat_di NO-ERROR.
    IF NOT AVAIL param_estab_acr 
    THEN DO:    
         ASSIGN v_des_param = SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",cta_corren.cod_estab) + "~~~~~~~~~~~~~~~~".
         RUN pi_gera_dni_criar_msg_erro (INPUT 4545,
                                         INPUT v_des_param) /*pi_gera_dni_criar_msg_erro*/.
         RETURN "NOK".
    END.

    IF param_estab_acr.cod_espec_docto_di = '' OR param_estab_acr.cod_espec_docto_di = ?
    OR param_estab_acr.cod_ser_docto_di   = '' OR param_estab_acr.cod_ser_docto_di   = ?
    OR param_estab_acr.cod_motiv_movto_di = '' OR param_estab_acr.cod_motiv_movto_di = ?
    OR param_estab_acr.cod_cart_bcia_di   = '' OR param_estab_acr.cod_cart_bcia_di   = ? 
    THEN DO:
         ASSIGN v_des_param = SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",cta_corren.cod_estab) + "~~~~~~~~~~~~~~~~".
         RUN pi_gera_dni_criar_msg_erro (INPUT 19705,
                                         INPUT v_des_param) /*pi_gera_dni_criar_msg_erro*/.
         RETURN "NOK".
    END.

    FIND espec_docto NO-LOCK
        WHERE espec_docto.cod_espec_docto = param_estab_acr.cod_espec_docto_di NO-ERROR.
    IF NOT AVAIL espec_docto 
    THEN DO:
         ASSIGN v_des_param = SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",param_estab_acr.cod_espec_docto_di) + "~~~~~~~~~~~~~~~~".
         RUN pi_gera_dni_criar_msg_erro (INPUT 4546,
                                         INPUT v_des_param) /*pi_gera_dni_criar_msg_erro*/.
         RETURN "NOK".
    END.

    assign v_num_cont = 0.
    for each portad_finalid_econ no-lock
       where portad_finalid_econ.cod_estab        = cta_corren.cod_estab
       and   portad_finalid_econ.cod_cta_corren   = cta_corren.cod_cta_corren
       and   portad_finalid_econ.cod_finalid_econ = cta_corren.cod_finalid_econ:
       assign v_num_cont = v_num_cont + 1.
       if v_num_cont > 1 then leave.
    end.

    if v_num_cont > 1 then do:

        /* * Assume a carteira banc†ria DNI parametrizada nos parÉmetros do estabelecimento ACR **/
        assign v_cod_cart_di = param_estab_acr.cod_cart_bcia_dni.

        if v_cod_cart_di = ""
        then do:
             assign v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9") + "~~~~~~~~~~~~~~~~".
             run pi_gera_dni_criar_msg_erro (Input 11114,
                                             Input v_des_param) /*pi_gera_dni_criar_msg_erro*/.
             return "NOK" /*l_nok*/ .
        end.

        find first portad_finalid_econ no-lock
           where portad_finalid_econ.cod_estab        = cta_corren.cod_estab
           and   portad_finalid_econ.cod_cta_corren   = cta_corren.cod_cta_corren
           and   portad_finalid_econ.cod_finalid_econ = cta_corren.cod_finalid_econ 
           and   portad_finalid_econ.cod_cart_bcia    = v_cod_cart_di no-error.
    end.
    else do:

        find first portad_finalid_econ no-lock
           where portad_finalid_econ.cod_estab        = cta_corren.cod_estab
           and   portad_finalid_econ.cod_cta_corren   = cta_corren.cod_cta_corren
           and   portad_finalid_econ.cod_finalid_econ = cta_corren.cod_finalid_econ no-error.
        if avail portad_finalid_econ then do:
            assign v_cod_cart_di = portad_finalid_econ.cod_cart_bcia.
        end.    
        else do:
             assign v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", cta_corren.cod_estab,cta_corren.cod_cta_corren,cta_corren.cod_finalid_econ) + "~~~~~~~~~~~~~~~~".
             run pi_gera_dni_criar_msg_erro (Input 12526,
                                             Input v_des_param) /*pi_gera_dni_criar_msg_erro*/.
             return "NOK" /*l_nok*/ .
        end.    
    end.

    if avail portad_finalid_econ
       then assign v_cod_portad_di = portad_finalid_econ.cod_portador.
       else do:
            assign v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", cta_corren.cod_estab, cta_corren.cod_cta_corren, cta_corren.cod_finalid_econ) + "~~~~~~~~~~~~~~~~".
            run pi_gera_dni_criar_msg_erro (Input 12526,
                                            Input v_des_param) /*pi_gera_dni_criar_msg_erro*/.
            return "NOK" /*l_nok*/ .
       end.

    find portad_bco no-lock 
        where portad_bco.cod_modul_dtsul  = "ACR" /*l_acr*/ 
          and portad_bco.cod_estab        = cta_corren.cod_estab
          and portad_bco.cod_portador     = v_cod_portad_di
          and portad_bco.cod_cart_bcia    = v_cod_cart_di
          and portad_bco.cod_finalid_econ = cta_corren.cod_finalid_econ no-error.

    if not avail portad_bco then do:
        assign v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", v_cod_portad_di, "ACR" /*l_acr*/ , cta_corren.cod_estab , v_cod_cart_di , cta_corren.cod_finalid_econ   ) + "~~~~~~~~".
        run pi_gera_dni_criar_msg_erro (Input 3499,
                                        Input v_des_param) /*pi_gera_dni_criar_msg_erro*/. 
        RETURN "NOK".
    end.

END.

/*****************************************************************************
** Procedure Interna.....: pi_main_code_api_gera_dni_1
*****************************************************************************/
PROCEDURE pi_main_code_api_gera_dni_1:

    empty temp-table tt_integr_acr_abat_antecip.
    empty temp-table tt_integr_acr_abat_prev.
    empty temp-table tt_integr_acr_aprop_ctbl_pend.
    empty temp-table tt_integr_acr_aprop_desp_rec.
    empty temp-table tt_integr_acr_aprop_liq_antec.
    empty temp-table tt_integr_acr_aprop_relacto.
    empty temp-table tt_integr_acr_aprop_relacto_2.
    empty temp-table tt_integr_acr_cheq.
    empty temp-table tt_integr_acr_impto_impl_pend.
    empty temp-table tt_integr_acr_item_lote_impl.
    empty temp-table tt_integr_acr_item_lote_impl_4.
    empty temp-table tt_integr_acr_lote_impl.
    empty temp-table tt_integr_acr_ped_vda_pend.
    empty temp-table tt_integr_acr_relacto_pend.
    empty temp-table tt_integr_acr_relacto_pend_cheq.
    empty temp-table tt_integr_acr_repres_comis.
    empty temp-table tt_integr_acr_repres_pend.
    empty temp-table tt_log_erros_atualiz.

    RUN pi_gera_lote_impl_dni.
    RUN pi_gera_item_lote_impl_dni.

    FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR. 
    IF AVAIL tt_log_erros_atualiz 
    THEN DO: 
         FOR EACH tt_log_erros_atualiz.
             MESSAGE tt_log_erros_atualiz.ttv_num_mensagem
                     tt_log_erros_atualiz.ttv_des_msg_erro
                     tt_log_erros_atualiz.ttv_des_msg_ajuda VIEW-AS ALERT-BOX.
         END.
         RETURN "NOK".
    END.

    /* cria nova temp-table que ser† passada como parametro para a api evoluida */
    for each tt_integr_acr_item_lote_impl no-lock:
        create tt_integr_acr_item_lote_impl_4.
        buffer-copy tt_integr_acr_item_lote_impl to tt_integr_acr_item_lote_impl_4.
        assign tt_integr_acr_item_lote_impl_4.ttv_rec_item_lote_impl_tit_acr = recid( tt_integr_acr_item_lote_impl).
    end.        

    VALIDATE tt_integr_acr_item_lote_impl.
    VALIDATE tt_integr_acr_item_lote_impl_4.
    VALIDATE tt_integr_acr_lote_impl.
    VALIDATE tt_integr_acr_aprop_ctbl_pend.

    if session:set-wait-state ("General") then.

    run prgfin/acr/acr900zh.py (Input 8,
                                Input "",
                                Input yes,
                                Input no,
                                Input table tt_integr_acr_repres_comis,
                                input-output table tt_integr_acr_item_lote_impl_4,
                                input table tt_integr_acr_aprop_relacto_2). 

    if session:set-wait-state ("") then.

    FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR. 
    IF AVAIL tt_log_erros_atualiz 
    THEN DO: 
         FOR EACH tt_log_erros_atualiz.
             MESSAGE tt_log_erros_atualiz.ttv_num_mensagem
                     tt_log_erros_atualiz.ttv_des_msg_erro
                     tt_log_erros_atualiz.ttv_des_msg_ajuda VIEW-AS ALERT-BOX.
         END.
         RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE. /* pi_main_code_api_gera_dni_1 */

/*****************************************************************************
** Procedure Interna.....: pi_gera_dni_criar_msg_erro
*****************************************************************************/
PROCEDURE pi_gera_dni_criar_msg_erro:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_des_param
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    create tt_log_erros_atualiz.
    run pi_messages (input "msg",
                     input p_num_mensagem,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
    assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_p_num_mensagem*/.
    run pi_messages (input "help",
                     input p_num_mensagem,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
    assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_p_num_mensagem*/.
    assign tt_log_erros_atualiz.tta_cod_estab     = (if avail tt_integr_acr_item_lote_impl then tt_integr_acr_lote_impl.tta_cod_estab else "")
           tt_log_erros_atualiz.tta_cod_refer     = (if avail tt_integr_acr_item_lote_impl then tt_integr_acr_lote_impl.tta_cod_refer else "")
           tt_log_erros_atualiz.tta_num_seq_refer = (if avail tt_integr_acr_item_lote_impl then tt_integr_acr_item_lote_impl.tta_num_seq_refer else 0)
           tt_log_erros_atualiz.ttv_num_mensagem  = p_num_mensagem
           tt_log_erros_atualiz.ttv_des_msg_erro  = substitute(tt_log_erros_atualiz.ttv_des_msg_erro,entry(1,p_des_param,"~~"),entry(2,p_des_param,"~~"),entry(3,p_des_param,"~~"),entry(4,p_des_param,"~~"),entry(5,p_des_param,"~~"),entry(6,p_des_param,"~~"),entry(7,p_des_param,"~~"),entry(8,p_des_param,"~~"),entry(9,p_des_param,"~~"))
           tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute(tt_log_erros_atualiz.ttv_des_msg_ajuda,entry(1,p_des_param,"~~"),entry(2,p_des_param,"~~"),entry(3,p_des_param,"~~"),entry(4,p_des_param,"~~"),entry(5,p_des_param,"~~"),entry(6,p_des_param,"~~"),entry(7,p_des_param,"~~"),entry(8,p_des_param,"~~"),entry(9,p_des_param,"~~")).
END PROCEDURE. /* pi_gera_dni_criar_msg_erro */

/*****************************************************************************
** Procedure Interna.....: pi_gera_lote_impl_dni
*****************************************************************************/
PROCEDURE pi_gera_lote_impl_dni:

    /************************* Variable Definition Begin ************************/

    def var v_des_1
        as character
        format "x(40)":U
        initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
        case-sensitive
        no-undo.
    def var v_cod_return                     as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_1   = "rdi"
           v_log_sai = NO.

    /* * Procura a Ultima Referencia Titulo no Contas a Receber **/
    assign v_cod_refer = v_des_1 + string(month(today),"99")
                                 + string(day(today),"99")
                                 + "00".   

    DO WHILE v_log_sai = no:

       FIND LAST movto_tit_acr /*USE-INDEX mvtttcr_refer*/ NO-LOCK 
           WHERE movto_tit_acr.cod_estab = cta_corren.cod_estab
           AND   movto_tit_acr.cod_refer = v_cod_refer NO-ERROR.
       
       IF  NOT AVAIL movto_tit_acr THEN do:
           ASSIGN v_log_sai = YES.
       END.
       ELSE DO:
           ASSIGN v_cod_return = SUBSTRING(v_cod_refer,8,2). /* Ex: rdi0730 */             
           RUN pi_increase_char_counter(INPUT-OUTPUT v_cod_return) /*pi_increase_char_counter*/.
           ASSIGN v_cod_refer = v_des_1 + STRING(MONTH(TODAY),"99")
                                        + STRING(DAY(TODAY),"99") 
                                        + v_cod_return.
       END.
    END.

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ        = cta_corren.cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= v_dat_di
           and histor_finalid_econ.dat_fim_valid_finalid   > v_dat_di
         use-index hstrfnld_id no-error.
    if avail histor_finalid_econ 
       then assign v_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

    create tt_integr_acr_lote_impl.
    assign tt_integr_acr_lote_impl.tta_cod_empresa               = cta_corren.cod_empresa
           tt_integr_acr_lote_impl.tta_cod_estab                 = cta_corren.cod_estab
           tt_integr_acr_lote_impl.tta_cod_refer                 = v_cod_refer
           tt_integr_acr_lote_impl.tta_cod_indic_econ            = v_cod_indic_econ
           tt_integr_acr_lote_impl.tta_cod_espec_docto           = param_estab_acr.cod_espec_docto_di
           tt_integr_acr_lote_impl.tta_dat_transacao             = v_dat_di
           tt_integr_acr_lote_impl.tta_ind_tip_espec_docto       = "Antecipaá∆o"
           tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr = 0
           tt_integr_acr_lote_impl.ttv_log_lote_impl_ok          = yes
           v_rec_lote_impl_tit_acr                               = recid(tt_integr_acr_lote_impl).

END PROCEDURE. /* pi_gera_lote_impl_dni */

/*****************************************************************************
** Procedure Interna.....: pi_gera_item_lote_impl_dni
*****************************************************************************/
PROCEDURE pi_gera_item_lote_impl_dni:

    /************************* Variable Definition Begin ************************/

    def var v_des_1
        as character
        format "x(40)":U
        initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
        case-sensitive
        no-undo.
    def var v_cod_return                     as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_tit_acr = ""
           v_des_1       = "DI"
           v_log_sai     = NO.

    /* * Procura o Pr¢ximo Titulo no Contas a Receber **/
    assign v_cod_tit_acr = v_des_1 
                         + string(month(today),"99")
                         + string(day(today),"99").

    find last tit_acr use-index titacr_id
        where tit_acr.cod_estab       = cta_corren.cod_estab
        and   tit_acr.cod_espec_docto = param_estab_acr.cod_espec_docto_di
        and   tit_acr.cod_ser_docto   = param_estab_acr.cod_ser_docto_di
        and   tit_acr.cod_tit_acr     begins v_cod_tit_acr
        and   tit_acr.cod_parcela     = "1"
        no-lock no-error.

    if  not avail tit_acr then do:
        /* * Inicializa o Primeiro da Data **/
        assign v_cod_tit_acr = v_des_1
                             + string(month(today),"99")
                             + string(day(today),"99")
                             + "0000".
    end.
    else do:
        /* * Procura Proxima Sequencia do Titulo **/
        assign v_cod_tit_acr = tit_acr.cod_tit_acr.
        /* adiciona zeros na frente da ultima sequencia caso nao tenha 
           para nao gerar duplicidade */
        if  length(trim(substring(v_cod_tit_acr, 7, 4))) < 4 then
                assign substring(v_cod_tit_acr, 7, 4) = fill("0", 4 - length(trim(substring(v_cod_tit_acr,7,4)))) 
                                                      + trim(substring(v_cod_tit_acr,7,4)).    
    end.

    do  while v_log_sai = NO:
        /* * Procura Proxima Sequencia do Titulo **/
        assign v_cod_return = substring(v_cod_tit_acr,7,4).

        run pi_increase_char_counter (input-output v_cod_return) /*pi_increase_char_counter*/.

        assign v_cod_tit_acr = v_des_1
                             + string(month(today),"99")
                             + string(day(today),"99") 
                             + v_cod_return.

        find last tit_acr use-index titacr_id
            where tit_acr.cod_estab       = cta_corren.cod_estab
            and   tit_acr.cod_espec_docto = param_estab_acr.cod_espec_docto_di
            and   tit_acr.cod_ser_docto   = param_estab_acr.cod_ser_docto_di
            and   tit_acr.cod_tit_acr     = v_cod_tit_acr
            and   tit_acr.cod_parcela     = "1"
            no-lock no-error.
        if  avail tit_acr then DO:
            next.
        END.
        ELSE DO:
            ASSIGN v_log_sai = YES.
        END.
    end.

    create tt_integr_acr_item_lote_impl.
    assign tt_integr_acr_item_lote_impl.ttv_rec_lote_impl_tit_acr        = v_rec_lote_impl_tit_acr
           tt_integr_acr_item_lote_impl.tta_num_seq_refer                = 1
           tt_integr_acr_item_lote_impl.tta_cdn_cliente                  = int(v_cod_clien_infor)
           tt_integr_acr_item_lote_impl.tta_cod_espec_docto              = param_estab_acr.cod_espec_docto_di
           tt_integr_acr_item_lote_impl.tta_cod_ser_docto                = param_estab_acr.cod_ser_docto_di
           tt_integr_acr_item_lote_impl.tta_cod_tit_acr                  = v_cod_tit_acr
           tt_integr_acr_item_lote_impl.tta_cod_parcela                  = "1"
           tt_integr_acr_item_lote_impl.tta_cod_indic_econ               = v_cod_indic_econ
           tt_integr_acr_item_lote_impl.tta_cod_portador                 = v_cod_portad_di
           tt_integr_acr_item_lote_impl.tta_cod_cart_bcia                = param_estab_acr.cod_cart_bcia_di
           tt_integr_acr_item_lote_impl.tta_cod_motiv_movto_tit_acr      = param_estab_acr.cod_motiv_movto_di
           tt_integr_acr_item_lote_impl.tta_dat_vencto_tit_acr           = v_dat_di
           tt_integr_acr_item_lote_impl.tta_dat_prev_liquidac            = v_dat_di
           tt_integr_acr_item_lote_impl.tta_dat_desconto                 = ?
           tt_integr_acr_item_lote_impl.tta_dat_emis_docto               = v_dat_di
           tt_integr_acr_item_lote_impl.tta_val_tit_acr                  = v_val_tot_di
           tt_integr_acr_item_lote_impl.tta_val_liq_tit_acr              = v_val_tot_di
           tt_integr_acr_item_lote_impl.tta_des_text_histor              = ""
           tt_integr_acr_item_lote_impl.tta_cod_banco                    = cta_corren.cod_banco
           tt_integr_acr_item_lote_impl.tta_cod_agenc_bcia               = cta_corren.cod_agenc_bcia
           tt_integr_acr_item_lote_impl.tta_cod_cta_corren               = cta_corren.cod_cta_corren
           tt_integr_acr_item_lote_impl.tta_ind_tip_espec_docto          = "Antecipaá∆o".

    for each rat_motiv_movto_tit_acr no-lock
        where rat_motiv_movto_tit_acr.cod_estab               = cta_corren.cod_estab
          and rat_motiv_movto_tit_acr.cod_motiv_movto_tit_acr = param_estab_acr.cod_motiv_movto_di:
        create tt_integr_acr_aprop_ctbl_pend.
        assign tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = recid(tt_integr_acr_item_lote_impl)
               tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = rat_motiv_movto_tit_acr.cod_plano_cta_ctbl
               tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = rat_motiv_movto_tit_acr.cod_cta_ctbl
               tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = rat_motiv_movto_tit_acr.cod_unid_negoc
               tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = rat_motiv_movto_tit_acr.cod_tip_fluxo_financ
               tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_integr_acr_item_lote_impl.tta_val_tit_acr * rat_motiv_movto_tit_acr.val_perc_rat_ctbz / 100.
    end.

END PROCEDURE. /* pi_gera_item_lote_impl_dni */

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
/***********************  End of bas_cta_corren_concil **********************/

PROCEDURE piTelaUPC :
/*------------------------------------------------------------------------------
  Purpose:     Buscar objetos na tela do produto padr∆o.
  Parameters:  pWghFrame (WIDGET-HANDLE),
               pObjType  (CHARACTER),
               pObjName  (CHARACTER),
               phObj     (HANDLE).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pWghFrame AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER pObjType  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pObjName  AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER phObj     AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.
        END.

        IF wgh-obj:TYPE = "FIELD-GROUP":U THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    ASSIGN wgh-obj = ?.

    RETURN "OK":U.

END PROCEDURE.

/*****************************************************************************
** Procedure Interna.....: pi_increase_char_counter
*****************************************************************************/
PROCEDURE pi_increase_char_counter:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_cod_geral
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_adc                        as logical         no-undo. /*local*/
    def var v_num_count                      as integer         no-undo. /*local*/
    def var v_num_pos                        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ---------------------------------- Funcionamento desta pi ---------------------------------------
    O resultado desta pi Ç o seguinte:
    Para criar sequencias sao considerados os caracteres 0123456789abcdefghijklmnopqrstuvwxyz.
    As sequencias sao crecentes somente dentro do mesmo n£mero de digitos. Por exemplo, uma 
    sequencia variando de 00...09-0a..0z..9z-aa..zz, ser†, ap¢s atingido o valor zz, 000.
    PorÇm, 000 Ç menor que zz, fato que deve ser considerado pelo programa chamador que utilizar
    o comando find last.
    -------------------------------------------------------------------------------------------------*/

    if  p_cod_geral <> "" then do:

        valida_caracters:
        do v_num_count = length(p_cod_geral) to 1 by -1:
            if  index("0123456789abcdefghijklmnopqrstuvwxyz" /*l_alphanum_chars*/ , substr(p_cod_geral, v_num_count, 1)) = 0
            then do:
                assign substr(p_cod_geral, v_num_count, 1) = "".
            end /* if */.
        end /* do valida_caracters */.

        loop:
        do v_num_count = length(p_cod_geral) to 1 by -1:
            assign v_num_pos = index("0123456789abcdefghijklmnopqrstuvwxyz" /*l_alphanum_chars*/ , substr(p_cod_geral, v_num_count, 1)).
            if  v_num_pos > 0
            then do:
                /* A atividade 138.827 alterou esta pi para gerar corretamente a parcela, devido a lista de impacto, a alteraá∆o foi realizada sob demanda.*/
                if  v_num_pos >= 36
                then do:
                    assign substr(p_cod_geral, v_num_count, 1) = "0"
                           v_log_adc = yes.
                end /* if */.
                else do:
                    assign substr(p_cod_geral, v_num_count, 1) = substr("0123456789abcdefghijklmnopqrstuvwxyz" /*l_alphanum_chars*/ , v_num_pos + 1, 1)
                           v_log_adc = no.
                    leave loop.
                end /* else */.
            end /* if */.
        end /* do loop */.
        if  v_log_adc = yes
        then do:
            assign p_cod_geral = "0" + p_cod_geral.
        end /* if */.
    end.
    else do:
        assign p_cod_geral = fill( "0", length(p_cod_geral) - 1 ) + "1" .
    end.

    assign p_cod_geral = TRIM(p_cod_geral).
END PROCEDURE. /* pi_increase_char_counter */

