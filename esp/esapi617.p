block-level on error undo, throw.
/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{utp/ut-glob.i}

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer
    field ttv_des_msg_ajuda as character
    field ttv_des_msg_erro  as character.

define temp-table tt-erros no-undo
  field erro-geral    as logical
  field sequence      as integer
  field centerIDcc    as character
  field ledgerAccount as character
  field costCenter    as character
  field businessUnit  as character
  field centerID      as character
  field cont          as integer
  field cod-erro      as integer format "99999"   
  field des-erro      as char    format "x(100)"
  index id is primary erro-geral
                      sequence
                      centerIDcc
                      ledgerAccount
                      costCenter
                      businessUnit
                      centerID
                      cont.

def temp-table tt-contas no-undo
    field sequence      as inte
    field centerIDcc    as char
    field ledgerAccount as char
    field costCenter    as char
    field businessUnit  as char
    field centerID      as char
    field content       as char
    field budgetCheck   as logi
    field useCostCenter as logi
    index id is primary sequence
                        centerIDcc
                        ledgerAccount
                        costCenter
                        businessUnit
                        centerID.

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

def var oBudgets as JsonArray  no-undo.
def var oBudget  as JsonObject no-undo.

def var iLoop           as inte no-undo.
def var i-sequence      as inte no-undo.
def var c-centerIDcc    as char no-undo.
def var i-ledgerAccount as inte no-undo.
def var c-content       as char no-undo.
def var c-costCenter    as char no-undo.
def var c-businessUnit  as char no-undo.
def var c-centerID      as char no-undo.
def var c-ledgerAccount as char no-undo.
def var i-cont          as inte no-undo.
def var c-tags          as char no-undo.

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
    run pi-acompanhar in h-acomp ("Budget Check").

  run pi-input-api-headers (jsonInput).

  run pi-carga-json.

  if return-value = "OK"
  then for each tt-contas:
           run pi-valida-conta.

           if return-value = "OK"
           then next.

           assign i-cont = 0.

           for each tt_log_erro:
               assign i-cont = i-cont + 1.

               create tt-erros.
               assign tt-erros.erro-geral    = no
                      tt-erros.sequence      = tt-contas.sequence
                      tt-erros.centerIDcc    = tt-contas.centerIDcc
                      tt-erros.ledgerAccount = tt-contas.ledgerAccount
                      tt-erros.costCenter    = tt-contas.costCenter
                      tt-erros.businessUnit  = tt-contas.businessUnit
                      tt-erros.centerID      = tt-contas.centerID
                      tt-erros.cont          = i-cont
                      tt-erros.cod-erro      = tt_log_erro.ttv_num_cod_erro
                      tt-erros.des-erro      = tt_log_erro.ttv_des_msg_erro.
               find current tt-erros no-error.
           end. /* for each tt_log_erro */
       end. /* for each tt-contas */
  release tt-erros.

  /* Tratamento do Retorno */
  jsonObjectOutput = new JsonObject().
  jsonOutput       = new JsonObject().

  assign es-api-log.retorno-content-type = "application/json".

  if can-find(first tt-erros where
                    tt-erros.erro-geral = yes)
  then do:
       oErrors = new JsonArray().

       for each tt-erros
          where tt-erros.erro-geral = yes:
           oError = new JsonObject().
           oError:add("errorCode",        tt-erros.cod-erro). 
           oError:add("errorInfo",        ""). 
           oError:add("errorDescription", tt-erros.des-erro).
           oErrors:add(oError).
       end.

       jsonObjectOutput:add("Erros", oErrors).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
  end. /* if temp-table tt-erros:has-records */
  else do:
       oBudgets = new JsonArray().

       for each tt-contas:
           oBudget = new JsonObject().
           oBudget:add("sequence",      tt-contas.sequence).
           oBudget:add("ledgerAccount", tt-contas.ledgerAccount).
           oBudget:add("costCenter",    tt-contas.content).
           oBudget:add("centerID",      tt-contas.centerID).
           oBudget:add("budgetCheck",   tt-contas.budgetCheck).
           oBudget:add("useCostCenter", tt-contas.useCostCenter).

           if can-find(first tt-erros where
                             tt-erros.sequence      = tt-contas.sequence
                         and tt-erros.centerIDcc    = tt-contas.centerIDcc
                         and tt-erros.ledgerAccount = tt-contas.ledgerAccount
                         and tt-erros.costCenter    = tt-contas.costCenter
                         and tt-erros.businessUnit  = tt-contas.businessUnit
                         and tt-erros.centerID      = tt-contas.centerID)
           then do:
                oErrors = new JsonArray().

                for each tt-erros
                   where tt-erros.sequence      = tt-contas.sequence
                     and tt-erros.centerIDcc    = tt-contas.centerIDcc
                     and tt-erros.ledgerAccount = tt-contas.ledgerAccount
                     and tt-erros.costCenter    = tt-contas.costCenter
                     and tt-erros.businessUnit  = tt-contas.businessUnit
                     and tt-erros.centerID      = tt-contas.centerID:
                    oError = new JsonObject().
                    oError:add("errorCode",        tt-erros.cod-erro). 
                    oError:add("errorInfo",        ""). 
                    oError:add("errorDescription", tt-erros.des-erro).
                    oErrors:add(oError).
                end. /* for each tt-erros */

                oBudget:add("Erros", oErrors).
           end. /* if temp-table tt-erros:has-records */

           oBudgets:add(oBudget).
       end. /* for each tt-contas */

       jsonObjectOutput:add("account", oBudgets).
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
  end. /* else do */

  jsonOutput:write(lcOutput).
  copy-lob lcOutput to es-api-log.cl-retorno.

  if can-find(first tt-erros where
                    tt-erros.erro-geral = yes)
  then assign es-api-log.cod-retorno = "500".
  else assign es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Contas e Centros de Custo foram conferidos".

  release es-api-log.
end.

{esp/esapi505x.i &OPC="CLOSE"}

return "OK".

/* **********************  Internal Procedures  *********************** */
procedure pi-carga-json :
  define variable jsonObjectPayload as JsonObject no-undo.

  empty temp-table tt-contas.
  empty temp-table tt-erros.

  assign jsonObjectPayload = jsonInput:GetJsonObject("payload").

  if not valid-object(jsonObjectPayload)
  or not jsonObjectPayload:has("account")
  then do:
       run pi-cria-erro("N∆o foi poss°vel identificar informaá‰es de Conta e Centro de Custo para validar").
       return "NOK".
  end.

  oBudgets = new JsonArray().
  oBudgets = jsonObjectPayload:GetJsonArray("account").

  if not valid-object(oBudgets)
  then do:
       run pi-cria-erro("N∆o foi poss°vel identificar Contas e Centros de Custo para validar").
       return "NOK".       
  end.

  do iLoop = 1 to oBudgets:length:
      oBudget = new JsonObject().
      oBudget = oBudgets:GetJsonObject(iLoop).

      assign i-sequence      = 0
             c-centerIDcc    = ""
             c-content       = ""
             i-ledgerAccount = 0
             c-costCenter    = ""
             c-businessUnit  = ""
             c-centerID      = ""
             c-tags          = "".

      assign i-sequence      = oBudget:GetInteger("sequence")      no-error.
      assign c-tags          = c-tags + ",sequence"      when error-status:error or i-sequence      = 0 or i-sequence      = ?
             i-ledgerAccount = oBudget:GetInteger("ledgerAccount") no-error.
      assign c-tags          = c-tags + ",ledgerAccount" when error-status:error or i-ledgerAccount = 0 or i-ledgerAccount = ?
             c-content       = oBudget:GetCharacter("costCenter")  no-error.
      assign c-tags          = c-tags + ",costCenter"    when error-status:error.

      if oBudget:has("centerID")
      then assign c-centerID = oBudget:GetCharacter("centerID") no-error.
      if c-centerID = ?
      then assign c-centerID = "".

      if num-entries(c-content, ".") >= 3 
      then assign c-businessUnit = entry(1, c-content, ".")
                  c-costCenter   = entry(2, c-content, ".")
                  c-centerIDcc   = entry(3, c-content, ".").

      if c-tags <> ""
      then do:
           run pi-cria-erro("Erro quanto Ö propriedade ou ao tipo de entrada de dados no bloco account: " + trim(c-tags,",")).
           return "NOK".
      end.

      if i-ledgerAccount > 99999999
      then do:
           run pi-cria-erro(substitute("Conta &1 muito extensa", 
                                       quoter(i-ledgerAccount))).
           return "NOK".  
      end.

      assign c-ledgerAccount = string(i-ledgerAccount, "99999999").

      if can-find(first tt-contas where
                        tt-contas.sequence      = i-sequence
                    and tt-contas.centerIDcc    = c-centerIDcc
                    and tt-contas.ledgerAccount = c-ledgerAccount
                    and tt-contas.costCenter    = c-costCenter
                    and tt-contas.businessUnit  = c-businessUnit
                    and tt-contas.centerID      = c-centerID)
      then do:
           run pi-cria-erro(substitute("Seq &1 Estab &2 Conta &3 CCusto &4 Unidade Neg¢cio &5 repetidos no array",
                                       quoter(i-sequence),
                                       quoter(c-centerIDcc),
                                       quoter(c-ledgerAccount),
                                       quoter(c-costCenter),
                                       quoter(c-businessUnit))).
           return "NOK".  
      end.

      create tt-contas.
      assign tt-contas.sequence      = i-sequence
             tt-contas.centerIDcc    = c-centerIDcc
             tt-contas.ledgerAccount = c-ledgerAccount
             tt-contas.costCenter    = c-costCenter
             tt-contas.businessUnit  = c-businessUnit
             tt-contas.centerID      = c-centerID
             tt-contas.content       = c-content
             tt-contas.budgetCheck   = no
             tt-contas.useCostCenter = ?.
      find current tt-contas no-error.
  end. /* do iLoop = 1 to oBudgets:length */

  if not temp-table tt-contas:has-records
  then do:
       run pi-cria-erro("Nenhuma conta foi lida").
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
      release tt-contas.
      delete object oBudgets          no-error.
      delete object oBudget           no-error.
      delete object jsonObjectPayload no-error.
  end.
end procedure.

PROCEDURE pi-valida-conta:
    define variable h_api_ccusto     as handle  no-undo.
    define variable h_api_cta_ctbl   as handle  no-undo.
    define variable v_log_utz_ccusto as logical no-undo.    

    empty temp-table tt_log_erro.

    release estabelec.

    if tt-contas.centerIDcc <> ""
    then for first estabelec fields(cod-estabel ep-codigo)
             where estabelec.cod-estabel = tt-contas.centerIDcc
                   no-lock: end.

    if not avail estabelec
    then do:
         create tt_log_erro.
         assign tt_log_erro.ttv_num_cod_erro  = 17006
                tt_log_erro.ttv_des_msg_ajuda = ""
                tt_log_erro.ttv_des_msg_erro  = "Estabelecimento para Centro Custo " + tt-contas.costCenter + " Ç inv†lido".
         find current tt_log_erro no-error.

         return "NOK".     
    end.

    if not can-find(first unid-negoc where
                          unid-negoc.cod-unid-negoc = tt-contas.businessUnit
                          no-lock)
    then do:
         create tt_log_erro.
         assign tt_log_erro.ttv_num_cod_erro  = 17006
                tt_log_erro.ttv_des_msg_ajuda = ""
                tt_log_erro.ttv_des_msg_erro  = "Unidade Neg¢cio n∆o cadastrada".
         find current tt_log_erro no-error.

         return "NOK".
    end.

    if not valid-handle(h_api_ccusto) 
    then run prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  estabelec.ep-codigo,     /* EMPRESA EMS 2 */
                                                       input  estabelec.cod-estabel,   /* ESTABELECIMENTO EMS2 */
                                                       input  "PADRAO",                /* PLANO CONTAS */
                                                       input  tt-contas.ledgerAccount, /* CONTA */
                                                       input  TODAY,                   /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,        /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro).  /* ERROS */
    if temp-table tt_log_erro:has-records 
    then return "NOK".

    assign tt-contas.useCostCenter = v_log_utz_ccusto.

    IF NOT v_log_utz_ccusto THEN
        ASSIGN tt-contas.costCenter = "".

    if  not v_log_utz_ccusto
    and tt-contas.costCenter <> ""
    then do:
         create tt_log_erro.
         assign tt_log_erro.ttv_num_cod_erro  = 17006
                tt_log_erro.ttv_des_msg_ajuda = ""
                tt_log_erro.ttv_des_msg_erro  = "Conta " + tt-contas.ledgerAccount + " n∆o utiliza Centro de Custo".
         find current tt_log_erro no-error.

         return "NOK".
    end.

/*     if  v_log_utz_ccusto                                                        */
/*     and tt-contas.costCenter = ""                                               */
/*     then do:                                                                    */
/*          create tt_log_erro.                                                    */
/*          assign tt_log_erro.ttv_num_cod_erro  = 0                               */
/*                 tt_log_erro.ttv_des_msg_ajuda = "Conta utiliza Centro de Custo" */
/*                 tt_log_erro.ttv_des_msg_erro  = tt_log_erro.ttv_des_msg_ajuda.  */
/*          find current tt_log_erro no-error.                                     */
/*                                                                                 */
/*          return "NOK".                                                          */
/*     end.                                                                        */

    if not valid-handle(h_api_cta_ctbl) 
    then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    run pi_valida_conta_contabil in h_api_cta_ctbl (input  estabelec.ep-codigo,     /* EMPRESA EMS2 */
                                                    input  estabelec.cod-estabel,   /* ESTABELECIMENTO EMS2 */
                                                    input  tt-contas.businessUnit,  /* UNIDADE NEG‡CIO */
                                                    input  "PADRAO",                /* PLANO CONTAS */ 
                                                    input  tt-contas.ledgerAccount, /* CONTA */
                                                    input  "",                      /* PLANO CCUSTO */ 
                                                    input  tt-contas.costCenter,    /* CCUSTO */
                                                    input  today,                   /* DATA TRANSACAO */
                                                    output table tt_log_erro).      /* ERROS */
    if temp-table tt_log_erro:has-records 
    then return "NOK".

    assign tt-contas.budgetCheck = yes.
    
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
        release tt_log_erro.
        delete procedure h_api_cta_ctbl no-error.
        delete procedure h_api_ccusto   no-error.
    end.
end procedure. /* pi-valida-conta */

procedure pi-cria-erro:
  define input parameter p-des-erro as character no-undo.

  log-manager:write-message(p-des-erro, "ARIBA").

  create tt-erros.
  assign tt-erros.erro-geral = yes
         tt-erros.cod-erro   = 17006
         tt-erros.des-erro   = p-des-erro.
  find current tt-erros no-error.

  return "OK".
end procedure.
