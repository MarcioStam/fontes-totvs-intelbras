.block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi615.i}
{utp/ut-glob.i}

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define new global shared var l-esapi556 as logical no-undo.

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

def var i-purchaseOrder as inte no-undo.

function fcGetCharacter returns character ( cProperty as character, oJson as JsonObject ) forwards.
function fcGetInteger   returns integer   ( cProperty as character, oJson as JsonObject ) forwards.

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
    run pi-acompanhar in h-acomp ("Elimin Pedido de Compra").

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
           es-api-log.aux         = "Pedido de Venda " + string(i-purchaseOrder) + " eliminado com sucesso".
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
    run pi-delete-ped-buying.
    
    if return-value <> "OK" 
    then undo, return "NOK".

    return "OK".
END PROCEDURE. /* procedure pi-principal */

procedure pi-carga-json :
  define variable oRequestParser      as JsonAPIRequestParser no-undo.
  define variable jsonObjectPayload   as JsonObject           no-undo.
  define variable jsonArrayPathParams as JsonArray            no-undo.

  def var i-num-param  as inte no-undo.

  assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

  assign jsonArrayPathParams = new JsonArray().
  jsonArrayPathParams = oRequestParser:getPathParams() no-error.

  assign i-purchaseOrder = ?
         i-num-param     = jsonArrayPathParams:length no-error.

  if i-num-param <> 1 
  then do:
       run pi-cria-erro(input "Parƒmetros no link inv lidos").
       return "NOK". 
  end.

  assign i-purchaseOrder = inte(JsonAPIUtils:getPropertyJsonArray(jsonArrayPathParams, 1)) no-error.

  if error-status:error 
  or i-purchaseOrder = 0
  or i-purchaseOrder = ?
  then do:
       run pi-cria-erro("NÆo foi poss¡vel identificar informa‡äes de pedido de compra para integrar").
       return "NOK".
  end.

  for first pedido-compr 
      where pedido-compr.num-pedido = i-purchaseOrder
            no-lock: end.

  if not avail pedido-compr
  then do:
       run pi-cria-erro(substitute("Registro de Pedido nÆo localizado com o c¢digo &1 vindo da integra‡Æo", 
                                   quoter(i-purchaseOrder))).
       return "NOK".       
  end.

  if not can-find(first int-prazo-compra use-index ch-ariba where
                        int-prazo-compra.num-pedido = pedido-compr.num-pedido
                        no-lock)
  then do:
       run pi-cria-erro(substitute("Pedido Ariba com o c¢digo &1 nÆo foi criado via integra‡Æo", 
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
           run pi-cria-erro(substitute("Pedido Ariba com o c¢digo &1 possui OC nÆo criada via integra‡Æo Buying, como a &2", 
                                       quoter(ordem-compra.num-pedido),
                                       quoter(ordem-compra.numero-ordem))).
           return "NOK". 
      end.
  end. /* for each ordem-compra */

  if pedido-compr.situacao = 3 /* Eliminado */ 
  then do:
       run pi-cria-erro(substitute("Pedido &1 j  se encontra eliminado", 
                                   quoter(pedido-compr.num-pedido))).
       return "NOK".   
  end.

  if can-find(first ordem-compra use-index ordmcmpr_ix33 where
                    ordem-compra.num-pedido = pedido-compr.num-pedido
                and ordem-compra.situacao  <> 1
                and ordem-compra.situacao  <> 2
                and ordem-compra.situacao  <> 4
                and ordem-compra.situacao  <> 5                
                    no-lock)
  then do:
       run pi-cria-erro(substitute("Pedido &1 possui ao menos uma Ordem de Compra com situa‡Æo que impede a sua elimina‡Æo", 
                                   quoter(pedido-compr.num-pedido))).
       return "NOK".  
  end.

  if can-find(first ordem-compra use-index ordmcmpr_ix33 where
                    ordem-compra.num-pedido   = pedido-compr.num-pedido
                and ordem-compra.situacao    <> 4
                and ordem-compra.nr-contrato <> 0               
                    no-lock)
  then do:
       run pi-cria-erro(substitute("Pedido &1 possui ao menos uma Ordem de Compra com N£mero Contrato", 
                                   quoter(pedido-compr.num-pedido))).
       return "NOK".  
  end.

  if can-find(first ordem-compra use-index ordmcmpr_ix33 where
                    ordem-compra.num-pedido   = pedido-compr.num-pedido
                and ordem-compra.situacao    <> 4
                and ordem-compra.num-ord-inv <> 0               
                    no-lock)
  then do:
       run pi-cria-erro(substitute("Pedido &1 possui ao menos uma Ordem de Compra com relacto com Ordem Investimento", 
                                   quoter(pedido-compr.num-pedido))).
       return "NOK".  
  end.

  for first emitente
      where emitente.cod-emitente = pedido-compr.cod-emitente
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

  if temp-table tt-erros-geral:has-records then
    return "NOK".

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
    delete OBJECT jsonArrayPathParams no-error.
    delete object oRequestParser      no-error.
  end.
end procedure.

PROCEDURE pi-delete-ped-buying:
  define variable h-bocx140        as handle  no-undo.
  define variable h_api_ccusto     as handle  no-undo.
  define variable h_api_cta_ctbl   as handle  no-undo.
  define variable i-nr-ordem       as integer no-undo.
  define variable v_log_utz_ccusto as logical no-undo.
  define variable r-proc-imp       as rowid   no-undo.

  empty temp-table tt-versao-integr.
  empty temp-table tt-pedido-compr.
  empty temp-table tt-cond-especif.
  empty temp-table tt-ordem-compra.
  empty temp-table tt-prazo-compra.
  empty temp-table tt-cotacao-item.
  empty temp-table tt-desp-cotacao-item.

  for each ordem-compra no-lock
     where ordem-compra.num-pedido = pedido-compr.num-pedido
       and ordem-compra.situacao  <> 4:
      run pi-elimina-oc.
      if return-value <> "OK"
      then return "NOK".
  end.

  if can-find(first processo-imp use-index pedido where
                    processo-imp.num-pedido = pedido-compr.num-pedido
                    no-lock)
  then do:
       find processo-imp use-index pedido where
            processo-imp.num-pedido = pedido-compr.num-pedido
            no-lock no-error.

       if not avail processo-imp
       then do:
            run pi-cria-erro(substitute("Pedido &1 possui mais de um Processo de Importa‡Æo", 
                                        quoter(pedido-compr.num-pedido))).
            return "NOK".               
       end.

       assign r-proc-imp = rowid(processo-imp).
       
       run cxbo/bocx140.p persistent set h-bocx140.
       run openQuery       in h-bocx140(1).
       RUN validateDelete  IN h-bocx140 (INPUT-OUTPUT r-proc-imp,
                                         OUTPUT TABLE rowErrors).
       if temp-table RowErrors:has-records then do:
         for each RowErrors:
           create tt-erros-geral.
           assign tt-erros-geral.cod-erro = RowErrors.ErrorNumber
                  tt-erros-geral.des-erro = RowErrors.ErrorDescription.
         end.
         return "NOK".
       end.
  end.

  FOR FIRST pedido-compr
      WHERE pedido-compr.num-pedido = i-purchaseOrder
            no-lock: end.

  IF pedido-compr.situacao = 3
  THEN RETURN "OK".

  create tt-pedido-compr.
  buffer-copy pedido-compr to tt-pedido-compr
  assign tt-pedido-compr.ind-tipo-movto = 3
         tt-pedido-compr.mot-elimina    = "Solicita‡Æo Ariba-Buying".
  find current tt-pedido-compr no-error.

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
    delete procedure h-bocx140      no-error.
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

procedure pi-elimina-oc:
    DEFINE VARIABLE l-portal-paradigma  AS LOG INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-importacao        AS LOG INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-motivo-retorno    AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE h-boin356vl         AS HANDLE         NO-UNDO.
    DEFINE VARIABLE h-boin274           AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hDBOOrdens-embarque AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hDBOProcesso-imp    AS HANDLE         NO-UNDO.
    define variable c-return            AS CHAR           NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL param-global 
    THEN ASSIGN l-importacao = param-global.modulo-07.

    IF l-importacao 
    THEN DO:
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
/*                    else run pi-cria-erro(substitute("Erro no processo de elimina‡ao da OC &1", */
/*                                                     quoter(ordem-compra.numero-ordem))).       */
/*                                                                                                */
/*                    return "NOK".                                                               */
/*               end.                                                                             */
         END.            
    END. /* if l-importacao */

    RUN inbo/boin274vl.p PERSISTENT SET h-boin274.

    /* eliminaOrdensPedidoOrdemCompra */
    RUN eliminaOrdensCompraComMultiPlanta IN h-boin274 (INPUT ROWID(ordem-compra),
                                                        INPUT "", /* usuÿrio do sistema */
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
    DEF VAR h-bocx225    AS HANDLE NO-UNDO.
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
                    RowErrors.errordescription = "Impossibilitada desvincula‡Æo entre Ordem e Embarque."
                    RowErrors.errortype        = "error"
                    RowErrors.errorhelp        = "Impossibilitada desvincula‡Æo entre Ordem e Embarque.".
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
    run pi-cria-erro(substitute("NÆo localizado propriedade &1 no json de entrada", quoter(cProperty))).
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
        run pi-cria-erro(substitute("Propriedade &1 no json de entrada possui valor inv lido", quoter(cProperty))).
        return 0.
    end.
    return i-funcao.
  end.
  else do:
    run pi-cria-erro(substitute("NÆo localizado propriedade &1 no json de entrada", quoter(cProperty))).
    return 0.
  end.
end function.

