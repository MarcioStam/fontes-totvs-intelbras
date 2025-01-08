{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi607                                                         *
* Data ......: 06/10/2022                                                           *
* Empresa ...: iDBA                                                                 *
* Versao ....: 1.00.00.000                                                          *
* Autor .....: Mauricio C.                                                          *
*************************************************************************************
* VERSAO      DATA       RESPONSAVEL  EMPRESA  MOTIVO                               *
* 1.00.00.000 06/10/2022 Mauricio C.  iDBA     Desenvolvimento (chamado #11020)     *
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

def var jCentroCusto      as JsonObject no-undo.
def var jArrayCentroCusto as JsonArray  no-undo.
def var i-aux             as inte       no-undo.

def new global shared var v_cod_empres_usuar as character no-undo.

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
    run pi-acompanhar in h-acomp ("Ariba Centro Custo").

  run pi-input-api-headers (jsonInput).

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  run pi-consulta-centro-custo.

  assign es-api-log.retorno-content-type = "application/json".
  if i-aux > 0 
  then do:
       jsonObjectOutput:add("costs", jArrayCentroCusto).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if i-aux > 0 */
  else do:
       oErrors = new JsonArray().
       oError = new JsonObject().
       oError:add("errorCode", 1). 
       oError:add("errorInfo", "Nenhum Centro de Custo processado"). 
       oError:add("errorDescription", "Nenhum Centro de Custo processado").
       oErrors:add(oError).
       jsonObjectOutput:add("Erros", oErrors).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end. /* else do */

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if i-aux > 0
  then assign es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Centros de Custo lidos com sucesso".
  ELSE assign es-api-log.cod-retorno = "500".
  FIND CURRENT es-api-log NO-LOCK NO-ERROR.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

procedure pi-consulta-centro-custo:
    empty temp-table RowErrors.

    assign i-aux = 0.
    assign jArrayCentroCusto = new JsonArray().

    for each cc_uni_estab no-lock,
       first emscad.ccusto no-lock
       where ccusto.cod_empres       = v_cod_empres_usuar
         and ccusto.cod_plano_ccusto = "PADRAO"
         and ccusto.cod_ccusto       = cc_uni_estab.cc_codigo
         and ccusto.dat_inic_valid  <= today
         and ccusto.dat_fim_valid   >= today:
        assign i-aux = i-aux + 1.

        assign jCentroCusto = new JsonObject().
        jCentroCusto:add("costCenter",caps(cc_uni_estab.cod_unid_negoc) + "." +
                                      cc_uni_estab.cc_codigo            + "." +
                                      cc_uni_estab.cod_estab).
        jCentroCusto:add("name",trim(replace(ccusto.des_tit_ctbl,",","."))).
    
        jArrayCentroCusto:add(jCentroCusto).
    end. /* for each cc_uni_estab */

    RETURN "OK".
end procedure. /* procedure pi-consulta-centro-custo */

