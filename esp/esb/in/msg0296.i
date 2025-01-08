{esp/esb/esesb000.i}

DEFINE TEMP-TABLE MSG0296 NO-UNDO XML-NODE-NAME 'MSG0296'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto AS CHAR
   FIELD DataInicio    AS DATE
   FIELD DataFinal     AS DATE.

DEFINE TEMP-TABLE MSG0296r1 NO-UNDO XML-NODE-NAME 'MSG0296R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE Produtos NO-UNDO XML-NODE-NAME 'Produtos'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'.
    
DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto             AS CHAR 
    FIELD NomeProduto               AS CHARACTER.

DEFINE TEMP-TABLE NumeroSeries NO-UNDO XML-NODE-NAME 'NumeroSeries'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'.
                                          
  
DEFINE TEMP-TABLE NumeroSerieItem NO-UNDO XML-NODE-NAME 'NumeroSerieItem'
    FIELD idm                        AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroSerieProduto         AS CHAR
    FIELD DataGerado                 AS DATE.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
