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

define temp-table tt-erros-geral no-undo
  field identif-msg           as char    format "x(60)"
  field num-sequencia-erro    as integer format "999"
  field cod-erro              as integer format "99999"   
  field des-erro              as char    format "x(60)"
  field cod-maq-origem        as integer format "999"
  field num-processo          as integer format "999999999".

define temp-table tt-itens no-undo
  field sequence              as character
  field quantity              as decimal
  field supplierQuantity      as decimal
  field unitPrice             as decimal
  field unitPriceAux          as character
  field leadTime              as INTEGER
  field unitSupplierMeasure   as character
  field numero-ordem          as integer
  field requester             as character
  field lg-status             as logical
  field rateio                as decimal
  field parcela               as integer
  field tipo-contr            as integer.

define temp-table tt-ccusto no-undo
  field r-item        as rowid
  field seq           as inte
  field ledgerAccount as character
  field costCenter    as character
  field businessUnit  as character
  field centerIDcc    as character
  field apportionment as decimal
  index id is primary r-item
                      seq
  index id2 r-item 
            apportionment desc
            seq.

def temp-table tt_log_erro no-undo
  field ttv_num_cod_erro  as integer
  field ttv_des_msg_ajuda as character
  field ttv_des_msg_erro  as character
  .

def temp-table tt-ordem-compra-aux no-undo
    field numero-ordem like ordem-compra.numero-ordem
    index id is primary numero-ordem.

{esp/imp/esimp000.i1}
