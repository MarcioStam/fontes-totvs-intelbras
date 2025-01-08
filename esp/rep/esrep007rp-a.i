/*------------------------------------------------------*/
/*  CRIA tt-documento para a procedure piRelatSintetico */
/*------------------------------------------------------*/
        IF  docum-est.ce-atual      = NO AND 
            tt-param.log-nf-atualiz = YES
        THEN
            NEXT {1}.


        FIND FIRST int-docum-est WHERE 
                   int-docum-est.serie-docto  = docum-est.serie-docto  AND
                   int-docum-est.nro-docto    = docum-est.nro-docto    AND
                   int-docum-est.cod-emitente = docum-est.cod-emitente AND
                   int-docum-est.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR. 
        IF AVAIL int-docum-est THEN DO:
           ASSIGN cod-motivacao = int-docum-est.cod-msg-devolucao. 
        END.
        ELSE DO:
           ASSIGN cod-motivacao = 0.
        END.

        
        IF cod-motivacao < tt-param.cod-msg-devolucao-ini
        OR cod-motivacao > tt-param.cod-msg-devolucao-fim THEN
             NEXT {1}.

        FIND FIRST int-codigo-servico NO-LOCK
             WHERE int-codigo-servico.cd-servico = int-docum-est.cd-servico NO-ERROR.
    
        FIND FIRST int-enquadramento NO-LOCK
             WHERE int-enquadramento.cd-enquadramento = int-docum-est.cd-enquadramento NO-ERROR.

        FIND FIRST int-atividade-mei NO-LOCK
             WHERE int-atividade-mei.cod-atividade = int-docum-est.cod-atividade-mei NO-ERROR.

        if can-find(first tt-digita WHERE tt-digita.nat-operacao <> "") 
        THEN DO:
            if not can-find(first tt-digita no-lock 
                            where tt-digita.nat-operacao = docum-est.nat-operacao) 
             then 
                next.
        END.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
        IF NOT AVAIL natur-oper 
        THEN 
            NEXT.

        /*Verifica notas devolucao*/
        IF NOT tt-param.imprime-devol AND 
               natur-oper.tipo-compra = 3 
        THEN 
            NEXT.

        FIND FIRST emitente 
             WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

        if tt-param.natureza = 1 and emitente.natureza <> 1 then next.
        if tt-param.natureza = 2 and emitente.natureza <> 2 then next.

        IF  tt-param.log-filtra-impto = YES
        THEN DO:
            FIND FIRST tt-fornec-imposto NO-LOCK
                WHERE  tt-fornec-imposto.cod-emitente = docum-est.cod-emitente NO-ERROR.

            IF  AVAIL tt-fornec-imposto
            THEN DO:
                IF  tt-fornec-imposto.log-listar = NO
                THEN
                    NEXT.
            END.
            ELSE DO:
                RUN esp/rep/esrep007rp-ems5.p (INPUT TABLE tt-digita,
                                               INPUT docum-est.cod-emitente,
                                               OUTPUT v-log-listar).
                CREATE tt-fornec-imposto.
                ASSIGN tt-fornec-imposto.cod-emitente = docum-est.cod-emitente
                       tt-fornec-imposto.log-listar   = v-log-listar.

                IF  v-log-listar = NO
                THEN
                    NEXT.
            END.
        END. /* IF  tt-param.log-filtra-impto = YES */

        CREATE tt-documento.
        ASSIGN tt-documento.nro-docto        = docum-est.nro-docto
               tt-documento.serie-docto      = docum-est.serie-docto
               tt-documento.dt-trans         = docum-est.dt-trans
               tt-documento.cod-emitente     = docum-est.cod-emitente
               tt-documento.nome-abrev       = IF tt-param.imprime-conta THEN emitente.nome-emit ELSE emitente.nome-abrev
               tt-documento.cgc              = emitente.cgc
               tt-documento.nat-operacao     = docum-est.nat-operacao
               tt-documento.valor-mercadoria = docum-est.valor-mercad
               tt-documento.valor-frete      = docum-est.valor-frete
               tt-documento.valor-frete      = docum-est.valor-frete
               tt-documento.valor-seguro     = docum-est.valor-seguro
               tt-documento.char-1           = docum-est.char-1
               tt-documento.tot-valor        = docum-est.tot-valor
               tt-documento.icm-deb-cre      = docum-est.icm-deb-cre
               tt-documento.icm-complem      = docum-est.icm-complem
               tt-documento.aliquota-icm     = docum-est.aliquota-icm
               tt-documento.usuario          = docum-est.usuario
               tt-documento.r-docum-est      = ROWID(docum-est)
               tt-documento.cod-estabel      = docum-est.cod-estabel
               tt-documento.hr-atualiza      = docum-est.hr-atualiza
               tt-documento.log-atualizado   = docum-est.ce-atual
               tt-documento.estado           = emitente.estado
               tt-documento.contrib-icms     = IF emitente.contrib-icms THEN "Sim" ELSE "N∆o"
               tt-documento.nom-solicitante  = IF AVAIL int-docum-est THEN int-docum-est.nom-solicitante ELSE ""
               tt-documento.cd-servico       = IF AVAIL int-docum-est THEN int-docum-est.cd-servico ELSE 0
               tt-documento.ds-servico       = IF AVAIL int-codigo-servico THEN int-codigo-servico.ds-servico ELSE ""
               tt-documento.cd-enquadramento = IF AVAIL int-docum-est THEN int-docum-est.cd-enquadramento ELSE ""
               tt-documento.ds-enquadramento = IF AVAIL int-enquadramento THEN int-enquadramento.ds-enquadramento ELSE ""

               tt-documento.cd-atividade-mei = IF AVAIL int-docum-est     THEN int-docum-est.cod-atividade-mei ELSE 0
               tt-documento.ds-atividade-mei = IF AVAIL int-atividade-mei THEN int-atividade-mei.des-atividade-mei     ELSE ""
               

               /*tt-documento.num-pedido       = item-doc-est.num-pedido       
               tt-documento.numero-ordem     = item-doc-est.numero-ordem     
               tt-documento.parcela          = item-doc-est.parcela*/.
        
        IF tt-param.imprime-conta THEN DO:
            FIND FIRST dupli-apagar OF docum-est NO-LOCK NO-ERROR.
            IF AVAIL dupli-apagar 
            THEN DO:
                ASSIGN tt-documento.dt-vencto = dupli-apagar.dt-vencim
                       tt-documento.esp-dupli = dupli-apagar.cod-esp.

                RUN esp/rep/esrep007rp-baixa-ems5.p (INPUT  docum-est.cod-estabel,    
                                                     INPUT  dupli-apagar.cod-emitente, 
                                                     INPUT  dupli-apagar.cod-esp,      
                                                     INPUT  dupli-apagar.serie-docto,  
                                                     INPUT  dupli-apagar.nro-docto,    
                                                     INPUT  dupli-apagar.parcela,     
                                                     OUTPUT tt-documento.dt-pagto).

                IF  tt-documento.dt-pagto = 12/31/9999 /* Data default do campo qdo ainda n∆o foi quitado */
                THEN
                    ASSIGN tt-documento.dt-pagto = ?.
            END.
        END.

        /*--- chamado 37224, lista Chave de Acesso ---*/
        IF  tt-param.l-listar-chave 
        THEN assign tt-documento.cod-chave-aces-nf-eletro = docum-est.cod-chave-aces-nf-eletro.
        ELSE assign tt-documento.cod-chave-aces-nf-eletro = "":U.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Nota: " + docum-est.nro-docto + " - Data: " + STRING(docum-est.dt-trans,"99/99/9999")).

        ASSIGN de-tot-ii  = 0
               nota-deb   = 0
               de-tot-pis = 0
               de-tot-cof = 0
               de-cotacao-emb = 1
               de-cotacao-entrada = 1
               de-cotacao-di  = 1.

        RUN pi-busca-cotacao (INPUT docum-est.dt-trans, OUTPUT de-cotacao-entrada). /* cotacao da entrada da nota */
        ASSIGN tt-documento.cotacao-entrada = de-cotacao-entrada.

        FOR EACH docum-est-cex WHERE
                 docum-est-cex.nro-docto    = docum-est.nro-docto    AND
                 docum-est-cex.serie-docto  = docum-est.serie-docto  AND
                 docum-est-cex.cod-emitente = docum-est.cod-emitente AND
                 docum-est-cex.nat-operacao = docum-est.nat-operacao no-lock:
            IF docum-est-cex.cod-desp = 1 THEN
                ASSIGN tt-documento.de-tot-ii = tt-documento.de-tot-ii + docum-est-cex.val-desp.
            ELSE IF docum-est-cex.cod-desp = 9 THEN
                ASSIGN tt-documento.tx-adm = tt-documento.tx-adm + docum-est-cex.val-desp.
            /*ELSE IF docum-est-cex.cod-desp = 23 THEN
                ASSIGN tt-documento.valor-seguro = tt-documento.valor-seguro + docum-est-cex.val-desp.*/
        END.
        
        FIND embarque-imp WHERE
             embarque-imp.cod-estabel = docum-est.cod-estabel AND
             embarque-imp.embarque = substring(tt-documento.char-1,1,12) NO-LOCK NO-ERROR.
        IF AVAIL embarque-imp THEN DO:
            run pi-busca-cotacao (INPUT embarque-imp.data-di - 1, OUTPUT de-cotacao-di).
            ASSIGN tt-documento.cotacao-di = de-cotacao-di.

            ASSIGN tt-documento.c-nr-di = embarque-imp.declaracao-imp
                   tt-documento.c-emb   = embarque-imp.embarque
                   tt-documento.data-di = IF embarque-imp.data-di = ? THEN "" ELSE STRING(embarque-imp.data-di,"99/99/9999").

            FOR EACH invoice-emb-imp NO-LOCK                           WHERE
                     invoice-emb-imp.cod-estabel = docum-est.cod-estabel  and
                     invoice-emb-imp.embarque    = embarque-imp.embarque:
                ASSIGN tt-documento.vl-invoice = tt-documento.vl-invoice + invoice-emb-imp.vl-invoice.
            END.
            
            /* Posicionar no itinerario para encontar a data de embarque */
            FIND FIRST historico-embarque 
                 WHERE historico-embarque.cod-estabel = docum-est.cod-estabel
                   AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
            IF AVAIL historico-embarque THEN DO:
                FIND FIRST itinerario 
                     where itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
                IF AVAIL itinerario THEN DO:
                    FOR FIRST b-historico-embarque 
                        WHERE b-historico-embarque.cod-estabel   = docum-est.cod-estabel
                          AND b-historico-embarque.embarque      = embarque-imp.embarque
                          AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner 
                          AND b-historico-embarque.cod-pto-contr = itinerario.pto-embarque no-lock:
                        if avail b-historico-embarque then do:
                            run pi-busca-cotacao (INPUT b-historico-embarque.dt-efetiva, OUTPUT de-cotacao-emb). /* cotac∆o data do embarque */
                            ASSIGN tt-documento.cotacao-emb = de-cotacao-emb.
                        END.
                    END.
                END.
            END.
        END.
        ELSE
           ASSIGN tt-documento.c-nr-di = ""
                  tt-documento.c-emb   = "".

        IF tt-param.imp-rateio THEN DO:
            FOR FIRST rat-docum 
                WHERE rat-docum.nf-emitente = docum-est.cod-emitente
                  AND rat-docum.nf-nro      = docum-est.nro-docto
                  AND rat-docum.nf-serie    = docum-est.serie-docto
                  AND rat-docum.nf-nat-oper = docum-est.nat-operacao NO-LOCK:
                FIND bf-docum-est WHERE
                     bf-docum-est.cod-emitente = rat-docum.cod-emitente AND
                     bf-docum-est.serie-docto  = rat-docum.serie-docto AND
                     bf-docum-est.nro-docto    = rat-docum.nro-docto AND
                     bf-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK NO-ERROR.
                IF AVAIL bf-docum-est THEN DO:
                    ASSIGN tt-documento.nf-rateio  = bf-docum-est.nro-docto.

                    FIND FIRST tt-rateio
                         WHERE tt-rateio.nro-docto   = rat-docum.nro-docto
                           AND tt-rateio.serie-docto = rat-docum.serie-docto 
                           AND tt-rateio.nat-operacao = rat-docum.nat-operacao
                           AND tt-rateio.cod-emitente = rat-docum.cod-emitente NO-ERROR.
                    IF NOT AVAIL tt-rateio THEN DO:
                        CREATE tt-rateio.
                        ASSIGN tt-rateio.nro-docto   = rat-docum.nro-docto
                               tt-rateio.serie-docto = rat-docum.serie-docto 
                               tt-rateio.nat-operacao = rat-docum.nat-operacao
                               tt-rateio.cod-emitente = rat-docum.cod-emitente
                               tt-documento.vlr-rateio = bf-docum-est.tot-valor.
                    END.
                END.
            END.

            FOR FIRST despesa-aces
                WHERE despesa-aces.serie-docto = docum-est.serie-docto
                  AND despesa-aces.nro-docto   = docum-est.nro-docto
                  AND despesa-aces.cod-emitente = docum-est.cod-emitente
                  AND despesa-aces.nat-operacao = docum-est.nat-operacao no-LOCK:
                ASSIGN tt-documento.nf-desp-aces  = despesa-aces.nro-docto-ac
                       tt-documento.vlr-desp-aces = despesa-aces.valor.

                FOR EACH  it-doc-fisc NO-LOCK
                    WHERE it-doc-fisc.cod-estabel  = docum-est.cod-estabel
                      AND it-doc-fisc.serie        = despesa-aces.ser-docto-ac
                      AND it-doc-fisc.nr-doc-fis   = despesa-aces.nro-docto-ac
                      AND it-doc-fisc.cod-emitente = despesa-aces.cod-forn-ac
                      AND it-doc-fisc.nat-operacao = despesa-aces.nat-oper-ac:
                
                    ASSIGN tt-documento.de-bc-pis-aces    = tt-documento.de-bc-pis-aces    + it-doc-fisc.val-base-calc-pis   
                           tt-documento.de-bc-cofins-aces = tt-documento.de-bc-cofins-aces + it-doc-fisc.val-base-calc-cofins             
                           tt-documento.de-pis-aces       = tt-documento.de-pis-aces       + it-doc-fisc.val-pis
                           tt-documento.de-cofins-aces    = tt-documento.de-cofins-aces    + it-doc-fisc.val-cofins.         
                END.
            END. /* FOR FIRST despesa-aces */
        END.

        /**********************************************/

        ASSIGN l-encontrou-contas = NO.
        FOR EACH item-doc-est OF docum-est NO-LOCK:
            IF item-doc-est.it-codigo < tt-param.it-codigo-ini OR
               item-doc-est.it-codigo > tt-param.it-codigo-fim THEN NEXT.

            IF item-doc-est.cod-depos < tt-param.cod-depos-ini OR
               item-doc-est.cod-depos > tt-param.cod-depos-fim THEN NEXT.
            
            IF item-doc-est.class-fiscal < tt-param.classific-ini OR
               item-doc-est.class-fiscal > tt-param.classific-fim THEN NEXT.

            /* considerando conta e subconta agora */
            if  tt-param.imprime-conta 
            AND ((item-doc-est.ct-codigo < tt-param.conta-ini    OR item-doc-est.ct-codigo > tt-param.conta-fim) 
            OR   (item-doc-est.sc-codigo < tt-param.subconta-ini OR item-doc-est.sc-codigo > tt-param.subconta-fim)) THEN NEXT.
            
            find first tt-documento-aux 
                where tt-documento-aux.r-documento = recid(tt-documento)
                and   tt-documento-aux.ct-codigo = item-doc-est.ct-codigo 
                and   tt-documento-aux.sc-codigo = item-doc-est.sc-codigo no-error.
                
            if not avail tt-documento-aux then do:
                create tt-documento-aux.
                assign tt-documento-aux.r-documento    = recid(tt-documento)
                       tt-documento-aux.ct-codigo      = item-doc-est.ct-codigo 
                       tt-documento-aux.sc-codigo      = item-doc-est.sc-codigo
                       tt-documento-aux.cod-unid-negoc = item-doc-est.cod-unid-negoc.
            end.
        
            ASSIGN l-encontrou-contas = YES
                   tt-documento.de-tot-pis    = tt-documento.de-tot-pis    + item-doc-est.valor-pis
                   tt-documento.de-tot-cof    = tt-documento.de-tot-cof    + item-doc-est.val-cofins
                   tt-documento-aux.tot-valor = tt-documento-aux.tot-valor + item-doc-est.preco-total[1].

            FIND tt-class WHERE
                 tt-class.ncm = item-doc-est.class-fiscal NO-ERROR.
            IF NOT AVAIL tt-class THEN DO:
                CREATE tt-class.
                ASSIGN tt-class.ncm = item-doc-est.class-fiscal.
            END.

            ASSIGN tt-class.valor = tt-class.valor + item-doc-est.preco-total[1].

            IF item-doc-est.cd-trib-icm = 1 OR
               item-doc-est.cd-trib-icm = 4 THEN DO:
                ASSIGN tt-documento.v-aliq          = item-doc-est.aliquota-icm                
                       tt-documento.icm-deb-cre     = item-doc-est.valor-icm[1] 
                       tt-documento.icm-complem     = item-doc-est.icm-complem[1]
                       tt-documento.de-tot-icm      = tt-documento.de-tot-icm + item-doc-est.valor-icm[1] + item-doc-est.icm-complem[1].
            END.

            /* REVER */
            IF item-doc-est.cd-trib-ipi = 1 OR
               item-doc-est.cd-trib-ipi = 3 OR
               item-doc-est.cd-trib-ipi = 4 THEN DO:
               ASSIGN tt-documento.nota-deb = tt-documento.nota-deb + item-doc-est.valor-ipi[1].
               ASSIGN tt-documento.v-aliq = item-doc-est.aliquota-icm.
            END.
         
            IF item-doc-est.it-codigo = " " THEN DO:
               ASSIGN tt-documento.v-aliq = item-doc-est.aliquota-icm.
               ASSIGN tt-documento.v-aliq = natur-oper.aliquota-icm.
            END.

            /* REVER */
            IF item-doc-est.cd-trib-icm = 2 THEN DO:
               ASSIGN tt-documento.v-aliq = 0
                      tt-documento.de-tot-ipi = 0.
            END.
            ELSE DO:
               ASSIGN tt-documento.v-aliq = item-doc-est.aliquota-icm.
            END.
            
            /*Chamado:56136*/                   
            if tt-documento.cod-depos <> "" and 
               tt-documento.cod-depos <> item-doc-est.cod-depos then
                assign tt-documento.cod-depos = 'V†rios'.
             
            if tt-documento.cod-depos <>  'V†rios' then  
                assign tt-documento.cod-depos = item-doc-est.cod-depos. 
                       
          END.

        IF tt-documento.nat-operacao BEGINS "197" OR
           tt-documento.nat-operacao BEGINS "297" OR
           tt-documento.nat-operacao BEGINS "191" OR
           tt-documento.nat-operacao BEGINS "291" THEN DO:
           /* natureza 391 passa a considerar por solicitacao da Janice no dia 19/11/2003 or docum-est.nat-operacao begins "391"   */
           ASSIGN tt-documento.de-tot-icm = 0
                  tt-documento.v-aliq = 0.
        END.
        
        /*Chamado:56136*/
        &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
            FIND FIRST modalid-frete NO-LOCK
                WHERE modalid-frete.cod-modalid-frete = docum-est.cod-modalid-frete NO-ERROR.
        &ELSE
            FIND FIRST modalid-frete NO-LOCK
                WHERE modalid-frete.cod-modalid-frete = SUBSTRING(docum-est.char-2,143,8) NO-ERROR.
        &ENDIF
        
        IF AVAIL modalid-frete THEN
            ASSIGN tt-documento.modal-frete = modalid-frete.des-modalid-frete.
        ELSE
            ASSIGN tt-documento.modal-frete = ''.
            
        if docum-est.nome-transp <> '' then
            assign tt-documento.nome-transp = docum-est.nome-transp.
        else
            assign tt-documento.nome-transp = ''.
            
        IF NOT l-encontrou-contas AND AVAIL tt-documento THEN DELETE tt-documento.    

        FOR EACH item-nf-adc FIELDS(val-livre-1 cod-livre-1 cod-livre-2 val-livre-2 cod-livre-4
                                    val-livre-3 val-livre-4)
            WHERE item-nf-adc.idi-tip-dado     = 24 /* DIFAL */
            AND   item-nf-adc.cod-estab        = docum-est.cod-estabel
            AND   item-nf-adc.cod-serie        = docum-est.serie
            AND   item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
            AND   item-nf-adc.cdn-emitente     = docum-est.cod-emitente NO-LOCK:

            ASSIGN tt-documento.d-vl-bc-uf-dest    = tt-documento.d-vl-bc-uf-dest    + item-nf-adc.val-livre-1
                   tt-documento.d-aliq-uf-dest     =  DEC(item-nf-adc.cod-livre-1)
                   tt-documento.d-aliq-inter       =  DEC(item-nf-adc.cod-livre-2)
                   tt-documento.d-perc-icms-fcp    =  item-nf-adc.val-livre-2
                   tt-documento.d-vl-icms-fcp      = tt-documento.d-vl-icms-fcp      + DEC(item-nf-adc.cod-livre-4)
                   tt-documento.d-vl-icms-uf-dest  = tt-documento.d-vl-icms-uf-dest  + item-nf-adc.val-livre-3
                   tt-documento.d-vl-icms-uf-remet = tt-documento.d-vl-icms-uf-remet + item-nf-adc.val-livre-4.
        END.

        FIND FIRST ext-docum-est OF docum-est NO-LOCK NO-ERROR.
        IF AVAIL ext-docum-est THEN
           ASSIGN tt-documento.de-vl-icms-simples-nac = ext-docum-est.val-livre-3.

