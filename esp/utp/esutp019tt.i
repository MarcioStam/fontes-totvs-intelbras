define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD equip-ini     AS CHARACTER
    FIELD equip-fim     AS CHARACTER
    FIELD periodo-ini   AS CHARACTER
    FIELD periodo-fim   AS CHARACTER
    FIELD fornec-ini    AS INTEGER
    FIELD fornec-fim    AS INTEGER.

define temp-table tt-digita no-undo
    field campo AS CHARACTER
    index id campo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
