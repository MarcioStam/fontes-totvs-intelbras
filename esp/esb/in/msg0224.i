{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0224 NO-UNDO XML-NODE-NAME 'MSG0224'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoContaContabil    LIKE cta_ctbl.cod_cta_ctbl     INITIAL ?
   FIELD DescricaoContaContabil LIKE cta_ctbl.des_tit_ctbl     INITIAL ?
   FIELD CodigoUnidadeNegocio   LIKE cta_ctbl.cod_cta_ctbl     INITIAL ?
   FIELD CodigoEstabelecimento  LIKE estabelecimento.cod_estab INITIAL ?.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0224R1 NO-UNDO XML-NODE-NAME 'MSG0224R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ContaContabil NO-UNDO XML-NODE-NAME 'ContaContabil'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoContaContabil    LIKE cta_ctbl.cod_cta_ctbl
   FIELD DescricaoContaContabil LIKE cta_ctbl.des_tit_ctbl
   FIELD Alternativa            LIKE cta_ctbl.cod_altern_cta_ctbl    
   FIELD FinalidadeContabil     LIKE cta_ctbl.ind_utiliz_ctbl_finalid
   FIELD DataInicioValidade     LIKE cta_ctbl.dat_inic_valid         
   FIELD DataFimValidade        LIKE cta_ctbl.dat_fim_valid.

   
DEFINE TEMP-TABLE CentroCusto NO-UNDO XML-NODE-NAME 'CentroCusto'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoContaContabil    LIKE cta_ctbl.cod_cta_ctbl XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoCentroCusto      LIKE emscad.ccusto.cod_ccusto         
   FIELD DescricaoCentroCusto   LIKE emscad.ccusto.des_tit_ctbl       
   FIELD MatriculaResponsavel   LIKE emscad.ccusto.cod_usuar_respons  
   FIELD DataInicioValidade     LIKE emscad.ccusto.dat_inic_valid     
   FIELD DataFimValidade        LIKE emscad.ccusto.dat_fim_valid.      

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt_cta_integr NO-UNDO
    FIELD ttv_cod_plano_cta_ctbl           AS CHARACTER FORMAT "X(8)"  LABEL "Plano Contas"   COLUMN-LABEL "Plano Contas"
    FIELD ttv_cod_cta_ctbl                 AS CHARACTER FORMAT "X(20)" LABEL "Conta Contÿbil" COLUMN-LABEL "Conta Contÿbil"
    FIELD ttv_des_titulo                   AS CHARACTER FORMAT "X(40)"
    FIELD ttv_num_tip_cta_ctbl             AS INTEGER   FORMAT ">9"    LABEL "Tipo Conta"     COLUMN-LABEL "Tipo Conta"
    FIELD ttv_num_sit_cta_ctbl             AS INTEGER   FORMAT ">9"    LABEL "Situa‡Æo Conta" COLUMN-LABEL "Situa‡Æo Cta"
    FIELD ttv_ind_finalid_ctbl_cta         AS CHARACTER FORMAT "X(40)" LABEL "Finalidade Contÿbil"
    INDEX tt_id                           
          ttv_cod_plano_cta_ctbl           ASCENDING
          ttv_cod_cta_ctbl                 ASCENDING.

DEFINE TEMP-TABLE tt_ccusto_cta_integr NO-UNDO
    FIELD ttv_cod_empresa                  AS CHARACTER FORMAT "x(3)"  LABEL "Empresa"         COLUMN-LABEL "Empresa"
    FIELD ttv_cod_plano_cta_ctbl           AS CHARACTER FORMAT "x(8)"  LABEL "Plano Contas"    COLUMN-LABEL "Plano Contas"
    FIELD ttv_cod_cta_ctbl                 AS CHARACTER FORMAT "x(20)" LABEL "Conta Contÿbil" COLUMN-LABEL "Conta Contÿbil"
    FIELD ttv_cod_plano_ccusto             AS CHARACTER FORMAT "x(8)"  LABEL "Plano CCusto"   COLUMN-LABEL "Plano CCusto"
    FIELD ttv_cod_ccusto                   AS CHARACTER FORMAT "x(11)" LABEL "Centro Custo"   COLUMN-LABEL "Centro Custo"
    FIELD ttv_des_ccusto                   AS CHARACTER FORMAT "x(40)" LABEL "Des Ccusto"     COLUMN-LABEL "Des Ccusto"
    INDEX tt_id                           
          ttv_cod_empresa                  ASCENDING
          ttv_cod_plano_cta_ctbl           ASCENDING
          ttv_cod_cta_ctbl                 ASCENDING
          ttv_cod_plano_ccusto             ASCENDING
          ttv_cod_ccusto                   ASCENDING.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro                 AS INTEGER FORMAT ">>>>,>>9" LABEL "Nœmero"         COLUMN-LABEL "Nœmero"
    FIELD ttv_des_msg_ajuda                AS CHARACTER FORMAT "x(40)"  LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro                 AS CHARACTER FORMAT "x(60)"  LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsist¼ncia".

DEFINE VARIABLE v_cod_plano_cta_ctbl AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h_api_ccusto         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl       AS HANDLE      NO-UNDO.
