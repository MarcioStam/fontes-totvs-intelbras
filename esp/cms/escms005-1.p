/******************************************************************************
** Programa: 
** Data....: Maráo/2005
** Autor...: Maria Ester - Gestech.
** Objetivo: Gera Titulo de previs∆o e provisao de comiss‰es para o APB - CPE/CPO
** Versao..: Esse programa Ç uma c¢pia do ESCMS002.P com a tratamento do acordo comercial
******************************************************************************/

/* Temporary Tables Definitions - vari†veis utilizadas na API*/
{esp/cms/apb767zc.i}
{esp/cms/apb768za.i}
{esp/cms/apb900zd.i}

DEF INPUT PARAM rmovto_repres_tit_acr   AS RECID.  /*Recid do movto_tit_acr ou do repres_tit_acr*/
DEF INPUT PARAM p-cta-aprop-acr         LIKE aprop_ctbl_acr.cod_cta_ctbl. /*Conta da apropriaá∆o contabil*/
DEF INPUT PARAM c_ind_trans_acr_abrev   LIKE movto_tit_acr.ind_trans_acr_abrev. /* Indica o ponto de onde Ç chamado a rotina*/

DEF VAR c-ser-docto  LIKE tit_ap.cod_ser_docto.

/*receber tiPo de transaá∆o, "AVMN" ou "AVMA"*/
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

/* variables Definitions */
DEF VAR c_lista_trans              AS CHAR INIT "AVMN"                                               NO-UNDO.
DEF VAR v_val_sdo_tit_ap           LIKE tit_ap.val_sdo_tit_ap                                        NO-UNDO.
DEF VAR v-vlr-movto                LIKE movto_tit_acr.val_movto_tit_acr                              NO-UNDO. 
DEF VAR v-fator-comis              AS DEC                                                            NO-UNDO.
DEF VAR l_erro                     AS LOG                                                            NO-UNDO.
DEF VAR l_vendor                   AS LOG  INIT NO                                                   NO-UNDO.
DEF VAR v_log_livre_1              AS CHAR  NO-UNDO.
DEF VAR l_imprime_erro             AS LOG                                                            NO-UNDO.
DEF VAR c_desc_erro                AS CHAR FORMAT "x(60)"                                            NO-UNDO.
DEF VAR v_num_aux_2                AS   INT.
DEF VAR v_num_aux                  AS   INT.
DEF VAR v_cod_refer_antec          LIKE movto_tit_ap.cod_refer.
DEF VAR v_cod_refer_impl           LIKE movto_tit_ap.cod_refer.
DEF VAR v_num_cont                 AS   INT.
DEF VAR v_data_trans               LIKE movto_tit_acr.dat_transacao                                  NO-UNDO.
DEF VAR v-vlr-comissao             LIKE movto_tit_acr.val_movto_tit_acr                              NO-UNDO. 
DEF VAR v_val_dif_comis            LIKE movto_tit_acr.val_movto_tit_acr                              NO-UNDO. 
DEF VAR v-acordo-com-perc          AS DECIMAL                                                        NO-UNDO.
DEF VAR v_seq_tit_cpo              AS INT  FORMAT "99"                                               NO-UNDO.
DEF VAR v_cod_tit_cpo              AS CHAR FORMAT "x(12)"                                            NO-UNDO.
DEF VAR v_num_seq                  AS INTEGER                                                        NO-UNDO.
DEF VAR v_num_refer                AS INTEGER                                                        NO-UNDO.
DEF VAR v_cod_refer_cpo            LIKE movto_tit_acr.num_id_movto_tit_acr                           NO-UNDO.
DEF VAR v_cod_plano_cta_ctbl       LIKE param_estab_comis.cod_plano_cta_ctbl                         NO-UNDO.
DEF VAR v_cod_cta_ctbl             LIKE param_estab_comis.cod_cta_ctbl                               NO-UNDO.
DEF VAR v_cod_tip_fluxo_financ     LIKE param_estab_comis.cod_tip_fluxo_financ_ap                    NO-UNDO.

DEF TEMP-TABLE tt_erro
     FIELD cod_estab               LIKE tit_acr.cod_estab                        
     FIELD cod_especie             LIKE tit_acr.cod_espec_docto                        
     FIELD serie                   LIKE tit_acr.cod_ser_docto                              
     FIELD cod_tit_acr             LIKE tit_acr.cod_tit_acr                              
     FIELD cod_parcela             LIKE tit_acr.cod_parcela                              
     FIELD cdn_repres              LIKE tit_acr.cdn_repres                               
     FIELD nom_repres              LIKE representante.nom_abrev                          
     FIELD dat_transacao           LIKE movto_tit_acr.dat_transacao                      
     FIELD trans_abrev             LIKE movto_tit_acr.ind_trans_acr_abrev  
     FIELD cod_refer               LIKE movto_tit_acr.num_id_movto_tit_acr
     FIELD vlr_trans               LIKE movto_tit_acr.val_movto_tit_acr 
     FIELD mensagem                AS CHAR FORMAT "x(145)". 

DEF BUFFER btit_acr FOR tit_acr .

RUN Pi_zera_temp_table_api.

/*Chamada da UPC do repres_tit_acr, troca % de comiss∆o */

/*eliminar no futuro Maria Ester 21/03/2005 */
IF c_ind_trans_acr_abrev <> "" THEN DO:
  FIND FIRST repres_tit_acr NO-LOCK
       WHERE RECID(repres_tit_acr) = rmovto_repres_tit_acr NO-ERROR. /*recid repres_tit_acr*/

  FIND FIRST tit_acr NO-LOCK
       WHERE tit_acr.cod_estab = repres_tit_acr.cod_estab 
         AND tit_acr.num_id_tit_acr = repres_tit_acr.num_id_tit_acr NO-ERROR. 
  
END.
ELSE DO: /*Chamada diretamente do movto_tit_acr*/
  FIND FIRST movto_tit_acr 
       WHERE RECID(movto_tit_acr) = rmovto_repres_tit_acr NO-LOCK NO-ERROR.

  /*Pesquisa tit_acr correspondente a movimentaá∆o */
  FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.

END.

ASSIGN l_erro          = NO
       l_imprime_erro  = NO
       l_vendor        = NO
       v-fator-comis   = 0
       v-vlr-movto     = 0
       v-vlr-comissao  = 0
       v_cod_refer_impl = ""
       v-acordo-com-perc = 0.

/* atualiza o c¢digo da conta cont†bil do cadastro de comiss∆o ACR utilizado para criar a CPO */
FIND FIRST param_estab_comis NO-LOCK
    WHERE param_estab_comis.dat_inic_valid < TODAY
      AND param_estab_comis.dat_fim_valid  > TODAY NO-ERROR.
IF AVAIL param_estab_comis THEN DO:
  ASSIGN v_cod_plano_cta_ctbl   = param_estab_comis.cod_plano_cta_ctbl
         v_cod_cta_ctbl         = param_estab_comis.cod_cta_ctbl
         v_cod_tip_fluxo_financ = param_estab_comis.cod_tip_fluxo_financ_ap.
END.

RUN pi-calc-comis-acordo-com (output v-acordo-com-perc).

/* bloco:
DO TRANSACTION ON ERROR UNDO, LEAVE:
   */ 
    /*valida portador*/
    FIND FIRST int-portador NO-LOCK
         WHERE int-portador.cod_portador = tit_acr.cod_portador
           AND int-portador.log_considera_comissao = YES NO-ERROR.
    IF NOT AVAIL int-portador THEN
      LEAVE.
    
    /*valida especie */
    FIND FIRST int_espec_docto_financ_acr NO-LOCK
         WHERE int_espec_docto_financ_acr.cod_espec_docto = tit_acr.cod_espec_docto
           AND int_espec_docto_financ_acr.log_gera_comissao = YES NO-ERROR.
    IF NOT AVAIL int_espec_docto_financ_acr THEN
       LEAVE.
    
    IF c_ind_trans_acr_abrev <> "" THEN DO:
       RUN pi-troca-perc-comis.
    END.
    ELSE DO:
      /*Pesquisa Titulos do Contas a Receber que possuem comiss∆o*/
      RUN Pi-Tit-acr.
    END.

    /*Verifca se houve erro de validaá∆o */
    FIND FIRST tt_erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt_erro THEN DO:
      /*Executa API*/
      RUN Pi-roda-api.
    END.
    ELSE
       ASSIGN l_imprime_erro = YES.

    /*Imprime erros ocorridos durante o processamento*/
    IF l_imprime_erro THEN DO:
       FOR EACH tt_log_erros_atualiz  NO-LOCK:
           MESSAGE 'ESCMS005 - Erro'
                   'tt_log_erros_atualiz.ttv_num_mensagem  ' tt_log_erros_atualiz.ttv_num_mensagem  SKIP
                   'tt_log_erros_atualiz.ttv_des_msg_erro  ' tt_log_erros_atualiz.ttv_des_msg_erro  SKIP
                   'tt_log_erros_atualiz.ttv_des_msg_ajuda ' tt_log_erros_atualiz.ttv_des_msg_ajuda SKIP VIEW-AS ALERT-BOX.
      END.

      RUN esp/cms/escms004.p (INPUT TABLE tt_erro,
                              INPUT TABLE tt_log_erros_atualiz,
                              INPUT TABLE tt_log_erros_tit_ap_alteracao,
                              INPUT TABLE tt_log_erros_estorn_cancel_apb).
      FOR EACH tt_log_erros_tit_ap_alteracao  NO-LOCK:
          MESSAGE 'ESCMS005 - Erro'
                  'tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  ' tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  SKIP
                  'tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  ' tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  SKIP
                  'tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda ' tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda SKIP VIEW-AS ALERT-BOX.
     END.

     RUN esp/cms/escms004.p (INPUT TABLE tt_erro,
                             INPUT TABLE tt_log_erros_atualiz,
                             INPUT TABLE tt_log_erros_tit_ap_alteracao,
                             INPUT TABLE tt_log_erros_estorn_cancel_apb).
     LEAVE.
    
    END.
    RUN Pi_zera_temp_table_api.

/* END. /*do transaction*/
   */
RETURN "OK":U.

/* Internal Procedures Definitions */
/*Essa procedure Ç executada a apartir da chamada direto da UPC  do movto_tit_acr*/

PROCEDURE Pi-Tit-Acr.

   IF LOOKUP(movto_tit_acr.ind_trans_acr_abrev,c_lista_trans) <> 0 THEN DO:
      /*Tratamento para espÇcie em VENDOR*/   
      IF movto_tit_acr.cod_espec_docto = "VE" OR  movto_tit_acr.cod_espec_docto = "VD" THEN
        ASSIGN l_vendor = YES.

      /*Pesquisa o percetual de comissÉo do representante */
      FOR EACH repres_tit_acr NO-LOCK
         WHERE repres_tit_acr.cod_estab             = tit_acr.cod_estab 
           AND repres_tit_acr.num_id_tit_acr        = tit_acr.num_id_tit_acr
           AND repres_tit_acr.val_perc_comis_repres > 0,
         FIRST representante NO-LOCK
         WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
           AND representante.cdn_repres  = repres_tit_acr.cdn_repres:
                
          FIND FIRST repres_financ OF representante NO-LOCK
             WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.

          IF AVAIL repres_financ THEN
             NEXT.
        /*Valida representante x fornecedor x fornec_financ e tit_ap */
        RUN pi_valida.

        /*Tratamento para espÇcie em VENDOR*/   
        IF l_vendor = YES THEN DO:
           RUN pi-vendor. 
        END.

        /*Calcula percentual de comiss∆o / valor comiss∆o*/
        RUN pi-valor-comis.
      
        /*Atualiza a data de transaá∆o e referencia do titulo*/
        ASSIGN v_data_trans = TODAY     /***movto_tit_acr.dat_transacao***/
             /*  v_cod_refer_impl = STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999')*/ .
                    
        /*Verifca se houve erro de validaá∆o */
        FIND FIRST tt_erro NO-LOCK NO-ERROR.

        IF NOT AVAIL tt_erro THEN DO:  /*Tratamento para acordo comercial*/
          /*IF v-acordo-com-perc <> 0 THEN
          DO:*/
            IF p-cta-aprop-acr = '41110025' OR p-cta-aprop-acr = '41110028' THEN /*conta contabil - acordo comercial*/  
            DO:
               /*Cria CPO correspondente ao acordo comercial*/                                                          
              RUN pi-cria-cpo-acordo-coml.
            END.
            ELSE DO:
              /*Cria Temp-tables da API - CPE*/
              RUN Pi-Cria-tt-api-alt.
            END.
          /*END. 
          ELSE
          DO:
             MESSAGE ' _ Pi-Cria-tt-api-alt _' VIEW-AS ALERT-BOX.
            /*Cria Temp-tables da API - CPE*/
            RUN Pi-Cria-tt-api-alt.
          END.*/
       
        END. /*tt_erro*/
      END. /*repres_tit_acr*/

    END. /*do*/
END PROCEDURE.

/*Essa procedure Ç executada a apartir da chamada direto da UPC  do representante*/
PROCEDURE pi-troca-perc-comis.
      
   FIND FIRST representante NO-LOCK
        WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
          AND representante.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.

   FIND FIRST repres_financ OF representante NO-LOCK
      WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.

   IF AVAIL repres_financ THEN
      LEAVE.

   RUN pi_valida.

   /*Calcula o valor da comiss∆o*/
   ASSIGN v-fator-comis = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
          v-vlr-movto    = tit_acr.val_sdo_tit_acr * v-fator-comis 
          v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).
   
   IF v-acordo-com-perc <> 0 THEN
       ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).

   /*Atualiza a data de transaá∆o*/
   ASSIGN v_data_trans = TODAY.
   
   /*Cria Temp-tables da API*/
   RUN Pi-Cria-tt-api-alt.
        
END PROCEDURE.

PROCEDURE pi-valor-comis.
    IF  l_vendor THEN DO:
       /* Moser - C†lculo da comiss∆o vendor com base na parcela do fechamento vendor */
        IF tit_acr.cod_espec_docto = "vd" THEN DO:
           ASSIGN v-fator-comis = btit_acr.val_liq_tit_acr / btit_acr.val_origin_tit_acr
                  v-vlr-movto    =  movto_tit_acr.val_movto_tit_acr * v-fator-comis 
                  v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).

        END.
        ELSE do: /* c†lculo de comiss∆o vendor deve pegar o valor da parcela de fechamento vendor */
            ASSIGN v-fator-comis = btit_acr.val_liq_tit_acr / btit_acr.val_origin_tit_acr
                   v-vlr-movto    = parc_vendor.val_parc_vendor_clien * v-fator-comis 
                   v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).

        END.
    END.
    ELSE DO:
       ASSIGN v-fator-comis  = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
              v-vlr-movto    = movto_tit_acr.val_movto_tit_acr * v-fator-comis
              v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).
    END.
    IF v-acordo-com-perc <> 0 THEN
       ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
END PROCEDURE.
 
PROCEDURE Pi_Valida.
    /*Pesquisa relacionamento entre fornecedor x representante*/                      
    FIND FIRST emscad.fornecedor NO-LOCK 
         WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
           AND emscad.fornecedor.num_pessoa  = representante.num_pessoa 
         USE-INDEX frncdr_empr_pessoa NO-ERROR.
    IF NOT AVAIL emscad.fornecedor THEN
    DO:
      RUN pi_Erro (INPUT "7 - Fornecedor n∆o localizado para o representante " + STRING(representante.cdn_repres)).
    END.
    
    FIND FIRST fornec_financ NO-LOCK
         WHERE fornec_financ.cod_empresa = emscad.fornecedor.cod_empresa 
           AND fornec_financ.cdn_fornecedor = emscad.fornecedor.cdn_fornecedor NO-ERROR.
    IF NOT AVAIL fornec_financ THEN
    DO:
      RUN pi_Erro (INPUT "8 - Fornecedor Financeiro n∆o localizado para o representante " + STRING(representante.cdn_repres)).
    END.
     
    /*Pesquisa se o titulo j† esta integrado no APB*/                                                                         
    IF tit_acr.cod_espec_docto = "dm" then  
       ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
    ELSE                                    
       ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
    
    FIND FIRST tit_ap NO-LOCK                                                                                                 
         WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
           AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
           AND tit_ap.cod_espec_docto = "CPE"                                                                                 
           AND tit_ap.cod_ser_docto   = c-ser-docto
           AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr                                                                   
           AND tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.                                                                   
    IF NOT AVAIL tit_ap THEN DO:
      RUN pi_erro (INPUT "9 - Previs∆o de Comiss∆o - CPE, n∆o existe para o t°tulo APB"). 
    END.
    
END PROCEDURE.

PROCEDURE pi_erro:
   DEF INPUT PARAMETER c_desc_erro AS CHAR FORMAT "x(60)" NO-UNDO.
    
   CREATE tt_erro.
   ASSIGN tt_erro.cod_estab     = tit_acr.cod_estab
          tt_erro.cod_especie   = tit_acr.cod_espec_docto
          tt_erro.serie         = tit_acr.cod_ser_Docto      
          tt_erro.cod_tit_acr   = tit_acr.cod_tit_acr
          tt_erro.cod_parcela   = tit_acr.cod_parcela
          tt_erro.cdn_repres    = repres_tit_acr.cdn_repres
          tt_erro.nom_repres    = representante.nom_abrev
          tt_erro.dat_transacao = movto_tit_acr.dat_transacao
          tt_erro.trans_abrev   = movto_tit_acr.ind_trans_acr_abrev   
          tt_erro.vlr_trans     = movto_tit_acr.val_movto_tit_acr
          tt_erro.mensagem      = c_desc_erro.

END PROCEDURE.
    
PROCEDURE pi-vendor.
   /*Identifica a DM correspondente ao Vendor*/                                                                                            

   FIND FIRST dupl_vendor NO-LOCK
       WHERE dupl_vendor.num_planilha_vendor = int(tit_acr.cod_tit_acr) NO-ERROR.

   IF AVAIL dupl_vendor THEN DO:

       /* Moser Verificar a parcela vendor para o c†lculo da comiss∆o */
       FIND FIRST parc_vendor
           WHERE parc_vendor.cod_estab           = dupl_vendor.cod_estab
             AND parc_vendor.num_planilha_vendor = dupl_vendor.num_planilha_vendor
             AND parc_vendor.cod_estab_tit_acr   = tit_acr.cod_estab
             AND parc_vendor.num_id_tit_acr      = tit_acr.num_id_tit_acr NO-ERROR.

       FIND FIRST btit_acr NO-LOCK 
          WHERE btit_acr.cod_estab      = dupl_vendor.cod_estab_tit_acr
            AND btit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
       IF AVAIL btit_acr THEN DO:
           FIND nota-fiscal NO-LOCK                                                                                                            
           WHERE nota-fiscal.cod-estabel = btit_acr.cod_estab                                                                                  
             AND nota-fiscal.serie       = btit_acr.cod_ser_docto                                                                              
             AND nota-fiscal.nr-nota-fis = btit_acr.cod_tit_acr NO-ERROR.                                                                      
           IF AVAIL nota-fiscal THEN                                                                                                           
             FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK                                                                                     
                  WHERE it-nota-fisc.it-codigo = "servicos de inst" NO-ERROR.                                                                   
       END.                                                                                                                                  
   END.                                                                                                                                    
   ELSE DO:                                                                                                                                     
     RUN pi_erro (INPUT "10 - N∆o localizou a espÇcie DM na tabela Dupl_vendor correpondente ao fechamento do Vendor - VE").                 
   END.     

END PROCEDURE.
   
PROCEDURE pi-cria-tt-api-alt:
     
     /*Calcula referencia automatica*/
     /*****
     Essa rotina foi implementada, devido um t°tulo possuir mais de um represente. 
     Ocorreu erro de duplicidade pois a referencia do tit_ap e o num_id_movto_tit_acr 
     *****/
     repeat:       
       ASSIGN v_cod_refer_impl = ''
              v_num_aux_2 = integer(this-procedure:handle)
              v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
              v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux)
              .
      
       FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK
            WHERE tt_tit_ap_alteracao_base_1.tta_cod_estab =  tit_acr.cod_estab
              AND tt_tit_ap_alteracao_base_1.ttv_cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.
      
       find first movto_tit_ap 
            where movto_tit_ap.cod_estab   = tit_acr.cod_estab 
              and movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.
       if NOT avail movto_tit_ap AND NOT AVAIL tt_tit_ap_alteracao_base_1 then 
          leave.
     end.                                       
    
      /*Pesquisa o tit_ap para enviar dados a temp-table da API - alteraá∆o da CPE conforme a transaá∆o*/
     IF tit_acr.cod_espec_docto = "dm" then  
        ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
     ELSE                                    
        ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
      
     FIND FIRST tit_ap NO-LOCK
          WHERE tit_ap.cod_estab       = tit_acr.cod_estab
            AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
            AND tit_ap.cod_espec_docto = "CPE" 
            AND tit_ap.cod_ser_docto   = c-ser-docto
            AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
            AND tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
     IF AVAIL tit_ap THEN DO:
        FIND movto_tit_ap OF tit_ap 
             WHERE SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.          
        IF AVAIL movto_tit_ap THEN 
           LEAVE.
     END.
     ELSE 
        LEAVE. 


      ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap.
        
      /*calcula valor a ser atualizado por transaá∆o */    
      RUN  pi-calcula-valor. 
      
      /*Cria temp-table com as informaá‰es dos t°tulos para alteraá∆o no APB. */    
      
      CREATE tt_tit_ap_alteracao_base_1.
      ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             =  v_cod_usuar_corren
             tt_tit_ap_alteracao_base_1.tta_cod_empresa                  =  tit_ap.cod_empresa
             tt_tit_ap_alteracao_base_1.tta_cod_estab                    =  tit_ap.cod_estab
             tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap                =  tit_ap.num_id_tit_ap
             tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                   =  RECID(tt_tit_ap_alteracao_base_1)
             tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor               =  tit_ap.cdn_fornecedor
             tt_tit_ap_alteracao_base_1.tta_cod_espec_docto              =  tit_ap.cod_espec_docto
             tt_tit_ap_alteracao_base_1.tta_cod_ser_docto                =  c-ser-docto
             tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                   =  tit_ap.cod_tit_ap
             tt_tit_ap_alteracao_base_1.tta_cod_parcela                  =  tit_ap.cod_parcela
             tt_tit_ap_alteracao_base_1.ttv_dat_transacao                =  v_data_trans
             tt_tit_ap_alteracao_base_1.ttv_cod_refer                    =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) 
             tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap               =  v_val_sdo_tit_ap 
             tt_tit_ap_alteracao_base_1.tta_dat_emis_docto               =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap            =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto               =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto                =  ?                  
             tt_tit_ap_alteracao_base_1.tta_num_dias_atraso              =  tit_ap.num_dias_atraso
             tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso        =  tit_ap.val_perc_multa_atraso
             tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso         =  tit_ap.val_juros_dia_atraso
             tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso    =  tit_ap.val_perc_juros_dia_atraso
             tt_tit_ap_alteracao_base_1.tta_dat_desconto                 =  ?
             tt_tit_ap_alteracao_base_1.tta_val_perc_desc                =  tit_ap.val_perc_desc      
             tt_tit_ap_alteracao_base_1.tta_val_desconto                 =  tit_ap.val_desconto   
             tt_tit_ap_alteracao_base_1.tta_cod_portador                 =  tit_ap.cod_portador     
             tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov             =  ""                 
             tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo             =  tit_ap.log_pagto_bloqdo
             tt_tit_ap_alteracao_base_1.tta_cod_seguradora               =  tit_ap.cod_seguradora  
             tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro              =  tit_ap.cod_apol_seguro
             tt_tit_ap_alteracao_base_1.tta_cod_arrendador               =  tit_ap.cod_arrendador   
             tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas             =  tit_ap.cod_contrat_leas  
             tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto          =  tit_ap.ind_tip_espec_docto 
             tt_tit_ap_alteracao_base_1.tta_cod_indic_econ               =  tit_ap.cod_indic_econ  
             tt_tit_ap_alteracao_base_1.tta_num_seq_refer                =  ?
             tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap   =  "Alteraá∆o"
             tt_tit_ap_alteracao_base_1.ttv_wgh_lista                    =  ?           
             tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores  =  NO                 
             tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor        =  ""
             tt_tit_ap_alteracao_base_1.tta_cod_histor_padr              =  ""
             tt_tit_ap_alteracao_base_1.tta_des_histor_padr              =  ""                 
             tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               =  tit_ap.ind_sit_tit_ap    
             tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              =  tit_ap.cod_forma_pagto   
             tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                =  "" .
            
    /*T°tulo em situaá∆o normal, ou seja chamada direto do movto_tit_acr*/
    IF c_ind_trans_acr_abrev = "" AND movto_tit_acr.ind_trans_acr_abrev = "ELIQ" THEN do: /*Estorno da Liquidaá∆o*/
      /*Elimina CPO - Provis∆o de Comiss∆o*/
      RUN pi-cria-tt-api-cancel.
    END.
    
END PROCEDURE.


PROCEDURE pi-cria-cpo-acordo-coml:
    /* Maria Ester Verifica se existe a CPE e valida valores entre valor da comiss∆o x sdo_tit_ap */
    
    IF tit_acr.cod_espec_docto = "dm" then  
       ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
    ELSE                                    
       ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
    
    FIND LAST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = tit_acr.cod_estab
           AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
           AND tit_ap.cod_espec_docto = "CPE" 
           AND tit_ap.cod_ser_docto   = c-ser-docto
           AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
           AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
           AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
    IF NOT AVAIL tit_ap THEN DO:
      RUN Pi_erro (INPUT "12 - N∆o localizou o titulo no contas a pagar, espÇcie CPE referente a DM para baixa CPE e criar CPO").
      LEAVE.   
    END.
    ELSE DO:
       IF ABS((v-vlr-comissao - tit_ap.val_sdo_tit_ap)) <= 0.03 THEN
          ASSIGN v-vlr-comissao = tit_ap.val_sdo_tit_ap.
    END.

    FIND LAST tit_ap NO-LOCK                                                                                                
        WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
          AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
          AND tit_ap.cod_espec_docto = "CPO"                                                                                 
          AND tit_ap.cod_ser_docto   = c-ser-docto
          AND SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr    
          AND tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.   
    
    IF AVAIL tit_ap THEN DO:
       ASSIGN v_seq_tit_cpo = INT(SUBSTRING(tit_ap.cod_tit_ap,09,2)) + 1.
    END.
    ELSE DO:
       ASSIGN v_seq_tit_cpo = 01.
    END.

    ASSIGN v_cod_tit_cpo = STRING(STRING(tit_acr.cod_tit_acr,'9999999') + "-" + STRING(v_seq_tit_cpo,"99")).
    
    ASSIGN v_num_seq = v_num_seq + 1
           v_num_refer = random(1,9).
         
     /*Calcula referencia automatica*/
     /*****
     Essa rotina foi implementada, devido um t°tulo possuir mais de um represente. 
     Ocorreu erro de duplicidade pois a referencia do tit_ap e o num_id_movto_tit_acr 
     *****/
     repeat:       
       ASSIGN v_cod_refer_impl = ''
              v_num_aux_2 = integer(this-procedure:handle)
              v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
              v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).

       FIND FIRST tt_integr_apb_lote_impl NO-LOCK 
            WHERE tt_integr_apb_lote_impl.tta_cod_estab_ext =  tit_acr.cod_estab 
              AND tt_integr_apb_lote_impl.tta_cod_refer     =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.
       
       FIND first movto_tit_ap 
            where movto_tit_ap.cod_estab   = tit_acr.cod_estab 
              and movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.
       if not avail movto_tit_ap AND NOT AVAIL tt_integr_apb_lote_impl then 
          leave.
     end.                                       
    
    /*Cria CPO - Provis∆o de Comiss∆o no APB*/
    CREATE tt_integr_apb_lote_impl.
    ASSIGN tt_integr_apb_lote_impl.tta_cod_refer                =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9)
           tt_integr_apb_lote_impl.tta_dat_transacao            =  TODAY
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        =  'APB'                                 
           tt_integr_apb_lote_impl.tta_cod_estab_ext            =  tit_acr.cod_estab                     
           tt_integr_apb_lote_impl.tta_val_tot_lote_impl_tit_ap =  0                                     
           tt_integr_apb_lote_impl.ttv_cod_empresa_ext          =  v_cod_empres_usuar                    
           tt_integr_apb_lote_impl.tta_cod_indic_econ           =  'Real'                                
           tt_integr_apb_lote_impl.tta_cod_espec_docto          =  'CPO'.                                
         
    CREATE tt_integr_apb_item_lote_impl_2.                                                                                                                                      
    ASSIGN tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_lote_impl  =  RECID(tt_integr_apb_lote_impl)                                                                       
           tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote  =  RECID(tt_integr_apb_item_lote_impl_2)                                                                
           tt_integr_apb_item_lote_impl_2.tta_num_seq_refer             =  v_num_seq                                /*Referencia*/
           tt_integr_apb_item_lote_impl_2.tta_cdn_fornecedor            =  fornec_financ.cdn_fornecedor             /* Fornecedor     */
           tt_integr_apb_item_lote_impl_2.tta_cod_espec_docto           =  'CPO'                                    /* EspÇcie        */
           tt_integr_apb_item_lote_impl_2.tta_cod_ser_docto             =  c-ser-docto                              /* SÇrie          */
           tt_integr_apb_item_lote_impl_2.tta_cod_tit_ap                =  v_cod_tit_cpo                            /* T°tulo parcela */
           tt_integr_apb_item_lote_impl_2.tta_cod_parcela               =  tit_acr.cod_parcela                      /* Parc           */
           tt_integr_apb_item_lote_impl_2.tta_dat_emis_docto            =  tit_acr.dat_emis_docto                   /* Dt Emiss∆o     */
           tt_integr_apb_item_lote_impl_2.tta_dat_vencto_tit_ap         =  tit_acr.dat_vencto_tit_acr               /* Dt Vencto      */
           tt_integr_apb_item_lote_impl_2.tta_dat_prev_pagto            =  tit_acr.dat_vencto_tit_acr               /* Dt Prev Pagto  */
           tt_integr_apb_item_lote_impl_2.tta_dat_desconto              =  ?                                        /* Dt Descto      */
           tt_integr_apb_item_lote_impl_2.tta_cod_indic_econ            =  'Real'                                   /* Moeda          */
           tt_integr_apb_item_lote_impl_2.tta_val_tit_ap                =  v-vlr-comissao                           /* Valor T°tulo   */
           tt_integr_apb_item_lote_impl_2.tta_val_desconto              =  0                                        /* Valor Desconto */
           tt_integr_apb_item_lote_impl_2.tta_num_dias_atraso           =  0                                        /* Dias Atr       */
           tt_integr_apb_item_lote_impl_2.tta_val_juros_dia_atraso      =  0                                        /* Vl Juro        */
           tt_integr_apb_item_lote_impl_2.tta_val_perc_juros_dia_atraso =  0                                        /* Perc Dia       */
           tt_integr_apb_item_lote_impl_2.tta_val_perc_multa_atraso     =  0                                        /* Multa Atr      */
           tt_integr_apb_item_lote_impl_2.tta_cod_portad_ext            =  '999'                                    /* Portador Externo   */
           tt_integr_apb_item_lote_impl_2.tta_cod_modalid_ext           =  "0"                                      /* Modalidade Externa */
           tt_integr_apb_item_lote_impl_2.tta_des_text_histor           =  'Provis∆o de Comiss∆o correspondente ao acordo comercial do t°tulo no ACR: ' +                          
                                                                           'Estab:' + tit_acr.cod_estab +                                                                       
                                                                           '  Esp:' + tit_acr.cod_espec_docto +  '  Sr:' + c-ser-docto +                              
                                                                           '  titulo:' + STRING(tit_acr.cod_tit_acr) + '  parc:' + tit_acr.cod_parcela +                        
                                                                           '  Cliente:' + STRING(tit_acr.cdn_cliente) + '  Repres:' + STRING(repres_tit_acr.cdn_repres).        
                                                                                                                                                                                
    CREATE tt_integr_apb_aprop_ctbl_pend.                                                                                                                                       
    ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_2)                         
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0                                                             
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0                                                             
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = v_cod_plano_cta_ctbl /* "PADRAO" moser*/                                        
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = v_cod_cta_ctbl       /* "21930005"  moser */                                         
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               = "ADM"                                                         
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   = ""                                                                   
           tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         = v_cod_tip_fluxo_financ /* '204' moser */          
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               = v-vlr-comissao                                                
           tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext     = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext             = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext         = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext               = ""                                                            
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc_ext           = "".                                                          
                                                                                                                         

    /*Baixa CPE - Previs∆o de Comiss∆o no APB*/
    CREATE tt_integr_apb_abat_prev_provis.
    ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote    = RECID(tt_integr_apb_item_lote_impl_2)
           tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend        = ? 
           tt_integr_apb_abat_prev_provis.tta_cod_estab                   = '101' 
           tt_integr_apb_abat_prev_provis.tta_cod_espec_docto             = 'CPE'
           tt_integr_apb_abat_prev_provis.tta_cod_ser_docto               = c-ser-docto 
           tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor              = fornec_financ.cdn_fornecedor
           tt_integr_apb_abat_prev_provis.tta_cod_tit_ap                  = tit_acr.cod_tit_acr    
           tt_integr_apb_abat_prev_provis.tta_cod_parcela                 = tit_acr.cod_parcela    
           tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap             = v-vlr-comissao.   /*valor da baixa do tit-acr*/

END PROCEDURE.

PROCEDURE pi-cria-tt-api-cancel:
    ASSIGN l_erro = NO.
    
    IF tit_acr.cod_espec_docto = "dm" then  
       ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
    ELSE                                    
       ASSIGN c-ser-docto = tit_acr.cod_espec_docto.

    FIND LAST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = tit_acr.cod_estab
           AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
           AND tit_ap.cod_espec_docto = "CPO" 
           AND tit_ap.cod_ser_docto   = c-ser-docto
           AND SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr    
           AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
           AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
    IF AVAIL tit_ap THEN
    DO:
      FIND FIRST movto_tit_ap OF tit_ap NO-LOCK NO-ERROR.
      IF NOT AVAIL movto_tit_ap THEN
        l_erro = YES.
    END.
    ELSE
      l_erro = YES.
        
    /*Elimina a Provis∆o de comissao*/
    IF l_erro = NO THEN
    DO:
      CREATE tt_cancelamento_estorno_apb. 
      ASSIGN ttv_ind_niv_operac_apb            = "titulo"
             ttv_ind_tip_operac_apb            = "cancelamento"
             tta_cod_estab                     = tit_ap.cod_estab                                                                         
             tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
             tta_num_id_movto_tit_ap           = movto_tit_ap.num_id_movto_tit_ap 
             tta_cod_refer                     = movto_tit_ap.cod_refer
             tta_dat_transacao                 = movto_tit_ap.dat_transacao
             tta_cod_histor_padr               = "" 
             ttv_des_histor                    = 'Cancelamento da Provis∆o de Comiss∆o, devido ao Estorno de Liquidaá∆o do t°tulo no ACR:' +
                                                 '  Estab:' + tit_acr.cod_estab + 
                                                 '  Esp:' + tit_acr.cod_espec_docto +  '  Sr:' + c-ser-docto +
                                                 '  titulo:' + STRING(tit_acr.cod_tit_acr) + '  parc:' + tit_acr.cod_parcela +
                                                 '  Cliente:' + STRING(tit_acr.cdn_cliente) + '  Repres:' + STRING(repres_tit_acr.cdn_repres)
             ttv_ind_tip_estorn                = "total"
             tta_cod_portador                  = ""
             ttv_cod_estab_reembol             = ""
             ttv_log_reaber_item               = NO 
             ttv_log_reembol                   = NO 
             ttv_log_estorn_impto_retid        = NO. 
      
      run prgfin/apb/apb768za.py (Input 1,
                                  Input table tt_cancelamento_estorno_apb,
                                  Input table tt_estornar_agrupados,
                                  output table tt_log_erros_estorn_cancel_apb,
                                  output table tt_estorna_tit_imptos,
                                  output v_log_livre_1).

         /*Valida se ocorreu erro durante o processamento*/                                                                                               
      FIND FIRST tt_log_erros_estorn_cancel_apb NO-LOCK NO-ERROR.                                                                                         
      IF AVAIL tt_log_erros_estorn_cancel_apb THEN                                                                                                        
         ASSIGN l_imprime_erro = YES.

    END. /*l_erro*/
    ELSE
    DO:
      RUN Pi_erro (INPUT "11 - N∆o localizou o titulo no contas a pagar, espÇcie CPO para efetuar o cancelamento").
    END.

END PROCEDURE.
/****
PROCEDURE Pi-baixa-cpe:
    /*Baixa CPE - Previs∆o de Comiss∆o no APB*/
    CREATE tt_integr_apb_abat_prev_provis.
    ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote    = RECID(tt_integr_apb_item_lote_impl_2)
           tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend        = ? 
           tt_integr_apb_abat_prev_provis.tta_cod_estab                   = '101' 
           tt_integr_apb_abat_prev_provis.tta_cod_espec_docto             = 'CPE'
           tt_integr_apb_abat_prev_provis.tta_cod_ser_docto               = tit_acr.cod_ser_docto 
           tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor              = fornec_financ.cdn_fornecedor
           tt_integr_apb_abat_prev_provis.tta_cod_tit_ap                  = tit_acr.cod_tit_acr    
           tt_integr_apb_abat_prev_provis.tta_cod_parcela                 = tit_acr.cod_parcela    
           tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap             = v-vlr-comissao.   /*valor da baixa do tit-acr*/

END PROCEDURE.
*********/
PROCEDURE pi-calcula-valor: 
    /*T°tulo em situaá∆o normal, ou seja chamada direto do movto_tit_acr*/
    IF c_ind_trans_acr_abrev = "" THEN DO:
      IF movto_tit_acr.ind_trans_acr_abrev = "AVMN" THEN  /*Acerto Valor a Menor*/                                                                                                 
        ASSIGN v_val_sdo_tit_ap = v_val_sdo_tit_ap - v-vlr-comissao.
    END.
    ELSE DO: /*Chamada da UPC do repres_tit_acr, troca % de comissao */
      /*Calcula a diferenáa do novo valor da comissao  com o valor atual no APB*/
      ASSIGN v_val_dif_comis  = v-vlr-comissao - v_val_sdo_tit_ap
             v_val_sdo_tit_ap = v-vlr-comissao.
    END.

END PROCEDURE. 

PROCEDURE Pi-roda-api:
   
   FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.
   IF AVAIL tt_tit_ap_alteracao_base_1 THEN DO:
     RUN prgfin/apb/apb767zc.py (INPUT 1,
                                 INPUT "APB",
                                 INPUT '',        /*cod_matriz_trad_org_ext*/
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                 OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

   END.

   /* Moser - tratamento de erro na API para AVA na CPE*/
   FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK
       WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6788:
       DELETE tt_log_erros_tit_ap_alteracao.
   END.

   /*Valida se ocorreu erro durante o processamento*/
   FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
   IF AVAIL tt_log_erros_tit_ap_alteracao THEN 
      ASSIGN l_imprime_erro = YES.

   /*Maria Ester - Cria CPO */
   FIND FIRST tt_integr_apb_item_lote_impl_2 NO-LOCK NO-ERROR.
   IF AVAIL tt_integr_apb_item_lote_impl_2 THEN DO:
      FIND FIRST  tt_integr_apb_lote_impl NO-LOCK NO-ERROR.
     
      RUN prgfin/apb/apb900zd.py (INPUT 3,
                                  INPUT 'EMS',
                                  INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_2).
   END.

   /*Valida se ocorreu erro durante o processamento*/
   FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.
   IF AVAIL tt_log_erros_atualiz THEN 
      ASSIGN l_imprime_erro = YES.

END PROCEDURE.

PROCEDURE Pi_Zera_temp_table_api:
    FOR EACH tt_tit_ap_alteracao_base_1 EXCLUSIVE-LOCK:
       DELETE tt_tit_ap_alteracao_base_1.
    END.
        
    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK: 
       DELETE tt_log_erros_tit_ap_alteracao. 
    END.

    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK:
        DELETE tt_log_erros_tit_ap_alteracao. 
    END.
    
    FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
        DELETE tt_cancelamento_estorno_apb. 
    END.

    FOR EACH tt_log_erros_estorn_cancel_apb EXCLUSIVE-LOCK:
        DELETE tt_log_erros_estorn_cancel_apb. 
    END.

    FOR EACH tt_log_erros_atualiz EXCLUSIVE-LOCK:
        DELETE tt_log_erros_atualiz.
    END.
    
END PROCEDURE.

PROCEDURE pi-calc-comis-acordo-com:

DEF OUTPUT PARAM p_perc AS DECIMAL NO-UNDO.
DEF VAR v_data LIKE tit_acr.dat_transacao.

find first nota-fiscal NO-LOCK
    where nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
      and nota-fiscal.cod-estabel = "101" 
      AND nota-fiscal.serie       = "3" no-error.
if not avail nota-fiscal then
   find first nota-fiscal NO-LOCK 
    WHERE nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
      AND nota-fiscal.cod-estabel = "101" 
      AND nota-fiscal.serie       = "1" no-error.

find first ped-venda no-lock
    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
      AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
IF AVAIL ped-venda THEN
    ASSIGN v_data = ped-venda.dt-emissao. 
ELSE
    ASSIGN v_data = tit_acr.dat_transacao.


ASSIGN p_perc = 0. /* inicializaá∆o */

FIND FIRST emscad.cliente NO-LOCK
    WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
IF AVAIL emscad.cliente THEN DO:
    if  emscad.cliente.num_pessoa modulo 2 <> 0
    then do:
        find pessoa_jurid
            where pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa no-lock no-error.
        if  avail pessoa_jurid then do:
            FIND FIRST acordo-com 
               WHERE acordo-com.cgc = substr(pessoa_jurid.cod_id_feder,1,2) +
                                      substr(pessoa_jurid.cod_id_feder,3,3) +
                                      substr(pessoa_jurid.cod_id_feder,6,3)
                 AND acordo-com.periodo = string(month(v_data),"99") + 
                                          string(year(v_data))
                                           NO-ERROR.
            IF AVAIL acordo-com THEN DO:
               ASSIGN p_perc = acordo-com.perc.
            END.
        end.
    end.
    else do:
        find pessoa_fisic
            where pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa no-lock no-error.
        if  avail pessoa_fisic then do:
    
            FIND FIRST acordo-com 
               WHERE acordo-com.cgc = substr(pessoa_fisic.cod_id_feder,1,2) +
                                      substr(pessoa_fisic.cod_id_feder,3,3) +
                                      substr(pessoa_fisic.cod_id_feder,6,3)
                 AND acordo-com.periodo = string(month(v_data),"99") + 
                                          string(year(v_data))
                                           NO-ERROR.
            IF AVAIL acordo-com THEN DO:
                ASSIGN p_perc = acordo-com.perc.
            END.
        end.
    end.               
END.

END PROCEDURE.

