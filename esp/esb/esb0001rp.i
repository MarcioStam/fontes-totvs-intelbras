DEFINE TEMP-TABLE tt-param NO-UNDO                            
    FIELD destino                     AS INTEGER              
    FIELD arquivo                     AS CHAR FORMAT "x(35)"
    FIELD usuario                     AS CHAR FORMAT "x(12)"
    FIELD data-exec                   AS DATE
    FIELD hora-exec                   AS INTEGER
    FIELD classifica                  AS INTEGER
    FIELD desc-classifica             AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf                  AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf               AS LOG
    FIELD ind-execucao                AS INT
    FIELD dt-emiss-nota-ini           AS DATE
    FIELD dt-emiss-nota-fim           AS DATE
    FIELD c-cod-estabel-ini           AS CHAR
    FIELD c-cod-estabel-fim           AS CHAR
    FIELD c-serie-ini                 AS CHAR
    FIELD c-serie-fim                 AS CHAR
    FIELD c-nr-nota-fis-ini           AS CHAR
    FIELD c-nr-nota-fis-fim           AS CHAR
    FIELD c-cod-emitente-ini          AS INT
    FIELD c-cod-emitente-fim          AS INT
    FIELD log-nota-fiscal             AS LOG.
