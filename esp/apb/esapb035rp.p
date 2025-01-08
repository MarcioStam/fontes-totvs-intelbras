/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esapb035rp 1.00.00.000}
/*****************************************************************************
**       Programa: esp/apb/esapb035rp.p
**       Data....: 23/10/2018
**       Autor...: Andrey M Oliveira
**       Objetivo: Abatimento de Antecipa‡äes ACR (Troca expressa).
*******************************************************************************/

{include/i-rpvar.i}    
{utp/utapi019.i}
{esp/apb/esapb035.i}
{esapi/esapi015tt.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHARACTER FORMAT "x(35)":U
    FIELD usuario            AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD i-tipo-concilia    AS INT
    FIELD dt-pagto           AS DATE
    FIELD c-conta-ava        AS CHAR
    FIELD c-email            AS CHAR
    FIELD gr-cob-ini         AS INT
    FIELD gr-cob-fim         AS INT
    FIELD gr-cli-ini         LIKE emscad.cliente.cod_grp_clien
    FIELD gr-cli-fim         LIKE emscad.cliente.cod_grp_clien
    FIELD matriz-ini         AS INT
    FIELD matriz-fim         AS INT
    FIELD emit-ini           AS INT
    FIELD emit-fim           AS INT
    FIELD dt-tra-ini         AS DATE
    FIELD dt-tra-fim         AS DATE
    FIELD tg-conferencia     AS LOG.
 
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE for tt-raw-digita.

DEF TEMP-TABLE tt-refer NO-UNDO
    FIELD cod-estab LIKE tit_acr.cod_estab
    FIELD cod-refer AS CHAR FORMAT "x(10)".

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD num-transac    LIKE int-pagtos-supcard-ocor.num-transac
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(150)"
    FIELD l-erro         AS LOGICAL.

DEF TEMP-TABLE tt-total-cliente NO-UNDO
    FIELD cod-estab   LIKE tit_acr.cod_estab  
    FIELD cdn-cliente LIKE tit_acr.cdn_cliente
    FIELD total-saldo LIKE tit_acr.val_sdo_tit_acr
    FIELD historico   LIKE tt_integr_apb_item_lote_impl3v.tta_des_text_histor.

DEF TEMP-TABLE tt-concil NO-UNDO
    FIELD cod_estab   LIKE tit_acr.cod_estab
    FIELD cdn_cli_for LIKE tit_acr.cdn_cliente
    FIELD cod_espec   LIKE tit_acr.cod_espec
    FIELD cod_serie   LIKE tit_acr.cod_ser_docto
    FIELD cod_titulo  LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela LIKE tit_acr.cod_parcela
    FIELD valor       LIKE tit_acr.val_sdo_tit_acr
    FIELD nf-devol    LIKE nota_devol_tit_acr.cod_nota_devol 
    FIELD cod_modulo  AS CHAR.

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD num_id_tit_acr LIKE tit_acr.num_id_tit_acr
    FIELD cod_estab      LIKE tit_acr.cod_estab
    FIELD cdn_cliente    LIKE tit_acr.cdn_cliente
        INDEX concil cod_estab 
                     cdn_cliente.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.

DEF VAR h-acomp         AS HANDLE                                               NO-UNDO.
DEF VAR c-tipo          AS CHAR                                                 NO-UNDO.
DEF VAR c-email         AS CHAR                                                 NO-UNDO.
DEF VAR c-arq-anexo     AS CHAR                                                 NO-UNDO.
DEF VAR de-total-an     LIKE tit_acr.val_sdo_tit_acr                            NO-UNDO.
DEF VAR c-cod-refer     AS CHAR                                                 NO-UNDO.
DEF VAR l-erro          AS LOG                                                  NO-UNDO.
DEF VAR c-des-dat       AS CHAR                                                 NO-UNDO.
DEF VAR i-num-aux       AS INT64                                                NO-UNDO.
DEF VAR i-cont          AS INT                                                  NO-UNDO.
DEF VAR v_hdl_aux       AS HANDLE                                               NO-UNDO.
DEF VAR da-vencto-apb   LIKE tt-param.dt-pagto                                  NO-UNDO.
DEF VAR c-cod-tit       LIKE tit_ap.cod_tit_ap                                  NO-UNDO.
DEF VAR c-parcela       LIKE tit_ap.cod_parcela                                 NO-UNDO.
DEF VAR v_log_refer_uni AS LOG INIT NO                                          NO-UNDO.
DEF VAR de-acerto       LIKE tit_acr.val_sdo_tit_acr                            NO-UNDO.
DEF VAR c-nf-devol      AS CHAR                                                 NO-UNDO.
DEF VAR c-historico     LIKE tt_integr_apb_item_lote_impl3v.tta_des_text_histor NO-UNDO.

DEF BUFFER b_tit_acr FOR tit_acr.

create tt-param.
raw-transfer raw-param to tt-param.

ASSIGN c-arq-anexo = tt-param.arquivo.

{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
EMPTY TEMP-TABLE tt_log_erros_atualiz.
EMPTY TEMP-TABLE tt-concil.
EMPTY TEMP-TABLE tt-total-cliente.
EMPTY TEMP-TABLE tt-refer.
EMPTY TEMP-TABLE tt_tit_acr.

RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

RUN pi_encontro_contas.

{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF  tt-param.c-email <> "" THEN
    RUN pi-envia-email (INPUT tt-param.c-email,
                        INPUT c-arq-anexo).

RETURN "OK".


PROCEDURE pi_encontro_contas:

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        FOR EACH tit_acr NO-LOCK
            WHERE tit_acr.cod_estab       = estabelecimento.cod_estab
            AND   tit_acr.cod_espec_docto = "AN"
            AND   tit_acr.log_sdo_tit_acr
            BREAK BY cdn_cliente:

            IF  tit_acr.cdn_cliente < tt-param.emit-ini 
            OR  tit_acr.cdn_cliente > tt-param.emit-fim THEN 
                NEXT.

            IF  tit_acr.dat_transacao < tt-param.dt-tra-ini
            OR  tit_acr.dat_transacao > tt-param.dt-tra-fim THEN 
                NEXT.

            IF  tit_acr.cdn_clien_matriz < tt-param.matriz-ini 
            OR  tit_acr.cdn_clien_matriz > tt-param.matriz-fim THEN 
                NEXT.

            FIND FIRST emscad.cliente
                WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                AND   emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
        
            IF  AVAIL emscad.cliente
            AND (emscad.cliente.cod_grp_clien < tt-param.gr-cli-ini 
            OR   emscad.cliente.cod_grp_clien > tt-param.gr-cli-fim) THEN
                NEXT.

            FIND FIRST emscad.fornecedor
                WHERE emscad.fornecedor.cod_empresa    = tit_acr.cod_empresa
                AND   emscad.fornecedor.cdn_fornecedor = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL emscad.fornecedor THEN
                NEXT.

            FIND FIRST int-emitente
                WHERE int-emitente.cod-emit = tit_acr.cdn_cliente NO-LOCK NO-ERROR.

            IF  AVAIL int-emitente
            AND (int-emitente.cod-gr-cob < tt-param.gr-cob-ini
            OR   int-emitente.cod-gr-cob > tt-param.gr-cob-fim) THEN
                NEXT.

            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp(INPUT "Buscando t¡tulos - Cod Titulo: " + STRING(tit_acr.cod_tit_acr) + " / Cliente: " + STRING(tit_acr.cdn_cliente)).

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab      = tit_acr.cod_estab
                   tt_tit_acr.cdn_cliente    = tit_acr.cdn_cliente
                   tt_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.
        END.
    END.

    ASSIGN de-total-an = 0.    

    run prgfin/acr/acr711zv.py persistent set v_hdl_program .

    block_encontro:
    DO TRANS ON ERROR UNDO block_encontro:

        FOR EACH tt_tit_acr
            BREAK BY tt_tit_acr.cod_estab
                  BY tt_tit_acr.cdn_cliente:

            FIND FIRST tit_acr
                WHERE tit_acr.cod_estab      = tt_tit_acr.cod_estab
                AND   tit_acr.num_id_tit_acr = tt_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.

            IF  AVAIL tit_acr THEN DO:
                
                EMPTY TEMP-TABLE tt_alter_tit_acr_base_5.

                IF  VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp(INPUT "Processando antecipa‡äes - Cod Titulo: " + STRING(tit_acr.cod_tit_acr) + " / Cliente: " + STRING(tit_acr.cdn_cliente)).

                IF  tt-param.tg-conferencia = NO THEN DO:
                    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                              INPUT  RECID(tit_acr),
                                                              OUTPUT c-cod-refer).

                    CREATE tt-refer.
                    ASSIGN tt-refer.cod-estab = tit_acr.cod_estab
                           tt-refer.cod-refer = c-cod-refer.
        
                    RUN pi-nf-devol.
    
                    IF  c-nf-devol = "" THEN
                        NEXT.

                    CREATE tt_alter_tit_acr_base_5.
                    ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tit_acr.cod_estab                      
                           tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr 
                           tt_alter_tit_acr_base_5.tta_dat_transacao               = TODAY
                           tt_alter_tit_acr_base_5.tta_cod_refer                   = c-cod-refer
                           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_imp = ?
                           tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr             = 0 /* tit_acr.val_sdo_tit_acr */
                           tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_alt = ?
                           tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val        = "Liquida‡Æo"
                           tt_alter_tit_acr_base_5.tta_cod_portador                = ? 
                           tt_alter_tit_acr_base_5.tta_cod_cart_bcia               = ?
                           tt_alter_tit_acr_base_5.tta_val_despes_bcia             = ?
                           tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia         = ?
                           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
                           tt_alter_tit_acr_base_5.tta_dat_emis_docto              = 01/01/0001
                           tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr          = 01/01/0001
                           tt_alter_tit_acr_base_5.tta_dat_prev_liquidac           = 01/01/0001 
                           tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr           = 01/01/0001
                           tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr             = ?
                           tt_alter_tit_acr_base_5.tta_cod_cond_cobr               = ?
                           tt_alter_tit_acr_base_5.tta_log_tip_cr_perda_dedut_tit  = ?
                           tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr            = ?
                           tt_alter_tit_acr_base_5.tta_val_perc_abat_acr           = ?
                           tt_alter_tit_acr_base_5.tta_val_abat_tit_acr            = ?
                           tt_alter_tit_acr_base_5.tta_dat_desconto                = ?
                           tt_alter_tit_acr_base_5.tta_val_perc_desc               = ?
                           tt_alter_tit_acr_base_5.tta_val_desc_tit_acr            = ?
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr   = ?
                           tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso   = ?
                           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr   = ?
                           tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso       = ?
                           tt_alter_tit_acr_base_5.ttv_cod_portador_mov            = ?
                           tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr            = ?
                           tt_alter_tit_acr_base_5.tta_ind_ender_cobr              = ?
                           tt_alter_tit_acr_base_5.tta_nom_abrev_contat            = ?
                           tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = ?
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1_movto    = ?
                           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2_movto    = ?
                           tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo         = ?
                           tt_alter_tit_acr_base_5.tta_cod_histor_padr             = ?
                           tt_alter_tit_acr_base_5.ttv_des_text_histor             = ?
                           tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ?
                           tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = ?            
                           tt_alter_tit_acr_base_5.ttv_cod_estab_planilha          = ?
                           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
                           tt_alter_tit_acr_base_5.ttv_des_text_histor             = "NÆo Valida"
                           tt_alter_tit_acr_base_5.tta_cdn_repres                  = ?.

                    CREATE tt_alter_tit_acr_rateio.
                    ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
                           tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                           tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Altera‡Æo":U
                           tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                           tt_alter_tit_acr_rateio.tta_num_seq_refer               = 10
                           tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                           tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = tt-param.c-conta-ava
                           tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 10
                           tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tit_acr.val_sdo_tit_acr.

                    ASSIGN de-total-an = de-total-an + tit_acr.val_sdo_tit_acr
                           de-acerto   = tit_acr.val_sdo_tit_acr.

                    run pi_main_code_integr_acr_alter_tit_acr_novo_14 in v_hdl_program (input  14,
                                                                                        input table tt_alter_tit_acr_base_5,
                                                                                        input table tt_alter_tit_acr_rateio,
                                                                                        input table tt_alter_tit_acr_ped_vda,                                                                     
                                                                                        input table tt_alter_tit_acr_comis_1,                                                      
                                                                                        input table tt_alter_tit_acr_cheq,                                                      
                                                                                        input table tt_alter_tit_acr_iva,                                                      
                                                                                        input table tt_alter_tit_acr_impto_retid_2,                                                      
                                                                                        input table tt_alter_tit_acr_cobr_espec_2,                                                      
                                                                                        input table tt_alter_tit_acr_rat_desp_rec,                                                      
                                                                                        output table tt_log_erros_alter_tit_acr,                                                      
                                                                                        input yes,
                                                                                        input table  tt_alter_tit_acr_cobr_esp_2_c,
                                                                                        input table  tt_params_generic_api).

                    ASSIGN l-erro = NO.
                    
                    IF  CAN-FIND (FIRST tt_log_erros_alter_tit_acr) THEN DO:
                        PUT UNFORMATTED SKIP(2).
                        PUT UNFORMATTED ";;;;;ERROS CONCILIA€ÇO ACR" SKIP.
                        PUT UNFORMATTED "Estab;Cliente;Esp‚cie;S‚rie;T¡tulo;Parc;MSG;Erro;Ajuda;Complemento" SKIP.
    
                        FOR EACH tt_log_erros_alter_tit_acr:
                            FIND FIRST b_tit_acr
                                WHERE b_tit_acr.cod_estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
                                AND   b_tit_acr.num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr NO-LOCK NO-ERROR.
    
                            IF  AVAIL b_tit_acr THEN DO:
                                PUT UNFORMATTED b_tit_acr.cod_estab                            ";"
                                                b_tit_acr.cdn_cliente                          ";"
                                                b_tit_acr.cod_espec_docto                      ";"
                                                b_tit_acr.cod_ser_docto                        ";"
                                                b_tit_acr.cod_tit_acr                          ";"
                                                b_tit_acr.cod_parcela                          ";"
                                                tt_log_erros_alter_tit_acr.ttv_num_mensagem  ";"
                                                tt_log_erros_alter_tit_acr.ttv_des_msg_erro  ";"
                                                tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda ";" 
                                                SKIP.
                            END.
    
                            FOR EACH tt-concil:
                                DELETE tt-concil.
                            END.
    
                            IF  VALID-HANDLE(h-acomp) THEN
                                RUN pi-finalizar IN h-acomp.
    
                            UNDO block_encontro, RETURN ERROR.
                        END.
                    END.
                    ELSE DO:
                        CREATE tt-concil.
                        ASSIGN tt-concil.cod_estab   = tit_acr.cod_estab      
                               tt-concil.cdn_cli_for = tit_acr.cdn_cliente    
                               tt-concil.cod_espec   = tit_acr.cod_espec_docto
                               tt-concil.cod_serie   = tit_acr.cod_ser_docto  
                               tt-concil.cod_titulo  = tit_acr.cod_tit_acr    
                               tt-concil.cod_parcela = tit_acr.cod_parcela  
                               tt-concil.nf-devol    = c-nf-devol
                               tt-concil.valor       = de-acerto
                               tt-concil.cod_modulo  = "ACR".
                    END.
                    
                    IF  LAST-OF(tt_tit_acr.cdn_cliente) 
                    AND de-total-an > 0 THEN DO:
                        
                        ASSIGN c-historico = "".
    
                        FOR EACH tt-concil
                            WHERE tt-concil.cod_estab   = tit_acr.cod_estab
                            AND   tt-concil.cdn_cli_for = tit_acr.cdn_cliente:
    
                            IF  c-historico = ""THEN
                                ASSIGN c-historico = "Notas Devolu‡Æo: ".
    
                            IF  c-historico MATCHES "*" + tt-concil.nf-devol + "*" THEN.
                            ELSE ASSIGN c-historico = c-historico + tt-concil.nf-devol + " / ".
                        END.
    
                        CREATE tt-total-cliente.
                        ASSIGN tt-total-cliente.cod-estab   = tit_acr.cod_estab
                               tt-total-cliente.cdn-cliente = tit_acr.cdn_cliente
                               tt-total-cliente.total-saldo = de-total-an
                               tt-total-cliente.historico   = c-historico.
                        
                        ASSIGN de-total-an = 0.
                    END.
                END.
                ELSE DO:
                    RUN pi-nf-devol.

                    IF  c-nf-devol = "" THEN
                        NEXT.

                    CREATE tt-concil.
                    ASSIGN tt-concil.cod_estab   = tit_acr.cod_estab      
                           tt-concil.cdn_cli_for = tit_acr.cdn_cliente    
                           tt-concil.cod_espec   = tit_acr.cod_espec_docto
                           tt-concil.cod_serie   = tit_acr.cod_ser_docto  
                           tt-concil.cod_titulo  = tit_acr.cod_tit_acr    
                           tt-concil.cod_parcela = tit_acr.cod_parcela  
                           tt-concil.nf-devol    = c-nf-devol
                           tt-concil.valor       = tit_acr.val_sdo_tit_acr
                           tt-concil.cod_modulo  = "ACR".
                END.
            END.
        END.

        IF  tt-param.tg-conferencia = NO THEN DO:
            FOR EACH tt-total-cliente:
                EMPTY TEMP-TABLE tt_integr_apb_lote_impl.
                EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
                EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
                EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
                EMPTY TEMP-TABLE tt_log_erros_atualiz.
        
                ASSIGN c-cod-refer = "".
    
                RUN pi-busca-referencia-apb (INPUT  "TEXP",
                                             INPUT  tt-total-cliente.cod-estab,
                                             OUTPUT c-cod-refer).
    
                IF  VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp(INPUT "Gerando t¡tulo APB ...." + STRING(c-cod-refer)).
    
                CREATE tt_integr_apb_lote_impl.
                ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = tt-total-cliente.cod-estab
                       tt_integr_apb_lote_impl.tta_cod_refer         = c-cod-refer.
                
                ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = TODAY
                       tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                        
                       tt_integr_apb_lote_impl.tta_cod_empresa       = "1".
                
                VALIDATE tt_integr_apb_lote_impl.
        
                ASSIGN da-vencto-apb = tt-param.dt-pagto
                       c-cod-tit     = "TE" + tt-total-cliente.cod-estab 
                                            + STRING(tt-total-cliente.cdn-cliente) 
                                            + STRING(MONTH(TODAY))
                                            + SUBSTR(STRING(YEAR(TODAY)),3,2).
    
                FIND LAST tit_ap
                    WHERE tit_ap.cod_empresa     = v_cod_empres_usuar
                    AND   tit_ap.cod_estab       = tt-total-cliente.cod-estab  
                    AND   tit_ap.cod_espec_docto = "TE"
                    AND   tit_ap.cod_ser_docto   = "U"
                    AND   tit_ap.cod_tit_ap      = c-cod-tit
                    AND   tit_ap.cdn_fornec      = tt-total-cliente.cdn-cliente NO-LOCK NO-ERROR.
                
                IF  NOT AVAIL tit_ap THEN
                    ASSIGN c-parcela = "01".
                ELSE
                    ASSIGN c-parcela = STRING(INTEGER(tit_ap.cod_parcela) + 1,"99").
    
                CREATE tt_integr_apb_item_lote_impl_3.
                ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = RECID(tt_integr_apb_lote_impl)
                       tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = RECID(tt_integr_apb_item_lote_impl_3)
                       tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = 1
                       tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = tt-total-cliente.cdn-cliente
                       tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = "TE"
                       tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "U"
                       tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = c-cod-tit
                       tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = c-parcela
                       tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = TODAY
                       tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = da-vencto-apb
                       tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = da-vencto-apb
                       tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "50"
                       tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "Real"
                       tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = tt-total-cliente.total-saldo
                       tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
                       tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1
                       tt_integr_apb_item_lote_impl_3.tta_des_text_histor              = tt-total-cliente.historico.
            
                VALIDATE tt_integr_apb_item_lote_impl_3.
        
                CREATE tt_integr_apb_aprop_ctbl_pend.
                ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
                       tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
                       tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = "ADM"
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "103"
                       tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = tt-total-cliente.total-saldo
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = tt-param.c-conta-ava
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = ""
                       tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = "".
                
                VALIDATE tt_integr_apb_aprop_ctbl_pend.
        
                RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
                
                FOR EACH tt_integr_apb_item_lote_impl_3:
                    CREATE tt_integr_apb_item_lote_impl3v.
                    BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.
                END.  
            
                EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
            
                IF  CAN-FIND (FIRST tt_integr_apb_item_lote_impl3v) THEN DO:
                    RUN pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (INPUT 5,
                                                                      INPUT "EMS",
                                                                      INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl3v).
        
                    IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
                        PUT UNFORMATTED SKIP(2).
                        PUT UNFORMATTED ";;;;;ERROS CONCILIA€ÇO APB" SKIP.
                        PUT UNFORMATTED "Estab;Referˆncia;Num Seq Refer;MSG;Erro;Ajuda;Complemento" SKIP.
    
                        FOR EACH tt_log_erros_atualiz:
                            PUT UNFORMATTED tt_log_erros_atualiz.tta_cod_estab      ";"
                                            tt_log_erros_atualiz.tta_cod_refer      ";"
                                            tt_log_erros_atualiz.tta_num_seq_refer  ";"
                                            tt_log_erros_atualiz.ttv_num_mensagem   ";"
                                            tt_log_erros_atualiz.ttv_des_msg_erro   ";"
                                            tt_log_erros_atualiz.ttv_des_msg_ajuda  ";"
                                            SKIP.
        
                            FOR EACH tt-concil:
                                DELETE tt-concil.
                            END.
    
                            IF  VALID-HANDLE(h-acomp) THEN
                                RUN pi-finalizar IN h-acomp.
    
                            UNDO block_encontro, RETURN ERROR.
                        END.
                    END.
                    ELSE DO:
                        CREATE tt-concil.
                        ASSIGN tt-concil.cod_estab   = tt-total-cliente.cod-estab
                               tt-concil.cdn_cli_for = tt-total-cliente.cdn-cliente
                               tt-concil.cod_espec   = "TE"
                               tt-concil.cod_serie   = "U"
                               tt-concil.cod_titulo  = c-cod-tit
                               tt-concil.cod_parcela = c-parcela
                               tt-concil.valor       = tt-total-cliente.total-saldo
                               tt-concil.cod_modulo  = "APB".
                    END.
                END.    
            END.
        END.

        FOR EACH tt-concil
            BREAK BY cod_modulo:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp(INPUT "Gerando relat¢rio de acompanhamento - M¢dulo: " + STRING(tt-concil.cod_modulo)).

            IF  FIRST-OF(tt-concil.cod_modulo) THEN DO:

                IF  tt-concil.cod_modulo = "APB" THEN DO:
                    PUT UNFORMATTED SKIP(2).
                    PUT UNFORMATTED ";;;;;CONCILIADOS APB" SKIP.
                    PUT UNFORMATTED "Estabelecimento;Fornecedor;Esp‚cie;S‚rie;T¡tulo;Parcela;Valor;" SKIP.
                END.
                ELSE DO:
                    PUT UNFORMATTED SKIP(2).
                    PUT UNFORMATTED ";;;;;CONCILIADOS ACR" SKIP.
                    PUT UNFORMATTED "Estabelecimento;Cliente;Esp‚cie;S‚rie;T¡tulo;Parcela;Valor;NF Devolu‡Æo" SKIP.
                END.
            END.
    
            PUT UNFORMATTED tt-concil.cod_estab   ";"
                            tt-concil.cdn_cli_for ";"
                            tt-concil.cod_espec   ";"
                            tt-concil.cod_serie   ";"
                            tt-concil.cod_titulo  ";"
                            tt-concil.cod_parcela ";"
                            tt-concil.valor       ";"
                            tt-concil.nf-devol
                            SKIP.
        END.
    END.
    
    DELETE PROCEDURE v_hdl_program.

END PROCEDURE.

PROCEDURE pi-gera-referencia:
    DEF INPUT  PARAM p-cod-estab  AS CHAR  FORMAT "x(3)"        NO-UNDO.
    DEF INPUT  PARAM p-rec-tabela AS RECID FORMAT ">>>>>>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p-referencia AS CHAR                       NO-UNDO.

    DEF VAR l-log-refer-uni AS LOG NO-UNDO.

    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INT64(p-rec-tabela) + int(time) + 100.

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.

    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    FIND FIRST tt-refer
        WHERE tt-refer.cod-estab = p-cod-estab
        AND   tt-refer.cod-refer = p-referencia NO-LOCK NO-ERROR.
    
    IF  NOT l-log-refer-uni 
    OR  AVAIL tt-refer THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-refer-unica-acr:
    DEF INPUT  PARAM p_cod_estab     AS CHAR  FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHAR  FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHAR  FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOG   FORMAT "Sim/NÆo" NO-UNDO.

    DEF BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEF BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEF BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEF BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEF BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEF BUFFER b_renegoc_acr       FOR renegoc_acr.

    ASSIGN p_log_refer_uni = YES.

    IF  p_cod_table <> "lote_impl_tit_acr" THEN DO:
        FIND FIRST b_lote_impl_tit_acr NO-LOCK
             WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
               AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
               AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
             USE-INDEX ltmplttc_id NO-ERROR.
        IF  AVAIL b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "lote_liquidac_acr" THEN DO:
        FIND FIRST b_lote_liquidac_acr NO-LOCK
             WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
               AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
             USE-INDEX ltlqdccr_id NO-ERROR.
        IF  AVAIL b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "Opera‡Æo financeira" THEN DO:
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

PROCEDURE pi-envia-email:
    DEF INPUT PARAM p-c-destino-email AS CHAR NO-UNDO.
    DEF INPUT PARAM p-c-arq-anexo     AS CHAR NO-UNDO.

    DEF VAR c-arquivo-email AS CHAR NO-UNDO.

    IF  i-num-ped-exec-rpw = 0 THEN
        ASSIGN p-c-arq-anexo = SEARCH(p-c-arq-anexo).
    ELSE
        ASSIGN p-c-arq-anexo = c-dir-spool-servid-exec + "/" + p-c-arq-anexo
               p-c-arq-anexo = SEARCH(p-c-arq-anexo).

    ASSIGN c-arquivo-email = p-c-arq-anexo
           c-arquivo-email = REPLACE(c-arquivo-email,".tmp",".txt")
           c-arquivo-email = REPLACE(c-arquivo-email,".lst",".txt")
           c-arquivo-email = REPLACE(c-arquivo-email,".LST",".txt").

    OS-COPY VALUE(p-c-arq-anexo) VALUE(c-arquivo-email).

    run utp/utapi019.p persistent set h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-erros.

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = ""
           tt-envio2.porta             = 0
           tt-envio2.destino           = p-c-destino-email
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.arq-anexo         = c-arquivo-email
           tt-envio2.assunto           = "Concilia‡Æo de Antecipa‡Æo - Troca Expressa" 
           tt-envio2.mensagem          = "Seu e-mail est  parametrizado para receber avisos das concilia‡äes de antecipa‡Æo (Troca Expressa)."  + CHR(10) + CHR(10) + 
                                         "Atenciosamente," + CHR(10) + 
                                         "Equipe Financeira".
       
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute in h-utapi019 (input  table tt-envio2, 
                                  output table tt-erros).
    output close.

    delete procedure h-utapi019.

    if available tt-envio2 then
        delete tt-envio2.    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:
    def Input  param p_ind_tip_atualiz as CHARACTER format "X(08)"      no-undo.
    def Input  param p_dat_refer       as DATE      format "99/99/9999" no-undo.
    def output param p_cod_refer       as CHARACTER format "x(10)"      no-undo.
    
    def var v_des_dat   as character no-undo.
    def var v_num_aux   as integer   no-undo.
    def var v_num_aux_2 as integer   no-undo.
    def var v_num_cont  as integer   no-undo.

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.

PROCEDURE pi-busca-referencia-apb:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/NÆo" INITIAL YES NO-UNDO.
    def var v_cod_refer     AS CHARACTER format "x(10)" NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia-apb (INPUT  p-sigla,
                                                OUTPUT v_cod_refer).

        run pi_verifica_refer_unica_apb (INPUT  p-cod-estabel,
                                         INPUT  v_cod_refer,
                                         INPUT  "lote_impl_tit_ap",
                                         INPUT  ?,
                                         OUTPUT v_log_refer_uni).
    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia-apb:
    DEF INPUT  param p_ind_tip_atualiz AS CHARACTER format "X(08)" NO-UNDO.
    DEF OUTPUT param p_cod_refer       AS CHARACTER format "x(10)" NO-UNDO.

    DEF VAR v_num_aux   AS INTEGER NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER NO-UNDO. 

    ASSIGN p_cod_refer = SUBSTRING(p_ind_tip_atualiz,1,4)
           v_num_aux_2 = INTEGER(this-procedure:handle).

    DO  v_num_cont = 1 TO 6:
        ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    END.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:
    DEF INPUT  PARAM p_cod_estab        AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer        AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table        AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_movto_tit_ap AS RECID     FORMAT ">>>>>>9" NO-UNDO. 
    DEF OUTPUT PARAM p_log_refer_uni    AS LOGICAL   FORMAT "Sim/NÆo" NO-UNDO.

    DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEF BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEF BUFFER b_lote_pagto       FOR lote_pagto.
    DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    find first b_antecip_pef_pend no-lock
         where b_antecip_pef_pend.cod_estab = p_cod_estab
           and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail b_antecip_pef_pend then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_impl_tit_ap no-lock
         where b_lote_impl_tit_ap.cod_estab = p_cod_estab
           and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
    if  avail b_lote_impl_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_pagto no-lock
         where b_lote_pagto.cod_estab_refer = p_cod_estab
           and b_lote_pagto.cod_refer = p_cod_refer no-error.
    if  avail b_lote_pagto then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_movto_tit_ap NO-LOCK where b_movto_tit_ap.cod_estab = p_cod_estab
           and b_movto_tit_ap.cod_refer = p_cod_refer
           and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
    if  avail b_movto_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.

END PROCEDURE.

PROCEDURE pi-nf-devol:
    ASSIGN c-nf-devol = "".
    
    FIND FIRST nota_devol_tit_acr
        WHERE nota_devol_tit_acr.cod_estab       = tit_acr.cod_estab
        AND   nota_devol_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto
        AND   nota_devol_tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
        AND   nota_devol_tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
        AND   nota_devol_tit_acr.cod_parcela     = tit_acr.cod_parcela NO-LOCK NO-ERROR.
    
    IF  AVAIL nota_devol_tit_acr THEN
        ASSIGN c-nf-devol = nota_devol_tit_acr.cod_nota_devol.

    IF  c-nf-devol = "" THEN DO:
        FOR FIRST movto_tit_acr FIELDS(cod_estab num_id_movto_tit_acr) NO-LOCK
            WHERE movto_tit_acr.cod_estab      = tit_acr.cod_estab
            AND   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
            AND   movto_tit_acr.ind_trans_acr  = "Implanta‡Æo a Cr‚dito":
        
            FOR FIRST relacto_tit_acr FIELDS(cod_estab num_id_tit_acr) NO-LOCK
                WHERE relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
                AND   relacto_tit_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr:
        
                FOR FIRST b_tit_acr NO-LOCK
                    WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                    AND   b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr:
                    
                    FIND nota_devol_tit_acr NO-LOCK
                        WHERE nota_devol_tit_acr.cod_estab       = b_tit_acr.cod_estab
                        AND   nota_devol_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                        AND   nota_devol_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                        AND   nota_devol_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                        AND   nota_devol_tit_acr.cod_parcela     = b_tit_acr.cod_parcela NO-ERROR.
                    
                    IF  AVAIL nota_devol_tit_acr THEN
                        ASSIGN c-nf-devol = nota_devol_tit_acr.cod_nota_devol.
    
                END.
            END.
        END.
    END.

END PROCEDURE.
