{esp/es0018.i}
{esp/acr/esacr078.i}
DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura
    FIELD num-pedido LIKE pedido-compr.num-pedido
    FIELD lido       AS LOG.

DEFINE VARIABLE i-seq          AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-arquivo-csv       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-dir-saida         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-arq-excel         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE v_tta_num_seq_refer AS INTEGER                      NO-UNDO.
DEFINE VARIABLE v_dat_vencto        LIKE tit_acr.dat_vencto_tit_acr NO-UNDO.
DEFINE VARIABLE v_data_ven_aux      AS DATE NO-UNDO.

def var i-parc          as integer.
def var i-pagto         as integer.
def var c-cod-unid-neg  as char.
def var vl-tot-parcelas as decimal.

DEF BUFFER b-cond-ped FOR cond-ped.

DEFINE STREAM str-excel.
DEFINE STREAM tt-acr.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estabel-ini  LIKE nota-fiscal.cod-estabel
    FIELD cod-estabel-fim  LIKE nota-fiscal.cod-estabel
    FIELD serie-ini        LIKE nota-fiscal.serie
    FIELD serie-fim        LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-ini      LIKE nota-fiscal.dt-emis
    FIELD dt-emis-fim      LIKE nota-fiscal.dt-emis
    .

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esacr078_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    /**/
    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini
        AND   nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim
        AND   nota-fiscal.serie       >= tt-param.serie-ini
        AND   nota-fiscal.serie       <= tt-param.serie-fim
        AND   nota-fiscal.nr-nota-fis >= tt-param.nr-nota-fis-ini
        AND   nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fis-fim
        AND   nota-fiscal.dt-emis     >= tt-param.dt-emis-ini
        AND   nota-fiscal.dt-emis     <= tt-param.dt-emis-fim
        AND   nota-fiscal.dt-atual-cr  = ?:

        IF  nota-fiscal.cod-cond-pag = 0 THEN DO:
            
            EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
            EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_9.
            EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.
            EMPTY TEMP-TABLE tt_log_erros_atualiz.
    
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                 AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

            IF  NOT AVAIL ped-venda THEN 
                NEXT.

            FIND FIRST int-ped-venda
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

            IF  AVAIL int-ped-venda 
            AND int-ped-venda.cod-projeto = "" AND NOT int-ped-venda.origem MATCHES("*Salesforce*") THEN /* Considerar apenas pedidos da Solar */
                NEXT.

            ASSIGN i-pagto = 0.

            IF CAN-FIND(FIRST cond-ped OF ped-venda) THEN DO: //existe a cond-ped na ped-venda

                ASSIGN v_data_ven_aux = ?.

                /* ajuste vencimento das parcelas para pedidos faturados em meses posteriores */
                FIND FIRST b-cond-ped OF ped-venda NO-LOCK
                     WHERE b-cond-ped.data-pagto < nota-fiscal.dt-emis-nota NO-ERROR.
                
                IF  AVAIL b-cond-ped THEN DO:
                    ASSIGN v_data_ven_aux = nota-fiscal.dt-emis-nota.
                
                    FOR EACH b-cond-ped OF ped-venda EXCLUSIVE-LOCK
                        BREAK BY (SUBSTRING(b-cond-ped.observacoes,1,4)):
                
                        IF  SUBSTRING(b-cond-ped.observacoes,1,4) <> "" THEN DO:
                            ASSIGN b-cond-ped.data-pagto = v_data_ven_aux.
                
                            ASSIGN v_data_ven_aux = v_data_ven_aux + 30.
                        END.
                    END.
                END.
                /* ajuste vencimento das parcelas para pedidos faturados em meses posteriores */

               FOR EACH cond-ped OF ped-venda NO-LOCK
                   BREAK BY cond-ped.observacoes:
               
                   IF  SUBSTRING(cond-ped.observacoes,1,4) <> "" THEN DO:
                       ASSIGN i-parc          = i-parc + 1
                              vl-tot-parcelas = vl-tot-parcelas + cond-ped.vl-pagto.
               
                       IF  FIRST-OF(cond-ped.observacoes) THEN DO:
                           ASSIGN i-pagto = i-pagto + 1.
                           
                           RUN pi-cria-lote.
                       
                           ASSIGN v_tta_num_seq_refer = 1.
                       END.
                 
                       IF  LAST-OF(cond-ped.observacoes) THEN DO:
                           RUN pi-cria-item-lote.
               
                           ASSIGN i-parc          = 0
                                  vl-tot-parcelas = 0.
               
                           ASSIGN v_tta_num_seq_refer = v_tta_num_seq_refer + 1.
                       END.
                   END.
               END.
            END.
            ELSE DO: //sem cond-ped com condicao pagto 0
                FIND FIRST natur-oper NO-LOCK
                     WHERE natur-oper.nat-oper = ped-venda.nat-oper NO-ERROR.
                IF AVAIL natur-oper AND NOT natur-oper.emite-duplic THEN DO:
                    FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
                    ASSIGN nota-fiscal.dt-atual-cr = TODAY.
                    FIND CURRENT nota-fiscal NO-LOCK.
                END.
            END.

            OUTPUT STREAM tt-acr TO VALUE(SESSION:TEMP-DIRECTORY + "tt_integr_acr_item_lote_impl_9-" + nota-fiscal.nr-nota-fis + "-" + nota-fiscal.serie + ".txt").
            FOR EACH tt_integr_acr_item_lote_impl_9:
                EXPORT STREAM tt-acr tt_integr_acr_item_lote_impl_9.
            END.
            OUTPUT STREAM tt-acr CLOSE.
        
            FIND FIRST tt_integr_acr_lote_impl NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt_integr_acr_lote_impl THEN
                NEXT.
            
            DO TRANSACTION ON ERROR UNDO, LEAVE:
                RUN prgfin/acr/acr900zi.py PERSISTENT SET v_hdl_api_integr_acr.
                RUN pi_main_code_integr_acr_new_12 IN v_hdl_api_integr_acr (INPUT 12,
                                                                            INPUT "",  /*Matriz Trad Org Ext*/
                                                                            INPUT yes, /*Log Atualiz Refer*/
                                                                            INPUT NO,  /*Assume Data Emiss*/
                                                                            INPUT TABLE tt_integr_acr_repres_comis_2,
                                                                            INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_9,
                                                                            INPUT TABLE tt_integr_acr_aprop_relacto_2,
                                                                            INPUT-OUTPUT TABLE tt_params_generic_api,
                                                                            INPUT TABLE tt_integr_acr_relacto_pend_aux) /* prg_api_integr_acr_new_5*/.
                DELETE PROCEDURE v_hdl_api_integr_acr.
            END.
            
            FOR EACH tt_log_erros_atualiz:
                PUT STREAM str-excel UNFORMATTED nota-fiscal.nr-nota-fis + ";" +
                                                 nota-fiscal.serie       + ";" + 
                                                 tt_log_erros_atualiz.ttv_des_msg_erro SKIP.
            END.
    
            IF  NOT CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
                FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
                ASSIGN nota-fiscal.dt-atual-cr = TODAY.
                FIND CURRENT nota-fiscal NO-LOCK.
    
                PUT STREAM str-excel UNFORMATTED nota-fiscal.nr-nota-fis + ";" +
                                                 nota-fiscal.serie       + ";" + 
                                                 "Nota fiscal atualizada com sucesso no contas a receber." SKIP.
            END.
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF  NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-cria-lote:
   ASSIGN v-log-primeira-vez = YES.

   REPEAT WHILE AVAIL tt_integr_acr_lote_impl OR v-log-primeira-vez:
       ASSIGN v-log-primeira-vez = NO
              c-referencia = (substring(cond-ped.observacoes,1,4)) + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") + chr(RANDOM(65, 90)) + chr(RANDOM(65, 90)) + chr(RANDOM(65, 90)).

       FIND FIRST tt_integr_acr_lote_impl 
            WHERE tt_integr_acr_lote_impl.tta_cod_refer = c-referencia NO-ERROR.
   END.

   /*Criando Temp Table*/
   /*lotes de implantaá∆o*/		
   CREATE tt_integr_acr_lote_impl.
   ASSIGN tt_integr_acr_lote_impl.tta_cod_estab                  = nota-fiscal.cod-estabel
          tt_integr_acr_lote_impl.tta_cod_refer                  = c-referencia
          tt_integr_acr_lote_impl.tta_dat_transacao              = date(month(nota-fiscal.dt-emis),day(nota-fiscal.dt-emis),YEAR(nota-fiscal.dt-emis))
          tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr           = if (substring(cond-ped.observacoes,1,4)) begins 'BOLE' then 'Normal' else "Especial"
          tt_integr_acr_lote_impl.tta_ind_orig_tit_acr           = 'ACREMS50'
          tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr  = 0 
          tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr = 0
          tt_integr_acr_lote_impl.tta_cod_empresa                = v_cod_empres_usuar
          v-rec-lote = RECID(tt_integr_acr_lote_impl).

   FIND FIRST tt_integr_acr_lote_impl 
        WHERE RECID(tt_integr_acr_lote_impl) = v-rec-lote NO-ERROR.
END.

PROCEDURE pi-cria-item-lote.    
    ASSIGN c-titulo     = string(nota-fiscal.nr-nota-fis) + '/' + string(i-pagto)
           v_dat_vencto = nota-fiscal.dt-emis-nota.
    
    IF  ped-venda.cod-cond-pag = 0 /* Boleto Bradesco - B2C */
    AND TRIM(SUBSTRING(cond-ped.observacoes,1,6)) = 'BOLETO' THEN DO:
        ASSIGN v_cod_portador  = '341'
               v_cod_cart_bcia = '90'
               v_dat_vencto    = nota-fiscal.dt-emis-nota.
    END.
    ELSE DO:
        ASSIGN v_cod_portador         = ""
               v_cod_admdra_cartao_cr = ""
               v_cod_cart_bcia        = "".
        
        IF  AVAIL cond-ped 
        AND TRIM(SUBSTRING(cond-ped.observacoes,1,4)) <> "" THEN DO:
            /* Cart∆o de Credito */
            RUN esp/es0018p.p (INPUT "Solar":U,
                               INPUT 3,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
        
            FIND FIRST tt-prog-ponto 
                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") BEGINS TRIM(SUBSTRING(cond-ped.observacoes,1,4)) NO-ERROR.
        
            IF  AVAIL tt-prog-ponto THEN DO:
                IF ENTRY(3,tt-prog-ponto.conteudo,";") = "MKT" THEN DO:
                    ASSIGN v_cod_portador              = entry(2,tt-prog-ponto.conteudo,";")
                           v_cod_admdra_cartao_cr      = entry(5,tt-prog-ponto.conteudo,";")
                           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr  = "Especial".
        
                    RETURN "OK".
                END.
                
                ASSIGN v_cod_portador         = entry(2,tt-prog-ponto.conteudo,";") /*Redcard B2B*/
                       v_cod_admdra_cartao_cr = entry(3,tt-prog-ponto.conteudo,";") /*Administradora*/
                       v_cod_cartao_cr        = entry(4,tt-prog-ponto.conteudo,";") /*Bandeira*/
                       v_cod_cart_bcia        = entry(5,tt-prog-ponto.conteudo,";")
                       v_dat_vencto           = cond-ped.data-pagto.  

                IF  TRIM(SUBSTRING(cond-ped.observacoes,1,3)) = 'PIX' THEN
                    ASSIGN tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr  = "Normal".
            END.
            ELSE DO:
                /* Financiamento */
                RUN esp/es0018p.p (INPUT "Solar":U,
                                   INPUT 8,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
            
                FIND FIRST tt-prog-ponto 
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") BEGINS TRIM(SUBSTRING(cond-ped.observacoes,1,4)) NO-ERROR.
            
                IF  AVAIL tt-prog-ponto THEN
                    ASSIGN v_cod_portador                                = entry(2,tt-prog-ponto.conteudo,";")
                           v_cod_cart_bcia                               = entry(3,tt-prog-ponto.conteudo,";")
                           v_dat_vencto                                  = nota-fiscal.dt-emis-nota
                           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr  = "Normal".
            END.
        END.
    END.

    CREATE tt_integr_acr_item_lote_impl_9.
    ASSIGN tt_integr_acr_item_lote_impl_9.ttv_rec_lote_impl_tit_acr     = RECID(tt_integr_acr_lote_impl)
           tt_integr_acr_item_lote_impl_9.tta_ind_tip_espec_docto       = 'Normal'
           tt_integr_acr_item_lote_impl_9.tta_cod_portador              = v_cod_portador      
           tt_integr_acr_item_lote_impl_9.tta_cod_cart_bcia             = v_cod_cart_bcia         
           tt_integr_acr_item_lote_impl_9.tta_cod_espec_docto           = "DM"
           tt_integr_acr_item_lote_impl_9.tta_cod_parcela               = "01"
           tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr               = c-titulo
           tt_integr_acr_item_lote_impl_9.tta_num_seq_refer             = v_tta_num_seq_refer
           tt_integr_acr_item_lote_impl_9.tta_cdn_cliente               = nota-fiscal.cod-emitente
           tt_integr_acr_item_lote_impl_9.tta_cod_ser_docto             = nota-fiscal.serie         
           tt_integr_acr_item_lote_impl_9.tta_cod_finalid_econ_ext      = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_finalid_econ          = "Corrente"
           tt_integr_acr_item_lote_impl_9.tta_cod_finalid_econ_ext      = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_indic_econ            = "Real"
           tt_integr_acr_item_lote_impl_9.tta_cod_portad_ext            = ""
           tt_integr_acr_item_lote_impl_9.tta_dat_vencto_tit_acr        = v_dat_vencto
           tt_integr_acr_item_lote_impl_9.tta_dat_prev_liquidac         = v_dat_vencto
           tt_integr_acr_item_lote_impl_9.tta_dat_desconto              = ?
           tt_integr_acr_item_lote_impl_9.tta_dat_emis_docto            = nota-fiscal.dt-emis
           tt_integr_acr_item_lote_impl_9.tta_cod_cond_cobr             = ""
           tt_integr_acr_item_lote_impl_9.tta_val_tit_acr               = vl-tot-parcelas
           tt_integr_acr_item_lote_impl_9.tta_val_desconto              = 0
           tt_integr_acr_item_lote_impl_9.tta_val_perc_desc             = 0
           tt_integr_acr_item_lote_impl_9.tta_val_perc_juros_dia_atraso = 0
           tt_integr_acr_item_lote_impl_9.tta_val_perc_multa_atraso     = 0
           tt_integr_acr_item_lote_impl_9.tta_des_text_histor           = "" 
           tt_integr_acr_item_lote_impl_9.tta_cod_instruc_bcia_1_movto  = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_instruc_bcia_2_movto  = ""
           tt_integr_acr_item_lote_impl_9.tta_qtd_dias_carenc_juros_acr = ? 
           tt_integr_acr_item_lote_impl_9.tta_val_liq_tit_acr           = vl-tot-parcelas
           tt_integr_acr_item_lote_impl_9.tta_cod_agenc_cobr_bcia       = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr_bco           = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_cartcred              = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_mes_ano_valid_cartao  = ""
           tt_integr_acr_item_lote_impl_9.ttv_cod_lote_origin           = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_conces_telef          = ""
           tt_integr_acr_item_lote_impl_9.tta_num_ddd_localid_conces    = 0
           tt_integr_acr_item_lote_impl_9.tta_num_prefix_localid_conces = 0
           tt_integr_acr_item_lote_impl_9.tta_num_milhar_localid_conces = 0
           tt_integr_acr_item_lote_impl_9.tta_cod_banco                 = "" 
           tt_integr_acr_item_lote_impl_9.tta_cod_agenc_bcia            = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_cta_corren_bco        = ""
           tt_integr_acr_item_lote_impl_9.tta_cod_digito_cta_corren     = ""
           tt_integr_acr_item_lote_impl_9.tta_val_cotac_indic_econ      = 1
           tt_integr_acr_item_lote_impl_9.tta_ind_tip_calc_juros        = "Simples"
           tt_integr_acr_item_lote_impl_9.ttv_rec_item_lote_impl_tit_acr = recid(tt_integr_acr_item_lote_impl_9)
           tt_integr_acr_item_lote_impl_9.tta_cod_motiv_movto_tit_acr   = ""
           tt_integr_acr_item_lote_impl_9.tta_log_liquidac_autom        = NO
           tt_integr_acr_item_lote_impl_9.tta_val_base_calc_impto       = 0
           tt_integr_acr_item_lote_impl_9.tta_log_retenc_impto_impl     = YES
           tt_integr_acr_item_lote_impl_9.tta_cod_proces_export         = "".    
    
    /* Cartío de Cr≤dito - IMPORTANTE-CIASHOP */
    ASSIGN tt_integr_acr_item_lote_impl_9.tta_cod_admdra_cartao_cr    = v_cod_admdra_cartao_cr  /*"2"*/
           tt_integr_acr_item_lote_impl_9.tta_cod_band                = ""
           tt_integr_acr_item_lote_impl_9.tta_dat_compra_cartao_cr    = nota-fiscal.dt-emis-nota
           tt_integr_acr_item_lote_impl_9.ttv_cod_comprov_vda         = "123456789012"
           tt_integr_acr_item_lote_impl_9.ttv_cod_autoriz_bco_emissor = "123ABC"
           tt_integr_acr_item_lote_impl_9.ttv_num_parc_cartcred       = i-parc. 
    /* FIM-Cartío de Cr≤dito - IMPORTANTE-CIASHOP */
    
    IF ped-venda.cod-unid-neg = '' THEN DO:
       find first ped-item of ped-venda no-lock no-error.
       if avail ped-item then 
          assign c-cod-unid-neg = ped-item.cod-unid-neg.
    end.
    else assign c-cod-unid-neg = ped-venda.cod-unid-neg.
    
    CREATE tt_integr_acr_aprop_ctbl_pend.
    ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_9)
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "PADRAO"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = "11910010"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl_ext           = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext       = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = c-cod-unid-neg
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc_ext         = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto_ext             = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = "103"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_fluxo_financ_ext       = ""
           tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = vl-tot-parcelas
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_federac           = ""
           tt_integr_acr_aprop_ctbl_pend.tta_log_impto_val_agreg        = NO
           tt_integr_acr_aprop_ctbl_pend.tta_cod_imposto                = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_classif_impto          = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_pais                   = ""
           tt_integr_acr_aprop_ctbl_pend.tta_cod_pais_ext               = "".
    
    RELEASE tt_integr_acr_item_lote_impl_9.
END.
