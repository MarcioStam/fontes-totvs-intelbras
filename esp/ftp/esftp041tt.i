define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD ini-data         AS DATE
    FIELD fim-data         AS DATE
    FIELD ini-cod-emitente AS INTEGER
    FIELD fim-cod-emitente AS INTEGER
    FIELD ini-nat-operacao AS CHAR
    FIELD fim-nat-operacao AS CHAR
    FIELD ini-uf           AS CHAR
    FIELD fim-uf           AS CHAR
    FIELD tipo             AS INT
    field imprime-conta    as logical
    field excel            as logical    
    field ini-cod-estabel  as char
    field fim-cod-estabel  as char    
    field ini-it-codigo    AS char
    field fim-it-codigo    AS char
    FIELD fm-codigo-ini    AS CHARACTER
    FIELD fm-codigo-fim    AS CHARACTER
    FIELD devolucao        AS LOGICAL
    FIELD ini-usuario      AS CHAR
    FIELD fim-usuario      AS CHAR   
    FIELD imprime-cancel   AS LOGICAL
    FIELD classific-ini    AS CHAR
    FIELD classific-fim    AS CHAR
    FIELD segmento         AS LOG
    FIELD tg-lista-chave   AS LOG
    FIELD tg-lei-informatica AS LOG.
          

define temp-table tt-digita no-undo
    field nat-operacao like natur-oper.nat-operacao
    index id nat-operacao.
  
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
