define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD dt-emissao-ini   AS date
    FIELD dt-emissao-fim   AS date
    FIELD nr-ord-produ-ini AS INTEGER
    FIELD nr-ord-produ-fim AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
