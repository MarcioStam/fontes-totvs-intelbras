/*****************************************************************************
** Nome Externo..........: esp/apb/esapb023.p
** Descricao.............: Listar movimentaá‰es m¢dulos
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 22/03/2010
*****************************************************************************/

def var c-versao-prg as char initial " 5.01.00.000":U no-undo.

/************************** Buffer Definition Begin *************************/

def buffer b_ped_exec_style
    for ped_exec.
def buffer b_servid_exec_style
    for servid_exec.
def buffer b_tit_ap_export
    for tit_ap.
def buffer b_val_movto_ap
    for val_movto_ap.

/*************************** Buffer Definition End **************************/

def temp-table tt_converter_finalid_econ_apl no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transaá∆o" column-label "Transaá∆o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Projeá∆o" column-label "G/P Projeá∆o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers∆o" column-label "Forma Convers∆o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros_apl_1              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm_apl                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_dat_transacao_ini AS DATE INITIAL TODAY FORMAT "99/99/9999"      NO-UNDO.
DEFINE VARIABLE v_dat_transacao_fim AS DATE INITIAL TODAY FORMAT "99/99/9999"      NO-UNDO.

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim AS CHARACTER FORMAT "x(03)" NO-UNDO.

DEFINE VARIABLE v_log_acr AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES VIEW-AS TOGGLE-BOX LABEL "ACR" NO-UNDO.
DEFINE VARIABLE v_log_apb AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES VIEW-AS TOGGLE-BOX LABEL "APB" NO-UNDO.
DEFINE VARIABLE v_log_cmg AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES VIEW-AS TOGGLE-BOX LABEL "CMG" NO-UNDO.
DEFINE VARIABLE v_log_apl AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES VIEW-AS TOGGLE-BOX LABEL "APL" NO-UNDO.
DEFINE VARIABLE v_log_fas AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES VIEW-AS TOGGLE-BOX LABEL "FAS" NO-UNDO.

DEFINE VARIABLE v_cod_return AS CHARACTER   NO-UNDO.

def new shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new shared var v_cod_dwb_program
    as character
    format "x(32)":U
    label "Programa"
    column-label "Programa"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_log_print
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_integer
    as character
    format "x(30)":U
    no-undo.
def var v_num_ped_exec
    as integer
    format ">>>>9":U
    label "Pedido"
    column-label "Pedido"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.

/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_run
    size 1 by 1
    edge-pixels 2.
def rectangle rt_target
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.

/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_cod_dwb_output
    as character
    initial "Arquivo"
    view-as radio-set Horizontal
    radio-buttons "Arquivo", "Arquivo"
    bgcolor 8 
    no-undo.
def var rs_ind_run_mode
    as character
    initial "On-Line"
    view-as radio-set VERTICAL
    radio-buttons "On-Line", "On-Line","Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    no-undo.

/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_rpt_41_tit_ap_consistencia
    rt_001
         at row 01.50 col 02.00
    " Faixas " view-as text
         at row 01.20 col 04.00 bgcolor 8 
    rt_002
         at row 04.8 col 02.00
    " Filtro " view-as text
         at row 04.6 col 04.00 bgcolor 8 
    rt_target
         at row 06.50 col 02.00
    " Destino " view-as text
         at row 06.30 col 04.00 bgcolor 8 
    rt_run
         at row 06.50 col 48.00
    " Execuá∆o " view-as text
         at row 06.30 col 50.00
    rt_cxcf
         at row 9.7 col 02.00 bgcolor 7 
    v_cod_estab_ini
         at row 02 col 15.14 colon-aligned label "Estab"
         help "Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         at row 02 col 31.29 colon-aligned label "atÇ"
         help "Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_ini
         at row 03 col 15.14 colon-aligned label "Data Transaá∆o"
         help "Data de Transaá∆o Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_fim
         at row 03 col 31.29 colon-aligned label "atÇ"
         help "Data de Transaá∆o Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_acr
         at row 05.29 col 05
    v_log_apb
         at row 05.29 col 15
    v_log_cmg
         at row 05.29 col 25
    v_log_apl
         at row 05.29 col 35
    rs_cod_dwb_output
         at row 07 col 03.00
         help "" no-label
    rs_ind_run_mode
         at row 07.3 col 49.00
         help "" no-label
    ed_1x40
         at row 08 col 03.00
         help "" no-label
    bt_get_file
         at row 08 col 42.50 font ?
         help "Pesquisa Arquivo"
    bt_print
         at row 10 col 03.00 font ?
         help "Imprime"
    bt_can
         at row 10 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 63.00 by 11.5
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Relaá∆o Movimentos M¢dulos - esapb023".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_tit_ap_consistencia = 10.00
           bt_can:height-chars         in frame f_rpt_41_tit_ap_consistencia = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_tit_ap_consistencia = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_tit_ap_consistencia = 01.08
           bt_print:width-chars        in frame f_rpt_41_tit_ap_consistencia = 10.00
           bt_print:height-chars       in frame f_rpt_41_tit_ap_consistencia = 01.00
           ed_1x40:width-chars         in frame f_rpt_41_tit_ap_consistencia = 39.00
           ed_1x40:height-chars        in frame f_rpt_41_tit_ap_consistencia = 01.00
           rt_001:width-chars          in frame f_rpt_41_tit_ap_consistencia = 60.00
           rt_001:height-chars         in frame f_rpt_41_tit_ap_consistencia = 03
           rt_002:width-chars          in frame f_rpt_41_tit_ap_consistencia = 60.00
           rt_002:height-chars         in frame f_rpt_41_tit_ap_consistencia = 01.5
           rt_cxcf:width-chars         in frame f_rpt_41_tit_ap_consistencia = 59.57
           rt_cxcf:height-chars        in frame f_rpt_41_tit_ap_consistencia = 01.42
           rt_run:width-chars          in frame f_rpt_41_tit_ap_consistencia = 13.86
           rt_run:height-chars         in frame f_rpt_41_tit_ap_consistencia = 03.00
           rt_target:width-chars       in frame f_rpt_41_tit_ap_consistencia = 45.00
           rt_target:height-chars      in frame f_rpt_41_tit_ap_consistencia = 03.00.
    assign ed_1x40:return-inserted in frame f_rpt_41_tit_ap_consistencia = yes.

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign dwb_rpt_param.cod_dwb_file             = v_cod_dwb_file
               ed_1x40:screen-value in frame f_rpt_41_tit_ap_consistencia = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_ap_consistencia */

ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    if  input frame f_rpt_41_tit_ap_consistencia v_dat_transacao_ini > input frame f_rpt_41_tit_ap_consistencia v_dat_transacao_fim
    then do:
        apply "Entry" /*l_entry*/  to v_dat_transacao_ini in frame f_rpt_41_tit_ap_consistencia.
        run pi_messages (input "show",
                         input 6883,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6883*/.
        return no-apply.
    end /* if */.

    assign v_log_print = YES.

END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_ap_consistencia */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_tit_ap_consistencia:
        if  rs_cod_dwb_output:screen-value = "Arquivo" /*l_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
                if  ed_1x40:screen-value <> ""
                then do:
                    assign ed_1x40:screen-value   = replace(ed_1x40:screen-value, '~\', '/')
                           v_cod_filename_initial = entry(num-entries(ed_1x40:screen-value, '/'), ed_1x40:screen-value, '/')
                           v_cod_filename_final   = substring(ed_1x40:screen-value, 1,
                                                              length(ed_1x40:screen-value) - length(v_cod_filename_initial) - 1)
                           file-info:file-name    = v_cod_filename_final.

                    if  file-info:file-type = ?
                    then do:
                         /* O diret¢rio &1 n∆o existe ! */
                         run pi_messages (input "show",
                                          input 4354,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                             v_cod_filename_final)) /*msg_4354*/.
                         return no-apply.
                    end /* if */.
                end /* if */.
            end /* if */.

            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            assign dwb_rpt_param.cod_dwb_file = ed_1x40:screen-value.
        end /* if */.
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_ap_consistencia */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    initout:
    do with frame f_rpt_41_tit_ap_consistencia:
        /* block: */
        case self:screen-value:
            when "Arquivo" /*l_file*/ then fil:
             do:
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = yes
                       bt_get_file:visible    = yes.

                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
                     use-index srmstr_id
                      /*cl_current_user of usuar_mestre*/ no-error.
                do  transaction:                
                    find dwb_rpt_param
                        where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                        and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                        exclusive-lock no-error.

                    assign dwb_rpt_param.cod_dwb_file = "".

                    if  rs_ind_run_mode:screen-value in frame f_rpt_41_tit_ap_consistencia <> "Batch" /*l_batch*/ 
                    then do:
                        if  usuar_mestre.nom_dir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = usuar_mestre.nom_dir_spool
                                                              + "~/".
                        end /* if */.
                        if  usuar_mestre.nom_subdir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                              + usuar_mestre.nom_subdir_spool
                                                              + "~/".
                        end /* if */.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file.
                    end /* else */.
                    if  v_cod_dwb_file_temp = ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + caps("esapb023":U)
                                                          + '.rpt'.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + v_cod_dwb_file_temp.
                    end /* else */.
                    assign ed_1x40:screen-value               = dwb_rpt_param.cod_dwb_file
                           dwb_rpt_param.cod_dwb_print_layout = "".
                end.     
            end /* do fil */.
        end /* case block */.

        assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
        if  index(v_cod_dwb_file_temp, "~/") <> 0
        then do:
            assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
        end /* if */.
        else do:
            assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
        end /* else */.
    end /* do initout */.

    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_ap_consistencia */

ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_ap_consistencia
DO:

    do  transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.ind_dwb_run_mode = input frame f_rpt_41_tit_ap_consistencia rs_ind_run_mode.

        assign rs_ind_run_mode.
        apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_ap_consistencia.
    end.    

END. /* ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_ap_consistencia */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON GO OF FRAME f_rpt_41_tit_ap_consistencia
DO:

    do transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.cod_dwb_output     = rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_ap_consistencia.
        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:

             run pi_filename_validation (Input dwb_rpt_param.cod_dwb_file) /*pi_filename_validation*/.

             if  return-value = "NOK" /*l_nok*/ 
             then do:
                 /* Nome do arquivo incorreto ! */
                 run pi_messages (input "show",
                                  input 1064,
                                  input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
                 return no-apply.
             end /* if */.
        end /* if */.
    end.    

END. /* ON GO OF FRAME f_rpt_41_tit_ap_consistencia */

ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_consistencia
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_ap_consistencia */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

run pi_return_user (output v_cod_dwb_user) /*pi_return_user*/.

run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.
if (v_cod_dwb_user = "") then
   assign v_cod_dwb_user = v_cod_usuar_corren.

run prgtec/men/men901za.py (Input 'esapb023') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb023')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb023')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */

/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul    = 'esapb023' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'esapb023'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "esapb023":U
    no-lock no-error.

/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_tit_ap_consistencia:title = frame f_rpt_41_tit_ap_consistencia:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.01.00.000":U)
                            + chr(41).

/* inicializa vari†veis */
find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.

assign v_cod_dwb_program  = "esapb023":U.

if  v_cod_dwb_user begins 'es_'
then do:
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if (not avail dwb_rpt_param) then
        return "ParÉmetros para o relat¢rio n∆o encontrado." /*1993*/ + " (" + "1993" + ")" + chr(10) + "N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio corrente." /*1993*/.
    if index( dwb_rpt_param.cod_dwb_file ,'~\') <> 0 then
        assign file-info:file-name = replace(dwb_rpt_param.cod_dwb_file, '~\', '~/').
    else
        assign file-info:file-name = dwb_rpt_param.cod_dwb_file.

    assign file-info:file-name = substring(file-info:file-name, 1,
                                           r-index(file-info:file-name, '~/') - 1).
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
       if file-info:file-type = ? then
          return "Diret¢rio Inexistente:" /*l_directory*/  + dwb_rpt_param.cod_dwb_file.
    end /* if */.

    find ped_exec no-lock
         where ped_exec.num_ped_exec = v_num_ped_exec_corren /*cl_le_ped_exec_global of ped_exec*/ no-error.
    if (ped_exec.cod_release_prog_dtsul <> trim(" 5.01.00.000":U)) then
        return "Vers‰es do programa diferente." /*1994*/ + " (" + "1994" + ")" + chr(10)
                                     + substitute("A vers∆o do programa (&3) que gerou o pedido de execuá∆o batch (&1) Ç diferente da vers∆o do programa que deveria executar o pedido batch (&2)." /*1994*/,ped_exec.cod_release_prog_dtsul,
                                                  trim(" 5.01.00.000":U),
                                                  "esp/apb/esapb023.p":U).
    assign v_cod_dwb_file     = dwb_rpt_param.cod_dwb_file.

    /* Begin_Include: ix_p02_rpt_tit_ap_consistencia */
    find FIRST servid_exec no-lock 
        where servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR. 
    find FIRST usuar_mestre no-lock 
        where usuar_mestre.cod_usuario = ped_exec.cod_usuario no-error.       

    assign v_dat_transacao_ini = date(entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_dat_transacao_fim = date(entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cod_estab_ini     =      entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_cod_estab_fim     =      entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10))
           v_log_acr           =     (entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_apb           =     (entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_cmg           =     (entry(7, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
           v_log_apl           =     (entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes") NO-ERROR.

    output stream s_1 to value(v_cod_dwb_file) convert target 'iso8859-1'.

    run pi_rpt_movtos.

    output stream s_1 close.

    return "OK" /*l_ok*/ .

end /* if */.

pause 0 before-hide.
view frame f_rpt_41_tit_ap_consistencia.

super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    param_block:
    do transaction:

        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
        if  not available dwb_rpt_param
        then do:
            create dwb_rpt_param.
            assign dwb_rpt_param.cod_dwb_program         = v_cod_dwb_program
                   dwb_rpt_param.cod_dwb_user            = v_cod_dwb_user
                   dwb_rpt_param.cod_dwb_output          = "Arquivo" 
                   dwb_rpt_param.ind_dwb_run_mode        = "On-Line"
                   dwb_rpt_param.cod_dwb_file            = ""
                   dwb_rpt_param.nom_dwb_printer         = ""
                   dwb_rpt_param.cod_dwb_print_layout    = ""
                   v_cod_dwb_file_temp                   = "".
        end /* if */.
    end /* do param_block */.

    init:
    do with frame f_rpt_41_tit_ap_consistencia:
        assign rs_cod_dwb_output:screen-value   = dwb_rpt_param.cod_dwb_output
               rs_ind_run_mode:screen-value     = dwb_rpt_param.ind_dwb_run_mode.

        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
            assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
            if (index(v_cod_dwb_file_temp, "~/") <> 0) then
                assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
            else
                assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
            assign ed_1x40:screen-value = v_cod_dwb_file_temp.
        end /* if */.

    end /* do init */.

    enable rs_cod_dwb_output
           bt_get_file
           bt_print
           bt_can
           with frame f_rpt_41_tit_ap_consistencia.

    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_ap_consistencia.


    if  yes = yes
    then do:
       enable rs_ind_run_mode
              with frame f_rpt_41_tit_ap_consistencia.
       apply "value-changed" to rs_ind_run_mode in frame f_rpt_41_tit_ap_consistencia.
    end /* if */.



    /* Begin_Include: ix_p10_rpt_tit_ap_consistencia */
    if num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 5 
    then do:
         assign v_dat_transacao_ini = date(entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_dat_transacao_fim = date(entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_cod_estab_ini     =      entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cod_estab_fim     =      entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_log_acr           =     (entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
                v_log_apb           =     (entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
                v_log_cmg           =     (entry(7, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes")
                v_log_apl           =     (entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes") NO-ERROR.
    END.

    display v_dat_transacao_fim
            v_dat_transacao_ini
            v_cod_estab_ini
            v_cod_estab_fim
            v_log_acr
            v_log_apb
            v_log_cmg
            v_log_apl
            with frame f_rpt_41_tit_ap_consistencia.
    enable v_dat_transacao_fim
           v_dat_transacao_ini
           v_cod_estab_ini
           v_cod_estab_fim
           v_log_acr
           v_log_apb
           v_log_cmg
           v_log_apl
           with frame f_rpt_41_tit_ap_consistencia.

    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_tit_ap_consistencia:

            if (retry) then
                output stream s_1 close.
            assign v_log_print = no.

            wait-for go of frame f_rpt_41_tit_ap_consistencia.

            param_block:
            do transaction:

                /* Begin_Include: ix_p15_rpt_tit_ap_consistencia */
                assign input frame f_rpt_41_tit_ap_consistencia ed_1x40
                       input frame f_rpt_41_tit_ap_consistencia rs_cod_dwb_output
                       input frame f_rpt_41_tit_ap_consistencia rs_ind_run_mode
                       input frame f_rpt_41_tit_ap_consistencia v_dat_transacao_fim
                       input frame f_rpt_41_tit_ap_consistencia v_dat_transacao_ini
                       input frame f_rpt_41_tit_ap_consistencia v_cod_estab_ini                    
                       input frame f_rpt_41_tit_ap_consistencia v_cod_estab_fim                    
                       input frame f_rpt_41_tit_ap_consistencia v_log_acr
                       input frame f_rpt_41_tit_ap_consistencia v_log_apb
                       input frame f_rpt_41_tit_ap_consistencia v_log_cmg
                       input frame f_rpt_41_tit_ap_consistencia v_log_apl.

                assign dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_41_tit_ap_consistencia rs_ind_run_mode.

                assign dwb_rpt_param.cod_dwb_parameters = string( v_dat_transacao_ini )  + chr(10) +
                                                          string( v_dat_transacao_fim )  + chr(10) +
                                                                  v_cod_estab_ini        + chr(10) +             
                                                                  v_cod_estab_fim        + chr(10) +             
                                                          string( v_log_acr           )  + chr(10) +
                                                          string( v_log_apb           )  + chr(10) +
                                                          string( v_log_cmg           )  + chr(10) +
                                                          string( v_log_apl           ).                      
            end /* do param_block */.

            if  v_log_print = yes
            then do:
                if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
                then do:
                   if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
                   then do:
                       assign v_cod_dwb_file = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/")
                              v_nom_integer = v_cod_dwb_file.
                       if  index(v_cod_dwb_file, ":") <> 0
                       then do:
                           /* Nome de arquivo com problemas. */
                           run pi_messages (input "show",
                                            input 1979,
                                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                           next main_block.
                       end /* if */.

                       file_1:
                       do
                          while index(v_cod_dwb_file,"~/") <> 0:
                          assign v_cod_dwb_file = substring(v_cod_dwb_file,(index(v_cod_dwb_file,"~/" ) + 1)).
                       end /* do file_1 */.

                       /* valname: */
                       case num-entries(v_cod_dwb_file,"."):
                           when 1 then
                               if  length(v_cod_dwb_file) > 8
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           when 2 then
                               if  length(entry(1, v_cod_dwb_file, ".")) > 8
                               or length(entry(2, v_cod_dwb_file, ".")) > 3
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           otherwise other:
                                     do:
                               /* Nome de arquivo com problemas. */
                               run pi_messages (input "show",
                                                input 1979,
                                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                               next main_block.
                           end /* do other */.
                       end /* case valname */.
                   end /* if */.

                   assign v_cod_dwb_file = v_nom_integer.
                   if  search("prgtec/btb/btb911za.r") = ? and search("prgtec/btb/btb911za.p") = ? then do:
                       if  v_cod_dwb_user begins 'es_' then
                           return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb911za.p".
                       else do:
                           message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb911za.p"
                                  view-as alert-box error buttons ok.
                           return.
                       end.
                   end.
                   else
                       run prgtec/btb/btb911za.p (Input v_cod_dwb_program,
                                              Input "5.01.00.000",
                                              Input 41,
                                              Input recid(dwb_rpt_param),
                                              output v_num_ped_exec) /*prg_fnc_criac_ped_exec*/.
                   if (v_num_ped_exec <> 0) then
                       leave main_block.
                   else
                       next main_block.
                end /* if */.
                else do:
                    assign v_log_method = session:set-wait-state('general').
                    /* out_def: */
                    case dwb_rpt_param.cod_dwb_output:
                        when "Arquivo" /*l_file*/ then out_file:
                         do:
                            assign v_cod_dwb_file   = dwb_rpt_param.cod_dwb_file.
                            output stream s_1 to value(v_cod_dwb_file) convert target 'iso8859-1'.
                        end /* do out_file */.
                    end /* case out_def */.
                    run pi_rpt_movtos.
                end /* else */.
                output stream s_1 close.

                assign v_log_method = session:set-wait-state("").

                leave main_block.

            end /* if */.
            else do:
                leave super_block.
            end /* else */.

        end /* repeat main_block */.

        if  v_num_ped_exec <> 0
        then do:
            /* Criado pedido &1 para execuá∆o batch. */
            run pi_messages (input "show",
                             input 3556,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_ped_exec)) /*msg_3556*/.
            assign v_num_ped_exec = 0.
        end /* if */.

    end /* repeat block1 */.
end /* repeat super_block */.

/* ix_p40_rpt_tit_ap_consistencia */

hide frame f_rpt_41_tit_ap_consistencia.

/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */


if  this-procedure:persistent then
    delete procedure this-procedure.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_return_user
** Descricao.............: pi_return_user
*****************************************************************************/
PROCEDURE pi_return_user:

    /************************ Parameter Definition Begin ************************/

    def output param p_nom_user
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_nom_user = v_cod_usuar_corren.

    if  v_cod_usuar_corren begins 'es_'
    then do:
       assign v_cod_usuar_corren = entry(2,v_cod_usuar_corren,"_").
    end /* if */.

END PROCEDURE. /* pi_return_user */
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
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
/*****************************************************************************
** Procedure Interna.....: pi_rpt_movtos
** Descricao.............: pi_rpt_movtos
*****************************************************************************/
PROCEDURE pi_rpt_movtos:

    DEFINE VARIABLE v_dat_aux               AS DATE        NO-UNDO.
    DEFINE VARIABLE v_des_text_histor       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_val_aprop_ctbl        LIKE val_aprop_ctbl_ap.val_aprop NO-UNDO.

    PUT STREAM s_1 UNFORMATTED "modulo;estab;espec;ser;tit;parc;fornec/clien;CPF/CGC;nom_abrev;moeda;val_origin;dat_vencto;dat_transacao;cod_refer;trans_abrev;trans;usuario;nome;val_movto;tip_aprop;natur_lancto;cta_ctbl;des_cta;ccusto;des_ccusto;unid_negoc;val_aprop REAL;historico" SKIP.
  
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa  = v_cod_empres_usuar
          AND estabelecimento.cod_estab   >= v_cod_estab_ini
          AND estabelecimento.cod_estab   <= v_cod_estab_fim:
  
        REPEAT v_dat_aux = v_dat_transacao_ini TO v_dat_transacao_fim:
  
            IF v_log_apb
            THEN DO:

                 FOR EACH movto_tit_ap NO-LOCK
                     WHERE movto_tit_ap.cod_estab     = estabelecimento.cod_estab
                       AND movto_tit_ap.dat_transacao = v_dat_aux: 

                     FIND emscad.fornecedor 
                         WHERE emscad.fornecedor.cod_empresa = movto_tit_ap.cod_empresa 
                           AND emscad.fornecedor.cdn_fornec  = movto_tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.
                     FIND fornec_financ 
                         WHERE fornec_financ.cod_empresa = movto_tit_ap.cod_empresa
                           AND fornec_financ.cdn_fornec  = movto_tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.
                     FIND FIRST histor_tit_movto_ap NO-LOCK 
                          WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                            AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap
                            AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                            AND histor_tit_movto_ap.ind_orig_histor_ap <> "Erro" NO-ERROR.

                     IF AVAIL histor_tit_movto_ap 
                        THEN ASSIGN v_des_text_histor = REPLACE(histor_tit_movto_ap.des_text_histor, CHR(10), " ")
                                    v_des_text_histor = REPLACE(v_des_text_histor, ";", " ").
                        ELSE ASSIGN v_des_text_histor = "".

                     FIND tit_ap NO-LOCK 
                         WHERE tit_ap.cod_estab     = movto_tit_ap.cod_estab
                           AND tit_ap.num_id_tit_ap = movto_tit_ap.num_id_tit_ap NO-ERROR.

                     FIND usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = movto_tit_ap.cod_usuario NO-ERROR.

                     FOR EACH aprop_ctbl_ap NO-LOCK
                         WHERE aprop_ctbl_ap.cod_estab           = movto_tit_ap.cod_estab
                           AND aprop_ctbl_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap:
      
                           FIND cta_ctbl NO-LOCK
                               WHERE cta_ctbl.cod_plano_cta = 'padrao'
                                 AND cta_ctbl.cod_cta_ctbl  = aprop_ctbl_ap.cod_cta_ctbl.
                           FIND emscad.ccusto NO-LOCK
                               WHERE emscad.ccusto.cod_plano_ccusto = 'padrao'
                                 AND emscad.ccusto.cod_ccusto       = aprop_ctbl_ap.cod_ccusto NO-ERROR.
             
                           /* ** Tratamento para t°tulos implantados em outra moeda ***/
                           ASSIGN v_val_aprop_ctbl = aprop_ctbl_ap.val_aprop_ctbl.
                           IF aprop_ctbl_ap.cod_indic_econ <> 'real'
                           THEN DO:
                                ASSIGN v_val_aprop_ctbl = 0.
                                FOR EACH val_aprop_ctbl_ap OF aprop_ctbl_ap NO-LOCK:
                                    ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
                                END.
                           END.

                           PUT STREAM s_1  UNFORMATTED "APB;"
                                                       movto_tit_ap.cod_estab                                                              ";"
                                                       IF AVAIL tit_ap THEN tit_ap.cod_espec                                       ELSE "" ";"
                                                       IF AVAIL tit_ap THEN tit_ap.cod_ser                                         ELSE "" ";"
                                                       IF AVAIL tit_ap THEN tit_ap.cod_tit_ap                                      ELSE "" ";"
                                                       IF AVAIL tit_ap THEN tit_ap.cod_parcela                                     ELSE "" ";"
                                                       IF AVAIL tit_ap THEN STRING(tit_ap.cdn_fornec)                              ELSE "" ";"
                                                       IF AVAIL emscad.fornecedor THEN emscad.fornecedor.cod_id_feder                  ELSE "" ";"
                                                       IF AVAIL emscad.fornecedor THEN emscad.fornecedor.nom_abrev                     ELSE "" ";"
                                                       aprop_ctbl_ap.cod_indic_econ                                                        ";"
                                                       IF AVAIL tit_ap THEN STRING(tit_ap.val_origin_tit_ap, "->>,>>>,>>9.99")     ELSE "" ";"
                                                       IF AVAIL tit_ap THEN STRING(tit_ap.dat_vencto)                              ELSE "" ";"
                                                       movto_tit_ap.dat_transacao                                                          ";"
                                                       movto_tit_ap.cod_refer                                                              ";"
                                                       movto_tit_ap.ind_trans_ap_abrev                                                     ";"
                                                       movto_tit_ap.ind_trans_ap                                                           ";"
                                                       movto_tit_ap.cod_usuario                                                            ";"
                                                       usuar_mestre.nom_usuario                                                       ";"
                                                       STRING(movto_tit_ap.val_movto_ap, "->>,>>>,>>9.99")                                 ";"
                                                       aprop_ctbl_ap.ind_tip_aprop_ctbl                                                    ";"
                                                       aprop_ctbl_ap.ind_natur_lancto_ctbl                                                 ";"
                                                       aprop_ctbl_ap.cod_cta_ctbl                                                          ";"
                                                       cta_ctbl.des_tit                                                                    ";"
                                                       aprop_ctbl_ap.cod_ccusto                                                            ";"
                                                       IF AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl                          ELSE "" ";"
                                                       aprop_ctbl_ap.cod_unid_negoc                                                        ";"
                                                       STRING(v_val_aprop_ctbl, "->>,>>>,>>9.99")                                          ";"
                                                       v_des_text_histor                                                                   SKIP.

                     END.

                 END.

            END.
            
            IF v_log_acr
            THEN DO:

                 FOR EACH movto_tit_acr NO-LOCK
                     WHERE movto_tit_acr.cod_estab     = estabelecimento.cod_estab
                       AND movto_tit_acr.dat_transacao = v_dat_aux: 
    
                     FIND emscad.cliente 
                         WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                           AND emscad.cliente.cdn_clien   = movto_tit_acr.cdn_cliente NO-LOCK NO-ERROR.
                     FIND clien_financ 
                         WHERE clien_financ.cod_empresa = movto_tit_acr.cod_empresa
                           AND clien_financ.cdn_clien   = movto_tit_acr.cdn_cliente NO-LOCK NO-ERROR.
                     FIND FIRST histor_movto_tit_acr NO-LOCK 
                          WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                            AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                            AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                            AND histor_movto_tit_acr.ind_orig_histor_acr <> "Erro" NO-ERROR.
                
                     IF AVAIL histor_movto_tit_acr 
                        THEN ASSIGN v_des_text_histor = REPLACE(histor_movto_tit_acr.des_text_histor, CHR(10), " ")
                                    v_des_text_histor = REPLACE(v_des_text_histor, ";", " ").
                        ELSE ASSIGN v_des_text_histor = "".
                     
                     FIND tit_acr NO-LOCK 
                         WHERE tit_acr.cod_estab      = movto_tit_acr.cod_estab
                           AND tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-ERROR.
    
                     FIND usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = movto_tit_acr.cod_usuario NO-ERROR.
       
                     FOR EACH aprop_ctbl_acr NO-LOCK
                         WHERE aprop_ctbl_acr.cod_estab            = movto_tit_acr.cod_estab
                           AND aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr:
           
                           FIND cta_ctbl NO-LOCK
                               WHERE cta_ctbl.cod_plano_cta = 'padrao'
                                 AND cta_ctbl.cod_cta_ctbl  = aprop_ctbl_acr.cod_cta_ctbl.
                           FIND emscad.ccusto NO-LOCK
                               WHERE emscad.ccusto.cod_plano_ccusto = 'padrao'
                                 AND emscad.ccusto.cod_ccusto       = aprop_ctbl_acr.cod_ccusto NO-ERROR.
                  
                           /* ** Tratamento para t°tulos implantados em outra moeda ***/
                           ASSIGN v_val_aprop_ctbl = aprop_ctbl_acr.val_aprop_ctbl.
                           IF aprop_ctbl_acr.cod_indic_econ <> 'real'
                           THEN DO:
                                ASSIGN v_val_aprop_ctbl = 0.
                                FOR EACH val_aprop_ctbl_acr OF aprop_ctbl_acr NO-LOCK:
                                    ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + val_aprop_ctbl_acr.val_aprop.
                                END.
                           END.
                           
                           PUT STREAM s_1  UNFORMATTED "ACR;"
                                                       movto_tit_acr.cod_estab                                      ";"
                                                       tit_acr.cod_espec                                            ";"
                                                       tit_acr.cod_ser                                              ";"
                                                       tit_acr.cod_tit_acr                                          ";"
                                                       tit_acr.cod_parcela                                          ";"
                                                       STRING(tit_acr.cdn_cliente)                                  ";"
                                                       emscad.cliente.cod_id_feder                                    ";"
                                                       emscad.cliente.nom_abrev                                       ";"
                                                       aprop_ctbl_acr.cod_indic_econ                                ";"
                                                       STRING(tit_acr.val_origin_tit_acr, "->>,>>>,>>9.99")         ";"
                                                       STRING(tit_acr.dat_vencto_tit_acr)                           ";"
                                                       movto_tit_acr.dat_transacao                                  ";"
                                                       movto_tit_acr.cod_refer                                      ";"
                                                       movto_tit_acr.ind_trans_acr_abrev                            ";"
                                                       movto_tit_acr.ind_trans_acr                                  ";"
                                                       movto_tit_acr.cod_usuario                                    ";"
                                                       usuar_mestre.nom_usuario                                ";"
                                                       STRING(movto_tit_acr.val_movto_tit_acr, "->>,>>>,>>9.99")    ";"
                                                       aprop_ctbl_acr.ind_tip_aprop_ctbl                            ";"
                                                       aprop_ctbl_acr.ind_natur_lancto_ctbl                         ";"
                                                       aprop_ctbl_acr.cod_cta_ctbl                                  ";"
                                                       cta_ctbl.des_tit                                             ";"
                                                       aprop_ctbl_acr.cod_ccusto                                    ";"
                                                       IF AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl   ELSE "" ";"
                                                       aprop_ctbl_acr.cod_unid_negoc                                ";"
                                                       STRING(v_val_aprop_ctbl, "->>,>>>,>>9.99")                   ";"
                                                       v_des_text_histor                                            SKIP.

                     END.

                 END.

            END.

            IF v_log_cmg 
            THEN DO:

                 /* ** Movimentos Caixa e Bancos - CMG ***/
                 FOR EACH aprop_ctbl_cmg NO-LOCK
                     WHERE aprop_ctbl_cmg.cod_estab     = estabelecimento.cod_estab
                       AND aprop_ctbl_cmg.dat_transacao = v_dat_aux:

                     FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.

                     IF NOT AVAIL movto_cta_corren
                        THEN NEXT.

                     /* ** Tratamento para t°tulos implantados em outra moeda ***/
                     ASSIGN v_val_aprop_ctbl = aprop_ctbl_cmg.val_movto_cta_corren.
                     IF aprop_ctbl_cmg.cod_indic_econ <> 'real'
                     THEN DO:
                          ASSIGN v_val_aprop_ctbl = 0.
                          FOR EACH val_aprop_ctbl_cmg OF aprop_ctbl_cmg NO-LOCK:
                              ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + val_aprop_ctbl_cmg.val_movto_cta_corren.
                          END.
                     END.

                     FIND usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = movto_cta_corren.cod_usuar_ult NO-ERROR.

                     FIND cta_corren OF movto_cta_corren NO-LOCK NO-ERROR.
                     IF NOT AVAIL cta_corren 
                        THEN NEXT.

                     FIND cta_ctbl NO-LOCK
                         WHERE cta_ctbl.cod_plano_cta = 'padrao'
                           AND cta_ctbl.cod_cta_ctbl  = aprop_ctbl_cmg.cod_cta_ctbl.
                     FIND emscad.ccusto NO-LOCK
                         WHERE emscad.ccusto.cod_plano_ccusto = 'padrao'
                           AND emscad.ccusto.cod_ccusto       = aprop_ctbl_cmg.cod_ccusto NO-ERROR.

                     ASSIGN v_des_text_histor = REPLACE(movto_cta_corren.des_histor_movto_cta_corren, CHR(10), " ")
                            v_des_text_histor = REPLACE(v_des_text_histor, ";", " ").

                     PUT STREAM s_1  UNFORMATTED "CMG;"
                                                 cta_corren.cod_estab                                            ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 ""                                                              ";"
                                                 aprop_ctbl_cmg.cod_indic_econ                                   ";"
                                                 STRING(movto_cta_corren.val_movto_cta_corren, "->>,>>>,>>9.99") ";"
                                                 ""                                                              ";"
                                                 movto_cta_corren.dat_transacao                                  ";"
                                                 movto_cta_corren.cod_cta_corren                                 ";"
                                                 movto_cta_corren.cod_tip_trans_cx                               ";"
                                                 ""                                                              ";"
                                                 movto_cta_corren.cod_usuar_ult                                  ";"
                                                 usuar_mestre.nom_usuario                                   ";"
                                                 STRING(movto_cta_corren.val_movto_cta_corren, "->>,>>>,>>9.99") ";"
                                                 aprop_ctbl_cmg.ind_finalid_aprop_ctbl_cmg                       ";"
                                                 aprop_ctbl_cmg.ind_natur_lancto_ctbl                            ";"
                                                 aprop_ctbl_cmg.cod_cta_ctbl                                     ";"
                                                 cta_ctbl.des_tit                                                ";"
                                                 aprop_ctbl_cmg.cod_ccusto                                       ";"
                                                 IF AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl   ELSE ""    ";"
                                                 aprop_ctbl_cmg.cod_unid_negoc                                   ";"
                                                 STRING(v_val_aprop_ctbl, "->>,>>>,>>9.99")                      ";"
                                                 v_des_text_histor                                               SKIP.

                 END.
            END.


            /* ** quando precisar o m¢dulo FAS, refinar a l¢gica. Vai apresentar problema de performance por falta de °ndice de data ***/
            IF v_log_fas 
            THEN DO:

/*                    for each reg_calc_bem_pat no-lock
                        where reg_calc_bem_pat.cod_estab         = estabelecimento.cod_estab
                        and   reg_calc_bem_pat.cod_cenar_ctbl    = "FISCAL"
                        and   reg_calc_bem_pat.cod_finalid_econ  = "CORRENTE"
                        and   reg_calc_bem_pat.dat_calc_pat      = v_dat_aux:

                        blk_aprop:
                        for each aprop_ctbl_pat no-lock
                            where aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat:

                            if  v_log_funcao_selec_ccusto = no or
                               (v_log_funcao_selec_ccusto = yes and 
                                aprop_ctbl_pat.cod_plano_ccusto_db >= v_cod_plano_ccusto_ini and
                                aprop_ctbl_pat.cod_plano_ccusto_db <= v_cod_plano_ccusto_fim and
                                aprop_ctbl_pat.cod_ccusto_db       >= v_cod_ccusto_inicial   and
                                aprop_ctbl_pat.cod_ccusto_db       <= v_cod_ccusto_final)
                            then do:

                                if  not v_log_transf_ext then
                                    find tt_bem_pat_demonst_ctbz
                                        where tt_bem_pat_demonst_ctbz.tta_cod_estab              = reg_calc_bem_pat.cod_estab
                                        and   tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                        and   tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "DB" /*l_db*/ 
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_db
                                        no-lock no-error.
                                else
                                    find tt_bem_pat_demonst_ctbz
                                        where tt_bem_pat_demonst_ctbz.tta_cod_estab              = &if '{&emsfin_version}' >= '5.05'
                                                                                                   &then aprop_ctbl_pat.cod_estab
                                                                                                   &else aprop_ctbl_pat.cod_livre_1
                                                                                                   &endif
                                        and   tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                        and   tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "DB" /*l_db*/ 
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_db
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_db
                                        no-lock no-error.

                                if  not avail tt_bem_pat_demonst_ctbz
                                then do:
    .                       
                                    create tt_bem_pat_demonst_ctbz.
                                    assign tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                           tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "DB" /*l_db*/ 
                                           tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_db
                                           tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_db
                                           tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_db
                                           tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_db
                                           tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_db.
                                    if  not v_log_transf_ext then
                                        assign tt_bem_pat_demonst_ctbz.tta_cod_estab = reg_calc_bem_pat.cod_estab.
                                    else
                                        assign tt_bem_pat_demonst_ctbz.tta_cod_estab = &if '{&emsfin_version}' >= '5.05'
                                                                                       &then aprop_ctbl_pat.cod_estab
                                                                                       &else aprop_ctbl_pat.cod_livre_1
                                                                                       &endif.                                
                                end /* if */.
                                assign tt_bem_pat_demonst_ctbz.tta_val_aprop_ctbl = tt_bem_pat_demonst_ctbz.tta_val_aprop_ctbl +(if v_val_ajust_dec_chi_return <> 0 then
                                                                                                                                    v_val_movto_return 
                                                                                                                                 else 
                                                                                                                                    aprop_ctbl_pat.val_lancto_ctbl).
                                run pi_trata_dec_bem_pat_demonst_ctbz /*pi_trata_dec_bem_pat_demonst_ctbz*/.             
                                if  v_log_funcao_det_por_bem and v_log_detdo = yes
                                then do:
                                    create tt_bem_pat_demonst_ctbz_son.
                                    assign tt_bem_pat_demonst_ctbz_son.tta_cod_estab              = tt_bem_pat_demonst_ctbz.tta_cod_estab
                                           tt_bem_pat_demonst_ctbz_son.tta_des_histor_lancto_ctbl = tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl
                                           tt_bem_pat_demonst_ctbz_son.tta_ind_natur_lancto_ctbl  = tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl 
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_plano_cta_ctbl     = tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl    
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_cta_ctbl           = tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl          
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_plano_ccusto       = tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto      
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_ccusto             = tt_bem_pat_demonst_ctbz.tta_cod_ccusto            
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_unid_negoc         = tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc        
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_cta_pat            = bem_pat.cod_cta_pat   
                                           tt_bem_pat_demonst_ctbz_son.tta_num_bem_pat            = bem_pat.num_bem_pat  
                                           tt_bem_pat_demonst_ctbz_son.tta_num_seq_bem_pat        = bem_pat.num_seq_bem_pat
                                           tt_bem_pat_demonst_ctbz_son.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                           tt_bem_pat_demonst_ctbz_son.tta_val_lancto_ctbl        = (if v_val_ajust_dec_chi_return <> 0 then
                                                                                                        v_val_movto_return 
                                                                                                     else 
                                                                                                        aprop_ctbl_pat.val_lancto_ctbl).

                                end /* if */.

                                if not can-find(first tt_estab_ctbl no-lock
                                                where tt_estab_ctbl.tta_cod_estab = estabelecimento.cod_estab) then do:
                                   create tt_estab_ctbl.
                                   assign tt_estab_ctbl.tta_cod_estab  = estabelecimento.cod_estab
                                          tt_estab_ctbl.tta_nom_pessoa = estabelecimento.nom_pessoa.
                                end.
                            end.

                            if  v_log_funcao_selec_ccusto = no or
                               (v_log_funcao_selec_ccusto = yes and 
                                aprop_ctbl_pat.cod_plano_ccusto_cr >= v_cod_plano_ccusto_ini and
                                aprop_ctbl_pat.cod_plano_ccusto_cr <= v_cod_plano_ccusto_fim and
                                aprop_ctbl_pat.cod_ccusto_cr       >= v_cod_ccusto_inicial   and
                                aprop_ctbl_pat.cod_ccusto_cr       <= v_cod_ccusto_final)
                            then do:
                                if  not v_log_transf_ext then
                                    find tt_bem_pat_demonst_ctbz
                                        where tt_bem_pat_demonst_ctbz.tta_cod_estab              = reg_calc_bem_pat.cod_estab
                                        and   tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                        and   tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "CR" /*l_cr*/ 
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_cr
                                        no-lock no-error.
                                else
                                    find tt_bem_pat_demonst_ctbz
                                        where tt_bem_pat_demonst_ctbz.tta_cod_estab              = &if '{&emsfin_version}' >= '5.05'
                                                                                                   &then aprop_ctbl_pat.cod_estab
                                                                                                   &else aprop_ctbl_pat.cod_livre_1
                                                                                                   &endif
                                        and   tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                        and   tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "CR" /*l_cr*/ 
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_cr
                                        and   tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_cr
                                        no-lock no-error.
                                if  not avail tt_bem_pat_demonst_ctbz
                                then do:
                                    create tt_bem_pat_demonst_ctbz.
                                    assign tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl = aprop_ctbl_pat.des_histor_lancto_ctbl
                                           tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl  = "CR" /*l_cr*/ 
                                           tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl     = aprop_ctbl_pat.cod_plano_cta_ctbl_cr
                                           tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl           = aprop_ctbl_pat.cod_cta_ctbl_cr
                                           tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto       = aprop_ctbl_pat.cod_plano_ccusto_cr
                                           tt_bem_pat_demonst_ctbz.tta_cod_ccusto             = aprop_ctbl_pat.cod_ccusto_cr
                                           tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc         = aprop_ctbl_pat.cod_unid_negoc_cr.
                                    if  not v_log_transf_ext then
                                        assign tt_bem_pat_demonst_ctbz.tta_cod_estab = reg_calc_bem_pat.cod_estab.
                                    else
                                        assign tt_bem_pat_demonst_ctbz.tta_cod_estab = &if '{&emsfin_version}' >= '5.05'
                                                                                       &then aprop_ctbl_pat.cod_estab
                                                                                       &else aprop_ctbl_pat.cod_livre_1
                                                                                       &endif.                            
                                end /* if */.
                                assign tt_bem_pat_demonst_ctbz.tta_val_aprop_ctbl = tt_bem_pat_demonst_ctbz.tta_val_aprop_ctbl + (if v_val_ajust_dec_chi_return <> 0 then
                                                                                                                                     v_val_movto_return 
                                                                                                                                  else 
                                                                                                                                     aprop_ctbl_pat.val_lancto_ctbl).
                                if  v_log_funcao_det_por_bem and v_log_detdo = yes
                                then do:
                                    create tt_bem_pat_demonst_ctbz_son.
                                    assign tt_bem_pat_demonst_ctbz_son.tta_cod_estab              = tt_bem_pat_demonst_ctbz.tta_cod_estab
                                           tt_bem_pat_demonst_ctbz_son.tta_des_histor_lancto_ctbl = tt_bem_pat_demonst_ctbz.tta_des_histor_lancto_ctbl
                                           tt_bem_pat_demonst_ctbz_son.tta_ind_natur_lancto_ctbl  = tt_bem_pat_demonst_ctbz.tta_ind_natur_lancto_ctbl 
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_plano_cta_ctbl     = tt_bem_pat_demonst_ctbz.tta_cod_plano_cta_ctbl    
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_cta_ctbl           = tt_bem_pat_demonst_ctbz.tta_cod_cta_ctbl          
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_plano_ccusto       = tt_bem_pat_demonst_ctbz.tta_cod_plano_ccusto      
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_ccusto             = tt_bem_pat_demonst_ctbz.tta_cod_ccusto            
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_unid_negoc         = tt_bem_pat_demonst_ctbz.tta_cod_unid_negoc        
                                           tt_bem_pat_demonst_ctbz_son.tta_cod_cta_pat            = bem_pat.cod_cta_pat   
                                           tt_bem_pat_demonst_ctbz_son.tta_num_bem_pat            = bem_pat.num_bem_pat  
                                           tt_bem_pat_demonst_ctbz_son.tta_num_seq_bem_pat        = bem_pat.num_seq_bem_pat
                                           tt_bem_pat_demonst_ctbz_son.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                           tt_bem_pat_demonst_ctbz_son.tta_val_lancto_ctbl        = (if v_val_ajust_dec_chi_return <> 0 
                                                                                                     then v_val_movto_return 
                                                                                                     else aprop_ctbl_pat.val_lancto_ctbl).

                                end.
                            end.
                        end.
                    end.
                end.
*/

            END.

        END.
  
    END.


    IF v_log_apl 
    THEN DO:

         REPEAT v_dat_aux = v_dat_transacao_ini TO v_dat_transacao_fim:

             /* ** Movimentos Aplicaá∆o e EmprÇstimos - APL ***/
             FOR EACH movto_operac_financ NO-LOCK
                 WHERE movto_operac_financ.cod_empresa   = v_cod_empres_usuar
                   AND movto_operac_financ.dat_transacao = v_dat_aux:

                 IF (movto_operac_financ.ind_tip_trans_apl = "Variaá∆o Cambial"
                 OR  movto_operac_financ.ind_tip_trans_apl = "Transf Var Cambial"
                 OR  movto_operac_financ.ind_tip_trans_apl = "Transf VC Juros"
                 OR  movto_operac_financ.ind_tip_trans_apl = "Var Cambial Juros"
                 OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Juros Compet"
                 OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Competància")
                 AND movto_operac_financ.cod_indic_econ   <>  "Real" 
                     THEN NEXT.

                 FIND operac_financ OF movto_operac_financ NO-LOCK NO-ERROR.

                 IF NOT AVAIL operac_financ 
                    THEN NEXT.

                 FIND cta_corren NO-LOCK
                     WHERE cta_corren.cod_cta_corren = operac_financ.cod_cta_corren NO-ERROR.
                 IF NOT AVAIL cta_corren
                 OR cta_corren.cod_estab < v_cod_estab_ini
                 OR cta_corren.cod_estab > v_cod_estab_fim
                    THEN NEXT.

                 FIND usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = movto_operac_financ.cod_usuario NO-ERROR.

                 FOR EACH aprop_ctbl_apl OF movto_operac_financ NO-LOCK:

                     ASSIGN v_val_aprop_ctbl = 0.

                     /* ** 505
                     FOR EACH tab_livre_emsfin NO-LOCK 
                         WHERE tab_livre_emsfin.cod_modul_dtsul      = "APL"
                           AND tab_livre_emsfin.cod_tab_dic_dtsul    = "val_aprop_ctbl_apl"
                           AND tab_livre_emsfin.cod_compon_1_idx_tab = STRING(aprop_ctbl_apl.num_id_movto_operac_financ):
                         IF  ENTRY(1,tab_livre_emsfin.cod_compon_2_idx_tab,";") = STRING(aprop_ctbl_apl.num_seq_aprop_ctbl_apl)
                         AND ENTRY(2,tab_livre_emsfin.cod_compon_2_idx_tab,";") = "Corrente"
                         THEN DO:
                              ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + tab_livre_emsfin.val_livre_1.
                         END.
                     END.
                     ***/
                     
                     FIND val_aprop_ctbl_apl NO-LOCK 
                        WHERE val_aprop_ctbl_apl.num_id_movto_operac_financ = aprop_ctbl_apl.num_id_movto_operac_financ
                          AND val_aprop_ctbl_apl.num_seq_aprop_ctbl         = aprop_ctbl_apl.num_seq_aprop_ctbl_apl
                          AND val_aprop_ctbl_apl.cod_finalid_econ           = "Corrente" NO-ERROR.
                     IF AVAIL val_aprop_ctbl_apl 
                        THEN ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + val_aprop_ctbl_apl.val_aprop_ctbl.

                     IF v_val_aprop_ctbl = 0
                     THEN DO:    
                          IF  movto_operac_financ.ind_tip_trans_apl <> "Variaá∆o Cambial"
                          AND movto_operac_financ.ind_tip_trans_apl <> "Transf Var Cambial"
                          AND movto_operac_financ.ind_tip_trans_apl <> "Transf VC Juros"
                          AND movto_operac_financ.ind_tip_trans_apl <> "Var Cambial Juros"
                          AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Juros Compet"
                          AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Competància"
                          AND movto_operac_financ.cod_indic_econ    <> "Real"   
                          THEN DO:
                               RUN pi_converter_indic_econ_finalid_apl (INPUT movto_operac_financ.cod_indic_econ,
                                                                        INPUT "1",
                                                                        INPUT movto_operac_financ.dat_transacao,
                                                                        INPUT aprop_ctbl_apl.val_aprop_indic_econ_movto,
                                                                        INPUT "Corrente",
                                                                        OUTPUT v_cod_return).
                               FIND FIRST tt_converter_finalid_econ_apl NO-LOCK NO-ERROR. 
                               IF AVAIL tt_converter_finalid_econ_apl 
                                  THEN ASSIGN v_val_aprop_ctbl = tt_converter_finalid_econ_apl.tta_val_transacao.
                          END.
                     END. 

                     IF v_val_aprop_ctbl = 0
                        THEN ASSIGN v_val_aprop_ctbl = aprop_ctbl_apl.val_aprop_indic_econ_movto.

                     FOR EACH histor_operac_financ NO-LOCK
                          WHERE histor_operac_financ.num_id_operac_financ = operac_financ.num_id_operac_financ:
                          ASSIGN v_des_text_histor = v_des_text_histor + histor_operac_financ.des_text_histor_apl.
                     END.

                     ASSIGN v_des_text_histor = REPLACE(v_des_text_histor, CHR(10), " ")
                            v_des_text_histor = REPLACE(v_des_text_histor, ";", " ").

                     FIND cta_ctbl NO-LOCK
                         WHERE cta_ctbl.cod_plano_cta = 'padrao'
                           AND cta_ctbl.cod_cta_ctbl  = aprop_ctbl_apl.cod_cta_ctbl.

                     PUT STREAM s_1  UNFORMATTED "APL;"
                                                 cta_corren.cod_estab                                        ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 ""                                                          ";"
                                                 movto_operac_financ.cod_indic_econ                          ";"
                                                 STRING(movto_operac_financ.val_movto_apl, "->>,>>>,>>9.99") ";"
                                                 STRING(operac_financ.dat_vencto_operac)                     ";"
                                                 movto_operac_financ.dat_transacao                           ";"
                                                 "Banco: " + operac_financ.cod_banco + ". Produto: " + operac_financ.cod_produt_financ + ". Operaá∆o: " + operac_financ.cod_operac_financ + "." ";"
                                                 ""                                                          ";"
                                                 movto_operac_financ.ind_tip_trans_apl                       ";"
                                                 movto_operac_financ.cod_usuario                             ";"
                                                 usuar_mestre.nom_usuario                               ";"
                                                 STRING(movto_operac_financ.val_movto_apl, "->>,>>>,>>9.99") ";"
                                                 aprop_ctbl_apl.ind_finalid_ctbl                             ";"
                                                 aprop_ctbl_apl.ind_natur_lancto_ctbl                        ";"
                                                 aprop_ctbl_apl.cod_cta_ctbl                                 ";"
                                                 cta_ctbl.des_tit                                            ";"
                                                 ""                                                          ";"
                                                  ""                                                         ";"
                                                 aprop_ctbl_apl.cod_unid_negoc                               ";"
                                                 STRING(v_val_aprop_ctbl, "->>,>>>,>>9.99")                  ";"
                                                 v_des_text_histor                                            SKIP.

                 END.

             END.

         END.

    END.


END PROCEDURE.


PROCEDURE pi_converter_indic_econ_finalid_apl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_erro_compos_armaz
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_erro_compos_organ
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cotaá∆o"
        column-label "Data Cotaá∆o"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cotaá∆o"
        column-label "Cotaá∆o"
        no-undo.
    def var v_log_existe_compos              as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    elimina:
    for each tt_converter_finalid_econ_apl exclusive-lock:
        delete tt_converter_finalid_econ_apl.
    end.

    find first compos_finalid no-lock 
         where compos_finalid.cod_indic_econ_base = p_cod_indic_econ 
           and compos_finalid.cod_finalid_econ    = p_cod_finalid_econ 
           and compos_finalid.dat_inic_valid     <= p_dat_transacao 
           and compos_finalid.dat_fim_valid      >  p_dat_transacao 
         use-index cmpsfnld_parid_indic_econ no-error. 
    if  not avail compos_finalid
    then do: 
        assign p_cod_return = "782". 
        return. 
    end.

    if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
    then do: 

        find first compos_finalid_cmcmm no-lock 
              where compos_finalid_cmcmm.cod_finalid_econ       = compos_finalid.cod_finalid_econ 
                and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid 
                and compos_finalid_cmcmm.cod_indic_econ_base    = compos_finalid.cod_indic_econ_base 
                and compos_finalid_cmcmm.cod_indic_econ_idx     = compos_finalid.cod_indic_econ_idx 
                and compos_finalid_cmcmm.dat_inic_valid_compos  = compos_finalid.dat_inic_valid 
                and compos_finalid_cmcmm.dat_inic_valid        <= p_dat_transacao 
                and compos_finalid_cmcmm.dat_fim_valid         >  p_dat_transacao no-error. 

         if  avail compos_finalid_cmcmm
         then do: 
              run pi_achar_cotac_indic_econ (Input compos_finalid.cod_indic_econ_base,
                                             Input compos_finalid.cod_indic_econ_idx,
                                             Input p_dat_transacao,
                                             Input "Real",
                                             output v_dat_cotac_indic_econ,
                                             output v_val_cotac_indic_econ,
                                             output v_cod_return). 
              if  entry(1,v_cod_return) = "358"
              then do: 
                  elimina:
                  for each tt_converter_finalid_econ_apl exclusive-lock: 
                      delete tt_converter_finalid_econ_apl. 
                  end. 
                  assign p_cod_return = v_cod_return. 
                  return. 
              end. 
              create tt_converter_finalid_econ_apl. 
              assign tt_converter_finalid_econ_apl.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ 
                     tt_converter_finalid_econ_apl.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_cotac_indic_econ = v_val_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ.

         end. 
    end. 

    assign p_cod_return = "OK".

END PROCEDURE.


PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:

        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id no-error.
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.

        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */


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
/**********************  End of rpt_tit_ap_consistencia *********************/
