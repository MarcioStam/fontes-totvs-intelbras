{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0030 NO-UNDO XML-NODE-NAME 'MSG0030'
   FIELD idm              AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoSubFamilia AS CHARACTER
   FIELD Nome             AS CHARACTER
   FIELD Familia          AS CHARACTER
   field Situacao         as integer.
   
DEFINE TEMP-TABLE msg0030r NO-UNDO XML-NODE-NAME 'MSG0030R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
