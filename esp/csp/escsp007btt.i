define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    FIELD rs-opcao         AS INTEGER  /*1 - estrutura, 2 - faixa de grupo estoque */
    FIELD it-codigo-ini    AS CHARACTER
    FIELD it-codigo-fim    AS CHARACTER
    FIELD fm-codigo-ini    AS CHARACTER
    FIELD fm-codigo-fim    AS CHARACTER
    FIELD listar-sem-venda AS LOGICAL
    FIELD dt-base          AS DATE
    FIELD listar-sintetico AS LOGICAL
    FIELD listar-faturaveis AS LOGICAL.

define temp-table tt-digita no-undo
    field it-codigo        LIKE ITEM.it-codigo
    field desc-item        LIKE ITEM.desc-item
    index id it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
