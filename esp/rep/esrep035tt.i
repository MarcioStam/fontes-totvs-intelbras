define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD ini-data         AS DATE
    FIELD fim-data         AS DATE
    FIELD ini-cod-emitente AS INTEGER
    FIELD fim-cod-emitente AS INTEGER
    FIELD ini-nat-operacao AS CHAR
    FIELD fim-nat-operacao AS CHAR
    FIELD ini-uf           AS CHAR
    FIELD fim-uf           AS CHAR
    FIELD tipo             AS INT
    field natureza         as int
    field imprime-conta    as logical
    FIELD imprime-devol    AS LOGICAL
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    FIELD conta-ini        AS CHAR
    FIELD conta-fim        AS CHAR
    FIELD imprime-financeiro AS LOGICAL
    field imp-rateio       as logical.

define temp-table tt-digita no-undo
    field nat-operacao like natur-oper.nat-operacao
    index id nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
