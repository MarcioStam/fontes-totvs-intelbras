define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD data-ini         as date
    FIELD data-fim         as date
    FIELD estab-ini        as char 
    FIELD estab-fim        as char 
    FIELD linha-prod       AS CHAR
    FIELD it-codigo-ini    as char format "x(16)"
    FIELD it-codigo-fim    as char format "x(16)"
    FIELD cc-codigo-ini    as char format "x(16)"
    field cc-codigo-fim    as char format "x(16)"
    field saida-csv        as logi
    field arq-csv          as char
    field cod-estabel      as char
    field tipo-oper        as integer.

define temp-table tt-digita no-undo
    field cod-depos        like deposito.cod-depos
    field nome             like deposito.nome
    index id cod-depos.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
