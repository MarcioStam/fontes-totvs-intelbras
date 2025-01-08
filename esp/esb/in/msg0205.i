{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0205 NO-UNDO XML-NODE-NAME 'MSG0205'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD DataPedido                    AS DATE
   FIELD MatriculaComprador            LIKE usuar_mestre.cod_usuar
   FIELD CodigoMensagemPedido          LIKE pedido-compr.cod-mensagem
   FIELD GerarProcessoImportacao       AS LOG
   FIELD GerarEmbarque                 AS LOG
   FIELD TipoFrete                     AS INT
   .

DEFINE TEMP-TABLE MSG0205OrdensCompra NO-UNDO XML-NODE-NAME 'OrdensCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra       LIKE prazo-compra.numero-ordem.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0205R1 NO-UNDO XML-NODE-NAME 'MSG0205R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE MSG_Pedido_R1 NO-UNDO XML-NODE-NAME 'PedidoCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra      LIKE pedido-compr.num-pedido
   FIELD CodigoFornecedorEMS     LIKE pedido-compr.cod-emitente
   FIELD NomeAbreviadoFornecedor LIKE emitente.nome-abrev.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

define temp-table tt-digita
    field marca          as char format "x(01)"  COLUMN-LABEL ""
    field numero-ordem   like ordem-compra.numero-ordem
    field it-codigo      like ordem-compra.it-codigo
    field qt-solic       like ordem-compra.qt-solic
    field cod-emitente   like ordem-compra.cod-emitente
    field cod-estabel    like ordem-compra.cod-estabel
    field cod-comprado   like ordem-compra.cod-comprado
    field nr-processo    like ordem-compra.nr-processo
    field num-pedido     like ordem-compra.num-pedido
    field natureza       like ordem-compra.natureza
    field cod-transp     like ordem-compra.cod-transp
    field data-cotacao   like ordem-compra.data-cotacao
    field cod-cond-pag   like ordem-compra.cod-cond-pag
    field ordem-servic   like ordem-compra.ordem-servic
    field cod-incoterm   as char
    index id is primary unique numero-ordem.


DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

/* Preprocessador de Distribui‡Æo (Materiais) */
{cdp/cdcfgmat.i}

/*tt-param" */
{ccp/cc0311.i3}

