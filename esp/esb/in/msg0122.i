{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0122 NO-UNDO XML-NODE-NAME 'MSG0122'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoCategoriaCanal          AS CHAR
   FIELD Nome                          AS CHAR
   FIELD UnidadeNegocio                AS CHAR
   FIELD Conta                         AS CHAR
   FIELD Categoria                     AS CHAR
   FIELD Classificacao                 AS CHAR
   FIELD SubClassificacao              AS CHAR
   FIELD Situacao                      AS INT INIT 0
   FIELD Proprietario                  AS CHAR
   FIELD TipoProprietario              AS CHAR.


DEFINE TEMP-TABLE msg0122r1 NO-UNDO XML-NODE-NAME 'MSG0122R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

