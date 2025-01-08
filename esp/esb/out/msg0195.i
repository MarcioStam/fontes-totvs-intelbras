
DEFINE TEMP-TABLE msg0195 NO-UNDO XML-NODE-NAME 'MSG0195'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD TabelaPrecoEMS    AS CHAR
    FIELD NomeTabela        AS CHAR
    FIELD DataInicial       AS DATE
    FIELD DataFinal         AS DATE
    FIELD CodigoMoeda       AS INT
    FIELD NomeMoeda         AS CHAR
    FIELD SituacaoTabela    AS INT
    FIELD CodigoProduto     AS CHAR 
    FIELD CodigoItemPreco   AS CHAR 
    FIELD PMA               AS DECIMAL DECIMALS 2   
    FIELD PMD               AS DECIMAL DECIMALS 2   
    FIELD PrecoFOB          AS DECIMAL DECIMALS 5
    FIELD PrecoMinimoCIF    AS DECIMAL DECIMALS 5
    FIELD PrecoMinimoFOB    AS DECIMAL DECIMALS 5
    FIELD PrecoUnico        AS DECIMAL DECIMALS 2
    FIELD PrecoVenda        AS DECIMAL DECIMALS 2
    FIELD QuantidadeMinima  AS DECIMAL DECIMALS 4
    FIELD SituacaoItem      AS INT.

  
DEFINE TEMP-TABLE msg0195r NO-UNDO XML-NODE-NAME 'MSG0195R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD proprietario                          AS CHAR
   FIELD tipo-proprietario                     AS CHAR.





































