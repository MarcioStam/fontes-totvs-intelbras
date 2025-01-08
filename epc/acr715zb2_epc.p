/*****************************************************************************
** Programa.: epc/acr715zb2_epc.p
** Vers∆o...: 1.00
** Data.....: 10/01/2012
** Autor....: Estevan KrÅger - Exponencial TI
** Obs......: EPC para o programa de cancelamento de t°tulos
*****************************************************************************/


/*--- Definiá∆o das Temp-Tables ---*/
{esp/acr/esacr047a.i}

DEFINE TEMP-TABLE tt_epc_estrategico NO-UNDO
    FIELD ttv_cod_epc_event        AS CHARACTER FORMAT "x(12)"
    FIELD ttv_cod_epc_parameters   AS CHARACTER FORMAT "x(32)"
    FIELD ttv_cod_epc_msg          AS CHARACTER FORMAT "x(54)"
    INDEX tt_id_epc                IS PRIMARY
          ttv_cod_epc_parameters   ASCENDING
          ttv_cod_epc_event        ASCENDING.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT PARAM p_cod_evento AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt_epc_estrategico.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE c-nr-transacao AS CHARACTER   NO-UNDO.



/*--- Bloco Principal ---*/
IF  p_cod_evento <> "Valida - Cancelamento Titulo" THEN
    RETURN.

FIND FIRST tt_epc_estrategico NO-LOCK
    WHERE  tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
    AND    tt_epc_estrategico.ttv_cod_epc_parameters = "Id Movto" NO-ERROR.
IF  NOT AVAIL tt_epc_estrategico THEN
    RETURN.

FIND FIRST movto_tit_acr NO-LOCK
    WHERE  movto_tit_acr.cod_estab            = ENTRY(1,tt_epc_estrategico.ttv_cod_epc_msg,CHR(10))
    AND    movto_tit_acr.num_id_movto_tit_acr = INT(ENTRY(2,tt_epc_estrategico.ttv_cod_epc_msg,CHR(10))) NO-ERROR.
IF  NOT AVAIL movto_tit_acr THEN
    RETURN.

FIND FIRST tit_acr NO-LOCK
    WHERE  tit_acr.cod_estab      = movto_tit_acr.cod_estab
    AND    tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-ERROR.
IF  NOT AVAIL tit_acr THEN
    RETURN.

FIND FIRST nota-fiscal NO-LOCK
    WHERE  nota-fiscal.cod-estabel = tit_acr.cod_estab
    AND    nota-fiscal.serie       = tit_acr.cod_ser_docto
    AND    nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
IF  NOT AVAIL nota-fiscal THEN
    RETURN.


/* Condiá∆o de Pagamento marcada como SupplierCard */
FIND FIRST int-cond-pagto NO-LOCK
    WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
IF  AVAIL  int-cond-pagto
    AND    SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:

    /* O n£mero da transaá∆o Ç a juná∆o do Estabelecimento + SÇrie + Nr Nota Fiscal */
    ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999").

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    IF  NOT AVAIL emitente THEN
        RETURN.


    /* Se a nota ainda n∆o foi enviada para a SupplierCard, pode cancelar  */
    IF  NOT CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                     WHERE int-emitente-supcard-ocor.raiz-cnpj   = SUBSTRING(emitente.cgc,1,8)
                     AND   int-emitente-supcard-ocor.num-transac = c-nr-transacao
                     AND   int-emitente-supcard-ocor.ind-ocor    = "8.2") THEN
        RETURN "OK":U.

    /* Se a nota j† foi enviada e aprovada pela SupplierCard, n∆o pode cancelar */
    IF  CAN-FIND(LAST  int-emitente-supcard-ocor NO-LOCK
                 WHERE int-emitente-supcard-ocor.raiz-cnpj      = SUBSTRING(emitente.cgc,1,8)
                 AND   int-emitente-supcard-ocor.num-transac    = c-nr-transacao
                 AND   int-emitente-supcard-ocor.ind-ocor       = "8.3"
                 AND   int-emitente-supcard-ocor.log-habilitado = NO) THEN
        RETURN "OK":U.


    RUN pi-gera-antecipacao.

    CREATE tt_epc_estrategico.
    ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = p_cod_evento
           tt_epc_estrategico.ttv_cod_epc_parameters = "Erro"
           tt_epc_estrategico.ttv_cod_epc_msg        = "17006;T°tulo da SupplierCard;T°tulo relacionado a SupplierCard n∆o pode ser cancelado!".

    RETURN "NOK":U.
END.


RETURN "OK".



/*--- Procedures Internas ---*/
PROCEDURE pi-gera-antecipacao:
    DEFINE VARIABLE c-cod-refer       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-parcela     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-tot-val-titulo AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-acr900zi        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.
    
    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "101",
                                              INPUT  ?,
                                              OUTPUT c-cod-refer).

    CREATE tt_integr_acr_lote_impl. 
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = "1"
           tt_integr_acr_lote_impl.tta_cod_estab            = "101"
           tt_integr_acr_lote_impl.tta_cod_refer            = c-cod-refer
           tt_integr_acr_lote_impl.tta_dat_transacao        = TODAY
           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr     = "Antecipaá∆o"
           tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACREMS50"
           tt_integr_acr_lote_impl.ttv_cod_empresa_ext      = ""
           tt_integr_acr_lote_impl.tta_cod_estab_ext        = ""
           tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext = "".


    /* Verifica se j† foi gerada alguma parcela para o t°tulo */
    ASSIGN i-cod-parcela = 0.
    REPEAT:
        ASSIGN i-cod-parcela = i-cod-parcela + 1.
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab       = "101"
            AND    tit_acr.cod_espec_docto = "AN"
            AND    tit_acr.cod_ser_docto   = "4"
            AND    tit_acr.cod_tit_acr     = STRING(TODAY, "99999999")
            AND    tit_acr.cod_parcela     = STRING(i-cod-parcela, "99") NO-ERROR.
        IF  NOT AVAIL tit_acr THEN
            LEAVE.
    END.

    ASSIGN de-tot-val-titulo = nota-fiscal.vl-tot-nota.


    CREATE tt_integr_acr_item_lote_impl_8.
    ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
           tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "Antecipaá∆o"
           tt_integr_acr_item_lote_impl_8.tta_cod_portador               = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "AN"
           tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = STRING(i-cod-parcela, "99")
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = STRING(TODAY, "99999999")
           tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = 171061 
           tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = "4"          
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente"
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = "real"
           tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = ""
           tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = 2090
           tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = TODAY
           tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY
           tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
           tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
           tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "Cancelamento de T°tulo SupplierCard em " + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS") + ", por meio do programa acr715zb2_epc."
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
           tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_cobr_bcia        = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr_bco            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cartcred               = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_mes_ano_valid_cartao   = ""
           tt_integr_acr_item_lote_impl_8.tta_dat_compra_cartao_cr       = ? 
           tt_integr_acr_item_lote_impl_8.ttv_cod_comprov_vda            = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_autoriz_bco_emissor    = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_lote_origin            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_conces_telef           = ""
           tt_integr_acr_item_lote_impl_8.tta_num_ddd_localid_conces     = 0
           tt_integr_acr_item_lote_impl_8.tta_num_prefix_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_num_milhar_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_banco                  = "" 
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_bcia             = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cta_corren_bco         = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_digito_cta_corren      = ""
           tt_integr_acr_item_lote_impl_8.tta_val_cotac_indic_econ       = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_calc_juros         = "Simples"
           tt_integr_acr_item_lote_impl_8.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
           tt_integr_acr_item_lote_impl_8.tta_cod_motiv_movto_tit_acr    = ""
           tt_integr_acr_item_lote_impl_8.tta_log_liquidac_autom         = NO
           tt_integr_acr_item_lote_impl_8.ttv_num_parc_cartcred          = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_proces_export          = "".


    CREATE tt_integr_acr_aprop_ctbl_pend.
    ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
           tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = "11910010"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = "103"
           tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = de-tot-val-titulo
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = "ADM"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "padrao"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "".

    RELEASE tt_integr_acr_aprop_ctbl_pend.
    RELEASE tt_integr_acr_item_lote_impl_8.
    FIND FIRST tt_integr_acr_lote_impl NO-LOCK.


    IF  NOT VALID-HANDLE(h-acr900zi) THEN
        RUN prgfin\acr\acr900zi.py PERSISTENT SET h-acr900zi.

    IF  VALID-HANDLE(h-acr900zi) THEN
        RUN pi_main_code_integr_acr_new_9 IN h-acr900zi (INPUT 11,
                                                         INPUT "",  /*Matriz Trad Org Ext*/
                                                         INPUT YES, /*Log Atualiz Refer*/
                                                         INPUT NO,  /*Assume Data Emiss*/
                                                         INPUT TABLE tt_integr_acr_repres_comis_2,
                                                         INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_8,
                                                         INPUT TABLE tt_integr_acr_aprop_relacto_2).

    IF  VALID-HANDLE(h-acr900zi) THEN
        DELETE PROCEDURE h-acr900zi.

    /*ASSIGN l-erro = NO.
    FOR EACH tt_log_erros_atualiz:
        MESSAGE tt_log_erros_atualiz.ttv_des_msg_erro + " -> " + tt_log_erros_atualiz.ttv_des_msg_ajuda
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        ASSIGN l-erro = YES.
    END.

    IF  l-erro THEN
        RETURN "NOK":U.*/

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-referencia:
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-des-dat       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-num-aux       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.

    /* Gera o c¢digo da referància */
    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.


    /* Verifica se a referància Ç £nica */
    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-verifica-refer-unica-acr:
    /************************ Parameter Definition Begin ************************/
    DEF INPUT  PARAM p_cod_estab     AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOGICAL   FORMAT "Sim/N∆o" NO-UNDO.
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/
    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.
    /*************************** Buffer Definition End **************************/

    ASSIGN p_log_refer_uni = YES.

    IF  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  THEN DO:
        FIND FIRST b_lote_impl_tit_acr NO-LOCK
             WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
               AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
               AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
             USE-INDEX ltmplttc_id NO-ERROR.
        IF  AVAIL b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  THEN DO:
        FIND FIRST b_lote_liquidac_acr NO-LOCK
             WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
               AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
             USE-INDEX ltlqdccr_id NO-ERROR.
        IF  AVAIL b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "Operaá∆o financeira" /*l_operacao_financ*/  THEN DO:
        FIND FIRST b_operac_financ_acr NO-LOCK
             WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
               AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               AND RECID( b_operac_financ_acr )               <> p_rec_tabela
             USE-INDEX oprcfnna_id NO-ERROR.
        IF  AVAIL b_operac_financ_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table = 'cobr_especial_acr' THEN DO:
        FIND FIRST b_cobr_especial_acr NO-LOCK
             WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
               AND b_cobr_especial_acr.cod_refer = p_cod_refer
               AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
             USE-INDEX cbrspclc_id NO-ERROR.
        IF  AVAIL b_cobr_especial_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer
            AND   RECID(b_renegoc_acr)   <> p_rec_tabela
            NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                   AND RECID(b_movto_tit_acr)   <> p_rec_tabela
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.
    END.

END PROCEDURE.
