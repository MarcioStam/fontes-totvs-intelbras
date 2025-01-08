define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD nr-embarque      LIKE embarque.nr-embarque
    FIELD dt-ini-emiss     AS DATE
    FIELD dt-fim-emiss     AS DATE.

define temp-table tt-digita no-undo
    FIELD selecionado      AS LOGICAL LABEL 'Selecionado'
    FIELD cod-estab        LIKE nota-fiscal.cod-estabel
    FIELD serie            LIKE nota-fiscal.serie
    FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli      LIKE nota-fiscal.nome-ab-cli
    FIELD nome-transp      LIKE nota-fiscal.nome-transp
    FIELD vl-total-nota    LIKE nota-fiscal.vl-tot-nota
    FIELD nr-volume        LIKE nota-fiscal.nr-volume  
    FIELD nr-pedcli        LIKE nota-fiscal.nr-pedcli
    FIELD dt-emissao         AS DATE
    FIELD cd-atendente       AS CHAR
    FIELD cod-depos          AS CHAR
    FIELD estado             AS CHAR
    index id cod-estab serie nr-nota-fis.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
