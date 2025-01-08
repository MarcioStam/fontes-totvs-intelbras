{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0028 NO-UNDO XML-NODE-NAME 'MSG0028'
   FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
   field CodigoFamilia          as character
   FIELD Nome                   AS CHARACTER
   FIELD Segmento               AS CHARACTER
   field Situacao               as integer.
   
DEFINE TEMP-TABLE msg0028r NO-UNDO XML-NODE-NAME 'msg0028R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
