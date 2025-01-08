define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estabel-ini  LIKE estabelec.cod-estabel
    FIELD cod-estabel-fim  LIKE estabelec.cod-estabel
    FIELD cod-emitente-ini LIKE emitente.cod-emitente
    FIELD cod-emitente-fim LIKE emitente.cod-emitente
    FIELD tp-pedido-ini    LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim    LIKE ped-venda.tp-pedido
    FIELD dt-entrega-ini   LIKE ped-venda.dt-entrega
    FIELD dt-entrega-fim   LIKE ped-venda.dt-entrega
    FIELD it-codigo-ini    LIKE item.it-codigo
    FIELD it-codigo-fim    LIKE item.it-codigo
    FIELD cod-unid-negoc-ini        AS CHARACTER FORMAT "x(3)"
    FIELD cod-unid-negoc-fim        AS CHARACTER FORMAT "x(3)"
    FIELD grupo-canais-ini          AS INT
    FIELD grupo-canais-fim          AS INT
    FIELD i-dup-ini                 AS CHARACTER FORMAT "x(3)"
    FIELD i-dup-fim                 AS CHARACTER FORMAT "x(3)"
    FIELD l-lista-prioridade-44     AS LOGICAL
    FIELD l-lista-atendente-34      AS LOGICAL
    FIELD l-selecao-acesso-restrito AS LOGICAL
    FIELD l-cancelados              AS LOGICAL
    FIELD l-itens-cancelados        AS LOGICAL
    FIELD tg-importa                AS LOGICAL
    FIELD fi-arquivo-imp            AS CHAR 
    FIELD rs-class                  AS INTEGER
    FIELD i-rep-ini                 AS INTEGER
    FIELD i-rep-fim                 AS INTEGER.


define temp-table tt-digita no-undo
    field cod-depos           AS CHAR.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.
