/*------------------------------------------------------------------------
    File        : espdp100rp.p
    Purpose     : Envia Condi‡Æo Pagamento Salesforce
    Syntax      : <none>
    Description : <none>

------------------------------------------------------------------------*/
{esp/esapi505.i} 
{esp/pdp/espdp100.i}

{include/i-prgvrs.i espdp100 2.00.00.000}  /*** 010000 ***/

{utp/ut-glob.i}
{include/i-rpvar.i}
{include/i-freeac.i}

{utp/utapi019.i}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
/* Parameters Definitions ---                                           */

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.


create tt-param.
raw-transfer raw-param to tt-param.

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


/* ***************************  Main Block  *************************** */


FIND LAST param-global NO-LOCK NO-ERROR.


assign c-programa     = "ESPDP100"
       c-sistema      = "Envia Condi‡Æo Pagamento Salesforce"
       c-titulo-relat = "Envia Condi‡Æo Pagamento Salesforce"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
{include/i-rpcab.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

    
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

RUN pi-enviar-condpag IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-enviar-condpag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH cond-pagto NO-LOCK,
     FIRST int-cond-pagto 
     WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK:

    RUN pi-acompanhar IN h-acomp (INPUT cond-pagto.cod-cond-pag).

    RUN pi-gera-json.
    
    ASSIGN c-jason = JsonAPIUtils:getJsonArrayChar(arrayCondpag).
    
    FIND LAST bf-las-api-log
        WHERE bf-las-api-log.id-api-log > 0         NO-LOCK NO-ERROR.
    
    FIND FIRST es-api-URI    
         WHERE es-api-URI.id-URI = 'integraCondPag' NO-LOCK NO-ERROR.

    IF NOT AVAIL es-api-URI THEN NEXT.
    IF l-producao
       THEN ASSIGN c-endereco       = es-api-URI.ent-PRD.
       ELSE ASSIGN c-endereco       = es-api-URI.end-TST.

    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10  
           es-api-log.id-aplicacao   = 'CRM'
           es-api-log.id-codigo      = string(cond-pagto.cod-cond-pag)
           es-api-log.id-URI         = 'integraCondPag' 
           es-api-log.dh-request     = NOW
           es-api-log.end-envio      = c-endereco
           es-api-log.flg-processado = NO
           es-api-log.Origem         = bf-las-api-log.Origem
           es-api-log.aux            = string(cond-pagto.cod-cond-pag)
           es-api-log.cJson          = c-jason
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
    
    
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
       
    IF STRING(lcEnvio) > "" THEN 
       fc-chamada-2().


  END.

  RETURN "OK":U.

END PROCEDURE.


