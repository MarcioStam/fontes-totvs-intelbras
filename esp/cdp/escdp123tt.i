define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD c-ncm-ini        AS CHAR
    FIELD c-ncm-fim        AS CHAR
    FIELD rs-tipo          AS INT.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.
