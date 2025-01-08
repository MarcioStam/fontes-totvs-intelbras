{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0243 NO-UNDO XML-NODE-NAME 'MSG0243'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra        LIKE pedido-compr.num-pedido.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0243R1 NO-UNDO XML-NODE-NAME 'MSG0243R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
DEFINE VARIABLE h-bocx140 AS HANDLE      NO-UNDO.
