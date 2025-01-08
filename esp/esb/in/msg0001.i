{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0001 NO-UNDO XML-NODE-NAME 'MSG0001'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD cep AS CHAR.

DEFINE TEMP-TABLE msg0001r NO-UNDO XML-NODE-NAME 'MSG0001R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE EnderecoCEP NO-UNDO XML-NODE-NAME 'EnderecoCEP'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CEP              AS CHAR
   FIELD Endereco         AS CHAR
   FIELD Bairro           AS CHAR
   FIELD Cidade           AS CHAR
   FIELD NomeCidade       AS CHAR
   FIELD Estado           AS CHAR
   FIELD UF               AS CHAR
   FIELD Pais             AS CHAR
   FIELD CidadeZonaFranca AS LOG
   FIELD CodigoIBGE       AS INT.



DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
