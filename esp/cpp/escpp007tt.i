define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field it-codigo-ini    AS char 
    FIELD it-codigo-fim    AS CHAR
    FIELD num-linha-ini    AS INT
    FIELD num-linha-fim    AS INT
    FIELD periodo-ini      AS DATE
    FIELD periodo-fim      AS DATE
    FIELD imprime-param    AS LOGICAL
    FIELD ordem            AS INTEGER
    field tipo-rel         as integer
    field estabi           as char
    FIELD estabf           AS CHAR
    FIELD hora-ini         AS CHAR
    FIELD hora-fim         AS CHAR.    

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
