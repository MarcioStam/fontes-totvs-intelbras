/*****************************************************************************
** Nome Externo..........: esp/apb/esapb101.p
** Descricao.............: Listar pagamento emabrque
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 09/09/2015
*****************************************************************************/

def var c-versao-prg as char initial " 5.01.00.000":U no-undo.

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim AS CHARACTER FORMAT "x(03)" NO-UNDO.

DEFINE VARIABLE v_cdn_fornec_ini AS INTEGER  FORMAT ">>>,>>>,>>9"  NO-UNDO.
DEFINE VARIABLE v_cdn_fornec_fim AS INTEGER  FORMAT ">>>,>>>,>>9"  NO-UNDO.

DEFINE VARIABLE v_dat_transacao_ini AS DATE INITIAL TODAY FORMAT "99/99/9999"      NO-UNDO.
DEFINE VARIABLE v_dat_transacao_fim AS DATE INITIAL TODAY FORMAT "99/99/9999"      NO-UNDO.

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
    v_cdn_fornec_ini
         at row 03 col 15.14 colon-aligned label "Fornecedor"
         help "Fornecedor Inicial"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_fornec_fim
         at row 03 col 31.29 colon-aligned label "atÇ"
         help "Fornecedor Final"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_ini
         at row 04 col 15.14 colon-aligned label "Data Transaá∆o"
         help "Data de Transaá∆o Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_transacao_fim
         at row 04 col 31.29 colon-aligned label "atÇ"
         help "Data de Transaá∆o Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
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
         title "Relaá∆o Pagamento Embarque - esapb101".
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
           rt_001:height-chars         in frame f_rpt_41_tit_ap_consistencia = 04
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
        filters '*.csv' '*.csv',
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
                                                          + caps("esapb101":U)
                                                          + '.csv'.
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

run prgtec/men/men901za.py (Input 'esapb101') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb101')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esapb101')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */

/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul    = 'esapb101' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'esapb101'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "esapb101":U
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

assign v_cod_dwb_program  = "esapb101":U.

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
                                                  "esp/apb/esapb101.p":U).
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
           v_cdn_fornec_ini    =  INT(entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)))
           v_cdn_fornec_fim    =  INT(entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10))) NO-ERROR.

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
    if num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 6 
    then do:
         assign v_dat_transacao_ini = date(entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_dat_transacao_fim = date(entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_cod_estab_ini     =      entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10))
                v_cod_estab_fim     =      entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10)) 
                v_cdn_fornec_ini    =  INT(entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                v_cdn_fornec_fim    =  INT(entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10))) NO-ERROR.
    END.

    display v_dat_transacao_fim
            v_dat_transacao_ini
            v_cod_estab_ini
            v_cod_estab_fim
            v_cdn_fornec_ini
            v_cdn_fornec_fim
            with frame f_rpt_41_tit_ap_consistencia.
    enable v_dat_transacao_fim
           v_dat_transacao_ini
           v_cod_estab_ini
           v_cod_estab_fim
           v_cdn_fornec_ini
           v_cdn_fornec_fim
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
                       input frame f_rpt_41_tit_ap_consistencia v_cdn_fornec_ini                    
                       input frame f_rpt_41_tit_ap_consistencia v_cdn_fornec_fim.

                assign dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_41_tit_ap_consistencia rs_ind_run_mode.

                assign dwb_rpt_param.cod_dwb_parameters = string( v_dat_transacao_ini )  + chr(10) +
                                                          string( v_dat_transacao_fim )  + chr(10) +
                                                                  v_cod_estab_ini        + chr(10) +             
                                                                  v_cod_estab_fim        + chr(10) +
                                                          STRING(v_cdn_fornec_ini)       + CHR(10) + 
                                                          STRING(v_cdn_fornec_fim).                      
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

    PUT STREAM s_1 UNFORMATTED "HBL;Estab;Espec;Ser;Titulo;Parc;Fornecedor;CGC;Nome Abrev;Moeda;Valor Original;Saldo;Vencimento;Transacao;Transacao Abrev;Transacao;Valor Movimento;Valor Movimento R$" SKIP.
  
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa  = v_cod_empres_usuar
          AND estabelecimento.cod_estab   >= v_cod_estab_ini
          AND estabelecimento.cod_estab   <= v_cod_estab_fim:
  
        REPEAT v_dat_aux = v_dat_transacao_ini TO v_dat_transacao_fim:
  
            FOR EACH movto_tit_ap NO-LOCK
                WHERE movto_tit_ap.cod_estab       = estabelecimento.cod_estab
                  AND movto_tit_ap.dat_transacao   = v_dat_aux
                  AND movto_tit_ap.cdn_fornecedor >= v_cdn_fornec_ini
                  AND movto_tit_ap.cdn_fornecedor <= v_cdn_fornec_fim:

                IF movto_tit_ap.num_id_movto_cta_corren = 0
                OR movto_tit_ap.num_id_movto_cta_corren = ? 
                   THEN NEXT.

                FIND emscad.fornecedor NO-LOCK
                    WHERE emscad.fornecedor.cod_empresa = movto_tit_ap.cod_empresa 
                      AND emscad.fornecedor.cdn_fornec  = movto_tit_ap.cdn_fornecedor NO-ERROR.
                IF NOT AVAIL emscad.fornecedor 
                   THEN NEXT.

                FIND tit_ap NO-LOCK 
                    WHERE tit_ap.cod_estab     = movto_tit_ap.cod_estab
                      AND tit_ap.num_id_tit_ap = movto_tit_ap.num_id_tit_ap NO-ERROR.
                IF NOT AVAIL tit_ap 
                   THEN NEXT.

                FIND FIRST embarque-imp NO-LOCK
                    WHERE /*embarque-imp.cod-estab = tit_ap.cod_estab
                      AND*/ embarque-imp.embarque  = tit_ap.cod_tit_ap NO-ERROR.
                IF NOT AVAIL embarque-imp 
                   THEN NEXT.

                ASSIGN v_val_aprop_ctbl = 0.

                FOR EACH aprop_ctbl_ap NO-LOCK
                    WHERE aprop_ctbl_ap.cod_estab           = movto_tit_ap.cod_estab
                      AND aprop_ctbl_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                      AND aprop_ctbl_ap.ind_natur_lancto    = "CR":
                      /* ** Tratamento para titulos implantados em outra moeda ***/
                      ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + aprop_ctbl_ap.val_aprop_ctbl.
                      IF aprop_ctbl_ap.cod_indic_econ <> 'real'
                      THEN DO:
                           ASSIGN v_val_aprop_ctbl = 0.
                           FOR EACH val_aprop_ctbl_ap OF aprop_ctbl_ap NO-LOCK:
                               ASSIGN v_val_aprop_ctbl = v_val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
                           END.
                      END.
                END.

                PUT STREAM s_1 UNFORMATTED embarque-imp.cod-conhecto-house  ";"
                                           movto_tit_ap.cod_estab           ";"
                                           tit_ap.cod_espec                 ";"
                                           tit_ap.cod_ser                   ";"
                                           tit_ap.cod_tit_ap                ";"
                                           tit_ap.cod_parcela               ";"
                                           tit_ap.cdn_fornec                ";"
                                           emscad.fornecedor.cod_id_feder     ";"
                                           emscad.fornecedor.nom_abrev        ";"
                                           tit_ap.cod_indic_econ            ";"
                                           tit_ap.val_origin_tit_ap         ";"
                                           tit_ap.val_sdo_tit_ap            ";"
                                           tit_ap.dat_vencto                ";"
                                           movto_tit_ap.dat_transacao       ";"
                                           movto_tit_ap.ind_trans_ap_abrev  ";"
                                           movto_tit_ap.ind_trans_ap        ";"
                                           movto_tit_ap.val_movto_ap        ";"
                                           v_val_aprop_ctbl SKIP.
                

            END.
        END.
    END.


END PROCEDURE.

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
