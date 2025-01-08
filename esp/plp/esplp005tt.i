define temp-table tt-param
    field destino          as integer
    FIELD c-arquivo-destino AS CHAR
    FIELD arquivo           AS CHAR
    field arq-destino       as char
    field arq-entrada1      as char
    field todos             as integer
    field usuario           as char
    field data-exec         as date
    field hora-exec         as INTEGER
    FIELD cod-estabel       AS CHAR
    FIELD cod-plano         AS INTEGER
    FIELD c-arquivo-csv     AS CHAR
    FIELD log-elimina-itens AS LOG.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
