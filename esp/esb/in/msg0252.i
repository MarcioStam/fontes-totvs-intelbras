{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0252 NO-UNDO XML-NODE-NAME 'MSG0252'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto      LIKE item-fabric.it-fabric.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0252R1 NO-UNDO XML-NODE-NAME 'MSG0252R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProduto      LIKE item-fabric.it-fabric.

DEFINE TEMP-TABLE ItemFabricante NO-UNDO XML-NODE-NAME 'ItemFabricante'
   FIELD idm                      AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoFabricante         LIKE fabricante.cod-fabric
   FIELD NomeFabricante           LIKE fabricante.nome-abrev
   FIELD PartNumberItemFabricante LIKE item-fabric.it-fabric.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

