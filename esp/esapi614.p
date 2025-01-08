.block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi614.i}
{utp/ut-glob.i}

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define variable jsonObjectOutput as JsonObject        no-undo.
define variable jsonOutput       as JsonObject        no-undo.
define variable oErrors          as JsonArray         no-undo.
define variable oError           as JsonObject        no-undo.
define variable c-cod-fornecedor as character         no-undo.
define variable c-externalId     as character         no-undo.
define variable lcInput          as longchar          no-undo.
define variable lcOutput         as longchar          no-undo.
define variable jsonParser       as ObjectModelParser no-undo.
define variable jsonInput        as JsonObject        no-undo.
define variable iNumMessages     as integer           no-undo.
define variable c-tags           as character         no-undo.

def var i-purchaseOrder    as inte no-undo.
def var c-incoterm         as char no-undo.
def var c-logisticsAnalyst as char no-undo.
def var c-costCenter       as char no-undo.
def var i-ledgerAccount    as inte no-undo.
def var i-paymentTerms     as inte no-undo.
def var i-shipper          as inte no-undo.

def buffer b-tt-itens     for tt-itens.
def buffer b-tt-ccusto    for tt-ccusto.
def buffer b-ordem-compra for ordem-compra.
def buffer b-estabelec    for estabelec.

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetInteger   returns integer   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetDecimal   returns decimal   ( cProperty as character, oJson as JsonObject ) forwards.

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
    run pi-acompanhar in h-acomp ("Alter Pedido de Compra").

  run pi-input-api-headers (jsonInput).

  run pi-carga-json.

  if return-value = "OK"
  then run pi-principal.  

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  assign es-api-log.retorno-content-type = "application/json".
  if not can-find(first tt-erros-geral) then do:
    jsonObjectOutput:add("externalId",   c-externalId). 
    jsonObjectOutput:add("customerCode", c-cod-fornecedor). 
    jsonObjectOutput:add("purchasingId", string(i-purchaseOrder)). 
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

  if not temp-table tt-erros-geral:has-records then 
    assign es-api-log.cod-retorno = "200"
           es-api-log.aux         = "OCs do Pedido de Compra " + string(i-purchaseOrder) + " alteradas/eliminadas com sucesso".
  else do:
    assign es-api-log.cod-retorno = "500".
  end.
  empty temp-table tt-erros-geral.
  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

return "OK".

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-principal:
    run pi-update-ped-buying.
    
    if return-value <> "OK" 
    then undo, return "NOK".

    return "OK".
END PROCEDURE. /* procedure pi-principal */

procedure pi-carga-json :
  define variable jsonObjectPayload   as JsonObject no-undo.
  define variable oItens              as JsonArray  no-undo.
  define variable oCcustos            as JsonArray  no-undo.
  define variable oItem               as JsonObject no-undo.
  define variable oCcusto             as JsonObject no-undo.
  define variable iLoop               as integer    no-undo.
  define variable iLoop2              as integer    no-undo.
  define variable de-tot-rateio       as decimal    no-undo.

  DEFINE VARIABLE iResult             AS INTEGER     NO-UNDO.
  DEFINE VARIABLE dResult             AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE cResult             AS CHARACTER   NO-UNDO.

  release estabelec.
  release emitente.
  release emitente-cex.
  release transporte.

  empty temp-table tt-ordem-compra-aux.

  FIND FIRST param-global NO-LOCK NO-ERROR.

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload").

  if valid-object(jsonObjectPayload) then do:
    assign i-purchaseOrder = fcGetInteger("purchaseOrder",jsonObjectPayload).

    assign c-logisticsAnalyst = jsonObjectPayload:GetCharacter("logisticsAnalyst") when jsonObjectPayload:has("logisticsAnalyst") 
           c-incoterm         = jsonObjectPayload:GetCharacter("incoterm")         when jsonObjectPayload:has("incoterm")
           i-paymentTerms     = jsonObjectPayload:GetInteger("paymentTerms")       when jsonObjectPayload:has("paymentTerms")
           no-error.

    if  not error-status:error
    and c-logisticsAnalyst <> ?
    and c-incoterm         <> ?
    and i-paymentTerms     <> ?
    then.
    else run pi-cria-erro("Erro na entrada de dados do cabeáalho").

    if temp-table tt-erros-geral:has-records then
      return "NOK".

    for first pedido-compr 
        where pedido-compr.num-pedido = i-purchaseOrder
              no-lock: end.

    if not avail pedido-compr
    then do:
         run pi-cria-erro(substitute("Registro de Pedido n∆o localizado com o c¢digo &1 vindo da integraá∆o", 
                                     quoter(i-purchaseOrder))).
         return "NOK".       
    end.

    if not can-find(first int-prazo-compra use-index ch-ariba where
                          int-prazo-compra.num-pedido = pedido-compr.num-pedido
                          no-lock)
    then do:
         run pi-cria-erro(substitute("Pedido Ariba com o c¢digo &1 n∆o foi criado via integraá∆o", 
                                     quoter(pedido-compr.num-pedido))).
         return "NOK". 
    end.

    for each ordem-compra fields(num-pedido numero-ordem) use-index pedido
       where ordem-compra.num-pedido = pedido-compr.num-pedido
         and ordem-compra.situacao  <> 4:

        if not can-find(first int-ordem-compra where
                              int-ordem-compra.numero-ordem   = ordem-compra.numero-ordem
                          and int-ordem-compra.ind-origem-ext = 2 /* Buying */
                              no-lock)
        then do:
             run pi-cria-erro(substitute("Pedido Ariba com o c¢digo &1 possui OC n∆o criada via integraá∆o Buying, como a &2", 
                                         quoter(ordem-compra.num-pedido),
                                         quoter(ordem-compra.numero-ordem))).
             return "NOK". 
        end.

        create tt-ordem-compra-aux.
        assign tt-ordem-compra-aux.numero-ordem = ordem-compra.numero-ordem.
        find current tt-ordem-compra-aux no-error.
    end. /* for each ordem-compra */

    if pedido-compr.situacao = 3 /* Eliminado */ 
    then do:
         run pi-cria-erro(substitute("Situaá∆o do Pedido &1 (Eliminado) n∆o permite alteraá∆o", 
                                     quoter(pedido-compr.num-pedido))).
         return "NOK".   
    end.

    for first estabelec
        where estabelec.cod-estabel = pedido-compr.cod-estabel
              no-lock: end.

    for first emitente
        where emitente.cod-emitente = pedido-compr.cod-emitente
              no-lock: end.

    for first emitente-cex
        where emitente-cex.cod-emitente = emitente.cod-emitente
              no-lock: end.

    find first mgcad.pais no-lock 
         where mgcad.pais.nome-pais  = emitente.pais no-error.
    
    assign c-cod-fornecedor = string(emitente.cod-emitente)
           c-externalId     = trim(substring(pais.char-1,23,02)) when avail mgcad.pais.
    
    // Fornecedor Estrangeiro
    if emitente.natureza = 3 then 
      assign c-externalId = c-externalId + trim(substring(emitente.char-1,103,30)). // Passaporte.
    else
      assign c-externalId = c-externalId + emitente.cgc.

    assign i-shipper = pedido-compr.cod-transp.

    if  avail emitente-cex
    and emitente-cex.cod-incoterm-imp = c-incoterm
    then assign c-incoterm = "".

    if c-incoterm <> ""
    then do:
         if  c-incoterm           = "CIF"
         and emitente.tp-desp-pad <> 2
         then assign i-shipper = 396.
         else assign i-shipper = emitente.cod-transp.

         for first transporte
             where transporte.cod-transp = i-shipper
                   no-lock: end.
        
         if not avail transporte
        //or i-shipper = 0
         then do:
              run pi-cria-erro(substitute("Transportadora &1 n∆o est† cadastrada", 
                                          quoter(i-shipper))).
              return "NOK".            
         end.

         if transporte.via-transp = 0
         then do:
              run pi-cria-erro(substitute("Via Transp n∆o informada para transportadora &1", 
                                          quoter(transporte.cod-transp))).
              return "NOK".
         end.
    end. /* if c-incoterm <> "" */

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

      assign c-tags     = "".

      create tt-itens.
      assign tt-itens.rateio                = 100
             tt-itens.sequence              = oItem:GetCharacter("sequence")                                                  no-error.
      assign c-tags = c-tags + ",sequence"              when error-status:error or tt-itens.sequence  = "" or tt-itens.sequence = ?
             tt-itens.quantity              = oItem:GetDecimal("quantity")              when oItem:has("quantity")            no-error.
      assign c-tags = c-tags + ",quantity"              when error-status:error or tt-itens.quantity            = ?
             tt-itens.supplierQuantity      = oItem:GetDecimal("supplierQuantity")      when oItem:has("supplierQuantity")    no-error.
      assign c-tags = c-tags + ",supplierQuantity"      when error-status:error or tt-itens.supplierQuantity    = ?
             tt-itens.leadTime                     = oItem:GetInteger("leadTime")            when oItem:has("leadTime")            no-error.
      assign c-tags = c-tags + ",leadTime"              when error-status:ERROR or tt-itens.leadTime    = ?
             tt-itens.unitSupplierMeasure   = oItem:GetCharacter("unitSupplierMeasure") when oItem:has("unitSupplierMeasure") no-error.
      assign c-tags = c-tags + ",unitSupplierMeasure"   when error-status:error or tt-itens.unitSupplierMeasure = ?
             tt-itens.requester             = oItem:GetCharacter("requester")           when oItem:has("requester")           no-error.
      assign c-tags = c-tags + ",requester"             when error-status:error or tt-itens.requester           = ?
             tt-itens.lg-status             = oItem:GetLogical("status")                when oItem:has("status")              no-error.
      assign c-tags = c-tags + ",status"                when error-status:error or tt-itens.lg-status           = ?.

      if oItem:Has("unitPrice")
      then do:
           assign tt-itens.unitPrice = oItem:GetDecimal("unitPrice") no-error.
        
           if error-status:error
           then do:
                assign tt-itens.unitPriceAux = oItem:GetCharacter("unitPrice") no-error.
        
                if  not error-status:error
                and tt-itens.unitPriceAux <> ""
                then assign tt-itens.unitPrice = deci(replace(replace(tt-itens.unitPriceAux,",",""),".",",")) no-error.

                if error-status:error
                then assign c-tags = c-tags + ",unitPrice".
           end. /* if error-status:error */
      end. /* if oItem:Has("unitPrice") */

/*       if  c-leadTime <> ""                                                                           */
/*       and c-leadTime <> ?                                                                            */
/*       then do:                                                                                       */
/*            assign tt-itens.leadTime = OpenEdge.Core.TimeStamp:ToABLDateFromISO(c-leadTime) no-error. */
/*                                                                                                      */
/*            if error-status:error                                                                     */
/*            then assign c-tags = c-tags + ",leadTime".                                                */
/*       end. /* if c-leadTime */                                                                       */

      if c-tags <> ""
      then do:
           run pi-cria-erro("Erro quanto Ö propriedade ou ao tipo de entrada de dados no bloco Itens: " + trim(c-tags,",")).
           leave.
      end.

      if tt-itens.lg-status
      then next.

      if not oItem:has("account")
      then do:
           run pi-cria-erro("Bloco account est† ausente no Json").
           leave.           
      end.
      
      oCcustos = new JsonArray().
      oCcustos = oItem:GetJsonArray("account").

      if not valid-object(oCcustos)
      then do:
           run pi-cria-erro("Erro na leitura do array de CCustos para a sequància " + string(tt-itens.sequence)).
           return "NOK".
      end.

      assign de-tot-rateio = 0.

      do iLoop2 = 1 to oCcustos:length:
        oCcusto = new JsonObject().
        oCcusto = oCcustos:GetJsonObject(iLoop2).

        assign i-ledgerAccount = oCcusto:GetInteger("ledgerAccount")
               c-costCenter    = oCcusto:GetCharacter("costCenter")
               no-error.

        if error-status:error
        then do:
             run pi-cria-erro("Erro no bloco Account").
             leave.
        end.

        if  i-ledgerAccount <> 0
        and i-ledgerAccount <> ?
        and c-costCenter    <> ""
        and c-costCenter    <> ?
        then.
        else next.

        create tt-ccusto.
        assign c-tags                  = ""
               tt-ccusto.r-item        = rowid(tt-itens)
               tt-ccusto.seq           = iLoop2
               tt-ccusto.ledgerAccount = string(i-ledgerAccount, "99999999") no-error.        
        assign c-tags = c-tags + ",ledgerAccount" when error-status:error 
               tt-ccusto.costCenter    = c-costCenter                        no-error.
        assign c-tags = c-tags + ",costCenter"    when error-status:error
               tt-ccusto.apportionment = oCcusto:GetDecimal("apportionment") no-error.
        assign c-tags = c-tags + ",apportionment" when error-status:error.

        if c-tags <> ""
        then do:                                                                              
             run pi-cria-erro("Erro quanto Ö propriedade ou ao tipo de entrada de dados no bloco Account: "+ trim(c-tags,",")).
             leave.
        end.

        /* Validaá∆o apportionment mais de 2 casas decimais */
        dResult = tt-ccusto.apportionment - TRUNCATE(tt-ccusto.apportionment,0).

        IF dResult > 0 THEN DO:
            cResult = STRING(dresult).
            
            cResult = ENTRY(2,cResult,",").
            
            iResult = int(cResult).

            IF iResult > 99 THEN DO:
                run pi-cria-erro("Apportionment com mais de 2 casas decimais. Conta: " + tt-ccusto.ledgerAccount + " CCusto: " + tt-ccusto.costCenter ).
                leave.
            END.
        END.
        /* Fim validaá∆o apportionment */

        if tt-ccusto.apportionment = 0
        then assign tt-ccusto.apportionment = 100.

        if num-entries(tt-ccusto.costCenter, ".") >= 3 then
          assign tt-ccusto.businessUnit = entry(1, tt-ccusto.costCenter, ".")
                 tt-ccusto.centerIDcc   = entry(3, tt-ccusto.costCenter, ".")
                 tt-ccusto.costCenter   = entry(2, tt-ccusto.costCenter, ".").

        assign de-tot-rateio = de-tot-rateio + tt-ccusto.apportionment.
        find current tt-ccusto no-error.
      end. /* do iLoop2 = 1 to oCcustos:length */

      if can-find(first tt-ccusto where
                        tt-ccusto.r-item = rowid(tt-itens))
      then assign tt-itens.rateio = de-tot-rateio.
    end. /* do iLoop = 1 to oItens:length */
  end. /* if valid-object(oItens) */
  find current tt-itens no-error.

  if temp-table tt-erros-geral:has-records then
    return "NOK".

  if temp-table tt-itens:has-records 
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
    delete OBJECT jsonObjectPayload   no-error.
    delete OBJECT oItens              no-error.
    delete OBJECT oCcustos            no-error.
    delete OBJECT oItem               no-error.
    delete OBJECT oCcusto             no-error.
  end.
end procedure.

PROCEDURE pi-update-ped-buying:
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
  empty temp-table tt-desp-cotacao-item.  

  create tt-pedido-compr.
  buffer-copy pedido-compr to tt-pedido-compr
  assign tt-pedido-compr.ind-tipo-movto = 2.

  if i-paymentTerms <> 0
  then assign tt-pedido-compr.cod-cond-pag = i-paymentTerms.

  if c-logisticsAnalyst <> ""
  then assign tt-pedido-compr.responsavel = c-logisticsAnalyst.

  if c-incoterm <> ""
  then assign tt-pedido-compr.cod-transp = transporte.cod-transp
              tt-pedido-compr.via-transp = transporte.via-transp.

  for first cond-especif no-lock
      where cond-especif.num-pedido = pedido-compr.num-pedido:
      create tt-cond-especif.
      buffer-copy cond-especif to tt-cond-especif
          assign tt-cond-especif.ind-tipo-movto = 2.
      find current tt-cond-especif no-error.
  end.

  for each tt-itens:
    if can-find(first b-tt-itens where
                      b-tt-itens.sequence = tt-itens.sequence
                  and rowid(b-tt-itens)  <> rowid(tt-itens))
    then do:
         run pi-cria-erro("Sequància " + tt-itens.sequence + " repetida no Pedido" ).
         return "NOK".
    end.

    for first int-prazo-compra use-index ch-ariba
        where int-prazo-compra.num-pedido = pedido-compr.num-pedido
          and int-prazo-compra.seq-ariba  = tt-itens.sequence
              no-lock: end.

    if not avail int-prazo-compra
    then do:
         run pi-cria-erro("Sequància " + tt-itens.sequence + " n∆o identificada no Pedido " + string(pedido-compr.num-pedido)).
         return "NOK".
    end.

    if not can-find(first prazo-compra where 
                          prazo-compra.numero-ordem = int-prazo-compra.numero-ordem
                      and prazo-compra.parcela      = int-prazo-compra.parcela
                          no-lock)
    then do:
         run pi-cria-erro("Inconsistància sequància " + tt-itens.sequence + " no Pedido " + string(pedido-compr.num-pedido)).
         return "NOK".
    end.

    for first ordem-compra
        where ordem-compra.numero-ordem = int-prazo-compra.numero-ordem
              no-lock: end.

    if not can-find(first int-ordem-compra where 
                          int-ordem-compra.numero-ordem   = ordem-compra.numero-ordem
                      and int-ordem-compra.ind-origem-ext = 2 /* Buying */
                          no-lock)
    then do:
         run pi-cria-erro(substitute("Sequància Ariba &1 para o Pedido &2 n∆o foi criada via integraá∆o", 
                                     quoter(tt-itens.sequence),
                                     quoter(pedido-compr.num-pedido))).
         return "NOK". 
    end.

    if ordem-compra.num-pedido <> pedido-compr.num-pedido
    then do:
         run pi-cria-erro(substitute("OC &1 n∆o mais corresponde ao pedido &2", 
                                     quoter(ordem-compra.numero-ordem),
                                     quoter(pedido-compr.num-pedido))).
         return "NOK". 
    end.

    find prazo-compra where
         prazo-compra.numero-ordem = ordem-compra.numero-ordem
         no-lock no-error.

    if not avail prazo-compra /* mais de uma parcela */
    then do:
         run pi-cria-erro(substitute("H† mais de uma parcela para a OC &1, Pedido &2", 
                                     quoter(ordem-compra.numero-ordem),
                                     quoter(pedido-compr.num-pedido))).
         return "NOK".          
    end.

    for first prazo-compra
        where prazo-compra.numero-ordem = int-prazo-compra.numero-ordem
          and prazo-compra.parcela      = int-prazo-compra.parcela
              no-lock: end.

    for first tt-ordem-compra-aux
        where tt-ordem-compra-aux.numero-ordem = ordem-compra.numero-ordem: end.

    if tt-itens.lg-status
    then do:
         if ordem-compra.situacao = 4 /* Eliminada */
         then do: 
              if avail tt-ordem-compra-aux
              then delete tt-ordem-compra-aux.
              next.
         end.

         if  ordem-compra.situacao  > 2
         and ordem-compra.situacao <> 5 
         then do:
              run pi-cria-erro(substitute("Situaá∆o da OC &1 - Sequància &2 - n∆o permite eliminaá∆o", 
                                                        quoter(ordem-compra.numero-ordem),
                                                        quoter(tt-itens.sequence))).

              return "NOK".
         end.

         if ordem-compra.nr-contrato <> 0 
         then do:
              run pi-cria-erro(substitute("Ordem de Compra &1 - Sequància &2 - possui N£mero Contrato", 
                                                        quoter(ordem-compra.numero-ordem),
                                                        quoter(tt-itens.sequence))).

              return "NOK".
         end. /* if ordem-compra.nr-contrato <> 0 */

         if  param-global.modulo-in 
         and ordem-compra.num-ord-inv <> 0 
         then do:
              run pi-cria-erro(substitute("Ordem de Compra &1 - Sequància &2 - possui relacionamento com Ordem Investimento", 
                                                        quoter(ordem-compra.numero-ordem),
                                                        quoter(tt-itens.sequence))).

              return "NOK".
         end.
    end. /* if tt-itens.lg-status */

    if  ordem-compra.situacao < 3
    and prazo-compra.situacao < 3
    then.
    else do:
         run pi-cria-erro(substitute("Situaá∆o da OC &1 - Sequància &2 - n∆o permite alteraá∆o", 
                                     quoter(ordem-compra.numero-ordem),
                                     quoter(tt-itens.sequence))).
         return "NOK".    
    end.

    for first item 
        where item.it-codigo = ordem-compra.it-codigo
              no-lock: end.

    RUN pi-valida-alter.
    IF RETURN-VALUE <> "OK"
    THEN DO:
         run pi-cria-erro(substitute("OC &1 - Sequància &2 - possui embarque com situaá∆o que n∆o permite alteraá∆o", 
                                     quoter(ordem-compra.numero-ordem),
                                     quoter(tt-itens.sequence))).
         return "NOK".   
    END.

    if avail tt-ordem-compra-aux
    then delete tt-ordem-compra-aux.

    assign tt-itens.tipo-contr = item.tipo-contr.

    for first item-uni-estab
        where item-uni-estab.it-codigo   = item.it-codigo
          and item-uni-estab.cod-estabel = estabelec.cod-estabel
              no-lock: end.

    /* Refina Centros de Custo */
    for each tt-ccusto
       where tt-ccusto.r-item = rowid(tt-itens):
        release b-estabelec.

        if tt-ccusto.centerIDcc <> ""
        then for first b-estabelec
                 where b-estabelec.cod-estabel = tt-ccusto.centerIDcc
                       no-lock: end.

        if not avail b-estabelec
        then do:
             run pi-cria-erro("Estabelecimento para Centro Custo " + tt-ccusto.costCenter + " Ç inv†lido" ).
             return "NOK".
        end.

        if not valid-handle(h_api_cta_ctbl) then
          run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  b-estabelec.ep-codigo,   /* EMPRESA EMS2 */
                                                        input  b-estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                        input  "",                      /* UNIDADE NEG‡CIO */
                                                        input  "",                      /* PLANO CONTAS */ 
                                                        input  tt-ccusto.ledgerAccount, /* CONTA */
                                                        input  "",                      /* PLANO CCUSTO */ 
                                                        input  tt-ccusto.costCenter,    /* CCUSTO */
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
          run prgint/utb/utb742za.py persistent set h_api_ccusto.
        
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  b-estabelec.ep-codigo,   /* EMPRESA EMS 2 */
                                                           input  b-estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "",                      /* PLANO CONTAS */
                                                           input  tt-ccusto.ledgerAccount, /* CONTA */
                                                           input  today,                   /* DT TRANSACAO */
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
          assign tt-ccusto.costCenter = "".

        if tt-ccusto.apportionment <= 0
        then do:
             run pi-cria-erro("Apportionment n∆o pode estar zerado. ID " + item.it-codigo).
             return "NOK".
        end.

        if not can-find(first unid-negoc where
                              unid-negoc.cod-unid-negoc = tt-ccusto.businessUnit
                              no-lock)
        then do:
             run pi-cria-erro("Unidade Neg¢cio n∆o informada ou n∆o cadastrada para ID " + item.it-codigo + ", " + tt-ccusto.ledgerAccount + "/" + tt-ccusto.costCenter).
             return "NOK".
        end.
    end. /* for each tt-ccusto */
    /*
    /* Revalida Centros de Custo */
    for each tt-ccusto
       where tt-ccusto.r-item = rowid(tt-itens):
        if not can-find(first b-tt-ccusto where
                              b-tt-ccusto.r-item        = rowid(tt-itens)
                          and b-tt-ccusto.ledgerAccount = tt-ccusto.ledgerAccount
                          and b-tt-ccusto.costCenter    = tt-ccusto.costCenter
                          and rowid(b-tt-ccusto)       <> rowid(tt-ccusto))
        then next.

        run pi-cria-erro("Conta/Centro de Custo repetido na OC. ID " + item.it-codigo).
        return "NOK".        
    end.
    */

    if absolute(tt-itens.rateio - 100) > 0.01
    then do:
         run pi-cria-erro("Total do rateio para a OC deve ser de 100. ID " + item.it-codigo).
         return "NOK".
    end.

    for first tt-ccusto use-index id2
        where tt-ccusto.r-item = rowid(tt-itens): end.

    create tt-ordem-compra.
    buffer-copy ordem-compra to tt-ordem-compra
    assign tt-itens.numero-ordem          = ordem-compra.numero-ordem
           tt-ordem-compra.l-split        = false
           tt-ordem-compra.ind-tipo-movto = 2
           tt-ordem-compra.data-atualiz   = today
           tt-ordem-compra.hora-atualiz   = string(time,"hh:mm:ss").

    if tt-itens.lg-status
    then do:
         run pi-elimina-oc.

         if return-value <> "OK"
         then return "NOK".

         assign tt-ordem-compra.situacao = 4. /* Eliminada */
    end. /* if tt-itens.lg-status */
    else do:
         if avail tt-ccusto
         then do:
              assign tt-ordem-compra.ct-codigo      = tt-ccusto.ledgerAccount
                     tt-ordem-compra.sc-codigo      = tt-ccusto.costCenter
                     tt-ordem-compra.conta-contabil = tt-ordem-compra.ct-codigo + tt-ordem-compra.sc-codigo.
        
              if tt-ccusto.businessUnit <> ""
              then assign tt-ordem-compra.cod-unid-negoc = tt-ccusto.businessUnit.
         end. /* if avail tt-ccusto */
        
         if c-logisticsAnalyst <> ""
         then assign tt-ordem-compra.cod-comprado = tt-pedido-compr.responsavel.
        
         if i-paymentTerms <> 0
         then assign tt-ordem-compra.cod-cond-pag = tt-pedido-compr.cod-cond-pag.
        
         if tt-itens.quantity <> 0
         then assign tt-ordem-compra.qt-solic = tt-itens.quantity.
        
         if tt-itens.unitPrice <> 0
         then assign tt-ordem-compra.preco-fornec   = tt-itens.unitPrice
                     tt-ordem-compra.preco-unit     = tt-itens.unitPrice
                     tt-ordem-compra.preco-orig     = tt-itens.unitPrice
                     tt-ordem-compra.pre-unit-for   = tt-itens.unitPrice.
        
         if tt-itens.requester <> ""
         then assign tt-ordem-compra.requisitante = tt-itens.requester.
        
         if c-incoterm <> ""
         then assign tt-ordem-compra.frete      = not (c-incoterm <> "CIF" and
                                                       c-incoterm <> "CFR" and
                                                       c-incoterm <> "CPT" and
                                                       c-incoterm <> "CIP" and
                                                       c-incoterm <> "DPU" and
                                                       c-incoterm <> "DAP" and
                                                       c-incoterm <> "DDP")
                     tt-ordem-compra.cod-transp = transporte.cod-transp.
    end. /* else do */

    create tt-prazo-compra.
    buffer-copy prazo-compra to tt-prazo-compra
    assign tt-prazo-compra.ind-tipo-movto = 2
           tt-itens.parcela               = prazo-compra.parcela.

    if tt-itens.lg-status
    then do:
         assign tt-prazo-compra.situacao = 4.
         find current tt-prazo-compra.
         next.
    end. /* if tt-itens.lg-status */

    if tt-itens.quantity <> 0
    then assign tt-prazo-compra.quantidade   = tt-itens.quantity
                tt-prazo-compra.quantid-orig = tt-itens.quantity
                tt-prazo-compra.quant-saldo  = tt-itens.quantity
                tt-prazo-compra.qtd-do-forn  = tt-itens.quantity
                tt-prazo-compra.qtd-sal-forn = tt-itens.quantity.

    if tt-itens.supplierQuantity <> 0
    then assign tt-prazo-compra.qtd-sal-forn = tt-itens.supplierQuantity.

/*     if  pedido-compr.natureza <> 2                                       */
/*     and tt-itens.leadTime     <> 0                                       */
/*     then assign tt-prazo-compra.data-entrega = TODAY + tt-itens.leadTime */
/*                //tt-prazo-compra.data-orig    = tt-itens.leadTime        */
        .

    //Criar Cotacao
    for each cotacao-item no-lock
       where cotacao-item.numero-ordem = ordem-compra.numero-ordem
         and cotacao-item.cod-emitente = pedido-compr.cod-emitente
         and cotacao-item.it-codigo    = item.it-codigo:
        create tt-cotacao-item.
        buffer-copy cotacao-item to tt-cotacao-item
            assign tt-cotacao-item.ind-tipo-movto = 2
                   tt-cotacao-item.un             = if tt-itens.unitSupplierMeasure <> "" 
                                                    then tt-itens.unitSupplierMeasure 
                                                    else cotacao-item.un
                   tt-cotacao-item.preco-fornec   = tt-itens.unitPrice
                   tt-cotacao-item.preco-unit     = tt-itens.unitPrice                   
                   tt-cotacao-item.pre-unit-for   = tt-itens.unitPrice.

        if c-incoterm <> ""
        then assign tt-cotacao-item.cod-incoterm = c-incoterm
                    tt-cotacao-item.frete        = not (c-incoterm <> "CIF" and
                                                        c-incoterm <> "CFR" and
                                                        c-incoterm <> "CPT" and
                                                        c-incoterm <> "CIP" and
                                                        c-incoterm <> "DPU" and
                                                        c-incoterm <> "DAP" and
                                                        c-incoterm <> "DDP").

        for each desp-cotacao-item no-lock
           where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
             and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
             and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
             and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac:
            create tt-desp-cotacao-item.
            buffer-copy desp-cotacao-item to tt-desp-cotacao-item
                assign tt-desp-cotacao-item.ind-tipo-movto = 2.
            find current tt-desp-cotacao-item no-error.
        end. /* for each desp-cotacao-item */

        find current tt-cotacao-item no-error.
    end. /* for each cotacao-item */
    find current tt-ordem-compra no-error.
    find current tt-prazo-compra no-error.
  end.
  find current tt-pedido-compr no-error.

  if temp-table tt-ordem-compra-aux:has-records
  then do:
       run pi-cria-erro(substitute("Sequàncias ativas do Pedido Ariba com o c¢digo &1 n∆o foram todas informadas na integraá∆o", 
                                   quoter(pedido-compr.num-pedido))).
       return "NOK".        
  end.

  if not temp-table tt-ordem-compra:has-records
  then do:
       run pi-cria-erro(substitute("Sem OCs para alterar/eliminar no Pedido Ariba com o c¢digo &1", 
                                    quoter(pedido-compr.num-pedido))).
       return "NOK".  
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
          overlay(cotacao-item.char-1,21,20) = trim(string(tt-cotacao-item.cod-incoterm)).
          assign cotacao-item.cod-incoterm   = tt-cotacao-item.cod-incoterm.
      end. /* for first cotacao-item */
      find current cotacao-item no-lock no-error.
  end. /* for each tt-cotacao-item */

  if temp-table tt-erros-geral:has-records 
  then return "NOK".  

  for each tt-ordem-compra:
      for first tt-itens
          where tt-itens.numero-ordem = tt-ordem-compra.numero-ordem: end.           

      if can-find(first tt-ccusto where
                        tt-ccusto.r-item = rowid(tt-itens)) then do:
          for each matriz-rat-ordem exclusive-lock
              where matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem:                            

               delete matriz-rat-ordem.
          end. /* for each matriz-rat-ordem */
      END.

      if tt-itens.tipo-contr = 4 /* DÇbito Direto */
      then for each tt-ccusto
              where tt-ccusto.r-item = rowid(tt-itens):           

               FIND FIRST matriz-rat-ordem EXCLUSIVE-LOCK
                   WHERE matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                     AND matriz-rat-ordem.ct-codigo    = tt-ccusto.ledgerAccount
                     AND matriz-rat-ordem.sc-codigo    = tt-ccusto.costCenter NO-ERROR.
               IF NOT AVAIL matriz-rat-ordem THEN DO:

                   create matriz-rat-ordem.
                   assign matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                          matriz-rat-ordem.sc-codigo    = tt-ccusto.costCenter
                          matriz-rat-ordem.ct-codigo    = tt-ccusto.ledgerAccount                          
                          matriz-rat-ordem.char-1       = ""
                          overlay(matriz-rat-ordem.char-2,1,3) = tt-ccusto.businessUnit.
               END.

               ASSIGN matriz-rat-ordem.perc-rateio = matriz-rat-ordem.perc-rateio + tt-ccusto.apportionment.

               find current matriz-rat-ordem no-lock no-error.
           end. /* for each tt-ccusto */
  end. /* for each tt-ordem-compra */  

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
    delete procedure h_api_cta_ctbl no-error.
    delete procedure h_api_ccusto   no-error.
  end.
end.

procedure pi-cria-erro:
  define input parameter p-des-erro as character no-undo.
  log-manager:write-message(p-des-erro, "ARIBA").
  create tt-erros-geral.
  assign tt-erros-geral.cod-erro = 17006
         tt-erros-geral.des-erro = p-des-erro.
  return "OK".
end procedure.

PROCEDURE pi-valida-alter:
    DEF BUFFER b-prazo-compra FOR prazo-compra.

    if can-find(first b-prazo-compra where
                      b-prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  and b-prazo-compra.situacao     = 6 /* Recebida */
                      no-lock)
    then RETURN "NOK".

    for each b-prazo-compra no-lock
       where b-prazo-compra.numero-ordem = ordem-compra.numero-ordem
         and b-prazo-compra.situacao    <> 4:
        empty temp-table tt-emb.
    
        for first ordens-embarque use-index ordem
            where ordens-embarque.numero-ordem = b-prazo-compra.numero-ordem
              and ordens-embarque.parcela      = b-prazo-compra.parcela
                  no-lock: end.
    
        if avail ordens-embarque
        then run pi-busca-posicao.
        
        for first tt-emb: end.
    
        if  avail tt-emb
        and tt-emb.situacao <> 99 /*AGT*/
        and tt-emb.situacao <> 96 /*INST*/
        and tt-emb.situacao <> 97 /*MANUT*/
        and tt-emb.situacao <> 1  /*PREV*/
        then RETURN "NOK".
    end. /* for each b-prazo-compra */

    RETURN "OK".
END PROCEDURE. /* procedure pi-valida-alter */

PROCEDURE pi-busca-posicao :
    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1 /* N∆o Encerrado */
        AND   embarque-imp.cod-estabel = ordens-embarque.cod-estabel
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}   
        
    END. /* FOR EACH  embarque-imp NO-LOCK */
END PROCEDURE.

procedure pi-elimina-oc:
    DEFINE VARIABLE l-portal-paradigma  AS LOG INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-importacao        AS LOG INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-motivo-retorno    AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE h-boin356vl         AS HANDLE         NO-UNDO.
    DEFINE VARIABLE h-boin274           AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hDBOOrdens-embarque AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hDBOProcesso-imp    AS HANDLE         NO-UNDO.
    define variable c-return            AS CHAR           NO-UNDO.

    IF AVAIL param-global 
    THEN ASSIGN l-importacao = param-global.modulo-07.

    IF l-importacao 
    THEN DO:
         IF  pedido-compr.situacao = 1 /* Impresso */
         AND NOT CAN-FIND(FIRST b-ordem-compra
                          WHERE b-ordem-compra.num-pedido    = pedido-compr.num-pedido
                            AND b-ordem-compra.numero-ordem <> ordem-compra.numero-ordem
                            AND b-ordem-compra.situacao     <> 4
                                no-lock) 
         THEN DO:        
              RUN cxbo/bocx140na.p PERSISTENT SET hDBOProcesso-imp.
              RUN openQueryStatic IN hDBOProcesso-imp (INPUT "Main":U).
              
              RUN goToPedido IN hDBOProcesso-imp (INPUT pedido-compr.num-pedido).
              
              IF VALID-HANDLE(hDBOProcesso-imp) 
              THEN DO:
                   DELETE PROCEDURE hDBOProcesso-imp no-error.
                   assign hDBOProcesso-imp = ?.
              END.
              
              IF RETURN-VALUE = "OK" 
              OR RETURN-VALUE = "" 
              THEN DO:
                  {utp/ut-table.i movind pedido-compr 1}
                  ASSIGN c-return = TRIM(RETURN-VALUE).
                  {utp/ut-table.i mgcex processo-imp 1}
                  run pi-cria-erro(c-return + " possui relacionamentos ativos com " + TRIM(RETURN-VALUE)).
                  return "NOK".
              END.
         END.
        
         RUN cxbo/bocx225na.p PERSISTENT SET hDBOOrdens-embarque.
         RUN openQueryStatic IN hDBOordens-embarque (INPUT "Main":U).
         RUN goToOrdemcompra IN hDBOOrdens-embarque (INPUT ordem-compra.numero-ordem).
         IF VALID-HANDLE(hDBOOrdens-embarque) 
         THEN DO:
              DELETE PROCEDURE hDBOOrdens-embarque no-error.
              assign hDBOOrdens-embarque = ?.
         END.
        
         IF RETURN-VALUE = "OK" 
         OR RETURN-VALUE = "" 
         THEN DO:
              {utp/ut-table.i movind ordem-compra 1}
              ASSIGN c-return = TRIM(RETURN-VALUE).
              {utp/ut-table.i mgcex ordens-embarque 1}
              run pi-cria-erro(c-return + " possui relacionamentos ativos com " + TRIM(RETURN-VALUE)).
              return "NOK".

/*               empty temp-table RowErrors.                                                      */
/*               RUN pi-desvincula-oc.                                                            */
/*                                                                                                */
/*               if return-value <> "OK"                                                          */
/*               then do:                                                                         */
/*                    if temp-table RowErrors:has-records                                         */
/*                    then for each RowErrors:                                                    */
/*                           create tt-erros-geral.                                               */
/*                           assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber               */
/*                                  tt-erros-geral.des-erro = RowErrors.ErrorDescription.         */
/*                         end.                                                                   */
/*                    else run pi-cria-erro(substitute("Erro no processo de eliminaáao da OC &1", */
/*                                                     quoter(ordem-compra.numero-ordem))).       */
/*                                                                                                */
/*                    return "NOK".                                                               */
/*               end.                                                                             */
         END.            
    END. /* if l-importacao */


    RUN inbo/boin274vl.p PERSISTENT SET h-boin274.

    /* eliminaOrdensPedidoOrdemCompra */
    RUN eliminaOrdensCompraComMultiPlanta IN h-boin274 (INPUT ROWID(ordem-compra),
                                                        INPUT "", /* usuˇrio do sistema */
                                                        INPUT "Ariba",
                                                        INPUT YES).

    IF VALID-HANDLE(h-boin274) 
    THEN DO:
         DELETE PROCEDURE h-boin274 no-error.
         assign h-boin274 = ?.
    END.

    RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.

    /***Atualiza Situacao do Processo de Importacao***/
    RUN atualizaSituacaoProcessoImportacao IN h-boin356vl (INPUT pedido-compr.num-pedido,
                                                           INPUT pedido-compr.cod-emitente,
                                                           INPUT pedido-compr.cod-estabel).

    /***Fim***/
    IF VALID-HANDLE(h-boin356vl) 
    THEN DO:
         DELETE PROCEDURE h-boin356vl no-error.
         assign h-boin356vl = ?.
    END.

    return "OK".
end procedure. /* pi-elimina-oc */

procedure pi-desvincula-oc:
    def var h-bocx404    as handle no-undo.
    DEF VAR h-bocx225    as handle no-undo.
    def var r-rw-aux     as rowid  no-undo.
    def var l-integra-di as logi   no-undo.
    def var p-mensagem   as char   no-undo.
    def var c-embarque   as char   no-undo.

    run cxbo/bocx225.p persistent set h-bocx225.
    run cxbo/bocx404.p persistent set h-bocx404.
    run openQueryStatic in h-bocx404(input "Main":U).

    blk-desv:
    do transaction on error undo, return "NOK":
        for each ordens-embarque exclusive-lock
           where ordens-embarque.numero-ordem = ordem-compra.numero-ordem:

            assign r-rw-aux   = rowid(ordens-embarque)
                   c-embarque = ordens-embarque.embarque.

            run validateEliminacaoOrdem in h-bocx225 (input  pedido-compr.cod-estabel,
                                                      input  ordens-embarque.embarque,
                                                      output p-mensagem).

            if p-mensagem <> ""
            then do:
                 create RowErrors.
                 assign RowErrors.errorsequence    = 0
                        RowErrors.errornumber      = 0
                        RowErrors.errordescription = c-embarque + " possui relacionamentos ativos com " + p-mensagem
                        RowErrors.errortype        = "error"
                        RowErrors.errorhelp        = RowErrors.errordescription.
                 find current RowErrors no-error.

                 undo blk-desv, return "NOK".
            end. /* if p-mensagem <> "" */

            run validateDelete in h-bocx225 (input-output r-rw-aux, 
                                             output table RowErrors).

            if temp-table RowErrors:has-records
            then undo blk-desv, return "NOK".
        end. /* for each ordens-embarque */

        for each prazo-compra no-lock
           where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            if not can-find(first ordens-embarque where
                                  ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                              and ordens-embarque.parcela      = prazo-compra.parcela
                                  no-lock)
            then next.

            run verificaIntegraDI in h-bocx404(input  prazo-compra.numero-ordem, 
                                               input  prazo-compra.parcela, 
                                               output l-integra-di).

            if not l-integra-di
            then next.

            run desvinculaOrdem in h-bocx404 (input prazo-compra.numero-ordem, 
                                              input prazo-compra.parcela).
        end. /* for each prazo-compra */

        if can-find(first ordens-embarque where
                          ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                      and ordens-embarque.parcela      = prazo-compra.parcela
                          no-lock)
        then do:
             create RowErrors.
             assign RowErrors.errorsequence    = 0
                    RowErrors.errornumber      = 0
                    RowErrors.errordescription = "Impossibilitada desvinculaá∆o entre Ordem e Embarque."
                    RowErrors.errortype        = "error"
                    RowErrors.errorhelp        = "Impossibilitada desvinculaá∆o entre Ordem e Embarque.".
             find current RowErrors no-error.

             undo blk-desv, return "NOK".         
        end.
    end. /* do transaction */

    return "OK".

    finally:
        if valid-handle(h-bocx404)
        then delete procedure h-bocx404 no-error.
        if valid-handle(h-bocx225)
        then delete procedure h-bocx225 no-error.
    end.
end procedure. /* procedure pi-desvincula-oc */

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

