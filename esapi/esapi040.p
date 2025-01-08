/****************************************************************************
** Programa : 
** Descricao: 
**     Autor: Isac Abrahao
**      Data: 18/04/2024
*****************************************************************************/

{esp/esapi505.i}

DEF INPUT PARAM pItem   AS CHAR NO-UNDO.
DEF INPUT param pCelula AS CHAR NO-UNDO.

DEFINE VARIABLE objMES   AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayMES AS jsonArray  NO-UNDO.

DEFINE VARIABLE cJson   AS CHAR  NO-UNDO.
DEFINE VARIABLE cItem   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-result       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo-log1 AS CHARACTER NO-UNDO.

DEFINE VARIABLE my-datetime-tz AS DATETIME-TZ NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.

IF  OPSYS = 'UNIX' THEN    
    ASSIGN c-arquivo-log1 = "/usr/wrk/totvs/UNIX_ESCPP02_MES.txt".
ELSE
    ASSIGN c-arquivo-log1 = "\\erpapp\spool\totvs\UNIX_ESCPP02_MES.txt".

RUN pi-gerar-dados-extrato ( CHR(13) + CHR(13) + " Inicio"  + " - " + STRING(DATETIME(TODAY, MTIME))).

/* Inicio do Programa */                

ASSIGN objMES   = NEW JsonObject().
ASSIGN arrayMES = NEW JsonArray(). 

ASSIGN my-datetime-tz = NOW.

objMES:ADD("resCode" , pCelula).
objMES:ADD("item" , pItem). 
objMES:ADD("status", "OK").
objMES:ADD("version", 1). 
objMES:ADD("date"  , my-datetime-tz). 

RUN pi-gerar-dados-extrato ('Item : ' + pItem + ' - / Celula: ' + pCelula + ' - ' + STRING(my-datetime-tz)).

arrayMES:ADD(objMES).
   
cJson = JsonAPIUtils:getJsonArrayChar(arrayMES).

FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'mqttOrdemProd' NO-LOCK NO-ERROR.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10 
       es-api-log.id-aplicacao   = 'MES'
       es-api-log.id-codigo      = pItem + '-' + pCelula + '-' + STRING(my-datetime-tz)
       es-api-log.id-URI         = es-api-URI.id-URI
       es-api-log.Origem         = es-api-URI.id-URI
       //es-api-log.aux            = ferr-prod.cod-ferr-prod
       es-api-log.cJson          = cJson
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
   
ASSIGN c-endereco = es-api-URI.ent-PRD. //URL

ASSIGN lcEnvio = es-api-log.cjson
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF STRING(lcEnvio) > "" THEN 
   fc-chamada-2().

RELEASE es-api-URI.

ASSIGN c-result = es-api-log.cod-retorno + ' ' + string(es-api-log.cl-retorno).

RUN pi-gerar-dados-extrato ('Resultado: ' + c-result + ' - ' + STRING(es-api-log.seqexec)).

/* Fim do Programa */

PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT  p-string  FORMAT "x(200)" SKIP.
       OUTPUT CLOSE. 
    
    end.
END PROCEDURE.
