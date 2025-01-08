{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0022 NO-UNDO XML-NODE-NAME 'MSG0022'
   FIELD idm                  AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoTransportadora AS INTEGER
   FIELD Nome                 AS CHARACTER 
   FIELD NomeAbreviado        AS CHARACTER
   FIELD Situacao             AS INTEGER
   FIELD CodigoViaTransporte  AS INTEGER.
   
DEFINE TEMP-TABLE msg0022r NO-UNDO XML-NODE-NAME 'MSG0022R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
