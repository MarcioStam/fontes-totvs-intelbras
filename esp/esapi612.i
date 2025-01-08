assign i-aux    = i-aux + 1
       i-pagina = trunc(i-aux / i-page-size,0) + 1.

if i-pagina <> i-page
then next.

create tt-it-aux.
assign tt-it-aux.it-codigo   = item.it-codigo
       tt-it-aux.desc-item   = trim(replace(item.desc-item + " / " + ITEM.desc-inter,'"',''))
       tt-it-aux.un          = caps(item.un)
       tt-it-aux.fm-codigo   = item.fm-codigo
       tt-it-aux.cod-estabel = item-uni-estab.cod-estabel               
       tt-it-aux.pagina      = i-pagina.

