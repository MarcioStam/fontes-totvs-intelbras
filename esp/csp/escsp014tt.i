define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(45)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-desp-ini     as integer
    field cod-desp-fim     as integer
    field arquivo-csv      as char format "x(45)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
