for first tt-oper-ord
    where tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
      and tt-oper-ord.it-codigo    = ord-prod.it-codigo
      and tt-oper-ord.cod-roteiro  = oper-ord.cod-roteiro
      and tt-oper-ord.op-codigo    = oper-ord.op-codigo
      and tt-oper-ord.gm-codigo    = c-gm-codigo: end.

if not avail tt-oper-ord
then do:
     create tt-oper-ord.
     assign tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
            tt-oper-ord.it-codigo    = ord-prod.it-codigo
            tt-oper-ord.cod-roteiro  = oper-ord.cod-roteiro
            tt-oper-ord.op-codigo    = oper-ord.op-codigo
            tt-oper-ord.gm-codigo    = c-gm-codigo
            tt-oper-ord.cod-estabel  = ord-prod.cod-estabel
            tt-oper-ord.it-aux       = ""
            tt-oper-ord.tempo-maquin = oper-ord.tempo-maquin.

     case ord-prod.tipo:
         when 1
         then assign tt-oper-ord.tipo = "Interna".
         when 4
         then assign tt-oper-ord.tipo = "Retrabalho".
         when 5
         then assign tt-oper-ord.tipo = "Conserto".
     end case. /* case ord-prod.tipo */

     case oper-ord.un-med-tempo:
         when 2 /* Minutos */
         then assign tt-oper-ord.tempo-maquin = oper-ord.tempo-maquin / 60.
         when 3 /* Segundos */
         then assign tt-oper-ord.tempo-maquin = oper-ord.tempo-maquin / 3600.
         when 4 /* Dias */
         then assign tt-oper-ord.tempo-maquin = oper-ord.tempo-maquin * 24.
     end case. /* case oper-ord.un-med-tempo */

     assign tt-oper-ord.tempo-unit = tt-oper-ord.tempo-maquin / ord-prod.qt-ordem.
end. /* if not avail tt-oper-ord */

case p-esp-docto:
    when 1 
    then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade + movto-estoq.quantidade.
    when 8 
    then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade - movto-estoq.quantidade.
end case. /* case p-esp-docto */

assign tt-oper-ord.tempo-maquin = tt-oper-ord.quantidade * tt-oper-ord.tempo-unit.

