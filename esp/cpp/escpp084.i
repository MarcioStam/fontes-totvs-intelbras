define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    FIELD cod-estabel       AS CHAR
    FIELD cod-prod          AS INT
    FIELD cod-componente    AS CHAR
    FIELD cod-falha         AS INT
    FIELD origem-falha      AS INT
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD saida-excel       AS CHAR
    FIELD tg-produ          AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
