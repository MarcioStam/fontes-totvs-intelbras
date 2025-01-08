define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD nr-pedido-Ini    LIKE ped-venda.nr-pedido
    FIELD nr-pedido-Fim    LIKE ped-venda.nr-pedido   
    FIELD dt-implant-Ini   LIKE ped-venda.dt-implant
    FIELD dt-implant-Fim   LIKE ped-venda.dt-implant
    
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field tipo-relat       as int
/*
    FIELD nr-pedcli-ini    LIKE ped-venda.nr-pedcli   
    FIELD nr-pedcli-fim    LIKE ped-venda.nr-pedcli   
    FIELD nome-abrev-ini   LIKE ped-venda.nome-abrev  
    FIELD nome-abrev-fim   LIKE ped-venda.nome-abrev
*/
    FIELD tp-pedido-ini    LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim    LIKE ped-venda.tp-pedido
    field cod-estabel      as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
