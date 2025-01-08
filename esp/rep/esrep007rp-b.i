/*-----------------------------------------------------------------*/
/*       CRIA tt-documento para a procedure piRelatAnalistico      */
/*-----------------------------------------------------------------*/    
    
    
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

    FIND FIRST int-codigo-servico NO-LOCK
         WHERE int-codigo-servico.cd-servico = int-docum-est.cd-servico NO-ERROR.

    FIND FIRST int-enquadramento NO-LOCK
         WHERE int-enquadramento.cd-enquadramento = int-docum-est.cd-enquadramento NO-ERROR.

    FIND FIRST int-atividade-mei NO-LOCK
         WHERE int-atividade-mei.cod-atividade = int-docum-est.cod-atividade-mei NO-ERROR.


/*
    IF docum-est.nat-operacao < tt-param.ini-nat-operacao OR
       docum-est.nat-operacao > tt-param.fim-nat-operacao THEN NEXT.
*/
    IF cod-motivacao < tt-param.cod-msg-devolucao-ini
    OR cod-motivacao > tt-param.cod-msg-devolucao-fim THEN
         NEXT {1}.

    if can-find(first tt-digita WHERE tt-digita.nat-operacao <> "") then
        if not can-find(first tt-digita no-lock 
                        where tt-digita.nat-operacao = docum-est.nat-operacao) THEN NEXT {1}.

    FIND FIRST emitente WHERE
               emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

    if tt-param.natureza = 1 and emitente.natureza <> 1 then NEXT {1}.
    if tt-param.natureza = 2 and emitente.natureza <> 2 then NEXT {1}.
    
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
    IF NOT AVAIL natur-oper THEN NEXT {1}.

    /*Verifica notas devolucao*/
    IF NOT tt-param.imprime-devol AND natur-oper.tipo-compra = 3 THEN NEXT {1}.

    IF  tt-param.log-filtra-impto = YES THEN DO:
        FIND FIRST tt-fornec-imposto NO-LOCK
            WHERE  tt-fornec-imposto.cod-emitente = docum-est.cod-emitente NO-ERROR.

        IF  AVAIL tt-fornec-imposto
        THEN DO:
            IF  tt-fornec-imposto.log-listar = NO
            THEN
                NEXT {1}.
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
                NEXT {1}.
        END.
    END. /* IF  tt-param.log-filtra-impto = YES */
    ASSIGN c-atendente                    = "".
    for FIRST devol-cli NO-LOCK
        WHERE  devol-cli.serie-docto          = docum-est.serie-docto 
           and devol-cli.nro-docto            = docum-est.nro-docto   
           and devol-cli.cod-emitente         = docum-est.cod-emitente
           and devol-cli.nat-operacao         = docum-est.nat-operacao,
        FIRST nota-fiscal  NO-LOCK
        WHERE nota-fiscal.cod-estabel         = devol-cli.cod-estabel
          AND nota-fiscal.serie               = devol-cli.serie
          AND nota-fiscal.nr-nota-fis         = devol-cli.nr-nota-fis,
        FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli             = nota-fiscal.nr-pedcli
          AND ped-venda.nome-abrev            = nota-fiscal.nome-ab-cli:
        ASSIGN c-atendente                    = ped-venda.tp-pedido.
    END.                                       
           
                        
    ASSIGN de-cotacao-di = 1
           de-tot-ii     = 0
           de-tx-adm     = 0
           de-tx-adm2    = 0
           de-cotacao-entrada = 1
           de-cotacao-emb = 1.

    FOR EACH docum-est-cex WHERE
             docum-est-cex.nro-docto    = docum-est.nro-docto    AND
             docum-est-cex.serie-docto  = docum-est.serie-docto  AND
             docum-est-cex.cod-emitente = docum-est.cod-emitente AND
             docum-est-cex.nat-operacao = docum-est.nat-operacao no-lock:
        IF docum-est-cex.cod-desp = 1 THEN
            ASSIGN de-tot-ii = de-tot-ii + docum-est-cex.val-desp.
        ELSE IF docum-est-cex.cod-desp = 9 THEN
            ASSIGN de-tx-adm = de-tx-adm + docum-est-cex.val-desp.
    END.

    RUN pi-busca-cotacao (INPUT docum-est.dt-trans, OUTPUT de-cotacao-entrada).

    FIND embarque-imp WHERE
         embarque-imp.cod-estabel = docum-est.cod-estabel AND
         embarque-imp.embarque = substring(docum-est.char-1,1,12) NO-LOCK NO-ERROR.
    if avail embarque-imp THEN DO:

        run pi-busca-cotacao (INPUT embarque-imp.data-di - 1, OUTPUT de-cotacao-di).

        ASSIGN c-emb = embarque-imp.embarque.

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
                    END.
                END.
            END.
        END.
    END.
    ELSE ASSIGN c-emb   = "".

    ASSIGN de-frete     = 0
           de-seguro    = 0
           de-tot-frete = 0
           i-sequencia  = 10.

    RUN pi-acompanhar IN h-acomp (INPUT "Nota: " + docum-est.nro-docto + " - Data: " + STRING(docum-est.dt-trans,"99/99/9999")).

    FOR EACH item-doc-est OF docum-est NO-LOCK:


/*              docum-est.nat-operacao >= tt-param.ini-nat-operacao AND */
/*              docum-est.nat-operacao <= tt-param.fim-nat-operacao AND */

        IF item-doc-est.nat-of <> "" 
        THEN DO:
           IF item-doc-est.nat-of < tt-param.ini-nat-operacao OR
              item-doc-est.nat-of > tt-param.fim-nat-operacao THEN NEXT.
        END.
        ELSE DO:
           IF docum-est.nat-operacao < tt-param.ini-nat-operacao OR
              docum-est.nat-operacao > tt-param.fim-nat-operacao THEN NEXT.
        END.

        IF item-doc-est.it-codigo < tt-param.it-codigo-ini OR
           item-doc-est.it-codigo > tt-param.it-codigo-fim THEN NEXT.

        IF item-doc-est.cod-depos < tt-param.cod-depos-ini OR
           item-doc-est.cod-depos > tt-param.cod-depos-fim THEN NEXT.

        IF item-doc-est.class-fiscal < tt-param.classific-ini OR
           item-doc-est.class-fiscal > tt-param.classific-fim THEN NEXT.
           
        if tt-param.imprime-conta AND
           ((item-doc-est.ct-codigo < tt-param.conta-ini    OR item-doc-est.ct-codigo > tt-param.conta-fim) 
        OR  (item-doc-est.sc-codigo < tt-param.subconta-ini OR item-doc-est.sc-codigo > tt-param.subconta-fim)) THEN NEXT.

        FIND item WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Nota: " + docum-est.nro-docto + " - Data: " + STRING(docum-est.dt-trans,"99/99/9999")).

        FIND FIRST classif-fisc
            WHERE classif-fisc.class-fiscal = item-doc-est.class-fiscal NO-LOCK NO-ERROR.

        FIND FIRST item-doc-est-cex OF item-doc-est NO-LOCK NO-ERROR.
                                               
        FIND LAST dwf-docto-item-impto NO-LOCK
            WHERE dwf-docto-item-impto.cod-estab         = docum-est.cod-estabel 
              AND dwf-docto-item-impto.cod-serie         = docum-est.serie       
              AND dwf-docto-item-impto.cod-docto         = docum-est.nro-docto  
              AND dwf-docto-item-impto.cod-emitente      = STRING(docum-est.cod-emitente)
              AND dwf-docto-item-impto.cod-natur-operac  = docum-est.nat-operacao
              AND dwf-docto-item-impto.cod-impto         = "PIS" NO-ERROR.

        ASSIGN vlr-fcp = 0.

        IF NOT docum-est.LOG-1 THEN
            ASSIGN i-nr-seq = item-doc-est.sequencia.
        ELSE DO: /*integrado faturamento*/
            FIND FIRST it-nota-fisc NO-LOCK
                 WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
                   AND it-nota-fisc.serie       = docum-est.serie-docto
                   AND it-nota-fisc.nr-nota-fis = docum-est.nro-docto
                   AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo
                   AND it-nota-fisc.nr-seq-ped  = item-doc-est.sequencia NO-ERROR.
            IF AVAIL it-nota-fisc THEN
                ASSIGN i-nr-seq = it-nota-fisc.nr-seq-fat.
        END.
        
        FOR EACH item-nf-adc NO-LOCK
           WHERE item-nf-adc.cod-estab        = docum-est.cod-estabel
             AND item-nf-adc.cod-serie        = docum-est.serie-docto
             AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
             AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
             AND item-nf-adc.cod-natur-operac = (if item-doc-est.nat-of <> "" then item-doc-est.nat-of else item-doc-est.nat-operacao)
             AND item-nf-adc.idi-tip-dado     = 25
             AND item-nf-adc.num-seq          = i-nr-seq:
             ASSIGN vlr-fcp = vlr-fcp + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30)).
        END.

        IF  vlr-fcp = ? THEN 
            ASSIGN vlr-fcp = 0.

        FIND FIRST int-item-doc-est OF item-doc-est NO-LOCK NO-ERROR.

        CREATE tt-documento.
        ASSIGN tt-documento.dt-trans        = docum-est.dt-trans
               tt-documento.dt-emissao      = docum-est.dt-emissao
               tt-documento.serie-docto     = docum-est.serie-docto
               tt-documento.nro-docto       = docum-est.nro-docto
               tt-documento.cod-emitente    = docum-est.cod-emitente
               tt-documento.c-emb           = c-emb
               tt-documento.nome-abrev      = IF tt-param.imprime-conta THEN emitente.nome-emit ELSE emitente.nome-abrev
               tt-documento.cgc             = emitente.cgc
               tt-documento.estado          = emitente.estado
               tt-documento.cidade          = emitente.cidade
               tt-documento.pais            = emitente.pais
           /*    tt-documento.nat-operacao    = item-doc-est.nat-of */
           /*    tt-documento.nat-operacao    = docum-est.nat-operacao */
               tt-documento.nat-operacao    = IF item-doc-est.nat-of <> "" THEN item-doc-est.nat-of ELSE docum-est.nat-operacao
               tt-documento.cod-devolucao   = cod-motivacao
               tt-documento.it-codigo       = item-doc-est.it-codigo
               tt-documento.descricao-1     = item.descricao-1
               tt-documento.descricao-2     = item.descricao-2
               tt-documento.cod-dcr-item    = item.cod-dcr-item
               tt-documento.narrativa       = trim(REPLACE(item-doc-est.narrativa,CHR(10), " "))
               tt-documento.narrativa       = trim(REPLACE(tt-documento.narrativa,CHR(13), " "))
               tt-documento.narrativa       = trim(replace(tt-documento.narrativa,CHR(9),  " "))
               tt-documento.narrativa       = trim(replace(tt-documento.narrativa,CHR(11), " "))
               tt-documento.narrativa       = trim(replace(tt-documento.narrativa,";",     " "))
               tt-documento.class-fiscal    = item-doc-est.class-fiscal 
               tt-documento.aliquota-ipi    = item-doc-est.aliquota-ipi
               tt-documento.aliq-ipi-ncm    = IF AVAILABLE classif-fisc THEN classif-fisc.aliquota-ipi ELSE 0
               tt-documento.cod-depos       = item-doc-est.cod-depos
               tt-documento.cod-localiz     = item-doc-est.cod-localiz
               tt-documento.quantidade      = item-doc-est.quantidade   
               tt-documento.valor-mercadoria = item-doc-est.preco-total[1]
               de-frete                     = de-frete + (docum-est.valor-frete * (item-doc-est.preco-total[1] / docum-est.valor-mercad))
               tt-documento.valor-frete     = docum-est.valor-frete * (item-doc-est.preco-total[1] / docum-est.valor-mercad)
               de-tx-adm2                   = de-tx-adm2 + (de-tx-adm * (item-doc-est.preco-total[1] / docum-est.valor-mercad))
               tt-documento.tx-adm          = de-tx-adm * (item-doc-est.preco-total[1] / docum-est.valor-mercad)
               tt-documento.de-tot-ii       = IF AVAILABLE item-doc-est-cex THEN item-doc-est-cex.val-desp ELSE 0.0 /*de-tot-ii*/
               de-seguro                    = de-seguro + (docum-est.valor-seguro * (item-doc-est.preco-total[1] / docum-est.valor-mercad))
               tt-documento.valor-seguro    = docum-est.valor-seguro * (item-doc-est.preco-total[1] / docum-est.valor-mercad)
               tt-documento.nota-deb        = item-doc-est.valor-ipi[1]                  
               tt-documento.de-tot-pis      = item-doc-est.valor-pis
               tt-documento.de-tot-cof      = item-doc-est.val-cofins
               tt-documento.tot-valor       = (docum-est.tot-valor * (item-doc-est.preco-total[1] / docum-est.valor-mercad))  /*item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] /*+ tt-documento.valor-frete + tt-documento.tx-adm*/ * (item-doc-est.preco-total[1] / docum-est.tot-valor)*/
               tt-documento.nro-comp        = item-doc-est.nro-comp
               tt-documento.usuario         = docum-est.usuario
               tt-documento.preco-unit      = item-doc-est.preco-unit[1]
               tt-documento.preco-unit-dl   = item-doc-est.preco-unit[1] / de-cotacao-di
               tt-documento.cotacao-di      = de-cotacao-di
               tt-documento.nr-ord-prod     = item-doc-est.nr-ord-prod
               tt-documento.r-docum-est     = ROWID(docum-est)
               tt-documento.cod-estabel     = docum-est.cod-estabel
               tt-documento.cotacao-emb     = de-cotacao-emb
               tt-documento.cotacao-di      = de-cotacao-di
               tt-documento.cotacao-entrada = de-cotacao-entrada
               tt-documento.base-subs       = item-doc-est.base-subs
               tt-documento.vl-subs         = item-doc-est.vl-subs 
               tt-documento.ins-estadual    = emitente.ins-estadual
               tt-documento.log-atualizado  = docum-est.ce-atual
               tt-documento.cod-origem-item = ITEM.codigo-orig
               tt-documento.val-base-pis    = item-doc-est.base-pis
               tt-documento.val-base-cofins = item-doc-est.val-base-calc-cofins
               tt-documento.val-aliq-pis    = item-doc-est.val-aliq-pis
               tt-documento.val-aliq-cofins = item-doc-est.val-aliq-cofins
               tt-documento.cod-tributac    = IF AVAIL dwf-docto-item-impto THEN dwf-docto-item-impto.cod-tributac ELSE ""
               tt-documento.num-pedido      = item-doc-est.num-pedido       
               tt-documento.numero-ordem    = item-doc-est.numero-ordem     
               tt-documento.parcela         = item-doc-est.parcela
               tt-documento.ge-codigo       = ITEM.ge-codigo
               tt-documento.atendente       = c-atendente
               tt-documento.nom-solicitante  = IF AVAIL int-docum-est THEN int-docum-est.nom-solicitante ELSE ""
               tt-documento.contrib-icms    = IF emitente.contrib-icms THEN "Sim" ELSE "N∆o"
               tt-documento.fm-materias     = IF AVAIL int-item-doc-est AND int-item-doc-est.fm-codigo <> "" THEN int-item-doc-est.fm-codigo ELSE item.fm-codigo
               tt-documento.base-calc-icms  = item-doc-est.base-icm[1]
               tt-documento.origem-item     = SUBSTRING(item-doc-est.char-2,637,3)
               tt-documento.cst-item        = SUBSTRING(item-doc-est.char-2,502,3)
               tt-documento.fcp             = vlr-fcp
               tt-documento.cd-servico       = IF AVAIL int-docum-est THEN int-docum-est.cd-servico ELSE 0
               tt-documento.ds-servico       = IF AVAIL int-codigo-servico THEN int-codigo-servico.ds-servico ELSE ""
               tt-documento.cd-enquadramento = IF AVAIL int-docum-est THEN int-docum-est.cd-enquadramento ELSE ""
               tt-documento.ds-enquadramento = IF AVAIL int-enquadramento THEN int-enquadramento.ds-enquadramento ELSE ""

               tt-documento.cd-atividade-mei = IF AVAIL int-docum-est     THEN int-docum-est.cod-atividade-mei     ELSE 0
               tt-documento.ds-atividade-mei = IF AVAIL int-atividade-mei THEN int-atividade-mei.des-atividade-mei ELSE ""

               tt-documento.sequencia        = item-doc-est.sequencia.

        ASSIGN tt-documento.vl-subs [1] = tt-documento.vl-subs[1]  + vlr-fcp.
        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem =  item-doc-est.numero-ordem NO-ERROR.

        IF AVAIL ordem-compra THEN DO:
            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-ERROR.

            ASSIGN tt-documento.cod-cond-pag       = ordem-compra.cod-cond-pag
                   tt-documento.descricao-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                   tt-documento.cod-comprado       = ordem-compra.cod-comprado.
        END.

        /*Se os dados do pedido est∆o em branco tenta buscar do FIFO*/
        IF tt-documento.num-pedido = 0 THEN DO:
            
            FIND FIRST rat-ordem OF item-doc-est NO-LOCK NO-ERROR.
            
            IF AVAIL rat-ordem THEN DO:
                ASSIGN tt-documento.num-pedido      = rat-ordem.num-pedido       
                       tt-documento.numero-ordem    = rat-ordem.numero-ordem     
                       tt-documento.parcela         = rat-ordem.parcela.

                FIND FIRST ordem-compra NO-LOCK
                     WHERE ordem-compra.numero-ordem =  rat-ordem.numero-ordem NO-ERROR.
    
                IF AVAIL ordem-compra THEN DO:
                    FIND FIRST cond-pagto NO-LOCK
                         WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-ERROR.
    
                    ASSIGN tt-documento.cod-cond-pag       = ordem-compra.cod-cond-pag
                           tt-documento.descricao-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                           tt-documento.cod-comprado       = ordem-compra.cod-comprado.
                END.
            END.
        END.

        /*--- chamado nro 28457 - busca THC ---*/
        IF  tt-param.l-listar-THC-II THEN DO:
    
            FIND FIRST desp-imp NO-LOCK
                WHERE  desp-imp.descricao = "THC" NO-ERROR.
            IF  AVAIL  desp-imp THEN DO:
                FOR EACH  item-doc-est-cex NO-LOCK
                    WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                    AND   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                    AND   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                    AND   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                    AND   item-doc-est-cex.sequencia    = item-doc-est.sequencia
                    AND   item-doc-est-cex.cod-desp     = desp-imp.cod-desp:
                    
                    ASSIGN tt-documento.val-desp-THC = tt-documento.val-desp-THC + item-doc-est-cex.val-desp.
                
                END. /* FOR EACH  item-doc-est-cex NO-LOCK */
            END. /* IF  AVAIL  desp-imp THEN DO: */

            /*
            FOR EACH  ordem-compra NO-LOCK
                WHERE ordem-compra.cod-estabel = docum-est.cod-estabel
                AND   ordem-compra.it-codigo   = item-doc-est.it-codigo,
                FIRST ordens-embarque NO-LOCK
                WHERE ordens-embarque.cod-estabel  = docum-est.cod-estabel
                AND   ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                AND   ordens-embarque.embarque     = SUBSTRING(docum-est.char-1,1,12):
        
                ASSIGN tt-documento.perc-II = ordens-embarque.aliquota-ii.

            END. /* IF  AVAIL ordens-embarque THEN DO: */
            */
            FOR EACH  ordens-embarque NO-LOCK
                WHERE ordens-embarque.cod-estabel  = docum-est.cod-estabel    
                  AND ordens-embarque.embarque     = SUBSTRING(docum-est.char-1,1,12),
                EACH  ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem              
                  AND ordem-compra.it-codigo   = item-doc-est.it-codigo,
                FIRST cotacao-item OF ordem-compra NO-LOCK.
                
                ASSIGN tt-documento.perc-II = cotacao-item.aliquota-ii.
                LEAVE.
            END. 

            FOR EACH  item-docto-estoq-nfe-imp NO-LOCK
                WHERE item-docto-estoq-nfe-imp.cod-ser-docto    = item-doc-est.serie-docto
                  AND item-docto-estoq-nfe-imp.cod-docto        = item-doc-est.nro-docto
                  AND item-docto-estoq-nfe-imp.cdn-emitente     = item-doc-est.cod-emitente
                  AND item-docto-estoq-nfe-imp.cod-natur-operac = item-doc-est.nat-operacao
                  AND item-docto-estoq-nfe-imp.num-seq          = item-doc-est.sequencia.

                ASSIGN tt-documento.val-impto-import = item-docto-estoq-nfe-imp.val-impto-import
                       tt-documento.num-adic         = item-docto-estoq-nfe-imp.num-adic
                       tt-documento.num-seq-import   = item-docto-estoq-nfe-imp.num-seq-import.
                       
            END.
        
        END. /* IF  tt-param.l-listar-THC THEN DO: */
    
        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item-doc-est.it-codigo
              AND item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            ASSIGN tt-documento.cod_unid_negoc = item-uni-estab.cod-unid-negoc.

            RUN esp/rep/esrep007rp-uneg-ems5.p (INPUT  tt-documento.cod_unid_negoc,
                                                OUTPUT tt-documento.des_unid_negoc).
        END.

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

        IF item-doc-est.cd-trib-icm = 1 OR
           item-doc-est.cd-trib-icm = 4 THEN
           ASSIGN tt-documento.v-aliq          = item-doc-est.aliquota-icm                
                  tt-documento.icm-deb-cre     = item-doc-est.valor-icm[1] 
                  tt-documento.icm-complem     = item-doc-est.icm-complem[1].

        IF AVAIL embarque-imp THEN
            ASSIGN tt-documento.c-nr-di = embarque-imp.declaracao-imp
                   tt-documento.data-di = IF embarque-imp.data-di = ? THEN "" ELSE STRING(embarque-imp.data-di,"99/99/9999").
        ELSE
            ASSIGN tt-documento.c-nr-di = ""
                   tt-documento.data-di = "".

        do i = 1 to length(tt-documento.narrativa):
            if asc(substring(tt-documento.narrativa, i, 1)) < 32 then
                substring(tt-documento.narrativa, i, 1) = " ".
        end.                          

        find first tt-documento-aux 
             where tt-documento-aux.r-documento = recid(tt-documento)
             and   tt-documento-aux.it-codigo   = item-doc-est.it-codigo
             and   tt-documento-aux.ct-codigo   = item-doc-est.ct-codigo 
             and   tt-documento-aux.sc-codigo   = item-doc-est.sc-codigo  no-error.
        if not avail tt-documento-aux then do:
            create tt-documento-aux.
            assign tt-documento-aux.r-documento    = recid(tt-documento)
                   tt-documento-aux.it-codigo      = item-doc-est.it-codigo                     
                   tt-documento-aux.ct-codigo      = item-doc-est.ct-codigo
                   tt-documento-aux.sc-codigo      = item-doc-est.sc-codigo
                   tt-documento-aux.cod-unid-negoc = item-doc-est.cod-unid-negoc.
        end.


        FOR EACH item-nf-adc NO-LOCK
           WHERE item-nf-adc.cod-estab        = docum-est.cod-estabel
             AND item-nf-adc.cod-serie        = docum-est.serie-docto
             AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
             AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
             AND item-nf-adc.cod-natur-operac = (if item-doc-est.nat-of <> "" then item-doc-est.nat-of else item-doc-est.nat-operacao)
             AND item-nf-adc.idi-tip-dado     = 24
             AND item-nf-adc.num-seq          = i-nr-seq:
             ASSIGN tt-documento.d-vl-bc-uf-dest    = tt-documento.d-vl-bc-uf-dest    + item-nf-adc.val-livre-1
                    tt-documento.d-aliq-uf-dest     = DEC(item-nf-adc.cod-livre-1)
                    tt-documento.d-aliq-inter       = DEC(item-nf-adc.cod-livre-2)
                    tt-documento.d-perc-icms-fcp    = item-nf-adc.val-livre-2
                    tt-documento.d-vl-icms-fcp      = tt-documento.d-vl-icms-fcp      + DEC(item-nf-adc.cod-livre-4)
                    tt-documento.d-vl-icms-uf-dest  = tt-documento.d-vl-icms-uf-dest  + item-nf-adc.val-livre-3
                    tt-documento.d-vl-icms-uf-remet = tt-documento.d-vl-icms-uf-remet + item-nf-adc.val-livre-4.
        END.

        FIND FIRST ext-item-doc-est NO-LOCK
             WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto 
               AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto   
               AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
               AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
               AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
               AND ext-item-doc-est.cod-param    = "simplesnacional" NO-ERROR.
        IF AVAIL ext-item-doc-est THEN
           ASSIGN  tt-documento.de-vl-icms-simples-nac   = ext-item-doc-est.val-livre-3
                   tt-documento.de-aliq-icms-simples-nac = ext-item-doc-est.val-livre-1
                   tt-documento.de-base-icms-simples-nac = ext-item-doc-est.val-livre-2
                   tt-documento.csosn                    = substring(ext-item-doc-est.cod-livre-1,1,10).

        /* Reinf - Nicolas */
        IF substring(docum-est.char-2,256,1) = "S" 
        THEN ASSIGN tt-documento.reinf = "Sim".
        ELSE ASSIGN tt-documento.reinf = "N∆o".

        FIND FIRST tab-serv-inss WHERE
                   tab-serv-inss.cod-livre-1 = IF substring(item-doc-est.char-2,941,2) <> ""
                                                  THEN IF INT(substring(item-doc-est.char-2,941,2)) < 10
                                                       THEN "10000000" + substring(item-doc-est.char-2,941,2)
                                                       ELSE "1000000"  + substring(item-doc-est.char-2,941,2)
                                               ELSE ""
                   NO-LOCK NO-ERROR.

        FOR EACH item-nf-adc NO-LOCK
           WHERE item-nf-adc.cod-estab        = docum-est.cod-estabel
             AND item-nf-adc.cod-serie        = docum-est.serie-docto
             AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
             AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
             AND item-nf-adc.cod-natur-operac = (if item-doc-est.nat-of <> "" then item-doc-est.nat-of else item-doc-est.nat-operacao)
             AND item-nf-adc.idi-tip-dado     = 27
             AND item-nf-adc.num-seq          = i-nr-seq:
             ASSIGN tt-documento.vl-bc-retenc = DECIMAL(SUBSTR(item-nf-adc.cod-livre-1,1,16))
                    tt-documento.vl-retenc    = DECIMAL(SUBSTR(item-nf-adc.cod-livre-1,18,16)).
        END.
        /* Reinf fim */

        IF AVAIL tab-serv-inss 
        THEN ASSIGN tt-documento.tipo-serv = substring(item-doc-est.char-2,941,2) + " - " + tab-serv-inss.des-serv-inss.
        ELSE ASSIGN tt-documento.tipo-serv = "".

        ASSIGN tt-documento.vl-base-icm-compl = DECIMAL(SUBSTRING(item-doc-est.char-2,860,20))
               tt-documento.vl-icm-compl      = item-doc-est.icm-complem[1].

        FOR EACH nota-fiscal
            WHERE nota-fiscal.nr-nota-fis = item-doc-est.nro-comp  
              AND nota-fiscal.serie       = item-doc-est.serie-comp
              AND nota-fiscal.cod-estabel = docum-est.cod-estabel:

             ASSIGN tt-documento.cod-repres = nota-fiscal.cod-rep       
                    tt-documento.desc-repres = nota-fiscal.no-ab-reppri.

        END.

        FIND FIRST dia-item NO-LOCK
             WHERE dia-item.it-codigo = item-doc-est.it-codigo NO-ERROR.
        IF AVAIL dia-item THEN
            ASSIGN tt-documento.cod-trib-am = dia-item.cod-tributac-icms.
    END. /* FOR EACH item-doc-est OF docum-est NO-LOCK: */
