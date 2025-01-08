/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    FIELD ini-campo        AS CHAR
    FIELD fim-campo        AS CHAR
    FIELD impl-ini         AS DATE
    FIELD impl-fin         AS DATE
    FIELD aprov-ini        AS DATE 
    FIELD aprov-fin        AS DATE
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.
