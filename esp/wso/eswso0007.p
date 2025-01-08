/*****************************************************************************************
 INTEGRA?€O DE ITENS COM O CRM
******************************************************************************************/ 
{esp/esapi505.i} 
{esp/wso/eswso0007.i} 

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE INPUT PARAMETER c-it-codigo  AS character NO-UNDO.
DEF VAR c-arquivo-log1              AS CHAR NO-UNDO.

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

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
   ASSIGN l-producao = YES.
ELSE
   ASSIGN l-producao = NO.


EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                   INPUT 2,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0007' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:
    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0007'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0007'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

END.


CREATE tt-item.
ASSIGN tt-item.it-codigo = c-it-codigo.

IF SEARCH("esp/wso/out/wso0007.r") <> ?
OR SEARCH("esp/wso/out/wso0007.p") <> ? THEN DO:
    run esp/wso/out/wso0007.p  (input-output table tt-item,
                                input-output table tt-prod-composto).
END.

FOR EACH tt-item:

    RUN pi-gerar-dados-extrato (INPUT 'Exportando Item: ' + STRING(tt-item.it-codigo)).
    RUN pi-gera-json.
    
    ASSIGN c-jason = JsonAPIUtils:getJsonArrayChar(arrayItem).
    
    
    FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0        NO-LOCK NO-ERROR.
    FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'integraItemCRM' NO-LOCK NO-ERROR.
    
    IF NOT AVAIL es-api-URI THEN NEXT.
    
    IF l-producao THEN 
       ASSIGN c-endereco = es-api-URI.ent-PRD.
    ELSE 
       ASSIGN c-endereco = es-api-URI.end-TST.

    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10  
           es-api-log.id-aplicacao   = 'CRM'
           es-api-log.id-codigo      = c-it-codigo
           es-api-log.id-URI         = 'integraItemCRM'
           es-api-log.dh-request     = NOW
           es-api-log.end-envio      = c-endereco
           es-api-log.flg-processado = NO
           es-api-log.Origem         = 'Totvs'
           es-api-log.aux            = c-it-codigo
           es-api-log.cJson          = c-jason
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
    
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
    
    IF STRING(lcEnvio) > "" THEN DO:
         
         IF  OPSYS = 'UNIX' THEN DO:
             RUN pi-chamada-1.
            // fc-chamada-1().
         END.
         ELSE DO:
             fc-chamada-2().
         END.
       
    END.

END.



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


PROCEDURE pi-chamada-1.
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
    DEF VAR cArq           AS CHAR                          NO-UNDO.

    ASSIGN cAux = es-api-log.cJSON.

    IF  cAux > "" THEN DO:

       CLIPBOARD:VALUE = cAux.

       myLongchar = es-api-log.cJSON.
       myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).

       ASSIGN es-api-log.cl-envio = myLongchar.

       myParser = NEW ObjectModelParser().

       Json = CAST(myParser:Parse(myLongchar), JsonObject).
       
    END.

    oRequest = RequestBuilder:Post(c-endereco, Json)
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
           JsonString = STRING(oJsonObject:getJsonText()).
        END.
    END CASE.

    COPY-LOB JsonString TO es-api-log.cl-retorno.

    IF oResponse:StatusCode >= 300 THEN DO:
        
       RUN piErro ("Ocorreram erros no envio - " + 
                   STRING(oResponse:statusCode)  + 
                   " - " + 
                   STRING(oResponse:StatusReason) + 
                   STRING(JsonString)
                   ,"").
    END.

    ASSIGN es-api-log.retorno-content-type = oResponse:ContentType 
           es-api-log.cod-retorno          = STRING(oResponse:StatusCode)
           es-api-log.dh-retorno           = NOW.

    RETURN es-api-log.cod-retorno.

END PROCEDURE.
