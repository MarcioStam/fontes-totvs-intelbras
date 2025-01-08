/****************************************************************************
** Programa..: ESWSO0021
** Descricao.: Integra‡Æo de clientes com o DEPS.
** Autor.....: Andrey M Oliveira
** Data......: 27/12/2022
*****************************************************************************/

{esp/wso/eswso0022.i1}

DEF INPUT PARAM p_cod_emit LIKE emitente.cod-emit NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEF VAR l-producao AS LOG      NO-UNDO.

{esp/es0018.i}
{esp/wso/eswso0022.i}

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF  AVAIL tt-prog-ponto
AND tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

/*
IF  OPSYS = 'UNIX' THEN DO:                                
    OUTPUT TO "/mnt/spool/an052677/log_deps_sales.txt" APPEND.
    PUT UNFORMATTED "1 - eswso0022 - p_cod_emit " p_cod_emit SKIP.
    OUTPUT CLOSE.                                
END.
*/

RUN pi-gera-json.

FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0         NO-LOCK NO-ERROR.
FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'integraEmitDEPS' NO-LOCK NO-ERROR.

IF NOT AVAIL es-api-URI THEN NEXT.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  + 10 ELSE 10
       es-api-log.id-aplicacao   = 'DEP'
       es-api-log.id-codigo      = "1"
       es-api-log.id-URI         = 'integraEmitDEPS'
       es-api-log.dh-request     = NOW
       es-api-log.end-envio      = IF l-producao = YES THEN es-api-URI.ent-PRD ELSE es-api-URI.end-tst
       es-api-log.flg-processado = NO
       es-api-log.Origem         = bf-las-api-log.Origem
       es-api-log.aux            = "1"
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).

ASSIGN cJSON-aux = c-jason.

ASSIGN lcEnvio = c-jason
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

ASSIGN es-api-log.cJson = lcEnvio. /* teste */

ASSIGN c-endereco = IF l-producao = YES THEN es-api-URI.ent-PRD ELSE es-api-URI.end-tst.

COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF  lcEnvio > "" THEN DO:
    IF  OPSYS = 'UNIX' THEN DO:
        RUN pi-chamada-1.
    END.
    ELSE DO:
        fc-chamada-2().
    END.
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
