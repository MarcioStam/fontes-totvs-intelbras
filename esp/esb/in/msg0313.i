{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0313 NO-UNDO XML-NODE-NAME 'MSG0313'
   FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
   FIELD CpfCnpjCodEstrangeiro  AS CHAR FORMAT "x(19)"
   FIELD CodigoGrupoEconomico   AS CHAR FORMAT "x(50)"
   FIELD DataValidade           AS DATE /*CHAR FORMAT "x(20)"*/
   FIELD LimiteAdotado          AS DEC.

define temp-table msg0313r no-undo xml-node-name 'MSG0313R1'
   field idm as int xml-node-type 'hidden'.
