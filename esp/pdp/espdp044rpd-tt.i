define temp-table ttSaldo no-undo
   field it-codigo     like item.it-codigo
   field qtde-dispon   as decimal
   field qtde-min      as decimal initial 1
   index ch-pri is primary unique it-codigo.

/** WebService **/

define temp-table ttEstoque no-undo
   field LojaCodigo                       as character
   field Qtde                             as character
   field QtdeMinimo                       as character
   field ProdutoCodigo                    as character
   field ProdutoValorCaracteristicaCodigo as character
   index ch_pri LojaCodigo ProdutoCodigo.
