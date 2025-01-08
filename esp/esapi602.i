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

DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
    FIELD r-rowid AS ROWID.

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

define temp-table tt-item-fornec-estab like item-fornec-estab
  field r-rowid as rowid.

define temp-table tt-processo-imp like processo-imp
  field r-rowid as rowid.

define temp-table tt-cabec no-undo
  field centerID         as character
  field buyer            as character
  field spendType        as character
  field supplierID       as integer
  field logisticsAnalyst as character
  field shipper          as integer
  field paymentTerms     as integer
  field itinerary        as integer
  field incoterm         as character
  field codigo-icm       as integer
  field cod-mensagem     as integer.

define temp-table tt-itens no-undo
  field r-cabec               as rowid
  field sequence              as integer
  field productID             as int64
  field productNameComplement as character
  field quantity              as decimal
  field supplierQuantity      as decimal
  field unitPrice             as decimal
  field unitPriceAux          as character
  field currency              as character
  field ipiTax                as decimal
  field ipiTaxAux             as character
  field icmsTax               as decimal
  field icmsTaxAux            as character
  field issTax                as decimal
  field issTaxAux             as character
  field leadTime              as integer
  field transitTime           as integer
  field supplierReference     as character
  field unitMeasure           as character
  field checkpoint            as integer
  field ledgerAccount         as character
  field costCenter            as character
  field businessUnit          as character
  field centerIDcc            as character
  field numero-ordem          as integer
  field tp-despesa            as integer
  field parcela               as integer
  field tipo-contr            as integer.

def temp-table tt_log_erro no-undo
  field ttv_num_cod_erro  as integer
  field ttv_des_msg_ajuda as character
  field ttv_des_msg_erro  as character
  .

define temp-table tt-item-fornec no-undo like item-fornec
    field r-Rowid as rowid.
