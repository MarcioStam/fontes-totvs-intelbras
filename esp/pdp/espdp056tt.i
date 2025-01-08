define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD dt-emissao-ini   AS DATE
    FIELD dt-emissao-fim   AS DATE
    FIELD dt-entrega-ini   AS DATE
    FIELD dt-entrega-fim   AS DATE
    FIELD nr-pedcli-ini    AS CHAR
    FIELD nr-pedcli-fim    AS CHAR
    FIELD atendente-ini    LIKE ped-venda.tp-pedido
    FIELD atendente-fim    LIKE ped-venda.tp-pedido
    FIELD prioridade-ini   LIKE ped-venda.cod-priori
    FIELD prioridade-fim   LIKE ped-venda.cod-priori
    FIELD it-codigo-ini    LIKE ped-item.it-codigo
    FIELD it-codigo-fim    LIKE ped-item.it-codigo
    FIELD l-parcial        AS LOGICAL
    FIELD l-suspensos      AS LOGICAL
    FIELD l-so-listar      AS LOGICAL
    FIELD pedidos          AS CHARACTER
    FIELD it-codigo        AS CHARACTER
    FIELD dt-entrega-dest  AS DATE
    FIELD considera        AS LOGICAL
    FIELD dt-entrega-futura LIKE item-dt-entrega.dt-entrega-futura
    FIELD i-altera-data    AS INT.  /*wilson gesplus*/

DEFINE TEMP-TABLE tt-digita no-undo
    FIELD tipo-trans        AS CHAR FORMAT "x(1)" 
    FIELD nr-pedcli         LIKE ped-venda.nr-pedcli 
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD nr-sequencia      LIKE ped-item.nr-sequencia 
    FIELD dt-entrega-futura LIKE item-dt-entrega.dt-entrega-futura
    FIELD qt-pedida         like ped-item.qt-pedida
    FIELD vl-preuni         like ped-item.vl-preuni
    FIELD per-des-item      LIKE ped-item.per-des-item
    FIELD nr-tabpre         AS CHAR
    FIELD observacao        LIKE ped-item.observacao.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.


DEFINE TEMP-TABLE tt-digita-2 LIKE tt-digita
    FIELD seq-imp       AS INT FORMAT 9 .

DEF BUFFER bf-tt-digita-2 FOR tt-digita-2.
