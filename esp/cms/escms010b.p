/* ** Defini‡Æo das Temp-Tables da API de Altera‡Æo e Implanta‡Æo ***/
{esp/cms/escms010b.i}

/* ** Defini‡Æo dos Parƒmetros ***/
DEF INPUT PARAMETER p_cod_estab_ini AS CHAR.
DEF INPUT PARAMETER p_cod_estab_fim AS CHAR.
DEF INPUT PARAMETER p_periodo       AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR tt_log_erros_comis.

/* ** Defini‡Æo das Vari veis ***/
DEF NEW GLOBAL SHARED VAR v_log_atualiza_refer_apb
    AS LOGICAL 
    FORMAT "Sim/NÆo"
    INITIAL YES 
    VIEW-AS TOGGLE-BOX 
    LABEL "Atualiza Referˆncia"
    COLUMN-LABEL "Atualiza Referˆncia"
    NO-UNDO.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
DEFINE VARIABLE vvl-comissao    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_data          AS DATE        NO-UNDO.
DEFINE VARIABLE v_num_ano_refer AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_num_mes_refer AS INTEGER     NO-UNDO.

/* ** Calcula o £ltimo dia do mˆs de Referˆncia de C lculo da ComissÆo ***/
ASSIGN v_data = DATE("01" + SUBSTRING(p_periodo, 5, 2) + SUBSTRING(p_periodo, 1, 4)).
/* ** Posiciona um mˆs a frente ***/
ASSIGN v_num_ano_refer = YEAR(v_data)
       v_num_mes_refer = MONTH(v_data) + 1.
IF v_num_mes_refer = 13
   THEN ASSIGN v_num_mes_refer = 1
               v_num_ano_refer = v_num_ano_refer + 1.
/* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
ASSIGN v_data = DATE('01' + STRING(v_num_mes_refer, '99') + STRING(v_num_ano_refer, '9999'))
       v_data = v_data - 1.

/* ** Reverte e recria CPI ***/
FOR EACH estabelecimento NO-LOCK
    WHERE estabelecimento.cod_estab >= p_cod_estab_ini
      AND estabelecimento.cod_estab <= p_cod_estab_fim:

    /* ** Reverte ProvisÆo CPI existentes ***/
    FOR EACH tit_ap NO-LOCK
        WHERE tit_ap.cod_estab      = estabelecimento.cod_estab
          AND tit_ap.cod_espec      = 'CPI'
          AND tit_ap.log_sdo_tit_ap = YES:
        RUN pi-gera-ava.
        IF RETURN-VALUE <> "OK" 
           THEN RETURN.
    END.
    
    /* ** Cria CPI com base na inadimplˆncia do per¡odo ***/
    FOR EACH comissao-fat NO-LOCK
        WHERE comissao-fat.cod-estab      = estabelecimento.cod_estab
          AND comissao-fat.periodo        = p_periodo
          AND comissao-fat.id-tipo-inform = 3 USE-INDEX ch_sec
        BREAK BY comissao-fat.cod-rep:
    
        ASSIGN vvl-comissao = vvl-comissao + comissao-fat.vl-comissao * -1.
    
        IF LAST-OF(cod-rep) 
        THEN DO: 
    
             FIND representante NO-LOCK
                 WHERE representante.cod_empresa = estabelecimento.cod_empresa
                   AND representante.cdn_repres  = comissao-fat.cod-rep NO-ERROR.
             IF NOT AVAIL representante 
             THEN DO: 
                  CREATE tt_log_erros_comis.
                  ASSIGN tt_log_erros_comis.tta_cod_estab     = estabelecimento.cod_estab
                         tt_log_erros_comis.tta_cdn_repres    = comissao-fat.cod-rep
                         tt_log_erros_comis.tta_periodo       = p_periodo
                         tt_log_erros_comis.ttv_num_mensagem  = 0
                         tt_log_erros_comis.ttv_des_msg_erro  = "Representante nÆo Localizado !"
                         tt_log_erros_comis.ttv_des_msg_ajuda = "Repres: " + STRING(comissao-fat.cod-rep). 
                  RETURN.
             END.
             FIND FIRST emscad.fornecedor NO-LOCK
                  WHERE emscad.fornecedor.cod_empresa = estabelecimento.cod_empresa
                    AND emscad.fornecedor.num_pessoa  = representante.num_pessoa NO-ERROR.
             IF NOT AVAIL emscad.fornecedor 
             THEN DO: 
                  CREATE tt_log_erros_comis.
                  ASSIGN tt_log_erros_comis.tta_cod_estab     = estabelecimento.cod_estab
                         tt_log_erros_comis.tta_cdn_repres    = comissao-fat.cod-rep
                         tt_log_erros_comis.tta_periodo       = p_periodo
                         tt_log_erros_comis.ttv_num_mensagem  = 0
                         tt_log_erros_comis.ttv_des_msg_erro  = "Fornecedor nÆo localizado !"
                         tt_log_erros_comis.ttv_des_msg_ajuda = "Pessoa: " + STRING(representante.num_pessoa). 
                  RETURN.
             END.
    
             IF vvl-comissao > 0 
             THEN DO:
                  RUN pi-gera-cpi.
                  IF RETURN-VALUE <> "OK" 
                     THEN RETURN.
             END.
             ASSIGN vvl-comissao = 0.
    
        END.
    END.
END.

PROCEDURE pi-gera-cpi:

    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_cod_parcela   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_hdl_aux       AS HANDLE      NO-UNDO.
    
    RUN pi-zera-tabelas.

    /* ** Atualiza lote sim ou nÆo ***/
    ASSIGN v_log_atualiza_refer_apb = YES.
     
    ASSIGN v_log_refer_uni = NO
           v_cod_parcela   = 1.
    
    /* ** Verifica se j  existe o t¡tulo no contas a pagar ***/
    REPEAT WHILE NOT v_log_refer_uni:
        ASSIGN v_log_refer_uni = YES.
        IF CAN-FIND (tit_ap NO-LOCK
                     WHERE tit_ap.cod_estab   = estabelecimento.cod_estab
                       AND tit_ap.cdn_fornec  = emscad.fornecedor.cdn_fornec
                       AND tit_ap.cod_espec   = "CPI"
                       AND tit_ap.cod_ser     = ""
                       AND tit_ap.cod_tit_ap  = "CPI" + STRING(v_data, "999999")
                       AND tit_ap.cod_parcela = STRING(v_cod_parcela, "99")) 
        THEN ASSIGN v_log_refer_uni = NO
                    v_cod_parcela   = v_cod_parcela + 1.
        
        IF CAN-FIND (FIRST tit_ap NO-LOCK 
                     WHERE tit_ap.num_pessoa      = representante.num_pessoa
                       AND tit_ap.cod_espec_docto = "CPI"
                       AND tit_ap.cod_ser_docto   = ""
                       AND tit_ap.cod_tit_ap      = "CPI" + STRING(v_data, "999999")
                       AND tit_ap.cod_parcela     = STRING(v_cod_parcela, "99"))
        THEN ASSIGN v_log_refer_uni = NO
                    v_cod_parcela   = v_cod_parcela + 1.
    END.
    
    ASSIGN v_log_refer_uni = NO.
    
    /* ** Gera Referˆncia V lida ***/
    REPEAT WHILE NOT v_log_refer_uni:
       RUN pi_retorna_sugestao_referencia (INPUT  "CPI",
                                           INPUT  v_data,
                                           OUTPUT v_cod_refer).
       RUN pi_verifica_refer_unica_apb (INPUT  estabelecimento.cod_estab,
                                        INPUT  v_cod_refer,
                                        INPUT  "lote_impl_tit_ap",
                                        INPUT  ?,
                                        OUTPUT v_log_refer_uni).
    END.
    
    /* ** Cria‡Æo do Lote ***/
    CREATE tt_integr_apb_lote_impl.
    ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = estabelecimento.cod_estab
           tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer
           tt_integr_apb_lote_impl.tta_cod_espec_docto   = "CPI"
           tt_integr_apb_lote_impl.tta_dat_transacao     = v_data
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"   
           tt_integr_apb_lote_impl.tta_cod_empresa       = estabelecimento.cod_empresa.
    RELEASE tt_integr_apb_lote_impl.
    FIND FIRST tt_integr_apb_lote_impl.
    
    /* ** T¡tulo de ProvisÆo ***/
    CREATE tt_integr_apb_item_lote_impl_3.
    ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = 1
           tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = emscad.fornecedor.cdn_fornec
           tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = "CPI"
           tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = ""
           tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = "CPI" + STRING(v_data, "999999")
           tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = STRING(v_cod_parcela, "99")
           tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = v_data
           tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = v_data
           tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = v_data
           tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "20"
           tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "Real"
           tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = vvl-comissao
           tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
           tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.
    RELEASE tt_integr_apb_item_lote_impl_3.
    FIND FIRST tt_integr_apb_item_lote_impl_3.
    
    /* ** Apropria‡äes do T¡tulo ***/
    CREATE tt_integr_apb_aprop_ctbl_pend.
    ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = "ADM"
           tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "204"
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = vvl-comissao
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = "21210016".
    RELEASE tt_integr_apb_aprop_ctbl_pend.
    FIND FIRST tt_integr_apb_aprop_ctbl_pend.
    
    /* ** Transfere o t¡tulo para a nova temp-table da API ***/
    CREATE tt_integr_apb_item_lote_impl3v.
    BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.
    RELEASE tt_integr_apb_item_lote_impl3v.
    FIND FIRST tt_integr_apb_item_lote_impl3v.
    
    /* ** Chamada da API ***/ 
    RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
    
    RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                      INPUT "EMS",
                                                      INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl3v).
    
    DELETE PROCEDURE v_hdl_aux.
    
    /* ** Retorna erros da API ***/
    FOR EACH tt_log_erros_atualiz :
        CREATE tt_log_erros_comis.
        ASSIGN tt_log_erros_comis.tta_cod_estab     = estabelecimento.cod_estab
               tt_log_erros_comis.tta_cdn_repres    = comissao-fat.cod-rep
               tt_log_erros_comis.tta_periodo       = p_periodo
               tt_log_erros_comis.ttv_num_mensagem  = tt_log_erros_atualiz.ttv_num_mensagem
               tt_log_erros_comis.ttv_des_msg_erro  = tt_log_erros_atualiz.ttv_des_msg_erro
               tt_log_erros_comis.ttv_des_msg_ajuda = tt_log_erros_atualiz.ttv_des_msg_ajuda. 

        PUT UNFORMATTED "Erro na Integracao com o Contas a Pagar CPI - IMPL" "~r~n".
        PUT UNFORMATTED  tt_log_erros_comis.tta_cod_estab " - " tt_log_erros_comis.tta_cdn_repres " - " tt_log_erros_comis.tta_periodo " - " vvl-comissao " - " tt_log_erros_comis.ttv_num_mensagem " - " tt_log_erros_comis.ttv_des_msg_erro "~r~n" tt_log_erros_comis.ttv_des_msg_ajuda "~r~n".

    END.
    
    IF NOT CAN-FIND(FIRST tt_log_erros_comis) 
    THEN DO:
         FIND tit_ap NO-LOCK
            WHERE tit_ap.cod_estab   = estabelecimento.cod_estab
              AND tit_ap.cdn_fornec  = emscad.fornecedor.cdn_fornec
              AND tit_ap.cod_espec   = "CPI"
              AND tit_ap.cod_ser     = ""
              AND tit_ap.cod_tit_ap  = "CPI" + STRING(v_data, "999999")
              AND tit_ap.cod_parcela = STRING(v_cod_parcela, "99") NO-ERROR.
         IF NOT AVAIL tit_ap 
         THEN DO:
              CREATE tt_log_erros_comis.
              ASSIGN tt_log_erros_comis.tta_cod_estab     = estabelecimento.cod_estab
                     tt_log_erros_comis.tta_cdn_repres    = comissao-fat.cod-rep
                     tt_log_erros_comis.tta_periodo       = p_periodo
                     tt_log_erros_comis.ttv_num_mensagem  = 0
                     tt_log_erros_comis.ttv_des_msg_erro  = "T¡tulo nÆo gerado no contas a pagar !"
                     tt_log_erros_comis.ttv_des_msg_ajuda = "Estab/Fornec/Espec/Ser/Tit/Parc: " + estabelecimento.cod_estab + " / " + STRING(emscad.fornecedor.cdn_fornec) + " / " + "CPI/  /" + "CPI" + STRING(v_data, "999999") + " / " + "01". 
              RETURN "NOK".
         END.
    END.
    ELSE DO:
         RETURN "NOK".
    END.
    RETURN "OK".

END.

PROCEDURE pi-gera-ava:

    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.

    RUN pi-zera-tabelas.

    ASSIGN v_log_refer_uni = NO.
    
    /* ** Gera Referˆncia V lida ***/
    REPEAT WHILE NOT v_log_refer_uni:
       RUN pi_retorna_sugestao_referencia (INPUT  "CPI",
                                           INPUT  v_data,
                                           OUTPUT v_cod_refer).
       RUN pi_verifica_refer_unica_apb (INPUT  estabelecimento.cod_estab,
                                        INPUT  v_cod_refer,
                                        INPUT  "lote_impl_tit_ap",
                                        INPUT  ?,
                                        OUTPUT v_log_refer_uni).
    END.

    CREATE tt_tit_ap_alteracao_base_aux_1.
    ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = RECID(tt_tit_ap_alteracao_base_aux_1)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = v_data
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = v_cod_refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = 0
           tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = tit_ap.dat_vencto_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = tit_ap.dat_prev_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = tit_ap.dat_ult_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = tit_ap.dat_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = tit_ap.val_perc_desc
           tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = tit_ap.val_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = tit_ap.cod_portador
           tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo
           tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = tit_ap.cod_seguradora
           tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro
           tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = tit_ap.cod_arrendador
           tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas
           tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "Altera‡Æo"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = "Acerto efetuado via sistema, zeramento CPI - escms010b - per¡odo " + p_periodo + "."
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.
           
    RUN prgfin/apb/apb767ze.py(INPUT 1,
                               INPUT "",
                               INPUT "",
                               INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                               INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                               OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

    FIND FIRST tt_log_erros_tit_ap_alteracao 
         WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6542 NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao 
       THEN DELETE tt_log_erros_tit_ap_alteracao.

    IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao NO-LOCK) 
    THEN DO:
         FOR EACH tt_log_erros_tit_ap_alteracao:
             CREATE tt_log_erros_comis.
             ASSIGN tt_log_erros_comis.tta_cod_estab     = tit_ap.cod_estab
                    tt_log_erros_comis.tta_cdn_repres    = 0
                    tt_log_erros_comis.tta_periodo       = p_periodo
                    tt_log_erros_comis.ttv_num_mensagem  = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                    tt_log_erros_comis.ttv_des_msg_erro  = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                    tt_log_erros_comis.ttv_des_msg_ajuda = tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda. 

             PUT UNFORMATTED "Erro na Integracao com o Contas a Pagar CPI - AVA" "~r~n".
             PUT UNFORMATTED  tt_log_erros_comis.tta_cod_estab " - " tt_log_erros_comis.tta_cdn_repres " - " tt_log_erros_comis.tta_periodo " - " tt_log_erros_comis.ttv_num_mensagem " - " tt_log_erros_comis.ttv_des_msg_erro "~r~n" tt_log_erros_comis.ttv_des_msg_ajuda "~r~n".

         END.
         RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

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

PROCEDURE pi_verifica_refer_unica_apb:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_movto_tit_ap
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N’o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_antecip_pef_pend
        for antecip_pef_pend.
    def buffer b_lote_impl_tit_ap
        for lote_impl_tit_ap.
    def buffer b_lote_pagto
        for lote_pagto.
    def buffer b_movto_tit_ap
        for movto_tit_ap.

    /*************************** Buffer Definition End **************************/

    assign p_log_refer_uni = yes.

    find first b_antecip_pef_pend no-lock
         where b_antecip_pef_pend.cod_estab = p_cod_estab
           and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail b_antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_impl_tit_ap no-lock
         where b_lote_impl_tit_ap.cod_estab = p_cod_estab
           and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
    if  avail b_lote_impl_tit_ap
    then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_pagto no-lock
         where b_lote_pagto.cod_estab_refer = p_cod_estab
           and b_lote_pagto.cod_refer = p_cod_refer no-error.
    if  avail b_lote_pagto
    then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_movto_tit_ap no-lock
         where b_movto_tit_ap.cod_estab = p_cod_estab
           and b_movto_tit_ap.cod_refer = p_cod_refer
           and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
    if  avail b_movto_tit_ap
    then do:
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
