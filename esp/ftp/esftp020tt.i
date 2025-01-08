define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD rs-opcao         AS INTEGER
    FIELD fi-cod-emitente  AS INTEGER
    FIELD da-data-ini      AS DATE
    FIELD da-data-fim      AS DATE
    FIELD nr-nota-fis-ini  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE nota-fiscal.nr-nota-fis
    FIELD serie-ini        LIKE nota-fiscal.serie
    FIELD serie-fim        LIKE nota-fiscal.serie
    FIELD i-idioma         as INT
    field cod-estabel      as char
    FIELD gera-excel       AS LOG
    FIELD arquivo-excel    AS CHAR
    FIELD da-periodo-ini   AS DATE
    FIELD da-periodo-fim   AS DATE
    FIELD cod-estab-per    AS CHAR
    FIELD serie-per        AS CHAR
    FIELD busca-solar      AS LOG
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
