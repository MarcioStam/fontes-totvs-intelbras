{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-nf get /~*}
{utp/ut-api-notfound.i} 

/************************************************************************************
* Programa ..: API Rest espIntegration_Nota                                         *
* Data ......: 22/02/2022                                                           *
* Empresa ...: iDBA                                                                 *
* Versao ....: 1.00.00.000                                                          *
* Autor .....: Mauricio C.                                                          *
*************************************************************************************
* VERSAO      DATA       RESPONSAVEL  EMPRESA  MOTIVO                               *
* 1.00.00.000 22/02/2022 Mauricio C.  iDBA     Desenvolvimento (chamado #8665)      *
*************************************************************************************/

def var jNF          as JsonObject no-undo.

def var jItens       as jsonObject no-undo.
def var jItem        as JsonObject no-undo.
def var jArrayItem   as JsonArray  no-undo.

def var jFaturas     as jsonObject no-undo.
def var jFatura      as JsonObject no-undo.
def var jArrayFatura as JsonArray  no-undo.

def var jArrayNF     as JsonArray  no-undo.

procedure pi-consulta-nf:
    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse       as JsonAPIResponse      no-undo.
    def var oRequestParser  as JsonAPIRequestParser no-undo.
    def var oJsonObject     as JsonObject           no-undo.
    def var jPrincipal      as JsonObject           no-undo.
    def var jArrayPrincipal as JsonArray            no-undo.

    def var c-cgc        as char no-undo.
    def var dt-startDate as date no-undo.
    def var dt-endDate   as date no-undo.
    def var c-orderCode  as char no-undo.
    def var i-aux        as inte no-undo.
    def var i-num-param  as inte no-undo.

    delete object jNF          no-error.
    delete object jItens       no-error.
    delete object jItem        no-error.
    delete object jArrayItem   no-error.
    delete object jFaturas     no-error.
    delete object jFatura      no-error.
    delete object jArrayFatura no-error.
    delete object jArrayNF     no-error.

    empty temp-table RowErrors.

    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    assign i-num-param = jArrayPrincipal:length no-error.

    if i-num-param > 1 
    then.
    else return.

    do i-aux = 1 to i-num-param:
        case i-aux:
            when 1
            then assign c-cgc = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 2 
            then if i-num-param > 2
                 then assign dt-startDate = OpenEdge.Core.TimeStamp:ToABLDateFromISO(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
                 else assign c-orderCode  = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 3
            then assign dt-endDate = OpenEdge.Core.TimeStamp:ToABLDateFromISO(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
        end case.
    end.

    assign c-cgc = trim(substr(c-cgc,3,16)) no-error.

    if c-cgc = ""
    or c-cgc = ?
    then return. 

    if not can-find(first emitente use-index cgc where
                          emitente.cgc = c-cgc
                          no-lock)
    then return.

    assign i-aux = 0.

    assign jArrayNF = new JsonArray().

    for each emitente use-index cgc no-lock
       where emitente.cgc = c-cgc:
        if  dt-startDate <> ?
        and dt-endDate   <> ?
        then do:
             for each nota-fiscal use-index ch-clinota no-lock
                where nota-fiscal.nome-ab-cli   = emitente.nome-abrev
                  and nota-fiscal.dt-emis-nota >= dt-startDate
                  and nota-fiscal.dt-emis-nota <= dt-endDate,
                first transporte no-lock
                where transporte.nome-abrev = nota-fiscal.nome-transp:
                 assign i-aux = i-aux + 1.
    
                 IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT. // Autorizadas 

                 run pi-array-NF.
             end.

             next.
        end.

        if c-orderCode <> ""
        then for each nota-fiscal use-index ch-pedido no-lock
                where nota-fiscal.nome-ab-cli = emitente.nome-abrev
                  and nota-fiscal.nr-pedcli   = c-orderCode,
                first transporte no-lock
                where transporte.nome-abrev = nota-fiscal.nome-transp:
                 assign i-aux = i-aux + 1.
        
                 IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT. // Autorizadas 

                 run pi-array-NF.
             end.
    end. /* for each emitente */
    
    if i-aux = 0
    then return.

    assign jPrincipal  = new JsonObject().
    assign oJsonObject = new JsonObject().

    jPrincipal:add("nf",jArrayNF).
    oJsonObject:add("nfs",jPrincipal).

    run createJsonResponse(input  oJsonObject, 
                           input  table RowErrors, 
                           input  false,
                           output jsonOutput).   
end procedure. /* procedure pi-consulta-nf */

procedure pi-array-NF:
    def var de-icmsSubValue as deci no-undo.
    def var de-icmsValue    as deci no-undo.
   

    assign jNF = new JsonObject().
    jNF:add("orderCode",nota-fiscal.nr-pedcli).
    jNF:add("nfNumber",nota-fiscal.nr-nota-fis).
    jNF:add("serie",nota-fiscal.serie).
    jNF:add("siteCode",nota-fiscal.cod-estabel).
    jNF:add("operationNature",nota-fiscal.nat-operacao).
    jNF:add("issueDate",iso-date(nota-fiscal.dt-emis-nota)).
    jNF:add("departureDate",iso-date(nota-fiscal.dt-saida)).
    jNF:add("cancelDate",iso-date(nota-fiscal.dt-cancela)).
    jNF:add("paymentConditionCode",nota-fiscal.cod-cond-pag).
    jNF:add("erpAccountCode",nota-fiscal.cod-emitente).
    jNF:add("shortAccountName",nota-fiscal.nome-ab-cli).
    jNF:add("carrierShortName",nota-fiscal.nome-transp).
    jNF:add("carrierName",transporte.nome).
    jNF:add("carrierCNPJ",transporte.cgc).
    jNF:add("volumes",nota-fiscal.nr-volumes).
    jNF:add("netWeight",nota-fiscal.peso-liq-tot).
    jNF:add("grossWeight",nota-fiscal.peso-bru-tot).
    jNF:add("deliveryForecast",ISO-DATE(nota-fiscal.dt-saida)).
    jNF:add("effectiveDeliveryDate",ISO-DATE(nota-fiscal.dt-entr-cli)).
    jNF:add("ipiTotalValue",nota-fiscal.vl-tot-ipi).
    jNF:add("productTotalValue",nota-fiscal.vl-merc-tot-fat).
    jNF:add("totalValueNf",nota-fiscal.vl-tot-nota).
   
    assign jFaturas     = new JsonObject(). 
    assign jArrayFatura = new JsonArray().

    FOR EACH fat-duplic
       WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
         AND fat-duplic.serie       = nota-fiscal.serie
         AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK:
        assign jFatura = new JsonObject().
        jFatura:add("invoiceParcel",fat-duplic.parcela).
        jFatura:add("invoiceNumber",nota-fiscal.nr-fatura).
        jFatura:add("invoiceValue",fat-duplic.vl-parcela).
        jFatura:ADD("invoiceDueDate",ISO-DATE(fat-duplic.dt-vencimen)).

        jArrayFatura:add(jFatura).
    end.

    jFaturas:add("Invoice",JArrayFatura).
    jNF:add("invoices",jFaturas).

    assign de-icmsSubValue = 0
           de-icmsValue    = 0.

    assign jItens     = new JsonObject().
    assign jArrayItem = new JsonArray().

    for each it-nota-fisc no-lock
       where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
         and it-nota-fisc.serie       = nota-fiscal.serie
         and it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis,
       first item no-lock
       where item.it-codigo = it-nota-fisc.it-codigo:
        assign de-icmsSubValue = de-icmsSubValue + it-nota-fisc.vl-icmsub-it
               de-icmsValue    = de-icmsValue    + it-nota-fisc.vl-icms-it.

        assign jItem = new JsonObject().
        jItem:add("productCode",it-nota-fisc.it-codigo).
        jItem:add("productDescription",item.desc-item).
        jItem:ADD("billedQuantity",it-nota-fisc.qt-faturada[1]).
        jItem:add("unityValue",it-nota-fisc.vl-preuni).
        jItem:add("totalValue",it-nota-fisc.vl-tot-item).
        jItem:add("icms",it-nota-fisc.aliquota-icm).
        jItem:add("ipi",it-nota-fisc.aliquota-ipi).
        jItem:add("nfNumber",it-nota-fisc.nr-nota-fis).

        jArrayItem:add(jItem).
    end. /* for each it-nota-fisc */

    jNF:add("icmsSubValue",de-icmsSubValue).
    jNF:add("icmsValue",de-icmsValue).

    jItens:add("item",JArrayItem).
    jNF:add("itens",jItens).
    jArrayNF:add(jNF).
end procedure. /* procedure pi-array-NF */
