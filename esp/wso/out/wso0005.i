DEFINE TEMP-TABLE ttNotaFiscal XML-NODE-NAME "NotaFiscal" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD numeroPedido    AS CHAR
   FIELD pedidoCliente   AS CHAR /*Vetex*/
   FIELD estabelecimento AS CHAR
   FIELD serie           AS CHAR
   FIELD numeroNota      AS CHAR
   FIELD dataEmissao     AS DATE
   FIELD valorNota       AS DEC
   FIELD chaveAcesso     AS CHAR.

DEFINE TEMP-TABLE ttItemNota XML-NODE-NAME "Item" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD codigoItem    AS CHAR
   FIELD quantidade    AS DEC DECIMALS 10
   FIELD precoItem     AS DEC DECIMALS 10.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttNotaFiscal, ttItemNota
    DATA-RELATION FOR ttNotaFiscal, ttItemNota RELATION-FIELDS (idm, idm) NESTED.
