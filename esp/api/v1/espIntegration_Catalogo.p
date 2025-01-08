/****************************************************************************************************
** Intelbras
**
** API Rest Retorno JSON tt-item
**
** 21/07/2021 - VERSAO INICIAL   // http://10.1.1.71:32080/api/esp/v1/espIntegration_Catalogo/piCatalogo
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piCatalogo POST /~*}
{utp/ut-api-notfound.i} 

{esp/wso/eswso0012.i} 

define temp-table tt-erro no-undo
  field i-sequen as integer
  field cd-erro  as integer
  field mensagem as character format "x(255)".


procedure piCatalogo:
    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE logItemCriado   AS LOGICAL     NO-UNDO.

    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
    END.

    IF SEARCH("esp/wso/out/wso0012.r") <> ?
    OR SEARCH("esp/wso/out/wso0012.p") <> ? THEN DO:
        run esp/wso/out/wso0012.p  (input-output table tt-item).
    END.

    run pi-gera-json.

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).
    
END PROCEDURE.
