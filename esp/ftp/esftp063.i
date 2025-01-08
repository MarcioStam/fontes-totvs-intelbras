define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    FIELD fi-estab-ini           like nota-fiscal.cod-estabel
    FIELD fi-estab-fim           like nota-fiscal.cod-estabel
    FIELD fi-cod-repres-ini      like nota-fiscal.cod-rep
    FIELD fi-cod-repres-fim      like nota-fiscal.cod-rep
    FIELD fi-periodo             AS CHARACTER
    FIELD rs-previa-oficial      as integer
    field envia-e-mail           as logical.
    
.
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
