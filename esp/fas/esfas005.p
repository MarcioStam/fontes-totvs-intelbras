/*****************************************************************************
** Nome Externo..........: esp/fas/esfas005.p
** Data Cria‡Æo..........: 16/07/2009
** Criado por............: Fabiano Zarpe Henke
*****************************************************************************/

def var c-versao-prg as char initial "5.00.00.001":U no-undo.

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=37":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

DEF TEMP-TABLE tt-dados
    FIELD cod_estab             LIKE bem_pat.cod_estab
    FIELD cod_cta_pat           LIKE bem_pat.cod_cta_pat
    FIELD des_cta_pat           LIKE cta_pat.des_cta_pat      
    FIELD num_bem_pat           LIKE bem_pat.num_bem_pat      
    FIELD num_seq_bem_pat       LIKE bem_pat.num_seq_bem_pat  
    FIELD des_bem_pat           LIKE bem_pat.des_bem_pat      
    FIELD dat_aquis_bem_pat     LIKE bem_pat.dat_aquis_bem_pat
    FIELD cb3_ident_visual      LIKE bem_pat.cb3_ident_visual     
    FIELD val_perc_bxa          LIKE bem_pat.val_perc_bxa     
    FIELD cod_ccusto_respons    LIKE bem_pat.cod_ccusto_respons       
    FIELD val_perc_aprop        LIKE aloc_bem.val_perc_aprop    
    FIELD cod_unid_negoc        LIKE bem_pat.cod_unid_negoc   
    FIELD dat_inic_valid        LIKE bem_pat.dat_inic_valid   
    FIELD dat_fim_valid         LIKE bem_pat.dat_fim_valid    
    FIELD val_original          LIKE bem_pat.val_original
    INDEX bem IS PRIMARY UNIQUE cod_estab
                                cod_cta_pat
                                num_bem_pat
                                num_seq_bem_pat
                                cod_ccusto_respons.

/********************** Temporary Table Definition End **********************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_estab_ini      LIKE bem_pat.cod_estab          NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim      LIKE bem_pat.cod_estab          NO-UNDO.
DEFINE VARIABLE v_cod_cta_pat_ini    LIKE bem_pat.cod_cta_pat        NO-UNDO.
DEFINE VARIABLE v_cod_cta_pat_fim    LIKE bem_pat.cod_cta_pat        NO-UNDO.
DEFINE VARIABLE v_ccusto_respons_ini AS CHAR FORMAT "x(05)"          NO-UNDO.
DEFINE VARIABLE v_ccusto_respons_fim AS CHAR FORMAT "x(05)"          NO-UNDO.
DEFINE VARIABLE v_cod_arquivo        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE v_cod_arq            AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE v_log_alocacao       AS LOGICAL INIT NO LABEL "Somente Bens com Aloca‡Æo"  NO-UNDO.

def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_method
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
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
    " Sele‡Æo " view-as text
         at row 01.12 col 04.14 bgcolor 8 
    rt_target
         at row 06.63 col 02.00
    " Destino " view-as text
         at row 06.33 col 04.00 bgcolor 8 
    rt_cxcf
         at row 10.13 col 02.00 bgcolor 7 
    v_cod_estab_ini
         at row 02.08 col 13.43 colon-aligned label "Estab"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         at row 02.13 col 36 colon-aligned label "at‚"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_pat_ini
         at row 03.08 col 13.43 colon-aligned label "Cta Patrimonial"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_pat_fim
         at row 03.13 col 36 colon-aligned label "at‚"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_ccusto_respons_ini
         at row 04.08 col 13.43 colon-aligned label "CCusto"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_ccusto_respons_fim
         at row 04.13 col 36 colon-aligned label "at‚"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_log_alocacao
         at row 05.23 col 15.43
         VIEW-AS TOGGLE-BOX
    rs_cod_dwb_output
         at row 07.33 col 03.00
         help "" no-label
    ed_1x40
         at row 08.29 col 03.00
         help "" no-label
    bt_get_file
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
         title "Relat¢rio Aloca‡Æo Bem Patrimonial".
    assign bt_can:width-chars          in frame f_rpt_41_motiv_movto_tit_acr_dem = 10.00
           bt_can:height-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_motiv_movto_tit_acr_dem = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.08
           bt_print:width-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 10.00
           bt_print:height-chars       in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           ed_1x40:width-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 50.00
           ed_1x40:height-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.00
           rt_cxcf:width-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_cxcf:height-chars        in frame f_rpt_41_motiv_movto_tit_acr_dem = 01.42
           rt_005:width-chars          in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_005:height-chars         in frame f_rpt_41_motiv_movto_tit_acr_dem = 04.83
           rt_target:width-chars       in frame f_rpt_41_motiv_movto_tit_acr_dem = 57.00
           rt_target:height-chars      in frame f_rpt_41_motiv_movto_tit_acr_dem = 03.00.
    assign ed_1x40:return-inserted in frame f_rpt_41_motiv_movto_tit_acr_dem = yes.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    system-dialog get-file v_cod_arquivo
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
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
                 /* O diret¢rio &1 nÆo existe ! */
                 run pi_messages (input "show",
                                  input 4354,
                                  input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                     v_cod_filename_final)) /*msg_4354*/.
                 return no-apply.
            end /* if */.
        end /* if */.
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_motiv_movto_tit_acr_dem */

/************************ User Interface Trigger End ************************/

ON GO OF FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

     run pi_filename_validation (Input ed_1x40:screen-value).

END. /* ON GO OF FRAME f_rpt_41_motiv_movto_tit_acr_dem */

ON WINDOW-CLOSE OF FRAME f_rpt_41_motiv_movto_tit_acr_dem
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_motiv_movto_tit_acr_dem */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e versÆo */
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
assign v_cod_arq = v_cod_arq + caps("esfas005":U) + '.txt'.

assign v_cod_estab_ini      = ""
       v_cod_estab_fim      = "ZZZ"
       v_cod_cta_pat_ini    = ""
       v_cod_cta_pat_fim    = "ZZZZZZZZZZZZZZZZZZ"
       v_ccusto_respons_ini = ""
       v_ccusto_respons_fim = "ZZZZZ"
       ed_1x40              = v_cod_arq.

pause 0 before-hide.
view frame f_rpt_41_motiv_movto_tit_acr_dem.

super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    enable bt_get_file
           bt_print
           bt_can
           v_cod_estab_ini     
           v_cod_estab_fim     
           v_cod_cta_pat_ini   
           v_cod_cta_pat_fim   
           v_ccusto_respons_ini
           v_ccusto_respons_fim
           v_log_alocacao
           ed_1x40
           with frame f_rpt_41_motiv_movto_tit_acr_dem.

    display v_cod_estab_ini     
            v_cod_estab_fim     
            v_cod_cta_pat_ini   
            v_cod_cta_pat_fim   
            v_ccusto_respons_ini
            v_ccusto_respons_fim
            v_log_alocacao
            rs_cod_dwb_output
            ed_1x40
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

                assign v_cod_estab_ini      = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_cod_estab_ini     
                       v_cod_estab_fim      = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_cod_estab_fim     
                       v_cod_cta_pat_ini    = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_cod_cta_pat_ini   
                       v_cod_cta_pat_fim    = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_cod_cta_pat_fim   
                       v_ccusto_respons_ini = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_ccusto_respons_ini
                       v_ccusto_respons_fim = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_ccusto_respons_fim
                       v_log_alocacao       = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem v_log_alocacao
                       ed_1x40              = INPUT FRAME f_rpt_41_motiv_movto_tit_acr_dem ed_1x40.

                if  v_cod_estab_ini > v_cod_estab_fim then do:
                    /* &1 Inicial deve ser menor ou igual a &1 Final ! */
                    run pi_messages (input "show",
                                     input 5123,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        "Estabelecimento")) /*msg_5123*/.
                    assign v_wgh_focus = v_cod_estab_ini:handle in frame f_rpt_41_motiv_movto_tit_acr_dem.
                    undo main_block, retry main_block.
                end.
                if  v_cod_cta_pat_ini > v_cod_cta_pat_fim then do:
                    /* &1 Inicial deve ser menor ou igual a &1 Final ! */
                    run pi_messages (input "show",
                                     input 5123,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        "Conta Patrimonial")) /*msg_5123*/.
                    assign v_wgh_focus = v_cod_cta_pat_ini:handle in frame f_rpt_41_motiv_movto_tit_acr_dem.
                    undo main_block, retry main_block.
                end.
                if  v_ccusto_respons_ini > v_ccusto_respons_fim then do:
                    /* &1 Inicial deve ser menor ou igual a &1 Final ! */
                    run pi_messages (input "show",
                                     input 5123,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        "CCusto")) /*msg_5123*/.
                    assign v_wgh_focus = v_ccusto_respons_ini:handle in frame f_rpt_41_motiv_movto_tit_acr_dem.
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

        FOR EACH tt-dados:
            DELETE tt-dados.
        END.

        FOR EACH aloc_bem NO-LOCK
            WHERE aloc_bem.cod_empres = v_cod_empres_usuar
              AND aloc_bem.cod_plano_ccusto  = 'padrao'
              AND aloc_bem.cod_ccusto       >= v_ccusto_respons_ini 
              AND aloc_bem.cod_ccusto       <= v_ccusto_respons_fim:
            IF aloc_bem.val_perc_aprop = 0 
               THEN NEXT.
            FIND bem_pat NO-LOCK OF aloc_bem.
            IF bem_pat.cod_estab < v_cod_estab_ini
            OR bem_pat.cod_estab > v_cod_estab_fim 
               THEN NEXT.
            IF bem_pat.cod_cta_pat < v_cod_cta_pat_ini
            OR bem_pat.cod_cta_pat > v_cod_cta_pat_fim 
               THEN NEXT.
            FIND cta_pat NO-LOCK OF bem_pat NO-ERROR.
            CREATE tt-dados.
            ASSIGN tt-dados.cod_estab          = bem_pat.cod_estab         
                   tt-dados.cod_cta_pat        = bem_pat.cod_cta_pat       
                   tt-dados.des_cta_pat        = cta_pat.des_cta_pat       
                   tt-dados.num_bem_pat        = bem_pat.num_bem_pat       
                   tt-dados.num_seq_bem_pat    = bem_pat.num_seq_bem_pat   
                   tt-dados.des_bem_pat        = bem_pat.des_bem_pat       
                   tt-dados.dat_aquis_bem_pat  = bem_pat.dat_aquis_bem_pat 
                   tt-dados.cb3_ident_visual   = bem_pat.cb3_ident_visual  
                   tt-dados.val_perc_bxa       = bem_pat.val_perc_bxa      
                   tt-dados.cod_ccusto_respons = aloc_bem.cod_ccusto
                   tt-dados.val_perc_aprop     = aloc_bem.val_perc_aprop    
                   tt-dados.cod_unid_negoc     = aloc_bem.cod_unid_negoc    
                   tt-dados.dat_inic_valid     = aloc_bem.dat_inic_valid    
                   tt-dados.dat_fim_valid      = aloc_bem.dat_fim_valid     
                   tt-dados.val_original       = bem_pat.val_original.
        END.

        IF v_log_alocacao = NO 
        THEN DO:
            FOR EACH bem_pat NO-LOCK
                WHERE bem_pat.cod_empres          = v_cod_empres_usuar
                  AND bem_pat.cod_plano_ccusto    = 'padrao'
                  AND bem_pat.cod_ccusto_respons >= v_ccusto_respons_ini
                  AND bem_pat.cod_ccusto_respons <= v_ccusto_respons_fim:
                FIND tt-dados
                    WHERE tt-dados.cod_estab          = bem_pat.cod_estab  
                      AND tt-dados.cod_cta_pat        = bem_pat.cod_cta_pat
                      AND tt-dados.num_bem_pat        = bem_pat.num_bem_pat    
                      AND tt-dados.num_seq_bem_pat    = bem_pat.num_seq_bem_pat
                      AND tt-dados.cod_ccusto_respons = bem_pat.cod_ccusto_respons NO-ERROR.
                IF AVAIL tt-dados 
                   THEN NEXT.
                IF bem_pat.cod_estab < v_cod_estab_ini
                OR bem_pat.cod_estab > v_cod_estab_fim 
                   THEN NEXT.
                IF bem_pat.cod_cta_pat < v_cod_cta_pat_ini
                OR bem_pat.cod_cta_pat > v_cod_cta_pat_fim 
                   THEN NEXT.
                FIND cta_pat NO-LOCK OF bem_pat NO-ERROR.
                CREATE tt-dados.
                ASSIGN tt-dados.cod_estab          = bem_pat.cod_estab         
                       tt-dados.cod_cta_pat        = bem_pat.cod_cta_pat       
                       tt-dados.des_cta_pat        = cta_pat.des_cta_pat       
                       tt-dados.num_bem_pat        = bem_pat.num_bem_pat       
                       tt-dados.num_seq_bem_pat    = bem_pat.num_seq_bem_pat   
                       tt-dados.des_bem_pat        = bem_pat.des_bem_pat       
                       tt-dados.dat_aquis_bem_pat  = bem_pat.dat_aquis_bem_pat 
                       tt-dados.cb3_ident_visual   = bem_pat.cb3_ident_visual  
                       tt-dados.val_perc_bxa       = bem_pat.val_perc_bxa      
                       tt-dados.cod_ccusto_respons = bem_pat.cod_ccusto_respons
                       tt-dados.val_perc_aprop     = 100
                       tt-dados.cod_unid_negoc     = bem_pat.cod_unid_negoc    
                       tt-dados.dat_inic_valid     = bem_pat.dat_aquis_bem_pat    
                       tt-dados.dat_fim_valid      = 12/31/9999
                       tt-dados.val_original       = bem_pat.val_original.
            END.
        END.

        OUTPUT STREAM s_1 TO VALUE(ed_1x40) CONVERT TARGET 'iso8859-1'.

        PUT STREAM s_1 UNFORMATTED "Estab;Cta Pat;Des Cta Pat;Bem Pat;Seq;Des Bem Pat;Dat Aquis;Plaqueta;%Bxa;CCusto;%Aloc;UN;Ini Valid;Fim Valid;Val Original" SKIP.
        
        FOR EACH tt-dados:
            IF tt-dados.cb3_ident_visual = ? 
               THEN ASSIGN tt-dados.cb3_ident_visual = "".
            IF tt-dados.val_perc_bxa < 0 
               THEN ASSIGN tt-dados.val_perc_bxa = 0.
            ASSIGN tt-dados.des_bem_pat = REPLACE(tt-dados.des_bem_pat,";"," ").
            PUT stream s_1 UNFORMATTED tt-dados.cod_estab                 + ";" +
                                       tt-dados.cod_cta_pat               + ";" +
                                       tt-dados.des_cta_pat               + ";" +
                                       STRING(tt-dados.num_bem_pat)       + ";" +
                                       STRING(tt-dados.num_seq_bem_pat)   + ";" +
                                       tt-dados.des_bem_pat               + ";" +
                                       STRING(tt-dados.dat_aquis_bem_pat) + ";" +
                                       tt-dados.cb3_ident_visual          + ";" +
                                       STRING(tt-dados.val_perc_bxa)      + ";" +
                                       tt-dados.cod_ccusto_respons        + ";" +
                                       STRING(tt-dados.val_perc_aprop)    + ";" +
                                       tt-dados.cod_unid_negoc            + ";" +
                                       STRING(tt-dados.dat_inic_valid)    + ";" +
                                       STRING(tt-dados.dat_fim_valid)     + ";" +
                                       STRING(tt-dados.val_original) SKIP.          
        END.
        
        OUTPUT STREAM s_1 CLOSE.

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
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/********************  End of rpt_motiv_movto_tit_acr_dem *******************/
