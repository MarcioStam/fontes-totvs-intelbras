/*****************************************************************************
** Programa..............: esp/cms/escms012.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 09/03/2009
*****************************************************************************/

def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lanáto" column-label "Apropriacao Lanáto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid                        
          ttv_rec_integr_aprop_lancto_ctbl ascending
    .

def new shared temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posiá∆o"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending
    .

def new shared temp-table tt_integr_ctbl_valid_parametros no-undo
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem"
    .

def new shared temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequància Lanáto" column-label "Sequància Lanáto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont†bil" column-label "Hist¢rico Cont†bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequància CPartida" column-label "Sequància CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending
    .

def new shared temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending
    .

def temp-table tt_integr_lancto_ctbl_aux no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    .

def new shared temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descriá∆o Lote" column-label "Descriá∆o Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Cont†bil" column-label "Data Lote Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_log_integr_ctbl_online       as logical format "Sim/N∆o" initial no label "Integraá∆o Online" column-label "Integr Online"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    index tt_recid                        
          ttv_rec_integr_lote_ctbl         ascending.

DEF TEMP-TABLE tt_rateio_rep NO-UNDO 
    FIELD cod_unid_negoc  AS CHARACTER
    FIELD val_comis       AS DECIMAL.

DEF TEMP-TABLE tt_rateio NO-UNDO 
    FIELD cod_unid_negoc  AS CHARACTER
    FIELD val_comis       AS DECIMAL.

DEFINE VARIABLE v_tot_comis_db_cr AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_tot_comis_un    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_tot_comis_rep   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_num_seq         AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_tot_val_comis   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_tot_rat_conf    AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_periodo       AS CHARACTER FORMAT "999999"  NO-UNDO.
DEFINE VARIABLE v_dat_ini       AS DATE        NO-UNDO.
DEFINE VARIABLE v_dat_fim       AS DATE        NO-UNDO.
DEFINE VARIABLE v_mes           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_ano           AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_log_print  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_wgh_focus  AS WIDGET      NO-UNDO.
DEFINE VARIABLE v_log_method AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_log_answer AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_cod_arq    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_ccusto AS CHARACTER   NO-UNDO.

DEF NEW SHARED STREAM s_1.

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
def button bt_print
    label "&Rateia"
    tooltip "Rateia"
    size 1 by 1
    auto-go.

/************************** Frame Definition Begin **************************/

def frame f_rpt_41_tit_acr_faturamento
    rt_001
         at row 02.00 col 02.00
    " ParÉmetros " view-as text
         at row 01.70 col 04.00
    rt_cxcf
         at row 6.17 col 02.00 bgcolor 7 
    v_cod_estab_ini
         at row 02.75 col 15.43 colon-aligned label "Estabelecimento"
         help "Estabelecimento Inicial de Execuá∆o"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         at row 02.75 col 23.43 colon-aligned label "atÇ"
         help "Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_periodo
         at row 03.75 col 15.43 colon-aligned label "Per°odo"
         help "Per°odo"
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_print
         at row 6.38 col 4.00 font ?
         help "Rateia"
    bt_can
         at row 6.38 col 15.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 40.00 by 8.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Rateio Comiss∆o - escms012".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_tit_acr_faturamento = 10.00
           bt_can:height-chars         in frame f_rpt_41_tit_acr_faturamento = 01.00
           bt_print:width-chars          in frame f_rpt_41_tit_acr_faturamento = 10.00
           bt_print:height-chars         in frame f_rpt_41_tit_acr_faturamento = 01.00
           rt_001:width-chars          in frame f_rpt_41_tit_acr_faturamento = 36.00
           rt_001:height-chars         in frame f_rpt_41_tit_acr_faturamento = 03.5
           rt_cxcf:width-chars         in frame f_rpt_41_tit_acr_faturamento = 36.57
           rt_cxcf:height-chars        in frame f_rpt_41_tit_acr_faturamento = 01.42.
    /* set return-inserted = yes for editors */
    assign v_cod_estab_ini:private-data         in frame f_rpt_41_tit_acr_faturamento = "HLP=000000000":U
           v_cod_estab_fim:private-data         in frame f_rpt_41_tit_acr_faturamento = "HLP=000018542":U
           bt_print:private-data          in frame f_rpt_41_tit_acr_faturamento = "HLP=000010815":U
           bt_can:private-data            in frame f_rpt_41_tit_acr_faturamento = "HLP=000011050":U
           frame f_rpt_41_tit_acr_faturamento:private-data                      = "HLP=000000000".


ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_acr_faturamento
DO:

    assign v_log_print = YES
           input frame f_rpt_41_tit_acr_faturamento v_cod_estab_ini
           input frame f_rpt_41_tit_acr_faturamento v_cod_estab_fim
           input frame f_rpt_41_tit_acr_faturamento v_periodo.

END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_acr_faturamento */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_acr_faturamento
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_acr_faturamento */

/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

run prgtec/men/men901za.py (Input 'rpt_tit_acr_faturamento').
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_acr_faturamento')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_acr_faturamento')) /*msg_2012*/.
    return.
end /* if */.

/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_tit_acr_faturamento:title = frame f_rpt_41_tit_acr_faturamento:title
                            + chr(32)
                            + chr(40)
                            + trim("5.00.00.000":U)
                            + chr(41).

assign v_cod_estab_ini:screen-value  in frame f_rpt_41_tit_acr_faturamento = ""
       v_cod_estab_fim:screen-value  in frame f_rpt_41_tit_acr_faturamento = "ZZZ"
       v_periodo:screen-value  in frame f_rpt_41_tit_acr_faturamento = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99").

pause 0 before-hide.
view frame f_rpt_41_tit_acr_faturamento.

super_block:
repeat
    on stop undo super_block, retry super_block:

    enable bt_print
           bt_can
           v_cod_estab_ini
           v_cod_estab_fim
           v_periodo
           with frame f_rpt_41_tit_acr_faturamento.

    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_tit_acr_faturamento:

            assign v_log_print = no.
            if  valid-handle(v_wgh_focus) then
                wait-for go of frame f_rpt_41_tit_acr_faturamento focus v_wgh_focus.
            else
                wait-for go of frame f_rpt_41_tit_acr_faturamento.

            if  v_log_print = yes
            then do:

                assign v_log_method = session:set-wait-state('general').
                run pi_rpt_tit_acr_faturamento.
                assign v_log_method = session:set-wait-state("").
                leave main_block.

            end.
            else do:
                leave super_block.
            end.

        end.

    end.
end.

hide frame f_rpt_41_tit_acr_faturamento.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_show_report_2
** Descricao.............: pi_show_report_2
** Criado por............: Gilsinei
** Criado em.............: 07/03/1996 14:42:50
** Alterado por..........: bre19127
** Alterado em...........: 21/05/2002 10:16:34
*****************************************************************************/
PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE. /* pi_show_report_2 */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_tit_acr_faturamento
** Descricao.............: pi_rpt_tit_acr_faturamento
** Criado por............: src12113
** Criado em.............: 19/11/2002 19:52:13
** Alterado por..........: fut1147_3
** Alterado em...........: 30/03/2006 15:20:30
*****************************************************************************/
PROCEDURE pi_rpt_tit_acr_faturamento:

    ASSIGN v_dat_ini = DATE("01/" + SUBSTRING(v_periodo,5,2) + "/" + SUBSTRING(v_periodo,1,4)).

    IF SUBSTRING(v_periodo,5,2) = "12" 
       THEN ASSIGN v_mes = "01"
                   v_ano = string((int( SUBSTRING(v_periodo,1,4)) + 1), "9999").
       ELSE ASSIGN v_mes = string((int(SUBSTRING(v_periodo,5,2)) + 1),"99")
                   v_ano = string((int(SUBSTRING(v_periodo,1,4)) ), "9999").

       ASSIGN v_dat_fim = DATE("01/" + v_mes + "/" + v_ano) - 1.

    ASSIGN v_cod_arq = session:temp-directory + "escms012.txt".

    OUTPUT STREAM s_1 TO VALUE(v_cod_arq)
                   PAGED PAGE-SIZE VALUE(65) CONVERT TARGET 'iso8859-1'.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_estab >= v_cod_estab_ini
          AND estabelecimento.cod_estab <= v_cod_estab_fim:
        
        FOR EACH tt_integr_aprop_lancto_ctbl_1:
            DELETE tt_integr_aprop_lancto_ctbl_1.
        END.
        FOR EACH tt_integr_ctbl_valid_1:
            DELETE tt_integr_ctbl_valid_1.
        END.
        FOR EACH tt_integr_ctbl_valid_parametros:
            DELETE tt_integr_ctbl_valid_parametros.
        END.
        FOR EACH tt_integr_item_lancto_ctbl_1:
            DELETE tt_integr_item_lancto_ctbl_1.
        END.
        FOR EACH tt_integr_lancto_ctbl_1:
            DELETE tt_integr_lancto_ctbl_1.
        END.
        FOR EACH tt_integr_lancto_ctbl_aux:
            DELETE tt_integr_lancto_ctbl_aux.
        END.
        FOR EACH tt_integr_lote_ctbl_1:
            DELETE tt_integr_lote_ctbl_1.
        END.
        FOR EACH tt_rateio_rep:
            DELETE tt_rateio_rep.
        END.
        FOR EACH tt_rateio:
            DELETE tt_rateio.
        END.
        
        ASSIGN v_tot_comis_db_cr = 0
               v_tot_comis_un    = 0
               v_tot_comis_rep   = 0
               v_num_seq         = 0
               v_tot_val_comis   = 0.
    
        FOR EACH comissao-fat NO-LOCK USE-INDEX ch_sec
            WHERE comissao-fat.periodo     = v_periodo
              AND comissao-fat.cod-estabel = estabelecimento.cod_estab
              AND comissao-fat.cod-rep     < 1143 /* ** Valor informado pelo comercial ***/
            BREAK BY comissao-fat.cod-rep 
                  BY comissao-fat.unid-neg:
        
            ASSIGN v_tot_comis_un = v_tot_comis_un + comissao-fat.vl-comissao.
        
            IF LAST-OF (comissao-fat.unid-neg) 
            THEN DO:
        
                 FOR EACH comis-deb-cred    
                     WHERE comis-deb-cred.cod-estabel  = estabelecimento.cod_estab
                       AND comis-deb-cred.unid-neg     = comissao-fat.unid-neg
                       AND comis-deb-cred.cod-rep      = comissao-fat.cod-rep
                       AND comis-deb-cred.base-final   = YES
                       AND comis-deb-cred.dt-movto    >= v_dat_ini
                       AND comis-deb-cred.dt-movto    <= v_dat_fim:
        
                     IF comis-deb-cred.deb-cred = yes 
                        THEN ASSIGN v_tot_comis_db_cr = v_tot_comis_db_cr + comis-deb-cred.valor * -1.
                        ELSE ASSIGN v_tot_comis_db_cr = v_tot_comis_db_cr + comis-deb-cred.valor.
        
                 END.
                 
                 CREATE tt_rateio_rep.
                 ASSIGN tt_rateio_rep.cod_unid_negoc = comissao-fat.unid-neg
                        tt_rateio_rep.val_comis      = v_tot_comis_un + v_tot_comis_db_cr.
                 
                 ASSIGN v_tot_comis_rep   = v_tot_comis_rep + v_tot_comis_db_cr + v_tot_comis_un
                        v_tot_comis_db_cr = 0
                        v_tot_comis_un    = 0.
        
            END.
        
            IF LAST-OF (comissao-fat.cod-rep) 
            THEN DO:
        
                 /* ** Desconsidera do Rateio representantes que tiveram comiss∆o negariva, rateando o total de CPO entre as unidades e representantes v†lidos ***/
                 IF v_tot_comis_rep > 0 
                 THEN DO: 
        
                      FOR EACH tt_rateio_rep:
        
                          FIND tt_rateio EXCLUSIVE-LOCK
                              WHERE tt_rateio.cod_unid_negoc = tt_rateio_rep.cod_unid_negoc NO-ERROR.
                          IF NOT AVAIL tt_rateio 
                          THEN DO:
                               CREATE tt_rateio.
                               ASSIGN tt_rateio.cod_unid_negoc = tt_rateio_rep.cod_unid_negoc.
                          END.
                          ASSIGN tt_rateio.val_comis = tt_rateio.val_comis + tt_rateio_rep.val_comis.
        
                      END.
        
                 END.
                 
                 FOR EACH tt_rateio_rep:
                     DELETE tt_rateio_rep.
                 END.
                 ASSIGN v_tot_comis_rep = 0.
                 
            END.
        
        END.
    
        ASSIGN v_tot_rat_conf = 0.
        FOR EACH tt_rateio:
            ASSIGN v_tot_rat_conf = v_tot_rat_conf + tt_rateio.val_comis.
        END.
    
        ASSIGN v_log_answer = YES.
        MESSAGE SUBSTITUTE("Total estabelecimento &1: &2 . Confirma Rateio ?", estabelecimento.cod_estab, STRING(v_tot_rat_conf, ">,>>>,>>9.99"))
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE SUBSTITUTE("Rateio Comiss∆o") UPDATE v_log_answer.
        IF v_log_answer = YES
        THEN DO:

            CREATE tt_integr_lote_ctbl_1.
            ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL"
                   tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 99999
                   tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Rateio Comissao " + v_periodo
                   tt_integr_lote_ctbl_1.tta_cod_empresa          = estabelecimento.cod_empresa
                   tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = v_dat_fim
                   tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).
            
            CREATE tt_integr_lancto_ctbl_1.
            ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = ""
                   tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
                   tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
                   tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = v_dat_fim
                   tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).
            
            ASSIGN v_num_seq = 1.
            
            FOR EACH tt_rateio:
            
                ASSIGN v_cod_ccusto = "".
                IF estabelecimento.cod_estab = "101"
                THEN DO: 
                     IF tt_rateio.cod_unid_negoc = "ADM" 
                        THEN ASSIGN v_cod_ccusto = "25040".
                     IF tt_rateio.cod_unid_negoc = "TER" 
                        THEN ASSIGN v_cod_ccusto = "21040".
                     IF tt_rateio.cod_unid_negoc = "SEC" 
                        THEN ASSIGN v_cod_ccusto = "21045".
                     IF tt_rateio.cod_unid_negoc = "NET" 
                        THEN ASSIGN v_cod_ccusto = "21048".
                     IF tt_rateio.cod_unid_negoc = "CEN" 
                        THEN ASSIGN v_cod_ccusto = "21030".
                     IF tt_rateio.cod_unid_negoc = "CEL" 
                        THEN ASSIGN v_cod_ccusto = "21049".
                END.
                IF estabelecimento.cod_estab = "102"
                THEN DO: 
                     IF tt_rateio.cod_unid_negoc = "ADM" 
                        THEN ASSIGN v_cod_ccusto = "21010".
                END.

                CREATE tt_integr_item_lancto_ctbl_1.
                ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
                       tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v_num_seq
                       tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB"
                       tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padrao"
                       tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = "41110005"
                       tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = "Padrao"
                       tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = v_cod_ccusto
                       tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = estabelecimento.cod_estab
                       tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = tt_rateio.cod_unid_negoc
                       tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Rateio Comissao " + v_periodo
                       tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
                       tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = v_dat_fim
                       tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = tt_rateio.val_comis
                       tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
                       tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).
                
                CREATE tt_integr_aprop_lancto_ctbl_1.
                ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "Corrente"
                       tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = tt_rateio.cod_unid_negoc
                       tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = "Padrao"
                       tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = v_cod_ccusto
                       tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = tt_rateio.val_comis
                       tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
                       tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).
            
                ASSIGN v_num_seq       = v_num_seq + 1
                       v_tot_val_comis = v_tot_val_comis + tt_rateio.val_comis.
            
            END.
            
            CREATE tt_integr_item_lancto_ctbl_1.
            ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
                   tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v_num_seq
                   tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "CR"
                   tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padrao"
                   tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = "21930005"
                   tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = ""
                   tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = ""
                   tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = estabelecimento.cod_estab
                   tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = "ADM"
                   tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Rateio Comissao " + v_periodo
                   tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
                   tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = v_dat_fim
                   tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = v_tot_val_comis
                   tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
                   tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).
            
            CREATE tt_integr_aprop_lancto_ctbl_1.
            ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "Corrente"
                   tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = "ADM"
                   tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = ""
                   tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = ""
                   tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = v_tot_val_comis
                   tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
                   tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).
            
            RUN prgfin/fgl/fgl900zl.py (INPUT 3,
                                        INPUT "Aborta Tudo",
                                        INPUT YES,
                                        INPUT 66,
                                        INPUT "Apropriaá∆o",
                                        INPUT "Todos",
                                        INPUT YES,
                                        INPUT YES,
                                        INPUT-OUTPUT TABLE tt_integr_lote_ctbl_1,
                                        INPUT-OUTPUT TABLE tt_integr_lancto_ctbl_1,
                                        INPUT-OUTPUT TABLE tt_integr_item_lancto_ctbl_1,
                                        INPUT-OUTPUT TABLE tt_integr_aprop_lancto_ctbl_1,
                                        INPUT-OUTPUT TABLE tt_integr_ctbl_valid_1).
        END.
        ELSE DO:
             MESSAGE "Rateio cancelado pelo usu†rio !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.    

    OUTPUT STREAM s_1 CLOSE.
    RUN pi_show_report_2 (INPUT v_cod_arq).
    
END PROCEDURE. /* pi_rpt_tit_acr_faturamento */
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
/**********************  End of rpt_tit_acr_faturamento *********************/
