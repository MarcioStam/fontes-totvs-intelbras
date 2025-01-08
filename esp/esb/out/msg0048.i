{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0048 NO-UNDO XML-NODE-NAME 'MSG0048'
    FIELD idm                     AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoMensagemPedido    AS INTEGER
    FIELD Nome                    AS CHARACTER
    FIELD Texto                   AS character
    field Situacao                as integer.
    
DEFINE TEMP-TABLE msg0048r NO-UNDO XML-NODE-NAME 'MSG0048R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
