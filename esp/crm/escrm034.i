/** temp-tables do WS **/

define temp-table tt-Pedido no-undo
   field cliente               as character
   field transportadora        as character
   field estabelecimento       as character
   field atendente             as character
   field canalDeVendas         as character.
                               
define temp-table tt-Itens no-undo
   field codigoItem            as character
   field quantidade            as character
   field numeroOs              as character
   field id                    as character
   FIELD codigoProdutoPrincipal AS CHARACTER.




/** temp-tables para BO's **/
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

