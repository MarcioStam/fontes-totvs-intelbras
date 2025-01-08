{esp/cms/apb900zd.i}
{esp/cms/apb767zc.i}
{esp/es0018.i}

DEFINE NEW SHARED TEMP-TABLE tt_vl_sdo_un_origem NO-UNDO
    FIELD ttv_cod_unid_negoc_orig AS CHARACTER FORMAT "x(3)":U                       LABEL "Unid Negoc":U        COLUMN-LABEL "Unid Negoc":U
    FIELD ttv_val_sdo_unid_negoc  AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U DECIMALS 2 LABEL "Saldo UN":U          COLUMN-LABEL "Saldo UN":U
    FIELD ttv_val_tot_transfdo    AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U DECIMALS 2 LABEL "Total Transferido":U COLUMN-LABEL "Total Transferido":U.

DEFINE NEW SHARED TEMP-TABLE tt_vl_transfdo_un NO-UNDO
    FIELD ttv_cod_unid_negoc_orig AS CHARACTER FORMAT "x(3)":U                        LABEL "Unid Negoc":U        COLUMN-LABEL "Unid Negoc":U
    FIELD ttv_cod_unid_negoc_dest AS CHARACTER FORMAT "x(3)":U                        LABEL "UN Destino":U        COLUMN-LABEL "UN Destino":U
    FIELD ttv_val_transfdo        AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U DECIMALS 2  LABEL "Valor Transferido":U COLUMN-LABEL "Valor Transferido":U
    FIELD ttv_val_perc_transf     AS DECIMAL   FORMAT ">>9.9999999999":U  DECIMALS 10
    INDEX tt_un_orig_dest IS PRIMARY UNIQUE
        ttv_cod_unid_negoc_orig ASCENDING
        ttv_cod_unid_negoc_dest ASCENDING.

DEFINE TEMP-TABLE tt_imp NO-UNDO
    FIELD cod_estab             LIKE tit_ap.cod_estab
    FIELD cdn_fornecedor        LIKE emscad.fornecedor.cdn_fornecedor
    FIELD nom_abrev             LIKE emscad.fornecedor.nom_abrev
    FIELD cdn_repres            LIKE representante.cdn_repres
    FIELD nom_abrev_r           LIKE representante.nom_abrev
    FIELD cod_ser_docto         LIKE tit_ap.cod_ser_docto                 FORMAT "x(3)":U          COLUMN-LABEL "Sr":U
    FIELD cod_espec_docto       LIKE tit_ap.cod_espec_docto
    FIELD cod_tit_ap            LIKE tit_ap.cod_tit_ap                    FORMAT "x(10)":U         COLUMN-LABEL "Docto":U
    FIELD num_id_tit_ap         LIKE tit_ap.num_id_tit_ap
    FIELD cod_parcela           AS CHARACTER                              FORMAT "x(5)":U          COLUMN-LABEL "Parc":U
    FIELD dat_vencto_tit_ap     LIKE tit_ap.dat_vencto_tit_ap             FORMAT "99/99/9999":U    COLUMN-LABEL "Dt Vcto":U
    FIELD dat_liquidac_tit_ap   LIKE tit_ap.dat_liquidac_tit_ap           FORMAT "99/99/9999":U    COLUMN-LABEL "Dt Baixa":U
    FIELD dat_pedido            AS DATE                                   FORMAT "99/99/9999":U    COLUMN-LABEL "Dt Pedido":U
    FIELD cdn_cliente           LIKE emscad.cliente.cdn_cliente                                      COLUMN-LABEL "Cliente":U
    FIELD nom_abrev_c           LIKE emscad.cliente.nom_abrev
    FIELD nom_cidade_c          LIKE pessoa_fisic.nom_cidade
    FIELD cod_unid_federac_c    LIKE pessoa_fisic.cod_unid_federac
    FIELD val_origin_tit_ap     LIKE tit_ap.val_origin_tit_ap             FORMAT ">>,>>>,>>9.99":U
    FIELD val_sdo_tit_ap        LIKE tit_ap.val_sdo_tit_ap                FORMAT ">>,>>>,>>9.99":U COLUMN-LABEL "Valor s/IR":U
    FIELD val_perc_comis_repres LIKE repres_tit_acr.val_perc_comis_repres FORMAT ">>9.99":U
    FIELD val_base              AS DECIMAL                                FORMAT ">>,>>>,>>9.99":U COLUMN-LABEL "Valor Base":U
    FIELD  cod_e_mail           LIKE pessoa_fisic.cod_e_mail
    INDEX tt-imprime IS PRIMARY
        cdn_fornecedor
        cod_espec_docto
        cod_ser_docto
        cod_tit_ap
        cod_parcela.

DEFINE TEMP-TABLE tt-comis-deb-cred NO-UNDO LIKE comis-deb-cred
    FIELD descricao   LIKE mov-comis.descricao
    FIELD selecao     AS CHARACTER FORMAT "x(1)":U LABEL "":U COLUMN-LABEL "Seleá∆o":U.

DEFINE TEMP-TABLE tt_antecip NO-UNDO
    FIELD tta_cod_estab           AS CHARACTER FORMAT "x(3)":U                                 LABEL "Estabelecimento":U   COLUMN-LABEL "Estab":U
    FIELD tta_cod_espec_docto     AS CHARACTER FORMAT "x(3)":U                                 LABEL "EspÇcie Documento":U COLUMN-LABEL "EspÇcie":U
    FIELD tta_cod_ser_docto       AS CHARACTER FORMAT "x(3)":U                                 LABEL "SÇrie Documento":U   COLUMN-LABEL "SÇrie":U
    FIELD tta_cdn_fornecedor      AS INTEGER   FORMAT ">>>,>>>,>>9":U                INITIAL 0 LABEL "Fornecedor":U        COLUMN-LABEL "Fornecedor":U
    FIELD tta_cod_tit_ap          AS CHARACTER FORMAT "x(10)":U                                LABEL "T°tulo":U            COLUMN-LABEL "T°tulo":U
    FIELD tta_cod_parcela         AS CHARACTER FORMAT "x(02)":U                                LABEL "Parcela":U           COLUMN-LABEL "Parc":U
    FIELD tta_dat_transacao       AS DATE      FORMAT "99/99/9999":U                           LABEL "Dt Transaá∆o":U      COLUMN-LABEL "Dt Transaá∆o":U
    FIELD tta_val_abat_tit_ap     AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U DECIMALS 2 INITIAL 0 LABEL "Valor Abatimento":U  COLUMN-LABEL "Vl Abatimento":U
    FIELD tta_val_tit_ap          AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U DECIMALS 2 INITIAL 0 LABEL "Valor T°tulo":U      COLUMN-LABEL "Vl T°tulo":U
    FIELD tta_selecao             AS CHARACTER FORMAT "x(1)":U                                 LABEL "":U                  COLUMN-LABEL "Seleá∆o":U.

DEFINE TEMP-TABLE tt_log_erro_atualiz_rpc NO-UNDO 
    FIELD tta_cod_estab       AS CHARACTER FORMAT "x(3)":U               LABEL "Estabelecimento":U     COLUMN-LABEL "Estab":U
    FIELD tta_cod_refer       AS CHARACTER FORMAT "x(10)":U              LABEL "Referància":U          COLUMN-LABEL "Referància":U
    FIELD tta_num_seq_refer   AS INTEGER   FORMAT ">>>9":U     INITIAL 0 LABEL "Sequància":U           COLUMN-LABEL "Seq":U
    FIELD ttv_num_mensagem    AS INTEGER   FORMAT ">>>>,>>9":U           LABEL "N£mero":U              COLUMN-LABEL "N£mero Mensagem":U
    FIELD ttv_des_msg_erro    AS CHARACTER FORMAT "x(60)":U              LABEL "Mensagem Erro":U       COLUMN-LABEL "Inconsistància":U
    FIELD ttv_des_msg_ajuda   AS CHARACTER FORMAT "x(40)":U              LABEL "Mensagem Ajuda":U      COLUMN-LABEL "Mensagem Ajuda":U
    FIELD ttv_ind_tip_relacto AS CHARACTER FORMAT "X(15)":U              LABEL "Tipo Relacionamento":U COLUMN-LABEL "Tipo Relac":U
    FIELD ttv_num_relacto     AS INTEGER   FORMAT ">>>>,>>9":U           LABEL "Relacionamento":U      COLUMN-LABEL "Relacionamento":U.

DEFINE VARIABLE v_ct_codigo           LIKE conta-programa.ct-codigo NO-UNDO.
DEFINE VARIABLE v_ct_codigo_ava_maior LIKE conta-programa.ct-codigo NO-UNDO.
DEFINE VARIABLE v_sc_codigo_ava_maior LIKE conta-programa.sc-codigo NO-UNDO.
DEFINE VARIABLE v_ct_codigo_ava_menor LIKE conta-programa.ct-codigo NO-UNDO.
DEFINE VARIABLE v_sc_codigo_ava_menor LIKE conta-programa.sc-codigo NO-UNDO.
DEFINE VARIABLE v_sdo_tit_ap_aux      LIKE tit_ap.val_sdo_tit_ap    NO-UNDO.
DEFINE VARIABLE v_num_seq_alt         AS INTEGER                    NO-UNDO INITIAL 0.
DEFINE VARIABLE v_cod_refer_alt       LIKE tit_ap.cod_refer    NO-UNDO.
DEFINE VARIABLE v_log_erro            AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE v_arquivo             AS CHARACTER                  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar            AS CHARACTER   NO-UNDO FORMAT "x(3)":U  LABEL "Empresa":U              COLUMN-LABEL "Empresa":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_grp_usuar_lst           AS CHARACTER   NO-UNDO FORMAT "x(3)":U  LABEL "Grupo Usu†rios":U       COLUMN-LABEL "Grupo":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_idiom_usuar             AS CHARACTER   NO-UNDO FORMAT "x(8)":U  LABEL "Idioma":U               COLUMN-LABEL "Idioma":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_pais_empres_usuar       AS CHARACTER   NO-UNDO FORMAT "x(3)":U  LABEL "Pa°s Empresa Usu†rio":U COLUMN-LABEL "Pa°s":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren            AS CHARACTER   NO-UNDO FORMAT "x(12)":U LABEL "Usu†rio Corrente":U     COLUMN-LABEL "Usu†rio Corrente":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren_criptog    AS CHARACTER   NO-UNDO FORMAT "x(16)":U.
DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

DEFINE INPUT  PARAMETER TABLE FOR tt_imp.
DEFINE INPUT  PARAMETER TABLE FOR tt-comis-deb-cred.
DEFINE INPUT  PARAMETER TABLE FOR tt_antecip.
DEFINE INPUT  PARAMETER p_cod_refer                LIKE movto_tit_ap.cod_refer                NO-UNDO.
DEFINE INPUT  PARAMETER p_data_bxa                 LIKE movto_tit_ap.dat_trans                NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_estab_usuar          AS CHARACTER                               NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_empres_usuar         LIKE movto_tit_ap.cod_empresa              NO-UNDO.
DEFINE INPUT  PARAMETER p_cdn_fornec               LIKE tit_ap.cdn_fornec                     NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_espec_docto          LIKE tit_ap.cod_espec_docto                NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_ser_docto            LIKE tit_ap.cod_ser_docto                  NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_tit_ap               LIKE tit_ap.cod_tit_ap                     NO-UNDO.      
DEFINE INPUT  PARAMETER p_cod_parcela              LIKE tit_ap.cod_parcela                    NO-UNDO.     
DEFINE INPUT  PARAMETER p_dat_vencto               LIKE tit_ap.dat_vencto_tit_ap              NO-UNDO.
DEFINE INPUT  PARAMETER p_val_desc                 LIKE tit_ap.val_desconto                   NO-UNDO.
DEFINE INPUT  PARAMETER p_des_histor               LIKE histor_movto_tit_acr.des_text_histor  NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_tip_fluxo_financ     LIKE tip_fluxo_financ.cod_tip_fluxo_financ NO-UNDO.
DEFINE INPUT  PARAMETER p_vl_bruto_comis           AS DECIMAL                                 NO-UNDO.
DEFINE INPUT  PARAMETER p_val_ir                   AS DECIMAL                                 NO-UNDO.
DEFINE INPUT  PARAMETER p_dat_vencto_ir            LIKE tit_ap.dat_vencto_tit_ap              NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_usuar                LIKE v_cod_usuar_corren                    NO-UNDO.
DEFINE INPUT  PARAMETER p_cod_grp_usuar_lst        LIKE v_cod_grp_usuar_lst                   NO-UNDO.     
DEFINE INPUT  PARAMETER p_cod_idiom_usuar          LIKE v_cod_idiom_usuar                     NO-UNDO.       
DEFINE INPUT  PARAMETER p_cod_pais_empres_usuar    LIKE v_cod_pais_empres_usuar               NO-UNDO. 
DEFINE INPUT  PARAMETER p_cod_usuar_corren_criptog LIKE v_cod_usuar_corren_criptog            NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro_atualiz_rpc.
DEFINE OUTPUT PARAMETER p_erro_pi_impl             AS LOGICAL                                 NO-UNDO.
DEFINE OUTPUT PARAMETER p_erro_pi_alt              AS LOGICAL                                 NO-UNDO.


ASSIGN v_cod_usuar_corren            = p_cod_usuar
       v_cod_empres_usuar            = p_cod_empres_usuar      
       v_cod_grp_usuar_lst           = p_cod_grp_usuar_lst  
       v_cod_idiom_usuar             = p_cod_idiom_usuar      
       v_cod_pais_empres_usuar       = p_cod_pais_empres_usuar 
       v_cod_usuar_corren_criptog    = p_cod_usuar_corren_criptog
       v_des_contdo_prog_valid_dtsul = "esapb007e-2":U.

RUN pi_elimina_tt.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN v_arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(v_arquivo, LENGTH(v_arquivo), 1) <> "/":U THEN
    ASSIGN v_arquivo = v_arquivo + "/":U.

ASSIGN v_arquivo = v_arquivo + "erro_rpc.log":U.

OUTPUT TO VALUE(v_arquivo).

PUT SKIP
    PROPATH FORMAT "x(150)":U SKIP
    "MGESP CONENECTED":U CONNECTED("mgesp":U) SKIP.

PUT SKIP
    OPSYS                                                       SKIP
    " v_cod_usuar_corren         ":U v_cod_usuar_corren         SKIP
    " v_cod_empres_usuar         ":U v_cod_empres_usuar         SKIP
    " v_cod_estab_usuar          ":U p_cod_estab_usuar          SKIP
    " v_cod_grp_usuar_lst        ":U v_cod_grp_usuar_lst        SKIP
    " v_cod_idiom_usuar          ":U v_cod_idiom_usuar          SKIP
    " v_cod_pais_empres_usuar    ":U v_cod_pais_empres_usuar    SKIP
    " v_cod_usuar_corren_criptog ":U v_cod_usuar_corren_criptog SKIP.

bloco-principal:
DO TRANSACTION ON ERROR UNDO bloco-principal, LEAVE bloco-principal:
    FIND FIRST conta-programa
        WHERE conta-programa.programa = "esapb007a":U
          AND conta-programa.indice   = 1 NO-LOCK NO-ERROR.

    IF AVAILABLE conta-programa THEN
        ASSIGN v_ct_codigo = conta-programa.ct-codigo.

    FIND FIRST plano_ccusto   NO-LOCK NO-ERROR.
    FIND FIRST plano_cta_ctbl NO-LOCK NO-ERROR.

    CREATE tt_integr_apb_lote_impl.
    ASSIGN tt_integr_apb_lote_impl.tta_cod_refer                = p_cod_refer
           tt_integr_apb_lote_impl.tta_dat_transacao            = p_data_bxa
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        = "APB":U
           tt_integr_apb_lote_impl.tta_cod_estab_ext            = p_cod_estab_usuar
           tt_integr_apb_lote_impl.tta_val_tot_lote_impl_tit_ap = 0
           tt_integr_apb_lote_impl.ttv_cod_empresa_ext          = p_cod_empres_usuar
           tt_integr_apb_lote_impl.tta_cod_indic_econ           = "Real":U.

    CREATE tt_integr_apb_item_lote_impl_2.
    ASSIGN tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_lote_impl  =  RECID(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote  =  RECID(tt_integr_apb_item_lote_impl_2)
           tt_integr_apb_item_lote_impl_2.tta_num_seq_refer             =  1                                        /* Referencia         */
           tt_integr_apb_item_lote_impl_2.tta_cdn_fornecedor            =  p_cdn_fornec                             /* Fornecedor         */
           tt_integr_apb_item_lote_impl_2.tta_cod_espec_docto           =  p_cod_espec_docto                        /* EspÇcie            */
           tt_integr_apb_item_lote_impl_2.tta_cod_ser_docto             =  p_cod_ser_docto                          /* SÇrie              */
           tt_integr_apb_item_lote_impl_2.tta_cod_tit_ap                =  p_cod_tit_ap                             /* T°tulo parcela     */
           tt_integr_apb_item_lote_impl_2.tta_cod_parcela               =  p_cod_parcela                            /* Parc               */
           tt_integr_apb_item_lote_impl_2.tta_dat_emis_docto            =  p_data_bxa                               /* Dt Emiss∆o         */
           tt_integr_apb_item_lote_impl_2.tta_dat_vencto_tit_ap         =  p_dat_vencto                             /* Dt Vencto          */
           tt_integr_apb_item_lote_impl_2.tta_dat_prev_pagto            =  p_dat_vencto                             /* Dt Prev Pagto      */
           tt_integr_apb_item_lote_impl_2.tta_dat_desconto              =  ?                                        /* Dt Descto          */
           tt_integr_apb_item_lote_impl_2.tta_cod_indic_econ            =  "Real":U                                 /* Moeda              */ 
           tt_integr_apb_item_lote_impl_2.tta_val_tit_ap                =  p_vl_bruto_comis                         /* Valor T°tulo       */
           tt_integr_apb_item_lote_impl_2.tta_val_desconto              =  p_val_desc                               /* Valor Desconto     */
           tt_integr_apb_item_lote_impl_2.tta_num_dias_atraso           =  0                                        /* Dias Atr           */
           tt_integr_apb_item_lote_impl_2.tta_val_juros_dia_atraso      =  0                                        /* Vl Juro            */
           tt_integr_apb_item_lote_impl_2.tta_val_perc_juros_dia_atraso =  0                                        /* Perc Dia           */
           tt_integr_apb_item_lote_impl_2.tta_val_perc_multa_atraso     =  0                                        /* Multa Atr          */
           tt_integr_apb_item_lote_impl_2.tta_cod_portad_ext            =  "999":U                                  /* Portador Externo   */               
           tt_integr_apb_item_lote_impl_2.tta_cod_modalid_ext           =  "0":U                                    /* Modalidade Externa */
           tt_integr_apb_item_lote_impl_2.tta_des_text_histor           =  p_des_histor + "                                             ":U + OPSYS.

    CREATE tt_integr_apb_aprop_ctbl_pend.
    ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = RECID(tt_integr_apb_item_lote_impl_2)
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = IF AVAILABLE plano_cta_ctbl THEN plano_cta_ctbl.cod_plano_cta_ctbl ELSE "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = v_ct_codigo
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               = "ADM":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             = "":U /* em Mario F. Fleith - IF AVAILABLE plano_ccusto THEN plano_ccusto.cod_plano_ccusto ELSE "":U */
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         = p_cod_tip_fluxo_financ
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               = p_vl_bruto_comis
           tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            = "":U
           tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext     = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext             = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext         = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext               = "":U
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc_ext           = "":U.

    IF p_val_ir >= 10 THEN DO:
        FIND FIRST fornec_financ
            WHERE fornec_financ.cod_empresa    = p_cod_empres_usuar
              AND fornec_financ.cdn_fornecedor = p_cdn_fornec NO-LOCK NO-ERROR.

        IF AVAILABLE fornec_financ THEN DO:
            FIND FIRST impto_vincul_fornec
                WHERE impto_vincul_fornec.cod_empresa       = fornec_financ.cod_empresa
                  AND impto_vincul_fornec.cdn_fornecedor    = fornec_financ.cdn_fornecedor
                  AND impto_vincul_fornec.cod_classif_impto = "8045":U NO-LOCK NO-ERROR.

            IF AVAILABLE impto_vincul_fornec THEN DO:
                FIND FIRST imposto
                    WHERE imposto.cod_pais         = impto_vincul_fornec.cod_pais
                      AND imposto.cod_unid_federac = impto_vincul_fornec.cod_unid_federac
                      AND imposto.cod_imposto      = impto_vincul_fornec.cod_imposto NO-LOCK NO-ERROR.

                IF AVAILABLE imposto THEN DO:
                    FIND FIRST classif_impto
                        WHERE classif_impto.cod_pais         = imposto.cod_pais
                          AND classif_impto.cod_unid_federac = imposto.cod_unid_federac
                          AND classif_impto.cod_imposto      = imposto.cod_imposto NO-LOCK NO-ERROR.

                    IF AVAILABLE classif_impto THEN DO:
                        FIND FIRST impto_vincul_empres
                            WHERE impto_vincul_empres.cod_pais         = imposto.cod_pais
                              AND impto_vincul_empres.cod_unid_federac = imposto.cod_unid_federac
                              AND impto_vincul_empres.cod_imposto      = imposto.cod_imposto
                              AND impto_vincul_empres.cod_empresa      = impto_vincul_fornec.cod_empresa NO-LOCK NO-ERROR.

                        IF AVAILABLE impto_vincul_empres THEN DO:
                            FIND FIRST histor_impto_empres
                                WHERE histor_impto_empres.cod_pais         = impto_vincul_empres.cod_pais
                                  AND histor_impto_empres.cod_unid_federac = impto_vincul_empres.cod_unid_federac
                                  AND histor_impto_empres.cod_imposto      = impto_vincul_empres.cod_imposto
                                  AND histor_impto_empres.cod_empresa      = impto_vincul_empres.cod_empresa NO-LOCK NO-ERROR.

                            IF AVAILABLE histor_impto_empres THEN DO:
                                CREATE tt_integr_apb_impto_impl_pend.
                                ASSIGN tt_integr_apb_impto_impl_pend.ttv_rec_integr_apb_item_lote   = tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote
                                       tt_integr_apb_impto_impl_pend.ttv_rec_antecip_pef_pend       = ?
                                       tt_integr_apb_impto_impl_pend.tta_cod_pais                   = impto_vincul_fornec.cod_pais
                                       tt_integr_apb_impto_impl_pend.tta_cod_unid_federac           = impto_vincul_fornec.cod_unid_federac
                                       tt_integr_apb_impto_impl_pend.tta_cod_imposto                = impto_vincul_fornec.cod_imposto
                                       tt_integr_apb_impto_impl_pend.tta_cod_classif_impto          = impto_vincul_fornec.cod_classif_impto
                                       tt_integr_apb_impto_impl_pend.tta_cod_espec_docto            = imposto.cod_espec_docto_impto
                                       tt_integr_apb_impto_impl_pend.tta_cod_ser_docto              = imposto.cod_ser_docto_impto
                                       tt_integr_apb_impto_impl_pend.tta_cod_tit_ap                 = p_cod_tit_ap
                                       tt_integr_apb_impto_impl_pend.tta_cod_parcela                = p_cod_parcela
                                       tt_integr_apb_impto_impl_pend.tta_ind_clas_impto             = imposto.ind_clas_impto
                                       tt_integr_apb_impto_impl_pend.tta_cod_plano_cta_ctbl         = histor_impto_empres.cod_plano_cta_ctbl
                                       tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl               = v_ct_codigo
                                       tt_integr_apb_impto_impl_pend.tta_val_rendto_tribut          = p_vl_bruto_comis
                                       tt_integr_apb_impto_impl_pend.tta_val_deduc_inss             = 0
                                       tt_integr_apb_impto_impl_pend.tta_val_deduc_depend           = 0
                                       tt_integr_apb_impto_impl_pend.tta_val_deduc_pensao           = 0
                                       tt_integr_apb_impto_impl_pend.tta_val_outras_deduc_impto     = 0
                                       tt_integr_apb_impto_impl_pend.tta_val_base_liq_impto         = p_vl_bruto_comis
                                       tt_integr_apb_impto_impl_pend.tta_val_aliq_impto             = classif_impto.val_aliq_impto
                                       tt_integr_apb_impto_impl_pend.tta_val_impto_ja_recolhid      = 0
                                       tt_integr_apb_impto_impl_pend.tta_val_imposto                = p_val_ir
                                       tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap          = p_dat_vencto_ir
                                       tt_integr_apb_impto_impl_pend.tta_cod_indic_econ             = histor_impto_empres.cod_finalid_econ
                                       tt_integr_apb_impto_impl_pend.tta_val_impto_indic_econ_impto = 0
                                       tt_integr_apb_impto_impl_pend.tta_des_text_histor            = "":U
                                       tt_integr_apb_impto_impl_pend.tta_cdn_fornec_favorec         = histor_impto_empres.cdn_fornec_favorec
                                       tt_integr_apb_impto_impl_pend.tta_val_deduc_faixa_impto      = 0
                                       tt_integr_apb_impto_impl_pend.tta_num_id_tit_ap              = ?
                                       tt_integr_apb_impto_impl_pend.tta_num_id_movto_tit_ap        = ?
                                       tt_integr_apb_impto_impl_pend.tta_num_id_movto_cta_corren    = ?
                                       tt_integr_apb_impto_impl_pend.tta_cod_pais_ext               = "":U
                                       tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl_ext           = "":U
                                       tt_integr_apb_impto_impl_pend.tta_cod_sub_cta_ctbl_ext       = "":U
                                       tt_integr_apb_impto_impl_pend.ttv_cod_tip_fluxo_financ_ext   = "":U.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    FOR EACH tt_imp NO-LOCK
        WHERE tt_imp.val_sdo_tit_ap > 0:
        FIND FIRST tit_ap
            WHERE tit_ap.cod_estab     = tt_imp.cod_estab
              AND tit_ap.num_id_tit_ap = tt_imp.num_id_tit_ap NO-LOCK NO-ERROR.

        IF AVAILABLE tit_ap          AND
           tit_ap.val_sdo_tit_ap > 0 THEN DO: /* Mario Fleith - Defido Erro Datasul 6410 */
            CREATE tt_integr_apb_abat_prev_provis.
            ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote
                   tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     = ? 
                   tt_integr_apb_abat_prev_provis.tta_cod_estab                = tit_ap.cod_estab
                   tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          = "CPO":U
                   tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            = tit_ap.cod_ser_docto 
                   tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           = tit_ap.cdn_fornecedor
                   tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               = tit_ap.cod_tit_ap    
                   tt_integr_apb_abat_prev_provis.tta_cod_parcela              = tit_ap.cod_parcela
                   tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap          = tit_ap.val_sdo_tit_ap.
        END.
    END. /* FOR EACH tt_imp NO-LOCK */

/*     /* Antecipaá∆o */                                                                                                                     */
/*     FOR EACH tt_antecip NO-LOCK                                                                                                           */
/*         WHERE tt_antecip.tta_selecao         = "*":U                                                                                      */
/*           AND tt_antecip.tta_val_abat_tit_ap > 0:                                                                                         */
/*         CREATE tt_integr_apb_abat_antecip_vouc.                                                                                           */
/*         ASSIGN tt_integr_apb_abat_antecip_vouc.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote */
/*                tt_integr_apb_abat_antecip_vouc.tta_cod_estab                = tt_antecip.tta_cod_estab                                    */
/*                tt_integr_apb_abat_antecip_vouc.tta_cod_espec_docto          = tt_antecip.tta_cod_espec_docto                              */
/*                tt_integr_apb_abat_antecip_vouc.tta_cod_ser_docto            = tt_antecip.tta_cod_ser_docto                                */
/*                tt_integr_apb_abat_antecip_vouc.tta_cdn_fornecedor           = tt_antecip.tta_cdn_fornecedor                               */
/*                tt_integr_apb_abat_antecip_vouc.tta_cod_tit_ap               = tt_antecip.tta_cod_tit_ap                                   */
/*                tt_integr_apb_abat_antecip_vouc.tta_cod_parcela              = tt_antecip.tta_cod_parcela                                  */
/*                tt_integr_apb_abat_antecip_vouc.tta_val_abat_tit_ap          = tt_antecip.tta_val_abat_tit_ap.                             */
/*     END.                                                                                                                                  */

    /* implantaá∆o de t°tulo */
    FIND FIRST tt_integr_apb_lote_impl NO-LOCK NO-ERROR.

    FOR EACH tt_log_erro_atualiz_rpc EXCLUSIVE-LOCK:
        DELETE tt_log_erro_atualiz_rpc.
    END.
    
    IF AVAILABLE tt_integr_apb_lote_impl THEN DO:
        PUT SKIP
            TRANSACTION
            SKIP
            "MGESP CONENECTED ":U CONNECTED("mgesp":U) SKIP.

        FIND FIRST tt_integr_apb_item_lote_impl_2
            WHERE tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl) NO-LOCK NO-ERROR.

        FIND FIRST tt_integr_apb_aprop_ctbl_pend
            WHERE tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_2) NO-LOCK NO-ERROR.

        FIND FIRST tt_integr_apb_abat_prev_provis
            WHERE tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote NO-LOCK NO-ERROR.

        FIND FIRST  tt_integr_apb_abat_antecip_vouc
            WHERE tt_integr_apb_abat_antecip_vouc.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote NO-LOCK NO-ERROR.

        PUT " Antes chamada api (apb900zd.py) ":U STRING(TIME, "hh:mm:ss":U) SKIP.

        RUN prgfin/apb/apb900zd.py (INPUT 3,
                                    INPUT "EMS":U,
                                    INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_2).

        PUT " Depois chamada api (apb900zd.py) ":U STRING(TIME, "hh:mm:ss":U) SKIP.

        FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.

        IF AVAILABLE tt_log_erros_atualiz THEN DO:
            ASSIGN p_erro_pi_impl = YES.

            FOR EACH tt_log_erros_atualiz:
                CREATE tt_log_erro_atualiz_rpc.
                ASSIGN tt_log_erro_atualiz_rpc.tta_cod_estab       = tt_log_erros_atualiz.tta_cod_estab       
                       tt_log_erro_atualiz_rpc.tta_cod_refer       = tt_log_erros_atualiz.tta_cod_refer       
                       tt_log_erro_atualiz_rpc.tta_num_seq_refer   = tt_log_erros_atualiz.tta_num_seq_refer   
                       tt_log_erro_atualiz_rpc.ttv_num_mensagem    = tt_log_erros_atualiz.ttv_num_mensagem    
                       tt_log_erro_atualiz_rpc.ttv_des_msg_erro    = tt_log_erros_atualiz.ttv_des_msg_erro    
                       tt_log_erro_atualiz_rpc.ttv_des_msg_ajuda   = tt_log_erros_atualiz.ttv_des_msg_ajuda   
                       tt_log_erro_atualiz_rpc.ttv_ind_tip_relacto = tt_log_erros_atualiz.ttv_ind_tip_relacto 
                       tt_log_erro_atualiz_rpc.ttv_num_relacto     = tt_log_erros_atualiz.ttv_num_relacto.

                DELETE tt_log_erros_atualiz.
            END.
        END.
        ELSE
            RUN pi-alt-tit-apb.

        IF p_erro_pi_impl OR
           p_erro_pi_alt  THEN
            UNDO bloco-principal, LEAVE bloco-principal.

        RUN pi_elimina_tt.
    END.
END. /* bloco-principal:
        DO TRANSACTION ON ERROR UNDO bloco-principal, LEAVE bloco-principal: */

ASSIGN v_des_contdo_prog_valid_dtsul = "":U.

OUTPUT CLOSE.

RETURN "OK":U.


PROCEDURE pi_elimina_tt:
    FOR EACH tt_integr_apb_lote_impl:
        DELETE tt_integr_apb_lote_impl.
    END.
    
    FOR EACH tt_integr_apb_item_lote_impl_2:
        DELETE tt_integr_apb_item_lote_impl_2.
    END.
    
    FOR EACH tt_integr_apb_aprop_ctbl_pend:
        DELETE tt_integr_apb_aprop_ctbl_pend.
    END.
    
    FOR EACH tt_integr_apb_impto_impl_pend:
        DELETE tt_integr_apb_impto_impl_pend.
    END.
    
    FOR EACH tt_integr_apb_abat_prev_provis:
        DELETE tt_integr_apb_abat_prev_provis.
    END.
    
    FOR EACH tt_integr_apb_abat_antecip_vouc:
        DELETE tt_integr_apb_abat_antecip_vouc.
    END.
    FOR EACH tt_log_erros_atualiz:
        DELETE tt_log_erros_atualiz.
    END.

    RETURN "OK":U.

END.

PROCEDURE pi-alt-tit-apb:
    FOR EACH tt_tit_ap_alteracao_base_1:
        DELETE tt_tit_ap_alteracao_base_1.
    END.
    
    FOR EACH tt_tit_ap_alteracao_rateio:
        DELETE tt_tit_ap_alteracao_rateio.
    END.
    
    FIND FIRST tit_ap
        WHERE tit_ap.cod_estab       = p_cod_estab_usuar
          AND tit_ap.cdn_fornec      = p_cdn_fornec
          AND tit_ap.cod_espec_docto = p_cod_espec_docto
          AND tit_ap.cod_ser_docto   = p_cod_ser_docto
          AND tit_ap.cod_tit_ap      = p_cod_tit_ap
          AND tit_ap.cod_parcela     = p_cod_parcela NO-LOCK NO-ERROR.

    IF AVAILABLE tit_ap THEN DO:
        FIND FIRST plano_ccusto   NO-LOCK NO-ERROR.
        FIND FIRST plano_cta_ctbl NO-LOCK NO-ERROR.

        ASSIGN v_sdo_tit_ap_aux = tit_ap.val_sdo_tit_ap
               v_num_seq_alt    = 0.

        FOR EACH tt-comis-deb-cred NO-LOCK
            WHERE tt-comis-deb-cred.selecao    = "*":U
              AND tt-comis-deb-cred.base-final = NO:
            ASSIGN v_num_seq_alt = v_num_seq_alt + 1.

            RUN pi-referencia (INPUT  tt-comis-deb-cred.dt-movto,
                               INPUT  STRING(v_num_seq_alt, "999":U),
                               OUTPUT v_cod_refer_alt).

            /* ** Transfere o saldo para a UN do AVA ** */
            FIND val_tit_ap OF tit_ap
                WHERE val_tit_ap.val_sdo_tit_ap <> 0 NO-LOCK NO-ERROR.

            IF val_tit_ap.cod_unid_negoc <> tt-comis-deb-cred.unid-neg THEN DO:
                FOR EACH tt_vl_transfdo_un:
                    DELETE tt_vl_transfdo_un.
                END.

                FOR EACH tt_vl_sdo_un_origem:
                    DELETE tt_vl_sdo_un_origem.
                END.

                CREATE tt_vl_sdo_un_origem.
                ASSIGN tt_vl_sdo_un_origem.ttv_cod_unid_negoc_orig = val_tit_ap.cod_unid_negoc
                       tt_vl_sdo_un_origem.ttv_val_sdo_unid_negoc  = val_tit_ap.val_sdo_tit_ap
                       tt_vl_sdo_un_origem.ttv_val_tot_transfdo    = val_tit_ap.val_sdo_tit_ap.

                CREATE tt_vl_transfdo_un.
                ASSIGN tt_vl_transfdo_un.ttv_cod_unid_negoc_ori  = val_tit_ap.cod_unid_negoc
                       tt_vl_transfdo_un.ttv_cod_unid_negoc_dest = tt-comis-deb-cred.unid-neg
                       tt_vl_transfdo_un.ttv_val_transfdo        = val_tit_ap.val_sdo_tit_ap.

                RUN prgfin/apb/apb706zd.py (INPUT  RECID(tit_ap),
                                            INPUT  v_cod_refer_alt,
                                            INPUT  p_data_bxa,
                                            INPUT  "Corrente":U,
                                            OUTPUT v_log_erro,
                                            INPUT  "Alteraá∆o":U,
                                            INPUT  "Transferància":U).

                IF v_log_erro THEN DO:
                    ASSIGN p_erro_pi_alt = YES.

                    CREATE tt_log_erro_atualiz_rpc.
                    ASSIGN tt_log_erro_atualiz_rpc.tta_cod_estab       = tit_ap.cod_estab
                           tt_log_erro_atualiz_rpc.tta_cod_refer       = v_cod_refer_alt
                           tt_log_erro_atualiz_rpc.tta_num_seq_refer   = v_num_seq_alt
                           tt_log_erro_atualiz_rpc.ttv_num_mensagem    = 16
                           tt_log_erro_atualiz_rpc.ttv_des_msg_erro    = "Transferància de Valores n∆o Realizada !":U
                           tt_log_erro_atualiz_rpc.ttv_des_msg_ajuda   = "Problemas na Transferància de Valores entre Unidades de Neg¢cio.":U
                           tt_log_erro_atualiz_rpc.ttv_ind_tip_relacto = "":U
                           tt_log_erro_atualiz_rpc.ttv_num_relacto     =  0.
                END.
            END.

            /* ** Efetua AVA no titulo na UN da comis-deb-cred  ** */
            ASSIGN v_num_seq_alt = v_num_seq_alt + 1.

            RUN pi-referencia(INPUT  tt-comis-deb-cred.dt-movto,
                              INPUT  STRING(v_num_seq_alt, "999":U),
                              OUTPUT v_cod_refer_alt).

            IF tt-comis-deb-cred.deb-cred THEN
                ASSIGN v_sdo_tit_ap_aux = v_sdo_tit_ap_aux - tt-comis-deb-cred.valor.
            ELSE
                ASSIGN v_sdo_tit_ap_aux = v_sdo_tit_ap_aux + tt-comis-deb-cred.valor.
                
            /*Cria temp-table com as informaªÑes dos t≠tulos para alteraá∆o no APB. */
            CREATE tt_tit_ap_alteracao_base_1.
            ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
                   tt_tit_ap_alteracao_base_1.tta_cod_empresa                  = v_cod_empres_usuar
                   tt_tit_ap_alteracao_base_1.tta_cod_estab                    = p_cod_estab_usuar
                   tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
                   tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                   = RECID(tt_tit_ap_alteracao_base_1)
                   tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
                   tt_tit_ap_alteracao_base_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
                   tt_tit_ap_alteracao_base_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
                   tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
                   tt_tit_ap_alteracao_base_1.tta_cod_parcela                  = tit_ap.cod_parcela
                   tt_tit_ap_alteracao_base_1.ttv_dat_transacao                = p_data_bxa
                   tt_tit_ap_alteracao_base_1.ttv_cod_refer                    = v_cod_refer_alt
                   tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap               = v_sdo_tit_ap_aux
                   tt_tit_ap_alteracao_base_1.tta_dat_emis_docto               = ?
                   tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap            = ?
                   tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto               = ?
                   tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto                = ?
                   tt_tit_ap_alteracao_base_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso
                   tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso
                   tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso
                   tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso
                   tt_tit_ap_alteracao_base_1.tta_dat_desconto                 = ?
                   tt_tit_ap_alteracao_base_1.tta_val_perc_desc                = tit_ap.val_perc_desc
                   tt_tit_ap_alteracao_base_1.tta_val_desconto                 = tit_ap.val_desconto
                   tt_tit_ap_alteracao_base_1.tta_cod_portador                 = tit_ap.cod_portador
                   tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov             = "":U
                   tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo
                   tt_tit_ap_alteracao_base_1.tta_cod_seguradora               = tit_ap.cod_seguradora
                   tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro
                   tt_tit_ap_alteracao_base_1.tta_cod_arrendador               = tit_ap.cod_arrendador
                   tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas
                   tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto
                   tt_tit_ap_alteracao_base_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ
                   tt_tit_ap_alteracao_base_1.tta_num_seq_refer                = ?
                   tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap   = "Alteracao":U
                   tt_tit_ap_alteracao_base_1.ttv_wgh_lista                    = ?
                   tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores  = NO
                   tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor        = "":U
                   tt_tit_ap_alteracao_base_1.tta_cod_histor_padr              = "":U
                   tt_tit_ap_alteracao_base_1.tta_des_histor_padr              = tt-comis-deb-cred.historico + "                               ":U + OPSYS
                   tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
                   tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto
                   tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                = "":U.

            CREATE tt_tit_ap_alteracao_rateio.
            ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap           = RECID(tt_tit_ap_alteracao_base_1)
                   tt_tit_ap_alteracao_rateio.tta_cod_estab            = p_cod_estab_usuar
                   tt_tit_ap_alteracao_rateio.tta_cod_refer            = v_cod_refer_alt
                   tt_tit_ap_alteracao_rateio.tta_num_seq_refer        = v_num_seq_alt
                   tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ = "":U
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl   = IF AVAILABLE plano_cta_ctbl THEN plano_cta_ctbl.cod_plano_cta_ctbl ELSE "":U
                   tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl         = STRING(tt-comis-deb-cred.ct-codigo)
                   tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc       = "":U
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto     = IF tt-comis-deb-cred.sc-codigo = 0 THEN "":U ELSE plano_ccusto.cod_plano_ccusto
                   tt_tit_ap_alteracao_rateio.tta_cod_ccusto           = IF tt-comis-deb-cred.sc-codigo = 0 THEN "":U ELSE STRING(tt-comis-deb-cred.sc-codigo)
                   tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl       = tt-comis-deb-cred.valor
                   tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat          = "Valor":U
                   tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        = tit_ap.num_id_tit_ap.

            PUT " Antes chamada api (apb767zc.py) " STRING(TIME, "hh:mm:ss":U) SKIP.

            RUN prgfin/apb/apb767zc.py (INPUT 1,
                                        INPUT "APB":U,
                                        INPUT "":U,        /*cod_matriz_trad_org_ext*/
                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                        OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

            PUT " Depois chamada api (apb767zc.py) ":U STRING(TIME, "hh:mm:ss":U) SKIP.

            FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.

            IF AVAILABLE tt_log_erros_tit_ap_alteracao  THEN DO:
                ASSIGN p_erro_pi_alt = YES.

                FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK:
                    CREATE tt_log_erro_atualiz_rpc.
                    ASSIGN tt_log_erro_atualiz_rpc.tta_cod_estab       = tt_log_erros_tit_ap_alteracao.tta_cod_estab
                           tt_log_erro_atualiz_rpc.tta_cod_refer       = v_cod_refer_alt
                           tt_log_erro_atualiz_rpc.tta_num_seq_refer   = 1
                           tt_log_erro_atualiz_rpc.ttv_num_mensagem    = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                           tt_log_erro_atualiz_rpc.ttv_des_msg_erro    = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                           tt_log_erro_atualiz_rpc.ttv_des_msg_ajuda   = tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda_1
                           tt_log_erro_atualiz_rpc.ttv_ind_tip_relacto = "":U
                           tt_log_erro_atualiz_rpc.ttv_num_relacto     =  0.
                END.
            END.

            FOR EACH tt_tit_ap_alteracao_base_1 EXCLUSIVE-LOCK:
                DELETE tt_tit_ap_alteracao_base_1.                                                                  
            END.

            FOR EACH tt_tit_ap_alteracao_rateio EXCLUSIVE-LOCK:
                DELETE tt_tit_ap_alteracao_rateio.                                                                  
            END. /* teste moser performance */
        END. /*FOR EACH tt-comis-deb-cred NO-LOCK*/

        /* ** Retorna o saldo para a UN ADM ** */
        FIND val_tit_ap OF tit_ap
            WHERE val_tit_ap.val_sdo_tit_ap <> 0 NO-LOCK NO-ERROR.

        IF AVAILABLE val_tit_ap                 AND
           val_tit_ap.cod_unid_negoc <> "ADM":U THEN DO:
            FOR EACH tt_vl_transfdo_un:
                DELETE tt_vl_transfdo_un.
            END.

            FOR EACH tt_vl_sdo_un_origem:
                DELETE tt_vl_sdo_un_origem.
            END.

            CREATE tt_vl_sdo_un_origem.
            ASSIGN tt_vl_sdo_un_origem.ttv_cod_unid_negoc_orig = val_tit_ap.cod_unid_negoc
                   tt_vl_sdo_un_origem.ttv_val_sdo_unid_negoc  = val_tit_ap.val_sdo_tit_ap
                   tt_vl_sdo_un_origem.ttv_val_tot_transfdo    = val_tit_ap.val_sdo_tit_ap.

            CREATE tt_vl_transfdo_un.
            ASSIGN tt_vl_transfdo_un.ttv_cod_unid_negoc_ori  = val_tit_ap.cod_unid_negoc
                   tt_vl_transfdo_un.ttv_cod_unid_negoc_dest = "ADM":U
                   tt_vl_transfdo_un.ttv_val_transfdo        = val_tit_ap.val_sdo_tit_ap.

            RUN prgfin/apb/apb706zd.py (INPUT  RECID(tit_ap),
                                        INPUT  v_cod_refer_alt,
                                        INPUT  p_data_bxa,
                                        INPUT  "Corrente":U,
                                        OUTPUT v_log_erro,
                                        INPUT  "Alteraá∆o":U,
                                        INPUT  "Transferància":U).

            IF v_log_erro THEN DO:
                ASSIGN p_erro_pi_alt = YES.

                CREATE tt_log_erro_atualiz_rpc.
                ASSIGN tt_log_erro_atualiz_rpc.tta_cod_estab       = tit_ap.cod_estab
                       tt_log_erro_atualiz_rpc.tta_cod_refer       = v_cod_refer_alt
                       tt_log_erro_atualiz_rpc.tta_num_seq_refer   = v_num_seq_alt
                       tt_log_erro_atualiz_rpc.ttv_num_mensagem    = 16
                       tt_log_erro_atualiz_rpc.ttv_des_msg_erro    = "Transferància de Valores n∆o Realizada !":U
                       tt_log_erro_atualiz_rpc.ttv_des_msg_ajuda   = "Problemas na Transferància de Valores entre Unidades de Neg¢cio.":U
                       tt_log_erro_atualiz_rpc.ttv_ind_tip_relacto = "":U
                       tt_log_erro_atualiz_rpc.ttv_num_relacto     = 0.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-referencia:
    DEFINE INPUT  PARAMETER p_data      AS DATE        NO-UNDO.
    DEFINE INPUT  PARAMETER p_tipo      AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p_cod_refer AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v_data_aux   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_aux    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_aux_2  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_cont   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_log_repeat AS LOGICAL     NO-UNDO INITIAL YES.

    REPEAT WHILE v_log_repeat:
        ASSIGN v_data_aux  = STRING(p_data, "999999":U)
               p_cod_refer = SUBSTRING(v_data_aux, 7, 2) + SUBSTRING(v_data_aux, 3, 2) + SUBSTRING(v_data_aux, 1, 2) + SUBSTRING(p_tipo,1,3)
               v_num_aux_2 = INTEGER(THIS-PROCEDURE:HANDLE).

        DO v_num_cont = 1 TO 3:
            ASSIGN v_num_aux   = (RANDOM(0, v_num_aux_2) MODULO 26) + 97
                   p_cod_refer = p_cod_refer + CHR(v_num_aux).
        END.

        FIND FIRST movto_tit_ap
            WHERE movto_tit_ap.cod_estab = p_cod_estab_usuar
              AND movto_tit_ap.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        FIND FIRST tt_tit_ap_alteracao_base_1
            WHERE tt_tit_ap_alteracao_base_1.ttv_cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        IF NOT AVAILABLE movto_tit_ap               AND
           NOT AVAILABLE tt_tit_ap_alteracao_base_1 THEN DO:
            ASSIGN v_log_repeat = NO.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE. /*PROCEDURE pi-referencia :*/

