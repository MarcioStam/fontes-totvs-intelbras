/****************************************************************************
**
** Descricao ........: Importaá∆o de planilha de Fundo Fixo e Verbas para 
**                     geraá∆o de t°tulos no Contas a Pagar
**
** Nome Externo .....: esp/apb/esapb033.p
**
** Criado por .......: Andrey Mauricio de Oliveira
**
** Criado em ........: 19/12/2017
**
*****************************************************************************/


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/


/************************** Window Definition Begin *************************/
def var wh_w_program as WIDGET-HANDLE no-undo.

IF session:window-system <> "TTY" THEN DO:
    create window wh_w_program
    assign row                  = 01.00
           col                  = 01.00
           height-chars         = 01.00
           width-chars          = 01.00
           min-width-chars      = 01.00
           min-height-chars     = 01.00
           max-width-chars      = 01.00
           max-height-chars     = 01.00
           virtual-width-chars  = 300.00
           virtual-height-chars = 200.00
           title                = "Program"
           resize               = yes
           scroll-bars          = no
           status-area          = yes
           status-area-font     = ?
           message-area         = no
           message-area-font    = ?
           fgcolor              = ?
           bgcolor              = ?.
END.
/*************************** Window Definition End **************************/


/************************* Variable Definition Begin ************************/
def new global shared var v_cod_aplicat_dtsul_corren as CHARACTER format "x(3)":U no-undo.
def new global shared var v_cod_ccusto_corren        as CHARACTER format "x(11)":U label "Centro Custo" column-label "Centro Custo" no-undo.
def new global shared var v_cod_dwb_user             as CHARACTER format "x(21)":U label "Usu†rio" column-label "Usu†rio" no-undo.
def new global shared var v_cod_empres_usuar         as CHARACTER format "x(3)":U label "Empresa" column-label "Empresa" no-undo.
def new global shared var v_cod_estab_usuar          as CHARACTER format "x(3)":U label "Estabelecimento" column-label "Estab" no-undo.
def new global shared var v_cod_funcao_negoc_empres  as CHARACTER format "x(50)":U no-undo. 
def new global shared var v_cod_grp_usuar_lst        as CHARACTER format "x(3)":U label "Grupo Usu†rios" column-label "Grupo" no-undo.
def new global shared var v_cod_idiom_usuar          as CHARACTER format "x(8)":U label "Idioma" column-label "Idioma" no-undo. 
def new global shared var v_cod_modul_dtsul_corren   as CHARACTER format "x(3)":U label "M¢dulo Corrente" column-label "M¢dulo Corrente" no-undo.
def new global shared var v_cod_modul_dtsul_empres   as CHARACTER format "x(100)":U no-undo. 
def new global shared var v_cod_pais_empres_usuar    as CHARACTER format "x(3)":U label "Pa°s Empresa Usu†rio" column-label "Pa°s" no-undo.
def new global shared var v_cod_plano_ccusto_corren  as CHARACTER format "x(8)":U label "Plano CCusto" column-label "Plano CCusto" no-undo.
def new global shared var v_cod_unid_negoc_usuar     as CHARACTER format "x(3)":U view-as COMBO-BOX list-items "" inner-lines 5 bgcolor 15 font 2 label "Unidade Neg¢cio" column-label "Unid Neg¢cio" no-undo.
def new global shared var v_cod_usuar_corren         as CHARACTER format "x(12)":U label "Usu†rio Corrente" column-label "Usu†rio Corrente" no-undo.
def new global shared var v_cod_usuar_corren_criptog as CHARACTER format "x(16)":U no-undo. 
def new global shared var v_log_historico            as LOGICAL format "Sim/N∆o" initial NO view-as TOGGLE-BOX label "Hist¢rico" column-label "Hist¢rico" no-undo.

def new global shared var v_arq_import_esapb033    as CHARACTER format "x(80)":U view-as editor max-chars 250 NO-WORD-WRAP size 40 by .88 bgcolor 15 font 2 label "Nome Arquivo" column-label "Arquivo" no-undo.
def new global shared var v_dat_transacao_esapb033 as DATE format "99/99/9999":U view-as FILL-IN size 13 by .88 bgcolor 15 font 2 label "Data Transaá∆o" column-label "Dt Transaá∆o" no-undo.
def new global shared var rs_tipo_exec_esapb033             AS INTEGER INITIAL 2 LABEL "Tipo Execuá∆o" COLUMN-LABEL "Tp Exec"
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS "Fundo Fixo", 1,
                   "Verbas/PF", 2,
                   "Exportaá∆o", 3
     SIZE 20 BY 2.00 NO-UNDO.

def var v_nom_name      as CHARACTER format "x(20)":U extent 10 no-undo. 
def var v_nom_title     as CHARACTER format "x(40)":U no-undo. 
def var v_nom_title_aux as CHARACTER format "x(60)":U no-undo.
def var v_wgh_focus     as WIDGET-HANDLE format ">>>>>>9":U no-undo.
def var v_nom_filename  as CHARACTER format "x(80)":U view-as editor max-chars 250 NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 label "Nome Arquivo" no-undo.
def var v_des_filespec  as CHARACTER format "x(10)":U extent 10 no-undo. 
def var v_log_answer    as LOGICAL format "Sim/N∆o" initial YES view-as TOGGLE-BOX no-undo.

/************************** Variable Definition End *************************/


/*************************** Menu Definition Begin **************************/
def sub-menu  mi_table
    menu-item mi_run               label "Execuá∆o".
    rule
    menu-item mi_exi               label "Sa°da".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Menu".
/**************************** Menu Definition End ***************************/


/************************ Rectangle Definition Begin ************************/
def rectangle rt_mold size 1 by 1 edge-pixels 2.
def rectangle rt_rgf  size 1 by 1 edge-pixels 2.
/************************* Rectangle Definition End *************************/


/************************** Button Definition Begin *************************/
def button bt_exi              label "Sa°da" tooltip "Sa°da"            image-up file "image/im-exi"  image-insensitive file "image/ii-exi"  size 1 by 1.
def button bt_rnl1             label "Exc"   tooltip "Executar Lista"   image-up file "image/im-rnl"  image-insensitive file "image/ii-rnl"  size 1 by 1.
def button bt_get_file2_264936 label "Get"   tooltip "Encontra Arquivo" image-up file "image/im-sea2" image-insensitive file "image/ii-sea2" size 4 by 1.
/*************************** Button Definition End **************************/


/************************** Frame Definition Begin **************************/
def frame f_bas_importa_APB
    rt_rgf  at row 01.00 col 01.00 bgcolor 7 
    rt_mold at row 02.50 col 02.00
    bt_rnl1 at row 01.08 col 02.14 font ? help "Executar Lista"
    bt_exi  at row 01.10 col 76.34 font ? help "Sa°da"
    v_arq_import_esapb033 at row 02.80 col 18.00 colon-aligned label "Nome Arquivo" help "Arquivo com os dados para importaá∆o" view-as editor max-chars 250 no-word-wrap size 46 by .88 bgcolor 15 font 2
    bt_get_file2_264936 at row 02.75 col 66.10 help "Buscar Arquivo"
    v_dat_transacao_esapb033 at row 03.80 col 18.00 colon-aligned help "Data de transaá∆o utilizada para geraá∆o dos movimentos"
    rs_tipo_exec_esapb033 AT ROW 3.80 COL 50 COLON-ALIGNED HELP "Informar qual o tipo de execuá∆o"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 06.29
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Geraá∆o T°tulos Contas a Pagar - ESAPB033 - ".

    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_importa_APB = 04.00
           bt_exi:height-chars    in frame f_bas_importa_APB = 01.13
           bt_rnl1:width-chars    in frame f_bas_importa_APB = 04.00
           bt_rnl1:height-chars   in frame f_bas_importa_APB = 01.13
           rt_mold:width-chars    in frame f_bas_importa_APB = 78.44
           rt_mold:height-chars   in frame f_bas_importa_APB = 03.50
           rt_rgf:width-chars     in frame f_bas_importa_APB = 80.44
           rt_rgf:height-chars    in frame f_bas_importa_APB = 01.29.
    /* set return-inserted = yes for editors */
    assign v_arq_import_esapb033:return-inserted in frame f_bas_importa_APB = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_importa_APB = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_importa_APB = "HLP=000004665":U
           bt_get_file2_264936:private-data      in frame f_bas_importa_APB = "HLP=000023693":U
           v_arq_import_esapb033:private-data    in frame f_bas_importa_APB = "HLP=000017147":U
           frame f_bas_importa_APB:private-data                             = "HLP=000023693".
    /* enable function buttons */
    assign bt_get_file2_264936:sensitive in frame f_bas_importa_APB = yes.
/*************************** Frame Definition End ***************************/


/*********************** User Interface Trigger Begin ***********************/
ON  CHOOSE OF bt_exi IN FRAME f_bas_importa_APB
OR  CHOOSE OF MENU-ITEM mi_exi IN MENU m_10 DO:
    run pi_close_program.
END.

ON  CHOOSE OF bt_rnl1 IN FRAME f_bas_importa_APB
OR  CHOOSE OF MENU-ITEM mi_run IN MENU m_10 DO:
    assign v_arq_import_esapb033   
           v_dat_transacao_esapb033
           rs_tipo_exec_esapb033.   

    if  v_arq_import_esapb033    = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Arquivo de importaá∆o n∆o pode ficar em branco.":U +
                                 "~~":U +
                                 "Informe um <caminho>/<arquivo> v†lido para importaá∆o.":U).
        APPLY "ENTRY":U TO v_arq_import_esapb033 IN FRAME f_bas_importa_APB.
        RETURN NO-APPLY.
    END.
    
    IF  v_dat_transacao_esapb033 = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Data de Transaá∆o n∆o pode ficar em branco.":U +
                                 "~~":U +
                                 "Informe uma data v†lida para criaá∆o dos movimentos.":U).
        APPLY "ENTRY":U TO v_dat_transacao_esapb033 IN FRAME f_bas_importa_APB.
        RETURN NO-APPLY.
    END.

    run esp/apb/esapb033rp.p.
END.
/************************ User Interface Trigger End ************************/


/************************** Function Trigger Begin **************************/
ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_importa_APB
OR F5 OF v_arq_import_esapb033 IN FRAME f_bas_importa_APB 
OR MOUSE-SELECT-DBLCLICK OF v_arq_import_esapb033 IN FRAME f_bas_importa_APB DO:
    /************************* Variable Definition Begin ************************/
    def var v_cod_get_file                   as character       no-undo. /*local*/
    def var v_log_pressed                    as logical         no-undo. /*local*/
    /************************** Variable Definition End *************************/

    system-dialog get-file v_cod_get_file
        title "Procurando..." /*l_procurando...*/ 
        filters '*.csv' '*.csv'
        must-exist
        update v_log_pressed.

    if  v_log_pressed = yes then do:
        assign v_arq_import_esapb033:screen-value in frame f_bas_importa_APB = v_cod_get_file.
        apply "entry" to v_arq_import_esapb033 in frame f_bas_importa_APB.
    end /* if */.
end. /* ON  CHOOSE OF bt_get_file2_264936 IN FRAME f_bas_importa_APB */
/*************************** Function Trigger End ***************************/


/**************************** Frame Trigger Begin ***************************/
ON END-ERROR OF FRAME f_bas_importa_APB DO:
    run pi_close_program.
END.
/**************************** Frame Trigger End *****************************/

/*************************** Window Trigger Begin ***************************/
ON WINDOW-CLOSE OF wh_w_program DO:
    apply "choose" to bt_exi in frame f_bas_importa_APB.
END.
/**************************** Window Trigger End ****************************/


/****************************** Main Code Begin *****************************/
assign wh_w_program:title         = frame f_bas_importa_APB:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_importa_APB:title       = ?
       wh_w_program:width-chars   = frame f_bas_importa_APB:width-chars
       wh_w_program:height-chars  = frame f_bas_importa_APB:height-chars - 0.85
       frame f_bas_importa_APB:row         = 1
       frame f_bas_importa_APB:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_importa_APB:handle).

pause 0 before-hide.

view frame f_bas_importa_APB.

ASSIGN v_dat_transacao_esapb033 = TODAY.

disp v_arq_import_esapb033
     v_dat_transacao_esapb033
     with frame f_bas_importa_APB.

enable bt_rnl1
       bt_exi
       v_arq_import_esapb033
       v_dat_transacao_esapb033
       rs_tipo_exec_esapb033
       with frame f_bas_importa_APB.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_arq_import_esapb033:read-only    in frame f_bas_importa_APB = no
           v_dat_transacao_esapb033:read-only in frame f_bas_importa_APB = NO.

    if  this-procedure:persistent = no then do:
        wait-for choose of bt_exi in frame f_bas_importa_APB
              OR CHOOSE OF MENU-ITEM mi_exi IN MENU m_10.
    end.
end.
/******************************* Main Code End ******************************/


/************************* Internal Procedure Begin *************************/
PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = YES then do:
        delete procedure this-procedure.
    end.

END PROCEDURE. /* pi_close_program */


PROCEDURE pi_frame_settings:
    /************************ Parameter Definition Begin ************************/
    def Input param p_wgh_frame as WIDGET-HANDLE format ">>>>>>9" no-undo.
    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/
    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/
    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.
END PROCEDURE. /* pi_frame_settings */


PROCEDURE pi_filename_validation:
    /************************ Parameter Definition Begin ************************/
    def Input param p_cod_filename as CHARACTER format "x(40)" no-undo.
    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/
    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/
    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "." then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0 then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(v_cod_1, "~/~/") > 0 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = "" then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0 then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
            if  length(v_cod_2) > 8 then do:
                return "NOK" /*l_nok*/ .
            end /* if */.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).
    if  length(v_cod_2) > 8 then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE.


PROCEDURE pi_system_dialog_get_file:
    system-dialog get-file v_nom_filename
        title v_nom_title
        filters v_nom_name[1]  v_des_filespec[1] ,
                v_nom_name[2]  v_des_filespec[2] ,
                v_nom_name[3]  v_des_filespec[3] ,
                v_nom_name[4]  v_des_filespec[4] ,
                v_nom_name[5]  v_des_filespec[5] ,
                v_nom_name[6]  v_des_filespec[6] ,
                v_nom_name[7]  v_des_filespec[7] ,
                v_nom_name[8]  v_des_filespec[8] ,
                v_nom_name[9]  v_des_filespec[9] ,
                v_nom_name[10] v_des_filespec[10]
        must-exist
        initial-dir v_nom_filename
        use-filename
        update v_log_answer.
END PROCEDURE.


PROCEDURE pi_messages:
    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U + string(trunc(i_msg / 1000,0),"99":U) + "/msg":U + string(i_msg, "99999":U).

    if  search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U SKIP "Programa Mensagem" c_prg_msg "n∆o encontrado." view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.
