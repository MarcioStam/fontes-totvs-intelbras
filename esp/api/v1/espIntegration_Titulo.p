
/************************************************************************************
* Programa ..: API Rest espIntegration_Nota                                         *
*************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-titulo get /~*}
{utp/ut-api-notfound.i} 


def var JEmitente               as JsonObject no-undo.

def var jItens                  as jsonObject no-undo.
def var jItem                   as JsonObject no-undo.
def var jArrayItem              as JsonArray  no-undo.

def var jFaturas                as jsonObject no-undo.
def var jFatura                 as JsonObject no-undo.
def var jArrayFatura            as JsonArray  no-undo.

def var jArrayTit               as JsonArray  no-undo.

DEF VAR i-cod-rep               AS INT NO-UNDO.
def var c-cgc                   as char no-undo.
def var dt-startDate            as date no-undo.
def var dt-endDate              as date no-undo.
DEF VAR state                   AS CHAR NO-UNDO.
def var c-orderCode             as char no-undo.
def var i-aux                   as inte no-undo.
def var i-num-param             as inte no-undo.
DEF VAR de-total-aberto         AS DECIMAL NO-UNDO.
DEF VAR de-total-vencido        AS DECIMAL NO-UNDO.
DEF VAR de-total-saldo          AS DECIMAL NO-UNDO.
DEF VAR c-status                AS CHAR    NO-UNDO.


// VERIFICA BASE LOGADA 
DEF VAR c-arquivo-log1          AS CHAR NO-UNDO.
def var l-producao              AS LOG NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


procedure pi-consulta-titulo:
    
    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse           as JsonAPIResponse      no-undo.
    def var oRequestParser      as JsonAPIRequestParser no-undo.
    def var oJsonObject         as JsonObject           no-undo.
    def var jArrayPrincipal     as JsonArray            no-undo.

 
    delete object JEmitente      no-error.
    delete object jItens         no-error.
    delete object jItem          no-error.
    delete object jArrayItem     no-error.
    delete object jFaturas       no-error.
    delete object jFatura        no-error.
    delete object jArrayFatura   no-error.
    delete object jArrayTit      no-error.

    empty temp-table RowErrors.
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-ERROR.
    
    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
       ASSIGN l-producao = YES.
    ELSE
       ASSIGN l-producao = NO.
    
    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_titulo'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_titulo'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
    

    RUN pi-gerar-dados-extrato (">> INICIO PESQUISA DE TITULO ").

    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    assign i-num-param = jArrayPrincipal:length no-error.

    RUN pi-gerar-dados-extrato (">> NUMERO PARAMETROS " + STRING(i-num-param)).


    if i-num-param > 1 
    then.
    else return.

    do i-aux = 1 to i-num-param:
        case i-aux:
            WHEN 1
            THEN ASSIGN i-cod-rep    = INT(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) NO-ERROR.
            when 2
            then assign c-cgc        = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 3 
            then ASSIGN dt-startDate = OpenEdge.Core.TimeStamp:ToABLDateFromISO(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
            when 4
            then assign dt-endDate   = OpenEdge.Core.TimeStamp:ToABLDateFromISO(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
            WHEN 5
            THEN ASSIGN state        = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
        end case.
    end.

    RUN pi-gerar-dados-extrato (">> REPRESENTANTE: " + STRING(i-cod-rep)).
    RUN pi-gerar-dados-extrato (">> DATA INICIO  : " + STRING(dt-startDate)).
    RUN pi-gerar-dados-extrato (">> DATA FINAL   : " + STRING(dt-endDate)).

    if c-cgc = ""
    or c-cgc = ?
    then return. 

    RUN pi-gerar-dados-extrato (">> COD CLIENTE  : " + trim(substr(c-cgc,3,14))).

    FIND first emitente use-index cgc 
         where emitente.cgc = trim(substr(c-cgc,3,14)) NO-LOCK NO-ERROR.
    
    RUN pi-gerar-dados-extrato (">>     CLIENTE  : " + STRING(c-cgc) + emitente.nome-emit).
    assign i-aux            = 0
           de-total-aberto  = 0
           de-total-vencido = 0
           de-total-saldo   = 0
           c-status         = ''.


   assign jArrayTit = new JsonArray(). 
    for each emitente use-index cgc no-lock
       where emitente.cgc = trim(substr(c-cgc,3,14)):
        
      if  dt-startDate <> ?
      and dt-endDate   <> ? then do:
           
          
         assign JEmitente = new JsonObject().
         JEmitente:add("externalId",      c-cgc). 
         JEmitente:add("corporateName",   emitente.nome-emit).
         JEmitente:add("addressCity",     emitente.cidade).
         JEmitente:add("addressState",    emitente.estado).
         JEmitente:add("creditLimit",     emitente.lim-credito).
         JEmitente:add("dateCreditLimit", ISO-DATE(emitente.dt-lim-cred)).
         
         RUN pi-faturas.

         JEmitente:add("totalDued", de-total-aberto).
         JEmitente:add("totalDue", de-total-vencido).
         JEmitente:add("grandTotal", de-total-saldo).
          
        // RUN pi-gerar-dados-extrato (JsonAPIUtils:getJsonArrayChar(jArrayFatura)).
         
         RUN pi-gerar-dados-extrato ("Finalizando dados do cliente").


      END.
    end. /* for each emitente */
    
    jArrayTit:add(JEmitente).
/*
    RUN pi-gerar-dados-extrato (JsonAPIUtils:getJsonArrayChar(jArrayTit)).
  */  
    assign oJsonObject = new JsonObject().
    oJsonObject:add("Customer",jArrayTit).
   
    run createJsonResponse(input  oJsonObject, 
                           input  table RowErrors, 
                           input  false,
                           output jsonOutput).   
end procedure. /* procedure pi-consulta-titulo */



PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put UNFORMATTED "     " + c-lbl-liter-ponto-executado + ": " p-string " - " + STRING(DATETIME(TODAY, MTIME)) skip.
        output close. 
    
    end.
END.


PROCEDURE pi-faturas:
         
     RUN pi-gerar-dados-extrato (">> gravando dados do cliente ").

     assign jArrayFatura = new JsonArray().

     FOR EACH estabelec,
     EACH tit_acr NO-LOCK
        WHERE tit_acr.cod_estab           = estabelec.cod-estabel
          AND tit_acr.cdn_cliente         = emitente.cod-emitente
          AND tit_acr.dat_emis_docto      >= dt-startDate 
          AND tit_acr.dat_emis_docto      <= dt-endDate
          AND tit_acr.val_sdo_tit_acr      > 0
          AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:
          
          assign i-aux = i-aux + 1.

          IF cdn_repres = i-cod-rep THEN DO:
                
              IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN do:
                 ASSIGN c-status         = 'Vencido'
                        de-total-vencido = de-total-vencido + tit_acr.val_sdo_tit_acr.
              END.
              ELSE do:
                 ASSIGN c-status = 'Aberto'
                        de-total-aberto = de-total-aberto + tit_acr.val_sdo_tit_acr.
              END.

              IF state = 'Vencido' AND 
                 c-status <> 'Vencido' THEN NEXT.

              IF state = 'Aberto' AND
                 c-status <> 'Aberto' THEN NEXT.
              
              de-total-saldo = de-total-saldo + tit_acr.val_sdo_tit_acr.


             assign jFatura = new JsonObject().
                    jFatura:ADD("Establishment",         tit_acr.cod_estab).
                    jFatura:add("invoiceSerie",          tit_acr.cod_ser_docto).
                    jFatura:add("invoiceNumber",         tit_acr.cod_tit_acr).
                    jFatura:add("invoiceParcel",         tit_acr.cod_parcela).
                    jFatura:add("invoiceIssuanceDate",   iso-date(tit_acr.dat_emis_docto)).
                    jFatura:add("invoiceDueDate",        ISO-DATE(tit_acr.dat_vencto_tit_acr)).
                    jFatura:ADD("invoiceOriginalValue",  tit_acr.val_origin_tit_acr).
                    jFatura:ADD("invoiceBalanceDue",     tit_acr.val_sdo_tit_acr).
                    jFatura:ADD("invoiceStatus",         c-status).
                    jFatura:ADD("daysOfDelay",           INT(TODAY - tit_acr.dat_vencto_tit_acr)).
            jArrayFatura:add(jFatura).
          END.
     END.
   
     JEmitente:add("Invoices", jArrayFatura).
     
 END PROCEDURE.
