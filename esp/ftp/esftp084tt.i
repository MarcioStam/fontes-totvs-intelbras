
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    field cod-estab-ini     as char
    field cod-estab-fim     as char
    FIELD i-ano-med         AS INTEGER FORMAT "9999":U
    FIELD i-mes-med         AS INTEGER FORMAT "99":U
    FIELD da-data-ini       as date
    FIELD da-data-fim       as date
    FIELD da-data-medio     AS DATE
    FIELD it-codigo-ini     AS CHARACTER
    FIELD it-codigo-fim     AS CHARACTER
    FIELD cod-rep-ini       AS INTEGER
    FIELD cod-rep-fim       AS INTEGER
    FIELD cod-emitente-ini  AS INTEGER
    FIELD cod-emitente-fim  AS INTEGER
    FIELD cod-gr-cli-ini    AS INTEGER
    FIELD cod-gr-cli-fim    AS INTEGER
    FIELD raiz-ini          AS CHAR
    FIELD raiz-fim          AS CHAR
    FIELD fm-cod-com-ini    AS CHARACTER
    FIELD fm-cod-com-fim    AS CHARACTER
    FIELD l-vl-presente     as dec format ">9.999999" 
    FIELD vl-icms-est       AS DEC
    FIELD l-imp-nota        AS LOG
    FIELD cod-gr-cob-ini    AS INT
    FIELD cod-gr-cob-fim    AS INT.    

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

