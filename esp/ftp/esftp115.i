
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHARACTER FORMAT "x(35)":U
    FIELD usuario            AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD c-estab            AS CHAR.    

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

