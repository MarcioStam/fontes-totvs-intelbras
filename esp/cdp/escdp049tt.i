define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    
    field ini-it-codigo     AS char
    field fim-it-codigo     AS char
    FIELD fm-codigo-ini     AS CHARACTER
    FIELD fm-codigo-fim     AS CHARACTER
    FIELD faturavel         AS INTEGER
    FIELD lei-informatica   AS INTEGER
    FIELD familia-cod-ini   AS CHARACTER
    FIELD familia-cod-fim   AS CHARACTER
    FIELD classi-fiscal-ini AS CHARACTER
    FIELD classi-fiscal-fim AS CHARACTER
    FIELD narrativa         AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
