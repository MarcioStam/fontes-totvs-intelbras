DEFINE TEMP-TABLE ttNotaFiscal XML-NODE-NAME "NotaFiscal" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD numeroPedido    AS CHAR
   FIELD pedidoCliente   AS CHAR /*Vtex*/
   FIELD estabelecimento AS CHAR
   FIELD serie           AS CHAR
   FIELD numeroNota      AS CHAR
   FIELD dataEmissao     AS DATE
   FIELD valorNota       AS DEC
   FIELD chaveAcesso     AS CHAR.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttNotaFiscal.
