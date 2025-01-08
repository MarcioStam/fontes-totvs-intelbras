define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD pedido           AS CHAR FORMAT "X(10)"
    field nome-abrev       as char
    FIELD packing          AS LOG
    FIELD proforma         AS LOG
    FIELD qtde             AS INT
    field local-embarque   as char
    field embarque-via     as char
    field incoterm         as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
