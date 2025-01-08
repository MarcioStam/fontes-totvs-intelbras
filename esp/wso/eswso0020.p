/********************************************************************************
 ** Programa..: eswso0020.p
 ** Data......: 26/12/2022
 ** Objetivo..: Integra‡Æo do status de escritura‡Æo das NFS para o V360.
********************************************************************************/

{esp/wso/eswso0020.i1}
{esp/es0018.i}

DEF INPUT PARAM p_row_nota AS ROWID NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

{esp/wso/eswso0020.i}

/*
OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
PUT UNFORMATTED "0.1 - eswso0020" skip(2).
OUTPUT CLOSE.  
*/

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF  AVAILABLE tt-prog-ponto
AND tt-prog-ponto.conteudo = "PRODUCAO":U THEN
   ASSIGN l-producao = YES.
ELSE
   ASSIGN l-producao = NO.

FIND LAST bf-las-api-log 
    WHERE bf-las-api-log.id-api-log > 0 NO-LOCK NO-ERROR.

FIND FIRST es-api-URI
    WHERE es-api-URI.id-URI = 'integraNotaV360' NO-LOCK NO-ERROR.

IF  NOT AVAIL es-api-URI THEN 
    NEXT.

RUN pi-gera-json.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10
       es-api-log.id-aplicacao   = 'V36'
       es-api-log.id-codigo      = "1"
       es-api-log.id-URI         = 'integraNotaV360'
       es-api-log.dh-request     = NOW
       //es-api-log.end-envio      = es-api-URI.ent-prd
       es-api-log.flg-processado = NO
       es-api-log.Origem         = bf-las-api-log.Origem
       es-api-log.aux            = "1"
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).

ASSIGN cJSON-aux = c-jason.

ASSIGN lcEnvio = c-jason
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

IF  l-producao THEN 
    ASSIGN c-endereco = es-api-URI.ent-PRD + docto-orig-nfse.cod-livre-1.
ELSE 
    ASSIGN c-endereco = es-api-URI.end-TST + docto-orig-nfse.cod-livre-1.

COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF  lcEnvio > "" THEN
    fc-chamada-2().
