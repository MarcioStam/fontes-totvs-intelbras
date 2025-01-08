{esp/esb/esesb000.i}

/*Entrada*/
DEFINE TEMP-TABLE msg0302 NO-UNDO XML-NODE-NAME 'MSG0302'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD TabelaPrecoEMS LIKE tb-preco.nr-tabpre. 

DEFINE TEMP-TABLE ListaItensTabelaPreco NO-UNDO XML-NODE-NAME 'ListaItensTabelaPreco'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ItemTabelaPreco NO-UNDO XML-NODE-NAME 'ItemTabelaPreco'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoProduto LIKE preco-item.it-codigo 
    FIELD Quantidade    AS DECIMAL.
   
/*Retorno*/
DEFINE TEMP-TABLE msg0302r NO-UNDO XML-NODE-NAME 'MSG0302R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ListaItensTabelaPrecoR NO-UNDO XML-NODE-NAME 'ListaItensTabelaPreco'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ItemTabelaPrecoR NO-UNDO XML-NODE-NAME 'ItemTabelaPreco'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoProduto         LIKE preco-item.it-codigo 
    FIELD Quantidade            AS DECIMAL
    FIELD ValorUnitario         LIKE preco-item.preco-venda[1]
    FIELD ValorTotalSemImposto  LIKE preco-item.preco-venda[1]
    FIELD PercentualDesconto    LIKE preco-item.desco-quant.

/*Outras*/
