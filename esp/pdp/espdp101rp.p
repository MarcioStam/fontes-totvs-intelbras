using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.URI.
using progress.Json.ObjectModel.ObjectModelParser.
using progress.Json.*.
using progress.Json.ObjectModel.*.

/****************************************************************************************************
** Intelbras - Catia Schmauch
**
** API para cria‡Æo dos beneficios do pci
**
** 08/06/2021 - VERSÇO INICIAL
**

Dados de entrada:

{
    "totalSize": 943,
    "done": true,
    "records": [
        {
            "id": "a2A3I0000001JeTUAU",
            "isDeleted": false,
            "accountExternalId": "BR01455957000195",
            "active": true,
            "discountPercent": 1.0,
            "infringementBlocking": false,
            "productFamily": null,
            "segmentExternalId": 1001,
            "segmentName": "Comunicacao Corporativa",
            "familyCode": null,
            "typeOfBenefit": null
         }
         ]
       }     
   
 : = %3A
- = %2B
Ex: 2022-10-13T10:41:38.156-03:00 = 2022-10-13T10%3A41%3A38%2B03:00
LAST_90_DAYS
LAST_FISCAL_QUARTER
LAST_FISCAL_YEAR
LAST_MONTH
LAST_N_DAYS:n
LAST_N_FISCAL_QUARTERS:n
LAST_N_FISCAL_YEARS:n
LAST_N_MONTHS:n
LAST_N_QUARTERS:n
LAST_N_WEEKS:n
LAST_N_YEARS:n
LAST_QUARTER
LAST_WEEK LAST_
YEAR NEXT_90_DAYS
NEXT_FISCAL_QUARTER
NEXT_FISCAL_YEAR
NEXT_MONTH NEXT_N_DAYS:n
NEXT_N_FISCAL_QUARTERS:n
NEXT_N_FISCAL_YEARS:n
NEXT_N_MONTHS:n
NEXT_N_QUARTERS:n
NEXT_N_WEEKS:n
NEXT_N_YEARS:n
NEXT_QUARTER
NEXT_WEEK NEXT_YEAR
THIS_FISCAL_QUARTER
THIS_FISCAL_YEAR
THIS_MONTH
THIS_QUARTER
THIS_WEEK THIS_YEAR
TODAY
TOMORROW
YESTERDAY  
   
 ****************************************************************************************************/
/*------------------------------------------------------------------------
    File        : espdp101rp.p
    Purpose     : Busca Beneficios PCI da Conta Salesforce
    Syntax      : <none>
    Description : <none>

------------------------------------------------------------------------*/

{include/i-prgvrs.i espdp101 2.00.00.000}  /*** 010000 ***/

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


DEFINE VARIABLE ojsonRespObj            AS JsonObject   NO-UNDO.
DEFINE VARIABLE ojsonRespArray          AS jsonArray    NO-UNDO.
DEFINE VARIABLE ojsonObj                AS JsonObject   NO-UNDO.
DEFINE VARIABLE ojsonArray              AS JsonArray    NO-UNDO.
DEFINE VARIABLE ojsonObjArray           AS JsonObject   NO-UNDO.
DEFINE VARIABLE cjsonAux                AS jsonObject   NO-UNDO.
define variable JsonString              AS CHAR     no-undo.
DEFINE VARIABLE c-endereco              AS CHAR FORMAT 'X(60)'.


 DEFINE TEMP-TABLE tt-erro  NO-UNDO
        FIELD codigo     AS INT
        FIELD informacao AS CHAR
        FIELD mensagem   AS CHARACTER FORMAT "x(250)".


DEF TEMP-TABLE tt-aux 
  field id                      AS CHARACTER   
  field isDeleted               AS CHARACTER  
  field accountExternalId       AS CHARACTER  
  field ativo                   AS CHARACTER  
  field discountPercent         AS CHARACTER    
  field infringementBlocking    AS CHARACTER  
  field productFamily           AS CHARACTER  
  field segmentExternalId       AS CHARACTER  
  field segmentName             AS CHARACTER  
  field typeOfBenefit           AS CHARACTER  .


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


assign c-programa     = "ESPDP101"
       c-sistema      = "Busca Beneficios PCI da Conta Salesforce"
       c-titulo-relat = "Busca Beneficios PCI da Conta Salesforce"
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

RUN pi-busca-beneficio IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-busca-beneficio:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEF VAR oClient    AS IhttpClient   NO-UNDO.
    DEF VAR oUri       AS URI           NO-UNDO.
    DEF VAR oReq       AS iHTTPRequest  NO-UNDO.
    DEF VAR oResp      AS iHTTPResponse NO-UNDO.
    DEF VAR oCreds     AS credentials   NO-UNDO.
 
    DEF VAR i-cont AS INT.
    
    FIND FIRST es-api-URI 
        WHERE es-api-URI.id-URI = 'integraBenefCont' NO-LOCK NO-ERROR.   
    
    /* requisi‡Æo WEB */
     //Build a request
    oClient = ClientBuilder:Build():Client.

    IF AVAIL es-api-URI THEN 
      IF l-producao
         THEN ASSIGN c-endereco       = es-api-URI.ent-PRD.
         ELSE ASSIGN c-endereco       = es-api-URI.end-TST.

    assign oURI = URI:Parse(c-endereco).

    
    //Execute a request
    oReq    = RequestBuilder:GET(oURI):Request.
    oResp   = oClient:Execute(oReq).
        
    

    //Process the response
    if oResp:StatusCode <> 200 
    then put unformat
             "Erro de reposta para a consulta de beneficios" + ":" + string(oResp:StatusCode)
             skip(1).
    else do:
     
        assign oJsonObj = CAST(oResp:Entity, Progress.Json.ObjectModel.jSonObject).

        //oJsonObj:Write(JsonString, true).
        oJsonObj:WriteFile(session:temp-directory + "JSON_RET_" +  ".json", yes).


        //run ProcessObject (input "ROOT", INPUT oJsonObj).

        
         ASSIGN // ojsonRespObj    = oJsonObj:GetJsonObject("payload")
               ojsonRespArray  = oJsonObj:getJsonArray("records").   
        
    end.
    IF //TYPE-OF(oResp:Entity, JsonArray) THEN DO:
        oResp:StatusCode = 200 THEN DO:

         Loopl:
        DO i-cont = 1 TO oJsonRespArray:LENGTH ON ERROR UNDO, NEXT:
           ojsonObjArray = oJsonRespArray:GetJsonObject(i-cont).
           ojsonObjArray:Write(JsonString, TRUE).
           cjsonAux = ojsonObjArray.

         
           CREATE tt-aux.
           ASSIGN tt-aux.id                      = cjsonaux:GetJsonText("id").
                  tt-aux.isDeleted               = cjsonAux:GetJsonText("isDeleted").
                  tt-aux.accountExternalId       = cjsonAux:GetJsonText("accountExternalId").     
                  tt-aux.ativo                   = cjsonAux:GetJsonText("active").
                  tt-aux.discountPercent         = (cjsonAux:GetJsonText("discountPercent")) .     
                  tt-aux.infringementBlocking    = cjsonAux:GetJsonText("infringementBlocking").
                  tt-aux.productFamily           = cjsonAux:GetJsonText("productFamily").
                  tt-aux.segmentExternalId       = cjsonAux:GetJsonText("segmentExternalId").
                  tt-aux.segmentName             = cjsonAux:GetJsonText("segmentName").
                  tt-aux.typeOfBenefit           = cjsonAux:GetJsonText("typeOfBenefit").

        END.

        FOR EACH tt-aux WHERE tt-aux.typeOfBenefit <> '' .
           IF tt-aux.isDeleted = 'false' THEN DO:
              FIND FIRST emitente
                   WHERE emitente.cgc                     = SUBSTR(tt-aux.accountExternalId,3,14) NO-LOCK NO-ERROR.
              IF AVAIL emitente THEN DO:
                 FIND FIRST int-beneficio-conta
                      WHERE int-beneficio-conta.codigo-id    = tt-aux.id
                        AND int-beneficio-conta.id-externo   = tt-aux.accountExternalId  NO-ERROR.
                 IF NOT AVAIL int-beneficio-conta THEN DO:
                   CREATE int-beneficio-conta.
                   ASSIGN int-beneficio-conta.codigo-id         = tt-aux.id
                          int-beneficio-conta.id-externo        = tt-aux.accountExternalId.
                 END.
                 ASSIGN tt-aux.discountPercent = REPLACE(tt-aux.discountPercent,'.',',').
                 ASSIGN  int-beneficio-conta.cod-emitente      = emitente.cod-emitente
                         int-beneficio-conta.log-ativo         = IF tt-aux.ativo = 'false' THEN NO ELSE YES
                         int-beneficio-conta.perc-desconto     = dec(tt-aux.discountPercent) * 100
                         int-beneficio-conta.log-bloq-infracao = IF tt-aux.infringementBlocking = 'false' THEN NO ELSE YES
                         int-beneficio-conta.Familia-produto   = IF tt-aux.productFamily = 'null' THEN '' ELSE tt-aux.productFamily
                         int-beneficio-conta.Segmento-produto  = IF tt-aux.segmentExternalId = 'null' THEN '' ELSE tt-aux.segmentExternalId 
                         int-beneficio-conta.nome-beneficio    = tt-aux.typeOfBenefit.
              END.
           END.
           ELSE DO:
              FIND FIRST int-beneficio-conta
                   WHERE int-beneficio-conta.codigo-id    = tt-aux.id
                     AND int-beneficio-conta.id-externo   = tt-aux.accountExternalId  NO-ERROR.
              IF AVAIL int-beneficio-conta THEN DO:
                 DELETE int-beneficio-conta.
              END.
           END.

           DISP tt-aux.id                     column-label "ID"  
                tt-aux.accountExternalId      column-label "Conta"
                tt-aux.ativo                  column-label "Ativo"
                tt-aux.discountPercent        column-label "% Desc"
                tt-aux.infringementBlocking   column-label "Bloq Infr"
                tt-aux.productFamily          column-label "Familia"
                tt-aux.segmentExternalId      column-label "Segmento"
                tt-aux.typeOfBenefit          column-label "Tipo Beneficio"
                tt-aux.isDeleted              column-label "Eliminado"   WITH WIDTH 200 STREAM-IO .


        END.

    END.

  RETURN "OK":U.

END PROCEDURE.

