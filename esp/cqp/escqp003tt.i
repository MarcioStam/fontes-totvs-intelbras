define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-emitente     AS INT
    FIELD serie-docto      AS CHAR
    FIELD nro-docto        AS CHAR
    FIELD nat-operacao     AS CHAR
    FIELD urgencia         AS LOGICAL
    FIELD imprime-param    AS LOGICAL
    FIELD volume           AS DECIMAL
    FIELD localizacao1     AS CHAR FORMAT "x(50)"
    FIELD localizacao2     AS CHAR FORMAT "x(50)"
    FIELD localizacao3     AS CHAR FORMAT "x(50)"
    FIELD localizacao4     AS CHAR FORMAT "x(50)"
    FIELD localizacao5     AS CHAR FORMAT "x(50)"
    field cod-estabel      as CHAR.

DEF TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo AS CHAR FORMAT "x(16)"
    FIELD selecionado AS LOGICAL FORMAT "X/ " INIT YES.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
       FIELD raw-digita AS RAW.
