{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0012 NO-UNDO XML-NODE-NAME 'MSG0012'
    FIELD idm              AS INT XML-NODE-TYPE 'hidden'
    FIELD ChaveIntegracao  AS CHARACTER
    FIELD Nome             AS CHARACTER
    FIELD Estado           AS CHARACTER
    FIELD CodigoIBGE       AS INTEGER  
    field Situacao         as integer.
 
DEFINE TEMP-TABLE msg0012r NO-UNDO XML-NODE-NAME 'MSG0012R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
