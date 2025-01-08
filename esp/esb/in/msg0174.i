{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0174 NO-UNDO XML-NODE-NAME 'MSG0174'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto                 LIKE item.it-codigo
   FIELD QuantidadeSolicitada          AS INTEGER
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0174R1 NO-UNDO XML-NODE-NAME 'MSG0174R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE MSG_Mac_R1 NO-UNDO XML-NODE-NAME 'EnderecoMacAddress'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoMacAddress  LIKE mac-address.mac
    .

/*Outras temp tables*/
