{esp/esb/esesb000.i}

DEFINE TEMP-TABLE MSG0239 NO-UNDO XML-NODE-NAME 'MSG0239'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoFornecedorEMS       AS INT  INITIAL ?
   FIELD MatriculaComprador        AS CHAR INITIAL ?
   FIELD NivelCriticidade          AS INT  INITIAL ?
   FIELD CodigoInspetor            AS CHAR INITIAL ?
   FIELD NecessitaInspecaoOrigem   AS LOG  INITIAL ?
   FIELD CodigoProdutoInicial      AS CHAR INITIAL ?
   FIELD CodigoProdutoFinal        AS CHAR INITIAL ?
   FIELD NumeroOrdemCompra         LIKE ordem-compra.numero-ordem INITIAL ?
   FIELD SomenteParcelasSoltas     AS LOG  INITIAL ?
   FIELD CodigoIncoterm            AS CHAR INITIAL ?
   FIELD CodigoItinerario          AS INT  INITIAL ?
   FIELD StatusInspecao            LIKE historico-inspecao.status-inspec INITIAL ?
   FIELD MatriculaUsuario          LIKE usuar_mestre.cod_usuario
   FIELD SomenteInspecoesPendentes AS LOG  INITIAL NO
   FIELD SomenteComMovimentacaoPossivel AS LOG
   FIELD I18N                      AS LOG
   FIELD ApenasStatusPrev          AS LOG.

DEFINE TEMP-TABLE ttEstabelecimento NO-UNDO XML-NODE-NAME 'Estabelecimento'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoEstabelecimento LIKE estabelec.cod-estabel.

DEFINE TEMP-TABLE ttPedidos NO-UNDO XML-NODE-NAME 'PedidoCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido.

DEFINE TEMP-TABLE ttEmbarques NO-UNDO XML-NODE-NAME 'EmbarqueParcela'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque LIKE embarque-imp.embarque.

DEFINE TEMP-TABLE ttProdutoFabricante NO-UNDO XML-NODE-NAME 'ProdutoFabricante'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD PartNumberItemFabricante AS CHAR.

DEFINE TEMP-TABLE ttFiltroData NO-UNDO XML-NODE-NAME 'FiltroData'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD DataInicialPeriodo AS DATE
    FIELD DataFinalPeriodo AS DATE
    FIELD PesquisaData AS INTEGER.

DEFINE TEMP-TABLE FiltroAceite NO-UNDO XML-NODE-NAME 'FiltroAceite'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD SituacaoAceitePedido AS INT.

DEFINE TEMP-TABLE MSG0239R1 NO-UNDO XML-NODE-NAME 'MSG0239R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ExibePrecos                AS LOG.

DEFINE TEMP-TABLE PedidoOrdemCompra NO-UNDO XML-NODE-NAME 'PedidoOrdemCompra'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedidoCompra            LIKE pedido-compr.num-pedido
    FIELD DataPedido                    LIKE pedido-compr.data-pedido
    FIELD CodigoFornecedorEMS           LIKE pedido-compr.cod-emitente
    FIELD NomeAbreviadoFornecedor       LIKE emitente.nome-abrev
    FIELD CodigoCondicaoPagamento       LIKE pedido-compr.cod-cond-pag
    FIELD NomeCondicaoPagamento         AS CHARACTER 
    FIELD CodigoEstabelecimento         LIKE pedido-compr.cod-estabel
    FIELD MatriculaComprador            LIKE pedido-compr.responsavel
    FIELD NomeComprador                 LIKE usuar_mestre.nom_usuario
    FIELD CodigoTipoPedido              AS INTEGER
    FIELD PedidoEmergencial             LIKE pedido-compr.emergencial
    FIELD SituacaoAceitePedido          AS INT
    FIELD NumeroOrdemCompra             LIKE ordem-compra.numero-ordem                           
    FIELD CodigoProduto                 LIKE ordem-compra.it-codigo                              
    FIELD NomeProduto                   LIKE ITEM.desc-item
    FIELD PartNumberItemFabricante      LIKE item-fabric.it-fabric INITIAL ? 
    FIELD NecessitaLicencaImportacao    LIKE item.log-necessita-li
    FIELD NecessitaInspecaoOrigem       LIKE int-item-fornec-estab.log-nec-inspec
    FIELD ValorUnitarioItem             LIKE ordem-compra.pre-unit-for
    FIELD QuantidadeTotalOrdem          LIKE ordem-compra.qt-solic
    FIELD NivelCriticidade              AS INTEGER INITIAL ?
    FIELD SequenciaParcela              LIKE prazo-compra.parcela
    FIELD DataParcela                   LIKE prazo-compra.data-entrega
    FIELD QuantidadeParcela             LIKE prazo-compra.quantidade
    FIELD CodigoUnidadeMedida           LIKE prazo-compra.un
    FIELD QuantidadeFornecedor          LIKE prazo-compra.qtd-do-forn
    FIELD CodigoUnidadeMedidaFornecedor LIKE item-fornec-estab.unid-med-for
    FIELD SituacaoMovimentoParcela      AS INTEGER
    FIELD DataLimiteInspecao            AS DATE /*campo novo*/
    FIELD ValorParcela                  LIKE ordem-compra.preco-fornec
    FIELD NumeroEmbarque                LIKE embarque-imp.embarque INITIAL ?
    FIELD DataDespacho                  AS DATE INITIAL ?
    FIELD AliquotaIPI                   LIKE cotacao-item.aliquota-ipi
    FIELD ValorUnitarioIPI              LIKE cotacao-item.pre-unit-for
    FIELD NCM                           LIKE cotacao-item.class-fiscal
    FIELD CodigoUnidadeNegocio          LIKE ordem-compra.cod-unid-negoc
    FIELD NomeUnidadeNegocio            LIKE unid-negoc.des-unid-negoc
    FIELD CodigoMoedaEMS                LIKE cotacao-item.mo-codigo
    FIELD ConhecimentoEmbarque          LIKE embarque-imp.cod-conhecto-master
    FIELD SituacaoEmbarque              LIKE embarque-imp.situacao
    FIELD DataEmbarque                  LIKE embarque-imp.data-di
    FIELD OrdemInspecao                 AS INT
    FIELD QuantidadeSaldo               LIKE prazo-compra.quant-saldo
    FIELD CodigoViaTransporte           LIKE embarque-imp.cod-via-transp
    FIELD NomeDestino                   LIKE int-processo-imp.NomeDestino
    FIELD NumeroNotaFiscalPrevista      LIKE int-prazo-compra.nro-docto   
    FIELD SerieNotaFiscalPrevista       LIKE int-prazo-compra.serie-docto 
    FIELD CodigoCKD                     LIKE int-pedido-compr.cod-produto-ckd
    FIELD QuantidadeCKD                 LIKE int-pedido-compr.qtd-pedido-ckd
    /*FIELD TipoSDCV                      LIKE int-ordem-compra.sdc-tipo*/
    FIELD id-relac                      AS INTEGER XML-NODE-TYPE 'HIDDEN'
    FIELD ObservacaoLogistica           AS CHAR 
/*     FIELD LogLiberaAlteracaoComex       LIKE ext-embarque-imp.log-libera-alteracao */
    FIELD DataNecessidade               AS DATE
    FIELD DataEntregaIdeal              AS DATE
    INDEX idx1 IS UNIQUE PRIMARY NumeroPedidoCompra NumeroOrdemCompra SequenciaParcela.


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

DEFINE VARIABLE c-destination AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-inspecao   AS INTEGER     NO-UNDO.

{esp/imp/esimp000.i1} /*tt-emb*/
