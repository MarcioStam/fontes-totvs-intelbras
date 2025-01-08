define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as character
    field cod-emitente     as integer.

define temp-table tt-digita no-undo
    FIELD l-sel            AS LOGICAL LABEL ''
    FIELD nr-ord-produ     LIKE ord-prod.nr-ord-prod
    FIELD quantidade       LIKE ord-prod.qt-ordem
    FIELD it-codigo        LIKE ord-prod.it-codigo
    FIELD desc-item        LIKE ITEM.desc-item
    INDEX id nr-ord-produ
    INDEX chave it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
