/****************************************************************************************************
** SCM Concept / Visus
**
** API Rest Retorno JSON table-item-protheus
**
** 25/10/2022 - VERSAO INICIAL
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i piItemProtheus POST /~*}
{utp/ut-api-notfound.i} 

DEFINE TEMP-TABLE tt-erro  NO-UNDO
    FIELD codigo     AS INT
    FIELD informacao AS CHAR
    FIELD mensagem   AS CHARACTER FORMAT "x(250)".

/****************************************************************************************************/

PROCEDURE piItemProtheus:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.      /* Input parameter jsonObject */
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.      /* Output parameter jsonObject */

    DEFINE VARIABLE jsonObjectOutput             AS JsonObject  NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload            AS jsonObject  NO-UNDO.  /* Vai receber o conteudo Payload */
    DEFINE VARIABLE objItem                      AS JsonObject  NO-UNDO.
    DEFINE VARIABLE arrayItem                    AS jsonArray   NO-UNDO.  /* JsonArray, que vai receber a temp table */

    DEFINE VARIABLE cCodEstabel                  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodLocal                    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE codigoProduto                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE descricaoProduto             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE unidadeDeMedida              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE codigoBarras                 AS CHARACTER   NO-UNDO.
    //DEFINE VARIABLE familia                      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ativaControleDeLote          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lastro                       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE EmbalagemUnidade             AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE EmbalagemQuantidade          AS DEC         NO-UNDO.
    DEFINE VARIABLE EmbalagemCodigoBarras        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE EmbalagemVolume              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE EmbalagemUnidadeVolume       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE EmbalagemAltura              AS DEC                 NO-UNDO.
    DEFINE VARIABLE EmbalagemLargura             AS DEC                 NO-UNDO.
    DEFINE VARIABLE EmbalagemComprimento         AS DEC                 NO-UNDO.
    DEFINE VARIABLE EmbalagemPesoBruto           AS DEC                 NO-UNDO.

    IF jsonInput:has("payload")   /* conteudo */
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
               /* Atribui os valores do payload as vari veis */
        ASSIGN cCodEstabel                  =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "cCodEstabel")
               cCodLocal                    =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "cCodLocal")
               codigoProduto                =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codigoProduto")
               descricaoProduto             =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "descricaoProduto")
               unidadeDeMedida              =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "unidadeDeMedida")
               codigoBarras                 =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codigoBarras")
               //familia                      =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "familia")
               ativaControleDeLote          =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "ativaControleDeLote")
               lastro                       =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "lastro")
               EmbalagemUnidade             =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemUnidade"))
               EmbalagemQuantidade          =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemQuantidade"))
               EmbalagemCodigoBarras        =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemCodigoBarras")
               EmbalagemVolume              =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemVolume")
               EmbalagemUnidadeVolume       =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemUnidadeVolume")
               EmbalagemAltura              =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemAltura"))
               EmbalagemLargura             =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemLargura"))
               EmbalagemComprimento         =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemComprimento"))
               EmbalagemPesoBruto           =       dec(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "EmbalagemPesoBruto")).
    END.

    IF SEARCH("esp/wmp/item-wms.r") <> ?
    OR SEARCH("esp/wmp/item-wms.p") <> ?
    THEN DO:
        run esp/wmp/item-wms.p (input cCodEstabel,
                                input cCodLocal,
                                input codigoProduto,
                                input descricaoProduto,
                                input unidadeDeMedida,
                                input codigoBarras,
                                //input familia,
                                input ativaControleDeLote,
                                INPUT lastro,
                                input EmbalagemUnidade,
                                input EmbalagemQuantidade,
                                input EmbalagemCodigoBarras,
                                input EmbalagemVolume,
                                input EmbalagemUnidadeVolume,
                                input EmbalagemAltura,
                                input EmbalagemLargura,
                                input EmbalagemComprimento,
                                input EmbalagemPesoBruto,
                                output table tt-erro).
    END.

    ASSIGN jsonObjectOutput = NEW jsonObject().

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
       jsonObjectOutput:ADD("codigoProduto",    STRING(codigoProduto)). 
       jsonObjectOutput:ADD("descricaoProduto", STRING(descricaoProduto)). 
       
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


