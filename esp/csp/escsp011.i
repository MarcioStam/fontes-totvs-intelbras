define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    FIELD arq-entrada      AS CHAR FORMAT "x(60)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita          AS RAW.
