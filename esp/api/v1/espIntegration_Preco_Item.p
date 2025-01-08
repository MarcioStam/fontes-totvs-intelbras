/****************************************************************************************************
** Intelbras - Catia Schmauch
**
** API Rest Retorno JSON tt-item - retorno do pre»o do item com impostos
**
** 08/06/2021 - VERSÇO INICIAL
**

Dados de entrada:


{"priceTable":"vareg-sp",
 "typeOfTrading":"UniqueSale",
 "finallity":"Revenda",
 "customerCode":"281457",
 "payCondition":"501",
 "customerType":"Pessoa Jur¡dica",
 "icmsTaxpayer":true,
 "ie":"054473918",
 "suframaCode":"210177659",
 "uf":"SP",
 "cep":"69083020",
 "alcClient":"false",
 "internalSpecialRegime":"false",
 "formTaxation":"NÆo Cumulativo",
 "shippingHandling":"0.0",
 "itens":[
    {"price": 0.00,
         "product": "4143011",
         "priceTable": "vareg-SP",
         "discount": 0.00,
         "quantity": 1,
         "siteCode": 105,
         "parentKit": "",
         "kitItemDiscountPercent": 0.00,
         "greenerPercentDiscount": 2.00,
         "topMillionPercentDiscount": 1.25,
         "unitFocusedPercentDiscount": 1.5,
         "distributorTwoZeroPercentDiscount": 2.00,
         "wideCloudPercentDiscount": 1.00
      }]
}
 
Dados de sa­da:


{
   "returnedItens":[
      {
         "product":"1920158",
         "siteCode":"104",
         "operationNature":"610100",
         "price":12.36,
         "quantity":2.0,
         "commercialDiscount":2.0,
         "quantityDiscount":2.0,
         "pisValue":0.0,
         "percentPIS":20.3,
         "ISS":4.0,
         "percentISS":5.0,
         "ICMS":0.4,
         "percentICMS":12.0,
         "ICMSST":0.3,
         "percentICMSST":0.3,
         "IPI":2.0,
         "percentIPI":2.9,
         "COFINS":0.0,
         "percentCOFINS":10.9,
         "totalPrice":22.4
         "discountFactor": 0,9888
      }
   ]
}
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piPriceItem POST /~*}
{utp/ut-api-notfound.i} 

    DEFINE TEMP-TABLE tt-erro  NO-UNDO
           FIELD codigo     AS INT
           FIELD informacao AS CHAR
           FIELD mensagem   AS CHARACTER FORMAT "x(250)".

    def temp-table tt-item NO-UNDO
        field it-codigo            LIKE ped-item.it-codigo
        FIELD log-servico          AS LOG
        field cod-estabel          AS CHAR
        field nat-operacao         LIKE ped-item.nat-operacao
        field preco-unit           LIKE ped-item.vl-preuni
        field quant-min            LIKE ped-item.qt-pedida
        FIELD parentKit            LIKE ped-item.it-codigo
        FIELD segmento             LIKE int-segmento-portifolio.descricao
        FIELD nr-tabpre            LIKE preco-item.nr-tabpre
        FIELD kit-desconto         AS DECIMAL DECIMALS 4
        field perc-desconto        as decimal DECIMALS 4
        field perc-desc-qt         as decimal DECIMALS 4
        FIELD desc-indice-finan    AS DECIMAL DECIMALS 4
        FIELD val-desconto         AS DECIMAL DECIMALS 4
        field vl-pis               AS DECIMAL DECIMALS 4
        FIELD perc-pis             AS DECIMAL DECIMALS 4
        field vl-iss               AS DECIMAL DECIMALS 4
        FIELD perc-iss             AS DECIMAL DECIMALS 4
        field vl-icms              AS DECIMAL DECIMALS 4
        FIELD perc-icms            AS DECIMAL DECIMALS 4
        field vl-icmsst            AS DECIMAL DECIMALS 4
        field vl-ipi               AS DECIMAL DECIMALS 4
        field perc-ipi             AS DECIMAL DECIMALS 4
        field vl-cofins            AS DECIMAL DECIMALS 4
        FIELD perc-cofins          AS DECIMAL DECIMALS 4
        field preco-total          AS DECIMAL DECIMALS 4
        FIELD fator-desconto       AS DECIMAL DECIMALS 4
        FIELD desconto-maisverde   AS decimal DECIMALS 4
        FIELD desconto-topmilhao   AS decimal DECIMALS 4
        FIELD desconto-focounid    AS decimal DECIMALS 4
        FIELD desconto-distrib20   AS decimal DECIMALS 4
        FIELD desconto-widecloud   AS decimal DECIMALS 4.    

    DEFINE TEMP-TABLE tt-item-envio   NO-UNDO LIKE tt-item.
    DEFINE TEMP-TABLE tt-item-retorno NO-UNDO LIKE tt-item.
    DEFINE TEMP-TABLE tt-erro-geral   NO-UNDO LIKE tt-erro.


/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/


PROCEDURE piPriceItem:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
    DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
    
    DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.
    DEFINE VARIABLE jsonArrayPayload        AS jsonArray    NO-UNDO.

    DEFINE VARIABLE priceTable              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE purchaseGoal               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE payCondition            AS INTEGER     NO-UNDO. 
    DEFINE VARIABLE customerType            AS CHAR        NO-UNDO.
    DEFINE VARIABLE isICMSTaxPayer          AS CHAR        NO-UNDO.
    DEFINE VARIABLE stateRegistration       AS CHAR        NO-UNDO.
    DEFINE VARIABLE suframaCode             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE billingStateCode        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE billingPostalCode       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE freeTradeAreaCustomer   AS CHAR        NO-UNDO.
    DEFINE VARIABLE internalSpecialRegime   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE formTaxation            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE customercode            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE shippingHandling        AS DECIMAL DECIMALS 4    NO-UNDO.
    DEFINE VARIABLE typeOfTrading           AS CHAR        NO-UNDO.
    DEFINE VARIABLE i-cont                  AS INTEGER NO-UNDO. 
    DEFINE VARIABLE ijsonArrayPayload       AS INTEGER NO-UNDO. 

    EMPTY TEMP-TABLE tt-item-envio.
    EMPTY TEMP-TABLE tt-item-retorno.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-geral.

    IF jsonInput:has("payload") THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload")
               jsonArrayPayload     = jsonObjectPayload:getJsonArray("itens").       

        ASSIGN priceTable                =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"priceTable")            .
               typeOfTrading             =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"typeOfTrading").
               purchaseGoal              =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"finallity")             .
               customercode              = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"customerCode")).
               payCondition              = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"payCondition"))     .     
               customerType              =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"customerType")          .
               isICMSTaxPayer            =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"icmsTaxpayer").     
               stateRegistration         =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"ie")                    .
               suframaCode               =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"suframaCode")           .
               billingStateCode          =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"uf")                    .
               billingPostalCode         =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"cep")                   .
               freeTradeAreaCustomer     =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"alcClient").
               internalSpecialRegime     =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"internalSpecialRegime").
               formTaxation              =     JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"formTaxation").
               shippingHandling          = DEC(REPLACE(REPLACE(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"shippingHandling"),",",""),".",",")).
      
        assign i-cont = 0.

        DO i-cont = 1 TO jsonArrayPayload:LENGTH: 
            IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-cont),"price") = '' THEN LEAVE.
               
               CREATE tt-item.                
               ASSIGN tt-item.preco-unit         = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "price"))
                      tt-item.it-codigo          =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "product")
                      tt-item.nr-tabpre          =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "priceTable")
                      tt-item.perc-desconto      = dec(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "discount"))
                      tt-item.quant-min          = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "quantity"))
                      tt-item.cod-estabel        =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "siteCode")
                      tt-item.parentkit          =       JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "parentKit")
                      tt-item.kit-desconto       = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "kitItemDiscountPercent"))
                      tt-item.desconto-maisverde = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "greenerPercentDiscount"))
	                  tt-item.desconto-topmilhao = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "topMillionPercentDiscount"))
	                  tt-item.desconto-focounid  = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "unitFocusedPercentDiscount"))
	                  tt-item.desconto-distrib20 = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "distributorTwoZeroPercentDiscount"))
	                  tt-item.desconto-widecloud = DEC(  JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(i-Cont), "wideCloudPercentDiscount")).
               
               MESSAGE i-cont 'CONTADOR PARA VER O ERRO DE ESTOURO'.
        END.
    END.


    FOR EACH tt-item:

        CREATE tt-item-envio.
        BUFFER-COPY tt-item TO tt-item-envio.

        IF SEARCH("esp/wso/eswso0010.r") <> ?
        OR SEARCH("esp/wso/eswso0010.p") <> ? THEN DO:
            run esp/wso/eswso0010.p (INPUT priceTable,             
                                     INPUT purchaseGoal,              
                                     INPUT payCondition,           
                                     INPUT customerType,           
                                     INPUT isICMSTaxPayer,           
                                     INPUT stateRegistration,                     
                                     INPUT suframaCode ,           
                                     INPUT billingStateCode ,                    
                                     INPUT billingPostalCode,                    
                                     INPUT freeTradeAreaCustomer ,             
                                     INPUT internalSpecialRegime, 
                                     INPUT formTaxation,
                                     INPUT customerCode,
                                     INPUT shippingHandling,
                                     INPUT typeOfTrading,
                                     INPUT-OUTPUT TABLE tt-item-envio,
                                     OUTPUT TABLE tt-erro).

           FIND FIRST tt-item-envio NO-ERROR.
           IF AVAIL tt-item-envio THEN DO: 
               
              CREATE tt-item-retorno.
              BUFFER-COPY tt-item-envio TO tt-item-retorno.
              
           END.

           IF CAN-FIND(FIRST tt-erro) THEN DO:
               FOR EACH tt-erro:
                   CREATE tt-erro-geral.
                   BUFFER-COPY tt-erro TO tt-erro-geral.
               END.
           END.
        END.
        EMPTY TEMP-TABLE tt-item-envio.
    END.
      
    ASSIGN arrayItem  = NEW JsonArray().
    jsonObjectOutput = NEW jsonObject().
      
    IF NOT CAN-FIND(FIRST tt-erro-geral) THEN DO:
       FOR EACH tt-item-retorno NO-LOCK:
           ASSIGN objItem    = NEW JsonObject().
           objItem:ADD("product",             STRING(tt-item-retorno.it-codigo)).
           objItem:ADD("siteCode",            STRING(tt-item-retorno.cod-estabel)).
           objItem:ADD("segmentCode",         STRING(tt-item-retorno.segmento)).
           objItem:ADD("operationNature",     STRING(tt-item-retorno.nat-operaca)).
           objItem:ADD("price",               TRIM(STRING(tt-item-retorno.preco-unit * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("quantity",            STRING(tt-item-retorno.quant-min)).
           objItem:ADD("commercialDiscount",  TRIM(STRING(tt-item-retorno.perc-desconto * 100000,"->>>>>>>>9,99999"))).
           objItem:ADD("quantityDiscount",    TRIM(STRING(tt-item-retorno.perc-desc-qt * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("discountValue",       TRIM(STRING(tt-item-retorno.val-desconto * 100000,"->>>>>>>>9,99999"))).
           objItem:ADD("PIS",                 TRIM(STRING(tt-item-retorno.vl-pis * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("percentPIS",          TRIM(STRING(tt-item-retorno.perc-pis * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("ISS",                 TRIM(STRING(tt-item-retorno.vl-iss * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("percentISS",          TRIM(STRING(tt-item-retorno.perc-iss * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("ICMS",                TRIM(STRING(tt-item-retorno.vl-icms * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("percentICMS",         TRIM(STRING(tt-item-retorno.perc-icms * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("ICMSST",              TRIM(STRING(tt-item-retorno.vl-icmsst * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("IPI",                 TRIM(STRING(tt-item-retorno.vl-ipi * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("percentIPI",          TRIM(STRING(tt-item-retorno.perc-ipi * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("COFINS",              TRIM(STRING(tt-item-retorno.vl-cofins * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("percentCOFINS",       TRIM(STRING(tt-item-retorno.perc-cofins * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("totalPrice",          TRIM(STRING(tt-item-retorno.preco-total * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("itemFactor",          TRIM(STRING(tt-item-retorno.fator-desconto * 100000,">>>>>>>>9,99999"))).
           objItem:ADD("paymentFactor",       TRIM(STRING(tt-item-retorno.desc-indice-finan * 100000,">>>>>>>>9,99999"))).

           IF tt-item-retorno.it-codigo <> '' THEN DO:        
              arrayItem:ADD(objItem).
           END.        
       END. 

       jsonObjectOutput:ADD("returnItens", arrayItem).

       RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).
    END.
    ELSE DO:
        FOR EACH tt-erro-geral:
            ASSIGN objItem    = NEW JsonObject().
    
            objItem:ADD("errorCode", tt-erro-geral.codigo).
            objItem:ADD("errorInfo",tt-erro-geral.informacao).
            objItem:ADD("errorDescription",  tt-erro-geral.mensagem).

            arrayItem:ADD(objItem).
        END. 

        jsonObjectOutput:ADD("returnErrors", arrayItem).

        ASSIGN jsonOutput = NEW jsonObject().
        jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).
    END.                                                              
                                                           
END PROCEDURE.

 
