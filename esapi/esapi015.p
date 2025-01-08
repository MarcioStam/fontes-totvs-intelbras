/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/

DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.
DEF VAR h-acomp      as handle no-undo.

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as INTEGER no-undo.
    
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}
{utp/utapi009.i}
/* {esbo/boes455.i tt-vpc} */
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
    FIELD r-Rowid AS ROWID.
/* {esbo/boes456.i tt-pagto-vpc} */
     
DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

PROCEDURE pi-libera-vpc.
    DEFINE INPUT  PARAMETER TABLE FOR tt-vpc.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros_atualiz.

    DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.

    FOR EACH tt_log_erros_atualiz:
        DELETE tt_log_erros_atualiz.
    END.

    FIND FIRST tt-vpc NO-ERROR.
    IF NOT AVAIL tt-vpc THEN DO:
        CREATE tt_log_erros_atualiz.
        ASSIGN tt_log_erros_atualiz.ttv_num_mensagem  = 17006
               tt_log_erros_atualiz.ttv_des_msg_erro  = "VPC n∆o encontrada."
               tt_log_erros_atualiz.ttv_des_msg_ajuda = "VPC inexistente.".
        RETURN "NOK".
    END.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = tt-vpc.cod-estabel NO-ERROR.
    IF NOT AVAIL estabelec THEN DO:
        CREATE tt_log_erros_atualiz.
        ASSIGN tt_log_erros_atualiz.ttv_num_mensagem  = 17006
               tt_log_erros_atualiz.ttv_des_msg_erro  = "Estabelecimento inv†lido."
               tt_log_erros_atualiz.ttv_des_msg_ajuda = "Estabelecimento: " + STRING(tt-vpc.cod-estabel) + " n∆o cadastrado.".
        RETURN "NOK".
    END.

    FIND FIRST tipo-verba NO-LOCK
         WHERE tipo-verba.codigo = tt-vpc.tipo-verba NO-ERROR.
    IF NOT AVAIL tipo-verba THEN DO:
        CREATE tt_log_erros_atualiz.
        ASSIGN tt_log_erros_atualiz.ttv_num_mensagem  = 17006
               tt_log_erros_atualiz.ttv_des_msg_erro  = "Tipo Verba inv†lida."
               tt_log_erros_atualiz.ttv_des_msg_ajuda = "Tipo Verba " + STRING(tt-vpc.tipo-verba) + " n∆o cadastrada.".
        RETURN "NOK".
    END.

    FOR EACH vpc-rateio NO-LOCK
        WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:

        FIND FIRST ctb-tipo-verba NO-LOCK
             WHERE ctb-tipo-verba.codigo         = tt-vpc.tipo-verba 
               AND ctb-tipo-verba.cod-estabel    = tt-vpc.cod-estabel
               AND ctb-tipo-verba.cod-unid-negoc = vpc-rateio.cod-unid-negoc NO-ERROR.

        IF NOT AVAIL ctb-tipo-verba THEN DO:
            CREATE tt_log_erros_atualiz.
            ASSIGN tt_log_erros_atualiz.ttv_num_mensagem  = 17006
                   tt_log_erros_atualiz.ttv_des_msg_erro  = "Parametros Contabil Tipo Verba n∆o encontrado"
                   tt_log_erros_atualiz.ttv_des_msg_ajuda = "N∆o encontrado parametros contabil para Tipo Verba: " + 
                                                           STRING(tt-vpc.tipo-verba) + " Estab: " + tt-vpc.cod-estabel + " Unidade Neg¢cio: " + STRING(vpc-rateio.cod-unid-negoc) +  ".".
    
            RETURN "NOK".
        END.
    END.

    /* Atualiza lote sim ou nío */
    assign v_log_atualiza_refer_apb = YES.

    /*Criando Temp Table*/

    /*lotes de implantaªío*/		
    create tt_integr_apb_lote_impl.
    assign tt_integr_apb_lote_impl.tta_cod_estab                = tt-vpc.cod-estabel
           tt_integr_apb_lote_impl.tta_cod_refer                = "VPC" + STRING(tt-vpc.nr-vpc,"9999999")
    /*       tt_integr_apb_lote_impl.tta_cod_espec_docto          = "dp" Esp≤cie sΩ deve ser informada quando for Previsío/Provisío*/
           tt_integr_apb_lote_impl.tta_dat_transacao            = tt-vpc.data-trans
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        = "apb"   
           tt_integr_apb_lote_impl.tta_cod_empresa              = STRING(estabelec.ep-codigo).

    release tt_integr_apb_lote_impl.  

    find first tt_integr_apb_lote_impl no-lock.

    /*itens dos lote de implantaªío*/
    create tt_integr_apb_item_lote_impl_3.
    assign tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = 1
           tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = tt-vpc.cod-emitente
           tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = tipo-verba.cod-esp
           tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "U"
           tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = "ADM" + STRING(tt-vpc.nr-vpc,"9999999")
           tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = "01"
           tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = tt-vpc.data-trans
           tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = tt-vpc.data-vencto
           tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = tt-vpc.data-vencto
           tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /*boleto*/
           tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"
           tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = tt-vpc.valor
           tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
           tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.
            release tt_integr_apb_item_lote_impl_3.

    release tt_integr_apb_item_lote_impl_3.
    FIND FIRST tt_integr_apb_item_lote_impl_3 NO-LOCK NO-ERROR.

    /*ApropriaªÑes dos t≠tulos*/

    FOR EACH vpc-rateio NO-LOCK
        WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:

        FIND FIRST ctb-tipo-verba NO-LOCK
           WHERE ctb-tipo-verba.codigo         = tt-vpc.tipo-verba 
             AND ctb-tipo-verba.cod-estabel    = tt-vpc.cod-estabel
             AND ctb-tipo-verba.cod-unid-negoc = vpc-rateio.cod-unid-negoc NO-ERROR.

        create tt_integr_apb_aprop_ctbl_pend.
        assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
               tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = vpc-rateio.cod-unid-negoc
               tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = tipo-verba.tp-fluxo-financ
               tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = vpc-rateio.valor
               tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
               tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
               tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "Padrao"
               tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = ctb-tipo-verba.ct-codigo
                tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto         = "Padrao"
               tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = vpc-rateio.cod_ccusto /*SUBSTRING(ctb-tipo-verba.sc-codigo,4,5)*/ .
    END.
    assign p_num_vers_integr_api     = 4
           v_cod_matriz_trad_org_ext = "EMS".


    /*chamada da api*/ 

    /* --- Nova chamada --- */
    run prgfin/apb/apb900zg.py persistent set v_hdl_aux /*prg_api_tit_ap_cria_4*/.

    for each tt_integr_apb_item_lote_impl_3:
        create tt_integr_apb_item_lote_impl3v.
        buffer-copy tt_integr_apb_item_lote_impl_3
                 to tt_integr_apb_item_lote_impl3v.
    end.  


    DO TRANSACTION:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Liberaá∆o VPC...").

        run pi-acompanhar in h-acomp (INPUT "VPC: " + STRING(tt-vpc.nr-vpc)).
        run pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (Input 5,
                                             Input v_cod_matriz_trad_org_ext,
                                             input-output table tt_integr_apb_item_lote_impl3v) /*pi_main_block_api_tit_ap_cria_4*/.
        RUN pi-finalizar in h-acomp.
        delete procedure v_hdl_aux.  
    
        IF CAN-FIND(FIRST tt_log_erros_atualiz NO-LOCK) THEN
            RETURN "NOK".
        ELSE DO:
            FIND FIRST vpc EXCLUSIVE-LOCK
                 WHERE vpc.nr-vpc = tt-vpc.nr-vpc NO-ERROR.
            IF AVAIL vpc THEN DO:
                FIND FIRST tt_integr_apb_item_lote_impl3v NO-LOCK NO-ERROR.
                IF NOT AVAIL tt_integr_apb_item_lote_impl3v THEN
                    RETURN "NOK".

                ASSIGN vpc.situacao          = 1
                       vpc.nro-docto         = tt_integr_apb_item_lote_impl3v.tta_cod_tit_ap
                       vpc.serie             = tt_integr_apb_item_lote_impl3v.tta_cod_ser_docto
                       vpc.cod-esp           = tt_integr_apb_item_lote_impl3v.tta_cod_espec_docto
                       vpc.data-liberacao    = TODAY
                       vpc.usuario-liberacao = v_cod_usuar_corren.

                RUN pi-retorna-email(INPUT v_cod_usuar_corren, OUTPUT c-email).

                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = vpc.cod-emitente NO-ERROR.

                ASSIGN c-mensagem = CAPS(tipo-verba.descricao) + " aprovada senha nß: " + STRING(vpc.nr-vpc) + CHR(13) +
                                    "C¢d. Emitente: " + STRING(vpc.cod-emitente) + " - " + TRIM(emitente.nome-emit) + CHR(13) +   
                                    "Valor Aprovado: " + TRIM(STRING(vpc.valor,"->>>,>>>,>>9.99")) + CHR(13) + CHR(13) +
                                    "OBS: ***Favor encaminhar empenho de verba devidamente preenchido para " + TRIM(c-email) + ", no prazo de 24 horas***".
                
                RUN pi-envia-email(/*Remetente   */ INPUT c-email,
                                   /*Destinatario*/ INPUT vpc.email-repres, 
                                   /*Assunto     */ INPUT "Aprovaá∆o " + CAPS(tipo-verba.descricao),
                                   /*Mensagem    */ INPUT c-mensagem,
                                   /*Anexo       */ INPUT "").
            END.
        END.
        /*RUN prgfin/apb/apb222aa.r.
        UNDO, LEAVE.                */
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-altera-vencto:
    DEFINE INPUT PARAMETER p-nr-vpc      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-data-vencto AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros_tit_ap_alteracao.

    DEFINE VARIABLE c-refer AS CHARACTER   NO-UNDO.

    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

    IF p-data-vencto = ? THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Data Vencimento T°tulo inv†lida."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Data de Vencimento do t°tulo deve ser informada.".
        RETURN "NOK".
    END.

    IF p-motivo = "" THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Motivo da Alteraá∆o Vencimento inv†lida."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "ê obrigat¢rio informar motivo alteraá∆o do vencimento do t°tulo.".
        RETURN "NOK".
    END.

    FIND FIRST vpc NO-LOCK WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF NOT AVAIL vpc THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "VPC " + STRING(p-nr-vpc) + " n∆o encontrada."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "VPC inexistente ou j† foi eliminada.".
        RETURN "NOK".
    END.

    FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = vpc.cod-estabel
           AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
           AND tit_ap.cod_espec_docto = vpc.cod-esp
           AND tit_ap.cod_ser_docto   = vpc.serie
           AND tit_ap.cod_tit_ap      = vpc.nro-docto
           AND tit_ap.cod_parcela     = "01" NO-ERROR.
    IF NOT AVAIL tit_ap THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "T°tulo da VPC n∆o encontrado."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi encontrado t°tulo para Est:" + vpc.cod-estabel + " Emitente: " + STRING(vpc.cod-emitente) +
                                                        " Especie: " + vpc.cod-esp + " Serie: " + vpc.serie + " Documento: " + vpc.nro-docto + " Parcela: 01".
        RETURN "NOK".
    END.

    IF tit_ap.val_sdo_tit_ap = 0 THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Alteraá∆o n∆o pode ser efetuada, pois t°tulo j† est† finalizado."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi poss°vel efetuar alteraá∆o do vencimento, pois t°tulo j† foi finalizado.".
        RETURN "NOK".
    END.

    /*busca referencia*/
    ASSIGN c-refer = "".
    RUN pi-busca-referencia (INPUT "VPCD",
                             INPUT vpc.cod-estabel,
                             OUTPUT c-refer).

    /*gera referencia*/
    create tt_tit_ap_alteracao_base_aux_1.
    assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = TODAY
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = tit_ap.val_sdo_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = p-data-vencto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = p-data-vencto
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
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = p-motivo
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.
           
    DO TRANSACTION:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Altera Vencimento VPC...").
        RUN pi-acompanhar in h-acomp (INPUT "VPC: " + STRING(vpc.nr-vpc) + " - Vencto: " + STRING(p-data-vencto,"99/99/9999") ).
        run prgfin/apb/apb767ze.py(input 1,
                                   input "",
                                   INPUT "",
                                   input-output table tt_tit_ap_alteracao_base_aux_1,
                                   input-output table tt_tit_ap_alteracao_rateio,
                                   output table tt_log_erros_tit_ap_alteracao).
        RUN pi-finalizar in h-acomp.

        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao NO-LOCK) THEN DO:
            RETURN "NOK".
        END.
        ELSE DO:
            FIND FIRST vpc EXCLUSIVE-LOCK
                 WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
            IF AVAIL vpc THEN
                ASSIGN vpc.data-vencto = p-data-vencto.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-zera-saldo:
    DEFINE INPUT PARAMETER p-nr-vpc      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros_tit_ap_alteracao.

    DEFINE VARIABLE c-refer    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.

    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

    FIND FIRST vpc NO-LOCK WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF NOT AVAIL vpc THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "VPC " + STRING(p-nr-vpc) + " n∆o encontrada."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "VPC inexistente ou j† foi eliminada.".
        RETURN "NOK".
    END.

    IF p-motivo = "" THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Motivo Geraá∆o AVA(-) inv†lido."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "ê obrigat¢rio informar motivo da geraá∆o do AVA(-) do t°tulo.".
        RETURN "NOK".
    END.

    FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = vpc.cod-estabel
           AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
           AND tit_ap.cod_espec_docto = vpc.cod-esp
           AND tit_ap.cod_ser_docto   = vpc.serie
           AND tit_ap.cod_tit_ap      = vpc.nro-docto
           AND tit_ap.cod_parcela     = "01" NO-ERROR.
    IF NOT AVAIL tit_ap THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "T°tulo da VPC n∆o encontrado."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi encontrado t°tulo para Est:" + vpc.cod-estabel + " Emitente: " + STRING(vpc.cod-emitente) +
                                                        " Especie: " + vpc.cod-esp + " Serie: " + vpc.serie + " Documento: " + vpc.nro-docto + " Parcela: 01".
        RETURN "NOK".
    END.

    IF tit_ap.val_sdo_tit_ap = 0 THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "AVA(-) n∆o pode ser efetuado, pois t°tulo j† est† sem saldo."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi poss°vel efetuar AVA(-), pois saldo do t°tulo j† est† zerado.".
        RETURN "NOK".
    END.

    ASSIGN i-situacao = IF tit_ap.val_origin_tit_ap = tit_ap.val_sdo_tit_ap THEN 3 ELSE 2.

    /*busca referencia*/
    ASSIGN c-refer = "".
    RUN pi-busca-referencia (INPUT "VPCV",
                             INPUT vpc.cod-estabel,
                             OUTPUT c-refer).

    /*gera referencia*/
    create tt_tit_ap_alteracao_base_aux_1.
    assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = TODAY
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
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
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = p-motivo
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.
           
    DO TRANSACTION:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Zera Saldo VPC...").
        RUN pi-acompanhar in h-acomp (INPUT "VPC: " + STRING(vpc.nr-vpc) + " - Documento: " + STRING(tit_ap.cod_tit_ap)).
        run prgfin/apb/apb767ze.py(input 1,
                                   input "",
                                   INPUT "",
                                   input-output table tt_tit_ap_alteracao_base_aux_1,
                                   input-output table tt_tit_ap_alteracao_rateio,
                                   output table tt_log_erros_tit_ap_alteracao).
        RUN pi-finalizar in h-acomp.

        FIND FIRST tt_log_erros_tit_ap_alteracao 
             WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6542 NO-ERROR.
        IF AVAIL tt_log_erros_tit_ap_alteracao THEN
            DELETE tt_log_erros_tit_ap_alteracao.

        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao NO-LOCK) THEN DO:
            RETURN "NOK".
        END.
        ELSE DO:
            FIND FIRST vpc EXCLUSIVE-LOCK
                 WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
            IF AVAIL vpc THEN
                ASSIGN vpc.situacao = i-situacao.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-pagamento-vpc:
    DEFINE INPUT PARAMETER TABLE FOR tt-pagto-vpc.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros_tit_ap_alteracao.

    DEFINE VARIABLE c-refer    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-pag  AS INTEGER     NO-UNDO.

    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

    FIND FIRST tt-pagto-vpc NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-pagto-vpc THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Pagamento VPC n∆o encontrada."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Pagamento VPC n∆o encontrada.".
        RETURN "NOK".
    END.

    FIND FIRST vpc NO-LOCK WHERE vpc.nr-vpc = tt-pagto-vpc.nr-vpc NO-ERROR.
    IF NOT AVAIL vpc THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "VPC " + STRING(tt-pagto-vpc.nr-vpc) + " n∆o encontrada."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "VPC inexistente ou j† foi eliminada.".
        RETURN "NOK".
    END.

    IF tt-pagto-vpc.observacoes = "" THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Observaá∆o AVA(-) Pagamento Produto inv†lido."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "ê obrigat¢rio informar motivo da geraá∆o do AVA(-) do pagamento por produto.".
        RETURN "NOK".
    END.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = tt-pagto-vpc.cod-estab-nf
           AND nota-fiscal.serie       = tt-pagto-vpc.serie
           AND nota-fiscal.nr-nota-fis = tt-pagto-vpc.nr-nota-fis NO-ERROR.
    IF NOT AVAIL nota-fiscal THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Nota Fiscal do Pagamento Ç inv†lida."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Nota Fiscal do pagamento por produto n∆o est† cadastrada.".
        RETURN "NOK".
    END.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = tt-pagto-vpc.nr-pedcli NO-ERROR.
    IF  NOT AVAIL ped-venda THEN DO:

        FIND FIRST ped-fiscal
            WHERE ped-fiscal.nr-pedido = int(tt-pagto-vpc.nr-pedcli) NO-LOCK NO-ERROR.

        IF  NOT AVAIL ped-fiscal THEN DO:
            CREATE tt_log_erros_tit_ap_alteracao.
            ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
                   tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Pedido do Pagamento Ç inv†lida."
                   tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Pedido do pagamento por produto n∆o est† cadastrado.".
            RETURN "NOK".
        END.
    END.

    FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = vpc.cod-estabel
           AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
           AND tit_ap.cod_espec_docto = vpc.cod-esp
           AND tit_ap.cod_ser_docto   = vpc.serie
           AND tit_ap.cod_tit_ap      = vpc.nro-docto
           AND tit_ap.cod_parcela     = "01" NO-ERROR.
    IF NOT AVAIL tit_ap THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "T°tulo da VPC n∆o encontrado."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi encontrado t°tulo para Est:" + vpc.cod-estabel + " Emitente: " + STRING(vpc.cod-emitente) +
                                                        " Especie: " + vpc.cod-esp + " Serie: " + vpc.serie + " Documento: " + vpc.nro-docto + " Parcela: 01".
        RETURN "NOK".
    END.

    IF tit_ap.val_sdo_tit_ap = 0 THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "AVA(-) n∆o pode ser efetuado, pois t°tulo j† est† sem saldo."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o foi poss°vel efetuar AVA(-), pois saldo do t°tulo j† est† zerado.".
        RETURN "NOK".
    END.

    IF tit_ap.val_sdo_tit_ap - tt-pagto-vpc.valor < 0 THEN DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Valor do Pagamento superior ao saldo do t°tulo R$: " + TRIM(STRING(tit_ap.val_sdo_tit_ap,"->>>,>>>,>>9.99")) + "."
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Valor do Pagamento n∆o pode ser maior que R$: " + TRIM(STRING(tit_ap.val_sdo_tit_ap,"->>>,>>>,>>9.99")) + ".".
        RETURN "NOK".
    END.

    IF tit_ap.val_sdo_tit_ap - tt-pagto-vpc.valor = 0 THEN DO:
        ASSIGN i-situacao = 2.
    END.
    ELSE DO:
        ASSIGN i-situacao = vpc.situacao.
    END.
    /*busca referencia*/
    ASSIGN c-refer = "".
    RUN pi-busca-referencia (INPUT "VPCB",
                             INPUT vpc.cod-estabel,
                             OUTPUT c-refer).

    /*Monta observacao do pagamento por produto + observacao digitada pelo usuario*/
    ASSIGN tt-pagto-vpc.observacoes = "Est: " + tt-pagto-vpc.cod-estab-nf + 
                                      " Serie: " + tt-pagto-vpc.serie + 
                                      " Nota Fiscal: " + tt-pagto-vpc.nr-nota-fis + 
                                      " Pedido: " + tt-pagto-vpc.nr-pedcli + 
                                      chr(13) + tt-pagto-vpc.observacoes.

    /*gera referencia*/
    create tt_tit_ap_alteracao_base_aux_1.
    assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = RECID(tit_ap)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = tt-pagto-vpc.data-pagto
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = tit_ap.val_sdo_tit_ap - tt-pagto-vpc.valor
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
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = tt-pagto-vpc.observacoes
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                = 1.

    /* 
    FIND FIRST tipo-verba NO-LOCK
         WHERE tipo-verba.codigo = vpc.tipo-verba NO-ERROR.
    IF AVAIL tipo-verba THEN DO:
        FIND FIRST ctb-tipo-verba NO-LOCK
             WHERE ctb-tipo-verba.codigo         = vpc.tipo-verba 
               AND ctb-tipo-verba.cod-estabel    = vpc.cod-estabel
               AND ctb-tipo-verba.cod-unid-negoc = vpc.cod-unid-negoc
               AND ctb-tipo-verba.cod_ccusto     = vpc.cod_ccusto NO-ERROR.
        IF AVAIL ctb-tipo-verba THEN DO:
            CREATE tt_tit_ap_alteracao_rateio.
            ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = RECID(tit_ap)
                   tt_tit_ap_alteracao_rateio.tta_cod_estab             = tit_ap.cod_estab
                   tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_rateio.tta_cod_refer             = c-refer
                   tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = 1
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = "PADRAO"
                   tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = ctb-tipo-verba.ct-codigo
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto      = "Padrao"                 
                   tt_tit_ap_alteracao_rateio.tta_cod_ccusto            = vpc.cod_ccusto
                   tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
                   tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor"
                   tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl        = tt-pagto-vpc.valor.
        END.
        ELSE DO:
            CREATE tt_log_erros_tit_ap_alteracao.
            ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
                   tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "ParÉmetro Cont†bil Tipo Verba N∆o Encontrado!"
                   tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "Cadastrar o ParÉmetro Cont†bil Tipo Verba NO ESUTP021. Tipo:" + STRING(vpc.tipo-verba) + "/Estab:" + STRING(vpc.cod-estabel) + "/UN:" + STRING(vpc.cod-unid-negoc) + "/CC:" + STRING(vpc.cod_ccusto).
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        CREATE tt_log_erros_tit_ap_alteracao.
        ASSIGN tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  = 17006
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  = "Tipo Verba n∆o encontrado!"
               tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda = "N∆o encontrado o Tipo Verba " + STRING(vpc.tipo-verba).
        RETURN "NOK".
    END.
    */

    DO TRANSACTION:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Pagamento VPC...").
        RUN pi-acompanhar in h-acomp (INPUT "VPC: " + STRING(vpc.nr-vpc) + " - Documento: " + STRING(tit_ap.cod_tit_ap)).
        run prgfin/apb/apb767ze.py(input 1,
                                   input "",
                                   INPUT "",
                                   input-output table tt_tit_ap_alteracao_base_aux_1,
                                   input-output table tt_tit_ap_alteracao_rateio,
                                   output table tt_log_erros_tit_ap_alteracao).
        RUN pi-finalizar in h-acomp.

        FIND FIRST tt_log_erros_tit_ap_alteracao 
             WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6542 NO-ERROR.
        IF AVAIL tt_log_erros_tit_ap_alteracao THEN
            DELETE tt_log_erros_tit_ap_alteracao.

        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao NO-LOCK) THEN DO:
            RETURN "NOK".
        END.
        ELSE DO:
            FIND FIRST vpc EXCLUSIVE-LOCK
                 WHERE vpc.nr-vpc = tt-pagto-vpc.nr-vpc NO-ERROR.
            IF AVAIL vpc THEN DO:
                ASSIGN vpc.situacao = i-situacao.

                FIND LAST pagto-vpc NO-LOCK
                    WHERE pagto-vpc.nr-vpc = tt-pagto-vpc.nr-vpc NO-ERROR.
                IF NOT AVAIL pagto-vpc THEN
                    ASSIGN i-seq-pag = 1.
                ELSE 
                    ASSIGN i-seq-pag = pagto-vpc.sequencia + 1.

                CREATE pagto-vpc.
                ASSIGN pagto-vpc.nr-vpc       = vpc.nr-vpc
                       pagto-vpc.sequencia    = i-seq-pag
                       pagto-vpc.data-trans   = tt-pagto-vpc.data-trans
                       pagto-vpc.data-pagto   = tt-pagto-vpc.data-pagto
                       pagto-vpc.cod-estab-nf = tt-pagto-vpc.cod-estab-nf
                       pagto-vpc.serie        = tt-pagto-vpc.serie
                       pagto-vpc.nr-nota-fis  = tt-pagto-vpc.nr-nota-fis
                       pagto-vpc.nr-pedcli    = tt-pagto-vpc.nr-pedcli
                       pagto-vpc.observacoes  = tt-pagto-vpc.observacoes
                       pagto-vpc.usuario      = tt-pagto-vpc.usuario 
                       pagto-vpc.valor        = tt-pagto-vpc.valor
                       pagto-vpc.refer-docto  = c-refer.
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-envia-email:
    DEFINE INPUT PARAMETER p-remetente AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-destino   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-assunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-anexo     AS CHARACTER NO-UNDO.

    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    FIND FIRST param-global NO-LOCK.

    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.remetente         = p-remetente
           tt-envio.destino           = p-destino
           tt-envio.assunto           = p-assunto
           tt-envio.mensagem          = p-mensagem
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = no.
           tt-envio.arq-anexo         = p-anexo.
           
     run utp/utapi009.p ( input  table tt-envio,
                          output  table tt-erros).

     IF CAN-FIND(FIRST tt-erros) THEN DO:
         FOR EACH tt-erros:
             MESSAGE "Erro envio email : "tt-erros.cod-erro " - " tt-erros.desc-erro VIEW-AS ALERT-BOX.
             DELETE tt-erros.
         END.
     END.

END PROCEDURE.

PROCEDURE pi-retorna-email:
    DEFINE  INPUT PARAMETER p-usuario AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-email   AS CHARACTER NO-UNDO.

    ASSIGN p-email = "".
    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = p-usuario NO-ERROR.
    IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN 
        ASSIGN p-email = usuar_mestre.cod_e_mail_local.

END PROCEDURE.

PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer      AS CHARACTER NO-UNDO.

    def var v_log_refer_uni
        as logical
        format "Sim/Nío"
        initial yes
        no-undo.

    def var v_cod_refer
        as character
        format "x(10)":U
        label "Referºncia"
        column-label "Referºncia"
        no-undo.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia (Input p-sigla,
                                            output v_cod_refer).

        run pi_verifica_refer_unica_apb (Input p-cod-estabel,
                                         Input v_cod_refer,
                                         Input "lote_impl_tit_ap",
                                         Input ?,
                                         output v_log_refer_uni).

    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign p_cod_refer = substring(p_ind_tip_atualiz,1,4)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 6:
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
        format "Sim/Nío"
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

PROCEDURE pi-retorna-saldo-titulo:
    DEFINE INPUT  PARAMETER p-nr-vpc AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo  AS DECIMAL NO-UNDO.


    ASSIGN p-saldo = ?.

    FIND FIRST vpc NO-LOCK
         WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF AVAIL vpc THEN DO:
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = vpc.cod-estabel
               AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
               AND tit_ap.cod_espec_docto = vpc.cod-esp
               AND tit_ap.cod_ser_docto   = vpc.serie
               AND tit_ap.cod_tit_ap      = vpc.nro-docto
               AND tit_ap.cod_parcela     = "01" NO-ERROR.
        IF AVAIL tit_ap THEN ASSIGN p-saldo = tit_ap.val_sdo_tit_ap.
    END.

END PROCEDURE.

PROCEDURE pi-verifica-titulo:
    DEFINE INPUT PARAMETER p-nr-vpc AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-recid AS RECID   NO-UNDO.
    
    ASSIGN p-recid = ?.

    FIND FIRST vpc NO-LOCK
         WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF AVAIL vpc THEN DO:
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = vpc.cod-estabel
               AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
               AND tit_ap.cod_espec_docto = vpc.cod-esp
               AND tit_ap.cod_ser_docto   = vpc.serie
               AND tit_ap.cod_tit_ap      = vpc.nro-docto
               AND tit_ap.cod_parcela     = "01" NO-ERROR.
        IF AVAIL tit_ap THEN ASSIGN p-recid = RECID(tit_ap).
    END.
END PROCEDURE.

PROCEDURE pi-retorna-unidade:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-unid-negoc.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.

    FOR EACH unid_negoc:
        CREATE tt-unid-negoc.
        ASSIGN tt-unid-negoc.cod-unid-negoc = unid_negoc.cod_unid_negoc
               tt-unid-negoc.descricao      = unid_negoc.des_unid_negoc.
    END.

END PROCEDURE.

PROCEDURE pi-retorna-cc:
    DEFINE  INPUT PARAMETER p-cod-ccusto AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-descricao  AS CHARACTER NO-UNDO.

    FIND FIRST emscad.ccusto NO-LOCK
         WHERE ccusto.cod_ccusto = p-cod-ccusto NO-ERROR.
    IF NOT AVAIL ccusto THEN
        RETURN "NOK".
    ELSE
        ASSIGN p-descricao = ccusto.des_tit_ctbl.

    RETURN "OK".
END PROCEDURE.

