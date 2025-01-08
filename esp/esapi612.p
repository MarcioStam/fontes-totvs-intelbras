{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi612                                                         *
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

def temp-table tt-it-aux no-undo
    field it-codigo   like item.it-codigo
    field desc-item   like item.desc-item
    field un          like item.un
    field fm-codigo   like item.fm-codigo
    field cod-estabel like item-uni-estab.cod-estabel
    field pagina      as inte
    index id is primary it-codigo
                        cod-estabel.

define variable cMetodo          as character            no-undo.
define variable jsonObjectOutput as JsonObject           no-undo.
define variable jsonOutput       as JsonObject           no-undo.
define variable oErrors          as JsonArray            no-undo.
define variable oError           as JsonObject           no-undo.
define variable lcInput          as longchar             no-undo.
define variable lcOutput         as longchar             no-undo.
define variable jsonParser       as ObjectModelParser    no-undo.
define variable oRequestParser   as JsonAPIRequestParser no-undo.
define variable jsonInput        as JsonObject           no-undo.
define variable iNumMessages     as integer              no-undo.

define variable jsonArrayPathParams   as JsonArray  no-undo.
define variable jsonObjectQueryParams as JsonObject no-undo.

def var jCadastroMat      as JsonObject no-undo.
def var jArrayCadastroMat as JsonArray  no-undo.

def var i-page       as inte init 1          no-undo.
def var i-page-size  as inte init 1000       no-undo.
def var i-aux        as inte init -1         no-undo.
def var i-pagina     as inte                 no-undo.
def var i-num-param  as inte                 no-undo.
def var c-next       as char                 no-undo.
def var c-dataCorte  as char                 no-undo.
def var dt-corte     as date init 01/01/0001 no-undo.
def var lg-processou as logi                 no-undo.

DEF VAR c-erro AS CHAR INIT "Nenhum Material processado" NO-UNDO.

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
    run pi-acompanhar in h-acomp ("Ariba Cadastro Material").

  run pi-input-api-headers (jsonInput).

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

/*   assign i-page-size = oRequestParser:getPageSize() no-error. */
/*   assign i-page      = oRequestParser:getPage()     no-error. */

  if jsonObjectQueryParams:has("pagina")
  then do:
       assign i-page = inte(JsonAPIUtils:getPropertyJsonObject(jsonObjectQueryParams,"pagina")) no-error.
    
       if error-status:error
       then assign i-page = ?.
  end. /* if jsonObjectQueryParams:has("page") */

  if jsonObjectQueryParams:has("tamanhoPagina")
  then do:
       assign i-page-size = inte(JsonAPIUtils:getPropertyJsonObject(jsonObjectQueryParams,"tamanhoPagina")) no-error.
    
       if error-status:error
       then assign i-page-size = ?.
  end. /* if jsonObjectQueryParams:has("pageSize") */

/*   assign oRequestParser = NEW JsonAPIRequestParser(jsonInput) no-error.                                    */
/*   assign jsonArrayPathParams = new JsonArray().                                                            */
/*   jsonArrayPathParams = oRequestParser:getPathParams() no-error.                                           */
/*                                                                                                            */
/*   assign i-num-param = jsonArrayPathParams:length no-error.                                                */
/*                                                                                                            */
/*   if  i-num-param <> 0                                                                                     */
/*   and i-num-param <> 2                                                                                     */
/*   then assign i-page-size = ?.                                                                             */
/*   else if i-num-param = 2                                                                                  */
/*        then do:                                                                                            */
/*             assign i-page-size = inte(JsonAPIUtils:getPropertyJsonArray(jsonArrayPathParams, 1)) no-error. */
/*                                                                                                            */
/*             if error-status:error                                                                          */
/*             then assign i-page-size = ?.                                                                   */
/*                                                                                                            */
/*             assign i-page      = inte(JsonAPIUtils:getPropertyJsonArray(jsonArrayPathParams, 2)) no-error. */
/*                                                                                                            */
/*             if error-status:error                                                                          */
/*             then assign i-page      = ?.                                                                   */
/*        END. /* if i-num-param <> 0 */                                                                      */

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  IF  i-page-size > 0
  AND i-page      > 0
  and dt-corte   <> ?
  THEN run pi-CadastroMat.
  ELSE ASSIGN c-erro = c-erro + ". Erro de parametriza‡Æo!".

  assign es-api-log.retorno-content-type = "application/json".
  if lg-processou 
  then do:
       jsonObjectOutput:add("nextPage",c-next).
       jsonObjectOutput:add("totalRows",i-aux + 1).
       jsonObjectOutput:add("material", jArrayCadastroMat).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if temp-table tt-it-aux:has-records */
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
              es-api-log.aux         = "Materiais processados com sucesso".
  ELSE assign es-api-log.cod-retorno = "404".
  FIND CURRENT es-api-log NO-LOCK NO-ERROR.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

FINALLY:
    delete object oRequestParser      no-error.
    DELETE OBJECT jsonArrayPathParams NO-ERROR.
END.

procedure pi-CadastroMat:
    empty temp-table RowErrors.
    empty temp-table tt-it-aux.

    if dt-corte = 1/1/0001 
    then for each item fields(it-codigo un fm-codigo desc-item desc-inter) use-index codigo no-lock,
             each item-uni-estab fields(it-codigo cod-estabel cod-obsoleto) use-index codigo no-lock
            where item-uni-estab.it-codigo    = item.it-codigo
              and item-uni-estab.cod-obsoleto = 1: /* Ativo */
             {esp/esapi612.i}
         end. /* for each item */
    else for each int-item fields(it-codigo dt-atualiza) use-index idx-dt-atualiza no-lock
            where int-item.dt-atualiza >= dt-corte,
            first item fields(it-codigo un fm-codigo desc-item desc-inter) use-index codigo no-lock
            where item.it-codigo = int-item.it-codigo,
             each item-uni-estab fields(it-codigo cod-estabel cod-obsoleto) use-index codigo no-lock
            where item-uni-estab.it-codigo    = item.it-codigo
              and item-uni-estab.cod-obsoleto = 1: /* Ativo */
             {esp/esapi612.i}
         end. /* for each int-item */

    find current tt-it-aux no-error.
    release tt-it-aux.

    if i-page < i-pagina
    then assign c-next = string(i-page + 1).

    assign jArrayCadastroMat = new JsonArray().

    for each tt-it-aux:
        assign jCadastroMat = new JsonObject().
        jCadastroMat:add("productID",tt-it-aux.it-codigo).
        jCadastroMat:add("description",tt-it-aux.desc-item).
        jCadastroMat:add("unitOfMeasureID",tt-it-aux.un).
        jCadastroMat:add("materialGroupID",tt-it-aux.fm-codigo).
        jCadastroMat:add("plantID",tt-it-aux.cod-estabel).
    
        jArrayCadastroMat:add(jCadastroMat).
    end. /* for each tt-it-aux */

    assign lg-processou = yes.

    RETURN "OK".
end procedure. /* procedure pi-CadastroMat */

