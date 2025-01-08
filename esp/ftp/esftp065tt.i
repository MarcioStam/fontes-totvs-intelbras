define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel      AS CHAR
    FIELD serie            AS CHAR
    FIELD dt-ini-emiss     AS DATE
    FIELD dt-fim-emiss     AS DATE
    FIELD atendente-ini    AS CHAR
    FIELD atendente-fim    AS CHAR
    FIELD estado-ini       AS CHAR
    FIELD estado-fim       AS CHAR.

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
    FIELD estado           LIKE nota-fiscal.estado
    FIELD cod-dep          LIKE nota-fiscal.cod-dep
    FIELD dt-emissao         AS DATE
    FIELD cd-atendente       AS CHAR
    index id cod-estab serie nr-nota-fis.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
