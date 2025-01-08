define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    FIELD dt-ini           AS DATE LABEL "Data"  FORMAT "99/99/9999"
    FIELD dt-fim           AS DATE LABEL "Data"  FORMAT "99/99/9999"
    FIELD cod-estabel-ini  AS CHAR LABEL "Estab" FORMAT "X(03)"
    FIELD cod-estabel-fim  AS CHAR LABEL "Estab" FORMAT "X(03)"
    FIELD nr-linha-ini     AS INT  LABEL "Linha" FORMAT ">>9"
    FIELD nr-linha-fim     AS INT  LABEL "Linha" FORMAT ">>9"
    FIELD it-codigo-ini    AS CHAR LABEL "Item"  FORMAT "X(16)"
    FIELD it-codigo-fim    AS CHAR LABEL "Item"  FORMAT "X(16)"
    FIELD nao-iniciada     AS LOG
    FIELD liberada         AS LOG
    FIELD reservada        AS LOG
    FIELD separada         AS LOG
    FIELD requisitada      AS LOG 
    FIELD iniciada         AS LOG.



define temp-table tt-digita no-undo
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-produ
    FIELD cod-estabel LIKE ord-prod.cod-estabel
    FIELD nr-linha    LIKE ord-prod.nr-linha
    FIELD tipo        AS INT
    FIELD dt-inicio   LIKE ord-prod.dt-inicio
    FIELD qt-ordem    LIKE ord-prod.qt-ordem
    FIELD it-codigo   LIKE ord-prod.it-codigo
    FIELD desc-item   LIKE ITEM.desc-item
    index id nr-ord-prod.
