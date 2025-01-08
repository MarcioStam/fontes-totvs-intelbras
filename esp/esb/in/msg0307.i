{esp/es0018.i}
{esp/esb/esesb000.i}

/*Entrada*/
DEFINE TEMP-TABLE msg0307 NO-UNDO XML-NODE-NAME 'MSG0307'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CpfCnpjCodEstrangeiro LIKE emitente.cgc
   FIELD CodigoProduto         LIKE wt-It-docto.it-codigo
   FIELD PrecoItem             AS DEC 
   FIELD ValorOperadora        AS DEC
   FIELD DataPagamento         AS DATE
   FIELD IDPagamento           LIKE int-nota-fiscal.id-pagto-cartao
   FIELD Observacoes           AS CHAR. 

/*Retorno*/
DEFINE TEMP-TABLE msg0307r NO-UNDO XML-NODE-NAME 'MSG0307R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CpfCnpjCodEstrangeiro LIKE emitente.cgc
   FIELD CodigoEstabelecimento AS CHAR INITIAL ?
   FIELD NumeroSerie           AS CHAR INITIAL ?
   FIELD NumeroNotaFiscal      AS CHAR INITIAL ?
   FIELD Observacoes           AS CHAR INITIAL ?.

/*Outras*/
