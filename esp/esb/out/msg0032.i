{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0032 NO-UNDO XML-NODE-NAME 'MSG0032'
   FIELD idm          AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoOrigem AS CHARACTER
   FIELD Nome         AS CHARACTER
   FIELD SubFamilia   AS CHARACTER
   field Situacao     as integer.

DEFINE TEMP-TABLE msg0032r NO-UNDO XML-NODE-NAME 'MSG0032R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
