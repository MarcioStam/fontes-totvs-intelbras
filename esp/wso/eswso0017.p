/*****************************************************************************
** Programa..............: eswso0017.p
** Descri‡Æo.............: Integra‡Æo titulos ACR x DEPS
** Autor.................: Andrey M Oliveira
*****************************************************************************/

{esp/wso/eswso0017.i1}

DEF TEMP-TABLE tt_tit_acr_deps NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

{esp/wso/eswso0017.i}

DEF INPUT PARAM TABLE FOR tt_tit_acr_deps.
DEF OUTPUT PARAM p_cod_return AS CHAR NO-UNDO.

EMPTY TEMP-TABLE tt_tit_acr.

RUN pi-gera-json.

FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0        NO-LOCK NO-ERROR.
FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'integraTitDEPS' NO-LOCK NO-ERROR.

IF NOT AVAIL es-api-URI THEN NEXT.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10
       es-api-log.id-aplicacao   = 'DEP'
       es-api-log.id-codigo      = "1"
       es-api-log.id-URI         = 'integraTitDEPS'
       es-api-log.dh-request     = NOW
       es-api-log.flg-processado = NO
       es-api-log.Origem         = bf-las-api-log.Origem
       es-api-log.aux            = "1"
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).

ASSIGN cJSON-aux = c-jason.

ASSIGN lcEnvio = c-jason
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

ASSIGN c-endereco = es-api-URI.end-tst.

COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF  lcEnvio > "" THEN DO:
    fc-chamada-2().

    ASSIGN p_cod_return = es-api-log.cod-retorno WHEN AVAIL es-api-log.

    RETURN es-api-log.cod-retorno.
END.
