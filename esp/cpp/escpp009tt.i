define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD nr-linha-ini     AS INT
    FIELD nr-linha-fim     AS INT
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD minimo-ini       AS INT
    FIELD minimo-fim       AS INT
    FIELD maximo-ini       AS INT
    FIELD maximo-fim       AS INT
    FIELD lista-ok         AS LOGICAL
    FIELD lista-min        AS LOGICAL
    FIELD lista-max        AS LOGICAL
    FIELD imprime-param    AS LOGICAL
    field cod-estabel      as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
