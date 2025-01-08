/********************************************************************************
 INTEGRA€ÇO DE PEDIDOS COM O SALESFORCE 
*******************************************************************************/ 

{esp/wso/eswso0011.i} 
  
function fcGetDescFinallity returns character ( iFinallity as integer) forwards.
function fcGetDiscount      returns decimal ( cDiscount as character, iDiscount as integer ) forwards.

define temp-table tt-ped-venda no-undo like ped-venda.
define temp-table tt-ped-item  no-undo like ped-item.

define variable c-json-new       as LONGCHAR   no-undo.
define variable c-json-old       as LONGCHAR   no-undo.
define variable cTbPreco         as character  no-undo.
define variable cOrigem          as character  no-undo.
define variable oJsonPedido      as JsonObject no-undo.

define variable oJsonItemPedido  as JsonObject no-undo.
define variable oJsonItensPedido as JsonArray  no-undo.
DEFINE VARIABLE c-supervisor     AS CHAR       NO-UNDO.
DEFINE VARIABLE c-origem         LIKE int-ped-venda.origem NO-UNDO.
DEFINE VARIABLE i-sequencia      AS INT NO-UNDO.

define input parameter table for tt-ped-venda.
define input parameter table for tt-ped-item.

DEF VAR de-ipi               AS DECIMAL   NO-UNDO.
DEF VAR de-st                AS DECIMAL   NO-UNDO.
DEF VAR c-status             AS CHAR      NO-UNDO.
DEF VAR c-motivo             LIKE ped-venda.desc-bloq-cr NO-UNDO.

DEFINE VARIABLE cJsonAtual   AS LONGCHAR NO-UNDO.
DEF VAR c-arquivo-log1       AS CHAR     NO-UNDO.

// VERIFICA BASE LOGADA 
def var l-producao   AS LOG NO-UNDO.
DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
   ASSIGN l-producao = YES.
ELSE
   ASSIGN l-producao = NO.


EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL NO-UNDO.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                   INPUT 2,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
  WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0011' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
  ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
  ASSIGN l-log = YES.
ELSE
  ASSIGN l-log = NO.

// ABERTURA DO LOG 
IF l-log = YES THEN DO:

    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0011'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0011'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

END.
 
find first tt-ped-venda NO-LOCK no-error.

IF NOT AVAIL tt-ped-venda 
   OR tt-ped-venda.cod-priori = 44 THEN NEXT.
ELSE DO:

/***** Inicio *****/

   find first es-api-uri    
        where es-api-URI.id-URI = 'integraPedidoCRM' no-lock no-error.
   find first int-ped-venda 
        where int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido no-lock no-error.
		
   RUN pi-gerar-dados-extrato (">> Inicio da Integracao ").
   RUN pi-gerar-dados-extrato (">> Pedido " + STRING(tt-ped-venda.nr-pedcli) + '/' + string(int-ped-venda.nr-pedido)).

   IF NOT AVAIL es-api-URI THEN 
  
   RUN pi-gerar-dados-extrato (">> Antes de criar Objeto ").
   RUN pi-gera-json.
      
   assign c-json-new = oJsonPedido:getjsontext().
     
   RUN pi-gerar-dados-extrato (">> Depois de criar Objeto ").
      
   IF l-producao
      THEN ASSIGN c-endereco       = es-api-URI.ent-PRD.
      ELSE ASSIGN c-endereco       = es-api-URI.end-TST.
   
   RUN pi-gerar-dados-extrato (">> URL: " + C-ENDERECO).
         
   FIND FIRST tt-ped-venda NO-LOCK NO-ERROR.
   FIND LAST es-api-log    
        WHERE es-api-log.id-aplicacao = 'CRM'
          AND es-api-log.id-codigo    = string(tt-ped-venda.nr-pedido) 
          AND es-api-log.id-URI       = 'integraPedidoCRM' EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL es-api-log THEN DO:
      RUN pi-gerar-dados-extrato (">> PRIMEIRA INTEGRACAO DO PEDIDO").
      i-sequencia = 10.
   END.
   ELSE DO: 
      c-json-old = es-api-log.cJSON.
      c-json-old = CODEPAGE-CONVERT(c-json-old, "UTF-8":U).
      i-sequencia = es-api-log.seqexec + 10.

      RUN pi-gerar-dados-extrato (">> ALTERACAO / MOVIMENTACAO DO PEDIDO ").
   END.

   FIND FIRST int-ped-venda
        WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-LOCK NO-ERROR.

   IF (tt-ped-venda.nr-pedrep <> ' ' AND int-ped-venda.origem <> ' ') OR
      (tt-ped-venda.nr-pedrep  = ' ' AND int-ped-venda.origem =  ' ') THEN DO: 
      IF int-ped-venda.origem = '' THEN 
         ASSIGN c-origem = int-ped-venda.origem.
      ELSE 
         ASSIGN c-origem = 'TOTVS'.
       
      CREATE es-api-log.
      ASSIGN es-api-log.id-api-log     = NEXT-VALUE(seq_api_log)
             es-api-log.seqexec        = i-sequencia
             es-api-log.id-aplicacao   = 'CRM'
             es-api-log.id-codigo      = string(tt-ped-venda.nr-pedido)
             es-api-log.id-URI         = 'integraPedidoCRM'
             es-api-log.end-envio      = c-endereco
             es-api-log.flg-processado = NO
             es-api-log.Origem         = c-origem
             es-api-log.aux            = string(tt-ped-venda.nr-pedido).
               
      run piHeader(input 1,
                   input "Addressee",
                   input c-origem).
             
      RUN pi-gerar-dados-extrato (">> MUDOU JSON ??? "  + STRING(c-json-old <> c-json-new)).
    
      IF (c-json-old <> c-json-new) THEN DO:
        // RUN pi-gerar-dados-extrato (">> JSON ANTIGO " + STRING(c-json-old)).
       //  RUN pi-gerar-dados-extrato (">> JSON NOVO   " + STRING(c-json-new)).
      
         RUN pi-gerar-dados-extrato (">> passou piIntegraPedido ").
       
         ASSIGN lcEnvio =  c-json-new
                lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
        
         ASSIGN es-api-log.cJson = lcEnvio.
          
         COPY-LOB lcEnvio TO es-api-log.cl-envio.
       
         RUN pi-chamada-2.
       
      END.
   END.
END.



/***** Fim *****/

                                                               
PROCEDURE pi-gera-json.

  for each tt-ped-venda,
     first emitente no-lock
     where emitente.cod-emitente = tt-ped-venda.cod-emitente,
     first int-ped-venda no-lock 
     where int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido,
     first repres no-lock
     where repres.nome-abrev = tt-ped-venda.no-ab-reppri,
     FIRST transporte no-lock
     where transporte.nome-abrev = tt-ped-venda.nome-transp,
     first natur-oper no-lock
     where natur-oper.nat-operacao = tt-ped-venda.nat-operacao:

    assign oJsonPedido = new JsonObject().
    
    if int-ped-venda.origem <> "" and int-ped-venda.origem <> ? then
      assign cOrigem = int-ped-venda.origem.
    else
      assign cOrigem = "Totvs".

    
    ASSIGN c-supervisor =  substring(int-ped-venda.char-1, 68, 8).

    IF c-supervisor = '        ' OR 
       c-supervisor = " " THEN ASSIGN c-supervisor = ''.

    ASSIGN de-ipi = 0
           de-st  = 0.
    for each tt-ped-item:
        ASSIGN de-ipi = de-ipi + tt-ped-item.val-ipi
               de-st  = de-st + (tt-ped-item.vl-tot-it - tt-ped-item.vl-liq-it - tt-ped-item.val-ipi).
    END.

    FIND LAST historico-credito 
         WHERE historico-credito.nome-abrev = tt-ped-venda.nome-abrev
           AND historico-credito.nr-pedcli  = tt-ped-venda.nr-pedcli
        NO-LOCK NO-ERROR.
    IF AVAIL historico-credito                  AND
      historico-credito.tipo-movto    = "Aprov" THEN
      ASSIGN c-status = 'Aprovado'
             c-motivo = ''.
    ELSE 
      ASSIGN c-status = {diinc/i03di159.i 04 tt-ped-venda.cod-sit-aval}
             c-motivo = tt-ped-venda.desc-bloq-cr.


    oJsonPedido:add("accountExternalId", substring(tt-ped-venda.pais, 1, 2) + emitente.cgc).
    oJsonPedido:add("externalId", tt-ped-venda.nr-pedido).
    oJsonPedido:add("erpOrderId", tt-ped-venda.nr-pedido).
    oJsonPedido:add("externalOrderId", int-ped-venda.nr-pedido-externo).
    oJsonPedido:add("accountCurrency", tt-ped-venda.mo-codigo).
    oJsonPedido:add("finallity", string(fcGetDescFinallity(tt-ped-venda.cod-des-merc)) ).
    oJsonPedido:add("siteCode", tt-ped-venda.cod-estabel).
    oJsonPedido:add("shippingCost", int-ped-venda.vl-frete).
    oJsonPedido:add("representativeCode", repres.cod-rep).
    oJsonPedido:add("paymentCondition", tt-ped-venda.cod-cond-pag).
    oJsonPedido:add("origin", cOrigem).
    oJsonPedido:add("partialBillingAllowed", false).
    oJsonPedido:add("supervisorRegistration", c-supervisor).
    oJsonPedido:add("orderComments", tt-ped-venda.observacoes).
    oJsonPedido:add("effectiveDate", tt-ped-venda.dt-implant).
    oJsonPedido:add("attendantCode", tt-ped-venda.tp-pedido).
    oJsonPedido:add("status", {diinc/i03di149.i 04 tt-ped-venda.cod-sit-ped}).
    oJsonPedido:add("estimatedDeliveryDate", tt-ped-venda.dt-entrega).
    oJsonPedido:add("shippingCompany", transporte.nome-abrev).
    oJsonPedido:add("shippingCompanyCode", transporte.cod-transp).
    oJsonPedido:add("operationNatureCode", natur-oper.nat-operacao).
    oJsonPedido:add("operationNature", natur-oper.denominacao).
    oJsonPedido:add("IPITotalValue", de-ipi).
    oJsonPedido:add("STTotalValue", de-st).
    oJsonPedido:add("financialStatus", c-status).
    oJsonPedido:add("reasonFinancialStatus", c-motivo).
    IF SUBSTR(int-ped-venda.char-1,80,12) > '' THEN
       oJsonPedido:ADD("contract", SUBSTRING(int-ped-venda.char-1,80,8)).
    IF tt-ped-venda.dt-apr-cred <> ? THEN
    oJsonPedido:add("creditAssessmentData", tt-ped-venda.dt-apr-cred).

    for each tt-ped-item:
     FIND FIRST mgesp.int-ped-item-pci
          WHERE int-ped-item-pci.nr-pedcli    = tt-ped-venda.nr-pedcli
            AND int-ped-item-pci.nome-abrev   = tt-ped-venda.nome-abrev
            AND int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
            AND int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia NO-LOCK NO-ERROR.
     IF AVAIL int-ped-item-pci THEN DO:
        IF cTbPreco = '' THEN
           ASSIGN cTbPreco = int-ped-item-pci.nr-tabpre.
        IF cTbPreco <> '' THEN
           IF int-ped-item-pci.nr-tabpre <> cTbPreco  THEN
              ASSIGN cTbPreco = 'STD'.
     END.
    END.
    IF cTbPreco = '' THEN
       ASSIGN cTbPreco = 'STD'.

    oJsonPedido:add("priceBook", cTbPreco). // tabela de pre‡os do cabe‡alho

    assign oJsonItensPedido = new JsonArray().

    for each tt-ped-item:
      
      assign oJsonItemPedido = new JsonObject().

      
      FIND FIRST mgesp.int-ped-item-pci
          WHERE int-ped-item-pci.nr-pedcli    = tt-ped-venda.nr-pedcli
            AND int-ped-item-pci.nome-abrev   = tt-ped-venda.nome-abrev
            AND int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
            AND int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia NO-LOCK NO-ERROR.
      IF AVAIL int-ped-item-pci THEN
         ASSIGN cTbPreco = int-ped-item-pci.nr-tabpre.
      ELSE 
        ASSIGN cTbPreco = "STD".


      IF (tt-ped-item.vl-tot-it / (tt-ped-item.qt-pedida - tt-ped-item.qt-atendida)) > 0 THEN
          oJsonItemPedido:add("unitPrice", (tt-ped-item.vl-tot-it / (tt-ped-item.qt-pedida - tt-ped-item.qt-atendida))).
      ELSE DO:
         FIND LAST nota-fiscal
             WHERE nota-fiscal.nr-pedcli = tt-ped-venda.nr-pedcli
               AND nota-fiscal.nome-ab-cli = tt-ped-venda.nome-abrev NO-LOCK NO-ERROR.
         IF AVAIL nota-fiscal THEN
            FIND FIRST it-nota-fisc OF nota-fiscal
                 WHERE it-nota-fisc.it-codigo  = tt-ped-item.it-codigo
                   AND it-nota-fisc.nr-seq-ped = tt-ped-item.nr-sequencia NO-LOCK NO-ERROR.
            IF AVAIL it-nota-fisc THEN
               oJsonItemPedido:add("unitPrice", it-nota-fisc.vl-tot-item / it-nota-fisc.qt-faturada[1]). 
            ELSE 
               oJsonItemPedido:add("unitPrice", tt-ped-item.vl-tot-it / tt-ped-item.qt-pedida ). 
      END.
      
      oJsonItemPedido:add("sequence", tt-ped-item.nr-sequencia).
      IF AVAIL int-ped-item-pci THEN
         oJsonItemPedido:add("quantityDiscount", int-ped-item-pci.desc-quant ).
      oJsonItemPedido:add("quantity", tt-ped-item.qt-pedida).
      oJsonItemPedido:add("productCode", tt-ped-item.it-codigo).

      IF AVAIL int-ped-item-pci THEN
         oJsonItemPedido:add("commercialDiscount", int-ped-item-pci.desc-comerical ).
      oJsonItemPedido:add("implantationDate", tt-ped-item.dt-userimp).
      oJsonItemPedido:add("estimatedDeliveryDate", tt-ped-item.dt-entrega).
      oJsonItemPedido:add("billedQuantity", tt-ped-item.qt-pedida).
      oJsonItemPedido:add("deliveredQuantity", tt-ped-item.qt-atendida).
      oJsonItemPedido:add("itemStatus",  {diinc/i03di149.i 04 tt-ped-item.cod-sit-item}).
      oJsonItemPedido:add("IPIValue", tt-ped-item.val-ipi).
      oJsonItemPedido:add("IPIPercent", tt-ped-item.aliquota-ipi).
      oJsonItemPedido:add("ICMSSTValue", (tt-ped-item.vl-tot-it - tt-ped-item.vl-liq-it - tt-ped-item.val-ipi)).
      oJsonItemPedido:add("priceBook", cTbPreco).


      oJsonItensPedido:add(oJsonItemPedido).

    end.

    oJsonPedido:add("OrderItems", oJsonItensPedido).
  end.

end procedure. 

PROCEDURE piHeader :
   DEF INPUT PARAM iSeq   AS i NO-UNDO.
   DEF INPUT PARAM cChave AS c NO-UNDO.
   DEF INPUT PARAM cValor AS c NO-UNDO.
   CREATE ttHeader.
   ASSIGN
      ttHeader.Seq   = iSeq  
      ttHeader.Chave = cChave
      ttHeader.Valor = cValor
      .

END PROCEDURE.


PROCEDURE pi-chamada-2.

 DEF VAR JsonString     AS LONGCHAR                      NO-UNDO.
 DEF VAR oRequest       as IHttpRequest                  NO-UNDO.
 DEF VAR oResponse      as IHttpResponse                 NO-UNDO.
 DEF VAR oJsonObject    AS JsonObject                    NO-UNDO.
 DEF VAR oJsonEntity    AS JsonArray                     NO-UNDO.
 DEF VAR oClient        AS IHttpClient                   NO-UNDO.
 DEF VAR myLongchar     AS LONGCHAR                      NO-UNDO.
 DEF VAR myParser       AS ObjectModelParser             NO-UNDO.
 DEF VAR Json           AS JsonObject                    NO-UNDO.
 DEF VAR cAux           AS LONGCHAR                      NO-UNDO.

 ASSIGN cAux = es-api-log.cJSON.

 RUN pi-gerar-dados-extrato (">> CHAMADA 2 ").

 IF cAux > "" THEN DO:

    //CLIPBOARD:VALUE = cAux.

    myLongchar = es-api-log.cJSON.
    myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).

    ASSIGN es-api-log.cl-envio = myLongchar.

    myParser = NEW ObjectModelParser().

    Json = CAST(myParser:Parse(myLongchar), JsonObject).
 END.

 oRequest = RequestBuilder:PUT(c-endereco, Json)
           :ContentType('application/json')
           :AcceptJson()
           :Request.

 oResponse = ClientBuilder:Build():Client:EXECUTE(oRequest) NO-ERROR.

 IF ERROR-STATUS:ERROR = YES THEN DO:
     DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        RUN piErro (ERROR-STATUS:GET-MESSAGE(i),"").
     END.
 END.

 CASE TRUE:
     WHEN TYPE-OF(oResponse:Entity, JsonObject) 
     THEN DO:
        oJsonObject = CAST(oResponse:Entity, JsonObject). 
        JsonString = oJsonObject:getJsonText().
     END.
 END CASE.

 COPY-LOB JsonString TO es-api-log.cl-retorno.

 IF oResponse:StatusCode >= 300
 THEN DO:
    RUN piErro ("Ocorreram erros no envio - " + 
                STRING(oResponse:statusCode)  + 
                " - " + 
                STRING(oResponse:StatusReason) + 
                STRING(JsonString)
                ,"").
 END.

 ASSIGN es-api-log.retorno-content-type = oResponse:ContentType 
        es-api-log.cod-retorno          = STRING(oResponse:StatusCode)
        es-api-log.dh-retorno           = NOW
        es-api-log.dh-request 	        = NOW
        es-api-log.flg-processado = YES.


 RUN pi-gerar-dados-extrato (">> Depois da Funcao fc-chamada-2 ").
 RUN pi-gerar-dados-extrato (">> RETORNO INTEGRA --- " + string(es-api-log.cod-retorno)).

 RETURN es-api-log.cod-retorno.

END PROCEDURE.




function fcGetDescFinallity returns character ( iFinallity as integer) :
  case iFinallity:
    when 1 then return "Revenda/Industrializacao".
    when 2 then return "Consumo Proprio".
    otherwise   return "Finalidade Nao Definida".
  end case.
end function.

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
