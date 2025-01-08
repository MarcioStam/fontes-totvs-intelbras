define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD c-ramal-ini     AS CHARACTER
    FIELD c-ramal-fim     AS CHARACTER
    FIELD i-tipo          AS INTEGER
    FIELD i-relat         AS INTEGER
    FIELD c-telefone      AS CHARACTER
    FIELD data-ini        AS DATE 
    FIELD data-fim        AS DATE.

define temp-table tt-digita no-undo
    field campo AS CHARACTER
    index id campo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
