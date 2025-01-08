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
    FIELD i-cod-rep-ini         LIKE repres.cod-rep
    FIELD i-cod-rep-fim         LIKE repres.cod-rep 
    FIELD i-cod-cli-ini         LIKE emitente.cod-emitente
    FIELD i-cod-cli-fim         LIKE emitente.cod-emitente
    FIELD i-gr-cli-ini          LIKE emitente.cod-gr-cli
    FIELD i-gr-cli-fim          LIKE emitente.cod-gr-cli
    FIELD c-cgc-ini             LIKE emitente.cgc
    FIELD c-cgc-fim             LIKE emitente.cgc
    FIELD i-familia-com-ini     AS   CHAR
    FIELD i-familia-com-fim     AS   CHAR
    FIELD i-Dup-ini             AS   CHAR 
    FIELD i-Dup-fim             AS   CHAR
    field c-cod-estabel-ini     as char format "x(03)"
    field c-cod-estabel-fim     as char format "x(03)"
    FIELD c-cod-atendente-ini   AS CHAR
    FIELD c-cod-atendente-fim   AS CHAR
    field cod-estabel           as char
    FIELD ItCodigoIni           LIKE ITEM.it-codigo
    FIELD ItCodigoFim           LIKE ITEM.it-codigo
    FIELD c-unid-neg-ini        AS CHARACTER
    FIELD c-unid-neg-fim        AS CHARACTER
    FIELD uf-ini                AS CHAR
    FIELD uf-fim                AS CHAR.

define temp-table tt-digita no-undo
    field cd-gr-com as CHAR
    field descricao as character format "x(60)"
    index id cd-gr-com.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
