for each int-rel-ped-import use-index {1} no-lock
   where int-rel-ped-import.{2} >= tt-param.num-pedido-ini
     and int-rel-ped-import.{2} <= tt-param.num-pedido-fim,
   first pedido-compr no-lock
   where pedido-compr.num-pedido    = int-rel-ped-import.{2}
     and pedido-compr.data-pedido  >= tt-param.data-pedido-ini
     and pedido-compr.data-pedido  <= tt-param.data-pedido-fim
     and pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
     and pedido-compr.cod-emitente <= tt-param.cod-emitente-fim,
   first emitente fields(cod-emitente nome-emit) no-lock
   where emitente.cod-emitente = pedido-compr.cod-emitente,
   first ordem-compra no-lock
   where ordem-compra.numero-ordem   = int-rel-ped-import.{3}
     and ordem-compra.it-codigo     >= tt-param.it-codigo-ini
     and ordem-compra.it-codigo     <= tt-param.it-codigo-fim,
   first item fields(it-codigo desc-item) no-lock
   where item.it-codigo = ordem-compra.it-codigo,
   first prazo-compra no-lock
   where prazo-compra.numero-ordem = ordem-compra.numero-ordem
     and prazo-compra.parcela      = int-rel-ped-import.{4},
   first b-ordem-compra no-lock
   where b-ordem-compra.numero-ordem = int-rel-ped-import.{5},
   first b-pedido-compr no-lock
   where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido,
   first b-prazo-compra no-lock
   where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem
     and b-prazo-compra.parcela      = int-rel-ped-import.{6}:
    {esp/ccp/esccp054rp.i}
end. /* for each int-rel-ped-import */
