define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD ini-data         AS DATE
    FIELD fim-data         AS DATE
    FIELD tipo             AS INTEGER
    field cod-ini-estabel  as char
    field cod-fim-estabel  as char
    FIELD cod-msg-devolucao-ini AS INT
    FIELD cod-msg-devolucao-fim AS INT.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
