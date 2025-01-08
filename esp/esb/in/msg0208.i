{esp/esb/esesb000.i}

DEFINE TEMP-TABLE MSG0208 NO-UNDO XML-NODE-NAME 'MSG0208'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido
   FIELD NumeroEmbarque     LIKE embarque-imp.embarque
   FIELD MatriculaUsuario   LIKE usuar_mestre.cod_usuar
   FIELD I18N               AS LOGICAL.

DEFINE TEMP-TABLE MSG0208R1 NO-UNDO XML-NODE-NAME 'MSG0208R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ExibePrecos                   AS LOG
   .


DEFINE TEMP-TABLE Pedido_R1 NO-UNDO XML-NODE-NAME 'PedidoCompra'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedidoCompra            LIKE pedido-compr.num-pedido
    FIELD DataPedido                    LIKE pedido-compr.data-pedido
    FIELD CodigoFornecedorEMS           LIKE pedido-compr.cod-emitente
    FIELD NomeAbreviadoFornecedor       LIKE emitente.nome-abrev
    FIELD CGCFornecedor                 LIKE emitente.cgc
    FIELD SituacaoAceitePedido          AS INT       
    FIELD MotivoRejeicao                AS CHAR
    FIELD CodigoCondicaoPagamento       LIKE pedido-compr.cod-cond-pag
    FIELD NomeCondicaoPagamento         AS CHARACTER 
    FIELD CodigoEstabelecimentoEntrega  LIKE pedido-compr.end-entrega     
    FIELD CodigoEstabelecimentoCobranca LIKE pedido-compr.end-cobranca    
    FIELD MatriculaResponsavel          LIKE pedido-compr.responsavel
    FIELD NomeResponsavel               LIKE usuar_mestre.nom_usuario
    FIELD CodigoTipoPedido              AS INTEGER
    FIELD NomeTipoPedido                AS CHARACTER 
    FIELD PedidoEmergencial             AS LOG
    FIELD CodigoCKD                     AS CHARACTER INITIAL ?
    FIELD QuantidadeCKD                 AS DECIMAL INITIAL ?
    FIELD NaturezaPedido                LIKE pedido-compr.natureza
    FIELD TipoFrete                     LIKE pedido-compr.frete
    FIELD CodigoTransportadora          LIKE pedido-compr.cod-transp
    FIELD NomeTransportadora            LIKE transporte.nome
    FIELD CodigoViaTransporte           LIKE pedido-compr.via-transp
    FIELD NarrativaPedido               LIKE pedido-compr.comentarios
    FIELD CodigoMensagemPedido          LIKE pedido-compr.cod-mensagem
    FIELD SituacaoPedidoCompra          LIKE pedido-compr.situacao
    FIELD HistoricoPedidoCompra         AS CHAR
    FIELD LogEnvioComex                 LIKE ext-embarque-imp.log-envio-comex
    FIELD LogLiberaItinerarioComex      LIKE int-processo-imp.log-libera-itinerario
//    FIELD FinalidadeCourier             AS i
    INDEX idx1 IS PRIMARY NumeroPedidoCompra.

DEFINE TEMP-TABLE ProcessoImportacao_R1 NO-UNDO XML-NODE-NAME 'ProcessoImportacao'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedidoCompra        LIKE pedido-compr.num-pedido XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroProcessoImportacao  LIKE processo-imp.nr-proc-imp
    FIELD DataEmissao               LIKE processo-imp.dt-emissao
    FIELD CodigoDespachante         LIKE processo-imp.cod-despachante
    FIELD NomeDespachante           LIKE emitente.nome-abrev
    FIELD CodigoAgenteCargas        LIKE processo-imp.cod-agente
    FIELD NomeAgenteCargas          LIKE emitente.nome-abrev
    FIELD CodigoItinerario          LIKE processo-imp.cod-itiner
    FIELD DescricaoItinerario       LIKE itinerario.descricao
    FIELD CodigoIdioma              LIKE processo-imp.cod-idioma
    FIELD CodigoCorretorCambio      LIKE processo-imp.cdn-corretor-cambio-import
    FIELD NomeCorretorCambio        LIKE emitente.nome-abrev
    FIELD CodigoDespachanteExterior LIKE processo-imp.cdn-despa-exter-import
    FIELD NomeDespachanteExterior   LIKE emitente.nome-abrev
    FIELD CodigoSeguradora          LIKE processo-imp.cdn-segurad-import
    FIELD NomeSeguradora            LIKE emitente.nome-abrev
    FIELD CodigoCorretorSeguro      LIKE processo-imp.cdn-corretor-import
    FIELD NomeCorretorSeguro        LIKE emitente.nome-abrev
    FIELD NomeDestino               AS CHAR
    INDEX idx1 IS PRIMARY NumeroPedidoCompra.

DEFINE TEMP-TABLE Ordem_R1 NO-UNDO XML-NODE-NAME 'OrdemCompra'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedidoCompra       LIKE pedido-compr.num-pedido XML-NODE-TYPE 'HIDDEN'      
    FIELD NumeroOrdemCompra        LIKE ordem-compra.numero-ordem                           
    FIELD CodigoProduto            LIKE ordem-compra.it-codigo                              
    FIELD NomeProduto              LIKE ITEM.desc-item
    FIELD PartNumberItemFabricante LIKE item-fabric.it-fabric     INITIAL ? 
    FIELD CodigoUnidadeNegocio     LIKE ordem-compra.cod-unid-negoc
    FIELD NomeUnidadeNegocio       AS CHARACTER
    FIELD NecessitaInspecaoOrigem  LIKE int-item-fornec-estab.log-nec-inspec
    FIELD ValorUnitarioItem        LIKE ordem-compra.pre-unit-for
    FIELD ValorUnitarioIPI         LIKE cotacao-item.pre-unit-for INITIAL ?
    FIELD QuantidadeTotalOrdem     LIKE ordem-compra.qt-solic
    FIELD QuantidadeRecebidaOrdem  LIKE ordem-compra.qt-acum-rec
    FIELD CodigoDepositoOrdem      LIKE ordem-compra.dep-almoxar
    FIELD NomeDepositoOrdem        AS CHARACTER
    FIELD Destaque                 LIKE int-cotacao-item.destaque INITIAL ?
    FIELD NivelCriticidade         AS INTEGER INITIAL ?
    FIELD CodigoMoedaEMS           LIKE moeda.mo-codigo
    FIELD SituacaoOrdemCompra      LIKE ordem-compra.situacao
    FIELD MatriculaComprador       LIKE ordem-compra.cod-comprado
    FIELD NomeComprador            LIKE usuar_mestre.nom_usuario
    FIELD NumeroOrdemServico       LIKE ordem-compra.ordem-servic
    FIELD MatriculaRequisitante    LIKE ordem-compra.requisitante
    FIELD NomeRequisitante         LIKE usuar_mestre.nom_usuario
    FIELD CodigoContaContabil      LIKE ordem-compra.ct-codigo
    FIELD CodigoCentroCusto        LIKE ordem-compra.sc-codigo
    FIELD CodigoTipoDespesa        LIKE ordem-compra.tp-despesa
    FIELD DescricaoTipoDespesa     LIKE tipo-rec-desp.descricao
    FIELD NarrativaOrdemCompra     LIKE ordem-compra.narrativa
    FIELD ObservacaoLogistica      LIKE int-item-uni-estab.observacao 
    INDEX idx1 IS PRIMARY NumeroPedidoCompra NumeroOrdemCompra.


DEFINE TEMP-TABLE Cotacao_R1 NO-UNDO XML-NODE-NAME 'Cotacao'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroOrdemCompra             LIKE ordem-compra.numero-ordem XML-NODE-TYPE 'HIDDEN'      
    FIELD CodigoUnidadeMedidaFornecedor LIKE cotacao-item.un          
    FIELD Reajuste                      LIKE cotacao-item.reaj-tabela 
    FIELD PrecoFornecedor               LIKE cotacao-item.preco-fornec
    FIELD CodigoMoedaEMS                LIKE cotacao-item.mo-codigo   
    FIELD NumeroCotacao                 LIKE cotacao-item.seq-cotac   
    FIELD IPIIncluso                    LIKE cotacao-item.codigo-ipi
    FIELD AliquotaIPI                   LIKE cotacao-item.aliquota-ipi INITIAL ?
    FIELD TipoICMS                      LIKE cotacao-item.codigo-icm
    FIELD AliquotaICMS                  LIKE cotacao-item.aliquota-icm
    FIELD AliquotaISS                   LIKE cotacao-item.aliquota-iss
    FIELD NomeContato                   LIKE cotacao-item.contato
    FIELD FreteIncluso                  LIKE cotacao-item.frete
    FIELD ValorFrete                    LIKE cotacao-item.valor-frete
    FIELD TaxaFinanceira                LIKE cotacao-item.valor-taxa
    FIELD EncargosFinanceiros           LIKE cotacao-item.taxa-financ
    FIELD DiasTaxaFinanceira            LIKE cotacao-item.nr-dias-taxa
    FIELD PercentualDesconto            LIKE cotacao-item.perc-descto
    FIELD ValorDesconto                 LIKE cotacao-item.valor-descto
    FIELD PrazoEntrega                  LIKE cotacao-item.prazo-entreg
    FIELD PrecoUnitarioFornecedor       LIKE cotacao-item.pre-unit-for
    INDEX idx1 IS PRIMARY NumeroOrdemCompra.

DEFINE TEMP-TABLE CotacaoItemImportado_R1 NO-UNDO XML-NODE-NAME 'CotacaoItemImportado'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroOrdemCompra          LIKE ordem-compra.numero-ordem XML-NODE-TYPE 'HIDDEN'     
    FIELD SequenciaCotacao           LIKE cotacao-item.seq-cotac
    FIELD CotacaoAprovada            LIKE cotacao-item.cot-aprovada
    FIELD MapaCotacao                LIKE cotacao-item.mapa-cotacao
    FIELD CodigoIncoterm             LIKE cotacao-item.cod-incoterm
    FIELD CodigoPontoControleBase    LIKE cotacao-item.cod-pto-contr
    FIELD DescricaoPontoControleBase LIKE pto-contr.descricao
    FIELD CodigoFabricante           LIKE emitente.cod-emitente       INITIAL ? 
    FIELD NomeFabricante             LIKE cotacao-item.nome-abrev-fabricante        
    FIELD PaisOrigem                 LIKE mgcad.pais.nome-pais
    FIELD NCM                        LIKE cotacao-item.class-fiscal
    FIELD DestaqueNCM                LIKE int-cotacao-item.destaque
    FIELD AliquotaII                 LIKE cotacao-item.aliquota-ii
    FIELD CodigoItinerario           LIKE cotacao-item.int-1
    FIELD DescricaoItinerario        LIKE itinerario.descricao
    FIELD NVE                        LIKE int-cotacao-item.nve
    FIELD ExTarifario                LIKE int-item.ex-tarifario       INITIAL ?
    FIELD NecessitaLicencaImportacao LIKE item.log-necessita-li                
    FIELD GATT                       LIKE int-cotacao-item.log-gatt
    FIELD PercentualGATT             LIKE int-cotacao-item.perc-gatt  INITIAL ?
    INDEX idx1 IS PRIMARY NumeroOrdemCompra.

DEFINE TEMP-TABLE Parcela_R1 NO-UNDO XML-NODE-NAME 'Parcela'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroOrdemCompra             LIKE ordem-compra.numero-ordem XML-NODE-TYPE 'HIDDEN'
    FIELD SequenciaParcela              LIKE prazo-compra.parcela
    FIELD DataOriginalParcela           LIKE prazo-compra.data-orig
    FIELD DataParcela                   LIKE prazo-compra.data-entrega
    FIELD QuantidadeParcela             LIKE prazo-compra.quantidade
    FIELD CodigoUnidadeMedida           LIKE prazo-compra.un
    FIELD QuantidadeFornecedor          LIKE prazo-compra.qtd-do-forn          
   /* FIELD CodigoUnidadeMedidaFornecedor LIKE item-fornec-estab.unid-med-for */
    FIELD SituacaoMovimentoParcela      AS INTEGER
    FIELD DataLimiteInspecao            AS DATE /*campo novo*/
    FIELD ValorParcela                  LIKE ordem-compra.preco-fornec
    FIELD ValorParcelaIPI               LIKE cotacao-item.pre-unit-for        INITIAL ?
    FIELD DiasAtraso                    AS INT /*nacional today - data entrega, today - ponto de controle de libera‡Æo (ponto 2)*/
    FIELD NumeroEmbarque                LIKE embarque-imp.embarque            INITIAL ?
    FIELD EmbarqueContabilizado         LIKE embarque-imp.contabiliza         INITIAL ?
    FIELD House                         LIKE embarque-imp.cod-conhecto-house  INITIAL ?
    FIELD Master                        LIKE embarque-imp.cod-conhecto-master INITIAL ?
    FIELD PesoBruto                     LIKE ordens-embarque.peso-bruto       INITIAL ?
    FIELD PesoLiquido                   LIKE ordens-embarque.peso-liquido     INITIAL ?
    FIELD Cubagem                       LIKE ordens-embarque.val-cub-tot      INITIAL ?
    FIELD DataDespacho                  AS DATE                               INITIAL ?
    FIELD NumeroLIAnuida                LIKE licenciam-import-oc.licenca-import
    FIELD ValidadeLI                    AS DATE
    FIELD LocalEmbarqueParcela          LIKE pto-contr.descricao
    FIELD SituacaoParcela               LIKE prazo-compra.situacao
    FIELD NumeroNotaFiscal              LIKE recebimento.numero-nota
    FIELD NumeroSerie                   LIKE recebimento.serie-nota 
    FIELD MatriculaUsuarioRecebimento   LIKE recebimento.usuario
    FIELD SituacaoEmbarque              AS INT
    FIELD QuantidadeSaldo               LIKE prazo-compra.quant-saldo
    FIELD NumeroNotaFiscalPrevista      LIKE int-prazo-compra.nro-docto   
    FIELD SerieNotaFiscalPrevista       LIKE int-prazo-compra.serie-docto
    FIELD DataNecessidade               AS DATE
    FIELD DataEntregaIdeal              AS DATE
    FIELD id-relac                      AS INTEGER XML-NODE-TYPE 'HIDDEN' 
    INDEX idx1 IS PRIMARY NumeroOrdemCompra SequenciaParcela.

DEFINE TEMP-TABLE InspecaoAgendada NO-UNDO XML-NODE-NAME 'InspecaoAgendada'
    FIELD idm                           AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD id-relac                      AS INTEGER XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoAgendamento             AS INTEGER 
    FIELD DataAgendamentoInspecao       LIKE historico-inspecao.data-prev-inspec
    FIELD DuracaoAgendamento            LIKE historico-inspecao.duracao-agendamento
    FIELD DataExecucaoInspecao          LIKE historico-inspecao.data-inspec 
    FIELD DuracaoExecucao               LIKE historico-inspecao.duracao-execucao
    FIELD StatusInspecao                LIKE historico-inspecao.status-inspec
    FIELD ObservacoesInspecao           AS CHARACTER
    FIELD QuantidadeAgendada            AS INTEGER
    FIELD QuantidadeInspecionada        AS INTEGER
    FIELD CodigoInspetor                LIKE historico-inspecao.cod-inspetor
    FIELD NomeInspetor                  LIKE historico-inspecao.nome-inspetor
    FIELD RegiaoInspecao                LIKE historico-inspecao.regiao-inspec.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

{esp/imp/esimp000.i1} /*tt-emb*/
