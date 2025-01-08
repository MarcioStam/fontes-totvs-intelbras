/****************************************************************************************/
/* Programa.: esp/esb/esesbapi008p - Realizar contro de contas t¡tulos                  */
/* Data.....: 10/09/2014                                                                */
/****************************************************************************************/

{esp/esb/esesbapi008.i} /*tt-titulo-acr e temp-tables auxiliares */

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(500)"
    FIELD ajuda    AS CHAR FORMAT "X(500)".

DEFINE VARIABLE c-referencia AS CHAR NO-UNDO.
DEFINE VARIABLE v_hapb944za  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER NO-UNDO FORMAT "x(40)".

DEFINE VARIABLE h-acomp                   AS HANDLE                 NO-UNDO.

/* Parƒmetros do t¡tulo APB */
DEF INPUT  PARAM p-rowid-solicitacao  AS ROWID NO-UNDO.
DEF INPUT  PARAM p-cod-estabel        AS CHAR  NO-UNDO. 
DEF INPUT  PARAM p-canal              AS INT   NO-UNDO.
DEF INPUT  PARAM p-tit-ap             AS CHAR  NO-UNDO.
DEF INPUT  PARAM p-ser-ap             AS CHAR  NO-UNDO.
DEF INPUT  PARAM p-esp-tit-ap         AS CHAR  NO-UNDO.
DEF INPUT  PARAM p-parcela-ap         AS CHAR  NO-UNDO.
DEF INPUT  PARAM p-val-abater-tit-ap  AS DEC   NO-UNDO.
DEF INPUT  PARAM p-transacao          AS DATE  NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-titulo-acr.
DEF OUTPUT PARAM TABLE FOR tt-erro.

FIND FIRST estabelec 
    WHERE estabele.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.

RUN pi-busca-referencia (INPUT  "ENCTRO",
                         INPUT  p-cod-estabel,
                         OUTPUT c-referencia).


/*-----------------------------------------------------*/
/*         CAPA DO LOTE DO ENCONTRO DE CONTAS          */
/*-----------------------------------------------------*/ 
CREATE tt_dados_integr_apb_enc_ctas.
ASSIGN tt_dados_integr_apb_enc_ctas.tta_cod_estab_refer           = p-cod-estabel
       tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor            = p-canal
       tt_dados_integr_apb_enc_ctas.tta_cdn_cliente               = p-canal
       tt_dados_integr_apb_enc_ctas.tta_cod_refer                 = c-referencia
       tt_dados_integr_apb_enc_ctas.tta_dat_transacao             = p-transacao
       tt_dados_integr_apb_enc_ctas.tta_val_tot_lote_pagto_efetd  = 10
       tt_dados_integr_apb_enc_ctas.tta_cod_indic_econ            = "REAL"
       tt_dados_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
       tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = RECID(tt_dados_integr_apb_enc_ctas)
       tt_dados_integr_apb_enc_ctas.tta_log_bxa_estab_tit_ap      = NO
       tt_dados_integr_apb_enc_ctas.ttv_log_vinc_impto_auto       = NO.

/* MESSAGE "CAPA DO LOTE"                                                                                                                   */
/*         "tt_dados_integr_apb_enc_ctas.tta_cod_estab_refer           : " tt_dados_integr_apb_enc_ctas.tta_cod_estab_refer           SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor            : " tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor            SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_cdn_cliente               : " tt_dados_integr_apb_enc_ctas.tta_cdn_cliente               SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_cod_refer                 : " tt_dados_integr_apb_enc_ctas.tta_cod_refer                 SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_dat_transacao             : " tt_dados_integr_apb_enc_ctas.tta_dat_transacao             SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_val_tot_lote_pagto_efetd  : " tt_dados_integr_apb_enc_ctas.tta_val_tot_lote_pagto_efetd  SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_cod_indic_econ            : " tt_dados_integr_apb_enc_ctas.tta_cod_indic_econ            SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_cod_empresa               : " tt_dados_integr_apb_enc_ctas.tta_cod_empresa               SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta : " tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.tta_log_bxa_estab_tit_ap      : " tt_dados_integr_apb_enc_ctas.tta_log_bxa_estab_tit_ap      SKIP  */
/*         "tt_dados_integr_apb_enc_ctas.ttv_log_vinc_impto_auto       : " tt_dados_integr_apb_enc_ctas.ttv_log_vinc_impto_auto       SKIP  */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                   */

/*-----------------------------------------------------*/
/*  RELACIONAMENTO DO TÖTULOS APB DO CANAL CENTRAL     */
/*-----------------------------------------------------*/    
CREATE tt_item_integr_apb_enc_ctas.
ASSIGN tt_item_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
       tt_item_integr_apb_enc_ctas.tta_num_seq_refer             = 1
       tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "APB"
       tt_item_integr_apb_enc_ctas.tta_cod_estab                 = p-cod-estabel
       tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           = p-esp-tit-ap
       tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             = "U"
       tt_item_integr_apb_enc_ctas.ttv_cod_tit                   = p-tit-ap
       tt_item_integr_apb_enc_ctas.tta_cod_parcela               = p-parcela-ap
       tt_item_integr_apb_enc_ctas.tta_val_pagto                 = p-val-abater-tit-ap
       tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      = 1
       tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
       tt_item_integr_apb_enc_ctas.tta_des_text_histor           = "Pagamento Encontro de Contas - Programa de Canais".

/* MESSAGE  "RELACIONAMENTO COM O TÖTULO DO AP"                                                                                            */
/*          "tt_item_integr_apb_enc_ctas.tta_cod_empresa               : " tt_item_integr_apb_enc_ctas.tta_cod_empresa               skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_num_seq_refer             : " tt_item_integr_apb_enc_ctas.tta_num_seq_refer             skip  */
/*          "tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              : " tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_cod_estab                 : " tt_item_integr_apb_enc_ctas.tta_cod_estab                 skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           : " tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             : " tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             skip  */
/*          "tt_item_integr_apb_enc_ctas.ttv_cod_tit                   : " tt_item_integr_apb_enc_ctas.ttv_cod_tit                   skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_cod_parcela               : " tt_item_integr_apb_enc_ctas.tta_cod_parcela               skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_val_pagto                 : " tt_item_integr_apb_enc_ctas.tta_val_pagto                 skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      : " tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      skip  */
/*          "tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta : " tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta skip  */
/*          "tt_item_integr_apb_enc_ctas.tta_des_text_histor           : " tt_item_integr_apb_enc_ctas.tta_des_text_histor           skip  */
/*                                                                                                                                         */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                  */

/*---------------------------------------------*/
/*  RELACIONAMENTO DOS TÖTULOS (DUPLICATAS     */
/*---------------------------------------------*/    
DEF VAR i-seq AS INT NO-UNDO.

FOR EACH tt-titulo-acr:

    i-seq = i-seq + 1.
    CREATE tt_item_integr_apb_enc_ctas.
    ASSIGN tt_item_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
           tt_item_integr_apb_enc_ctas.tta_num_seq_refer             = i-seq
           tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "ACR"
           tt_item_integr_apb_enc_ctas.tta_cod_estab                 = tt-titulo-acr.cod_estab
           tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           = tt-titulo-acr.cod_espec_docto
           tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             = tt-titulo-acr.cod_ser_docto
           tt_item_integr_apb_enc_ctas.ttv_cod_tit                   = tt-titulo-acr.cod_tit_acr
           tt_item_integr_apb_enc_ctas.tta_cod_parcela               = tt-titulo-acr.cod_parcela
           tt_item_integr_apb_enc_ctas.tta_val_pagto                 = tt-titulo-acr.valor
           tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      = 1
           tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
           tt_item_integr_apb_enc_ctas.tta_des_text_histor           = "Pagamento Encontro de Contas - Programa de Canais"       
           tt_item_integr_apb_enc_ctas.tta_cod_portador              = "999"
           tt_item_integr_apb_enc_ctas.tta_cod_cart_bcia             = "90".
/*                                                                                                                                             */
/*     MESSAGE  "tt_item_integr_apb_enc_ctas.tta_cod_empresa               : "  tt_item_integr_apb_enc_ctas.tta_cod_empresa               skip */
/*              "tt_item_integr_apb_enc_ctas.tta_num_seq_refer             : "  tt_item_integr_apb_enc_ctas.tta_num_seq_refer             skip */
/*              "tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              : "  tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_estab                 : "  tt_item_integr_apb_enc_ctas.tta_cod_estab                 skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           : "  tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             : "  tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             skip */
/*              "tt_item_integr_apb_enc_ctas.ttv_cod_tit                   : "  tt_item_integr_apb_enc_ctas.ttv_cod_tit                   skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_parcela               : "  tt_item_integr_apb_enc_ctas.tta_cod_parcela               skip */
/*              "tt_item_integr_apb_enc_ctas.tta_val_pagto                 : "  tt_item_integr_apb_enc_ctas.tta_val_pagto                 skip */
/*              "tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      : "  tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      skip */
/*              "tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta : "  tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta skip */
/*              "tt_item_integr_apb_enc_ctas.tta_des_text_histor           : "  tt_item_integr_apb_enc_ctas.tta_des_text_histor           skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_portador              : "  tt_item_integr_apb_enc_ctas.tta_cod_portador              skip */
/*              "tt_item_integr_apb_enc_ctas.tta_cod_cart_bcia             : "  tt_item_integr_apb_enc_ctas.tta_cod_cart_bcia                  */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                  */
END.


IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      

IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Encontro de contas.").

IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-acompanhar IN h-acomp (INPUT "Efetuando atualiza‡Æo dos t¡tulos...").

/* TRANSA€ÇO PRINCIPAL */                                                    
bloco:                                                                       
DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco ON ERROR UNDO bloco, LEAVE bloco:  
       
    ASSIGN v_des_contdo_prog_valid_dtsul = "esesbapi008".

    RUN prgfin/apb/apb944za.py PERSISTENT SET v_hapb944za.
    
    RUN pi_main_api_enctro_cta_apb_acr_ems5_2 IN v_hapb944za (INPUT 1,
                                                              INPUT TABLE tt_dados_integr_apb_enc_ctas,
                                                              INPUT TABLE tt_item_integr_apb_enc_ctas,
                                                              INPUT "",
                                                              OUTPUT TABLE tt_log_integr_apb_enc_ctas,
                                                              OUTPUT TABLE tt_tit_acr_info,
                                                              INPUT NO).
    DELETE PROCEDURE v_hapb944za.

    ASSIGN v_des_contdo_prog_valid_dtsul = "".
    
     
    DEF VAR c-help AS CHAR FORMAT "X(5000)".

    FOR EACH tt_item_integr_apb_enc_ctas
        WHERE tt_item_integr_apb_enc_ctas.ttv_cod_tit <> p-esp-tit-ap:

        ASSIGN c-help =  c-help + "TÖTULOS RELACIONADOS" + CHR(10) + 
                                  "Estab......: " + STRING(tt_item_integr_apb_enc_ctas.tta_cod_estab)       + CHR(10) + 
                                  "Esp........: " + STRING(tt_item_integr_apb_enc_ctas.tta_cod_espec_docto) + CHR(10) + 
                                  "S‚rie......: " + STRING(tt_item_integr_apb_enc_ctas.tta_cod_ser_docto)   + CHR(10) + 
                                  "T¡tulo.....: " + STRING(tt_item_integr_apb_enc_ctas.ttv_cod_tit )        + CHR(10) + 
                                  "Parcela....: " + STRING(tt_item_integr_apb_enc_ctas.tta_cod_parcela)     + CHR(10) + 
                                  "Pagto......: " + STRING(tt_item_integr_apb_enc_ctas.tta_val_pagto)       + CHR(10) + CHR(10).
    END.

    FOR EACH tt_log_integr_apb_enc_ctas:
         
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT tt_log_integr_apb_enc_ctas.ttv_num_cod_erro,
                                            INPUT tt_log_integr_apb_enc_ctas.ttv_des_msg_erro,
                                            INPUT tt_log_integr_apb_enc_ctas.ttv_des_msg_ajuda + CHR(10) + c-help).
    END.

    IF  CAN-FIND (FIRST tt-erro) THEN DO:
       IF VALID-HANDLE(h-acomp) then    
            RUN pi-finalizar IN h-acomp. 

        UNDO, RETURN "NOK".
    END.

    /* VERIFICA SE REALMENTE CONSEGUIU GRAVAR O LOTE */
    FIND enctro_cta NO-LOCK
        WHERE enctro_cta.cod_estab = p-cod-estabel
          AND enctro_cta.cod_refer = c-referencia NO-ERROR.

    IF  NOT AVAIL enctro_cta THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Erro na atualiza‡Æo encontro de contas",
                                            INPUT "Ocorreu um erro de atualiza‡Æo. Informe ao suporte TIC caso erros tenham sido apresentados em tela. Talvez seja falta de permissÆo de usu rio aos programas.").
       IF VALID-HANDLE(h-acomp) then
            RUN pi-finalizar IN h-acomp.

        UNDO, RETURN "NOK".
    END.

    /*----------------------------------------------*/
    /*  MUDAR STATUS DA SOLICITACAO PARA  P A G A   */
    /*----------------------------------------------*/
    FIND int-solicitacao EXCLUSIVE-LOCK
        WHERE ROWID(int-solicitacao) = p-rowid-solicitacao NO-ERROR.

    IF  AVAIL int-solicitacao THEN DO:
    
        ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004
               int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004
               int-solicitacao.ValorPago                       = int-solicitacao.ValorAbater
               int-solicitacao.ref-encontro-contas             = c-referencia.

    END.
    IF  int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004 THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Erro ao atualizar o STATUS da Solicita‡Æo",
                                            INPUT "Ocorreu um erro de atualiza‡Æo da Situa‡Æo da Solicita‡Æo. Provavelemente a tabela est  em lock com outro usu rio").
       IF VALID-HANDLE(h-acomp) then    
            RUN pi-finalizar IN h-acomp. 

        UNDO, RETURN "NOK".
    END.

    FIND CURRENT int-solicitacao NO-LOCK NO-ERROR.
    RELEASE int-solicitacao.


    /*RUN prgfin/acr/acr212aa.r.*/

END. /*End Trans*/

IF VALID-HANDLE(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 

RETURN "OK".

PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/NÆo" INITIAL YES NO-UNDO.
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

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

