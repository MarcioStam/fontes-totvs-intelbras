define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field ind-moeda        as int
    field log-despesas     as logical
    field log-invoices     as logical
    field log-fator-interna as logical
    field e-mail           as char extent 4
    field data-ini         as date
    field data-fim         as date.
    
define temp-table tt-digita no-undo
    field it-codigo        like item.it-codigo
    field desc-item        like item.desc-item
    index id it-codigo.
