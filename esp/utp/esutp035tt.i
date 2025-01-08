define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    
    FIELD processo-ini     AS CHARACTER
    FIELD processo-fim     AS CHARACTER
    FIELD dt-receb-ini     AS DATE
    FIELD dt-receb-fim     AS DATE
    FIELD dt-processo-ini  AS DATE
    FIELD dt-processo-fim  AS DATE
    FIELD cod-acao-ini     AS INTEGER
    FIELD cod-acao-fim     AS INTEGER
    FIELD dt-prevista-ini  AS DATE
    FIELD dt-prevista-fim  AS DATE
    FIELD cod-despesa-ini  AS INTEGER
    FIELD cod-despesa-fim  AS INTEGER
    FIELD i-tipo           AS INTEGER
    FIELD l-despesas       AS LOGICAL
    FIELD c-arq-excel      AS CHARACTER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
