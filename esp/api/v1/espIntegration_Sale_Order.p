/****************************************************************************************************
** iDBA - Helder Breda
**
** API Rest - Implantação Pedidos SalesForce
**
** 30/08/2021 - Versão Inicial
**

Dados de entrada:

Entrada do pedido:
{
   "tradingDays":0,
   "tradingBaseDate":"",
   "supervisorRegistration":"",
   "siteCode":"105",
   "shippingCost":0.00,
   "representativeCode":"4000",
   "projectRegisterNumber":"",
   "poNumber":"",
   "paymentCondition":"553",
   "partialBillingAllowed":true,
   "OrderItems":[
      {
         "wideCloudPercentDiscount":0,
         "unitPrice":352.9543,
         "unitFocusedPercentDiscount":0,
         "topMillionPercentDiscount":0,
         "sequence":10,
         "quantityDiscount":0.00,
         "quantity":1.00,
         "priceBook":"VAREG-SP",
         "productCode":"4565502",
         "kitItemDiscountPercent":0,
         "portfolioSegmentation":"",
         "orderItemPoNumber":"",
         "itemObservation":"",
         "greenerPercentDiscount":0,
         "executiveCode":"",
         "expectedBillingDate":"2022-11-11",
         "distributorTwoZeroPercentDiscount":0,
         "commercialDiscount":0.00
      }
   ],
   "orderId":"8017i000001S4zXAAS",
   "orderComments":"",
   "fiscalObservation":"",
   "finallity":"Revenda / Industrialização",
   "expectedBillingDate":"",
   "effectiveDate":"2022-09-29T00:00:00.000Z",
   "attendantCode":"20",
   "accountExternalId":"BR21495055000190",
   "accountCurrency":0,
   "origin":"Salesforce-HOMOLOG"
}


Retorno:
{
"originalOrderId":"01s7h000000sziIAAQ",
"erpOrderId": "3213123123",
"status":"Aberto",
"orderComments":"Comentário concatenado com o to totvs"
}


****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i piSaleOrder POST /~*}
{utp/ut-api-notfound.i} 
{include/i-license-manager.i espIntegration_Sale_Order MFP}

define temp-table tt-erro no-undo
  field i-sequen as integer
  field cd-erro  as integer
  field mensagem as character format "x(255)".

define temp-table tt-item NO-UNDO
  field sequencia              like ped-item.nr-sequencia
  field it-codigo              like ped-item.it-codigo
  field preco-unit             like ped-item.vl-preuni
  field qt-pedida              like ped-item.qt-pedida
  FIELD nr-tabpre              LIKE ped-item.nr-tabpre
  field item-obs               as char format "x(2000)"
  field ordem-compra           as CHAR FORMAT "x(15)"
  FIELD dt-prev-fat            AS DATE
  field desconto-com           as decimal
  field desconto-qtd           as DECIMAL
  field desconto-kit           as DECIMAL
  FIELD log-servico            AS LOG
  field executivo              as INTEGER       
  field segmento-portifolio    as CHAR         
  field desc-maisverde         as decimal   
  field desc-topmilhao         as decimal
  field desc-focounidade       as decimal  
  field desc-distrib20         as decimal
  field desc-widecloud         as decimal .

DEFINE TEMP-TABLE tt-comissao NO-UNDO
    FIELD cnpj       AS CHAR
    FIELD percentual AS DEC 
    FIELD valor      AS DEC.

DEFINE TEMP-TABLE tt-grupo NO-UNDO
    FIELD ncm         AS CHAR
    field name        AS CHAR
    field items       AS CHAR
    field unitPrice   AS DEC 
    FIELD quantity    AS DEC.

DEFINE TEMP-TABLE tt-cond-pagto NO-UNDO
    FIELD method    AS CHAR
    FIELD tid       AS CHAR 
    FIELD reference AS CHAR 
    FIELD processor AS CHAR
    FIELD number    AS INT
    FIELD sequencia AS INT.						   

DEFINE TEMP-TABLE tt-prestac
    FIELD method    AS CHAR
    FIELD reference AS CHAR 
    FIELD data      AS DATE
    FIELD valor     AS DEC.

DEFINE TEMP-TABLE tt-address NO-UNDO
    FIELD District   AS CHAR
    FIELD Cep        AS CHAR
    FIELD Complement AS CHAR
    FIELD Street     AS CHAR
    FIELD City       AS CHAR
    FIELD Number     AS CHAR
    FIELD State      AS CHAR
    FIELD Country    AS CHAR.

procedure piSaleOrder:
  define input  parameter jsonInput  as JsonObject no-undo.
  define output parameter jsonOutput as JsonObject no-undo.
  EMPTY TEMP-TABLE tt-address .
  EMPTY TEMP-TABLE tt-prestac .
  EMPTY TEMP-TABLE tt-cond-pagto .
  EMPTY TEMP-TABLE tt-grupo .
  EMPTY TEMP-TABLE tt-comissao .
  EMPTY TEMP-TABLE tt-item .
  EMPTY TEMP-TABLE tt-erro .

  /*MESSAGE "sale order 1"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

  define variable oResponse              as JsonAPIResponse no-undo.
  define variable jsonObjectOutput       as JsonObject      no-undo.
  define variable jsonObjectPayload      as jsonObject      no-undo.
  define variable jsonArrayPayment       as jsonArray       no-undo.
  define variable jsonObjectGroup        as jsonObject      no-undo.
  define variable jsonArrayGroup         as jsonArray       no-undo.
  define variable jsonArrayCommission    as jsonArray       no-undo.  
  define variable jsonObjectCommission   as jsonObject      no-undo.
  define variable jsonArrayAddress       as jsonArray       no-undo.
  define variable jsonObjectAddress      as jsonObject      no-undo.
  define variable objSaleOrder           as JsonObject      no-undo.
  define variable oJsonObject            as JsonObject      no-undo.
  DEFINE VARIABLE jsonObjectPayment      as JsonObject      no-undo.
  define variable arraySaleorder         as jsonArray       no-undo.
  define variable jsonArrayItems         as jsonArray       no-undo.
  define variable jsonArrayPayload       as jsonArray       no-undo.
  define variable jsonArrayMethod        as jsonArray       no-undo.
  define variable jsonArrayInstall       as jsonArray       no-undo.

  define variable oJsonArray             as jsonArray       no-undo.
  define variable origin                 as character       no-undo.
  define variable orderId                as character       no-undo format "x(60)".
  define variable accountExternalId      as character       no-undo format "x(60)".
  define variable finallity              as character       no-undo.
  define variable siteCode               as character       no-undo.
  define variable paymentCondition       as integer         no-undo. 
  define variable partialBillingAllowed  as logical         no-undo.
  define variable financialApproval      as logical         no-undo. 
  define variable accountCurrency        as CHARACTER       no-undo.
  define variable effectiveDate          as character       no-undo.
  define variable orderComments          as character       no-undo format "x(200)".
  define variable representativeCode     as integer         no-undo.
  define variable attendantCode          as character       no-undo.
  define variable supervisorRegistration as character       no-undo.
  define variable shippingCost           as decimal         no-undo.
  define variable poNumber               as char            no-undo.
  define variable projectRegisterNumber  as character       no-undo.
  define variable fiscalObservation      as character       no-undo.
  define variable dtNegociacao           as DATE            no-undo.
  define variable diasNegociacao         AS INTEGER         no-undo.
  define variable dtFaturamento          as DATE            no-undo.
  define variable projectCode            as character       no-undo.
  define variable externalID             as character       no-undo.  
  define variable totalService           as decimal         no-undo.
  DEFINE VARIABLE serviceContract        AS CHARACTER       NO-UNDO.

  define variable i-cont                 as integer         no-undo.
  define variable i-inst                 as integer         no-undo.
  define variable i-grp                  as integer         no-undo.
  define variable c-pedido               as character       no-undo. 
  define variable c-status               as character       no-undo. 
  define variable c-sequence             as character       no-undo. 
  define variable c-observacao           as character       no-undo format 'X(2000)'.
  DEFINE VARIABLE c-negociacao           AS CHAR.
  DEFINE VARIABLE c-faturamento          AS CHAR.

 /* MESSAGE "sale order 2"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

  if jsonInput:has("payload") THEN DO:

     /* MESSAGE "sale order 3"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */


    assign jsonObjectPayload    = jsonInput:GetJsonObject("payload").
    //       jsonArrayPayload     = jsonObjectPayload:getJsonArray("OrderItems").
    
    IF jsonObjectPayload:has("GroupItems") THEN
        ASSIGN jsonArrayGroup     = jsonObjectPayload:getJsonArray("GroupItems").

   /* MESSAGE "sale order 4"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    IF jsonObjectPayload:has("Commissions") THEN
        ASSIGN jsonArrayCommission = jsonObjectPayload:getJsonArray("Commissions").    

  /*  MESSAGE "sale order 5"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    IF jsonObjectPayload:has("ShippingAddress") THEN
        ASSIGN jsonObjectAddress   = jsonObjectPayload:getJsonObject("ShippingAddress").

   /* MESSAGE "sale order 6"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    IF jsonObjectPayload:has("OrderItems") THEN
        ASSIGN jsonArrayPayload   = jsonObjectPayload:getJsonArray("OrderItems").

   /* MESSAGE "sale order 7"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    IF jsonObjectPayload:has("PaymentDetail") THEN
        ASSIGN jsonArrayPayment   = jsonObjectPayload:GetJsonArray("PaymentDetail").

   /* MESSAGE "sale order 8"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
    
    assign origin                             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"origin").
           orderId                            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"orderId").
           accountExternalId                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"accountExternalId").
           finallity                          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"finallity").
           siteCode                           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"siteCode").     
           paymentCondition                   = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"paymentCondition")).     
           partialBillingAllowed              = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"partialBillingAllowed")).
           accountCurrency                    = (JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"accountCurrency")).     
           effectiveDate                      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"effectiveDate").
           orderComments                      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"orderComments").
           representativeCode                 = integer(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"representativeCode")).
           attendantCode                      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"attendantCode").
           supervisorRegistration             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"supervisorRegistration").
           shippingCost                       = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"shippingCost")).
           poNumber                           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"poNumber").
           projectRegisterNumber              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"projectRegisterNumber").
           fiscalObservation                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"fiscalObservation").
           c-Negociacao                       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"tradingBaseDate").
           diasNegociacao                     = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"tradingDays")).
           c-faturamento                      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"expectedBillingDate").
           projectCode                        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"orderId").  /* RF001 */
           externalID                         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"externalId").   /* RF001 */
           totalService                       = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"totalService")). /* RF001 */
           financialApproval                  = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"financialApproval")) /* RF013 */.    
           serviceContract                    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"serviceContract").  /*  */
           

   /* MESSAGE "sale order 9"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
               
    IF c-Negociacao <> '' THEN
       ASSIGN dtNegociacao = DATE(int(substr(c-negociacao,6,2)),int(SUBSTR(c-negociacao,9,2)),int(SUBSTR(c-negociacao,1,4))).

    IF c-Faturamento <> '' THEN
       ASSIGN dtFaturamento = DATE(int(substr(c-faturamento,6,2)),int(SUBSTR(c-faturamento,9,2)),int(SUBSTR(c-faturamento,1,4))).

    /* /* RF009 */ 
    "paymentDetail": [
       {
           "method": "creditCard",
           "installments": [
               {
                   "dueDate": "2023-01-03",
                   "ammount": 250.0
               },
               {
                   "dueDate": "2023-02-03",
                   "ammount": 250.0
               },
               {
                   "dueDate": "2023-03-03",
                   "ammount": 250.0
               }
           ],
           "tid": "465sd546fs45df546sd",
           "referenceNumber": "123456",
           "processor": "MASTERCARD",
           "number": "4444"
       },
       {
           "method": "pix",
           "installments": [
               {
                   "dueDate": "2022-01-03",
                   "ammount": 300.0
               }
           ],
           "tid": "a5s4df45435445f46fsd45f5"
       }
    ],
    */
    /* Testado */
    /* RF009 */ 
    IF /*paymentCondition = 0 
    AND*/ VALID-OBJECT (jsonArrayPayment) THEN DO:        
        DO i-cont = 1 TO jsonArrayPayment:LENGTH: 
            ASSIGN jsonObjectPayment = jsonArrayPayment:getJsonObject(i-cont).
            CREATE tt-cond-pagto.
            ASSIGN tt-cond-pagto.method    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayment, "method")
                   tt-cond-pagto.tid       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayment, "tid")
                   tt-cond-pagto.reference = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayment, "referenceNumber")
                   tt-cond-pagto.processor = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayment, "processor")
                   tt-cond-pagto.number    = INT (JsonAPIUtils:getPropertyJsonObject(jsonObjectPayment, "number"))
                   tt-cond-pagto.sequencia = i-cont.				   
            ASSIGN jsonArrayInstall = jsonObjectPayment:getJsonArray("installments").
            DO i-inst = 1 TO jsonArrayInstall:LENGTH:
                CREATE tt-prestac.
                ASSIGN tt-prestac.method    = tt-cond-pagto.method
                       tt-prestac.reference = tt-cond-pagto.reference
                       tt-prestac.data      = jsonArrayInstall:getJSONObject(i-inst):getdate("dueDate")
                       tt-prestac.valor     = DEC (JsonAPIUtils:getPropertyJsonObject(jsonArrayInstall:getJSONObject(i-inst), "ammount")).
            END.
        END.
    END.

    /* RF014
        "ShippingAddress": {
            "district": "COLUMBIA",
            "complement": "SALA A",
            "number": "157",
            "city": "SAO PAULO",
            "country": "Brasil",
            "countryCode": "BR",
            "postalCode": "02234100",
            "state": "SÆo Paulo",
            "stateCode": "SP",
            "street": "RUA HAROLDO MADUREIRA RIBEIRO"
        },
     */

    /* Testado */
    /* RF014 */ 
    IF origin MATCHES "*Solar*" 
    AND VALID-OBJECT (jsonObjectAddress) THEN DO:
        CREATE tt-address.
        ASSIGN tt-address.District   = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"district")
               tt-address.Cep        = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"postalCode")
               tt-address.Complement = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"complement")
               tt-address.Street     = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"street")
               tt-address.City       = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"city")
               tt-address.Number     = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"Number")
               tt-address.State      = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"stateCode")
               tt-address.Country    = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress,"country").               
    END.

    /* RF011
      "comission": [
          {
              "cnpj": "BR09544884000624",
              "percentual": 6.0,
              "valor": 54.0
          }
      ],
    */

    IF origin MATCHES "*Solar*" 
    AND VALID-OBJECT (jsonArrayCommission) THEN DO:
        DO i-cont = 1 TO jsonArrayCommission:LENGTH:
            ASSIGN jsonObjectCommission = jsonArrayCommission:getJsonObject(i-cont).
            CREATE tt-comissao.
																																			  
            ASSIGN tt-comissao.cnpj       = JsonAPIUtils:getPropertyJsonObject(jsonObjectCommission,"externalId")
																																						  
																																							
                   tt-comissao.percentual = DEC (JsonAPIUtils:getPropertyJsonObject(jsonObjectCommission,"percentual"))
																																								
                   tt-comissao.valor      = DEC (JsonAPIUtils:getPropertyJsonObject(jsonObjectCommission,"valor")).           
																																							  
																																						
									 
																																			 
        END.
    END.

    /*
      "groupItems": [
           {
               "name": "Gerador Solar On Grid 2.15kWp",
               "ncm": "8501.72.10",
               "items": [
                   10,
                   20
               ],
               "unitPrice": 700.0,
               "quantity": 1.0
           }
       ],
    */
    
    IF origin MATCHES "*Solar*" 
    AND VALID-OBJECT (jsonArrayGroup) THEN DO:
        DO i-grp = 1 TO jsonArrayGroup:LENGTH:
            ASSIGN jsonObjectGroup = jsonArrayGroup:getJsonObject(i-grp).
            CREATE tt-grupo.
            ASSIGN tt-grupo.ncm       = JsonAPIUtils:getPropertyJsonObject(jsonObjectGroup,"ncm")
                   tt-grupo.name      = JsonAPIUtils:getPropertyJsonObject(jsonObjectGroup,"name")    
                   tt-grupo.unitPrice = DEC (JsonAPIUtils:getPropertyJsonObject(jsonObjectGroup,"unitPrice"))
                   tt-grupo.quantity  = DEC (JsonAPIUtils:getPropertyJsonObject(jsonObjectGroup,"quantity")).
            ASSIGN jsonArrayItems = jsonObjectGroup:getJsonArray("sequences").            
            DO i-cont = 1 TO jsonArrayItems:LENGTH:
                ASSIGN tt-grupo.items = tt-grupo.items + "," 
                                      + STRING (jsonArrayItems:getinteger (i-cont)).
            END.
        END.
    END.

    assign i-cont = 0.

    if JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(1),"sequence") <> " " THEN DO:

       it_blk:
       repeat:
         assign i-cont = i-cont + 1.
         //IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-cont),"sequence") = '' THEN LEAVE.
         c-sequence = JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-cont),"sequence") NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
            LEAVE it_blk.
         
         create tt-item.
         assign tt-item.sequencia             = INT(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "sequence"))
                tt-item.it-codigo             =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "productCode")
                tt-item.qt-pedida             = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "quantity"))
                tt-item.preco-unit            = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "unitPrice"))
                tt-item.ordem-compra          =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "orderItemPoNumber")
                tt-item.item-obs              =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "itemObservation")
                tt-item.desconto-com          = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "commercialDiscount"))
                tt-item.desconto-qtd          = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "quantityDiscount")).
                tt-item.desconto-kit          = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "kitItemDiscountPercent")).
                tt-item.nr-tabpre             =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "priceBook").
                tt-item.executivo             = INT(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "executiveCode")).
                tt-item.segmento-portifolio   =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "portfolioSegmentation").
                tt-item.desc-maisverde        = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "greenerPercentDiscount")).
                tt-item.desc-topmilhao        = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "topMillionPercentDiscount")).
                tt-item.desc-focounidade      = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "unitFocusedPercentDiscount")).
                tt-item.desc-distrib20        = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "distributorTwoZeroPercentDiscount")).
                tt-item.desc-widecloud        = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "wideCloudPercentDiscount")).
                c-faturamento                 =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "expectedBillingDate").
          IF c-faturamento <> '' THEN
             ASSIGN tt-item.dt-prev-fat = DATE(int(substr(c-faturamento,6,2)),int(SUBSTR(c-faturamento,9,2)),int(SUBSTR(c-faturamento,1,4))).
       END.
    END.
  END.

  if search("esp/wso/in/wso0010.r") <> ?
  or search("esp/wso/in/wso0010.p") <> ?
  then do:
    run esp/wso/in/wso0010.p (input  origin, 
                              input  orderId,
                              input  accountExternalId,
                              input  finallity,
                              input  siteCode,
                              input  paymentCondition,
                              input  partialBillingAllowed,
                              input  accountCurrency,
                              input  effectiveDate,
                              input  orderComments,
                              input  representativeCode,
                              input  attendantCode,
                              input  supervisorRegistration,
                              input  shippingCost,
                              input  poNumber,
                              input  projectRegisterNumber,
                              input  fiscalObservation,
                              INPUT  dtNegociacao,
                              INPUT  diasNegociacao,
                              INPUT  dtFaturamento,
                              INPUT  projectCode,
                              INPUT  externalID,
                              INPUT  totalService,
                              INPUT  financialApproval,
                              INPUT  serviceContract,
                              output c-pedido,
                              output c-status,
                              output c-observacao,
                              INPUT-OUTPUT TABLE tt-comissao,
                              INPUT-OUTPUT TABLE tt-grupo,
                              INPUT-OUTPUT TABLE tt-item,
                              INPUT-OUTPUT TABLE tt-cond-pagto,
                              INPUT-OUTPUT TABLE tt-prestac,
                              INPUT-OUTPUT TABLE tt-address,
                              output       table tt-erro).
  end.

  assign arraySaleOrder = new JsonArray().
         objSaleOrder   = new JsonObject().
         objSaleOrder:add("originalOrderId", string(orderId)).
         objSaleOrder:add("erpOrderId",      string(c-pedido)).
         objSaleOrder:add("status",          string(c-status)).
         objSaleOrder:add('orderComments',   string(c-observacao)).

  arraySaleOrder:add(objSaleOrder).

  jsonObjectOutput = new jsonObject().
  jsonObjectOutput:add("SaleOrder", arraySaleOrder ).

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

