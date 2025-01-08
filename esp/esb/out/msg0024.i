{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0024 NO-UNDO XML-NODE-NAME 'MSG0024'
   FIELD idm            AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoPortador AS INTEGER
   FIELD Nome           AS CHARACTER
   field Situacao       as integer.
   
DEFINE TEMP-TABLE msg0024r NO-UNDO XML-NODE-NAME 'MSG0024R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
