{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0211 NO-UNDO XML-NODE-NAME 'MSG0211'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra            LIKE pedido-compr.num-pedido INITIAL ?
   FIELD SituacaoAceitePedido          AS INT
   FIELD MotivoRejeicao                AS CHAR
   FIELD CodigoFornecedorEMS           LIKE pedido-compr.cod-emitente
   FIELD NaturezaPedido                LIKE pedido-compr.natureza
   FIELD PedidoEmergencial             LIKE pedido-compr.emergencial
   FIELD CodigoTipoPedido              LIKE int-pedido-compr.tp-pedido
   FIELD TipoFrete                     LIKE pedido-compr.frete
   FIELD CodigoTransportadora          LIKE pedido-compr.cod-transp
   FIELD CodigoViaTransporte           LIKE pedido-compr.via-transp
   FIELD CodigoEstabelecimentoEntrega  LIKE pedido-compr.end-entrega
   FIELD CodigoEstabelecimentoCobranca LIKE pedido-compr.end-cobranca
   FIELD CodigoCondicaoPagamento       LIKE pedido-compr.cod-cond-pag
   FIELD MatriculaResponsavel          LIKE pedido-compr.responsavel
   FIELD CodigoMensagemPedido          LIKE pedido-compr.cod-mensagem
   FIELD NarrativaPedido               LIKE pedido-compr.comentarios
   FIELD HistoricoPedidoCompra         AS CHAR
   FIELD CodigoCKD                     AS CHARACTER
   FIELD QuantidadeCKD                 AS DECIMAL .

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0211R1 NO-UNDO XML-NODE-NAME 'MSG0211R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
   FIELD r-rowid AS ROWID
   FIELD rownum  AS INT.

DEF TEMP-TABLE tt-processo-imp NO-UNDO LIKE mgcex.processo-imp
    FIELD r-rowid AS ROWID.

{method/dbotterr.i}
DEFINE VARIABLE h-boin295    AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-num-pedido AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-follow AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-header     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cabec      AS CHARACTER   NO-UNDO.
