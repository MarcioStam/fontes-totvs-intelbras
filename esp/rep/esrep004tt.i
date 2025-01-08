define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD ini-dt-pedido    AS DATE
    FIELD fim-dt-pedido    AS DATE
    FIELD ini-nat-oper     AS INTEGER
    FIELD fim-nat-oper     AS INTEGER
    FIELD ini-usuario      AS CHAR
    FIELD fim-usuario      AS CHAR
    FIELD ini-dt-emissao   AS DATE
    FIELD fim-dt-emissao   AS DATE
    FIELD situacao         AS INTEGER
    FIELD tipo             AS INTEGER
    field estabel-ini      as char
    field estabel-fim      as char.
    


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.



DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
