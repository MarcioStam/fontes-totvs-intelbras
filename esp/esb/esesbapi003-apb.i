/*------------------------------------------------------------------------------*/
/*  Programa: esp/esb/esesbapi003-apb.i                                         */
/*  Funá∆o..: Centralizar procedures de acesso ao Finaceiro, as quais s∆o       */
/*            utilizadas pelos programas esesbapi003-apb.p e esesb005-rp.p      */
/*------------------------------------------------------------------------------*/

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/
               
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



PROCEDURE pi-efetiva-ALTERECAO-titulo-ABP:
    DEF VAR c-usuario-corrente-atual AS CHAR NO-UNDO.
    
    ASSIGN c-usuario-corrente-atual = v_cod_usuar_corren.

    IF  CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1)  THEN DO:

        EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

        run prgfin/apb/apb767ze.py(input 1,
                                   input "",
                                   INPUT "",
                                   input-output table tt_tit_ap_alteracao_base_aux_1,
                                   input-output table tt_tit_ap_alteracao_rateio,
                                   output table tt_log_erros_tit_ap_alteracao).

        ASSIGN v_cod_usuar_corren = c-usuario-corrente-atual.
        IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao 
                        WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542  
                          AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 11834 
                          AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 20260 ) THEN DO:

            FOR EACH tt_log_erros_tit_ap_alteracao:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT tt_log_erros_tit_ap_alteracao.ttv_num_mensagem, /* Erro */
                                                    INPUT tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro,
                                                    INPUT tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda).
            END.
            RETURN "NOK".
        END.
    
    END.

    RETURN "OK".
END.


PROCEDURE pi-efetiva-CRIACAO-titulo-APB:

    DEF VAR c-usuario-corrente-atual AS CHAR NO-UNDO.
    
    ASSIGN c-usuario-corrente-atual = v_cod_usuar_corren.

    assign p_num_vers_integr_api     = 4
           v_cod_matriz_trad_org_ext = "EMS".

    run prgfin/apb/apb900zg.py persistent set v_hdl_aux.
    
    FOR EACH tt_integr_apb_item_lote_impl_3:
        CREATE tt_integr_apb_item_lote_impl3v.
        BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.
    END.  

    EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

    IF  CAN-FIND (FIRST tt_integr_apb_item_lote_impl3v) THEN DO:

        run pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (Input 5,
                                                          Input v_cod_matriz_trad_org_ext,
                                                          input-output table tt_integr_apb_item_lote_impl3v) /*pi_main_block_api_tit_ap_cria_4*/.

        ASSIGN v_cod_usuar_corren = c-usuario-corrente-atual.
        IF  VALID-HANDLE (v_hdl_aux) THEN 
            DELETE PROCEDURE v_hdl_aux.

        IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:

            FOR EACH tt_log_erros_atualiz:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT tt_log_erros_atualiz.ttv_num_mensagem, /* Erro */
                                                    INPUT tt_log_erros_atualiz.ttv_des_msg_erro,
                                                    INPUT tt_log_erros_atualiz.ttv_des_msg_ajuda).
            END.
            RETURN "NOK".
        END.
        ELSE DO:
            FIND FIRST tt_integr_apb_item_lote_impl3v NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt_integr_apb_item_lote_impl3v THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "T°tulo(s) n∆o foram criados. Atualizaá∆o interrompida." ,
                                                    INPUT "").
                RETURN "NOK".
            END.
        END.
    END.

    RETURN "OK".
END.


PROCEDURE pi_verifica_refer_unica_apb:

    DEF INPUT  PARAM p_cod_estab        AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer        AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table        AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_movto_tit_ap AS RECID     FORMAT ">>>>>>9" NO-UNDO. 
    DEF OUTPUT PARAM p_log_refer_uni    AS LOGICAL   FORMAT "Sim/N∆o" NO-UNDO.

    DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEF BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEF BUFFER b_lote_pagto       FOR lote_pagto.
    DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    /*************************** Buffer Definition End **************************/
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


PROCEDURE pi-zera-tabelas:

    FOR EACH tt_integr_apb_item_lote_impl3v:
        DELETE tt_integr_apb_item_lote_impl3v.
    END.
    FOR EACH tt_integr_apb_abat_antecip_vouc:
        DELETE tt_integr_apb_abat_antecip_vouc.
    END.
    FOR EACH tt_integr_apb_abat_prev_provis:
        DELETE tt_integr_apb_abat_prev_provis.
    END.
    FOR EACH tt_integr_apb_aprop_ctbl_pend:
        DELETE tt_integr_apb_aprop_ctbl_pend.
    END.
    FOR EACH tt_integr_apb_aprop_relacto:
        DELETE tt_integr_apb_aprop_relacto.
    END.
    FOR EACH tt_integr_apb_impto_impl_pend:
        DELETE tt_integr_apb_impto_impl_pend.
    END.
    FOR EACH tt_integr_apb_item_lote_impl:
        DELETE tt_integr_apb_item_lote_impl.
    END.
    FOR EACH tt_integr_apb_lote_impl:
        DELETE tt_integr_apb_lote_impl.
    END.
    FOR EACH tt_integr_apb_relacto_pend:
        DELETE tt_integr_apb_relacto_pend.
    END.
    FOR EACH tt_log_erros_atualiz:
        DELETE tt_log_erros_atualiz.
    END.
    FOR EACH tt_integr_apb_item_lote_impl_3:
        DELETE tt_integr_apb_item_lote_impl_3.
    END.
    FOR EACH tt_tit_ap_alteracao_rateio:
        DELETE tt_tit_ap_alteracao_rateio.
    END.
    FOR EACH tt_tit_ap_alteracao_base:
        DELETE tt_tit_ap_alteracao_base.
    END.
    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.
    FOR EACH tt_tit_ap_alteracao_base_aux_1:
        DELETE tt_tit_ap_alteracao_base_aux_1.
    END.

END PROCEDURE.


PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/N∆o" INITIAL YES NO-UNDO.
    def var v_cod_refer     AS CHARACTER format "x(10)" NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia (INPUT  p-sigla,
                                            OUTPUT v_cod_refer).

        run pi_verifica_refer_unica_apb (INPUT  p-cod-estabel,
                                         INPUT  v_cod_refer,
                                         INPUT  "lote_impl_tit_ap",
                                         INPUT  ?,
                                         OUTPUT v_log_refer_uni).
    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.
