/****************************************************************************************************
** SCM Concept / Visus
**
** API Rest Retorno JSON documensto de entrada WMS
**
** 25/10/2022 - VERSAO INICIAL
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i piDoctoEntProtheus POST /~*}
{utp/ut-api-notfound.i} 

DEFINE TEMP-TABLE tt-erro  NO-UNDO
    FIELD codigo     AS INT
    FIELD informacao AS CHAR
    FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD numeroItem     AS INT
    FIELD codigoProduto  AS CHAR FORMAT "x(16)"
    FIELD quantidade     AS DEC
    FIELD lote           AS CHAR FORMAT "x(20)"
    FIELD dataDeValidade AS DATE FORMAT "99/99/9999"
    FIELD loteSerial     AS CHAR.

DEFINE VARIABLE cdata AS CHARACTER   NO-UNDO.
/****************************************************************************************************/

PROCEDURE piDoctoEntProtheus:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.      /* Input parameter jsonObject */
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.      /* Output parameter jsonObject */

    DEFINE VARIABLE jsonObjectOutput             AS JsonObject  NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload            AS jsonObject  NO-UNDO. /* Vai receber o conteudo Payload */
    DEFINE VARIABLE jsonArrayPayload             as jsonArray   NO-UNDO.
    DEFINE VARIABLE objItem                      AS JsonObject  NO-UNDO.
    DEFINE VARIABLE arrayItem                    AS jsonArray   NO-UNDO. /* JsonArray, que vai receber a temp table */
    DEFINE VARIABLE i-contItem                   AS INTEGER     NO-UNDO.

    DEFINE VARIABLE armazem                      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE filialNotaFiscal             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE numeroNotaFiscal             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE serieNotaFiscal              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE codigoFornecedor             AS CHARACTER   NO-UNDO.
    
    IF jsonInput:has("payload")   /* conteudo */
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload")
               jsonArrayPayload     = jsonObjectPayload:getJsonArray("DoctoItem").
               /* Atribui os valores do payload as vari veis */
        ASSIGN armazem          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "armazem")
               FilialNotaFiscal = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "filialNotaFiscal")
               numeroNotaFiscal = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "numeroNotaFiscal")
               serieNotaFiscal  = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "serieNotaFiscal")
               codigoFornecedor = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codigoFornecedor").

        if JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(1),"numeroItem") <> " " THEN DO:
            repeat:
            assign i-contItem = i-contItem + 1.
            IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem),"numeroItem") = '' THEN LEAVE.
         
                create tt-item.
                assign tt-item.numeroItem     = INT(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "numeroItem"))
                       tt-item.codigoProduto  =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "codigoProduto")
                       tt-item.quantidade     = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "quantidade"))
                       tt-item.lote           =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "lote")
                       cdata                  =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "dataDeValidade")
                       cdata                  =       substring(cdata,7,2) + "/" + substring(cdata,5,2) + "/" + substring(cdata,1,4)   
                       tt-item.dataDeValidade =       DATE(cdata)
                       tt-item.loteSerial     =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-contItem), "loteSerial").
            END.
        END.
    END.

    IF SEARCH("esp/wmp/docto-entrada-wms.r") <> ?
    OR SEARCH("esp/wmp/docto-entrada-wms.p") <> ?
    THEN DO:
        run esp/wmp/docto-entrada-wms.p (INPUT armazem,
                                         input FilialNotaFiscal,
                                         input numeroNotaFiscal,
                                         input serieNotaFiscal,
                                         INPUT codigoFornecedor,                                         
                                         input-output TABLE tt-item,
                                         output table tt-erro).
    END.

   ASSIGN jsonObjectOutput = NEW jsonObject().

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
       jsonObjectOutput:ADD("numeroNotaFiscal", "Documento " + STRING(numeroNotaFiscal) + " criado com sucesso."). 
       RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT FALSE, OUTPUT jsonOutput).
    END.
    ELSE DO:
       
       ASSIGN arrayItem    = NEW JsonArray().
       
       FOR EACH tt-erro:
           ASSIGN objItem = NEW JsonObject().
    
           objItem:ADD("errorCode",       tt-erro.codigo ). 
           objItem:ADD("errorInfo",       tt-erro.informacao ). 
           objItem:ADD("errorDescription",tt-erro.mensagem ).
    
           arrayItem:ADD(objItem).
       END.

       jsonObjectOutput:ADD("Erros", arrayItem).

       ASSIGN jsonOutput = NEW jsonObject().
              jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).

    END.

END PROCEDURE.
