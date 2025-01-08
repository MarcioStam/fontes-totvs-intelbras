DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD modelo           AS CHAR FORMAT "x(35)":U
    FIELD grupo-ini        AS CHAR
    FIELD grupo-fim        AS CHAR
    FIELD email            AS LOG
    FIELD l-habilitaRtf    AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo  LIKE ITEM.it-codigo 
    FIELD descricao  LIKE ITEM.desc-item
        INDEX id it-codigo.






