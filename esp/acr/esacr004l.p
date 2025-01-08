/*****************************************************************************
** Nome Externo..........: esp/acr/esacr004l.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 12/01/2009
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

&if "{&emsuni_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSUNI")) /*msg_5884*/.
&elseif "{&emsuni_version}" < "1.00" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "SEE_CTA_CTBL_INTEGR","~~EMSUNI", "~~{~&emsuni_version}", "~~1.00")) /*msg_5009*/.
&else

/************************ Parameter Definition Begin ************************/

def Input param p_cod_modul_dtsul
    as character
    format "x(3)"
    no-undo.
def Input param p_cod_plano_cta_ctbl
    as character
    format "x(8)"
    no-undo.
def Input param p_ind_finalid_ctbl
    as character
    format "X(30)"
    no-undo.


/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

def buffer b_plano_cta_ctbl
    for plano_cta_ctbl.


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cod_altern_cta_ctbl_fim
    as character
    format "x(12)":U
    initial "ZZZZZZZZZZZZ"
    label "Final"
    column-label "Final"
    no-undo.
def var v_cod_altern_cta_ctbl_ini
    as character
    format "x(12)":U
    label "Inicial"
    column-label "Inicial"
    no-undo.
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
def var v_cod_cta_ctbl_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "Conta Final"
    column-label "Final"
    no-undo.
def var v_cod_cta_ctbl_ini
    as character
    format "x(20)":U
    label "Conta Inicial"
    column-label "Inicial"
    no-undo.
def var v_cod_dat_type
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu rio"
    column-label "Usu rio"
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
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
    no-undo.
def new global shared var v_cod_modul_dtsul
    as character
    format "x(3)":U
    label "M¢dulo"
    column-label "M¢dulo"
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
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
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
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_des_tit_ctbl_fim
    as character
    format "x(40)":U
    initial "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
    label "Final"
    column-label "T¡tulo Cont bil"
    no-undo.
def var v_des_tit_ctbl_ini
    as character
    format "x(40)":U
    label "Inicial"
    column-label "T¡tulo Cont bil"
    no-undo.
def var v_nom_attrib
    as character
    format "x(30)":U
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_rec_cta_ctbl_integr
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_modul_dtsul
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_cod_format_cta_ctbl            as character       no-undo. /*local*/


/************************** Variable Definition End *************************/

/************************** Query Definition Begin **************************/

def query qr_see_cta_ctbl_integr
    for cta_ctbl_integr,
        b_plano_cta_ctbl,
        cta_ctbl
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_see_cta_ctbl_integr query qr_see_cta_ctbl_integr display 
    string(cta_ctbl_integr.cod_cta_ctbl, b_plano_cta_ctbl.cod_format_cta_ctbl) format "x(20)" column-label "Conta Cont bil"
    cta_ctbl.des_tit_ctbl
    width-chars 40.00
        column-label "T¡tulo Cont bil"
    cta_ctbl.cod_altern_cta_ctbl
    width-chars 12.00
        column-label "Alternativa"
    cta_ctbl_integr.dat_inic_valid
    width-chars 10.00
        column-label "Inic Validade"
    cta_ctbl_integr.dat_fim_valid
    width-chars 10.00
        column-label "Fim Validade"
    with no-box separators single 
         size 86.00 by 07.00
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_cxcl
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
def button bt_ran
    label "Faixa"
    tooltip "Faixa"
    size 1 by 1.
/*************************** Button Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_see_cta_ctbl_integr
    as character
    initial "Por Conta Cont bil"
    view-as radio-set Horizontal
    radio-buttons "Por Conta Cont bil", "Por Conta Cont bil","Por T¡tulo", "Por T¡tulo","Conta Alternativa", "Conta Alternativa"
     /*l_por_conta_contabil*/ /*l_por_conta_contabil*/ /*l_por_titulo*/ /*l_por_titulo*/ /*l_cta_alternativa*/ /*l_cta_alternativa*/
    bgcolor 15 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/
def frame f_ran_01_cta_ctbl_alternativa
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.88 col 02.00 bgcolor 7 
    v_cod_altern_cta_ctbl_ini
         at row 01.42 col 14.00 colon-aligned label "Inicial"
         help "C¢digo Alternativo Conta Cont bil"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_altern_cta_ctbl_fim
         at row 02.42 col 14.00 colon-aligned label "Final"
         help "C¢digo Alternativo Conta Cont bil"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.08 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 42.00 by 05.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - Alternativa".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_cta_ctbl_alternativa = 10.00
           bt_can:height-chars  in frame f_ran_01_cta_ctbl_alternativa = 01.00
           bt_ok:width-chars    in frame f_ran_01_cta_ctbl_alternativa = 10.00
           bt_ok:height-chars   in frame f_ran_01_cta_ctbl_alternativa = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_cta_ctbl_alternativa = 38.57
           rt_cxcf:height-chars in frame f_ran_01_cta_ctbl_alternativa = 01.42
           rt_mold:width-chars  in frame f_ran_01_cta_ctbl_alternativa = 38.57
           rt_mold:height-chars in frame f_ran_01_cta_ctbl_alternativa = 02.29.
    /* set private-data for the help system */
    assign v_cod_altern_cta_ctbl_ini:private-data in frame f_ran_01_cta_ctbl_alternativa = "HLP=000021910":U
           v_cod_altern_cta_ctbl_fim:private-data in frame f_ran_01_cta_ctbl_alternativa = "HLP=000021911":U
           bt_ok:private-data                     in frame f_ran_01_cta_ctbl_alternativa = "HLP=000010721":U
           bt_can:private-data                    in frame f_ran_01_cta_ctbl_alternativa = "HLP=000011050":U
           frame f_ran_01_cta_ctbl_alternativa:private-data                              = "HLP=000011414".

def frame f_ran_01_cta_ctbl_integr_conta
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.88 col 02.00 bgcolor 7 
    v_cod_cta_ctbl_ini
         at row 01.42 col 20.00 colon-aligned label "Conta Inicial"
         help "C¢digo Conta Cont bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_ctbl_fim
         at row 02.42 col 20.00 colon-aligned label "Conta Final"
         help "C¢digo Conta Cont bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.08 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 62.00 by 05.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - Conta Cont bil".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_cta_ctbl_integr_conta = 10.00
           bt_can:height-chars  in frame f_ran_01_cta_ctbl_integr_conta = 01.00
           bt_ok:width-chars    in frame f_ran_01_cta_ctbl_integr_conta = 10.00
           bt_ok:height-chars   in frame f_ran_01_cta_ctbl_integr_conta = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_cta_ctbl_integr_conta = 58.57
           rt_cxcf:height-chars in frame f_ran_01_cta_ctbl_integr_conta = 01.42
           rt_mold:width-chars  in frame f_ran_01_cta_ctbl_integr_conta = 58.57
           rt_mold:height-chars in frame f_ran_01_cta_ctbl_integr_conta = 02.29.
    /* set private-data for the help system */
    assign v_cod_cta_ctbl_ini:private-data in frame f_ran_01_cta_ctbl_integr_conta = "HLP=000019246":U
           v_cod_cta_ctbl_fim:private-data in frame f_ran_01_cta_ctbl_integr_conta = "HLP=000019247":U
           bt_ok:private-data              in frame f_ran_01_cta_ctbl_integr_conta = "HLP=000010721":U
           bt_can:private-data             in frame f_ran_01_cta_ctbl_integr_conta = "HLP=000011050":U
           frame f_ran_01_cta_ctbl_integr_conta:private-data                       = "HLP=000011414".

def frame f_ran_01_cta_ctbl_titulo
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 03.88 col 02.00 bgcolor 7 
    v_des_tit_ctbl_ini
         at row 01.42 col 10.00 colon-aligned label "Inicial"
         help "Descri‡Æo T¡tulo Cont bil"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_tit_ctbl_fim
         at row 02.42 col 10.00 colon-aligned label "Final"
         help "Descri‡Æo T¡tulo Cont bil"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.08 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.08 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 56.00 by 05.71 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - T¡tulo".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_cta_ctbl_titulo = 10.00
           bt_can:height-chars  in frame f_ran_01_cta_ctbl_titulo = 01.00
           bt_ok:width-chars    in frame f_ran_01_cta_ctbl_titulo = 10.00
           bt_ok:height-chars   in frame f_ran_01_cta_ctbl_titulo = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_cta_ctbl_titulo = 52.57
           rt_cxcf:height-chars in frame f_ran_01_cta_ctbl_titulo = 01.42
           rt_mold:width-chars  in frame f_ran_01_cta_ctbl_titulo = 52.57
           rt_mold:height-chars in frame f_ran_01_cta_ctbl_titulo = 02.29.
    /* set private-data for the help system */
    assign v_des_tit_ctbl_ini:private-data in frame f_ran_01_cta_ctbl_titulo = "HLP=000021904":U
           v_des_tit_ctbl_fim:private-data in frame f_ran_01_cta_ctbl_titulo = "HLP=000021905":U
           bt_ok:private-data              in frame f_ran_01_cta_ctbl_titulo = "HLP=000010721":U
           bt_can:private-data             in frame f_ran_01_cta_ctbl_titulo = "HLP=000011050":U
           frame f_ran_01_cta_ctbl_titulo:private-data                       = "HLP=000011414".

def frame f_see_01_cta_ctbl_integr
    rt_001
         at row 01.21 col 02.00
    rt_cxcf
         at row 15.04 col 02.00 bgcolor 7 
    rt_cxcl
         at row 04.58 col 02.00 bgcolor 15 
    p_cod_modul_dtsul
         at row 01.42 col 26.00 colon-aligned label "M¢dulo"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    modul_dtsul.des_modul_dtsul
         at row 01.42 col 33.00 no-label
         view-as fill-in
         size-chars 33.14 by .88
         fgcolor ? bgcolor 15 font 2
    p_cod_plano_cta_ctbl
         at row 02.42 col 26.00 colon-aligned label "Plano Contas"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    plano_cta_ctbl.des_tit_ctbl
         at row 02.42 col 38.00 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    p_ind_finalid_ctbl
         at row 03.42 col 26.00 colon-aligned label "Finalidade Cont bil"
         view-as fill-in
         size-chars 31.14 by .88
         fgcolor ? bgcolor 15 font 2
    rs_see_cta_ctbl_integr
         at row 04.79 col 03.00
         help "" no-label
    br_see_cta_ctbl_integr
         at row 05.83 col 02.00
    bt_ran
         at row 13.54 col 03.00 font ?
         help "Faixa"
    bt_ok
         at row 15.25 col 03.00 font ?
         help "OK"
    bt_can
         at row 15.25 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 88.43 by 16.88 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Pesquisa Contas Cont beis de Integra‡Æo".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_see_01_cta_ctbl_integr = 10.00
           bt_can:height-chars  in frame f_see_01_cta_ctbl_integr = 01.00
           bt_ok:width-chars    in frame f_see_01_cta_ctbl_integr = 10.00
           bt_ok:height-chars   in frame f_see_01_cta_ctbl_integr = 01.00
           rt_001:width-chars   in frame f_see_01_cta_ctbl_integr = 86.00
           rt_001:height-chars  in frame f_see_01_cta_ctbl_integr = 03.29
           bt_ran:width-chars   in frame f_see_01_cta_ctbl_integr = 10.00
           bt_ran:height-chars  in frame f_see_01_cta_ctbl_integr = 01.00
           rt_cxcf:width-chars  in frame f_see_01_cta_ctbl_integr = 85.00
           rt_cxcf:height-chars in frame f_see_01_cta_ctbl_integr = 01.42
           rt_cxcl:width-chars  in frame f_see_01_cta_ctbl_integr = 86.00
           rt_cxcl:height-chars in frame f_see_01_cta_ctbl_integr = 01.25.
    /* set private-data for the help system */
    assign p_cod_modul_dtsul:private-data           in frame f_see_01_cta_ctbl_integr = "HLP=000022019":U
           modul_dtsul.des_modul_dtsul:private-data in frame f_see_01_cta_ctbl_integr = "HLP=000005702":U
           p_cod_plano_cta_ctbl:private-data        in frame f_see_01_cta_ctbl_integr = "HLP=000022021":U
           plano_cta_ctbl.des_tit_ctbl:private-data in frame f_see_01_cta_ctbl_integr = "HLP=000025187":U
           p_ind_finalid_ctbl:private-data          in frame f_see_01_cta_ctbl_integr = "HLP=000022024":U
           rs_see_cta_ctbl_integr:private-data      in frame f_see_01_cta_ctbl_integr = "HLP=000011414":U
           br_see_cta_ctbl_integr:private-data      in frame f_see_01_cta_ctbl_integr = "HLP=000011414":U
           bt_ok:private-data                       in frame f_see_01_cta_ctbl_integr = "HLP=000010721":U
           bt_can:private-data                      in frame f_see_01_cta_ctbl_integr = "HLP=000011050":U
           frame f_see_01_cta_ctbl_integr:private-data                                = "HLP=000011414".

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_can IN FRAME f_see_01_cta_ctbl_integr
DO:

    apply "end-error" to self.
END. /* ON CHOOSE OF bt_can IN FRAME f_see_01_cta_ctbl_integr */

ON CHOOSE OF bt_ok IN FRAME f_see_01_cta_ctbl_integr
DO:

    if  avail cta_ctbl_integr
    then do:
        assign v_rec_cta_ctbl_integr = recid(cta_ctbl_integr).
    end /* if */.
END. /* ON CHOOSE OF bt_ok IN FRAME f_see_01_cta_ctbl_integr */

ON VALUE-CHANGED OF rs_see_cta_ctbl_integr IN FRAME f_see_01_cta_ctbl_integr
DO:

    run pi_open_see_cta_ctbl_integr /*pi_open_see_cta_ctbl_integr*/.
END. /* ON VALUE-CHANGED OF rs_see_cta_ctbl_integr IN FRAME f_see_01_cta_ctbl_integr */

ON END-ERROR OF FRAME f_see_01_cta_ctbl_integr
DO:

    assign v_rec_cta_ctbl_integr = ?.
END. /* ON END-ERROR OF FRAME f_see_01_cta_ctbl_integr */

ON ENTRY OF FRAME f_see_01_cta_ctbl_integr
DO:

    apply "value-changed" to rs_see_cta_ctbl_integr in frame f_see_01_cta_ctbl_integr.

END. /* ON ENTRY OF FRAME f_see_01_cta_ctbl_integr */

ON CHOOSE OF bt_ran IN FRAME f_see_01_cta_ctbl_integr
DO:

    /* case_block: */
    case input frame f_see_01_cta_ctbl_integr rs_see_cta_ctbl_integr:
        when "Por Conta Cont bil" /*l_por_conta_contabil*/ then
            code_block:
            do:

                /* Begin_Include: i_see_range */
                view frame f_ran_01_cta_ctbl_integr_conta.

                range_block:
                do on error undo range_block, retry range_block:
                    update v_cod_cta_ctbl_ini
                           v_cod_cta_ctbl_fim
                           bt_ok
                           bt_can
                           with frame f_ran_01_cta_ctbl_integr_conta.
                    run pi_open_see_cta_ctbl_integr /*pi_open_see_cta_ctbl_integr*/.
                end /* do range_block */.

                hide frame f_ran_01_cta_ctbl_integr_conta.

                /* End_Include: i_see_range */

            end /* do code_block */.
        when "Por T¡tulo" /*l_por_titulo*/ then
            code_block:
            do:

                /* Begin_Include: i_see_range */
                view frame f_ran_01_cta_ctbl_titulo.

                range_block:
                do on error undo range_block, retry range_block:
                    update v_des_tit_ctbl_ini
                           v_des_tit_ctbl_fim
                           bt_ok
                           bt_can
                           with frame f_ran_01_cta_ctbl_titulo.
                    run pi_open_see_cta_ctbl_integr /*pi_open_see_cta_ctbl_integr*/.
                end /* do range_block */.

                hide frame f_ran_01_cta_ctbl_titulo.

                /* End_Include: i_see_range */

            end /* do code_block */.     
        when "Conta Alternativa" /*l_cta_alternativa*/ then
            code_block:
            do:

                /* Begin_Include: i_see_range */
                view frame f_ran_01_cta_ctbl_alternativa.

                range_block:
                do on error undo range_block, retry range_block:
                    update v_cod_altern_cta_ctbl_ini
                           v_cod_altern_cta_ctbl_fim
                           bt_ok
                           bt_can
                           with frame f_ran_01_cta_ctbl_alternativa.
                    run pi_open_see_cta_ctbl_integr /*pi_open_see_cta_ctbl_integr*/.
                end /* do range_block */.

                hide frame f_ran_01_cta_ctbl_alternativa.

                /* End_Include: i_see_range */

            end /* do code_block */.
    end /* case case_block */.

END. /* ON CHOOSE OF bt_ran IN FRAME f_see_01_cta_ctbl_integr */


/****************************** Main Code Begin *****************************/

/* Begin_Include: ix_p00_see_cta_ctbl_integr */
display p_cod_modul_dtsul
        p_cod_plano_cta_ctbl
        p_ind_finalid_ctbl
        with frame f_see_01_cta_ctbl_integr.

if  p_cod_modul_dtsul = ""
then do:
    /* Empresa: &1 nÆo possui m¢dulo &2 ! */
    run pi_messages (input "show",
                     input 3157,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       v_cod_empres_usuar, p_cod_modul_dtsul)) /*msg_3157*/.
end /* if */.
else do:
    find modul_dtsul no-lock
         where modul_dtsul.cod_modul_dtsul = p_cod_modul_dtsul /*cl_key_parameter of modul_dtsul*/ no-error.
    if  not avail modul_dtsul
    then do:
       /* Empresa: &1 nÆo possui m¢dulo: &2 ! */
       run pi_messages (input "show",
                        input 491,
                        input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           v_cod_empres_usuar, p_cod_modul_dtsul)) /*msg_491*/.
    end /* if */.
    display modul_dtsul.des_modul_dtsul when avail modul_dtsul
            "" when not avail modul_dtsul @ modul_dtsul.des_modul_dtsul
            with frame f_see_01_cta_ctbl_integr.
end /* else */.

find plano_cta_ctbl no-lock
     where plano_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl /*cl_key_parameter of plano_cta_ctbl*/ no-error.
if  not avail plano_cta_ctbl
then do:
   /* Plano de Contas inv lido ! */
   run pi_messages (input "show",
                    input 2736,
                    input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2736*/.
   return error.
end /* if */.
else do:
     assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
            v_cod_cta_ctbl_ini:format in frame f_ran_01_cta_ctbl_integr_conta = plano_cta_ctbl.cod_format_cta_ctbl
            v_cod_cta_ctbl_fim:format in frame f_ran_01_cta_ctbl_integr_conta = plano_cta_ctbl.cod_format_cta_ctbl.
end /* else */.

display plano_cta_ctbl.des_tit_ctbl when avail plano_cta_ctbl
        "" when not avail plano_cta_ctbl @ plano_cta_ctbl.des_tit_ctbl
        with frame f_see_01_cta_ctbl_integr.

/* --- Seta m scara e valores iniciais para a faixa de contas ---*/
assign v_cod_cta_ctbl_ini:format in frame f_ran_01_cta_ctbl_integr_conta = plano_cta_ctbl.cod_format_cta_ctbl
       v_cod_cta_ctbl_fim:format in frame f_ran_01_cta_ctbl_integr_conta = plano_cta_ctbl.cod_format_cta_ctbl.

run pi_retornar_min_format (Input plano_cta_ctbl.cod_format_cta_ctbl,
                            output v_cod_cta_ctbl_ini) /*pi_retornar_min_format*/.
run pi_retornar_max_format (Input plano_cta_ctbl.cod_format_cta_ctbl,
                            output v_cod_cta_ctbl_fim) /*pi_retornar_max_format*/.
/* End_Include: ix_p00_see_cta_ctbl_integr */


/* redefini‡äes do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e versÆo */
assign frame f_see_01_cta_ctbl_integr:title = frame f_see_01_cta_ctbl_integr:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).

assign br_see_cta_ctbl_integr:num-locked-columns in frame f_see_01_cta_ctbl_integr = 0.

pause 0 before-hide.
view frame f_see_01_cta_ctbl_integr.

assign v_rec_table    = v_rec_cta_ctbl_integr.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.
    display rs_see_cta_ctbl_integr
            with frame f_see_01_cta_ctbl_integr.

    enable rs_see_cta_ctbl_integr
           br_see_cta_ctbl_integr
           bt_ran
           bt_ok
           bt_can
           with frame f_see_01_cta_ctbl_integr.

    wait-for go of frame f_see_01_cta_ctbl_integr
          or default-action of br_see_cta_ctbl_integr
          or mouse-select-dblclick of br_see_cta_ctbl_integr.
    if  avail cta_ctbl_integr
    then do:
        assign v_rec_cta_ctbl_integr = recid(cta_ctbl_integr).
    end /* if */.
    /* ix_p20_see_cta_ctbl_integr */
end /* do main_block */.

hide frame f_see_01_cta_ctbl_integr.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_open_see_cta_ctbl_integr
** Descricao.............: pi_open_see_cta_ctbl_integr
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre17906
** Alterado em...........: 27/07/2001 15:45:58
*****************************************************************************/
PROCEDURE pi_open_see_cta_ctbl_integr:

    /* case_block: */
    case input frame f_see_01_cta_ctbl_integr rs_see_cta_ctbl_integr:
        when "Por Conta Cont bil" /*l_por_conta_contabil*/ then
            code_block:
            do:
                open query qr_see_cta_ctbl_integr for
                    each cta_ctbl_integr no-lock
                          where cta_ctbl_integr.cod_modul_dtsul    = p_cod_modul_dtsul
                            and cta_ctbl_integr.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                            and can-do( p_ind_finalid_ctbl, cta_ctbl_integr.ind_finalid_ctbl )
                            and cta_ctbl_integr.cod_cta_ctbl      >= v_cod_cta_ctbl_ini
                            and cta_ctbl_integr.cod_cta_ctbl      <= v_cod_cta_ctbl_fim,
                    each b_plano_cta_ctbl no-lock
                    where b_plano_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl
                    ,
                    each cta_ctbl no-lock
                    where cta_ctbl.cod_cta_ctbl = cta_ctbl_integr.cod_cta_ctbl
                      and cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl

                    by cta_ctbl_integr.cod_cta_ctbl.
            end /* do code_block */.
        when "Por T¡tulo" /*l_por_titulo*/ then
            code_block:
            do:
                open query qr_see_cta_ctbl_integr for
                    each cta_ctbl_integr no-lock 
                         where cta_ctbl_integr.cod_modul_dtsul    = p_cod_modul_dtsul
                           and cta_ctbl_integr.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                           and can-do( p_ind_finalid_ctbl, cta_ctbl_integr.ind_finalid_ctbl )
                    ,first b_plano_cta_ctbl no-lock
                     where b_plano_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl
                     ,
                    each cta_ctbl no-lock
                    where cta_ctbl.cod_cta_ctbl = cta_ctbl_integr.cod_cta_ctbl
                      and cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl

                      and cta_ctbl.des_tit_ctbl >= v_des_tit_ctbl_ini
                      and cta_ctbl.des_tit_ctbl <= v_des_tit_ctbl_fim /*cl_sea_cta_ctbl_titulo of cta_ctbl*/
                    by cta_ctbl.des_tit_ctbl.
            end /* do code_block */.
        when "Conta Alternativa" /*l_cta_alternativa*/ then
            code_block:
            do:
                open query qr_see_cta_ctbl_integr for
                    each cta_ctbl_integr no-lock
                          where cta_ctbl_integr.cod_modul_dtsul    = p_cod_modul_dtsul
                            and cta_ctbl_integr.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                            and can-do( p_ind_finalid_ctbl, cta_ctbl_integr.ind_finalid_ctbl ),
                    each b_plano_cta_ctbl no-lock
                    where b_plano_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl_integr.cod_plano_cta_ctbl
                    ,
                    each cta_ctbl no-lock
                    where cta_ctbl.cod_plano_cta_ctbl   = cta_ctbl_integr.cod_plano_cta_ctbl
                      and cta_ctbl.cod_cta_ctbl         = cta_ctbl_integr.cod_cta_ctbl
                      and cta_ctbl.cod_altern_cta_ctbl >= v_cod_altern_cta_ctbl_ini
                      and cta_ctbl.cod_altern_cta_ctbl <= v_cod_altern_cta_ctbl_fim
                    by cta_ctbl.cod_altern_cta_ctbl.
            end /* do code_block */.
    end /* case case_block */.
END PROCEDURE. /* pi_open_see_cta_ctbl_integr */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_min_format
** Descricao.............: pi_retornar_min_format
** Criado por............: vanei
** Criado em.............: 07/12/1995 11:08:01
** Alterado por..........: BRE17264
** Alterado em...........: 04/12/1998 11:46:02
*****************************************************************************/
PROCEDURE pi_retornar_min_format:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_count  = 1
           p_cod_return = "".

    contador:
    do while v_num_count <= length(p_cod_format):
        /* testa_block: */
        case substring(p_cod_format, v_num_count, 1):
            when "!" then
                assign p_cod_return = p_cod_return + keylabel(65).
            when 'X' then
                assign p_cod_return = p_cod_return + keylabel(65) /* keylabel(32) - Puccini */.
            when "9" then
                assign p_cod_return = p_cod_return + "0".
        end /* case testa_block */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
END PROCEDURE. /* pi_retornar_min_format */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_max_format
** Descricao.............: pi_retornar_max_format
** Criado por............: vanei
** Criado em.............: 07/12/1995 11:08:18
** Alterado por..........: vanei
** Alterado em...........: 07/12/1995 11:23:25
*****************************************************************************/
PROCEDURE pi_retornar_max_format:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_count  = 1
           p_cod_return = "".

    contador:
    do while v_num_count <= length(p_cod_format):
        /* testa_block: */
        case substring(p_cod_format, v_num_count, 1):
            when "!" then
                assign p_cod_return = p_cod_return + keylabel(90).
            when 'X' then
                assign p_cod_return = p_cod_return + keylabel(90).
            when "9" then
                assign p_cod_return = p_cod_return + "9".
        end /* case testa_block */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
END PROCEDURE. /* pi_retornar_max_format */

/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/
&endif

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
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/************************  End of see_cta_ctbl_integr ***********************/
