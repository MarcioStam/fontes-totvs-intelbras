{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0038 NO-UNDO XML-NODE-NAME 'MSG0038'
   FIELD idm                AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoGrupoEstoque AS INTEGER
   FIELD Nome               AS CHARACTER FORMAT "x(100)"
   field Situacao           as integer.
   
DEFINE TEMP-TABLE msg0038r NO-UNDO XML-NODE-NAME 'MSG0038R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
