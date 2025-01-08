define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)":U
    field usuario             as char format "x(12)":U
    field data-exec           as date
    field hora-exec           as integer

    FIELD ge-codigo-ini       AS INTEGER
    FIELD ge-codigo-fim       AS INTEGER
    FIELD it-codigo-ini       AS CHARACTER
    FIELD it-codigo-fim       AS CHARACTER
    FIELD class-fiscal-ini    AS CHARACTER
    FIELD class-fiscal-fim    AS CHARACTER
    FIELD fm-codigo-ini       AS CHARACTER
    FIELD fm-codigo-fim       AS CHARACTER
    FIELD fm-cod-com-ini      AS CHARACTER
    FIELD fm-cod-com-fim      AS CHARACTER
    FIELD l-ativo             AS LOGICAL
    field l-obso-ord-aut      AS LOGICAL
    field l-obso-todas-ord    AS LOGICAL
    FIELD l-total-obsoleto    AS LOGICAL
    FIELD l-somente-consumo   AS LOGICAL
    FIELD cod-estabel         AS CHARACTER
    FIELD cd-plano            AS INTEGER
    FIELD periodo-ini         AS DATE
    FIELD periodo-fim         AS DATE
    FIELD l-imprime-narrativa AS LOGICAL
    FIELD l-peso-medida       AS LOGICAL
    FIELD l-panumber-fabric   AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
       FIELD raw-digita AS RAW.
