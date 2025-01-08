/*****************************************************************************
** Programa..............: Geraá∆o planilha excel
** Nome Externo..........: esp/acr/esacr028c.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 10/12/2009
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def shared var v_cod_arq_modul
    as character
    format "x(8)":U
    no-undo.
def shared var v_cod_arq_planilha
    as character
    format "x(100)":U
    label "Arq Planilha"
    column-label "Arq Planilha"
    no-undo.
def shared var v_cod_carac_lim
    as character
    format "x(1)":U
    initial ";"
    label "Caracter Delimitador"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
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
def shared var v_ind_run_mode
    as character
    format "X(08)":U
    initial "On-Line" /*l_online*/
    no-undo.
def new global shared var v_log_gerac_planilha
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Planilha"
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
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
def shared var v_nom_prog_ext_aux
    as character
    format "x(8)":U
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_cod_arq_planilha_aux           as character       no-undo. /*local*/
def var v_cod_carac_lim_aux              as character       no-undo. /*local*/
def var v_cod_gerac_planilha_aux         as character       no-undo. /*local*/
def var v_log_gerac_planilha_aux         as logical         no-undo. /*local*/
def var v_log_programa                   as logical         no-undo. /*local*/


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

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_gera_planilha
    rt_001
         at row 01.38 col 02.14 bgcolor 8 
    rt_cxcf
         at row 05.79 col 02.00 bgcolor 7 
    v_log_gerac_planilha
         at row 01.63 col 06.00 label "Gerar Arquivo Planilha"
         view-as toggle-box
    v_cod_arq_planilha
         at row 02.92 col 06.00 no-label
         help "Arquivo Sa°da para Planilha Eletrìnica"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_carac_lim
         at row 04.13 col 24.00 colon-aligned label "Caracter Delimitador"
         help "Caracter Delimitador de Colunas"
         view-as fill-in
         size-chars 2.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 06.00 col 03.00 font ?
         help "OK"
    bt_can
         at row 06.00 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 54.72 by 07.63 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Geraá∆o Planilha".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_03_gera_planilha = 10.00
           bt_can:height-chars  in frame f_dlg_03_gera_planilha = 01.00
           bt_ok:width-chars    in frame f_dlg_03_gera_planilha = 10.00
           bt_ok:height-chars   in frame f_dlg_03_gera_planilha = 01.00
           rt_001:width-chars   in frame f_dlg_03_gera_planilha = 51.14
           rt_001:height-chars  in frame f_dlg_03_gera_planilha = 04.21
           rt_cxcf:width-chars  in frame f_dlg_03_gera_planilha = 51.29
           rt_cxcf:height-chars in frame f_dlg_03_gera_planilha = 01.42.
    /* set private-data for the help system */
    assign v_log_gerac_planilha:private-data in frame f_dlg_03_gera_planilha = "HLP=000016907":U
           v_cod_arq_planilha:private-data   in frame f_dlg_03_gera_planilha = "HLP=000016908":U
           v_cod_carac_lim:private-data      in frame f_dlg_03_gera_planilha = "HLP=000016909":U
           bt_ok:private-data                in frame f_dlg_03_gera_planilha = "HLP=000010721":U
           bt_can:private-data               in frame f_dlg_03_gera_planilha = "HLP=000011050":U
           frame f_dlg_03_gera_planilha:private-data                         = "HLP=000000000".

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_can IN FRAME f_dlg_03_gera_planilha
DO:

    assign v_log_gerac_planilha = v_log_gerac_planilha_aux
           v_cod_arq_planilha   = v_cod_arq_planilha_aux
           v_cod_carac_lim      = v_cod_carac_lim_aux.
END. /* ON CHOOSE OF bt_can IN FRAME f_dlg_03_gera_planilha */

ON CHOOSE OF bt_ok IN FRAME f_dlg_03_gera_planilha
DO:

    /* --- Validar Arquivo p/ Planilha ---*/
    assign input frame f_dlg_03_gera_planilha v_log_gerac_planilha v_cod_arq_planilha.
    assign v_cod_arq_planilha = replace(input frame f_dlg_03_gera_planilha v_cod_arq_planilha, "~\", "~/").

    if  v_log_gerac_planilha = yes
    then do:
        run pi_filename_validation (Input v_cod_arq_planilha) /*pi_filename_validation*/.
        if  return-value = "NOK" /*l_nok*/ 
        then do:
             /* Nome do arquivo incorreto ! */
             /* Nome do arquivo incorreto ! */
             run pi_messages (input "show",
                              input 1064,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
             return no-apply.
        end /* if */.

        if  v_ind_run_mode <> "Batch" /*l_batch*/ 
        then do:
            if index(v_cod_Arq_planilha,'~\') <> 0 then
                assign file-info:file-name = substring(v_cod_arq_planilha ,1,r-index(v_cod_arq_planilha,'~\') - 1).
            else
               assign file-info:file-name = substring(v_cod_arq_planilha,1,r-index(v_cod_arq_planilha,'~/') - 1).
            if  (file-info:file-type = ?) and (index(v_cod_arq_planilha,'~\') <> 0 or 
               index(v_cod_arq_planilha,'/') <> 0 or index(v_cod_arq_planilha ,':') <> 0)
            then do:
                /* O diret¢rio &1 n∆o existe ! */
                run pi_messages (input "show",
                                 input 4354,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                   file-info:file-name)) /*msg_4354*/.
                return no-apply.
            end /* if */.
        end /* if */.
        else do:
            assign v_cod_arq_planilha_aux = replace(v_cod_arq_planilha,"~\","~/").
            if  index(v_cod_arq_planilha_aux,":") <> 0
            then do:
                /* Nome de arquivo com problemas. */
                run pi_messages (input "show",
                                 input 1979,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                return no-apply.
            end /* if */.

            file_1:
            do while index(v_cod_arq_planilha_aux,"~/") <> 0:
                assign v_cod_arq_planilha_aux = substring(v_cod_arq_planilha_aux,(index(v_cod_arq_planilha_aux,"~/" ) + 1)).
            end /* do file_1 */.

            /* valname: */
            case num-entries(v_cod_arq_planilha_aux,"."):
                when 1 then
                   if  length(v_cod_arq_planilha_aux) > 8
                   then do:
                       /* Nome de arquivo com problemas. */
                       run pi_messages (input "show",
                                        input 1979,
                                        input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                       return no-apply.
                   end /* if */.
                when 2 then
                   if  length(entry(1,v_cod_arq_planilha_aux,".")) > 8 or length(entry(2,v_cod_arq_planilha_aux,".")) > 3
                   then do:
                       /* Nome de arquivo com problemas. */
                       run pi_messages (input "show",
                                        input 1979,
                                        input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                       return no-apply.
                   end /* if */.
                otherwise other:
                          do:
                    /* Nome de arquivo com problemas. */
                    run pi_messages (input "show",
                                     input 1979,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                    return no-apply.
                end /* do other */.
            end /* case valname */.
        end /* else */.

       /* --- Validar Caracter Delimitador ---*/
        if  input frame f_dlg_03_gera_planilha v_cod_carac_lim = "" and v_log_gerac_planilha
        then do:
            assign v_wgh_focus = v_cod_carac_lim:handle in frame f_dlg_03_gera_planilha.
            /* &1 n∆o pode ser igual a branco ! */
            run pi_messages (input "show",
                             input 3703,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "O Caracter Delimitador" /*l_caracter_delimitador*/)) /*msg_3703*/.
            return no-apply.
        end /* if */.
        assign input frame f_dlg_03_gera_planilha v_cod_carac_lim.
    end /* if */.
    assign v_cod_arq_planilha_aux = v_cod_arq_planilha.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_03_gera_planilha */

ON VALUE-CHANGED OF v_log_gerac_planilha IN FRAME f_dlg_03_gera_planilha
DO:

    if  input frame f_dlg_03_gera_planilha v_log_gerac_planilha then do:
        if  v_cod_arq_planilha = "" then do:
            assign v_cod_arq_planilha = v_cod_arq_modul
                   v_cod_carac_lim    = ";".
        end /* if */.

        enable v_cod_arq_planilha
               v_cod_carac_lim
               with frame f_dlg_03_gera_planilha.
    end /* if */.
    else do:
        assign v_cod_arq_planilha = ""
               v_cod_carac_lim    = "".
        disable v_cod_arq_planilha
                v_cod_carac_lim
                with frame f_dlg_03_gera_planilha.
    end /* else */.
    display v_cod_arq_planilha
            v_cod_carac_lim
            with frame f_dlg_03_gera_planilha.
END. /* ON VALUE-CHANGED OF v_log_gerac_planilha IN FRAME f_dlg_03_gera_planilha */


/************************ User Interface Trigger End ************************/

ON WINDOW-CLOSE OF FRAME f_dlg_03_gera_planilha
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_dlg_03_gera_planilha */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign frame f_dlg_03_gera_planilha:title = frame f_dlg_03_gera_planilha:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.001":U)
                            + chr(41).

pause 0 before-hide.
view frame f_dlg_03_gera_planilha.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.
    assign v_cod_carac_lim:width in frame f_dlg_03_gera_planilha = 2.22.
    assign v_log_gerac_planilha_aux = v_log_gerac_planilha
           v_cod_arq_planilha_aux   = v_cod_arq_planilha
           v_cod_carac_lim_aux      = v_cod_carac_lim
           v_wgh_focus = v_log_gerac_planilha:handle in frame f_dlg_03_gera_planilha.

    pause 0 before-hide.
    display bt_can
            bt_ok
            v_cod_arq_planilha
            v_cod_carac_lim
            v_log_gerac_planilha
            with frame f_dlg_03_gera_planilha.

    enable all with frame f_dlg_03_gera_planilha.

    apply "value-changed" to v_log_gerac_planilha in frame f_dlg_03_gera_planilha.

    planilha_block:
    do on endkey undo planilha_block, leave planilha_block on error undo planilha_block, retry planilha_block.
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_03_gera_planilha focus v_wgh_focus.
        end /* if */.
        else do:
            wait-for go of frame f_dlg_03_gera_planilha focus bt_ok.
        end /* else */.
    end /* do planilha_block */.
    assign v_wgh_focus = ?.
    hide frame f_dlg_03_gera_planilha.
end /* do main_block */.


hide frame f_dlg_03_gera_planilha.

return.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: tech35592
** Alterado em...........: 14/02/2006 07:39:05
*****************************************************************************/
PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_filename
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "."
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0
        then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_filename_validation */
/************************** Internal Procedure End **************************/

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
/*************************  End of fnc_info_planilha ************************/
