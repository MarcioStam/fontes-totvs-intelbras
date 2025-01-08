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
    field natureza         as int
    field imprime-conta    as logical
    FIELD imprime-devol    AS LOGICAL
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    FIELD conta-ini        AS CHAR 
    FIELD conta-fim        AS CHAR 
    FIELD subconta-ini     AS CHAR 
    FIELD subconta-fim     AS CHAR 
    FIELD imprime-financeiro AS LOGICAL
    field imp-rateio       as logical
    FIELD log-filtra-impto AS LOG
    FIELD ini-usuario      AS CHAR
    FIELD fim-usuario      AS CHAR
    FIELD classific-ini    AS CHAR
    FIELD classific-fim    AS CHAR
    FIELD cod-msg-devolucao-ini AS INT
    FIELD cod-msg-devolucao-fim AS INT
    FIELD cod-depos-ini     AS CHAR
    FIELD cod-depos-fim     AS CHAR
    FIELD log-nf-atualiz   AS LOG   
    FIELD log-bc-aliq      AS LOG
    FIELD l-listar-THC-II  AS LOG
    FIELD l-listar-Chave   AS LOG.

define temp-table tt-digita no-undo
    FIELD tipo              AS INT INIT 0
    field nat-operacao      AS CHAR
    FIELD cod-pais          AS CHAR
    FIELD cod-unid-federac  AS CHAR
    FIELD cod-imposto       AS CHAR
    FIELD cod-classif-impto AS CHAR
    FIELD cod-emitente      AS INT
    index id nat-operacao
    INDEX id_2 tipo cod-emitente.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
