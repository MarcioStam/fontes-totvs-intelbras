define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD it-codigo-fim     AS CHARACTER
    FIELD it-codigo-ini     AS CHARACTER
    FIELD cod-comprado-ini  AS CHARACTER 
    FIELD cod-comprado-fim  AS CHARACTER   
    FIELD i-ge-ini          AS INTEGER
    FIELD i-ge-fim          AS INTEGER
    FIELD c-arq-htm         AS CHARACTER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
