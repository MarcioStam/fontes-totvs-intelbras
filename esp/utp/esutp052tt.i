define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD cod-estabel-ini  AS CHARACTER
    FIELD cod-estabel-fim  AS CHARACTER
    FIELD periodo-ini      AS CHARACTER
    FIELD periodo-fim      AS CHARACTER
    FIELD contrato-ini     AS CHARACTER
    FIELD contrato-fim     AS CHARACTER
    FIELD fatura-ini       AS CHARACTER
    FIELD fatura-fim       AS CHARACTER
    FIELD cod-cli-ini      AS INTEGER
    FIELD cod-cli-fim      AS INTEGER
    FIELD cartao-ini       AS CHARACTER
    FIELD cartao-fim       AS CHARACTER
    FIELD dt-postagem-ini  AS DATE
    FIELD dt-postagem-fim  AS DATE
    FIELD servico-ini      AS CHARACTER
    FIELD servico-fim      AS CHARACTER
    FIELD nr-docto-ini     AS CHARACTER
    FIELD nr-docto-fim     AS CHARACTER
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
