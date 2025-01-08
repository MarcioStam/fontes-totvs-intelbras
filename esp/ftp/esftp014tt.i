define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field dt-emis-ini      like nota-fiscal.dt-emis-nota
    field dt-emis-fim      like nota-fiscal.dt-emis-nota
    FIELD cod-estabel-ini  LIKE nota-fiscal.cod-estabel
    field cod-estabel-fin  LIKE nota-fiscal.cod-estabel
    field excel            as char
.

define temp-table tt-digita no-undo
    field nat-operacao    like nota-fiscal.nat-operacao label "Natureza" HELP "F5 - Zoom"
    field estado-ini      like nota-fiscal.estado label "UF Ini"
    field estado-fim      like nota-fiscal.estado label "UF Fim" 
    index codigo is primary nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
