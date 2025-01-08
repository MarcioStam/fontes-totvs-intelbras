/*****************************************************************************
** Nome Externo..........: esp/fas/esfas015.p
** Data Criaá∆o..........: 02/12/2014
** Criado por............: Fabiano Zarpe Henke
*****************************************************************************/

def var c-versao-prg as char initial "5.00.00.001":U no-undo.

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=37":U.
/*************************************  *************************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_dat_transacao LIKE movto_bem_pat.dat_transacao  NO-UNDO.
DEFINE VARIABLE v_cod_arquivo   AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE v_cod_arq       AS CHARACTER                      NO-UNDO.

def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
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
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.
def button bt_get_file2
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 1 by 1.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.

/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.

def var ed_2x40
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
    radio-buttons "Terminal", "Terminal","Arquivo", "Arquivo","Impressora", "Impressora"
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Frame Definition Begin **************************/

def frame f_rpt_41_motiv_movto_tit_acr_dem
    rt_005
         at row 01.42 col 02.14
    " Seleá∆o " view-as text
         at row 01.12 col 04.14 bgcolor 8 
    rt_target
         at row 05.63 col 02.00
    " Destino " view-as text
         at row 05.33 col 04.00 bgcolor 8 
    rt_cxcf
         at row 10.13 col 02.00 bgcolor 7 
    v_dat_transacao
         at row 03.08 col 21.43 colon-aligned label "Data C†lculo"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    rs_cod_dwb_output
         at row 06.33 col 03.00
         help "" no-label
    ed_1x40
         at row 07.29 col 04.00
         help "" LABEL "Arq Fiscal"
    bt_get_file
         at row 07.29 col 53.50 font ?
         help "Pesquisa Arquivo"
    ed_2x40
         at row 08.29 col 04.40
         help "" LABEL "Arq IFRS"
    bt_get_file2
         at row 08.29 col 53.50 font ?
         help "Pesquisa Arquivo"
    bt_print
         at row 10.33 col 03.00 font ?
         help "Imprime"
    bt_can
         at row 10.33 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 60.00 by 11.96
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Validaá∆o C†lculo Bem Patrimonial - esfas015".
    assign bt_can:width-chars          in frame f_rpt_41_motiv_movto_tit_acr_dem = 10.00
           bt_can:height-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_motiv_movto_tit_acr_dem = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.08
           bt_get_file2:width-chars    in frame f_rpt_41_motiv_movto_tit_acr_dem = 04.00
           bt_get_file2:height-chars   in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.08
           bt_print:width-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 10.00
           bt_print:height-chars       in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           ed_1x40:width-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 42.00
           ed_1x40:height-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           ed_2x40:width-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 42.00
           ed_2x40:height-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           rt_cxcf:width-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_cxcf:height-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.42
           rt_005:width-chars          in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_005:height-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 03.83
           rt_target:width-chars       in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_target:height-chars      in frame f_rpt_41_motiv_movto_tit_acr_dem = 04.00.
    assign ed_1x40:return-inserted in frame f_rpt_41_motiv_movto_tit_acr_dem = YES
           ed_2x40:return-inserted in frame f_rpt_41_motiv_movto_tit_acr_dem = yes.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    system-dialog get-file v_cod_arquivo
        title "Imprimir" /*l_imprimir*/ 
        filters '*.csv' '*.csv',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign ed_1x40:screen-value in frame f_rpt_41_motiv_movto_tit_acr_dem = v_cod_arquivo.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_motiv_movto_tit_acr_dem */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_motiv_movto_tit_acr_dem:
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
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem */

ON CHOOSE OF bt_get_file2 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    system-dialog get-file v_cod_arquivo
        title "Imprimir" /*l_imprimir*/ 
        filters '*.csv' '*.csv',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign ed_2x40:screen-value in frame f_rpt_41_motiv_movto_tit_acr_dem = v_cod_arquivo.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_motiv_movto_tit_acr_dem */

ON LEAVE OF ed_2x40 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_motiv_movto_tit_acr_dem:
        if  ed_2x40:screen-value <> ""
        then do:
            assign ed_2x40:screen-value   = replace(ed_2x40:screen-value, '~\', '/')
                   v_cod_filename_initial = entry(num-entries(ed_2x40:screen-value, '/'), ed_2x40:screen-value, '/')
                   v_cod_filename_final   = substring(ed_2x40:screen-value, 1,
                                                      length(ed_2x40:screen-value) - length(v_cod_filename_initial) - 1)
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
    end /* do block */.

END. /* ON LEAVE OF ed_2x40 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem */

/************************ User Interface Trigger End ************************/

ON GO OF FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

     run pi_filename_validation (Input ed_1x40:screen-value).
     run pi_filename_validation (Input ed_2x40:screen-value).

END. /* ON GO OF FRAME f_rpt_41_motiv_movto_tit_acr_dem */

ON WINDOW-CLOSE OF FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_motiv_movto_tit_acr_dem */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_motiv_movto_tit_acr_dem:title = frame f_rpt_41_motiv_movto_tit_acr_dem:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.00.00.001":U)
                            + chr(41).

assign v_cod_arq = SESSION:TEMP-DIRECTORY.
find usuar_mestre no-lock
     where usuar_mestre.cod_usuario = v_cod_usuar_corren use-index srmstr_id no-error.
if usuar_mestre.nom_dir_spool <> ""
   then assign v_cod_arq = usuar_mestre.nom_dir_spool + "~/".
if usuar_mestre.nom_subdir_spool <> ""
   then assign v_cod_arq = v_cod_arq + usuar_mestre.nom_subdir_spool + "~/".
assign v_cod_arq = v_cod_arq + caps("esfas015":U).

assign v_dat_transacao      = DATE(MONTH(TODAY),01, YEAR(TODAY)) - 1
       ed_1x40              = v_cod_arq + "_fiscal.csv"
       ed_2x40              = v_cod_arq + "_ifrs.csv".

pause 0 before-hide.
view frame f_rpt_41_motiv_movto_tit_acr_dem.

super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    enable bt_get_file
           bt_get_file2
           bt_print
           bt_can
           v_dat_transacao     
           ed_1x40
           ed_2x40
           with frame f_rpt_41_motiv_movto_tit_acr_dem.

    display v_dat_transacao     
            rs_cod_dwb_output
            ed_1x40
            ed_2x40
            with frame f_rpt_41_motiv_movto_tit_acr_dem.       

    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_motiv_movto_tit_acr_dem:

            if (retry) then
                output stream s_1 close.
            if  valid-handle(v_wgh_focus) then
                wait-for go of frame f_rpt_41_motiv_movto_tit_acr_dem focus v_wgh_focus.
            else
                wait-for go of frame f_rpt_41_motiv_movto_tit_acr_dem.

            param_block:
            do transaction:

                assign v_dat_transacao      = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_dat_transacao     
                       ed_1x40              = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem ed_1x40
                       ed_2x40              = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem ed_2x40.

                if  MONTH(v_dat_transacao) = MONTH(v_dat_transacao + 1) then do:
                    MESSAGE "Favor informar o £ltimo dia do màs!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    assign v_wgh_focus = v_dat_transacao:handle in frame f_rpt_41_motiv_movto_tit_acr_dem.
                    undo main_block, retry main_block.
                end.

            end /* do param_block */.

            assign v_log_method  = session:set-wait-state('general')
                   v_cod_arquivo = ed_1x40:screen-value.
            run pi_rpt_motiv_movto_tit_acr_dem.
            output stream s_1 close.
            assign v_log_method = session:set-wait-state("").
            leave main_block.

        end /* repeat main_block */.

    end /* repeat block1 */.
end /* repeat super_block */.

hide frame f_rpt_41_motiv_movto_tit_acr_dem.

if  this-procedure:persistent then
    delete procedure this-procedure.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: michelle
** Alterado em...........: 10/02/2000 17:30:59
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

    if  index(v_cod_1, "~/~/") > 0
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
            if  length(v_cod_2) > 8
            then do:
                return "NOK" /*l_nok*/ .
            end /* if */.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).
    if  length(v_cod_2) > 8
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_filename_validation */

/*****************************************************************************
** Procedure Interna.....: pi_rpt_motiv_movto_tit_acr_dem
** Descricao.............: pi_rpt_motiv_movto_tit_acr_dem
** Criado por............: borba
** Criado em.............: 07/05/1997 09:17:55
** Alterado por..........: Claudia
** Alterado em...........: 13/08/1997 17:17:33
*****************************************************************************/
PROCEDURE pi_rpt_motiv_movto_tit_acr_dem:

    DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE de-vl-credito       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-total-apropriada  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-total-a-apropriar AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total-ficha      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vlr-remanescente AS DECIMAL     NO-UNDO.

    run utp/ut-acomp.p persistent set h-acomp.

    run pi-inicializar in h-acomp  (input "Gerando Informaá‰es").

    /* Inicio FISCAL */
    OUTPUT STREAM s_1 TO VALUE(ed_1x40) CONVERT TARGET 'iso8859-1'.

    PUT STREAM s_1 UNFORMATTED "Estab;Cta Pat;Bem Pat;Seq;Saldo Fiscal" SKIP.

    FOR EACH bem_pat NO-LOCK
        WHERE bem_pat.cod_empresa = v_cod_empres_usuar:

        IF bem_pat.cod_grp_calc = "NDNA" 
        OR ROUND(bem_pat.val_perc_bxa, 1) = 100
           THEN NEXT.

        FIND FIRST movto_bem_pat OF bem_pat NO-LOCK NO-ERROR.
        IF NOT AVAIL movto_bem_pat
        OR movto_bem_pat.dat_movto_bem_pat > v_dat_transacao 
           THEN NEXT.

        IF CAN-FIND(FIRST reg_calc_bem_pat NO-LOCK 
                    WHERE reg_calc_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                      AND reg_calc_bem_pat.num_seq_incorp_bem_pat = 0
                      AND reg_calc_bem_pat.cod_tip_calc           = (IF bem_pat.cod_grp_calc = "Amort" THEN "Amortiz" ELSE "Deprec")
                      AND reg_calc_bem_pat.cod_cenar_ctbl         = "FISCAL"
                      AND reg_calc_bem_pat.cod_finalid_econ       = "Corrente"
                      AND reg_calc_bem_pat.dat_calc_pat           = v_dat_transacao) 
            THEN NEXT.

        FIND LAST sdo_bem_pat NO-LOCK
            WHERE sdo_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
              AND sdo_bem_pat.num_seq_incorp_bem_pat = 0
              AND sdo_bem_pat.cod_cenar_ctbl         = "FISCAL"
              AND sdo_bem_pat.cod_finalid_econ       = "Corrente" NO-ERROR.
        IF TRUNCATE((sdo_bem_pat.val_origin_corrig - ((sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr) + (sdo_bem_pat.val_dpr_val_origin_amort + sdo_bem_pat.val_dpr_cm_amort + sdo_bem_pat.val_cm_dpr_amort))), 2) <= 0
           THEN NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando relat¢rio: Bem Patrimonial " + STRING(bem_pat.num_bem_pat)).

        PUT STREAM s_1 UNFORMATTED bem_pat.cod_estab ";" bem_pat.cod_cta_pat ";" bem_pat.num_bem_pat ";" bem_pat.num_seq ";" (sdo_bem_pat.val_origin_corrig - ((sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr) + (sdo_bem_pat.val_dpr_val_origin_amort + sdo_bem_pat.val_dpr_cm_amort + sdo_bem_pat.val_cm_dpr_amort))) SKIP.

    END.

    OUTPUT STREAM s_1 CLOSE.
    /* Fim FISCAL */

    /* Inicio IFRS */
    OUTPUT STREAM s_1 TO VALUE(ed_2x40) CONVERT TARGET 'iso8859-1'.

    PUT STREAM s_1 UNFORMATTED "Estab;Cta Pat;Bem Pat;Seq;Saldo IFRS" SKIP.

    FOR EACH bem_pat NO-LOCK
        WHERE bem_pat.cod_empresa = v_cod_empres_usuar:

        IF bem_pat.cod_grp_calc = "NDNA" 
        OR ROUND(bem_pat.val_perc_bxa, 1) = 100
           THEN NEXT.

        FIND FIRST movto_bem_pat OF bem_pat NO-LOCK NO-ERROR.
        IF NOT AVAIL movto_bem_pat
        OR movto_bem_pat.dat_movto_bem_pat > v_dat_transacao 
           THEN NEXT.

        IF CAN-FIND(FIRST reg_calc_bem_pat NO-LOCK 
                    WHERE reg_calc_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                      AND reg_calc_bem_pat.num_seq_incorp_bem_pat = 0
                      AND reg_calc_bem_pat.cod_tip_calc           = (IF bem_pat.cod_grp_calc = "Amort" THEN "Amortiz" ELSE "Deprec")
                      AND reg_calc_bem_pat.cod_cenar_ctbl         = "IFRS"
                      AND reg_calc_bem_pat.cod_finalid_econ       = "Corrente"
                      AND reg_calc_bem_pat.dat_calc_pat           = v_dat_transacao) 
            THEN NEXT.

        FIND LAST sdo_bem_pat NO-LOCK
            WHERE sdo_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
              AND sdo_bem_pat.num_seq_incorp_bem_pat = 0
              AND sdo_bem_pat.cod_cenar_ctbl         = "IFRS"
              AND sdo_bem_pat.cod_finalid_econ       = "Corrente" NO-ERROR.
        IF TRUNCATE((sdo_bem_pat.val_origin_corrig - ((sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr) + (sdo_bem_pat.val_dpr_val_origin_amort + sdo_bem_pat.val_dpr_cm_amort + sdo_bem_pat.val_cm_dpr_amort))), 2) <= 0
           THEN NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando relat¢rio: Bem Patrimonial " + STRING(bem_pat.num_bem_pat)).

        PUT STREAM s_1 UNFORMATTED bem_pat.cod_estab ";" bem_pat.cod_cta_pat ";" bem_pat.num_bem_pat ";" bem_pat.num_seq ";" (sdo_bem_pat.val_origin_corrig - ((sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr) + (sdo_bem_pat.val_dpr_val_origin_amort + sdo_bem_pat.val_dpr_cm_amort + sdo_bem_pat.val_cm_dpr_amort))) SKIP.

    END.

    OUTPUT STREAM s_1 CLOSE.
    /* Fim IFRS */
    
    run pi-finalizar in h-acomp.

    MESSAGE "Processo finalizado !!!" VIEW-AS ALERT-BOX INFORMATION.
    return "OK":U.

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
/********************  End of rpt_motiv_movto_tit_acr_dem *******************/
