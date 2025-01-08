{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0221 NO-UNDO XML-NODE-NAME 'MSG0221'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE PesquisaEstrutura NO-UNDO XML-NODE-NAME 'Item'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE ITEM.it-codigo
   FIELD CodigoEstabelecimento LIKE estabelec.cod-estabel.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0221R1 NO-UNDO XML-NODE-NAME 'MSG0221R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE EstruturaItem_R NO-UNDO XML-NODE-NAME 'EstruturaItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE ITEM.it-codigo
   FIELD CodigoEstabelecimento LIKE estabelec.cod-estabel INITIAL ?.

DEFINE TEMP-TABLE SparePart NO-UNDO XML-NODE-NAME 'SparePart'
   FIELD CodigoProduto      LIKE ITEM.it-codigo  XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSparePart    LIKE ITEM.it-codigo.

DEFINE TEMP-TABLE Acessorio NO-UNDO XML-NODE-NAME 'Acessorio'
   FIELD CodigoProduto      LIKE ITEM.it-codigo  XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoAcessorio    LIKE ITEM.it-codigo.

DEFINE TEMP-TABLE Componente NO-UNDO XML-NODE-NAME 'Componente'
   FIELD CodigoProduto       LIKE ITEM.it-codigo  XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoComponente    LIKE ITEM.it-codigo.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura.
