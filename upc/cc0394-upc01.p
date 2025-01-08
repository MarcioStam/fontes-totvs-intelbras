/******************************************************************************
*      Programa .....: CC0394-UPC01.P                                         *
*      Data .........: 29 de Novembro de 2022                                 *
*      Sistema ......: CC - COMPRAS                                           *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: Chamado pela UPC no CC0394                             *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 29/11/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "cc0394-upc01" 1.00.00.000} 
{upc/cc0394-upc.i}

def input param p-btOK-pad     as handle no-undo.
def input param p-brTarget     as handle no-undo.
def input param p-pedido-compr as rowid  no-undo.

def var h-buffer     as handle no-undo.
def var i-cont       as inte   no-undo.
def var i-num-pedido as inte   no-undo.
def var i-seq        as inte   no-undo.

def buffer b-pedido-compr for pedido-compr.

empty temp-table tt-cc0394-upc.
empty temp-table tt-cc0394-upc-par.

if  valid-handle(p-btOK-pad)
and valid-handle(p-brTarget)
and can-find(first b-pedido-compr where
                   rowid(b-pedido-compr) = p-pedido-compr
                   no-lock)
then.
else return.

if p-brTarget:num-entries > 0
then do:
     for first b-pedido-compr fields(num-pedido)
         where rowid(b-pedido-compr) = p-pedido-compr
               no-lock: end.
     
     do i-cont = 1 to p-brTarget:num-entries:
         p-brTarget:select-row(i-cont).
         p-brTarget:query:get-current().
         h-buffer = p-brTarget:query:get-buffer-handle(1).
     
         assign i-num-pedido = integer(h-buffer:buffer-field("num-pedido"):buffer-value).
     
         if b-pedido-compr.num-pedido = i-num-pedido
         then next.

         assign i-seq = i-seq + 1.
     
         create tt-cc0394-upc.
         assign tt-cc0394-upc.num-pedido-dest   = b-pedido-compr.num-pedido
                tt-cc0394-upc.num-pedido-orig   = i-num-pedido
                tt-cc0394-upc.numero-ordem-orig = integer(h-buffer:buffer-field("numero-ordem"):buffer-value)
                tt-cc0394-upc.it-codigo         = string(h-buffer:buffer-field("it-codigo"):buffer-value)
                tt-cc0394-upc.processado        = no
                tt-cc0394-upc.validado          = no
                tt-cc0394-upc.seq               = i-seq.

         for each prazo-compra fields(numero-ordem parcela quant-saldo situacao) no-lock
            where prazo-compra.numero-ordem = tt-cc0394-upc.numero-ordem-orig
              and prazo-compra.situacao    <> 4  /* Eliminada */
              and prazo-compra.situacao    <> 6: /* Recebida  */
             create tt-cc0394-upc-par.
             assign tt-cc0394-upc-par.r-tt-cc0394 = rowid(tt-cc0394-upc)
                    tt-cc0394-upc-par.parcela     = prazo-compra.parcela
                    tt-cc0394-upc-par.quant-saldo = prazo-compra.quant-saldo.
         end. /* for each prazo-compra */
     end. /* o i-cont = 1 to p-brTarget:num-entries */

     find current tt-cc0394-upc     no-error.
     find current tt-cc0394-upc-par no-error.
     release tt-cc0394-upc.
     release tt-cc0394-upc-par.
     
     p-brTarget:deselect-rows(). 
end.

apply "choose" to p-btOK-pad.

return.
