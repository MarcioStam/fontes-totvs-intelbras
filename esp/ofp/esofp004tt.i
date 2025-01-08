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
    field c-cod-estabel-ini     as char format "x(03)"
    field c-cod-estabel-fim     as char format "x(03)".
    

define temp-table tt-digita no-undo
    field nat-operacao   as CHARACTER format "x(6)"
    field conta-origem   as character format "x(8)"
    field conta-destino  as character format "x(8)"
    field ccusto-origem  as character format "x(5)" 
    field ccusto-destino as character format "x(5)" 
    index nat nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
