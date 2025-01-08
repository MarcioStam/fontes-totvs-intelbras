define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field ep-codigo        like mgcad.empresa.ep-codigo
    field desc-classifica  as char format "x(40)":U
    field cod-emit-ini     like emitente.cod-emitente
    field cod-emit-fim     like emitente.cod-emitente
    field da-emis-ini      like nota-fiscal.dt-emis-nota
    field da-emis-fim      like nota-fiscal.dt-emis-nota
    field nat-oper-ini     like natur-oper.nat-operacao
    field nat-oper-fim     like natur-oper.nat-operacao
    field ct-cod-ini       like movto-estoq.ct-codigo
    field ct-cod-fim       like movto-estoq.ct-codigo
    field sc-cod-ini       like movto-estoq.sc-codigo
    field sc-cod-fim       like movto-estoq.sc-codigo
    field cod-estabel-ini  like movto-estoq.cod-estabel    
    field cod-estabel-fim  like movto-estoq.cod-estabel
.

define temp-table tt-digita no-undo
    field nat-operacao    like nota-fiscal.nat-operacao label "Natureza" HELP "F5 - Zoom"
    field estado-ini      like nota-fiscal.estado label "UF Ini"
    field estado-fim      like nota-fiscal.estado label "UF Fim" 
    index codigo is primary nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
