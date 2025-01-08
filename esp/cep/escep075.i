define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    FIELD cod-estabel      AS CHAR
    FIELD cod-estab-orig   AS CHAR
    FIELD cod-emitente     AS INTEGER
    FIELD lemail           AS LOGICAL
    FIELD d-estoq-min      AS DECIMAL.
    
define temp-table tt-digita no-undo
    field cod-depos            as CHAR  format "X(03)":U
    FIELD descricao            AS CHAR  FORMAT "X(30)":U
    index id cod-depos.


def temp-table tt-raw-digita
   field raw-digita      as raw.
