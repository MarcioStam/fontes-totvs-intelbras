DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD ini-data         AS DATE
    FIELD fim-data         AS DATE
    FIELD ini-conta        AS CHAR
    FIELD fim-conta        AS CHAR
    FIELD l-despesa        AS LOG
    FIELD ini-ccusto       AS CHAR
    FIELD fim-ccusto       AS CHAR
    FIELD ini-estab        AS CHAR
    FIELD fim-estab        AS CHAR
    FIELD l-ACR            AS LOG
    FIELD l-APB            AS LOG
    FIELD l-APL            AS LOG
    FIELD l-CMG            AS LOG.

define temp-table tt-digita no-undo
    field nat-operacao like natur-oper.nat-operacao
    index id nat-operacao.
  
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
