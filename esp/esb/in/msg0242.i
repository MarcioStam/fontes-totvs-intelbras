{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0242 NO-UNDO XML-NODE-NAME 'MSG0242'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ProcessoImportacao NO-UNDO XML-NODE-NAME 'ProcessoImportacao'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoDespachante         LIKE processo-imp.cod-despachante
   FIELD CodigoAgenteCargas        LIKE processo-imp.cod-agente
   FIELD CodigoItinerario          LIKE processo-imp.cod-itiner
   FIELD CodigoIdioma              LIKE processo-imp.cod-idioma
   FIELD CodigoCorretorCambio      LIKE processo-imp.cdn-corretor-cambio-import 
   FIELD CodigoDespachanteExterior LIKE processo-imp.cdn-despa-exter-import
   FIELD CodigoSeguradora          LIKE processo-imp.cdn-segurad-import 
   FIELD CodigoCorretorSeguro      LIKE processo-imp.cdn-corretor-import
   FIELD NomeDestino               LIKE int-processo-imp.NomeDestino
   FIELD NumeroPedidoCompra        LIKE pedido-compr.num-pedido.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0242R1 NO-UNDO XML-NODE-NAME 'MSG0242R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
   FIELD r-rowid AS ROWID
   FIELD rownum  AS INT.

DEF TEMP-TABLE tt-processo-imp NO-UNDO LIKE mgcex.processo-imp
    FIELD r-rowid AS ROWID.

{method/dbotterr.i}
DEFINE VARIABLE h-bocx140 AS HANDLE      NO-UNDO.
