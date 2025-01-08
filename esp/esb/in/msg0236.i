{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0236 NO-UNDO XML-NODE-NAME 'MSG0236'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra     LIKE pedido-compr.num-pedido
   FIELD ConsultarSerialNumbers AS   LOGICAL
   FIELD ConsultarMacAddresses  AS   LOGICAL     
   .

DEFINE TEMP-TABLE ItensConsulta NO-UNDO XML-NODE-NAME 'ItensConsulta'
    FIELD idm AS INT XML-NODE-NAME 'HIDDEN'
    FIELD CodigoProduto LIKE ordem-compra.it-codigo
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0236R1 NO-UNDO XML-NODE-NAME 'MSG0236R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedidoCompra LIKE pedido-compr.num-pedido
    .

DEFINE TEMP-TABLE MSG_SN_R1 NO-UNDO XML-NODE-NAME 'SerialNumbers'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto LIKE ordem-compra.it-codigo
   FIELD SerialNumber  LIKE num-serie.n-serie
    .

DEFINE TEMP-TABLE MSG_Mac_R1 NO-UNDO XML-NODE-NAME 'MacAddresses'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto LIKE ordem-compra.it-codigo
   FIELD MacAddress    LIKE mac-address.mac
   FIELD SenhaWifi     AS CHAR
   FIELD SenhaAdm      AS CHAR
    .
/*Outras temp tables*/
