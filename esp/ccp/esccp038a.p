/*----------------------------------------------------------------------------------------------
** PROGRAMA: esp/ccp/esccp038a.p
** OBJETIVO: Atualiza‡Æo das tabelas relacionadas a tabela de pre‡o, usando a data limite do
             arquivo importado da mesma forma que ocorre com a UPC do programa CD9014.
** DATA    : mar‡o de 2014
** AUTOR   : Heron Borba - SENSUS Tecnologia
------------------------------------------------------------------------------------------------*/

def buffer b-prazo-compra for prazo-compra.

{esp/imp/esimp000.i1} /*tt-emb*/

def var i-num-casa-dec as dec.
def var de-fator-conver as dec.

{upc/btb910za-upc.i}

PROCEDURE p-atualiza-pedido:
    
    DEFINE INPUT PARAMETER p-row-table AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pDtLimite   AS DATE  NO-UNDO.

    FOR FIRST item-tab NO-LOCK
        WHERE ROWID(item-tab) = p-row-table,
        FIRST tb-pr-cc NO-LOCK 
        WHERE tb-pr-cc.cod-emitente  = item-tab.cod-emitente  
        AND   tb-pr-cc.cod-cond-pag  = item-tab.cod-cond-pag  
        AND   tb-pr-cc.nr-tab        = item-tab.nr-tab        
        AND   tb-pr-cc.nome-abrev    = item-tab.nome-abrev:
        find emitente no-lock 
            where emitente.nome-abrev = tb-pr-cc.nome-abrev.

        for each  ordem-compra EXCLUSIVE-LOCK 
            where ordem-compra.cod-estabel = v_cod_estab_usuar
            and   ordem-compra.it-codigo    = item-tab.it-codigo
            and   ordem-compra.cod-emitente = emitente.cod-emitente
            and   ordem-compra.situacao = 2 /*"C"*/,
            each  prazo-compra NO-LOCK 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
            and   prazo-compra.data-entrega > pDtLimite
            and   prazo-compra.quant-saldo > 0:

/*             find first b-prazo-compra NO-LOCK                                                                                                                                                 */
/*                  where b-prazo-compra.numero-ordem = ordem-compra.numero-ordem                                                                                                                */
/*                  and   b-prazo-compra.parcela > 1 no-error.                                                                                                                                   */
/*             if  avail  b-prazo-compra then do:                                                                                                                                                */
/*                 RUN utp/ut-msgs.p (input "SHOW", input 17567,                                                                                                                                 */
/*                                    input "A ordem " + string(ordem-compra.numero-ordem) + " do pedido " + string(ordem-compra.num-pedido) +  " tem mais de uma parcela. Nao sera alterada."). */
/*                 next.                                                                                                                                                                         */
/*             end. /* if  avail  b-prazo-compra */                                                                                                                                              */
            
            find first ordens-embarque NO-LOCK
                WHERE  ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                AND    ordens-embarque.parcela       = prazo-compra.parcela no-error.
            if  avail  ordens-embarque then do:

                RUN pi-busca-posicao. 

                FIND FIRST tt-emb NO-ERROR.
                IF AVAIL tt-emb
                     and tt-emb.situacao >= 2
                     and tt-emb.situacao <= 4 then
                     next.
            end. /* if  avail  ordens-embarque */
            
/*             RUN utp/ut-msgs.p (input "SHOW",                                                                 */
/*                                input 27100,                                                                  */
/*                                input "Altera a ordem " + string(ordem-compra.numero-ordem) + " do pedido " + */
/*                                                          string(ordem-compra.num-pedido)   + " de " +        */
/*                                                          string(prazo-compra.data-entrega) + "."             */
/*                                                        + "~~" +                                              */
/*                                      "Altera a ordem " + string(ordem-compra.numero-ordem) + " do pedido " + */
/*                                                          string(ordem-compra.num-pedido)   + " de " +        */
/*                                                          string(prazo-compra.data-entrega) + ".").           */
/*                                                                                                              */
/*             IF RETURN-VALUE = "NO" THEN next.                                                                */

            find cotacao-item EXCLUSIVE-LOCK 
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                and   cotacao-item.cot-aprovada NO-ERROR.
            IF NOT AVAIL cotacao-item THEN NEXT.

            find item-fornec no-lock
                 where item-fornec.it-codigo = item-tab.it-codigo
                   and item-fornec.cod-emitente = tb-pr-cc.cod-emitente.

            assign i-num-casa-dec            = exp(10,item-fornec.num-casa-dec)
                   de-fator-conver           = item-fornec.fator-conver / i-num-casa-dec
                   ordem-compra.preco-unit   = item-tab.pr-item * de-fator-conver + 
                                               if not tb-pr-cc.codigo-ipi 
                                               then ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                                               else 0 
                   cotacao-item.preco-unit   = item-tab.pr-item * de-fator-conver + 
                                               if not tb-pr-cc.codigo-ipi 
                                               then ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                                               else 0 
                   ordem-compra.pre-unit-for = item-tab.pr-item + 
                                               if not tb-pr-cc.codigo-ipi 
                                               then ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                                               else 0 
                   ordem-compra.preco-fornec = item-tab.pr-item
                   cotacao-item.pre-unit-for = item-tab.pr-item + 
                                               if not tb-pr-cc.codigo-ipi 
                                               then ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                                               else 0 
                   cotacao-item.preco-fornec = item-tab.pr-item
                   ordem-compra.aliquota-icm = item-tab.aliquota-icm
                   cotacao-item.aliquota-icm = item-tab.aliquota-icm
                   ordem-compra.aliquota-ipi = item-tab.aliquota-ipi
                   cotacao-item.aliquota-ipi = item-tab.aliquota-ipi.

/*                     RUN utp/ut-msgs.p (input "show", input 27979,                                                                                                      */
/*                                        input "Foi alterada a ordem " + string(ordem-compra.numero-ordem) +  " do pedido " + string(ordem-compra.num-pedido) +  " .").  */
        end. /* for each  ordem-compra EXCLUSIVE-LOCK */
    END. /* FOR FIRST item-tab NO-LOCK */
END PROCEDURE. /* PROCEDURE p-atualiza-pedido: */

PROCEDURE pi-busca-posicao :
    
    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1 /* NÆo Encerrado */
        AND   embarque-imp.cod-estabel = v_cod_estab_usuar
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}   
        
    END. /* FOR EACH  embarque-imp NO-LOCK */

END PROCEDURE. /* PROCEDURE pi-busca-posicao : */
