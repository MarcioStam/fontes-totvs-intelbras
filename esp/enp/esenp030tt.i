define temp-table tt-param no-undo
    field destino         AS integer
    field arquivo         AS char format "x(35)":U
    field usuario         AS char format "x(12)":U
    field data-exec       AS date
    field hora-exec       AS integer
    field modelo          AS char format "x(35)":U
    FIELD item-ini        AS CHAR
    FIELD item-fim        AS CHAR
    FIELD data-ini        AS DATE
    FIELD data-fim        AS DATE
    FIELD periodo-ini     AS CHAR
    FIELD periodo-fim     AS CHAR
    FIELD tg-semi         AS LOGICAL
    FIELD cod-estabel     AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo  LIKE ITEM.it-codigo 
    FIELD descricao  LIKE ITEM.desc-item
        INDEX id it-codigo.
