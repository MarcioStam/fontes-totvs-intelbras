define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD da-data-ini           LIKE nota-fiscal.dt-emis-nota
    FIELD da-data-fim           LIKE nota-fiscal.dt-emis-nota
    FIELD i-cod-cli-ini         LIKE emitente.cod-emitente
    FIELD i-cod-cli-fim         LIKE emitente.cod-emitente
    field c-cod-estabel-ini     as char format "x(03)"
    field c-cod-estabel-fim     as char format "x(03)"
    field cod-estabel           as char
    FIELD ItCodigoIni           LIKE ITEM.it-codigo
    FIELD ItCodigoFim           LIKE ITEM.it-codigo
    FIELD uf-ini                AS CHAR
    FIELD uf-fim                AS CHAR
    FIELD ind-exec-aut          AS LOGICAL.

define temp-table tt-digita no-undo
    field cd-gr-com as CHAR
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
