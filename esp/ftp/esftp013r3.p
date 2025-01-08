
{cdp\cd0666.i}
{esp\acr\acr711zo.i}

DEFINE VARIABLE v_num_aux_2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE v_num_cont AS INTEGER    NO-UNDO.
DEFINE VARIABLE v_num_aux AS INTEGER    NO-UNDO.
DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.

DEFINE INPUT  PARAM pcod_estabel     LIKE tit_acr.cod_estab.
DEFINE INPUT  PARAM pcod_espec_docto LIKE tit_acr.cod_espec_docto.
DEFINE INPUT  PARAM c-documento      LIKE tit_acr.cod_tit_acr.
DEFINE INPUT  PARAM tc-nossonumero   LIKE tit_acr.cod_tit_acr.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.
/*
BLOCO:
DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:*/

    FIND estabelec no-lock
        WHERE estabelec.cod-estabel = pcod_estabel NO-ERROR.
    
    FIND FIRST tit_acr NO-LOCK
         WHERE tit_acr.cod_estab            = pcod_estabel
         AND   tit_acr.cod_espec_docto      = pcod_espec_docto
         AND   tit_acr.cod_ser              = estabelec.serie
         AND   tit_acr.cod_tit_acr          = substr(c-documento,1,7)
         AND   tit_acr.cod_parcela          = substr(c-documento,9,2) NO-ERROR.
    IF  NOT AVAIL tit_acr THEN
        RUN piCriaErro(INPUT "NÆo encontrado T¡tulo para c¢digo.: " + substr(c-documento,1,7) + "/"+ substr(c-documento,9,2)).

    FOR FIRST tit_acr NO-LOCK
        WHERE tit_acr.cod_estab            = pcod_estabel
        AND   tit_acr.cod_espec_docto      = pcod_espec_docto
        AND   tit_acr.cod_ser              = estabelec.serie
        AND   tit_acr.cod_tit_acr          = substr(c-documento,1,7)
        AND   tit_acr.cod_parcela          = substr(c-documento,9,2):
          
        FIND FIRST int_tit_acr OF tit_acr NO-ERROR.
        IF  NOT AVAIL INT_tit_acr THEN
        DO:
            CREATE int_tit_acr.
            ASSIGN int_tit_acr.cod_cart_bcia       = tit_acr.cod_cart_bcia 
                   int_tit_acr.cod_estab           = tit_acr.cod_estab     
                   int_tit_acr.cod_portador        = tit_acr.cod_portador  
                   int_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr.
        END.
        ASSIGN int_tit_acr.log_boleto_impresso = YES.


        /*Calcula referencia automatica*/
        repeat:       
          ASSIGN v_num_aux_2 = integer(this-procedure:handle)
                 v_cod_refer_impl = "NN".
          
          do v_num_cont = 1 to 8:
            assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
                   v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).
          end.

          find first movto_tit_acr 
               where movto_tit_acr.cod_estab   = tit_acr.cod_estab
                 and   movto_tit_acr.cod_refer = v_cod_refer_impl no-lock no-error.

          if not avail movto_tit_acr then leave.
        end.                                       



        CREATE tt_alter_tit_acr_base_2.
        ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab                     
               tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr

               tt_alter_tit_acr_base_2.tta_dat_transacao               = tit_acr.dat_transacao
               tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
               tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ? /*tit_acr.val_sdo_tit_acr*/
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
               tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
               tt_alter_tit_acr_base_2.tta_cod_portador                = ? /*tit_acr.cod_portador                   */
               tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ? /*tit_acr.cod_cart_bcia                  */
               tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ? /*tit_acr.val_despes_bcia                */
               tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ? /*tit_acr.cod_agenc_cobr_bcia            */
               tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? /*tit_acr.cod_tit_acr_bco                */
               tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? /*tit_acr.dat_emis_docto                 */
               tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
               tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac 
               tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ? /*tit_acr.dat_fluxo_tit_acr              */
               tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ? /*tit_acr.ind_sit_tit_acr                */
               tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ? /*tit_acr.cod_cond_cobr                  */
               tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ? /*tit_acr.log_tip_cr_perda_dedut_tit     */
               tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ? /*tit_acr.dat_abat_tit_acr               */
               tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ? /*tit_acr.val_perc_abat_acr              */
               tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ? /*tit_acr.val_abat_tit_acr               */
               tt_alter_tit_acr_base_2.tta_dat_desconto                = ? /*tit_acr.dat_desconto                   */
               tt_alter_tit_acr_base_2.tta_val_perc_desc               = ? /*tit_acr.val_perc_desc                  */
               tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ? /*tit_acr.val_desc_tit_acr               */
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ? /*tit_acr.qtd_dias_carenc_juros_acr      */
               tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ? /*tit_acr.val_perc_juros_dia_atraso      */
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ? /*tit_acr.qtd_dias_carenc_multa_acr      */
               tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ? /*tit_acr.val_perc_multa_atraso          */
               tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?                                        
               tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ? /*tit_acr.ind_tip_cobr_acr               */
               tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ? /*tit_acr.ind_ender_cobr                 */
               tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ? /*tit_acr.nom_abrev_contat               */
               tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ? /*tit_acr.val_liq_tit_acr                */
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?                                         
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?                                        
               tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ? /*tit_acr.log_tit_acr_destndo            */
               tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?                                        
               tt_alter_tit_acr_base_2.ttv_des_text_histor             = ?                                        
               tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ? /*tit_acr.des_obs_cobr                     */
             /*tt_alter_tit_acr_base_2.ttv_wgh_lista                   = tit_acr.wgh_lista                      */
               tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ? /*tit_acr.num_seq_tit_acr*/               
               tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ? /*tit_acr.cod_estab */
            /*
               tt_alter_tit_acr_base_2.ttv_num_planilha_vendor         = tit_acr.num_planilha_vendor           
               tt_alter_tit_acr_base_2.ttv_cod_cond_pagto_vendor       = tit_acr.cod_cond_pagto_vendor         
               tt_alter_tit_acr_base_2.ttv_val_cotac_tax_vendor_clien  = tit_acr.val_cotac_tax_vendor_clien   
               tt_alter_tit_acr_base_2.ttv_dat_base_fechto_vendor      = tit_acr.dat_base_fechto_vendor      
               tt_alter_tit_acr_base_2.ttv_qti_dias_carenc_fechto      = tit_acr.qti_dias_carenc_fechto      
               tt_alter_tit_acr_base_2.ttv_log_assume_tax_bco          = tit_acr.log_assume_tax_bco            
               tt_alter_tit_acr_base_2.ttv_log_vendor                  = tit_acr.log_vendor                   
               */ 
               
               tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = entry(1,tc-nossonumero,"-") + 
                                                                         entry(2,tc-nossonumero,"-") /*titulo.titulo-banco = ... */
               tt_alter_tit_acr_base_2.tta_cod_portador                = "237"                       /* titulo.cod_portador = 237.*/
               tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = "11"                        /* titulo.modalidade   = 5   */
            .
    
        run prgfin/acr/acr711zo.py (Input 4,
                                    Input  table tt_alter_tit_acr_base_2,
                                    Input  table tt_alter_tit_acr_rateio,
                                    Input  table tt_alter_tit_acr_ped_vda,
                                    Input  table tt_alter_tit_acr_comis,
                                    Input  table tt_alter_tit_acr_cheq,
                                    Input  table tt_alter_tit_acr_iva,
                                    Input  table tt_alter_tit_acr_impto_retid_2,
                                    Input  table tt_alter_tit_acr_cobr_espec_2,
                                    Input  table tt_alter_tit_acr_rat_desp_rec,
                                    output table tt_log_erros_alter_tit_acr,
                                    Input no).
        IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN 
        DO:
            FOR EACH tt_log_erros_alter_tit_acr:
                RUN piCriaErro(INPUT tt_log_erros_alter_tit_acr.ttv_des_msg_erro).
                    /*
                DISP 
                     tt_log_erros_alter_tit_acr.tta_cod_estab                    column-label "Estab"
                     tt_log_erros_alter_tit_acr.tta_num_id_tit_acr               column-label "Token Cta Receber"
                     tt_log_erros_alter_tit_acr.ttv_num_mensagem                 column-label "N£mero Mensagem"
                     tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb              column-label "Tipo Mensagem"
                     tt_log_erros_alter_tit_acr.ttv_des_msg_erro                 column-label "Inconsistˆncia"
                     tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda                column-label "Mensagem Ajuda"
                    WITH 1 COLUMN 1 DOWN WIDTH 132.*/
            END.

        END.
        /*
        for each mov_tit_acr of tit_acr
            /* Ser  atualizado na API
            where mov_tit_acr.transacao = 0*/ :
            assign mov_tit_acr.cod_portador  = titulo.cod_portador
                   /*mov_tit_acr.modalidade = titulo.modalidade
                   mov_tit_acr.pedido-rep = titulo.titulo-banco*/ . 
        end. */
    END.
    /*
    FOR EACH  tit_acr
        WHERE tit_acr.cod_empresa          = '1'
        AND   tit_acr.cod_estab            = "101"
        AND   tit_acr.cod_tit_acr          = "0500007"
        AND   tit_acr.cod_espec_docto      = "DM"
        AND   tit_acr.cod_parcela          = "01":
    
        DISP tit_acr.cod_tit_acr_bco
             tit_acr.cod_portador
             tit_acr.cod_cart_bcia.
    END.
    MESSAGE 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    UNDO, LEAVE BLOCO.
    
END.
*/

PROCEDURE piCriaErro:
    DEF INPUT PARAM pMsg AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 17567
           tt-erro.mensagem = pMsg.

END PROCEDURE.
