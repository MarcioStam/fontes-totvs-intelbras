DEFINE TEMP-TABLE msg0160 NO-UNDO XML-NODE-NAME 'MSG0160'
    FIELD idm  AS INT XML-NODE-TYPE 'hidden'.

   
DEFINE TEMP-TABLE msg0160r NO-UNDO XML-NODE-NAME 'MSG0160R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE temp-table msg0160r-FormaPagamentoItens no-undo xml-node-name 'FormaPagamentoItens'
   field idm as int xml-node-type 'hidden'.
   
DEFINE temp-table msg0160r-FormaPagamentoItem no-undo xml-node-name 'FormaPagamentoItem'
   field idm as int xml-node-type 'hidden'
   FIELD CodigoFormaPagamento  AS CHAR FORMAT "X(36)"
   field NomeFormaPagamento    AS CHAR FORMAT "X(100)".
   


