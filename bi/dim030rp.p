/**
 * Extrator para BI
 * Dimens∆o: Relacionamento Item
 *
 * Autor: Hoepers
 * Alteraá‰es: Cleto May
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/dim030tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttDimRelacionamentoItem.
define output parameter table for tt-erro.

for each item-fornec-estab no-lock:
   if not can-find(first estabelec
                   where estabelec.cod-estabel = item-fornec-estab.cod-estabel) then do:
      run createError("Estabelecimento n∆o encontrado " + item-fornec-estab.cod-estabel + ', ' + item-fornec-estab.it-codigo).
      next.
   end.

   find item-uni-estab no-lock
      where item-uni-estab.cod-estabel = item-fornec-estab.cod-estabel
        and item-uni-estab.it-codigo   = item-fornec-estab.it-codigo no-error.

   if not available item-uni-estab then do:
      run createError("Item por estabelecimento n∆o encontrado " + item-fornec-estab.cod-estabel + ', ' + item-fornec-estab.it-codigo).
      next.
   end.

   create ttDimRelacionamentoItem.
   assign ttDimRelacionamentoItem.CD_Estabelecimento = item-fornec-estab.cod-estabel
          ttDimRelacionamentoItem.CD_Item            = fn-free-accent(upper(trim(item-fornec-estab.it-codigo)))
          ttDimRelacionamentoItem.CD_Emitente        = item-fornec-estab.cod-emitente
          ttDimRelacionamentoItem.CD_Comprador       = fn-free-accent(lower(trim(item-uni-estab.cod-comprado))).

   find first int-item-uni-estab no-lock
      where int-item-uni-estab.cod-estabel = item-fornec-estab.cod-estabel
        and int-item-uni-estab.it-codigo   = item-fornec-estab.it-codigo no-error.

   if available int-item-uni-estab then
      assign ttDimRelacionamentoItem.NM_Quantidade_Politica = int-item-uni-estab.qtd-pol.
end.

