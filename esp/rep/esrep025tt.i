define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD gera-html        AS LOGICAL
    FIELD dt-trans-ini     AS DATE
    FIELD dt-trans-fim     AS DATE
    FIELD cod-emitente-ini AS INTE
    FIELD cod-emitente-fim AS INTE
    FIELD nat-operacao-ini AS CHAR
    FIELD nat-operacao-fim AS CHAR
    FIELD nro-docto-ini    AS CHAR
    FIELD nro-docto-fim    AS CHAR
    FIELD cod-estabel-ini  AS CHAR
    FIELD serie-docto-ini  AS char
    FIELD serie-docto-fim  AS CHAR
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR.

define temp-table tt-digita no-undo
    field cod-depos like deposito.cod-depos
    index id cod-depos.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
