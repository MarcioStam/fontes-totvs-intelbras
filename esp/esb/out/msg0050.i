{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0050 NO-UNDO XML-NODE-NAME 'MSG0050'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoNaturezaOperacao AS CHAR
    FIELD Nome                   AS CHARACTER FORMAT "x(100)"
    FIELD Tipo                   AS INTEGER
    FIELD Situacao               AS INTEGER
    FIELD EmiteDuplicata         AS LOGICAL
    FIELD AtualizaEstatistica    AS LOGICAL.
        
DEFINE TEMP-TABLE msg0050r NO-UNDO XML-NODE-NAME 'MSG0050R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
