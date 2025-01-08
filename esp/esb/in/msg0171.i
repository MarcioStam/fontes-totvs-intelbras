{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0171 NO-UNDO XML-NODE-NAME 'MSG0171'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento AS CHAR.

DEFINE TEMP-TABLE msg0171r NO-UNDO XML-NODE-NAME 'MSG0171R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ItemCritico NO-UNDO XML-NODE-NAME 'ItemCritico'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto          AS CHAR
   FIELD NomeProduto            AS CHAR
   FIELD DataHoraSolicitacao    AS CHAR
   FIELD NomeSolicitante        AS CHAR
   FIELD CodigoDeposito         AS CHAR
   FIELD CodigoSolicitacaoItem  AS INTEGER
   FIELD EmAtendimento          AS CHAR.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
