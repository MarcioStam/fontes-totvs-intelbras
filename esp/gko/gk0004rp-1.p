/*------------------------------------------------------------------------
    File        : GK0004RP-1.P
    Purpose     : Gerar contabilizaá∆o do GKO no EMS 5.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* New Shared Temp-Table Definitions ---                                */

DEFINE NEW SHARED TEMP-TABLE tt_integr_lote_ctbl_1 NO-UNDO
    FIELD tta_cod_modul_dtsul        AS CHARACTER FORMAT "x(3)":U                        LABEL "M¢dulo":U             COLUMN-LABEL "M¢dulo":U
    FIELD tta_num_lote_ctbl          AS INTEGER   FORMAT ">>>,>>>,>>9":U INITIAL 1       LABEL "Lote Cont†bil":U      COLUMN-LABEL "Lote Cont†bil":U
    FIELD tta_des_lote_ctbl          AS CHARACTER FORMAT "x(40)":U                       LABEL "Descriá∆o Lote":U     COLUMN-LABEL "Descriá∆o Lote":U
    FIELD tta_cod_empresa            AS CHARACTER FORMAT "x(3)":U                        LABEL "Empresa":U            COLUMN-LABEL "Empresa":U
    FIELD tta_dat_lote_ctbl          AS DATE      FORMAT "99/99/9999":U  INITIAL TODAY   LABEL "Data Lote Cont†bil":U COLUMN-LABEL "Data Lote Cont†bil":U
    FIELD ttv_ind_erro_valid         AS CHARACTER FORMAT "x(8)":U        INITIAL "N∆o":U
    FIELD tta_log_integr_ctbl_online AS LOGICAL   FORMAT "Sim/N∆o":U     INITIAL NO      LABEL "Integraá∆o Online":U  COLUMN-LABEL "Integr Online":U
    FIELD ttv_rec_integr_lote_ctbl   AS RECID     FORMAT ">>>>>>9":U
    INDEX tt_recid
        ttv_rec_integr_lote_ctbl ASCENDING.

DEFINE NEW SHARED TEMP-TABLE tt_integr_lancto_ctbl_1 NO-UNDO
    FIELD tta_cod_cenar_ctbl           AS CHARACTER FORMAT "x(8)":U                       LABEL "Cen†rio Cont†bil":U     COLUMN-LABEL "Cen†rio Cont†bil":U
    FIELD tta_log_lancto_conver        AS LOGICAL   FORMAT "Sim/N∆o":U    INITIAL NO      LABEL "Lanáamento Convers∆o":U COLUMN-LABEL "Lanáto Conv":U
    FIELD tta_log_lancto_apurac_restdo AS LOGICAL   FORMAT "Sim/N∆o":U    INITIAL NO      LABEL "Lanáamento Apuraá∆o":U  COLUMN-LABEL "Lancto Apuraá∆o":U
    FIELD tta_cod_rat_ctbl             AS CHARACTER FORMAT "x(8)":U                       LABEL "Rateio Cont†bil":U      COLUMN-LABEL "Rateio":U
    FIELD ttv_rec_integr_lote_ctbl     AS RECID     FORMAT ">>>>>>9":U
    FIELD tta_num_lancto_ctbl          AS INTEGER   FORMAT ">>,>>>,>>9":U INITIAL 10      LABEL "Lanáamento Cont†bil":U  COLUMN-LABEL "Lanáamento Cont†bil":U
    FIELD ttv_ind_erro_valid           AS CHARACTER FORMAT "x(8)":U       INITIAL "N∆o":U
    FIELD tta_dat_lancto_ctbl          AS DATE      FORMAT "99/99/9999":U INITIAL ?       LABEL "Data Lanáamento":U      COLUMN-LABEL "Data Lanáto":U
    FIELD ttv_rec_integr_lancto_ctbl   AS RECID     FORMAT ">>>>>>9":U
    INDEX tt_id IS PRIMARY UNIQUE
        ttv_rec_integr_lote_ctbl ASCENDING
        tta_num_lancto_ctbl      ASCENDING
    INDEX tt_recid
        ttv_rec_integr_lancto_ctbl ASCENDING.

DEFINE NEW SHARED TEMP-TABLE tt_integr_item_lancto_ctbl_1 NO-UNDO
    FIELD ttv_rec_integr_lancto_ctbl      AS RECID     FORMAT ">>>>>>9":U
    FIELD tta_num_seq_lancto_ctbl         AS INTEGER   FORMAT ">>>>9":U                       INITIAL 0       LABEL "Sequància Lanáto":U    COLUMN-LABEL "Sequància Lanáto":U
    FIELD ttv_ind_natur_lancto_ctbl       AS CHARACTER FORMAT "x(2)":U                        INITIAL "DB":U  LABEL "Natureza":U            COLUMN-LABEL "Natureza":U
    FIELD tta_cod_plano_cta_ctbl          AS CHARACTER FORMAT "x(8)":U                                        LABEL "Plano Contas":U        COLUMN-LABEL "Plano Contas":U
    FIELD tta_cod_cta_ctbl                AS CHARACTER FORMAT "x(20)":U                                       LABEL "Conta Cont†bil":U      COLUMN-LABEL "Conta Cont†bil":U
    FIELD tta_cod_plano_ccusto            AS CHARACTER FORMAT "x(8)":U                                        LABEL "Plano Centros Custo":U COLUMN-LABEL "Plano Centros Custo":U
    FIELD tta_cod_estab                   AS CHARACTER FORMAT "x(3)":U                                        LABEL "Estabelecimento":U     COLUMN-LABEL "Estab":U
    FIELD tta_cod_unid_negoc              AS CHARACTER FORMAT "x(3)":U                                        LABEL "Unid Neg¢cio":U        COLUMN-LABEL "Un Neg":U
    FIELD tta_cod_histor_padr             AS CHARACTER FORMAT "x(8)":U                                        LABEL "Hist¢rico Padr∆o":U    COLUMN-LABEL "Hist¢rico Padr∆o":U
    FIELD tta_des_histor_lancto_ctbl      AS CHARACTER FORMAT "x(2000)":U                                     LABEL "Hist¢rico Cont†bil":U  COLUMN-LABEL "Hist¢rico Cont†bil":U
    FIELD tta_cod_espec_docto             AS CHARACTER FORMAT "x(3)":U                                        LABEL "EspÇcie Documento":U   COLUMN-LABEL "EspÇcie":U
    FIELD tta_dat_docto                   AS DATE      FORMAT "99/99/9999":U                  INITIAL ?       LABEL "Data Documento":U      COLUMN-LABEL "Data Documento":U
    FIELD tta_des_docto                   AS CHARACTER FORMAT "x(25)":U                                       LABEL "N£mero Documento":U    COLUMN-LABEL "N£mero Documento":U
    FIELD tta_cod_imagem                  AS CHARACTER FORMAT "x(30)":U                                       LABEL "Imagem":U              COLUMN-LABEL "Imagem":U
    FIELD tta_cod_indic_econ              AS CHARACTER FORMAT "x(8)":U                                        LABEL "Moeda":U               COLUMN-LABEL "Moeda":U
    FIELD tta_dat_lancto_ctbl             AS DATE      FORMAT "99/99/9999":U                  INITIAL ?       LABEL "Data Lanáamento":U     COLUMN-LABEL "Data Lanáto":U
    FIELD tta_qtd_unid_lancto_ctbl        AS DECIMAL   FORMAT ">>,>>>,>>9.99":U    DECIMALS 2 INITIAL 0       LABEL "Quantidade":U          COLUMN-LABEL "Quantidade":U
    FIELD tta_val_lancto_ctbl             AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U DECIMALS 2 INITIAL 0       LABEL "Valor Lanáamento":U    COLUMN-LABEL "Valor Lanáamento":U
    FIELD tta_num_seq_lancto_ctbl_cpart   AS INTEGER   FORMAT ">>>9":U                        INITIAL 0       LABEL "Sequància CPartida":U  COLUMN-LABEL "Sequància CP":U
    FIELD ttv_ind_erro_valid              AS CHARACTER FORMAT "X(08)":U                       INITIAL "N∆o":U
    FIELD tta_cod_ccusto                  AS CHARACTER FORMAT "x(11)":U                                       LABEL "Centro Custo":U        COLUMN-LABEL "Centro Custo":U
    FIELD tta_cod_proj_financ             AS CHARACTER FORMAT "x(20)":U                                       LABEL "Projeto":U             COLUMN-LABEL "Projeto":U
    FIELD ttv_rec_integr_item_lancto_ctbl AS RECID     FORMAT ">>>>>>9":U
    INDEX tt_id IS PRIMARY UNIQUE
        ttv_rec_integr_lancto_ctbl ASCENDING
        tta_num_seq_lancto_ctbl    ASCENDING
    INDEX tt_recid
        ttv_rec_integr_item_lancto_ctbl ASCENDING.

DEFINE NEW SHARED TEMP-TABLE tt_integr_aprop_lancto_ctbl_1 NO-UNDO
    FIELD tta_cod_finalid_econ             AS CHARACTER FORMAT "x(10)":U                                                 LABEL "Finalidade":U          COLUMN-LABEL "Finalidade":U
    FIELD tta_cod_unid_negoc               AS CHARACTER FORMAT "x(3)":U                                                  LABEL "Unid Neg¢cio":U        COLUMN-LABEL "Un Neg":U
    FIELD tta_cod_plano_ccusto             AS CHARACTER FORMAT "x(8)":U                                                  LABEL "Plano Centros Custo":U COLUMN-LABEL "Plano Centros Custo":U
    FIELD tta_qtd_unid_lancto_ctbl         AS DECIMAL   FORMAT ">>,>>>,>>9.99":U       DECIMALS 2  INITIAL 0             LABEL "Quantidade":U          COLUMN-LABEL "Quantidade":U
    FIELD tta_val_lancto_ctbl              AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U    DECIMALS 2  INITIAL 0             LABEL "Valor Lanáamento":U    COLUMN-LABEL "Valor Lanáamento":U
    FIELD tta_num_id_aprop_lancto_ctbl     AS INTEGER   FORMAT "9999999999":U                      INITIAL 0             LABEL "Apropriacao Lanáto":U  COLUMN-LABEL "Apropriacao Lanáto":U
    FIELD ttv_rec_integr_item_lancto_ctbl  AS RECID     FORMAT ">>>>>>9":U
    FIELD tta_dat_cotac_indic_econ         AS DATE      FORMAT "99/99/9999":U                      INITIAL ?             LABEL "Data Cotaá∆o":U        COLUMN-LABEL "Data Cotaá∆o":U
    FIELD tta_val_cotac_indic_econ         AS DECIMAL   FORMAT ">>>>,>>9.9999999999":U DECIMALS 10 INITIAL 0             LABEL "Cotaá∆o":U             COLUMN-LABEL "Cotaá∆o":U
    FIELD ttv_ind_erro_valid               AS CHARACTER FORMAT "x(08)":U                           INITIAL "N∆o":U
    FIELD tta_ind_orig_val_lancto_ctbl     AS CHARACTER FORMAT "x(10)":U                           INITIAL "Informado":U LABEL "Origem Valor":U        COLUMN-LABEL "Origem Valor":U
    FIELD tta_cod_ccusto                   AS CHARACTER FORMAT "x(11)":U                                                 LABEL "Centro Custo":U        COLUMN-LABEL "Centro Custo":U
    FIELD ttv_rec_integr_aprop_lancto_ctbl AS RECID     FORMAT ">>>>>>9":U
    INDEX tt_id IS PRIMARY UNIQUE
        ttv_rec_integr_item_lancto_ctbl ASCENDING
        tta_cod_finalid_econ            ASCENDING
        tta_cod_unid_negoc              ASCENDING
        tta_cod_plano_ccusto            ASCENDING
        tta_cod_ccusto                  ASCENDING
    INDEX tt_recid
        ttv_rec_integr_aprop_lancto_ctbl ASCENDING.

DEFINE NEW SHARED TEMP-TABLE tt_integr_ctbl_valid_1 NO-UNDO
    FIELD ttv_rec_integr_ctbl AS RECID     FORMAT ">>>>>>9":U
    FIELD ttv_num_mensagem    AS INTEGER   FORMAT ">>>>,>>9":U LABEL "N£mero":U  COLUMN-LABEL "N£mero Mensagem":U
    FIELD ttv_ind_pos_erro    AS CHARACTER FORMAT "x(08)":U    LABEL "Posiá∆o":U
    INDEX tt_id IS PRIMARY UNIQUE
        ttv_rec_integr_ctbl ASCENDING
        ttv_num_mensagem    ASCENDING.

DEFINE NEW SHARED TEMP-TABLE tt_integr_ctbl_valid_parametros NO-UNDO
    FIELD ttv_rec_aux        AS RECID     FORMAT ">>>>>>9":U
    FIELD ttv_cod_parameters AS CHARACTER FORMAT "x(256)":U
    FIELD ttv_cod_msg        AS CHARACTER FORMAT "x(8)":U LABEL "Mensagem":U COLUMN-LABEL "Mensagem":U.

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_transportador NO-UNDO
    FIELD tta_cdn_transportador     AS INTEGER   FORMAT ">>>,>>>,>>9":U      LABEL "Transportador":U        COLUMN-LABEL "Transp":U
    FIELD tta_cod_estab             AS CHARACTER FORMAT "x(3)":U             LABEL "Estabelecimento":U      COLUMN-LABEL "Estab":U
    FIELD tta_cod_cta_ctbl          AS CHARACTER FORMAT "x(20)":U            LABEL "Conta Cont†bil":U       COLUMN-LABEL "Conta Cont†bil":U
    FIELD tta_cdn_unid_negoc        AS INTEGER   FORMAT ">>>>>>9":U          LABEL "N£mero Unidade Negoc":U COLUMN-LABEL "N£mero UN":U
    FIELD tta_cod_ccusto            AS CHARACTER FORMAT "x(11)":U            LABEL "Centro Custo":U         COLUMN-LABEL "Centro Custo":U
    FIELD tta_ind_natur_lancto_ctbl AS CHARACTER FORMAT "x(2)":U             LABEL "Natureza":U             COLUMN-LABEL "Natureza":U
    FIELD tta_cod_lote_gko          AS CHAR      FORMAT "x(12)"              LABEL "Lote GKO"               COLUMN-LABEL "Lote GKO"
    FIELD ttv_nom_completo          AS CHARACTER FORMAT "x(100)":U           LABEL "Nome Completo":U        COLUMN-LABEL "Nome Completo":U
    FIELD ttv_nom_arquivo           AS CHARACTER FORMAT "x(100)":U           LABEL "Nome Arquivo":U         COLUMN-LABEL "Arquivo":U
    FIELD ttv_val_lancto_ctbl       AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U LABEL "Valor Lanáamento":U     COLUMN-LABEL "Valor Lanáamento":U
    INDEX tt_id IS PRIMARY UNIQUE
        tta_cdn_transportador
        tta_cod_estab
        tta_cod_cta_ctbl
        tta_cdn_unid_negoc
        tta_cod_ccusto
        tta_ind_natur_lancto_ctbl
        tta_cod_lote_gko
        ttv_nom_completo.

DEFINE TEMP-TABLE tt_transportador_aux NO-UNDO
    FIELD tta_cdn_transportador            AS INTEGER   FORMAT ">>>,>>>,>>9":U LABEL "Transportador":U        COLUMN-LABEL "Transp":U
    FIELD tta_cod_estab                    AS CHARACTER FORMAT "x(3)":U        LABEL "Estabelecimento":U      COLUMN-LABEL "Estab":U
    FIELD tta_cod_cta_ctbl                 AS CHARACTER FORMAT "x(20)":U       LABEL "Conta Cont†bil":U       COLUMN-LABEL "Conta Cont†bil":U
    FIELD tta_cdn_unid_negoc               AS INTEGER   FORMAT ">>>>>>9":U     LABEL "N£mero Unidade Negoc":U COLUMN-LABEL "N£mero UN":U
    FIELD tta_cod_ccusto                   AS CHARACTER FORMAT "x(11)":U       LABEL "Centro Custo":U         COLUMN-LABEL "Centro Custo":U
    FIELD tta_ind_natur_lancto_ctbl        AS CHARACTER FORMAT "x(2)":U        LABEL "Natureza":U             COLUMN-LABEL "Natureza":U
    FIELD tta_cod_lote_gko                 AS CHAR      FORMAT "x(12)"         LABEL "Lote GKO"               COLUMN-LABEL "Lote GKO"
    FIELD ttv_rec_integr_item_lancto_ctbl  AS RECID     FORMAT ">>>>>>9":U
    FIELD ttv_rec_integr_aprop_lancto_ctbl AS RECID     FORMAT ">>>>>>9":U
    FIELD ttv_nom_completo                 AS CHARACTER FORMAT "x(100)":U      LABEL "Nome Completo":U        COLUMN-LABEL "Nome Completo":U
    FIELD ttv_nom_arquivo                  AS CHARACTER FORMAT "x(100)":U      LABEL "Nome Arquivo":U         COLUMN-LABEL "Arquivo":U
    INDEX tt_id IS PRIMARY UNIQUE
        tta_cdn_transportador
        tta_cod_estab
        tta_cod_cta_ctbl
        tta_cdn_unid_negoc
        tta_cod_ccusto
        tta_ind_natur_lancto_ctbl
        tta_cod_lote_gko
        ttv_nom_completo
    INDEX tt_rec_integr_item_lancto_ctbl
        ttv_rec_integr_item_lancto_ctbl
    INDEX tt_rec_integr_aprop_lancto_ctbl
        ttv_rec_integr_aprop_lancto_ctbl.

DEFINE TEMP-TABLE tt_log_erros NO-UNDO
    FIELD tta_cdn_transportador     AS INTEGER   FORMAT ">>>,>>>,>>9":U LABEL "Transportador":U        COLUMN-LABEL "Transp":U
    FIELD tta_cod_estab             AS CHARACTER FORMAT "x(3)":U        LABEL "Estabelecimento":U      COLUMN-LABEL "Estab":U
    FIELD tta_cod_cta_ctbl          AS CHARACTER FORMAT "x(20)":U       LABEL "Conta Cont†bil":U       COLUMN-LABEL "Conta Cont†bil":U
    FIELD tta_cdn_unid_negoc        AS INTEGER   FORMAT ">>>>>>9":U     LABEL "N£mero Unidade Negoc":U COLUMN-LABEL "N£mero UN":U
    FIELD tta_cod_ccusto            AS CHARACTER FORMAT "x(11)":U       LABEL "Centro Custo":U         COLUMN-LABEL "Centro Custo":U
    FIELD tta_ind_natur_lancto_ctbl AS CHARACTER FORMAT "x(2)":U        LABEL "Natureza":U             COLUMN-LABEL "Natureza":U
    FIELD tta_cod_lote_gko          AS CHAR      FORMAT "x(12)"         LABEL "Lote GKO"               COLUMN-LABEL "Lote GKO"
    FIELD ttv_nom_completo          AS CHARACTER FORMAT "x(100)":U      LABEL "Nome Completo":U        COLUMN-LABEL "Nome Completo":U
    FIELD ttv_nom_arquivo           AS CHARACTER FORMAT "x(100)":U      LABEL "Nome Arquivo":U         COLUMN-LABEL "Arquivo":U
    FIELD ttv_num_mensagem          AS INTEGER   FORMAT ">>>>,>>9":U    LABEL "N£mero":U               COLUMN-LABEL "N£mero":U
    FIELD ttv_des_msg_erro          AS CHARACTER FORMAT "x(60)":U       LABEL "Mensagem":U             COLUMN-LABEL "Mensagem":U
    FIELD ttv_des_msg_ajuda         AS CHARACTER FORMAT "x(40)":U       LABEL "Ajuda":U                COLUMN-LABEL "Ajuda":U.

/* Shared Stream Definitions ---                                        */

DEFINE NEW SHARED STREAM s_1.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i_seq          AS INTEGER     NO-UNDO.
DEFINE VARIABLE h_fgl900zg     AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_des_mensagem AS CHARACTER   NO-UNDO FORMAT "x(80)":U.
DEFINE VARIABLE v_des_ajuda    AS CHARACTER   NO-UNDO FORMAT "x(80)":U.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p_dat_ctbl AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt_transportador.
DEFINE INPUT  PARAMETER p-acomp    AS HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erros.


/* ***************************  Main Block  *************************** */

OUTPUT STREAM s_1 TO VALUE(SESSION:TEMP-DIRECTORY + "fgl900zl.lst":U) CONVERT TARGET "iso8859-1":U.

EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.
EMPTY TEMP-TABLE tt_integr_lancto_ctbl_1.
EMPTY TEMP-TABLE tt_integr_item_lancto_ctbl_1.
EMPTY TEMP-TABLE tt_integr_aprop_lancto_ctbl_1.
EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
EMPTY TEMP-TABLE tt_log_erros.

CREATE tt_integr_lote_ctbl_1.
ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL":U /* Verificar se Ç isto mesmo */
       tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 99999 /* Manter assim mesmo, pois ele ser† gerado pelo EMS 5 */
       tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "GKO - Contabilizaá∆o":U
       tt_integr_lote_ctbl_1.tta_cod_empresa          = "1":U
       tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = p_dat_ctbl
       tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).

CREATE tt_integr_lancto_ctbl_1.
ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = "":U
       tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
       tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
       tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = tt_integr_lote_ctbl_1.tta_dat_lote_ctbl
       tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).

ASSIGN i_seq = 0.   

FOR EACH tt_transportador:
    IF VALID-HANDLE(p-acomp) THEN
        RUN pi-acompanhar IN p-acomp (INPUT "Transp/Est/Cta Ctbl/Un Neg/C Custo/Lancto/Lote: ":U + TRIM(STRING(tt_transportador.tta_cdn_transportador)) + "/":U + TRIM(tt_transportador.tta_cod_estab) + "/":U + TRIM(tt_transportador.tta_cod_cta_ctbl) + "/":U + TRIM(STRING(tt_transportador.tta_cdn_unid_negoc)) + "/":U + TRIM(tt_transportador.tta_cod_ccusto) + "/":U + TRIM(tt_transportador.tta_ind_natur_lancto_ctbl) + "/":U + TRIM(tt_transportador.tta_cod_lote_gko)).

    FIND FIRST unid_negoc
        WHERE unid_negoc.cdn_unid_negoc = INTEGER(tt_transportador.tta_cdn_unid_negoc) NO-LOCK NO-ERROR.

    IF NOT AVAILABLE unid_negoc THEN
        FIND FIRST unid_negoc
            WHERE unid_negoc.cdn_unid_negoc = 001 NO-LOCK NO-ERROR.

    FIND FIRST emscad.fornecedor
        WHERE emscad.fornecedor.cod_empresa    = "1":U
          AND emscad.fornecedor.cdn_fornecedor = tt_transportador.tta_cdn_transportador NO-LOCK NO-ERROR.

    ASSIGN i_seq = i_seq + 1.

    CREATE tt_integr_item_lancto_ctbl_1.
    ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i_seq
           tt_integr_item_lancto_ctbl_1.ttv_ind_natur_lancto_ctbl       = tt_transportador.tta_ind_natur_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padr∆o":U
           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = tt_transportador.tta_cod_cta_ctbl
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF tt_transportador.tta_cod_ccusto <> "" THEN 'Padr∆o' ELSE ''
           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = tt_transportador.tta_cod_estab
           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = unid_negoc.cod_unid_negoc
           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real":U
           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = tt_transportador.tta_cod_ccusto
           tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = "":U
           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1)
           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = tt_transportador.ttv_val_lancto_ctbl.

    IF AVAILABLE fornecedor THEN
        ASSIGN tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl = "Lote GKO: "       + TRIM(tt_transportador.tta_cod_lote_gko)              + "#"
                                                                       + "Transportadora: " + TRIM(STRING(tt_transportador.tta_cdn_transportador)) + "#"
                                                                       + emscad.fornecedor.nom_pessoa.
    ELSE
        ASSIGN tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl = "Lote GKO: "       + TRIM(tt_transportador.tta_cod_lote_gko)              + "#"
                                                                       + "Transportadora: " + TRIM(STRING(tt_transportador.tta_cdn_transportador)) + "#"
                                                                       + "Fornecedor n∆o cadastrado no EMS-5".
    
    CREATE tt_integr_aprop_lancto_ctbl_1.
    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "corrente":U
           tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = unid_negoc.cod_unid_negoc
           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF tt_transportador.tta_cod_ccusto <> "" THEN 'Padr∆o' ELSE ''
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = tt_transportador.tta_cod_ccusto
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1)
           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = tt_transportador.ttv_val_lancto_ctbl.

    CREATE tt_transportador_aux.
    ASSIGN tt_transportador_aux.tta_cdn_transportador            = tt_transportador.tta_cdn_transportador
           tt_transportador_aux.tta_cod_estab                    = tt_transportador.tta_cod_estab
           tt_transportador_aux.tta_cod_cta_ctbl                 = tt_transportador.tta_cod_cta_ctbl
           tt_transportador_aux.tta_cdn_unid_negoc               = tt_transportador.tta_cdn_unid_negoc
           tt_transportador_aux.tta_cod_ccusto                   = tt_transportador.tta_cod_ccusto
           tt_transportador_aux.tta_ind_natur_lancto_ctbl        = tt_transportador.tta_ind_natur_lancto_ctbl
           tt_transportador_aux.tta_cod_lote_gko                 = tt_transportador.tta_cod_lote_gko
           tt_transportador_aux.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
           tt_transportador_aux.ttv_rec_integr_aprop_lancto_ctbl = tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl
           tt_transportador_aux.ttv_nom_completo                 = tt_transportador.ttv_nom_completo
           tt_transportador_aux.ttv_nom_arquivo                  = tt_transportador.ttv_nom_arquivo.

END.

IF VALID-HANDLE(p-acomp) THEN
    RUN pi-acompanhar IN p-acomp (INPUT "Integrando...":U).

RUN prgfin/fgl/fgl900zl.py (INPUT 3,
                            INPUT "Aborta Tudo":U,
                            INPUT YES,
                            INPUT 66,
                            INPUT "Apropriaá∆o":U,
                            INPUT "Todos":U,
                            INPUT YES,
                            INPUT YES,
                            INPUT-OUTPUT TABLE tt_integr_lote_ctbl_1,
                            INPUT-OUTPUT TABLE tt_integr_lancto_ctbl_1,
                            INPUT-OUTPUT TABLE tt_integr_item_lancto_ctbl_1,
                            INPUT-OUTPUT TABLE tt_integr_aprop_lancto_ctbl_1,
                            INPUT-OUTPUT TABLE tt_integr_ctbl_valid_1).

IF NOT VALID-HANDLE(h_fgl900zg) THEN
    RUN prgfin/fgl/fgl900zg.py PERSISTENT SET h_fgl900zg (INPUT ?,
                                                          INPUT ?,
                                                          INPUT ?,
                                                          INPUT ?,
                                                          INPUT ?).

OUTPUT STREAM s_1 CLOSE.

IF CAN-FIND(FIRST tt_integr_ctbl_valid_1) AND
   VALID-HANDLE(p-acomp)                  THEN
    RUN pi-acompanhar IN p-acomp (INPUT "Gerando Mensagem EMS 5...":U).

ASSIGN v_des_mensagem = "":U
       v_des_ajuda    = "":U.

FOR EACH tt_integr_ctbl_valid_1:
    IF VALID-HANDLE(h_fgl900zg) THEN
        RUN pi_msg_lote_ctbl_recebto_1 IN h_fgl900zg (INPUT  tt_integr_ctbl_valid_1.ttv_num_mensagem,
                                                      OUTPUT v_des_mensagem,
                                                      OUTPUT v_des_ajuda).

    FIND FIRST tt_transportador_aux
        WHERE tt_transportador_aux.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl NO-ERROR.

    IF NOT AVAILABLE tt_transportador_aux THEN
        FIND FIRST tt_transportador_aux
            WHERE tt_transportador_aux.ttv_rec_integr_aprop_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl NO-ERROR.
    
    CREATE tt_log_erros.
    ASSIGN tt_log_erros.tta_cdn_transportador     = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cdn_transportador     ELSE 0
           tt_log_erros.tta_cod_estab             = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cod_estab             ELSE "":U
           tt_log_erros.tta_cod_cta_ctbl          = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cod_cta_ctbl          ELSE "":U
           tt_log_erros.tta_cdn_unid_negoc        = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cdn_unid_negoc        ELSE 0
           tt_log_erros.tta_cod_ccusto            = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cod_ccusto            ELSE "":U
           tt_log_erros.tta_ind_natur_lancto_ctbl = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_ind_natur_lancto_ctbl ELSE "":U
           tt_log_erros.tta_cod_lote_gko          = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.tta_cod_lote_gko          ELSE ""
           tt_log_erros.ttv_nom_completo          = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.ttv_nom_completo          ELSE "":U
           tt_log_erros.ttv_nom_arquivo           = IF AVAILABLE tt_transportador_aux THEN tt_transportador_aux.ttv_nom_arquivo           ELSE "":U
           tt_log_erros.ttv_num_mensagem          = tt_integr_ctbl_valid_1.ttv_num_mensagem
           tt_log_erros.ttv_des_msg_erro          = v_des_mensagem
           tt_log_erros.ttv_des_msg_ajuda         = v_des_ajuda.
END.

IF VALID-HANDLE(h_fgl900zg) THEN
    DELETE PROCEDURE h_fgl900zg.

ASSIGN h_fgl900zg = ?.

