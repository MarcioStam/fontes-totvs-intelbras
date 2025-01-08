{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0244 NO-UNDO XML-NODE-NAME 'MSG0244'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedidoCompra     LIKE pedido-compr.num-pedido
   FIELD CadastrarSerialNumbers AS   LOGICAL
   FIELD CadastrarMacAddresses  AS   LOGICAL     
   .

DEFINE TEMP-TABLE MSG0244R1 NO-UNDO XML-NODE-NAME 'MSG0244R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    .

DEFINE TEMP-TABLE ItensConsulta NO-UNDO XML-NODE-NAME 'ItensConsulta'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoProduto LIKE ordem-compra.it-codigo
    .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-lista-ns
    FIELD num-serie AS CHAR FORMAT "X(13)".

DEFINE TEMP-TABLE tt-param
    FIELD usuario      AS CHARACTER
    FIELD destino      AS INTEGER
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD ind-execucao AS INTEGER
    FIELD num-pedido   AS INTEGER
    FIELD gera-ns      AS LOGICAL
    FIELD gera-mac     AS LOGICAL
    FIELD raw-param    AS RAW
    .

