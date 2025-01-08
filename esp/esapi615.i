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

def temp-table tt_log_erro no-undo
  field ttv_num_cod_erro  as integer
  field ttv_des_msg_ajuda as character
  field ttv_des_msg_erro  as character
  .

