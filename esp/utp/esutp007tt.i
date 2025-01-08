define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD cod-estabel-ini  AS CHARACTER
    FIELD cod-estabel-fim  AS CHARACTER
    FIELD equipamento-ini  AS CHARACTER
    FIELD equipamento-fim  AS CHARACTER
    FIELD periodo-ini      AS CHARACTER
    FIELD periodo-fim      AS CHARACTER
    FIELD tipo-ini         AS INTEGER
    FIELD tipo-fim         AS INTEGER
    FIELD fornecedor-ini   AS INTEGER
    FIELD fornecedor-fim   AS INTEGER 
    FIELD excel            AS LOGICAL
    FIELD conta-ini        AS CHARACTER
    FIELD conta-fim        AS CHARACTER
    FIELD cc-ini           AS CHARACTER
    FIELD cc-fim           AS CHARACTER
    FIELD sintetico-cc     AS LOGICAL 
    FIELD i-exec           AS INTEGER.

define temp-table tt-digita no-undo
    field ordem as character
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
