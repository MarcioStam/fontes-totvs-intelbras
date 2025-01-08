
DEFINE TEMP-TABLE msg0192 NO-UNDO XML-NODE-NAME 'MSG0192'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoRepresentante AS INT
    FIELD NomeRepresentante   AS CHAR
    FIELD NomeAbreviado       AS CHAR
    FIELD Natureza            AS INT
    FIELD Situacao            AS INT
    FIELD Email               AS CHAR
    FIELD Site                AS CHAR.
  
DEFINE TEMP-TABLE msg0192-Endereco NO-UNDO XML-NODE-NAME 'EnderecoPrincipal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco        AS CHAR
   FIELD TipoEndereco        AS INTEGER
   FIELD CaixaPostal         AS CHAR
   FIELD CEP                 AS CHAR
   FIELD Logradouro          AS CHAR
   FIELD Numero              AS CHAR
   FIELD Complemento         AS CHAR
   FIELD Bairro              AS CHAR
   FIELD NomeCidade          AS CHAR
   FIELD Cidade              AS CHAR
   FIELD UF                  AS CHAR
   FIELD Estado              AS CHAR
   FIELD NomePais            AS CHAR
   FIELD Pais                AS CHAR
   FIELD NomeContato         AS CHAR
   FIELD Telefone            AS CHAR
   FIELD Fax                 AS CHAR.


DEFINE TEMP-TABLE msg0192-statusr NO-UNDO XML-NODE-NAME 'MSG0192R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD proprietario                          AS CHAR
   FIELD tipo-proprietario                     AS CHAR.



















