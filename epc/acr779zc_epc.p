/***********************************************************************************
** Programa..............: acr779zc_epc
** Objetivo..............: Alterar a forma de integra‡Æo para grande varejo
** Nome Externo..........: epc/acr779zc_epc.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 14/04/2010
** Programa Base.........: api_integracao_recebimento_acr_3 - prgfin/acr/acr779zc.py
***********************************************************************************/

/********************* Temporary Table Definition Begin *********************/

DEF TEMP-TABLE tt_epc_estrategico NO-UNDO 
    FIELD ttv_cod_epc_event                AS CHARACTER FORMAT "x(12)"
    FIELD ttv_cod_epc_parameters           AS CHARACTER FORMAT "x(32)"
    FIELD ttv_cod_epc_msg                  AS CHARACTER FORMAT "x(54)"
    INDEX tt_id_epc                        IS primary
          ttv_cod_epc_parameters           ASCENDING 
          ttv_cod_epc_event                ASCENDING.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

DEF INPUT PARAM p_cod_evento
    AS CHARACTER 
    FORMAT "x(1)"
    NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE  
    FOR tt_epc_estrategico.

/************************* Parameter Definition End *************************/

{esp/acr/acr711zo.i}
{esp/acr/esacr047a.i}

DEFINE VARIABLE c_cod_estab      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i_num_id_tit_acr AS INTEGER     NO-UNDO.

DEFINE VARIABLE c_cod_estab_tit    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_cod_espec_docto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_cod_ser_docto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_cod_tit_acr      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_cod_parcela      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de_val_sdo_tit_acr AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c_cod_refer        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h_acr900zi         AS HANDLE      NO-UNDO.
DEFINE VARIABLE i_cod_parcela      AS INTEGER     NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.

DEFINE TEMP-TABLE tt_val_tit_acr NO-UNDO
    FIELD cod_unid_negoc       LIKE val_tit_acr.cod_unid_negoc
    FIELD cod_tip_fluxo_financ LIKE val_tit_acr.cod_tip_fluxo_financ
    FIELD val_liq_tit_acr      LIKE val_tit_acr.val_liq_tit_acr
    FIELD val_origin_tit_acr   LIKE val_tit_acr.val_origin_tit_acr
    INDEX idx_unid_negoc       AS PRIMARY UNIQUE
          cod_unid_negoc
          cod_tip_fluxo_financ.

DEF BUFFER b_cliente     FOR emscad.cliente.
DEF BUFFER bint-emitente FOR int-emitente.
DEF BUFFER b_tit_acr     FOR tit_acr.
DEF BUFFER b2_tit_acr    FOR tit_acr.
DEF BUFFER b-emitente    FOR emitente.    

/****************************** Main Code Begin *****************************/

IF p_cod_evento = "Altera Tipo Integra‡Æo" THEN DO:
    FIND tt_epc_estrategico NO-LOCK
        WHERE tt_epc_estrategico.ttv_cod_epc_event      = "Altera Tipo Integra‡Æo"
          AND tt_epc_estrategico.ttv_cod_epc_parameters = "Cod Cliente" NO-ERROR.

    IF NOT AVAIL tt_epc_estrategico
       THEN RETURN "OK".

    FIND b_cliente NO-LOCK
        WHERE b_cliente.cod_empresa = v_cod_empres_usuar
          AND b_cliente.cdn_cliente = INT(tt_epc_estrategico.ttv_cod_epc_msg) NO-ERROR.
    IF NOT AVAIL b_cliente
       THEN RETURN "OK".

    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = b_cliente.cdn_cliente NO-ERROR.
    IF NOT AVAIL emitente
       THEN RETURN "OK".

    FIND bint-emitente NO-LOCK
        WHERE bint-emitente.cod-emitente = b_cliente.cdn_cliente NO-ERROR.
    IF NOT AVAIL bint-emitente 
       THEN RETURN "OK".

    FIND int-excecao-dev-cliente NO-LOCK 
        WHERE int-excecao-dev-cliente.id-identificacao = 2 /* Grupo Cobranca */
          AND int-excecao-dev-cliente.cod-gr-cli       = string(bint-emitente.cod-gr-cob) NO-ERROR.

    IF NOT AVAIL int-excecao-dev-cliente THEN
        FIND int-excecao-dev-cliente NO-LOCK 
            WHERE int-excecao-dev-cliente.id-identificacao = 1 /* Cliente */
              AND int-excecao-dev-cliente.cod-cliente      = bint-emitente.cod-emitente NO-ERROR.
    
    IF  NOT AVAIL int-excecao-dev-cliente THEN DO:
        FIND FIRST b-emitente NO-LOCK
            WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

        IF  AVAIL b-emitente THEN
            FIND int-excecao-dev-cliente NO-LOCK 
               WHERE int-excecao-dev-cliente.id-identificacao = 1 /* Cliente */
                 AND int-excecao-dev-cliente.cod-cliente      = b-emitente.cod-emitente NO-ERROR.

    END.

    IF AVAIL int-excecao-dev-cliente
    THEN DO:

        FIND tt_epc_estrategico NO-LOCK
            WHERE tt_epc_estrategico.ttv_cod_epc_event      = "Altera Tipo Integra‡Æo"
              AND tt_epc_estrategico.ttv_cod_epc_parameters = "Ind Tipo Integra‡Æo" NO-ERROR.
        IF NOT AVAIL tt_epc_estrategico 
        THEN DO:
             CREATE tt_epc_estrategico.
             ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "Altera Tipo Integra‡Æo"
                    tt_epc_estrategico.ttv_cod_epc_parameters = "Ind Tipo Integra‡Æo".
        END.
    
        /* ** Altera o parƒmetro de integra‡Æo para gerar AN ao inv‚s de Creditar a nota devolvida - Grande Varejo ***/
        ASSIGN tt_epc_estrategico.ttv_cod_epc_msg = "Antecipa".

        RETURN "OK":U.
    END.



    FIND FIRST tt_epc_estrategico NO-LOCK
        WHERE  tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
        AND    tt_epc_estrategico.ttv_cod_epc_parameters = "Cod Estab" NO-ERROR.
    IF  AVAIL  tt_epc_estrategico THEN
        ASSIGN c_cod_estab = tt_epc_estrategico.ttv_cod_epc_msg.

    FIND FIRST tt_epc_estrategico NO-LOCK
        WHERE  tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
        AND    tt_epc_estrategico.ttv_cod_epc_parameters = "Num ID tit ACR" NO-ERROR.
    IF  AVAIL  tt_epc_estrategico THEN
        ASSIGN i_num_id_tit_acr = INT(tt_epc_estrategico.ttv_cod_epc_msg).

    FIND FIRST b_tit_acr NO-LOCK
        WHERE  b_tit_acr.cod_estab      = c_cod_estab
        AND    b_tit_acr.num_id_tit_acr = i_num_id_tit_acr NO-ERROR.
    IF  NOT AVAIL b_tit_acr THEN
        RETURN.

    IF  b_tit_acr.cod_portador     = '9915'     /* Caso seja t¡tulo da SupplierCard, altera o parƒmetro de integra‡Æo para gerar AN ao inv‚s de Creditar a nota devolvida */
    OR  b_tit_acr.ind_tip_cobr_acr = "Especial" /* caso seja e-commerce gera antecipa‡Æo ao inv‚s de creditar */ THEN DO:

        FIND FIRST tt_epc_estrategico EXCLUSIVE-LOCK
            WHERE  tt_epc_estrategico.ttv_cod_epc_event      = "Altera Tipo Integra‡Æo"
            AND    tt_epc_estrategico.ttv_cod_epc_parameters = "Ind Tipo Integra‡Æo" NO-ERROR.
        IF  NOT AVAIL tt_epc_estrategico THEN DO:
             CREATE tt_epc_estrategico.
             ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "Altera Tipo Integra‡Æo"
                    tt_epc_estrategico.ttv_cod_epc_parameters = "Ind Tipo Integra‡Æo".
        END.
    
        ASSIGN tt_epc_estrategico.ttv_cod_epc_msg = "Antecipa".
    END.
END.

IF p_cod_evento = "Baixa_Dup_Antecip":U THEN DO:
    FIND FIRST tt_epc_estrategico
        WHERE tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
          AND tt_epc_estrategico.ttv_cod_epc_parameters = "Liquida_Titulo":U NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tt_epc_estrategico THEN
        RETURN "OK":U.

    IF NUM-ENTRIES(tt_epc_estrategico.ttv_cod_epc_msg, CHR(10)) < 5 THEN
        RETURN "OK":U.

    ASSIGN c_cod_estab_tit   = TRIM(ENTRY(1, tt_epc_estrategico.ttv_cod_epc_msg, CHR(10)))
           c_cod_espec_docto = TRIM(ENTRY(2, tt_epc_estrategico.ttv_cod_epc_msg, CHR(10)))
           c_cod_ser_docto   = TRIM(ENTRY(3, tt_epc_estrategico.ttv_cod_epc_msg, CHR(10)))
           c_cod_tit_acr     = TRIM(ENTRY(4, tt_epc_estrategico.ttv_cod_epc_msg, CHR(10)))
           c_cod_parcela     = TRIM(ENTRY(5, tt_epc_estrategico.ttv_cod_epc_msg, CHR(10))).

    FIND FIRST b_tit_acr
        WHERE b_tit_acr.cod_estab       = c_cod_estab_tit
          AND b_tit_acr.cod_espec_docto = c_cod_espec_docto
          AND b_tit_acr.cod_ser_docto   = c_cod_ser_docto
          AND b_tit_acr.cod_tit_acr     = c_cod_tit_acr
          AND b_tit_acr.cod_parcela     = c_cod_parcela NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b_tit_acr THEN
        RETURN "OK":U.

    IF b_tit_acr.cod_portador = "9915":U THEN DO:
        FIND FIRST espec_docto_financ_acr
            WHERE espec_docto_financ_acr.cod_espec_docto = c_cod_espec_docto NO-LOCK NO-ERROR.

        IF AVAILABLE espec_docto_financ_acr THEN DO:
            FIND LAST b_tit_acr
                WHERE b_tit_acr.cod_estab       = c_cod_estab_tit
                  AND b_tit_acr.cod_espec_docto = espec_docto_financ_acr.cod_espec_docto_antecip
                  AND b_tit_acr.cod_ser_docto   = c_cod_ser_docto
                  AND b_tit_acr.cod_tit_acr     = c_cod_tit_acr NO-LOCK NO-ERROR.

            IF NOT AVAILABLE b_tit_acr THEN
                RETURN "OK":U.

            FIND FIRST int-contas-supcard
                WHERE int-contas-supcard.tipo-despesa = "Transit¢ria":U NO-LOCK NO-ERROR.

            IF NOT AVAIL int-contas-supcard THEN
                RETURN "OK":U.

            EMPTY TEMP-TABLE tt_val_tit_acr.

            FOR EACH val_tit_acr NO-LOCK
                WHERE val_tit_acr.cod_estab      = b_tit_acr.cod_estab
                  AND val_tit_acr.num_id_tit_acr = b_tit_acr.num_id_tit_acr:
                FIND FIRST tt_val_tit_acr
                    WHERE tt_val_tit_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc
                      AND tt_val_tit_acr.cod_tip_fluxo_financ = val_tit_acr.cod_tip_fluxo_financ EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAILABLE tt_val_tit_acr THEN DO:
                    CREATE tt_val_tit_acr.
                    ASSIGN tt_val_tit_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc
                           tt_val_tit_acr.cod_tip_fluxo_financ = val_tit_acr.cod_tip_fluxo_financ.
                END.

                ASSIGN tt_val_tit_acr.val_origin_tit_acr = tt_val_tit_acr.val_origin_tit_acr + val_tit_acr.val_sdo_tit_acr.
            END.

            ASSIGN de_val_sdo_tit_acr = b_tit_acr.val_sdo_tit_acr.

            RUN pi_gera_referencia IN THIS-PROCEDURE (INPUT  b_tit_acr.cod_estab,
                                                      INPUT  RECID(b_tit_acr),
                                                      OUTPUT c_cod_refer).

            EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.
            EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
            EMPTY TEMP-TABLE tt_alter_tit_acr_ped_vda.
            EMPTY TEMP-TABLE tt_alter_tit_acr_comis.
            EMPTY TEMP-TABLE tt_alter_tit_acr_cheq.
            EMPTY TEMP-TABLE tt_alter_tit_acr_iva.
            EMPTY TEMP-TABLE tt_alter_tit_acr_impto_retid_2.
            EMPTY TEMP-TABLE tt_alter_tit_acr_cobr_espec_2.
            EMPTY TEMP-TABLE tt_alter_tit_acr_rat_desp_rec.

            CREATE tt_alter_tit_acr_rateio.
            ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = b_tit_acr.cod_estab
                   tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = b_tit_acr.num_id_tit_acr
                   tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Altera‡Æo":U
                   tt_alter_tit_acr_rateio.tta_cod_refer                   = c_cod_refer
                   tt_alter_tit_acr_rateio.tta_num_seq_refer               = 1
                   tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                   tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = int-contas-supcard.cod-conta
                   tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 10
                   tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = b_tit_acr.val_sdo_tit_acr.

            CREATE tt_alter_tit_acr_base_2.
            ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = b_tit_acr.cod_estab
                   tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = b_tit_acr.num_id_tit_acr
                   tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY
                   tt_alter_tit_acr_base_2.tta_cod_refer                   = c_cod_refer
                   tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
                   tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = 0
                   tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = "":U
                   tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Liquida‡Æo":U
                   tt_alter_tit_acr_base_2.tta_cod_portador                = ?
                   tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?
                   tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
                   tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
                   tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
                   tt_alter_tit_acr_base_2.tta_dat_emis_docto              = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
                   tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
                   tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?  
                   tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
                   tt_alter_tit_acr_base_2.tta_dat_desconto                = 01/01/0001
                   tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
                   tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
                   tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
                   tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
                   tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
                   tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
                   tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
                   tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
                   tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
                   tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Transferencia de saldo para SupplierCard":U
                   tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = "NORMAL":U
                   tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
                   tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?.

            RUN prgfin/acr/acr711zo.py (INPUT  4,
                                        INPUT  TABLE tt_alter_tit_acr_base_2,
                                        INPUT  TABLE tt_alter_tit_acr_rateio,
                                        INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                        INPUT  TABLE tt_alter_tit_acr_comis,
                                        INPUT  TABLE tt_alter_tit_acr_cheq,
                                        INPUT  TABLE tt_alter_tit_acr_iva,
                                        INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                        INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                        INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                        OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                        INPUT  NO).

            IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN
                RETURN "OK":U.

            EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
            EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_8.
            EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.
            EMPTY TEMP-TABLE tt_integr_acr_repres_comis_2.
            EMPTY TEMP-TABLE tt_integr_acr_aprop_relacto_2.
            EMPTY TEMP-TABLE tt_log_erros_atualiz.

            ASSIGN i_cod_parcela = 0.

            REPEAT:
                ASSIGN i_cod_parcela = i_cod_parcela + 1.

                FIND FIRST b2_tit_acr
                    WHERE b2_tit_acr.cod_estab       = b_tit_acr.cod_estab
                      AND b2_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                      AND b2_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                      AND b2_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                      AND b2_tit_acr.cod_parcela     = STRING(i_cod_parcela, "99":U) NO-LOCK NO-ERROR.

                IF NOT AVAILABLE b2_tit_acr THEN
                    LEAVE.
            END.

            RUN pi_gera_referencia IN THIS-PROCEDURE (INPUT  b_tit_acr.cod_estab,
                                                      INPUT  ?,
                                                      OUTPUT c_cod_refer).

            CREATE tt_integr_acr_lote_impl.
            ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = v_cod_empres_usuar
                   tt_integr_acr_lote_impl.tta_cod_estab            = b_tit_acr.cod_estab
                   tt_integr_acr_lote_impl.tta_cod_refer            = c_cod_refer
                   tt_integr_acr_lote_impl.tta_dat_transacao        = TODAY
                   tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr     = "Normal":U
                   tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACREMS50":U
                   tt_integr_acr_lote_impl.ttv_cod_empresa_ext      = "":U
                   tt_integr_acr_lote_impl.tta_cod_estab_ext        = "":U
                   tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext = "":U.

            CREATE tt_integr_acr_item_lote_impl_8.
            ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
                   tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = 1
                   tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "Antecipa‡Æo":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_portador               = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = b_tit_acr.cod_espec_docto
                   tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = STRING(i_cod_parcela, "99":U)
                   tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = b_tit_acr.cod_tit_acr
                   tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = 171061
                   tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = b_tit_acr.cod_ser_docto
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = b_tit_acr.cod_indic_econ
                   tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = b_tit_acr.cdn_repres
                   tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = b_tit_acr.dat_vencto_tit_acr
                   tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
                   tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
                   tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY
                   tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = "":U
                   tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = de_val_sdo_tit_acr
                   tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
                   tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = "":U
                   tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ?
                   tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = de_val_sdo_tit_acr
                   tt_integr_acr_item_lote_impl_8.tta_cod_agenc_cobr_bcia        = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr_bco            = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_cartcred               = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_mes_ano_valid_cartao   = "":U
                   tt_integr_acr_item_lote_impl_8.tta_dat_compra_cartao_cr       = ?
                   tt_integr_acr_item_lote_impl_8.ttv_cod_comprov_vda            = "":U
                   tt_integr_acr_item_lote_impl_8.ttv_cod_autoriz_bco_emissor    = "":U
                   tt_integr_acr_item_lote_impl_8.ttv_cod_lote_origin            = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_conces_telef           = "":U
                   tt_integr_acr_item_lote_impl_8.tta_num_ddd_localid_conces     = 0
                   tt_integr_acr_item_lote_impl_8.tta_num_prefix_localid_conces  = 0
                   tt_integr_acr_item_lote_impl_8.tta_num_milhar_localid_conces  = 0
                   tt_integr_acr_item_lote_impl_8.tta_cod_banco                  = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_agenc_bcia             = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_cta_corren_bco         = "":U
                   tt_integr_acr_item_lote_impl_8.tta_cod_digito_cta_corren      = "":U
                   tt_integr_acr_item_lote_impl_8.tta_val_cotac_indic_econ       = 1
                   tt_integr_acr_item_lote_impl_8.tta_ind_tip_calc_juros         = "Simples":U
                   tt_integr_acr_item_lote_impl_8.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
                   tt_integr_acr_item_lote_impl_8.tta_cod_motiv_movto_tit_acr    = "":U
                   tt_integr_acr_item_lote_impl_8.tta_log_liquidac_autom         = NO
                   tt_integr_acr_item_lote_impl_8.ttv_num_parc_cartcred          = 0
                   tt_integr_acr_item_lote_impl_8.tta_cod_proces_export          = "":U.

            FOR EACH tt_val_tit_acr NO-LOCK:
                CREATE tt_integr_acr_aprop_ctbl_pend.
                ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = int-contas-supcard.cod-conta
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = tt_val_tit_acr.cod_tip_fluxo_financ
                       tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_val_tit_acr.val_origin_tit_acr
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = tt_val_tit_acr.cod_unid_negoc
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "padrao":U
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = "":U
                       tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "":U.
            END.

            RELEASE tt_integr_acr_aprop_ctbl_pend.
            RELEASE tt_integr_acr_item_lote_impl_8.

            FIND FIRST tt_integr_acr_lote_impl NO-LOCK NO-ERROR.

            IF NOT VALID-HANDLE(h_acr900zi) THEN
                RUN prgfin/acr/acr900zi.py PERSISTENT SET h_acr900zi.

            IF VALID-HANDLE(h_acr900zi) THEN
                RUN pi_main_code_integr_acr_new_9 IN h_acr900zi (INPUT 11,
                                                                 INPUT "":U,  /* Matriz Trad Org Ext */
                                                                 INPUT YES,   /* Log Atualiza Refer  */
                                                                 INPUT NO,    /* Assume Data EmissÆo */
                                                                 INPUT TABLE tt_integr_acr_repres_comis_2,
                                                                 INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_8,
                                                                 INPUT TABLE tt_integr_acr_aprop_relacto_2).

            IF VALID-HANDLE(h_acr900zi) THEN
                DELETE PROCEDURE h_acr900zi.

            ASSIGN h_acr900zi = ?.

            IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN
                RETURN "OK":U.
        END.
    END.
END.

IF  p_cod_evento = 'altera_tipo_integracao_aux' THEN DO:
    
    FIND tt_epc_estrategico NO-LOCK
        WHERE tt_epc_estrategico.ttv_cod_epc_event      = "altera_tipo_integracao_aux"
        AND   tt_epc_estrategico.ttv_cod_epc_parameters = "nat-operacao" NO-ERROR.

    IF  AVAIL tt_epc_estrategico THEN DO:

        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = tt_epc_estrategico.ttv_cod_epc_msg NO-LOCK NO-ERROR.

        /* caso seja nota de reentrada ou de cancelamento, continua abatendo as DPïs */
        IF  AVAIL natur-oper 
        AND natur-oper.imp-nota = YES THEN DO:
            CREATE tt_epc_estrategico.
            ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "altera_tipo_integracao_aux"
                   tt_epc_estrategico.ttv_cod_epc_parameters = "ret_altera_tipo_integracao_aux"
                   tt_epc_estrategico.ttv_cod_epc_msg        = "Credita/Antecipa".
        END.
    END.

END.

RETURN "OK":U.


PROCEDURE pi_gera_referencia :
    DEFINE INPUT  PARAMETER p_cod_estab  AS CHARACTER   NO-UNDO FORMAT "x(03)":U.
    DEFINE INPUT  PARAMETER p_rec_tabela AS RECID       NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_referencia AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c_des_dat       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i_num_aux       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l_log_refer_uni AS LOGICAL     NO-UNDO.

    /* Gera o c¢digo da referˆncia */
    ASSIGN c_des_dat    = STRING(TODAY, "99999999":U)
           p_referencia = SUBSTRING(c_des_dat, 7, 2) + SUBSTRING(c_des_dat, 3, 2) + SUBSTRING(c_des_dat, 1, 2) + "T":U
           i_num_aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO i_cont = 1 TO 3:
        ASSIGN p_referencia = p_referencia + CHR((RANDOM(0, i_num_aux) MODULO 26) + 97).
    END.

    /* Verifica se a referˆncia ‚ £nica */
    RUN pi_verifica_referencia_unica_acr IN THIS-PROCEDURE (INPUT  p_cod_estab,
                                                            INPUT  p_referencia,
                                                            INPUT  "":U,
                                                            INPUT  p_rec_tabela,
                                                            OUTPUT l_log_refer_uni).

    IF NOT l_log_refer_uni THEN
        RUN pi_gera_referencia IN THIS-PROCEDURE (INPUT  p_cod_estab,
                                                  INPUT  p_rec_tabela,
                                                  OUTPUT p_referencia).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_verifica_referencia_unica_acr :
    DEFINE INPUT  PARAMETER p_cod_estab     AS CHARACTER   NO-UNDO FORMAT "x(03)":U.
    DEFINE INPUT  PARAMETER p_cod_refer     AS CHARACTER   NO-UNDO FORMAT "x(10)":U.
    DEFINE INPUT  PARAMETER p_cod_table     AS CHARACTER   NO-UNDO FORMAT "x(08)":U.
    DEFINE INPUT  PARAMETER p_rec_tabela    AS RECID       NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_log_refer_uni AS LOGICAL     NO-UNDO FORMAT "Sim/NÆo":U.

    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.

    ASSIGN p_log_refer_uni = YES.

    IF p_cod_table <> "lote_impl_tit_acr":U THEN DO:
        FIND FIRST b_lote_impl_tit_acr
            WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
              AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
              AND RECID(b_lote_impl_tit_acr)   <> p_rec_tabela USE-INDEX ltmplttc_id NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF p_cod_table <> "lote_liquidac_acr":U THEN DO:
        FIND FIRST b_lote_liquidac_acr
            WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
              AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
              AND RECID(b_lote_liquidac_acr)         <> p_rec_tabela USE-INDEX ltlqdccr_id NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF p_cod_table <> "Opera‡Æo financeira":U THEN DO:
        FIND FIRST b_operac_financ_acr
            WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
              AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
              AND RECID(b_operac_financ_acr)                 <> p_rec_tabela USE-INDEX oprcfnna_id NO-LOCK NO-ERROR.

        IF AVAILABLE b_operac_financ_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF p_cod_table = "cobr_especial_acr":U THEN DO:
        FIND FIRST b_cobr_especial_acr
            WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
              AND b_cobr_especial_acr.cod_refer = p_cod_refer
              AND RECID(b_cobr_especial_acr)   <> p_rec_tabela USE-INDEX cbrspclc_id NO-LOCK NO-ERROR.

        IF AVAILABLE b_cobr_especial_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF p_log_refer_uni THEN DO:
        FIND FIRST b_renegoc_acr
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
              AND b_renegoc_acr.cod_refer = p_cod_refer
              AND RECID(b_renegoc_acr)   <> p_rec_tabela NO-LOCK NO-ERROR.

        IF AVAILABLE b_renegoc_acr THEN
            ASSIGN p_log_refer_uni = NO.
        ELSE DO:
            FIND FIRST b_movto_tit_acr
                WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                  AND b_movto_tit_acr.cod_refer = p_cod_refer
                  AND RECID(b_movto_tit_acr)   <> p_rec_tabela USE-INDEX mvtttcr_refer NO-LOCK NO-ERROR.

            IF AVAILABLE b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

