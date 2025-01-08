define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field arquivo-csv      as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD estabel          AS CHARACTER FORMAT "x(3)":U
    FIELD item-ini         AS CHARACTER FORMAT "x(16)":U
    FIELD item-fim         AS CHARACTER FORMAT "x(16)":U
    FIELD comprador-ini    AS CHARACTER FORMAT "x(12)":U
    FIELD comprador-fim    AS CHARACTER FORMAT "x(12)":U
    FIELD periodo          AS CHARACTER FORMAT "x(07)":U
    FIELD variacao         AS INTEGER
    FIELD email            AS CHARACTER FORMAT "x(35)":U.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.
