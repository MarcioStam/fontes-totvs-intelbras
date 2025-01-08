/* Include utilizada pela epc epcre1005a.p */
    assign de-saldo-val-rec = b-receb.valor-total
           rat-qtd-rec-forn = b-receb.qtd-rec-forn 
           rat-quant-receb  = b-receb.quant-receb  
           rat-qtd-rej-forn = b-receb.qtd-rej-forn 
           rat-quant-rejei  = b-receb.quant-rejei
           rat-valor-icm    = b-receb.valor-icm    
           rat-valor-ipi    = b-receb.valor-ipi    
           rat-valor-iss    = b-receb.valor-iss.
    
    FOR FIRST ITEM FIELDS (tipo-contr un )
        WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK: END.
    
    for each b-movto {cdp/cd8900.i b-movto item-doc-est} 
         and b-movto.it-codigo   = item-doc-est.it-codigo 
         and b-movto.sequen-nf   = item-doc-est.sequencia
         and b-movto.tipo-trans  <> docum-est.tipo-docto 
         AND b-movto.referencia  <> "Matriz" no-lock:

        FOR FIRST estabelec FIELDS (custo-contab)
            WHERE estabelec.cod-estabel = b-movto.cod-estabel NO-LOCK: END.
        
        ASSIGN de-qtd-saldo  = b-movto.quantidade
               rat-qtd-saldo = b-movto.quantidade
               bas-qtd-saldo = b-movto.quantidade.
    
        IF estabelec.custo-contab = 1 THEN DO:
            DO i-cont = 1 to 3:
                ASSIGN de-saldo-val[i-cont]    = b-movto.valor-mat-m[i-cont]
                       rat-saldo-val-m[i-cont] = b-movto.valor-mat-m[i-cont]
                       bas-saldo-val-m[i-cont] = b-movto.valor-mat-m[i-cont].
            END.
        END.    
    
        ASSIGN rat-valor-total = b-movto.valor-mat-m[1]. 
    
        if estabelec.custo-contab = 2 then do:
            do i-cont = 1 to 3:
                assign de-saldo-val[i-cont]    = b-movto.valor-mat-o[i-cont]
                       rat-saldo-val-o[i-cont] = b-movto.valor-mat-o[i-cont]
                       bas-saldo-val-o[i-cont] = b-movto.valor-mat-o[i-cont].
            end.
        end.    
        
        if estabelec.custo-contab = 3 then do:
            do i-cont = 1 to 3:
                assign de-saldo-val[i-cont]    = b-movto.valor-mat-p[i-cont]
                       rat-saldo-val-p[i-cont] = b-movto.valor-mat-p[i-cont]
                       bas-saldo-val-p[i-cont] = b-movto.valor-mat-p[i-cont].
            end.
        end.        
        
        assign bas-qtd-rec-forn = rat-qtd-rec-forn
               bas-quant-receb  = rat-quant-receb 
               bas-qtd-rej-forn = rat-qtd-rej-forn
               bas-quant-rejei  = rat-quant-rejei 
               bas-valor-total  = rat-valor-total 
               bas-valor-icm    = rat-valor-icm   
               bas-valor-ipi    = rat-valor-ipi   
               bas-valor-iss    = rat-valor-iss.
        
        for each matriz-rat-ordem 
           where matriz-rat-ordem.numero-ordem  = ordem-compra.numero-ordem
            AND matriz-rat-ordem.perc-rateio <> 100 no-lock:
            
            /* ceapi cria movimentos de entrada e sa¡da com base na tt-movto para itens de d‚bito direto */
            create tt-movto.
            assign tt-movto.esp-docto    = 28                  /* Tipo REQ para movimentos de matriz */
                   tt-movto.cod-depos    = item-doc-est.cod-depos
                   tt-movto.cod-emitente = docum-est.cod-emitente
                   tt-movto.cod-estabel  = docum-est.cod-estabel
                   tt-movto.cod-refer    = item-doc-est.cod-refer
                   tt-movto.dt-trans     = docum-est.dt-trans
                   tt-movto.it-codigo    = item-doc-est.it-codigo
                   tt-movto.cod-localiz  = item-doc-est.cod-localiz
                   tt-movto.lote         = item-doc-est.lote
                   tt-movto.nat-operacao = docum-est.nat-operacao
                   tt-movto.nro-docto    = docum-est.nro-docto
                   tt-movto.numero-ordem = ordem-compra.numero-ordem
                   tt-movto.peso-liquido = item-doc-est.peso-liquido
                   tt-movto.serie-docto  = docum-est.serie-docto
                   tt-movto.tipo-trans   = if b-movto.tipo-trans = 1 then 2 /* Vinicio alterei de 2 para 1 */
                                           else 1 /* Vinicio alterei de 1 para 2 */
                   tt-movto.un           = ITEM.un
                   tt-movto.sequen-nf    = item-doc-est.sequencia

                   tt-movto.referencia   = "Matriz"
                   tt-movto.ct-codigo    = matriz-rat-ordem.ct-codigo              /*  b-movto.ct-codigo    */
                   tt-movto.sc-codigo    = matriz-rat-ordem.sc-codigo              /*  b-movto.sc-codigo    */
                   tt-movto.ct-db        = matriz-rat-ordem.ct-codigo
                   tt-movto.sc-db        = matriz-rat-ordem.sc-codigo
                   tt-movto.descricao-db = matriz-rat-ordem.char-1 /*item-doc-est.narrativa */
                   tt-movto.cod-versao-integracao = 1
                   tt-movto.cod-unid-negoc = SUBSTRING(matriz-rat-ordem.char-2,1,3)
                   tt-movto.cod-unid-negoc-db = SUBSTRING(matriz-rat-ordem.char-2,1,3).

            do  i-cont = 1 to 3:
                IF  b-movto.valor-mat-m[i-cont] > 0 THEN DO:
                    assign c-valor-mat            = STRING((b-movto.valor-mat-m[i-cont] 
                                                            *   matriz-rat-ordem.perc-rateio
                                                            / 100 ),">>>>,>>>,>>9.99")
                           de-valor-mat[i-cont]   = dec(c-valor-mat)
                           de-saldo-val[i-cont]   = de-saldo-val[i-cont]
                                                    - de-valor-mat[i-cont]
                           tt-movto.valor-mat-m[i-cont] = de-valor-mat[i-cont].
                END.

                IF  b-movto.valor-mat-o[i-cont] > 0 THEN DO:
                    assign c-valor-mat            = STRING(( b-movto.valor-mat-o[i-cont] 
                                                             *   matriz-rat-ordem.perc-rateio
                                                             / 100 ),">>>>,>>>,>>9.99")
                           de-valor-mat[i-cont]   = dec(c-valor-mat)
                           de-saldo-val[i-cont]   = de-saldo-val[i-cont]
                                                    - de-valor-mat[i-cont]
                           tt-movto.valor-mat-o[i-cont] = de-valor-mat[i-cont].
                END.

                IF  b-movto.valor-mat-p[i-cont] > 0 THEN DO:
                    assign c-valor-mat            = STRING(( b-movto.valor-mat-p[i-cont] 
                                                             *   matriz-rat-ordem.perc-rateio
                                                             / 100 ),">>>>,>>>,>>9.99")
                           de-valor-mat[i-cont]   = dec(c-valor-mat)
                           de-saldo-val[i-cont]   = de-saldo-val[i-cont]
                                                    - de-valor-mat[i-cont]
                           tt-movto.valor-mat-p[i-cont] = de-valor-mat[i-cont].
                END.
                
            end.

            assign tt-movto.quantidade = b-movto.quantidade 
                                          * matriz-rat-ordem.perc-rateio / 100
                   de-qtd-saldo        = de-qtd-saldo - tt-movto.quantidade.

            run cdp/cd9750.p (rowid(tt-movto)).   /*  Atualiza consumo */

            assign r-movto = rowid(tt-movto).

            IF ITEM.tipo-contr <> 4 THEN DO: /* se nÆo for item de d‚bito direto */
                
                create tt-movto.
                assign tt-movto.esp-docto    = 28                 /* Tipo REQ para movimentos de matriz */
                       tt-movto.cod-depos    = item-doc-est.cod-depos
                       tt-movto.cod-emitente = docum-est.cod-emitente
                       tt-movto.cod-estabel  = docum-est.cod-estabel
                       tt-movto.cod-refer    = item-doc-est.cod-refer
                       tt-movto.dt-trans     = docum-est.dt-trans
                       tt-movto.it-codigo    = item-doc-est.it-codigo
                       tt-movto.cod-localiz  = item-doc-est.cod-localiz
                       tt-movto.lote         = item-doc-est.lote
                       tt-movto.nat-operacao = docum-est.nat-operacao
                       tt-movto.nro-docto    = docum-est.nro-docto
                       tt-movto.numero-ordem = ordem-compra.numero-ordem
                       tt-movto.peso-liquido = item-doc-est.peso-liquido
                       tt-movto.serie-docto  = docum-est.serie-docto
                       tt-movto.tipo-trans   = 2
                       tt-movto.un           = ITEM.un
                       tt-movto.sequen-nf    = item-doc-est.sequencia
                       tt-movto.referencia   = "Matriz"
                       tt-movto.ct-codigo    = matriz-rat-ordem.ct-codigo
                       tt-movto.sc-codigo    = matriz-rat-ordem.sc-codigo
                       tt-movto.ct-db        = ""
                       tt-movto.sc-db        = ""
                       tt-movto.descricao-db = matriz-rat-ordem.char-1 /*item-doc-est.narrativa*/
                       tt-movto.cod-versao-integracao = 1
                       tt-movto.cod-unid-negoc = SUBSTRING(matriz-rat-ordem.char-2,1,3)
                       tt-movto.cod-unid-negoc-db = SUBSTRING(matriz-rat-ordem.char-2,1,3).

                do  i-cont = 1 to 3:
                    IF b-movto.valor-mat-m[i-cont] > 0 THEN DO:
                        assign c-valor-mat            = STRING(( b-movto.valor-mat-m[i-cont] 
                                                                 *   matriz-rat-ordem.perc-rateio
                                                                 / 100 ),">>>>,>>>,>>9.99")
                               de-valor-mat[i-cont]   = dec(c-valor-mat)
                               tt-movto.valor-mat-m[i-cont] = de-valor-mat[i-cont].
                    END.

                    IF b-movto.valor-mat-o[i-cont] > 0 THEN DO:
                        assign c-valor-mat            = STRING(( b-movto.valor-mat-o[i-cont] 
                                                                 *   matriz-rat-ordem.perc-rateio
                                                                 / 100 ),">>>>,>>>,>>9.99")
                               de-valor-mat[i-cont]   = dec(c-valor-mat)
                               tt-movto.valor-mat-o[i-cont] = de-valor-mat[i-cont].
                    END.

                    IF b-movto.valor-mat-p[i-cont] > 0 THEN DO:
                        assign c-valor-mat            = STRING(( b-movto.valor-mat-p[i-cont] 
                                                                 *   matriz-rat-ordem.perc-rateio
                                                                 / 100 ),">>>>,>>>,>>9.99")
                               de-valor-mat[i-cont]   = dec(c-valor-mat)
                               tt-movto.valor-mat-p[i-cont] = de-valor-mat[i-cont].
                    END.
                end.

                assign tt-movto.quantidade = b-movto.quantidade 
                                              * matriz-rat-ordem.perc-rateio / 100.
            END.
        end.

/*COMENTADO POIS ESTAVA CAUSANDO ERRO NA GERA€ÇO DOS TOTAIS, QUANDO PEDIDOS RATEADOS. CONFORME SINALIZADO NO CHAMADO NRO. 27683, DE RODRIGO SILVANO.*/
/*         /* Acerto de Residuos - Movimento de Estoque */                                                                         */
/*         if  r-movto <> ?  then do:                                                                                              */
/*             if  ( de-saldo-val[1] <> 0 or de-saldo-val[2] <> 0                                                                  */
/*             or    de-saldo-val[3] <> 0) then do:                                                                                */
/*                 find tt-movto where rowid(tt-movto) = r-movto no-error.                                                         */
/*                                                                                                                                 */
/*                 IF AVAIL tt-movto THEN DO:                                                                                      */
/*                     do  i-cont = 1 to 3:                                                                                        */
/*                         MESSAGE 'tt-movto.valor-mat-m[i-cont] ' tt-movto.valor-mat-m[i-cont] VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*                         IF tt-movto.valor-mat-m[i-cont] > 0 THEN                                                                */
/*                             assign tt-movto.valor-mat-m[i-cont] =                                                               */
/*                                                       tt-movto.valor-mat-m[i-cont]                                              */
/*                                                     + de-saldo-val[i-cont].                                                     */
/*                                                                                                                                 */
/*                         MESSAGE 'tt-movto.valor-mat-o[i-cont ' tt-movto.valor-mat-o[i-cont] VIEW-AS ALERT-BOX INFO BUTTONS OK.  */
/*                         IF tt-movto.valor-mat-o[i-cont] > 0 THEN                                                                */
/*                             assign tt-movto.valor-mat-o[i-cont] =                                                               */
/*                                                       tt-movto.valor-mat-o[i-cont]                                              */
/*                                                     + de-saldo-val[i-cont].                                                     */
/*                                                                                                                                 */
/*                         MESSAGE 'tt-movto.valor-mat-p[i-cont] ' tt-movto.valor-mat-p[i-cont] VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*                         IF tt-movto.valor-mat-p[i-cont] > 0 THEN                                                                */
/*                             assign tt-movto.valor-mat-p[i-cont] =                                                               */
/*                                                       tt-movto.valor-mat-p[i-cont]                                              */
/*                                                     + de-saldo-val[i-cont].                                                     */
/*                     end.                                                                                                        */
/*                                                                                                                                 */
/*                     MESSAGE 'tt-movto.quantidade ' tt-movto.quantidade SKIP                                                     */
/*                             'de-qtd-saldo ' de-qtd-saldo VIEW-AS ALERT-BOX INFO BUTTONS OK.                                     */
/*                                                                                                                                 */
/*                     assign tt-movto.quantidade = tt-movto.quantidade                                                            */
/*                                                  + de-qtd-saldo.                                                                */
/*                 END.                                                                                                            */
/*             end.                                                                                                                */
/*         end.                                                                                                                    */

    end. /*     for each b-movto {cdp/cd8900.i b-movto item-doc-est}  */

