{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0054 NO-UNDO XML-NODE-NAME 'MSG0054'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoRota        AS character 
    FIELD Nome              AS CHARACTER
    FIELD Roteiro           AS CHARACTER
    field Situacao          as integer.
    
    
DEFINE TEMP-TABLE msg0054r NO-UNDO XML-NODE-NAME 'MSG0054R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
