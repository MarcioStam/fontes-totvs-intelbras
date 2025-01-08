{esp/esapi505.i}
{utp/ut-glob.i}

/************************************************************************************
* Programa ..: API esapi606                                                         *
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

def var jConvMoeda      as JsonObject no-undo.
def var jArrayConvMoeda as JsonArray  no-undo.
def var i-aux           as inte       no-undo.

def work-table wt-paridade
    field currency1 as char
    field currency2 as char
    field currency3 as char
    field currency4 as char.

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
    run pi-acompanhar in h-acomp ("Ariba Conv. Moedas").

  run pi-input-api-headers (jsonInput).

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  /* Paridades consideradas pela API */
  run pi-paridade(input "Real,BRL,Dolar,USD").
  run pi-paridade(input "Real,BRL,ren,CNY").
  run pi-paridade(input "Real,BRL,EURO,EUR").
  run pi-paridade(input "Real,BRL,yen,JPY").
  run pi-paridade(input "Real,BRL,Libra,GBP").
  run pi-paridade(input "EURO,EUR,Dolar,USD").
  run pi-paridade(input "Dolar,USD,ren,CNY").
  run pi-paridade(input "Dolar,USD,yen,JPY").
  run pi-paridade(input "Dolar,USD,Libra,GBP").

  run pi-conversao-moeda.

  assign es-api-log.retorno-content-type = "application/json".
  if i-aux > 0 
  then do:
       jsonObjectOutput:add("currencies", jArrayConvMoeda).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* if i-aux > 0 */
  else do:
       oErrors = new JsonArray().
       oError = new JsonObject().
       oError:add("errorCode", 1). 
       oError:add("errorInfo", "Nenhuma ConversÆo de Moeda processada"). 
       oError:add("errorDescription", "Nenhuma ConversÆo de Moeda processada").
       oErrors:add(oError).
       jsonObjectOutput:add("Erros", oErrors).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end. /* else do */

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if i-aux > 0
  then assign es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Conversäes de Moeda processadas com sucesso".
  else assign es-api-log.cod-retorno = "500".
  find current es-api-log no-lock no-error.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

return "OK".

procedure pi-conversao-moeda:
    def var c-data as char no-undo.

    def var c-weekday as char init "Sun,Mon,Tue,Wed,Thu,Fri,Sat"                     no-undo.
    def var c-month   as char init "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" no-undo.

    empty temp-table RowErrors.

    assign i-aux = 0.
    assign jArrayConvMoeda = new JsonArray().

    for each cotac_parid no-lock
       where cotac_parid.ind_tip_cotac_parid   = "Real"
         and cotac_parid.dat_cotac_indic_econ >= today:
        for first wt-paridade
            where wt-paridade.currency1 = trim(cotac_parid.cod_indic_econ_base)
              and wt-paridade.currency3 = trim(cotac_parid.cod_indic_econ_idx): end.

        if not avail wt-paridade
        then next.

        assign i-aux  = i-aux + 1
               c-data = entry(weekday(cotac_parid.dat_cotac_indic_econ),c-weekday)
                      + " "
                      + entry(month(cotac_parid.dat_cotac_indic_econ),c-month)
                      + " "
                      + string(day(cotac_parid.dat_cotac_indic_econ),"99")
                      + " 00:00:00 PST "
                      + string(year(cotac_parid.dat_cotac_indic_econ),"9999").

        assign jConvMoeda = new JsonObject().
        jConvMoeda:add("parityID",wt-paridade.currency2 + ":" + 
                                  wt-paridade.currency4).
        jConvMoeda:add("currencyBaseID",wt-paridade.currency2).
        jConvMoeda:add("dateConversion",c-data).
        jConvMoeda:add("currencyDestinationID",wt-paridade.currency4).
        jConvMoeda:add("currencyConvertionValue",cotac_parid.val_cotac_indic_econ).
    
        jArrayConvMoeda:add(jConvMoeda).
    end. /* for each cotac_parid */

    RETURN "OK".
end procedure. /* procedure pi-conversao-moeda */

procedure pi-paridade:
    def input param p-paridade as char no-undo.

    create wt-paridade.
    assign wt-paridade.currency1 = entry(1,p-paridade)
           wt-paridade.currency2 = entry(2,p-paridade)
           wt-paridade.currency3 = entry(3,p-paridade)
           wt-paridade.currency4 = entry(4,p-paridade).
    create wt-paridade.
    assign wt-paridade.currency1 = entry(3,p-paridade)
           wt-paridade.currency2 = entry(4,p-paridade)
           wt-paridade.currency3 = entry(1,p-paridade)
           wt-paridade.currency4 = entry(2,p-paridade).
    find current wt-paridade no-error.

    return "OK".
end procedure. /* procedure pi-paridade */

