define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-depos        AS CHAR
    FIELD data-ini         as date
    FIELD data-fim         as date
    FIELD considera        AS LOG
    field cod-estabel      as char.
        

define temp-table tt-digita no-undo
    field it-codigo        like ITEM.it-codigo
    field descricao        AS CHAR FORMAT "x(80)"
    index id it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
