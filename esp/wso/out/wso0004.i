DEFINE TEMP-TABLE ttPedidoAlteracao XML-NODE-NAME "PedidoAlteracao" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD numeroPedido    AS CHAR
   FIELD codigoLoja      AS INT
   FIELD status-ped      AS CHAR XML-NODE-NAME "status"
   FIELD motivoAlteracao AS CHAR
   FIELD totalDesconto   AS DEC DECIMALS 10
   FIELD totalAcrescimo  AS DEC DECIMALS 10.


DEF TEMP-TABLE ttItemPedido XML-NODE-NAME "Item"
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD codigoItem      AS CHAR
    FIELD quantidade      AS DEC DECIMALS 10
    FIELD precoItem       AS DEC DECIMALS 10
    FIELD tipoAlteracao   AS CHAR.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttPedidoAlteracao, ttItemPedido
    DATA-RELATION FOR ttPedidoAlteracao, ttItemPedido   RELATION-FIELDS (idm, idm) NESTED.
