/****************************************************************************
** Descricao ........: Importaá∆o para geraá∆o de t°tulos no Contas a Pagar
** Nome Externo .....: esp/apb/esapb032rp.p
** Criado por .......: Heron Borba - Sensus
** Criado em ........: 25/01/2017
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/
{esp/es0018.i}

/********************* Temporary Table Definition Begin *********************/
{esp/cms/apb900zg.i} /* Definiá∆o das temp-tables da API de implantaá∆o */

def temp-table tt_file_import no-undo
    field tta_num_line             as Integer   format ">>>,>>>,>>9" initial 0                label "Linha"             column-label "Linha"
    field tta_cod_estab            as character format "x(3)"                                 label "Estabelecimento"   column-label "Estab"
    field tta_cod_evento           as character format "x(40)"                                label "Evento"            column-label "Evento"
    field tta_cdn_fornecedor       as Integer   format ">>>,>>>,>>9" initial 0                label "Fornecedor"        column-label "Fornecedor"
    field tta_cod_cta_ctbl         as character format "x(20)"                                label "Conta Contabil"    column-label "Conta Contabil"
    field tta_cod_tip_fluxo_financ as character format "x(12)"                                label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_ser_docto        as character format "x(3)"                                 label "SÇrie Documento"   column-label "SÇrie"
    field tta_cod_tit_ap           as character format "x(10)"                                label "T°tulo"            column-label "T°tulo"
    field tta_cod_parcela          as character format "x(02)"                                label "Parcela"           column-label "Parc"
    field tta_cod_espec_docto      as character format "x(3)"                                 label "EspÇcie Documento" column-label "EspÇcie"
    field tta_val_tit_ap           as decimal   format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo"      column-label "Valor T°tulo"
    field tta_dat_vencto_tit_ap    as date      format "99/99/9999" initial today             label "Data Vencimento"   column-label "Dt Vencto"
    field tta_cod_ccusto           as char      format "x(11)"                                label "Centro de Custo"   column-label "CCusto".
     
def temp-table tt_relac_erro no-undo
    field tta_cod_refer            as character format "x(50)"    label "Ajuda"  column-label "Ajuda"
    field ttv_num_linha            as integer   format ">>>>,>>9" label "N£mero" column-label "N£mero"
    index tt_refer                    
          tta_cod_refer                    ascending.

/********************** Temporary Table Definition End **********************/

/************************** Stream Definition Begin *************************/
def stream s_1.
/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/
def var v_cod_dwb_file       as CHARACTER format "x(40)":U label "Arquivo" column-label "Arquivo" no-undo.
def var v_cod_release        as CHARACTER format "x(12)":U no-undo. 
def var v_cod_tip_reg        as CHARACTER format "x(03)":U label "Tipo Registro" column-label "Tipo Registro" no-undo.
def var v_dat_execution      as DATE      format "99/99/9999":U no-undo.
def var v_des_filespec       as CHARACTER format "x(10)":U extent 10 no-undo.
def var v_des_mensagem       as CHARACTER format "x(50)":U view-as editor max-chars 2000 SCROLLBAR-VERTICAL size 50 by 4 bgcolor 15 font 2 label "Mensagem" column-label "Mensagem" no-undo.
def var v_des_reg_import     as CHARACTER format "x(40)":U no-undo. 
def var v_hra_execution      as CHARACTER format "99:99":U no-undo. 
def var v_hra_execution_end  as CHARACTER format "99:99:99":U label "Tempo Exec" no-undo.
def var v_ind_message_output as CHARACTER format "X(10)":U initial "Em Arquivo" /*l_on_Screen*/ view-as radio-set HORIZONTAL radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo" bgcolor 8 no-undo.
def var v_log_answer         as LOGICAL   format "Sim/N∆o" initial YES view-as TOGGLE-BOX no-undo.
def var v_log_method         as LOGICAL   format "Sim/N∆o" initial YES no-undo. 
def var v_log_view_file      as LOGICAL   format "Sim/N∆o" initial YES view-as TOGGLE-BOX label "Visualiza Arquivo" column-label "Visualiza Arquivo" no-undo.
def var v_nom_enterprise     as CHARACTER format "x(40)":U no-undo. 
def var v_nom_filename       as CHARACTER format "x(80)":U view-as editor max-chars 250 NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 label "Nome Arquivo" no-undo.
def var v_nom_name           as CHARACTER format "x(20)":U extent 10 no-undo.
def var v_nom_prog_ext       as CHARACTER format "x(8)":U label "Nome Externo" no-undo.
def var v_nom_report_title   as CHARACTER format "x(40)":U no-undo.
def var v_nom_title          as CHARACTER format "x(40)":U no-undo.
def var v_nom_title_aux      as CHARACTER format "x(60)":U no-undo.
def var v_num_line           as INTEGER   format ">>,>>9":U label "Linha" column-label "Linha" no-undo. 
def var v_num_page_number    as INTEGER   format ">>>>>9":U label "P†gina" column-label "P†gina" no-undo. 
def var v_num_seq            as INTEGER   format ">>>,>>9":U label "SeqÅància" column-label "Seq" no-undo. 
def var v_rec_log            as RECID     format ">>>>>>9":U no-undo. 
DEF VAR i-conta-refer        AS INTEGER     NO-UNDO.

def new global shared var v_cod_aplicat_dtsul_corren   as CHARACTER format "x(3)":U no-undo. 
def new global shared var v_cod_ccusto_corren          as CHARACTER format "x(11)":U label "Centro Custo" column-label "Centro Custo" no-undo.
def new global shared var v_cod_dwb_user               as CHARACTER format "x(21)":U label "Usu†rio" column-label "Usu†rio" no-undo.
def new global shared var v_cod_empresa_imp            as CHARACTER format "x(3)":U label "Empresa" column-label "Empresa" no-undo.
def new global shared var v_cod_empres_usuar           as CHARACTER format "x(3)":U label "Empresa" column-label "Empresa" no-undo.
def new global shared var v_cod_estab_usuar            as CHARACTER format "x(3)":U label "Estabelecimento" column-label "Estab" no-undo.
def new global shared var v_cod_funcao_negoc_empres    as CHARACTER format "x(50)":U no-undo. 
def new global shared var v_cod_grp_usuar_lst          as CHARACTER format "x(3)":U label "Grupo Usu†rios" column-label "Grupo" no-undo.
def new global shared var v_cod_idiom_usuar            as CHARACTER format "x(8)":U label "Idioma" column-label "Idioma" no-undo.
def new global shared var v_cod_matriz_trad_pais_ext   as CHARACTER format "x(8)":U label "Matriz Traduá∆o Pa°s" column-label "Matriz Traduá∆o Pa°s" no-undo.
def new global shared var v_cod_matriz_trad_portad_ext as CHARACTER format "x(8)":U label "Matriz Trad Portador" column-label "Matriz Trad Portador" no-undo.
def new global shared var v_cod_modul_dtsul_corren     as CHARACTER format "x(3)":U label "M¢dulo Corrente" column-label "M¢dulo Corrente" no-undo.
def new global shared var v_cod_modul_dtsul_empres     as CHARACTER format "x(100)":U no-undo. 
def new global shared var v_cod_pais_empres_usuar      as CHARACTER format "x(3)":U label "Pa°s Empresa Usu†rio" column-label "Pa°s" no-undo.
def new global shared var v_cod_plano_ccusto_corren    as CHARACTER format "x(8)":U label "Plano CCusto" column-label "Plano CCusto" no-undo.
def new global shared var v_cod_unid_negoc_usuar       as CHARACTER format "x(3)":U view-as COMBO-BOX list-items "" inner-lines 5 bgcolor 15 font 2 label "Unidade Neg¢cio" column-label "Unid Neg¢cio" no-undo.
def new global shared var v_cod_usuar_corren           as CHARACTER format "x(12)":U label "Usu†rio Corrente" column-label "Usu†rio Corrente" no-undo.
def new global shared var v_cod_usuar_corren_criptog   as CHARACTER format "x(16)":U no-undo. 
def new global shared var v_des_program_estrut         as CHARACTER format "x(65)":U label "Estrutura" column-label "Estrutura" no-undo. 
def new global shared var v_log_eai_habilit            as LOGICAL   format "Sim/N∆o" initial NO no-undo.
def new global shared var v_log_historico              as LOGICAL   format "Sim/N∆o" initial NO view-as TOGGLE-BOX label "Hist¢rico" column-label "Hist¢rico" no-undo.
def new global shared var v_log_atualiza_refer_apb
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Atualiza Referància"
    column-label "Atualiza Referància"
    no-undo.

def new global shared var v_arq_import_esapb032    as CHARACTER format "x(80)":U view-as editor max-chars 250 NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 label "Nome Arquivo" column-label "Arquivo" no-undo.
def new global shared var v_dat_transacao_esapb032 as DATE format "99/99/9999":U view-as FILL-IN size 13 by .88 bgcolor 15 font 2 label "Data Transaá∆o" column-label "Dt Transaá∆o" no-undo.
def new global shared var v_val_total_esapb032     as DECIMAL format ">>>>>,>>>,>>9.99":U INITIAL 0 view-as FILL-IN size 18 by .88 bgcolor 15 font 2 label "Valor Total" column-label "Vl Total" no-undo.

def new global shared var v_portador_esapb032     as CHAR FORMAT "x(5)" INITIAL '' view-as FILL-IN size 7 by .88 bgcolor 15 font 2 label "Portador" column-label "Portador" no-undo.
def new global shared var v_unid_negoc_esapb032   as CHAR FORMAT "x(3)" INITIAL '' view-as FILL-IN size 7 by .88 bgcolor 15 font 2 label "Unidade Negocio" column-label "Unidade Negocio" no-undo.
/************************** Variable Definition End *************************/



/************************ Rectangle Definition Begin ************************/
def rectangle rt_001      size 1 by 1 edge-pixels 2.
def rectangle rt_cxcf     size 1 by 1 fgcolor 1 edge-pixels 2.
def rectangle rt_messages size 1 by 1 edge-pixels 2.
def rectangle rt_run      size 1 by 1 edge-pixels 2.
/************************* Rectangle Definition End *************************/



/************************** Button Definition Begin *************************/
def button bt_can      label "Cancela"          tooltip "Cancela" size 1 by 1 auto-endkey.
def button bt_can2     label "Cancela"          tooltip "Cancela" size 1 by 1. 
def button bt_get_file label "Pesquisa Arquivo" tooltip "Pesquisa Arquivo" image-up file "image/im-sea1" image-insensitive file "image/ii-sea1" size 1 by 1.
def button bt_ok       label "OK"               tooltip "OK" size 1 by 1 auto-go.
/*************************** Button Definition End **************************/



/************************** Editor Definition Begin *************************/
def var ed_12x85 as CHARACTER view-as editor scrollbar-horizontal scrollbar-vertical NO-WORD-WRAP size 85 by 12 bgcolor 15 font 2 no-undo.
def var ed_1x40  as CHARACTER view-as editor NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 no-undo.
/*************************** Editor Definition End **************************/



/************************ Radio-Set Definition Begin ************************/
def var rs_ind_message_output as CHARACTER initial "Em Arquivo" view-as radio-set HORIZONTAL radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo" bgcolor 8 no-undo.
def var rs_ind_run_mode       as CHARACTER initial "On-Line"    view-as radio-set HORIZONTAL radio-buttons "On-Line", "On-Line","Batch", "Batch" bgcolor 8 no-undo.
/************************* Radio-Set Definition End *************************/



/************************** Report Definition Begin *************************/
def new shared var v_rpt_s_1_lines   as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 80.
def new shared var v_rpt_s_1_bottom  as integer initial 65.
def new shared var v_rpt_s_1_page    as integer.
def new shared var v_rpt_s_1_name    as character initial "Logs Importaá∆o Geraá∆o T°tulos APB".

def var v_total_a_validar like tt_file_import.tta_val_tit_ap no-undo.
def var v_cod_refer       as char    no-undo.
def var v_hdl_aux         as handle  no-undo.
DEF VAR c-usuario-corrente-atual AS CHAR NO-UNDO.
DEF VAR i-contador AS INTEGER NO-UNDO.

ASSIGN c-usuario-corrente-atual = v_cod_usuar_corren.

def frame f_rpt_s_1_header_period header
    "------------------------------------------------------------" at 1
    "-----" at 61
    "P†gina: " at 67
    (page-number (s_1) + v_rpt_s_1_page) to 80 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 80 format "x(40)" skip
    "--------------------" at 34
    "--------" at 54
    v_dat_execution at 63 format "99/99/9999"
    "-" at 74
    v_hra_execution at 76 format "99:99" skip (1)
    with no-box no-labels width 80 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "------------------------------------------------------------" at 1
    "-----" at 61
    "P†gina: " at 67
    (page-number (s_1) + v_rpt_s_1_page) to 80 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 80 format "x(40)" skip
    "------------------------------------------------------------" at 1
    "-" at 61
    v_dat_execution at 63 format "99/99/9999"
    "-" at 74
    v_hra_execution at 76 format "99:99" skip (1)
    with no-box no-labels width 80 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    skip (1)
    "Èltima p†gina" at 1
    "------------------------------------" at 16
    "-----" at 52
    v_nom_prog_ext at 58 format "x(8)"
    "-" at 67
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    skip (1)
    "------------------------------------------------" at 1
    "---------" at 49
    v_nom_prog_ext at 59 format "x(8)"
    "-" at 68
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    skip (1)
    "P†gina ParÉmetros" at 1
    "---------------------------------------" at 19
    v_nom_prog_ext at 59 format "x(8)"
    "-" at 68
    v_cod_release at 69 format "x(12)" skip
    with no-box no-labels width 80 page-bottom stream-io.
def frame f_rpt_s_1_grp_logs_lay_unico header
    "Linha" to 19
    "Mensagem" at 21 skip
    "------" to 19
    "--------------------------------------------------" at 21 skip
    with no-box no-labels width 80 page-top stream-io.
/*************************** Report Definition End **************************/



/************************** Frame Definition Begin **************************/
def frame f_dlg_02_wait_processing
    rt_001 at row 01.29 col 02.00
    " Processando... " view-as text at row 01.00 col 04.00
    ed_1x40 at row 02.04 col 03.00 help "" no-label
    bt_can2 at row 03.50 col 27.86 font ? help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 65.72 by 05.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "".
    /* adjust size of objects in this frame */
    assign bt_can2:width-chars  in frame f_dlg_02_wait_processing = 10.00
           bt_can2:height-chars in frame f_dlg_02_wait_processing = 01.00
           rt_001:width-chars   in frame f_dlg_02_wait_processing = 62.43
           rt_001:height-chars  in frame f_dlg_02_wait_processing = 01.92.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_dlg_02_wait_processing = yes.
    /* set private-data for the help system */
    assign ed_1x40:private-data in frame f_dlg_02_wait_processing = "HLP=000023694":U
           bt_can2:private-data in frame f_dlg_02_wait_processing = "HLP=000011451":U
           frame f_dlg_02_wait_processing:private-data            = "HLP=000023694".

def frame f_exec_importacao
    rt_messages at row 01.30 col 02.00
    " Mensagens " view-as text at row 01.00 col 04.00
    rt_run at row 05.18 col 02.00
    " Execuá∆o " view-as text at row 04.88 col 04.00
    rt_cxcf at row 07.18 col 02.00 bgcolor 7 
    rs_ind_message_output at row 01.68 col 03.00 help "" no-label
    bt_get_file at row 02.64 col 43.00 font ? help "Pesquisa Arquivo"
    ed_1x40 at row 02.68 col 03.00 help "" no-label
    v_log_view_file at row 03.80 col 03.00 label "Visualiza Arquivo" help "Visualiza Arquivo" view-as toggle-box
    rs_ind_run_mode at row 05.68 col 03.00 help "" no-label
    bt_ok at row 07.38 col 03.00 font ? help "OK"
    bt_can at row 07.38 col 14.00 font ? help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 56.43 by 09.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Executa Importaá∆o Geraá∆o T°tulos APB".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars       in frame f_exec_importacao = 10.00
           bt_can:height-chars      in frame f_exec_importacao = 01.00
           bt_get_file:width-chars  in frame f_exec_importacao = 04.00
           bt_get_file:height-chars in frame f_exec_importacao = 01.08
           bt_ok:width-chars        in frame f_exec_importacao = 10.00
           bt_ok:height-chars       in frame f_exec_importacao = 01.00
           ed_1x40:width-chars      in frame f_exec_importacao = 40.00
           ed_1x40:height-chars     in frame f_exec_importacao = 01.00
           rt_cxcf:width-chars      in frame f_exec_importacao = 52.99
           rt_cxcf:height-chars     in frame f_exec_importacao = 01.42
           rt_messages:width-chars  in frame f_exec_importacao = 53.00
           rt_messages:height-chars in frame f_exec_importacao = 03.50
           rt_run:width-chars       in frame f_exec_importacao = 53.00
           rt_run:height-chars      in frame f_exec_importacao = 01.50.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_exec_importacao = yes.
    /* set private-data for the help system */
    assign rs_ind_message_output:private-data in frame f_exec_importacao = "HLP=000023695":U
           bt_get_file:private-data           in frame f_exec_importacao = "HLP=000008782":U
           ed_1x40:private-data               in frame f_exec_importacao = "HLP=000023695":U
           v_log_view_file:private-data       in frame f_exec_importacao = "HLP=000011183":U
           rs_ind_run_mode:private-data       in frame f_exec_importacao = "HLP=000023695":U
           bt_ok:private-data                 in frame f_exec_importacao = "HLP=000010721":U
           bt_can:private-data                in frame f_exec_importacao = "HLP=000011050":U
           frame f_exec_importacao:private-data                          = "HLP=000023695".
/*************************** Frame Definition End ***************************/



/*********************** User Interface Trigger Begin ***********************/
ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_wait_processing DO:
    /************************* Variable Definition Begin ************************/
    def var v_cod_prog_dtsul as character format "x(50)":U label "Programa" column-label "Programa" no-undo.
    /************************** Variable Definition End *************************/

    assign v_cod_prog_dtsul = program-name(1).

    if  index(v_cod_prog_dtsul, 'men903za') <> 0 then do:
        run pi_messages (input 'show', input 4289, input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.

    if  index(v_cod_prog_dtsul, 'men903za') = 0 then do:
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.
END.

ON CHOOSE OF bt_get_file IN FRAME f_exec_importacao DO:
    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite
        update v_log_answer.

    if  v_log_answer = yes then do:
        assign ed_1x40:screen-value in frame f_exec_importacao = v_cod_dwb_file.
    end /* if */.
END.

ON LEAVE OF ed_1x40 IN FRAME f_exec_importacao DO:
    /************************* Variable Definition Begin ************************/
    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/
    /************************** Variable Definition End *************************/

    block:
    do  with frame f_exec_importacao:
        if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ then do:
                if  ed_1x40:screen-value <> "" then do:
                    assign ed_1x40:screen-value   = replace(ed_1x40:screen-value, '~\', '/')
                           v_cod_filename_initial = entry(num-entries(ed_1x40:screen-value, '/'), ed_1x40:screen-value, '/')
                           v_cod_filename_final   = substring(ed_1x40:screen-value, 1, length(ed_1x40:screen-value) - length(v_cod_filename_initial) - 1)
                           file-info:file-name    = v_cod_filename_final.
                    if  file-info:file-type = ? then do:
                        /* O diret¢rio &1 n∆o existe ! */
                        run pi_messages (input "show",
                                         input 4354,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            v_cod_filename_final)) /*msg_4354*/.
                        return no-apply.
                    end /* if */.
                end /* if */.
            end /* if */.
        end /* if */.
    end /* do block */.
END.

ON  VALUE-CHANGED OF rs_ind_message_output IN FRAME f_exec_importacao DO:
    block:
    do  with frame f_exec_importacao:
        if  self:screen-value = "Na Tela" /*l_on_screen*/ then do:
            disable ed_1x40 bt_get_file v_log_view_file with frame f_exec_importacao.
        end /* if */.
        else do:
            enable ed_1x40 bt_get_file v_log_view_file with frame f_exec_importacao.
        end /* else */.
    end /* do block */.
END.
/************************ User Interface Trigger End ************************/



/**************************** Frame Trigger Begin ***************************/
ON  WINDOW-CLOSE OF FRAME f_dlg_02_wait_processing DO:
    APPLY "end-error" TO SELF.
END.

ON  WINDOW-CLOSE OF FRAME f_exec_importacao DO:
    APPLY "end-error" TO SELF.
END.
/***************************** Frame Trigger End ****************************/



/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
assign frame f_exec_importacao:title = frame f_exec_importacao:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.00.00.000":U)
                            + chr(41).

pause 0 before-hide.
view frame f_exec_importacao.

RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    ASSIGN tt-prog-ponto.conteudo = replace(tt-prog-ponto.conteudo, "/", "~\").

    IF SUBSTRING(tt-prog-ponto.conteudo, LENGTH(tt-prog-ponto.conteudo), 1) <> "~\" THEN ASSIGN tt-prog-ponto.conteudo = tt-prog-ponto.conteudo + "~\".
    
    ASSIGN ed_1x40 = tt-prog-ponto.conteudo + 'esapb032.txt'.
END.




DISP ed_1x40
     v_log_view_file
     rs_ind_message_output
     rs_ind_run_mode
     with frame f_exec_importacao.


enable bt_can
       bt_get_file
       bt_ok
       ed_1x40
       v_log_view_file
       with frame f_exec_importacao.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    wait-for go of frame f_exec_importacao.

    assign input frame f_exec_importacao v_log_view_file.
    assign v_nom_filename = ed_1x40:screen-value
           v_ind_message_output = rs_ind_message_output:screen-value.


    if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ then do:
        run pi_filename_validation (Input v_nom_filename) /*pi_filename_validation*/. 
        if  return-value = "NOK" /*l_nok*/ then do:
            /* Nome do arquivo incorreto ! */
            run pi_messages (input "show",
                             input 1064,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
            undo main_block, retry main_block.
        end /* if */.
    end /* if */.

    if  rs_ind_message_output:screen-value = "Em Arquivo" /*l_on_file*/ then do:
        assign v_nom_prog_ext  = caps("esapb032":U)
               v_dat_execution = today
               v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
               v_nom_filename = lc(v_nom_filename).
        output stream s_1 to value(v_nom_filename) paged
               page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
    end.

    EMPTY TEMP-TABLE tt_file_import NO-ERROR.
    run pi_importacao_gera_APB.

    if  rs_ind_message_output:screen-value = "Em Arquivo" then do:
        output stream s_1 close.
        if  v_log_view_file = yes then do:
            run pi_show_report_2 (Input v_nom_filename).
        end.
    end.
end.

hide frame f_exec_importacao.
/******************************* Main Code End ******************************/

PROCEDURE pi_importacao_gera_APB:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_bord      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cdn_fornec    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOG INIT NO NO-UNDO.
    DEFINE VARIABLE v_val_tit_ap    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_log_integr    AS logical     NO-UNDO.

    RUN pi-zera-tabelas.

    ASSIGN v_nom_prog_ext   = CAPS("ESAPB032":U)
           v_cod_release    = " 5.00.00.000":U
           v_dat_execution  = TODAY 
           v_hra_execution  = REPLACE(STRING(TIME,"hh:mm:ss"),":","")
           v_nom_enterprise = "Intelbras S.A.".

    HIDE STREAM s_1 FRAME f_rpt_s_1_header_period.
    VIEW STREAM s_1 FRAME f_rpt_s_1_header_unique.
    HIDE STREAM s_1 FRAME f_rpt_s_1_footer_last_page.
    HIDE STREAM s_1 FRAME f_rpt_s_1_footer_param_page.
    VIEW STREAM s_1 FRAME f_rpt_s_1_footer_normal.
    VIEW STREAM s_1 FRAME f_rpt_s_1_Grp_Logs_Lay_unico.  

    ASSIGN v_log_method      = SESSION:SET-WAIT-STATE('general') 
           v_num_line        = 0
           v_log_refer_uni   = NO
           v_cod_refer       = ""
           v_total_a_validar = 0
           v_log_integr      = yes.

    /*--- Geraá∆o da temp-table com os dados do arquivo ---*/
    EMPTY TEMP-TABLE tt_file_import NO-ERROR.
    INPUT FROM VALUE(v_arq_import_esapb032) NO-CONVERT.
    
    REPEAT:
        IMPORT UNFORMATTED v_des_reg_import.

        ASSIGN v_num_line = v_num_line + 1.
        CREATE tt_file_import.
        ASSIGN tt_file_import.tta_num_line             = v_num_line
               tt_file_import.tta_cod_estab            = trim(ENTRY(1,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_evento           = trim(ENTRY(2,  v_des_reg_import, ";"))
               tt_file_import.tta_cdn_fornecedor       =  int(ENTRY(3,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_cta_ctbl         = trim(ENTRY(4,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_tip_fluxo_financ = trim(ENTRY(5,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_ser_docto        = trim(ENTRY(6,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_tit_ap           = trim(ENTRY(7,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_parcela          = trim(ENTRY(8,  v_des_reg_import, ";"))
               tt_file_import.tta_cod_espec_docto      = trim(ENTRY(9,  v_des_reg_import, ";"))
               tt_file_import.tta_val_tit_ap           =  dec(ENTRY(10, v_des_reg_import, ";"))
               tt_file_import.tta_dat_vencto_tit_ap    = date(ENTRY(11, v_des_reg_import, ";"))
               tt_file_import.tta_cod_ccusto           = trim(ENTRY(12, v_des_reg_import, ";")).
    END. /* REPEAT: */

    /* Totalizador para verificaá∆o do valor informado em tela */
    ASSIGN v_total_a_validar = 0.
    FOR EACH tt_file_import:
        ASSIGN v_total_a_validar = v_total_a_validar + tt_file_import.tta_val_tit_ap.
        run pi_valida_dados(input tt_file_import.tta_cdn_fornecedor,
                            input tt_file_import.tta_cod_estab,
                            input tt_file_import.tta_num_line).
        if return-value = "NOK" then
            assign v_log_integr = no.
    END. /* FOR EACH tt_file_import: */

    /* se total n∆o for igual ao informado em tela, n∆o importa nada */

    /* COMENTADO MELHORIA M2009-196 - 17/03/21
    IF  v_total_a_validar NE v_val_total_esapb032 THEN DO:
        ASSIGN v_des_mensagem = "Valor total do arquivo n∆o confere com o informado em tela!".
        RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
        PUT STREAM s_1 UNFORMATTED  v_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
        RUN pi_print_editor ("s_1", v_des_mensagem, "at021050", "", "", "", "").
        assign v_log_integr = no.
    END.*/

    if v_log_integr then do:

        EMPTY TEMP-TABLE tt_relac_erro                  NO-ERROR.
        EMPTY TEMP-TABLE tt_integr_apb_lote_impl        NO-ERROR.
        EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3 NO-ERROR.
        EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v NO-ERROR.
        EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend  NO-ERROR.
        EMPTY TEMP-TABLE tt_log_erros_atualiz           NO-ERROR.
    
        ASSIGN i-conta-refer = 0
            v_log_atualiza_refer_apb = yes.
        
        /* Baseado na temp-table criada da importaá∆o, chama a API para criaá∆o do t°ulo no APB */
        FOR EACH tt_file_import BREAK BY tt_file_import.tta_cod_estab:
            
            IF  FIRST-OF(tt_file_import.tta_cod_estab) THEN DO:
    
                ASSIGN v_log_refer_uni = NO.
                
    
                /*** Gera Referància V†lida ***/
                REPEAT WHILE NOT v_log_refer_uni:
                    RUN pi_retorna_sugestao_referencia (INPUT "APB":U, INPUT  v_dat_transacao_esapb032, OUTPUT v_cod_refer).
                    RUN pi_verifica_refer_unica_apb (INPUT  estabelecimento.cod_estab,
                                                     INPUT  v_cod_refer,
                                                     INPUT  "lote_impl_tit_ap":U,
                                                     INPUT  ?,
                                                     OUTPUT v_log_refer_uni).
                END. /* REPEAT WHILE ... */
                
                CREATE tt_integr_apb_lote_impl.
                ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = tt_file_import.tta_cod_estab
                       tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer /*manter logica de referencia unica*/
                       tt_integr_apb_lote_impl.tta_dat_transacao     = v_dat_transacao_esapb032
                       tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
                       tt_integr_apb_lote_impl.tta_cod_empresa       = estabelecimento.cod_empresa /*do estabelecimento informado na planilha*/.
            END.
    
            RELEASE tt_integr_apb_lote_impl.
            FIND FIRST tt_integr_apb_lote_impl 
                where tt_integr_apb_lote_impl.tta_cod_estab         = tt_file_import.tta_cod_estab
                and   tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer NO-ERROR.
    
            ASSIGN i-conta-refer = i-conta-refer + 1.
    
            CREATE tt_integr_apb_item_lote_impl_3.
            ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
                   tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = i-conta-refer
                   tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = tt_file_import.tta_cdn_fornecedor
                   tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = tt_file_import.tta_cod_espec_docto
                   tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = tt_file_import.tta_cod_ser_docto
                   tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = tt_file_import.tta_cod_tit_ap
                   tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = tt_file_import.tta_cod_parcela
                   tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = v_dat_transacao_esapb032
                   tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = tt_file_import.tta_dat_vencto_tit_ap
                   tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = tt_file_import.tta_dat_vencto_tit_ap
                   tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = "20":U
                   tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = "Real":U
                   tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               = tt_file_import.tta_val_tit_ap
                   tt_integr_apb_item_lote_impl_3.tta_cod_portador             = v_portador_esapb032 /*"341":U*/ //PORTADOR INFORMADO PELO USUARIO EM TELA - M2009-196 - 17/03/21
                   tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 1
                   tt_integr_apb_item_lote_impl_3.tta_des_text_histor          = "Evento: " + tt_file_import.tta_cod_evento + " - importado - esapb032 - " + v_arq_import_esapb032.
    
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = v_unid_negoc_esapb032 /*"ADM":U*/
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = tt_file_import.tta_cod_tip_fluxo_financ
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = tt_file_import.tta_val_tit_ap
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = tt_file_import.tta_cod_cta_ctbl.

            IF  tt_file_import.tta_cod_ccusto <> "" THEN
                ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto = "PADRAO"
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto       = tt_file_import.tta_cod_ccusto.
            
            RELEASE tt_integr_apb_aprop_ctbl_pend.
            FIND FIRST tt_integr_apb_aprop_ctbl_pend NO-ERROR.
        
            IF  last-of(tt_file_import.tta_cod_estab) then
                assign i-conta-refer = 0.

        END. /* FOR EACH tt_file_import .. */
    
        IF  CAN-FIND(FIRST tt_integr_apb_lote_impl) THEN DO:
    
            cria_docto:
            DO TRANSACTION:
                /* ** Chamada da API ***/ 
                IF NOT VALID-HANDLE(v_hdl_aux) THEN RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
            
                EMPTY TEMP-TABLE tt_log_erros_atualiz NO-ERROR.
                RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                                  INPUT "EMS":U,
                                                                  INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_3).
                ASSIGN v_cod_usuar_corren = c-usuario-corrente-atual.
                
                IF  VALID-HANDLE(v_hdl_aux) THEN DELETE PROCEDURE v_hdl_aux.
                ASSIGN v_hdl_aux = ?.
                
                IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
                    FOR EACH tt_log_erros_atualiz:
                        find first tt_integr_apb_lote_impl
                            where tt_integr_apb_lote_impl.tta_cod_estab = tt_log_erros_atualiz.tta_cod_estab
                            and   tt_integr_apb_lote_impl.tta_cod_refer = tt_log_erros_atualiz.tta_cod_refer no-error.
                        
                        IF  tt_log_erros_atualiz.tta_num_seq_refer > 0 THEN DO:
                            find first tt_integr_apb_item_lote_impl_3 
                                where tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
                                and  tt_integr_apb_item_lote_impl_3.tta_num_seq_refer = tt_log_erros_atualiz.tta_num_seq_refer no-error.
    
                            find first tt_file_import
                                where tt_file_import.tta_cod_estab        = tt_integr_apb_lote_impl.tta_cod_estab
                                and   tt_file_import.tta_cdn_fornecedor   = tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor
                                and   tt_file_import.tta_cod_espec_docto  = tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto
                                and   tt_file_import.tta_cod_ser_docto    = tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto
                                and   tt_file_import.tta_cod_tit_ap       = tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap
                                and   tt_file_import.tta_cod_parcela      = tt_integr_apb_item_lote_impl_3.tta_cod_parcela no-error.
    
                            RUN pi_print_editor ("s_1", "(" + string(tt_log_erros_atualiz.ttv_num_mensagem) + 
                                                        ") " + tt_log_erros_atualiz.ttv_des_msg_erro + " " + 
                                                        tt_log_erros_atualiz.ttv_des_msg_ajuda + ". Documento: " + 
                                                        string(tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap) + " Parcela: " + 
                                                        string(tt_integr_apb_item_lote_impl_3.tta_cod_parcela), "     050", "", "     ", "", "     ").
                            PUT STREAM s_1 UNFORMATTED  tt_file_import.tta_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
                            RUN pi_print_editor ("s_1", "(" + string(tt_log_erros_atualiz.ttv_num_mensagem) + 
                                                        ") " + tt_log_erros_atualiz.ttv_des_msg_erro + " " + 
                                                        tt_log_erros_atualiz.ttv_des_msg_ajuda + ". Documento: " + 
                                                        string(tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap) + " Parcela: " + 
                                                        string(tt_integr_apb_item_lote_impl_3.tta_cod_parcela), "at021050", "", "", "", "").
                        END.
                        ELSE DO:
                            RUN pi_print_editor ("s_1", "(" + string(tt_log_erros_atualiz.ttv_num_mensagem) + 
                                                        ") " + tt_log_erros_atualiz.ttv_des_msg_erro + " " + 
                                                        tt_log_erros_atualiz.ttv_des_msg_ajuda, "     050", "", "     ", "", "     ").
                            PUT STREAM s_1 UNFORMATTED  tt_file_import.tta_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
                            RUN pi_print_editor ("s_1", "(" + string(tt_log_erros_atualiz.ttv_num_mensagem) + 
                                                        ") " + tt_log_erros_atualiz.ttv_des_msg_erro + " " + 
                                                        tt_log_erros_atualiz.ttv_des_msg_ajuda, "at021050", "", "", "", "").
                        END.
                    END.
                    UNDO cria_docto, LEAVE cria_docto.
                END.
            END. /* Do Transaction */
        END. /* IF  CAN-FIND(FIRST tt_integr_apb_item_lote_impl3v) ... */
        ELSE DO:
            RUN pi_print_editor ("s_1", "T°tulo(s) n∆o foram criados. Atualizaá∆o interrompida.", "     050", "", "     ", "", "     ").
            PUT STREAM s_1 UNFORMATTED  v_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
            RUN pi_print_editor ("s_1", "T°tulo(s) n∆o foram criados. Atualizaá∆o interrompida.", "at021050", "", "", "", "").
        END. /* ELSE DO: */
        
        IF NOT CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
            RUN pi_print_editor ("s_1", "T°tulo(s) foram criados com sucesso. Atualizaá∆o encerrada.", "     050", "", "     ", "", "     ").
            PUT STREAM s_1 UNFORMATTED  v_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
            RUN pi_print_editor ("s_1", "T°tulo(s) foram criados com sucesso. Atualizaá∆o encerrada.", "at021050", "", "", "", "").
        END.
    end.
    

RETURN "OK":U.


    
END PROCEDURE. /* PROCEDURE pi_importacao_gera_APB: */
procedure pi_valida_dados:
    def input param p_cdn_fornecedor
        as integer
        no-undo.
    def input param p_cod_estab
        as character
        no-undo.
    def input param p_num_line
        as integer
        no-undo.

    /* valida fornecedor */
    FIND FIRST fornec_financ NO-LOCK
        WHERE  fornec_financ.cod_empresa = v_cod_empres_usuar
        AND    fornec_financ.cdn_fornec  = p_cdn_fornecedor NO-ERROR.
    IF  NOT AVAIL fornec_financ THEN DO:
        ASSIGN v_des_mensagem = SUBSTITUTE("Fornecedor &1 n∆o localizado!", p_cdn_fornecedor).
        RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
        PUT STREAM s_1 UNFORMATTED  p_num_line TO 19 FORMAT  ">>>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
        RUN pi_print_editor ("s_1", v_des_mensagem, "at021050", "", "", "", "").
        return "NOK".
    END.

    /* valida estabelecimento */
    FIND FIRST estabelecimento NO-LOCK
        WHERE  estabelecimento.cod_estab = p_cod_estab NO-ERROR.
    IF  NOT AVAIL estabelecimento THEN DO:
        ASSIGN v_des_mensagem = SUBSTITUTE("Estabelecimento &1 n∆o localizado!", p_cod_estab).
        RUN pi_print_editor ("s_1", v_des_mensagem, "     050", "", "     ", "", "     ").
        PUT STREAM s_1 UNFORMATTED  p_num_line TO 19 FORMAT  ">>,>>9" ENTRY(1, RETURN-VALUE, CHR(255)) AT 21 FORMAT "x(50)" SKIP.
        RUN pi_print_editor ("s_1", v_des_mensagem, "at021050", "", "", "", "").
        return "NOK".
    END.
    return "OK".
end procedure.
PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/
    def Input param p_cod_dwb_file as character format "x(40)" no-undo.
    /************************* Parameter Definition End *************************/


    /************************* Variable Definition Begin ************************/
    def var v_cod_key_value as character format "x(8)":U no-undo.
    /************************** Variable Definition End *************************/


    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or  v_cod_key_value = ? then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.

END PROCEDURE.


PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/
    def Input param p_cod_filename as character format "x(40)" no-undo.
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
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK" /*l_ok*/ .
END PROCEDURE.


PROCEDURE pi_wait_processing:

    /************************ Parameter Definition Begin ************************/
    def Input param p_des_message     as CHARACTER format "x(40)" no-undo.
    def Input param p_nom_frame_title as CHARACTER format "x(32)" no-undo.
    /************************* Parameter Definition End *************************/


    if  p_nom_frame_title <> ? or
       frame f_dlg_02_wait_processing:visible = no then do:
        if  p_nom_frame_title <> "" then do:
            assign frame f_dlg_02_wait_processing:title = p_nom_frame_title.
        end /* if */.
        else do:
            assign frame f_dlg_02_wait_processing:title = "Aguarde, em processamento..." /*l_aguarde_em_processamento*/ .
        end /* else */.
        assign ed_1x40:width-chars in frame f_dlg_02_wait_processing = 60.
    end /* if */.
    assign ed_1x40:screen-value in frame f_dlg_02_wait_processing = p_des_message.
    enable all with frame f_dlg_02_wait_processing.
    process events.
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


PROCEDURE pi_print_editor:

    def input param p_stream    as char    no-undo.
    def input param p1_editor   as char    no-undo.
    def input param p1_pos      as char    no-undo.
    def input param p2_editor   as char    no-undo.
    def input param p2_pos      as char    no-undo.
    def input param p3_editor   as char    no-undo.
    def input param p3_pos      as char    no-undo.

    def var c_editor as char    extent 5             no-undo.
    def var l_first  as logical extent 5 initial yes no-undo.
    def var c_at     as char    extent 5             no-undo.
    def var i_pos    as integer extent 5             no-undo.
    def var i_len    as integer extent 5             no-undo.

    def var c_aux    as char               no-undo.
    def var i_aux    as integer            no-undo.
    def var c_ret    as char               no-undo.
    def var i_ind    as integer            no-undo.

    assign c_editor [1] = p1_editor
           c_at  [1]    =         substr(p1_pos,1,2)
           i_pos [1]    = integer(substr(p1_pos,3,3))
           i_len [1]    = integer(substr(p1_pos,6,3)) - 4
           c_editor [2] = p2_editor
           c_at  [2]    =         substr(p2_pos,1,2)
           i_pos [2]    = integer(substr(p2_pos,3,3))
           i_len [2]    = integer(substr(p2_pos,6,3)) - 4
           c_editor [3] = p3_editor
           c_at  [3]    =         substr(p3_pos,1,2)
           i_pos [3]    = integer(substr(p3_pos,3,3))
           i_len [3]    = integer(substr(p3_pos,6,3)) - 4
           c_ret        = chr(255) + chr(255).

    do while c_editor [1] <> "" or c_editor [2] <> "" or c_editor [3] <> "":
        do i_ind = 1 to 3:
            if c_editor[i_ind] <> "" then do:
                assign i_aux = index(c_editor[i_ind], chr(10)).
                if i_aux > i_len[i_ind] or (i_aux = 0 and length(c_editor[i_ind]) > i_len[i_ind]) then assign i_aux = r-index(c_editor[i_ind], " ", i_len[i_ind] + 1).

                if i_aux = 0 
                then assign c_aux = substr(c_editor[i_ind], 1, i_len[i_ind])
                            c_editor[i_ind] = substr(c_editor[i_ind], i_len[i_ind] + 1).
                else assign c_aux = substr(c_editor[i_ind], 1, i_aux - 1)
                            c_editor[i_ind] = substr(c_editor[i_ind], i_aux + 1).

                if i_pos[1] = 0 
                THEN assign entry(i_ind, c_ret, chr(255)) = c_aux.
                else if l_first[i_ind] 
                     THEN assign l_first[i_ind] = no.
                     else
                         case p_stream:
                             when "s_1" then
                                 if c_at[i_ind] = "at" 
                                 THEN put stream s_1 unformatted c_aux at i_pos[i_ind].
                                 ELSE put stream s_1 unformatted c_aux to i_pos[i_ind].
                         end.
            end.
        end.
        case p_stream:
           when "s_1" then put stream s_1 unformatted skip.
        end.
        if i_pos[1] = 0 then return c_ret.
    end.
    return c_ret.
END PROCEDURE.


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
        message "Mensagem nr. " i_msg "!!!":U SKIP 
                "Programa Mensagem" c_prg_msg "n∆o encontrado." view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.


PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/
    def Input param p_ind_tip_atualiz as CHARACTER format "X(08)"      no-undo.
    def Input param p_dat_refer       as DATE      format "99/99/9999" no-undo.
    def output param p_cod_refer      as CHARACTER format "x(10)"      no-undo.
    /************************* Parameter Definition End *************************/


    /************************* Variable Definition Begin ************************/
    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/
    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_cod_estab        AS CHARACTER   NO-UNDO FORMAT "x(3)":U.
    DEFINE INPUT  PARAMETER p_cod_refer        AS CHARACTER   NO-UNDO FORMAT "x(10)":U.
    DEFINE INPUT  PARAMETER p_cod_table        AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_rec_movto_tit_ap AS RECID       NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_log_refer_uni    AS LOGICAL     NO-UNDO FORMAT "Sim/N∆o":U.

    DEFINE BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEFINE BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEFINE BUFFER b_lote_pagto       FOR lote_pagto.
    DEFINE BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    IF p_cod_table <> "antecip_pef_pend":U THEN
        FIND FIRST b_antecip_pef_pend
            WHERE b_antecip_pef_pend.cod_estab = p_cod_estab
              AND b_antecip_pef_pend.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

    IF AVAILABLE b_antecip_pef_pend THEN
        ASSIGN p_log_refer_uni = NO.
    ELSE DO:
        IF p_cod_table <> "lote_impl_tit_ap":U THEN
            FIND FIRST b_lote_impl_tit_ap
                WHERE b_lote_impl_tit_ap.cod_estab = p_cod_estab
                  AND b_lote_impl_tit_ap.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_impl_tit_ap THEN
            ASSIGN p_log_refer_uni = NO.
        ELSE DO:
            IF p_cod_table <> "lote_pagto":U THEN
                FIND FIRST b_lote_pagto
                    WHERE b_lote_pagto.cod_estab_refer = p_cod_estab
                      AND b_lote_pagto.cod_refer       = p_cod_refer NO-LOCK NO-ERROR.

            IF AVAILABLE b_lote_pagto THEN
                ASSIGN p_log_refer_uni = NO.
            ELSE DO:
                FIND FIRST b_movto_tit_ap
                    WHERE b_movto_tit_ap.cod_estab = p_cod_estab
                      AND b_movto_tit_ap.cod_refer = p_cod_refer
                      AND RECID(b_movto_tit_ap)   <> p_rec_movto_tit_ap NO-LOCK NO-ERROR.

                IF AVAILABLE b_movto_tit_ap THEN
                    ASSIGN p_log_refer_uni = NO.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-zera-tabelas:

    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v  NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_abat_antecip_vouc NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_abat_prev_provis  NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend   NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_relacto     NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend   NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl    NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_lote_impl         NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_relacto_pend      NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erros_atualiz            NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3  NO-ERROR.
    EMPTY TEMP-TABLE tt_file_import                  NO-ERROR.
    
END PROCEDURE.
