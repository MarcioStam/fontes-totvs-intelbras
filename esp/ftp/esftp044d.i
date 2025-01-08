define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    FIELD c-ano                  as char.
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
