/****************************************************************************************************
** SCOPEL TechSoluction
**
** API Rest Retorno JSON tt-item
**
** 02/02/2021 - VERSÃO INICIAL
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piPriceTable POST /~*}
{utp/ut-api-notfound.i} 

def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoItem'
    field it-codigo            LIKE ped-item.it-codigo
    field quant-min            LIKE ped-item.qt-pedida
    field nat-operacao         LIKE ped-item.nat-operacao
    field preco-unit           LIKE ped-item.vl-preuni
    field vl-icms              AS DECIMAL
    field perc-icms            AS DECIMAL
    field vl-ipi               AS DECIMAL
    field perc-ipi             AS DECIMAL
    field vl-pis               AS DECIMAL
    field vl-cofins            AS DECIMAL
    field vl-icmsst            AS DECIMAL
    field preco-total          AS DECIMAL.

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piPriceTable:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
    DEFINE VARIABLE objPriceTable           AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayPriceTable         AS jsonArray    NO-UNDO.

    DEFINE VARIABLE siteCode        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE customerCode    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE destinationtype AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE priceTable      AS CHARACTER   NO-UNDO.

    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").

        ASSIGN  siteCode        =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "siteCode")
                customerCode    = INT(  JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "customerCode"))
                destinationtype =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "destinationtype")
                priceTable      =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "priceTable").
    END.

    IF SEARCH("esp/calculo_preco_portifolio.r") <> ?
    OR SEARCH("esp/calculo_preco_portifolio.p") <> ?
    THEN DO:
        run esp/calculo_preco_portifolio.p  (input siteCode,
                                             input customerCode,
                                             input destinationtype,
                                             input priceTable,
                                             input-output table tt-item).
    END.

    ASSIGN arrayPriceTable  = NEW JsonArray().
    FOR EACH tt-item NO-LOCK:
        
        ASSIGN objPriceTable = NEW JsonObject().
        objPriceTable:ADD("codigo",             STRING(tt-item.it-codigo)).
        objPriceTable:ADD("quantidade",         STRING(tt-item.quant-min)).
        objPriceTable:ADD("naturezaOperacao",   STRING(tt-item.nat-operacao)).
        objPriceTable:ADD("precoLiquido",       STRING(tt-item.preco-unit)).
        objPriceTable:ADD("valorICMS",          STRING(tt-item.vl-icms)).
        objPriceTable:ADD("percentalICMS",      STRING(tt-item.perc-icms)).
        objPriceTable:ADD("valorIPI",           STRING(tt-item.vl-ipi)).
        objPriceTable:ADD("percentualIPI",      STRING(tt-item.perc-ipi)).
        objPriceTable:ADD("valorPIS",           STRING(tt-item.vl-pis)).
        objPriceTable:ADD("valorCOFINS",        STRING(tt-item.vl-cofins)).
        objPriceTable:ADD("valorICMSST",        STRING(tt-item.vl-icmsst)).
        objPriceTable:ADD("precoTotal",         STRING(tt-item.preco-total)).
        arrayPriceTable:ADD(objPriceTable).
    END. 

    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("returnItens", arrayPriceTable).

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.

