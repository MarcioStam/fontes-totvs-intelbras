block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
//USING OpenEdge.Core.*. 
USING OpenEdge.Core.String.
//USING OpenEdge.Net.HTTP.*. 
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder. 
USING OpenEdge.Net.URI.
USING com.totvs.framework.api.*.
//USING Progress.Json.ObjectModel.*.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.

{utp/ut-glob.i}
{esp/wso/in/wso0003.i}

DEF TEMP-TABLE ttDue NO-UNDO XML-NODE-NAME 'due'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	FIELD dueDate as CHAR
	FIELD description as char
	FIELD amount as DEC
	FIELD numberOfPayment as INT.
	
DEF TEMP-TABLE ttBilling  NO-UNDO XML-NODE-NAME 'billing'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	FIELD name as char
	FIELD document as char.
	
DEF TEMP-TABLE ttAddress  NO-UNDO XML-NODE-NAME 'address'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	FIELD postCode as char
	field street as char
	field addressNumber as char
	field complement as char
	field neighborhood as char
	field city as char
	field state as char.
	
DEF TEMP-TABLE ttPhone  NO-UNDO XML-NODE-NAME 'phone'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	field telefone as char.
    
DEF TEMP-TABLE ttE-mail  NO-UNDO XML-NODE-NAME 'email'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	field email as char.
	
DEF TEMP-TABLE ttSubscription  NO-UNDO XML-NODE-NAME 'subscription'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
    FIELD description as char
	field id as INT.
	
DEF TEMP-TABLE ttMetadata  NO-UNDO XML-NODE-NAME 'metadata'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD nrDue AS INT
	field name as char
	field dvalue as char.

DEFINE TEMP-TABLE tt-int-ped-venda NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item  NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda-aux NO-UNDO LIKE tt-ped-venda.

DEFINE TEMP-TABLE ttItemSplit NO-UNDO LIKE tt-ped-item
    FIELD cod-servico AS INT.

/***
-due
--billing
---address
---phone
---email    
--subscription
---metadata
***/

/*
DEFINE INPUT PARAMETER p-dt-ini AS data NO-UNDO.
DEFINE INPUT PARAMETER p-dt-fim AS data NO-UNDO.
*/

DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE oResponseMemptrEntity AS OpenEdge.Core.Memptr NO-UNDO. 
DEFINE VARIABLE oByteBucket AS OpenEdge.Core.ByteBucket NO-UNDO. 
DEFINE VARIABLE c-endereco AS CHAR NO-UNDO.
DEFINE VARIABLE c-retorno AS CHAR NO-UNDO.

DEFINE VARIABLE pJsonInput               AS JsonObject   NO-UNDO.
DEFINE VARIABLE pJsonArray               AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonArrayPhone           AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonArrayEmail           AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonObjectIsArray        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectDue            AS JsonObject   NO-UNDO. 
DEFINE VARIABLE jsonObjectBilling        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectAddress        AS JsonObject   NO-UNDO. 
DEFINE VARIABLE jsonObjectPhone          AS JsonObject   NO-UNDO. 
DEFINE VARIABLE jsonObjectEmail          AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectSubscription   AS JsonObject   NO-UNDO. 
DEFINE VARIABLE jsonObjectMetadata       AS JsonObject   NO-UNDO. 

DEFINE VARIABLE jsonObject               AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectPlp            AS JsonObject   NO-UNDO.        

DEFINE VARIABLE jsonObjectDocsExternos   AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectDestinatario   AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectRemetente      AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectAwbs           AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectItens          AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonArrayResumoServicos  AS jsonArray    NO-UNDO.  
DEFINE VARIABLE jsonArrayDocsExternos    AS jsonArray    NO-UNDO. 
DEFINE VARIABLE jsonArrayAwbs            AS jsonArray    NO-UNDO. 
DEFINE VARIABLE jsonArrayItens           AS jsonArray    NO-UNDO. 
DEFINE VARIABLE jsonArrayMetadata        AS jsonArray    NO-UNDO. 

DEFINE VARIABLE iContDue       AS INT NO-UNDO.
DEFINE VARIABLE iContPhone     AS INT NO-UNDO.
DEFINE VARIABLE iContEmail     AS INT NO-UNDO.
DEFINE VARIABLE iContMetadata  AS INT NO-UNDO.
                               
DEFINE VARIABLE c-natureza     AS CHAR INITIAL "500001" NO-UNDO.
DEFINE VARIABLE i              AS INTEGER NO-UNDO.
DEFINE VARIABLE c-servicos     AS CHAR    NO-UNDO.
DEFINE VARIABLE d-vl-liq-it    AS DEC NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe   AS DEC NO-UNDO.
DEFINE VARIABLE l-erro         AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-desc-suspend AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE h-bodi159com   AS HANDLE                      NO-UNDO.

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
    FIELD id-conta-ini     AS INT
    FIELD id-conta-fim     AS INT
    FIELD dt-venc-ini      AS DATE
    FIELD dt-venc-fim      AS DATE
    FIELD dias-param       AS LOG. 

DEFINE INPUT PARAMETER TABLE FOR tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST int-recorrencia-param NO-LOCK NO-ERROR.
IF NOT AVAIL int-recorrencia-param THEN NEXT.

DEF VAR c-dt-ini AS CHAR NO-UNDO.
DEF VAR c-dt-fim AS CHAR NO-UNDO.

IF tt-param.dias-param THEN
    ASSIGN c-dt-ini = STRING(YEAR(TODAY)) + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99")
           c-dt-fim = STRING(YEAR(TODAY + int-recorrencia-param.dias-venc)) + "-" + STRING(MONTH(TODAY + int-recorrencia-param.dias-venc),"99") + "-" + STRING(DAY(TODAY + int-recorrencia-param.dias-venc),"99").
ELSE
    ASSIGN c-dt-ini = STRING(YEAR(tt-param.dt-venc-ini)) + "-" + STRING(MONTH(tt-param.dt-venc-ini),"99") + "-" + STRING(DAY(tt-param.dt-venc-ini),"99")
           c-dt-fim = STRING(YEAR(tt-param.dt-venc-fim)) + "-" + STRING(MONTH(tt-param.dt-venc-fim),"99") + "-" + STRING(DAY(tt-param.dt-venc-fim),"99").

ASSIGN c-endereco = int-recorrencia-param.host + "?status=pendingBoleto,payedBoleto,payExternal&dueDateStart=" + c-dt-ini + "&dueDateEnd=" + c-dt-fim.

def var h-acomp      as handle no-undo.

RUN utp/ut-acomp.p persistent set h-acomp.
RUN pi-inicializar in h-acomp (input "Lendo...").

RUN pi-acompanhar in h-acomp (input "Iniciando").
RUN pi-busca-registros.
RUN pi-acompanhar in h-acomp (input "Ap¢s buscar registros").
RUN pi-grava-registros.

RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

RETURN "OK".

PROCEDURE pi-busca-registros:
        
    //ASSIGN c-endereco = "http://payment.apps.intelbras.com.br/paymentManagement/v1/bills?status=pendingBoleto,payedBoleto&dueDateStart=2021-09-19&dueDateEnd=2021-09-19".
    
    oRequest = RequestBuilder:GET(c-endereco)
                             :AddHeader("Authorization","Bearer 11b4d25b-fb0d-331d-9213-a67c1590c15d")
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest).
    
    RUN pi-acompanhar in h-acomp (input "Ap¢s buscar registros " + STRING(oResponse:StatusCode)).

    IF  oResponse:StatusCode = 200
    AND oResponse:ContentType = "application/json" THEN DO:
        //CAST(oResponse:Entity, JsonArray):Write(c-retorno, true).


        jsonObjectIsArray = CAST(oResponse:Entity, JsonObject) NO-ERROR.


        IF JsonAPIUtils:checkJsonIsArray(jsonObjectIsArray) THEN DO:

            pJsonArray = CAST(oResponse:Entity, JsonArray).

            DO iContDue = 1 TO pJsonArray:LENGTH: 
    
                ASSIGN jsonObjectDue = pJsonArray:GetJsonObject(iContDue).
    
                CREATE ttDue.
                ASSIGN ttDue.idm             = iContDue
                       ttDue.nrDue           = iContDue
                       ttDue.dueDate         = JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "dueDate")
                       ttDue.description     = JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "description")
                       ttDue.amount          = DEC(REPLACE(STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "amount")),".",","))
                       ttDue.numberOfPayment = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "numberOfPayment")).
        
                ASSIGN jsonObjectBilling = jsonObjectDue:GetJsonObject("billing").
        
                CREATE ttBilling.
                ASSIGN ttBilling.idm         = iContDue
                       ttBilling.nrDue       = iContDue
                       ttBilling.name        = JsonAPIUtils:getPropertyJsonObject(jsonObjectBilling, "name")
                       ttBilling.document    = JsonAPIUtils:getPropertyJsonObject(jsonObjectBilling, "document").
    
                RUN pi-acompanhar in h-acomp (input "Buscando Cliente: " + ttBilling.document).
        
                ASSIGN jsonObjectAddress = jsonObjectBilling:GetJsonObject("address").
        
                CREATE ttAddress.
                ASSIGN ttAddress.idm           = iContDue
                       ttAddress.nrDue         = iContDue
                       ttAddress.postCode      = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "postCode")
                       ttAddress.street        = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "street")
                       ttAddress.addressNumber = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "addressNumber")
                       ttAddress.complement    = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "complement")
                       ttAddress.neighborhood  = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "neighborhood")
                       ttAddress.city          = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "city")
                       ttAddress.state         = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "state").
        
                ASSIGN jsonArrayEmail = jsonObjectBilling:getJsonArray("email").
        
                CREATE ttE-mail.
                ASSIGN ttE-mail.idm           = iContDue
                       ttE-mail.nrDue         = iContDue
                       ttE-mail.email         = JsonAPIUtils:getJsonArrayChar(jsonArrayEmail).
        
                ASSIGN jsonArrayPhone = jsonObjectBilling:getJsonArray("phone").
        
                CREATE ttPhone.
                ASSIGN ttPhone.idm           = iContDue
                       ttPhone.nrDue         = iContDue
                       ttPhone.telefone      = "99999999999". //JsonAPIUtils:getJsonArrayChar(jsonArrayPhone)
        
                ASSIGN jsonObjectSubscription = jsonObjectDue:GetJsonObject("subscription").
        
                CREATE ttSubscription.
                ASSIGN ttSubscription.idm         = iContDue
                       ttSubscription.nrDue       = iContDue
                       ttSubscription.id          = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectSubscription, "id"))
                       ttSubscription.description = JsonAPIUtils:getPropertyJsonObject(jsonObjectSubscription, "description").
        
                ASSIGN jsonArrayMetadata = jsonObjectSubscription:getJsonArray("metadata").
                DO iContMetadata = 1 TO jsonArrayMetadata:LENGTH: 
        
                    ASSIGN jsonObjectMetadata = jsonArrayMetadata:GetJsonObject(iContMetadata).
            
                    CREATE ttMetadata.
                    ASSIGN ttMetadata.idm     = iContMetadata
                           ttMetadata.nrDue   = iContDue
                           ttMetadata.name    = JsonAPIUtils:getPropertyJsonObject(jsonObjectMetadata, "name")  
                           ttMetadata.dvalue  = JsonAPIUtils:getPropertyJsonObject(jsonObjectMetadata, "value").
        
                END.
            END.
        END.
        ELSE DO:

            ASSIGN jsonObjectDue = CAST(oResponse:Entity, JsonObject) NO-ERROR.

            CREATE ttDue.
            ASSIGN ttDue.idm             = iContDue
                   ttDue.nrDue           = iContDue
                   ttDue.dueDate         = JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "dueDate")
                   ttDue.description     = JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "description")
                   ttDue.amount          = DEC(REPLACE(STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "amount")),".",","))
                   ttDue.numberOfPayment = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectDue, "numberOfPayment")).
    
            ASSIGN jsonObjectBilling = jsonObjectDue:GetJsonObject("billing").
    
            CREATE ttBilling.
            ASSIGN ttBilling.idm         = iContDue
                   ttBilling.nrDue       = iContDue
                   ttBilling.name        = JsonAPIUtils:getPropertyJsonObject(jsonObjectBilling, "name")
                   ttBilling.document    = JsonAPIUtils:getPropertyJsonObject(jsonObjectBilling, "document").

            RUN pi-acompanhar in h-acomp (input "Buscando Cliente: " + ttBilling.document).
    
            ASSIGN jsonObjectAddress = jsonObjectBilling:GetJsonObject("address").
    
            CREATE ttAddress.
            ASSIGN ttAddress.idm           = iContDue
                   ttAddress.nrDue         = iContDue
                   ttAddress.postCode      = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "postCode")
                   ttAddress.street        = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "street")
                   ttAddress.addressNumber = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "addressNumber")
                   ttAddress.complement    = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "complement")
                   ttAddress.neighborhood  = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "neighborhood")
                   ttAddress.city          = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "city")
                   ttAddress.state         = JsonAPIUtils:getPropertyJsonObject(jsonObjectAddress, "state").
    
            ASSIGN jsonArrayEmail = jsonObjectBilling:getJsonArray("email").
    
            CREATE ttE-mail.
            ASSIGN ttE-mail.idm           = iContDue
                   ttE-mail.nrDue         = iContDue
                   ttE-mail.email         = JsonAPIUtils:getJsonArrayChar(jsonArrayEmail).
    
            ASSIGN jsonArrayPhone = jsonObjectBilling:getJsonArray("phone").
    
            CREATE ttPhone.
            ASSIGN ttPhone.idm           = iContDue
                   ttPhone.nrDue         = iContDue
                   ttPhone.telefone      = "99999999999". //JsonAPIUtils:getJsonArrayChar(jsonArrayPhone)
    
            ASSIGN jsonObjectSubscription = jsonObjectDue:GetJsonObject("subscription").
    
            CREATE ttSubscription.
            ASSIGN ttSubscription.idm         = iContDue
                   ttSubscription.nrDue       = iContDue
                   ttSubscription.id          = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectSubscription, "id"))
                   ttSubscription.description = JsonAPIUtils:getPropertyJsonObject(jsonObjectSubscription, "description").
    
            ASSIGN jsonArrayMetadata = jsonObjectSubscription:getJsonArray("metadata").
            DO iContMetadata = 1 TO jsonArrayMetadata:LENGTH: 
    
                ASSIGN jsonObjectMetadata = jsonArrayMetadata:GetJsonObject(iContMetadata).
        
                CREATE ttMetadata.
                ASSIGN ttMetadata.idm     = iContMetadata
                       ttMetadata.nrDue   = iContDue
                       ttMetadata.name    = JsonAPIUtils:getPropertyJsonObject(jsonObjectMetadata, "name")  
                       ttMetadata.dvalue  = JsonAPIUtils:getPropertyJsonObject(jsonObjectMetadata, "value").
    
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-grava-registros:

    DEFINE VARIABLE i-seq AS INT INITIAL 1 NO-UNDO.
  
    FOR EACH ttDue:

        FIND FIRST ttSubscription 
             WHERE ttSubscription.nrDue = ttDue.nrDue NO-ERROR.
        FIND FIRST ttBilling
             WHERE ttBilling.nrDue = ttDue.nrDue NO-ERROR.

        RUN pi-acompanhar in h-acomp (input "Gravando Cliente1: " + ttBilling.document).
    
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = ttBilling.document NO-ERROR.
        
        IF NOT CAN-FIND(FIRST int-recorrencia-contratos
                        WHERE int-recorrencia-contratos.id-recorrencia = "13917"                      
                          AND int-recorrencia-contratos.nr-contrato    = STRING(INT(ttSubscription.id),"999999") 
                          AND int-recorrencia-contratos.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99") 
                          AND int-recorrencia-contratos.nr-transacao   = "1") THEN DO:

            RUN pi-acompanhar in h-acomp (input "Gravando Cliente2: " + ttBilling.document).
        
            CREATE int-recorrencia-contratos.
            ASSIGN int-recorrencia-contratos.id-recorrencia = "13917"                      
                   int-recorrencia-contratos.nr-contrato    = STRING(INT(ttSubscription.id),"999999")    
                   int-recorrencia-contratos.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99")
                   int-recorrencia-contratos.nr-transacao   = "1"                          
                   int-recorrencia-contratos.cod-emitente   = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0                                                                                        
                   int-recorrencia-contratos.dt-venc        = DATE(SUBSTRING(ttDue.dueDate,9,2) + "/" + SUBSTRING(ttDue.dueDate,6,2) + "/" + SUBSTRING(ttDue.dueDate,1,4)) 
                   int-recorrencia-contratos.observacao     = ttSubscription.description                                                                                            
                   int-recorrencia-contratos.valor          = ttDue.amount                                                                                                 
                   int-recorrencia-contratos.cod-sit-trans  = "Incluida".

        END.

        FIND FIRST int-recorrencia-contratos NO-LOCK
             WHERE int-recorrencia-contratos.id-recorrencia = "13917"                      
               AND int-recorrencia-contratos.nr-contrato    = STRING(INT(ttSubscription.id),"999999")    
               AND int-recorrencia-contratos.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99")
               AND int-recorrencia-contratos.nr-transacao   = "1" NO-ERROR.

        IF int-recorrencia-contratos.cod-sit-trans  = "Incluida" THEN DO:

            FIND LAST int-recorrencia-historico NO-LOCK
                WHERE int-recorrencia-historico.id-recorrencia = "13917"
                  AND int-recorrencia-historico.nr-contrato    = STRING(INT(ttSubscription.id),"999999") 
                  AND int-recorrencia-historico.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99")
                  AND int-recorrencia-historico.nr-transacao   = "1" NO-ERROR.
            IF AVAIL int-recorrencia-historico THEN
                ASSIGN i-seq = int-recorrencia-historico.nr-sequencia + 1.
                                                                                                                                                                           
            CREATE int-recorrencia-historico.                                                                                                                               
            ASSIGN int-recorrencia-historico.id-recorrencia = "13917"       
                   int-recorrencia-historico.nr-contrato    = STRING(INT(ttSubscription.id),"999999") 
                   int-recorrencia-historico.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99") 
                   int-recorrencia-historico.nr-transacao   = "1"                             
                   int-recorrencia-historico.nr-sequencia   = i-seq
                   int-recorrencia-historico.dt-evento      = TODAY                                                                                                          .
                   int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                          .
                   int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                  .
                   int-recorrencia-historico.desc-evento    = "Inserido a transa‡Æo no sistema".

            FIND FIRST ttMetadata
                 WHERE ttMetadata.nrDue  = ttDue.nrDue
                   AND ttMetadata.name   = "CP_STATUS_DO_SERVICO"
                   AND ttMetadata.dvalue = "Suspenso" NO-ERROR.
            IF AVAIL ttMetadata THEN DO:

                ASSIGN i-seq = i-seq + 1.

                RUN pi-acompanhar in h-acomp (input "Gravando Cliente3: " + ttBilling.document).
                CREATE int-recorrencia-historico.                                                                                                                               
                ASSIGN int-recorrencia-historico.id-recorrencia = "13917"       
                       int-recorrencia-historico.nr-contrato    = STRING(INT(ttSubscription.id),"999999") 
                       int-recorrencia-historico.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99") 
                       int-recorrencia-historico.nr-transacao   = "1"                             
                       int-recorrencia-historico.nr-sequencia   = i-seq
                       int-recorrencia-historico.dt-evento      = TODAY                                                                                                          .
                       int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                          .
                       int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                  .
                       int-recorrencia-historico.desc-evento    = "Contrato suspenso".
            END.
            ELSE DO:

                RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente1: " + ttBilling.document).



                RUN pi-gera-pedido.

                /*
                CREATE int-recorrencia-historico.                                                                                                                               
                ASSIGN int-recorrencia-historico.id-recorrencia = "13917"       
                       int-recorrencia-historico.nr-contrato    = STRING(INT(ttSubscription.id),"999999") 
                       int-recorrencia-historico.nr-parcela     = STRING(INT(ttDue.numberOfPayment),"99") 
                       int-recorrencia-historico.nr-transacao   = "1"                             
                       int-recorrencia-historico.nr-sequencia   = 2
                       int-recorrencia-historico.dt-evento      = TODAY                                                                                                          .
                       int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                          .
                       int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                  .
                       int-recorrencia-historico.desc-evento    = "Pedido gerado".*/


            END.
        END.                                                                             .
    END.

END PROCEDURE.

PROCEDURE pi-gera-pedido:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-rua               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-comp              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.

    DEFINE VARIABLE iXML AS LONGCHAR   NO-UNDO.
    DEFINE VARIABLE oXML AS LONGCHAR   NO-UNDO.

    EMPTY TEMP-TABLE ttPedido.
    EMPTY TEMP-TABLE ttCondicaoPagamento.
    EMPTY TEMP-TABLE ttpessoaFisica.
    EMPTY TEMP-TABLE ttpessoaJuridica.
    EMPTY TEMP-TABLE ttTelefone.
    EMPTY TEMP-TABLE ttEmail.
    EMPTY TEMP-TABLE ttDocumento.
    EMPTY TEMP-TABLE ttEndereco.
    EMPTY TEMP-TABLE ttItem.
    EMPTY TEMP-TABLE ttPedidoPJ.
    EMPTY TEMP-TABLE ttCondicaoPagamentoPJ.
    EMPTY TEMP-TABLE ttpessoaJuridicaPJ.
    EMPTY TEMP-TABLE ttTelefonePJ.
    EMPTY TEMP-TABLE ttEmailPJ.
    EMPTY TEMP-TABLE ttDocumentoPJ.
    EMPTY TEMP-TABLE ttEnderecoPJ.
    EMPTY TEMP-TABLE ttItemPJ.

    RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente2: " + ttBilling.document).

    IF int-recorrencia-contratos.cod-emitente <> 0 THEN
        FIND FIRST emitente WHERE emitente.cod-emitente = int-recorrencia-contratos.cod-emitente NO-LOCK NO-ERROR.
    
    CREATE ttPedido.
    ASSIGN ttPedido.numeroPedido      = "GLX-" + int-recorrencia-contratos.id-recorrencia + "-" + int-recorrencia-contratos.nr-contrato + "-" + int-recorrencia-contratos.nr-parcela
           ttPedido.sequenciaPedido   = ttPedido.numeroPedido
           ttPedido.codigoLoja        = "1"
           ttPedido.marketplace       = "GLX"
           ttPedido.statusPedido      = "ready-for-handling"
           ttPedido.dataCriacao       = TODAY
           ttPedido.totalItens        = int-recorrencia-contratos.valor
           ttPedido.totalPedido       = int-recorrencia-contratos.valor
           ttPedido.totalDesconto     = 0
           ttPedido.totalFrete        = 0
           ttPedido.totalTaxas        = 0
           ttPedido.descontoMarketplace = 0
           ttPedido.valorPagamento = int-recorrencia-contratos.valor
           ttPedido.moedaCorrente     = "BRL".
           
    CREATE ttCondicaoPagamento.
    ASSIGN ttCondicaoPagamento.formaPagamento      = "0"                    
           ttCondicaoPagamento.dataCaptura         = TODAY                  
           ttCondicaoPagamento.quantidadeParcelas  = 1                      
           ttCondicaoPagamento.valorTotal          = int-recorrencia-contratos.valor
           ttCondicaoPagamento.finalCartao         = 0                      
           ttCondicaoPagamento.idAutorizacao       = ttPedido.numeroPedido  
           ttCondicaoPagamento.nsu                 = ttPedido.numeroPedido
           ttCondicaoPagamento.tid                 = ttPedido.numeroPedido
           ttCondicaoPagamento.numeroReferencia    = ttPedido.numeroPedido.

    CREATE ttItem.
    ASSIGN ttItem.codigoItem           = int-recorrencia-contratos.observacao
           ttItem.quantidade           = 1
           ttItem.precoItem            = int-recorrencia-contratos.valor     
           ttItem.valorDesconto        = 0
           ttItem.estabelecimento      = "101"     
           ttItem.codigoTransportadora = "0".

    IF AVAIL emitente THEN DO:

        RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente3: " + ttBilling.document).

        IF emitente.natureza <> 1 THEN DO:
            CREATE ttpessoaJuridica.
            ASSIGN ttpessoaJuridica.nomeFantasia = emitente.nome-emit.
    
            CREATE ttDocumento.
            ASSIGN ttDocumento.tipoDocumento   = "inscricaoEstadual"  
                   ttDocumento.numeroDocumento = emitente.ins-estadual.
        END.
        ELSE DO:
            CREATE ttpessoaFisica.
            ASSIGN ttpessoaFisica.nome = emitente.nome-emit.
        END.                                                     

        CREATE ttDocumento.
        ASSIGN ttDocumento.tipoDocumento   = IF emitente.natureza <> 1 THEN "CNPJ" ELSE "CPF"
               ttDocumento.numeroDocumento = emitente.cgc.
    
        CREATE ttTelefone.
        ASSIGN ttTelefone.ddd      = REPLACE(REPLACE(REPLACE(SUBSTRING(emitente.telefone[1],1,2),"-",""),"(",""),")","")
               ttTelefone.telefone = REPLACE(REPLACE(REPLACE(SUBSTRING(emitente.telefone[1],3,9),"-",""),"(",""),")","")
               ttTelefone.tipo     = "Celular".
    
        CREATE ttEmail.
        ASSIGN ttEmail.endereco = emitente.e-mail     
               ttEmail.tipo     = "NFe".

        IF  NOT VALID-HANDLE(h-cdapi704) THEN
            RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
        RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco,
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
        IF  VALID-HANDLE(h-cdapi704) THEN DO:
            DELETE PROCEDURE h-cdapi704.
            ASSIGN h-cdapi704 = ?.
        END.

        CREATE ttEndereco.
        ASSIGN ttEndereco.logradouro  = c-rua
               ttEndereco.cep         = emitente.cep        
               ttEndereco.bairro      = emitente.bairro     
               ttEndereco.municipio   = emitente.cidade     
               ttEndereco.siglaEstado = emitente.estado     
               ttEndereco.complemento = c-comp
               ttEndereco.numero      = c-nro   
               ttEndereco.siglaPais   = emitente.pais
               ttEndereco.tipo        = "principal". 
    END.
    ELSE DO:

        RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente4: " + ttBilling.document).

        IF LENGTH(ttBilling.document) > 11 THEN DO:
            CREATE ttpessoaJuridica.
            ASSIGN ttpessoaJuridica.nomeFantasia = ttBilling.name.
        END.
        ELSE DO:
            CREATE ttpessoaFisica.
            ASSIGN ttpessoaFisica.nome = ttBilling.name.
        END.                                                     

        CREATE ttDocumento.
        ASSIGN ttDocumento.tipoDocumento   = IF LENGTH(ttBilling.document) > 11 THEN "CNPJ" ELSE "CPF"
               ttDocumento.numeroDocumento = ttBilling.document.
    
        CREATE ttTelefone.
        ASSIGN ttTelefone.ddd      = REPLACE(REPLACE(REPLACE(SUBSTRING(ttPhone.telefone,1,2),"-",""),"(",""),")","")
               ttTelefone.telefone = REPLACE(REPLACE(REPLACE(SUBSTRING(ttPhone.telefone,3,9),"-",""),"(",""),")","")
               ttTelefone.tipo     = "Celular".
    
        CREATE ttEmail.
        ASSIGN ttEmail.endereco = ttEmail.endereco   
               ttEmail.tipo     = "NFe".

        IF  NOT VALID-HANDLE(h-cdapi704) THEN
            RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
        RUN pi-trata-endereco IN h-cdapi704 (INPUT  ttAddress.street,
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
        IF  VALID-HANDLE(h-cdapi704) THEN DO:
            DELETE PROCEDURE h-cdapi704.
            ASSIGN h-cdapi704 = ?.
        END.

        IF c-nro = "" THEN
            ASSIGN c-nro = ttAddress.addressNumber.

        IF c-comp = "" THEN
            ASSIGN c-comp = ttAddress.complement.
    
        CREATE ttEndereco.
        ASSIGN ttEndereco.logradouro  = c-rua
               ttEndereco.cep         = ttAddress.postCode       
               ttEndereco.bairro      = ttAddress.neighborhood     
               ttEndereco.municipio   = ttAddress.city     
               ttEndereco.siglaEstado = ttAddress.state     
               ttEndereco.complemento = c-comp
               ttEndereco.numero      = c-nro   
               ttEndereco.siglaPais   = "BRASIL"
               ttEndereco.tipo        = "principal". 
    END.

    FIND FIRST ttpessoaJuridica NO-ERROR.
    IF AVAIL ttpessoaJuridica THEN DO:
        FOR EACH ttPedido:            CREATE ttPedidoPJ.            BUFFER-COPY ttPedido            TO ttPedidoPJ.            END.
        FOR EACH ttCondicaoPagamento: CREATE ttCondicaoPagamentoPJ. BUFFER-COPY ttCondicaoPagamento TO ttCondicaoPagamentoPJ. END.
        FOR EACH ttItem:              CREATE ttItemPJ.              BUFFER-COPY ttItem              TO ttItemPJ.              END.
        FOR EACH ttpessoaJuridica:    CREATE ttpessoaJuridicaPJ.    BUFFER-COPY ttpessoaJuridica    TO ttpessoaJuridicaPJ.    END.
        FOR EACH ttDocumento:         CREATE ttDocumentoPJ.         BUFFER-COPY ttDocumento         TO ttDocumentoPJ.         END.
        FOR EACH ttTelefone:          CREATE ttTelefonePJ.          BUFFER-COPY ttTelefone          TO ttTelefonePJ.          END.
        FOR EACH ttEmail:             CREATE ttEmailPJ.             BUFFER-COPY ttEmail             TO ttEmailPJ.             END.
        FOR EACH ttEndereco:          CREATE ttEnderecoPJ.          BUFFER-COPY ttEndereco          TO ttEnderecoPJ.          END.

        DATASET mensagemPJ:WRITE-XML('longchar', iXML, YES). 
    END.
    ELSE
        DATASET mensagem:WRITE-XML('longchar', iXML, YES).

    
    RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente5: " + ttBilling.document).

    RUN esp/wso/IN/wso0003.p (INPUT iXML,
                              OUTPUT oXML).

    EMPTY TEMP-TABLE ttPedido.
    EMPTY TEMP-TABLE ttCondicaoPagamento.
    EMPTY TEMP-TABLE ttpessoaFisica.
    EMPTY TEMP-TABLE ttpessoaJuridica.
    EMPTY TEMP-TABLE ttTelefone.
    EMPTY TEMP-TABLE ttEmail.
    EMPTY TEMP-TABLE ttDocumento.
    EMPTY TEMP-TABLE ttEndereco.
    EMPTY TEMP-TABLE ttItem.
    EMPTY TEMP-TABLE ttPedidoPJ.
    EMPTY TEMP-TABLE ttCondicaoPagamentoPJ.
    EMPTY TEMP-TABLE ttpessoaJuridicaPJ.
    EMPTY TEMP-TABLE ttTelefonePJ.
    EMPTY TEMP-TABLE ttEmailPJ.
    EMPTY TEMP-TABLE ttDocumentoPJ.
    EMPTY TEMP-TABLE ttEnderecoPJ.
    EMPTY TEMP-TABLE ttItemPJ.

    RUN pi-acompanhar in h-acomp (input "Gerando pedido do cliente6: " + ttBilling.document).
    

END PROCEDURE.

RETURN "OK".
