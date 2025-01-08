/* 
** 
** BOCX220C.I - temp-table tempor ria para cria‡Æo da tt-itens para gera‡Æo documento 
**
*/


{cdp/cdcfgmat.i}

define temp-table {1} no-undo
    field numero-ordem             like ordens-embarque.numero-ordem
    field parcela                  like ordens-embarque.parcela
    field sequencial               as   integer
    field it-codigo                like item.it-codigo
    field nr-proc-imp              like ordens-embarque.nr-proc-imp
    field quantidade               like ordens-embarque.quantidade
    field lote                     like item-doc-est.lote           
    field dt-vali-lote             like item-doc-est.dt-vali-lote
    field cod-refer                like item-doc-est.cod-refer
    field tipo-con-est             as   integer
    field encerra-pa               like item-doc-est.encerra-pa
    field situacao                 as   logical
    field quant-total              like ordens-embarque.quantidade
    field r-rowid                  as   rowid
    field class-fiscal             like classif-fisc.class-fiscal
    field nr-ato-concessorio       as   char format "x(20)"
    field preco-unit               like item-doc-est.preco-unit  extent 0 
    field preco-unit-mo            like item-doc-est.preco-unit  extent 0
    field preco-total              like item-doc-est.preco-total extent 0
    field preco-total-mo           like item-doc-est.preco-total extent 0
    field desconto                 like item-doc-est.desconto    extent 0
    field num-pedido               like pedido-compr.num-pedido
    field tp-despesa               like ordem-compra.tp-despesa
    field cod-depos                like ordem-compra.dep-almoxar
    field peso-bruto               as   decimal format ">>>,>>>,>>9.99999"
    field peso-liquido             as   decimal format ">>>,>>>,>>9.99999"
    field val-cub-tot              as   dec format ">>>>>,>>>,>>9.999999"
    field cod-lote-fabrican        like item-doc-est.cod-lote-fabrican
    field dat-fabricc-lote         like item-doc-est.dat-fabricc-lote
    field dat-valid-lote-fabrican  like item-doc-est.dat-valid-lote-fabrican
    field nom-fabrican             like item-doc-est.nom-fabrican
    field val-cub-uni              as   dec format ">>>>>,>>>,>>9.999999"
    field cd-trib-ii               as   integer
    field cd-trib-ipi              as   integer
    field cd-trib-icms             as   integer
    field aliquota-ii              as   decimal format ">>9.99"
    field aliquota-ipi             as   decimal format ">>9.99"
    field aliquota-icms            as   decimal format ">>9.99"
    field l-regime                 as   logical
    field l-ordens-embarque        as   logical
    field un                       as   character
    field qtd-do-forn              as   decimal format ">>>>,>>9.9999"
    field un-fornec                as   character
    field suspensao-II             as   logical
    field suspensao-IPI            as   logical
    field l-selecionado            as   logical /* campo incluso para filtrar o browse da tela do im0100a */
    field l-gera-prim-nf-remes-mae as   logical
    index ordem is primary unique
          numero-ordem 
          parcela 
          sequencial.


/* BOCX220C.I */
