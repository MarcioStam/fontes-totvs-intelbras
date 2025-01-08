define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel-ini  LIKE estabelec.cod-estabel
    FIELD cod-estabel-fim  LIKE estabelec.cod-estabel
    FIELD dt-emissao-ini   LIKE ped-venda.dt-emissao
    FIELD dt-emissao-fim   LIKE ped-venda.dt-emissao
    FIELD cod-depos-ini    LIKE saldo-estoq.cod-depos
    FIELD cod-depos-fim    LIKE saldo-estoq.cod-depos
    FIELD localiza-ini     LIKE saldo-estoq.cod-localiz
    FIELD localiza-fim     LIKE saldo-estoq.cod-localiz.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
