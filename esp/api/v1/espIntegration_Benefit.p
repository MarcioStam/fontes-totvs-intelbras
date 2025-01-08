/****************************************************************************************************
** API Rest - Implantaá∆o Aá‰es VMC
**
** 17/05/2022 - Vers∆o Inicial
**

Entrada:
    "externalId": "5007i000007CZJiAAO",
    "accountExternalId": "BR83661066000150",
    "paymentMethod": "Dep¢sito Banc†rio",
    "vmcRowId": "0x00000000d942558f",
    "approvedValue": 0.0,
    "requestedAmount": 123.0,
    "status": "Criada",
    "createdDate": "2022-05-19T17:30:06.000Z"
    "discarded":"N∆o"

Retorno:
{
"originalOrderId":"01s7h000000sziIAAQ",
"erpOrderId": "3213123123",
"status":"Aberto",
"orderComments":"Coment†rio concatenado com o to totvs"
}


****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i piVMC POST /~*}
{utp/ut-api-notfound.i} 

define temp-table tt-erro no-undo
  field i-sequen as integer
  field cd-erro  as integer
  field mensagem as character format "x(255)".

procedure piVMC:
  define input  parameter jsonInput  as JsonObject no-undo.
  define output parameter jsonOutput as JsonObject no-undo.

  define variable oResponse              as JsonAPIResponse no-undo.
  define variable jsonObjectOutput       as JsonObject      no-undo.
  define variable jsonObjectPayload      as jsonObject      no-undo.
  define variable objBenefit             as JsonObject      no-undo.
  define variable oJsonObject            as JsonObject      no-undo.
  define variable arrayBenefit           as jsonArray       no-undo.
  define variable jsonArrayPayload       as jsonArray       no-undo.
  define variable oJsonArray             as jsonArray       no-undo.
                                    define variable Id                     as character       no-undo.
  define variable account                as character       no-undo format "x(60)".
  define variable PaymentMethod          as character       no-undo format "x(60)".
  define variable VMC                    as character       no-undo.
  define variable ApprovedValue          as DECIMAL         no-undo.
  define variable RequestedAmount        as DECIMAL         no-undo. 
  define variable cStatus                as CHAR            no-undo.
  define variable CreatedDate            as CHAR            no-undo.
  define variable businessUnity          as CHAR            no-undo.
  define variable actiontype             as CHAR            no-undo.
  define variable CaseType               as character       no-undo.
  DEFINE VARIABLE discarded              AS CHAR.
  DEFINE VARIABLE c-status               AS CHAR.
  DEFINE VARIABLE c-observacao           AS CHAR.

  if jsonInput:has("payload") THEN DO:
    assign jsonObjectPayload    = jsonInput:GetJsonObject("payload").
        
    
    assign Id                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"externalId").
           account            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"accountExternalId").
           PaymentMethod      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"paymentMethod").
           VMC                = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"vmcRowId").
           ApprovedValue      = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"approvedValue")).
           RequestedAmount    = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"requestedAmount")).     
           cstatus            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"status").
           CreatedDate        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"createdDate").
           actionType         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"actionType").
           businessUnity      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"businessUnity").
           discarded          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"discarded").
               
  end.

  if search("esp/wso/in/wso0018.r") <> ?
  or search("esp/wso/in/wso0018.p") <> ?
  then do:
    run esp/wso/in/wso0018.p (input  Id,              
                              input  account,         
                              input  PaymentMethod,   
                              input  VMC,             
                              input  ApprovedValue,   
                              input  RequestedAmount, 
                              input  cstatus,         
                              input  CreatedDate,
                              INPUT  actionType,
                              INPUT  businessUnity,
                              INPUT  discarded,
                              output c-status,
                              output c-observacao,
                              OUTPUT table tt-erro).
  end.

  assign arrayBenefit = new JsonArray().
         objBenefit   = new JsonObject().
         objBenefit:add("status",          string(c-status)).
         objBenefit:add('Comments',        string(c-observacao)).

  arrayBenefit:add(objBenefit).

  jsonObjectOutput = new jsonObject().
  jsonObjectOutput:add("Benefit", arrayBenefit ).

  run createJsonResponse(input jsonObjectOutput, input table rowErrors, input false, output jsonOutput).

  if temp-table tt-erro:has-records then do:
    assign oJsonArray  = new JsonArray().
    for each tt-erro:
      assign oJsonObject = new JsonObject().
      oJsonObject:Add("message", tt-erro.mensagem).
      oJsonObject:Add("detail",  tt-erro.mensagem).
      oJsonObject:Add("code",    tt-erro.cd-erro).
      oJsonArray:Add(oJsonObject).
      create RowErrors.
      ASSIGN RowErrors.ErrorNumber      = tt-erro.cd-erro
             RowErrors.ErrorDescription = tt-erro.mensagem
             RowErrors.ErrorSubType     = "ERROR".
    end.
    assign oJsonObject = new JsonObject().
    oJsonObject:Add("Error", oJsonArray).

    oResponse = NEW JsonAPIResponse(oJsonObject).
    oResponse:setHasNext(false).
    oResponse:setStatus(400).
    jsonOutput = oResponse:createJsonResponse().
    
  end.
end procedure.
