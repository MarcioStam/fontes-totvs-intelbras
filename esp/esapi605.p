{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi605                                                         *
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

def var jCondPagto      as JsonObject no-undo.
def var jArrayCondPagto as JsonArray  no-undo.
def var i-aux           as inte       no-undo.

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
    run pi-acompanhar in h-acomp ("Ariba Cond Pagto").

  run pi-input-api-headers (jsonInput).

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  run pi-consulta-cod-pagto.

  assign es-api-log.retorno-content-type = "application/json".
  if i-aux > 0 
  then do:
       jsonObjectOutput:add("paymentTerms", jArrayCondPagto).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if i-aux > 0 */
  else do:
       oErrors = new JsonArray().
       oError = new JsonObject().
       oError:add("errorCode", 1). 
       oError:add("errorInfo", "Nenhuma Condi‡Æo de Pagamento processada"). 
       oError:add("errorDescription", "Nenhuma Condi‡Æo de Pagamento processada").
       oErrors:add(oError).
       jsonObjectOutput:add("Erros", oErrors).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end. /* else do */

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if i-aux > 0
  then assign es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Condi‡äes de Pagamento lidas com sucesso".
  ELSE assign es-api-log.cod-retorno = "500".
  FIND CURRENT es-api-log NO-LOCK NO-ERROR.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

procedure pi-consulta-cod-pagto:
    empty temp-table RowErrors.

    assign i-aux = 0.
    assign jArrayCondPagto = new JsonArray().

    for each cond-pagto no-lock,
       first int-cond-pagto no-lock
       where int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag
         and int-cond-pagto.log-sdcv:
        assign i-aux = i-aux + 1.
    
        assign jCondPagto = new JsonObject().
        jCondPagto:add("paymentTermsId",cond-pagto.cod-cond-pag).
        jCondPagto:add("name",trim(cond-pagto.descricao)).
    
        jArrayCondPagto:add(jCondPagto).
    end. /* for each cond-pagto */

    RETURN "OK".
end procedure. /* procedure pi-consulta-cod-pagto */

