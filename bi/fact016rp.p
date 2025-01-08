/**
 * Extrator para BI
 * Fato: Entradas previstas para pedidos e ordens de compra
 *
 * Autor: Hoepers
 */
 
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact016tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactEntradaPedido.
define output parameter table for tt-erro.

find first tt-param NO-ERROR.

/****************************  Variaveis    ****************************/
DEFINE VARIABLE de-cotacao-di      AS DECIMAL  NO-UNDO.
DEFINE VARIABLE i-numero-ordem     AS INTEGER  NO-UNDO.

/** ConexÆo com o EMS para a execu‡Æo de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

EMPTY TEMP-TABLE ttFactEntradaPedido.

FOR EACH prazo-compra NO-LOCK
   WHERE prazo-compra.situacao     = 2 /*confirmada*/
     AND prazo-compra.quant-saldo  > 0,
   FIRST ordem-compra of prazo-compra NO-LOCK
   WHERE ordem-compra.situacao = 2 /*confirmada*/,
   FIRST ITEM NO-LOCK
   WHERE item.it-codigo = ordem-compra.it-codigo,
   FIRST pedido-compr NO-LOCK
   WHERE pedido-compr.num-pedido = ordem-compra.num-pedido:

   CREATE ttFactEntradaPedido.
   ASSIGN ttFactEntradaPedido.cd_emitente            = ordem-compra.cod-emitente
          ttFactEntradaPedido.cd_pedido_compra       = ordem-compra.num-pedido
          ttFactEntradaPedido.cd_ordem_compra        = ordem-compra.numero-ordem
          ttFactEntradaPedido.cd_parcela             = prazo-compra.parcela
          ttFactEntradaPedido.cd_estabelecimento     = fn-free-accent(upper(trim(ordem-compra.cod-estabel)))
          ttFactEntradaPedido.cd_item                = fn-free-accent(upper(trim(ordem-compra.it-codigo)))
          ttFactEntradaPedido.dt_original            = prazo-compra.data-orig
          ttFactEntradaPedido.dt_entrega             = prazo-compra.data-entrega
          ttFactEntradaPedido.dt_pedido              = pedido-compr.data-pedido
          ttFactEntradaPedido.dt_posicao             = today
          ttFactEntradaPedido.nm_quantidade_pedida   = prazo-compra.quantidade
          ttFactEntradaPedido.nm_quantidade_recebida = prazo-compra.quant-receb
          ttFactEntradaPedido.nm_quantidade_saldo    = prazo-compra.quant-saldo
          ttFactEntradaPedido.cd_modal               = pedido-compr.via-transp
          ttFactEntradaPedido.cd_situacao_embarque   = "PREVISTO"
          ttFactEntradaPedido.nm_cotacao_compra      = 1
          ttFactEntradaPedido.dt_embarque            = ?
          ttFactEntradaPedido.dt_despacho            = ?
          ttFactEntradaPedido.cd_dias_atraso         = today - prazo-compra.data-entrega.

   RUN pi-dados-embarque.

END. /* FOR EACH prazo-compra NO-LOCK */

PROCEDURE pi-dados-embarque:

    FIND FIRST cotacao-item NO-LOCK
        WHERE  cotacao-item.numero-ordem = ordem-compra.numero-ordem 
          AND  cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

    IF  AVAIL cotacao-item 
    THEN 
        FIND FIRST itinerario NO-LOCK 
            WHERE  itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
    
    FIND LAST ordens-embarque NO-LOCK 
        WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
          AND ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

    IF  AVAIL ordens-embarque
    THEN DO:
        ASSIGN ttFactEntradaPedido.cd_embarque = ordens-embarque.embarque.

        FIND FIRST embarque-imp NO-LOCK
            WHERE  embarque-imp.cod-estabel = ordens-embarque.cod-estabel 
              AND  embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

        FIND FIRST historico-embarque NO-LOCK 
            WHERE  historico-embarque.cod-estabel   = ordem-compra.cod-estabel 
              AND  historico-embarque.embarque      = ordens-embarque.embarque 
              AND  historico-embarque.cod-itiner    = cotacao-item.int-1       
              AND  historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

        IF  AVAIL historico-embarque 
        THEN
            IF historico-embarque.dt-efetiva = ? 
            THEN
                ASSIGN ttFactEntradaPedido.dt_embarque = historico-embarque.dt-ult-previsao.
            ELSE
                ASSIGN ttFactEntradaPedido.dt_embarque = historico-embarque.dt-efetiva.

        FIND FIRST historico-embarque NO-LOCK
            WHERE  historico-embarque.cod-estabel   = ordem-compra.cod-estabel 
              AND  historico-embarque.embarque      = ordens-embarque.embarque 
              AND  historico-embarque.cod-itiner    = cotacao-item.int-1       
              AND  historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.

        IF  AVAIL historico-embarque 
        THEN
            IF historico-embarque.dt-efetiva = ? 
            THEN
                ASSIGN ttFactEntradaPedido.dt_despacho = historico-embarque.dt-ult-previsao.
            ELSE
                ASSIGN ttFactEntradaPedido.dt_despacho = historico-embarque.dt-efetiva.

        /* Busca Situa‡Æo do Embarque */
        RUN pi-situacao.
    END. /* IF  AVAIL ordens-embarque */
    ELSE
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".

    /* Busca Cota‡Æo */
    IF AVAIL cotacao-item 
    THEN DO:
        IF cotacao-item.mo-codigo <> 0 
        THEN DO:
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

            IF emitente.natureza <= 2 /* Nacional */
            THEN
                RUN pi-busca-cotacao  (input ordem-compra.data-emissao).
            ELSE
                RUN pi-busca-cotacao  (input prazo-compra.data-entrega).
        END.    
        
        ASSIGN ttFactEntradaPedido.cd_moeda              = cotacao-item.mo-codigo
               ttFactEntradaPedido.nm_preco_unit_fornec  = cotacao-item.preco-fornec
               ttFactEntradaPedido.nm_valor_unitario     = cotacao-item.preco-fornec * ttFactEntradaPedido.nm_cotacao_compra
               ttFactEntradaPedido.nm_valor_unitario_ipi = cotacao-item.pre-unit-for * ttFactEntradaPedido.nm_cotacao_compra
               ttFactEntradaPedido.nm_valor_saldo        = prazo-compra.quant-saldo * ttFactEntradaPedido.nm_valor_unitario.
    END.

END PROCEDURE.


PROCEDURE pi-busca-cotacao :
DEF INPUT PARAMETER da-data as DATE NO-UNDO.
    
    FIND FIRST cotacao NO-LOCK         
        WHERE  cotacao.mo-codigo   = cotacao-item.mo-codigo 
          AND  cotacao.ano-periodo = STRING(year(da-data),"9999") + STRING(month(da-data),"99") NO-ERROR.

    IF AVAIL cotacao AND 
             cotacao.cotacao[day(da-data)] <> 0 
    THEN  
        ASSIGN ttFactEntradaPedido.nm_cotacao_compra = cotacao.cotacao[day(da-data)].
END.


PROCEDURE pi-situacao:

    FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.
    IF NOT AVAIL historico-embarque 
    THEN DO:
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
        RETURN.
    END.

    FIND itinerario WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK.
    IF itinerario.pto-embarque = 0 
    THEN DO:
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
        RETURN.
    END.

    FIND historico-embarque OF embarque-imp NO-LOCK
         WHERE historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
    IF NOT AVAIL historico-embarque 
    THEN DO:
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
        RETURN.
    END.
  
    IF historico-embarque.dt-efetiva <> ? 
    THEN
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "EMBARCADO". 

    IF itinerario.pto-eadi <> 0 /* Ponto EADI */
    THEN DO:
        FIND historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-eadi NO-ERROR.
        IF NOT AVAIL historico-embarque THEN DO:
            FIND FIRST historico-embarque OF embarque-imp
                 WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-LOCK NO-ERROR.
            IF AVAIL historico-embarque 
                 AND historico-embarque.dt-efetiva = ? 
            THEN DO:
                ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
                RETURN.
            END.
        END.
        ELSE DO:
            IF historico-embarque.dt-efetiva <> ? 
            THEN 
                ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "EADI".

            IF embarque-imp.cod-estabel = "101" OR
               embarque-imp.cod-estabel = "102" 
            THEN DO:
                IF embarque-imp.cod-estabel = '101' 
                THEN
                    FIND historico-embarque OF embarque-imp
                        WHERE historico-embarque.cod-pto-contr = 33 NO-LOCK NO-ERROR. /* EADI Saida, base Intelbras.*/
                ELSE 
                    IF embarque-imp.cod-estabel = '102' 
                    THEN
                        FIND historico-embarque OF embarque-imp
                            WHERE historico-embarque.cod-pto-contr = 35 NO-LOCK NO-ERROR. /* EADI Saida, base Nova. */

                IF NOT AVAIL historico-embarque 
                THEN DO:
                    ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
                    RETURN.
                END.
            END.
        END.
    END.

    FIND historico-embarque OF embarque-imp
        WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-LOCK NO-ERROR.
    IF NOT AVAIL historico-embarque 
    THEN DO:
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "PEDIDO".
        RETURN.
    END.
    IF historico-embarque.dt-efetiva <> ? 
    THEN 
        ASSIGN ttFactEntradaPedido.cd_situacao_embarque = "NF".

END PROCEDURE.

