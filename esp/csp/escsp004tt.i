define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD cod-estabel-ini  AS CHARACTER
    FIELD cod-estabel-fim  AS CHARACTER
    FIELD it-codigo-ini    AS CHARACTER
    FIELD it-codigo-fim    AS CHARACTER
    FIELD excel            AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem as character
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
