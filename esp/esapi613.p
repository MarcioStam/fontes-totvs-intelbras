block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi613.i}
{esp/ccp/esccp055r.i}
{utp/ut-glob.i}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE tt-ordem-compra-all NO-UNDO
    LIKE tt-ordem-compra.

DEF TEMP-TABLE tt-matriz-rat-med-aux NO-UNDO LIKE matriz-rat-med.
DEF TEMP-TABLE tt-matriz-rat-med     NO-UNDO LIKE matriz-rat-med
    FIELD cod-maq-origem    AS  INTEGER FORMAT "999"       INITIAL 0
    FIELD num-processo      AS  INTEGER FORMAT ">>>>>>>>9" INITIAL 0
    FIELD num-sequencia     AS  INTEGER FORMAT ">>>>>9"    INITIAL 0
    FIELD ind-tipo-movto    AS  INTEGER FORMAT "99"        INITIAL 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define new global shared var l-esapi556 as logical no-undo.

DEF NEW GLOBAL SHARED VAR v-rw-es-api-log AS ROWID NO-UNDO.

define variable cMetodo          as character         no-undo.
define variable jsonObjectOutput as JsonObject        no-undo.
define variable jsonOutput       as JsonObject        no-undo.
define variable oErrors          as JsonArray         no-undo.
define variable oError           as JsonObject        no-undo.
define variable i-num-pedido     as integer           no-undo.
define variable c-cod-fornecedor as character         no-undo.
define variable c-externalId     as character         no-undo.
define variable lcInput          as longchar          no-undo.
define variable lcOutput         as longchar          no-undo.
define variable jsonParser       as ObjectModelParser no-undo.
define variable jsonInput        as JsonObject        no-undo.
define variable iNumMessages     as integer           no-undo.
define variable i-cod-mensagem   as integer           no-undo.
define variable i-aux            as integer           no-undo.
define variable i-codigo-icm     as integer           no-undo.
define variable i-tp-pedido      as integer           no-undo. 
define variable i-itinerary      as integer           no-undo.
define variable c-tags           as character         no-undo.
            
def var hboin082ca           as handle no-undo.
def var c-centerID           as char no-undo.
def var c-buyer              as char no-undo.
def var c-incoterm           as char no-undo.
def var c-logisticsAnalyst   as char no-undo.
def var c-costCenter         as char no-undo.
def var c-demandType         as char no-undo.
def var c-natureOrder        as char no-undo.
def var i-ledgerAccount      as inte no-undo.
def var i-shipper            as inte no-undo.
def var i-supplierID         as inte no-undo.
def var i-supplierExternalId as CHAR no-undo.
def var i-paymentTerms       as inte no-undo.

define variable c-via-transp as character init "Rodovi†rio,Aerovi†rio,Mar°timo,Ferrovi†rio,Rodoferrovi†rio,Rodofluvial,Rodoaerovi†rio,Outros" no-undo.

define temp-table auxRowErrors no-undo like RowErrors.

def buffer b-tt-itens  for tt-itens.
def buffer b-tt-ccusto for tt-ccusto.
def buffer b-estabelec for estabelec.
DEF BUFFER b-es-api-log FOR es-api-log.


function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetInteger   returns integer   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetDecimal   returns decimal   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetPais      returns integer   () forwards.

{esp/esapi505x.i &OPC="OPEN"}

/* ***************************  Main Block  *************************** */
for first es-api-log NO-LOCK
    where rowid(es-api-log) = rw-registro,
    first es-api-uri       no-lock
       of es-api-log,
    first es-api-empresa   no-lock
       of es-api-log,
    first es-api-aplicacao no-lock
       of es-api-log
       by es-api-log.flg-processado
       by es-api-log.dh-request:

    v-rw-es-api-log     = rw-registro.

    FIND FIRST b-es-api-log EXCLUSIVE-LOCK
         WHERE rowid(b-es-api-log) = rw-registro NO-ERROR.
    IF AVAIL b-es-api-log THEN DO:  
        assign b-es-api-log.dh-envio = NOW.               

        RELEASE b-es-api-log NO-ERROR.
    END.

    copy-lob es-api-log.cl-envio to lcInput.
    
    assign jsonParser = NEW ObjectModelParser()
           jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).
    
    if valid-handle(h-acomp) then 
      run pi-acompanhar in h-acomp ("Pedido de Compra").
    
    run pi-input-api-headers (jsonInput).
    
    run pi-carga-json.  
    
    if return-value = "OK"
    then RUN pi-principal.
    
    /* Tratamento do Retorno */
    jsonOutput       = new JsonObject().
    jsonObjectOutput = new JsonObject().
    
    FIND FIRST b-es-api-log EXCLUSIVE-LOCK
         WHERE rowid(b-es-api-log) = rw-registro NO-ERROR.
    IF AVAIL b-es-api-log THEN DO:  

        assign b-es-api-log.retorno-content-type = "application/json".

        RELEASE b-es-api-log.
    END.
    if not can-find(first tt-erros-geral) then do:
      jsonObjectOutput:add("externalId",   c-externalId). 
      jsonObjectOutput:add("customerCode", c-cod-fornecedor). 
      jsonObjectOutput:add("purchasingId", string(i-num-pedido)). 
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

    FIND FIRST b-es-api-log EXCLUSIVE-LOCK
         WHERE rowid(b-es-api-log) = rw-registro NO-ERROR.
    IF AVAIL b-es-api-log THEN DO:  
        copy-lob lcOutput to b-es-api-log.cl-retorno.
        RELEASE b-es-api-log.
    END.
    
    if not temp-table tt-erros-geral:has-records then do:

        FIND FIRST b-es-api-log EXCLUSIVE-LOCK
             WHERE rowid(b-es-api-log) = rw-registro NO-ERROR.
        IF AVAIL b-es-api-log THEN DO:  
            assign b-es-api-log.cod-retorno = "200"
                   b-es-api-log.aux         = "Pedido de Venda " + string(i-num-pedido) + " criado(s) com sucesso".

            RELEASE b-es-api-log.
        END.
        
        /* TESTE - Trocar pelo tipo de sistema */
        IF (c-natureOrder <> "servico")
        THEN DO:
            run pi-back-integration.
        END.
    end.
    else do:
        FIND FIRST b-es-api-log EXCLUSIVE-LOCK
         WHERE rowid(b-es-api-log) = rw-registro NO-ERROR.
        IF AVAIL b-es-api-log THEN DO:  
            assign b-es-api-log.cod-retorno = "500".

            RELEASE b-es-api-log.
        END.
    end.

    empty temp-table tt-erros-geral.    
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

    run pi-create-ped-buying.
    
    if return-value <> "OK" 
    then UNDO, RETURN "NOK".

    RETURN "OK".
END PROCEDURE. /* procedure pi-principal */

procedure pi-carga-json :
  define variable jsonObjectPayload   as JsonObject no-undo.
  define variable jsonArrayPathParams as JsonArray  no-undo.
  define variable oItens              as JsonArray  no-undo.
  define variable oCcustos            as JsonArray  no-undo.
  define variable oItem               as JsonObject no-undo.
  define variable oCcusto             as JsonObject no-undo.
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
  define variable de-tot-rateio       as decimal    no-undo.

  DEFINE VARIABLE iResult             AS INTEGER     NO-UNDO.
  DEFINE VARIABLE dResult             AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE cResult             AS CHARACTER   NO-UNDO.

  release estabelec.
  release emitente.
  release emitente-cex.

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload")
         cMetodo           = jsonInput:GetCharacter("method")
         c-tags            = "".

  if valid-object(jsonObjectPayload) then do:
    assign c-centerID         = fcGetCharacter("centerID",    jsonObjectPayload)
           c-buyer            = fcGetCharacter("buyer",       jsonObjectPayload)
           c-demandType       = fcGetCharacter("demandType",  jsonObjectPayload)
           no-error.
           
    ASSIGN i-supplierID         = fcGetInteger("supplierID",    jsonObjectPayload) when jsonObjectPayload:Has("supplierID") no-error.
    ASSIGN i-supplierExternalId = fcGetCharacter("externalId",  jsonObjectPayload) when jsonObjectPayload:Has("externalId") no-error.
    ASSIGN c-natureOrder        = fcGetCharacter("natureOrder", jsonObjectPayload) when jsonObjectPayload:Has("natureOrder") no-error.
                                                            
    assign i-paymentTerms     = jsonObjectPayload:GetInteger("paymentTerms")       when jsonObjectPayload:Has("paymentTerms")     no-error.
    assign c-tags             = c-tags + ",paymentTerms"     when error-status:error
           i-shipper          = jsonObjectPayload:GetInteger("shipper")            when jsonObjectPayload:Has("shipper")          no-error.
    assign c-tags             = c-tags + ",shipper"          when error-status:error
           c-incoterm         = jsonObjectPayload:GetCharacter("incoterm")         when jsonObjectPayload:Has("incoterm")         no-error.
    assign c-tags             = c-tags + ",incoterm"         when error-status:error
           c-logisticsAnalyst = jsonObjectPayload:GetCharacter("logisticsAnalyst") when jsonObjectPayload:Has("logisticsAnalyst") no-error.
    assign c-tags             = c-tags + ",logisticsAnalyst" when error-status:error.

    if c-tags <> ""
    then run pi-cria-erro("Erro entrada de dados do cabeáalho: " + trim(c-tags,",")).

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

    /* Regras para identificar qual o fornecedor, podendo ser por c¢digo ou for id externo */
    IF (i-supplierID > 0)
    THEN DO:
        FIND FIRST emitente
        WHERE emitente.cod-emitente = i-supplierID NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST emitente
        WHERE emitente.cgc = SUBSTR(i-supplierExternalId, 3, 15) NO-LOCK NO-ERROR.
    END.

    if not avail emitente
    then do:
         IF (i-supplierID > 0) THEN
            run pi-cria-erro(substitute("Registro de Fornecedor n∆o localizado com o c¢digo &1 vindo da integraá∆o", 
                                         quoter(i-supplierID))).
         ELSE
            run pi-cria-erro(substitute("Registro de Fornecedor n∆o localizado com o c¢digo externo &1 vindo da integraá∆o", 
                                         quoter(i-supplierExternalId))).
         return "NOK".
    end.

    if emitente.identific = 1
    then do:
         run pi-cria-erro(substitute("Emitente com o c¢digo &1 est† cadastrado como cliente, n∆o fornecedor", 
                                     quoter(emitente.cod-emitente))).
         return "NOK".
    end.

    IF (i-supplierID = 0)
    THEN DO:
        ASSIGN i-supplierID = emitente.cod-emitente.
    END.

    /* Regra alterada conforme solicitaá∆o - 21/10 */
    if emitente.tp-desp-pad = 2 /* Internacional */
    then assign i-cod-mensagem = 136.
    else assign i-cod-mensagem = 135.
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

    /* Controle de Servico */
    IF (c-natureOrder = "servico")
    THEN DO:
        assign i-cod-mensagem = 1.
    END.

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

    if i-paymentTerms = 0
    then assign i-paymentTerms = emitente.cod-cond-pag.

    assign i-codigo-icm = 0
           i-tp-pedido  = 0.

    if c-demandType = "Oráamento"
    then assign c-demandType = "Compra Normal".

    if c-demandType <> ""
    then FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
             WHERE ponto-programa.nome-programa = "cc0300a"
               AND ponto-programa.ponto         = 1
               AND ponto-programa.tipo          = 3,
              each conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
             if  trim(entry(1,conteudo-programa.conteudo,";")) = string(conteudo-programa.sequencia)
             and num-entries(conteudo-programa.conteudo,";")   > 3
             then.
             else do:
                  assign i-codigo-icm = 0
                         i-tp-pedido  = 0.
                  leave.
             end.

             if trim(entry(2,conteudo-programa.conteudo,";")) <> c-demandType
             then next.

             /* Testa redundÉncia */
             if  i-tp-pedido = 0 
             and entry(4,conteudo-programa.conteudo,";") <> "INATIVO"
             then.
             else do:
                  assign i-codigo-icm = 0
                         i-tp-pedido  = 0.
                  leave.
             end.

             assign i-tp-pedido = conteudo-programa.sequencia.

             case entry(3,conteudo-programa.conteudo,";"):
                 when "Consumo"
                 then assign i-codigo-icm = 1.
                 when "Industrializaá∆o"
                 then assign i-codigo-icm = 2.
             end case.                 
         END. /* for first ponto-programa */

    if  i-codigo-icm <> 0
    and i-tp-pedido  <> 0
    then.
    else do:
         run pi-cria-erro("N∆o foi poss°vel recuperar o Tipo Pedido e c¢digo ICM. Revisar Json (demandType) e/ou ES0018 (cadastro para o CC0300A)").
         return "NOK".
    end.

    if avail emitente-cex
    then do:
         if c-incoterm = ""
         then assign c-incoterm = emitente-cex.cod-incoterm-imp.

         assign i-itinerary = emitente-cex.cod-itiner-imp.
    end. /* if avail emitente-cex */

    if i-itinerary = 0
    then assign i-itinerary = 340.

    if  c-incoterm = ""
    and emitente.natureza = 3
    then do:
         run pi-cria-erro(substitute("Incoterm n∆o informado para Emitente ComÇrcio Exterior com o c¢digo &1",
                                     quoter(i-supplierID))).
         return "NOK".
    end.

    if i-shipper = 0
    then assign i-shipper = emitente.cod-transp.

    /* Regra alterada conforme solicitaá∆o - 21/10 */
    if  c-incoterm           = "CIF"
    and emitente.tp-desp-pad <> 2 
    then assign i-shipper = 396. /* Frete CIF */
/*     if  c-incoterm           = "CIF"             */
/*     and emitente.tp-desp-pad = 1 /* Nacional */  */
/*     then assign i-shipper = 396. /* Frete CIF */ */

    find first transporte no-lock
         where transporte.cod-transp = i-shipper no-error.
    
    if not available transporte then do:
      run pi-cria-erro(substitute("Registro de transportadora n∆o localizado com o c¢digo &1", 
                                  quoter(i-shipper))).
      return "NOK".
    end.
    
    if transporte.via-transp = 0
    then do:
         run pi-cria-erro(substitute("Via Transp n∆o informada para transportadora &1", 
                                     quoter(transporte.cod-transp))).
         return "NOK".
    end.

    if  i-paymentTerms <> 0
    and can-find(first cond-pagto where
                       cond-pagto.cod-cond-pag = i-paymentTerms
                       no-lock)
    then.
    else do:
         run pi-cria-erro("Condiá∆o de Pagamento inv†lida").
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

      assign c-tags = "".

      create tt-itens.
      assign tt-itens.sequence              = oItem:GetCharacter("sequence")                                                      no-error.
      assign c-tags = c-tags + ",sequence"              when error-status:error or tt-itens.sequence     = ""
             tt-itens.productID             = oItem:GetInt64("productID")                                                         no-error.
      assign c-tags = c-tags + ",productID"             when error-status:error or tt-itens.productID    = 0
             tt-itens.productNameComplement = oItem:GetCharacter("productNameComplement") when oItem:Has("productNameComplement") no-error.
      assign c-tags = c-tags + ",productNameComplement" when error-status:error
             tt-itens.quantity              = oItem:GetDecimal("quantity")                                                        no-error.
      assign c-tags = c-tags + ",quantity"              when error-status:error or tt-itens.quantity    <= 0
             tt-itens.supplierQuantity      = oItem:GetDecimal("supplierQuantity")        when oItem:Has("supplierQuantity")      no-error.
      assign c-tags = c-tags + ",supplierQuantity"      when error-status:error or tt-itens.supplierQuantity < 0    
             tt-itens.currency              = oItem:GetCharacter("currency")              no-error.
      assign c-tags = c-tags + ",currency"              when error-status:error or tt-itens.currency     = ""
             tt-itens.leadTime              = int(oItem:GetCharacter("leadTime"))            no-error.
      IF error-status:error THEN
          ASSIGN tt-itens.leadTime          = oItem:GetInteger("leadTime") no-error.  
      assign c-tags = c-tags + ",leadTime"              when error-status:error
             tt-itens.supplierReference     = oItem:GetCharacter("supplierReference")     when oItem:Has("supplierReference")     no-error.
      assign c-tags = c-tags + ",supplierReference"     when error-status:error
             tt-itens.unitSupplierMeasure   = oItem:GetCharacter("unitSupplierMeasure")   when oItem:Has("unitSupplierMeasure")   no-error.
      assign c-tags = c-tags + ",unitSupplierMeasure"   when error-status:error
             tt-itens.requester             = oItem:GetCharacter("requester")                                                     no-error.
      assign c-tags = c-tags + ",requester"             when error-status:error or tt-itens.requester = "".      

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

      if not oItem:has("account") 
      then do:
           run pi-cria-erro("Bloco account est† ausente no Json").
           leave.           
      end.
      
      oCcustos = new JsonArray().
      oCcustos = oItem:GetJsonArray("account").

      if not valid-object(oCcustos)
      then do:
           run pi-cria-erro("Erro na leitura do array de CCustos para o ID " + string(tt-itens.productID)).
           return "NOK".
      end.

      assign de-tot-rateio = 0.

      do iLoop2 = 1 to oCcustos:length:
        oCcusto = new JsonObject().
        oCcusto = oCcustos:GetJsonObject(iLoop2).

        assign i-ledgerAccount = 0
               c-costCenter    = "".

        assign i-ledgerAccount = oCcusto:GetInteger("ledgerAccount")
               c-costCenter    = oCcusto:GetCharacter("costCenter")
               no-error.

        if  i-ledgerAccount <> 0
        and i-ledgerAccount <> ?
        and c-costCenter    <> ""
        and c-costCenter    <> ?
        then.
        else do:
             run pi-cria-erro("ledgerAccount e costCenter devem ser informados apropriadamente").
             leave.
        end.

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

      assign tt-itens.rateio = de-tot-rateio.
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
    delete object jsonObjectPayload   no-error.
    delete object jsonArrayPathParams no-error.
    delete object oItens              no-error.
    delete object oCcustos            no-error.
    delete object oItem               no-error.
    delete object oCcusto             no-error.
    delete object objFornecedor       no-error.
    delete object arrayFornecedor     no-error.
  end.
end procedure.

PROCEDURE pi-create-ped-buying:

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
    EMPTY TEMP-TABLE ttcotacao-item.
    empty temp-table tt-desp-cotacao-item.
    empty temp-table tt-processo-imp.
    EMPTY TEMP-TABLE tt-ordem-compra-all.
    
    def var i-cont as inte no-undo.
    
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
    
    for first tt-itens: end.
    
    create tt-pedido-compr.
    
    if  c-logisticsAnalyst <> tt-itens.requester
    and c-logisticsAnalyst <> ""
    and c-logisticsAnalyst <> ?
    then tt-pedido-compr.responsavel = c-logisticsAnalyst.
    else tt-pedido-compr.responsavel = c-buyer.

    assign tt-pedido-compr.ind-tipo-movto       = 1
           tt-pedido-compr.num-pedido           = i-num-pedido
           tt-pedido-compr.natureza             = IF (c-natureOrder = "servico")
                                                  THEN 2 /* Servico */
                                                  ELSE 1 /* Compra */
           tt-pedido-compr.end-cobranca         = estabelec.cod-estabel
           tt-pedido-compr.end-entrega          = estabelec.cod-estabel
           tt-pedido-compr.cod-estabel          = estabelec.cod-estabel
           tt-pedido-compr.cod-estab-gestor     = estabelec.cod-estabel
           tt-pedido-compr.num-ped-benef        = 0
           tt-pedido-compr.data-pedido          = today
           tt-pedido-compr.situacao             = 1 // 1 - Impresso, 2 - N∆o Impresso
           tt-pedido-compr.cod-emitente         = emitente.cod-emitente
           tt-pedido-compr.cod-emit-terc        = emitente.cod-emitente
           tt-pedido-compr.frete                = 2 // 2 - A Pagar
           tt-pedido-compr.cod-transp           = transporte.cod-transp
           tt-pedido-compr.via-transp           = transporte.via-transp
           tt-pedido-compr.cod-cond-pag         = i-paymentTerms
           tt-pedido-compr.cod-mensagem         = i-cod-mensagem
           tt-pedido-compr.impr-pedido          = true
           tt-pedido-compr.comentarios          = "Pedido gerado por meio da integraá∆o com Ariba (Buying)"
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
    
    if temp-table tt-erros-geral:has-records then
        return "NOK".
           
    /*
    run ccp/ccapi333.p (input yes,
                        output i-nr-ordem).
    */
    for each tt-itens:

        find first item no-lock
             where item.it-codigo = string(tt-itens.productID) no-error.
        
        if not avail item
        then do:
             run pi-cria-erro("Item " + string(tt-itens.productID) + " n∆o cadastrado" ).
             return "NOK".
        end.
        
        IF tt-itens.leadtime > 3650 THEN DO:
            run pi-cria-erro("Item " + string(tt-itens.productID) + " com leadtime maior do que 10 anos" ).
            RETURN "NOK".
        END.
        
        assign tt-itens.tipo-contr = item.tipo-contr.
        
        if can-find(first b-tt-itens where
                          b-tt-itens.sequence = tt-itens.sequence
                      and rowid(b-tt-itens)  <> rowid(tt-itens))
        then do:
             run pi-cria-erro("Sequància " + tt-itens.sequence + " repetida no Pedido" ).
             return "NOK".
        end.
        
        find first moeda no-lock
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
        for each  tt-ccusto
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
                                                            input  tt-ccusto.businessUnit,  /* UNIDADE NEG‡CIO */
                                                            input  "PADRAO",                /* PLANO CONTAS */ 
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
              run prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
            
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  b-estabelec.ep-codigo,   /* EMPRESA EMS 2 */
                                                               input  b-estabelec.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                               input  "PADRAO",                /* PLANO CONTAS */
                                                               input  tt-ccusto.ledgerAccount, /* CONTA */
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

        /* Revalida Centros de Custo */
        /*
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
        end.*/
        
        if absolute(tt-itens.rateio - 100) > 0.01
        then do:
             run pi-cria-erro("Total do rateio para a OC deve ser de 100. ID " + item.it-codigo).
             return "NOK".
        end.
        
        release tt-ccusto.
        if item.tipo-contr = 4 /* DÇbito Direto */
        then for first tt-ccusto use-index id2
                 where tt-ccusto.r-item = rowid(tt-itens): end.             
        
        EMPTY TEMP-TABLE tt-erros-geral.
        empty temp-table tt-versao-integr.    
        empty temp-table tt-ordem-compra.
        empty temp-table tt-prazo-compra.
        empty temp-table tt-cotacao-item.
        EMPTY TEMP-TABLE ttcotacao-item.
        empty temp-table tt-desp-cotacao-item.    
        EMPTY TEMP-TABLE tt-matriz-rat-med.
        
        run ccp/ccapi333.p (input yes,
                            output i-nr-ordem).
    
        create tt-ordem-compra.
        assign tt-ordem-compra.l-split        = false
               tt-ordem-compra.ind-tipo-movto = 1
               tt-ordem-compra.numero-ordem   = i-nr-ordem
               tt-itens.numero-ordem          = tt-ordem-compra.numero-ordem
               tt-ordem-compra.num-pedido     = tt-pedido-compr.num-pedido
               tt-ordem-compra.data-pedido    = tt-pedido-compr.data-pedido
               tt-ordem-compra.data-cotacao   = today
               tt-ordem-compra.requisitante   = tt-itens.requester
               tt-ordem-compra.tp-despesa     = emitente.tp-desp-padrao
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
               tt-ordem-compra.frete          = not (c-incoterm <> "CIF" and
                                                     c-incoterm <> "CFR" and
                                                     c-incoterm <> "CPT" and
                                                     c-incoterm <> "CIP" and
                                                     c-incoterm <> "DPU" and
                                                     c-incoterm <> "DAP" and
                                                     c-incoterm <> "DDP")
               tt-ordem-compra.it-codigo      = item.it-codigo
               tt-ordem-compra.dep-almoxar    = item.deposito-pad
               tt-ordem-compra.cod-refer      = ''
               tt-ordem-compra.mo-codigo      = moeda.mo-codigo
               /*tt-ordem-compra.narrativa      = if item.tipo-contr = 4
                                                then string(tt-itens.productNameComplement)
                                                else ""*/
               tt-ordem-compra.narrativa      = "[" + STRING(i-nr-ordem) + "] " + string(tt-itens.productNameComplement)
               tt-ordem-compra.cod-unid-negoc = if  avail tt-ccusto
                                                and tt-ccusto.businessUnit <> ""
                                                then tt-ccusto.businessUnit
                                                else if avail item-uni-estab
                                                     then item-uni-estab.cod-unid-negoc
                                                     else item.cod-unid-negoc
               tt-ordem-compra.ct-codigo      = if avail tt-ccusto
                                                then tt-ccusto.ledgerAccount
                                                else ""
               tt-ordem-compra.sc-codigo      = if avail tt-ccusto
                                                then tt-ccusto.costCenter
                                                else ""
               tt-ordem-compra.conta-contabil = tt-ordem-compra.ct-codigo + tt-ordem-compra.sc-codigo
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
        assign tt-prazo-compra.data-entrega = TODAY + tt-itens.leadTime
               tt-prazo-compra.data-orig    = TODAY + tt-itens.leadTime.

        //Criar Cotacao
        create tt-cotacao-item.
        buffer-copy tt-ordem-compra to tt-cotacao-item
        assign tt-cotacao-item.numero-ordem         = tt-ordem-compra.numero-ordem
               tt-cotacao-item.cod-emitente         = tt-ordem-compra.cod-emitente
               tt-cotacao-item.itinerario           = i-itinerary
               tt-cotacao-item.int-1                = i-itinerary
               tt-cotacao-item.cod-pto-contr-base   = if  avail emitente-cex
                                                      and emitente-cex.cod-pto-contr > 0
                                                      then emitente-cex.cod-pto-contr
                                                      else 1
               tt-cotacao-item.data-cotacao         = tt-ordem-compra.data-cotacao
               tt-cotacao-item.cot-aprovada         = yes
               tt-cotacao-item.un                   = if tt-itens.unitSupplierMeasure <> "" then tt-itens.unitSupplierMeasure else item.un
               tt-cotacao-item.motivo-apr           = 'Aprovaá∆o Autom†tica'
               tt-cotacao-item.aliquota-ipi         = tt-itens.ipiTax  //if tt-pedido-compr.natureza = 1 then tt-itens.ipiTax   else 0 - 20230210
               tt-cotacao-item.aliquota-icm         = tt-itens.icmsTax //if tt-pedido-compr.natureza = 1 then tt-itens.icmsTax  else 0 - 20230210
               tt-cotacao-item.aliquota-iss         = tt-itens.issTax  //if tt-pedido-compr.natureza = 2 then tt-itens.issTax   else 0 - 20230210
               tt-cotacao-item.frete                = tt-ordem-compra.frete
               tt-cotacao-item.cod-incoterm         = c-incoterm
               tt-cotacao-item.codigo-icm           = i-codigo-icm
               tt-cotacao-item.cdn-pais-orig        = fcGetPais().
        
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

        create tt-versao-integr.
        assign tt-versao-integr.cod-versao-integracao = 1.

        CREATE tt-ordem-compra-all.
        BUFFER-COPY tt-ordem-compra TO tt-ordem-compra-all.

        RUN ccp/ccapi302.p (INPUT  TABLE tt-versao-integr,
                            OUTPUT TABLE tt-erros-geral APPEND,
                            INPUT  TABLE tt-ordem-compra,
                            INPUT  TABLE tt-prazo-compra,
                            INPUT  TABLE tt-cotacao-item,
                            &IF DEFINED(bf_mat_despesa_fase_II) &THEN
                               INPUT TABLE tt-desp-cotacao-item,
                            &ENDIF
                            &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
                               INPUT TABLE tt-matriz-rat-med,
                            &ENDIF
                            INPUT  "MAT002").

        if temp-table tt-erros-geral:has-records then
            return "NOK".

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
    end.

    /*
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
                       */
    
    for each tt-ordem-compra-all:

        for first tt-itens
            where tt-itens.numero-ordem = tt-ordem-compra-all.numero-ordem: end.

        for first int-ordem-compra
            where int-ordem-compra.numero-ordem = tt-ordem-compra-all.numero-ordem
                  exclusive-lock: end.
        
        if not avail int-ordem-compra
        then do:
             create int-ordem-compra.
             assign int-ordem-compra.numero-ordem = tt-ordem-compra-all.numero-ordem.
        end.
        
        assign int-ordem-compra.ind-origem-ext = 2 /* Buying */
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
        
        /* TESTE - Trocar para diferente de Ariba */
        IF (c-natureOrder = "servico")
        THEN DO:
            assign int-ordem-compra.ind-origem-ext = 1.
        END.

        find current int-ordem-compra no-lock no-error.
                  
        /* TESTE - Trocar pelo header */
        IF (c-natureOrder <> "servico")
        THEN DO:
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
                   int-prazo-compra.seq-ariba        = tt-itens.sequence
                   int-prazo-compra.num-pedido       = tt-pedido-compr.num-pedido.
            find current int-prazo-compra no-lock no-error.
        END.
        
        if tt-itens.tipo-contr = 4 /* DÇbito Direto */
        then DO:
            for each tt-ccusto
                where tt-ccusto.r-item = rowid(tt-itens):
        
                FIND FIRST matriz-rat-ordem EXCLUSIVE-LOCK
                     WHERE matriz-rat-ordem.numero-ordem = tt-ordem-compra-all.numero-ordem
                       AND matriz-rat-ordem.ct-codigo    = tt-ccusto.ledgerAccount
                       AND matriz-rat-ordem.sc-codigo    = tt-ccusto.costCenter NO-ERROR.
                IF NOT AVAIL matriz-rat-ordem THEN DO:
                
                     CREATE matriz-rat-ordem.
                     ASSIGN matriz-rat-ordem.numero-ordem = tt-ordem-compra-all.numero-ordem
                            matriz-rat-ordem.sc-codigo    = tt-ccusto.costCenter
                            matriz-rat-ordem.ct-codigo    = tt-ccusto.ledgerAccount                          
                            matriz-rat-ordem.char-1       = ""
                            //overlay(matriz-rat-ordem.char-2,1,3) = tt-ordem-compra-all.cod-unid-negoc
                            overlay(matriz-rat-ordem.char-2,1,3) = tt-ccusto.businessUnit.
        
                end. /* for each tt-ccusto */          
              
                ASSIGN matriz-rat-ordem.perc-rateio = matriz-rat-ordem.perc-rateio + tt-ccusto.apportionment.
                find current matriz-rat-ordem no-lock no-error.
            END.
        END.
    end. /* for each tt-ordem-compra-all */

    // Fornecedor Estrangeiro
    if emitente.natureza = 3 then do:
      find first tt-itens no-error.
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
             tt-processo-imp.cod-itiner                 = i-itinerary
             tt-processo-imp.cod-idioma                 = emitente-cex.cod-idioma
             tt-processo-imp.cod-mensagem               = i-cod-mensagem
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
                                else string(emitente.cod-emitente) //item.it-codigo
           c-unid-med-for-aux = if  tt-itens.unitSupplierMeasure <> "" 
                                and tt-itens.unitSupplierMeasure <> ?
                                then tt-itens.unitSupplierMeasure       
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
           tt-item-fornec.cod-cond-pag            = i-paymentTerms        
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
    end.
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
         delete procedure h-boin178 no-error.
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
         run pi-cria-erro("Item x Fornecedor " + tt-item-fornec.it-codigo + "/" + string(tt-item-fornec.cod-emitente) + " n∆o pìde ser criado").
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
  log-manager:write-message(p-des-erro, "ARIBA").
  create tt-erros-geral.
  assign tt-erros-geral.cod-erro = 17006
         tt-erros-geral.des-erro = p-des-erro.
  return "OK".
end procedure.

procedure pi-back-integration:
    def var v-log-pedido     as logi no-undo.
    def var v-num-seq-movto  as inte no-undo.

    /* win295 */
    for first pedido-compr
        where pedido-compr.num-pedido = i-num-pedido
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

