{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0240 NO-UNDO XML-NODE-NAME 'MSG0240'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoItinerario      LIKE itinerario.cod-itiner.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0240R1 NO-UNDO XML-NODE-NAME 'MSG0240R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ItinerarioR1 NO-UNDO XML-NODE-NAME 'Itinerario'
   FIELD idm                       AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoItinerario          LIKE itinerario.cod-itiner
   FIELD DescricaoItinerario       LIKE itinerario.descricao                         
   FIELD Distancia                 LIKE itinerario.distancia                         
   FIELD DiasTrajeto               LIKE itinerario.nr-dias                           
   FIELD CodigoPontoDespacho       LIKE itinerario.pto-despacho                      
   FIELD CodigoPontoSolicitaLI     LIKE itinerario.cdn-pto-solic-licenciam-import    
   FIELD CodigoPontoEmbarque       LIKE itinerario.pto-embarque                      
   FIELD CodigoPontoEADI           LIKE itinerario.pto-eadi                          
   FIELD CodigoPontoNacionalizacao LIKE itinerario.pto-desembarque                   
   FIELD CodigoPontoChegada        LIKE itinerario.pto-chegada                       
   FIELD CodigoViaTransporte       AS INT INITIAL ?
   FIELD ItinerarioBackToBack      AS LOGICAL.

DEFINE TEMP-TABLE PontoControleItinerario NO-UNDO XML-NODE-NAME 'PontoControleItinerario'
   FIELD idm                    AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoItinerario       LIKE itinerario.cod-itiner XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoPontoControle    LIKE pto-itiner.cod-pto-contr     
   FIELD SequenciaPontoControle LIKE pto-itiner.sequencia
   FIELD DescricaoPontoControle LIKE pto-contr.descricao         
   FIELD Distancia              LIKE pto-itiner.distancia
   FIELD DiasTrajeto            LIKE pto-itiner.nr-dias.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{esp/es0018.i}
