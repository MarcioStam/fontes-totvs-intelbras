DEFINE temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as INTEGER
    field classifica       as INTEGER
    field ep-codigo        like mgcad.empresa.ep-codigo
    field desc-classifica  as char format "x(40)":U
    field da-emis-ini      like nota-fiscal.dt-emis-nota
    field da-emis-fim      like nota-fiscal.dt-emis-nota
    field cod-estabel      as char.


DEFINE temp-table tt-digita no-undo
    field data-emis-ini      like nota-fiscal.dt-emis-nota
    field data-emis-fim      like nota-fiscal.dt-emis-nota.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
