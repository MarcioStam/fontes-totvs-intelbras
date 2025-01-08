DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER

    FIELD cod-estab-ini     AS CHARACTER
    FIELD cod-estab-fim     AS CHARACTER
    FIELD data-ini          AS DATE
    FIELD data-fim          AS DATE
    FIELD it-codigo-ini     AS CHAR
    FIELD it-codigo-fim     AS CHAR
    FIELD nat-operacao-ini  AS CHAR
    FIELD nat-operacao-fim  AS CHAR
    FIELD opcao             AS INT.


DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo           AS CHARACTER FORMAT "x(30)":U
          INDEX id ordem.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
