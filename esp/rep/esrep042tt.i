define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD data-ini         AS date
    FIELD data-fim         AS date
    FIELD cod-estabel-ini  as char
    FIELD cod-estabel-fim  as char
    FIELD cod-emitente-ini AS INTE
    FIELD cod-emitente-fim AS INTE
    FIELD tg-filtra-sit    AS LOG
    FIELD situacao         AS INT
    FIELD c-cgc-ini        AS CHAR
    FIELD c-cgc-fim        AS CHAR
    .

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
