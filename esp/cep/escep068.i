DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR
    FIELD arquivo-csv      AS CHAR
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER    
    FIELD estab-ini        LIKE item-uni-estab.cod-estabel
    FIELD estab-fim        LIKE item-uni-estab.cod-estabel 
    FIELD comprador-ini    LIKE item-uni-estab.cod-comprado
    FIELD comprador-fim    LIKE item-uni-estab.cod-comprado
    FIELD item-ini         LIKE item-uni-estab.it-codigo
    FIELD item-fim         LIKE item-uni-estab.it-codigo
    FIELD periodo-ini      AS CHAR                                  FORMAT "9999/99"
    FIELD periodo-fim      AS CHAR                                  FORMAT "9999/99"
    FIELD i-obsoleto       AS INTEGER
    FIELD l-consumo        AS LOGICAL
    FIELD l-saldo          AS LOGICAL
    FIELD l-dep-saldo-disp AS LOGICAL
    FIELD c-destino        AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.
