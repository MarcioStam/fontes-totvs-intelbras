{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0018 NO-UNDO XML-NODE-NAME 'MSG0018'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoCategoria        AS CHAR
   FIELD Nome                          AS CHAR
   FIELD Codigo                        AS CHAR
   FIELD Situacao                      AS INT INIT 0.

DEFINE TEMP-TABLE msg0018r1 NO-UNDO XML-NODE-NAME 'MSG0018R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.
