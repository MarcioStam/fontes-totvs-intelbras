
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHARACTER FORMAT "x(35)":U
    FIELD usuario            AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD i-tipo-concilia    AS INT
    FIELD dt-pagto           AS DATE
    FIELD de-val-max-ava     AS DEC
    FIELD de-val-min-parcial AS DEC
    FIELD c-conta-ava        AS CHAR
    FIELD i-tipo-email       AS INT
    FIELD c-email-imposto    AS CHAR
    FIELD c-email-importacao AS CHAR
    FIELD cod_empres_usuar   LIKE v_cod_empres_usuar
    FIELD cod_estab_usuar    LIKE v_cod_estab_usuar.
 
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

