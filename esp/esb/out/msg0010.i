{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0010 NO-UNDO XML-NODE-NAME 'MSG0010'
    FIELD idm              AS INT XML-NODE-TYPE 'hidden'
    FIELD ChaveIntegracao  AS CHARACTER
    FIELD Sigla            AS CHARACTER
    FIELD Nome             AS CHARACTER
    FIELD Pais             AS CHARACTER
    /*field RegiaoGeografica as character*/
    field Situacao         as integer.
    
DEFINE TEMP-TABLE msg0010r NO-UNDO XML-NODE-NAME 'MSG0010R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
