{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0314 NO-UNDO XML-NODE-NAME 'MSG0314'
   FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
   FIELD CpfCnpjCodEstrangeiro  AS CHAR FORMAT "x(19)"
   FIELD NomeSituacao           AS CHAR FORMAT "x(50)"
   FIELD CodigoCliente          AS INT  FORMAT 999999999
   FIELD NumeroPedido           AS CHAR FORMAT "x(12)"
   FIELD NomeClassificacao      AS CHAR FORMAT "x(40)"
   FIELD DataAlteracaoSituacao  AS CHAR FORMAT "x(20)" /*DATETIME*/
   FIELD NomePolitica           AS CHAR FORMAT "x(40)"
   FIELD CodigoSituacao         AS CHAR FORMAT "x(50)"
   FIELD CodigoMotivo           AS CHAR FORMAT "x(50)".

DEFINE TEMP-TABLE msg0314-ListaMotivo NO-UNDO XML-NODE-NAME 'ListaMotivo'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoMotivo       AS CHAR FORMAT "x(50)"
   FIELD NomeMotivo         AS CHAR FORMAT "x(50)"
   FIELD RegistroRemovido   AS CHAR.

define temp-table msg0314r no-undo xml-node-name 'MSG0314R1'
   field idm as int xml-node-type 'hidden'.
