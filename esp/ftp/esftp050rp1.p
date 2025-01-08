DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-dt-faturam  AS DATE      NO-UNDO.

{utp/ut-glob.i}
{esp/ftp/esftp050rp1.i}
{esp/es0018.i}

DEF VAR v_hapb944za AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER NO-UNDO FORMAT "x(40)".

DEFINE TEMP-TABLE tt-devol NO-UNDO
    FIELD cod-estabel  AS CHARACTER
    FIELD matriz       AS INTEGER
    FIELD cod-unid-neg AS CHARACTER
    FIELD nr-nota-fis  AS CHARACTER
    FIELD nr-nota-dev  AS CHARACTER
    FIELD num-id-tit   AS INTEGER
    FIELD valor        AS DECIMAL
    FIELD saldo        AS DECIMAL.

DEFINE TEMP-TABLE tt-erros-encontrados NO-UNDO
    FIELD matriz   AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-erro AS INTEGER   FORMAT ">>>>,>>9"
    FIELD mensagem AS CHARACTER FORMAT "x(113)".

DEFINE TEMP-TABLE tt-sequencia NO-UNDO
    FIELD cod-estabel   AS CHARACTER
    FIELD cod-unid-neg  AS CHARACTER
    FIELD ct-codigo     AS CHARACTER
    FIELD sc-codigo     AS CHARACTER
    FIELD cnr-parcela   AS CHARACTER
    .

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren
    AS CHARACTER
    FORMAT "X(12)"
    LABEL "Usu rio Corrente"
    COLUMN-LABEL "Usu rio Corrente"
    NO-UNDO.

DEFINE TEMP-TABLE tt-prog-ponto-2 LIKE tt-prog-ponto.

/*Define variaveis*/
DEFINE VARIABLE v_hdl_aux AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE NO-UNDO.

DEFINE VARIABLE p_num_vers_integr_api     AS INTEGER   FORMAT ">>>>,>>9" NO-UNDO.
DEFINE VARIABLE v_cod_matriz_trad_org_ext AS CHARACTER FORMAT "X(8)"     NO-UNDO. 
DEFINE VARIABLE v_int                     AS i                           NO-UNDO.
    
DEFINE VARIABLE c-mensagem   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-refer      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-parcela    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cta-ctbl   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-ccusto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-valor     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-fat       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-dev       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-estab-exc  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodo    AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-acordo  FOR acordo-fatur.
DEFINE BUFFER bd-acordo FOR acordo-fatur.

def buffer b-tt_dados_integr_apb_enc_ctas for tt_dados_integr_apb_enc_ctas.  
def buffer b-tt_item_integr_apb_enc_ctas  for tt_item_integr_apb_enc_ctas.   
def buffer b-tt_log_integr_apb_enc_ctas   for tt_log_integr_apb_enc_ctas.    
def buffer b-tt_tit_acr_info              for tt_tit_acr_info.               

DEF BUFFER b-APB-tt_item_integr_apb_enc_cta FOR b-tt_item_integr_apb_enc_ctas.

DEF TEMP-TABLE tt-aux-apb-acr   NO-UNDO LIKE b-tt_item_integr_apb_enc_ctas.
DEF TEMP-TABLE tt-aux-capa-lote NO-UNDO LIKE b-tt_dados_integr_apb_enc_ctas.

ASSIGN l-erro = NO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Gerando Contas a Pagar...").

FOR EACH tt-erros-encontrados:
    DELETE tt-erros-encontrados.
END.

FOR EACH tt-devol:
    DELETE tt-devol.
END.

ASSIGN c-periodo = STRING(YEAR(p-dt-faturam),"9999") + STRING(MONTH(p-dt-faturam),"99").

/*faz provisÆo*/
PUT UNFORMATTED  SKIP(2)
    "PROVISAO: " SKIP(2)
    "Matriz    Unidade   Valor Liquido Vl. Faturamento  Vl. Devolu‡äes Observa‡äes                                                     " SKIP
    "--------- ------- --------------- --------------- --------------- ----------------------------------------------------------------" SKIP.

RUN esp/es0018p.p (INPUT "esftp050rp1",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    CREATE tt-sequencia.
    ASSIGN tt-sequencia.cod-estabel  = ENTRY(1,tt-prog-ponto.conteudo)
           tt-sequencia.cod-unid-neg = ENTRY(2,tt-prog-ponto.conteudo)
           tt-sequencia.ct-codigo    = ENTRY(3,tt-prog-ponto.conteudo)
           tt-sequencia.sc-codigo    = ENTRY(4,tt-prog-ponto.conteudo)
           tt-sequencia.cnr-parcela  = ENTRY(5,tt-prog-ponto.conteudo).
END.

RUN esp/es0018p.p (INPUT "esftp050rp1",
                   INPUT 2,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto-2).

FOR FIRST tt-prog-ponto-2:
    ASSIGN c-estab-exc = tt-prog-ponto-2.conteudo.
END.

FOR EACH acordo-fatur NO-LOCK
   WHERE acordo-fatur.cod-estabel   = p-cod-estabel
    AND  acordo-fatur.num-id-titulo = 0
    AND  acordo-fatur.periodo       = c-periodo
    AND  acordo-fatur.saldo         > 0
    /*AND  (acordo-fatur.matriz = 540889 OR acordo-fatur.matriz = 1046  OR acordo-fatur.matriz = 19864)*/
    AND  acordo-fatur.nr-nota-dev   = ""
    BREAK BY acordo-fatur.matriz
          BY acordo-fatur.cod-unid-neg:

    ASSIGN de-fat = de-fat + acordo-fatur.saldo.

    IF LAST-OF(acordo-fatur.matriz) OR LAST-OF(acordo-fatur.cod-unid-neg) THEN DO:

        ASSIGN c-parcela    = ""
               c-cta-ctbl   = ""
               c-cod-ccusto = "".

        FOR FIRST tt-sequencia
            WHERE tt-sequencia.cod-estabel  = acordo-fatur.cod-estabel
            AND   tt-sequencia.cod-unid-neg = acordo-fatur.cod-unid-neg:

            ASSIGN c-parcela    = tt-sequencia.cnr-parcela
                   c-cta-ctbl   = tt-sequencia.ct-codigo
                   c-cod-ccusto = tt-sequencia.sc-codigo.
        END.

        PUT UNFORMATTED 
            acordo-fatur.matriz                AT 01
            acordo-fatur.cod-unid-neg          AT 11
            de-valor FORMAT "->>>,>>>,>>9.99"  TO 33
            de-fat   FORMAT "->>>,>>>,>>9.99"  TO 49
            de-dev   FORMAT "->>>,>>>,>>9.99"  TO 65.

        IF de-fat > 0 THEN DO:
            /*Gera titulo com valor total de faturamento*/
            RUN pi-gera-titulo.
        END.

        PUT UNFORMATTED SKIP.
        ASSIGN de-valor = 0
               de-fat   = 0
               de-dev   = 0.
    END.
END.

PUT UNFORMATTED  SKIP(2)
    "DEVOLUCAO: " SKIP(2)
    "Matriz    Unidade   Valor Liquido Vl. Faturamento  Vl. Devolu‡äes Observa‡äes                                                     " SKIP
    "--------- ------- --------------- --------------- --------------- ----------------------------------------------------------------" SKIP.


FOR EACH acordo-fatur NO-LOCK
   WHERE acordo-fatur.cod-estabel   = p-cod-estabel
     AND acordo-fatur.num-id-titulo = 0
     AND acordo-fatur.periodo       = c-periodo
     AND acordo-fatur.saldo         < 0
     /*AND  (acordo-fatur.matriz = 540889 OR acordo-fatur.matriz = 1046  OR acordo-fatur.matriz = 19864)*/
    BREAK BY acordo-fatur.matriz
          BY acordo-fatur.cod-unid-neg:

    ASSIGN de-dev = de-dev + (acordo-fatur.saldo * -1).
    
    FIND FIRST b-acordo NO-LOCK
         WHERE b-acordo.cod-estabel  = acordo-fatur.cod-estabel 
           AND b-acordo.matriz       = acordo-fatur.matriz      
           AND b-acordo.cod-unid-neg = acordo-fatur.cod-unid-neg
           AND b-acordo.nr-nota-fis  = acordo-fatur.nr-nota-fis
        /* AND b-acordo.periodo      = acordo-fatur.periodo - Buscar notas de origem independentemente do per¡odo */
           AND b-acordo.nr-nota-dev  = "" NO-ERROR.
    IF AVAIL b-acordo THEN DO:
        FIND FIRST tt-devol NO-LOCK
             WHERE tt-devol.cod-estabel   = b-acordo.cod-estabel
               AND tt-devol.matriz        = b-acordo.matriz
               AND tt-devol.cod-unid-neg  = b-acordo.cod-unid-neg
               AND tt-devol.nr-nota-fis   = b-acordo.nr-nota-fis
               AND tt-devol.num-id-tit    = b-acordo.num-id-titulo NO-ERROR.
        IF NOT AVAIL tt-devol THEN DO:
            CREATE tt-devol.
            ASSIGN tt-devol.cod-estabel  = b-acordo.cod-estabel  
                   tt-devol.matriz       = b-acordo.matriz       
                   tt-devol.cod-unid-neg = b-acordo.cod-unid-neg 
                   tt-devol.nr-nota-fis  = b-acordo.nr-nota-fis  
                   tt-devol.num-id-tit   = b-acordo.num-id-titulo
                   tt-devol.nr-nota-dev  = acordo-fatur.nr-nota-dev /*pega nota devolu‡Æo*/.
        END.
        ASSIGN tt-devol.valor = tt-devol.valor + (acordo-fatur.saldo * -1)
               tt-devol.saldo = tt-devol.saldo + b-acordo.saldo.
    END.

    IF LAST-OF(acordo-fatur.matriz) OR LAST-OF(acordo-fatur.cod-unid-neg) THEN DO:

        ASSIGN c-parcela    = ""
               c-cta-ctbl   = ""
               c-cod-ccusto = "".

        FOR FIRST tt-sequencia
            WHERE tt-sequencia.cod-estabel  = acordo-fatur.cod-estabel
            AND   tt-sequencia.cod-unid-neg = acordo-fatur.cod-unid-neg:

            ASSIGN c-parcela    = tt-sequencia.cnr-parcela
                   c-cta-ctbl   = tt-sequencia.ct-codigo
                   c-cod-ccusto = tt-sequencia.sc-codigo.
        END.

        PUT UNFORMATTED 
            acordo-fatur.matriz                AT 01
            acordo-fatur.cod-unid-neg          AT 11
            de-valor FORMAT "->>>,>>>,>>9.99"  TO 33
            de-fat   FORMAT "->>>,>>>,>>9.99"  TO 49
            de-dev   FORMAT "->>>,>>>,>>9.99"  TO 65.

        IF CAN-FIND(FIRST tt-devol) OR  de-dev > 0 THEN DO:
            /*Faz AVA dos valores das devolu‡äes ocorridas no mˆs*/
            FOR EACH tt-devol WHERE tt-devol.matriz = acordo-fatur.matriz BREAK BY tt-devol.num-id-tit DESC:

                FIND FIRST bd-acordo NO-LOCK
                     WHERE bd-acordo.cod-estabel   = tt-devol.cod-estabel  
                       AND bd-acordo.matriz        = tt-devol.matriz
                       AND bd-acordo.cod-unid-neg  = tt-devol.cod-unid-neg
                       AND bd-acordo.nr-nota-fis   = tt-devol.nr-nota-fis
                       AND bd-acordo.num-id-titulo = tt-devol.num-id-tit 
                       AND bd-acordo.periodo       = c-periodo NO-ERROR.

                ASSIGN de-dev = tt-devol.valor.
                RUN pi-gera-ava.
            END.
            
        END.
        ELSE PUT UNFORMATTED SKIP.

        ASSIGN de-valor = 0
               de-fat   = 0
               de-dev   = 0.

        FOR EACH tt-devol:
            DELETE tt-devol.
        END.
    END.
END.

RUN pi-gera-encontro-ctas.


RUN pi-finalizar in h-acomp.

IF CAN-FIND(FIRST tt-erros-encontrados NO-LOCK) THEN DO:
    PUT UNFORMATTED SKIP(2) "Erros Encontrados: " SKIP(1)
        "   Matriz     Erro Mensagem                                                                                                         " SKIP
        "--------- -------- -----------------------------------------------------------------------------------------------------------------" SKIP.

    FOR EACH tt-erros-encontrados:
        PUT UNFORMATTED
            tt-erros-encontrados.matriz   TO 09
            tt-erros-encontrados.cod-erro TO 18
            tt-erros-encontrados.mensagem AT 20 SKIP.
    END.
END.



PROCEDURE pi-gera-titulo.
    DEFINE VARIABLE i-seq-movto       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tempo           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cod-tit-ap      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-referencia      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq             AS INTEGER     NO-UNDO.
    
    RUN pi-zera-tabelas.

    ASSIGN c-cod-tit-ap = STRING(MONTH(p-dt-faturam),"99") + STRING(YEAR(p-dt-faturam),"9999") + acordo-fatur.cod-unid-neg + acordo-fatur.cod-estabel.

    /* Atualiza lote sim ou n’o */
    assign v_log_atualiza_refer_apb = YES.

    /*busca referencia*/
    ASSIGN c-refer = "".
    RUN pi-busca-referencia (INPUT "VAC",
                             INPUT acordo-fatur.cod-estabel,
                             OUTPUT c-refer).

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = acordo-fatur.cod-estabel NO-ERROR.

    /*lotes de implanta»’o*/		
    create tt_integr_apb_lote_impl.
    assign tt_integr_apb_lote_impl.tta_cod_estab                = acordo-fatur.cod-estabel
           tt_integr_apb_lote_impl.tta_cod_refer                = c-refer
    /*       tt_integr_apb_lote_impl.tta_cod_espec_docto          = "dp" Esp²cie s½ deve ser informada quando for Previs’o/Provis’o*/
           tt_integr_apb_lote_impl.tta_dat_transacao            = p-dt-faturam
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        = "apb"   
           tt_integr_apb_lote_impl.tta_cod_empresa              = STRING(estabelec.ep-codigo).

    release tt_integr_apb_lote_impl.  

    find first tt_integr_apb_lote_impl no-lock.

    repeat v_int=1 to 1:
      /*itens dos lote de implanta»’o*/
      create tt_integr_apb_item_lote_impl_3.
      assign tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
             tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
             tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = v_int
             tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = acordo-fatur.matriz
             tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = "VA"
             tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "U"
             tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = c-cod-tit-ap
             tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = c-parcela
             tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = p-dt-faturam
             tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = p-dt-faturam
             tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = p-dt-faturam
             tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /*boleto*/
             tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"
             tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = de-fat
             tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
             tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.
              release tt_integr_apb_item_lote_impl_3.

      release tt_integr_apb_item_lote_impl_3.
      FIND FIRST tt_integr_apb_item_lote_impl_3 NO-LOCK NO-ERROR.

      /*Apropria»„es dos t­tulos*/
      create tt_integr_apb_aprop_ctbl_pend.
      assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
             tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
             tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
             tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = acordo-fatur.cod-unid-neg
             tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "232" /*tipo-verba.tp-fluxo-financ*/
             tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = de-fat
             tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
             tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
             tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
             tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
             tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "Padrao"
             tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = c-cta-ctbl
              tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto         = "Padrao"
             tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = c-cod-ccusto.
    end. /* end repeat */

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


    run pi-acompanhar in h-acomp (INPUT "Matriz: " + STRING(acordo-fatur.matriz) + " - Unid: " + STRING(acordo-fatur.cod-unid-neg) + " - Valor: " + TRIM(STRING(de-fat,"->>>,>>>,>>9.99"))).
    run pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (Input 5,
                                         Input v_cod_matriz_trad_org_ext,
                                         input-output table tt_integr_apb_item_lote_impl3v) /*pi_main_block_api_tit_ap_cria_4*/.
    delete procedure v_hdl_aux.  

    IF CAN-FIND(FIRST tt_log_erros_atualiz NO-LOCK) THEN DO:
        PUT UNFORMATTED "Ocorreu erro" AT 67.
        FOR EACH tt_log_erros_atualiz:
            CREATE tt-erros-encontrados.
            ASSIGN tt-erros-encontrados.matriz   = acordo-fatur.matriz
                   tt-erros-encontrados.cod-erro = tt_log_erros_atualiz.ttv_num_mensagem
                   tt-erros-encontrados.mensagem = tt_log_erros_atualiz.ttv_des_msg_erro + " - " + tt_log_erros_atualiz.ttv_des_msg_ajuda.
        END.
    END.
    ELSE DO:
        
        ASSIGN c-referencia = "".

        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = acordo-fatur.cod-estabel
               AND tit_ap.cdn_fornecedor  = acordo-fatur.matriz
               AND tit_ap.cod_espec_docto = "VA"
               AND tit_ap.cod_ser_docto   = "U"
               AND tit_ap.cod_tit_ap      = c-cod-tit-ap
               AND tit_ap.cod_parcela     = c-parcela NO-ERROR.

        IF  AVAIL tit_ap THEN DO:
            /* ---------------------------------  CAPA DO LOTE DO ENCONTRO DE CONTAS ---------------------------- */
            RUN pi-busca-referencia (INPUT  "ENCACO",
                                     INPUT  p-cod-estabel,
                                     OUTPUT c-referencia).

            CREATE b-tt_dados_integr_apb_enc_ctas.
            ASSIGN b-tt_dados_integr_apb_enc_ctas.tta_cod_estab_refer           = p-cod-estabel
                   b-tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor            = tit_ap.cdn_fornecedor
                   b-tt_dados_integr_apb_enc_ctas.tta_cdn_cliente               = tit_ap.cdn_fornecedor
                   b-tt_dados_integr_apb_enc_ctas.tta_cod_refer                 = c-referencia
                   b-tt_dados_integr_apb_enc_ctas.tta_dat_transacao             = p-dt-faturam
                   b-tt_dados_integr_apb_enc_ctas.tta_val_tot_lote_pagto_efetd  = 10
                   b-tt_dados_integr_apb_enc_ctas.tta_cod_indic_econ            = "REAL"
                   b-tt_dados_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
                   b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = RECID(b-tt_dados_integr_apb_enc_ctas)
                   b-tt_dados_integr_apb_enc_ctas.tta_log_bxa_estab_tit_ap      = NO
                   b-tt_dados_integr_apb_enc_ctas.ttv_log_vinc_impto_auto       = NO.
            /* --------------------------------------------------------------------------------------------------- */


            ASSIGN i-seq-movto = NEXT-VALUE(seq_movto_acordo)
                   i-tempo     = TIME.

            FOR EACH b-acordo EXCLUSIVE-LOCK
               WHERE b-acordo.cod-estabel   = acordo-fatur.cod-estabel
                 AND b-acordo.matriz        = acordo-fatur.matriz
                 AND b-acordo.cod-unid-neg  = acordo-fatur.cod-unid-neg
                 AND b-acordo.periodo       = acordo-fatur.periodo
                 AND b-acordo.num-id-titulo = 0
                 AND b-acordo.saldo         > 0:

                 FOR LAST acordo-contrato  NO-LOCK 
                    WHERE acordo-contrato.raiz-cnpj   = acordo-fatur.raiz-cnpj
                      AND acordo-contrato.ativo       = YES,
                     FIRST acordo-tipo OF acordo-contrato NO-LOCK. 
                 END. 

                 IF  AVAIL acordo-tipo
                 AND acordo-tipo.forma-pagto = 1 /* DESCONTO */
                 AND acordo-tipo.id-pagto    = 1 /* POR NF   */ 
                 THEN DO:
                      FOR EACH nota-fiscal FIELDS (cod-estabel serie nr-fatura) NO-LOCK
                          WHERE nota-fiscal.cod-estabel = b-acordo.cod-estab
                            AND nota-fiscal.serie       = b-acordo.serie
                            AND nota-fiscal.nr-nota-fis = b-acordo.nr-nota-fis:
                          
                           FOR EACH tit_acr NO-LOCK
                               WHERE tit_acr.cod_estab   = nota-fiscal.cod-estabel
                                 AND tit_acr.cod_espec   = "DM"
                                 AND tit_acr.cod_ser     = nota-fiscal.serie
                                 AND tit_acr.cod_tit_acr = nota-fiscal.nr-fatura
                                 AND tit_acr.log_sdo_tit_acr
                                 AND NOT tit_acr.log_tit_acr_estordo 
                                 AND tit_acr.cod_portador <> "9915":

                               IF  NOT CAN-FIND(FIRST b-tt_item_integr_apb_enc_ctas
                                                WHERE b-tt_item_integr_apb_enc_ctas.tta_cod_empresa     = estabelec.ep-codigo         
                                                  AND b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig    = "ACR"                       
                                                  AND b-tt_item_integr_apb_enc_ctas.tta_cod_estab       = tit_acr.cod_estab           
                                                  AND b-tt_item_integr_apb_enc_ctas.tta_cod_espec_docto = tit_acr.cod_espec_docto     
                                                  AND b-tt_item_integr_apb_enc_ctas.tta_cod_ser_docto   = tit_acr.cod_ser_docto       
                                                  AND b-tt_item_integr_apb_enc_ctas.ttv_cod_tit         = tit_acr.cod_tit_acr         
                                                  AND b-tt_item_integr_apb_enc_ctas.tta_cod_parcela     = tit_acr.cod_parcela
                                                  AND b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta)
                               THEN DO:
                                   ASSIGN i-seq = i-seq + 1.
                                   CREATE b-tt_item_integr_apb_enc_ctas.
                                   ASSIGN b-tt_item_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
                                          b-tt_item_integr_apb_enc_ctas.tta_num_seq_refer             = i-seq
                                          b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "ACR"
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_estab                 = tit_acr.cod_estab
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           = tit_acr.cod_espec_docto
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             = tit_acr.cod_ser_docto
                                          b-tt_item_integr_apb_enc_ctas.ttv_cod_tit                   = tit_acr.cod_tit_acr
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_parcela               = tit_acr.cod_parcela
                                          b-tt_item_integr_apb_enc_ctas.tta_val_pagto                 = tit_acr.val_sdo_tit_acr
                                          b-tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      = 1
                                          b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
                                          b-tt_item_integr_apb_enc_ctas.tta_des_text_histor           = "Pagamento Encontro de Contas - Acordo Comercial"       
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_portador              = "999"
                                          b-tt_item_integr_apb_enc_ctas.tta_cod_cart_bcia             = "90".
                               END.
                           END.
                      END.
                 END.

                 ASSIGN b-acordo.num-id-titulo = tit_ap.num_id_tit_ap
                        b-acordo.tipo-titulo   = 0.
                 
                 IF b-acordo.nr-nota-dev = "" THEN DO:
                     IF de-dev <> 0 THEN DO:
                         IF b-acordo.saldo > de-dev THEN
                             ASSIGN b-acordo.saldo = b-acordo.saldo - de-dev
                                    de-dev  = 0.
                         ELSE 
                             ASSIGN de-dev  = de-dev - b-acordo.saldo
                                    b-acordo.saldo = 0.
                     END.
                 END.
            END.

            IF  CAN-FIND (FIRST b-tt_item_integr_apb_enc_ctas
                              WHERE b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta)  THEN DO:
                /*-----------------------------------------------------*/
                /*            RELACIONAMENTO DO TÖTULOS APB            */
                /*-----------------------------------------------------*/    
                CREATE b-tt_item_integr_apb_enc_ctas.
                ASSIGN b-tt_item_integr_apb_enc_ctas.tta_cod_empresa               = estabelec.ep-codigo
                       b-tt_item_integr_apb_enc_ctas.tta_num_seq_refer             = 1
                       b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "APB"
                       b-tt_item_integr_apb_enc_ctas.tta_cod_estab                 = estabelec.cod-estabel
                       b-tt_item_integr_apb_enc_ctas.tta_cod_espec_docto           = tit_ap.cod_espec_docto
                       b-tt_item_integr_apb_enc_ctas.tta_cod_ser_docto             = "U"
                       b-tt_item_integr_apb_enc_ctas.ttv_cod_tit                   = tit_ap.cod_tit_ap
                       b-tt_item_integr_apb_enc_ctas.tta_cod_parcela               = tit_ap.cod_parcela
                       b-tt_item_integr_apb_enc_ctas.tta_val_pagto                 = tit_ap.val_sdo_tit_ap
                       b-tt_item_integr_apb_enc_ctas.tta_val_cotac_indic_econ      = 1
                       b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
                       b-tt_item_integr_apb_enc_ctas.tta_des_text_histor           = "Pagamento Encontro de Contas - Acordo Comercial. " + STRING(tit_ap.num_id_tit_ap)
                       b-tt_item_integr_apb_enc_ctas.ttv_cod_empresa_ext           = string(tit_ap.num_id_tit_ap).
            END.
            ELSE DO:
                DELETE b-tt_dados_integr_apb_enc_ctas.
            END.

        END.
        ELSE DO:
            PUT UNFORMATTED "Ocorreu erro" AT 67.
            CREATE tt-erros-encontrados.
            ASSIGN tt-erros-encontrados.matriz   = acordo-fatur.matriz
                   tt-erros-encontrados.cod-erro = 17006
                   tt-erros-encontrados.mensagem = "Titulo nÆo encontrado: " + c-cod-tit-ap + " - " + c-parcela.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-gera-ava:
    DEFINE VARIABLE l-tit-orig-aqui AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-seq-movto     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tempo         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-titulo-sel AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-baixa         AS DECIMAL     NO-UNDO.

    RUN pi-zera-tabelas.

    ASSIGN i-num-titulo-sel = 0.

    FIND FIRST b-acordo NO-LOCK
         WHERE b-acordo.num-id-titulo = tt-devol.num-id-tit NO-ERROR.
    IF AVAIL b-acordo THEN DO:
        FOR EACH tit_ap NO-LOCK
           WHERE tit_ap.cod_estab     = b-acordo.cod-estabel
             AND tit_ap.num_id_tit_ap = b-acordo.num-id-titulo
             AND tit_ap.val_sdo_tit_ap >= de-dev,
            EACH val_tit_ap OF tit_ap NO-LOCK
           WHERE val_tit_ap.cod_unid_negoc = acordo-fatur.cod-unid-neg
             AND val_tit_ap.val_sdo_tit_ap >= de-dev:
            ASSIGN i-num-titulo-sel = tit_ap.num_id_tit_ap.
            LEAVE.
        END.
    END.
        
    IF  i-num-titulo-sel = 0 
    AND acordo-fatur.cod-estabel <> c-estab-exc /* ** Tratamento para desconsiderar as VAs de Verba Extra que sÆo geradas somente no estabelecimento 101, isto por nÆo haver faturamento no 101, quando voltar a ter ser  necess rio revisar esta regra ***/
    THEN DO:
         FOR EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab       = acordo-fatur.cod-estabel
              AND tit_ap.cdn_fornecedor  = acordo-fatur.matriz
              AND tit_ap.cod_espec_docto = "VA"
              AND tit_ap.cod_ser_docto   = "U"
              AND tit_ap.val_sdo_tit_ap >= de-dev,
             EACH val_tit_ap OF tit_ap NO-LOCK
            WHERE val_tit_ap.cod_unid_negoc = acordo-fatur.cod-unid-neg
              AND val_tit_ap.val_sdo_tit_ap >= de-dev:
             ASSIGN i-num-titulo-sel = tit_ap.num_id_tit_ap.
             LEAVE.
         END.
    END.

    IF i-num-titulo-sel = 0 THEN DO:
        PUT UNFORMATTED "Pendente" AT 67.
        CREATE tt-erros-encontrados.
        ASSIGN tt-erros-encontrados.matriz   = acordo-fatur.matriz
               tt-erros-encontrados.cod-erro = 17006
               tt-erros-encontrados.mensagem = "NÆo encontrado titulo contas a pagar para descontar devolu‡äes no valor de: " + TRIM(STRING(de-dev,"->>>,>>>,>>9.99")).
        RETURN "NOK".
    END.
    ELSE DO:
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.num_id_tit_ap = i-num-titulo-sel NO-ERROR.
        IF NOT AVAIL tit_ap THEN DO:
            PUT UNFORMATTED "Pendente" AT 67.
            CREATE tt-erros-encontrados.
            ASSIGN tt-erros-encontrados.matriz   = acordo-fatur.matriz
                   tt-erros-encontrados.cod-erro = 17006
                   tt-erros-encontrados.mensagem = "Titulo encontrado contas a pagar para descontar devolu‡äes nÆo existe ou valor ‚ inferior.".
            RETURN "NOK".
        END.
    END.

    /*busca referencia*/
    ASSIGN c-refer = "".
    RUN pi-busca-referencia (INPUT "VACD",
                             INPUT acordo-fatur.cod-estabel,
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
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = p-dt-faturam
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = tit_ap.val_sdo_tit_ap - de-dev
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
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "altera‡Æo"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = "Acerto efetuado via sistema, devolu‡äes referente nota: " + tt-devol.nr-nota-dev
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.
           
    run pi-acompanhar in h-acomp (INPUT "Matriz: " + STRING(acordo-fatur.matriz) + " - Unid: " + STRING(acordo-fatur.cod-unid-neg) + " - Valor: " + TRIM(STRING(de-dev * -1,"->>>,>>>,>>9.99"))).
    run prgfin/apb/apb767ze.py(input 1,
                               input "",
                               INPUT "",
                               input-output table tt_tit_ap_alteracao_base_aux_1,
                               input-output table tt_tit_ap_alteracao_rateio,
                               output table tt_log_erros_tit_ap_alteracao).

    FIND FIRST tt_log_erros_tit_ap_alteracao 
         WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6542 NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN
        DELETE tt_log_erros_tit_ap_alteracao.

    IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao NO-LOCK) THEN DO:
        PUT UNFORMATTED "Ocorreu erro" AT 67.
        FOR EACH tt_log_erros_tit_ap_alteracao:
            CREATE tt-erros-encontrados.
            ASSIGN tt-erros-encontrados.matriz   = acordo-fatur.matriz
                   tt-erros-encontrados.cod-erro = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                   tt-erros-encontrados.mensagem = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro + " - " + tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda.
        END.
    END.
    ELSE DO:
        ASSIGN l-tit-orig-aqui = NO.
        FIND FIRST b-acordo NO-LOCK
             WHERE b-acordo.cod-estabel   = acordo-fatur.cod-estabel
               AND b-acordo.num-id-titulo = tit_ap.num_id_tit_ap 
               AND b-acordo.cod-unid-neg  = acordo-fatur.cod-unid-neg
               AND b-acordo.periodo       = acordo-fatur.periodo
               AND b-acordo.tipo-titulo   = 0 NO-ERROR.
        IF AVAIL b-acordo THEN
            ASSIGN l-tit-orig-aqui = YES.    

        ASSIGN i-seq-movto = NEXT-VALUE(seq_movto_acordo)
               i-tempo     = TIME.

        IF l-tit-orig-aqui THEN DO:

            /*zerando devolu‡Æo pela nota*/
            FOR EACH b-acordo EXCLUSIVE-LOCK
               WHERE b-acordo.cod-estabel   = bd-acordo.cod-estabel
                 AND b-acordo.matriz        = bd-acordo.matriz
                 AND b-acordo.cod-unid-neg  = bd-acordo.cod-unid-neg
                 AND b-acordo.nr-nota-fis   = bd-acordo.nr-nota-fis
                 AND b-acordo.periodo       = bd-acordo.periodo
                 AND b-acordo.saldo <> 0
                 AND (b-acordo.num-id-titulo = i-num-titulo-sel OR 
                      b-acordo.num-id-titulo = 0):

                IF b-acordo.nr-nota-dev = "" THEN DO:
                    IF de-dev <> 0 THEN DO:
                        IF b-acordo.saldo > de-dev THEN DO:
                            ASSIGN b-acordo.saldo = b-acordo.saldo - de-dev
                                   de-dev  = 0.
                        END.
                        ELSE DO:
                            ASSIGN de-dev  = de-dev - b-acordo.saldo
                                   b-acordo.saldo = 0.
                        END.
                    END.
                END.
                ELSE DO:
                    IF b-acordo.num-id-titulo = 0 THEN DO:
                        ASSIGN b-acordo.num-id-titulo = tit_ap.num_id_tit_ap
                               b-acordo.tipo-titulo   = IF l-tit-orig-aqui THEN 2 ELSE 1.

                        IF l-tit-orig-aqui THEN DO:
                            CREATE movto-acordo-fatur.
                            ASSIGN movto-acordo-fatur.num-id-movto  = i-seq-movto
                                   movto-acordo-fatur.num-id-fatur  = b-acordo.num-id-fatur
                                   movto-acordo-fatur.num-id-titulo = b-acordo.num-id-titulo
                                   movto-acordo-fatur.data          = p-dt-faturam
                                   movto-acordo-fatur.hora          = STRING(i-tempo,"HH:MM:SS")
                                   movto-acordo-fatur.usuario       = "devol"
                                   movto-acordo-fatur.valor         = b-acordo.saldo * -1
                                   movto-acordo-fatur.observacoes   = "Referente devolu‡Æo nota: " + tt-devol.nr-nota-dev.
                        END.
                        ASSIGN b-acordo.saldo = 0.
                    END.
                END.
            END.

            IF de-dev <> 0 THEN DO:
                /*zerando devolu‡Æo*/
                FOR EACH b-acordo EXCLUSIVE-LOCK
                   WHERE b-acordo.cod-estabel   = bd-acordo.cod-estabel
                     AND b-acordo.matriz        = bd-acordo.matriz
                     AND b-acordo.cod-unid-neg  = bd-acordo.cod-unid-neg
                     AND b-acordo.periodo       = bd-acordo.periodo
                     AND b-acordo.saldo         <> 0
                     AND b-acordo.num-id-titulo = i-num-titulo-sel:

                    IF b-acordo.nr-nota-dev = "" THEN DO:
                        IF de-dev <> 0 THEN DO:
                            IF b-acordo.saldo > de-dev THEN DO:
                                ASSIGN b-acordo.saldo = b-acordo.saldo - de-dev
                                       de-dev  = 0.
                            END.
                            ELSE DO:
                                ASSIGN de-dev  = de-dev - b-acordo.saldo
                                       b-acordo.saldo = 0.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF b-acordo.num-id-titulo = 0 THEN DO:
                            ASSIGN b-acordo.num-id-titulo = tit_ap.num_id_tit_ap
                                   b-acordo.tipo-titulo   = IF l-tit-orig-aqui THEN 2 ELSE 1.

                            IF l-tit-orig-aqui THEN DO:
                                CREATE movto-acordo-fatur.
                                ASSIGN movto-acordo-fatur.num-id-movto  = i-seq-movto
                                       movto-acordo-fatur.num-id-fatur  = b-acordo.num-id-fatur
                                       movto-acordo-fatur.num-id-titulo = b-acordo.num-id-titulo
                                       movto-acordo-fatur.data          = p-dt-faturam
                                       movto-acordo-fatur.hora          = STRING(i-tempo,"HH:MM:SS")
                                       movto-acordo-fatur.usuario       = "devol"
                                       movto-acordo-fatur.valor         = b-acordo.saldo * -1
                                       movto-acordo-fatur.observacoes   = "Referente devolu‡Æo nota: " + bd-acordo.nr-nota-dev.
                            END.
                            ASSIGN b-acordo.saldo = 0.
                        END.
                    END.
                END.
            END.
        END.

        PUT UNFORMATTED "Acerto Valor: " + tit_ap.cod_tit_ap + " - Nota: " + tt-devol.nr-nota-fis + " - Valor: " + TRIM(STRING(tt-devol.valor * -1,"->>>,>>>,>>9.99")) AT 68 SKIP.
    END.

    RETURN "OK".

END PROCEDURE.


PROCEDURE pi-gera-encontro-ctas:
    DEFINE VARIABLE de-maior-acr      AS DEC         NO-UNDO.
    DEFINE VARIABLE de-total-acr      AS DEC         NO-UNDO.
    DEFINE VARIABLE r-maior-acr       AS ROWID       NO-UNDO.
    DEFINE VARIABLE de-tot-pos-rateio AS DEC         NO-UNDO.
    DEFINE VARIABLE de-saldos-acordos AS DEC         NO-UNDO.
    DEFINE VARIABLE i-seq-movto       AS INTEGER     NO-UNDO.
    
    PAGE.
    PUT SKIP(2) "---------------- ENCONTRO DE CONTAS  ------------------ " SKIP(1).
    
    /*Para cada capa de lote*/
    FOR EACH b-tt_dados_integr_apb_enc_ctas:
        
        EMPTY TEMP-TABLE tt-aux-apb-acr.
        EMPTY TEMP-TABLE tt-aux-capa-lote.

        CREATE tt-aux-capa-lote.
        BUFFER-COPY  b-tt_dados_integr_apb_enc_ctas TO tt-aux-capa-lote.

        /* Posicionar o t¡tulo do AP criadd */
        FOR FIRST b-APB-tt_item_integr_apb_enc_cta
            WHERE b-APB-tt_item_integr_apb_enc_cta.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
              AND b-APB-tt_item_integr_apb_enc_cta.ttv_ind_tit_orig              = "APB":

            ASSIGN de-tot-pos-rateio = 0
                   de-total-acr      = 0
                   de-maior-acr      = 0
                   r-maior-acr       = ?
                   de-saldos-acordos = 0.

            FOR EACH acordo-fatur EXCLUSIVE-LOCK
               WHERE acordo-fatur.num-id-titulo = int(entry(2, b-APB-tt_item_integr_apb_enc_cta.tta_des_text_histor, ". "))
                 AND acordo-fatur.periodo       = c-periodo:
                
                 IF CAN-FIND (FIRST tit_acr NO-LOCK
                              WHERE tit_acr.cod_estab   = acordo-fatur.cod-estab
                                AND tit_acr.cod_espec   = "DM"
                                AND tit_acr.cod_ser     = acordo-fatur.serie
                                AND tit_acr.cod_tit_acr = acordo-fatur.nr-nota-fis
                                AND NOT (tit_acr.log_sdo_tit_acr OR tit_acr.log_tit_acr_estordo)
                                AND tit_acr.cod_portador = "9915") THEN
                     NEXT.
                
                ASSIGN de-saldos-acordos = de-saldos-acordos + acordo-fatur.saldo.
            END.

            ASSIGN   b-APB-tt_item_integr_apb_enc_cta.tta_val_pagto = de-saldos-acordos.
            
            /* Ler ACR para verificar o valor total, a maior parcela e o rowid da maior parcela para o rateio*/
            FOR EACH b-tt_item_integr_apb_enc_ctas
                WHERE b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
                  AND b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "ACR":

                ASSIGN de-total-acr = de-total-acr + b-tt_item_integr_apb_enc_ctas.tta_val_pagto.

                IF  de-maior-acr < b-tt_item_integr_apb_enc_ctas.tta_val_pagto THEN
                    ASSIGN de-maior-acr = b-tt_item_integr_apb_enc_ctas.tta_val_pagto
                           r-maior-acr  = ROWID(b-tt_item_integr_apb_enc_ctas).

            END.

            /* FAZER A PROPOR€ÇO */
            FOR EACH b-tt_item_integr_apb_enc_ctas
                WHERE b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta
                  AND b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "ACR":
                
                ASSIGN b-tt_item_integr_apb_enc_ctas.tta_val_pagto = (b-tt_item_integr_apb_enc_ctas.tta_val_pagto * de-saldos-acordos) /  de-total-acr
                       de-tot-pos-rateio = de-tot-pos-rateio + b-tt_item_integr_apb_enc_ctas.tta_val_pagto.
            END.

            FIND FIRST b-tt_item_integr_apb_enc_ctas
                WHERE rowid(b-tt_item_integr_apb_enc_ctas) = r-maior-acr NO-ERROR.

            IF  AVAIL b-tt_item_integr_apb_enc_ctas THEN DO:

                IF  de-tot-pos-rateio > de-saldos-acordos THEN
                    b-tt_item_integr_apb_enc_ctas.tta_val_pagto = b-tt_item_integr_apb_enc_ctas.tta_val_pagto - (de-tot-pos-rateio - de-saldos-acordos).

                IF  de-tot-pos-rateio < de-saldos-acordos THEN
                    b-tt_item_integr_apb_enc_ctas.tta_val_pagto = b-tt_item_integr_apb_enc_ctas.tta_val_pagto + (de-saldos-acordos - de-tot-pos-rateio).
            END.

            FOR EACH b-tt_item_integr_apb_enc_ctas
                WHERE b-tt_item_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta = b-tt_dados_integr_apb_enc_ctas.ttv_rec_integr_apb_enctro_cta      
                  AND b-tt_item_integr_apb_enc_ctas.ttv_ind_tit_orig              = "ACR":                                                            
                CREATE tt-aux-apb-acr.
                BUFFER-COPY  b-tt_item_integr_apb_enc_ctas TO tt-aux-apb-acr. 

            END.

            CREATE tt-aux-apb-acr.
            BUFFER-COPY b-APB-tt_item_integr_apb_enc_cta TO tt-aux-apb-acr.

        END.

        /* INTEGRAR O ENCONTRO DE CONTAS */
        DO TRANS:
            ASSIGN v_des_contdo_prog_valid_dtsul = "esftp050rp1".
    
            RUN prgfin/apb/apb944za.py PERSISTENT SET v_hapb944za.
            RUN pi_main_api_enctro_cta_apb_acr_ems5_2 IN v_hapb944za (INPUT 1, INPUT TABLE tt-aux-capa-lote, INPUT TABLE tt-aux-apb-acr, INPUT "", OUTPUT TABLE b-tt_log_integr_apb_enc_ctas,  OUTPUT TABLE b-tt_tit_acr_info, INPUT NO).
            DELETE PROCEDURE v_hapb944za.
            ASSIGN v_des_contdo_prog_valid_dtsul = "".
    
            /* VERIFICA SE REALMENTE CONSEGUIU GRAVAR O LOTE */
            FOR FIRST enctro_cta NO-LOCK
                WHERE enctro_cta.cod_estab = b-tt_dados_integr_apb_enc_ctas.tta_cod_estab_refer
                  AND enctro_cta.cod_refer = b-tt_dados_integr_apb_enc_ctas.tta_cod_refer:
    
                FOR EACH acordo-fatur EXCLUSIVE-LOCK
                   WHERE acordo-fatur.num-id-titulo = int(entry(2, b-APB-tt_item_integr_apb_enc_cta.tta_des_text_histor, ". "))
                     AND acordo-fatur.periodo       = c-periodo:
                    
                    IF CAN-FIND (FIRST tit_acr NO-LOCK
                                 WHERE tit_acr.cod_estab   = acordo-fatur.cod-estab
                                   AND tit_acr.cod_espec   = "DM"
                                   AND tit_acr.cod_ser     = acordo-fatur.serie
                                   AND tit_acr.cod_tit_acr = acordo-fatur.nr-nota-fis
                                   AND NOT (tit_acr.log_sdo_tit_acr OR tit_acr.log_tit_acr_estordo)
                                   AND tit_acr.cod_portador = "9915") THEN
                        NEXT.
                    
                    IF  acordo-fatur.saldo > 0  THEN DO:
                        ASSIGN i-seq-movto = NEXT-VALUE(seq_movto_acordo).
                        
                        CREATE movto-acordo-fatur.
                        ASSIGN movto-acordo-fatur.num-id-movto  = i-seq-movto
                               movto-acordo-fatur.num-id-fatur  = acordo-fatur.num-id-fatur
                               movto-acordo-fatur.num-id-titulo = acordo-fatur.num-id-titulo
                               movto-acordo-fatur.data          = p-dt-faturam
                               movto-acordo-fatur.hora          = STRING(TIME,"HH:MM:SS")
                               movto-acordo-fatur.usuario       = c-seg-usuario
                               movto-acordo-fatur.valor         = acordo-fatur.saldo
                               movto-acordo-fatur.observacoes   = "Referete Encontro de contas estab: " + enctro_cta.cod_estab + ", Refer " + enctro_cta.cod_refer.
                    END.
                    ASSIGN acordo-fatur.saldo = 0.
                END.

                PUT UNFORMATTED SKIP(1) "MATRIZ: "  STRING(b-tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor)  
                                        "  TÖTULO APB: " b-APB-tt_item_integr_apb_enc_cta.ttv_cod_tit 
                                        " / Encontro Contas: " enctro_cta.cod_estab " - "  enctro_cta.cod_refer
                                        " / TOTAL: " string(de-saldos-acordos, ">,>>>,>>9.99") SKIP(1).

                PUT SKIP(1) "Estab    Esp‚cie  S‚rie    T¡tulo   Parcela  Pagamento  " SKIP. 
                PUT         "-------  -------  -------  -------  -------  -----------" SKIP. 
                FOR EACH tt-aux-apb-acr
                    WHERE tt-aux-apb-acr.ttv_ind_tit_orig  = "ACR":
                    PUT UNFORMATTED STRING(tt-aux-apb-acr.tta_cod_estab)       "      " 
                                    STRING(tt-aux-apb-acr.tta_cod_espec_docto) "       "
                                    STRING(tt-aux-apb-acr.tta_cod_ser_docto)   "       "
                                    STRING(tt-aux-apb-acr.ttv_cod_tit )        "  "
                                    STRING(tt-aux-apb-acr.tta_cod_parcela)     "       "
                                    STRING(tt-aux-apb-acr.tta_val_pagto, ">,>>>,>>9.99") TO 56      SKIP.
                END.
                PUT SKIP(2).
            END.
            
            FOR EACH b-tt_log_integr_apb_enc_ctas:
                CREATE tt-erros-encontrados.
                ASSIGN tt-erros-encontrados.matriz   = b-tt_dados_integr_apb_enc_ctas.tta_cdn_fornecedor
                       tt-erros-encontrados.cod-erro = b-tt_log_integr_apb_enc_ctas.ttv_num_cod_erro
                       tt-erros-encontrados.mensagem = b-tt_log_integr_apb_enc_ctas.ttv_des_msg_erro + " - " + b-tt_log_integr_apb_enc_ctas.ttv_des_msg_ajuda.
            END.
    
        END.
    END.
END.

PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer      AS CHARACTER NO-UNDO.

    def var v_log_refer_uni
        as logical
        format "Sim/N’o"
        initial yes
        no-undo.

    def var v_cod_refer
        as character
        format "x(10)":U
        label "Refer¼ncia"
        column-label "Refer¼ncia"
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
