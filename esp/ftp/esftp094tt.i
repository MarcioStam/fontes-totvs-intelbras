define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field desc-estabel     as char
    field nr-embarque      as integer
    field dt-emis-ini      as date
    field dt-emis-fim      as date
.

define temp-table tt-digita no-undo
    field campo1 AS CHAR
    field campo2 AS CHAR
    index codigo is primary campo1.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
