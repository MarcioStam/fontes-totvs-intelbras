define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel-ini  as char
    field cod-depos-ini    as char
    field cod-depos-fim    as char
    field it-codigo-ini    as CHAR
    field it-codigo-fim    as CHAR.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    index id ordem.
