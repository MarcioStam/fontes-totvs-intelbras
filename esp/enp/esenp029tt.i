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
    FIELD fabricado       AS LOG
    FIELD comprado        AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
