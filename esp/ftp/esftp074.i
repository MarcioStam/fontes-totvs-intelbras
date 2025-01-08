
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    field cod-estab-ini     as char
    field cod-estabel       AS CHAR
    field cod-emitente      AS INTEGER
    field dt-emis-nota-ini  AS DATE
    field dt-emis-nota-fim  AS DATE
    FIELD reenvia           AS LOGICAL.   

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

