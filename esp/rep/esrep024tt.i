define temp-table tt-param no-undo
    field destino        as integer
    field arquivo        as char format "x(35)":U
    field usuario        as char format "x(12)":U
    field data-exec      as date
    field hora-exec      as integer
    FIELD cod-emitente   AS INTEGER
    FIELD nat-oper-saida AS CHAR
    FIELD nat-oper-ent   AS CHAR
    field cod-estabel    as CHAR
    FIELD dt-corte       AS DATE
    FIELD tipo           AS INT.

define temp-table tt-digita no-undo
    field nat-operacao like natur-oper.nat-operacao
    index id nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
