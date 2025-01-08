def new global shared temp-table tt-cc0394-upc no-undo
    field num-pedido-dest   like ordem-compra.num-pedido
    field numero-ordem-dest like ordem-compra.numero-ordem
    field num-pedido-orig   like ordem-compra.num-pedido
    field numero-ordem-orig like ordem-compra.numero-ordem
    field it-codigo         like ordem-compra.it-codigo
    field seq               as integer
    field processado        as logical
    field validado          as logical
    index id is primary num-pedido-dest
                        it-codigo
                        processado
                        seq
    index id2 numero-ordem-orig
              processado.

def new global shared temp-table tt-cc0394-upc-par no-undo
    field r-tt-cc0394  as rowid
    field parcela-orig like prazo-compra.parcela
    field quant-saldo  like prazo-compra.quant-saldo
    index id is primary r-tt-cc0394.

