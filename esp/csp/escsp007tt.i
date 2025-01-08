define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD nr-linha-ini     AS INT
    FIELD nr-linha-fim     AS INT
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD data-ini         AS date
    FIELD data-fim         AS date
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    FIELD l-estrutura      AS LOGICAL
    FIELD it-codigo        AS CHARACTER
    FIELD data-corte       AS DATE
    FIELD l-ultima-entrada AS LOGICAL
    FIELD l-calc-custo     AS LOGICAL
    FIELD l-listar-THC     AS LOGICAL
    FIELD prog-chamador    AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
