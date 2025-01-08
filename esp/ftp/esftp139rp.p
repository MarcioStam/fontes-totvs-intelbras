block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
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
USING OpenEdge.Net.HTTP.*.
USING OpenEdge.Net.URI.
USING Progress.Json.ObjectModel.*.
USING OpenEdge.Core.WidgetHandle FROM PROPATH.

{include/i-prgvrs.i esftp139rp 2.00.00.000}
{esp/esb/esesb000.i}
{esp/wso/out/wso0005.i}
{esp/es0018.i}

DEFINE VARIABLE cUrl        AS CHAR NO-UNDO.
DEFINE VARIABLE c-json      AS CHAR NO-UNDO.

DEFINE VARIABLE oRequest     AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse    AS IHttpResponse NO-UNDO.
DEFINE VARIABLE iXml         AS STRING        NO-UNDO.
DEFINE VARIABLE c-retorno    AS CHAR          NO-UNDO.

DEFINE VARIABLE p-requisicao AS LONGCHAR NO-UNDO.
DEFINE VARIABLE p-retorno    AS LONGCHAR NO-UNDO.

DEF VAR oJsonObject AS JsonObject NO-UNDO.
DEF VAR JsonString AS LONGCHAR NO-UNDO.

DEFINE VARIABLE hXml AS HANDLE NO-UNDO.
DEFINE VARIABLE hNodeChild AS HANDLE NO-UNDO.
DEFINE VARIABLE jx AS INTEGER NO-UNDO.

DEFINE VARIABLE PEDIDO AS CHAR NO-UNDO.
DEFINE VARIABLE PASTA AS CHAR NO-UNDO.
DEFINE VARIABLE NOMEARQUIVO AS CHAR NO-UNDO.
DEFINE VARIABLE ARQUIVO AS CHAR NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE l-pedido-ja-integrado AS LOG NO-UNDO.
DEFINE VARIABLE cString AS CHAR NO-UNDO.

DEF VAR i-embarque AS INT FORMAT ">>>>>>>9" LABEL "Embarque" NO-UNDO.
DEF VAR c-url      AS CHAR NO-UNDO.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR emscad.empresa.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cdd-embarq       LIKE nota-fiscal.cdd-embarq.
   
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FIND FIRST tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.cdd-embarq = tt-param.cdd-embarq,
       FIRST int-pedido-vtex NO-LOCK
       WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli:

        RUN pi-acompanhar in h-acomp (input int-pedido-vtex.nr-pedcli).
        RUN pi-integra.
    
    END.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    RETURN "OK".   
END.

PROCEDURE pi-integra:

    DEF VAR Json           AS JsonObject                    NO-UNDO.
    
    ASSIGN cUrl = "http://integracoes-ecommerce.intelbras.com.br/transporte/colaborador/" + int-pedido-vtex.nr-pedido + "/" + nota-fiscal.nr-nota-fis + "/disponivel".
    
    SESSION:DEBUG-ALERT = TRUE.
    
    oRequest = RequestBuilder:PUT(cUrl, Json)
                             :ContentType("application/json")
                             :AcceptAll()
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest) NO-ERROR.

    CASE TRUE:
        WHEN TYPE-OF(oResponse:Entity, JsonObject) THEN DO:
           oJsonObject = CAST(oResponse:Entity, JsonObject). 
           JsonString = STRING(oJsonObject:getJsonText()).
        END.
    END CASE.

    ASSIGN cString = SUBSTRING(JsonString, 1, 30000).
    
    RETURN "OK".

END.
