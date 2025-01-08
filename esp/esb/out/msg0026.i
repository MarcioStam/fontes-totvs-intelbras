{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0026 NO-UNDO XML-NODE-NAME 'MSG0026'
   FIELD idm                AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoSegmento     AS CHARACTER FORMAT "x(20)"
   FIELD Nome               AS CHARACTER FORMAT "x(100)"
   FIELD UnidadeNegocio     AS CHARACTER FORMAT "x(20)"
   FIELD QuantidadeShowRoom AS INTEGER
   field Situacao           as integer.

DEFINE TEMP-TABLE msg0026r NO-UNDO XML-NODE-NAME 'MSG0026R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
