/****************************************************************************************************
** SCM Concept / Visus
**
** API Rest Retorno JSON documensto de Saida WMS
**
** 25/10/2022 - VERSAO INICIAL
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i piDoctoSaiProtheus POST /~*}
{utp/ut-api-notfound.i} 

DEFINE TEMP-TABLE tt-erro  NO-UNDO
    FIELD codigo     AS INT
    FIELD informacao AS CHAR
    FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD numeroItem     AS INT
    FIELD codigoProduto  AS CHAR FORMAT "x(16)"
    FIELD quantidade     AS DEC
    FIELD numeroOrdemProducao AS char 
    FIELD codigoGerador       AS char 
    FIELD descGerador         AS char .

/****************************************************************************************************/

PROCEDURE piDoctoSaiProtheus:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.      /* Input parameter jsonObject */
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.      /* Output parameter jsonObject */

    DEFINE VARIABLE jsonObjectOutput             AS JsonObject  NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload            AS jsonObject  NO-UNDO. /* Vai receber o conteudo Payload */
    define variable jsonArrayPayload             as jsonArray   no-undo.
    DEFINE VARIABLE objItem                      AS JsonObject  NO-UNDO.
    DEFINE VARIABLE arrayItem                    AS jsonArray   NO-UNDO. /* JsonArray, que vai receber a temp table */
    define variable i-cont                       as integer         no-undo.

    define variable objSaleOrder           as JsonObject      no-undo.

    DEFINE VARIABLE filialPedido                 AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE numeroPedido                 AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE codigoCliente                AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE entregaEstado                AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE entregaCidade                AS CHARACTER FORMAT "x(30)"  NO-UNDO.
    DEFINE VARIABLE entregaRazaoSocial           AS CHARACTER FORMAT "x(30)"  NO-UNDO.
    DEFINE VARIABLE nomeTransportadora           AS CHARACTER FORMAT "x(30)"  NO-UNDO.
    DEFINE VARIABLE armazem                      AS CHARACTER                 NO-UNDO.
    
    IF jsonInput:has("payload")   /* conteudo */
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload")
               jsonArrayPayload     = jsonObjectPayload:getJsonArray("DoctoItem").

        /* Atribui os valores do payload as vari veis */
        ASSIGN filialPedido              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "filialPedido")
               numeroPedido              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "numeroPedido")
               codigoCliente             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codigoCliente")
               entregaEstado             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "entregaEstado")
               entregaCidade             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "entregaCidade")
               entregaRazaoSocial        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "entregaRazaoSocial")
               nomeTransportadora        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "nomeTransportadora")
               armazem                   = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "armazem")  .

        if JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(1),"numeroItem") <> " " THEN DO:
            repeat:
            assign i-cont = i-cont + 1.
            IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-cont),"numeroItem") = '' THEN LEAVE.
         
                create tt-item.
                assign tt-item.numeroItem          = INT(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "numeroItem"))
                       tt-item.codigoProduto       =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "codigoProduto")
                       tt-item.quantidade          = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "quantidade"))
                       tt-item.numeroOrdemProducao =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "numeroOrdemProducao")
                       tt-item.codigoGerador       =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "codigoGerador")
                       tt-item.descGerador         =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "descGerador").
            END.
        END.
    END.

    IF SEARCH("esp/wmp/docto-saida-wms.r") <> ?
    OR SEARCH("esp/wmp/docto-saida-wms.p") <> ?
    THEN DO:
        run esp/wmp/docto-saida-wms.p   (input filialPedido       ,
                                         input numeroPedido       ,
                                         input codigoCliente      ,
                                         input entregaEstado      ,
                                         input entregaCidade      ,
                                         input entregaRazaoSocial ,
                                         input nomeTransportadora ,
                                         INPUT armazem            ,
                                         input-output TABLE tt-item,
                                         output table tt-erro).
    END.
    
    ASSIGN jsonObjectOutput = NEW jsonObject().

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
       jsonObjectOutput:ADD("numeroPedido", "Documento " + STRING(numeroPedido) + " criado com sucesso."). 
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

       ASSIGN jsonOutput = NEW jsonObject()
              jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).

    END.

END PROCEDURE.
