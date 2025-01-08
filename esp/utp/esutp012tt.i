define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD periodo         AS CHARACTER
    FIELD diretorio       AS CHARACTER
    FIELD envia-email     AS LOGICAL
    FIELD cc-ini          AS CHARACTER
    FIELD cc-fim          AS CHARACTER
    FIELD responsavel     AS CHARACTER.

define temp-table tt-digita no-undo
    field campo AS CHARACTER
    index id campo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
