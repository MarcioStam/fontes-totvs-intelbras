{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0172 NO-UNDO XML-NODE-NAME 'MSG0172'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio AS CHAR.
   

DEFINE TEMP-TABLE msg0172r1 NO-UNDO XML-NODE-NAME 'MSG0172R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0172r1-tit NO-UNDO XML-NODE-NAME 'TituloSolicitacao'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento      AS INT
   FIELD CNPJEstabelecimento        AS CHAR
   FIELD NumeroSerie                AS CHAR
   FIELD NumeroTitulo               AS CHAR
   FIELD NumeroParcela              AS CHAR
   FIELD CodigoConta                AS CHAR
   FIELD CodigoCliente              AS INT
   FIELD NomeConta                  AS CHAR
   FIELD DataVencimento             AS DATE
   FIELD ValorOriginal              AS DEC
   FIELD ValorAbatido               AS DEC
   FIELD SaldoTitulo                AS DEC .                                             .

