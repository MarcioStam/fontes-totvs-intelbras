define temp-table ttPedido no-undo
   field PedidoCodigo   like int-ped-venda.PedidoCodigo
   field statusOk       as logical initial true
   index ch-Pedido      is primary unique PedidoCodigo.
