/*****************************************************************************
** Descricao.............: Relaá∆o receb°veis cobranáa
** Versao................:  5.00.00.000
** Nome Externo..........: esp/acr/esacr032.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 22/10/2010
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
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

DEF TEMP-TABLE tt_liq_tit_acr 
  FIELD v_dat_trans          LIKE movto_tit_acr.dat_transacao           
  FIELD v_tot_a_vencer_1     LIKE movto_tit_acr.val_movto_tit_acr 
  FIELD v_tot_a_vencer_2     LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_a_vencer_3     LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_a_vencer_4     LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencto         LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_1      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_2      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_3      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_4      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_5      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_vencido_6      LIKE movto_tit_acr.val_movto_tit_acr
  FIELD v_tot_dia            LIKE movto_tit_acr.val_movto_tit_acr
  INDEX tt_liq IS PRIMARY UNIQUE v_dat_trans.

/************************* Variable Definition Begin ************************/
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.
DEFINE NEW SHARED VARIABLE c_cod_estab_selec AS CHARACTER FORMAT "x(2000)" 
     LABEL "Estabelecimento" 
     VIEW-AS EDITOR MAX-CHARS 2000
     SIZE 30 BY .88 NO-UNDO.

def button bt_selec_estab
    label "Todos"
    tooltip "Seleciona Estabelecimento"
    image file "image/im-ran_a.bmp"
    size 4 by 1.

DEF VAR v_cod_arq              AS CHAR NO-UNDO.
DEF VAR v_cod_filename_initial AS CHAR NO-UNDO.
DEF VAR v_cod_filename_final   AS CHAR NO-UNDO.
DEF VAR v_dat_trans_ini        AS DATE FORMAT "99/99/9999"  INITIAL TODAY  LABEL "Data Transaá∆o" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEF VAR v_dat_trans_fim        AS DATE FORMAT "99/99/9999"  INITIAL TODAY  VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE v_val_liq_movto_tit_acr AS DECIMAL     NO-UNDO.
    
/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.

/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 1 by 1.
def button bt_rnl1
    label "Exc"
    tooltip "Executar"
    image-up file "image/im-rnl"
    image-insensitive file "image/ii-rnl"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    c_cod_estab_selec  AT ROW 3 COL 18 COLON-ALIGNED HELP "Estabelecimento"
    bt_selec_estab     AT ROW 3 COL 50.5 FONT ?
        help "Seleciona Estabelecimento"
    v_dat_trans_ini
         at row 04.5 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_dat_trans_fim
         at row 04.5 col 33.00 COLON-ALIGNED LABEL "AtÇ" BGCOLOR 15 FONT 2
    v_cod_arq
         at row 06.20 col 18.00 colon-aligned label "Nome Arquivo"
         help "Arquivo com os dados para importaá∆o"
         view-as editor max-chars 250 no-word-wrap
         size 55 by 1
         bgcolor 15 font 2
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 76.34 font ?
         help "Sa°da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 08
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Relaá∆o Extrato Recebimento (ESACR032) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 78.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 05
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_cod_arq:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data                  in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data                   in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           v_cod_arq:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data                             = "HLP=000023693".
    /* enable function buttons */

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

ON CHOOSE OF bt_selec_estab IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    assign input frame f_bas_10_histor_fornec_import_ems c_cod_estab_selec.
    run esp/acr/esacr028a.p.
    display c_cod_estab_selec with frame f_bas_10_histor_fornec_import_ems.

END.


ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    DEFINE VARIABLE v_dat_liquidac AS DATE        NO-UNDO.

    ASSIGN c_cod_estab_selec
           v_dat_trans_ini
           v_dat_trans_fim
           v_cod_arq.

    IF c_cod_estab_selec = ""
    THEN DO:
         MESSAGE "Estabelecimento n∆o informado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF v_dat_trans_ini > v_dat_trans_fim 
    THEN DO:
         MESSAGE "Data final menor do que data inicial !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_arq:SCREEN-VALUE = REPLACE(v_cod_arq:SCREEN-VALUE, '~\', '/').

    IF NUM-ENTRIES(v_cod_arq, "/") = 0
    THEN DO:
         MESSAGE "Diret¢rio n∆o informado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_filename_initial = ENTRY(NUM-ENTRIES(v_cod_arq:SCREEN-VALUE, '/'), v_cod_arq:SCREEN-VALUE, '/')
           v_cod_filename_final   = SUBSTRING(v_cod_arq:SCREEN-VALUE, 1,
                                              LENGTH(v_cod_arq:SCREEN-VALUE) - LENGTH(v_cod_filename_initial) - 1)
           FILE-INFO:FILE-NAME    = v_cod_filename_final.
    IF FILE-INFO:FILE-TYPE = ?
    THEN DO:
         MESSAGE "Diret¢rio n∆o localizado: " v_cod_filename_final
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    DEFINE VARIABLE v_dat_aux   AS DATE        NO-UNDO.

    FOR EACH tt_liq_tit_acr:
        DELETE tt_liq_tit_acr.
    END.

    DEF BUFFER b_tt_liq_tit_acr FOR tt_liq_tit_acr.

    CREATE b_tt_liq_tit_acr.
    ASSIGN b_tt_liq_tit_acr.v_dat_trans = 12/31/9999.

    DO v_dat_aux = v_dat_trans_ini TO v_dat_trans_fim:

        IF NOT CAN-FIND(tt_liq_tit_acr
                        WHERE tt_liq_tit_acr.v_dat_trans = v_dat_aux) 
        THEN DO:
             CREATE tt_liq_tit_acr.
             ASSIGN tt_liq_tit_acr.v_dat_trans = v_dat_aux.
        END.

        FOR EACH estabelecimento NO-LOCK
            WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:
    
            FOR EACH movto_tit_acr NO-LOCK
                WHERE movto_tit_acr.cod_estab                   = estabelecimento.cod_estab
                  AND movto_tit_acr.dat_transacao               = v_dat_aux
                  AND movto_tit_acr.ind_trans_acr_abrev         = "LIQ"
                  AND movto_tit_acr.log_liquidac_contra_antecip = NO
                  AND movto_tit_acr.log_movto_estordo           = NO
                  AND movto_tit_acr.num_id_movto_cta_corren    <> 0:
    
                FIND tit_acr OF movto_tit_acr NO-LOCK.
    
                FOR EACH val_movto_tit_acr 
                    FIELDS(cod_estab num_id_movto_tit_acr num_id_val_movto_tit_acr cod_finalid_econ val_abat_tit_acr val_ajust_val_tit_acr val_juros 
                           val_saida_subst_nf_dupl val_liquidac_tit_acr val_desconto val_multa_tit_acr val_cm_tit_acr
                           val_despes_bcia val_despes_financ val_impto_operac_financ val_transf_estab cod_unid_negoc cod_tip_fluxo) NO-LOCK 
                     WHERE val_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                       AND val_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                       AND val_movto_tit_acr.cod_finalid_econ     = 'Corrente':
    
                    ASSIGN v_val_liq_movto_tit_acr = val_movto_tit_acr.val_liquidac_tit_acr.
    
                     /*montante recebido de t°tulos a vencer em 4 dias ou mais*/
                     IF (tit_acr.dat_fluxo_tit_acr - v_dat_aux) >= 4 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_a_vencer_1   = tt_liq_tit_acr.v_tot_a_vencer_1   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_a_vencer_1 = b_tt_liq_tit_acr.v_tot_a_vencer_1 + v_val_liq_movto_tit_acr.
                     /*montante recebido de t°tulos a vencer em 3 dias*/
                     IF (tit_acr.dat_fluxo_tit_acr - v_dat_aux) = 3 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_a_vencer_2   = tt_liq_tit_acr.v_tot_a_vencer_2   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_a_vencer_2 = b_tt_liq_tit_acr.v_tot_a_vencer_2 + v_val_liq_movto_tit_acr.
                     /*montante recebido de t°tulos a vencer em 2 dias*/
                     IF (tit_acr.dat_fluxo_tit_acr - v_dat_aux) = 2 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_a_vencer_3   = tt_liq_tit_acr.v_tot_a_vencer_3   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_a_vencer_3 = b_tt_liq_tit_acr.v_tot_a_vencer_3 + v_val_liq_movto_tit_acr.
                     /*montante recebido de t°tulos a vencer em 1 dias*/
                     IF (tit_acr.dat_fluxo_tit_acr - v_dat_aux) = 1 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_a_vencer_4   = tt_liq_tit_acr.v_tot_a_vencer_4   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_a_vencer_4 = b_tt_liq_tit_acr.v_tot_a_vencer_4 + v_val_liq_movto_tit_acr.
                     /*montante recebido de vencimentos do dia*/
                     IF tit_acr.dat_fluxo_tit_acr = v_dat_aux 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencto   = tt_liq_tit_acr.v_tot_vencto   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencto = b_tt_liq_tit_acr.v_tot_vencto + v_val_liq_movto_tit_acr.
                     /*montante recebido de 1 dias atr†s (vencido)*/
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) = 1 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_1   = tt_liq_tit_acr.v_tot_vencido_1   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_1 = b_tt_liq_tit_acr.v_tot_vencido_1 + v_val_liq_movto_tit_acr.
                     /*montante recebido de 2 dias atr†s*/
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) = 2 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_2   = tt_liq_tit_acr.v_tot_vencido_2   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_2 = b_tt_liq_tit_acr.v_tot_vencido_2 + v_val_liq_movto_tit_acr.
                     /*montante recebido de 3 dias atr†s*/
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) = 3 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_3   = tt_liq_tit_acr.v_tot_vencido_3   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_3 = b_tt_liq_tit_acr.v_tot_vencido_3 + v_val_liq_movto_tit_acr.
                     /*montante recebido de 4 dias atr†s*/
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) = 4 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_4   = tt_liq_tit_acr.v_tot_vencido_4   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_4 = b_tt_liq_tit_acr.v_tot_vencido_4 + v_val_liq_movto_tit_acr.
                     /*montante recebido de 5 dias atr†s*/
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) = 5 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_5   = tt_liq_tit_acr.v_tot_vencido_5   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_5 = b_tt_liq_tit_acr.v_tot_vencido_5 + v_val_liq_movto_tit_acr.
                     /*montante recebido de 6 dias em diante atr†s*/ 
                     IF (v_dat_aux - tit_acr.dat_fluxo_tit_acr) >= 6 
                        THEN ASSIGN tt_liq_tit_acr.v_tot_vencido_6   = tt_liq_tit_acr.v_tot_vencido_6   + v_val_liq_movto_tit_acr
                                    b_tt_liq_tit_acr.v_tot_vencido_6 = b_tt_liq_tit_acr.v_tot_vencido_6 + v_val_liq_movto_tit_acr.
                     /*total dia*/
                     ASSIGN tt_liq_tit_acr.v_tot_dia   = tt_liq_tit_acr.v_tot_dia   + v_val_liq_movto_tit_acr
                            b_tt_liq_tit_acr.v_tot_dia = b_tt_liq_tit_acr.v_tot_dia + v_val_liq_movto_tit_acr.
    
                END.
    
            END.
    
        END.
/*
        MESSAGE "Dia " v_dat_aux                                                            SKIP
                "Total Identificado " v_tot_dia                                             SKIP
                "montante recebido de t°tulos a vencer em 4 dias ou mais " v_tot_a_vencer_1 SKIP
                "montante recebido de t°tulos a vencer em 3 dias "         v_tot_a_vencer_2 SKIP
                "montante recebido de t°tulos a vencer em 2 dias "         v_tot_a_vencer_3 SKIP
                "montante recebido de t°tulos a vencer em 1 dias "         v_tot_a_vencer_4 SKIP
                "montante recebido de vencimentos do dia "                 v_tot_vencto     SKIP
                "montante recebido de 1 dias atr†s (vencido) "             v_tot_vencido_1  SKIP
                "montante recebido de 2 dias atr†s "                       v_tot_vencido_2  SKIP
                "montante recebido de 3 dias atr†s "                       v_tot_vencido_3  SKIP
                "montante recebido de 4 dias atr†s "                       v_tot_vencido_4  SKIP
                "montante recebido de 5 dias atr†s "                       v_tot_vencido_5  SKIP
                "montante recebido de 6 dias em diante atr†s "             v_tot_vencido_6  
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
    END.

    OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.

    PUT UNFORMATTED "Data/Per°odo;4+;3;2;1;0;-1;-2;-3;-4;-5;-6+;Total Dia" SKIP.
             
    FIND b_tt_liq_tit_acr
        WHERE b_tt_liq_tit_acr.v_dat_trans = 12/31/9999.

    FOR EACH tt_liq_tit_acr:

        IF tt_liq_tit_acr.v_tot_dia = 0 
           THEN NEXT.

        IF tt_liq_tit_acr.v_dat_trans = 12/31/9999 
           THEN PUT UNFORMATTED "Total;".
           ELSE PUT UNFORMATTED STRING(tt_liq_tit_acr.v_dat_trans, "99/99/9999") ";".

        PUT UNFORMATTED STRING(tt_liq_tit_acr.v_tot_a_vencer_1, ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_a_vencer_2, ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_a_vencer_3, ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_a_vencer_4, ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencto    , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_1 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_2 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_3 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_4 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_5 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_vencido_6 , ">>,>>>,>>>,>>9.99") ";" 
                        STRING(tt_liq_tit_acr.v_tot_dia       , ">>,>>>,>>>,>>9.99") ";".
        IF tt_liq_tit_acr.v_dat_trans <> 12/31/9999 
           THEN PUT UNFORMATTED STRING(tt_liq_tit_acr.v_tot_dia * 100 / b_tt_liq_tit_acr.v_tot_dia, ">9.99") "%" SKIP.
           ELSE PUT UNFORMATTED SKIP.

        IF tt_liq_tit_acr.v_dat_trans = 12/31/9999 
           THEN PUT UNFORMATTED ";"
                                STRING(tt_liq_tit_acr.v_tot_a_vencer_1 * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_a_vencer_2 * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_a_vencer_3 * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_a_vencer_4 * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencto     * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_1  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_2  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_3  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_4  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_5  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" 
                                STRING(tt_liq_tit_acr.v_tot_vencido_6  * 100 / tt_liq_tit_acr.v_tot_dia, ">9.99") "% ;" SKIP.

    END.

    OUTPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("") THEN.

    MESSAGE "Processamento conclu°do !" SKIP(1) "Verificar arquivo: " v_cod_arq
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

/*************************** Window Trigger Begin ***************************/

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_histor_fornec_import_ems.
END.

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign wh_w_program:title         = frame f_bas_10_histor_fornec_import_ems:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_10_histor_fornec_import_ems:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_histor_fornec_import_ems:width-chars
       wh_w_program:height-chars  = frame f_bas_10_histor_fornec_import_ems:height-chars - 0.85
       frame f_bas_10_histor_fornec_import_ems:row         = 1
       frame f_bas_10_histor_fornec_import_ems:col         = 1
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_10_histor_fornec_import_ems:handle).

pause 0 before-hide.

view frame f_bas_10_histor_fornec_import_ems.

enable bt_rnl1
       bt_exi
       c_cod_estab_selec
       bt_selec_estab   
       v_dat_trans_ini
       v_dat_trans_fim
       v_cod_arq      
       with frame f_bas_10_histor_fornec_import_ems.

ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "esacr032.csv".

DISP c_cod_estab_selec
     v_dat_trans_ini
     v_dat_trans_fim
     v_cod_arq WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_cod_arq:read-only in frame f_bas_10_histor_fornec_import_ems = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_histor_fornec_import_ems.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END PROCEDURE. /* pi_close_program */
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/
    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.
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
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
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
END PROCEDURE.







