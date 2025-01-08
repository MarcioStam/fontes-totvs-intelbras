/***********************************************************************************************
** Integra produtos liberados para condi‡Æo de pagamento 
***********************************************************************************************/
{esp/esapi505.i} 
{esp/wso/eswso0015.i} 

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE INPUT        PARAM row-table AS ROWID NO-UNDO.
DEFINE input-output PARAM table     for tt-cond.
DEFINE INPUT        PARAM evento    AS CHARACTER NO-UNDO.

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
  WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0015' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
  ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
  ASSIGN l-log = YES.
ELSE
  ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:

    
    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0015'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0015'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
END.


IF SEARCH("esp/wso/out/wso0015.r") <> ?
OR SEARCH("esp/wso/out/wso0015.p") <> ? 
   AND evento = 'PUT' THEN DO:
    run esp/wso/out/wso0015.p  (INPUT  row-table,
                                input-output table tt-cond).
END.


FOR EACH tt-cond BREAK BY tt-cond.cond-pagto:
        
    RUN pi-gerar-dados-extrato (INPUT 'Exportando CondPag: ' + STRING(tt-cond.cond-pagto) + '/' + STRING(tt-cond.it-codigo) + ' ' + evento).
    RUN pi-gera-json.
    
    ASSIGN c-jason = JsonAPIUtils:getJsonArrayChar(arrayCond).
    
    
    FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0        NO-LOCK NO-ERROR.
    
    IF evento = 'PUT' THEN
        FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'integraCPagtoIt' NO-LOCK NO-ERROR.
    ELSE FIND FIRST es-api-URI    WHERE es-api-URI.id-URI = 'deleteCPagtoItem' NO-LOCK NO-ERROR.
    

    IF NOT AVAIL es-api-URI THEN NEXT.
    IF l-producao
       THEN ASSIGN c-endereco       = es-api-URI.ent-PRD.
       ELSE ASSIGN c-endereco       = es-api-URI.end-TST.

    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10  
           es-api-log.id-aplicacao   = 'CRM'
           es-api-log.id-codigo      = IF AVAIL tt-cond THEN string(tt-cond.cond-pagto) + '/' + STRING(tt-cond.it-codigo) ELSE '0'
           es-api-log.id-URI         = IF evento = 'PUT' THEN 'integraCPagtoIt' ELSE 'deleteCPagtoItem'
           es-api-log.dh-request     = NOW
           es-api-log.end-envio      = c-endereco
           es-api-log.flg-processado = NO
           es-api-log.Origem         = 'TOTVS'
           es-api-log.aux            = IF AVAIL tt-cond THEN  string(tt-cond.cond-pagto) + '/' + STRING(tt-cond.it-codigo) ELSE '0'
           es-api-log.cJson          = c-jason
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
    
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
    
    IF STRING(lcEnvio) > "" THEN 
       fc-chamada-2().
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

