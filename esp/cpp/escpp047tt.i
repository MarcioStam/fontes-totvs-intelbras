define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel       as char
    FIELD it-codigo        AS CHAR
    field dt-data-ini      as date
    field dt-data-fim    as DATE
    FIELD nr-ord-produ-ini AS INT
    FIELD nr-ord-produ-fim AS INT.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
