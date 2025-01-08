{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0044 NO-UNDO XML-NODE-NAME 'MSG0044'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroTabelaFinanciamento AS CHARACTER
    FIELD DataInicioValidade        AS DATE
    FIELD DataFinalValidade         AS DATE 
    field Situacao                  as integer.
          
DEFINE TEMP-TABLE msg0044r NO-UNDO XML-NODE-NAME 'MSG0044R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
