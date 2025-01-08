block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi602.i}
{esp/ccp/esccp055r.i}
{utp/ut-glob.i}

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define new global shared var l-esapi556 as logical no-undo.

DEF NEW GLOBAL SHARED VAR v-rw-es-api-log AS ROWID NO-UNDO.

define variable cMetodo          as character         no-undo.
define variable jsonObjectOutput as JsonObject        no-undo.
define variable jsonOutput       as JsonObject        no-undo.
define variable oPurchases       as JsonArray         no-undo.
define variable oErrors          as JsonArray         no-undo.
define variable oPurchase        as JsonObject        no-undo.
define variable oError           as JsonObject        no-undo.
define variable i-num-pedido     as integer           no-undo.
define variable c-num-pedidos    as character         no-undo.
define variable c-cod-fornecedor as character         no-undo.
define variable c-externalId     as character         no-undo.
define variable lcInput          as longchar          no-undo.
define variable lcOutput         as longchar          no-undo.
define variable jsonParser       as ObjectModelParser no-undo.
define variable jsonInput        as JsonObject        no-undo.
define variable iNumMessages     as integer           no-undo.
define variable i-aux            as integer           no-undo.
define variable i-codigo-icm     as integer           no-undo.
define variable i-tp-pedido      as integer init 3    no-undo. /* Tipo Pedido - Comum */
define variable i-tp-despesa     as integer           no-undo.
define variable c-tags           as character         no-undo.
def var hboin082ca                  as handle no-undo.

define variable c-via-transp as character init "Rodovi†rio,Aerovi†rio,Mar°timo,Ferrovi†rio,Rodoferrovi†rio,Rodofluvial,Rodoaerovi†rio,Outros" no-undo.

define temp-table auxRowErrors no-undo like RowErrors.

def buffer b-tt-itens  for tt-itens.
def buffer b-estabelec for estabelec.    

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetInteger   returns integer   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetDecimal   returns decimal   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetPais      returns integer   () forwards.

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

  assign es-api-log.dh-envio = NOW
         v-rw-es-api-log     = rw-registro.

  // MESSAGE "v-rw-es-api-log: " STRING (v-rw-es-api-log) VIEW-AS ALERT-BOX. 

  copy-lob es-api-log.cl-envio to lcInput.

  assign jsonParser = NEW ObjectModelParser()
         jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

  if valid-handle(h-acomp) then 
    run pi-acompanhar in h-acomp ("Pedido de Compra").

  run pi-input-api-headers (jsonInput).

  run pi-carga-json.

  if return-value = "OK"
  then do:
       for first tt-cabec: end.

       RUN pi-principal.
  end. /* if return-value = "OK" */

  /* Tratamento do Retorno */
  jsonObjectOutput = new JsonObject().
  jsonOutput       = new JsonObject().

  assign c-num-pedidos = trim(c-num-pedidos,",").

  assign es-api-log.retorno-content-type = "application/json".
  if not can-find(first tt-erros-geral) then do:
    oPurchases = new JsonArray().
    do i-aux = 1 to num-entries(c-num-pedidos,","):
        oPurchase = new JsonObject().
        oPurchase:add("externalId",   c-externalId). 
        oPurchase:add("customerCode", c-cod-fornecedor). 
        oPurchase:add("purchasingId", entry(i-aux,c-num-pedidos,",")).
        oPurchases:add(oPurchase).
    end.
    jsonObjectOutput:add("Purchases", oPurchases).
    jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end.
  else do:
    oErrors = new JsonArray().
    for each tt-erros-geral:
        oError = new JsonObject().
        oError:add("errorCode",        tt-erros-geral.cod-erro ). 
        oError:add("errorInfo",        ""). 
        oError:add("errorDescription", tt-erros-geral.des-erro ).
        oErrors:add(oError).
    end.
    jsonObjectOutput:add("Erros", oErrors).
    jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end.

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if not temp-table tt-erros-geral:has-records then do:
    assign es-api-log.cod-retorno = "200"
           es-api-log.aux         = "Pedido(s) de Venda " + c-num-pedidos + " criado(s) com sucesso".

    run pi-back-integration.
  end.
  else do:
    assign es-api-log.cod-retorno = "500".
  end.
  empty temp-table tt-erros-geral.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

ASSIGN v-rw-es-api-log = ?.

return "OK".

finally:
    assign v-rw-es-api-log = ?.
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-principal:
    run pi-cria-item-fornec.
    
    if return-value <> "OK" 
    then UNDO, RETURN "NOK".
    ELSE for each tt-cabec:
             run pi-create-ped-sourcing.
         
             if return-value <> "OK" 
             then UNDO, RETURN "NOK".
         end. /* for each tt-cabec */

    RETURN "OK".
END PROCEDURE. /* procedure pi-principal */

procedure pi-carga-json :
  define variable jsonObjectPayload   as JsonObject no-undo.
  define variable jsonArrayPathParams as JsonArray  no-undo.
  define variable oItens              as JsonArray  no-undo.
  define variable oItem               as JsonObject no-undo.
  define variable lErr                as logical    no-undo.
  define variable lRetOK              as logical    no-undo.
  define variable httpInput           as handle     no-undo.
  define variable hQuery              as handle     no-undo.
  define variable hBuffer             as handle     no-undo.
  define variable iNumFields          as integer    no-undo.
  define variable iLoop               as integer    no-undo.
  define variable iLoop2              as integer    no-undo.
  DEFINE VARIABLE objFornecedor       AS JsonObject NO-UNDO.
  DEFINE VARIABLE arrayFornecedor     AS jsonArray  NO-UNDO.
  define variable lcAux               as longchar   no-undo.

  def var c-centerID         as char no-undo.
  def var c-buyer            as char no-undo.
  def var c-spendType        as char no-undo.
  def var c-incoterm         as char no-undo.
  def var c-logisticsAnalyst as char no-undo.
  def var i-supplierID       as inte no-undo.
  def var i-paymentTerms     as inte no-undo.
  def var i-itinerary        as inte no-undo.
  def var i-shipper          as inte no-undo.
  def var i-checkpoint       as inte no-undo.

  release estabelec.
  release emitente.
  release emitente-cex.

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload")
         cMetodo           = jsonInput:GetCharacter("method").

  if valid-object(jsonObjectPayload) then do:
    assign c-centerID   = fcGetCharacter("centerID", jsonObjectPayload)
           c-buyer      = fcGetCharacter("buyer",    jsonObjectPayload)
           c-spendType  = fcGetCharacter("spendType",jsonObjectPayload)
           i-supplierID = fcGetInteger("supplierID", jsonObjectPayload) 
           no-error.

    if error-status:error
    then run pi-cria-erro("Erro entrada de dados do cabeáalho").

    if temp-table tt-erros-geral:has-records then
      return "NOK".

    find first param-compra no-lock no-error.

    for first estabelec
        where estabelec.cod-estabel = c-centerID
              no-lock: end.

    if not avail estabelec
    then do:
         run pi-cria-erro(substitute("Registro de Estabelecimento n∆o localizado com o c¢digo &1 vindo da integraá∆o", 
                                     quoter(c-centerID))).
         return "NOK".       
    end.

    for first emitente
        where emitente.cod-emitente = i-supplierID
              no-lock: end.

    if not avail emitente
    then do:
         run pi-cria-erro(substitute("Registro de Fornecedor n∆o localizado com o c¢digo &1 vindo da integraá∆o", 
                                     quoter(i-supplierID))).
         return "NOK".
    end.

    if emitente.identific = 1
    then do:
         run pi-cria-erro(substitute("Emitente com o c¢digo &1 est† cadastrado como cliente, n∆o fornecedor", 
                                     quoter(emitente.cod-emitente))).
         return "NOK".
    end.

    /* Regra alterada conforme solicitaá∆o - 21/10 */
/*     if emitente.tp-desp-pad = 1 /* Nacional */                                                                  */
/*     then assign i-cod-mensagem = 135.                                                                           */
/*     else if emitente.tp-desp-pad = 2 /* Internacional */                                                        */
/*          then assign i-cod-mensagem = 136.                                                                      */
/*          else do:                                                                                               */
/*               run pi-cria-erro(substitute("Fornecedor com o c¢digo &1 possui tipo de despesa n∆o previsto: &2", */
/*                                           quoter(emitente.cod-emitente),                                        */
/*                                           quoter(emitente.tp-desp-pad))).                                       */
/*               return "NOK".                                                                                     */
/*          end.                                                                                                   */

    for first emitente-cex
        where emitente-cex.cod-emitente = emitente.cod-emitente
              no-lock: end.

    if  emitente.natureza = 3 // Fornecedor Estrangeiro
    and not avail emitente-cex
    then do:
         run pi-cria-erro(substitute("Fornecedor ComÇrcio Exterior n∆o localizado com o c¢digo &1", 
                                     quoter(emitente.cod-emitente))).
         return "NOK".
    end.

    assign i-codigo-icm = 0.
    FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
        WHERE ponto-programa.nome-programa = "cc0300a"
          AND ponto-programa.ponto         = 1
          AND ponto-programa.tipo          = 3,
        first conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.sequencia    = i-tp-pedido:
        if  trim(entry(1,conteudo-programa.conteudo,";")) = string(conteudo-programa.sequencia)
        and num-entries(conteudo-programa.conteudo,";") > 3
        and entry(4,conteudo-programa.conteudo,";") <> "INATIVO"
        then case entry(3,conteudo-programa.conteudo,";"):
                 when "Consumo"
                 then assign i-codigo-icm = 1.
                 when "Industrializaá∆o"
                 then assign i-codigo-icm = 2.
             end case.
    END. /* for first ponto-programa */

    if i-codigo-icm = 0
    then do:
         run pi-cria-erro("N∆o foi poss°vel recuperar o c¢digo ICM. Revisar ES0018 (cadastro para o CC0300A)").
         return "NOK".
    end.

    find first mgcad.pais no-lock 
         where mgcad.pais.nome-pais  = emitente.pais no-error.
    
    assign c-cod-fornecedor = string(emitente.cod-emitente)
           c-externalId     = trim(substring(pais.char-1,23,02)) when avail mgcad.pais.
    
    // Fornecedor Estrangeiro
    if emitente.natureza = 3 then 
      assign c-externalId = c-externalId + trim(substring(emitente.char-1,103,30)). // Passaporte.
    else
      assign c-externalId = c-externalId + emitente.cgc.

    if jsonObjectPayload:has("Itens") then do:
      oItens = new JsonArray().
      oItens = jsonObjectPayload:GetJsonArray("Itens").
    end.
  end.
  else do:
    run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de pedido de compra para integrar").
    return "NOK".
  end.

  if valid-object(oItens) then do:
    do iLoop = 1 to oItens:length:
      oItem = new JsonObject().
      oItem = oItens:GetJsonObject(iLoop).

      assign i-tp-despesa   = 0
             i-paymentTerms = 0
             i-shipper      = 0
             i-itinerary    = 0
             i-checkpoint   = 0
             c-tags         = ""
             c-incoterm     = "".

      create tt-itens.
      assign tt-itens.productNameComplement = oItem:GetCharacter("productNameComplement") when oItem:Has("productNameComplement")
             tt-itens.supplierQuantity      = oItem:GetDecimal("supplierQuantity")        when oItem:Has("supplierQuantity")
             tt-itens.supplierReference     = oItem:GetCharacter("supplierReference")     when oItem:Has("supplierReference")
             tt-itens.unitMeasure           = oItem:GetCharacter("unitSupplierMeasure")   when oItem:Has("unitSupplierMeasure")
             i-itinerary                    = oItem:GetInteger("itinerary")               when oItem:Has("itinerary")
             i-paymentTerms                 = oItem:GetInteger("paymentTerms")            when oItem:Has("paymentTerms")
             i-shipper                      = oItem:GetInteger("shipper")                 when oItem:Has("shipper")
             i-checkpoint                   = oItem:GetInteger("checkpoint")              when oItem:Has("checkpoint")
             c-incoterm                     = oItem:GetCharacter("incoterm")              when oItem:Has("incoterm")
             tt-itens.ledgerAccount         = string(oItem:GetInteger("ledgerAccount"))   when oItem:Has("ledgerAccount")
             tt-itens.costCenter            = oItem:GetCharacter("costCenter")            when oItem:Has("costCenter")
             tt-itens.transitTime           = oItem:GetInteger("transitTime")             when oItem:Has("transitTime")
             no-error.

      if error-status:error
      then do:
           run pi-cria-erro("Erro quanto Ö propriedade ou ao tipo de entrada de dados no bloco Itens").
           leave.
      end.

      assign tt-itens.sequence              = oItem:GetInteger("sequence")                no-error.
      assign c-tags = c-tags + ",sequence"              when error-status:error or tt-itens.sequence     = 0  or tt-itens.sequence      = ?
             tt-itens.productID             = oItem:GetInt64("productID")                 no-error.
      assign c-tags = c-tags + ",productID"             when error-status:error or tt-itens.productID    = 0  or tt-itens.productID     = ?
             tt-itens.quantity              = oItem:GetDecimal("quantity")                no-error.
      assign c-tags = c-tags + ",quantity"              when error-status:error or tt-itens.quantity    <= 0  or tt-itens.quantity      = ?
             tt-itens.currency              = oItem:GetCharacter("currency")              no-error.
      assign c-tags = c-tags + ",currency"              when error-status:error or tt-itens.currency     = "" or tt-itens.currency      = ?
             tt-itens.leadTime              = oItem:GetInteger("leadTime")                no-error.
      assign c-tags = c-tags + ",leadTime"              when error-status:error or tt-itens.leadTime     = 0  or tt-itens.leadTime      = ?.

      if oItem:Has("ipiTax")
      then do:
           assign tt-itens.ipiTax = oItem:GetDecimal("ipiTax") no-error.
        
           if error-status:error
           then do:
                assign tt-itens.ipiTaxAux = oItem:GetCharacter("ipiTax") no-error.
        
                if  not error-status:error
                and tt-itens.ipiTaxAux <> ""
                then assign tt-itens.ipiTax = deci(replace(replace(tt-itens.ipiTaxAux,",",""),".",",")) no-error.

                if error-status:error
                then assign c-tags = c-tags + ",ipiTax".
           end. /* if error-status:error */
      end. /* if oItem:Has("ipiTax") */

      if oItem:Has("icmsTax")
      then do:
           assign tt-itens.icmsTax = oItem:GetDecimal("icmsTax") no-error.
        
           if error-status:error
           then do:
                assign tt-itens.icmsTaxAux = oItem:GetCharacter("icmsTax") no-error.
        
                if  not error-status:error
                and tt-itens.icmsTaxAux <> ""
                then assign tt-itens.icmsTax = deci(replace(replace(tt-itens.icmsTaxAux,",",""),".",",")) no-error.

                if error-status:error
                then assign c-tags = c-tags + ",icmsTax".
           end. /* if error-status:error */
      end. /* if oItem:Has("icmsTax") */

      if oItem:Has("issTax")
      then do:
           assign tt-itens.issTax = oItem:GetDecimal("issTax") no-error.
        
           if error-status:error
           then do:
                assign tt-itens.issTaxAux = oItem:GetCharacter("issTax") no-error.
        
                if  not error-status:error
                and tt-itens.issTaxAux <> ""
                then assign tt-itens.issTax = deci(replace(replace(tt-itens.issTaxAux,",",""),".",",")) no-error.

                if error-status:error
                then assign c-tags = c-tags + ",issTax".
           end. /* if error-status:error */
      end. /* if oItem:Has("issTax") */

      if oItem:Has("unitPrice")
      then do:
           assign tt-itens.unitPrice = oItem:GetDecimal("unitPrice") no-error.
        
           if error-status:error
           then do:
                assign tt-itens.unitPriceAux = oItem:GetCharacter("unitPrice") no-error.
        
                if  not error-status:error
                and tt-itens.unitPriceAux <> ""
                then assign tt-itens.unitPrice = deci(replace(replace(tt-itens.unitPriceAux,",",""),".",",")) no-error.
           end. /* if error-status:error */
      end. /* if oItem:Has("unitPrice") */

      if tt-itens.unitPrice > 0
      then.
      else assign c-tags = c-tags + ",unitPrice".

      if c-tags <> ""
      then do:
           run pi-cria-erro("Erro quanto Ö propriedade ou ao tipo de entrada de dados no bloco Itens: " + trim(c-tags,",")).
           leave.
      end.

      if tt-itens.ledgerAccount = "0"
      then assign tt-itens.ledgerAccount = "".

      if num-entries(tt-itens.costCenter, ".") >= 3 then
        assign tt-itens.businessUnit = entry(1, tt-itens.costCenter, ".")
               tt-itens.centerIDcc   = entry(3, tt-itens.costCenter, ".")
               tt-itens.costCenter   = entry(2, tt-itens.costCenter, ".").

      if c-spendType = "Indiretos"
      then assign c-logisticsAnalyst = oItem:GetCharacter("logisticsAnalyst") when oItem:Has("logisticsAnalyst"). /* N∆o obrigat¢rio informar */
      else assign c-logisticsAnalyst = fcGetCharacter("logisticsAnalyst",oItem).                                  /* Obrigat¢rio informar     */

      if i-tp-despesa > 0
      then.
      else assign i-tp-despesa = emitente.tp-desp-padrao.

      if i-paymentTerms > 0
      then.
      else assign i-paymentTerms = emitente.cod-cond-pag.

      if avail emitente-cex
      then do:
           if  c-incoterm <> ""
           and c-incoterm <> ?
           then.
           else assign c-incoterm = emitente-cex.cod-incoterm-imp.

           if i-itinerary > 0
           then.
           else assign i-itinerary = emitente-cex.cod-itiner-imp.

           if i-checkpoint > 0
           then.
           else assign i-checkpoint = emitente-cex.cod-pto-contr.
      end. /* if avail emitente-cex */
     //else assign c-incoterm = "".

      if i-shipper > 0
      then.
      else assign i-shipper = emitente.cod-transp.

      /* Regra alterada conforme solicitaá∆o - 21/10 */
      if  c-incoterm    = "CIF"
      and i-tp-despesa <> 2 
      then assign i-shipper = 396. /* Frete CIF */
/*       if  c-incoterm           = "CIF"             */
/*       and emitente.tp-desp-pad = 1 /* Nacional */  */
/*       then assign i-shipper = 396. /* Frete CIF */ */

      for first tt-cabec
          where tt-cabec.incoterm         = c-incoterm
            and tt-cabec.logisticsAnalyst = c-logisticsAnalyst
            and tt-cabec.paymentTerms     = i-paymentTerms
            and tt-cabec.itinerary        = i-itinerary
            and tt-cabec.shipper          = i-shipper: end.

      if not avail tt-cabec
      then do:
           create tt-cabec.
           assign tt-cabec.centerID         = c-centerID
                  tt-cabec.spendType        = c-spendType
                  tt-cabec.buyer            = c-buyer           
                  tt-cabec.supplierID       = i-supplierID      
                  tt-cabec.incoterm         = c-incoterm        
                  tt-cabec.logisticsAnalyst = c-logisticsAnalyst
                  tt-cabec.paymentTerms     = i-paymentTerms    
                  tt-cabec.itinerary        = i-itinerary       
                  tt-cabec.shipper          = i-shipper
                  tt-cabec.codigo-icm       = i-codigo-icm.
           find current tt-cabec no-error.
      end. /* if not avail tt-cabec */

      assign tt-itens.r-cabec    = rowid(tt-cabec)
             tt-itens.tp-despesa = i-tp-despesa
             tt-itens.checkpoint = i-checkpoint.

      if tt-cabec.cod-mensagem = 0
      then if i-tp-despesa = 2 /* Internacional */
           then assign tt-cabec.cod-mensagem = 136.
           else assign tt-cabec.cod-mensagem = 135.
    end. /* do iLoop = 1 to oItens:length */
  end. /* if valid-object(oItens) */
  find current tt-itens no-error.

  if temp-table tt-erros-geral:has-records then
    return "NOK".

  if  temp-table tt-cabec:has-records
  and temp-table tt-itens:has-records 
  then.
  else do:
       run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de itens de pedido de compra para integrar").
       return "NOK".
  end.

  return "OK".
  catch oStop AS Progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
      run pi-cria-erro(oStop:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  catch eAnyError AS Progress.Lang.Error:
    do iNumMessages = 1 to eAnyError:nummessages:
      run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  finally:
    delete object jsonObjectPayload   no-error.
    delete object jsonArrayPathParams no-error.
    delete object oItens              no-error.
    delete object oItem               no-error.
    delete object objFornecedor       no-error.
    delete object arrayFornecedor     no-error.
  end.
end procedure.

PROCEDURE pi-create-ped-sourcing:
  define variable h-boin295        as handle  no-undo.
  define variable h-bocx140        as handle  no-undo.
  define variable h_api_ccusto     as handle  no-undo.
  define variable h_api_cta_ctbl   as handle  no-undo.
  define variable i-nr-ordem       as integer no-undo.
  define variable v_log_utz_ccusto as logical no-undo.

  empty temp-table tt-versao-integr.
  empty temp-table tt-pedido-compr.
  empty temp-table tt-cond-especif.
  empty temp-table tt-ordem-compra.
  empty temp-table tt-prazo-compra.
  empty temp-table tt-cotacao-item.
  empty temp-table ttcotacao-item.
  empty temp-table tt-desp-cotacao-item.
  empty temp-table tt-processo-imp.

  def var i-cont as inte no-undo.

  if emitente.natureza = 3
  then do:
       if tt-cabec.incoterm = ""
       then do:
            run pi-cria-erro(substitute("Incoterm n∆o encontrado para Emitente ComÇrcio Exterior com o c¢digo &1",
                                        quoter(tt-cabec.supplierID))).
            return "NOK".
       end.

       if tt-cabec.itinerary > 0
       then.
       else do:
            run pi-cria-erro(substitute("Itiner†rio n∆o encontrado para Emitente ComÇrcio Exterior com o c¢digo &1",
                                        quoter(tt-cabec.supplierID))).
            return "NOK".
       end.
  end. /*  if emitente.natureza = 3 */

  find first transporte no-lock
       where transporte.cod-transp = tt-cabec.shipper no-error.

  if not available transporte then do:
    run pi-cria-erro(substitute("Registro de transportadora n∆o localizado com o c¢digo &1", 
                                quoter(tt-cabec.shipper))).
    return "NOK".
  end.

  if transporte.via-transp = 0
  then do:
       run pi-cria-erro(substitute("Via Transp n∆o informada para transportadora &1", 
                                   quoter(transporte.cod-transp))).
       return "NOK".
  end.

  if  tt-cabec.paymentTerms <> 0
  and can-find(first cond-pagto where
                     cond-pagto.cod-cond-pag = tt-cabec.paymentTerms
                     no-lock)
  then.
  else do:
       run pi-cria-erro("Condiá∆o de Pagamento inv†lida").
       return "NOK".
  end.

  run inbo/boin295.p persistent set h-boin295.
  run openQueryStatic        in h-boin295(input "Main":U).
  run emptyRowErrors         in h-boin295.
  run geraNumeroPedidoCompra in h-boin295 (output i-num-pedido ).

  do i-cont = 1 to 3:
      find first int-pedido-compr 
           where int-pedido-compr.num-pedido = i-num-pedido
                 exclusive-lock no-error no-wait.

      if  not avail  int-pedido-compr
      and not locked int-pedido-compr
      then leave.

      pause(5).
      run geraNumeroPedidoCompra in h-boin295 (output i-num-pedido ).
  end. /* do i-cont = 1 to 3 */

  if can-find(first int-pedido-compr where
                    int-pedido-compr.num-pedido = i-num-pedido
                    no-lock)
  then do:
       run pi-cria-erro("Extens∆o j† cadastrada. Tente novamente.").
       return "NOK".       
  end.

  create int-pedido-compr.
  assign int-pedido-compr.num-pedido = i-num-pedido
         int-pedido-compr.tp-pedido  = i-tp-pedido.
  find current int-pedido-compr no-lock no-error.

  assign c-num-pedidos = c-num-pedidos
                      + ","
                      + string(i-num-pedido).

  create tt-pedido-compr.

  if tt-cabec.spendType = "Indiretos" 
  then assign tt-pedido-compr.responsavel = tt-cabec.buyer.
  else assign tt-pedido-compr.responsavel = tt-cabec.logisticsAnalyst.

  assign tt-pedido-compr.ind-tipo-movto       = 1
         tt-pedido-compr.num-pedido           = i-num-pedido
         tt-pedido-compr.natureza             = 1 // 1 - Compra
         tt-pedido-compr.end-cobranca         = tt-cabec.centerID
         tt-pedido-compr.end-entrega          = tt-cabec.centerID
         tt-pedido-compr.cod-estabel          = tt-cabec.centerID
         tt-pedido-compr.cod-estab-gestor     = tt-cabec.centerID
         tt-pedido-compr.num-ped-benef        = 0
         tt-pedido-compr.data-pedido          = today
         tt-pedido-compr.situacao             = 1 // 1 - Impresso, 2 - N∆o Impresso
         tt-pedido-compr.cod-emitente         = emitente.cod-emitente
         tt-pedido-compr.cod-emit-terc        = emitente.cod-emitente
         tt-pedido-compr.frete                = 2 // 2 - A Pagar
         tt-pedido-compr.cod-transp           = transporte.cod-transp
         tt-pedido-compr.via-transp           = transporte.via-transp
         tt-pedido-compr.cod-cond-pag         = tt-cabec.paymentTerms
         tt-pedido-compr.cod-mensagem         = tt-cabec.cod-mensagem
         tt-pedido-compr.impr-pedido          = true
         tt-pedido-compr.comentarios          = "Pedido gerado por meio da integraá∆o com Ariba (Sourcing)"
         tt-pedido-compr.mot-elimina          = ""
         tt-pedido-compr.emergencial          = true
         tt-pedido-compr.contr-forn           = false
         //tt-pedido-compr.nr-prox-ped        = 
         //tt-pedido-compr.nr-processo        = 
         //tt-pedido-compr.i-importador       = 
         //tt-pedido-compr.i-moeda            = 
         //tt-pedido-compr.i-cod-forma        = 
         //tt-pedido-compr.i-cod-via          = 
         //tt-pedido-compr.i-cod-porto        = 
         //tt-pedido-compr.de-vl-fob          = 
         //tt-pedido-compr.i-exportador       = 
         //tt-pedido-compr.num-id-documento   = 
         //tt-pedido-compr.nr-contrato        = 
         //tt-pedido-compr.gera-edi           = 
         //tt-pedido-compr.nome-ass           =
         //tt-pedido-compr.cargo-ass          =
         //tt-pedido-compr.compl-entrega      =
         //tt-pedido-compr.l-tipo-ped         =
         //tt-pedido-compr.l-classificacao    =
         //tt-pedido-compr.l-ind-prof         =
         //tt-pedido-compr.i-situacao         =
         //tt-pedido-compr.c-cod-tabela       =
         //tt-pedido-compr.c-prazo            =
         //tt-pedido-compr.c-descr-merc       =
         //tt-pedido-compr.i-cod-porto        =
         //tt-pedido-compr.de-vl-fob          =
         //tt-pedido-compr.c-embalagem        =
         //tt-pedido-compr.c-observacao       =
         //tt-pedido-compr.desc-forma         =
         //tt-pedido-compr.desc-via           =
         //tt-pedido-compr.de-vl-frete-i      =
         //tt-pedido-compr.ind-orig-entrada   =
         //tt-pedido-compr.ind-via-envio      =
         //tt-pedido-compr.nro-proc-entrada   =
         //tt-pedido-compr.nro-proc-saida     =
         //tt-pedido-compr.nro-proc-alteracao =
         //tt-pedido-compr.cod-maq-origem     =
         //tt-pedido-compr.num-processo-mp    =
         //tt-pedido-compr.nr-ped-venda       =
         //tt-pedido-compr.cod-entrega        =
         //tt-pedido-compr.endereco_text      =
         //tt-pedido-compr.endereco           =
         //tt-pedido-compr.bairro             =
         //tt-pedido-compr.cidade             =
         //tt-pedido-compr.estado             =
         //tt-pedido-compr.pais               =
         //tt-pedido-compr.cep                =
         //tt-pedido-compr.jurisdicao         =
         //tt-pedido-compr.local-entrega      =
         //tt-pedido-compr.cod-usuar-criac    =
         //tt-pedido-compr.dat-criac          =
         //tt-pedido-compr.cod-usuar-alter    =
         //tt-pedido-compr.dat-alter          =
         //tt-pedido-compr.hra-criac          =
         //tt-pedido-compr.hra-alter          =
         .

  create tt-cond-especif.
  buffer-copy tt-pedido-compr 
       except nr-contrato comentarios
              char-1      char-2
              int-1       int-2 
              dec-1       dec-2 
              log-1       log-2 
              data-1      data-2
           to tt-cond-especif.

  run ccp/ccapi333.p (input yes,
                      output i-nr-ordem).

  for each tt-itens
     where tt-itens.r-cabec = rowid(tt-cabec):
    find first item no-lock
         where item.it-codigo = string(tt-itens.productID) no-error.

    if not avail item
    then do:
         run pi-cria-erro("Item " + string(tt-itens.productID) + " n∆o cadastrado" ).
         return "NOK".
    end.

    if emitente.natureza = 3
    then if tt-itens.checkpoint > 0
         then.
         else do:
              run pi-cria-erro(substitute("Ponto de Controle n∆o encontrado para Emitente ComÇrcio Exterior com o c¢digo &1",
                                          quoter(tt-cabec.supplierID))).
              return "NOK".
         end.

    assign tt-itens.tipo-contr = item.tipo-contr.

    if can-find(first b-tt-itens where
                    //b-tt-itens.r-cabec  = rowid(tt-cabec) and
                      b-tt-itens.sequence = tt-itens.sequence
                  and rowid(b-tt-itens)  <> rowid(tt-itens))
    then do:
         run pi-cria-erro("Sequància " + string(tt-itens.sequence) + " repetida no Pedido" ).
         return "NOK".
    end.

    find first mgcad.moeda no-lock
         where moeda.descricao = tt-itens.currency no-error.

    if not avail moeda
    then do:
         run pi-cria-erro("Moeda " + tt-itens.currency + " n∆o cadastrada" ).
         return "NOK".
    end.

    for first item-uni-estab
        where item-uni-estab.it-codigo   = item.it-codigo
          and item-uni-estab.cod-estabel = estabelec.cod-estabel
              no-lock: end.

    find first item-fornec no-lock
         where item-fornec.it-codigo    = item.it-codigo
           and item-fornec.cod-emitente = emitente.cod-emitente no-error.

    /* Refina Centros de Custo */
    if tt-itens.ledgerAccount <> ""
    THEN DO:
        release b-estabelec.

        if tt-itens.centerIDcc <> ""
        then for first b-estabelec
                 where b-estabelec.cod-estabel = tt-itens.centerIDcc
                       no-lock: end.

        if not avail b-estabelec
        then do:
             run pi-cria-erro("Estabelecimento para Centro Custo " + tt-itens.costCenter + " Ç inv†lido" ).
             return "NOK".
        end.

        assign tt-itens.ledgerAccount = string(integer(tt-itens.ledgerAccount), "99999999") no-error.
    
        if not valid-handle(h_api_cta_ctbl) then
          run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  b-estabelec.ep-codigo,   /* EMPRESA EMS2 */
                                                        input  b-estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                        input  tt-itens.businessUnit,   /* UNIDADE NEG‡CIO */
                                                        input  "PADRAO",                      /* PLANO CONTAS */ 
                                                        input  tt-itens.ledgerAccount,  /* CONTA */
                                                        input  "",                      /* PLANO CCUSTO */ 
                                                        input  tt-itens.costCenter,     /* CCUSTO */
                                                        input  today,                   /* DATA TRANSACAO */
                                                        output table tt_log_erro).      /* ERROS */
        if temp-table tt_log_erro:has-records then do:
          for each tt_log_erro:
            run pi-cria-erro(substitute("&1 - &2. &3",
                            tt_log_erro.ttv_num_cod_erro,
                            tt_log_erro.ttv_des_msg_ajuda,
                            tt_log_erro.ttv_des_msg_erro)).
          end.
          return "NOK".
        end.
        if not valid-handle(h_api_ccusto) then
          run prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
        
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  b-estabelec.ep-codigo,   /* EMPRESA EMS 2 */
                                                           input  b-estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "PADRAO",                /* PLANO CONTAS */
                                                           input  tt-itens.ledgerAccount,  /* CONTA */
                                                           input  TODAY,                   /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,        /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).      /* ERROS */
        if temp-table tt_log_erro:has-records then do:
          for each tt_log_erro:
            run pi-cria-erro(substitute("&1 - &2. &3",
                            tt_log_erro.ttv_num_cod_erro,
                            tt_log_erro.ttv_des_msg_ajuda,
                            tt_log_erro.ttv_des_msg_erro)).
          end.
          return "NOK".
        end.
        if not v_log_utz_ccusto then
          assign tt-itens.costCenter = "".

        if not can-find(first unid-negoc where
                              unid-negoc.cod-unid-negoc = tt-itens.businessUnit
                              no-lock)
        then do:
             run pi-cria-erro("Unidade Neg¢cio n∆o informada ou n∆o cadastrada para ID " + item.it-codigo + ", " + tt-itens.ledgerAccount + "/" + tt-itens.costCenter).
             return "NOK".
        end.
    end. /* if tt-itens.ledgerAccount <> "" */

    create tt-ordem-compra.
    if tt-cabec.spendType = "Indiretos" 
    then assign tt-ordem-compra.requisitante = tt-cabec.buyer.
    else assign tt-ordem-compra.requisitante = tt-cabec.logisticsAnalyst.

    assign tt-ordem-compra.l-split        = false
           tt-ordem-compra.ind-tipo-movto = 1
           tt-ordem-compra.numero-ordem   = i-nr-ordem
           tt-itens.numero-ordem          = tt-ordem-compra.numero-ordem
           tt-ordem-compra.num-pedido     = tt-pedido-compr.num-pedido
           tt-ordem-compra.data-pedido    = tt-pedido-compr.data-pedido
           tt-ordem-compra.data-cotacao   = today
           tt-ordem-compra.cod-cond-pag   = tt-pedido-compr.cod-cond-pag
           tt-ordem-compra.cod-comprado   = tt-pedido-compr.responsavel
           tt-ordem-compra.cod-emitente   = tt-pedido-compr.cod-emitente
           tt-ordem-compra.cod-estabel    = tt-pedido-compr.cod-estabel
           tt-ordem-compra.cod-estab-gestor = tt-pedido-compr.cod-estab-gestor
           tt-ordem-compra.ep-codigo      = estabelec.ep-codigo
           tt-ordem-compra.impr-ficha     = param-compra.imprime-fich
           tt-ordem-compra.usuario        = c-seg-usuario
           tt-ordem-compra.natureza       = tt-pedido-compr.natureza
           tt-ordem-compra.situacao       = if tt-pedido-compr.cod-emitente = 532365 /* regra 27/02/2023 */
                                            then 6 /* Recebida   */
                                            else 2 /* Confirmada */
           tt-ordem-compra.origem         = 1 /* Manual     */
           tt-ordem-compra.frete          = not (tt-cabec.incoterm <> "CIF" and
                                                 tt-cabec.incoterm <> "CFR" and
                                                 tt-cabec.incoterm <> "CPT" and
                                                 tt-cabec.incoterm <> "CIP" and
                                                 tt-cabec.incoterm <> "DPU" and
                                                 tt-cabec.incoterm <> "DAP" and
                                                 tt-cabec.incoterm <> "DDP")
           tt-ordem-compra.it-codigo      = item.it-codigo
           tt-ordem-compra.dep-almoxar    = item.deposito-pad
           tt-ordem-compra.cod-refer      = ''
           tt-ordem-compra.mo-codigo      = moeda.mo-codigo
           /*tt-ordem-compra.narrativa      = if item.tipo-contr = 4
                                            then string(tt-itens.productNameComplement)
                                            else ""*/
           tt-ordem-compra.narrativa      = "[" + STRING(i-nr-ordem) + "] " + string(tt-itens.productNameComplement) 
           tt-ordem-compra.cod-unid-negoc = if  item.tipo-contr       = 4    /* DÇbito Direto */
                                            and tt-itens.businessUnit <> ""
                                            then tt-itens.businessUnit
                                            else if avail item-uni-estab
                                                 then item-uni-estab.cod-unid-negoc
                                                 else item.cod-unid-negoc
           tt-ordem-compra.ct-codigo      = if item.tipo-contr = 4          /* DÇbito Direto */
                                            then tt-itens.ledgerAccount
                                            else ""
           tt-ordem-compra.sc-codigo      = if  item.tipo-contr         = 4 /* DÇbito Direto */
                                            and tt-itens.ledgerAccount <> ""
                                            then tt-itens.costCenter
                                            else ""
           tt-ordem-compra.conta-contabil = trim(tt-ordem-compra.ct-codigo + tt-ordem-compra.sc-codigo)
           tt-ordem-compra.qt-solic       = tt-itens.quantity
           tt-ordem-compra.data-emissao   = today
           tt-ordem-compra.data-atualiz   = today
           tt-ordem-compra.hora-atualiz   = string(time,"hh:mm:ss")
           tt-ordem-compra.aliquota-icm   = tt-itens.icmsTax //if tt-pedido-compr.natureza = 1 then tt-itens.icmsTax else 0 - 20230210
           tt-ordem-compra.aliquota-ipi   = tt-itens.ipiTax  //if tt-pedido-compr.natureza = 1 then tt-itens.ipiTax  else 0 - 20230210
           tt-ordem-compra.aliquota-iss   = tt-itens.issTax  //if tt-pedido-compr.natureza = 2 then tt-itens.issTax  else 0 - 20230210
           tt-ordem-compra.preco-fornec   = tt-itens.unitPrice
           tt-ordem-compra.preco-unit     = tt-itens.unitPrice
           tt-ordem-compra.preco-orig     = tt-itens.unitPrice
           tt-ordem-compra.pre-unit-for   = tt-itens.unitPrice
           tt-ordem-compra.cod-transp     = transporte.cod-transp
           tt-ordem-compra.codigo-ipi     = FALSE
           tt-ordem-compra.tp-despesa     = tt-itens.tp-despesa
           i-nr-ordem                     = i-nr-ordem + 1
          //tt-ordem-compra.ordem-servic   = ord-prod.nr-ord-prod
          //tt-ordem-compra.op-codigo      = 
          //tt-ordem-compra.nr-tab         = 
           .

    create tt-prazo-compra.
    assign tt-prazo-compra.numero-ordem   = tt-ordem-compra.numero-ordem
           tt-prazo-compra.ind-tipo-movto = 1
           tt-prazo-compra.parcela        = 1
           tt-itens.parcela               = tt-prazo-compra.parcela
           tt-prazo-compra.it-codigo      = tt-ordem-compra.it-codigo
           tt-prazo-compra.un             = /*if available item-fornec then item-fornec.unid-med-for else*/ item.un
           tt-prazo-compra.quantidade     = tt-itens.quantity
           tt-prazo-compra.quantid-orig   = tt-itens.quantity
           tt-prazo-compra.quant-saldo    = tt-itens.quantity
           tt-prazo-compra.qtd-a-ped-forn = 0
           tt-prazo-compra.qtd-do-forn    = tt-itens.quantity
           tt-prazo-compra.qtd-sal-forn   = if tt-itens.supplierQuantity <> 0
                                            then tt-itens.supplierQuantity
                                            else tt-itens.quantity
           tt-prazo-compra.cod-alter      = false
           tt-prazo-compra.situacao       = tt-ordem-compra.situacao
           //tt-prazo-compra.nome-abrev     = emitente.nome-abrev - Se informado retorna erro 558 - Cliente n∆o cadastrado(a)!
           //tt-prazo-compra.cod-refer         = ord-prod.cod-refer
           //tt-prazo-compra.pedido-clien      = ''
           //tt-prazo-compra.nr-sequencia      = ord-prod.nr-sequencia
           //tt-prazo-compra.data-entrega-ant  = tt-prazo-compra.data-entrega
           .

/*     if tt-pedido-compr.natureza = 2 then           */
/*       assign tt-prazo-compra.data-entrega = today  */
/*              tt-prazo-compra.data-orig    = today. */
/*     else                                           */
      assign tt-prazo-compra.data-entrega = add-interval(today, integer(tt-itens.leadTime) + integer(tt-itens.transitTime), "day")
             tt-prazo-compra.data-orig    = tt-prazo-compra.data-entrega.

    //Criar Cotacao
    create tt-cotacao-item.
    buffer-copy tt-ordem-compra to tt-cotacao-item
    assign tt-cotacao-item.numero-ordem         = tt-ordem-compra.numero-ordem
           tt-cotacao-item.cod-emitente         = tt-ordem-compra.cod-emitente
           tt-cotacao-item.itinerario           = tt-cabec.itinerary
           tt-cotacao-item.int-1                = tt-cabec.itinerary
          //tt-cotacao-item.cod-pto-contr-base   = tt-itens.checkpoint
           tt-cotacao-item.data-cotacao         = tt-ordem-compra.data-cotacao
           tt-cotacao-item.cot-aprovada         = yes
           tt-cotacao-item.un                   = if tt-itens.unitMeasure <> "" then tt-itens.unitMeasure else item.un
           tt-cotacao-item.motivo-apr           = 'Aprovaá∆o Autom†tica'
           tt-cotacao-item.aliquota-ipi         = tt-itens.ipiTax  //if tt-pedido-compr.natureza = 1 then tt-itens.ipiTax   else 0 - 20230210
           tt-cotacao-item.aliquota-icm         = tt-itens.icmsTax //if tt-pedido-compr.natureza = 1 then tt-itens.icmsTax  else 0 - 20230210
           tt-cotacao-item.aliquota-iss         = tt-itens.issTax  //if tt-pedido-compr.natureza = 2 then tt-itens.issTax   else 0 - 20230210
           tt-cotacao-item.frete                = tt-ordem-compra.frete
           tt-cotacao-item.cod-incoterm         = tt-cabec.incoterm
           tt-cotacao-item.codigo-icm           = tt-cabec.codigo-icm
           tt-cotacao-item.cdn-pais-orig        = fcGetPais().

    // Fornecedor Estrangeiro
    //if emitente.natureza = 3 then 
      if tt-itens.checkpoint <> 0 then
        assign tt-cotacao-item.cod-pto-contr-base = tt-itens.checkpoint.
      else 
        if avail emitente-cex
        then assign tt-cotacao-item.cod-pto-contr-base = emitente-cex.cod-pto-contr.

    EMPTY TEMP-TABLE ttcotacao-item.

    create ttcotacao-item.
    buffer-copy tt-cotacao-item to ttcotacao-item.

    /*--- Calcula o pre-unit-for ---*/
    run inbo/boin082ca.p persistent set hboin082ca.
    run calculaPrecoUnitFornecedorCotacao in hBoin082ca (input NO,
                                                         input ttcotacao-item.numero-ordem,
                                                         input-output table ttcotacao-item).

    FIND FIRST ttcotacao-item NO-ERROR.
    BUFFER-COPY ttcotacao-item TO tt-cotacao-item.
   
    delete procedure hBoin082ca.
                     hBoin082ca = ?.

    create tt-desp-cotacao-item.
    buffer-copy tt-cotacao-item to tt-desp-cotacao-item.
  end.

  create tt-versao-integr.
  assign tt-versao-integr.cod-versao-integracao = 1.

  run ccp/ccapi303.p(input  table tt-versao-integr,
                     output table tt-erros-geral append,
                     input  table tt-pedido-compr,
                     input  table tt-cond-especif,
                     input  table tt-ordem-compra,
                     input  table tt-prazo-compra,
                     input  table tt-cotacao-item,
                     input  table tt-desp-cotacao-item).

  for each tt-cotacao-item:
    for first cotacao-item exclusive-lock
        where cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem
          and cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente:
      assign overlay(cotacao-item.char-1, 21, 20) = trim(string(tt-cotacao-item.cod-incoterm))
             overlay(cotacao-item.char-1, 41, 20) = trim(string(tt-cotacao-item.cod-pto-contr-base))
             overlay(cotacao-item.char-2, 41, 20) = trim(string(tt-cotacao-item.cod-emitente))
             cotacao-item.cod-incoterm       = tt-cotacao-item.cod-incoterm
             cotacao-item.cod-pto-contr-base = tt-cotacao-item.cod-pto-contr-base
             cotacao-item.itinerario         = tt-cotacao-item.itinerario
             cotacao-item.cdn-pais-orig      = tt-cotacao-item.cdn-pais-orig.
    end.
  end.

  if temp-table tt-erros-geral:has-records then
      return "NOK".

  for each tt-ordem-compra:
      for first tt-itens
          where tt-itens.numero-ordem = tt-ordem-compra.numero-ordem: end.

      for first int-ordem-compra
          where int-ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem
                exclusive-lock: end.

      if not avail int-ordem-compra
      then do:
           create int-ordem-compra.
           assign int-ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem.
      end.

      assign int-ordem-compra.ind-origem-ext = 3 /* Sourcing */
             int-ordem-compra.ind-origem-end = 1 /* Outros */
             int-ordem-compra.end-entrega    = "Nome: "     + trim(estabelec.nome)
                                             + chr(10)
                                             + "Endereáo: " + trim(estabelec.endereco)
                                             + chr(10)
                                             + "Bairro: "   + trim(estabelec.bairro)
                                             + chr(10)
                                             + "Cidade: "   + trim(estabelec.cidade)
                                             + chr(10)
                                             + "CEP: "      + STRING(estabelec.cep)
                                             + chr(10)
                                             + "UF: "       + trim(estabelec.estado)
                                             + chr(10)
                                             + "Pa°s: "     + trim(estabelec.pais)
                                             + chr(10).
      find current int-ordem-compra no-lock no-error.

      for first int-prazo-compra
          where int-prazo-compra.numero-ordem = tt-itens.numero-ordem
            and int-prazo-compra.parcela      = tt-itens.parcela
                exclusive-lock: end.

      if not avail int-prazo-compra
      then do:
           create int-prazo-compra.
           assign int-prazo-compra.numero-ordem = tt-itens.numero-ordem
                  int-prazo-compra.parcela      = tt-itens.parcela.
      end.

      assign int-prazo-compra.data-necessidade = today
             int-prazo-compra.seq-ariba        = string(tt-itens.sequence)
             int-prazo-compra.num-pedido       = tt-pedido-compr.num-pedido.
      find current int-prazo-compra no-lock no-error.

      if  tt-itens.tipo-contr     = 4 /* DÇbito Direto */
      and tt-itens.ledgerAccount <> ""
      then do:
           CREATE matriz-rat-ordem.
           ASSIGN matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                  matriz-rat-ordem.sc-codigo    = tt-itens.costCenter
                  matriz-rat-ordem.ct-codigo    = tt-itens.ledgerAccount
                  matriz-rat-ordem.perc-rateio  = 100
                  matriz-rat-ordem.char-1       = ""
                  overlay(matriz-rat-ordem.char-2,1,3) = tt-ordem-compra.cod-unid-negoc.
           find current matriz-rat-ordem no-lock no-error.
      end. /* if tt-itens.tipo-contr = 4 */
  end. /* for each tt-ordem-compra */

  // Fornecedor Estrangeiro
  if emitente.natureza = 3 then do:
/*     find first emitente-cex of emitente no-lock no-error. */
    find first tt-itens 
         where tt-itens.r-cabec = rowid(tt-cabec) no-error.
    create tt-processo-imp.
    assign tt-processo-imp.cod-estabel                = tt-pedido-compr.cod-estabel
           tt-processo-imp.estab-fisc                 = tt-pedido-compr.cod-estabel
           tt-processo-imp.nr-proc-imp                = string(tt-pedido-compr.num-pedido)
           tt-processo-imp.num-pedido                 = tt-pedido-compr.num-pedido
           tt-processo-imp.cod-exportador             = emitente.cod-emitente
           tt-processo-imp.dt-emissao                 = today
           tt-processo-imp.cod-fabricante             = emitente.cod-emitente
           tt-processo-imp.cod-despachante            = emitente-cex.cdn-despa-import
           tt-processo-imp.cod-transportador          = tt-pedido-compr.cod-transp
           tt-processo-imp.via-transp                 = tt-pedido-compr.via-transp
           tt-processo-imp.cod-itiner                 = tt-cabec.itinerary
           tt-processo-imp.cod-idioma                 = emitente-cex.cod-idioma
           tt-processo-imp.cod-mensagem               = tt-cabec.cod-mensagem
           //tt-processo-imp.dt-implantacao             = 
           //tt-processo-imp.dt-autorizacao             = 
           //tt-processo-imp.cod-consignatario          = 
           //tt-processo-imp.nr-conhecimento            = 
           //tt-processo-imp.carta-credito              = 
           //tt-processo-imp.narrativa                  = 
           //tt-processo-imp.cod-banco                  = 
           //tt-processo-imp.nr-rof                     = 
           //tt-processo-imp.regime-import              = 
           //tt-processo-imp.licenca-import             = 
           //tt-processo-imp.declaracao-import          = 
           //tt-processo-imp.cod-incoterm               = 
           //tt-processo-imp.contrato-cambio            = 
           //tt-processo-imp.situacao                   = 
           //tt-processo-imp.merc-orig                  = 
           //tt-processo-imp.cod-agente                 = 
           //tt-processo-imp.texto-mensag               = 
           //tt-processo-imp.destino-documentacao       = 
           //tt-processo-imp.cdn-corretor-cambio-import = 
           //tt-processo-imp.cdn-despa-exter-import     = 
           //tt-processo-imp.cdn-segurad-import         = 
           //tt-processo-imp.cdn-corretor-import        = 
           .

      run cxbo/bocx140.p persistent set h-bocx140.
      run openQuery       in h-bocx140(1).
      run validateCreate IN h-bocx140 (input  table tt-processo-imp,
                                       output table RowErrors,
                                       output tt-processo-imp.r-rowid).
      if temp-table RowErrors:has-records then do:
        for each RowErrors:
          create tt-erros-geral.
          assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                 tt-erros-geral.des-erro = "Processo Imp: " + RowErrors.ErrorDescription.
        end.
        delete procedure h-bocx140 no-error.
        return "NOK".
      end.
  end.
  return "OK".
  catch oStop AS Progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
      run pi-cria-erro(oStop:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  catch eAnyError AS Progress.Lang.Error:
    do iNumMessages = 1 to eAnyError:nummessages:
      run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  finally:
    delete procedure h-boin295      no-error.
    delete procedure h-bocx140      no-error.
    delete procedure h_api_cta_ctbl no-error.
    delete procedure h_api_ccusto   no-error.
  end.

end.

procedure pi-cria-item-fornec:
  define variable h-boin688 as handle no-undo.
  define variable h-boin178 as handle no-undo.

  def var c-item-do-forn-aux as char no-undo.
  def var c-unid-med-for-aux as char no-undo.

  create tt-versao-integr.
  assign tt-versao-integr.cod-versao-integracao = 2.

  for each tt-itens
           break by tt-itens.productID:

    if not first-of(tt-itens.productID)
    then next.

    assign c-item-do-forn-aux = ""
           c-unid-med-for-aux = "" /* atená∆o; mais adiante no c¢digo, vari†vel ser† usada como referància para indicar criaá∆o/alteraá∆o do registro */
        .

    find first item no-lock
         where item.it-codigo = string(tt-itens.productID) no-error.
    if not available item then do:
      run pi-cria-erro(substitute("Registro de item n∆o localizado com o c¢digo &1", quoter(tt-itens.productID))).
      return "NOK".
    end.

    empty temp-table tt-item-fornec.
    empty temp-table tt-item-fornec-estab.
    empty temp-table RowErrors.

    assign c-item-do-forn-aux = if  tt-itens.supplierReference <> ""
                                and tt-itens.supplierReference <> ?
                                then tt-itens.supplierReference 
                                else string(emitente.cod-emitente)
           c-unid-med-for-aux = if  tt-itens.unitMeasure <> "" 
                                and tt-itens.unitMeasure <> ?
                                then tt-itens.unitMeasure       
                                else item.un.

    run inbo/boin178.p persistent set h-boin178.
    run openQueryStatic in h-boin178 (input "main":U).
    run emptyRowErrors  in h-boin178.

    find first item-fornec no-lock
         where item-fornec.it-codigo    = item.it-codigo
           and item-fornec.cod-emitente = emitente.cod-emitente no-error.

    create tt-item-fornec.

    if avail item-fornec
    then buffer-copy item-fornec to tt-item-fornec.
    else do:
         buffer-copy item except char-1 char-2 
                                 int-1  int-2 
                                 dec-1  dec-2 
                                 log-1  log-2 
                                 data-1 data-2 
                          to tt-item-fornec
         assign tt-item-fornec.cod-emitente        = emitente.cod-emitente
                tt-item-fornec.fator-conver        = item.fator-conver
                tt-item-fornec.num-casa-dec        = 0
                tt-item-fornec.aval-insp           = 5
                tt-item-fornec.idi-tributac-cofins = 2
                tt-item-fornec.idi-tributac-pis    = 2
                tt-item-fornec.classe-repro        = 4
                tt-item-fornec.cot-aut             = true.
    end. /* else do */

    assign tt-item-fornec.item-do-forn            = c-item-do-forn-aux
           tt-item-fornec.unid-med-for            = c-unid-med-for-aux
           tt-item-fornec.ativo                   = true
           tt-item-fornec.cod-cond-pag            = integer(tt-cabec.paymentTerms)
           //tt-item-fornec.lote-mul-for            = 
           //tt-item-fornec.tempo-ressup            = 
           //tt-item-fornec.narrativa               = 
           //tt-item-fornec.perc-compra             = 
           //tt-item-fornec.lote-minimo             = 
           //tt-item-fornec.cot-aut                 = 
           //tt-item-fornec.conceito                = 
           //tt-item-fornec.observacao              = 
           //tt-item-fornec.serie-nota              = 
           //tt-item-fornec.numero-nota             = 
           //tt-item-fornec.horiz-fixo              = 
           //tt-item-fornec.ped-fornec              = 
           //tt-item-fornec.tp-inspecao             = 
           //tt-item-fornec.criticidade             = 
           //tt-item-fornec.qt-max-ordem            = 
           //tt-item-fornec.niv-qua-ac              = 
           //tt-item-fornec.niv-inspecao            = 
           //tt-item-fornec.cod-mensagem            = 
           //tt-item-fornec.perc-pont-forn          = 
           //tt-item-fornec.ind-pont                = 
           //tt-item-fornec.perc-dev-forn           = 
           //tt-item-fornec.concentracao            = 
           //tt-item-fornec.rendimento              = 
           //tt-item-fornec.contr-forn              = 
           //tt-item-fornec.hora-ini                = 
           //tt-item-fornec.hora-fim                = 
           //tt-item-fornec.reaj-tabela             = 
           //tt-item-fornec.cd-referencia           = 
           //tt-item-fornec.usa-contrato            = 
           //tt-item-fornec.char-1                  = 
           //tt-item-fornec.char-2                  = 
           //tt-item-fornec.dec-1                   = 
           //tt-item-fornec.dec-2                   = 
           //tt-item-fornec.int-1                   = 
           //tt-item-fornec.int-2                   = 
           //tt-item-fornec.log-1                   = 
           //tt-item-fornec.log-2                   = 
           //tt-item-fornec.data-1                  = 
           //tt-item-fornec.data-2                  = 
           //tt-item-fornec.check-sum               = 
           //tt-item-fornec.ult-ficha               = 
           //tt-item-fornec.val-aliq-cofins         = 
           //tt-item-fornec.val-aliq-pis            = 
           //tt-item-fornec.val-unit-pis            = 
           //tt-item-fornec.val-unit-cofins         = 
           //tt-item-fornec.val-reduc-pis-normal    = 
           //tt-item-fornec.val-reduc-cofins-normal = 
           //tt-item-fornec.cod-embal               = 
           //tt-item-fornec.cdn-fabrican            = 
           //tt-item-fornec.cdn-pais-orig           = 
           //tt-item-fornec.cdn-fornec-pregao       = 
           //tt-item-fornec.cod-barras              = 
           //tt-item-fornec.log-cod-barra-obrig     = 
           //tt-item-fornec.cod-unid-calc-cofins    = 
           //tt-item-fornec.cod-unid-calc-pis       = 
           no-error.
    
    if error-status:error
    then do:
         run pi-cria-erro("Erro no processamento do Item x Fornecedor " + tt-item-fornec.it-codigo + "/" + string(tt-item-fornec.cod-emitente)).
         return "NOK".
    end.

    if not avail item-fornec
    then do:
         run setRecord in h-boin178 (input table tt-item-fornec).
         run createRecord in h-boin178.
         run getRowErrors in h-boin178 (output table RowErrors).
    end. /* if avail item-fornec */
    else do:
         assign c-unid-med-for-aux = ? /* mais adiante no c¢digo, valor nulo indicar† alteraá∆o do registro, e n∆o criaá∆o */
/*                 c-item-do-forn-aux = if  item-fornec.item-do-forn <> ""        */
/*                                      and item-fornec.item-do-forn <> ?         */
/*                                      then item-fornec.item-do-forn             */
/*                                      else if  tt-itens.supplierReference <> "" */
/*                                           and tt-itens.supplierReference <> ?  */
/*                                           then tt-itens.supplierReference      */
/*                                           else string(emitente.cod-emitente)   */
                .

         if  item-fornec.item-do-forn = tt-item-fornec.item-do-forn
         and item-fornec.unid-med-for = tt-item-fornec.unid-med-for
         and item-fornec.ativo        = tt-item-fornec.ativo       
         and item-fornec.cod-cond-pag = tt-item-fornec.cod-cond-pag
         then.
         else do:
              run goToKey in h-boin178(input tt-item-fornec.it-codigo,
                                       input tt-item-fornec.cod-emitente).
        
              if return-value <> "OK":U
              then do:
                   run pi-cria-erro("Erro na leitura do Item x Fornecedor " + tt-item-fornec.it-codigo + "/" + string(tt-item-fornec.cod-emitente)).
                   return "NOK".
              end. /* if return-value <> "OK":U */

              run setRecord in h-boin178 (input table tt-item-fornec).
              run updateRecord in h-boin178.
              run getRowErrors in h-boin178 (output table RowErrors).
         end. /* else do */
    end. /* else do */
           
    if can-find(first RowErrors
                where RowErrors.ErrorType <> "INTERNAL":U) 
    then do:
         for each RowErrors:
             create tt-erros-geral.
             assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                    tt-erros-geral.des-erro = "Item x Fornec: " + RowErrors.ErrorDescription.
             find current tt-erros-geral no-error.
         end. /* for each RowErrors */
         return "NOK".
    end.

    find first item-fornec no-lock
         where item-fornec.it-codigo    = item.it-codigo
           and item-fornec.cod-emitente = emitente.cod-emitente no-error.

    if  avail item-fornec
    and item-fornec.item-do-forn = tt-item-fornec.item-do-forn
    and item-fornec.unid-med-for = tt-item-fornec.unid-med-for
    and item-fornec.ativo        = tt-item-fornec.ativo       
    and item-fornec.cod-cond-pag = tt-item-fornec.cod-cond-pag
    then if  c-unid-med-for-aux = ? /* int-fornec preexistente */
         and can-find(first int-item-for-pn where
                            int-item-for-pn.it-codigo    = item-fornec.it-codigo
                        and int-item-for-pn.cod-emitente = item-fornec.cod-emitente
                            no-lock)
         then.
         else do:
              /* cria-se/sobrep‰e-se */
              for first int-item-for-pn 
                  where int-item-for-pn.it-codigo    = item-fornec.it-codigo       
                    and int-item-for-pn.cod-emitente = item-fornec.cod-emitente
                        exclusive-lock: end.
        
              if not avail int-item-for-pn
              then do:
                   create int-item-for-pn.
                   assign int-item-for-pn.it-codigo    = item-fornec.it-codigo       
                          int-item-for-pn.cod-emitente = item-fornec.cod-emitente.
              end. /* if not avail int-item-for-pn */

              if c-unid-med-for-aux = ?
              then assign int-item-for-pn.item-do-forn = "".
              else assign int-item-for-pn.item-do-forn = string(item-fornec.cod-emitente).

              find current int-item-for-pn no-lock no-error.
              release int-item-for-pn.
         end. /* else do */
    else do:
         run pi-cria-erro("Item x Fornecedor " + tt-item-fornec.it-codigo + "/" + string(tt-item-fornec.cod-emitente) + " n∆o pìde ser criado/alterado").
         return "NOK".
    end. /* else do */

    empty temp-table RowErrors.

    find first item-fornec-estab no-lock
         where item-fornec-estab.it-codigo    = item.it-codigo
           and item-fornec-estab.cod-emitente = emitente.cod-emitente
           and item-fornec-estab.cod-estabel  = estabelec.cod-estabel no-error.
    if not available item-fornec-estab then do:
      create tt-item-fornec-estab.
      buffer-copy item-fornec except char-1 char-2 
                                     int-1  int-2 
                                     dec-1  dec-2 
                                     log-1  log-2 
                                     data-1 data-2 to tt-item-fornec-estab
      assign tt-item-fornec-estab.cod-estabel = estabelec.cod-estabel.
      overlay(tt-item-fornec-estab.char-1,1,2) = substr(item-fornec.char-2,3,2).
      run inbo/boin688.p persistent set h-boin688.
      run openQueryStatic in h-boin688("Main").
      run setRecord       in h-boin688(input table tt-item-fornec-estab).
      run createRecord    in h-boin688.
      run getRowErrors    in h-boin688(output table RowErrors).
      if temp-table RowErrors:has-records then do:
        for each RowErrors:
          create tt-erros-geral.
          assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                 tt-erros-geral.des-erro = "Item x Fornec x Estab: " + RowErrors.ErrorDescription.
        end.
        run emptyRowErrors  in h-boin688.
        delete procedure h-boin688 no-error.
        return "NOK".
      end.
    end.
  end.
  return "OK".
  catch oStop AS Progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
      run pi-cria-erro(oStop:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  catch eAnyError AS Progress.Lang.Error:
    do iNumMessages = 1 to eAnyError:nummessages:
      run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  finally:
      if valid-handle(h-boin178)
      then delete procedure h-boin178 no-error.
  end.
end procedure.

procedure pi-cria-erro:
  define input parameter p-des-erro as character no-undo.
  create tt-erros-geral.
  assign tt-erros-geral.cod-erro = 17006
         tt-erros-geral.des-erro = p-des-erro.
  IF log-manager:logging-level > 0 THEN
      log-manager:write-message(p-des-erro, "ARIBA").
  return "OK".
end procedure.

procedure pi-back-integration:
    def var i-num-ped-integr as inte no-undo.
    def var v-log-pedido     as logi no-undo.
    def var v-num-seq-movto  as inte no-undo.

    do i-aux = 1 to num-entries(c-num-pedidos,","):
        assign i-num-ped-integr = inte(entry(i-aux,c-num-pedidos,",")).

        /* win295 */
        for first pedido-compr
            where pedido-compr.num-pedido = i-num-ped-integr
                  no-lock: end.

        if not avail pedido-compr
        then next.

        IF  can-find(first int-ped-compr where
                           int-ped-compr.num-pedido = pedido-compr.num-pedido
                           no-lock)
        AND CAN-FIND(FIRST ordem-compra WHERE
                           ordem-compra.num-pedido = pedido-compr.num-pedido
                           NO-LOCK)
        then.
        else next.
       
        for first int-ped-compr 
            where int-ped-compr.num-pedido = pedido-compr.num-pedido
                  exclusive-lock: end.
    
        FIND LAST int-mov-ped-compr NO-LOCK
             WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
               AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
        IF  AVAIL int-mov-ped-compr
        and int-mov-ped-compr.ind-tip-movto = "N∆o Integrado"
        THEN.
        else next.

        /* Verifica se o Tipo do Pedido est† na lista pra integrar automaticamente no ARIBA */
        RUN pi-tipo-pedido (INPUT  pedido-compr.num-pedido,
                            OUTPUT v-log-pedido).

        if not v-log-pedido
        then next.
    
        ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
        CREATE int-mov-ped-compr.
        ASSIGN int-ped-compr.ind-status        = 2 // "Em Processamento"
               int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
               int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
               int-mov-ped-compr.num-seq-movto = v-num-seq-movto
               int-mov-ped-compr.ind-tip-movto = "Em Processamento"
               int-mov-ped-compr.dat-movto     = TODAY
               int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
               int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
               int-mov-ped-compr.des-text-histor = "Pedido de Compras em processamento: " + STRING (pedido-compr.num-pedido).
        /* Cria tt-int-ped-compr */
        RUN esp/ccp/esccp055r.p (INPUT NO,                 // Acompanhamento
                                 INPUT pedido-compr.num-pedido,
                                 INPUT "tt-int-ped-compr", // pi-cria-tt-int-ped-compr
                                 INPUT NO,                 // Reenvio
                                 INPUT-OUTPUT TABLE tt-int-ped-compr).
        /* Envia para o ARIBA */
        RUN esp/ccp/esccp055r.p (INPUT NO,            // Acompanhamento
                                 INPUT pedido-compr.num-pedido,
                                 INPUT "es-api-log",  // pi-cria-es-api-log
                                 INPUT NO,            // Reenvio
                                 INPUT-OUTPUT TABLE tt-int-ped-compr).
    end. /* do i-aux = 1 to */

    return "OK".
end procedure.

PROCEDURE pi-tipo-pedido: /* win295 */
    DEF INPUT PARAM p-num-pedido  AS INT NO-UNDO.
    DEF OUTPUT PARAM p-log-pedido AS LOG NO-UNDO.

    DEF VAR v-num           AS INT NO-UNDO.
    DEF VAR i-tp-pedido     AS INT NO-UNDO.
    DEF VAR c-tp-pedido     AS CHAR NO-UNDO.
    DEF VAR c-tp-pedido-num AS CHAR NO-UNDO.
    DEF var p-des-tipo      AS CHAR NO-UNDO.

    FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
        WHERE ponto-programa.nome-programa = "cc0300a"
          AND ponto-programa.ponto         = 1
          AND ponto-programa.tipo          = 3, // Item
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF NUM-ENTRIES(conteudo-programa.conteudo, ";") < 4         THEN NEXT.
        IF ENTRY(4,conteudo-programa.conteudo,";")      = "INATIVO" THEN NEXT.
        ASSIGN c-tp-pedido = c-tp-pedido + ","
                           + TRIM (ENTRY (2, conteudo-programa.conteudo, ";"))
               c-tp-pedido-num = c-tp-pedido-num + ","
                           + TRIM (ENTRY (1, conteudo-programa.conteudo, ";")).
    END.
    ASSIGN c-tp-pedido     = SUBSTR (c-tp-pedido, 2)
           c-tp-pedido-num = SUBSTR (c-tp-pedido-num, 2).
           
    FIND FIRST int-pedido-compr NO-LOCK 
         WHERE int-pedido-compr.num-pedido = p-num-pedido NO-ERROR.
    IF AVAIL int-pedido-compr THEN
        ASSIGN i-tp-pedido = int-pedido-compr.tp-pedido.

    ASSIGN p-log-pedido = NO.
    DO v-num = 1 TO NUM-ENTRIES (c-tp-pedido-num):
        IF ENTRY (v-num, c-tp-pedido-num) = STRING (i-tp-pedido) THEN DO:
            ASSIGN p-des-tipo = TRIM (ENTRY (v-num, c-tp-pedido)).
            FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
                WHERE ponto-programa.nome-programa = "win295"
                  AND ponto-programa.ponto         = 1
                  AND ponto-programa.tipo          = 5, // texto
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  and conteudo-programa.conteudo     = p-des-tipo:
                ASSIGN p-log-pedido = YES.
                RETURN.            
            END.
        END.            
    END.
    
END.

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) :
  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then
    return trim(oJson:GetCharacter(cProperty)).
  else do:
    run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
    return "NOK".
  end.
end function.

function fcGetInteger returns integer ( cProperty as character, oJson as JsonObject ) :
  def var i-funcao as inte no-undo.

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then do:
    assign i-funcao = integer(oJson:GetInt64(cProperty)) no-error.

    if error-status:error
    then do:
        run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
        return 0.
    end.
    return i-funcao.
  end.
  else do:
    run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
    return 0.
  end.
end function.

function fcGetDecimal returns decimal ( cProperty as character, oJson as JsonObject ) :
  def var de-funcao as deci no-undo.

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then do:
      assign de-funcao = decimal(oJson:GetDecimal(cProperty)) no-error.

      if error-status:error
      then do:
          run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
          return 0.
      end.

      return de-funcao.
  end.
  else do:
    run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
    return 0.
  end.
end function.

function fcGetPais returns integer () : 
    if  avail item-fornec
    and item-fornec.cdn-pais-orig > 0
    then return item-fornec.cdn-pais-orig.
    
    if avail item
    then for first item-mat fields (cdn-pais-orig) no-lock
             where item-mat.it-codigo     = item.it-codigo
               and item-mat.cdn-pais-orig > 0:
             return item-mat.cdn-pais-orig.
         end.

    if avail mgcad.pais
    then return pais.cod-pais.

    return 0.
end function.

