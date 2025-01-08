/*********************************************************************************
** eswso0011.i - disparo do json para o wso2 (usando Header)
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

