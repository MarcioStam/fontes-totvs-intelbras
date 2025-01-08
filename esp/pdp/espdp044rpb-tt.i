/** temp-tables do WS **/

define temp-table ttPedido no-undo
   field LojaCodigo                as character
   field PedidoCodigo              as character
   field PedidoCodigoCliente       as character
   field PedidoCodigoInterno       as character
   field UsuarioCodigo             as character
   field UsuarioOperador           as character
   field UsuarioGerente            as character
   field ContaCodigo               as character
   field ContaCorrenteCodigo       as character
   field ParceiroCodigo            as character
   field AfiliadoCodigo            as character
   field CupomCodigo               as character
   field GrupoCodigo               as character
   field VitrineCodigo             as character
   field PromocaoCodigo            as character
   field ParcelamentoGCodigo       as character
   field ParcelamentoPCodigo       as character
   field CestaCodigo               as character
   field CestaMensagem             as character
   field Sedex                     as character
   field SedexData                 as character
   field Observacao                as character
   field MotivoCancel              as character
   field Desconto                  as character
   field Pessoa                    as character
   field Nome                      as character
   field Sobrenome                 as character
   field RazaoSocial               as character
   field CPF                       as character
   field CNPJ                      as character
   field RG                        as character
   field IE                        as character
   field DataNascimento            as character
   field NomeDestinatario          as character
   field TipoLogradouro            as character
   field Logradouro                as character
   field Numero                    as character
   field Complemento               as character
   field CEP                       as character
   field Bairro                    as character
   field Cidade                    as character
   field Estado                    as character
   field Pais                      as character
   field DDD1                      as character
   field Telefone1                 as character
   field Ramal1                    as character
   field DDD2                      as character
   field Telefone2                 as character
   field Ramal2                    as character
   field DDD3                      as character
   field Telefone3                 as character
   field Ramal3                    as character
   field DDDCelular                as character
   field Celular                   as character
   field DDDFax                    as character
   field Fax                       as character
   field Referencia                as character
   field Email                     as character
   field NumeroNF                  as character
   field SerieNF                   as character
   field Operadora                 as character
   field FormaPgto                 as character
   field ValorSubTotal             as character
   field ValorTotal                as character
   field ValorParcela              as character
   field ValorJuros                as character
   field Mensagem                  as character
   field ValorPresente             as character
   field ValorGarantiaEstendida    as character
   field QtdeParcelas              as character
   field Score                     as character
   field PedidoStatus              as character
   field PedidoStatusInterno       as character
   field StatusIntegracao          as character
   field StatusClearSale           as character
   field Data                      as character
   field MensagemErro              as character
   field AvisoBoleto               as character
   field ValorVale                 as character
   field ValorRestante             as character
   field ListaCodigo               as character
   field EnderecoLista             as character
   field FreteGratis               as character
   field TipoFrete                 as character
   field ValorFrete                as character
   field ValorFreteCobrado         as character
   field PesoTotal                 as character
   field PesoTotalCubado           as character
   field PesoTotalCobrado          as character
   field PesoTotalCubadoCobrado    as character
   field ServicoEntregaCodigo      as character
   field PrazoEntrega              as character
   field DataEntrega               as character
   field CPFNP                     as character
   field AssinaturaDebitoBradesco  as character
   field Texto1                    as character
   field Texto2                    as character
   field Texto3                    as character
   field Texto4                    as character
   field Texto5                    as character
   field Numero1                   as character
   field Numero2                   as character
   field Numero3                   as character
   field Numero4                   as character
   field Numero5                   as character
   field SemCadastro               as character
   field VerificaHistoricoAnterior as character
   field PedidoCupomProximaCompra  as character
   field PedidoCupomValidade       as character
   field CpfCnpjOrigem             as character
   index ch_pri LojaCodigo PedidoCodigo.

define temp-table ttCartao no-undo
   field LojaCodigo                  as character
   field PedidoCodigo                as character
   field Numero                      as character
   field Seguranca                   as character
   field Titular                     as character
   field ValidadeMes                 as character
   field ValidadeAno                 as character
   field CarTID                      as character
   field CarOperadoraRetornoCodigo   as character
   field CarOperadoraRetornoMensagem as character
   field CarAutorizacaoCodigo        as character
   field CarCPFCNPJ                  as character
   field MensagemErro                as character
   index ch_pri LojaCodigo PedidoCodigo.

define temp-table ttItens no-undo
   field LojaCodigo                       as character
   field ItemCodigo                       as character
   field PedidoCodigo                     as character
   field ProdutoCodigo                    as character
   field ItemCodigoComprado               as character
   field PromocaoCodigo                   as character
   field CategoriaCodigo                  as character
   field CrossSellingCodigo               as character
   field VitrineCodigo                    as character
   field FabricanteCodigo                 as character
   field ParceiroCodigo                   as character
   field GrupoCodigo                      as character
   field ProdutoValorCaracteristicaCodigo as character
   field ItemStatus                       as character
   field ItemStatusInterno                as character
   field ItemStatusIntegracao             as character
   field ItemQtde                         as character
   field ItemValor                        as character
   field ItemValorFinal                   as character
   field ItemValorPresente                as character
   field ItemValorGarantiaEstendida       as character
   field ItemAnosGarantiaEstendida        as character
   field ItemCertificadoGarantiaEstendida as character
   field EnqCodInterno                    as character
   field ItemTipo                         as character
   field Presente                         as character
   field Cupom                            as character
   field ItemNome                         as character
   field ItemMensagem                     as character
   field ItemMsgPresente                  as character
   field ItemPartNumber                   as character
   field CodigoInterno                    as character
   field FreteGratis                      as character
   field ItemValorFrete                   as character
   field ItemValorFreteCobrado            as character
   field ItemPeso                         as character
   field ItemPesoCubado                   as character
   field ItemPesoCobrado                  as character
   field ItemPesoCubadoCobrado            as character
   field ServicoEntregaCodigo             as character
   field ItemPrazoEntrega                 as character
   field ItemDataEntrega                  as character
   field Sedex                            as character
   field ListaCodigo                      as character
   field ListaCodigoInterno               as character
   field ListaTipoEntrega                 as character
   field ItemTroca                        as character
   field ItemTexto1                       as character
   field ItemTexto2                       as character
   field ItemTexto3                       as character
   field ItemNumero1                      as character
   field ItemNumero2                      as character
   field ItemNumero3                      as character
   field PersonalizacaoExtra              as character
   field PersonalizacaoTexto              as character
   field ItemCodigoInterno                as character
   field MensagemErro                     as character
   field VerificaHistoricoAnterior        as character
   index ch_pri LojaCodigo PedidoCodigo ItemCodigo.

define temp-table ttAuxPedido no-undo like ttPedido.
define temp-table ttAuxItens  no-undo like ttItens.
define temp-table ttAuxCartao no-undo like ttCartao.

/** temp-tables para BO's **/
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

define temp-table tt-ped-venda no-undo like ped-venda
   field r-rowid  as rowid.
define temp-table tt-ped-item no-undo like ped-item
   field r-rowid  as rowid.
define temp-table tt-ped-ent no-undo like ped-ent
   field r-rowid  as rowid.
define temp-table tt-ped-repre no-undo like ped-repre
   field r-rowid  as rowid.
define temp-table tt-ped-antecip no-undo like ped-antecip
   field r-rowid  as rowid.
define temp-table tt-cond-ped no-undo like cond-ped
   field r-rowid  as rowid.

define temp-table tt-ped-vendor no-undo
   field data-base    as date
   field dias-base    as integer format ">>>9"
   field cod-cond-pag as integer format ">9"
   field taxa-cliente as decimal format ">>9.9999".

define temp-table ttEstabPedido no-undo
    field cod-estabel like estabelec.cod-estabel.

define temp-table tt-ped-valid no-undo
    field PedidoCodigo as character
    FIELD contaCodigo  AS CHARACTER.

/** Temp-table maldita pra achar corretamente o pre‡o de um item na tabela **/
define temp-table tt-preco-item no-undo
   field nr-tabpre   like preco-item.nr-tabpre
   field it-codigo   like preco-item.it-codigo
   field cod-refer   like preco-item.cod-refer
   field dt-inival   like preco-item.dt-inival
   field quant-min   like preco-item.quant-min
   field preco-venda like preco-item.preco-venda
   field situacao    like preco-item.situacao
   field desco-quant like preco-item.desco-quant
   index ch-data     is primary dt-inival it-codigo nr-tabpre cod-refer quant-min
   index ch-itemtab  it-codigo cod-refer nr-tabpre dt-inival quant-min.

/** Temp-table do Pagador **/
define temp-table ttDadosPedido no-undo
   field CodigoAutorizacao as character
   field CodigoErro        as character
   field CodigoPagamento   as character
   field FormaPagamento    as character
   field MensagemErro      as character
   field NumeroParcelas    as character
   /*field Status            as character*/
   field Valor             as character
   field DataCancelamento  as character
   field DataPagamento     as character
   field DataPedido        as character
   field TransId           as character
   field BraspagTid        as character.
