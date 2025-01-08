DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD especie-ini       AS CHAR FORMAT "x(5)":U
    FIELD especie-fim       AS CHAR FORMAT "x(5)":U
    field cod-estabel-ini       as CHAR
    field cod-estabel-fim       as char.


DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo           AS CHARACTER FORMAT "x(30)":U
          INDEX id ordem.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
