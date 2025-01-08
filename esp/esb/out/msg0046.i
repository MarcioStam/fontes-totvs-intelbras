{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0046 NO-UNDO XML-NODE-NAME 'MSG0046'
    FIELD idm                 AS INT XML-NODE-TYPE 'hidden'
    FIELD ChaveIntegracao     AS character
    FIELD Indice              AS DECIMAL
    field Nome                as character
    FIELD NumeroDias          AS INTEGER
    FIELD TabelaFinanciamento AS INTEGER
    field Situacao            as integer.
    
DEFINE TEMP-TABLE msg0046r NO-UNDO XML-NODE-NAME 'MSG0046R'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
