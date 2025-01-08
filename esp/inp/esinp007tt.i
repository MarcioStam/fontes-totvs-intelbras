/****************************  Definitions  ****************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field c-ncm-ini        AS CHAR FORMAT "x(8)"
    field c-ncm-fim        AS CHAR FORMAT "x(8)"
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field cod-estabel as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

