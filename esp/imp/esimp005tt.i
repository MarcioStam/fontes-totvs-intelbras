define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field log-estrutura    as logical
    field ind-tipo         as int
    field log-excel        as logical
    field cotacao          as dec
    field pis              as dec
    field cofins           as dec
    field data-fi-ini      as date
    field data-fi-fim      as date.
    
define temp-table tt-digita no-undo
    field it-codigo        like item.it-codigo
    field desc-item        like item.desc-item
    index id it-codigo.
