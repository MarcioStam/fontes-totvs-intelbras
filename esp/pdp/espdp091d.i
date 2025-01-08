define temp-table   tt-param no-undo 
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    FIELD fi-Estabel-ini     like ped-venda.cod-estabel
    FIELD fi-Estabel-fim     like ped-venda.cod-estabel
    FIELD fi-Atendente-ini   like ped-venda.tp-pedido
    FIELD fi-Atendente-fim   like ped-venda.tp-pedido
    FIELD fi-Atendente-mestre-ini   like ped-venda.tp-pedido
    FIELD fi-Atendente-mestre-fim   like ped-venda.tp-pedido
    FIELD fi-Cod-repres-ini  like repres.cod-rep
    FIELD fi-Cod-repres-fim  like repres.cod-rep
    FIELD fi-dt-entrega-ini  like ped-venda.dt-entrega
    FIELD fi-dt-entrega-fim  like ped-venda.dt-entrega
    FIELD fi-nr-pedcli-ini   like ped-venda.nr-pedcli
    FIELD fi-nr-pedcli-fim   like ped-venda.nr-pedcli
    FIELD fi-dt-implant-ini  like ped-venda.dt-implant
    FIELD fi-dt-implant-fim  like ped-venda.dt-implant
    FIELD fi-cond-pagto-ini  like ped-venda.cod-cond-pag 
    FIELD fi-cond-pagto-fim  like ped-venda.cod-cond-pag
    FIELD fi-prioridade-ini  as integer
    FIELD fi-prioridade-fim  as integer
    FIELD fi-cod-grupo-ini   as integer
    FIELD fi-cod-grupo-fim   as INTEGER
    FIELD cod-unid-neg       AS CHARACTER
    FIELD Localizacao        AS CHARACTER
    FIELD libera-item-parcial AS LOGICAL
    FIELD fatura-total        AS LOGICAL
    FIELD l-alocLibFat        AS LOGICAL
    FIELD l-alocFat           AS LOGICAL
    .
DEFINE TEMP-TABLE tt-digita NO-UNDO                                  
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD cod-depos    LIKE deposito.cod-depos.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
