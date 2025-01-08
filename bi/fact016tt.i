define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table ttFactEntradaPedido no-undo
   field CD_Estabelecimento     like ordem-compra.cod-estabel
   field CD_Pedido_Compra       like ordem-compra.num-pedido
   field CD_Ordem_Compra        like ordem-compra.numero-ordem
   field CD_Emitente            like ordem-compra.cod-emitente
   field DT_Pedido              like ordem-compra.data-pedido
   field DT_Original            like prazo-compra.data-orig
   field DT_Entrega             like prazo-compra.data-entrega
   field DT_Despacho            like prazo-compra.data-entrega
   field DT_Embarque            like prazo-compra.data-entrega
   field DT_Posicao               as date
   field CD_Moeda               like ordem-compra.mo-codigo
   field CD_Parcela             like prazo-compra.parcela
   field CD_Item                like prazo-compra.it-codigo
   field CD_Embarque            like embarque-imp.embarque
   field CD_Modal               like pedido-compr.via-transp
   field CD_Situacao_Embarque     as char
   field CD_Dias_Atraso           as int 
   field NM_Quantidade_Pedida   like prazo-compra.quantidade
   field NM_Quantidade_Recebida like prazo-compra.quantidade
   field NM_Quantidade_Saldo    like prazo-compra.quantidade
   field NM_Preco_Unit_Fornec   like cotacao-item.preco-fornec
   field NM_Cotacao_Compra      like cotacao.cotacao[1]
   field NM_Valor_Unitario      like cotacao-item.pre-unit-for
   field NM_Valor_Unitario_Ipi  like cotacao-item.pre-unit-for
   field NM_Valor_Saldo           as decimal
   index id_item_entrega_fornec
         cd_item
         dt_entrega
         cd_emitente.

def temp-table tt-emb
    field situacao as int
    index codigo is primary situacao.
