{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0092 NO-UNDO XML-NODE-NAME 'MSG0092'
   FIELD idm                  AS INT XML-NODE-TYPE 'hidden'
   FIELD NumeroPedido         AS CHAR
   FIELD MotivoCancelamento   AS CHARACTER .
   
DEFINE TEMP-TABLE msg0092r NO-UNDO XML-NODE-NAME 'MSG0092R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
