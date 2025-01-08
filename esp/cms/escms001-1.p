/******************************************************************************
** Programa: escms001.p
** Data....: Novembro/2004
** Autor...: Maria Ester - Aporte.
** Objetivo: Gera Titulo de previs∆o de comiss‰es para o APB
** Versao..: 1.00
******************************************************************************/

/* Temporary Tables Definitions API*/
{esp/cms/apb900zd.i}
{esp/cms/apb768za.i}
{esp/cms/apb767zc.i}

/* Temporary Tables Definitions Variable*/
{esp/cms/escms001.i}

DEF INPUT PARAM rmovto_repres_tit_acr AS RECID.
DEF INPUT PARAM c_ind_trans_acr_abrev AS CHAR . /* Indica o ponto de onde Ç chamado a rotina*/

DEF BUFFER btit_acr FOR tit_acr.
DEF BUFFER bmovto_tit_acr FOR movto_tit_acr.

DEF BUFFER b2tit_acr FOR tit_acr.
DEF BUFFER b2movto_tit_acr FOR movto_tit_acr.
DEF BUFFER b3tit_acr FOR tit_acr.             
DEF BUFFER b3movto_tit_acr FOR movto_tit_acr. 

DEF VAR c-ser-docto  LIKE tit_ap.cod_ser_docto.
def var h-boes464    as handle.
RUN Pi_zera_temp_table_api.

/*Chamada da UPC do repres_tit_acr, troca % de comiss∆o ou UPC do portad_tit_acr alteraá∆o do portador*/                                                                               
IF c_ind_trans_acr_abrev <> "" THEN DO:        
  FIND FIRST repres_tit_acr NO-LOCK                                                                                                       
       WHERE RECID(repres_tit_acr) = rmovto_repres_tit_acr NO-ERROR. 
  
  FIND LAST tit_acr                                                                                                                      
       WHERE tit_acr.cod_estab      = repres_tit_acr.cod_estab                                                                                 
         AND tit_acr.num_id_tit_acr = repres_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.                                                             

  FIND LAST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.

  IF NOT AVAIL movto_tit_acr THEN DO:
    LEAVE.
  END.
END.                                                                                                                                      
ELSE DO: /*Chamada diretamente do movto_tit_acr*/                                                                                              
  FIND FIRST movto_tit_acr                                                                                                                
       WHERE RECID(movto_tit_acr) = rmovto_repres_tit_acr NO-LOCK NO-ERROR.                                                               
                                                                                                                                           
  /*Pesquisa tit_acr correspondente a movimentaá∆o */                                                                                     
  FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.                                                                                   
                                                                                                                                           
END.                                                                                                                                      


ASSIGN l_erro            = NO
       l_imprime_erro    = NO
       v_vendor          = NO
       v-fator-comis     = 0
       v-vlr-movto       = 0
       v-vlr-comissao    = 0
       v_num_seq         = 0
       v_log_ped_repre   = NO
       v_cont_cpo        = 0
       v_log_gera_cpo    = YES
       v-acordo-com-perc =  0
       v_vlr_liq_extra   = 0.

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
      /*Isso vai ocorrer quando o t°tulo sofrer um Estorno, transaá∆o "ESTT" */
      IF movto_tit_acr.ind_trans_acr_abrev = "IMPL" AND movto_tit_acr.log_movto_estordo = YES  THEN
        LEAVE.
    
      IF movto_tit_acr.ind_trans_acr_abrev = "LIQ" AND movto_tit_acr.log_movto_estordo = YES  THEN
        LEAVE.

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
PROCEDURE Pi-Tit-Acr. /*AQUI*/
    
    IF movto_tit_acr.ind_trans_acr_abrev = "IMPL" OR  /*Implantaá∆o*/
       movto_tit_acr.ind_trans_acr_abrev = "LIQ"  OR  /*Liquidaá∆o*/
       movto_tit_acr.ind_trans_acr_abrev = "REN"  OR  /*Renegociaá∆o*/
       movto_tit_acr.ind_trans_acr_abrev = "LQEC" THEN  /*Liquidaá∆o por encontro de contos*/
    DO:
      /*Tratamento para espÇcie em VENDOR*/   
      IF movto_tit_acr.cod_espec_docto = "VE" OR movto_tit_acr.cod_espec_docto = "VD" THEN  
         ASSIGN v_vendor = YES.
          
      /*Pesquisa titulo e percetual de comissÉo do representante */
      FOR EACH repres_tit_acr NO-LOCK
          WHERE repres_tit_acr.cod_estab             = tit_acr.cod_estab 
          AND   repres_tit_acr.num_id_tit_acr        = tit_acr.num_id_tit_acr
          AND   repres_tit_acr.val_perc_comis_repres > 0,
          FIRST representante NO-LOCK
                WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
                AND   representante.cdn_repres  = repres_tit_acr.cdn_repres:
          
        FIND FIRST repres_financ OF representante NO-LOCK
             WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.
        IF AVAIL repres_financ THEN
           NEXT.
          
          ASSIGN v_vlr_liq_extra = 0
                 v-vlr-comis-jur = 0. 

        /*Valida representante x fornecedor x fornec_financ e tit_ap */
        RUN pi_valida. 
        /*Tratamento para espÇcie em VENDOR*/   
        
        IF v_vendor = YES THEN DO:
          RUN pi-vendor.
        END.
        ELSE DO:
          /*Calcula percentual de comiss∆o e valor comiss∆o para titulo normal*/
          RUN pi-valor-comis. 
        END.

        IF movto_tit_acr.ind_trans_acr_abrev = "IMPL" OR 
           movto_tit_acr.ind_trans_acr_abrev = "REN" THEN  /*Implantaá∆o ou Renegociaá∆o de t°tulo*/                
        DO:                                                                  
           ASSIGN v_cod_tit_acr = tit_acr.cod_tit_acr
                  i = 1.
           RUN Pi-Cria-tt-api-IMPL. 
        END.
        ELSE                                                                 
        IF movto_tit_acr.ind_trans_acr_abrev = "LIQ" OR movto_tit_acr.ind_trans_acr_abrev = "LQEC" THEN   /*Liquidaá∆o de T°tulo ou Liquidaá∆o por Enctro de Contas*/                  
        DO:                                                                  
          
          FIND FIRST b2movto_tit_acr NO-LOCK
             WHERE b2movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
             AND   b2movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

          /*MESSAGE 'ESCMS001' SKIP(2)
                  'avail b2movto_tit_acr           ' AVAIL b2movto_tit_acr             SKIP(3)
                  'movto_tit_acr.cod_espec_docto   ' movto_tit_acr.cod_espec_docto     SKIP
                  'movto_tit_acr.val_movto_tit_acr ' movto_tit_acr.val_movto_tit_acr       SKIP
                  'movto_tit_acr.cod_estab_tit_acr    ' movto_tit_acr.cod_estab_tit_acr    SKIP 
                  'movto_tit_acr.num_id_movto_tit_acr ' movto_tit_acr.num_id_movto_tit_acr SKIP 
                  'movto_tit_acr.cod_estab_tit_acr    ' movto_tit_acr.cod_estab_tit_acr    SKIP 
                  'movto_tit_Acr.cod_espec_docto      ' movto_tit_Acr.cod_espec_docto      SKIP 
                  'movto_tit_acr.ind_trans_acr_abrev  ' movto_tit_acr.ind_trans_acr_abrev  SKIP 
                  VIEW-AS ALERT-BOX.*/

          IF AVAIL b2movto_tit_acr THEN DO:
             FIND FIRST b2tit_acr OF b2movto_tit_acr NO-LOCK NO-ERROR.
             
             IF b2tit_acr.ind_tip_espec_docto = 'Antecipaá∆o' AND
                (b2tit_acr.ind_orig_tit_acr    = 'REC'        OR
                 b2tit_acr.ind_orig_tit_acr    = 'ACR') THEN DO:
                 ASSIGN v_orig_an_devol = YES.

                 IF b2tit_acr.ind_orig_tit_acr    = 'REC' OR 
                    b2tit_acr.cod_portador        = ''    THEN DO:

                    RUN pi-altera-cpe-liq.
                    LEAVE.
                 END.
                 ELSE DO: /* b2tit_acr.ind_orig_tit_acr    = 'ACR' */
                    FIND FIRST relacto_tit_acr NO-LOCK
                        WHERE relacto_tit_acr.cod_estab_tit_acr_pai     = b2movto_tit_acr.cod_estab       
                        AND   relacto_tit_acr.num_id_tit_acr_pai        = b2movto_tit_acr.num_id_tit_Acr NO-ERROR.
                    IF AVAIL relacto_tit_acr THEN DO:
                       FIND FIRST b3tit_acr NO-LOCK
                          WHERE b3tit_acr.cod_estab           = relacto_tit_acr.cod_estab
                          AND   b3tit_acr.num_id_tit_acr      = relacto_tit_acr.num_id_tit_acr 
                          AND   b3tit_acr.ind_tip_espec_docto = 'Nota de CrÇdito' NO-ERROR.
                       IF AVAIL b3tit_acr THEN DO:
                          RUN pi-altera-cpe-liq.
                          LEAVE.
                       END.
                    END.
                 END.
             END.
          END.
          
          /*N∆o gera CPO para os t°tulos da espÇcie DM, carteira tipo Vendor, s¢ cancela a CPE 
            tambÇm n∆o pode gerar CPO para espÇcie VE com baixa em vendor debitado */
          FIND cart_bcia NO-LOCK
             WHERE cart_bcia.cod_cart_bcia  = movto_tit_acr.cod_cart_bcia 
               AND cart_bcia.ind_tip_cart_bcia = "Vendor" NO-ERROR.
          IF AVAIL cart_bcia AND tit_acr.ind_tip_espec_docto = "NORMAL" THEN DO:
             RUN pi-altera-cpe-liq.
          END.
          ELSE DO:
            /*Trata todos os tipos de liquidaá∆o: c/ juros, multas, desctos e abatimentos */              
            ASSIGN v_vlr_jur_multa   = ABS(movto_tit_acr.val_juros + movto_tit_acr.val_multa_tit_acr)
                   v_vlr_descto_abat = ABS(movto_tit_acr.val_desconto + movto_tit_acr.val_abat_tit_acr).
            
            /*Em 20/05 - Mario Fleith, para os cliente do grupo 25, nao devesse realizar o AVA a Menor na CPE, 
              ja que o desconto nos titulos para este grupo de cliente caracteriza o Pagamento de Multa po Atraso da Intelbras,
              aonde o representantes nao podem ser penalizados*/
            IF emscad.cliente.cod_grp_clien = '25' THEN
               ASSIGN v_vlr_descto_abat = v_vlr_descto_abat - movto_tit_acr.val_desconto.

            IF v_vlr_jur_multa > 0 AND v_vlr_descto_abat > 0 THEN
               ASSIGN v_vlr_liq_extra = ABS(v_vlr_jur_multa - v_vlr_descto_abat).
            ELSE DO:
              IF v_vlr_jur_multa > 0 THEN 
                ASSIGN v_vlr_liq_extra = v_vlr_jur_multa.
              ELSE
                ASSIGN v_vlr_liq_extra = v_vlr_descto_abat.
            END.
          
            IF v_vlr_liq_extra > 0 THEN DO:
              /*Calcula valor da comiss∆o correspondente */
              ASSIGN v-fator-comis  = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
                     v-vlr-movto    = v_vlr_liq_extra * v-fator-comis
                     v-vlr-comis-jur = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).
              
              IF v-acordo-com-perc <> 0 THEN
                 ASSIGN v-vlr-comis-jur = v-vlr-comis-jur - (v-vlr-comis-jur * (v-acordo-com-perc / 100)).
              
              /*Efetua movimentaá∆o na CPE referente ao tipo de liquidaá∆o*/
              /*IF v_cod_usuar_corren = 'Super' THEN
                 MESSAGE 'ESCMS001 ' SKIP(2) '  2 '
                         SKIP(2)'IF AVAIL cart_bcia AND tit_acr.ind_tip_espec_docto = "NORMAL" THEN DO: ' SKIP 
                         'v-vlr-comissao  ' v-vlr-comissao  SKIP
                         'v-vlr-comis-jur ' v-vlr-comis-jur SKIP
                         'v_vlr_liq_extra ' v_vlr_liq_extra SKIP
                         'movto_tit_acr.val_movto_tit_acr ' movto_tit_acr.val_movto_tit_acr SKIP
                         VIEW-AS ALERT-BOX.*/
              RUN pi-altera-cpe-liq.

            END.
            
            /*Atualiza o valor da comiss∆o ref. ao movto_tit_acr com o valor da comiss∆o ref. aos juros,multas..*/
            IF v-vlr-comis-jur > 0 THEN DO:
               IF v_vlr_jur_multa > 0 THEN
                  ASSIGN v-vlr-comissao = v-vlr-comissao + v-vlr-comis-jur. 
               ELSE
                  ASSIGN v-vlr-comissao = v-vlr-comissao - v-vlr-comis-jur. 
            END.
          
            /*IF v_cod_usuar_corren = 'Super' THEN
                MESSAGE 'tit_ap.val_sdo    ' tit_ap.val_sdo    SKIP
                        'v-vlr-comissao    ' v-vlr-comissao    SKIP(1)
                        'v-vlr-comis-jur   ' v-vlr-comis-jur   SKIP(1)
                        'v_vlr_jur_multa   ' v_vlr_jur_multa   SKIP(1)
                        'v_vlr_descto_abat ' v_vlr_descto_abat SKIP(2)
                        'v-vlr-comis-jur > 0 ' v-vlr-comis-jur > 0
                          VIEW-AS ALERT-BOX.*/

            
            /*Cria Temp-tables da API para Provis∆o e baixa Previs∆o*/                          
            RUN pi-cria-prov-liq-prev.

          END. /*else*/
        END. /*else LIQ*/                                                                
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
   

   /*Tratamento para espÇcie em VENDOR*/   
   IF tit_acr.cod_espec_docto = "VE" OR  tit_acr.cod_espec_docto = "VD" THEN DO:
      RUN pi-vendor.

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
        
      IF v-acordo-com-perc <> 0 THEN
         ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
          
   END.
   ELSE DO:
     /*Calcula o valor da comiss∆o*/
     ASSIGN v-fator-comis = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
            v-vlr-movto    = tit_acr.val_sdo_tit_acr * v-fator-comis 
            v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).

     IF v-acordo-com-perc <> 0 THEN
        ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
   END.
   
   ASSIGN v_cod_tit_acr = tit_acr.cod_tit_acr
          i = 1.
   /*Cria temp-tables da API para Previs∆o*/     
   RUN Pi-Cria-tt-api-IMPL.                                              
        
END PROCEDURE.

PROCEDURE pi-valor-comis. 
    
    IF v_vendor THEN DO:
       IF tit_acr.cod_espec_docto = "vd" THEN DO:
          ASSIGN v-fator-comis = btit_acr.val_liq_tit_acr / btit_acr.val_origin_tit_acr
                 v-vlr-movto    =  movto_tit_acr.val_movto_tit_acr * v-fator-comis 
                 v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).

          IF v-acordo-com-perc <> 0 THEN
              ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
       END.
       ELSE do: /* c†lculo de comiss∆o vendor deve pegar o valor da parcela de fechamento vendor */
           ASSIGN v-fator-comis = btit_acr.val_liq_tit_acr / btit_acr.val_origin_tit_acr
                  v-vlr-movto    = parc_vendor.val_parc_vendor_clien * v-fator-comis 
                  v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).
    
           IF v-acordo-com-perc <> 0 THEN
               ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
       END.
    END.
    ELSE DO:
        ASSIGN v-fator-comis  = tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
               v-vlr-movto    = movto_tit_acr.val_movto_tit_acr * v-fator-comis
               v-vlr-comissao = ((v-vlr-movto * repres_tit_acr.val_perc_comis_repres) / 100).

        IF v-acordo-com-perc <> 0 THEN
            ASSIGN v-vlr-comissao = v-vlr-comissao - (v-vlr-comissao * (v-acordo-com-perc / 100)).
    END.
    
END PROCEDURE.

PROCEDURE Pi_Valida.
    
    /*Pesquisa relacionamento entre fornecedor x representante*/                      
    FIND FIRST emscad.fornecedor NO-LOCK 
         WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
           AND emscad.fornecedor.num_pessoa  = representante.num_pessoa 
         USE-INDEX frncdr_empr_pessoa NO-ERROR.
    IF NOT AVAIL emscad.fornecedor THEN DO:
      RUN pi_Erro (INPUT "1 - Fornecedor n∆o localizado para o representante " + STRING(representante.cdn_repres) + " (escms001)").
    END.
    
    FIND FIRST fornec_financ NO-LOCK
         WHERE fornec_financ.cod_empresa = emscad.fornecedor.cod_empresa 
           AND fornec_financ.cdn_fornecedor = emscad.fornecedor.cdn_fornecedor NO-ERROR.
    IF NOT AVAIL fornec_financ THEN DO:
      RUN pi_Erro (INPUT "2 - Fornecedor Financeiro n∆o localizado para o representante " + STRING(representante.cdn_repres) + " (escms001)").
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
    IF AVAIL tit_ap AND 
       (movto_tit_acr.ind_trans_acr_abrev = "IMPL" OR movto_tit_acr.ind_trans_acr_abrev = "REN") THEN DO:
       RUN pi_erro (INPUT "3 - Previs∆o de Comiss∆o - CPE, j† existe para o t°tulo APB (escms001)"). 
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
    
    FIND FIRST dupl_vendor NO-LOCK
         WHERE dupl_vendor.num_planilha_vendor = int(tit_acr.cod_tit_acr) 
         AND   dupl_vendor.cod_estab           = tit_acr.cod_estab NO-ERROR.

    IF AVAIL dupl_vendor THEN DO:
        /* Leitura para o c†lculo da comiss∆o vendor */        
        FIND FIRST parc_vendor no-lock
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
      RUN pi_erro (INPUT "4 - N∆o localizou a espÇcie DM na tabela dupl_vendor correpondente ao fechamento do Vendor - VE (escms001)").  
    END.
        
    IF c_ind_trans_acr_abrev = "" THEN DO:
       RUN pi-valor-comis. 
    END.

END PROCEDURE.

PROCEDURE Pi-Cria-tt-api-IMPL.
         

/* Validaá∆o portador para implantaá∆o */
FIND FIRST int-portador NO-LOCK
     WHERE int-portador.cod_portador = tit_acr.cod_portador
       AND int-portador.log_considera_comissao = YES NO-ERROR.
IF AVAIL int-portador THEN DO:

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
           WHERE tt_integr_apb_lote_impl.tta_cod_estab_ext = tit_acr.cod_estab 
             AND tt_integr_apb_lote_impl.tta_cod_refer = SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-error.

      FIND FIRST movto_tit_ap 
           WHERE movto_tit_ap.cod_estab   = tit_acr.cod_estab 
             AND movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.
      IF NOT AVAIL movto_tit_ap AND NOT AVAIL tt_integr_apb_lote_impl THEN 
        LEAVE.
    end.                                       
    
     /* Tratamento para criar somente um lote de implantaá∆o para v†rias parcelas reduzidas e uma parcela normal */
    IF i = 1 THEN DO:
         /*Cria CPE - Previs∆o de Comiss∆o no APB*/ 
         CREATE tt_integr_apb_lote_impl.
         ASSIGN tt_integr_apb_lote_impl.tta_cod_refer                =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,"9999999999"),2,9) 
                tt_integr_apb_lote_impl.tta_dat_transacao            =  TODAY /*tit_acr.dat_trans Em 01/04/2005 Maria Ester e Mario Fleith*/
                tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        =  'APB' 
                tt_integr_apb_lote_impl.tta_cod_estab_ext            =  tit_acr.cod_estab  
                tt_integr_apb_lote_impl.tta_val_tot_lote_impl_tit_ap =  0
                tt_integr_apb_lote_impl.ttv_cod_empresa_ext          =  v_cod_empres_usuar
                tt_integr_apb_lote_impl.tta_cod_indic_econ           =  'Real'
                tt_integr_apb_lote_impl.tta_cod_espec_docto          =  'CPE'.
     END.

     ASSIGN v_num_seq = v_num_seq + 1.
     
     /** Maria Ester 06/04/05
     /* Moser n£mero da parcela reduzida */
     IF v_log_ped_repre THEN
        ASSIGN v_cod_parcela = STRING(v_num_seq,'99').
     ELSE
     ****/   
         
     ASSIGN v_cod_parcela = tit_acr.cod_parcela.
     
     IF tit_acr.cod_espec_docto = "dm" then
        ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
     ELSE                                    
        ASSIGN c-ser-docto = tit_acr.cod_espec_docto.

     CREATE tt_integr_apb_item_lote_impl_2.
     ASSIGN tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_lote_impl  =  RECID(tt_integr_apb_lote_impl)
            tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote  =  RECID(tt_integr_apb_item_lote_impl_2)
            tt_integr_apb_item_lote_impl_2.tta_num_seq_refer             =  v_num_seq                                /*Referencia      */
            tt_integr_apb_item_lote_impl_2.tta_cdn_fornecedor            =  fornec_financ.cdn_fornecedor             /* Fornecedor     */
            tt_integr_apb_item_lote_impl_2.tta_cod_espec_docto           =  'CPE'                                    /* EspÇcie        */
            tt_integr_apb_item_lote_impl_2.tta_cod_ser_docto             =  c-ser-docto                              /* SÇrie          */
            tt_integr_apb_item_lote_impl_2.tta_cod_tit_ap                =  v_cod_tit_acr                            /* T°tulo         */
            tt_integr_apb_item_lote_impl_2.tta_cod_parcela               =  v_cod_parcela                            /* Parc           */
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
            tt_integr_apb_item_lote_impl_2.tta_cod_portad_ext            =  '999'                                    /* Portador Externo */               
            tt_integr_apb_item_lote_impl_2.tta_cod_modalid_ext           =  "0"                                      /* Modalidade Externa */
            tt_integr_apb_item_lote_impl_2.tta_des_text_histor           =  'Previs∆o de Comiss∆o ref. ao t°tulo do ACR: ' + 'Estab:' + tit_acr.cod_estab + 
                                                                            '  Esp:' + tit_acr.cod_espec_docto +  '  Sr:' + c-ser-docto +
                                                                            '  titulo:' + STRING(tit_acr.cod_tit_acr) + '  parc:' + tit_acr.cod_parcela +
                                                                            '  Cliente:' + STRING(tit_acr.cdn_cliente) + '  Repres:' + STRING(repres_tit_acr.cdn_repres).
      CREATE tt_integr_apb_aprop_ctbl_pend.                                                                                       
      ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_2)               
             tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0                                                   
             tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0                                                   
             tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = ""                                            
             tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = ""                                          
             tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               = "ADM"                                               
             tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             = ""                                                  
             tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   = ""                                                  
             tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         = v_cod_tip_fluxo_financ 
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
END.

END PROCEDURE.

/*Cria Provis∆o e baixa Previsao no APB*/
PROCEDURE pi-cria-prov-liq-prev.
    
    
/*Pesquisa se ja existe uma CPO no APB, se existir incrementa 1 no cod_tit*/       
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
  FIND FIRST tt_integr_apb_lote_impl NO-LOCK
       WHERE tt_integr_apb_lote_impl.tta_cod_estab_ext = tit_acr.cod_estab 
         AND tt_integr_apb_lote_impl.tta_cod_refer = SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-error.
  find first movto_tit_ap 
       where movto_tit_ap.cod_estab   = tit_acr.cod_estab 
         and movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.
  if not avail movto_tit_ap AND NOT AVAIL  tt_integr_apb_lote_impl THEN 
    LEAVE .
END.

/* validaá∆o do portador */
FIND FIRST int-portador NO-LOCK
     WHERE int-portador.cod_portador = movto_tit_acr.cod_portador
       AND int-portador.log_considera_comissao = YES NO-ERROR.
IF NOT AVAIL int-portador THEN DO:
   run pi-cancel-CPE-DM-LIQ-port-nao-cons-comis.
END.
ELSE DO:

     IF tit_acr.cod_espec_docto = "dm" then
        ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
     ELSE                                    
        ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
     
     FOR EACH tit_ap NO-LOCK                                                                                                
         WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
           AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
           AND tit_ap.cod_espec_docto = "CPO"                                                                                 
           AND tit_ap.cod_ser_docto   = c-ser-docto
           AND SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr:       
         ASSIGN v_cont_cpo = v_cont_cpo + 1.
     END.

     IF v_log_gera_cpo THEN DO:
         FIND LAST tit_ap NO-LOCK                                                                                                
             WHERE tit_ap.cod_estab              = tit_acr.cod_estab                                                                     
               AND tit_ap.cdn_fornecedor         = emscad.fornecedor.cdn_fornecedor                                                        
               AND tit_ap.cod_espec_docto        = "CPO"                                                                                 
               AND tit_ap.cod_ser_docto          = c-ser-docto
               AND SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr       
               AND tit_ap.cod_parcela            = tit_acr.cod_parcela NO-ERROR.   
         IF AVAIL tit_ap THEN DO:
            ASSIGN v_seq_tit_cpo = INT(SUBSTRING(tit_ap.cod_tit_ap,09,2)) + 1.
         END.
         ELSE DO:
            ASSIGN v_seq_tit_cpo = 01.
         END.
         ASSIGN v_cod_tit_cpo = STRING(STRING(tit_acr.cod_tit_acr,'9999999') + "-" + STRING(v_seq_tit_cpo,"99")).

         ASSIGN v_num_seq = v_num_seq + 1.
                                                       
         /* Maria Ester Verifica se existe a CPE e valida valores entre valor da comiss∆o x sdo_tit_ap */
         FIND LAST tit_ap NO-LOCK
              WHERE tit_ap.cod_estab       = tit_acr.cod_estab
                AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
                AND tit_ap.cod_espec_docto = "CPE" 
                AND tit_ap.cod_ser_docto   = c-ser-docto
                AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
                AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
                AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
         IF AVAIL tit_ap THEN DO:
           IF ABS((v-vlr-comissao - tit_ap.val_sdo_tit_ap)) <= 0.03 THEN
              ASSIGN v-vlr-comissao = tit_ap.val_sdo_tit_ap.
         END.
         ELSE DO:
           FIND movto_tit_ap NO-LOCK
              WHERE movto_tit_ap.cod_empresa    = tit_acr.cod_empresa
              AND movto_tit_ap.cdn_fornecedor   = emscad.fornecedor.cdn_fornecedor 
              AND SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.          
           IF AVAIL movto_tit_ap THEN
              LEAVE.
           ELSE DO:
              IF repres_tit_acr.val_perc_comis_repres  > 0 AND 
                 tit_acr.ind_tip_espec_docto          <> 'Vendor' THEN
                 RUN Pi_erro (INPUT "7 - N∆o localizou o titulo no contas a pagar, espÇcie CPE referente a DM para baixa CPE e criar CPO(escms001). Fornec " + STRING(emscad.fornecedor.cdn_fornecedor)).
              LEAVE. /*Mario Fleith em 10/05/2005 Mesmo ocorrendo erro esta chamando a API, dando erro desnecess†rio no retorno da API*/
           END.
            
         END.

         /*Cria CPO - Provis∆o de Comiss∆o no APB*/
         CREATE tt_integr_apb_lote_impl.
         ASSIGN tt_integr_apb_lote_impl.tta_cod_refer                =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,"9999999999"),2,9) /*STRING( movto_tit_acr.num_id_movto_tit_acr,'9999999999')*/  
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
                tt_integr_apb_item_lote_impl_2.tta_des_text_histor           =  'Provis∆o de Comiss∆o ref. a liquidaá∆o parcial/total do t°tulo no ACR: ' + 
                                                                                'Estab:' + tit_acr.cod_estab + 
                                                                                '  Esp:' + tit_acr.cod_espec_docto +  '  Sr:' + c-ser-docto +
                                                                                '  titulo:' + STRING(tit_acr.cod_tit_acr) + '  parc:' + tit_acr.cod_parcela +
                                                                                '  Cliente:' + STRING(tit_acr.cdn_cliente) + '  Repres:' + STRING(repres_tit_acr.cdn_repres).
         
         CREATE tt_integr_apb_aprop_ctbl_pend.                                                                                            
         ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_2)                    
                tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0                                                        
                tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0                                                        
                tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = v_cod_plano_cta_ctbl /* "PADRAO" moser*/                                   
                tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = v_cod_cta_ctbl /* "21930005"  moser */                                    
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
    
         
/*         CREATE tt_integr_apb_abat_prev_provis.
         ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote    = RECID(tt_integr_apb_item_lote_impl_2)
                tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend        = ? 
                tt_integr_apb_abat_prev_provis.tta_cod_estab                   = '101' 
                tt_integr_apb_abat_prev_provis.tta_cod_espec_docto             = 'CPE'
                tt_integr_apb_abat_prev_provis.tta_cod_ser_docto               = "3" 
                tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor              = 18605
                tt_integr_apb_abat_prev_provis.tta_cod_tit_ap                  = "0080024"
                tt_integr_apb_abat_prev_provis.tta_cod_parcela                 = "04"
                tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap             = 204.96.
  */
         
         CREATE tt_integr_apb_abat_prev_provis.
         ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote    = RECID(tt_integr_apb_item_lote_impl_2)
                tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend        = ? 
                tt_integr_apb_abat_prev_provis.tta_cod_estab                   = '101' 
                tt_integr_apb_abat_prev_provis.tta_cod_espec_docto             = 'CPE'
                tt_integr_apb_abat_prev_provis.tta_cod_ser_docto               = c-ser-docto 
                tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor              = fornec_financ.cdn_fornecedor
                tt_integr_apb_abat_prev_provis.tta_cod_tit_ap                  = tit_acr.cod_tit_acr    
                tt_integr_apb_abat_prev_provis.tta_cod_parcela                 = tit_acr.cod_parcela    
                tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap             = IF tit_ap.val_sdo_tit_ap < v-vlr-comissao THEN 
                                                                                    tit_ap.val_sdo_tit_ap 
                                                                                 ELSE 
                                                                                    v-vlr-comissao.   /*valor da baixa do tit-acr*/  
     END.
END. /*else*/

END PROCEDURE.

/*Efetua alteraá∆o na CPE conforme tipo de liquidaá∆o*/
PROCEDURE pi-altera-cpe-liq:
      
   
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
        
        FIND movto_tit_ap OF tit_ap NO-LOCK
           WHERE SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.          
        IF AVAIL movto_tit_ap THEN DO: 
           RUN Pi_erro (INPUT "14 - Titulo APB ja sofreu a devida movimentaá∆o (escms001)").
           LEAVE.                                                                           
        END.
      END.
      ELSE DO:
        RUN Pi_erro (INPUT "13 - N∆o localizou o titulo no contas a pagar, espÇcie CPE para efetuar a movimentaá∆o (escms001)").
        LEAVE.
      END.
      
      /*****  Calcula referància autom†tica 
      Essa rotina foi implementada, devido um t°tulo possuir mais de um represente. 
      Ocorreu erro de duplicidade pois a referencia do tit_ap Ç o num_id_movto_tit_acr 
      *****/
      REPEAT:
       ASSIGN v_cod_refer_impl = ''
              v_num_aux_2 = integer(this-procedure:handle)
              v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
              v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux)
              .
       FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK
            WHERE tt_tit_ap_alteracao_base_1.tta_cod_estab = tit_acr.cod_estab
              AND tt_tit_ap_alteracao_base_1.ttv_cod_refer = SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-error.
       FIND FIRST movto_tit_ap 
            WHERE movto_tit_ap.cod_estab = tit_acr.cod_estab 
              AND movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer_impl,1,1) + SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.
       IF NOT AVAIL movto_tit_ap AND NOT AVAIL tt_tit_ap_alteracao_base_1 THEN
         LEAVE.
      END.
      
      /*Valida se a DM pertence a uma carteira tipo vendor, se sim baixa a CPE referente relacionada*/
      IF (AVAIL cart_bcia AND tit_acr.ind_tip_espec_docto = "NORMAL") OR 
          v_orig_an_devol                                 = YES       THEN DO:
          ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap - v-vlr-comissao.   
      END.
      ELSE
      DO:
        /*DM normal, calcula o novo saldo do t°tulo conforme liq. com juros, multa, descto e abatimento*/
        IF v_vlr_jur_multa > v_vlr_descto_abat THEN
          ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap + v-vlr-comis-jur.   
        ELSE    
          ASSIGN v_val_sdo_tit_ap = tit_ap.val_sdo_tit_ap - v-vlr-comis-jur.   
      END.
      /*IF v_cod_usuar_corren = 'Super' THEN
        MESSAGE 'ESCMS001 -  ALTERACAO'                                  SKIP(2) 
                'v_val_sdo_tit_ap  ' v_val_sdo_tit_ap           SKIP 
                'tit_ap.val_sdo_tit_ap ' tit_ap.val_sdo_tit_ap  SKIP
                'v-vlr-comis-jur '   v-vlr-comis-jur            SKIP
                'v_vlr_jur_multa '   v_vlr_jur_multa            SKIP
                'v_vlr_descto_abat ' v_vlr_descto_abat          SKIP
                VIEW-AS ALERT-BOX.*/

      IF v_val_sdo_tit_ap < 0 AND                                                                                                                                               
         v_val_sdo_tit_ap >= - 0.03 THEN /*Em 12/04 - Mario Fleith - Problema de arrendondamento, dando erro '12.800 ; Desc Msg: Ocorreu o Erro 9172 no Processo Executado !'*/ 
         ASSIGN v_val_sdo_tit_ap = 0.                                                                                                                                           

      /*IF v_cod_usuar_corren = 'Super' THEN
         MESSAGE 'CRIANDO TEMP-TABLE ' SKIP(4)
                 'v_val_sdo_tit_ap      ' v_val_sdo_tit_ap      SKIP 
                 'tit_ap.val_sdo_tit_ap ' tit_ap.val_sdo_tit_ap SKIP
                 'v_vlr_jur_multa       ' v_vlr_jur_multa       SKIP
                 'v_vlr_descto_abat     ' v_vlr_descto_abat     SKIP
                 VIEW-AS ALERT-BOX.*/
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
             tt_tit_ap_alteracao_base_1.ttv_dat_transacao                =  TODAY 
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
             tt_tit_ap_alteracao_base_1.tta_des_histor_padr              =  IF v_orig_an_devol = YES THEN 'Documento DM baixado contra AN originada por uma DEVOLUCAO' ELSE ''
             tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               =  tit_ap.ind_sit_tit_ap    
             tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              =  tit_ap.cod_forma_pagto   
             tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                =  "" .

   FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.
   IF AVAIL tt_tit_ap_alteracao_base_1 THEN DO:
      RUN prgfin/apb/apb767zc.py (INPUT 1,
                                  INPUT "APB",
                                  INPUT '',        /*cod_matriz_trad_org_ext*/
                                  INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                  INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                  OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

   END.

   FOR EACH tt_tit_ap_alteracao_base_1 EXCLUSIVE-LOCK:
       DELETE tt_tit_ap_alteracao_base_1.
   END.

   /* Moser - tratamento de erro na API para AVA na CPE*/
   FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK
       WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6788:
       DELETE tt_log_erros_tit_ap_alteracao.
   END.

   /*Valida se ocorreu erro durante o processamento*/
   FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
   IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
      ASSIGN l_imprime_erro = YES.
   END.
   
END PROCEDURE.


/* PROCEDURE pi-cancel-CPE-DM-vendor:
    
        l_erro = NO.
        
        /*Localiza CPE correspondente ao t°tulo do contas a receber */
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
               AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
               AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
        IF AVAIL tit_ap THEN DO:
          FIND movto_tit_ap OF tit_ap NO-LOCK NO-ERROR.
          IF NOT AVAIL movto_tit_ap THEN
            ASSIGN l_erro = YES.
        END.                                                                                                                          
        ELSE DO:
           ASSIGN l_erro = YES.
        END.
        
        /*Elimina a Previs∆o de comissao referente a DM - Vendor*/
        IF l_erro = NO THEN DO:
          CREATE tt_cancelamento_estorno_apb. 
          ASSIGN ttv_ind_niv_operac_apb            = "titulo"
                 ttv_ind_tip_operac_apb            = "cancelamento"
                 tta_cod_estab                     = tit_ap.cod_estab                                                                         
                 tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                 tta_num_id_movto_tit_ap           = movto_tit_ap.num_id_movto_tit_ap 
                 tta_cod_refer                     = movto_tit_ap.cod_refer
                 tta_dat_transacao                 = TODAY /*movto_tit_ap.dat_transacao Em 01/04/2005 Maria Ester e Mario Fleith*/
                 tta_cod_histor_padr               = "" 
                 ttv_des_histor                    = 'Cancelamento da Previs∆o de Comiss∆o, referente ao fechamento de VENDOR:' +
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
                 
          /*Zera temp-table*/
          FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
            DELETE tt_cancelamento_estorno_apb. 
          END.
      
        END. /*l_erro*/
        ELSE
        DO:
          RUN Pi_erro (INPUT "6 - N∆o localizou o titulo no contas a pagar, espÇcie CPE referente a DM - Vendor para o cancelamento (escms001)").
        END.
        
END.
   */

PROCEDURE pi-cancel-CPE-DM-LIQ-port-nao-cons-comis:
    
    IF tit_acr.cod_espec_docto = "dm" then
       ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
    ELSE                                    
       ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
    
    ASSIGN l_erro = NO.
    FIND LAST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab       = tit_acr.cod_estab
           AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
           AND tit_ap.cod_espec_docto = "CPE" 
           AND tit_ap.cod_ser_docto   = c-ser-docto
           AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
           AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
           AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
    IF AVAIL tit_ap THEN DO:
      FIND movto_tit_ap OF tit_ap no-lock
      WHERE SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.          
      IF NOT AVAIL movto_tit_ap THEN                                                                                              
        ASSIGN l_erro = YES.                                                                                                            
    END.                                                                                                                          
    ELSE                                                                                                                          
      ASSIGN l_erro = YES.                                                                                                              
    
    /*Elimina a Previs∆o de comissao referente a DM - Portador n∆o considera comiss∆o */
    IF l_erro = NO THEN
    DO:
      CREATE tt_cancelamento_estorno_apb. 
      ASSIGN ttv_ind_niv_operac_apb            = "titulo"
             ttv_ind_tip_operac_apb            = "cancelamento"
             tta_cod_estab                     = tit_ap.cod_estab                                                                         
             tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
             tta_num_id_movto_tit_ap           = movto_tit_ap.num_id_movto_tit_ap 
             tta_cod_refer                     = movto_tit_ap.cod_refer
             tta_dat_transacao                 = TODAY /*movto_tit_ap.dat_transacao Em 01/04/2005 Maria Ester e Mario Fleith */
             tta_cod_histor_padr               = "" 
             ttv_des_histor                    = 'Cancelamento da Previs∆o de Comiss∆o, referente Portador n∆o considera comiss∆o:' +
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
    
      /*Zera temp-table*/
      FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
        DELETE tt_cancelamento_estorno_apb. 
      END.
      
    END. /*l_erro*/
    
END.

PROCEDURE Pi-roda-api:
    
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
    
    FOR EACH tt_integr_apb_lote_impl EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_lote_impl.
    END.
    
    FOR EACH tt_integr_apb_item_lote_impl_2 EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_item_lote_impl_2.
    END.
    
    FOR EACH tt_integr_apb_aprop_ctbl_pend EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_aprop_ctbl_pend.
    END.
    
    FOR EACH tt_log_erros_atualiz EXCLUSIVE-LOCK:
        DELETE tt_log_erros_atualiz. 
    END.
    
    FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
        DELETE tt_cancelamento_estorno_apb. 
    END.

    FOR EACH tt_log_erros_estorn_cancel_apb EXCLUSIVE-LOCK:
        DELETE tt_log_erros_estorn_cancel_apb. 
    END.

    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.
    
END PROCEDURE.

PROCEDURE pi-calc-comis-acordo-com:

DEF OUTPUT PARAM p_perc AS DECIMAL NO-UNDO.

DEFINE VARIABLE v_data LIKE tit_acr.dat_transacao.
DEFINE VARIABLE c-unid-neg              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-id-faturamento-acordo AS INTEGER NO-UNDO. 
DEFINE VARIABLE i-id-base-calc-acordo   AS INTEGER NO-UNDO. 
DEFINE VARIABLE i-id-devolucoes         AS INTEGER NO-UNDO.

find first nota-fiscal NO-LOCK
    where nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
      and nota-fiscal.cod-estabel = "101" 
      AND nota-fiscal.serie       = "3" no-error.
if not avail nota-fiscal then
   find first nota-fiscal NO-LOCK 
    WHERE nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
      AND nota-fiscal.cod-estabel = "101" 
      AND nota-fiscal.serie       = "1" no-error.
if not avail nota-fiscal then
   find first nota-fiscal NO-LOCK 
    WHERE nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
      AND nota-fiscal.cod-estabel = "101" 
      AND nota-fiscal.serie       = "5" no-error.
      
if avail nota-fiscal then do:
   find emitente where emitente.cod-emitente = nota-fiscal.cod-emitente no-lock no-error.
   find first it-nota-fisc of nota-fiscal no-lock no-error.
   find item where item.it-codigo = it-nota-fisc.it-codigo no-lock no-error.
end.
find first ped-venda no-lock
    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
      AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
IF AVAIL ped-venda THEN
    ASSIGN v_data = ped-venda.dt-emissao. 
ELSE
    ASSIGN v_data = tit_acr.dat_transacao.

ASSIGN p_perc = 0. /* inicializaá∆o */

if avail emitente then do:
    run esbo/boes464.p persistent set h-boes464.

    ASSIGN c-unid-neg = "".
    IF AVAIL it-nota-fisc THEN DO:
        FIND FIRST unid-neg-fat OF it-nota-fisc NO-LOCK NO-ERROR.
        IF AVAIL unid-neg-fat THEN
            ASSIGN c-unid-neg = unid-neg-fat.cod_unid_negoc.
    END.

    IF c-unid-neg = "" 
    THEN DO:
        assign c-unid-neg = "INVALIDA".

        FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    
        IF  AVAIL item-uni-estab
        THEN
            ASSIGN c-unid-neg = item-uni-estab.cod-unid-neg.
    END.

    RUN getAcordoComercial IN h-boes464    (INPUT emitente.cgc,
                                            INPUT nota-fiscal.cod-estabel,
                                            INPUT c-unid-neg,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT nota-fiscal.dt-emis-nota,
                                            OUTPUT i-id-faturamento-acordo,
                                            OUTPUT i-id-base-calc-acordo,  
                                            OUTPUT i-id-devolucoes,  
                                            OUTPUT p_perc) NO-ERROR.
    delete procedure h-boes464.
        
end.
END PROCEDURE.
