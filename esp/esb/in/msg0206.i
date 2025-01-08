{esp/esb/esesb000.i}

/*Data set entrada*/
DEFINE TEMP-TABLE msg0206 NO-UNDO XML-NODE-NAME 'msg0206'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE embarque-imp.embarque
   FIELD CodigoEstabelecimento LIKE embarque-imp.cod-estabel
   FIELD MatriculaUsuario      LIKE usuar_mestre.cod_usuar
   FIELD I18N                  AS LOGICAL.

/*Data set retorno*/
DEFINE TEMP-TABLE msg0206R1 NO-UNDO XML-NODE-NAME 'MSG0206R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ExibePrecos AS LOG.

DEFINE TEMP-TABLE Embarque NO-UNDO XML-NODE-NAME 'Embarque'
   FIELD idm                          AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque               LIKE embarque-imp.embarque
   FIELD CodigoEstabelecimento        LIKE embarque-imp.cod-estabel
   FIELD SituacaoEmbarque             LIKE embarque-imp.situacao
   FIELD EmbarqueContabilizado        LIKE embarque-imp.contabilizado
   FIELD CodigoViaTransporte          LIKE embarque-imp.cod-via-transp
   FIELD CodigoIncoterm               LIKE embarque-imp.cod-incoterm
   FIELD Atrasado                     AS LOGICAL
   FIELD CodigoUltimoPontoControle    LIKE pto-contr.cod-pto-contr
   FIELD DescricaoUltimoPontoControle LIKE pto-contr.descricao
   FIELD DataUltimoPontoControle      LIKE historico-embarque.dt-efetiva
   FIELD CodigoItinerario             LIKE cotacao-item.int-1
   FIELD DescricaoItinerario          LIKE itinerario.descricao
   FIELD ValorEmbarque                AS DECIMAL 
   FIELD CodigoMoedaEMS               LIKE cotacao-item.mo-codigo
   FIELD NomeMoeda                    LIKE moeda.descricao
   FIELD Narrativa                    LIKE embarque-imp.narrativa
   FIELD CodigoCondicaoPagamento      LIKE pedido-compr.cod-cond-pag
   FIELD NomeCondicaoPagamento        LIKE cond-pagto.descricao
   FIELD CodigoFornecedorEMS          LIKE pedido-compr.cod-emitente INITIAL ?
   FIELD NomeAbreviadoFornecedor      LIKE emitente.nome-abrev
   FIELD DataPrevisaoEntrega          AS DATE
   FIELD DataPrevisaoChegada          AS DATE
   FIELD DataNecessidadeFabrica       AS DATE /*Campo novo*/
   FIELD Master                       LIKE embarque-imp.cod-conhecto-master
   FIELD House                        LIKE embarque-imp.cod-conhecto-house
   FIELD CodigoTransportadora         LIKE embarque-imp.cod-transportador
   FIELD NomeTransportadora           LIKE transporte.nome-abrev
   FIELD CodigoCorretorCambio         LIKE embarque-imp.cdn-corretor-cambio-import
   FIELD NomeCorretorCambio           LIKE emitente.nome-abrev
   FIELD CodigoDespachante            LIKE embarque-imp.cod-despachante
   FIELD NomeDespachante              LIKE emitente.nome-abrev
   FIELD CodigoDespachanteExterior    LIKE embarque-imp.cdn-despa-exter-import
   FIELD NomeDespachanteExterior      LIKE emitente.nome-abrev
   FIELD CodigoSeguradora             LIKE embarque-imp.cdn-segurad-import
   FIELD NomeSeguradora               LIKE emitente.nome-abrev
   FIELD CodigoCorretorSeguro         LIKE embarque-imp.cdn-corretor-import
   FIELD NomeCorretorSeguro           LIKE emitente.nome-abrev
   FIELD TipoContainer                LIKE ext-embarque-imp.conteiner
   FIELD Quantidade1Container         LIKE ext-embarque-imp.qtd-conteiner
   FIELD Quantidade2Container         LIKE ext-embarque-imp.qtd2-conteiner
   FIELD MatriculaResponsavel         LIKE usuar_mestre.cod_usuar
   FIELD NomeResponsavel              LIKE usuar_mestre.nom_usuar
   FIELD PossuiAnexos                 AS LOG
   FIELD StatusEmbarque               AS INTEGER
   FIELD LogItinerarioIntegraComex    LIKE int-itinerario.log-integra-comex
   FIELD LogEnvioComex                LIKE ext-embarque-imp.log-envio-comex
   FIELD LogLiberaAlteracaoComex      LIKE ext-embarque-imp.log-libera-alteracao
   FIELD LogLiberaModalComex          LIKE ext-embarque-imp.log-libera-modal
   FIELD FinalidadeCourier            AS i.

DEFINE TEMP-TABLE FinanceiroFiscal NO-UNDO XML-NODE-NAME 'FinanceiroFiscal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ROF                         LIKE embarque-imp.nr-rof
   FIELD DISiscomex                  LIKE embarque-imp.declaracao-import  
   FIELD DIEMS                       LIKE embarque-imp.int-2
   FIELD DataDI                      LIKE embarque-imp.data-di
   FIELD NaturezaCambial             LIKE embarque-imp.int-1
   FIELD NumeroCartaCredito          LIKE embarque-imp.carta-credito
   FIELD CodigoBanco                 LIKE embarque-imp.cod-banco
   FIELD NomeBanco                   LIKE mgcad.banco.nome-banco
   FIELD DataSolicitacaoCartaCredito LIKE ext-embarque-imp.DataSolicitacaoCartaCredito
   FIELD DataAprovacaoCartaCredito   LIKE ext-embarque-imp.DataAprovacaoCartaCredito  
   FIELD DataValidadeCartaCredito    LIKE ext-embarque-imp.DataValidadeCartaCredito   
   FIELD DeadlineCartaCredito        LIKE ext-embarque-imp.DeadlineCartaCredito       
   FIELD ValorCartaCredito           LIKE ext-embarque-imp.ValorCartaCredito          
   FIELD CodigoMoedaEMS              LIKE ext-embarque-imp.CodigoMoedaEMS             
   FIELD NomeMoeda                   LIKE moeda.descricao.

DEFINE TEMP-TABLE PontoControle NO-UNDO XML-NODE-NAME 'PontoControle'
   FIELD idm                               AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoPontoControle               LIKE historico-embarque.cod-pto-contr
   FIELD SequenciaPontoControle            LIKE historico-embarque.sequencia
   FIELD DescricaoPontoControle            LIKE pto-contr.descricao 
   FIELD DataPrevOriginalPontoControle     LIKE historico-embarque.dt-previsao
   FIELD DataUltimaPrevisaoPontoControle   LIKE historico-embarque.dt-ult-previsao
   FIELD IntegrouDI                        AS LOG
   FIELD DataEfetivaPontoControle          LIKE historico-embarque.dt-efetiva
   FIELD VeiculoTransporte                 LIKE historico-embarque.id-meio-transp
   FIELD ObservacoesPontoControle          LIKE historico-embarque.observacao
   FIELD CodigoTipoPontoControle           AS INTEGER.

DEFINE TEMP-TABLE ParcelaEmbarque NO-UNDO XML-NODE-NAME 'ParcelaEmbarque'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra            LIKE ordem-compra.num-pedido
   FIELD NumeroOrdemCompra             LIKE prazo-compra.numero-ordem
   FIELD SequenciaParcela              LIKE prazo-compra.parcela
   FIELD QuantidadeParcela             LIKE prazo-compra.quantidade
   FIELD DataParcela                   LIKE prazo-compra.data-entrega
   FIELD CodigoUnidadeMedida           LIKE prazo-compra.un
   FIELD NumeroLIAnuida                LIKE licenciam-import-oc.licenca-import
   FIELD ValidadeLI                    AS DATE /*Campo Novo*/
   FIELD NecessitaLI                   LIKE item.log-necessita-li
   FIELD CodigoProduto                 LIKE prazo-compra.it-codigo
   FIELD NomeProduto                   LIKE ITEM.desc-item
   FIELD QuantidadeFornecedor          LIKE prazo-compra.qtd-do-forn
   FIELD CodigoUnidadeMedidaFornecedor LIKE item-fornec-estab.unid-med-for
   FIELD CodigoCondicaoPagamento       LIKE pedido-compr.cod-cond-pag
   FIELD NomeCondicaoPagamento         LIKE cond-pagto.descricao
   FIELD NCM                           LIKE cotacao-item.class-fiscal
   FIELD NivelCriticidade              AS INT /*Campo novo*/
   FIELD PrecoFornecedor               LIKE cotacao-item.preco-fornec
   FIELD ValorParcela                  LIKE ordem-compra.preco-fornec
   FIELD CodigoMoedaEMS                LIKE moeda.mo-codigo
   FIELD NomeMoeda                     LIKE moeda.descricao
   FIELD ObservacaoLogistica           AS CHAR.

DEFINE TEMP-TABLE Despesa NO-UNDO XML-NODE-NAME 'Despesa'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'       
   FIELD CodigoDespesa           LIKE desp-embarque.cod-desp
   FIELD DescricaoDespesa        LIKE desp-imp.descricao
   FIELD CodigoPontoControle     LIKE desp-embarque.cod-pto-contr
   FIELD DescricaoPontoControle  LIKE pto-contr.descricao
   FIELD CodigoFornecedorEMS     LIKE desp-embarque.cod-emitente-desp
   FIELD NomeAbreviadoFornecedor LIKE emitente.nome-abrev
   FIELD CodigoCondicaoPagamento LIKE desp-embarque.cod-cond-pag
   FIELD NomeCondicaoPagamento   LIKE cond-pagto.descricao
   FIELD CodigoMoedaEMS          LIKE desp-embarque.mo-codigo
   FIELD NomeMoeda               LIKE moeda.descricao
   FIELD ValorDespesa            LIKE desp-embarque.val-desp.

DEFINE TEMP-TABLE CommercialInvoice NO-UNDO XML-NODE-NAME 'CommercialInvoice'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'       
   FIELD NumeroCommercialInvoice  LIKE invoice-emb-imp.nr-invoice 
   FIELD ParcelaCommercialInvoice LIKE invoice-emb-imp.parcela
   FIELD DataCommercialInvoice    LIKE invoice-emb-imp.dt-vencim
   FIELD ValorCommercialInvoice   LIKE invoice-emb-imp.vl-invoice
   FIELD CodigoMoedaEMS           LIKE invoice-emb-imp.mo-codigo
   FIELD NomeMoeda                LIKE moeda.descricao
   FIELD Recebida                 LIKE pagamento.recebido-ap
   FIELD DataFFT                  AS DATE /*Campo novo*/
   FIELD NumeroContratoCambio     LIKE pagamento.nr-cont-cambio
   FIELD DataFechamentoCambio     LIKE pagamento.dt-fecha-cam
   FIELD NumeroCIPagamento        LIKE pagamento-invoice.nr-pagamento.

DEFINE TEMP-TABLE LI NO-UNDO XML-NODE-NAME 'LI'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'   
   FIELD NumeroOrdemCompra        LIKE licenciam-import-oc.numero-ordem
   FIELD SequenciaParcela         LIKE licenciam-import-oc.parcela
   FIELD QuantidadeParcela        LIKE prazo-compra.quantidade
   FIELD CodigoProduto            LIKE licenciam-import-oc.cod-livre-1
   FIELD NumeroProcessoImportacao LIKE pedido-compr.num-pedido /*Numero do pedido ou do processo de importa‡Æo*/
   FIELD NCM                      LIKE licenciam-import-oc.cod-livre-2
   FIELD NumeroLIAnuida           LIKE licenciam-import-oc.licenca-import
   FIELD ValidadeLI               AS DATE /*Campo novo*/.

/*Outras defini‡äes*/
DEFINE BUFFER b-moeda FOR moeda.

{esp/imp/esimp000.i1} /*tt-emb*/
 
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE l-integra-di  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-bocx384     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx120     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx351     AS HANDLE      NO-UNDO.
DEFINE VARIABLE cLocal        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-eadi        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-solicita-li AS LOGICAL     NO-UNDO.
