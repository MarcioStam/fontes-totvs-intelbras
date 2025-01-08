DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD modelo           AS CHAR FORMAT "x(35)":U
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE
    FIELD tipo-arquivo     AS INT
    FIELD semanal          AS LOG 
    FIELD l-habilitaRtf    AS LOG
    FIELD email            AS CHAR
    FIELD habilita-email   AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo  LIKE ITEM.it-codigo 
    FIELD descricao  LIKE ITEM.desc-item
        INDEX id it-codigo.






