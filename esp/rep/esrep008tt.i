define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD cod-estab-ini    AS CHARACTER
    FIELD cod-estab-fim    AS CHARACTER
    FIELD ini-cod-emitente AS INTEGER
    FIELD fim-cod-emitente AS INTEGER
    FIELD ini-nat-operacao AS CHAR
    FIELD fim-nat-operacao AS CHAR
    FIELD ini-it-codigo    AS CHAR
    FIELD fim-it-codigo    AS CHAR
    FIELD narrativa        AS LOGICAL
    FIELD observacao       AS LOGICAL
    FIELD data-corte       AS DATE
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE
    FIELD analit-sint      AS LOGICAL
    FIELD saldo-zero       AS LOGICAL
    FIELD notas-transf     AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
