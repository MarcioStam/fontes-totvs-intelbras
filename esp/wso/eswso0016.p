/*****************************************************************************
** Programa..............: eswso0016.p
** Descri‡Æo.............: Integra‡Æo cadastros complementares DEPS
** Autor.................: Andrey M Oliveira
*****************************************************************************/

{esp/wso/eswso0017.i1} 
{esp/wso/eswso0016.i} 

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEF INPUT PARAM TABLE FOR tt_categ_cad.

RUN pi-gera-json.

FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0        NO-LOCK NO-ERROR.
FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'integraCadDEPS' NO-LOCK NO-ERROR.

IF NOT AVAIL es-api-URI THEN NEXT.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10
       es-api-log.id-aplicacao   = 'DEP'
       es-api-log.id-codigo      = "1"
       es-api-log.id-URI         = 'integraCadDEPS'
       es-api-log.dh-request     = NOW
       //es-api-log.end-envio      = es-api-URI.ent-prd
       es-api-log.flg-processado = NO
       es-api-log.Origem         = bf-las-api-log.Origem
       es-api-log.aux            = "1"
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
       /*es-api-log.cJson          = c-jason.*/

ASSIGN cJSON-aux = c-jason.

ASSIGN lcEnvio = c-jason /*es-api-log.cjson*/
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

ASSIGN c-endereco = es-api-URI.end-tst.

COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF STRING(lcEnvio) > "" THEN
   fc-chamada-2().
