/*********************************************************************************
** eswso0019.i - disparo do json para o wso2 (usando Header)
*********************************************************************************/


USING Progress.Json.*.
USING Progress.Json.ObjectModel.*.
USING com.totvs.framework.api.*.
USING Progress.Lang.Object.
USING OpenEdge.Core.WidgetHandle.
USING OpenEdge.Core.String.
USING OpenEdge.Core.*.
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.ResponseBuilder.
USING OpenEdge.Net.URI.
USING OpenEdge.Net.HTTP.IHttpResponse.

{method/dbotterr.i}

DEF TEMP-TABLE ttHeader NO-UNDO
    FIELD Seq   AS i
    FIELD Chave AS c
    FIELD Valor AS c
    INDEX i Seq.

DEF BUFFER bf-api-aux FOR es-api-aux.

DEF VAR cJSON-aux AS LONGCHAR.

DEF VAR client      AS COM-HANDLE NO-UNDO.
DEF VAR lcEnvio     AS LONGCHAR   NO-UNDO.
DEF VAR cLongJson   AS LONGCHAR   NO-UNDO.
DEF VAR i           AS i          NO-UNDO.
DEF VAR c-endereco  AS c          NO-UNDO.

DEF VAR iErro       AS i          NO-UNDO.

DEF VAR cArquivoRec AS c          NO-UNDO.

ASSIGN 
   cArquivoRec = SESSION:TEMP-DIRECTORY 
               + "RECAPI-"
               + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(STRING(NOW),":","")," ",""),",",""),"-",""),"/","")
               + STRING(RANDOM(1,1000),"9999")
               + ".tmp".

FUNCTION fc-chamada-3 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


   DEFINE VARIABLE myLongchar  AS LONGCHAR          NO-UNDO.
   DEFINE VARIABLE myParser    AS ObjectModelParser NO-UNDO.
   DEFINE VARIABLE Json        AS JsonObject        NO-UNDO.
   DEF    VAR      cArqJson    AS c                 NO-UNDO.

   PUT UNFORMATTED SKIP(2) ">> Chamada 2" SKIP.

   CREATE "Msxml2.ServerXMLHTTP.6.0" client.

   IF cJSON-aux > ""
   THEN DO:
      //PUT UNFORMATTED "Envio >> " string(cJSON-aux) SKIP.

      myLongchar = cJSON-aux.
      myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).
    
      myParser = NEW ObjectModelParser().
    
      Json = CAST(myParser:Parse(myLongchar), JsonObject).
    
      ASSIGN
         cArqJson = SESSION:TEMP-DIRECTORY 
                  + "send-json-" 
                  + "-"
                  + STRING(TIME)
                  + ".json".
    
      CAST(myParser:Parse(mylongchar),JsonObject):WriteFile(cArqJson, TRUE).
      COPY-LOB FILE cArqJson TO lcEnvio.
      OS-DELETE cArqJson.
      ASSIGN
         es-api-log.cl-envio = lcEnvio.
   END.

   client:OPEN(es-api-URI.metodo, c-endereco, FALSE) NO-ERROR.
   IF ERROR-STATUS:ERROR = YES 
   THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).
      END.
      STOP.
   END.

   FOR EACH ttHeader:
      client:SetRequestHeader (ttHeader.Chave, ttHeader.Valor).
      IF es-api-log.envio-headers = ""
      THEN ASSIGN
         es-api-log.retorno-headers = ttHeader.Chave
                                    + ": "
                                    + ttHeader.Valor.
      ELSE ASSIGN
         es-api-log.retorno-headers = chr(13)
                                    + ttHeader.Chave
                                    + ": "
                                    + ttHeader.Valor.
   END.

   ASSIGN
      es-api-log.envio-content-type = "application/json"
      es-api-log.end-envio          = c-endereco.
   

   IF cJSON-aux > ""
   THEN DO:
      client:SetRequestHeader ("Content-Type", "application/json").
      client:SEND(lcEnvio) NO-ERROR. /**/
   END.
   ELSE client:SEND NO-ERROR. /**/
 
   IF ERROR-STATUS:ERROR = YES 
   THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).
      END.
      STOP.
   END.


   /*
   MESSAGE 
      'endereco'              c-endereco                               SKIP(1)
      'getAllResponseHeaders' client:getAllResponseHeaders             SKIP(1)
      'getResponseHeader'     client:getResponseHeader("Content-Type") SKIP(1)
      'ResponseBody  '        client:ResponseBody                      SKIP(1)
      'ResponseText  '        client:ResponseText                      SKIP(1)
      'Responsexml   '        client:ResponseXml                       SKIP(1)
      'responseStream'        client:responseStream                    SKIP(1)
      'STATUS        '        client:STATUS                            SKIP
       VIEW-AS ALERT-BOX TITLE "retorno".*/
   

   IF client:getResponseHeader("Content-Type") = "application/pdf" 
   THEN COPY-LOB client:ResponseBody TO cLongJson CONVERT TARGET CODEPAGE 'UTF-8' NO-ERROR.
   ELSE DO:
      IF client:ResponseText <> "" AND client:ResponseText <>  ? 
      THEN DO:
         ASSIGN 
            cLongJson = CODEPAGE-CONVERT(cLongJson, "UTF-8":U)
            cLongJson = client:ResponseText
            
            .
         COPY-LOB cLongJson TO es-api-log.cl-retorno.
      END.
   END.

   COPY-LOB cLongJson TO es-api-log.cl-retorno.

   PUT UNFORMATTED                                                          SKIP(2)
      'Retorno'                                                             SKIP(1)
      'endereco               >> ' c-endereco                               SKIP(1)
      'getAllResponseHeaders  >> '                                          SKIP
                                   client:getAllResponseHeaders             SKIP(1)
      'getResponseHeader      >> ' client:getResponseHeader("Content-Type") SKIP(1)
      //'ResponseBody           >> ' client:ResponseBody                      SKIP(1)
      'ResponseText           >> ' client:ResponseText                      SKIP(1)
       SKIP(1)
       STRING(cLongJson)
       SKIP(1)
      'Responsexml            >> ' client:ResponseXml                       SKIP(1)
      'responseStream         >> ' client:responseStream                    SKIP(1)
      'STATUS                 >> ' client:STATUS                            SKIP(1).

 
   ASSIGN
      es-api-log.retorno-headers      = client:getAllResponseHeaders
      es-api-log.retorno-content-type = client:getResponseHeader("Content-Type") 

      es-api-log.cod-retorno          = client:STATUS
      es-api-log.dh-retorno           = NOW.
 
   RETURN es-api-log.cod-retorno.

END FUNCTION.
