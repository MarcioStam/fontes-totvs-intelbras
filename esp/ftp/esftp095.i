define temp-table tt-param no-undo
    field destino          as integer
    FIELD desc-destino     AS CHAR
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD dt-emissao-ini   AS DATE      LABEL "Data EmissÆo"    FORMAT "99/99/9999"
    FIELD dt-emissao-fim   AS DATE                              FORMAT "99/99/9999"
    FIELD estabel-ini      AS CHAR      LABEL "Estab"           FORMAT "X(05)"
    FIELD estabel-fim      AS CHAR                              FORMAT "X(05)"
    FIELD serie-ini        AS CHAR      LABEL "S‚rie"           FORMAT "X(05)"
    FIELD serie-fim        AS CHAR                              FORMAT "X(05)"
    FIELD nota-fiscal-ini  AS CHAR      LABEL "Nota Fiscal"     FORMAT "X(16)"
    FIELD nota-fiscal-fim  AS CHAR                              FORMAT "X(16)"
    FIELD c-saida-csv      AS CHAR      LABEL "Sa¡da CSV"       FORMAT "X(80)"
    FIELD it-codigo-ini    AS CHAR      LABEL "ITEM"            FORMAT "X(16)"
    FIELD it-codigo-fim    AS CHAR                              FORMAT "X(16)"
    .
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
