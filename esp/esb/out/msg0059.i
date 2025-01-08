{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0059 NO-UNDO XML-NODE-NAME 'MSG0059'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoContato          AS CHAR
    FIELD CodigoCliente          AS INT
    FIELD CodigoRepresentante    AS INT.
    
DEFINE TEMP-TABLE msg0059r NO-UNDO XML-NODE-NAME 'MSG0059R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
