DEFINE TEMP-TABLE ttProduto  XML-NODE-NAME "Produto" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.
   
DEFINE TEMP-TABLE ttPreco  XML-NODE-NAME "Preco"
   FIELD idm           AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD codigoProduto LIKE preco-item.it-codigo .

/*
DEFINE TEMP-TABLE ListaItensTabelaPreco NO-UNDO XML-NODE-NAME 'ListaItensTabelaPreco'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.
*/
DEFINE TEMP-TABLE ItemTabelaPreco XML-NODE-NAME 'ItemTabelaPreco' 
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD tabelaPreco          LIKE preco-item.nr-tabpre
    FIELD quantidade           AS DECIMAL
    FIELD valorUnitario        LIKE preco-item.preco-venda[1]
    FIELD valorTotalSemImposto LIKE preco-item.preco-venda[1]
    FIELD percentualDesconto   LIKE preco-item.desco-quant
    FIELD inicioValidade       AS DATETIME-TZ
    FIELD fimValidade          AS DATETIME-TZ.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttProduto, ttPreco,  ItemTabelaPreco
   DATA-RELATION FOR ttProduto, ttPreco                     RELATION-FIELDS (idm, idm) NESTED
   /*DATA-RELATION FOR ttPreco, ListaItensTabelaPreco         RELATION-FIELDS (idm, idm) NESTED*/
   DATA-RELATION FOR ttPreco, ItemTabelaPreco RELATION-FIELDS (idm, idm) NESTED.
