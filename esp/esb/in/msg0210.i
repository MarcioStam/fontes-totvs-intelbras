{esp/esb/esesb000.i}
{method/dbotterr.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0210 NO-UNDO XML-NODE-NAME 'MSG0210'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaComprador LIKE pedido-compr.responsave.

DEFINE TEMP-TABLE CancelarPedidoCompra NO-UNDO XML-NODE-NAME 'CancelarPedidoCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido INITIAL ?
   FIELD MotivoCancelamento AS CHAR.
   
DEFINE TEMP-TABLE CancelarOrdemCompra NO-UNDO XML-NODE-NAME 'CancelarOrdemCompra'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido INITIAL ? XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra  LIKE ordem-compra.numero-ordem
   FIELD MotivoCancelamento AS CHAR.

DEFINE TEMP-TABLE CancelarParcela NO-UNDO XML-NODE-NAME 'CancelarParcela'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido   INITIAL ? XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroOrdemCompra  LIKE ordem-compra.numero-ordem XML-NODE-TYPE 'HIDDEN'
   FIELD SequenciaParcela   LIKE prazo-compra.parcela
   FIELD MotivoCancelamento AS CHAR.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0210_R1 NO-UNDO XML-NODE-NAME 'MSG0210R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-motivo-elimina NO-UNDO
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD numero-ordem LIKE prazo-compra.numero-ordem
    FIELD motivo       AS CHAR.

DEFINE TEMP-TABLE tt-prazo-eliminado LIKE prazo-compra
    FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-bocx140 AS HANDLE      NO-UNDO.
