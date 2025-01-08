define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD nr-ficha         AS INT
    FIELD data-fax         AS DATE
    FIELD hora-fax         AS CHAR
    FIELD enderecos        AS CHAR
    FIELD telefax          AS CHAR
    FIELD imprime-param    AS LOGICAL.

DEF TEMP-TABLE tt-digita NO-UNDO
    FIELD campo AS CHAR.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
