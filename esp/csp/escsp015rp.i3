create tt-oper-ord.
assign tt-oper-ord.it-codigo    = operacao.it-codigo
       tt-oper-ord.cod-roteiro  = operacao.cod-roteiro
       tt-oper-ord.op-codigo    = operacao.op-codigo
       tt-oper-ord.gm-codigo    = c-gm-codigo
       tt-oper-ord.tipo         = ""
       tt-oper-ord.cod-estabel  = tt-semiacabados.cod-estabel
       tt-oper-ord.it-aux       = p-it-aux
       tt-oper-ord.tempo-maquin = operacao.tempo-maquin
       tt-oper-ord.quantidade   = 1.

case operacao.un-med-tempo:
    when 2 /* Minutos */
    then assign tt-oper-ord.tempo-maquin = operacao.tempo-maquin / 60.
    when 3 /* Segundos */
    then assign tt-oper-ord.tempo-maquin = operacao.tempo-maquin / 3600.
    when 4 /* Dias */
    then assign tt-oper-ord.tempo-maquin = operacao.tempo-maquin * 24.
end case. /* case oper-ord.un-med-tempo */

assign tt-oper-ord.tempo-unit = tt-oper-ord.tempo-maquin / tt-oper-ord.quantidade.

