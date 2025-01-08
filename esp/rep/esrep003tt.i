define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD ini-dt-transacao AS DATE
    FIELD fim-dt-transacao AS DATE
    FIELD ini-cod-fornec   AS INTEGER
    FIELD fim-cod-fornec   AS INTEGER
    FIELD usuario-doc      AS CHAR
    FIELD origem           AS LOGICAL
    field cod-estabel      as char
    FIELD observacao       AS CHAR
    FIELD cod-esp-ini      AS CHAR
    FIELD cod-esp-fim      AS CHAR.

define temp-table tt-digita no-undo
    field nat-operacao like natur-oper.nat-operacao
    index id nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
