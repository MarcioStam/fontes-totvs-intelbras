define temp-table tt-param no-undo
    FIELD destino          as integer
    FIELD arquivo          as char format "x(35)":U
    FIELD usuario          as char format "x(12)":U
    FIELD data-exec        as date
    FIELD hora-exec        as integer
    FIELD data-ini         AS date
    FIELD data-fim         AS date
    FIELD cod-estabel-ini  as char
    FIELD cod-estabel-fim  as char
    FIELD rs-tipo          AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
