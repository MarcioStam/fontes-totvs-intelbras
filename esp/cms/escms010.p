/* ** Defini‡Æo das Temp-Tables da API de Implanta‡Æo ***/
{esp/cms/apb900zg.i}

/* ** Defini‡Æo das Vari veis ***/
DEF NEW GLOBAL SHARED VAR v_log_atualiza_refer_apb
    AS LOGICAL 
    FORMAT "Sim/NÆo"
    INITIAL YES 
    VIEW-AS TOGGLE-BOX 
    LABEL "Atualiza Referˆncia"
    COLUMN-LABEL "Atualiza Referˆncia"
    NO-UNDO.
DEF VAR v_log_refer_uni AS LOG    NO-UNDO.
DEF VAR v_cod_refer     AS CHAR   NO-UNDO.
DEF VAR v_data          AS DATE   NO-UNDO.
DEF VAR v_num_ano_refer AS INT    NO-UNDO.
DEF VAR v_num_mes_refer AS INT    NO-UNDO.
DEF VAR v_hdl_aux       AS HANDLE NO-UNDO.
DEF VAR v_cod_parcela   AS INT    NO-UNDO.

/* ** Defini‡Æo dos Parƒmetros ***/
DEF INPUT PARAMETER p_estab   AS CHAR.
DEF INPUT PARAMETER p_repres  AS INT.
DEF INPUT PARAMETER p_periodo AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR tt_log_erros_comis.

/*
DEF VAR p_estab   AS CHAR INITIAL "101".
DEF VAR p_repres  AS INT  INITIAL 10.
DEF VAR p_periodo AS CHAR INITIAL "200812".
*/

/* ** Limpa Temp-Table de Erros ***/
FOR EACH tt_log_erros_comis:
    DELETE tt_log_erros_comis.
END.

/* ** Atualiza lote sim ou nÆo ***/
ASSIGN v_log_atualiza_refer_apb = YES.
 
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

/* ** Leitura no totalizador das comissäes, conforme per¡odo recebido ***/
FIND comissao-fat-tot EXCLUSIVE-LOCK
    WHERE comissao-fat-tot.cod-estabel = p_estab
      AND comissao-fat-tot.cod-rep     = p_repres
      AND comissao-fat-tot.periodo     = p_periodo NO-ERROR.
IF NOT AVAIL comissao-fat-tot 
THEN DO:
     CREATE tt_log_erros_comis.
     ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
            tt_log_erros_comis.tta_cdn_repres    = p_repres
            tt_log_erros_comis.tta_periodo       = p_periodo
            tt_log_erros_comis.ttv_num_mensagem  = 0
            tt_log_erros_comis.ttv_des_msg_erro  = "Total ComissÆo Faturamento nÆo localizado !"
            tt_log_erros_comis.ttv_des_msg_ajuda = "Estab: " + p_estab + " / Repres: " + STRING(p_repres) + " / Periodo: " + p_periodo. 
     RETURN.
END.

FIND estabelecimento NO-LOCK
   WHERE estabelecimento.cod_estab = p_estab NO-ERROR.
IF NOT AVAIL estabelecimento 
THEN DO: 
     CREATE tt_log_erros_comis.
     ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
            tt_log_erros_comis.tta_cdn_repres    = p_repres
            tt_log_erros_comis.tta_periodo       = p_periodo
            tt_log_erros_comis.ttv_num_mensagem  = 0
            tt_log_erros_comis.ttv_des_msg_erro  = "Estabelecimento nÆo Localizado !"
            tt_log_erros_comis.ttv_des_msg_ajuda = "Estab: " + p_estab. 
     RETURN.
END.

FIND representante NO-LOCK
    WHERE representante.cod_empresa = estabelecimento.cod_empresa
      AND representante.cdn_repres  = p_repres NO-ERROR.
IF NOT AVAIL representante 
THEN DO: 
     CREATE tt_log_erros_comis.
     ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
            tt_log_erros_comis.tta_cdn_repres    = p_repres
            tt_log_erros_comis.tta_periodo       = p_periodo
            tt_log_erros_comis.ttv_num_mensagem  = 0
            tt_log_erros_comis.ttv_des_msg_erro  = "Representante nÆo Localizado !"
            tt_log_erros_comis.ttv_des_msg_ajuda = "Repres: " + STRING(p_repres). 
     RETURN.
END.
FIND FIRST emscad.fornecedor NO-LOCK
     WHERE emscad.fornecedor.cod_empresa = estabelecimento.cod_empresa
       AND emscad.fornecedor.num_pessoa  = representante.num_pessoa NO-ERROR.
IF NOT AVAIL emscad.fornecedor 
THEN DO: 
     CREATE tt_log_erros_comis.
     ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
            tt_log_erros_comis.tta_cdn_repres    = p_repres
            tt_log_erros_comis.tta_periodo       = p_periodo
            tt_log_erros_comis.ttv_num_mensagem  = 0
            tt_log_erros_comis.ttv_des_msg_erro  = "Fornecedor nÆo localizado !"
            tt_log_erros_comis.ttv_des_msg_ajuda = "Pessoa: " + STRING(representante.num_pessoa). 
     RETURN.
END.

ASSIGN v_log_refer_uni = NO
       v_cod_parcela   = 1.

/* ** Verifica se j  existe o t¡tulo no contas a pagar ***/
REPEAT WHILE NOT v_log_refer_uni:
    ASSIGN v_log_refer_uni = YES.
    IF CAN-FIND (tit_ap NO-LOCK
                 WHERE tit_ap.cod_estab   = p_estab
                   AND tit_ap.cdn_fornec  = emscad.fornecedor.cdn_fornec
                   AND tit_ap.cod_espec   = "CPO"
                   AND tit_ap.cod_ser     = ""
                   AND tit_ap.cod_tit_ap  = "CPO" + STRING(v_data, "999999")
                   AND tit_ap.cod_parcela = STRING(v_cod_parcela, "99")) 
    THEN ASSIGN v_log_refer_uni = NO
                v_cod_parcela   = v_cod_parcela + 1.
    
    IF CAN-FIND (FIRST tit_ap NO-LOCK 
                 WHERE tit_ap.num_pessoa      = representante.num_pessoa
                   AND tit_ap.cod_espec_docto = "CPO"
                   AND tit_ap.cod_ser_docto   = ""
                   AND tit_ap.cod_tit_ap      = "CPO" + STRING(v_data, "999999")
                   AND tit_ap.cod_parcela     = STRING(v_cod_parcela, "99"))
    THEN ASSIGN v_log_refer_uni = NO
                v_cod_parcela   = v_cod_parcela + 1.
END.

ASSIGN v_log_refer_uni = NO.

/* ** Gera Referˆncia V lida ***/
REPEAT WHILE NOT v_log_refer_uni:
   RUN pi_retorna_sugestao_referencia (INPUT  "C",
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
       tt_integr_apb_lote_impl.tta_cod_espec_docto   = "CPO"
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
       tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = "CPO"
       tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = ""
       tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = "CPO" + STRING(v_data, "999999")
       tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = STRING(v_cod_parcela, "99")
       tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = v_data
       tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = v_data
       tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = v_data
       tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "20"
       tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "Real"
       tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = comissao-fat-tot.vl-tot-comissao /* ** Valor Bruto ***/
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
       tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = comissao-fat-tot.vl-tot-comissao /* ** Valor Bruto ***/
       tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
       tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = "21930005".
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
    ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
           tt_log_erros_comis.tta_cdn_repres    = p_repres
           tt_log_erros_comis.tta_periodo       = p_periodo
           tt_log_erros_comis.ttv_num_mensagem  = tt_log_erros_atualiz.ttv_num_mensagem
           tt_log_erros_comis.ttv_des_msg_erro  = tt_log_erros_atualiz.ttv_des_msg_erro
           tt_log_erros_comis.ttv_des_msg_ajuda = tt_log_erros_atualiz.ttv_des_msg_ajuda. 
END.

IF NOT CAN-FIND(FIRST tt_log_erros_comis) 
THEN DO:
     FIND tit_ap NO-LOCK
        WHERE tit_ap.cod_estab   = p_estab
          AND tit_ap.cdn_fornec  = emscad.fornecedor.cdn_fornec
          AND tit_ap.cod_espec   = "CPO"
          AND tit_ap.cod_ser     = ""
          AND tit_ap.cod_tit_ap  = "CPO" + STRING(v_data, "999999")
          AND tit_ap.cod_parcela = STRING(v_cod_parcela, "99") NO-ERROR.
    IF AVAIL tit_ap 
    THEN DO:
         ASSIGN comissao-fat-tot.num-id-tit-ap = tit_ap.num_id_tit_ap.      
    END.
    ELSE DO:
         CREATE tt_log_erros_comis.
         ASSIGN tt_log_erros_comis.tta_cod_estab     = p_estab
                tt_log_erros_comis.tta_cdn_repres    = p_repres
                tt_log_erros_comis.tta_periodo       = p_periodo
                tt_log_erros_comis.ttv_num_mensagem  = 0
                tt_log_erros_comis.ttv_des_msg_erro  = "T¡tulo nÆo gerado no contas a pagar !"
                tt_log_erros_comis.ttv_des_msg_ajuda = "Estab/Fornec/Espec/Ser/Tit/Parc: " + p_estab + " / " + STRING(emscad.fornecedor.cdn_fornec) + " / " + "CPO/  /" + "CPO" + STRING(v_data, "999999") + " / " + "01". 
    END.
END.

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
        format "Sim/NÆo"
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

    if  p_cod_table <> "antecip_pef_pend"
    then do:
        find first b_antecip_pef_pend no-lock
             where b_antecip_pef_pend.cod_estab = p_cod_estab
               and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    end.
    if  avail b_antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
    end.
    else do:
        if  p_cod_table <> "lote_impl_tit_ap"
        then do:
            find first b_lote_impl_tit_ap no-lock
                 where b_lote_impl_tit_ap.cod_estab = p_cod_estab
                   and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
        end.
        if  avail b_lote_impl_tit_ap
        then do:
            assign p_log_refer_uni = no.
        end.
        else do:
            if  p_cod_table <> "lote_pagto"
            then do:
                find first b_lote_pagto no-lock
                     where b_lote_pagto.cod_estab_refer = p_cod_estab
                       and b_lote_pagto.cod_refer = p_cod_refer no-error.
            end.
            if  avail b_lote_pagto
            then do:
                assign p_log_refer_uni = no.
            end.
            else do:
                find first b_movto_tit_ap no-lock
                     where b_movto_tit_ap.cod_estab = p_cod_estab
                       and b_movto_tit_ap.cod_refer = p_cod_refer
                       and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
                if  avail b_movto_tit_ap
                then do:
                    assign p_log_refer_uni = no.
                end.
            end.
        end.
    end.

END PROCEDURE.
