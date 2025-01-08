// boin425.i
DEFINE TEMP-TABLE tt-tb-pr-cc NO-UNDO LIKE tb-pr-cc
    FIELD r-rowid AS ROWID.

// boin185.i
DEFINE TEMP-TABLE tt-item-tab NO-UNDO LIKE item-tab
    FIELD r-rowid AS ROWID
    FIELD c-unid-med-for  like item-fornec.unid-med-for
    FIELD de-preco-un-int like item-tab.pr-item
    FIELD c-unid-med-int  like item-fornec.unid-med-for
    FIELD de-indice-int   as decimal.

// boin178.i
DEFINE TEMP-TABLE tt-item-fornec NO-UNDO LIKE item-fornec
    FIELD r-Rowid AS ROWID.

// boin688.i
DEFINE TEMP-TABLE tt-item-fornec-estab NO-UNDO LIKE item-fornec-estab
    FIELD r-Rowid AS ROWID.

// boin684.i
DEFINE TEMP-TABLE tt-item-uni-estab NO-UNDO LIKE item-uni-estab
    FIELD r-Rowid AS ROWID.

define temp-table tt-erros-geral no-undo
  field identif-msg           as char    format "x(60)"
  field num-sequencia-erro    as integer format "999"
  field cod-erro              as integer format "99999"   
  field des-erro              as char    format "x(60)"
  field cod-maq-origem        as integer format "999"
  field num-processo          as integer format "999999999".

define temp-table tt-ordem-compra no-undo like ordem-compra
  field l-split           as   logical                    initial no
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem-mp
                              num-processo
                              num-sequencia.

define temp-table tt-prazo-compra no-undo like prazo-compra
  field cod-maq-origem    as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                              num-processo
                              num-sequencia.

define temp-table tt-pedido-compr no-undo like pedido-compr
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                              num-processo
                              num-sequencia.

define temp-table tt-cond-especif no-undo like cond-especif
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem-mp
                              num-processo
                              num-sequencia.

define temp-table tt-cotacao-item no-undo like cotacao-item
  field cod-maq-origem    as integer format "999"       initial 0
  field num-processo      as integer format ">>>>>>>>9" initial 0
  field num-sequencia     as integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY cod-maq-origem
                             num-processo
                             num-sequencia.

define temp-table tt-desp-cotacao-item no-undo like desp-cotacao-item
  field cod-maq-origem    as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.

define temp-table tt-versao-integr no-undo
  field cod-versao-integracao as integer format "999"
  field ind-origem-msg        as integer format "99" /* i01mp900.i */.

define temp-table tt-altera-preco no-undo
    field it-codigo like item.it-codigo.

{esp/imp/esimp000.i1}

