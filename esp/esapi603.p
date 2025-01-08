block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{utp/ut-glob.i}

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

DEFINE VARIABLE meslist AS CHARACTER  FORMAT "x(15)" NO-UNDO
  INITIAL "Janeiro, Fevereiro, Maráo, Abril, Maio, 
      Junho, Julho, Agosto, Setembro, Outubro, Novembro, Dezembro".    

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

DEFINE VARIABLE h-boin425        AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin185        AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin178        AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin688        AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin684        AS HANDLE NO-UNDO.

DEF VAR v-rec-tb-pr-cc           AS RECID NO-UNDO.
DEF VAR v-rec-item-uni-estab     AS RECID NO-UNDO.
DEF VAR v-rec-item-fornec        AS RECID NO-UNDO.
DEF VAR v-rec-item-fornec-estab  AS RECID NO-UNDO.
DEF VAR v-rec-item-tab           AS RECID NO-UNDO.
DEF VAR c-externalId             AS CHAR  NO-UNDO.
def var c-cod-modelo             as char  no-undo.
DEF VAR c-purchasingContractId   AS CHAR FORMAT "x(20)" NO-UNDO.

/* Temp Tables */
{esp/esapi603.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-dados
    FIELD cod-emitente         LIKE item-fornec.cod-emitente
    FIELD cod-estab            LIKE item-fornec-estab.cod-estab
    FIELD dt-inicio            LIKE tb-pr-cc.dt-inicio
    FIELD dt-termino           LIKE tb-pr-cc.dt-termino
    FIELD moeda                AS CHAR
    FIELD mo-codigo            LIKE dist-emitente.mo-fatur
    FIELD spendType            AS CHAR
    FIELD data-limite          AS DATE FORMAT "99/99/9999".

DEFINE TEMP-TABLE tt-itens
    FIELD it-codigo           LIKE item-fornec.it-codigo
    FIELD pr-item             LIKE item-tab.pr-item
    FIELD unid-med-for        LIKE item-fornec.unid-med-for
    FIELD tempo-ressup        LIKE item-fornec.tempo-ressup
    FIELD res-for-comp        LIKE item-uni-estab.res-for-comp
    FIELD lote-minimo         LIKE item-fornec.lote-minimo
    FIELD lote-mul-for        LIKE item-fornec.lote-mul-for
    FIELD perc-compra         AS DEC // LIKE item-fornec-estab.perc-compra
    FIELD aliquota-ipi        LIKE item-tab.aliquota-ipi
    FIELD aliquota-icm        LIKE item-tab.aliquota-icm
    FIELD fator-conver        LIKE item-fornec.fator-conver
    FIELD num-casa-dec        LIKE item-fornec.num-casa-dec
    FIELD item-do-forn        LIKE item-fornec.item-do-forn
    FIELD cod-comprado        LIKE item-uni-estab.cod-comprado
    FIELD quant-segur         LIKE item-uni-estab.quant-segur
    FIELD cod-cond-pag        LIKE tb-pr-cc.cod-cond-pag
    FIELD num-dias-libera-fft LIKE int-tb-pr-cc.num-dias-libera-fft
    FIELD atual-quant-segur   AS LOGICAL.    

define temp-table tt-erro no-undo
  field codigo     as integer
  field informacao as character
  field mensagem   as character format "x(250)".

define temp-table auxRowErrors no-undo like RowErrors.

define buffer b-emitente for emitente.

DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetInteger   returns integer   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetDecimal   returns decimal   ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetDate      returns date      ( cProperty as character, oJson as JsonObject ) forwards.

{esp/esapi505x.i &OPC="OPEN"}

/*if i-acao = 0 then do:
   l-esapi556 = no.
   {esp/esapi505x.i &OPC="CLOSE"}
   return "OK".
end.*/

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
    run pi-acompanhar in h-acomp ("Tabela de Preáos").

  run pi-input-api-headers (jsonInput).

  run pi-carga-json.
  

  // MESSAGE "Cria Registros: " RETURN-VALUE VIEW-AS ALERT-BOX.

  if return-value = "OK" then
    run pi-cria-tabela.

  /*
  MESSAGE "retorno" RETURN-VALUE CAN-FIND(FIRST tt-erro)
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  */

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  assign es-api-log.retorno-content-type = "application/json".
  if not can-find(first tt-erros-geral) then do:
      FIND FIRST tt-dados NO-ERROR.
      // jsonObjectOutput:add("supplierId",   tt-dados.cod-emitente). 
      // jsonObjectOutput:add("centerId",     tt-dados.cod-estab).    
      jsonObjectOutput:add("purchasingContractId", c-purchasingContractId).
      jsonObjectOutput:add("customerCode", tt-dados.cod-emitente).
      jsonObjectOutput:add("externalId",   c-externalId).
      jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end.
  else do:
     oErrors = new JsonArray().
     for each tt-erros-geral:
         oError = new JsonObject().
         oError:add("errorCode",        tt-erros-geral.cod-erro). 
         oError:add("errorInfo",        ""). 
         oError:add("errorDescription", tt-erros-geral.des-erro).
         oErrors:add(oError).
     end.
     jsonObjectOutput:add("Erros", oErrors).
     jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end.

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if not temp-table tt-erros-geral:has-records then 
     assign es-api-log.cod-retorno = "200"
            es-api-log.aux         = "Tabela de Preáo criada com sucesso".
  else do:      
      assign es-api-log.cod-retorno = "500".
  end.
  empty temp-table tt-erros-geral.
  release es-api-log.

  finally:
     delete procedure h-boin425 no-error.
     delete procedure h-boin185 no-error.
     DELETE procedure h-boin178 no-error.
     delete procedure h-boin688 no-error.
     delete procedure h-boin684 no-error.
  end.

end.

{esp/esapi505x.i &OPC="CLOSE"}

return "OK".

/* **********************  Internal Procedures  *********************** */
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
  DEFINE VARIABLE objFornecedor       AS JsonObject NO-UNDO.
  DEFINE VARIABLE arrayFornecedor     AS jsonArray  NO-UNDO.
  define variable lcAux               as longchar   no-undo.
  define variable c-tags              as character  no-undo.    

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload")
         cMetodo           = jsonInput:GetCharacter("method").

  if valid-object(jsonObjectPayload) then do:

    CREATE tt-dados.
    ASSIGN tt-dados.cod-emitente  = fcGetInteger("supplierID", jsonObjectPayload)
           tt-dados.cod-estab     = fcGetCharacter("centerId", jsonObjectPayload)
           tt-dados.dt-inicio     = fcGetDate("initialDate",   jsonObjectPayload)
           tt-dados.dt-termino    = fcGetDate("finalDate",     jsonObjectPayload)
           tt-dados.moeda         = fcGetCharacter("currency", jsonObjectPayload) 
           tt-dados.spendType     = fcGetCharacter("spendType",jsonObjectPayload).

    if temp-table tt-erros-geral:has-records
    then undo, return "NOK".

    assign tt-dados.data-limite = ?.

    if jsonObjectPayload:has("purchaseDataupdate")
    then do:
         ASSIGN tt-dados.data-limite = jsonObjectPayload:getDate("purchaseDataupdate") NO-ERROR.
         
         IF ERROR-STATUS:ERROR 
         then do:
              run pi-cria-erro("Formato do campo purchaseDataupdate n∆o Ç v†lido").
              undo, return "NOK".
         end. /* if error-status:error */
    end. /* if jsonObjectPayload:has("purchaseDataupdate") */

    find current tt-dados no-error.

    if jsonObjectPayload:has("Itens") then do:
      oItens = new JsonArray().
      oItens = jsonObjectPayload:GetJsonArray("Itens").
    end.
  end.
  else do:
    run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de tabela de preáo para integrar").
    undo, return "NOK".
  end.

  if valid-object(oItens) then do:
    do iLoop = 1 to oItens:length:
      oItem = new JsonObject().
      oItem = oItens:GetJsonObject(iLoop).

      CREATE tt-itens.
      ASSIGN tt-itens.it-codigo           = fcGetCharacter("productId",          oItem)
             tt-itens.pr-item             = fcGetDecimal("unitPrice",            oItem)
             tt-itens.tempo-ressup        = fcGetInteger("leadTime",             oItem)
             tt-itens.lote-minimo         = fcGetDecimal("moqQuantity",          oItem)
             tt-itens.lote-mul-for        = fcGetDecimal("multipleQuantity",     oItem)
             tt-itens.perc-compra         = inte(fcGetDecimal("share",           oItem))
             tt-itens.cod-comprado        = fcGetCharacter("logisticsAnalyst",   oItem).           

      if temp-table tt-erros-geral:has-records
      THEN return "NOK".

      assign tt-itens.res-for-comp        = oItem:getInteger("transitTime")                                                 no-error.
      assign c-tags                       = c-tags + ",transitTime"         when error-status:error
             tt-itens.unid-med-for        = oItem:getCharacter("unitSupplierMeasure") when oItem:has("unitSupplierMeasure") no-error.
      assign c-tags                       = c-tags + ",unitSupplierMeasure" when error-status:error
             tt-itens.aliquota-ipi        = oItem:getDecimal("ipiTax")                when oItem:has("ipiTax")              no-error.
      assign c-tags                       = c-tags + ",ipiTax"              when error-status:error                                 
             tt-itens.aliquota-icm        = oItem:getDecimal("icmsTax")               when oItem:has("icmsTax")             no-error.   
      assign c-tags                       = c-tags + ",icmsTax"             when error-status:error
             tt-itens.cod-cond-pag        = oItem:getInteger("paymentTerms")          when oItem:has("paymentTerms")        no-error.
      assign c-tags                       = c-tags + ",paymentTerms"        when error-status:error
             tt-itens.fator-conver        = fcGetDecimal("conversion",          oItem).
      assign c-tags                       = c-tags + ",conversion"          when error-status:error
             tt-itens.num-casa-dec        = oItem:getInteger("decimalPlaces")         when oItem:has("decimalPlaces")       no-error.
      assign c-tags                       = c-tags + ",decimalPlaces"       when error-status:error
             tt-itens.item-do-forn        = oItem:getCharacter("supplierReference")   when oItem:has("supplierReference")   no-error.
      assign c-tags                       = c-tags + ",supplierReference"   when error-status:error
             tt-itens.quant-segur         = oItem:getDecimal("safetyStock")           when oItem:has("safetyStock")         no-error.
      assign c-tags                       = c-tags + ",safetyStock"         when error-status:error
             tt-itens.num-dias-libera-fft = oItem:getInteger("fftDays")               when oItem:has("fftDays")             no-error.
      assign c-tags                       = c-tags + ",fftDays"             when error-status:error
             c-tags                       = trim(c-tags,",").    

      IF oItem:has("safetyStock") THEN
          ASSIGN tt-itens.atual-quant-segur = YES.
      ELSE
          ASSIGN tt-itens.atual-quant-segur = NO.

      if c-tags <> ""
      then do:
        run pi-cria-erro("Erro quanto ao tipo de entrada de dados dos seguintes campos: " + c-tags).
        undo, return "NOK".           
      end.

      if tt-itens.cod-cond-pag = 0
      then if not can-find(first b-emitente where
                                 b-emitente.cod-emitente = tt-dados.cod-emitente
                             and b-emitente.cod-cond-pag > 0
                                 no-lock)
           then do:
             run pi-cria-erro(substitute("Condiá∆o de Pagamento n∆o encontrada para emitente com ID &1",
                                         quoter(tt-dados.cod-emitente))).
             undo, return "NOK".            
           end.
           else for first b-emitente fields(cod-emitente cod-cond-pag) no-lock
                    where b-emitente.cod-emitente = tt-dados.cod-emitente:
                    assign tt-itens.cod-cond-pag = b-emitente.cod-cond-pag.
                end.
    end. //do iLoop
  end. //if valid-handle  

  if not temp-table tt-itens:has-records then do:
     run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de itens de tabelas de preáo para integrar").
     undo, return "NOK".
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

end procedure.

PROCEDURE pi-cria-tabela:

    DEF BUFFER b-item-fornec-estab FOR item-fornec-estab.
    DEF BUFFER b-tb-pr-cc FOR tb-pr-cc.
    def buffer b-tt-itens for tt-itens.

    DEF VAR i-cod-maior-fornecedor AS INTEGER NO-UNDO INITIAL ?.
    DEF VAR d-data-limite          AS DATE NO-UNDO.
    def var c-item-do-forn-aux     as char no-undo.
    def var de-pr-item             as deci no-undo.
    DEFINE VARIABLE l-estab-atualiza-lote AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-atualiza-lote AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-tb-pr-cc.
    EMPTY TEMP-TABLE tt-item-tab.
    EMPTY TEMP-TABLE tt-item-fornec.
    EMPTY TEMP-TABLE tt-item-fornec-estab.
    EMPTY TEMP-TABLE tt-item-uni-estab.
    EMPTY TEMP-TABLE tt-altera-preco.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "esapi603":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    //Criar Tabela de Preáos

    FIND FIRST tt-dados NO-LOCK NO-ERROR.

    IF CAN-FIND(FIRST tt-prog-ponto
                WHERE tt-prog-ponto.conteudo = tt-dados.cod-estab) THEN
        ASSIGN l-estab-atualiza-lote = NO.
    ELSE
        ASSIGN l-estab-atualiza-lote = YES.

    FOR EACH tt-itens BREAK BY tt-itens.cod-cond-pag:
        
        IF NOT l-estab-atualiza-lote THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-itens.it-codigo NO-ERROR.
            IF AVAIL ITEM THEN DO:
                /* 2- Fabricado */
                IF ITEM.compr-fabric = 2 THEN
                    ASSIGN l-atualiza-lote = NO.                
                ELSE
                    ASSIGN l-atualiza-lote = YES.
            END.
        END.
        ELSE
            ASSIGN l-atualiza-lote = YES.

        IF FIRST-OF(tt-itens.cod-cond-pag) THEN DO:
            
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-dados.cod-emitente NO-ERROR.
            IF NOT AVAIL emitente THEN DO:
                RUN pi-cria-erro("Fornecedor " + STRING(tt-dados.cod-emitente) + " N∆o Cadastrado").
                undo, RETURN "NOK".
            END.

            FIND FIRST mgcad.pais NO-LOCK 
                WHERE mgcad.pais.nome-pais = emitente.pais NO-ERROR.
            ASSIGN c-externalId  = TRIM (SUBSTRING (pais.char-1,23,02)) WHEN avail mgcad.pais.

            // Fornecedor Estrangeiro
            IF emitente.natureza = 3 then 
               ASSIGN c-externalId = c-externalId + TRIM (SUBSTRING (emitente.char-1,103,30)). // Passaporte.
            ELSE 
                ASSIGN c-externalId = c-externalId + emitente.cgc.
        
            FIND estabelec NO-LOCK WHERE estabelec.cod-estabel = tt-dados.cod-estab NO-ERROR.
            IF NOT AVAIL estabelec THEN DO:
               RUN pi-cria-erro("Estabelecimento " + STRING(tt-dados.cod-estab) + " N∆o Cadastrado").
               undo, RETURN "NOK".
            END.

            if tt-dados.dt-inicio > tt-dados.dt-termino then do:
               RUN pi-cria-erro(substitute("Data In°cio &1 Ç posterior Ö Data TÇrmino &2",
                                           quoter(tt-dados.dt-inicio),
                                           quoter(tt-dados.dt-termino))).
               undo, RETURN "NOK".
            end.
        
            FIND cond-pagto NO-LOCK WHERE cond-pagto.cod-cond-pag = tt-itens.cod-cond-pag NO-ERROR.
            IF NOT AVAIL cond-pagto THEN DO:
                RUN pi-cria-erro("Condiá∆o de Pagamento " + STRING(tt-itens.cod-cond-pag) + " N∆o Cadastrada").
                undo, RETURN "NOK".
            END.

            ASSIGN c-purchasingContractId = TRIM (STRING (tt-dados.cod-emitente) + "." + STRING (tt-itens.cod-cond-pag) + "." + STRING (tt-dados.cod-estab)).

            IF tt-dados.dt-inicio = ? THEN DO:
                RUN pi-cria-erro("Data de In°cio de Validade da Tabela de Preáos Inv†lida").
                UNDO, RETURN "NOK".
            END.

            IF tt-dados.dt-termino = ? THEN DO:
                RUN pi-cria-erro("Data de TÇrmino de Validade da Tabela de Preáos Inv†lida").
                UNDO, RETURN "NOK".
            END.

            IF tt-dados.dt-inicio > tt-dados.dt-termino THEN DO:
                RUN pi-cria-erro("Data de In°cio " + STRING(tt-dados.dt-inicio) + " N∆o Pode Ser Maior Que a Data de TÇrmino " + STRING(tt-dados.dt-termino)).
                undo, RETURN "NOK".
            END.

            IF INDEX("OEM,CKD,SKD,MP,Indiretos,QRF,198,495 OEM,495 CKD,495 SKD,RFI",tt-dados.spendType) = 0 THEN DO:
                RUN pi-cria-erro("Spend Type " + tt-dados.spendType + " Informado N∆o ê V†lido" ).
                undo, RETURN "NOK".

            END.

            // MESSAGE "Data Atualizaá∆o: " STRING (tt-dados.data-limite, "99/99/9999") VIEW-AS ALERT-BOX.
                        
            IF tt-dados.data-limite <> ? THEN DO:
                ASSIGN d-data-limite = tt-dados.data-limite.                
            END.            
            
            IF INDEX("Real,Dolar,Euro,Renminbi,Yen,Libra", tt-dados.moeda)  = 0 THEN DO:
                RUN pi-cria-erro("Moeda " + tt-dados.moeda + " Informada N∆o ê V†lida" ).
                undo, RETURN "NOK".

            END.
       
            IF NOT VALID-HANDLE(h-boin425) THEN
               RUN inbo/boin425.p PERSISTENT SET h-boin425.

            FIND FIRST tt-tb-pr-cc  
                WHERE tt-tb-pr-cc.cod-emitente   = tt-dados.cod-emitente
                  AND tt-tb-pr-cc.cdn-fabrican   = 0
                  AND tt-tb-pr-cc.cod-cond-pag   = tt-itens.cod-cond-pag
                  AND tt-tb-pr-cc.nr-tab         = tt-dados.cod-estab
                  AND tt-tb-pr-cc.dt-inicio      = tt-dados.dt-inicio NO-ERROR.
            IF NOT AVAIL tt-tb-pr-cc THEN DO:
                CREATE tt-tb-pr-cc.
                ASSIGN tt-tb-pr-cc.cod-emitente = tt-dados.cod-emitente
                       tt-tb-pr-cc.cdn-fabrican = 0
                       tt-tb-pr-cc.cod-cond-pag = tt-itens.cod-cond-pag
                       tt-tb-pr-cc.nr-tab       = tt-dados.cod-estab
                       tt-tb-pr-cc.dt-inicio    = tt-dados.dt-inicio
                       tt-tb-pr-cc.dt-termino   = tt-dados.dt-termino
                       tt-tb-pr-cc.cod-estabel  = tt-dados.cod-estab
                       tt-tb-pr-cc.descricao    = "Negociaá∆o Via Ariba"
                       tt-tb-pr-cc.codigo-ipi  = NO
                       tt-tb-pr-cc.situacao    = 1.
                       // tt-tb-pr-cc.mo-codigo    = int(tt-importado-result.valor[6])
                       // tt-tb-pr-cc.dt-termino   = DATE(tt-importado-result.valor[8])                   
                       // tt-tb-pr-cc.taxa-financ  = if tt-importado-result.valor[10] = "S":U then yes else no
                       // tt-tb-pr-cc.perc-descto  = dec(tt-importado-result.valor[11])
                       // tt-tb-pr-cc.valor-taxa   = dec(tt-importado-result.valor[12])                      
                       // tt-tb-pr-cc.valor-frete  = dec(tt-importado-result.valor[14])
                       // tt-tb-pr-cc.descricao    = tt-importado-result.valor[15]
                       // tt-tb-pr-cc.frete        = if tt-importado-result.valor[16] = "S":U then yes else no
                       // tt-tb-pr-cc.aliquota-icm = dec(tt-importado-result.valor[17])
                       // tt-tb-pr-cc.nr-dia-preco = int(tt-importado-result.valor[18])
                       // tt-tb-pr-cc.tx-fin-dia   = int(tt-importado-result.valor[19])
                       // tt-tb-pr-cc.observacao   = tt-importado-result.valor[20]
                       // tt-tb-pr-cc.nr-dias-taxa     = int(tt-importado-result.valor[21])

                find first emitente NO-LOCK
                    where emitente.cod-emitente = tt-tb-pr-cc.cod-emitente no-error.
                IF AVAIL emitente THEN do:
                    assign tt-tb-pr-cc.nome-abrev = emitente.nome-abrev.
                end.
                IF tt-dados.dt-termino < TODAY THEN 
                    ASSIGN tt-tb-pr-cc.situacao = 2.        
                CASE tt-dados.moeda: /* moeda */
                   when "Dolar" then assign tt-tb-pr-cc.mo-codigo  = 1. /* 1 - D¢lar */ 
                   when "Euro"  then assign tt-tb-pr-cc.mo-codigo  = 5. /* 5 - Euro  */
                   when "Renminbi"  then assign tt-tb-pr-cc.mo-codigo  = 7. /* 7 - Renminbi  */
                   when "Yen"  then assign tt-tb-pr-cc.mo-codigo  = 4. /* 4 - Yen  */
                   when "Libra" then assign tt-tb-pr-cc.mo-codigo  = 6. /* 6 - Libra  */
                   otherwise assign tt-tb-pr-cc.mo-codigo = 0.
                END CASE.
            END.            

            IF NOT VALID-HANDLE(h-boin425) THEN
                RUN inbo/boin425.p PERSISTENT SET h-boin425.

            FIND FIRST tb-pr-cc 
                 WHERE tb-pr-cc.cod-emitente = tt-tb-pr-cc.cod-emitente
                   AND tb-pr-cc.cod-cond-pag = tt-tb-pr-cc.cod-cond-pag
                   AND tb-pr-cc.nr-tab       = tt-tb-pr-cc.cod-estabel
                   AND tb-pr-cc.cod-estabel  = tt-tb-pr-cc.cod-estabel
                   AND tb-pr-cc.mo-codigo    = tt-tb-pr-cc.mo-codigo
                   and tb-pr-cc.dt-inicio   <> tt-tb-pr-cc.dt-inicio 
                       EXCLUSIVE-LOCK NO-ERROR.
            // Elimina a Tabela de Preáo caso a data inicial seja diferente 
            IF AVAIL tb-pr-cc THEN DO:               
                FOR EACH item-tab EXCLUSIVE-LOCK 
                    WHERE item-tab.cod-emitente   = tb-pr-cc.cod-emitente
                      AND item-tab.cdn-fabrican   = tb-pr-cc.cdn-fabrican
                      AND item-tab.des-referencia = ""
                      AND item-tab.cod-cond-pag   = tb-pr-cc.cod-cond-pag
                      AND item-tab.nr-tab         = tb-pr-cc.nr-tab
                      AND item-tab.dt-inicio      = tb-pr-cc.dt-inicio:                        
                    DELETE item-tab.
                END. //for each item-tab

                RUN openQueryStatic IN h-boin425 (INPUT "main":U).
                RUN emptyRowErrors IN h-boin425.

                RUN goToKey IN h-boin425 (INPUT tt-tb-pr-cc.nome-abrev,
                                          INPUT tt-tb-pr-cc.cod-cond-pag,
                                          INPUT tt-tb-pr-cc.nr-tab,
                                          INPUT tt-tb-pr-cc.cod-estabel,
                                          INPUT tt-tb-pr-cc.mo-codigo).
                IF RETURN-VALUE = "OK":U THEN do:
                    RUN setRecord IN h-boin425 (INPUT TABLE tt-tb-pr-cc).   
                    RUN validateRecord in h-boin425 (input "Delete"). 
                    if return-value = "OK":U then do:
                        RUN deleteRecord IN h-boin425.
                        RUN getRowErrors in h-boin425(output table RowErrors).
                        IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                            FOR EACH RowErrors:
                                create tt-erros-geral.
                                assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                       tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                               + " (proc. delete1)".
                                // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                            end.
                            run emptyRowErrors  in h-boin425.
                            delete procedure h-boin425 no-error.
                            undo, return "NOK".
                        END.
                    end.
                    ELSE DO:
                        RUN getRowErrors in h-boin425(output table RowErrors).
                        IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                            FOR EACH RowErrors:
                                create tt-erros-geral.
                                assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                       tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                               + " (proc. delete2)".
                                // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                            end.
                            run emptyRowErrors  in h-boin425.
                            delete procedure h-boin425 no-error.
                            UNDO, return "NOK".
                        END.
                    END.
                END.                
            END. //if avail tb-pr-cc
            /*
            ELSE DO:
                RUN pi-cria-erro("Tabela de Preáos j† Existe para Forncedor/Condiá∆o/Estab/Data de Inicio: " + STRING(tt-dados.cod-emitente) + "-" + STRING(tt-itens.cod-cond-pag) + "-" + STRING(tt-dados.cod-estab) + "-" + STRING(tt-dados.dt-inicio)).
                undo, RETURN "NOK".
            END.
            */            

            /* Cria ou Altera a tb-pr-cc */
            FIND FIRST tb-pr-cc EXCLUSIVE-LOCK 
                WHERE tb-pr-cc.cod-emitente = tt-tb-pr-cc.cod-emitente
                  AND tb-pr-cc.cod-cond-pag = tt-tb-pr-cc.cod-cond-pag
                  AND tb-pr-cc.nr-tab       = tt-tb-pr-cc.cod-estabel
                  AND tb-pr-cc.cod-estabel  = tt-tb-pr-cc.cod-estabel
                  AND tb-pr-cc.mo-codigo    = tt-tb-pr-cc.mo-codigo NO-ERROR.
            IF NOT AVAIL tb-pr-cc THEN DO:
                RUN openQueryStatic IN h-boin425 (INPUT "main":U).
                RUN emptyRowErrors IN h-boin425.
    
                RUN setRecord IN h-boin425 (INPUT TABLE tt-tb-pr-cc).
                RUN validateRecord in h-boin425 (input "Create").                
                
                IF RETURN-VALUE = "OK":U THEN DO:
                   RUN createRecord IN h-boin425. 
                   RUN getRowErrors in h-boin425(output table RowErrors).
                   IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                       FOR EACH RowErrors:
                           create tt-erros-geral.
                           assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                  tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                          + " (proc. create1)".
                           // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                       end.
                       run emptyRowErrors  in h-boin425.
                       delete procedure h-boin425 no-error.
                       undo, return "NOK".
                   END.

                   FOR EACH item-tab EXCLUSIVE-LOCK 
                       WHERE item-tab.cod-emitente   = tt-tb-pr-cc.cod-emitente
                         AND item-tab.cdn-fabrican   = tt-tb-pr-cc.cdn-fabrican
                         AND item-tab.des-referencia = ""
                         AND item-tab.cod-cond-pag   = tt-tb-pr-cc.cod-cond-pag
                         AND item-tab.nr-tab         = tt-tb-pr-cc.nr-tab
                         AND item-tab.dt-inicio      = tt-tb-pr-cc.dt-inicio:

                       DELETE item-tab.
                   END. //for each item-tab
                END.
                ELSE DO:
                    RUN getRowErrors in h-boin425(output table RowErrors).
                    IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                        FOR EACH RowErrors:
                            create tt-erros-geral.
                            assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                   tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                           + " (proc. create2)".
                            // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                        end.
                        run emptyRowErrors  in h-boin425.
                        delete procedure h-boin425 no-error.
                        UNDO, return "NOK".
                    END.
                END.
            END.
            else do:
                FIND FIRST tb-pr-cc EXCLUSIVE-LOCK 
                    WHERE tb-pr-cc.cod-emitente = tt-dados.cod-emitente
                      AND tb-pr-cc.cdn-fabrican = 0
                      AND tb-pr-cc.cod-cond-pag = tt-itens.cod-cond-pag
                      AND tb-pr-cc.nr-tab       = tt-dados.cod-estab
                      AND tb-pr-cc.dt-inicio    = tt-dados.dt-inicio NO-ERROR.
                IF NOT AVAIL tb-pr-cc THEN DO:
                    ASSIGN v-rec-tb-pr-cc = ?.
                    RUN pi-cria-erro ("Tabela de Preáos N∆o Encontrada para Forncedor/Condiá∆o/Estab/Data de Inicio: " + STRING(tt-dados.cod-emitente) + "-" + STRING(tt-itens.cod-cond-pag) + "-" + STRING(tt-dados.cod-estab) + "-" + STRING(tt-dados.dt-inicio)).
                    undo, RETURN "NOK".
                END.
                ELSE
                    ASSIGN v-rec-tb-pr-cc = RECID (tb-pr-cc).
                
                IF CAN-FIND(FIRST b-tb-pr-cc NO-LOCK WHERE b-tb-pr-cc.cod-emitente = tt-dados.cod-emitente AND
                                                           b-tb-pr-cc.cdn-fabrican = 0                     AND
                                                           b-tb-pr-cc.cod-cond-pag = tt-itens.cod-cond-pag AND
                                                           b-tb-pr-cc.nr-tab       = tt-dados.cod-estab    AND
                                                           b-tb-pr-cc.dt-inicio   <= tt-dados.dt-termino   AND
                                                           b-tb-pr-cc.dt-termino  >= tt-dados.dt-inicio    AND
                                                           ROWID(b-tb-pr-cc)        <> ROWID(tb-pr-cc)) THEN DO:
                    RUN pi-cria-erro ("J† Existe uma Tabela de Preáos para o Per°odo de Vigància Informado").
                    UNDO, RETURN "NOK".
                END.
                
                FIND FIRST tt-tb-pr-cc  
                    WHERE tt-tb-pr-cc.cod-emitente   = tt-dados.cod-emitente
                      AND tt-tb-pr-cc.cdn-fabrican   = 0
                      AND tt-tb-pr-cc.cod-cond-pag   = tt-itens.cod-cond-pag
                      AND tt-tb-pr-cc.nr-tab         = tt-dados.cod-estab
                      AND tt-tb-pr-cc.dt-inicio      = tt-dados.dt-inicio NO-ERROR.
                IF NOT AVAIL tt-tb-pr-cc THEN DO:
                    RUN pi-cria-erro ("Tabela de Preáos N∆o Encontrada para Forncedor/Condiá∆o/Estab/Data de Inicio: " + STRING(tt-dados.cod-emitente) + "-" + STRING(tt-itens.cod-cond-pag) + "-" + STRING(tt-dados.cod-estab) + "-" + STRING(tt-dados.dt-inicio)).
                    undo, RETURN "NOK".
                END.

                /* Atualiza tb-pr-cc */
                IF NOT VALID-HANDLE(h-boin425) THEN
                   RUN inbo/boin425.p PERSISTENT SET h-boin425.

                RUN openQueryStatic IN h-boin425 (INPUT "main":U).
                RUN emptyRowErrors IN h-boin425.

                RUN goToKey IN h-boin425 (INPUT tt-tb-pr-cc.nome-abrev,
                                          INPUT tt-tb-pr-cc.cod-cond-pag,
                                          INPUT tt-tb-pr-cc.nr-tab,
                                          INPUT tt-tb-pr-cc.cod-estabel,
                                          INPUT tt-tb-pr-cc.mo-codigo). 

                IF RETURN-VALUE = "OK":U THEN do:
                    RUN setRecord IN h-boin425 (INPUT TABLE tt-tb-pr-cc).   
                    RUN validateRecord in h-boin425 (input "Update").
                    if return-value = "OK":U then do:
                        RUN updateRecord IN h-boin425.
                        RUN getRowErrors in h-boin425(output table RowErrors).
                        IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                            FOR EACH RowErrors:
                                create tt-erros-geral.
                                assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                       tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                               + " (proc. update1)".
                                // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                            end.
                            run emptyRowErrors  in h-boin425.
                            delete procedure h-boin425 no-error.
                            undo, return "NOK".
                        END.
                    end.
                END. 
                ELSE DO:
                    RUN getRowErrors in h-boin425(output table RowErrors).
                    IF TEMP-TABLE RowErrors:HAS-RECORDS THEN DO:
                        FOR EACH RowErrors:
                            create tt-erros-geral.
                            assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                                   tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                           + " (proc. update2)".
                            // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                        end.
                        run emptyRowErrors  in h-boin425.
                        delete procedure h-boin425 no-error.
                        UNDO, return "NOK".
                    END.
                END.
           end. /* else do */

           IF v-rec-tb-pr-cc <> ? THEN DO:
               FIND tb-pr-cc NO-LOCK
                   WHERE RECID (tb-pr-cc) = v-rec-tb-pr-cc NO-ERROR.
           END.
           ELSE DO:
               FIND FIRST tb-pr-cc NO-LOCK 
                   WHERE tb-pr-cc.cod-emitente = tt-dados.cod-emitente
                     AND tb-pr-cc.cdn-fabrican = 0
                     AND tb-pr-cc.cod-cond-pag = tt-itens.cod-cond-pag
                     AND tb-pr-cc.nr-tab       = tt-dados.cod-estab
                     AND tb-pr-cc.dt-inicio    = tt-dados.dt-inicio NO-ERROR.
           END.

           IF AVAIL tb-pr-cc THEN DO:
               ASSIGN v-rec-tb-pr-cc = RECID (tb-pr-cc). 
               FIND int-tb-pr-cc EXCLUSIVE-LOCK 
                   WHERE int-tb-pr-cc.cod-emitente = tb-pr-cc.cod-emitente
                     AND int-tb-pr-cc.cod-estabel  = tb-pr-cc.cod-estabel
                     AND int-tb-pr-cc.cod-cond-pag = tb-pr-cc.cod-cond-pag
                     AND int-tb-pr-cc.mo-codigo    = tb-pr-cc.mo-codigo
                     AND int-tb-pr-cc.nr-tab       = tb-pr-cc.nr-tab
                     AND int-tb-pr-cc.dt-inicio    = tb-pr-cc.dt-inicio NO-ERROR.
                IF NOT AVAIL int-tb-pr-cc THEN DO:
                   CREATE int-tb-pr-cc.
                   ASSIGN int-tb-pr-cc.cod-cond-pag        = tb-pr-cc.cod-cond-pag
                          int-tb-pr-cc.nr-tab              = tb-pr-cc.nr-tab
                          int-tb-pr-cc.cod-emitente        = tb-pr-cc.cod-emitente
                          int-tb-pr-cc.cod-estabel         = tb-pr-cc.cod-estabel
                          int-tb-pr-cc.mo-codigo           = tb-pr-cc.mo-codigo
                          int-tb-pr-cc.dt-inicio           = tb-pr-cc.dt-inicio.
                   find first emitente NO-LOCK
                       where emitente.cod-emitente = tb-pr-cc.cod-emitente no-error.
                   IF AVAIL emitente THEN do:
                       assign int-tb-pr-cc.nome-abrev = emitente.nome-abrev.
                   end.

                END. //if not avail
                ASSIGN int-tb-pr-cc.num-dias-libera-fft = tt-itens.num-dias-libera-fft.                
           END.

        END. //if first-of

        FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-dados.cod-emitente NO-ERROR.

        for FIRST ITEM 
            WHERE ITEM.it-codigo = tt-itens.it-codigo
                  EXCLUSIVE-LOCK: end.
                   
        if not avail item THEN DO:
            RUN pi-cria-erro("Item " + tt-itens.it-codigo + " N∆o Cadastrado").
            undo, RETURN "NOK".
        END. //if not can-find

        if can-find(first b-tt-itens where
                          b-tt-itens.it-codigo = tt-itens.it-codigo
                      and rowid(b-tt-itens)   <> rowid(tt-itens))
        then do:
             RUN pi-cria-erro("Item " + tt-itens.it-codigo + " econtra-se repetido no Json").
             undo, RETURN "NOK".
        end.

        if tt-itens.unid-med-for = ""
        then assign tt-itens.unid-med-for = item.un
                    tt-itens.fator-conver = 1          
                    tt-itens.num-casa-dec = 0.
        else if  tt-itens.fator-conver > 0
             and tt-itens.num-casa-dec >= 0
             then.
             else assign tt-itens.fator-conver = 1          
                         tt-itens.num-casa-dec = 0.
        
        // MESSAGE "1 item-uni-estab: " tt-itens.it-codigo VIEW-AS ALERT-BOX.
        
        /* Cria e atualiza item-uni-estab */
        IF NOT VALID-HANDLE(h-boin684) THEN
            run inbo/boin684.p persistent set h-boin684.

        /*Unidade de medida */
        ASSIGN de-indice = tt-itens.fator-conver / IF tt-itens.num-casa-dec = 0 THEN 1 ELSE EXP(10,tt-itens.num-casa-dec).        

        EMPTY TEMP-TABLE tt-item-uni-estab.
        FIND item-uni-estab EXCLUSIVE-LOCK 
            WHERE item-uni-estab.it-codigo   = tt-itens.it-codigo
              AND item-uni-estab.cod-estabel = tt-dados.cod-estab NO-ERROR.
        IF NOT AVAIL item-uni-estab THEN DO:
            CREATE tt-item-uni-estab.
            ASSIGN tt-item-uni-estab.it-codigo            = tt-itens.it-codigo
                   tt-item-uni-estab.cod-estabel          = tt-dados.cod-estab
                   tt-item-uni-estab.cod-estab-gestor     = "101"
                   tt-item-uni-estab.cod-comprado         = tt-itens.cod-comprado
                   tt-item-uni-estab.lote-multipl         = round(tt-itens.lote-mul-for / de-indice,2)
                   tt-item-uni-estab.res-for-comp         = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-uni-estab.horiz-fixo           = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-uni-estab.quant-segur          = tt-itens.quant-segur.        
            overlay(tt-item-uni-estab.char-1,10,1)  = "1". /* Reabastecimento Demanda */     
            overlay(tt-item-uni-estab.char-1,129,3) = string(tt-item-uni-estab.horiz-fixo).
            overlay(tt-item-uni-estab.char-1,132,1) = "1". /* Represa Demanda */
                  //OVERLAY (tt-item-uni-estab.char-1,1,2) = STRING (tb-pr-cc.mo-codigo,"99").

            run openQueryStatic in h-boin684 ("Main").
            run setRecord       in h-boin684 (input table tt-item-uni-estab).
            RUN validateRecord  in h-boin684 (input "Create").

            IF RETURN-VALUE = "OK":U then DO:
                run createRecord    in h-boin684.
                run getRowErrors    in h-boin684 (output table RowErrors).
                if temp-table RowErrors:has-records then do:
                    ASSIGN v-rec-item-uni-estab = ?.                    
                    for each RowErrors:
                        // MESSAGE "cria item-uni-estab: " RowErrors.ErrorNumber VIEW-AS ALERT-BOX.
                        create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                       + " (proc. create1 it x estab)".
                     end.
                     run emptyRowErrors  in h-boin684.
                     delete procedure h-boin684 no-error.
                     undo, return "NOK".
                end.
                ELSE DO:
                    FIND item-uni-estab OF tt-item-uni-estab NO-LOCK NO-ERROR.
                    IF AVAIL item-uni-estab THEN
                        ASSIGN v-rec-item-uni-estab = RECID (item-uni-estab).
                END.
            END.
            else do:
                run getRowErrors    in h-boin684 (output table RowErrors).
                if temp-table RowErrors:has-records then do:
                    ASSIGN v-rec-item-uni-estab = ?.                    
                    for each RowErrors:
                        // MESSAGE "cria item-uni-estab: " RowErrors.ErrorNumber VIEW-AS ALERT-BOX.
                        create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                       + " (proc. create2 it x estab)".
                     end.
                     run emptyRowErrors  in h-boin684.
                     delete procedure h-boin684 no-error.
                     undo, return "NOK".
                end.
            end.

            empty temp-table tt-item-uni-estab.
        END.
        ELSE DO:
            ASSIGN v-rec-item-uni-estab = RECID (item-uni-estab).

            create tt-item-uni-estab.
            buffer-copy item-uni-estab to tt-item-uni-estab
                assign tt-item-uni-estab.r-Rowid = rowid(item-uni-estab).
        END.
        
        FIND item-uni-estab NO-LOCK
            WHERE RECID (item-uni-estab) = v-rec-item-uni-estab NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:
            find current tt-item-uni-estab no-error.

            if not avail tt-item-uni-estab
            then CREATE tt-item-uni-estab.

            ASSIGN tt-item-uni-estab.r-Rowid              = ROWID (item-uni-estab)
                   tt-item-uni-estab.it-codigo            = tt-itens.it-codigo
                   tt-item-uni-estab.cod-estabel          = tt-dados.cod-estab
                   tt-item-uni-estab.cod-estab-gestor     = "101"
                   tt-item-uni-estab.cod-comprado         = tt-itens.cod-comprado                   
                   tt-item-uni-estab.res-for-comp         = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-uni-estab.horiz-fixo           = tt-itens.tempo-ressup + tt-itens.res-for-comp                   
            overlay(tt-item-uni-estab.char-1,10,1)  = "1". /* Reabastecimento Demanda */ 
            overlay(tt-item-uni-estab.char-1,129,3) = string(tt-item-uni-estab.horiz-fixo).
            overlay(tt-item-uni-estab.char-1,132,1) = "1". /* Represa Demanda */
                  //OVERLAY (tt-item-uni-estab.char-1,1,2) = STRING (tb-pr-cc.mo-codigo,"99").

            IF l-atualiza-lote THEN
                ASSIGN tt-item-uni-estab.lote-multipl         = round(tt-itens.lote-mul-for / de-indice,2).

            IF tt-itens.atual-quant-segur THEN
                ASSIGN tt-item-uni-estab.quant-segur          = tt-itens.quant-segur.

            if  item.ge-codigo <> 40
            and item.ge-codigo <> 42
            and item.ge-codigo <> 45 then DO:

                IF l-atualiza-lote THEN
                    ASSIGN tt-item-uni-estab.lote-minimo = round(tt-itens.lote-minimo / de-indice,2).
            END.
            else do:
                if item.ge-codigo <> 42 THEN DO:
                    IF l-atualiza-lote THEN
                        ASSIGN tt-item-uni-estab.lote-minimo = round(tt-itens.lote-minimo / de-indice,2).
                END.

                case item.ge-codigo:
                    when 40
                    then assign c-cod-modelo = "IND".                        
                    when 42
                    then assign c-cod-modelo = "CKD".
                    when 45
                    then assign c-cod-modelo = "OEM".
                end case.

                for first int-modelo no-lock
                    where int-modelo.cod-modelo = c-cod-modelo:
                    for first int-item-uni-estab 
                        WHERE int-item-uni-estab.cod-estabel = tt-item-uni-estab.cod-estabel
                          AND int-item-uni-estab.it-codigo   = tt-item-uni-estab.it-codigo 
                              exclusive-lock: end.
    
                    if not avail int-item-uni-estab
                    then do:
                         create int-item-uni-estab.
                         assign int-item-uni-estab.cod-estabel = tt-item-uni-estab.cod-estabel
                                int-item-uni-estab.it-codigo   = tt-item-uni-estab.it-codigo.
                    end.  

                    assign int-item-uni-estab.cod-modelo = int-modelo.cod-modelo.

                    if int-modelo.log-aps then do:

                        if item.ge-codigo = 42 THEN DO: 
                            IF l-atualiza-lote THEN
                                assign int-item-uni-estab.qtd-min-comp = round(tt-itens.lote-minimo / de-indice,2).
                        END.
                        else.                        
                    END.
                    else assign int-item-uni-estab.qtd-min-comp     = 0
                                int-item-uni-estab.qtd-min-fab      = 0
                                int-item-uni-estab.num-dias-cob-mp  = 0
                                int-item-uni-estab.num-dias-alvo-mp = 0.
                end. /* for first int-modelo */

                find current int-item-uni-estab no-lock no-error.
                release int-item-uni-estab.
            END. //else do
                
            assign i-cod-maior-fornecedor = ?.
            
            FOR EACH b-item-fornec-estab use-index item-estab NO-LOCK 
                WHERE b-item-fornec-estab.it-codigo   = tt-item-uni-estab.it-codigo
                  and b-item-fornec-estab.cod-estabel = tt-dados.cod-estab
                  and b-item-fornec-estab.perc-compra > tt-itens.perc-compra
                   BY b-item-fornec-estab.perc-compra desc:
                ASSIGN i-cod-maior-fornecedor = b-item-fornec-estab.cod-emitente.
                leave.
            END. //for each b-item-fornec-estab
            IF i-cod-maior-fornecedor <> ? THEN DO:
                FIND b-emitente NO-LOCK WHERE b-emitente.cod-emitente = i-cod-maior-fornecedor NO-ERROR.
                IF AVAIL b-emitente THEN
                     ASSIGN tt-item-uni-estab.tp-desp-padrao = b-emitente.tp-desp-padrao.
                else assign tt-item-uni-estab.tp-desp-padrao = emitente.tp-desp-padrao.
            END. //if i-cod-maior-fornecedor
            else assign tt-item-uni-estab.tp-desp-padrao = emitente.tp-desp-padrao.

            /* Atualiza item-uni-estab */
            IF NOT VALID-HANDLE(h-boin684) THEN
                run inbo/boin684.p persistent set h-boin684.

            run openQueryStatic in h-boin684 ("Main").
            RUN emptyRowErrors IN h-boin684.

            RUN goToKey IN h-boin684 (INPUT tt-item-uni-estab.it-codigo, INPUT tt-item-uni-estab.cod-estabel).

            IF RETURN-VALUE = "OK":U THEN do:                
                RUN setRecord IN h-boin684 (INPUT TABLE tt-item-uni-estab).   
                RUN updateRecord IN h-boin684.
                RUN validateRecord in h-boin684 (input "Update").
                run getRowErrors    in h-boin684 (output table RowErrors).
                if temp-table RowErrors:has-records then do: 
                    for each RowErrors:
                        // MESSAGE "atualiza item-uni-estab: " RowErrors.ErrorNumber VIEW-AS ALERT-BOX.
                        create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                       + " (proc. update it x estab)".
                     end.
                     run emptyRowErrors  in h-boin684.
                     delete procedure h-boin684 no-error.
                     undo, return "NOK".
                end.                
            end.            

        END.  

        ASSIGN item.cod-comprado = tt-itens.cod-comprado               
               item.res-for-comp = tt-itens.tempo-ressup + tt-itens.res-for-comp
               item.horiz-fixo   = tt-itens.tempo-ressup + tt-itens.res-for-comp.

        IF l-atualiza-lote THEN
            ASSIGN item.lote-multipl = round(tt-itens.lote-mul-for / de-indice,2).

        IF tt-itens.atual-quant-segur THEN                
            ASSIGN item.quant-segur  = tt-itens.quant-segur.

        IF NOT CAN-FIND (FIRST item-uni-estab NO-LOCK WHERE item-uni-estab.it-codigo   = tt-itens.it-codigo AND
                                                            item-uni-estab.cod-estabel = tt-dados.cod-estab) THEN DO:
            RUN pi-cria-erro("Item " + tt-itens.it-codigo + " N∆o Relacionado ao Estab " + STRING(tt-dados.cod-estab)).
            undo, RETURN "NOK".
        END. //if not can-find

        // MESSAGE "2 item-fornec: " tt-itens.it-codigo VIEW-AS ALERT-BOX.

        //Atualizar Dados dos Itens Fornec
        IF NOT VALID-HANDLE(h-boin178) THEN
           RUN inbo/boin178.p PERSISTENT SET h-boin178.

        assign c-item-do-forn-aux = "".
        EMPTY TEMP-TABLE tt-item-fornec.
        FIND item-fornec EXCLUSIVE-LOCK 
            WHERE item-fornec.it-codigo    = tt-itens.it-codigo
              AND item-fornec.cod-emitente = tt-dados.cod-emitente NO-ERROR.
        IF NOT AVAIL item-fornec THEN DO:
            /* Cria item-fornec */
            CREATE tt-item-fornec.
            ASSIGN tt-item-fornec.it-codigo    = tt-itens.it-codigo
                   tt-item-fornec.cod-emitente = tt-dados.cod-emitente
                   tt-item-fornec.classe-repro = 4 //N∆o Reprograma
                   tt-item-fornec.ativo        = TRUE
                   tt-item-fornec.cot-aut      = TRUE
                  //tt-item-fornec.perc-compra  = tt-itens.perc-compra
                   tt-item-fornec.fator-conver = tt-itens.fator-conver
                   tt-item-fornec.num-casa-dec = tt-itens.num-casa-dec
                   tt-item-fornec.item-do-forn = if  tt-itens.item-do-forn <> ""
                                                 and tt-itens.item-do-forn <> ?
                                                 then tt-itens.item-do-forn
                                                 else string(tt-dados.cod-emitente) //tt-itens.it-codigo
                   c-item-do-forn-aux          = string(tt-dados.cod-emitente)
                   tt-item-fornec.unid-med-for = tt-itens.unid-med-for
                   tt-item-fornec.lote-minimo  = tt-itens.lote-minimo
                   tt-item-fornec.lote-mul-for = tt-itens.lote-mul-for
                   tt-item-fornec.cod-cond-pag = tt-itens.cod-cond-pag
                   tt-item-fornec.tempo-ressup = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-fornec.horiz-fixo   = tt-itens.tempo-ressup + tt-itens.res-for-comp.
/*             IF tt-item-fornec.perc-compra = 0 THEN   */
/*                 ASSIGN tt-item-fornec.ativo = FALSE. */

            RUN openQueryStatic IN h-boin178 (INPUT "main":U).
            RUN emptyRowErrors IN h-boin178.

            RUN setRecord IN h-boin178 (INPUT TABLE tt-item-fornec).
            RUN validateRecord in h-boin178 (input "Create").

            IF RETURN-VALUE = "OK":U then DO:
                RUN createRecord IN h-boin178. 
                run getRowErrors    in h-boin178 (output table RowErrors).
                if temp-table RowErrors:has-records then do:
                    ASSIGN v-rec-item-fornec = ?.
                    for each RowErrors:
                       create tt-erros-geral.
                       assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                       + " (proc. create1 it x fornec)".
                     end.
                     run emptyRowErrors  in h-boin178.
                     delete procedure h-boin178 no-error.
                     undo, return "NOK".
                end.
                ELSE DO:
                    FIND item-fornec OF tt-item-fornec NO-LOCK NO-ERROR.
                    IF AVAIL item-fornec THEN
                        ASSIGN v-rec-item-fornec = RECID (item-fornec).
                END.
            END. /* IF NOT AVAIL item-fornec */          
            ELSE DO:
                run getRowErrors    in h-boin178 (output table RowErrors).
                if temp-table RowErrors:has-records then do:
                    ASSIGN v-rec-item-fornec = ?.
                    for each RowErrors:
                       create tt-erros-geral.
                       assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                       + " (proc. create2 it x fornec)".
                       // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                     end.
                     run emptyRowErrors  in h-boin178.
                     delete procedure h-boin178 no-error.
                     undo, return "NOK".
                end.
                ELSE DO:
                    FIND item-fornec OF tt-item-fornec NO-LOCK NO-ERROR.
                    IF AVAIL item-fornec THEN
                        ASSIGN v-rec-item-fornec = RECID (item-fornec).
                END.
            END. /* else do */

            empty temp-table tt-item-fornec.
        END.
        ELSE DO:
            ASSIGN v-rec-item-fornec = RECID (item-fornec).

            create tt-item-fornec.
            buffer-copy item-fornec to tt-item-fornec
                assign tt-item-fornec.r-Rowid = rowid(item-fornec).

            if can-find(first int-item-for-pn where
                              int-item-for-pn.it-codigo    = item-fornec.it-codigo
                          and int-item-for-pn.cod-emitente = item-fornec.cod-emitente
                              no-lock)
            then assign c-item-do-forn-aux = ?. /* mantÇm original, conforme UPC */
        END. /* else do */

        FIND item-fornec NO-LOCK
            WHERE RECID (item-fornec) = v-rec-item-fornec NO-ERROR.
        IF AVAIL item-fornec THEN DO:
            find current tt-item-fornec no-error.

            if not avail tt-item-fornec
            then CREATE tt-item-fornec.

            ASSIGN tt-item-fornec.r-Rowid      = ROWID (item-fornec)
                   tt-item-fornec.it-codigo    = tt-itens.it-codigo
                   tt-item-fornec.cod-emitente = tt-dados.cod-emitente
                   tt-item-fornec.classe-repro = 4 //N∆o Reprograma
                   tt-item-fornec.ativo        = TRUE
                   tt-item-fornec.cot-aut      = TRUE
                  //tt-item-fornec.perc-compra  = tt-itens.perc-compra
                   tt-item-fornec.fator-conver = tt-itens.fator-conver
                   tt-item-fornec.num-casa-dec = tt-itens.num-casa-dec                   
                   tt-item-fornec.unid-med-for = tt-itens.unid-med-for                   
                   tt-item-fornec.cod-cond-pag = tt-itens.cod-cond-pag
                   tt-item-fornec.tempo-ressup = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-fornec.horiz-fixo   = tt-itens.tempo-ressup + tt-itens.res-for-comp.
/*             IF tt-item-fornec.perc-compra = 0 THEN   */
/*                 ASSIGN tt-item-fornec.ativo = FALSE. */

            IF c-item-do-forn-aux NE ? THEN DO.
                ASSIGN tt-item-fornec.item-do-forn = if  tt-itens.item-do-forn <> ""
                                                     and tt-itens.item-do-forn <> ?
                                                    then tt-itens.item-do-forn
                                                    else string(tt-dados.cod-emitente). //tt-itens.it-codigo*/ 
            END.

            IF l-atualiza-lote THEN
                ASSIGN tt-item-fornec.lote-minimo  = tt-itens.lote-minimo
                       tt-item-fornec.lote-mul-for = tt-itens.lote-mul-for.

            /* Atualiza item-fornec */
            IF NOT VALID-HANDLE(h-boin178) THEN
               RUN inbo/boin178.p PERSISTENT SET h-boin178.

            run openQueryStatic in h-boin178("Main").

            RUN emptyRowErrors IN h-boin178.
            RUN goToKey IN h-boin178(INPUT tt-item-fornec.it-codigo,INPUT tt-item-fornec.cod-emitente).

            IF RETURN-VALUE = "OK":U THEN do:
                RUN setRecord IN h-boin178 (INPUT TABLE tt-item-fornec).   
                RUN updateRecord IN h-boin178.
            END.
            run getRowErrors    in h-boin178 (output table RowErrors).
            if temp-table RowErrors:has-records then do:
                ASSIGN v-rec-item-fornec = ?.
                for each RowErrors:
                   create tt-erros-geral.
                   assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                           tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                   + " (proc. update it x fornec)".
                 end.
                 run emptyRowErrors  in h-boin178.
                 delete procedure h-boin178 no-error.
                 undo, return "NOK".
            end.

            if c-item-do-forn-aux <> ?
            then do:
                 for first int-item-for-pn
                     where int-item-for-pn.it-codigo    = tt-itens.it-codigo
                       and int-item-for-pn.cod-emitente = tt-dados.cod-emitente
                           exclusive-lock: end.

                 if not avail int-item-for-pn
                 then do:
                      create int-item-for-pn.
                      assign int-item-for-pn.it-codigo    = tt-itens.it-codigo
                             int-item-for-pn.cod-emitente = tt-dados.cod-emitente.
                 end.

                 assign int-item-for-pn.item-do-for = c-item-do-forn-aux.
                 find current int-item-for-pn no-lock no-error.
                 release int-item-for-pn.
            end. /* if c-item-do-for-aux <> ? */
        END.

        // MESSAGE "3 item-fornec-estab: " tt-itens.it-codigo VIEW-AS ALERT-BOX.
        /* Cria tt-item-fornec-estab */
        IF NOT VALID-HANDLE(h-boin688) THEN
            run inbo/boin688.p persistent set h-boin688.
        run openQueryStatic in h-boin688("Main").

        if tt-itens.perc-compra >= 100
        then for each item-fornec-estab no-lock
                where item-fornec-estab.it-codigo     = tt-itens.it-codigo
                  and item-fornec-estab.cod-emitente <> tt-dados.cod-emitente
                  and item-fornec-estab.cod-estabel   = tt-dados.cod-estab
                  and (item-fornec-estab.ativo        = yes or
                       item-fornec-estab.perc-compra  > 0):
                 run pi-zera-fornec (input h-boin688).

                 if return-value <> "OK":U
                 then undo, return "NOK".
             end. /* for each item-fornec-estab */

        EMPTY TEMP-TABLE tt-item-fornec-estab.
        FIND FIRST item-fornec-estab NO-LOCK 
            WHERE item-fornec-estab.it-codigo    = tt-itens.it-codigo
              AND item-fornec-estab.cod-emitente = tt-dados.cod-emitente
              AND item-fornec-estab.cod-estabel  = tt-dados.cod-estab NO-ERROR.
        IF NOT AVAIL item-fornec-estab THEN DO:
            FIND item-fornec NO-LOCK
                WHERE RECID (item-fornec) = v-rec-item-fornec NO-ERROR.
            IF AVAIL item-fornec THEN DO:
                create tt-item-fornec-estab.
                buffer-copy item-fornec to tt-item-fornec-estab
                ASSIGN tt-item-fornec-estab.cod-estabel = tt-dados.cod-estab
                       tt-item-fornec-estab.cod-cond-pag = tt-itens.cod-cond-pag
                       tt-item-fornec-estab.classe-repro = 4 //N∆o Reprograma
                       tt-item-fornec-estab.ativo        = TRUE
                       tt-item-fornec-estab.cot-aut      = TRUE
                       tt-item-fornec-estab.perc-compra  = tt-itens.perc-compra
                       tt-item-fornec-estab.lote-minimo  = tt-itens.lote-minimo
                       tt-item-fornec-estab.lote-mul-for = tt-itens.lote-mul-for                  
                       tt-item-fornec-estab.tempo-ressup = tt-itens.tempo-ressup + tt-itens.res-for-comp
                       tt-item-fornec-estab.horiz-fixo   = tt-itens.tempo-ressup + tt-itens.res-for-comp.
                if avail tb-pr-cc
                then OVERLAY (tt-item-fornec-estab.char-1,1,2) = STRING (tb-pr-cc.mo-codigo).
/*                 IF tt-item-fornec-estab.perc-compra = 0 THEN   */
/*                     ASSIGN tt-item-fornec-estab.ativo = FALSE. */
            END.
            
            RUN emptyRowErrors  IN h-boin688.
            run setRecord       in h-boin688(input table tt-item-fornec-estab).
            RUN validateRecord in h-boin688 (input "Create").
            // MESSAGE "create item-fornec-estab: " RETURN-VALUE VIEW-AS ALERT-BOX.
            IF RETURN-VALUE = "OK":U then DO:
                 RUN createRecord IN h-boin688. 
                 run getRowErrors    in h-boin688(output table RowErrors).
                if temp-table RowErrors:has-records then do:
                    ASSIGN v-rec-item-fornec-estab = ?.
                    for each RowErrors:
                        create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                       + " (proc. create1 it x fornec x estab)".
                        // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                    end.
                    run emptyRowErrors  in h-boin688.
                    delete procedure h-boin688 no-error.
                    undo, return "NOK".
                end.
                ELSE DO:
                    FIND item-fornec-estab OF tt-item-fornec-estab NO-LOCK NO-ERROR.
                    IF AVAIL item-fornec-estab THEN
                        ASSIGN v-rec-item-fornec-estab = RECID (item-fornec-estab).
                END.
            END.
            ELSE DO:
               run getRowErrors  in h-boin688(output table RowErrors).
               if temp-table RowErrors:has-records then do:                   
                   ASSIGN v-rec-item-fornec-estab = ?.
                   for each RowErrors:
                       create tt-erros-geral.
                       assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                              tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                      + " (proc. create2 it x fornec x estab)".
                       //undo, RETURN "NOK".
                   end.
                   run emptyRowErrors  in h-boin688.
                   delete procedure h-boin688 no-error.
                   undo, return "NOK".
               end.
            END.

            EMPTY TEMP-TABLE tt-item-fornec-estab.
        END.
        ELSE DO:
            ASSIGN v-rec-item-fornec-estab = RECID (item-fornec-estab).

            create tt-item-fornec-estab.
            buffer-copy item-fornec-estab to tt-item-fornec-estab
                assign tt-item-fornec-estab.r-Rowid = rowid(item-fornec-estab).
        END.


        FIND item-fornec-estab NO-LOCK
             WHERE RECID (item-fornec-estab) = v-rec-item-fornec-estab NO-ERROR.
        IF AVAIL item-fornec-estab THEN DO:   
            find current tt-item-fornec-estab no-error.

            if not avail tt-item-fornec-estab
            then CREATE tt-item-fornec-estab.

            ASSIGN tt-item-fornec-estab.r-Rowid      = ROWID (item-fornec-estab)
                   tt-item-fornec-estab.it-codigo    = tt-itens.it-codigo
                   tt-item-fornec-estab.cod-emitente = tt-dados.cod-emitente
                   tt-item-fornec-estab.cod-estabel  = tt-dados.cod-estab
                   tt-item-fornec-estab.cod-cond-pag = tt-itens.cod-cond-pag
                   tt-item-fornec-estab.classe-repro = 4 //N∆o Reprograma
                   tt-item-fornec-estab.ativo        = TRUE
                   tt-item-fornec-estab.cot-aut      = TRUE
                   tt-item-fornec-estab.perc-compra  = tt-itens.perc-compra                   
                   tt-item-fornec-estab.tempo-ressup = tt-itens.tempo-ressup + tt-itens.res-for-comp
                   tt-item-fornec-estab.horiz-fixo   = tt-itens.tempo-ressup + tt-itens.res-for-comp.
            if avail tb-pr-cc
            then OVERLAY (tt-item-fornec-estab.char-1,1,2) = STRING (tb-pr-cc.mo-codigo).
/*             IF tt-item-fornec-estab.perc-compra = 0 THEN   */
/*                 ASSIGN tt-item-fornec-estab.ativo = FALSE. */

            IF l-atualiza-lote THEN
                ASSIGN tt-item-fornec-estab.lote-minimo  = tt-itens.lote-minimo
                       tt-item-fornec-estab.lote-mul-for = tt-itens.lote-mul-for.

            /* Atualiza item-fornec-estab */
            IF NOT VALID-HANDLE(h-boin688) THEN
                run inbo/boin688.p persistent set h-boin688.
            
            run openQueryStatic in h-boin688("Main").
            RUN emptyRowErrors  IN h-boin688.

            RUN goToKey IN h-boin688 (INPUT tt-item-fornec-estab.it-codigo, INPUT tt-item-fornec-estab.cod-emitente, INPUT tt-item-fornec-estab.cod-estab).            

            // MESSAGE "update item-fornec-estab: " RETURN-VALUE VIEW-AS ALERT-BOX.
            IF RETURN-VALUE = "OK":U THEN do:
                RUN setRecord IN h-boin688 (INPUT TABLE tt-item-fornec-estab).   
                RUN updateRecord IN h-boin688.
                run getRowErrors    in h-boin688(output table RowErrors).                
                if temp-table RowErrors:has-records then do:                    
                    for each RowErrors:                        
                        create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                       + " (proc. update1 it x fornec x estab)".
                        //MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                     end.
                     run emptyRowErrors  in h-boin688.
                     delete procedure h-boin688 no-error.
                     UNDO, return "NOK".
                end.
            end. 
            ELSE DO:
                run getRowErrors in h-boin688(output table RowErrors).
                if temp-table RowErrors:has-records then do:                    
                    for each RowErrors:
                       // MESSAGE "item-fornec-estab2: " RowErrors.ErrorNumber VIEW-AS ALERT-BOX.
                       create tt-erros-geral.
                        assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                               tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                       + " (proc. update2 it x fornec x estab)".
                        // MESSAGE tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                     end.
                     run emptyRowErrors  in h-boin688.
                     delete procedure h-boin688 no-error.
                     UNDO, return "NOK".
                end.
            END.
        END.
        // item-fornec-estab

        // MESSAGE "4 item-tab: " tt-itens.it-codigo VIEW-AS ALERT-BOX.

        /* Cria e Atualiza item-tab */
        IF NOT VALID-HANDLE(h-boin185) THEN
           RUN inbo/boin185.p PERSISTENT SET h-boin185.

        IF v-rec-tb-pr-cc <> ? THEN DO:
            FIND tb-pr-cc NO-LOCK
                WHERE RECID (tb-pr-cc) = v-rec-tb-pr-cc NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST tb-pr-cc NO-LOCK 
                WHERE tb-pr-cc.cod-emitente = tt-dados.cod-emitente
                  AND tb-pr-cc.cdn-fabrican = 0
                  AND tb-pr-cc.cod-cond-pag = tt-itens.cod-cond-pag
                  AND tb-pr-cc.nr-tab       = tt-dados.cod-estab
                  AND tb-pr-cc.dt-inicio    = tt-dados.dt-inicio NO-ERROR.
        END.
       
        IF NOT AVAIL tb-pr-cc THEN DO:
            RUN pi-cria-erro ("Tabela de Preáos N∆o Encontrada para Fornecedor/Condiá∆o/Estab/Data de Inicio: " + STRING(tt-dados.cod-emitente) + "-" + STRING(tt-itens.cod-cond-pag) + "-" + STRING(tt-dados.cod-estab) + "-" + STRING(tt-dados.dt-inicio)).
            undo, RETURN "NOK".
        END.
        ELSE DO:
            ASSIGN v-rec-tb-pr-cc = RECID (tb-pr-cc).
        END.

        assign de-pr-item = ?.
        EMPTY TEMP-TABLE tt-item-tab.
        FIND FIRST item-tab EXCLUSIVE-LOCK 
            WHERE item-tab.cod-emitente   = tb-pr-cc.cod-emitente
              AND item-tab.cdn-fabrican   = tb-pr-cc.cdn-fabrican
              AND item-tab.des-referencia = ""
              AND item-tab.cod-cond-pag   = tb-pr-cc.cod-cond-pag
              AND item-tab.nr-tab         = tb-pr-cc.nr-tab
              AND item-tab.dt-inicio      = tb-pr-cc.dt-inicio
              AND item-tab.it-codigo      = tt-itens.it-codigo
              AND item-tab.quant-min      = 0 NO-ERROR.
        IF NOT AVAIL item-tab THEN DO:
            // MESSAGE "N∆o achou Item-tab" VIEW-AS ALERT-BOX.
            CREATE tt-item-tab.
            ASSIGN tt-item-tab.cod-emitente   = tb-pr-cc.cod-emitente
                   tt-item-tab.cdn-fabrican   = tb-pr-cc.cdn-fabrican
                   tt-item-tab.des-referencia = ""                   
                   tt-item-tab.cod-cond-pag   = tb-pr-cc.cod-cond-pag
                   tt-item-tab.nr-tab         = tb-pr-cc.nr-tab      
                   tt-item-tab.dt-inicio      = tb-pr-cc.dt-inicio
                   tt-item-tab.it-codigo      = tt-itens.it-codigo
                   tt-item-tab.cod-estabel    = tb-pr-cc.cod-estabel
                   tt-item-tab.mo-codigo      = tb-pr-cc.mo-codigo
                   tt-item-tab.quant-min      = 0 
                   tt-item-tab.situacao       = tb-pr-cc.situacao
                   tt-item-tab.frete          = tb-pr-cc.frete
                   tt-item-tab.valor-frete    = tb-pr-cc.valor-frete
                   tt-item-tab.pr-item      = tt-itens.pr-item
                   tt-item-tab.aliquota-ipi = tt-itens.aliquota-ipi
                   tt-item-tab.aliquota-icm = tt-itens.aliquota-icm.

            find first emitente 
               where emitente.cod-emitente = tt-item-tab.cod-emitente no-lock no-error.
            IF AVAIL emitente THEN
               assign tt-item-tab.nome-abrev = emitente.nome-abrev.

            /* Cria item-tab */
            RUN openQueryStatic IN h-boin185 (INPUT "main":U).
            RUN emptyRowErrors IN h-boin185.

            RUN setRecord IN h-boin185 (INPUT TABLE tt-item-tab).
            RUN validateRecord in h-boin185 (input "Create").

            IF RETURN-VALUE = "OK":U then
                RUN createRecord IN h-boin185. 

            run getRowErrors    in h-boin185 (output table RowErrors).
            if temp-table RowErrors:has-records then do:                    
                for each RowErrors:
                   create tt-erros-geral.
                   assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                           tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                   + " (proc. create item tabela)".
                   // MESSAGE "Item Tab erro: " tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                 end.
                 run emptyRowErrors  in h-boin185.
                 delete procedure h-boin185 no-error.
                 undo, return "NOK".
            end.
        END. /* if not avail item-tab */
        ELSE DO: 
            assign de-pr-item = item-tab.pr-item.
            CREATE tt-item-tab.
            ASSIGN tt-item-tab.cod-emitente   = tb-pr-cc.cod-emitente
                   tt-item-tab.cdn-fabrican   = tb-pr-cc.cdn-fabrican
                   tt-item-tab.des-referencia = ""                   
                   tt-item-tab.cod-cond-pag   = tb-pr-cc.cod-cond-pag
                   tt-item-tab.nr-tab         = tb-pr-cc.nr-tab      
                   tt-item-tab.dt-inicio      = tb-pr-cc.dt-inicio
                   tt-item-tab.it-codigo      = tt-itens.it-codigo
                   tt-item-tab.cod-estabel    = tb-pr-cc.cod-estabel
                   tt-item-tab.mo-codigo      = tb-pr-cc.mo-codigo
                   tt-item-tab.quant-min      = 0 
                   tt-item-tab.situacao       = tb-pr-cc.situacao
                   tt-item-tab.frete          = tb-pr-cc.frete
                   tt-item-tab.valor-frete    = tb-pr-cc.valor-frete
                   tt-item-tab.pr-item      = tt-itens.pr-item
                   tt-item-tab.aliquota-ipi = tt-itens.aliquota-ipi
                   tt-item-tab.aliquota-icm = tt-itens.aliquota-icm.

            find first emitente NO-LOCK
               where emitente.cod-emitente = tt-item-tab.cod-emitente no-error.
            IF AVAIL emitente THEN
               assign tt-item-tab.nome-abrev = emitente.nome-abrev.
            /*
            MESSAGE "Item: "  tt-item-tab.it-codigo    SKIP
                    "Nome: "  tt-item-tab.nome-abrev   SKIP
                    "Cond: "  tt-item-tab.cod-cond-pag SKIP
                    "Tab: "   tt-item-tab.nr-tab       SKIP
                    "Min: "   tt-item-tab.quant-min    SKIP
                    "Est: "   tt-item-tab.cod-estabel  SKIP
                    "Moeda: " tt-item-tab.mo-codigo
                    VIEW-AS ALERT-BOX.
            */       
            run openQueryStatic in h-boin185 ("Main").
            RUN emptyRowErrors IN h-boin185.
            RUN goToKey IN h-boin185 (INPUT tt-item-tab.it-codigo,
                                      INPUT tt-item-tab.nome-abrev,
                                      INPUT tt-item-tab.cod-cond-pag,
                                      INPUT tt-item-tab.nr-tab,
                                      INPUT tt-item-tab.quant-min,
                                      INPUT tt-item-tab.cod-estabel,
                                      INPUT tt-item-tab.mo-codigo).            
            IF RETURN-VALUE = "OK":U THEN do:
                RUN setRecord IN h-boin185 (INPUT TABLE tt-item-tab).   
                RUN validateRecord in h-boin185 (input "Update").
                if return-value = "OK":U THEN 
                    RUN updateRecord IN h-boin185.
            end.

            run getRowErrors in h-boin185 (output table RowErrors).
            if temp-table RowErrors:has-records then do:                    
                for each RowErrors:
                   create tt-erros-geral.
                   assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                          tt-erros-geral.des-erro = RowErrors.ErrorDescription
                                                  + " (proc. update item tabela)".
                   // MESSAGE "Item Tab erro: " tt-erros-geral.des-erro VIEW-AS ALERT-BOX.
                 end.
                 run emptyRowErrors  in h-boin185.
                 delete procedure h-boin185 no-error.
                 undo, return "NOK".
            end.
        END. /* else do */

        IF  d-data-limite <> ?
        and de-pr-item    <> tt-itens.pr-item 
        THEN DO:
            FIND LAST int-item-tab EXCLUSIVE-LOCK
                WHERE int-item-tab.cod-emitente   = tt-item-tab.cod-emitente  
                  AND int-item-tab.cdn-fabrican   = tt-item-tab.cdn-fabrican  
                  AND int-item-tab.des-referencia = tt-item-tab.des-referencia
                  AND int-item-tab.cod-cond-pag   = tt-item-tab.cod-cond-pag  
                  AND int-item-tab.nr-tab         = tt-item-tab.nr-tab        
                  AND int-item-tab.dt-inicio      = tt-item-tab.dt-inicio     
                  AND int-item-tab.it-codigo      = tt-item-tab.it-codigo     
                  AND int-item-tab.quant-min      = tt-item-tab.quant-min NO-ERROR.

            if not avail int-item-tab
            then do:
                 create int-item-tab.
                 assign int-item-tab.cod-emitente   = tt-item-tab.cod-emitente
                        int-item-tab.cdn-fabrican   = tt-item-tab.cdn-fabrican
                        int-item-tab.des-referencia = tt-item-tab.des-referencia
                        int-item-tab.cod-cond-pag   = tt-item-tab.cod-cond-pag
                        int-item-tab.nr-tab         = tt-item-tab.nr-tab
                        int-item-tab.dt-inicio      = tt-item-tab.dt-inicio
                        int-item-tab.it-codigo      = tt-item-tab.it-codigo
                        int-item-tab.quant-min      = tt-item-tab.quant-min
                        int-item-tab.data           = today
                        int-item-tab.hora           = string(time, "HH:MM")
                        int-item-tab.cod-usuario    = c-seg-usuario
                        int-item-tab.tipo           = 1
                        int-item-tab.pr-item-atual  = ?
                        int-item-tab.pr-item-novo   = tt-item-tab.pr-item.
            end. /* if not avail int-item-tab */

            ASSIGN int-item-tab.data_limite   = d-data-limite
                   int-item-tab.justificativa = "Atualizaá∆o de Preáo conforme Integraá∆o Ariba".

            if not can-find(first tt-altera-preco where
                                  tt-altera-preco.it-codigo = tt-item-tab.it-codigo)
            then do:
                 for first item-fornec
                     where item-fornec.it-codigo    = tt-item-tab.it-codigo
                       and item-fornec.cod-emitente = tt-item-tab.cod-emitente
                           no-lock: end.

                 create tt-altera-preco.
                 assign tt-altera-preco.it-codigo = tt-item-tab.it-codigo.
                 find current tt-altera-preco no-error.
                 release tt-altera-preco.

                 run pi-altera-ocs (input d-data-limite).
                 if return-value <> "OK"
                 then undo, return "NOK".
            end.
        END. /* IF d-data-limite <> ? */
   END. //for each tt-itens
   
   /* Elimina Item da Tabela que n∆o existe mais */
   FIND FIRST tb-pr-cc NO-LOCK
       WHERE RECID (tb-pr-cc) = v-rec-tb-pr-cc NO-ERROR.
   IF AVAIL tb-pr-cc THEN DO:
       FOR EACH item-tab OF tb-pr-cc EXCLUSIVE-LOCK:
           FIND FIRST tt-itens NO-LOCK
               WHERE tt-itens.it-codigo = item-tab.it-codigo NO-ERROR.
           IF NOT AVAIL tt-itens THEN DO:
               DELETE item-tab.
           END.
       END.
   END.

   return "OK".

   catch oStop AS Progress.Lang.StopError:
     do iNumMessages = 1 to oStop:nummessages:
         MESSAGE "Stop: " oStop:GetMessage(iNumMessages) VIEW-AS ALERT-BOX.
       run pi-cria-erro(oStop:GetMessage(iNumMessages)).
     end.
     return "NOK".
   end catch.
   catch eAnyError AS Progress.Lang.Error:
     do iNumMessages = 1 to eAnyError:nummessages:
       MESSAGE "AnyError: " eAnyError:GetMessage(iNumMessages) VIEW-AS ALERT-BOX.
       run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
     end.
     return "NOK".
   end catch.

   FINALLY:
       FIND CURRENT ITEM NO-LOCK NO-ERROR.
       RELEASE ITEM.
   END.

END PROCEDURE.

procedure pi-altera-ocs:
    def input param p-data-limite as date no-undo.

    def var de-fator-conver as deci no-undo.
    def var lg-codigo-ipi   as logi no-undo.
    def var lg-passou       as logi no-undo.
        
    assign de-fator-conver = item-fornec.fator-conver / exp(10,item-fornec.num-casa-dec)
           lg-codigo-ipi   = yes.

    if avail tb-pr-cc
    then assign lg-codigo-ipi = tb-pr-cc.codigo-ipi.

    empty temp-table tt-versao-integr.
    empty temp-table tt-pedido-compr.
    empty temp-table tt-cond-especif.
    empty temp-table tt-ordem-compra.
    empty temp-table tt-prazo-compra.
    empty temp-table tt-cotacao-item.
    empty temp-table tt-desp-cotacao-item.
    empty temp-table tt-erros-geral.

    blk-oc:
    for each ordem-compra use-index estab-item-sit no-lock
       where ordem-compra.cod-estabel  = tt-dados.cod-estab
         and ordem-compra.it-codigo    = item-fornec.it-codigo
         and ordem-compra.situacao     < 3
         and ordem-compra.cod-emitente = item-fornec.cod-emitente,
       first pedido-compr no-lock
       where pedido-compr.num-pedido = ordem-compra.num-pedido:
        if not can-find(first cotacao-item where 
                              cotacao-item.numero-ordem = ordem-compra.numero-ordem
                          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                          and cotacao-item.it-codigo    = ordem-compra.it-codigo
                          and cotacao-item.cot-aprovada
                              no-lock)
        then next blk-oc.

        if can-find(first prazo-compra where
                          prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      and prazo-compra.situacao     = 6 /* Recebida */
                          no-lock)
        then next blk-oc.

        blk-par:
        for each prazo-compra no-lock
           where prazo-compra.numero-ordem = ordem-compra.numero-ordem
             and prazo-compra.situacao    <> 4:
            empty temp-table tt-emb.
    
            for first ordens-embarque use-index ordem
                where ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                  and ordens-embarque.parcela      = prazo-compra.parcela
                      no-lock: end.
    
            if avail ordens-embarque
            then run pi-busca-posicao.
            
            for first tt-emb: end.
    
            if  avail tt-emb
            and tt-emb.situacao <> 99 /*AGT*/
            and tt-emb.situacao <> 96 /*INST*/
            and tt-emb.situacao <> 97 /*MANUT*/
            and tt-emb.situacao <> 1  /*PREV*/
            then do:
                 for each tt-prazo-compra
                    where tt-prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                     delete tt-prazo-compra.
                 end. /* for each tt-prazo-compra */

                 next blk-oc.
            end.

            IF  prazo-compra.situacao     < 3
            and prazo-compra.quant-saldo  > 0
            and prazo-compra.data-entrega >= p-data-limite
            THEN.
            ELSE NEXT blk-par.

            create tt-prazo-compra.
            buffer-copy prazo-compra to tt-prazo-compra
                assign tt-prazo-compra.ind-tipo-movto = 2.

            ASSIGN tt-prazo-compra.nome-abrev = "".
            find current tt-prazo-compra no-error.
            release tt-prazo-compra.
        end. /* for each prazo-compra */

        if not can-find(first tt-prazo-compra where
                              tt-prazo-compra.numero-ordem = ordem-compra.numero-ordem)
        then next blk-oc.

        if not can-find(first tt-pedido-compr where
                              tt-pedido-compr.num-pedido = pedido-compr.num-pedido)
        then do:
             create tt-pedido-compr.
             buffer-copy pedido-compr to tt-pedido-compr
                 assign tt-pedido-compr.ind-tipo-movto = 2.
             find current tt-pedido-compr no-error.
             release tt-pedido-compr.

             for first cond-especif no-lock
                 where cond-especif.num-pedido = pedido-compr.num-pedido:
                 create tt-cond-especif.
                 buffer-copy cond-especif to tt-cond-especif
                     assign tt-cond-especif.ind-tipo-movto = 2.
                 find current tt-cond-especif no-error.
                 release tt-cond-especif.
             end. /* for first cond-especif */
        end. /* if not can-find(first tt-pedido-compr */

        if not can-find(first tt-ordem-compra where
                              tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem)
        then do:
             create tt-ordem-compra.
             buffer-copy ordem-compra to tt-ordem-compra
                 assign tt-ordem-compra.ind-tipo-movto = 2.

             /* Altera - esccp047 */
             assign tt-ordem-compra.preco-unit = tt-item-tab.pr-item * de-fator-conver 
                    + if not lg-codigo-ipi then 
                    ((tt-item-tab.pr-item * de-fator-conver) * tt-item-tab.aliquota-ipi / 100)
                    else 0 
            
                    tt-ordem-compra.pre-unit-for = tt-item-tab.pr-item
                    + if not lg-codigo-ipi then 
                    ((tt-item-tab.pr-item) * tt-item-tab.aliquota-ipi / 100)
                    else 0 
                    tt-ordem-compra.preco-fornec = tt-item-tab.pr-item
                    tt-ordem-compra.aliquota-icm = tt-item-tab.aliquota-icm
                    tt-ordem-compra.aliquota-ipi = tt-item-tab.aliquota-ipi.
             find current tt-ordem-compra no-error.
             release tt-ordem-compra.
        end. /* if not can-find(first tt-ordem-compra */

        if not can-find(first tt-cotacao-item where
                              tt-cotacao-item.numero-ordem = ordem-compra.numero-ordem
                          and tt-cotacao-item.cod-emitente = pedido-compr.cod-emitente
                          and tt-cotacao-item.it-codigo    = ordem-compra.it-codigo) 
        then do:    
             for each cotacao-item no-lock
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                  and cotacao-item.cod-emitente = pedido-compr.cod-emitente
                  and cotacao-item.it-codigo    = ordem-compra.it-codigo:   
                 create tt-cotacao-item.
                 buffer-copy cotacao-item to tt-cotacao-item
                     assign tt-cotacao-item.ind-tipo-movto = 2.

                 /* Altera - esccp047 */
                 assign tt-cotacao-item.preco-unit = tt-item-tab.pr-item * de-fator-conver  
                        + if not lg-codigo-ipi then 
                        ((tt-item-tab.pr-item * de-fator-conver) * tt-item-tab.aliquota-ipi / 100)
                        else 0 
                        tt-cotacao-item.pre-unit-for = tt-item-tab.pr-item
                        + if not lg-codigo-ipi then 
                        ((tt-item-tab.pr-item) * tt-item-tab.aliquota-ipi / 100)
                        else 0 
                        tt-cotacao-item.preco-fornec = tt-item-tab.pr-item
                        tt-cotacao-item.aliquota-icm = tt-item-tab.aliquota-icm
                        tt-cotacao-item.aliquota-ipi = tt-item-tab.aliquota-ipi.
                
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
             end. /* for each cotacao-item */
                
             find current tt-cotacao-item no-error.
             release tt-cotacao-item.
             release tt-desp-cotacao-item.
       end. /* if not can-find(first tt-cotacao-item */
    end. /* for each ordem-compra */

    if not temp-table tt-ordem-compra:has-records
    then return "OK".

    create tt-versao-integr.
    assign tt-versao-integr.cod-versao-integracao = 1.
    find current tt-versao-integr no-error.
    release tt-versao-integr.
    
    run ccp/ccapi303.p(input  table tt-versao-integr,
                       output table tt-erros-geral append,
                       input  table tt-pedido-compr,
                       input  table tt-cond-especif,
                       input  table tt-ordem-compra,
                       input  table tt-prazo-compra,
                       input  table tt-cotacao-item,
                       input  table tt-desp-cotacao-item).
    
    /*for each tt-cotacao-item:
        for first cotacao-item exclusive-lock
            where cotacao-item.numero-ordem = tt-cotacao-item.numero-ordem
              and cotacao-item.cod-emitente = tt-cotacao-item.cod-emitente
              and cotacao-item.it-codigo    = tt-cotacao-item.it-codigo:
            //overlay(cotacao-item.char-1,21,20) = trim(string(tt-cotacao-item.cod-incoterm)).
            assign cotacao-item.cod-incoterm   = tt-cotacao-item.cod-incoterm.
        end. /* for first cotacao-item */
        find current cotacao-item no-lock no-error.
    end. /* for each tt-cotacao-item */*/
    
    if temp-table tt-erros-geral:has-records 
    then return "NOK".

    /* cria alt-ped? */

    return "OK".
end procedure.

PROCEDURE pi-busca-posicao :
    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1 /* N∆o Encerrado */
        AND   embarque-imp.cod-estabel = ordens-embarque.cod-estabel
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}   
        
    END. /* FOR EACH  embarque-imp NO-LOCK */
END PROCEDURE.

procedure pi-zera-fornec:
    define input parameter p-boin688 as handle no-undo.

    empty temp-table tt-item-fornec-estab.
    create tt-item-fornec-estab.
    buffer-copy item-fornec-estab to tt-item-fornec-estab
        assign tt-item-fornec-estab.ativo       = false
               tt-item-fornec-estab.perc-compra = 0
               tt-item-fornec-estab.contr-forn  = NO.
    
        
    run openQueryStatic in p-boin688("Main").
    run emptyRowErrors  in p-boin688.
    run goToKey in p-boin688 (input tt-item-fornec-estab.it-codigo, 
                              input tt-item-fornec-estab.cod-emitente, 
                              input tt-item-fornec-estab.cod-estab).

    if return-value = "OK"
    then do:
         run setRecord    in p-boin688 (input table tt-item-fornec-estab).   
         run updateRecord in p-boin688.
    end. /* if return-value = "OK" */

    if return-value <> "OK"
    then do:
         run getRowErrors in p-boin688(output table RowErrors).

         if temp-table RowErrors:has-records
         then for each RowErrors:
                  create tt-erros-geral.
                  assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                         tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + RowErrors.ErrorDescription
                                                 + " (proc. update0 it x fornec x estab)".
              end. /* for each RowErrors */
         else do:
              create tt-erros-geral.
              assign tt-erros-geral.cod-erro = 0
                     tt-erros-geral.des-erro = tt-itens.it-codigo + " - " + "N∆o foi poss°vel alterar item x fornec x estab (outros)".
         end. /* else do */

         run emptyRowErrors in p-boin688.

         undo, return "NOK".
    end. /* if return-value <> "OK" */

    return "OK".
end procedure. /* procedure pi-zera-fornec */

procedure pi-cria-erro:
   define input parameter p-des-erro as character no-undo.
   log-manager:write-message(p-des-erro, "ARIBA").
   create tt-erros-geral.
   assign tt-erros-geral.cod-erro = 17006
          tt-erros-geral.des-erro = p-des-erro.
   return "OK".
end procedure.

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) :
  def var c-funcao as char no-undo.

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) 
  then do:
       assign c-funcao = oJson:GetCharacter(cProperty) no-error.

       if error-status:error
       or c-funcao = ""
       then do:
            run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
            return "".
       end.

       return c-funcao.
  end.

  run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
  return "".
end function.

function fcGetInteger returns integer ( cProperty as character, oJson as JsonObject ) :
  def var i-funcao as inte no-undo.

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then do:
    assign i-funcao = integer(oJson:GetInt64(cProperty)) no-error.

    if error-status:error
    or i-funcao = 0
    then do:
        run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
        return 0.
    end.

    return i-funcao.
  end.

  run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
  return 0.
end function.

function fcGetDecimal returns decimal ( cProperty as character, oJson as JsonObject ) :
  def var de-funcao as deci no-undo.

  DEFINE VARIABLE cStr AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE power AS INTEGER     NO-UNDO.
  DEFINE VARIABLE base AS DECIMAL     NO-UNDO.  

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then do:      

      ASSIGN cStr = oJson:GetJsonText(cProperty).

      IF INDEX(cStr, "e") > 0 THEN DO: 
           ASSIGN base = DECIMAL(replace(SUBSTRING(cStr, 1, INDEX(cStr, "e") - 1),".",","))
           power = INTEGER(SUBSTRING(cStr, INDEX(cStr, "e") + 1 ))
           de-funcao = base * EXP(10, power).                               
      END.
      ELSE DO:
          ASSIGN de-funcao = decimal(oJson:GetDecimal(cProperty)) NO-ERROR.          
      END.
    
      if error-status:error
      or de-funcao = 0
      then do:          
          run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
          return 0.
      end.

      return de-funcao.
  end.

  IF cProperty = "conversion" THEN.
  ELSE DO:
      run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
  END.

  return 0.

end function.

function fcGetDate returns date ( cProperty as character, oJson as JsonObject ) :
  def var dt-funcao as date no-undo.

  assign cProperty = trim(cProperty).
  if oJson:has(cProperty) then do:
      assign dt-funcao = oJson:GetDate(cProperty) no-error.

      if error-status:error
      or dt-funcao = ?
      then do:
          run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv†lido", quoter(cProperty))).
          return ?.
      end.

      return dt-funcao.
  end.

  run pi-cria-erro(substitute("N∆o localizado propriedade &1 no json de entrada", quoter(cProperty))).
  return ?.
end function.

