/****************************************************************************
** Descricao ........: Envio t°tulos DEPS.
**
** Nome Externo .....: esp/acr/esacr084arp.p
**
** Criado por .......: Andrey Mauricio de Oliveira
**
** Criado em ........: 13/12/2021
**
*****************************************************************************/

assign this-procedure:private-data = "HLP=22":U.

{esp/es0018.i}
{cdp/cd0666.i}
{utp/utapi019.i}
{utp/ut-glob.i}

DEF INPUT PARAM v_opcao AS INT NO-UNDO.

def stream s_1.

DEF TEMP-TABLE tt_file_import NO-UNDO
    FIELD tta_num_line        AS INT
    FIELD tta_tip_reg         AS CHAR
    FIELD tta_num_id_tit_acr  LIKE tit_acr.num_id_tit_acr
    FIELD tta_cod_estab       LIKE tit_acr.cod_estab
    FIELD tta_cod_espec_docto LIKE tit_acr.cod_espec_docto
    FIELD tta_cod_ser_docto   LIKE tit_acr.cod_ser_docto
    FIELD tta_cod_tit_acr     LIKE tit_acr.cod_tit_acr
    FIELD tta_cod_parcela     LIKE tit_acr.cod_parcela
    FIELD tta_num_pedido      LIKE ped-venda.nr-pedido
    FIELD tta_cdn_cliente     LIKE tit_acr.cdn_cliente.

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

DEF VAR v_parcela            LIKE tit_acr.cod_parcela NO-UNDO.
DEF VAR v_cod_tit_acr        LIKE tit_acr.cod_tit_acr NO-UNDO.
DEF VAR i_cont               AS INT INIT 0            NO-UNDO.
DEF VAR v_tamanho            AS INT INIT 0            NO-UNDO.
DEF VAR h-bodi159cal         AS HANDLE NO-UNDO.
def var v_cod_dwb_file       as CHARACTER format "x(40)":U label "Arquivo" column-label "Arquivo" no-undo.
def var v_cod_release        as CHARACTER format "x(12)":U no-undo. 
def var v_cod_tip_reg        as CHARACTER format "x(03)":U label "Tipo Registro" column-label "Tipo Registro" no-undo.
def var v_dat_execution      as DATE      format "99/99/9999":U no-undo.
def var v_des_filespec       as CHARACTER format "x(10)":U extent 10 no-undo.
def var v_des_mensagem       as CHARACTER format "x(50)":U view-as editor max-chars 2000 SCROLLBAR-VERTICAL size 50 by 4 bgcolor 15 font 2 label "Mensagem" column-label "Mensagem" no-undo.
def var v_des_reg_import     as CHARACTER format "x(40)":U no-undo. 
def var v_hra_execution      as CHARACTER format "99:99":U no-undo. 
def var v_hra_execution_end  as CHARACTER format "99:99:99":U label "Tempo Exec" no-undo.
def var v_ind_message_output as CHARACTER format "X(10)":U initial "Em Arquivo" view-as radio-set HORIZONTAL radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo" bgcolor 8 no-undo.
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
DEF VAR c-msg                AS CHAR      FORMAT "x(100)"    NO-UNDO.
DEF VAR h-acomp              AS HANDLE                       NO-UNDO.
DEF VAR c-msg-mail           AS CHARACTER                    NO-UNDO.
DEF VAR v_portador           as char format "x(5)"           NO-UNDO.

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

def new global shared var v_arq_import_esacr084a    as CHARACTER format "x(80)":U view-as editor max-chars 250 NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 label "Nome Arquivo" column-label "Arquivo" no-undo.
def new global shared var v_dat_transacao_esacr084a as DATE format "99/99/9999":U view-as FILL-IN size 13 by .88 bgcolor 15 font 2 label "Data Transaá∆o" column-label "Dt Transaá∆o" no-undo.

def rectangle rt_001      size 1 by 1 edge-pixels 2.
def rectangle rt_cxcf     size 1 by 1 fgcolor 1 edge-pixels 2.
def rectangle rt_messages size 1 by 1 edge-pixels 2.
def rectangle rt_run      size 1 by 1 edge-pixels 2.

def button bt_can      label "Cancela"          tooltip "Cancela" size 1 by 1 auto-endkey.
def button bt_can2     label "Cancela"          tooltip "Cancela" size 1 by 1. 
def button bt_get_file label "Pesquisa Arquivo" tooltip "Pesquisa Arquivo" image-up file "image/im-sea1" image-insensitive file "image/ii-sea1" size 1 by 1.
def button bt_ok       label "OK"               tooltip "OK" size 1 by 1 auto-go.

def var ed_12x85 as CHARACTER view-as editor scrollbar-horizontal scrollbar-vertical NO-WORD-WRAP size 85 by 12 bgcolor 15 font 2 no-undo.
def var ed_1x40  as CHARACTER view-as editor NO-WORD-WRAP size 40 by 1 bgcolor 15 font 2 no-undo.

def var rs_ind_message_output as CHARACTER initial "Em Arquivo" view-as radio-set HORIZONTAL radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo" bgcolor 8 no-undo.
def var rs_ind_run_mode       as CHARACTER initial "On-Line"    view-as radio-set HORIZONTAL radio-buttons "On-Line", "On-Line","Batch", "Batch" bgcolor 8 no-undo.

def new shared var v_rpt_s_1_lines   as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 80.
def new shared var v_rpt_s_1_bottom  as integer initial 65.
def new shared var v_rpt_s_1_page    as integer.
def new shared var v_rpt_s_1_name    as character initial "Logs Importaá∆o Geraá∆o T°tulos APB".

def var v_hdl_aux         as handle  no-undo.

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
    
assign bt_can2:width-chars  in frame f_dlg_02_wait_processing = 10.00
       bt_can2:height-chars in frame f_dlg_02_wait_processing = 01.00
       rt_001:width-chars   in frame f_dlg_02_wait_processing = 62.43
       rt_001:height-chars  in frame f_dlg_02_wait_processing = 01.92.

assign ed_1x40:return-inserted in frame f_dlg_02_wait_processing = yes.
    
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
    
assign ed_1x40:return-inserted in frame f_exec_importacao = yes.
    
assign rs_ind_message_output:private-data in frame f_exec_importacao = "HLP=000023695":U
       bt_get_file:private-data           in frame f_exec_importacao = "HLP=000008782":U
       ed_1x40:private-data               in frame f_exec_importacao = "HLP=000023695":U
       v_log_view_file:private-data       in frame f_exec_importacao = "HLP=000011183":U
       rs_ind_run_mode:private-data       in frame f_exec_importacao = "HLP=000023695":U
       bt_ok:private-data                 in frame f_exec_importacao = "HLP=000010721":U
       bt_can:private-data                in frame f_exec_importacao = "HLP=000011050":U
       frame f_exec_importacao:private-data                          = "HLP=000023695".

ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_wait_processing DO:
    def var v_cod_prog_dtsul as character format "x(50)":U label "Programa" column-label "Programa" no-undo.

    assign v_cod_prog_dtsul = program-name(1).

    if  index(v_cod_prog_dtsul, 'men903za') <> 0 then do:
        run pi_messages (input 'show', input 4289, input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
        hide frame f_dlg_02_wait_processing.
        stop.
    end.

    if  index(v_cod_prog_dtsul, 'men903za') = 0 then do:
        hide frame f_dlg_02_wait_processing.
        stop.
    end.
END.

ON CHOOSE OF bt_get_file IN FRAME f_exec_importacao DO:
    system-dialog get-file v_cod_dwb_file
        title "Imprimir"
        filters "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite
        update v_log_answer.

    if  v_log_answer = yes then do:
        assign ed_1x40:screen-value in frame f_exec_importacao = v_cod_dwb_file.
    end.
END.

ON LEAVE OF ed_1x40 IN FRAME f_exec_importacao DO:
    def var v_cod_filename_final             as character       no-undo.
    def var v_cod_filename_initial           as character       no-undo.

    block:
    do  with frame f_exec_importacao:
        if  rs_ind_message_output:screen-value = "Em Arquivo" then do:
            if  rs_ind_run_mode:screen-value <> "Batch" then do:
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
                                                            v_cod_filename_final)).
                        return no-apply.
                    end.
                end.
            end.
        end.
    end.
END.

ON  VALUE-CHANGED OF rs_ind_message_output IN FRAME f_exec_importacao DO:
    block:
    do  with frame f_exec_importacao:
        if  self:screen-value = "Na Tela" then do:
            disable ed_1x40 bt_get_file v_log_view_file with frame f_exec_importacao.
        end.
        else do:
            enable ed_1x40 bt_get_file v_log_view_file with frame f_exec_importacao.
        end.
    end.
END.

ON  WINDOW-CLOSE OF FRAME f_dlg_02_wait_processing DO:
    APPLY "end-error" TO SELF.
END.

ON  WINDOW-CLOSE OF FRAME f_exec_importacao DO:
    APPLY "end-error" TO SELF.
END.

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
    
    ASSIGN ed_1x40 = tt-prog-ponto.conteudo + 'esacr084a.txt'.
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


    if  rs_ind_message_output:screen-value = "Em Arquivo" then do:
        run pi_filename_validation (Input v_nom_filename). 
        if  return-value = "NOK" then do:
            /* Nome do arquivo incorreto ! */
            run pi_messages (input "show",
                             input 1064,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            undo main_block, retry main_block.
        end.
    end.

    if  rs_ind_message_output:screen-value = "Em Arquivo" then do:
        assign v_nom_prog_ext  = caps("esacr084a":U)
               v_dat_execution = today
               v_hra_execution = replace(string(time,"hh:mm:ss"),":","")
               v_nom_filename = lc(v_nom_filename).
        output stream s_1 to value(v_nom_filename) paged
               page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
    end.
    
    RUN pi_processa.

    if  rs_ind_message_output:screen-value = "Em Arquivo" then do:
        output stream s_1 close.
        if  v_log_view_file = yes then do:
            run pi_show_report_2 (Input v_nom_filename).
        end.
    end.
end.

hide frame f_exec_importacao.


PROCEDURE pi_processa:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_bord      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cdn_fornec    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOG INIT NO NO-UNDO.
    DEFINE VARIABLE v_val_tit_ap    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_log_integr    AS logical     NO-UNDO.

    ASSIGN v_nom_prog_ext   = CAPS("esacr084a":U)
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
           v_log_integr      = yes.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Importando ...").

    /*--- Geraá∆o da temp-table com os dados do arquivo ---*/
    EMPTY TEMP-TABLE tt_file_import NO-ERROR.
    
    INPUT FROM VALUE(v_arq_import_esacr084a) NO-CONVERT.
    
    REPEAT:
        IMPORT UNFORMATTED v_des_reg_import.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivo.").

        IF  v_opcao = 1 THEN DO:

            IF  NUM-ENTRIES(v_des_reg_import, "/") = 3 THEN DO:
                IF  entry(3,v_des_reg_import,"/") = "" THEN
                    NEXT.

                ASSIGN v_num_line = v_num_line + 1.
                CREATE tt_file_import.
                ASSIGN tt_file_import.tta_num_line       = v_num_line
                       tt_file_import.tta_tip_reg        = "tit_acr_id"
                       tt_file_import.tta_num_id_tit_acr = int(entry(3,v_des_reg_import,"/")).
            END.

            IF  NUM-ENTRIES(v_des_reg_import, ";") = 5 THEN DO:
                ASSIGN v_num_line = v_num_line + 1.
                CREATE tt_file_import.
                ASSIGN tt_file_import.tta_num_line        = v_num_line
                       tt_file_import.tta_tip_reg         = "tit_acr_chave"
                       tt_file_import.tta_cod_estab       = trim(ENTRY(1,v_des_reg_import,";"))
                       tt_file_import.tta_cod_espec_docto = trim(ENTRY(2,v_des_reg_import,";"))
                       tt_file_import.tta_cod_ser_docto   = trim(ENTRY(3,v_des_reg_import,";")).

                ASSIGN v_cod_tit_acr = trim(ENTRY(4,v_des_reg_import,";")).
                ASSIGN v_tamanho = LENGTH(v_cod_tit_acr).
            
                IF  v_tamanho < 7 THEN DO:
                    ASSIGN i_cont = v_tamanho.
            
                    DO  WHILE i_cont < 7:
                        ASSIGN v_cod_tit_acr = "0" + v_cod_tit_acr
                               i_cont        = i_cont + 1.
                    END.
                END.
            
                ASSIGN v_parcela = trim(ENTRY(5,v_des_reg_import,";")).
                ASSIGN v_tamanho = LENGTH(v_parcela).
            
                IF  v_tamanho < 2 THEN DO:
                    ASSIGN i_cont = v_tamanho.
            
                    DO  WHILE i_cont < 2:
                        ASSIGN v_parcela = "0" + v_parcela
                               i_cont        = i_cont + 1.
                    END.
                END.

                ASSIGN tt_file_import.tta_cod_tit_acr = v_cod_tit_acr
                       tt_file_import.tta_cod_parcela = v_parcela.
            END.
        END.

        IF  v_opcao = 2 THEN DO:
            ASSIGN v_num_line = v_num_line + 1.

            IF  v_num_line = 1 THEN
                NEXT.

            CREATE tt_file_import.
            ASSIGN tt_file_import.tta_num_line   = v_num_line
                   tt_file_import.tta_tip_reg    = "pedido"
                   tt_file_import.tta_num_pedido = int(ENTRY(1,v_des_reg_import,";")).
        END.

        IF  v_opcao = 3 THEN DO:
            ASSIGN v_num_line = v_num_line + 1.

            IF  v_num_line = 1 THEN
                NEXT.

            CREATE tt_file_import.
            ASSIGN tt_file_import.tta_num_line    = v_num_line
                   tt_file_import.tta_tip_reg     = "cliente"
                   tt_file_import.tta_cdn_cliente = int(ENTRY(1,v_des_reg_import,";")).
        END.
    END.

    ASSIGN v_num_line = 0.

    IF  v_opcao = 1 THEN DO:
        PUT STREAM s_1 UNFORMATTED ";;;;;;;Envio T°tulos DEPS" SKIP.
        PUT STREAM s_1 UNFORMATTED "Sequància;Id Titulo;Estabelecimento;EspÇcie;SÇrie;T°tulo;Parcela;Cliente;Status" SKIP.
    END.

    IF  v_opcao = 2 THEN DO:
        PUT STREAM s_1 UNFORMATTED ";;;;;;;Completa Pedidos DEPS" SKIP.
        PUT STREAM s_1 UNFORMATTED "Sequància;Num Pedido;Status" SKIP.
    END.

    IF  v_opcao = 3 THEN DO:
        PUT STREAM s_1 UNFORMATTED ";;;;;;;Atualiza Clientes DEPS" SKIP.
        PUT STREAM s_1 UNFORMATTED "Sequància;Cliente;Status" SKIP.
    END.

    FOR EACH tt_file_import NO-LOCK:

        IF  tt_file_import.tta_tip_reg = "tit_acr_id" THEN DO:
            RUN pi_tit_acr_id.
        END.

        IF  tt_file_import.tta_tip_reg = "tit_acr_chave" THEN DO:
            RUN pi_tit_acr_chave.
        END.

        IF  tt_file_import.tta_tip_reg = "pedido" THEN DO:
            RUN pi_pedido.
        END.

        IF  tt_file_import.tta_tip_reg = "cliente" THEN DO:
            RUN pi_cliente.
        END.

    END.
    
    RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi_tit_acr_id:

    FOR EACH estabelecimento 
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar NO-LOCK:

        FIND FIRST tit_acr
            WHERE tit_acr.cod_estab       = estabelecimento.cod_estab
            AND   tit_acr.num_id_tit_acr  = tt_file_import.tta_num_id_tit_acr NO-LOCK NO-ERROR.

        IF  AVAIL tit_acr THEN DO:
            RUN pi-acompanhar IN h-acomp (INPUT "Enviando titulo, cod_tit_acr: " + tit_acr.cod_tit_acr).

            IF  tit_acr.ind_tip_espec_docto <> "Normal"
            and tit_acr.ind_tip_espec_docto <> "Antecipaá∆o" THEN
                NEXT.

            FIND FIRST tit_acr_deps
                WHERE tit_acr_deps.cod_estab      = tit_acr.cod_estab      
                AND   tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

            IF  NOT AVAIL tit_acr_deps THEN DO:

                CREATE tit_acr_deps.
                ASSIGN tit_acr_deps.cod_estab      = tit_acr.cod_estab
                       tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr
                       tit_acr_deps.dat_gerac      = TODAY.

                ASSIGN tit_acr_deps.log_integra    = NO.

            END.
            ELSE DO:
                ASSIGN tit_acr_deps.dat_gerac   = TODAY
                       tit_acr_deps.log_integra = NO.
            END.

            PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)       + ";" +
                                       string(tt_file_import.tta_num_id_tit_acr) + ";" +
                                       tit_acr.cod_estab                         + ";" + 
                                       tit_acr.cod_espec_docto                   + ";" + 
                                       tit_acr.cod_ser_docto                     + ";" +
                                       tit_acr.cod_tit_acr                       + ";" + 
                                       tit_acr.cod_parcela                       + ";" +
                                       tit_acr.nom_abrev                         + ";" +
                                       "OK" SKIP.          
        END.
        ELSE
            PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)         + ";" +
                                       string(tt_file_import.tta_num_id_tit_acr)   + ";" +
                                       estabelecimento.cod_estab                   + ";" + 
                                       tt_file_import.tta_cod_espec_docto          + ";" + 
                                       tt_file_import.tta_cod_ser_docto            + ";" +
                                       tt_file_import.tta_cod_tit_acr              + ";" + 
                                       tt_file_import.tta_cod_parcela              + ";" +
                                       ""                                          + ";" +
                                       "T°tulo n∆o existente para a chave informada." SKIP.   
    END.

END PROCEDURE.

PROCEDURE pi_tit_acr_chave:
    FIND FIRST tit_acr
        WHERE tit_acr.cod_estab       = tt_file_import.tta_cod_estab      
        AND   tit_acr.cod_espec_docto = tt_file_import.tta_cod_espec_docto
        AND   tit_acr.cod_ser_docto   = tt_file_import.tta_cod_ser_docto  
        AND   tit_acr.cod_tit_acr     = tt_file_import.tta_cod_tit_acr    
        AND   tit_acr.cod_parcela     = tt_file_import.tta_cod_parcela NO-LOCK NO-ERROR.

    IF  AVAIL tit_acr THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Enviando titulo, cod_tit_acr: " + tit_acr.cod_tit_acr).

        IF  tit_acr.ind_tip_espec_docto <> "Normal"
        AND tit_acr.ind_tip_espec_docto <> "Antecipaá∆o" THEN
            NEXT.

        FIND FIRST tit_acr_deps
            WHERE tit_acr_deps.cod_estab      = tit_acr.cod_estab      
            AND   tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL tit_acr_deps THEN DO:

            CREATE tit_acr_deps.
            ASSIGN tit_acr_deps.cod_estab      = tit_acr.cod_estab
                   tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr
                   tit_acr_deps.dat_gerac      = TODAY.
            
            ASSIGN tit_acr_deps.log_integra    = NO.
            
        END.
        ELSE DO:
            ASSIGN tit_acr_deps.dat_gerac   = TODAY
                   tit_acr_deps.log_integra = NO.
        END.   

        PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)       + ";" +
                                   string(tt_file_import.tta_num_id_tit_acr) + ";" +
                                   tt_file_import.tta_cod_estab              + ";" + 
                                   tt_file_import.tta_cod_espec_docto        + ";" + 
                                   tt_file_import.tta_cod_ser_docto          + ";" +
                                   tt_file_import.tta_cod_tit_acr            + ";" + 
                                   tt_file_import.tta_cod_parcela            + ";" +
                                   ""                                        + ";" +
                                   "OK" SKIP.          
    END.
    ELSE
        PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)       + ";" +
                                   string(tt_file_import.tta_num_id_tit_acr) + ";" +
                                   tt_file_import.tta_cod_estab              + ";" + 
                                   tt_file_import.tta_cod_espec_docto        + ";" + 
                                   tt_file_import.tta_cod_ser_docto          + ";" +
                                   tt_file_import.tta_cod_tit_acr            + ";" + 
                                   tt_file_import.tta_cod_parcela            + ";" +
                                   ""                                        + ";" +
                                   "T°tulo n∆o existente para a chave informada." SKIP.   
END PROCEDURE.

PROCEDURE pi_pedido:
    ASSIGN v_num_line = v_num_line + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Completando pedidos - seq: " + string(v_num_line)).

    FIND FIRST ped-venda 
        WHERE ped-venda.nr-pedido = tt_file_import.tta_num_pedido EXCLUSIVE-LOCK NO-ERROR.
    
    IF  AVAIL ped-venda THEN DO:
        ASSIGN ped-venda.completo = NO.
        
        EMPTY TEMP-TABLE RowErrors.
        
        run dibo/bodi159com.p persistent set h-bodi159cal.
        
        run completeOrder in h-bodi159cal (input rowid(ped-venda), 
                                           output table RowErrors).
    
        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            for each RowErrors no-lock
                where RowErrors.ErrorNumber <> 8259: /** crÇdito n∆o aprovado **/
                PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line) + ";" +
                                           string(ped-venda.nr-pedido)         + ";" + 
                                           RowErrors.ErrorDescription SKIP.  
            end.
        END.
        ELSE DO:
            PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line) + ";" +
                                       string(ped-venda.nr-pedido)         + ";" + 
                                       "OK" SKIP.   
        END.

        DELETE PROCEDURE h-bodi159cal.
        
        ASSIGN h-bodi159cal = ?.
    END.
    ELSE
        PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)   + ";" +
                                   string(tt_file_import.tta_num_pedido) + ";" + 
                                   "Pedido inexistente para chave informada." SKIP.  

    FIND CURRENT ped-venda NO-LOCK NO-ERROR.
    
    RELEASE ped-venda.
END PROCEDURE.

PROCEDURE pi_cliente:
    FIND FIRST emitente
        WHERE emitente.cod-emit = tt_file_import.tta_cdn_cliente EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL emitente THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Atualizando clientes: " + string(emitente.cod-emit)).

        ASSIGN emitente.ind-lib-estoque   = YES
               emitente.user-libcre       = "DEPS"
               emitente.ind-aval          = 1
               emitente.ind-aval-embarque = 2.
    
        IF  emitente.lim-credito > 0 THEN
            ASSIGN emitente.ind-cre-cli = 1.
        ELSE
            ASSIGN emitente.ind-cre-cli = 5.

        PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line) + ";" +
                                   string(emitente.cod-emit)           + ";" + 
                                   "OK" SKIP.  
    END.
    ELSE
        PUT STREAM s_1 UNFORMATTED string(tt_file_import.tta_num_line)   + ";" +
                                  string(tt_file_import.tta_cdn_cliente) + ";" + 
                                 "Cliente inexistente para chave informada." SKIP.  

END PROCEDURE.

PROCEDURE pi_show_report_2:
    def Input param p_cod_dwb_file as character format "x(40)" no-undo.
    
    def var v_cod_key_value as character format "x(8)":U no-undo.

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or  v_cod_key_value = ? then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.

END PROCEDURE.

PROCEDURE pi_filename_validation:
    def Input param p_cod_filename as character format "x(40)" no-undo.
    
    def var v_cod_1  as character no-undo.
    def var v_cod_2  as character no-undo.
    def var v_num_1  as integer   no-undo.
    def var v_num_2  as integer   no-undo.

    if  p_cod_filename = "" or p_cod_filename = "." then do:
        return "NOK" .
    end.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0 then do:
            return "NOK" .
        end.
    end.

    if  num-entries(v_cod_1, ":") > 2 then do:
        return "NOK" .
    end.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1 then do:
        return "NOK" .
    end.

    if  num-entries(v_cod_1, ".") > 2 then do:
        return "NOK" .
    end.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3 then do:
        return "NOK" .
    end.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0 then do:
        return "NOK" .
    end.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = "" then do:
           return "NOK" .
        end.
    end.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0 then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end.
    end.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK".
END PROCEDURE.

PROCEDURE pi_wait_processing:
    def Input param p_des_message     as CHARACTER format "x(40)" no-undo.
    def Input param p_nom_frame_title as CHARACTER format "x(32)" no-undo.

    if  p_nom_frame_title <> ? or
       frame f_dlg_02_wait_processing:visible = no then do:
        if  p_nom_frame_title <> "" then do:
            assign frame f_dlg_02_wait_processing:title = p_nom_frame_title.
        end.
        else do:
            assign frame f_dlg_02_wait_processing:title = "Aguarde, em processamento...".
        end.
        assign ed_1x40:width-chars in frame f_dlg_02_wait_processing = 60.
    end.
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
