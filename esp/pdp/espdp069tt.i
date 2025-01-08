define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel-ini  LIKE estabelec.cod-estabel
    FIELD cod-estabel-fim  LIKE estabelec.cod-estabel
    FIELD tp-pedido-ini    LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim    LIKE ped-venda.tp-pedido
    FIELD dt-cancelamento  LIKE ped-venda.dt-entrega
    FIELD lista            AS INTEGER
    FIELD dt-entrega-ini   AS DATE FORMAT "99/99/9999"
    FIELD dt-entrega-fim   AS DATE FORMAT "99/99/9999"
    FIELD cod-emitente     LIKE emitente.cod-emitente
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD motivo           AS CHAR.
    
define temp-table tt-digita no-undo
    field nr-pedido        LIKE ped-venda.nr-pedcli
    FIELD it-codigo        LIKE ped-item.it-codigo
    index id nr-pedido.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
