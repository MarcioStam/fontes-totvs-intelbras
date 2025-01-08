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
    FIELD fi-periodo-ini         AS CHARACTER
    FIELD fi-periodo-fim         AS CHARACTER
    FIELD fi-cod-emitente-ini    AS INTEGER
    FIELD fi-cod-emitente-fim    AS INTEGER
    FIELD fi-perc-ir             AS DECIMAL
    FIELD rs-previa-oficial      as integer
    field envia-e-mail           as logical
    FIELD agendamento            AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
