/****************************************************************************
** Programa..: ESWSO0021
** Descricao.: Requisi‡Æo de limite de credito ao DEPS.
** Autor.....: Andrey M Oliveira
** Data......: 27/12/2022
*****************************************************************************/

{esp/wso/eswso0021.i1}
{esp/es0018.i}

DEF INPUT  PARAM p_cod_emit LIKE emitente.cod-emit NO-UNDO.
DEF OUTPUT PARAM p_cod_erro AS CHAR                NO-UNDO.
DEF OUTPUT PARAM p_return   AS CHAR                NO-UNDO.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stringToDate Include 
FUNCTION stringToDate RETURNS DATE
  ( cDate AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER b-emitente     FOR emitente.

DEF VAR l-criado   AS LOG      NO-UNDO.
DEF VAR l-producao AS LOG      NO-UNDO.
DEF VAR c-json-new AS LONGCHAR NO-UNDO.
DEF VAR c-jason    AS CHAR     NO-UNDO.

/* Inicio */ 
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

FIND FIRST es-api-URI 
    WHERE es-api-URI.id-URI = 'integraRequisLim' NO-LOCK NO-ERROR.

IF  NOT AVAIL es-api-URI THEN 
    LEAVE.

FIND LAST bf-las-api-log NO-LOCK 
    WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-log
    WHERE es-api-log.id-aplicacao = 'DEP'
    AND   es-api-log.id-URI       = 'integraRequisLim'
    AND   es-api-log.seqexec      = bf-las-api-log.seqexec NO-LOCK NO-ERROR.

IF  NOT AVAIL es-api-log THEN DO:
    CREATE es-api-log.
    ASSIGN es-api-log.seqexec      = bf-las-api-log.seqexec + 10   
           es-api-log.id-aplicacao = 'DEP'
           es-api-log.id-URI       = es-api-URI.id-URI
           es-api-log.origem       = es-api-URI.id-URI
           es-api-log.id-api-log   = NEXT-VALUE(seq_api_log).
   
    FIND CURRENT es-api-log NO-LOCK NO-ERROR.

    RUN pi-metodo-get. 
END.
ELSE
    RUN pi-metodo-get.

/************************* Procedures *************************/
PROCEDURE pi-metodo-get:
    DEF VAR myParserAux  AS ObjectModelParser NO-UNDO.
    DEF VAR JsonAux      AS JsonObject        NO-UNDO.
    DEF VAR objDadosCad  AS JsonObject        NO-UNDO.
    DEF VAR objAnalise   AS JsonObject        NO-UNDO.
    DEF VAR oJsonArray   AS jsonArray         NO-UNDO.
    DEF VAR oJsonObj     AS jsonObject        NO-UNDO.
    DEF VAR i            AS INTEGER           NO-UNDO.
    DEF VAR v_cgc        AS CHAR              NO-UNDO.

    FIND FIRST emitente
        WHERE emitente.cod-emit = p_cod_emit NO-LOCK NO-ERROR.

    IF  AVAIL emitente THEN DO:

        FIND FIRST int-emitente
            WHERE int-emitente.cod-emit = emitente.cod-emit NO-LOCK NO-ERROR.

        IF  AVAIL int-emitente THEN DO:
            ASSIGN v_cgc = REPLACE(REPLACE(REPLACE(replace(emitente.cgc,'.',''),' ',''),'-',''),'/','').

            ASSIGN //es-api-URI.metodo = 'GET' 
                   c-endereco        = IF l-producao = YES THEN es-api-URI.ent-PRD + v_cgc + "/" + string(int-emitente.cod-gr-cob) 
                                                           ELSE es-api-URI.end-tst + v_cgc + "/" + string(int-emitente.cod-gr-cob).
        
            IF  OPSYS = 'UNIX' THEN
                RUN pi-chamada-1.
            ELSE
                fc-chamada-2().

            IF  SUBSTRING(es-api-log.cod-retorno,1,2) >= "300" THEN DO:
                ASSIGN p_return   = "NOK"
                       p_cod_erro = SUBSTRING(es-api-log.cod-retorno,1,2).
            END.
            ELSE DO:
                myParserAux = NEW ObjectModelParser().
                JsonAux     = CAST(myParserAux:Parse(cLongJson), JsonObject).
                objDadosCad = CAST(myParserAux:Parse(string(JsonAux:GetJsonText("dadosCadastrais"))),JsonObject).
                objAnalise  = CAST(myParserAux:Parse(string(JsonAux:GetJsonText("resultadoAnalise"))),JsonObject).
        
                /*MESSAGE "razaoSocial: "       string(objDadosCad:GetJsonText("razaoSocial"))                        SKIP
                        "documento: "         string(objDadosCad:GetJsonText("documento"))                          SKIP
                        "situacaoCadastral: " string(objDadosCad:GetJsonText("situacaoCadastralInscricaoEstadual")) SKIP
                        "naturezaJuridica: "  string(objDadosCad:GetJsonText("naturezaJuridica"))                   SKIP
                        "regimeTributario: "  string(objDadosCad:GetJsonText("regimeTributario"))                   SKIP
                        "politica: "          string(objAnalise:GetJsonText("politica"))                            SKIP
                        "classificacao: "     string(objAnalise:GetJsonText("classificacao"))                       SKIP
                        "ValidadeAnalise: "   stringToDate(string(objAnalise:GetJsonText("dataValidadeAnalise")))   SKIP
                        "limiteSugerido: "    string(objAnalise:GetJsonText("limiteSugerido"))                      SKIP
                        "limiteAdotado: "     string(objAnalise:GetJsonText("limiteAdotado")) 
                        VIEW-AS ALERT-BOX.*/
        
                ASSIGN p_return = "OK".
            END.
        END.
    END.
END PROCEDURE.

FUNCTION stringToDate RETURNS DATE
    (cDate AS CHAR).

    DEF VAR iAno AS INT.
    DEF VAR iMes AS INT.
    DEF VAR iDia AS INT.

    ASSIGN iAno = INT(SUBSTRING(REPLACE(cDate,"-",""),9,4))
           iMes = INT(SUBSTRING(REPLACE(cDate,"-",""),5,2))
           iDia = INT(SUBSTRING(REPLACE(cDate,"-",""),1,2)).

    RETURN DATE(iMes,iDia,iAno).

END FUNCTION.


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

    IF cAux > "" THEN DO:

       CLIPBOARD:VALUE = cAux.

       myLongchar = es-api-log.cJSON.
       myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).

       FIND CURRENT es-api-log EXCLUSIVE-LOCK NO-ERROR.

       ASSIGN es-api-log.cl-envio = myLongchar.

       FIND CURRENT es-api-log NO-LOCK NO-ERROR.

       myParser = NEW ObjectModelParser().

       Json = CAST(myParser:Parse(myLongchar), JsonObject).       
    END.

    oRequest = RequestBuilder:get(c-endereco /*, Json*/)
              /*:ContentType('application/json')
              :AcceptJson()*/
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

    FIND CURRENT es-api-log EXCLUSIVE-LOCK NO-ERROR.

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

    FIND CURRENT es-api-log NO-LOCK NO-ERROR.

    RETURN es-api-log.cod-retorno.

END PROCEDURE.
