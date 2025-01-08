DEF TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat.

PROCEDURE pi_calc_inad:

    DEF INPUT PARAM fi-periodo    AS CHAR.
    DEF INPUT PARAM p_log_oficial AS LOG.
    DEF INPUT PARAM p_cdn_repres  AS INT.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-comissao-fat.
  
    DEFINE VARIABLE h-boes398        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE v-erro           AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE h-boes396        AS HANDLE      NO-UNDO.

    DEF VAR v_data          AS DATE NO-UNDO.
    DEF VAR v_data_inad     AS DATE NO-UNDO.
    DEF VAR v_num_ano_refer AS INT  NO-UNDO.
    DEF VAR v_num_mes_refer AS INT  NO-UNDO.

    DEFINE VARIABLE v_val_sdo_nf     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_item   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_dev_item   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_base       AS DECIMAL     NO-UNDO.

    DEF BUFFER b-comissao-fat FOR comissao-fat.

    DEF BUFFER b_tit_acr_ve         FOR tit_acr.
    DEF BUFFER b_relacto_tit_acr_ve FOR relacto_tit_acr.
    DEF BUFFER b_movto_tit_acr_ve   FOR movto_tit_acr.
    
    DEF BUFFER b_tit_acr_dm         FOR tit_acr.
    DEF BUFFER b_relacto_tit_acr_dm FOR relacto_tit_acr.
    DEF BUFFER b_movto_tit_acr_dm   FOR movto_tit_acr.

    /* ** Calcula o £ltimo dia do màs de Referància de C†lculo da Comiss∆o ***/
    ASSIGN v_data = DATE("01" + SUBSTRING(fi-periodo, 5, 2) + SUBSTRING(fi-periodo, 1, 4)).
    /* ** Posiciona um màs a frente ***/
    ASSIGN v_num_ano_refer = YEAR(v_data)
           v_num_mes_refer = MONTH(v_data) + 1.
    IF v_num_mes_refer = 13
       THEN ASSIGN v_num_mes_refer = 1
                   v_num_ano_refer = v_num_ano_refer + 1.
    /* ** Diminui um dia para pegar o £ltimo dia do màs anterior ***/
    ASSIGN v_data = DATE('01' + STRING(v_num_mes_refer, '99') + STRING(v_num_ano_refer, '9999'))
           v_data = v_data - 1.

    /* ** Calcula o £ltimo dia do màs anterior de Referància de C†lculo da Comiss∆o, para recuperar a Inadimplància ***/
    ASSIGN v_num_ano_refer = YEAR(v_data)
           v_num_mes_refer = MONTH(v_data).
    /* ** Diminui um dia para pegar o £ltimo dia do màs anterior ***/
    ASSIGN v_data_inad = DATE('01' + STRING(v_num_mes_refer, '99') + STRING(v_num_ano_refer, '9999'))
           v_data_inad = v_data_inad - 1.

    /* ** 4 - Recuperaá∆o Inadimplància
    
       - Verificar todas as comiss‰es com tipo 3 do periodo anterior ao do calculo
       - Reverter toda a inadimplància criando registro tipo 4
       - Marcar como recuperado o registro tipo 3
         Obs. Ser† recuperada toda a inadimplància do per°odo anterior e posteriormente calculada a inadimplància do per°odo atual.
              Esta opá∆o foi considerada pois o controle dos saldos parciais no contas a receber geram muitas d£vidas na conciliaá∆o,
                   pois podem haver v†rios movimentos alterando o saldo do t°tulo, tanto para maior quanto para menor, e a conferància
                   com a inadimplància anterior seria pelo saldo considerado no primeiro calculo.
    ***/    

    /* ** Recuperaá∆o Inadimplància ****/
    IF p_log_oficial = YES 
    THEN DO:
         IF NOT VALID-HANDLE(h-boes396) THEN
            RUN esbo/boes396.p PERSISTENT SET h-boes396.
         FOR EACH comissao-fat EXCLUSIVE-LOCK
             WHERE comissao-fat.periodo        = string(YEAR(v_data_inad),"9999") + string(MONTH(v_data_inad),"99")
               AND comissao-fat.id-tipo-inform = 3 USE-INDEX ch_sec:
    
               /* ** Verifica se o representante est† ativo na data de recuperaá∆o - Tratamento distrato, representantes desativados ***/
               FIND ITEM NO-LOCK
                   WHERE ITEM.it-codigo = comissao-fat.it-codigo NO-ERROR.
               IF AVAIL ITEM 
               THEN DO:

                    FIND FIRST comissoes-faixa NO-LOCK
                         WHERE comissoes-faixa.cod-rep     = comissao-fat.cod-rep
                           AND comissoes-faixa.dt-inicial <= v_data
                           AND comissoes-faixa.dt-final   >= v_data NO-ERROR.
                    IF NOT AVAIL comissoes-faixa 
                    OR comissoes-faixa.vl-percentual = 0 
                       THEN NEXT. 

               END.

               /* ** Sempre que for alterada alguma regra no calculo da inadimplància, observar que a recuperaá∆o n∆o efetua nenhuma validaá∆o
                     Os registros tipo 3 devem ser igual ao valor descontado do representante no màs anterior ***/
               FIND FIRST b-comissao-fat NO-LOCK
                    WHERE b-comissao-fat.cod-estabel    = comissao-fat.cod-estabel   
                      AND b-comissao-fat.especie        = comissao-fat.especie       
                      AND b-comissao-fat.serie          = comissao-fat.serie         
                      AND b-comissao-fat.nr-nota-fis    = comissao-fat.nr-nota-fis   
                      AND b-comissao-fat.parcela        = comissao-fat.parcela       
                      AND b-comissao-fat.id-tipo-inform = 4
                      AND b-comissao-fat.cod-rep        = comissao-fat.cod-rep       
                      AND b-comissao-fat.it-codigo      = comissao-fat.it-codigo     
                      AND b-comissao-fat.sequencia      = comissao-fat.sequencia     
                      AND b-comissao-fat.periodo        = STRING(YEAR(v_data),"9999") + STRING(MONTH(v_data),"99") NO-ERROR.      
               IF NOT AVAIL b-comissao-fat 
               THEN DO:
                    CREATE b-comissao-fat.
                    BUFFER-COPY comissao-fat EXCEPT comissao-fat.id-tipo-inform comissao-fat.periodo TO b-comissao-fat.
                    ASSIGN b-comissao-fat.periodo        = STRING(YEAR(v_data),"9999") + STRING(MONTH(v_data),"99")
                           b-comissao-fat.id-tipo-inform = 4.

                    /* ** Converte os valores para (+) ***/
                    ASSIGN b-comissao-fat.vl-s-acordo = b-comissao-fat.vl-s-acordo * (-1)
                           b-comissao-fat.vl-merc-liq = b-comissao-fat.vl-merc-liq * (-1)
                           b-comissao-fat.vl-comissao = b-comissao-fat.vl-comissao * (-1)
                           b-comissao-fat.vl-a-vista  = b-comissao-fat.vl-a-vista  * (-1).
               END.

               /* ** Assinala a Inadimplància como recuperada ***/
               ASSIGN comissao-fat.log-recuperado = YES.

         END.
         IF VALID-HANDLE(h-boes396) THEN
            DELETE PROCEDURE h-boes396.    
    END.

    /* ** 3 - C†lculo Inadimplància ***/
    RUN esbo/boes398.p PERSISTENT SET h-boes398.
  
    FOR EACH estabelecimento NO-LOCK:
  
        IF estabelecimento.cod_estab = '201' 
           THEN NEXT. /*Titulos migrados para 102*/
  
        /* ** Calcula Comiss∆o Cobranáa Normal ***/
        FOR EACH tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
              AND tit_acr.cod_espec           = 'DM'
              AND tit_acr.log_sdo_tit_acr     = YES
              AND tit_acr.log_tit_acr_estordo = NO:
  
            IF v_data - tit_acr.dat_vencto_tit_acr < 30 
               THEN NEXT. /*Inadimplància 30 dias*/
  
            /* ** Inadimplància ****/
            FIND FIRST comissao-fat NO-LOCK
                 WHERE comissao-fat.cod-estabel    = tit_acr.cod_estab
                   AND comissao-fat.especie        = tit_acr.cod_espec
                   AND comissao-fat.serie          = tit_acr.cod_ser
                   AND comissao-fat.nr-nota-fis    = tit_acr.cod_tit_acr
                   AND comissao-fat.parcela        = tit_acr.cod_parcela
                   AND comissao-fat.id-tipo-inform = 3 
                   AND comissao-fat.periodo        = string(YEAR(v_data),"9999") + string(MONTH(v_data),"99") NO-ERROR.
            IF AVAIL comissao-fat 
               THEN NEXT. /* ** Inadimplància j† registrada ***/
  
            FIND fat-duplic NO-LOCK
                WHERE fat-duplic.cod-estabel = tit_acr.cod_estab
                  AND fat-duplic.serie       = tit_acr.cod_ser
                  AND fat-duplic.nr-fatura   = tit_acr.cod_tit_acr
                  AND fat-duplic.parcela     = tit_acr.cod_parcela
                  AND fat-duplic.cod-esp     = tit_acr.cod_espec NO-ERROR.
            IF NOT AVAIL fat-duplic 
            THEN DO: 
                 NEXT.
            END.
  
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = fat-duplic.cod-estabel
                   AND nota-fiscal.serie       = fat-duplic.serie
                   AND nota-fiscal.nr-fatura   = fat-duplic.nr-fatura NO-ERROR.
            IF NOT AVAIL nota-fiscal
            THEN DO: 
                 NEXT.
            END.
            
            /* ** Calcula o saldo da NF, valor original - devoluá∆o 
                  Este calculo Ç necess†rio para proporcionalizar o valor da inadimplància ***/
            ASSIGN v_val_sdo_nf   = 0
                   v_tot_dev_item = 0.
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FOR EACH devol-cli  NO-LOCK
                    WHERE devol-cli.serie        = nota-fiscal.serie
                      AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                      AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                      AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat,
                    EACH item-doc-est OF devol-cli NO-LOCK:
                    ASSIGN v_tot_dev_item = v_tot_dev_item + item-doc-est.preco-total[1] /* valor devoluá∆o do item */.
                END.
                ASSIGN v_val_sdo_nf   = v_val_sdo_nf + (it-nota-fisc.vl-merc-liq - v_tot_dev_item)
                       v_tot_dev_item = 0.
            END.

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
                EACH fat-repre NO-LOCK
                WHERE fat-repre.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-repre.serie       = nota-fiscal.serie
                  AND fat-repre.nr-fatura   = nota-fiscal.nr-fatura,
                FIRST repres NO-LOCK 
                WHERE repres.nome-abrev     = fat-repre.nome-ab-rep:  

                /* ** Simulaá∆o Ç feita por Representante, a Oficial gera para todos ***/
                IF p_log_oficial = NO
                THEN DO:
                     IF p_cdn_repres <> repres.cod-rep 
                        THEN NEXT.
                END.

                /* ** Calcula o saldo do Item, valor original - devoluá∆o 
                      Este calculo Ç necess†rio para proporcionalizar o valor da inadimplància ***/
                ASSIGN v_tot_dev_item = 0.
                FOR EACH devol-cli  NO-LOCK
                    WHERE devol-cli.serie        = nota-fiscal.serie
                      AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                      AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                      AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat,
                    EACH item-doc-est OF devol-cli NO-LOCK:
                    ASSIGN v_tot_dev_item = v_tot_dev_item + item-doc-est.preco-total[1] /* valor devoluá∆o do item */.
                END.
                ASSIGN v_val_sdo_item = it-nota-fisc.vl-merc-liq - v_tot_dev_item.

                IF v_val_sdo_item > 0 
                THEN DO:

                     /* ** Calcula valor do item ***/
                     ASSIGN v_val_base = ((((tit_acr.val_sdo_tit_acr * (v_val_sdo_item * 100 / v_val_sdo_nf)) / 100)) * (-1)).

                     RUN comissoes IN h-boes398 (INPUT 3,
                                                 INPUT p_log_oficial, /* yes = grava na tabela , no = grava na temp-table */
                                                 INPUT nota-fiscal.cod-estabel,   
                                                 INPUT nota-fiscal.cod-emitente,  
                                                 INPUT repres.cod-rep,    
                                                 INPUT it-nota-fisc.it-codigo,   
                                                 INPUT it-nota-fisc.nr-seq-fat,
                                                 INPUT it-nota-fisc.qt-faturada[1],
                                                 INPUT v_data, 
                                                 INPUT v_data,
                                                 INPUT ?,  
                                                 INPUT nota-fiscal.serie,         
                                                 INPUT nota-fiscal.nr-nota-fis,      
                                                 INPUT "",
                                                 INPUT tit_acr.cod_parcela,
                                                 INPUT tit_acr.cod_espec_docto,
                                                 INPUT nota-fiscal.nr-praz-med,   
                                                 INPUT nota-fiscal.cod-cond-pag,  
                                                 INPUT v_val_base,   
                                                 OUTPUT v-erro,
                                                 INPUT-OUTPUT TABLE tt-comissao-fat).          
                END.
  
            END.
  
        END.

        /* ** Calcula Comiss∆o Cobranáa Vendor ***/
        FOR EACH tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
              AND tit_acr.cod_espec           = 'VD'
              AND tit_acr.log_sdo_tit_acr     = YES
              AND tit_acr.log_tit_acr_estordo = NO:

            /* ** Localiza VE ***/
            FIND b_relacto_tit_acr_ve NO-LOCK 
                WHERE b_relacto_tit_acr_ve.cod_estab      = tit_acr.cod_estab
                  AND b_relacto_tit_acr_ve.num_id_tit_acr = tit_acr.num_id_tit_acr.
            FIND b_movto_tit_acr_ve NO-LOCK 
                WHERE b_movto_tit_acr_ve.cod_estab            = b_relacto_tit_acr_ve.cod_estab_tit_acr_pai
                  AND b_movto_tit_acr_ve.num_id_movto_tit_acr = b_relacto_tit_acr_ve.num_id_movto_tit_acr_pai.
            FIND b_tit_acr_ve NO-LOCK 
                WHERE b_tit_acr_ve.cod_estab      = b_movto_tit_acr_ve.cod_estab
                  AND b_tit_acr_ve.num_id_tit_acr = b_movto_tit_acr_ve.num_id_tit_acr.
  
            /* ** Localiza DM ***/
            FIND b_relacto_tit_acr_dm NO-LOCK 
                WHERE b_relacto_tit_acr_dm.cod_estab      = b_tit_acr_ve.cod_estab
                  AND b_relacto_tit_acr_dm.num_id_tit_acr = b_tit_acr_ve.num_id_tit_acr.
            FIND b_movto_tit_acr_dm NO-LOCK 
                WHERE b_movto_tit_acr_dm.cod_estab            = b_relacto_tit_acr_dm.cod_estab_tit_acr_pai
                  AND b_movto_tit_acr_dm.num_id_movto_tit_acr = b_relacto_tit_acr_dm.num_id_movto_tit_acr_pai.
            FIND b_tit_acr_dm NO-LOCK 
                WHERE b_tit_acr_dm.cod_estab      = b_movto_tit_acr_dm.cod_estab
                  AND b_tit_acr_dm.num_id_tit_acr = b_movto_tit_acr_dm.num_id_tit_acr.

            /* ** Calcula Comiss∆o com a DM Origem b_tit_acr_dm ***/
            IF v_data - tit_acr.dat_vencto_tit_acr < 30 
               THEN NEXT. /*Inadimplància 30 dias*/
  
            /* ** Inadimplància ****/
            FIND FIRST comissao-fat NO-LOCK
                 WHERE comissao-fat.cod-estabel    = b_tit_acr_dm.cod_estab
                   AND comissao-fat.especie        = b_tit_acr_dm.cod_espec
                   AND comissao-fat.serie          = b_tit_acr_dm.cod_ser
                   AND comissao-fat.nr-nota-fis    = b_tit_acr_dm.cod_tit_acr
                   AND comissao-fat.parcela        = b_tit_acr_dm.cod_parcela
                   AND comissao-fat.id-tipo-inform = 3 
                   AND comissao-fat.periodo        = string(YEAR(v_data),"9999") + string(MONTH(v_data),"99") NO-ERROR.
            IF AVAIL comissao-fat 
               THEN NEXT. /* ** Inadimplància j† registrada ***/
  
            FIND fat-duplic NO-LOCK
                WHERE fat-duplic.cod-estabel = b_tit_acr_dm.cod_estab
                  AND fat-duplic.serie       = b_tit_acr_dm.cod_ser
                  AND fat-duplic.nr-fatura   = b_tit_acr_dm.cod_tit_acr
                  AND fat-duplic.parcela     = b_tit_acr_dm.cod_parcela
                  AND fat-duplic.cod-esp     = b_tit_acr_dm.cod_espec NO-ERROR.
            IF NOT AVAIL fat-duplic 
            THEN DO: 
                 NEXT.
            END.
  
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = fat-duplic.cod-estabel
                   AND nota-fiscal.serie       = fat-duplic.serie
                   AND nota-fiscal.nr-fatura   = fat-duplic.nr-fatura NO-ERROR.
            IF NOT AVAIL nota-fiscal
            THEN DO: 
                 NEXT.
            END.
            
            /* ** Calcula o saldo da NF, valor original - devoluá∆o 
                  Este calculo Ç necess†rio para proporcionalizar o valor da inadimplància ***/
            ASSIGN v_val_sdo_nf   = 0
                   v_tot_dev_item = 0.
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FOR EACH devol-cli  NO-LOCK
                    WHERE devol-cli.serie        = nota-fiscal.serie
                      AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                      AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                      AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat,
                    EACH item-doc-est OF devol-cli NO-LOCK:
                    ASSIGN v_tot_dev_item = v_tot_dev_item + item-doc-est.preco-total[1] /* valor devoluá∆o do item */.
                END.
                ASSIGN v_val_sdo_nf   = v_val_sdo_nf + (it-nota-fisc.vl-merc-liq - v_tot_dev_item)
                       v_tot_dev_item = 0.
            END.

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
                EACH fat-repre NO-LOCK
                WHERE fat-repre.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-repre.serie       = nota-fiscal.serie
                  AND fat-repre.nr-fatura   = nota-fiscal.nr-fatura,
                FIRST repres NO-LOCK 
                WHERE repres.nome-abrev     = fat-repre.nome-ab-rep:  

                /* ** Simulaá∆o Ç feita por Representante, a Oficial gera para todos ***/
                IF p_log_oficial = NO
                THEN DO:
                     IF p_cdn_repres <> repres.cod-rep 
                        THEN NEXT.
                END.

                /* ** Calcula o saldo do Item, valor original - devoluá∆o 
                      Este calculo Ç necess†rio para proporcionalizar o valor da inadimplància ***/
                ASSIGN v_tot_dev_item = 0.
                FOR EACH devol-cli  NO-LOCK
                    WHERE devol-cli.serie        = nota-fiscal.serie
                      AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                      AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                      AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat,
                    EACH item-doc-est OF devol-cli NO-LOCK:
                    ASSIGN v_tot_dev_item = v_tot_dev_item + item-doc-est.preco-total[1] /* valor devoluá∆o do item */.
                END.
                ASSIGN v_val_sdo_item = it-nota-fisc.vl-merc-liq - v_tot_dev_item.

                IF v_val_sdo_item > 0 
                THEN DO:

                     /* ** Calcula valor do item ***/
                     ASSIGN v_val_base = ((((tit_acr.val_sdo_tit_acr * (v_val_sdo_item * 100 / v_val_sdo_nf)) / 100)) * (-1)).

                     RUN comissoes IN h-boes398 (INPUT 3,
                                                 INPUT p_log_oficial, /* yes = grava na tabela , no = grava na temp-table */
                                                 INPUT nota-fiscal.cod-estabel,   
                                                 INPUT nota-fiscal.cod-emitente,  
                                                 INPUT repres.cod-rep,    
                                                 INPUT it-nota-fisc.it-codigo,   
                                                 INPUT it-nota-fisc.nr-seq-fat,
                                                 INPUT it-nota-fisc.qt-faturada[1],
                                                 INPUT v_data, 
                                                 INPUT v_data,
                                                 INPUT ?,  
                                                 INPUT nota-fiscal.serie,         
                                                 INPUT nota-fiscal.nr-nota-fis,      
                                                 INPUT "",
                                                 INPUT b_tit_acr_dm.cod_parcela,
                                                 INPUT b_tit_acr_dm.cod_espec_docto,
                                                 INPUT nota-fiscal.nr-praz-med,   
                                                 INPUT nota-fiscal.cod-cond-pag,  
                                                 INPUT v_val_base,   
                                                 OUTPUT v-erro,
                                                 INPUT-OUTPUT TABLE tt-comissao-fat).          
                END.
  
            END.

        END.
  
    END.

    DELETE PROCEDURE h-boes398.

END.
