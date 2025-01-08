define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD dt-implant-ini   LIKE ped-venda.dt-entrega
    FIELD dt-implant-fim   LIKE ped-venda.dt-entrega
    FIELD repres-ini       LIKE repres.nome-abrev
    FIELD repres-fim       LIKE repres.nome-abrev
    FIELD aprovador-ini    AS CHAR FORMAT "x(08)"
    FIELD aprovador-fim    AS CHAR FORMAT "x(08)"
    FIELD rs-status        AS INTEGER.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
