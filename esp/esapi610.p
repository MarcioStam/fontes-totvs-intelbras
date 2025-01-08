{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi610                                                         *
* Data ......: 07/10/2022                                                           *
* Empresa ...: iDBA                                                                 *
* Versao ....: 1.00.00.000                                                          *
* Autor .....: Mauricio C.                                                          *
*************************************************************************************
* VERSAO      DATA       RESPONSAVEL  EMPRESA  MOTIVO                               *
* 1.00.00.000 07/10/2022 Mauricio C.  iDBA     Desenvolvimento (chamado #11020)     *
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

def var jCatalogo      as JsonObject no-undo.
def var jArrayCatalogo as JsonArray  no-undo.
def var c-dataCorte    as char       no-undo.
def var dt-corte       as date       no-undo.
def var lg-processou   as logi       no-undo.

def var oRequestParser        as JsonAPIRequestParser no-undo.
def var jsonObjectQueryParams as JsonObject           no-undo.

def var c-erro as char init "Nenhum Item processado" no-undo.

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
    run pi-acompanhar in h-acomp ("Ariba Cat logo").

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
  then run pi-catalogo.
  else assign c-erro = c-erro + ". Erro de parametriza‡Æo!".

  assign es-api-log.retorno-content-type = "application/json".
  if lg-processou
  then do:
       jsonObjectOutput:add("product", jArrayCatalogo).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if i-aux > 0 */
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

procedure pi-catalogo:
    empty temp-table RowErrors.

    assign jArrayCatalogo = new JsonArray().

    if dt-corte = 1/1/0001
    then for each item fields(it-codigo un fm-codigo desc-item cod-obsoleto desc-inter) use-index codigo no-lock
            where item.cod-obsoleto = 1, /* Ativo */
            first int-item fields(it-codigo desc-completa catalogo-ariba) no-lock
            where int-item.it-codigo = item.it-codigo
              and int-item.catalogo-ariba:
             {esp/esapi610.i}
         end. /* for each item */
    else for each int-item fields(it-codigo desc-completa catalogo-ariba dt-atualiza) use-index idx-dt-atualiza no-lock
            where int-item.dt-atualiza >= dt-corte
              and int-item.catalogo-ariba,
            first item fields(it-codigo un fm-codigo desc-item cod-obsoleto desc-inter) use-index codigo no-lock
            where item.it-codigo    = int-item.it-codigo
              and item.cod-obsoleto = 1:
             {esp/esapi610.i}
         end. /* for each int-item */

    assign lg-processou = yes.

    RETURN "OK".
end procedure. /* procedure pi-catalogo */

