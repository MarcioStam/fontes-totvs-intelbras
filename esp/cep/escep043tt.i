define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field cod-depos        as char
    field ind-tipo         as int
    field ind-imprime-local as int
    field ind-imprimir     as int
    field dt-saldo         as date
    field ind-disponibilidade as int
    field cod-tipo-ini     as int
    field cod-tipo-fim     as int
    field cod-localiz-ini  as char
    field cod-localiz-fim  as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    field cod-obsoleto-ini as int
    field cod-obsoleto-fim as int.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
