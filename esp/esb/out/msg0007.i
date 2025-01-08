{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0007 NO-UNDO XML-NODE-NAME 'MSG0007'
    FIELD idm                     AS INT XML-NODE-TYPE 'hidden'
    FIELD ChaveIntegracao         AS CHARACTER FORMAT "x(50)".
    
DEFINE TEMP-TABLE msg0007r NO-UNDO XML-NODE-NAME 'MSG0007R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
