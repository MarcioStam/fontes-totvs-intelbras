{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0198 NO-UNDO XML-NODE-NAME 'MSG0198'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroSerieProduto LIKE num-serie.n-serie        INITIAL ?
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0198R1 NO-UNDO XML-NODE-NAME 'MSG0198R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE Produto NO-UNDO XML-NODE-NAME 'Produto'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE num-serie.it-codigo
   FIELD Nome                  LIKE ITEM.desc-item
   FIELD DataFabricacao        AS DATE
   FIELD NumeroNotaFiscal      LIKE nota-fiscal.nr-nota-fis
   FIELD CodigoCliente         LIKE nota-fiscal.cod-emitente
   FIELD NomeRazaoSocial       LIKE emitente.nome-abrev
   FIELD DataEmissao           LIKE nota-fiscal.dt-emis-nota
   FIELD NumeroPedido          LIKE nota-fiscal.nr-pedcli
   FIELD NumeroSerie           LIKE nota-fiscal.serie
   FIELD CpfCnpjCodEstrangeiro LIKE nota-fiscal.cgc
   FIELD PrecoUnitario         LIKE it-nota-fisc.vl-preuni
   FIELD AliquotaIPI           LIKE it-nota-fisc.aliquota-ipi
   FIELD ValorIPI              LIKE it-nota-fisc.vl-ipi-it
   FIELD AliquotaICMS          LIKE it-nota-fisc.aliquota-icm
   FIELD ValorICMS             LIKE it-nota-fisc.vl-icms-it.


/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
