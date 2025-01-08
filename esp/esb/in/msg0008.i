{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0008 NO-UNDO XML-NODE-NAME 'MSG0008'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoRegiaoGeografica        AS CHAR
   FIELD Nome                          AS CHAR
   FIELD Situacao                      AS INT INIT 0.

DEFINE TEMP-TABLE msg0008r NO-UNDO XML-NODE-NAME 'MSG0008R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.
