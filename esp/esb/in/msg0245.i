{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0245 NO-UNDO XML-NODE-NAME 'MSG0245'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoFornecedorEMS      LIKE emitente.cod-emitente
   FIELD CodigoProduto            LIKE ITEM.it-codigo
   FIELD PartNumberItemFabricante LIKE item-fabric.it-fabric.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0245R1 NO-UNDO XML-NODE-NAME 'MSG0245R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoFornecedorEMS      LIKE emitente.cod-emitente.

DEFINE TEMP-TABLE ItensFornecedor NO-UNDO XML-NODE-NAME 'ItensFornecedor'
   FIELD idm                   AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto         LIKE ITEM.it-codigo
   FIELD CodigoFamiliaMaterial LIKE ITEM.fm-codigo.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

