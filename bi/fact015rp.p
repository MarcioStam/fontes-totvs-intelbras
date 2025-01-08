/**
 * Extrator para BI
 * Fato: Entradas de material e custos
 *
 * Autor: Hoepers
 */
 
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact015tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactEntrada.
define output parameter table for tt-erro.

find first tt-param NO-ERROR.

/****************************  Variaveis    ****************************/
DEFINE VARIABLE v-dat-tmp          AS DATE     NO-UNDO.
DEFINE VARIABLE de-cotacao-di      AS DECIMAL  NO-UNDO.
DEFINE VARIABLE i-numero-ordem     AS INTEGER  NO-UNDO.
define variable de-valor-mat     LIKE movto-estoq.valor-mat-m[1] NO-UNDO.
DEFINE VARIABLE i-cd-motivo-dev    AS INTEGER     NO-UNDO.

/** ConexÆo com o EMS para a execu‡Æo de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

EMPTY TEMP-TABLE ttFactEntrada.
EMPTY TEMP-TABLE tt-docum-est-fora-faixa.

DO v-dat-tmp = tt-param.dt-inicial TO tt-param.dt-final:

    /* Verifica notas originais com despesa complementar em outro per¡odo */
    RUN pi-nota-origem-fora-faixa.

    FOR EACH docum-est NO-LOCK
       WHERE docum-est.dt-trans = v-dat-tmp:

        RUN pi-cria-tt-entradas.

    END. /* FOR EACH docum-est NO-LOCK */
END. /* DO v-dat-tmp = tt-param.dt-inicial TO tt-param.dt-final: */


/* Carregar notas originais com despesa complementar em outro per¡odo */
FOR EACH tt-docum-est-fora-faixa:
    FIND docum-est NO-LOCK
       WHERE ROWID(docum-est) = tt-docum-est-fora-faixa.row-docum-est NO-ERROR.

    IF  AVAIL docum-est
    THEN
        RUN pi-cria-tt-entradas.
END.


PROCEDURE pi-cria-tt-entradas:

   FIND emitente NO-LOCK
       WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.

   FIND embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = docum-est.cod-estabel
          AND embarque-imp.embarque    = SUBSTRING(docum-est.char-1,1,12) NO-ERROR.

   if can-find(first rat-docum no-lock
      where rat-docum.serie-docto  = docum-est.serie-docto 
       and  rat-docum.nro-docto    = docum-est.nro-docto   
       and  rat-docum.cod-emitente = docum-est.cod-emitente
       and  rat-docum.nat-operacao = docum-est.nat-operacao) then next.

   ASSIGN i-cd-motivo-dev = 0.
   FIND int-docum-est OF docum-est NO-LOCK NO-ERROR.  
   IF  AVAIL int-docum-est then
       ASSIGN i-cd-motivo-dev = int-docum-est.cod-msg-devolucao.

   FOR EACH item-doc-est OF docum-est NO-LOCK:
        create ttFactEntrada.
        assign ttFactEntrada.dt_transacao            = docum-est.dt-trans
               ttFactEntrada.dt_emissao              = docum-est.dt-emissao
               ttFactEntrada.cd_documento            = fn-free-accent(upper(trim(docum-est.nro-docto)))
               ttFactEntrada.cd_serie                = fn-free-accent(upper(trim(docum-est.serie-docto)))
               ttFactEntrada.cd_natureza_operacao    = fn-free-accent(upper(trim(item-doc-est.nat-of)))
               ttFactEntrada.cd_sequencia            = item-doc-est.sequencia
               ttFactEntrada.cd_emitente             = docum-est.cod-emitente
               ttFactEntrada.cd_estabelecimento      = fn-free-accent(upper(trim(docum-est.cod-estabel)))
               ttFactEntrada.nm_preco_total_item     = (if docum-est.tot-valor > 0 then if item-doc-est.preco-total[1] > 0 then (docum-est.tot-valor * (item-doc-est.preco-total[1] / docum-est.valor-mercad)) else 0 else 0)
               ttFactEntrada.nm_quantidade           = item-doc-est.quantidade
               ttFactEntrada.nm_preco_unitario       = item-doc-est.preco-unit[1]
               ttFactEntrada.nm_vl_mercadoria_fob    = item-doc-est.preco-total[1]
               ttFactEntrada.cd_conta                = item-doc-est.ct-codigo    
               ttFactEntrada.cd_centro_custo         = item-doc-est.sc-codigo
               ttFactEntrada.cd_unidade_negocio_nota = upper(trim(item-doc-est.cod-unid-negoc))
               ttFactEntrada.cd_item                 = fn-free-accent(upper(trim(item-doc-est.it-codigo)))
               ttFactEntrada.cd_ordem_producao       = item-doc-est.nr-ord-prod
               ttFactEntrada.cd_deposito             = fn-free-accent(upper(trim(item-doc-est.cod-depos)))
               ttFactEntrada.nm_vl_ipi               = item-doc-est.valor-ipi[1]    
               ttFactEntrada.nm_vl_pis               = item-doc-est.valor-pis  
               ttFactEntrada.nm_vl_cofins            = item-doc-est.val-cofins
               ttFactEntrada.cd_pais                 = fn-free-accent(upper(trim(emitente.pais)))
               ttFactEntrada.cd_estado               = fn-free-accent(upper(trim(emitente.estado)))
               ttFactEntrada.cd_cidade               = IF emitente.estado = "DF" THEN "BRASILIA" ELSE fn-free-accent(upper(trim(emitente.cidade)))
               ttFactEntrada.cd_modal                = 1
               ttFactEntrada.CD_Motivo_Dev           = i-cd-motivo-dev.

        assign de-valor-mat = 0.

        IF  item-doc-est.cd-trib-icm = 1 OR
            item-doc-est.cd-trib-icm = 4 
        THEN
            ASSIGN ttFactEntrada.nm_vl_icms       = item-doc-est.valor-icm[1] 
                   ttFactEntrada.nm_vl_icms_compl = item-doc-est.icm-complem[1].

        /* Unidade de neg¢cio */
        find item-uni-estab no-lock
            where item-uni-estab.it-codigo   = item-doc-est.it-codigo
              and item-uni-estab.cod-estabel = docum-est.cod-estabel no-error.

        assign ttFactEntrada.cd_unidade_negocio = upper(if available item-uni-est and item-uni-est.cod-unid-negoc <> '' then item-uni-est.cod-unid-negoc else 'INV').
        
        /* Busca Unidade Neg¢cio da Nota */
        FIND unid_negoc NO-LOCK
            WHERE unid_negoc.cdn_unid_negoc = INT(ttFactEntrada.cd_unidade_negocio_nota) NO-ERROR.

        IF  AVAIL unid_negoc
        THEN
            ASSIGN ttFactEntrada.cd_unidade_negocio_nota = upper(trim(unid_negoc.cod_unid_negoc)).

        IF  ttFactEntrada.cd_unidade_negocio_nota = ""
        THEN
            ASSIGN ttFactEntrada.cd_unidade_negocio_nota = upper(trim(ttFactEntrada.cd_unidade_negocio)).

        /* Buscar datas do Embarque */
        IF  AVAIL embarque-imp 
        THEN DO:
            ASSIGN ttFactEntrada.cd_modal                 = embarque-imp.cod-via-transp
                   ttFactEntrada.cd_embarque              = embarque-imp.embarque
                   ttFactEntrada.cd_declaracao_importacao = embarque-imp.declaracao-imp
                   ttFactEntrada.dt_declaracao_importacao = embarque-imp.data-di.

            run pi-busca-cotacao (INPUT embarque-imp.data-di - 1, OUTPUT de-cotacao-di).

            ASSIGN ttFactEntrada.nm_preco_declaracao_importacao   = item-doc-est.preco-unit[1] / de-cotacao-di
                   ttFactEntrada.nm_cotacao_declaracao_importacao = de-cotacao-di.
            
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
                            ASSIGN ttFactEntrada.dt_embarque = b-historico-embarque.dt-efetiva.
                        END.
                    END.
                END.
            END.
        END. /* IF  AVAIL embarque-imp */
        /* FIM Buscar datas do Embarque */

        RUN pi-custo.

   END. /* FOR EACH item-doc-est OF docum-est NO-LOCK, */
END PROCEDURE.


PROCEDURE pi-custo:

    /* Busca dados ordem compra */
    ASSIGN i-numero-ordem = item-doc-est.numero-ordem .
    
    IF i-numero-ordem = 0 
    THEN DO:
        FIND FIRST rat-ordem OF item-doc-est NO-LOCK NO-ERROR.
        IF AVAIL rat-ordem 
        THEN
            ASSIGN i-numero-ordem = rat-ordem.numero-ordem.
    END.
    
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = i-numero-ordem NO-ERROR.
    IF  AVAIL ordem-compra 
    THEN DO:
        ASSIGN ttFactEntrada.cd_pedido_compra           = ordem-compra.num-pedido
               ttFactEntrada.cd_ordem_compra            = ordem-compra.numero-ordem
               ttFactEntrada.nm_preco_unit_ordem_compra = (item-doc-est.quantidade / item-doc-est.qt-do-forn ) * ordem-compra.preco-unit
               ttFactEntrada.cd_moeda                   = ordem-compra.mo-codigo.

        /* Busca valor sem ordem de compra */
        FIND FIRST movto-estoq NO-LOCK 
             WHERE movto-estoq.serie-docto  = docum-est.serie-docto
               AND movto-estoq.nro-docto    = docum-est.nro-docto
               AND movto-estoq.cod-emitente = docum-est.cod-emitente
               AND movto-estoq.nat-operacao = docum-est.nat-operacao 
               AND movto-estoq.numero-ordem = ordem-compra.numero-ordem
               AND movto-estoq.dt-trans     = docum-est.dt-trans
               AND movto-estoq.it-codigo    = item-doc-est.it-codigo
               AND movto-estoq.tipo-trans   = 1
               AND movto-estoq.esp-docto    = 21 
               AND movto-estoq.quantidade   = item-doc-est.quantidade NO-ERROR.
        IF AVAIL movto-estoq THEN DO:
            ASSIGN de-valor-mat = /*round(*/ movto-estoq.valor-mat-m[1]. /*/ item-doc-est.quantidade, 4) * item-doc-est.quantidade.*/
        END.
        ELSE DO:
            FIND FIRST movto-estoq NO-LOCK
                 WHERE movto-estoq.serie-docto  = docum-est.serie-docto
                   AND movto-estoq.nro-docto    = docum-est.nro-docto
                   AND movto-estoq.cod-emitente = docum-est.cod-emitente
                   AND movto-estoq.nat-operacao = docum-est.nat-operacao 
                   AND movto-estoq.numero-ordem = ordem-compra.numero-ordem
                   AND movto-estoq.it-codigo    = item-doc-est.it-codigo
                   AND movto-estoq.dt-trans     = docum-est.dt-trans
                   AND movto-estoq.tipo-trans   = 1
                   AND movto-estoq.esp-docto    = 21 NO-ERROR.
            IF AVAIL movto-estoq THEN DO:
                ASSIGN de-valor-mat = /*round(*/ movto-estoq.valor-mat-m[1]. /*/ item-doc-est.quantidade, 4) * item-doc-est.quantidade.*/
            END.
        END.
        /* Fim busca valor sem ordem de compra */

    END.
    
    IF NOT AVAIL ordem-compra OR ttFactEntrada.nm_vl_mercadoria_cif = 0 OR ttFactEntrada.nm_vl_mercadoria_cif = ? then do:
       FIND FIRST movto-estoq NO-LOCK 
             WHERE movto-estoq.serie-docto  = docum-est.serie-docto
               AND movto-estoq.nro-docto    = docum-est.nro-docto
               AND movto-estoq.cod-emitente = docum-est.cod-emitente
               AND movto-estoq.nat-operacao = docum-est.nat-operacao 
               AND movto-estoq.dt-trans     = docum-est.dt-trans
               AND movto-estoq.it-codigo    = item-doc-est.it-codigo
               AND movto-estoq.tipo-trans   = 1
               AND movto-estoq.esp-docto    = 21 
               AND movto-estoq.quantidade   = item-doc-est.quantidade NO-ERROR.
        IF AVAIL movto-estoq THEN DO:
            ASSIGN de-valor-mat = /*round(*/ movto-estoq.valor-mat-m[1]. /*/ item-doc-est.quantidade, 4) * item-doc-est.quantidade.*/
        END.
        ELSE DO:
            FIND FIRST movto-estoq NO-LOCK
                 WHERE movto-estoq.serie-docto  = docum-est.serie-docto
                   AND movto-estoq.nro-docto    = docum-est.nro-docto
                   AND movto-estoq.cod-emitente = docum-est.cod-emitente
                   AND movto-estoq.nat-operacao = docum-est.nat-operacao 
                   AND movto-estoq.it-codigo    = item-doc-est.it-codigo
                   AND movto-estoq.dt-trans     = docum-est.dt-trans
                   AND movto-estoq.tipo-trans   = 1
                   AND movto-estoq.esp-docto    = 21 NO-ERROR.
            IF AVAIL movto-estoq THEN DO:
                ASSIGN de-valor-mat = /*round(*/ movto-estoq.valor-mat-m[1]. /*/ item-doc-est.quantidade, 4) * item-doc-est.quantidade.*/
            end.
        end.
    end.
    /* Fim Busca dados ordem compra */
                                               
    /* Busca despesas nota */
    for each item-doc-est-cex of item-doc-est no-lock:
        FOR FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp:
        END.
        IF AVAIL desp-imp 
        THEN DO:
            IF desp-imp.gera-custo /* considerar apenas as despesas que geram custo ao item */
            THEN DO: 
                ASSIGN ttFactEntrada.nm_despesa_total = ttFactEntrada.nm_despesa_total + item-doc-est-cex.val-desp.
    
                CASE item-doc-est-cex.cod-desp:
                    WHEN(1)
                        THEN ASSIGN ttFactEntrada.nm_vl_importacao = ttFactEntrada.nm_vl_importacao + item-doc-est-cex.val-desp.
                    WHEN(3)  OR
                    WHEN(27) OR
                    WHEN(93)
                        THEN ASSIGN ttFactEntrada.nm_vl_frete    = ttFactEntrada.nm_vl_frete    + item-doc-est-cex.val-desp.
                    WHEN(22)
                        THEN ASSIGN ttFactEntrada.nm_vl_seguro   = ttFactEntrada.nm_vl_seguro   + item-doc-est-cex.val-desp.
                    WHEN(32) OR
                    WHEN(42)
                        THEN ASSIGN ttFactEntrada.nm_vl_handling = ttFactEntrada.nm_vl_handling + item-doc-est-cex.val-desp.
                END CASE.
            END.
            ELSE DO:
                ASSIGN de-valor-mat = de-valor-mat - item-doc-est-cex.val-desp.
            END.
        END.
    end. /* for each item-doc-est-cex of item-doc-est no-lock: */

    IF de-valor-mat > 0 THEN DO:
        ASSIGN ttFactEntrada.nm_vl_mercadoria_cif = de-valor-mat.
    END.

    IF ttFactEntrada.nm_vl_mercadoria_cif = ? THEN
        ASSIGN ttFactEntrada.nm_vl_mercadoria_cif = 0.

    /* Caso nÆo tenha despesas de importa‡Æo busca valores da nota */
    IF  ttFactEntrada.nm_vl_frete = 0 and docum-est.valor-frete > 0 then
       ASSIGN ttFactEntrada.nm_vl_frete = docum-est.valor-frete  * (item-doc-est.preco-total[1] / docum-est.valor-mercad).

    IF  ttFactEntrada.nm_vl_seguro = 0 and docum-est.valor-seguro > 0 then
       ASSIGN ttFactEntrada.nm_vl_seguro = docum-est.valor-seguro * (item-doc-est.preco-total[1] / docum-est.valor-mercad).

    ASSIGN ttFactEntrada.nm_outras_despesas      = ttFactEntrada.nm_despesa_total - ttFactEntrada.nm_vl_importacao - ttFactEntrada.nm_vl_frete - ttFactEntrada.nm_vl_seguro - ttFactEntrada.nm_vl_handling
           ttFactEntrada.nm_cotacao_ordem_compra = IF ttFactEntrada.nm_preco_unit_ordem_compra = 0 THEN 0 ELSE ttFactEntrada.nm_preco_unitario / ttFactEntrada.nm_preco_unit_ordem_compra.
    /* Fim Busca despesas nota */

    /* Buscar valor notas complementares */
    FOR EACH rat-docum NO-LOCK USE-INDEX nf-docto
       WHERE rat-docum.nf-serie     = docum-est.serie-docto
         AND rat-docum.nf-nro       = docum-est.nro-docto
         AND rat-docum.nf-emitente  = docum-est.cod-emitente
         AND rat-docum.nf-nat-oper  = docum-est.nat-oper:

        FIND FIRST b-docum-est USE-INDEX documento 
             WHERE b-docum-est.serie-docto  = rat-docum.serie-docto 
               AND b-docum-est.nro-docto    = rat-docum.nro-docto   
               AND b-docum-est.cod-emitente = rat-docum.cod-emitente 
               AND b-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK NO-ERROR.

        IF AVAIL b-docum-est THEN DO:
            FOR EACH b-item-doc-est OF b-docum-est
               WHERE b-item-doc-est.it-codigo = item-doc-est.it-codigo NO-LOCK:
        
                FIND FIRST movto-estoq NO-LOCK
                     WHERE movto-estoq.serie-docto  = b-docum-est.serie-docto
                       AND movto-estoq.nro-docto    = b-docum-est.nro-docto
                       AND movto-estoq.cod-emitente = b-docum-est.cod-emitente
                       AND movto-estoq.nat-operacao = b-docum-est.nat-operacao 
                       AND movto-estoq.it-codigo    = b-item-doc-est.it-codigo
                       AND movto-estoq.sequen-nf    = b-item-doc-est.sequencia
                       AND movto-estoq.dt-trans     = b-docum-est.dt-trans
                       AND movto-estoq.tipo-trans   = 1
                       AND movto-estoq.esp-docto    = 18 NO-ERROR.
                IF AVAIL movto-estoq THEN
                    ASSIGN ttFactEntrada.nm_vl_nota_complementar = ttFactEntrada.nm_vl_nota_complementar + movto-estoq.valor-mat-m[1].
            END.
        END.
    END.
    /* Fim Buscar valor notas complementares */

    ASSIGN ttFactEntrada.nm_fator_internacao = (ttFactEntrada.nm_vl_mercadoria_fob + ttFactEntrada.nm_despesa_total) / ttFactEntrada.nm_vl_mercadoria_fob.
    
    IF ttFactEntrada.nm_fator_internacao = ? 
    THEN
        ASSIGN ttFactEntrada.nm_fator_internacao = 0.
                                              
END PROCEDURE.


PROCEDURE pi-busca-cotacao.
    DEF INPUT PARAMETER p-da-data as DATE NO-UNDO.
    DEF OUTPUT PARAMETER p-de-cotacao AS DEC NO-UNDO.
    
    FIND cotacao NO-LOCK         WHERE
         cotacao.mo-codigo   = 1 AND
         cotacao.ano-periodo = STRING(year(p-da-data),"9999") + STRING(month(p-da-data),"99") NO-ERROR.
            
    IF AVAIL cotacao AND 
             cotacao.cotacao[day(p-da-data)] <> 0 THEN  
       ASSIGN p-de-cotacao = cotacao.cotacao[day(p-da-data)].
    ELSE
       ASSIGN p-de-cotacao = 1.
END.


PROCEDURE pi-nota-origem-fora-faixa:

    FOR EACH  movto-estoq NO-LOCK
        WHERE movto-estoq.esp-docto  = 18 /* Nota Complementar */
          AND movto-estoq.dt-trans   = v-dat-tmp
          AND movto-estoq.tipo-trans = 1:

        FIND FIRST rat-docum NO-LOCK USE-INDEX nf-docto
            WHERE  rat-docum.serie-docto   = movto-estoq.serie-docto 
              AND  rat-docum.nro-docto     = movto-estoq.nro-docto   
              AND  rat-docum.cod-emitente  = movto-estoq.cod-emitente
              AND  rat-docum.nat-operacao  = movto-estoq.nat-operacao NO-ERROR.

        IF  AVAIL rat-docum
        THEN DO:
            FIND FIRST docum-est NO-LOCK USE-INDEX documento 
                 WHERE docum-est.serie-docto  = rat-docum.nf-serie   
                   AND docum-est.nro-docto    = rat-docum.nf-nro     
                   AND docum-est.cod-emitente = rat-docum.nf-emitente 
                   AND docum-est.nat-operacao = rat-docum.nf-nat-oper NO-ERROR.

            IF  AVAIL docum-est AND
                     (docum-est.dt-trans < tt-param.dt-inicial OR
                      docum-est.dt-trans > tt-param.dt-final)
            THEN DO:
                FIND tt-docum-est-fora-faixa 
                    WHERE tt-docum-est-fora-faixa.row-docum-est = ROWID(docum-est) NO-ERROR.

                IF  NOT AVAIL tt-docum-est-fora-faixa
                THEN DO:
                    CREATE tt-docum-est-fora-faixa.
                    ASSIGN tt-docum-est-fora-faixa.row-docum-est = ROWID(docum-est).
                END.
            END.
        END. /* IF  AVAIL rat-docum */
    END. /* FOR EACH  movto-estoq NO-LOCK */
END PROCEDURE.

