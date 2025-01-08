define temp-table tt-param no-undo
    FIELD destino          as integer
    FIELD arquivo          as char format "x(35)":U
    FIELD usuario          as char format "x(12)":U
    FIELD data-exec        as date
    FIELD hora-exec        as integer
    FIELD cod-estabel-ini  as char FORMAT "x(5)"
    FIELD cod-estabel-fim  as char FORMAT "x(5)"
    FIELD item-ini         AS CHAR FORMAT "x(16)"
    FIELD item-fim         AS CHAR FORMAT "x(16)"
    FIELD cod-local-ini  as char FORMAT "x(5)"
    FIELD cod-local-fim  as char FORMAT "x(5)"
    FIELD cod-picking-ini  as char FORMAT "x(7)"
    FIELD cod-picking-fim  as char FORMAT "x(7)".

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
