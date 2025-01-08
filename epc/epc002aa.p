/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_codigo_barra_espec
** Descricao.............: C¢digo de Barras
** Versao................:  1.00.00.000
** Procedimento..........: man_codigo_barra_espec
** Nome Externo..........: epc/epc002aa.p
** Data Geracao..........: 19/10/2004
** Criado por............: fut12237
** Criado em.............: 19/10/2004
** Alterado por..........: fut12237
** Alterado em...........: 19/10/2004
** Gerado por............: fut12237
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/

/************************* Variable Definition Begin ************************/

def NEW GLOBAL shared var p_cod_num_bcio 
    as character
    no-undo.
def NEW global shared var p_cod_barra
    as character
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_barra_1
    as character
    format "99999.99999":U
    no-undo.
def var v_cod_barra_1_aux
    as character
    format "x(12)":U
    no-undo.
def var v_cod_barra_2
    as character
    format "99999.999999":U
    no-undo.
def var v_cod_barra_2_aux
    as character
    format "x(12)":U
    no-undo.
def var v_cod_barra_3
    as character
    format "99999.999999":U
    no-undo.
def var v_cod_barra_3_aux
    as character
    format "x(12)":U
    no-undo.
def var v_cod_barra_4
    as character
    format "9":U
    no-undo.
def var v_cod_barra_4_aux
    as character
    format "x(12)":U
    no-undo.
def var v_cod_barra_5
    as character
    format "99999999999999":U
    no-undo.
def var v_cod_barra_aux
    as character
    format "x(14)":U
    no-undo.
def var v_cod_barra_compl
    as character
    format "x(55)":U
    no-undo.
def var v_cod_barra_compl_aux
    as character
    format "x(55)":U
    no-undo.
def var v_cod_campo_livre
    as character
    format "x(50)":U
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
def var v_cod_format_barra_5
    as character
    format "x(14)":U
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
def var v_cod_num_bcio
    as character
    format "x(20)":U
    label "N£mero Banc†rio"
    column-label "N£mero Banc†rio"
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
def var v_ind_tit_fatur
    as character
    format "X(08)":U
    view-as radio-set Horizontal
    radio-buttons "T°tulo", "T°tulo","Fatura Cta Consumo", "Fatura Cta Consumo"
     /*l_titulo*/ /*l_titulo*/ /*l_fatura_cta_consumo*/ /*l_fatura_cta_consumo*/
    bgcolor 8 
    no-undo.
def var v_log_abert
    as logical
    format "Sim/Nao"
    initial yes
    no-undo.
def var v_log_aux
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_funcao_cod_barra
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_leitura_barra
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_acum
    as integer
    format ">>>>,>>9":U
    label "Acumulado"
    column-label "Acumulado"
    no-undo.
def var v_num_cont_aux
    as integer
    format ">9":U
    no-undo.
def var v_num_digito
    as integer
    format "9":U
    no-undo.
def var v_num_inicial_barra_5
    as integer
    format ">>9":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_abrev
    as integer
    format ">>>9":U
    label "Sq"
    column-label "Seq"
    no-undo.
def var v_num_tam_format
    as integer
    format ">>9":U
    no-undo.
def var v_num_tam_format_1
    as integer
    format ">9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

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
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_01_cod_barras
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 07.08 col 02.00 bgcolor 7 
    v_log_leitura_barra
         at row 01.54 col 04.00 label "Usa Leitura ‡tica"
         view-as toggle-box
    v_ind_tit_fatur
         at row 02.54 col 04.00 no-label
         view-as radio-set Horizontal
         radio-buttons "T°tulo", "T°tulo","Fatura Cta Consumo", "Fatura Cta Consumo"
          /*l_titulo*/ /*l_titulo*/ /*l_fatura_cta_consumo*/ /*l_fatura_cta_consumo*/
         bgcolor 8 
    v_cod_barra_compl
         at row 03.54 col 04.00 no-label
         view-as fill-in
         size-chars 56.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_1
         at row 04.54 col 04.00 no-label
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_2
         at row 04.54 col 16.29 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_3
         at row 04.54 col 29.57 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_4
         at row 04.54 col 42.86 no-label
         view-as fill-in
         size-chars 2.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_5
         at row 04.54 col 45.14 no-label
         view-as fill-in
         size-chars 15.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_1_aux
         at row 05.54 col 04.00 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_2_aux
         at row 05.54 col 17.00 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_3_aux
         at row 05.54 col 30.00 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_barra_4_aux
         at row 05.54 col 43.00 no-label
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_num_bcio
         at row 01.54 col 36.86 colon-aligned label "N£mero Banc†rio"
         help "N£mero Banc†rio"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 07.29 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.29 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 07.29 col 51.43 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 63.86 by 08.92 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "C¢digo de Barras".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_cod_barras = 10.00
           bt_can:height-chars  in frame f_dlg_01_cod_barras = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_cod_barras = 10.00
           bt_hel2:height-chars in frame f_dlg_01_cod_barras = 01.00
           bt_ok:width-chars    in frame f_dlg_01_cod_barras = 10.00
           bt_ok:height-chars   in frame f_dlg_01_cod_barras = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_cod_barras = 60.43
           rt_cxcf:height-chars in frame f_dlg_01_cod_barras = 01.42
           rt_mold:width-chars  in frame f_dlg_01_cod_barras = 60.43
           rt_mold:height-chars in frame f_dlg_01_cod_barras = 05.50.
    /* set private-data for the help system */
    assign v_log_leitura_barra:private-data in frame f_dlg_01_cod_barras = "HLP=000025554":U
           v_ind_tit_fatur:private-data     in frame f_dlg_01_cod_barras = "HLP=000025553":U
           v_cod_barra_compl:private-data   in frame f_dlg_01_cod_barras = "HLP=000025555":U
           v_cod_barra_1:private-data       in frame f_dlg_01_cod_barras = "HLP=000026039":U
           v_cod_barra_2:private-data       in frame f_dlg_01_cod_barras = "HLP=000026040":U
           v_cod_barra_3:private-data       in frame f_dlg_01_cod_barras = "HLP=000026041":U
           v_cod_barra_4:private-data       in frame f_dlg_01_cod_barras = "HLP=000026042":U
           v_cod_barra_5:private-data       in frame f_dlg_01_cod_barras = "HLP=000026043":U
           v_cod_barra_1_aux:private-data   in frame f_dlg_01_cod_barras = "HLP=000025553":U
           v_cod_barra_2_aux:private-data   in frame f_dlg_01_cod_barras = "HLP=000025553":U
           v_cod_barra_3_aux:private-data   in frame f_dlg_01_cod_barras = "HLP=000025553":U
           v_cod_barra_4_aux:private-data   in frame f_dlg_01_cod_barras = "HLP=000025553":U
           v_cod_num_bcio:private-data      in frame f_dlg_01_cod_barras = "HLP=000025553":U
           bt_ok:private-data               in frame f_dlg_01_cod_barras = "HLP=000010721":U
           bt_can:private-data              in frame f_dlg_01_cod_barras = "HLP=000011050":U
           bt_hel2:private-data             in frame f_dlg_01_cod_barras = "HLP=000011326":U
           frame f_dlg_01_cod_barras:private-data                        = "HLP=000025553".



/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_cod_barras
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_cod_barras */

ON CHOOSE OF bt_ok IN FRAME f_dlg_01_cod_barras
DO:
    run pi_choose_bt_ok_barras.
    if return-value = "NOK" /*l_nok*/  then
       return no-apply.




END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_01_cod_barras */

ON ENTRY OF v_cod_barra_1 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_1:format in frame f_dlg_01_cod_barras = "99999.99999":U.
END. /* ON ENTRY OF v_cod_barra_1 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_1 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_1 = input frame f_dlg_01_cod_barras v_cod_barra_1 no-error.
    if  error-status:get-number(1) <> 0 then do:
        assign v_cod_barra_1:format in frame f_dlg_01_cod_barras = 'x(10)'.
    end.

    if v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras <> "" 
    then do:
        assign v_cod_barra_1 = replace(substring(v_cod_barra_1:screen-value,1,10),".","")
               v_log_abert   = yes.

        run pi_verificar_codigo_barras(input v_cod_barra_1,output v_num_digito).

        if v_num_digito <> integer(substring(v_cod_barra_1:screen-value,11,1))
        then do:
            /* D°gito Verificador n∆o Confere ! */
            run pi_messages (input "show",
                             input 6500,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               substring(v_cod_barra_1:screen-value,11,1),v_num_digito)) /*msg_6500*/.
            assign v_cod_barra_1:format in frame f_dlg_01_cod_barras = '99999.99999'.
            return no-apply.
        end.
    end.

    assign v_cod_barra_1:format in frame f_dlg_01_cod_barras = 'xxxxx.xxxxx'.



END. /* ON LEAVE OF v_cod_barra_1 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_1_aux IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_1_aux = replace(substring(v_cod_barra_1_aux:screen-value,1,11),".","")
           v_log_abert = yes.
    run pi_verificar_codigo_barras (Input v_cod_barra_1_aux,
                                    output v_num_digito) /*pi_verificar_codigo_barras*/.
    if  v_num_digito <> integer(substring(v_cod_barra_1_aux:screen-value,12,1))
    then do:
        /* D°gito Verificador n∆o Confere ! */
        run pi_messages (input "show",
                         input 6500,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           substring(v_cod_barra_1_aux:screen-value,12,1),v_num_digito)) /*msg_6500*/.
        return no-apply.
    end /* if */.
END. /* ON LEAVE OF v_cod_barra_1_aux IN FRAME f_dlg_01_cod_barras */

ON ENTRY OF v_cod_barra_2 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_2:format in frame f_dlg_01_cod_barras = "99999.999999":U.
END. /* ON ENTRY OF v_cod_barra_2 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_2 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_2 = input frame f_dlg_01_cod_barras v_cod_barra_2 no-error.
    if  error-status:get-number(1) <> 0 then do:
        assign v_cod_barra_2:format in frame f_dlg_01_cod_barras = 'x(11)'.
    end.

    if v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras <> "" 
    then do:

        assign v_cod_barra_2 = replace(substring(v_cod_barra_2:screen-value,1,11),".","")
               v_log_abert   = yes.

        run pi_verificar_codigo_barras(input v_cod_barra_2,output v_num_digito).

        if v_num_digito <> integer(substring(v_cod_barra_2:screen-value,12,1))
        then do:
            /* D°gito Verificador n∆o Confere ! */
            run pi_messages (input "show",
                             input 6500,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               substring(v_cod_barra_2:screen-value,12,1),v_num_digito)) /*msg_6500*/.
            assign v_cod_barra_2:format in frame f_dlg_01_cod_barras = '99999.999999'.
            return no-apply.
        end.
    end.

    assign v_cod_barra_2:format in frame f_dlg_01_cod_barras = 'xxxxx.xxxxxx'.
END. /* ON LEAVE OF v_cod_barra_2 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_2_aux IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_2_aux = replace(substring(v_cod_barra_2_aux:screen-value,1,11),".","")
           v_log_abert = yes.
    run pi_verificar_codigo_barras (Input v_cod_barra_2_aux,
                                    output v_num_digito) /*pi_verificar_codigo_barras*/.
    if  v_num_digito <> integer(substring(v_cod_barra_2_aux:screen-value,12,1))
    then do:
        /* D°gito Verificador n∆o Confere ! */
        run pi_messages (input "show",
                         input 6500,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           substring(v_cod_barra_2_aux:screen-value,12,1),v_num_digito)) /*msg_6500*/.
        return no-apply.
    end /* if */.
END. /* ON LEAVE OF v_cod_barra_2_aux IN FRAME f_dlg_01_cod_barras */

ON ENTRY OF v_cod_barra_3 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_3:format in frame f_dlg_01_cod_barras = "99999.999999":U.
END. /* ON ENTRY OF v_cod_barra_3 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_3 IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_3 = input frame f_dlg_01_cod_barras v_cod_barra_3 no-error.
    if  error-status:get-number(1) <> 0 then do:
        assign v_cod_barra_3:format in frame f_dlg_01_cod_barras = 'x(11)'.
    end.

    if v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras <> "" 
    then do:

        assign v_cod_barra_3 = replace(substring(v_cod_barra_3:screen-value,1,11),".","")
               v_log_abert   = yes.

        run pi_verificar_codigo_barras(input v_cod_barra_3,output v_num_digito).

        if v_num_digito <> integer(substring(v_cod_barra_3:screen-value,12,1))
        then do:
            /* D°gito Verificador n∆o Confere ! */
            run pi_messages (input "show",
                             input 6500,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               substring(v_cod_barra_3:screen-value,12,1),v_num_digito)) /*msg_6500*/.
            assign v_cod_barra_3:format in frame f_dlg_01_cod_barras = '99999.999999'.
            return no-apply.
        end.
    end.

    assign v_cod_barra_3:format in frame f_dlg_01_cod_barras = 'xxxxx.xxxxxx'.
END. /* ON LEAVE OF v_cod_barra_3 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_3_aux IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_3_aux = replace(substring(v_cod_barra_3_aux:screen-value,1,11),".","")
           v_log_abert = yes.
    run pi_verificar_codigo_barras (Input v_cod_barra_3_aux,
                                    output v_num_digito) /*pi_verificar_codigo_barras*/.
    if  v_num_digito <> integer(substring(v_cod_barra_3_aux:screen-value,12,1))
    then do:
        /* D°gito Verificador n∆o Confere ! */
        run pi_messages (input "show",
                         input 6500,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           substring(v_cod_barra_3_aux:screen-value,12,1),v_num_digito)) /*msg_6500*/.
        return no-apply.
    end /* if */.
END. /* ON LEAVE OF v_cod_barra_3_aux IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_4 IN FRAME f_dlg_01_cod_barras
DO:


    if v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras <> "" 
    then do:

        assign v_cod_barra_4 = replace(substring(v_cod_barra_4:screen-value,1,1),".","")
               v_log_abert   = yes.

    end.
    else 
        assign v_cod_barra_4:format in frame f_dlg_01_cod_barras = 'X'.


END. /* ON LEAVE OF v_cod_barra_4 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_4_aux IN FRAME f_dlg_01_cod_barras
DO:

    assign v_cod_barra_4_aux = replace(substring(v_cod_barra_4_aux:screen-value,1,11),".","")
           v_log_abert = yes.
    run pi_verificar_codigo_barras (Input v_cod_barra_4_aux,
                                    output v_num_digito) /*pi_verificar_codigo_barras*/.
    if  v_num_digito <> integer(substring(v_cod_barra_4_aux:screen-value,12,1))
    then do:
        /* D°gito Verificador n∆o Confere ! */
        run pi_messages (input "show",
                         input 6500,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           substring(v_cod_barra_4_aux:screen-value,12,1),v_num_digito)) /*msg_6500*/.
        return no-apply.
    end /* if */.
END. /* ON LEAVE OF v_cod_barra_4_aux IN FRAME f_dlg_01_cod_barras */

ON ENTRY OF v_cod_barra_5 IN FRAME f_dlg_01_cod_barras
DO:

    if v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras = "" then
        assign v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras = '00000000000000'
               v_cod_barra_5:format in frame f_dlg_01_cod_barras = "99999999999999":U.
END. /* ON ENTRY OF v_cod_barra_5 IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_5 IN FRAME f_dlg_01_cod_barras
DO:

    /* Atividade 110696 - 17/02/04.*/
    if v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras <> "" then do:
        /* O campo n∆o pode ser incompleto. Deve ser totalmente preenchido.*/
        if length(v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras) < 14 then do:            
            /* Campo do C¢digo de Barras em branco ou incompleto ! */
            run pi_messages (input "show",
                             input 13154,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13154*/.
            return no-apply.
        end.        
    end.
    else
        assign v_cod_barra_5:format in frame f_dlg_01_cod_barras = 'XXXXXXXXXXXXXX'.

    if  v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras <> ""
    and v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras <> ""
    and v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras <> ""
    and v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras <> ""
    and v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras <> "" then do:
        assign p_cod_barra = replace(substring(v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras,1,11) + 
                                     substring(v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras,1,12) +
                                     substring(v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras,1,12) +
                                     substring(v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras,1,1)  +
                                     substring(v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras,1,v_num_tam_format),'.','').
        run pi_sugerir_numero_bancario (input p_cod_barra, output v_cod_num_bcio).
        disp v_cod_num_bcio with frame f_dlg_01_cod_barras.
    end.

END. /* ON LEAVE OF v_cod_barra_5 IN FRAME f_dlg_01_cod_barras */

ON ENTER OF v_cod_barra_compl IN FRAME f_dlg_01_cod_barras
DO:

    apply 'leave' to v_cod_barra_compl in frame f_dlg_01_cod_barras.

    /* Inserido o c¢digo abaixo para que possa dar foco no bot∆o OK quando for dado enter no 
    campo de leitura. Com o comando v_wgh_focus = bt_ok:handle n∆o funcionou */

    apply 'entry' to bt_ok in frame f_dlg_01_cod_barras.
        return no-apply.
END. /* ON ENTER OF v_cod_barra_compl IN FRAME f_dlg_01_cod_barras */

ON LEAVE OF v_cod_barra_compl IN FRAME f_dlg_01_cod_barras
DO:

    if  v_log_funcao_cod_barra and input frame f_dlg_01_cod_barras v_ind_tit_fatur = "Fatura Cta Consumo" /*l_fatura_cta_consumo*/ 
    then do:
        if  v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras <> ""
        then do:
            run pi_valida_cod_barra (Input v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras) /* pi_valida_cod_barra*/.
            if  return-value <> "OK" /*l_ok*/  
            then do:
                /* C¢digo de Barras inv†lido ! */
                run pi_messages (input "show",
                                 input 10093,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10093*/.
                return no-apply.
            end /* if */.
            run pi_funcao_leave_cod_barra_compl /*pi_funcao_leave_cod_barra_compl*/.
            run pi_sugerir_numero_bancario (input v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,
                                            output v_cod_num_bcio).
            disp v_cod_num_bcio with frame f_dlg_01_cod_barras.
        end /* if */.
    end /* if */.
    else do:
        if v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras <> ""
        then do:
            run pi_valida_cod_barra (Input v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras) /*pi_valida_cod_barra*/.
            if  return-value <> "OK" /*l_ok*/ 
            then do:
                /* C¢digo de Barras inv†lido ! */
                run pi_messages (input "show",
                                 input 10093,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10093*/.
                return no-apply.
            end /* if */.

            /* --- Separa os Campos do C¢digo de Barras Digitado --- */

            assign v_cod_barra_1 = substring(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,1,4) +
                                   substring(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,20,5)
                   v_log_abert   = yes.

            run pi_verificar_codigo_barras(input v_cod_barra_1,output v_num_digito).

            assign v_cod_barra_1 = v_cod_barra_1 + string(v_num_digito)
                   v_cod_barra_2 = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,25,10).

            run pi_verificar_codigo_barras(input v_cod_barra_2,output v_num_digito).

            assign v_cod_barra_2 = string(v_cod_barra_2) + string(v_num_digito)
                   v_cod_barra_3 = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,35,10).

            run pi_verificar_codigo_barras(input v_cod_barra_3,output v_num_digito).

            assign v_cod_barra_3  = string(v_cod_barra_3) + string(v_num_digito)
                   v_cod_barra_4 = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,5, 1)
                   v_cod_barra_5 = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,v_num_tam_format_1, v_num_tam_format).

            disp v_cod_barra_1
                 v_cod_barra_2
                 v_cod_barra_3
                 v_cod_barra_4
                 v_cod_barra_5
                 with frame f_dlg_01_cod_barras.    

            run pi_sugerir_numero_bancario (input v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,
                                            output v_cod_num_bcio).
            disp v_cod_num_bcio with frame f_dlg_01_cod_barras.
        end.
    end /* else */.
END. /* ON LEAVE OF v_cod_barra_compl IN FRAME f_dlg_01_cod_barras */

ON VALUE-CHANGED OF v_ind_tit_fatur IN FRAME f_dlg_01_cod_barras
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_aux_barra_1
        as character
        format "99999.99999":U
        no-undo.
    def var v_cod_aux_barra_2
        as character
        format "99999.999999":U
        no-undo.
    def var v_cod_aux_barra_3
        as character
        format "99999.999999":U
        no-undo.
    def var v_cod_aux_barra_4
        as character
        format "9":U
        no-undo.
    def var v_cod_aux_barra_5
        as character
        format "99999999999999":U
        no-undo.
    def var v_cod_barra_aux_1
        as character
        format "x(12)":U
        no-undo.
    def var v_cod_barra_aux_2
        as character
        format "x(12)":U
        no-undo.
    def var v_cod_barra_aux_3
        as character
        format "x(12)":U
        no-undo.
    def var v_cod_barra_aux_4
        as character
        format "x(12)":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  input frame f_dlg_01_cod_barras v_ind_tit_fatur = "T°tulo" /*l_titulo*/ 
    then do:
        if  v_cod_barra_1_aux <> "" or
            v_cod_barra_2_aux <> "" or
            v_cod_barra_3_aux <> "" or
            v_cod_barra_4_aux <> ""
        then do:
            assign v_cod_barra_aux_1 = input frame f_dlg_01_cod_barras v_cod_barra_1_aux
                   v_cod_barra_aux_2 = input frame f_dlg_01_cod_barras v_cod_barra_2_aux
                   v_cod_barra_aux_3 = input frame f_dlg_01_cod_barras v_cod_barra_3_aux
                   v_cod_barra_aux_4 = input frame f_dlg_01_cod_barras v_cod_barra_4_aux NO-ERROR.
            assign v_cod_barra_1_aux = v_cod_barra_aux_1
                   v_cod_barra_2_aux = v_cod_barra_aux_2
                   v_cod_barra_3_aux = v_cod_barra_aux_3
                   v_cod_barra_4_aux = v_cod_barra_aux_4 NO-ERROR.
        end /* if */.
        assign v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_2_aux:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_3_aux:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_4_aux:screen-value in frame f_dlg_01_cod_barras = "" NO-ERROR.
        disable v_cod_barra_1_aux
                v_cod_barra_2_aux
                v_cod_barra_3_aux
                v_cod_barra_4_aux with frame f_dlg_01_cod_barras.
        display v_cod_barra_1
                v_cod_barra_2
                v_cod_barra_3
                v_cod_barra_4
                v_cod_barra_5 with frame f_dlg_01_cod_barras.
        if  input frame f_dlg_01_cod_barras v_log_leitura_barra = no
        then do:
            enable v_cod_barra_1
                   v_cod_barra_2
                   v_cod_barra_3
                   v_cod_barra_4
                   v_cod_barra_5 with frame f_dlg_01_cod_barras.
        end /* if */.
    end /* if */.
    if  input frame f_dlg_01_cod_barras v_ind_tit_fatur = "Fatura Cta Consumo" /*l_fatura_cta_consumo*/ 
    then do:
        if  v_cod_barra_1 <> "" or
            v_cod_barra_2 <> "" or
            v_cod_barra_3 <> "" or
            v_cod_barra_4 <> "" or
            v_cod_barra_5 <> ""
        then do:
            assign v_cod_aux_barra_1 = input frame f_dlg_01_cod_barras v_cod_barra_1
                   v_cod_aux_barra_2 = input frame f_dlg_01_cod_barras v_cod_barra_2
                   v_cod_aux_barra_3 = input frame f_dlg_01_cod_barras v_cod_barra_3
                   v_cod_aux_barra_4 = input frame f_dlg_01_cod_barras v_cod_barra_4
                   v_cod_aux_barra_5 = input frame f_dlg_01_cod_barras v_cod_barra_5 NO-ERROR.
            assign v_cod_barra_1 = v_cod_aux_barra_1
                   v_cod_barra_2 = v_cod_aux_barra_2
                   v_cod_barra_3 = v_cod_aux_barra_3
                   v_cod_barra_4 = v_cod_aux_barra_4
                   v_cod_barra_5 = v_cod_aux_barra_5 NO-ERROR.
        end /* if */.
        assign v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras = ""
               v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras = "" NO-ERROR.
        disable v_cod_barra_1
                v_cod_barra_2
                v_cod_barra_3
                v_cod_barra_4
                v_cod_barra_5 with frame f_dlg_01_cod_barras.
        display v_cod_barra_1_aux
                v_cod_barra_2_aux
                v_cod_barra_3_aux
                v_cod_barra_4_aux with frame f_dlg_01_cod_barras.
        if  input frame f_dlg_01_cod_barras v_log_leitura_barra = no
        then do:
            enable v_cod_barra_1_aux
                   v_cod_barra_2_aux
                   v_cod_barra_3_aux
                   v_cod_barra_4_aux with frame f_dlg_01_cod_barras.
         end /* if */.
    end /* if */.
END. /* ON VALUE-CHANGED OF v_ind_tit_fatur IN FRAME f_dlg_01_cod_barras */

ON VALUE-CHANGED OF v_log_leitura_barra IN FRAME f_dlg_01_cod_barras
DO:

    if input frame f_dlg_01_cod_barras v_log_leitura_barra = yes
    then do:
        disable v_cod_barra_1
                v_cod_barra_2
                v_cod_barra_3
                v_cod_barra_4
                v_cod_barra_5
                with frame f_dlg_01_cod_barras.
        if  v_log_funcao_cod_barra
        then do:
            disable v_cod_barra_1_aux
                    v_cod_barra_2_aux
                    v_cod_barra_3_aux
                    v_cod_barra_4_aux
                    with frame f_dlg_01_cod_barras.
        end /* if */.
        enable  v_cod_barra_compl with frame f_dlg_01_cod_barras.
        apply "Entry" /*l_entry*/  to v_cod_barra_compl in frame f_dlg_01_cod_barras.
    end.
    else do: 
        if  v_log_funcao_cod_barra
        then do:
            if  input frame f_dlg_01_cod_barras v_ind_tit_fatur = "T°tulo" /*l_titulo*/ 
            then do:
                enable  v_cod_barra_1
                        v_cod_barra_2
                        v_cod_barra_3
                        v_cod_barra_4
                        v_cod_barra_5
                        with frame f_dlg_01_cod_barras.
            end /* if */.
            else do:
                enable  v_cod_barra_1_aux
                        v_cod_barra_2_aux
                        v_cod_barra_3_aux
                        v_cod_barra_4_aux
                        with frame f_dlg_01_cod_barras.
            end /* else */.
        end /* if */.
        else do:
            enable  v_cod_barra_1
                    v_cod_barra_2
                    v_cod_barra_3
                    v_cod_barra_4
                    v_cod_barra_5
                    with frame f_dlg_01_cod_barras.
        end /* else */.
        disable v_cod_barra_compl with frame f_dlg_01_cod_barras.
        apply "Entry" /*l_entry*/  to v_cod_barra_1 in frame f_dlg_01_cod_barras.
    end.
END. /* ON VALUE-CHANGED OF v_log_leitura_barra IN FRAME f_dlg_01_cod_barras */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_01_cod_barras ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_cod_barras */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_cod_barras ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_cod_barras */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_cod_barras ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_cod_barras */

ON WINDOW-CLOSE OF FRAME f_dlg_01_cod_barras
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_cod_barras */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_01_cod_barras.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(frame f_dlg_01_cod_barras:title, 1, max(1, length(frame f_dlg_01_cod_barras:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_codigo_barra_espec":U.




    assign v_nom_prog_ext = "epc/epc002aa.p":U
           v_cod_release  = trim(" 1.00.00.000":U).
    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/.
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('fnc_codigo_barra_espec':U, 'epc/epc002aa.p':U, '1.00.00.000':U, 'pro':U).
end /* if */.
/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_codigo_barra_espec') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_codigo_barra_espec')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_codigo_barra_espec')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_codigo_barra_espec' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_codigo_barra_espec'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */



/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_dlg_01_cod_barras:title = frame f_dlg_01_cod_barras:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.000":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_dlg_01_cod_barras = menu m_help:handle.


/* End_Include: i_std_dialog_box */


pause 0 before-hide.
view frame f_dlg_01_cod_barras.
assign v_log_aux = yes.


/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emscad.histor_exec_especial NO-LOCK
         WHERE emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
           AND emscad.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            SPP      at 1 
            v_log_retorno  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */
    .

    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_funcao_extract */


assign v_log_funcao_cod_barra = &IF DEFINED (BF_FIN_COD_BARRAS_CTA_CONSUMO) &THEN YES 
                                &ELSE GetDefinedFunction('SPP_COD_BARRAS_CTA_CONSUMO':U) &ENDIF.

if  not can-find(first emscad.histor_exec_especial
    where emscad.histor_exec_especial.cod_modul_dtsul = 'UFN'
    and   emscad.histor_exec_especial.cod_prog_dtsul  = 'SPP_alter_codigo_barra') then do transaction:
    create emscad.histor_exec_especial.
    assign emscad.histor_exec_especial.cod_modul_dtsul = 'UFN'
           emscad.histor_exec_especial.cod_prog_dtsul  = 'SPP_alter_codigo_barra'.
end.

/* *******************************************************************
**           ---------- V_COD_BARRA_5 ----------
** v_num_tam_format      -> Tamanho do Campo 12 ou 14 Posiá‰es
** v_cod_format_barra_5  -> Formato NumÇrico do Campo Cfme Acima
** v_num_inicial_barra_5 -> Valor inicial da Substring para o Campo
*********************************************************************/

&if defined(BF_FIN_ALTER_CODIGO_BARRA) &then
    assign v_num_tam_format      = 14
           v_num_tam_format_1    = 6
           v_cod_format_barra_5  = "99999999999999"
           v_num_inicial_barra_5 = 1.
&else
    find first emscad.histor_exec_especial no-lock
         where emscad.histor_exec_especial.cod_modul_dtsul = 'UFN'
         and   emscad.histor_exec_especial.cod_prog_dtsul  = 'SPP_alter_codigo_barra' no-error.
    if   avail emscad.histor_exec_especial then
         assign v_num_tam_format      = 14
                v_num_tam_format_1    = 6
                v_cod_format_barra_5  = "99999999999999"
                v_num_inicial_barra_5 = 1.
    else assign v_num_tam_format      = 12
                v_num_tam_format_1    = 8
                v_cod_format_barra_5  = "999999999999"
                v_num_inicial_barra_5 = 1.
&endif


assign v_cod_barra_4:width-chars in frame f_dlg_01_cod_barras = 2.
       v_log_leitura_barra = yes.
disp v_log_leitura_barra with frame f_dlg_01_cod_barras.

assign v_cod_num_bcio = p_cod_num_bcio.

display v_cod_num_bcio with frame f_dlg_01_cod_barras.

enable v_log_leitura_barra
       v_cod_num_bcio
       bt_ok
       bt_can
       bt_hel2 with frame f_dlg_01_cod_barras.

apply "value-changed" to v_log_leitura_barra in frame f_dlg_01_cod_barras.

/* --- Decomp‰e o parÉmetro recebido e nos campos 1,2,3,4,5 --- */
if p_cod_barra <> ""
then do:

    if  v_log_funcao_cod_barra = no
    then do:
        assign v_cod_barra_1 = substring(p_cod_barra,1,10)
               v_cod_barra_2 = substring(p_cod_barra,11,11)
               v_cod_barra_3 = substring(p_cod_barra,22,11)
               v_cod_barra_4 = substring(p_cod_barra,33,1)
               v_cod_barra_5 = substring(p_cod_barra,34,v_num_tam_format).

        disp v_cod_barra_1 
             v_cod_barra_2 
             v_cod_barra_3 
             v_cod_barra_4 
             v_cod_barra_5 with frame f_dlg_01_cod_barras. 
    end /* if */.
end.
if  v_log_funcao_cod_barra
then do:
    if  p_cod_barra = ""
    then do:
        assign v_ind_tit_fatur = "T°tulo" /*l_titulo*/ .        
    end /* if */.
    else do:
        if  length(p_cod_barra) >= 48
        then do:
            assign v_ind_tit_fatur = "Fatura Cta Consumo" /*l_fatura_cta_consumo*/ .
            assign v_cod_barra_1_aux = substring(p_cod_barra,1,12)
                   v_cod_barra_2_aux = substring(p_cod_barra,13,24)
                   v_cod_barra_3_aux = substring(p_cod_barra,25,36)
                   v_cod_barra_4_aux = substring(p_cod_barra,37,v_num_tam_format).
            disp v_cod_barra_1_aux 
                 v_cod_barra_2_aux
                 v_cod_barra_3_aux
                 v_cod_barra_4_aux with frame f_dlg_01_cod_barras.
        end /* if */.
        else do:
            assign v_ind_tit_fatur = "T°tulo" /*l_titulo*/ .
            assign v_cod_barra_1 = substring(p_cod_barra,1,10)
                   v_cod_barra_2 = substring(p_cod_barra,11,11)
                   v_cod_barra_3 = substring(p_cod_barra,22,11)
                   v_cod_barra_4 = substring(p_cod_barra,33,1)
                   v_cod_barra_5 = substring(p_cod_barra,34,v_num_tam_format).
            disp v_cod_barra_1 
                 v_cod_barra_2 
                 v_cod_barra_3 
                 v_cod_barra_4 
                 v_cod_barra_5 with frame f_dlg_01_cod_barras.
        end /* else */.
    end /* else */.
    display v_ind_tit_fatur
            with frame f_dlg_01_cod_barras.
    enable v_ind_tit_fatur
           with frame f_dlg_01_cod_barras.
end /* if */.
else do:
    HIDE v_ind_tit_fatur   in frame f_dlg_01_cod_barras
         v_cod_barra_1_aux in frame f_dlg_01_cod_barras
         v_cod_barra_2_aux in frame f_dlg_01_cod_barras
         v_cod_barra_3_aux in frame f_dlg_01_cod_barras
         v_cod_barra_4_aux in frame f_dlg_01_cod_barras.
end /* else */.

/* ------ Fim Decomposiá∆o --------- */

main_block:
do on endkey undo main_block, leave main_block
                on error undo main_block, leave main_block.
    apply "Entry" /*l_entry*/  to v_cod_barra_compl in frame f_dlg_01_cod_barras.

    if  valid-handle(v_wgh_focus)
    then do:
        wait-for go of frame f_dlg_01_cod_barras focus v_wgh_focus. 
    end /* if */.
    else do:
        wait-for go of frame f_dlg_01_cod_barras.
    end /* else */.          
end /* do main_block */.

hide frame f_dlg_01_cod_barras.


/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: bre19127
** Alterado em...........: 16/09/2002 08:55:44
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = p_cod_program 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_codigo_barras
** Descricao.............: pi_verificar_codigo_barras
** Criado por............: bre16616
** Criado em.............: 27/08/1998 16:02:53
** Alterado por..........: bre10545
** Alterado em...........: 17/06/1999 16:13:55
*****************************************************************************/
PROCEDURE pi_verificar_codigo_barras:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_campo
        as character
        format "x(25)"
        no-undo.
    def output param p_num_digito
        as integer
        format "9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* -- C†lculo de Verificaá∆o do Digito Verificador dos campos 1,2,3 -- M¢dulo 10 --*/

    if  v_log_abert = yes then do:
        assign v_num_seq_abrev = 2.
        repeat v_num_cont_aux = length(p_cod_campo) to 1 by -1:
           assign v_num_acum = (v_num_seq_abrev * int(substr(p_cod_campo,v_num_cont_aux,1))).

           if  v_num_acum > 9 then
               assign v_num_acum = (int(substr(string(v_num_acum),1,1)) + int(substr(string(v_num_acum),2,1))).

           assign p_num_digito = p_num_digito + v_num_acum.

           if  v_num_seq_abrev = 1 then 
               assign v_num_seq_abrev = 2.
           else 
               assign v_num_seq_abrev = 1.
        end.

        assign p_num_digito = 10 - (p_num_digito mod 10).

        if  p_num_digito = 10 then 
            assign p_num_digito = 0.
    end.

    /* --------- Fim verificaá∆o ---------

       ----- C†lculo do D°gito Geral  - M¢dulo 11 - ----- */

    if  v_log_abert = no then do:
        assign v_num_seq_abrev = 2.
        repeat v_num_cont_aux = length(p_cod_campo) to 1 by -1:
            assign v_num_acum   = (v_num_seq_abrev * int(substr(p_cod_campo,v_num_cont_aux,1)))
                   p_num_digito = p_num_digito + v_num_acum.

            if  v_num_seq_abrev = 9 then 
                assign v_num_seq_abrev = 2.
            else 
                assign v_num_seq_abrev = v_num_seq_abrev + 1.
        end.
        assign p_num_digito = (p_num_digito mod 11).

        if  p_num_digito >= 2 AND p_num_digito <= 9 then
            assign p_num_digito = 11 - p_num_digito.
        else 
            assign p_num_digito = 1.
    end.

    /* --------- Fim C†lculo D°gito Geral ------------- */
END PROCEDURE. /* pi_verificar_codigo_barras */
/*****************************************************************************
** Procedure Interna.....: pi_valida_cod_barra
** Descricao.............: pi_valida_cod_barra
** Criado por............: bre17230
** Criado em.............: 14/07/2000 16:21:00
** Alterado por..........: bre17230
** Alterado em...........: 14/07/2000 16:51:44
*****************************************************************************/
PROCEDURE pi_valida_cod_barra:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_barra_compl
        as character
        format "x(55)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_barra                      as character       no-undo. /*local*/
    def var v_cod_error                      as character       no-undo. /*local*/
    def var v_cod_valid                      as character       no-undo. /*local*/
    def var v_num_cod_barra                  as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/
    def var v_num_error                      as integer         no-undo. /*local*/
    def var v_num_tot_cod_barra              as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_barra     = p_cod_barra_compl
           v_num_cod_barra = length(v_cod_barra).

    do v_num_cont = 1 to v_num_cod_barra:
        assign v_cod_valid = substr(v_cod_barra,v_num_cont,1).
        if index("0123456789 ",v_cod_valid) = 0 then
             assign v_cod_error = v_cod_error + substr(v_cod_barra,v_num_cont,1).
    end.

    assign v_num_error = length(v_cod_error).

    if  v_num_error > 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_valida_cod_barra */
/*****************************************************************************
** Procedure Interna.....: pi_choose_bt_ok_barras
** Descricao.............: pi_choose_bt_ok_barras
** Criado por............: src370
** Criado em.............: 27/05/2003 09:20:19
** Alterado por..........: fut1210
** Alterado em...........: 04/06/2004 08:27:05
*****************************************************************************/
PROCEDURE pi_choose_bt_ok_barras:

    if  v_log_funcao_cod_barra and input frame f_dlg_01_cod_barras v_ind_tit_fatur = "Fatura Cta Consumo" /*l_fatura_cta_consumo*/ 
    then do:

        if  v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras = ""
          OR v_cod_barra_2_aux:screen-value in frame f_dlg_01_cod_barras = ""
          OR v_cod_barra_3_aux:screen-value in frame f_dlg_01_cod_barras = ""
          OR v_cod_barra_4_aux:screen-value in frame f_dlg_01_cod_barras = ""
        then do:
            /* Campo do C¢digo de Barras em branco ou incompleto ! */
            run pi_messages (input "show",
                             input 13154,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13154*/.
            apply "entry" to v_cod_barra_1_aux in frame f_dlg_01_cod_barras.
            return "NOK" /*l_nok*/ .
        end /* if */.

        assign p_cod_barra = substring(v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras,1,12) + 
                             substring(v_cod_barra_2_aux:screen-value in frame f_dlg_01_cod_barras,1,12) +
                             substring(v_cod_barra_3_aux:screen-value in frame f_dlg_01_cod_barras,1,12) +
                             substring(v_cod_barra_4_aux:screen-value in frame f_dlg_01_cod_barras,1,12).
        assign v_log_abert = yes
               v_cod_campo_livre = substring(v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras,1,3) +
                                   substring(v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras,5,7) +
                                   substring(v_cod_barra_2_aux:screen-value in frame f_dlg_01_cod_barras,1,11) +
                                   substring(v_cod_barra_3_aux:screen-value in frame f_dlg_01_cod_barras,1,11) +
                                   substring(v_cod_barra_4_aux:screen-value in frame f_dlg_01_cod_barras,1,11).
        run pi_verificar_codigo_barras (Input v_cod_campo_livre,
                                        output v_num_digito) /*pi_verificar_codigo_barras*/.

        if  v_num_digito <> integer(integer(substring(v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras,4,1)))
        then do:
            /* D°gito Verificador n∆o Confere ! */
            run pi_messages (input "show",
                             input 6500,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               integer(substring(v_cod_barra_1_aux:screen-value in frame f_dlg_01_cod_barras,4,1)),v_num_digito)) /*msg_6500*/.
            ASSIGN v_cod_barra_compl:SCREEN-VALUE IN FRAME f_dlg_01_cod_barras = v_cod_barra_compl_aux.
            return "NOK" /*l_nok*/  .
        end /* if */.

        if  v_cod_num_bcio:screen-value in frame f_dlg_01_cod_barras = ""  
            AND v_log_aux
        then do:
            ASSIGN v_log_aux = NO.
            /* N∆o foi informado N£mero Banc†rio. */
            run pi_messages (input "show",
                             input 10206,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10206*/.
        end /* if */.
        else do:
            /* Grava o n£mero banc†rio */
            assign p_cod_num_bcio = v_cod_num_bcio:screen-value in frame f_dlg_01_cod_barras.
        end /* else */.
    end /* if */.
    else do:
        if  v_log_funcao_cod_barra
        then do:
            if  v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras = ""
              OR v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras = ""
              OR v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras = ""
              OR v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras = ""
              OR v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras = ""
            then do:
                /* Campo do C¢digo de Barras em branco ou incompleto ! */
                run pi_messages (input "show",
                                 input 13154,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13154*/.
                apply "entry" to v_cod_barra_1_aux in frame f_dlg_01_cod_barras.
                return "NOK" /*l_nok*/  .
            end /* if */.
        end /* if */.

        ASSIGN v_cod_barra_compl_aux = input frame f_dlg_01_cod_barras v_cod_barra_compl
               v_cod_barra_compl:SCREEN-VALUE IN FRAME f_dlg_01_cod_barras = "".

        IF input frame f_dlg_01_cod_barras v_cod_barra_compl   = "" then do:

            assign v_log_abert        = no
                   v_cod_campo_livre  = substring(v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras,1,4)  + 
                                        substring(v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras,1,v_num_tam_format) + 
                                        replace(substring(v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras,5,6),'.','')  +
                                        replace(substring(v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras,1,11),'.','') + 
                                        replace(substring(v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras,1,11),'.','').

            /* Se for deixado em branco o campo, n∆o validar d°gito.*/
            if v_cod_campo_livre <> "" then do:
                run pi_verificar_codigo_barras (Input v_cod_campo_livre,
                                                output v_num_digito) /*pi_verificar_codigo_barras*/.

                if  v_num_digito <> integer(v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras) then do:
                    /* D°gito Verificador n∆o Confere ! */
                    run pi_messages (input "show",
                                     input 6500,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                       v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras,v_num_digito)) /*msg_6500*/.
                    apply 'entry' to v_cod_barra_4 in frame f_dlg_01_cod_barras. 
                    ASSIGN v_cod_barra_compl:SCREEN-VALUE IN FRAME f_dlg_01_cod_barras = v_cod_barra_compl_aux.
                    return "NOK" /*l_nok*/ .
                end.
            end.
        end.

        /* Atividade 110696 - 17/02/04.*/
        /* Se o £ltimo campo, que Ç o de valor, for deixado em branco, emitir mensagem de erro e n∆o deixar prosseguir.*/
        if v_log_leitura_barra:screen-value in frame f_dlg_01_cod_barras = "N∆o" /*l_nao*/  then do:
            if  v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras <> ""
            and v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras <> ""
            and v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras <> ""
            and v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras <> ""
            and v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras = "" then do:
                /* Campo do C¢digo de Barras em branco ou incompleto ! */
                run pi_messages (input "show",
                                 input 13154,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13154*/.
                apply "Entry" /*l_entry*/  to v_cod_barra_5 in frame f_dlg_01_cod_barras.
                return "NOK" /*l_nok*/ .
            end.
        end.

        if  v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras <> ""
        and v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras <> ""
        and v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras <> ""
        and v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras <> ""
        and v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras <> "" then do:
                assign p_cod_barra = replace(substring(v_cod_barra_1:screen-value in frame f_dlg_01_cod_barras,1,11) + 
                                             substring(v_cod_barra_2:screen-value in frame f_dlg_01_cod_barras,1,12) +
                                             substring(v_cod_barra_3:screen-value in frame f_dlg_01_cod_barras,1,12) +
                                             substring(v_cod_barra_4:screen-value in frame f_dlg_01_cod_barras,1,1)  +
                                             substring(v_cod_barra_5:screen-value in frame f_dlg_01_cod_barras,1,v_num_tam_format),'.','').
            /* end.*/

            if  v_cod_num_bcio:screen-value in frame f_dlg_01_cod_barras = ""  
                AND v_log_aux
            then do:
                ASSIGN v_log_aux = NO.
                /* N∆o foi informado N£mero Banc†rio. */
                run pi_messages (input "show",
                                 input 10206,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10206*/.
            end /* if */.
            else do:
                /* Grava o n£mero banc†rio */
                assign p_cod_num_bcio = v_cod_num_bcio:screen-value in frame f_dlg_01_cod_barras.
            end /* else */.
        end.
        else do:
            if  v_cod_num_bcio:screen-value in frame f_dlg_01_cod_barras <> ""
            then do:
                /* N£mero Banc†rio inv†lido ! */
                run pi_messages (input "show",
                                 input 10091,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10091*/.
                apply "entry" to v_cod_num_bcio in frame f_dlg_01_cod_barras.
                ASSIGN v_cod_barra_compl:SCREEN-VALUE IN FRAME f_dlg_01_cod_barras = v_cod_barra_compl_aux.
                return "NOK" /*l_nok*/ .
            end /* if */.
            assign p_cod_num_bcio = input frame f_dlg_01_cod_barras v_cod_num_bcio
                   p_cod_barra = "".
        end.
    end /* else */.
END PROCEDURE. /* pi_choose_bt_ok_barras */
/*****************************************************************************
** Procedure Interna.....: pi_funcao_leave_cod_barra_compl
** Descricao.............: pi_funcao_leave_cod_barra_compl
** Criado por............: its0098
** Criado em.............: 19/04/2004 11:01:36
** Alterado por..........: its0098
** Alterado em...........: 22/04/2004 10:27:33
*****************************************************************************/
PROCEDURE pi_funcao_leave_cod_barra_compl:

    /* --- Separa os Campos do C¢digo de Barras Digitado --- */

    assign v_cod_barra_1_aux = substring(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,1,11)
           v_log_abert   = yes.

    run pi_verificar_codigo_barras(input v_cod_barra_1_aux,output v_num_digito).

    assign v_cod_barra_1_aux = v_cod_barra_1_aux + string(v_num_digito)
           v_cod_barra_2_aux = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,12,11).

    run pi_verificar_codigo_barras(input v_cod_barra_2_aux,output v_num_digito).

    assign v_cod_barra_2_aux = string(v_cod_barra_2_aux) + string(v_num_digito)
           v_cod_barra_3_aux = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,23,11).

    run pi_verificar_codigo_barras(input v_cod_barra_3_aux,output v_num_digito).

    assign v_cod_barra_3_aux = string(v_cod_barra_3_aux) + string(v_num_digito)
           v_cod_barra_4_aux = substr(v_cod_barra_compl:screen-value in frame f_dlg_01_cod_barras,34,v_num_tam_format).

    run pi_verificar_codigo_barras(input v_cod_barra_4_aux,output v_num_digito).

    assign v_cod_barra_4_aux = string(v_cod_barra_4_aux) + string(v_num_digito).

    disp v_cod_barra_1_aux
         v_cod_barra_2_aux
         v_cod_barra_3_aux
         v_cod_barra_4_aux
         with frame f_dlg_01_cod_barras.
END PROCEDURE. /* pi_funcao_leave_cod_barra_compl */
/*****************************************************************************
** Procedure Interna.....: pi_sugerir_numero_bancario
** Descricao.............: pi_sugerir_numero_bancario
** Criado por............: fut12237
** Criado em.............: 20/10/2004
** Alterado por..........: fut12237
** Alterado em...........: 20/10/2004
*****************************************************************************/
PROCEDURE pi_sugerir_numero_bancario:

    /************************ Parameter Definition Begin ************************/

    def input param p_cod_barra_compl
        as character
        format "x(55)"
        no-undo.

    def output param p_cod_num_bancario
        as character
        format "x(20)"
        no-undo.

    /************************* Parameter Definition End *************************/
    
    /************************* Variable Definition Begin ************************/

    def var v_num_pos                        as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/

    /************************** Variable Definition End *************************/

    find ext_banco 
        where ext_banco.cod_sist_nac_bcio = substring(p_cod_barra_compl,1,3)
        no-lock no-error.
    if  avail ext_banco then
        do  v_num_cont = 1 to 2:
            if  ext_banco.num_pos_ini_cod_tit_bco[v_num_cont] > 0
            and ext_banco.num_pos_fin_cod_tit_bco[v_num_cont] > 0 then
            do  v_num_pos = ext_banco.num_pos_ini_cod_tit_bco[v_num_cont] to ext_banco.num_pos_fin_cod_tit_bco[v_num_cont]:
                assign p_cod_num_bancario = p_cod_num_bancario + substr(p_cod_barra_compl,v_num_pos,1).
            end.
        end.
    else
        assign p_cod_num_bancario = "".

END PROCEDURE. /* pi_sugerir_numero_bancario */


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
/***********************  End of fnc_codigo_barra_espec **********************/
