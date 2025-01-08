{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0036 NO-UNDO XML-NODE-NAME 'MSG0036'
   FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoFamiliaComercial AS CHARACTER
   FIELD Nome                   AS CHARACTER
   FIELD Segmento               AS CHARACTER
   FIELD Familia                AS CHARACTER
   FIELD SubFamilia             AS CHARACTER
   FIELD Origem                 AS CHARACTER
   FIELD Situacao               AS INTEGER.

DEFINE TEMP-TABLE msg0036r NO-UNDO XML-NODE-NAME 'MSG0036R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
