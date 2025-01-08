{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0034 NO-UNDO XML-NODE-NAME 'MSG0034'
   FIELD idm                   AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoFamiliaMaterial AS CHARACTER FORMAT "x(100)"
   FIELD Nome                  AS CHARACTER FORMAT "x(150)"
   field Situacao              as integer.

DEFINE TEMP-TABLE msg0034r NO-UNDO XML-NODE-NAME 'MSG0034R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
