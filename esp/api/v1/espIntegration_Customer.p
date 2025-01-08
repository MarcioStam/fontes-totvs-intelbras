/****************************************************************************************************
** Intelbras
**
** API Rest Retorno JSON tt-customer
**
** 21/07/2021 - VERSAO INICIAL   //http://10.1.1.71:32080/api/esp/v1/espIntegration_Customer/PiCustomer
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piCustomer POST /~*}
{utp/ut-api-notfound.i} 

DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE objKit                  AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.
DEFINE VARIABLE arrayKit                AS jsonArray    NO-UNDO.

DEFINE TEMP-TABLE tt-erro  NO-UNDO
       FIELD codigo     AS INT
       FIELD informacao AS CHAR
       FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEF VAR c-arquivo-log1  AS CHAR NO-UNDO.
DEF VAR v-cod_erro_21   AS CHAR NO-UNDO.
DEF VAR v_return_21     AS CHAR NO-UNDO.
DEF VAR l-log           AS LOG  NO-UNDO.


// VERIFICA BASE LOGADA 
def var l-producao   AS LOG NO-UNDO.
DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


/*
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


IF OPSYS = 'UNIX' THEN
   ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0008-conta'.
ELSE
   ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0008-conta'.

IF l-producao THEN
   ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
ELSE 
   ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
*/

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piCustomer:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.

    DEFINE VARIABLE objCustomer             AS JsonObject   NO-UNDO.
    DEFINE VARIABLE objCustomer2             AS JsonObject   NO-UNDO.
    DEFINE VARIABLE objCustomer3             AS JsonObject   NO-UNDO.

    DEFINE VARIABLE arrayCustomer           AS jsonArray    NO-UNDO.


    DEFINE VARIABLE jsonArrayPayload        AS jsonArray    NO-UNDO.

    DEFINE VARIABLE externalId              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome                  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome-fantaisa         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-natureza              AS CHARACTER   NO-UNDO. 
    DEFINE VARIABLE c-documento             AS CHAR        NO-UNDO.
    DEFINE VARIABLE i-cod-emitente          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-nome-abrev            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email                 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE idi-matriz-filial       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-matriz                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-registro-conta        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-inscricao-municipal   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-inscricao-estadual    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cnae                  AS CHARACTER   NO-UNDO. 
    DEFINE VARIABLE data-constituicao       AS CHAR        NO-UNDO.
    DEFINE VARIABLE c-key-account           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-telefone              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-telefone2             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-grupo-cliente         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-subgrupo              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-categoria-pci         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE idi-participa-pci       AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-codsuframa            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE idi-contrib-icms        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE data-concessao          AS CHAR        NO-UNDO.
    DEFINE VARIABLE c-ins-aux-sub-trib      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-forma-tributacao      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-regime-apuracao       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE idi-area-livre-com      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cod-grupo-cob         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-moeda                 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-limite-credito       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-bairro-cob            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cep-cob               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-compl-cob             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-endereco-cob          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cidade-cob            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-numero-cob            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-uf-cob                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pais-cob              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bairro-entr           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cep-entr              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-compl-entr            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-endereco-entr         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cidade-entr           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-numero-entr           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-uf-entr               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pais-entr             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE idi-ativo               AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-produtor-rural        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-observacao-cli        AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE customercode            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE shortname               AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE v_log_grupo_cob_21      AS LOG         NO-UNDO.
    DEFINE VARIABLE v_cod_erro_21           AS CHAR        NO-UNDO.
    DEFINE VARIABLE v_return_21             AS CHAR        NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

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

        //ver se o log esta ativado
    RUN esp/es0018p.p (INPUT "log-wso2":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'integrationcustomer' NO-ERROR.
    IF AVAILABLE tt-prog-ponto AND
       ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
       ASSIGN l-log = YES.
    ELSE
       ASSIGN l-log = NO.
    
    
    IF l-log = YES THEN DO:
       IF OPSYS = 'UNIX' THEN
          ASSIGN c-arquivo-log1 = '/usr/wrk/totvs/UNIX_esintegrationCustomer-conta'.
       ELSE
          ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_esintegrationCustomer-conta'.
       
       IF l-producao THEN
          ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
       ELSE 
          ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
    END.



    /*
    IF  OPSYS = 'UNIX' THEN DO:                                
       OUTPUT TO "/mnt/spool/an052677/log_deps_sales.txt" APPEND.
       PUT UNFORMATTED "0.1 - espintegration_customer" SKIP.
       OUTPUT CLOSE.                                
    END.
    */

    RUN pi-gerar-dados-extrato(chr(13) + chr(13) + "ENTROU espIntegration_Customer").

    RUN pi-gerar-dados-extrato('jsonInput:has("payload") ' + STRING(jsonInput:has("payload"))  ).

    IF  jsonInput:has("payload") THEN DO:

        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
               /*jsonArrayPayload     = jsonObjectPayload:getJsonArray("Customer"). */      

        IF l-log = YES THEN DO:
           IF OPSYS = 'UNIX' THEN
              ASSIGN c-arquivo-log1 = '/usr/wrk/totvs/UNIX_esintegrationCustomer-conta_' + JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"documentNumber").
           ELSE
              ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_esintegrationCustomer-conta_' + JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"documentNumber").
           
           IF l-producao THEN
              ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
           ELSE 
              ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'. 
        END.

        ASSIGN externalId              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"externalId").
               c-nome                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"corporateName").
               c-nome-fantaisa         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"fantasyName").     
               c-natureza              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"nature").     
               c-documento             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"documentNumber").
               i-cod-emitente          = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"customerCode")).     
               c-nome-abrev            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"shortName").
               c-email                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"email").
               idi-matriz-filial       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"headOrBranchOffice").
               c-matriz                = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"primaryAccount").
               c-registro-conta        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"accountOrigin").
               c-inscricao-municipal   = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"municipalRegistration").
               c-inscricao-estadual    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"stateRegistration").          
               c-cnae                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"cnae").
               data-constituicao       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"dateOfEstablishment").
               c-key-account           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"agent").
               c-telefone              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"mainPhone").
               c-telefone2             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"otherPhone").
               c-grupo-cliente         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"clientGroup").
               c-subgrupo              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"clientSubgroup").
               c-categoria-pci         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"pciCategory").
               idi-participa-pci       = IF (JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"isPciParticipant")) = 'false' THEN NO ELSE YES.
               c-codsuframa            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"suframaCode").
               idi-contrib-icms        = IF (JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"icmsTxpayer")) = 'false' THEN NO ELSE YES.
               data-concessao          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"concessionExpiration").
               c-ins-aux-sub-trib      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"taxSubstitutionRegistration").
               c-forma-tributacao      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"formOfTaxation").
               c-regime-apuracao       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"calculationRegime").
               idi-area-livre-com      = IF (JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"isAlcSales")) = 'false' THEN NO ELSE YES.
               i-cod-grupo-cob         = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingGroupCode")).
               c-moeda                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"currency").
               de-limite-credito       = decimal(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"creditLimitAdopted")).
               c-bairro-cob            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingDistrict").
               c-cep-cob               = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingCep").
               c-compl-cob             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingComplement").
               c-endereco-cob          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingStreet").
               c-cidade-cob            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingCity").
               c-numero-cob            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingNumber").
               c-uf-cob                = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingState").
               c-pais-cob              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"billingCountry").
               c-bairro-entr           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryDistrict").     
               c-cep-entr              = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryCep").          
               c-compl-entr            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryComplement").   
               c-endereco-entr         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryStreet").       
               c-cidade-entr           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryCity").         
               c-numero-entr           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryNumber").       
               c-uf-entr               = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryState").        
               c-pais-entr             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"deliveryCountry").
               idi-ativo               = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"isActive")).
               c-produtor-rural        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"isRuralProducer").
               c-observacao-cli        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload,"invoiceComments").
         
    END.

     RUN pi-gerar-dados-extrato("externalId                  : "                  + string( externalId           )).
     RUN pi-gerar-dados-extrato("corporateName               : "               + string( c-nome               )).
     RUN pi-gerar-dados-extrato("fantasyName                 : "                 + string( c-nome-fantaisa      )).
     RUN pi-gerar-dados-extrato("nature                      : "                      + string( c-natureza           )).
     RUN pi-gerar-dados-extrato("documentNumber              : "              + string( c-documento          )).
     RUN pi-gerar-dados-extrato("customerCode                : "                + string( i-cod-emitente       )).
     RUN pi-gerar-dados-extrato("shortName                   : "                   + string( c-nome-abrev         )).
     RUN pi-gerar-dados-extrato("email                       : "                       + string( c-email              )).
     RUN pi-gerar-dados-extrato("headOrBranchOffice          : "          + string( idi-matriz-filial    )).
     RUN pi-gerar-dados-extrato("primaryAccount              : "              + string( c-matriz             )).
     RUN pi-gerar-dados-extrato("accountOrigin               : "               + string( c-registro-conta     )).
     RUN pi-gerar-dados-extrato("municipalRegistration       : "       + string( c-inscricao-municipal)).
     RUN pi-gerar-dados-extrato("stateRegistration           : "           + string( c-inscricao-estadual )).
     RUN pi-gerar-dados-extrato("cnae                        : "                        + string( c-cnae               )).
     RUN pi-gerar-dados-extrato("dateOfEstablishment         : "         + string( data-constituicao    )).
     RUN pi-gerar-dados-extrato("agent                       : "                       + string( c-key-account        )).
     RUN pi-gerar-dados-extrato("mainPhone                   : "                   + string( c-telefone           )).
     RUN pi-gerar-dados-extrato("otherPhone                  : "                  + string( c-telefone2          )).
     RUN pi-gerar-dados-extrato("clientGroup                 : "                 + string( c-grupo-cliente      )).
     RUN pi-gerar-dados-extrato("clientSubgroup              : "              + string( c-subgrupo           )).
     RUN pi-gerar-dados-extrato("pciCategory                 : "                 + string( c-categoria-pci      )).
     RUN pi-gerar-dados-extrato("isPciParticipant            : "            + string( idi-participa-pci    )).
     RUN pi-gerar-dados-extrato("suframaCode                 : "                 + string( c-codsuframa         )).
     RUN pi-gerar-dados-extrato("icmsTxpayer                 : "                 + string( idi-contrib-icms     )).
     RUN pi-gerar-dados-extrato("concessionExpiration        : "        + string( data-concessao       )).
     RUN pi-gerar-dados-extrato("taxSubstitutionRegistration : " + string( c-ins-aux-sub-trib   )).
     RUN pi-gerar-dados-extrato("formOfTaxation              : "              + string( c-forma-tributacao   )).
     RUN pi-gerar-dados-extrato("calculationRegime           : "           + string( c-regime-apuracao    )).
     RUN pi-gerar-dados-extrato("isAlcSales                  : "                  + string( idi-area-livre-com   )).
     RUN pi-gerar-dados-extrato("billingGroupCode            : "            + string( i-cod-grupo-cob      )).
     RUN pi-gerar-dados-extrato("currency                    : "                    + string( c-moeda              )).
     RUN pi-gerar-dados-extrato("creditLimitAdopted          : "          + string( de-limite-credito    )).
     RUN pi-gerar-dados-extrato("billingDistrict             : "             + string( c-bairro-cob         )).
     RUN pi-gerar-dados-extrato("billingCep                  : "                  + string( c-cep-cob            )).
     RUN pi-gerar-dados-extrato("billingComplement           : "           + string( c-compl-cob          )).
     RUN pi-gerar-dados-extrato("billingStreet               : "               + string( c-endereco-cob       )).
     RUN pi-gerar-dados-extrato("billingCity                 : "                 + string( c-cidade-cob         )).
     RUN pi-gerar-dados-extrato("billingNumber               : "               + string( c-numero-cob         )).
     RUN pi-gerar-dados-extrato("billingState                : "                + string( c-uf-cob             )).
     RUN pi-gerar-dados-extrato("billingCountry              : "              + string( c-pais-cob           )).
     RUN pi-gerar-dados-extrato("deliveryDistrict            : "            + string( c-bairro-entr        )).
     RUN pi-gerar-dados-extrato("deliveryCep                 : "                 + string( c-cep-entr           )).
     RUN pi-gerar-dados-extrato("deliveryComplement          : "          + string( c-compl-entr         )).
     RUN pi-gerar-dados-extrato("deliveryStreet              : "              + string( c-endereco-entr      )).
     RUN pi-gerar-dados-extrato("deliveryCity                : "                + string( c-cidade-entr        )).
     RUN pi-gerar-dados-extrato("deliveryNumber              : "              + string( c-numero-entr        )).
     RUN pi-gerar-dados-extrato("deliveryState               : "               + string( c-uf-entr            )).
     RUN pi-gerar-dados-extrato("deliveryCountry             : "             + string( c-pais-entr          )).
     RUN pi-gerar-dados-extrato("isActive                    : "                    + string( idi-ativo            )).
     RUN pi-gerar-dados-extrato("isRuralProducer             : "             + string( c-produtor-rural          )).
     RUN pi-gerar-dados-extrato("invoiceComments             : "             + string( c-observacao-cli          )).

    IF SEARCH("esp/wso/IN/wso0008.r") <> ?
    OR SEARCH("esp/wso/IN/wso0008.p") <> ? THEN DO:
        EMPTY TEMP-TABLE tt-erro.

        RUN pi-gerar-dados-extrato("Antes do esp/wso/in/wso0008.p - " + STRING(TIME,"HH:MM:SS")).

        RUN esp/wso/IN/wso0008.p (INPUT-OUTPUT externalId     , 
                                  INPUT  c-nome               , 
                                  INPUT  c-nome-fantaisa      , 
                                  INPUT  c-natureza           , 
                                  INPUT  c-documento          , 
                                  INPUT  i-cod-emitente       , 
                                  INPUT  c-nome-abrev         , 
                                  INPUT  c-email              , 
                                  INPUT  idi-matriz-filial    , 
                                  INPUT  c-matriz             , 
                                  INPUT  c-registro-conta     , 
                                  INPUT  c-inscricao-municipal, 
                                  INPUT  c-inscricao-estadual , 
                                  INPUT  c-cnae               , 
                                  INPUT  data-constituicao    , 
                                  INPUT  c-key-account        , 
                                  INPUT  c-telefone           , 
                                  INPUT  c-telefone2          , 
                                  INPUT  c-grupo-cliente      , 
                                  INPUT  c-subgrupo           , 
                                  INPUT  c-categoria-pci      , 
                                  INPUT  idi-participa-pci    , 
                                  INPUT  c-codsuframa         , 
                                  INPUT  idi-contrib-icms     , 
                                  INPUT  data-concessao       , 
                                  INPUT  c-ins-aux-sub-trib   , 
                                  INPUT  c-forma-tributacao   , 
                                  INPUT  c-regime-apuracao    , 
                                  INPUT  idi-area-livre-com   , 
                                  INPUT  i-cod-grupo-cob      , 
                                  INPUT  c-moeda              , 
                                  INPUT  de-limite-credito    , 
                                  INPUT  c-bairro-cob         , 
                                  INPUT  c-cep-cob            , 
                                  INPUT  c-compl-cob          , 
                                  INPUT  c-endereco-cob       , 
                                  INPUT  c-cidade-cob         , 
                                  INPUT  c-numero-cob         , 
                                  INPUT  c-uf-cob             , 
                                  INPUT  c-pais-cob           , 
                                  INPUT  c-bairro-entr        , 
                                  INPUT  c-cep-entr           , 
                                  INPUT  c-compl-entr         , 
                                  INPUT  c-endereco-entr      , 
                                  INPUT  c-cidade-entr        , 
                                  INPUT  c-numero-entr        , 
                                  INPUT  c-uf-entr            , 
                                  INPUT  c-pais-entr          , 
                                  INPUT  idi-ativo            ,
                                  INPUT  c-produtor-rural     ,
                                  INPUT  c-observacao-cli     ,
                                  OUTPUT customercode         ,
                                  OUTPUT shortname            ,
                                  OUTPUT TABLE tt-erro).         
    END.
    
    ASSIGN jsonObjectOutput = NEW jsonObject().

    IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:

        RUN pi-gerar-dados-extrato("APOS wso0008 - SEM erros - 11").

        jsonObjectOutput:ADD("externalId",   STRING(externalId)). 
        jsonObjectOutput:ADD("customerCode", STRING(customercode)). 
        jsonObjectOutput:ADD("shortName",    STRING(shortname)). 

        RUN pi-gerar-dados-extrato("APOS wso0008 - SEM erros - 22").
       
        RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT FALSE, OUTPUT jsonOutput).

        RUN pi-gerar-dados-extrato("APOS wso0008 - SEM erros - 33").

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "dps-canal-vd", /* grupos tratados para pedidos */
                           INPUT 1,              /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        RUN pi-gerar-dados-extrato("APOS wso0008 - SEM erros - grp-cob " + STRING(i-cod-grupo-cob)).
      
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = string(i-cod-grupo-cob)) THEN DO:


            RUN pi-gerar-dados-extrato("Antes eswso0022 - "  + string(customercode)).

            RUN esp/wso/eswso0022.p (INPUT customercode). /* Envia cadastro atualizado ao DEPS */ 

            RUN pi-gerar-dados-extrato("Depois eswso0022 - "  + string(customercode)).
            
            RUN esp/wso/eswso0021.p (INPUT customercode, /* Envia nova requis‡Æo de limite ao DEPS */
                                     OUTPUT v_cod_erro_21,
                                     OUTPUT v_return_21).

            RUN pi-gerar-dados-extrato("Retorno apos eswso0021 - teste "  + string(customercode) + " - " + v-cod_erro_21 + " - " + v_return_21).

            IF v_return_21 = "NOK" THEN DO:
                RUN pi-gerar-dados-extrato("Retorno com erros do eswso0021 - "  + string(customercode) + " - " + v-cod_erro_21 + " - " + v_return_21).
            END.

        END.

        RUN pi-gerar-dados-extrato("ANTES DO RETURN OK").

        RETURN "OK".
    END.
    ELSE DO:
        RUN pi-gerar-dados-extrato(chr(13) + chr(13) + "APOS wso0008 - COM erros").

        ASSIGN arrayCustomer    = NEW JsonArray().
       
        FOR EACH tt-erro:
            ASSIGN objCustomer = NEW JsonObject().
    
            objCustomer:ADD("errorCode",       tt-erro.codigo ). 
            objCustomer:ADD("errorInfo",       tt-erro.informacao ). 
            objCustomer:ADD("errorDescription",tt-erro.mensagem ).
    
            arrayCustomer:ADD(objCustomer).
        END.

        jsonObjectOutput:ADD("Erros", arrayCustomer).

        ASSIGN jsonOutput = NEW jsonObject().
        jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).

       /* FUNCIONA LISTA*/
       /*ASSIGN arrayCustomer    = NEW JsonArray().
       ASSIGN jsonObjectOutput = NEW jsonObject().

       ASSIGN objCustomer = NEW JsonObject().

       objCustomer:ADD("externalId",   'codigo' ). 
       objCustomer:ADD("customerCode", 'informacao' ). 
       objCustomer:ADD("shortName",    'tt-erro' ).
       arrayCustomer:ADD(objCustomer).


       ASSIGN objCustomer = NEW JsonObject().

       objCustomer:ADD("externalId",   'tt-erro.codigo' ). 
       objCustomer:ADD("customerCode", 'tt-erro.informacao' ). 
       objCustomer:ADD("shortName",    'tt-erro.mensagem' ).

       arrayCustomer:ADD(objCustomer).                
       jsonObjectOutput:ADD("Customer", arrayCustomer).
       
       ASSIGN jsonOutput = NEW jsonObject().
       jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).*/
       /*FUNCIONA LISTA */

    END.   

    

END PROCEDURE. 



PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string + " - "  format "x(200)" skip.
        output close. 
    
    end.
END.
