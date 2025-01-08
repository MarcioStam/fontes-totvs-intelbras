/****************************************************************************
** Programa : ESAPI032
** Descricao: Integracao de Ferramentas para Projeto MES e APS
**     Autor: Isac Abrahao
**      Data: 08/09/2021
*****************************************************************************/
{esp/esapi505.i}         

DEF INPUT  PARAM p-acao    AS CHARACTER NO-UNDO.
DEF INPUT  PARAM p-ferran  AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-result  AS CHARACTER NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objFerramen          AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayFerramen        AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-JSON       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE DtCreation        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE DtLastMaintenance AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-JSON-atual      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE IDTooling         AS CHARACTER   NO-UNDO.

/* Inicio */                                            
ASSIGN arrayFerramen = NEW JsonArray().

FIND FIRST ferr-prod WHERE ferr-prod.cod-ferr-prod = p-ferran NO-LOCK NO-ERROR.

IF AVAIL ferr-prod THEN DO:
   ASSIGN DtCreation  = STRING(YEAR(TODAY),'9999') + '-' + 
                        STRING(MONTH(TODAY),'99')  + '-' + 
                        STRING(DAY(TODAY),'99').    
    
   ASSIGN DtLastMaintenance = STRING(YEAR(ferr-prod.data-2),'9999') + '-' + 
                              STRING(MONTH(ferr-prod.data-2),'99')  + '-' + 
                              STRING(DAY(ferr-prod.data-2),'99').   

   
   ASSIGN DtCreation        = DtCreation        + "T03:00:00-00:00"
          DtLastMaintenance = DtLastMaintenance + "T03:00:00-00:00".

   ASSIGN objFerramen = NEW JsonObject().

   objFerramen:ADD("Period"            , ferr-prod.un-ciclo * 60 * 60). //SEGUNDOS
   objFerramen:ADD("Code"              , ferr-prod.cod-ferr-prod).
   objFerramen:ADD("Name"              , ferr-prod.des-ferr-prod).
   objFerramen:ADD("DtCreation"        , DtCreation ).
   objFerramen:ADD("FlgEnable"         , IF ferr-prod.log-2 THEN 1 ELSE 0).
   objFerramen:ADD("IDToolingType"     , 1).
   objFerramen:ADD("DtLastMaintenance" , DtLastMaintenance).
   
   arrayFerramen:ADD(objFerramen).
   
   c-JSON = JsonAPIUtils:getJsonArrayChar(arrayFerramen).
   
   FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.
   
   FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'integraFerramMES' EXCLUSIVE-LOCK NO-ERROR.

   IF NOT AVAIL es-api-URI THEN LEAVE.

   ASSIGN es-api-URI.metodo = 'POST'. //METODO POST

   FIND FIRST es-api-log
        WHERE es-api-log.id-aplicacao   = 'MES'
          AND es-api-log.id-URI         = 'integraFerramMES'
          AND es-api-log.id-codigo      = ferr-prod.cod-ferr-prod
   EXCLUSIVE-LOCK NO-ERROR.

   IF NOT AVAIL es-api-log THEN DO:
      CREATE es-api-log.
      ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10   
             es-api-log.id-aplicacao   = 'MES'
             es-api-log.id-codigo      = ferr-prod.cod-ferr-prod
             es-api-log.id-URI         = es-api-URI.id-URI
             es-api-log.Origem         = es-api-URI.id-URI
             //es-api-log.aux            = ferr-prod.cod-ferr-prod
             es-api-log.cJson          = c-JSON
             es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).


      ASSIGN c-endereco = es-api-URI.ent-PRD. //URL

      RUN pi-atualiza.

      IF RETURN-VALUE = 'NOK' THEN
         RETURN 'NOK'.

      /* Busca ID ferramenta */
      RUN pi-metodo-get (OUTPUT IDTooling). 

      /* Grava ID banco MES*/
      ASSIGN es-api-log.aux = IDTooling. 

   END.
   ELSE DO:
      /* Busca ID ferramenta */
      IF es-api-log.aux = '' THEN DO:
         RUN pi-metodo-get (OUTPUT IDTooling).

         /* Grava ID banco MES*/
         ASSIGN es-api-log.aux = IDTooling. 
      END.

      IF es-api-log.aux = '' THEN DO:
         RETURN 'NOK'.
      END.

      ASSIGN c-JSON-atual     = es-api-log.cjson.
             es-api-log.cjson = c-JSON.
     
      IF p-acao = 'delete' THEN
         ASSIGN es-api-URI.metodo = 'DELETE'. //METODO DELETE
      ELSE
         ASSIGN es-api-URI.metodo = 'PUT'.    //METODO PUT

      ASSIGN c-endereco = es-api-URI.ent-PRD + '(' + es-api-log.aux + ')'.  //Endpoint PUT

      RUN pi-atualiza.

      IF RETURN-VALUE = 'NOK' THEN DO:
         ASSIGN es-api-log.cjson = c-JSON-atual.
      END.
   END.

   ASSIGN es-api-URI.metodo = 'POST'. //METODO POST

END.
ELSE DO:
   ASSIGN p-result = 'Ferramenta nao encontrada'.
END.

/**Fim **/

/************************* Procedures *************************/
PROCEDURE pi-atualiza:

   ASSIGN lcEnvio = es-api-log.cjson
          lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
   
   COPY-LOB lcEnvio TO es-api-log.cl-envio.
   
   IF STRING(lcEnvio) > "" THEN 
      fc-chamada-2().

   ASSIGN p-result = es-api-log.cod-retorno + ' ' + string(es-api-log.cl-retorno).
   
   IF SUBSTRING(es-api-log.cod-retorno,1,2) = '20' THEN 
      ASSIGN es-api-log.dh-request     = NOW
             es-api-log.flg-processado = NO.
   ELSE 
      RETURN 'NOK'.

   /*
   MESSAGE 'Integra Ferramenta' SKIP es-api-log.cod-retorno 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

   RETURN 'OK'.

END PROCEDURE.



PROCEDURE pi-metodo-get:
    
    DEFINE VARIABLE cArqJsonAux    AS CHARACTER           NO-UNDO.
    
    DEFINE VARIABLE myParserAux    AS ObjectModelParser   NO-UNDO.
    DEFINE VARIABLE JsonAux        AS JsonObject          NO-UNDO.
    DEFINE VARIABLE arrayAux       AS jsonArray           NO-UNDO.
    
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject NO-UNDO.
    DEFINE VARIABLE jsonArrayPayload        AS jsonArray  NO-UNDO.

    DEF OUTPUT PARAM p-IDTooling   AS CHARACTER           NO-UNDO.
    
    ASSIGN es-api-URI.metodo = 'GET'. //METODO GET

    ASSIGN c-endereco = es-api-URI.ent-PRD + "?$filter=Code eq '" + ferr-prod.cod-ferr-prod + "'". //Endpoint GET
   
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
    
    IF STRING(lcEnvio) > "" THEN 
       fc-chamada-2().
   
    IF SUBSTRING(es-api-log.cod-retorno,1,2) = '20' THEN DO:
       myParserAux = NEW ObjectModelParser().
    
       JsonAux = CAST(myParserAux:Parse(cLongJson), JsonObject).
    
       ASSIGN cArqJsonAux = 'c:/temp/'   + 
                            "send-json-" + "-" + 
                            STRING(TIME) + 
                            ".json".
    
       CAST(myParserAux:Parse(cLongJson),JsonObject):WriteFile(cArqJsonAux, TRUE).
    
       ASSIGN arrayAux = NEW JsonArray().
    
       arrayAux:ADD(JsonAux).
    
       c-JSON = JsonAPIUtils:getJsonArrayChar(arrayAux). 

       IF JsonAux:has("value") THEN DO:
          jsonArrayPayload     = JsonAux:getJsonArray("value").      
        
          ASSIGN p-IDTooling = JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(1),"IDTooling").
       END.
    END.
    

END PROCEDURE.


