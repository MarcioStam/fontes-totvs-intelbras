define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD i-cod-cli-ini         LIKE emitente.cod-emitente
    FIELD i-cod-cli-fim         LIKE emitente.cod-emitente
    FIELD c-raiz-ini            AS CHAR
    FIELD c-raiz-fim            AS CHAR
    FIELD i-ordem-ini           AS CHAR
    FIELD i-ordem-Fim           AS CHAR
    FIELD da-data-ini           AS DATE
    FIELD da-data-fim           AS DATE
    FIELD c-usuario-ini         AS CHAR
    FIELD c-usuario-fim         AS CHAR  
    FIELD i-tipo                AS INTEGER.

define temp-table tt-digita no-undo
    field cd-gr-com as CHAR
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
