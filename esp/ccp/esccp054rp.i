assign i-cont = i-cont + 1.

if i-cont mod 5 = 0
then run pi-acompanhar in h-acomp (input i-cont).

assign c-desc-transp1 = ""
       c-desc-transp2 = "".

create tt-pedidos.
assign tt-pedidos.num-pedido-orig   = int-rel-ped-import.num-pedido-orig
       tt-pedidos.numero-ordem-orig = int-rel-ped-import.numero-ordem-orig
       tt-pedidos.it-codigo         = ordem-compra.it-codigo
       tt-pedidos.desc-item         = trim(item.desc-item)
       tt-pedidos.parcela-orig      = int-rel-ped-import.parcela-orig
       tt-pedidos.cod-emitente      = pedido-compr.cod-emitente
       tt-pedidos.nome-emit         = emitente.nome-emit
       tt-pedidos.cod-estabel       = pedido-compr.cod-estabel
       tt-pedidos.data-pedido       = pedido-compr.data-pedido
       tt-pedidos.situacao          = entry(pedido-compr.situacao,c-situacao)
       tt-pedidos.num-pedido-dest   = int-rel-ped-import.num-pedido-dest
       tt-pedidos.numero-ordem-dest = int-rel-ped-import.numero-ordem-dest
       tt-pedidos.parcela-dest      = int-rel-ped-import.parcela-dest
       tt-pedidos.comentarios       = int-rel-ped-import.comentarios
       tt-pedidos.tipo-proces       = i-aux.

case i-aux:
    when 1 /* Origem */
    then assign tt-pedidos.cod-cond-pag-orig = ordem-compra.cod-cond-pag
                tt-pedidos.quant-saldo-orig  = prazo-compra.quant-saldo
                tt-pedidos.preco-fornec-orig = ordem-compra.preco-fornec
                tt-pedidos.cod-cond-pag-dest = b-ordem-compra.cod-cond-pag
                tt-pedidos.quant-saldo-dest  = b-prazo-compra.quant-saldo
                tt-pedidos.preco-fornec-dest = b-ordem-compra.preco-fornec
                c-desc-transp1               = fn-transp(pedido-compr.via-transp)
                c-desc-transp2               = fn-transp(b-pedido-compr.via-transp).
    when 2 /* Destino */
    then assign tt-pedidos.cod-cond-pag-orig = b-ordem-compra.cod-cond-pag
                tt-pedidos.quant-saldo-orig  = b-prazo-compra.quant-saldo
                tt-pedidos.preco-fornec-orig = b-ordem-compra.preco-fornec
                tt-pedidos.cod-cond-pag-dest = ordem-compra.cod-cond-pag
                tt-pedidos.quant-saldo-dest  = prazo-compra.quant-saldo
                tt-pedidos.preco-fornec-dest = ordem-compra.preco-fornec
                c-desc-transp1               = fn-transp(b-pedido-compr.via-transp)
                c-desc-transp2               = fn-transp(pedido-compr.via-transp).
end case.

assign tt-pedidos.desc-transp-orig = c-desc-transp1
       tt-pedidos.desc-transp-dest = c-desc-transp2.

