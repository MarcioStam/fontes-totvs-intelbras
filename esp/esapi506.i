&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-chamada-2 Include 
FUNCTION fc-chamada-2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-integra-aps Include 
FUNCTION fc-integra-aps RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE myLongchar  AS LONGCHAR          NO-UNDO.
    DEFINE VARIABLE myParser    AS ObjectModelParser NO-UNDO.
    DEFINE VARIABLE Json        AS JsonObject        NO-UNDO.
    DEF    VARIABLE cArqJson    AS CHAR              NO-UNDO.
    DEF    VARIABLE client      AS COM-HANDLE NO-UNDO.
    DEF    VARIABLE cLongJson   AS LONGCHAR   NO-UNDO.

      CREATE "Msxml2.ServerXMLHTTP.6.0" client.

   IF LENGTH(es-api-log.cJSON) > 0 THEN DO:
      
      myLongchar = es-api-log.cJSON.
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
      ASSIGN es-api-log.cl-envio = lcEnvio.
   END.

   DO ON ERROR UNDO, LEAVE:
            
       client:OPEN(es-api-URI.metodo, c-endereco, FALSE) NO-ERROR.
       
       IF ERROR-STATUS:ERROR = YES THEN DO:
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
    
       ASSIGN es-api-log.envio-content-type = "application/json"
              es-api-log.end-envio          = c-endereco.
       
    
       IF LENGTH(es-api-log.cJSON) > 0 THEN DO:
          client:SetRequestHeader ("Content-Type", "application/json").
          client:SEND(lcEnvio) NO-ERROR. /**/
       END.
       ELSE DO: 
           client:SEND NO-ERROR. /**/
       END.

       CATCH oneError AS Progress.Lang.SysError:
         //PUT UNFORMATTED 'Teste: ' + oneError:GetMessage(1) SKIP.
         RETURN "NOK".
       END CATCH.
    END.                            
 
    IF ERROR-STATUS:ERROR = YES THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).
      END.
      STOP.
    END.


    DO ON ERROR UNDO, LEAVE:

        IF client:ResponseText <> "" AND client:ResponseText <>  ? THEN DO:
            ASSIGN cLongJson = client:ResponseText
                   cLongJson = CODEPAGE-CONVERT(cLongJson, "UTF-8":U).
            COPY-LOB cLongJson TO es-api-log.cl-retorno.
        END.  
    
        ASSIGN es-api-log.retorno-headers      = client:getAllResponseHeaders
               es-api-log.retorno-content-type = client:getResponseHeader("Content-Type") 
               es-api-log.cod-retorno          = client:STATUS
               es-api-log.dh-retorno           = NOW.
    
        RETURN es-api-log.cod-retorno.

       CATCH oneError2 AS Progress.Lang.SysError:
         //PUT UNFORMATTED 'Teste 2: ' + oneError:GetMessage(1) SKIP.
       END CATCH.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-chamada-2 Include 
FUNCTION fc-chamada-2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE myLongchar  AS LONGCHAR          NO-UNDO.
   DEFINE VARIABLE myParser    AS ObjectModelParser NO-UNDO.
   DEFINE VARIABLE Json        AS JsonObject        NO-UNDO.
   DEF    VAR      cArqJson    AS c                 NO-UNDO.

   CREATE "Msxml2.ServerXMLHTTP.6.0" client.

   IF LENGTH(es-api-log.cJSON) > 0 THEN DO:

      //PUT UNFORMATTED "Envio >> " /*cAux*/ SKIP.

      myLongchar = es-api-log.cJSON.
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
   IF ERROR-STATUS:ERROR = YES THEN DO:

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
      IF es-api-log.envio-headers = "" THEN 
          ASSIGN es-api-log.retorno-headers = ttHeader.Chave
                                            + ": "
                                           + ttHeader.Valor.
      ELSE 
          ASSIGN es-api-log.retorno-headers = chr(13)
                                            + ttHeader.Chave
                                            + ": "
                                            + ttHeader.Valor.
   END.

   ASSIGN es-api-log.envio-content-type = "application/json"
          es-api-log.end-envio          = c-endereco.
   

   IF LENGTH(es-api-log.cJSON) > 0
   THEN DO:
      client:SetRequestHeader ("Content-Type", "application/json").
      client:SEND(lcEnvio) NO-ERROR. /**/
   END.
   ELSE client:SEND NO-ERROR. /**/
 
   IF ERROR-STATUS:ERROR = YES THEN DO:

      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).
      END.
      STOP.
   END.

   IF client:getResponseHeader("Content-Type") = "application/pdf" THEN 
       COPY-LOB client:ResponseBody TO cLongJson CONVERT TARGET CODEPAGE 'UTF-8' NO-ERROR.
   ELSE DO:
      IF client:ResponseText <> "" AND client:ResponseText <>  ? THEN DO:
         ASSIGN cLongJson = CODEPAGE-CONVERT(cLongJson, "UTF-8":U)
                cLongJson = client:ResponseText.

         COPY-LOB cLongJson TO es-api-log.cl-retorno.
      END.
   END.

   COPY-LOB cLongJson TO es-api-log.cl-retorno.

   ASSIGN es-api-log.retorno-headers      = client:getAllResponseHeaders
          es-api-log.retorno-content-type = client:getResponseHeader("Content-Type") 
          es-api-log.cod-retorno          = client:STATUS
          es-api-log.dh-retorno           = NOW.
 
   RETURN es-api-log.cod-retorno.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-chamada-2 Include 
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

   //PUT UNFORMATTED SKIP(2) ">> Chamada 2" SKIP.

   CREATE "Msxml2.ServerXMLHTTP.6.0" client.

   client:OPEN(es-api-URI.metodo, c-endereco, FALSE) NO-ERROR.
   IF ERROR-STATUS:ERROR = YES THEN DO:

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
      IF es-api-log.envio-headers = "" THEN 
          ASSIGN es-api-log.retorno-headers = ttHeader.Chave
                                            + ": "
                                           + ttHeader.Valor.
      ELSE 
          ASSIGN es-api-log.retorno-headers = chr(13)
                                            + ttHeader.Chave
                                            + ": "
                                            + ttHeader.Valor.
   END.

   ASSIGN es-api-log.envio-content-type = "application/json"
          es-api-log.end-envio          = c-endereco.
   

   IF LENGTH(es-api-log.cJSON) > 0
   THEN DO:
      client:SetRequestHeader ("Content-Type", "application/json").
      client:SEND(lcEnvio) NO-ERROR. /**/
   END.
   ELSE client:SEND NO-ERROR. /**/
 
   IF ERROR-STATUS:ERROR = YES THEN DO:

      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).
      END.
      STOP.
   END.

   IF client:getResponseHeader("Content-Type") = "application/pdf" THEN 
       COPY-LOB client:ResponseBody TO cLongJson CONVERT TARGET CODEPAGE 'UTF-8' NO-ERROR.
   ELSE DO:
      IF client:ResponseText <> "" AND client:ResponseText <>  ? THEN DO:
         ASSIGN cLongJson = CODEPAGE-CONVERT(cLongJson, "UTF-8":U)
                cLongJson = client:ResponseText.

         COPY-LOB cLongJson TO es-api-log.cl-retorno.
      END.
   END.

   COPY-LOB cLongJson TO es-api-log.cl-retorno.

   ASSIGN es-api-log.retorno-headers      = client:getAllResponseHeaders
          es-api-log.retorno-content-type = client:getResponseHeader("Content-Type") 
          es-api-log.cod-retorno          = client:STATUS
          es-api-log.dh-retorno           = NOW.
 
   RETURN es-api-log.cod-retorno.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME







