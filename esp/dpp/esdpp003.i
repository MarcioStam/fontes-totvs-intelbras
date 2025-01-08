DEFINE TEMP-TABLE tt-param NO-UNDO
    field destino          AS INTEGER
    field arquivo          AS CHAR format "x(35)":U
    field usuario          AS CHAR format "x(12)":U
    field data-exec        AS DATE
    field hora-exec        AS INTEGER
    FIELD c-it-codigo      LIKE ITEM.it-codigo
    FIELD i-versao         AS INT  FORMAT ">>>>>>9"
    FIELD l-linha          AS LOG
    FIELD dt-corte         AS DATE FORMAT "99/99/9999"
    FIELD i-estrut         AS INT
    FIELD i-completo       AS INT
    FIELD l-gera           AS LOG
    FIELD l-excel          AS LOG
    FIELD l-lista-vencidos AS LOG
    FIELD l-lista-comp     AS LOG 
    FIELD tipo             AS INT
    FIELD quantidade       AS DEC
    FIELD tg-fantasma      AS LOG
    FIELD fi-cod-fabric    AS INT.
    


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

