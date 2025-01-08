block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Core.String.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.

DEFINE INPUT  PARAMETER c-tid AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER c-plp AS CHAR NO-UNDO.

def var oClient        as IHttpClient        no-undo.
def var oUri           as URI                no-undo.
def var oReq           as IHttpRequest       no-undo.
def var oResp          as IHttpResponse      no-undo.
def var oCreds         as Credentials        no-undo.
        
def var oJsonRespObj   as JsonObject         no-undo.        
def var oJsonRespArray as JsonArray          no-undo.
def var oJsonObj       as JsonObject         no-undo.
def var oJsonArray     as JsonArray          no-undo.
        
def var i              as int                no-undo.

DEFINE VARIABLE httpUrl AS CHARACTER NO-UNDO.
DEFINE VARIABLE aJsonArray  AS JsonArray  NO-UNDO.
DEFINE VARIABLE oJsonObject AS JsonObject NO-UNDO.
DEFINE VARIABLE jsonOutput  AS HANDLE NO-UNDO.

DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oRequestText AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE c-retorno AS CHAR NO-UNDO.
DEFINE VARIABLE iXml      AS STRING        NO-UNDO.

SESSION:DEBUG-ALERT = TRUE.
httpUrl = "https://api.skyhub.com.br/shipments/b2w/".

DEFINE VARIABLE oJson AS JsonObject NO-UNDO.
DEFINE VARIABLE oAr AS JsonArray NO-UNDO.
DEFINE VARIABLE oArray AS JsonArray NO-UNDO.
DEFINE VARIABLE oRec AS JsonObject NO-UNDO.
DEFINE VARIABLE c-char AS CHAR NO-UNDO.
define variable vJsonAsString as longchar no-undo.

oJson  = NEW JsonObject().
oArray = NEW JsonArray().
oArray:ADD(c-tid).
oJson:Add("order_remote_codes",oArray).

ASSIGN vJsonAsString = oJson:GetJsonText().

ASSIGN iXml = new String(vJsonAsString).

oRequest = RequestBuilder:POST("https://api.skyhub.com.br/shipments/b2w/", iXml)
                         :AddHeader("x-api-key","KQTK8iqSZzny_JqvJYpL")
                         :AddHeader("x-user-email","leandro.jonk@intelbras.com.br")
                         :ContentType("application/json")
                         :AcceptAll()
                         :Request.

oResponse = ClientBuilder:Build():Client:Execute(oRequest).

IF  oResponse:StatusCode = 201
AND oResponse:ContentType = "application/json" THEN DO:
    CAST(oResponse:Entity, JsonObject):Write(c-retorno, true).

    ASSIGN c-plp = SUBSTRING(ENTRY(2,c-retorno,":"),7,9).

END.

IF  oResponse:StatusCode = 400
AND oResponse:ContentType = "application/json" THEN DO:
    CAST(oResponse:Entity, JsonObject):Write(c-retorno, true).

    ASSIGN c-plp = SUBSTRING(ENTRY(3,c-retorno,":"),LENGTH(ENTRY(3,c-retorno,":")) - 22,9).

END.

RETURN "OK".
