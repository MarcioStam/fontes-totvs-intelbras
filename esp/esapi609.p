{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi609                                                         *
* Data ......: 05/10/2022                                                           *
* Empresa ...: iDBA                                                                 *
* Versao ....: 1.00.00.000                                                          *
* Autor .....: Mauricio C.                                                          *
*************************************************************************************
* VERSAO      DATA       RESPONSAVEL  EMPRESA  MOTIVO                               *
* 1.00.00.000 05/10/2022 Mauricio C.  iDBA     Desenvolvimento (chamado #11020)     *
*************************************************************************************/
define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define variable cMetodo          as character         no-undo.
define variable jsonObjectOutput as JsonObject        no-undo.
define variable jsonOutput       as JsonObject        no-undo.
define variable oErrors          as JsonArray         no-undo.
define variable oError           as JsonObject        no-undo.
define variable lcInput          as longchar          no-undo.
define variable lcOutput         as longchar          no-undo.
define variable jsonParser       as ObjectModelParser no-undo.
define variable jsonInput        as JsonObject        no-undo.
define variable iNumMessages     as integer           no-undo.

def var jFornec      as JsonObject no-undo.
def var jArrayFornec as JsonArray  no-undo.
def var c-dataCorte  as char       no-undo.
def var dt-corte     as date       no-undo.
def var lg-processou as logi       no-undo.

def var oRequestParser        as JsonAPIRequestParser no-undo.
def var jsonObjectQueryParams as JsonObject           no-undo.

def var c-erro as char init "Nenhuma Cond Pag de Fornecedor processada" no-undo.

{esp/esapi505x.i &OPC="OPEN"}

/* ***************************  Main Block  *************************** */
for first es-api-log
    where rowid(es-api-log) = rw-registro,
    first es-api-uri       no-lock
       of es-api-log,
    first es-api-empresa   no-lock
       of es-api-log,
    first es-api-aplicacao no-lock
       of es-api-log
       by es-api-log.flg-processado
       by es-api-log.dh-request:

  assign es-api-log.dh-envio = now.

  copy-lob es-api-log.cl-envio to lcInput.

  assign jsonParser = NEW ObjectModelParser()
         jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

  if valid-handle(h-acomp) then 
    run pi-acompanhar in h-acomp ("Ariba Cond Pag Fornec").

  run pi-input-api-headers (jsonInput).

  assign dt-corte = 1/1/0001.

  assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.
  assign jsonObjectQueryParams = new JsonObject().
  jsonObjectQueryParams = oRequestParser:getQueryParams() no-error.

  if jsonObjectQueryParams:has("dataCorte")
  then do:
       assign c-dataCorte = trim(JsonAPIUtils:getPropertyJsonObject(jsonObjectQueryParams,"dataCorte")) no-error.
    
       if error-status:error
       then assign dt-corte = ?.

       if c-dataCorte <> ""
       then do:
            assign dt-corte = OpenEdge.Core.TimeStamp:ToABLDateFromISO(c-dataCorte) no-error.

            if error-status:error
            then assign dt-corte = ?.
       end.
  end. /* if jsonObjectQueryParams:has("dataCorte") */

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  if dt-corte <> ?
  then run pi-consulta-fornec.
  else assign c-erro = c-erro + ". Erro de parametriza‡Æo!".

  assign es-api-log.retorno-content-type = "application/json".
  if lg-processou
  then do:
       jsonObjectOutput:add("suppliersPayment", jArrayFornec).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if lg-processou */
  else do:
       oErrors = new JsonArray().
       oError = new JsonObject().
       oError:add("errorCode", 1). 
       oError:add("errorInfo", c-erro). 
       oError:add("errorDescription", c-erro).
       oErrors:add(oError).
       jsonObjectOutput:add("Erros", oErrors).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 404).
  end. /* else do */

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if lg-processou
  then assign es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Rotina processada".
  ELSE assign es-api-log.cod-retorno = "404".
  FIND CURRENT es-api-log NO-LOCK NO-ERROR.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

procedure pi-consulta-fornec:
    empty temp-table RowErrors.

    assign jArrayFornec = new JsonArray().

    for each emitente no-lock
       where emitente.identific > 1,
       first int-emitente no-lock
       where int-emitente.cod-emitente = emitente.cod-emitente
         and int-emitente.ind-participa-portal-fornec = 1 /* Participa do Portal de Fornecedores */
         and int-emitente.acm-ariba                  <> "": 
        for first dist-emitente fields (cod-emitente idi-sit-fornec) 
            where dist-emitente.cod-emitente = emitente.cod-emitente 
                  no-lock: end.
    
        if  avail dist-emitente
        and dist-emitente.idi-sit-fornec > 1
        then next.
    
        if emitente.dt-atualiza <> ?
        then if emitente.dt-atualiza >= dt-corte
             then.
             else next.
        else if emitente.data-implant < dt-corte
             then next.
    
        assign jFornec = new JsonObject().
        jFornec:add("supplierID",emitente.cod-emitente).
        jFornec:add("paymentTerms",emitente.cod-cond-pag).
    
        jArrayFornec:add(jFornec).
    end. /* for each emitente */

    assign lg-processou = yes.

    RETURN "OK".
end procedure. /* procedure pi-consulta-fornec */

