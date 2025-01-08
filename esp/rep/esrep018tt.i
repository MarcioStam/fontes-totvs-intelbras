define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field data-ini         as date
    field data-fim         as date
    field cod-emitente-ini as int
    field cod-emitente-fim as int
    field nat-oper-ini     as char
    field nat-oper-fim     as char
    field uf-ini           as char
    field uf-fim           as char
    FIELD estab-ini        AS CHAR
    FIELD estab-fim        AS CHAR.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
