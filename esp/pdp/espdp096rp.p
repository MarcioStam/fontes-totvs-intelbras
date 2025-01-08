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
/** Carrega bibliotecas necessarias **/
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
USING OpenEdge.Core.*.
USING OpenEdge.Core.String.
USING OpenEdge.Core.WidgetHandle.
USING Progress.Json.*.
USING Progress.Json.ObjectModel.*.
USING com.totvs.framework.api.*.
USING Progress.Lang.Object.

{include/i-prgvrs.i espdp096rp 2.00.00.001}
{esp/esb/esesb000.i}
//{esp/wso/out/wso0005.i}
{esp/wso/out/wso0002.i}
{btb/btb912zb.i}
{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE cUrl        AS CHAR NO-UNDO.
DEFINE VARIABLE c-json      AS CHAR NO-UNDO.

DEFINE VARIABLE oRequest     AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse    AS IHttpResponse NO-UNDO.
DEFINE VARIABLE oRequestPedido  AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponsePedido AS IHttpResponse NO-UNDO.
DEFINE VARIABLE oRequestStatus  AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponseStatus AS IHttpResponse NO-UNDO.
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
DEFINE VARIABLE myLongchar     AS LONGCHAR                      NO-UNDO.
DEFINE VARIABLE myParser       AS ObjectModelParser             NO-UNDO.
DEFINE VARIABLE Json           AS JsonObject                    NO-UNDO.
DEFINE VARIABLE objPreco          AS JsonObject  NO-UNDO.
DEFINE VARIABLE objfixedPrice     AS JsonObject   NO-UNDO.
DEFINE VARIABLE objfixedPrices    AS jsonArray   NO-UNDO.
DEFINE VARIABLE objdateRange      AS JsonObject   NO-UNDO.

DEFINE TEMP-TABLE tt-file NO-UNDO
    FIELD arquivo AS CLOB.

DEF TEMP-TABLE tt-item
    FIELDS it-codigo LIKE ITEM.it-codigo.

DEF VAR jsonPedidos          AS JsonArray    NO-UNDO.
DEF VAR JsonObjectPedidos    AS JsonObject   NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR cString AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-pedidos
    FIELDS nr-pedido AS CHAR.

DEF BUFFER bint-preco-ecommerce FOR int-preco-ecommerce.
        
DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE dt-ini-ult    AS DATE     NO-UNDO.

DEFINE VARIABLE i-cont-aux                                  AS INT NO-UNDO.

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
    field fi-tab-ini       AS CHAR
    field fi-tab-fim       AS CHAR
    field fi-item-ini      AS CHAR
    field fi-item-fim      AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

define temp-table tt-param-espdp096 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD it-codigo        LIKE preco-item.it-codigo.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

FIND FIRST tt-param NO-ERROR.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar in h-acomp (input "Integrando ...").

EMPTY TEMP-TABLE tt-prog-ponto.
/*
IF CAN-FIND(FIRST int-preco-ecommerce
            WHERE int-preco-ecommerce.situacao = 1) THEN
    RUN pi-preco-wso2.
    */

RUN pi-atualiza-preco-wso2.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

RETURN "OK".

PROCEDURE pi-preco-wso2:

    RUN esp/wso/out/wso0002.p (INPUT "v1/produto/preco-ecommerce",
                               INPUT TABLE ttEstoque).


END PROCEDURE.
    
PROCEDURE pi-atualiza-preco-wso2:

    FOR EACH int-preco-ecommerce NO-LOCK
       WHERE int-preco-ecommerce.situacao = 1:
        IF NOT CAN-FIND(FIRST tt-item
                        WHERE tt-item.it-codigo = int-preco-ecommerce.it-codigo) THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = int-preco-ecommerce.it-codigo.
        END.
    END.

    FOR EACH tt-item:
        RUN pi-acompanhar IN h-acomp (INPUT tt-item.it-codigo).
        
        FOR EACH int-preco-ecommerce NO-LOCK
           WHERE int-preco-ecommerce.it-codigo = tt-item.it-codigo
           BREAK BY int-preco-ecommerce.it-codigo
                 BY int(int-preco-ecommerce.tradePolicyId):

            IF FIRST-OF(int-preco-ecommerce.it-codigo) THEN DO:
                ASSIGN objPreco = NEW JsonObject().
                ASSIGN objfixedPrices = NEW JsonArray().

                IF CAN-FIND(FIRST bint-preco-ecommerce
                            WHERE bint-preco-ecommerce.it-codigo = int-preco-ecommerce.it-codigo
                              AND bint-preco-ecommerce.tradePolicyId = "1") THEN DO:
                    FOR FIRST bint-preco-ecommerce NO-LOCK
                        WHERE bint-preco-ecommerce.it-codigo = int-preco-ecommerce.it-codigo
                          AND bint-preco-ecommerce.tradePolicyId = "1":
                        objPreco:ADD("markup"        , 0).
                        objPreco:ADD("basePrice"     , bint-preco-ecommerce.dvalue).
                        objPreco:ADD("listPrice"     , bint-preco-ecommerce.listPrice).
                    END.
                END.
                ELSE DO:
                    FOR EACH bint-preco-ecommerce NO-LOCK
                       WHERE bint-preco-ecommerce.it-codigo = int-preco-ecommerce.it-codigo
                       BREAK BY bint-preco-ecommerce.it-codigo
                             BY bint-preco-ecommerce.dvalue:
                        IF LAST-OF(bint-preco-ecommerce.it-codigo) THEN DO:
                            objPreco:ADD("markup"        , 0).
                            objPreco:ADD("basePrice"     , bint-preco-ecommerce.dvalue).
                            objPreco:ADD("listPrice"     , bint-preco-ecommerce.listPrice).
                        END.
                    END.
                END.
            END.

            ASSIGN objfixedPrice = NEW JsonObject().
            ASSIGN objdateRange = NEW JsonObject().

            objfixedPrice:ADD("tradePolicyId"     , int-preco-ecommerce.tradePolicyId).
            objfixedPrice:ADD("value"             , int-preco-ecommerce.dvalue).
            objfixedPrice:ADD("listPrice"         , int-preco-ecommerce.listPrice).
            objfixedPrice:ADD("minQuantity"       , IF int-preco-ecommerce.minQuantity < 1 THEN 1 ELSE int-preco-ecommerce.minQuantity).
            objdateRange:ADD("from"               , STRING(int-preco-ecommerce.dateFrom)).
            objdateRange:ADD("to"                 , STRING(int-preco-ecommerce.dateTo)).
            objfixedPrice:ADD("dateRange"         , objdateRange).
            objfixedPrices:ADD(objfixedPrice).

            IF LAST-OF(int-preco-ecommerce.it-codigo) THEN DO:
                objPreco:ADD("fixedPrices"            , objfixedPrices).

                SESSION:DEBUG-ALERT = TRUE.

                assign c-JSON = objPreco:getjsontext().

                myLongchar = c-json.
                myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).

                myParser = NEW ObjectModelParser().
                Json = CAST(myParser:Parse(myLongchar), JsonObject).

                /*ASSIGN cUrl = "https://api.vtex.com/intelbras/pricing/prices/" + int-preco-ecommerce.it-codigo.
                oRequest = RequestBuilder:PUT(cUrl, Json)
                                         :AddHeader("X-VTEX-API-AppKey","vtexappkey-intelbras-LFKNPQ")
                                         :AddHeader("X-VTEX-API-AppToken","HKBYCCDACHLNPBRIHDYXCFDORBICQEFSSFOCIHFTESZZXUHKGUVWRJCBGMHATBKYCTUJNPZZYESJGERWUYVVJIAJDMVWZEZDIBXEAXWQVVYNQTVCVLGVFOOUSLGATCAT")
                                         :AddHeader("Accept","application/json")
                                         :ContentType("application/json")
                                         :AcceptAll()
                                         :Request.*/

                ASSIGN cUrl = "http://integracoes-ecommerce.intelbras.com.br/v1/produto/pricing/" + int-preco-ecommerce.it-codigo.
                oRequest = RequestBuilder:PUT(cUrl, Json)
                                         :ContentType("application/json")
                                         :AcceptAll()
                                         :Request.


                oResponse = ClientBuilder:Build():Client:Execute(oRequest) NO-ERROR.

                IF oResponse:StatusCode = 200 THEN DO:
                    FOR EACH bint-preco-ecommerce EXCLUSIVE-LOCK
                       WHERE bint-preco-ecommerce.it-codigo = int-preco-ecommerce.it-codigo:
                        ASSIGN bint-preco-ecommerce.situacao = 0.
                    END.
                END.
                PAUSE(2).
            END.
        END.
    END.

END PROCEDURE.
