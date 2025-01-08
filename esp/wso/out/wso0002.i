DEFINE TEMP-TABLE ttProduto XML-NODE-NAME "Produto" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.
   
DEF TEMP-TABLE ttEstoque XML-NODE-NAME "Estoque"
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD sku             AS CHAR
    FIELD quantidade      AS DEC
    FIELD estabelecimento AS CHAR
    FIELD deposito        AS CHAR
    FIELD unidadeMedida   AS CHAR
    FIELD tabela          AS CHAR XML-NODE-TYPE 'HIDDEN'.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttProduto, ttEstoque
    DATA-RELATION FOR ttProduto, ttEstoque   RELATION-FIELDS (idm, idm) NESTED.
