{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0101 NO-UNDO XML-NODE-NAME 'MSG0101'
   FIELD idm                         AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD Conta                       AS CHAR.
   
DEFINE TEMP-TABLE ProdutosItens NO-UNDO XML-NODE-NAME 'ProdutosItens'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto               AS CHAR
    FIELD Moeda                       AS CHAR 
    FIELD Quantidade                  AS DEC
    FIELD TipoPortfolio               AS INTEGER
    FIELD CodigoUnidadeNegocio        AS CHAR
    FIELD CodigoFamiliaComercial      AS CHAR
    FIELD CodigoEstabelecimento       AS CHAR.

DEFINE TEMP-TABLE msg0101r NO-UNDO XML-NODE-NAME 'MSG0101R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutosItensR NO-UNDO XML-NODE-NAME 'ProdutosItens'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD PrecoBase                AS DEC
    FIELD ValorProduto             AS DEC
    FIELD NomePoliticaComercial    AS CHAR
    FIELD TemCache                 AS LOGICAL
    FIELD DataValidade             AS DATE
    FIELD QuantidadeMaxima         AS DEC
    FIELD RebateAntecipado         AS LOGICAL
    FIELD CalcularRebate             AS LOGICAL
    FIELD PrecoAlterado              AS LOGICAL
    FIELD ValorComDesconto           AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.





