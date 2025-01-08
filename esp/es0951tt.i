define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD execucao         AS INTEGER
    field mensal           as logical
    field valida-cc        as logical
    field concil-transit   as logical
    field envia-email      as logical
    field lista-email      as character format "x(70)":U
    field data-ini         as date format "99/99/9999"
    field data-fim         as date format "99/99/9999"
    FIELD i-concil-ini     AS INTEGER
    FIELD i-concil-fim     AS INTEGER
    FIELD cod_cenar_ctbl   AS CHAR FORMAT "x(8)"
    FIELD devol            AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
