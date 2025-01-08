DEFINE TEMP-TABLE tt-param NO-UNDO
    field destino         AS INTEGER
    field arquivo         AS CHAR format "x(35)":U
    field usuario         AS CHAR format "x(12)":U
    field data-exec       AS DATE
    field hora-exec       AS INTEGER
    field modelo          AS CHAR format "x(35)":U
    FIELD estabel-ini     AS CHAR
    FIELD estabel-fim     AS CHAR
    FIELD deposito-ini    AS CHAR
    FIELD deposito-fim    AS CHAR  
    FIELD localiza-ini    AS CHAR
    FIELD localiza-fim    AS CHAR
    FIELD item-ini        AS CHAR
    FIELD item-fim        AS CHAR
    FIELD sem-filtrar-qtd AS LOG
    FIELD coluna-qtd-data AS LOG
    FIELD data-saldo      AS DATE.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    field ordem            AS INTEGER   FORMAT ">>>>9":U
    field exemplo          AS CHARACTER FORMAT "x(30)":U
    index id ordem.

