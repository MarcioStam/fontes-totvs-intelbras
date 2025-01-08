DEFINE TEMP-TABLE tt-param NO-UNDO
    field destino         AS INTEGER
    field arquivo         AS CHAR format "x(35)":U
    field usuario         AS CHAR format "x(12)":U
    field data-exec       AS DATE
    field hora-exec       AS INTEGER
    field modelo          AS CHAR format "x(35)":U
    FIELD estabel         AS CHAR  
    FIELD deposito-ori    AS CHAR
    FIELD localiza-ini    AS CHAR
    FIELD localiza-fim    AS CHAR
    FIELD item-ini        AS CHAR
    FIELD item-fim        AS CHAR
    FIELD deposito-des    AS CHAR
    FIELD localiza-des    AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    field ordem            AS INTEGER   FORMAT ">>>>9":U
    field exemplo          AS CHARACTER FORMAT "x(30)":U
    index id ordem.

