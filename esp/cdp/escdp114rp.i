/********** TEMP-TABLES **********/
define temp-table tt-relat-01 no-undo
    field it-codigo    like ordem-compra.it-codigo
    field cod-estabel  like ordem-compra.cod-estabel
    field rotina       as inte
    field num-pedido   like ordem-compra.num-pedido
    field numero-ordem like ordem-compra.numero-ordem
    field desc-item    like item.desc-item
    field ge-codigo    like item.ge-codigo
    field quantidade   like saldo-estoq.qtidade-atu
    field lote         like saldo-estoq.lote
    field cod-depos    like saldo-estoq.cod-depos
    field cod-localiz  like saldo-estoq.cod-localiz
    field cod-refer    like saldo-estoq.cod-refer
    field observacao   as char
    index id is primary it-codigo
                        cod-estabel
                        rotina
                        num-pedido
                        numero-ordem
                        cod-depos
                        lote
                        cod-localiz
                        cod-refer
    index id2 rotina
              num-pedido
              it-codigo  
              cod-estabel
              cod-depos  
              lote       
              cod-localiz
              cod-refer.

define temp-table tt-ped-item no-undo
    field nome-abrev   like ped-item.nome-abrev
    field nr-pedcli    like ped-item.nr-pedcli
    field nr-sequencia like ped-item.nr-sequencia
    field it-codigo    like ped-item.it-codigo
    field desc-item    like item.desc-item
    field cod-estabel  like ped-venda.cod-estabel
    field quantidade   as deci      
    index id is primary it-codigo
                        cod-estabel
                        nome-abrev
                        nr-pedcli
                        nr-sequencia.

define temp-table tt-saldo-estoq no-undo
    field it-codigo    like saldo-estoq.it-codigo
    field cod-estabel  like saldo-estoq.cod-estabel
    field cod-depos    like saldo-estoq.cod-depos
    field cod-localiz  like saldo-estoq.cod-localiz
    field lote         like saldo-estoq.lote
    field qtidade-atu  like saldo-estoq.qtidade-atu
    field qt-alocada   like saldo-estoq.qt-alocada
    field qt-aloc-prod like saldo-estoq.qt-aloc-prod
    field qt-aloc-ped  like saldo-estoq.qt-aloc-ped
    index id is primary it-codigo
                        cod-estabel
                        cod-depos
                        cod-localiz
                        lote.

define temp-table tt-ord-prod no-undo
    field it-codigo    like ord-prod.it-codigo
    field cod-estabel  like ord-prod.cod-estabel
    field nr-ord-produ like ord-prod.nr-ord-produ
    field qt-ordem     like ord-prod.qt-ordem
    index id is primary it-codigo
                        cod-estabel
                        nr-ord-produ.

define temp-table tt-prazo-compra no-undo
    field it-codigo    like ordem-compra.it-codigo
    field cod-estabel  like ordem-compra.cod-estabel
    field numero-ordem like prazo-compra.numero-ordem
    field parcela      like prazo-compra.parcela
    field quant-saldo  like prazo-compra.quant-saldo
    index id is primary it-codigo
                        cod-estabel
                        numero-ordem
                        parcela.

define temp-table tt-ferr-prod no-undo
    field cod-ferr-prod like ferr-prod.cod-ferr-prod
    index id is primary cod-ferr-prod.

define temp-table tt-ops no-undo
    field it-codigo     like item.it-codigo
    field desc-item     like item.desc-item
    field nr-ord-produ  like ord-prod.nr-ord-produ
    field qt-ordem      like ord-prod.qt-ordem
    field cod-estabel   like ord-prod.cod-estabel
    field estado        as char
    field sem-operacao  as logi
    field sem-reserva   as logi
    field sem-estrutura as logi
    index id is primary sem-operacao
                        it-codigo
                        nr-ord-produ
    index id2 sem-reserva
              it-codigo
              nr-ord-produ
    index id3 sem-estrutura
              it-codigo
              nr-ord-produ.

define temp-table tt-operacao no-undo
    field ferramenta like op-ferram.ferramenta
    field gm-codigo  like operacao.gm-codigo
    field it-codigo  like operacao.it-codigo
    field desc-item  like item.desc-item
    field op-codigo  like operacao.op-codigo
    index id is primary ferramenta 
                        it-codigo
                        op-codigo.

define temp-table tt-grup-maquina no-undo
    field gm-codigo like grup-maquina.gm-codigo
    index id is primary gm-codigo.

define temp-table tt-item no-undo
    field it-codigo  like item.it-codigo
    field desc-item  like item.desc-item
    field quantidade as deci extent 4 /* 1 - Pedido Venda; 2 - Estoque; 3 - OP; 4 - OC */
    index id is primary it-codigo.

define temp-table tt-item-uni-estab no-undo
    field cod-estabel like item-uni-estab.cod-estabel
    field it-codigo   like item-uni-estab.it-codigo
    field desc-item   like item.desc-item
    field nr-linha    like item-uni-estab.nr-linha
    field observacao  as char
    index id is primary cod-estabel
                        it-codigo.

define temp-table tt-recurso no-undo
    fields it-codigo      like operacao.it-codigo
    fields op-codigo      like operacao.op-codigo
    fields descricao      like operacao.descricao
    fields gm-codigo      like operacao.gm-codigo
    fields cod-ferr-prod  like op-ferram.ferramenta
    fields obrigatoria    like int-gm-recurso.obrigatoria
    fields mensagem       as char
    fields lg-oper        as logi
    fields cod-ferr-prod2 like op-ferram.ferramenta
    index id is primary it-codigo
                        op-codigo
                        gm-codigo
                        cod-ferr-prod.

define temp-table tt-estrutura no-undo
    field es-codigo    like estrutura.es-codigo
    field it-codigo    like estrutura.it-codigo
    field sequencia    like estrutura.sequencia
    field dt-ini-estr  like estrutura.data-inicio
    field dt-term-estr like estrutura.data-termino
    field it-op        like ord-prod.it-codigo
    field nr-ord-produ like ord-prod.nr-ord-produ
    field dt-ini-op    like ord-prod.dt-inicio
    field dt-term-op   like ord-prod.dt-termino
    field cod-estabel  like ord-prod.cod-estabel
    index id is primary es-codigo
                        nr-ord-produ
                        sequencia
                        it-codigo.

define temp-table tt-hom-aps no-undo
    field it-codigo    like oper-ord.it-codigo
    field op-codigo    like oper-ord.op-codigo
    field hom-aps      as decimal
    field hom-aps-oper as decimal
    field nr-ord-produ like oper-ord.nr-ord-produ
    field cod-estabel  like ord-prod.cod-estabel
    field tipo         as character
    field estado       as character
    field descricao    as character
    index id is primary cod-estabel
                        tipo
                        it-codigo
                        nr-ord-produ
                        op-codigo.

/********** FRAMES **********/
form tt-ops.it-codigo    format "x(16)"          column-label "Item"
     tt-ops.desc-item    format "x(60)"          column-label "Descri‡Æo"
     tt-ops.nr-ord-produ format ">>>,>>>,>>9"    column-label "Ord Prod"
     tt-ops.qt-ordem     format ">>>>>,>>9.9999" column-label "Qtde Ordem"
     tt-ops.cod-estabel  format "x(5)"           column-label "Estab"
     tt-ops.estado       format "x(15)"          column-label "Estado"
     with width 132 down no-box stream-io frame f-06-07-20.

find first param-global no-lock no-error.

assign c-programa     = "ESCDP114":U
       c-versao       = "1.00.00":U
       c-revisao      = "008":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Consistˆncia de Dados APS"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao.

assign c-rodape-80  = fill("-", 80  - length(c-rodape)) + c-rodape
       c-rodape-132 = fill("-", 132 - length(c-rodape)) + c-rodape
       c-rodape-172 = fill("-", 172 - length(c-rodape)) + c-rodape
       c-rodape-215 = fill("-", 215 - length(c-rodape)) + c-rodape
       c-rodape-250 = fill("-", 250 - length(c-rodape)) + c-rodape.

form header
     fill("-", 80) format "x(80)" skip
     c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
     "Folha:" at 70 page-number  at 76 format ">>>>9" skip
     fill("-", 60) format "x(58)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 80 no-labels no-box page-top frame f-cabec-80.

form header
     fill("-", 132) format "x(132)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 122 page-number  at 128 format ">>>>9" skip
     fill("-", 112) format "x(110)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 132 no-labels no-box page-top frame f-cabec-132.

form header
     fill("-", 172) format "x(172)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 162 page-number  at 168 format ">>>>9" skip
     fill("-", 152) format "x(150)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 172 no-labels no-box page-top frame f-cabec-172.

form header
     fill("-", 215) format "x(215)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 205 page-number  at 211 format ">>>>9" skip
     fill("-", 195) format "x(193)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 215 no-labels no-box page-top frame f-cabec-215.

form header
     fill("-", 250) format "x(250)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 240 page-number  at 246 format ">>>>9" skip
     fill("-", 230) format "x(228)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS")
     with stream-io width 250 no-labels no-box page-top frame f-cabec-250.

form header
     c-rodape-80  format "x(80)"
     with stream-io width 80  no-labels no-box page-bottom frame f-rodape-80.

form header
     c-rodape-132 format "x(132)"
     with stream-io width 132 no-labels no-box page-bottom frame f-rodape-132.

form header
     c-rodape-172 format "x(172)"
     with stream-io width 172 no-labels no-box page-bottom frame f-rodape-172.

form header
     c-rodape-215 format "x(215)"
     with stream-io width 250 no-labels no-box page-bottom frame f-rodape-215.

form header
     c-rodape-250 format "x(250)"
     with stream-io width 250 no-labels no-box page-bottom frame f-rodape-250.

