define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD tipo             AS LOGICAL
    FIELD alm              AS LOGICAL
    FIELD pro              AS LOGICAL
    FIELD obs              AS LOGICAL
    FIELD ast              AS LOGICAL
    FIELD dec-pin          AS LOGICAL 
    FIELD especifico       AS LOGICAL
    FIELD setup            AS LOGICAL
    FIELD excesso          AS LOGICAL
    FIELD agrupar          AS LOGICAL
    FIELD it-codigo        AS CHAR
    FIELD quantidade       AS DECIMAL
    FIELD titulo           AS CHAR
    field cod-estabel      as char
    FIELD lista-alter      AS LOGICAL
    FIELD fantasma         AS LOGICAL
    FIELD dependente       AS LOGICAL
    FIELD phase-in         AS LOGICAL
    field phase-out        as logical
    field acao             as integer.

define temp-table tt-digita no-undo
    field ti-it-codigo like item.it-codigo 
    FIELD desc-item LIKE ITEM.desc-item
    field ti-quantidade like estrutura.quant-usada format ">>>,>>9.99999"
    FIELD titulo as char format "x(40)" initial "Lista de Faltas - "
    index id ti-it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

