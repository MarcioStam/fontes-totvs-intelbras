{esp/esb/esesb000.i}
{cdp/cdcfgmat.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0222 NO-UNDO XML-NODE-NAME 'MSG0222'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra            LIKE pedido-compr.num-pedido
   FIELD LogLiberaItinerarioComex      LIKE int-processo-imp.log-libera-itinerario.

DEFINE TEMP-TABLE OrdemCompra NO-UNDO XML-NODE-NAME 'OrdemCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra     LIKE ordem-compra.numero-ordem INITIAL ?
   FIELD CodigoProduto         LIKE ordem-compra.it-codigo
   FIELD CodigoUnidadeNegocio  LIKE ordem-compra.cod-unid-negoc
   FIELD CodigoDepositoOrdem   LIKE ordem-compra.dep-almoxar
   FIELD MatriculaComprador    LIKE ordem-compra.cod-comprado
   FIELD NumeroOrdemServico    LIKE ordem-compra.ordem-servic
   FIELD MatriculaRequisitante LIKE ordem-compra.requisitante
   FIELD CodigoContaContabil   LIKE ordem-compra.ct-codigo
   FIELD CodigoCentroCusto     LIKE ordem-compra.sc-codigo
   FIELD CodigoTipoDespesa     LIKE ordem-compra.tp-despesa
   FIELD NarrativaOrdemCompra  LIKE ordem-compra.narrativa
   FIELD GerarItemFornecedor   AS LOG.

DEFINE TEMP-TABLE Cotacao NO-UNDO XML-NODE-NAME 'Cotacao'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoUnidadeMedidaFornecedor LIKE cotacao-item.un
   FIELD PrecoFornecedor               LIKE cotacao-item.preco-fornec
   FIELD IPIIncluso                    LIKE cotacao-item.codigo-ipi
   FIELD AliquotaIPI                   LIKE cotacao-item.aliquota-ipi
   FIELD TipoICMS                      LIKE cotacao-item.codigo-icm
   FIELD AliquotaICMS                  LIKE cotacao-item.aliquota-icm
   FIELD AliquotaISS                   LIKE cotacao-item.aliquota-iss
   FIELD NomeContato                   LIKE cotacao-item.contato
   FIELD FreteIncluso                  LIKE cotacao-item.frete
   FIELD ValorFrete                    LIKE cotacao-item.valor-frete
   FIELD TaxaFinanceira                LIKE cotacao-item.valor-taxa
   FIELD EncargosFinanceiros           LIKE cotacao-item.taxa-financ
   FIELD DiasTaxaFinanceira            LIKE cotacao-item.nr-dias-taxa
   FIELD PrazoEntrega                  LIKE cotacao-item.prazo-entreg
   FIELD CodigoMoedaEMS                LIKE cotacao-item.mo-codigo.

DEFINE TEMP-TABLE CotacaoItemImportado NO-UNDO XML-NODE-NAME 'CotacaoItemImportado'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoIncoterm             LIKE cotacao-item.cod-incoterm        
   FIELD CodigoPontoControleBase    LIKE cotacao-item.cod-pto-contr       
   FIELD CodigoFabricante           AS INT /* int(SUBSTRING(cotacao-item.char-2,41,9))*/
   FIELD PaisOrigem                 LIKE mgcad.pais.nome-pais
   FIELD NCM                        LIKE cotacao-item.class-fiscal        
   FIELD DestaqueNCM                LIKE int-cotacao-item.destaque       
   FIELD AliquotaII                 LIKE cotacao-item.aliquota-ii             
   FIELD CodigoItinerario           LIKE cotacao-item.int-1               
   FIELD NVE                        LIKE int-cotacao-item.nve             
   FIELD EXTarifario                LIKE int-item.ex-tarifario            
   FIELD NecessitaLicencaImportacao LIKE int-cotacao-item.log-necessita-li
   FIELD GATT                       LIKE int-cotacao-item.log-gatt        
   FIELD PercentualGATT             LIKE int-item.perc-gatt.

DEFINE TEMP-TABLE ParcelaManual NO-UNDO XML-NODE-NAME 'Parcela'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD DataParcela       LIKE prazo-compra.data-entrega
   FIELD QuantidadeParcela LIKE prazo-compra.quantidade.


/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0222R1 NO-UNDO XML-NODE-NAME 'MSG0222R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido INITIAL ?
   FIELD NumeroOrdemCompra  LIKE NumeroOrdemCompra INITIAL ?.

/*Outras Defini‡äes*/
DEFINE VARIABLE i-num-ordem AS INTEGER     NO-UNDO.
DEFINE VARIABLE hboin274sd  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082sd  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin356ca  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082ca  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin295    AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-indice   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-discard   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-discard   AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
    FIELD r-rowid AS ROWID.

{utp/ut-glob.i}
{ccp/ccapi202.i}  /*tt-ordem-compra tt-prazo-compra*/
{ccp/ccapi207.i}  /*tt-cotacao-item*/  
{cdp/cdapi300.i1} /*tt-erros-geral*/
{method/dbotterr.i}

