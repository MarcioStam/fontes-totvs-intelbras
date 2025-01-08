define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD ini-data         AS DATE
    FIELD fim-data         AS DATE
    FIELD ini-rep          AS INTEGER
    FIELD fim-rep          AS INTEGER
    FIELD ini-familia      AS CHAR
    FIELD fim-familia      AS CHAR
    FIELD ini-it-codigo    AS CHAR
    FIELD fim-it-codigo    AS CHAR
    FIELD familia          AS LOGICAL
    FIELD aca              AS LOGICAL
    FIELD blo              AS LOGICAL
    field cod-estabel-ini  as char
    field cod-estabel-fim  as CHAR
    FIELD cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
    FIELD cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)".

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
