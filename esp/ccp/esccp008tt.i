define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD fi-ini-cod-unid-negoc LIKE item-uni-estab.cod-unid-negoc
    FIELD fi-fim-cod-unid-negoc LIKE item-uni-estab.cod-unid-negoc
    FIELD cod-estabel-ini   AS CHARACTER
    FIELD cod-estabel-fim   AS CHARACTER
    FIELD cod-emitente-ini  AS INTEGER
    FIELD cod-emitente-fim  AS INTEGER
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD it-codigo-fim     AS CHARACTER
    FIELD it-codigo-ini     AS CHARACTER
    FIELD cod-comprado-ini  AS CHARACTER 
    FIELD cod-comprado-fim  AS CHARACTER   
    FIELD c-arq-htm         AS CHARACTER
    FIELD c-email           AS CHARACTER
    FIELD c-email-2         AS CHARACTER
    FIELD i-distribuicao    AS INTEGER
    FIELD i-classif         AS INTEGER
    FIELD l-dependente      AS LOGICAL
    FIELD l-independente    AS LOGICAL
    FIELD l-importados      AS LOGICAL
    FIELD l-nacionais       AS LOGICAL
    FIELD l-adicionais      AS LOGICAL
    FIELD l-oem             AS LOGICAL
    FIELD l-narrativa       AS LOGICAL
    FIELD l-narrativa-ordem AS LOGICAL
    FIELD l-lista-contatos  AS LOGICAL
    FIELD l-confirmada      AS LOGICAL
    FIELD l-recebida        AS LOGICAL
    FIELD l-eliminada       AS LOGICAL.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
