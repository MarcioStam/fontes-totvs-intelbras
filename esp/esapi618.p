.block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi618.i}
{utp/ut-glob.i}

define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

define variable jsonObjectOutput as JsonObject        no-undo.
define variable jsonOutput       as JsonObject        no-undo.
define variable oErrors          as JsonArray         no-undo.
define variable oError           as JsonObject        no-undo.
define variable lcInput          as longchar          no-undo.
define variable lcOutput         as longchar          no-undo.
define variable jsonParser       as ObjectModelParser no-undo.
define variable jsonInput        as JsonObject        no-undo.
define variable iNumMessages     as integer           no-undo.
define variable c-tags           as character         no-undo.

def var c-arrivalDate     as char no-undo.
def var dt-arrivalDate    as date no-undo.
def var i-purchaseOrderId as inte no-undo.
def var c-itemPosition    as char no-undo.
def var c-productID       as char no-undo.
def var i-numero-ordem    as inte no-undo.
def var i-parcela         as inte no-undo.
def var c-controle        as char no-undo.

def buffer b-tt-itens for tt-itens.

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
    run pi-acompanhar in h-acomp ("OC Confirma Entrega").

  run pi-input-api-headers (jsonInput).

  run pi-carga-json.

  if return-value = "OK"
  then run pi-principal.

  /* Tratamento do Retorno */
  jsonOutput       = new JsonObject().
  jsonObjectOutput = new JsonObject().

  assign es-api-log.retorno-content-type = "application/json".
  if not can-find(first tt-erros-geral) then do:
    jsonObjectOutput:add("arrivalDate", c-arrivalDate). 
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
           es-api-log.aux         = "Datas de Entrega de OCs alteradas com sucesso".
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
    run pi-upDate.
    
    if return-value <> "OK" 
    then undo, return "NOK".

    return "OK".
END PROCEDURE. /* procedure pi-principal */

procedure pi-carga-json:
  define variable jsonObjectPayload as JsonObject no-undo.
  define variable oItens            as JsonArray  no-undo.
  define variable oItem             as JsonObject no-undo.
  define variable iLoop             as integer    no-undo.

  FIND FIRST param-global NO-LOCK NO-ERROR.

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload").

  if valid-object(jsonObjectPayload) 
  then do:
       if jsonObjectPayload:has("arrivalDate")
       then assign c-arrivalDate = jsonObjectPayload:GetCharacter("arrivalDate") no-error.
      
       assign dt-arrivalDate = OpenEdge.Core.TimeStamp:ToABLDateFromISO(c-arrivalDate) no-error.

       if  not error-status:error
       and dt-arrivalDate <> ?
       and c-arrivalDate  <> ""
       then.
       else run pi-cria-erro("Campo arrivalDate ausente ou inv†lido").

       if jsonObjectPayload:has("Itens") 
       then do:
            oItens = new JsonArray().
            oItens = jsonObjectPayload:GetJsonArray("Itens").
       end.
       else run pi-cria-erro("N∆o foi poss°vel identificar bloco Itens no Json").
  end. /* if valid-object(jsonObjectPayload)  */
  else run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de pedido de compra para integrar").

  if temp-table tt-erros-geral:has-records 
  then return "NOK".

  if valid-object(oItens) 
  then do iLoop = 1 to oItens:length:
           oItem = new JsonObject().
           oItem = oItens:GetJsonObject(iLoop).
        
           assign c-tags            = ""
                  c-itemPosition    = ""
                  c-productID       = ""
                  i-purchaseOrderId = 0
                  i-numero-ordem    = 0
                  i-parcela         = 0.
        
           assign c-itemPosition    = trim(oItem:GetCharacter("itemPosition"))                           no-error.
           assign c-tags = c-tags + ",itemPosition"    when error-status:error or c-itemPosition    = "" or c-itemPosition   = ? or length(c-itemPosition) < 3 or length(c-itemPosition) > 7
                  c-productID       = trim(oItem:GetCharacter("productID")) when oItem:has("productID")  no-error.
           assign c-tags = c-tags + ",productID"       when error-status:error or c-productID       = "" or c-productID      = ?
                  i-purchaseOrderId = oItem:GetInteger("purchaseOrderId")                                no-error.
           assign c-tags = c-tags + ",purchaseOrderId" when error-status:error or i-purchaseOrderId = 0 or i-purchaseOrderId = ?.

           if c-tags = ""
           then do:
                assign i-numero-ordem = inte(substr(c-itemPosition,1,length(c-itemPosition) - 2))
                       i-parcela      = inte(substr(c-itemPosition,length(c-itemPosition) - 1,2))
                       no-error.

                if  i-numero-ordem > 0
                and i-parcela      > 0
                then.
                else assign c-tags = c-tags + ",itemPosition".
           end. /* assign c-tags = "" */

           if c-tags <> ""
           then do:
                run pi-cria-erro("Erro quanto ao conte£do no bloco Itens: " + trim(c-tags,",")).
                leave.
           end.

           if can-find(first b-tt-itens where
                             b-tt-itens.purchaseOrderId = i-purchaseOrderId
                         and b-tt-itens.numero-ordem    = i-numero-ordem
                         and b-tt-itens.parcela         = i-parcela
                         and rowid(b-tt-itens)         <> rowid(tt-itens))
           then do:
                if lookup((string(i-purchaseOrderId,"999999999") + c-itemPosition),trim(c-controle,",")) = 0
                then do:
                     run pi-cria-erro(substitute("Posiá∆o &1 repetida no Pedido &2",
                                                 quoter(c-itemPosition),
                                                 quoter(i-purchaseOrderId))).
        
                     assign c-controle = c-controle + "," + string(i-purchaseOrderId,"999999999") + c-itemPosition.
                end.

                next.
           end.

           if can-find(first b-tt-itens where
                             b-tt-itens.purchaseOrderId = i-purchaseOrderId
                         and b-tt-itens.numero-ordem    = i-numero-ordem
                         and b-tt-itens.productID      <> c-productID)
           then do:
                run pi-cria-erro(substitute("Posiá∆o &1 no Pedido &2 com productIDs inconsistentes",
                                            quoter(c-itemPosition),
                                            quoter(i-purchaseOrderId))).
                next.
           end.

           create tt-itens.
           assign tt-itens.itemPosition    = c-itemPosition
                  tt-itens.productID       = c-productID
                  tt-itens.purchaseOrderId = i-purchaseOrderId
                  tt-itens.numero-ordem    = i-numero-ordem
                  tt-itens.parcela         = i-parcela.
           find current tt-itens no-error.
           release tt-itens.
       end. /* do iLoop = 1 to oItens:length */

  if temp-table tt-erros-geral:has-records 
  then return "NOK".

  if not temp-table tt-itens:has-records 
  then do:
       run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de itens para integrar").
       return "NOK".
  end.

  return "OK".

  catch oStop as Progress.Lang.StopError:
      do iNumMessages = 1 to oStop:nummessages:
          run pi-cria-erro(oStop:GetMessage(iNumMessages)).
      end.
      return "NOK".
  end catch.
  catch eAnyError as Progress.Lang.Error:
      do iNumMessages = 1 to eAnyError:nummessages:
          run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
      end.
      return "NOK".
  end catch.
  finally:
      delete object jsonObjectPayload   no-error.
      delete object oItens              no-error.
      delete object oItem               no-error.
  end.
end procedure. /* procedure pi-carga-json */

procedure pi-upDate:
    empty temp-table tt-versao-integr.
    empty temp-table tt-pedido-compr.
    empty temp-table tt-cond-especif.
    empty temp-table tt-ordem-compra.
    empty temp-table tt-prazo-compra.
    empty temp-table tt-cotacao-item.
    empty temp-table tt-desp-cotacao-item.   
    
    for each tt-itens
        break by tt-itens.purchaseOrderId
              by tt-itens.numero-ordem
              by tt-itens.parcela:
        for first pedido-compr
            where pedido-compr.num-pedido = tt-itens.purchaseOrderId
              and pedido-compr.situacao  <> 3
                  no-lock: end.

        if first-of(tt-itens.purchaseOrderId)
        then do:
             if not avail pedido-compr
             then do:
                  run pi-cria-erro(substitute("Pedido &1 n∆o cadastrado ou j† eliminado",
                                              quoter(tt-itens.purchaseOrderId))).
                  next.             
             end.

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
        end. /* if first-of(tt-itens.purchaseOrderId) */

        if not avail pedido-compr
        then next.

        release ordem-compra.

        for first item
            where item.it-codigo = tt-itens.productID
                  no-lock: end.

        if avail item
        then find ordem-compra use-index pedido-item where 
                  ordem-compra.num-pedido = pedido-compr.num-pedido
              and ordem-compra.it-codigo  = item.it-codigo
              and inte(substr(string(ordem-compra.numero-ordem,"99999999"),4,5)) = tt-itens.numero-ordem
              and ordem-compra.situacao   < 3
                  no-lock no-error.

        if first-of(tt-itens.numero-ordem)
        then do:
             if not avail item
             then do:
                  run pi-cria-erro(substitute("productID &1 n∆o cadastrado",
                                              quoter(tt-itens.productID))).
                  next.      
             end.

             if not avail ordem-compra
             then do:
                  run pi-cria-erro(substitute("N∆o foi poss°vel identificar no pedido &1 uma OC compat°vel com posiá∆o &2, productID &3, cujas informaá‰es e situaá∆o permitam alteraá∆o",
                                              quoter(tt-itens.purchaseOrderId),
                                              quoter(tt-itens.itemPosition),
                                              quoter(item.it-codigo))).
                  next.
             end. /* if not avail ordem-compra */

             run pi-valida-alter.
             if return-value <> "OK"
             then do:
                  run pi-cria-erro(substitute("OC &1 possui embarque com situaá∆o que n∆o permite alteraá∆o", 
                                              quoter(ordem-compra.numero-ordem))).
                  next.   
             end. 

             create tt-ordem-compra.
             buffer-copy ordem-compra to tt-ordem-compra
             assign tt-ordem-compra.l-split        = false
                    tt-ordem-compra.ind-tipo-movto = 2
                    tt-ordem-compra.data-atualiz   = today
                    tt-ordem-compra.hora-atualiz   = string(time,"hh:mm:ss").
             find current tt-ordem-compra no-error.
             release tt-ordem-compra.
        end. /* if first-of(tt-itens.numero-ordem */

        if not avail item
        then next.

        if  avail ordem-compra
        and can-find(first tt-ordem-compra where
                           tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem)
        then.
        else next.
   
        for first prazo-compra
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
              and prazo-compra.parcela      = tt-itens.parcela
                  no-lock: end.

        if not avail prazo-compra
        then do:
             run pi-cria-erro(substitute("N∆o localizada parcela &1 para OC &2, pedido &3", 
                                         quoter(tt-itens.parcela),
                                         quoter(ordem-compra.numero-ordem),
                                         quoter(pedido-compr.num-pedido))).
             next.
        end. /* if not avail prazo-compra */

        if prazo-compra.situacao < 3
        then.
        else do:
             run pi-cria-erro(substitute("Situaá∆o da parcela &1, OC &2, pedido &3, n∆o permite alteraá∆o", 
                                         quoter(prazo-compra.parcela),
                                         quoter(ordem-compra.numero-ordem),
                                         quoter(pedido-compr.num-pedido))).
             next.
        end.
        
        create tt-prazo-compra.
        buffer-copy prazo-compra except data-entrega to tt-prazo-compra
        assign tt-prazo-compra.ind-tipo-movto = 2
               tt-prazo-compra.data-entrega   = dt-arrivalDate.
        find current tt-prazo-compra no-error.
        release tt-prazo-compra.
        
        //Criar Cotacao
        for each cotacao-item no-lock
           where cotacao-item.numero-ordem = ordem-compra.numero-ordem
             and cotacao-item.cod-emitente = pedido-compr.cod-emitente
             and cotacao-item.it-codigo    = item.it-codigo:
            create tt-cotacao-item.
            buffer-copy cotacao-item to tt-cotacao-item
                assign tt-cotacao-item.ind-tipo-movto = 2.
            find current tt-cotacao-item.
            release tt-cotacao-item.
        
            for each desp-cotacao-item no-lock
               where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                 and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                 and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
                 and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac:
                create tt-desp-cotacao-item.
                buffer-copy desp-cotacao-item to tt-desp-cotacao-item
                    assign tt-desp-cotacao-item.ind-tipo-movto = 2.
                find current tt-desp-cotacao-item no-error.
                release tt-desp-cotacao-item.
            end. /* for each desp-cotacao-item */       
        end. /* for each cotacao-item */
    end. /* for each tt-itens */

    if temp-table tt-erros-geral:has-records 
    then return "NOK".
    
    if not temp-table tt-prazo-compra:has-records
    then do:
         run pi-cria-erro("Sem Parcelas para alteraá∆o").
         return "NOK".  
    end.

/*     for each tt-ordem-compra:                                                          */
/*         if can-find(first tt-prazo-compra where                                        */
/*                           tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem) */
/*         then next.                                                                     */
/*                                                                                        */
/*         delete tt-ordem-compra.                                                        */
/*     end.                                                                               */
/*     for each tt-pedido-compr:                                                          */
/*         if not can-find(first tt-ordem-compra where                                    */
/*                               tt-ordem-compra.num-pedido = tt-pedido-compr.num-pedido) */
/*         then delete tt-pedido-compr.                                                   */
/*     end.                                                                               */
    
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
    
    if temp-table tt-erros-geral:has-records 
    then return "NOK".   

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
end procedure. /* procedure pi-upDate */

procedure pi-cria-erro:
  define input parameter p-des-erro as character no-undo.
  log-manager:write-message(p-des-erro, "ARIBA").
  create tt-erros-geral.
  assign tt-erros-geral.cod-erro = 17006
         tt-erros-geral.des-erro = p-des-erro.
  return "OK".
end procedure.

procedure pi-valida-alter:
    def buffer b-prazo-compra for prazo-compra.

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
        then return "NOK".
    end. /* for each b-prazo-compra */

    return "OK".
end procedure. /* procedure pi-valida-alter */

PROCEDURE pi-busca-posicao :
    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1 /* N∆o Encerrado */
        AND   embarque-imp.cod-estabel = ordens-embarque.cod-estabel
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}   
        
    END. /* FOR EACH  embarque-imp NO-LOCK */
END PROCEDURE.

