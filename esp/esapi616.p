&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{esp/esapi616.i}
{include/i-freeac.i} 
function fn-get-version returns integer (input i-num-pedido as integer) forward.
DEF STREAM sNew.
DEF STREAM sMSG.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.

DEF VAR c-metodo       AS CHAR NO-UNDO.
DEF VAR cMessage       AS CHAR NO-UNDO.
DEF VAR v-des-moeda    AS CHAR NO-UNDO.
DEF VAR v-des-transp   AS CHAR NO-UNDO.
DEF VAR v-desc-item    AS CHAR NO-UNDO.
DEF VAR v-texto-mensag AS CHAR NO-UNDO.
DEF VAR v-narrativa    AS CHAR NO-UNDO.
DEF VAR v-num-item     AS INT64 FORMAT ">>>>>>>>>>>>>9" NO-UNDO.

DEF VAR cJson          AS LONGCHAR NO-UNDO.
DEF VAR lgctdts        as LONGCHAR no-undo.
DEF VAR cRequest       AS LONGCHAR NO-UNDO.
def var cAction        as char     no-undo.
DEF VAR hdts AS HANDLE NO-UNDO.

// fc-chamada-1 espai505.i ---------------*/

DEF VAR JsonString     AS LONGCHAR                      NO-UNDO.
DEF VAR oRequest       as IHttpRequest                  NO-UNDO.
DEF VAR oResponse      as IHttpResponse                 NO-UNDO.
DEF VAR oJsonObject    AS JsonObject                    NO-UNDO.
DEF VAR oJsonEntity    AS JsonArray                     NO-UNDO.
DEF VAR oClient        AS IHttpClient                   NO-UNDO.
DEF VAR myLongchar     AS LONGCHAR                      NO-UNDO.
DEF VAR myParser       AS ObjectModelParser             NO-UNDO.
DEF VAR Json           AS JsonObject                    NO-UNDO.
DEFINE VARIABLE cAux AS  LONGCHAR /*CHARACTER*/   NO-UNDO.

DEF TEMP-TABLE ttPEDIDO SERIALIZE-NAME "PEDIDO"
    FIELD id                 AS INT SERIALIZE-HIDDEN
    field currency    	     AS CHAR // LIKE cotacao-item.mo-codigo
    field docVersion	     AS INT // CRIAR CAMPO	
    field paymentTerms	     LIKE pedido-compr.cod-cond-pag
    field paymentDescription LIKE cond-pagto.descricao
    field purchaseOrderId    LIKE pedido-compr.num-pedido
    field supplierId	     LIKE pedido-compr.cod-emitente
    field language	         LIKE emitente-cex.cod-idioma
    field businessUnit	     LIKE ordem-compra.cod-unid-negoc 
    field supplierEmail	     LIKE emitente.e-mail
    field buyerEmail	     LIKE usuar-mater.e-mail
    field taxId	             AS CHAR // Nr Passaporte
    field corporateName	     LIKE emitente.nome-emit
    field addressCountry	 LIKE emitente.pais
    field addressStreet	     LIKE int-emitente.logradouro
    field addressNumber	     LIKE int-emitente.numero
    field addressComplement	 LIKE int-emitente.complemento
    field addressDistrict	 LIKE emitente.bairro
    field addressPostalCode	 LIKE emitente.cep
    field addressState	     LIKE emitente.estado
    field addressCity	     LIKE emitente.cidade
    field billingLocationDescription LIKE emitente.nome-abrev
    field billingCountry	 LIKE emitente.pais
    field billingStreet	     LIKE int-emitente.logradouro
    field billingNumber	     LIKE int-emitente.numero
    field billingComplement	 LIKE int-emitente.complemento
    field billingDistrict	 LIKE emitente.bairro
    field billingPostalCode	 LIKE emitente.cep
    field billingState	     LIKE emitente.estado
    field billingCity	     LIKE emitente.cidade
    field deliveryLocationDescription LIKE emitente.nome-abrev
    field deliveryCountry	 LIKE emitente.pais
    field deliveryStreet	 LIKE int-emitente.logradouro
    field deliveryNumber	 LIKE int-emitente.numero
    field deliveryComplement LIKE int-emitente.complemento
    field deliveryDistrict	 LIKE emitente.bairro
    field deliveryPostalCode LIKE emitente.cep
    field deliveryState	     LIKE emitente.estado
    field deliveryCity	     LIKE emitente.cidade
    field billingCNPJ	     LIKE emitente.cgc
    field billingMunicipalRegistration LIKE emitente.ins-municipal
    field billingStateRegistration LIKE emitente.ins-estadual
    field deliveryCNPJ	     LIKE emitente.cgc
    field deliveryMunicipalRegistration	LIKE emitente.ins-municipal
    field deliveryStateRegistration	LIKE emitente.ins-estadual
    field supplierCNPJ	     LIKE emitente.cgc
    field supplierMunicipalRegistration	 LIKE emitente.ins-municipal
    field supplierStateRegistration	LIKE emitente.ins-estadual
    field orderMessage	     LIKE mensagem.texto-mensag
    field buyerName          like comprador.nome
    // field action	NA	NA
    .

DEF TEMP-TABLE ttITEM SERIALIZE-NAME "Itens"
    FIELD id              AS INT SERIALIZE-HIDDEN
    field itemPosition    AS int64 FORMAT ">>>>>>>>>>>>>>9" // ordem-compra.numero-ordem (9999) + prazo-compra.parcela (999)
    FIELD action          AS CHAR
    field quantity        LIKE ordem-compra.qt-solic // ou prazo-compra.quantidade
    field unitMeasure	  LIKE cotacao-item.un
    field unitPrice	      LIKE cotacao-item.pre-unit-for
    field unitSubtotal	  LIKE cotacao-item.preco-fornec
    field netWeight	      LIKE item.peso-liquido
    field centerId	      LIKE pedido-compr.cod-estabel
    field materialGroup	  LIKE item.fm-codigo
    field expectedDeliveryDate  LIKE prazo-compra.data-entrega
    field materialFamily  LIKE familia.descricao
    field productID       LIKE item.it-codigo
    field productName     LIKE item.desc-item
    field shipper	      AS CHAR // emitente.cod-transp + Ë Î Ë + Descri‡Æo
    field productLongName LIKE ordem-compra.narrativa
    field ncm	          LIKE item.class-fiscal
    field ipiTax	      LIKE cotacao-item.aliquota-ipi
    field icmsTax	      LIKE cotacao-item.aliquota-icm
    field issTax	      LIKE cotacao-item.aliquota-iss
    field serviceProvider AS CHAR // False
    .

DEF DATASET dts SERIALIZE-HIDDEN FOR ttPEDIDO, ttITEM
     DATA-RELATION relac FOR ttPEDIDO, ttITEM RELATION-FIELDS (ttPEDIDO.id, ttITEM.id) NESTED.

DEF TEMP-TABLE ttPEDDEL SERIALIZE-NAME "PEDIDO"
    FIELD id                 AS INT SERIALIZE-HIDDEN
    field currency    	     AS CHAR // LIKE cotacao-item.mo-codigo
    field paymentTerms	     LIKE pedido-compr.cod-cond-pag
    field paymentDescription LIKE cond-pagto.descricao
    field paymentDays        AS CHAR
    field purchaseOrderId    LIKE pedido-compr.num-pedido
    field supplierId	     LIKE pedido-compr.cod-emitente
    field language	         LIKE emitente-cex.cod-idioma
    field businessUnit	     LIKE ordem-compra.cod-unid-negoc 
    field supplierEmail      LIKE emitente.e-mail
    field buyerEmail	     LIKE usuar-mater.e-mail
    field corporateName	     LIKE emitente.nome-emit
    field addressCountry	 LIKE emitente.pais
    field addressStreet	     LIKE int-emitente.logradouro
    field addressNumber	     LIKE int-emitente.numero
    field addressComplement  LIKE int-emitente.complemento
    field addressDistrict	 LIKE emitente.bairro
    field addressPostalCode  LIKE emitente.cep
    field addressState	     LIKE emitente.estado
    field addressCity	     LIKE emitente.cidade
    field billingLocationDescription LIKE emitente.nome-abrev
    field billingCountry	 LIKE emitente.pais
    field billingStreet	     LIKE int-emitente.logradouro
    field billingNumber	     LIKE int-emitente.numero
    field billingComplement  LIKE int-emitente.complemento
    field billingDistrict	 LIKE emitente.bairro
    field billingPostalCode  LIKE emitente.cep
    field billingState	     LIKE emitente.estado
    field billingCity	     LIKE emitente.cidade
    field deliveryLocationDescription LIKE emitente.nome-abrev
    field deliveryCountry	 LIKE emitente.pais
    field deliveryStreet	 LIKE int-emitente.logradouro
    field deliveryNumber	 LIKE int-emitente.numero
    field deliveryComplement LIKE int-emitente.complemento
    field deliveryDistrict	 LIKE emitente.bairro
    field deliveryPostalCode LIKE emitente.cep
    field deliveryState	     LIKE emitente.estado
    field deliveryCity	     LIKE emitente.cidade
    field docVersion	     AS INT // CRIAR CAMPO 
    field buyerName          like comprador.nome 
    .

DEF TEMP-TABLE ttITDEL SERIALIZE-NAME "Itens"
    FIELD id               AS INT SERIALIZE-HIDDEN
    field itemPosition     AS int64 FORMAT ">>>>>>>>>>>>>>9" // ordem-compra.numero-ordem (9999) + prazo-compra.parcela (999)
    FIELD action           AS CHAR
    field quantity         LIKE ordem-compra.qt-solic // ou prazo-compra.quantidade
    field unitMeasure	   LIKE cotacao-item.un
    field unitPrice	       LIKE cotacao-item.pre-unit-for
	field materialBusinessUnit AS CHAR 
    field unitSubtotal	   LIKE cotacao-item.preco-fornec
    field netWeight	       LIKE item.peso-liquido
    field centerId	       LIKE pedido-compr.cod-estabel
    field materialGroup	   LIKE item.fm-codigo
    field expectedDeliveryDate  LIKE prazo-compra.data-entrega
	field remittanceQuantity AS CHAR 
    field materialFamily   LIKE familia.descricao
    field productID        LIKE item.it-codigo
    field productName      LIKE item.desc-item
	field productShortname LIKE item.desc-item
    .

define temp-table tt-ordem-compra no-undo like ordem-compra
  field l-split           as   logical                    initial no
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem-mp
                              num-processo
                              num-sequencia.

define temp-table tt-prazo-compra no-undo like prazo-compra
  field cod-maq-origem    as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                              num-processo
                              num-sequencia.

define temp-table tt-pedido-compr no-undo like pedido-compr
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                              num-processo
                              num-sequencia.

define temp-table tt-cond-especif no-undo like cond-especif
  field cod-maq-origem-mp as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem-mp
                              num-processo
                              num-sequencia.

define temp-table tt-cotacao-item no-undo like cotacao-item
  field cod-maq-origem    as integer format "999"       initial 0
  field num-processo      as integer format ">>>>>>>>9" initial 0
  field num-sequencia     as integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY cod-maq-origem
                             num-processo
                             num-sequencia.

define temp-table tt-desp-cotacao-item no-undo like desp-cotacao-item
  field cod-maq-origem    as   integer format "999"       initial 0
  field num-processo      as   integer format ">>>>>>>>9" initial 0
  field num-sequencia     as   integer format ">>>>>9"    initial 0
  field ind-tipo-movto    as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.

define temp-table tt-versao-integr no-undo
  field cod-versao-integracao as integer format "999"
  field ind-origem-msg        as integer format "99" /* i01mp900.i */.

define temp-table tt-erros-geral no-undo
  field identif-msg           as char    format "x(60)"
  field num-sequencia-erro    as integer format "999"
  field cod-erro              as integer format "99999"   
  field des-erro              as char    format "x(60)"
  field cod-maq-origem        as integer format "999"
  field num-processo          as integer format "999999999".

DEF DATASET dtsdel SERIALIZE-HIDDEN FOR ttPEDDEL, ttITDEL
     DATA-RELATION relac FOR ttPEDDEL, ttITDEL RELATION-FIELDS (ttPEDDEL.id, ttITDEL.id) NESTED.

DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi616 AS LOG NO-UNDO.

DEF TEMP-TABLE tt-historico-embarque NO-UNDO
          LIKE historico-embarque.
                               
DEF BUFFER bf-int-pto-contr-1      FOR int-pto-contr.
DEF BUFFER bf-int-pto-contr-2      FOR int-pto-contr.
DEF BUFFER bf-ordens-embarque      FOR ordens-embarque.
DEF BUFFER bf-tot-ordens-embarque  FOR ordens-embarque.
DEF BUFFER bf-tot-ordem-compra     FOR ordem-compra.

DEF BUFFER bf-ext-embarque-imp     FOR ext-embarque-imp.
    
DEF VAR i-pag               AS i                                    NO-UNDO.
DEF VAR dataPontoEmbarque1  LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoEmbarque2  LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoChegada1   LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoChegada2   LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataRegistroDI      LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataLiberacao       LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataProntidao       LIKE historico-embarque.dt-efetiva      NO-UNDO.
DEF VAR dataEntrada         LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataEmissaoNF       LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR l-prazo             AS l                                    NO-UNDO.
DEF VAR l-pedido            AS l                                    NO-UNDO.
DEF VAR l-proc              AS l                                    NO-UNDO.
DEF VAR l-inv               AS l                                    NO-UNDO.
DEF VAR cIDItem             AS c                                    NO-UNDO.

DEF VAR de-val-cub-tot      LIKE ordens-embarque.val-cub-tot        NO-UNDO.

/* Gera PDF */
{utp/ut-glob.i}
{include/pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE i-lin          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-linha        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-pdf  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-linha        AS INTEGER     NO-UNDO.
define variable c-email        as character   no-undo.

{esp/esapi505x.i &OPC="OPEN"}
/*
IF i-acao = 0 THEN DO:
   l-esapi616 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no


/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-data Procedure 
FUNCTION fc-data RETURNS CHARACTER
  ( d AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

DEF VAR v-num-seq-movto AS INT NO-UNDO.

/* ***************************  Main Block  *************************** */
FOR FIRST es-api-log EXCLUSIVE-LOCK
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:
    ASSIGN c-metodo                  = es-api-URI.metodo
           es-api-log.dh-envio       = NOW
           es-api-log.flg-processado = YES.
        
    /* POST e PUT */
    IF c-metodo <> "DELETE" THEN DO:
        RUN pi-cria-tt-pedido-compr (INPUT INT (es-api-log.aux),
                                     output c-email).
        IF cJson <> "" THEN
            ASSIGN l-proc = YES.
        ELSE
            ASSIGN l-proc = NO.        
        /*
        IF DATASET dts:HANDLE <> ? THEN
            ASSIGN l-proc = YES.
        ELSE
            ASSIGN l-proc = NO.*/
    END.
    ELSE DO:
        RUN pi-cria-tt-pedido-del (INPUT INT (es-api-log.aux),
                                   output c-email).
        IF DATASET dtsdel:HANDLE <> ? THEN
            ASSIGN l-proc = YES.
        ELSE
            ASSIGN l-proc = NO.
    END.

    IF VALID-HANDLE(h-acomp) THEN 
        RUN pi-acompanhar IN h-acomp ("Integra‡Æo com o ARIBA").

    IF l-proc = NO THEN DO:
        IF es-api-log.aux > "" THEN DO:
           if not can-find(first pedido-compr where
                                 pedido-compr.num-pedido = inte(es-api-log.aux)
                                 no-lock)
           then RUN piErro ("Nao foi encontrado o Pedido de Compra " + es-api-log.aux, "").
           else if c-email = ""
                then RUN piErro ("Nao foi encontrado email para fornecedor vinculado ao Pedido de Compra " + es-api-log.aux, "").
                else RUN piErro ("Erro no processamento do Pedido de Compra " + es-api-log.aux, "").
          //MESSAGE ">> Nao foi encontrado o Pedido de Compra " + es-api-log.aux.
        END.       
        FIND pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = INT (es-api-log.aux) NO-ERROR.
        FIND FIRST int-ped-compr OF pedido-compr EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL int-ped-compr THEN DO:
            FIND LAST int-mov-ped-compr NO-LOCK
                 WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                   AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
            IF AVAIL int-mov-ped-compr THEN
                ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
            ELSE
                ASSIGN v-num-seq-movto = 20.
            CREATE int-mov-ped-compr.
            ASSIGN int-ped-compr.ind-status        = 6	/* Erro Integra‡Æo */
                   int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                   int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                   int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                   int-mov-ped-compr.ind-tip-movto = "Erro Integra‡Æo"
                   int-mov-ped-compr.id-api-log    = es-api-log.id-api-log
                   int-mov-ped-compr.dat-movto     = TODAY
                   int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                   int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                   int-mov-ped-compr.des-text-histor = "Pedido de Compras nÆo Integrado (1): " + STRING (pedido-compr.num-pedido).
        END.
    END.
    ELSE DO:
        IF l-proc THEN DO:
           IF es-api-aplicacao.Testes = NO THEN 
               ASSIGN c-endereco = es-api-URI.ent-PRD.
           ELSE 
               ASSIGN c-endereco = es-api-URI.end-TST.

           ASSIGN cJson = CODEPAGE-CONVERT(cJson, "UTF-8":U).           
           /*          
           OUTPUT TO "c:/temp/ped230131.json".
           PUT UNFORMATTED
               STRING (cJson) SKIP.
           OUTPUT CLOSE.
           */
           CLIPBOARD:VALUE = cJson.

           ASSIGN es-api-log.cJSON = cJson.

           fc-chamada-1().

           IF es-api-log.cod-retorno BEGINS "2" THEN DO:
               FIND pedido-compr NO-LOCK
                   WHERE pedido-compr.num-pedido = INT (es-api-log.aux) NO-ERROR.
               FIND FIRST int-ped-compr OF pedido-compr EXCLUSIVE-LOCK NO-ERROR.
               IF AVAIL int-ped-compr THEN DO:
                   FIND LAST int-mov-ped-compr NO-LOCK
                        WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                          AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
                   IF AVAIL int-mov-ped-compr THEN
                       ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
                   ELSE
                       ASSIGN v-num-seq-movto = 20.
                   // MESSAGE "Seq: " v-num-seq-movto VIEW-AS ALERT-BOX.
                   CREATE int-mov-ped-compr.
                   ASSIGN int-ped-compr.ind-status        = 4 /* Integrado */
                          int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                          int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                          int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                          int-mov-ped-compr.ind-tip-movto = "Integrado"
                          int-mov-ped-compr.id-api-log    = es-api-log.id-api-log
                          int-mov-ped-compr.dat-movto     = TODAY
                          int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                          int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                          int-mov-ped-compr.des-text-histor = "Pedido de Compras Integrado com Sucesso: " + STRING (pedido-compr.num-pedido).
                   IF c-metodo = "DELETE" THEN
                       ASSIGN int-ped-compr.ind-status          = 7 /* Pedido Cancelado */
                              int-mov-ped-compr.ind-tip-movto   = "Pedido Cancelado"
                              int-mov-ped-compr.des-text-histor = "Pedido de Compras Cancelado com Sucesso: " + STRING (pedido-compr.num-pedido).                       
               END.
           END.
           ELSE DO:
               FIND pedido-compr NO-LOCK
                   WHERE pedido-compr.num-pedido = INT (es-api-log.aux) NO-ERROR.
               FIND FIRST int-ped-compr OF pedido-compr EXCLUSIVE-LOCK NO-ERROR.
               IF AVAIL int-ped-compr THEN DO:
                   FIND LAST int-mov-ped-compr NO-LOCK
                        WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                          AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
                   IF AVAIL int-mov-ped-compr THEN
                       ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
                   ELSE
                       ASSIGN v-num-seq-movto = 20.
                   CREATE int-mov-ped-compr.
                   ASSIGN int-ped-compr.ind-status        = 6 /* Erro Integra‡Æo */
                          int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                          int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                          int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                          int-mov-ped-compr.ind-tip-movto = "Erro Integra‡Æo"
                          int-mov-ped-compr.id-api-log    = es-api-log.id-api-log
                          int-mov-ped-compr.dat-movto     = TODAY
                          int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                          int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                          int-mov-ped-compr.des-text-histor = "Pedido de Compras NÆo Integrado (2): " + STRING (pedido-compr.num-pedido).
                   IF c-metodo = "DELETE" THEN
                       ASSIGN int-mov-ped-compr.des-text-histor = "Pedido de Compras nÆo foi Cancelado: " + STRING (pedido-compr.num-pedido).
               END.
           END.
        END.
    END.

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-data Procedure 
FUNCTION fc-data RETURNS CHARACTER
  ( d AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR c AS c NO-UNDO.

  IF d <> ?
  THEN ASSIGN
     c = STRING( YEAR(d),"9999")
       + "-"
       + STRING(MONTH(d),"99")
       + "-"
       + STRING(  DAY(d),"99")
       .

  RETURN c.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

function fCodificaArquivoBase64 returns longchar (cCaminhoArquivo as character):

    define variable mArquivoCodificado  as memptr   no-undo.
    define variable lcArquivoCodificado as longchar no-undo.

    if  search(cCaminhoArquivo) <> ? then do:
        
        copy-lob from file cCaminhoArquivo to mArquivoCodificado.
        lcArquivoCodificado = base64-encode(mArquivoCodificado).
    
    end.
    
    return lcArquivoCodificado.

end function.

function fRemoveAcento returns character (input p-string as character):

    define variable c-free-accent as character case-sensitive no-undo.

    assign c-free-accent = p-string
           c-free-accent =  replace(c-free-accent, 'À', 'A')
           c-free-accent =  replace(c-free-accent, 'Á', 'A')
           c-free-accent =  replace(c-free-accent, 'Â', 'A')
           c-free-accent =  replace(c-free-accent, 'Ã', 'A')
           c-free-accent =  replace(c-free-accent, 'Ä', 'A')
           c-free-accent =  replace(c-free-accent, 'È', 'E')
           c-free-accent =  replace(c-free-accent, 'É', 'E')
           c-free-accent =  replace(c-free-accent, 'Ê', 'E')
           c-free-accent =  replace(c-free-accent, 'Ë', 'E')
           c-free-accent =  replace(c-free-accent, 'Ì', 'I')
           c-free-accent =  replace(c-free-accent, 'Í', 'I')
           c-free-accent =  replace(c-free-accent, 'Î', 'I')
           c-free-accent =  replace(c-free-accent, 'Ï', 'I')
           c-free-accent =  replace(c-free-accent, 'Ò', 'O')
           c-free-accent =  replace(c-free-accent, 'Ó', 'O')
           c-free-accent =  replace(c-free-accent, 'Ô', 'O')
           c-free-accent =  replace(c-free-accent, 'Õ', 'O')
           c-free-accent =  replace(c-free-accent, 'Ö', 'O')
           c-free-accent =  replace(c-free-accent, 'Ù', 'U')
           c-free-accent =  replace(c-free-accent, 'Ú', 'U')
           c-free-accent =  replace(c-free-accent, 'Û', 'U')
           c-free-accent =  replace(c-free-accent, 'Ü', 'U')
           c-free-accent =  replace(c-free-accent, 'Ý', 'Y')
           c-free-accent =  replace(c-free-accent, 'ƒ', 'a')
           c-free-accent =  replace(c-free-accent, ' ', 'a')
           c-free-accent =  replace(c-free-accent, 'Ç', 'C')
           c-free-accent =  replace(c-free-accent, 'Ñ', 'N')
           c-free-accent =  replace(c-free-accent, 'à', 'a')
           c-free-accent =  replace(c-free-accent, 'á', 'a')
           c-free-accent =  replace(c-free-accent, 'â', 'a')
           c-free-accent =  replace(c-free-accent, 'ã', 'a')
           c-free-accent =  replace(c-free-accent, 'ä', 'a')
           c-free-accent =  replace(c-free-accent, 'è', 'e')
           c-free-accent =  replace(c-free-accent, 'é', 'e')
           c-free-accent =  replace(c-free-accent, 'ê', 'e')
           c-free-accent =  replace(c-free-accent, 'ë', 'e')
           c-free-accent =  replace(c-free-accent, 'ì', 'i')
           c-free-accent =  replace(c-free-accent, 'í', 'i')
           c-free-accent =  replace(c-free-accent, 'î', 'i')
           c-free-accent =  replace(c-free-accent, 'ï', 'i')
           c-free-accent =  replace(c-free-accent, 'ò', 'o')
           c-free-accent =  replace(c-free-accent, 'ó', 'o')
           c-free-accent =  replace(c-free-accent, 'ô', 'o')
           c-free-accent =  replace(c-free-accent, 'õ', 'o')
           c-free-accent =  replace(c-free-accent, 'ö', 'o')
           c-free-accent =  replace(c-free-accent, 'ù', 'u')
           c-free-accent =  replace(c-free-accent, 'ú', 'u')
           c-free-accent =  replace(c-free-accent, 'û', 'u')
           c-free-accent =  replace(c-free-accent, 'ü', 'u')
           c-free-accent =  replace(c-free-accent, 'ý', 'y')
           c-free-accent =  replace(c-free-accent, 'ÿ', 'y')
           c-free-accent =  replace(c-free-accent, 'ç', 'c')
           c-free-accent =  replace(c-free-accent, 'ñ', 'n').

    return c-free-accent.

end function.

PROCEDURE pi-cria-tt-pedido-compr:

    DEF INPUT  PARAM p-num-pedido AS INT NO-UNDO. 
    def output param p-email     as char no-undo.

    DEF VAR v-arq-pdf    AS CHAR NO-UNDO.
    DEF VAR v-des        AS CHAR NO-UNDO.
    DEF VAR v-texto-conv AS CHAR NO-UNDO.
    DEF VAR i-erro       AS INT NO-UNDO.
    DEF VAR v-cod-pais   AS CHAR NO-UNDO.
    def var c-return-aux as char no-undo.
    
    ASSIGN cMessage = SESSION:TEMP-DIRECTORY + "PED_" + STRING (p-num-pedido) + ".txt" NO-ERROR.

    FIND pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = p-num-pedido
          and pedido-compr.situacao  <> 3 NO-ERROR.
    IF AVAIL pedido-compr THEN DO:        
        FIND usuar-mater NO-LOCK
            WHERE usuar-mater.cod-usuario = pedido-compr.responsavel NO-ERROR.
        for first comprador fields(cod-comprado nome)
            where comprador.cod-comprado = pedido-compr.responsavel
                  no-lock: end.
        FIND FIRST ordem-compra OF pedido-compr NO-LOCK NO-ERROR.
        FIND FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
              AND cotacao-item.cot-aprovada = YES NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            CASE cotacao-item.mo-codigo: 
               WHEN 0 THEN ASSIGN v-des-moeda = "Real".  /* 0 - Real */ 
               WHEN 1 THEN ASSIGN v-des-moeda = "Dolar". /* 1 - D¢lar */ 
               WHEN 4 THEN ASSIGN v-des-moeda = "Yen".  /* 4 - Yen  */
               WHEN 5 THEN ASSIGN v-des-moeda = "Euro".  /* 5 - Euro  */           
               WHEN 6 THEN ASSIGN v-des-moeda = "Libra". /* 6 - Libra  */
               WHEN 7 THEN ASSIGN v-des-moeda = "Renminbi".  /* 7 - Renminbi  */
               OTHERWISE ASSIGN v-des-moeda = "Real".
            END CASE.        
        END.
        
        FIND cond-pagto OF pedido-compr NO-LOCK NO-ERROR.
        FIND emitente OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND int-emitente OF emitente NO-LOCK NO-ERROR.
            IF NOT AVAIL int-emitente THEN
                RETURN.
            FIND emitente-cex OF emitente NO-LOCK NO-ERROR.
            FIND mgcad.pais NO-LOCK
                WHERE pais.nome-pais = emitente.pais NO-ERROR.
            IF AVAIL pais THEN
                ASSIGN v-cod-pais = SUBSTR (pais.char-1, 23, 2).
            ELSE
                ASSIGN v-cod-pais = "BR".
            FIND idioma NO-LOCK
                WHERE idioma.cod_idioma = emitente-cex.cod-idioma NO-ERROR.

            FIND FIRST transporte NO-LOCK
                WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

            IF NOT AVAIL transporte
            THEN FIND FIRST transporte NO-LOCK
                     WHERE transporte.cod-transp = emitente.cod-transp NO-ERROR.

            ASSIGN v-des-transp = "".
            IF AVAIL transporte THEN
                ASSIGN v-des-transp = transporte.nome
                       v-des-transp = STRING (transporte.cod-transp) + chr(32) + CHR(45) + CHR(32) + v-des-transp.

            for first cont-emit fields(cod-emitente area e-mail) use-index codigo
                where cont-emit.cod-emitente = emitente.cod-emitente
                  and cont-emit.area         = "COMERCIAL"
                  and cont-emit.e-mail      <> ""
                      no-lock: end.

            if not avail cont-emit
            then for first cont-emit fields(cod-emitente sequencia e-mail)
                     where cont-emit.cod-emitente = emitente.cod-emitente
                       and cont-emit.sequencia    = 10
                       and cont-emit.e-mail      <> ""
                           no-lock: end.

            if avail cont-emit
            then assign p-email = trim(cont-emit.e-mail).
            else return.

            RUN pi-gera-pdf (INPUT pedido-compr.num-pedido,
                             OUTPUT v-arq-pdf).

            // ASSIGN p-texto-conv = FCODIFICAARQUIVOBASE64(c-arq-pdf).
            //MESSAGE NUM-ENTRIES (v-texto-conv, '\') VIEW-AS ALERT-BOX.

            //ASSIGN v-texto-conv = REPLACE (v-texto-conv, '\', '').
            /*
            OUTPUT TO c:/temp/arqconv.txt.
            PUT UNFORMATTED
                v-texto-conv
                SKIP.
            OUTPUT CLOSE.
            */

            CREATE ttPEDIDO.
            ASSIGN ttPEDIDO.id                 = pedido-compr.num-pedido
                   ttPEDIDO.purchaseOrderId    = pedido-compr.num-pedido
                   ttPEDIDO.docVersion	       = fn-get-version(input pedido-compr.num-pedido) 
                   ttPEDIDO.buyerEmail	       = IF AVAIL usuar-mater THEN usuar-mater.e-mail ELSE ""
                   ttPEDIDO.currency    	   = v-des-moeda
                   ttPEDIDO.paymentTerms	   = pedido-compr.cod-cond-pag
                   ttPEDIDO.paymentDescription = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                   ttPEDIDO.language	       = IF AVAIL idioma THEN idioma.des_idioma ELSE "Portuguˆs"
                   ttPEDIDO.businessUnit	   = ordem-compra.cod-unid-negoc 
                   ttPEDIDO.supplierId	       = pedido-compr.cod-emitente
                   ttPEDIDO.supplierCNPJ	   = emitente.cgc
                   ttPEDIDO.supplierEmail	   = p-email
                   ttPEDIDO.corporateName	   = emitente.nome-emit               
                   ttPEDIDO.addressStreet	   = int-emitente.logradouro
                   ttPEDIDO.addressNumber	   = int-emitente.numero
                   ttPEDIDO.addressComplement  = int-emitente.complemento
                   ttPEDIDO.addressDistrict	   = emitente.bairro
                   ttPEDIDO.addressPostalCode  = emitente.cep
                   ttPEDIDO.addressCity	       = emitente.cidade
                   ttPEDIDO.addressState	   = emitente.estado
                   ttPEDIDO.addressCountry	   = v-cod-pais
                   ttPEDIDO.supplierMunicipalRegistration = emitente.ins-municipal
                   ttPEDIDO.supplierStateRegistration	  = emitente.ins-estadual
                   ttPEDIDO.taxId	           = trim(SUBSTR(emitente.char-1,103,30)) //emitente.cgc
                   ttPEDIDO.buyerName          = if avail comprador 
                                                 then trim(comprador.nome)
                                                 else ""
                   ttPEDIDO.orderMessage	   = FCODIFICAARQUIVOBASE64 (v-arq-pdf).
           /*           
           INPUT FROM c:/temp/arqconv.txt.
           REPEAT:
               IMPORT UNFORMATTED v-des.
               IF v-des = "" THEN
                   LEAVE.
               ELSE

           END.      
           INPUT CLOSE.
           // MESSAGE v-des VIEW-AS ALERT-BOX.
           ASSIGN ttPEDIDO.orderMessage	= REPLACE (v-des, "\", "").
           */
           
           RUN pi-billing (INPUT pedido-compr.end-cobranca).
           RUN pi-delivery (INPUT pedido-compr.end-entrega).

           assign cAction = "Novo".

           for first int-ped-compr
               where int-ped-compr.num-pedido = pedido-compr.num-pedido
                     exclusive-lock: end.

           if  avail int-ped-compr
           and can-find(first int-mov-ped-compr where 
                              int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                          and int-mov-ped-compr.ind-tip-movto = "Integrado"
                              no-lock)
           then assign cAction = "Atualiza‡Æo".

           ordem_blk:
           FOR EACH ordem-compra OF pedido-compr NO-LOCK:
               IF ordem-compra.situacao = 4 /* Eliminada */
               OR ordem-compra.situacao = 6 /* Recebida */ then
                   NEXT ordem_blk.

               FIND FIRST cotacao-item NO-LOCK
                   WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                     AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                     AND cotacao-item.cot-aprovada = YES NO-ERROR.
               IF AVAIL cotacao-item THEN DO:                   
                   FIND ITEM OF ordem-compra NO-LOCK NO-ERROR.
                   IF AVAIL ITEM THEN DO:
                       ASSIGN v-desc-item = TRIM (ITEM.desc-item)
                              v-desc-item = fRemoveAcento (v-desc-item).  

                       ASSIGN v-desc-item = REPLACE (v-desc-item, CHR(9), " ")
                              v-desc-item = REPLACE (v-desc-item, '"',"'").
                   END.
                   ELSE
                       ASSIGN v-desc-item = "".
                   FIND familia OF ITEM NO-LOCK NO-ERROR.
                   ASSIGN v-narrativa = TRIM (ordem-compra.narrativa)
                          v-narrativa = REPLACE (v-narrativa, CHR(10), CHR(32))
                          v-narrativa = REPLACE (v-narrativa, CHR(13), CHR(32)).

                   ASSIGN v-narrativa = REPLACE (v-narrativa, CHR(9), " ")
                          v-narrativa = REPLACE (v-narrativa, '"',"'").
                          

                   FOR EACH prazo-compra OF ordem-compra NO-LOCK:
                       CREATE ttITEM.
                       ASSIGN v-num-item = INT (SUBSTR (STRING (ordem-compra.numero-ordem, "99999999"), 4) + STRING (prazo-compra.parcela, "99"))                          
                              ttITEM.id              = pedido-compr.num-pedido
                              ttITEM.itemPosition    = v-num-item
                              ttITEM.action          = cAction
                              ttITEM.quantity        = prazo-compra.qtd-do-forn
                              ttITEM.unitMeasure	 = cotacao-item.un
                              ttITEM.unitPrice	     = cotacao-item.pre-unit-for
                              ttITEM.unitSubtotal    = cotacao-item.preco-fornec
                              ttITEM.netWeight	     = IF AVAIL ITEM THEN item.peso-liquido ELSE 0
                              ttITEM.centerId	     = pedido-compr.cod-estabel
                              ttITEM.materialGroup   = IF AVAIL ITEM THEN item.fm-codigo ELSE ""
                              ttITEM.expectedDeliveryDate = prazo-compra.data-entrega
                              ttITEM.materialFamily  = IF AVAIL familia THEN familia.descricao ELSE ""
                              ttITEM.productID       = ordem-compra.it-codigo
                              ttITEM.productName     = v-desc-item
                              ttITEM.shipper	     = TRIM (v-des-transp)                          
                              ttITEM.productLongName = v-narrativa
                              ttITEM.ncm	         = item.class-fiscal
                              ttITEM.ipiTax	         = cotacao-item.aliquota-ipi
                              ttITEM.icmsTax	     = cotacao-item.aliquota-icm
                              ttITEM.issTax	         = cotacao-item.aliquota-iss
                              ttITEM.serviceProvider = "False"
                              NO-ERROR.                   
                   END.
               END.
           END.
        END.

        if  temp-table ttPEDIDO:has-records
       //and temp-table ttITEM:has-records
        then do:
             assign c-return-aux = "OK".

             if  avail pedido-compr
             and pedido-compr.situacao = 2
             and can-find(first ordem-compra use-index pedido where
                                ordem-compra.num-pedido = pedido-compr.num-pedido
                            and ordem-compra.situacao  <> 4
                                no-lock)
             then do:
                  run pi-atualiza-pedido.
                  assign c-return-aux = return-value.
             end.

             if c-return-aux = "OK"
             then RUN pi-gera-cJson.
        end.
        

        // RUN pi-gera-json-arq (INPUT pedido-compr.num-pedido).
        
    END.

    IF SEARCH (cMessage) <> ? THEN DO:
        OS-DELETE cMessage.
    END.

END.

procedure pi-atualiza-pedido:
    empty temp-table tt-versao-integr.
    empty temp-table tt-pedido-compr.
    empty temp-table tt-erros-geral.
/*     empty temp-table tt-cond-especif.      */
/*     empty temp-table tt-ordem-compra.      */
/*     empty temp-table tt-prazo-compra.      */
/*     empty temp-table tt-cotacao-item.      */
/*     empty temp-table tt-desp-cotacao-item. */

    FIND LAST int-mov-ped-compr NO-LOCK
        WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
          AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.

    IF AVAIL int-mov-ped-compr THEN
        ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
    ELSE
        ASSIGN v-num-seq-movto = 20.

    create tt-pedido-compr.
    buffer-copy pedido-compr to tt-pedido-compr
    assign tt-pedido-compr.ind-tipo-movto = 2
           tt-pedido-compr.situacao       = 1.

    create tt-versao-integr.
    assign tt-versao-integr.cod-versao-integracao = 1.

    do transaction on error undo, return "NOK":
        CREATE int-mov-ped-compr.
        ASSIGN int-ped-compr.ind-status        = 2 // "Em Processamento"
               int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
               int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
               int-mov-ped-compr.num-seq-movto = v-num-seq-movto
               int-mov-ped-compr.ind-tip-movto = "Em Processamento"
               int-mov-ped-compr.id-api-log    = es-api-log.id-api-log
               int-mov-ped-compr.dat-movto     = TODAY
               int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
               int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
               int-mov-ped-compr.des-text-histor = "Pedido de Compras em processamento: " + STRING (pedido-compr.num-pedido).

        run ccp/ccapi303.p(input  table tt-versao-integr,
                           output table tt-erros-geral append,
                           input  table tt-pedido-compr,
                           input  table tt-cond-especif,
                           input  table tt-ordem-compra,
                           input  table tt-prazo-compra,
                           input  table tt-cotacao-item,
                           input  table tt-desp-cotacao-item).

        if  return-value = "OK"
        and not temp-table tt-erros-geral:has-records
        and pedido-compr.situacao = 1 /* Impresso */
        then.
        else undo, return "NOK".
    end. /* do transaction */

    find current int-mov-ped-compr no-lock no-error.
    release int-mov-ped-compr.

    return "OK".
end procedure. /* procedure pi-atualiza-pedido */

PROCEDURE pi-gera-cJson:

    FIND FIRST ttPEDIDO NO-LOCK NO-ERROR.
    IF AVAIL ttPEDIDO THEN DO:
        ASSIGN cJson = '~{' + CHR(10)                     
                     + '  "currency": "' +  ttPEDIDO.currency + '",' + CHR(10)  
                     + '  "docVersion": "' + STRING (ttPEDIDO.docVersion) + '",' + CHR(10)                 
                     + '  "paymentTerms": "' + STRING (ttPEDIDO.paymentTerms) + '",' + CHR(10)                    
                     + '  "paymentDescription": "' + ttPEDIDO.paymentDescription + '",' + CHR(10)
                     + '  "purchaseOrderId": ' + STRING (ttPEDIDO.purchaseOrderId) + ',' + CHR(10)                    
                     + '  "supplierId": ' + STRING (ttPEDIDO.supplierId) + ',' + CHR(10)                    
                     + '  "language": "' + ttPEDIDO.language + '",'  + CHR(10)
                     + '  "businessUnit": "' + ttPEDIDO.businessUnit + '",' + CHR(10)
                     + '  "supplierEmail": "' + ttPEDIDO.supplierEmail + '",' + CHR(10)
                     + '  "buyerEmail": "' + ttPEDIDO.buyerEmail + '",' + CHR(10)
                     + '  "taxId": "' + ttPEDIDO.taxId + '",' + CHR(10)                    
                     + '  "corporateName": "' + ttPEDIDO.corporateName + '",' + CHR(10)
                     + '  "addressCountry": "' + ttPEDIDO.addressCountry + '",' + CHR(10)
                     + '  "addressStreet": "' + ttPEDIDO.addressStreet + '",' + CHR(10)
                     + '  "addressNumber": "' + ttPEDIDO.addressNumber + '",'   + CHR(10)
                     + '  "addressComplement": "' + ttPEDIDO.addressComplement + '",' + CHR(10)
                     + '  "addressDistrict": "' + ttPEDIDO.addressDistrict + '",' + CHR(10)
                     + '  "addressPostalCode": "' + ttPEDIDO.addressPostalCode + '",' + CHR(10)
                     + '  "addressState": "' + ttPEDIDO.addressState + '",' + CHR(10)
                     + '  "addressCity": "' + ttPEDIDO.addressCity + '",' + CHR(10)                    
                     + '  "billingLocationDescription": "' + ttPEDIDO.billingLocationDescription + '",' + CHR(10)
                     + '  "billingCountry": "' + ttPEDIDO.billingCountry + '",' + CHR(10)
                     + '  "billingStreet": "' + ttPEDIDO.billingStreet + '",' + CHR(10)
                     + '  "billingNumber": "' + ttPEDIDO.billingNumber + '",' + CHR(10) 
                     + '  "billingComplement": "' + ttPEDIDO.billingComplement + '",' + CHR(10)
                     + '  "billingDistrict": "' + ttPEDIDO.billingDistrict + '",' + CHR(10)
                     + '  "billingPostalCode": "' + ttPEDIDO.billingPostalCode + '",' + CHR(10)
                     + '  "billingState": "' + ttPEDIDO.billingState + '",' + CHR(10)
                     + '  "billingCity": "' + ttPEDIDO.billingCity + '",' + CHR(10)
                     + '  "deliveryLocationDescription": "' + ttPEDIDO.deliveryLocationDescription + '",' + CHR(10)
                     + '  "deliveryCountry": "' + ttPEDIDO.deliveryCountry + '",' + CHR(10)
                     + '  "deliveryStreet": "' + ttPEDIDO.deliveryStreet + '",' + CHR(10)
                     + '  "deliveryNumber": "' + ttPEDIDO.deliveryNumber + '",' + CHR(10)
                     + '  "deliveryComplement": "' + ttPEDIDO.deliveryComplement + '",' + CHR(10)
                     + '  "deliveryDistrict": "' + ttPEDIDO.deliveryDistrict + '",' + CHR(10)
                     + '  "deliveryPostalCode": "' + ttPEDIDO.deliveryPostalCode + '",' + CHR(10)
                     + '  "deliveryState": "' + ttPEDIDO.deliveryState + '",' + CHR(10)
                     + '  "deliveryCity": "' + ttPEDIDO.deliveryCity + '",' + CHR(10)            
                     + '  "billingCNPJ": "' + ttPEDIDO.billingCNPJ + '",' + CHR(10)
                     + '  "billingMunicipalRegistration": "' + ttPEDIDO.billingMunicipalRegistration + '",' + CHR(10)
                     + '  "billingStateRegistration": "' + ttPEDIDO.billingStateRegistration + '",' + CHR(10)
                     + '  "deliveryCNPJ": "' + ttPEDIDO.deliveryCNPJ + '",' + CHR(10)
                     + '  "deliveryMunicipalRegistration": "' + ttPEDIDO.deliveryMunicipalRegistration + '",' + CHR(10)
                     + '  "deliveryStateRegistration": "' + ttPEDIDO.deliveryStateRegistration + '",' + CHR(10)
                     + '  "supplierCNPJ": "' + ttPEDIDO.supplierCNPJ + '",' + CHR(10)
                     + '  "supplierMunicipalRegistration": "' + ttPEDIDO.supplierMunicipalRegistration + '",' + CHR(10)
                     + '  "supplierStateRegistration": "' + ttPEDIDO.supplierStateRegistration + '",' + CHR(10)
                     + '  "orderMessage": "' + ttPEDIDO.orderMessage + '",' + CHR(10)
                     + '  "buyerName": "' + ttPEDIDO.buyerName + '",' + CHR(10)
                     + '  "Itens": [' + CHR(10) .    
        
        FOR EACH ttITEM 
            WHERE ttITEM.id = ttPEDIDO.id
            BREAK BY ttITEM.id: 
            ASSIGN cJson = cJson
                         + FILL (chr(32), 7) + '~{' + CHR(10)                                                  
                         + '       "itemPosition":' + STRING (ttITEM.itemPosition) + ',' + CHR(10)
                         + '       "action": "' + ttITEM.action + '",' + CHR(10)
                         + '       "quantity": ' + REPLACE (STRING (ttITEM.quantity, ">>>>>>>>9.9999"), ",", ".") + ',' + CHR(10)               
                         + '       "unitMeasure": "' + ttITEM.unitMeasure + '",' + CHR(10)
                         + '       "unitPrice": ' + REPLACE (STRING (ttITEM.unitPrice, ">>>>>>>>9.99999"), ",", ".") + ',' + CHR(10)
                         + '       "unitSubtotal": ' + REPLACE (STRING (ttITEM.unitSubtotal, ">>>>>>>>9.99999"), ",", ".") + ',' + CHR(10)                
                         + '       "netWeight": ' + REPLACE (STRING (ttITEM.netWeight, ">>>>>>>>9.99999"), ",", ".") + ',' + CHR(10)
                         + '       "centerId": "' + ttITEM.centerId + '",' + CHR(10)
                         + '       "materialGroup": "' + ttITEM.materialGroup + '",' + CHR(10)                        
                         + '       "expectedDeliveryDate": "' + fc-data (ttITEM.expectedDeliveryDate) + '",' + CHR(10)                
                         + '       "materialFamily": "' + ttITEM.materialFamily + '",' + CHR(10)
                         + '       "productID": "' + ttITEM.productID + '",' + CHR(10)
                         + '       "productName": "' + ttITEM.productName + '",' + CHR(10)                
                         + '       "shipper": "' + ttITEM.shipper + '",' + CHR(10)
                         + '       "productLongName": "' + ttITEM.productLongName + '",' + CHR(10)
                         + '       "ncm": "' + ttITEM.ncm + '",' + CHR(10)
                         + '       "ipiTax": ' + REPLACE (STRING (ttITEM.ipiTax, ">>>>9.99"), ",", ".") + ',' + CHR(10)
                         + '       "icmsTax": ' + REPLACE (STRING (ttITEM.icmsTax, ">>>>9.99"), ",", ".") + ',' + CHR(10)
                         + '       "issTax": ' + REPLACE (STRING (ttITEM.issTax, ">>>>9.99"), ",", ".") + ',' + CHR(10)
                         + '       "serviceProvider": "' + ttITEM.serviceProvider + '"' + CHR(10).
            IF LAST-OF (ttITEM.id) THEN
                ASSIGN cJson = cJson
                             + FILL (chr(32), 7) + '}' + CHR(10).
            ELSE
                ASSIGN cJson = cJson
                             + FILL (chr(32), 7) + '},' + CHR(10).
        END.
        
        ASSIGN cJson = cJson
                     + '  ]' + CHR(10)
                     + '}'.                     
    END.

END.

PROCEDURE pi-gera-pdf:

    DEF INPUT PARAM p-num-pedido  AS INT NO-UNDO.
    DEF OUTPUT PARAM p-arq-pdf    AS CHAR NO-UNDO.

    FIND FIRST pedido-compr 
       WHERE pedido-compr.num-pedido = p-num-pedido NO-ERROR.
    IF AVAIL pedido-compr THEN DO:

        ASSIGN c-arquivo-pdf = SESSION:TEMP-DIRECTORY + "PED_" + STRING (p-num-pedido) + ".pdf" NO-ERROR.

        ASSIGN c-arq-pdf = TRIM(c-arquivo-pdf).

        IF OPSYS NE "UNIX" THEN
            ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/", "\").

        RUN pdf_new ("Spdf", c-arq-pdf).

        RUN pdf_new_page("Spdf").
            
        ASSIGN i-linha = 790.
    
        RUN pi-observacao.

    END.

    IF i-linha <> 0 THEN DO:
        RUN pdf_close ("Spdf").  
        // OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.
    END.

    ASSIGN p-arq-pdf = c-arq-pdf.

    // ASSIGN p-texto-conv = FCODIFICAARQUIVOBASE64(c-arq-pdf).
    // MESSAGE p-arq-pdf VIEW-AS ALERT-BOX.

END.

PROCEDURE pi-observacao:

    DEF VAR v-texto-mensag LIKE mensagem.texto-mensag NO-UNDO.

    FIND FIRST mensagem NO-LOCK
         WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem NO-ERROR.
    IF AVAIL mensagem THEN DO:
        
        ASSIGN v-texto-mensag = TRIM (mensagem.texto-mensag)
               // v-texto-mensag = REPLACE (v-texto-mensag, "https://", " ")
               v-texto-mensag = REPLACE (v-texto-mensag, CHR(10), CHR(32))
               v-texto-mensag = REPLACE (v-texto-mensag, CHR(13), CHR(32)).
        ASSIGN i-linha = i-linha - 10.

        RUN pdf_set_font("Spdf","Helvetica", 8).

        DO  i-lin = 1 TO NUM-ENTRIES(mensagem.texto-mensag, CHR(10)):
            ASSIGN c-linha = ENTRY(i-lin ,mensagem.texto-mensag,CHR(10)).

            IF LENGTH(ENTRY(i-lin, mensagem.texto-mensag, CHR(10))) > 150 THEN DO:
                RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(c-linha,1,150),  5,  i-linha). 
                ASSIGN i-linha = i-linha - 10.
                RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(c-linha,151,150),  5,  i-linha). 
                ASSIGN i-linha = i-linha - 10.
            END.
            ELSE DO:
                RUN pdf_text_xy IN h_PDFinc ("Spdf",c-linha,  5,  i-linha). 
                ASSIGN i-linha = i-linha - 10.
            END.
        END.
    END.

END.

PROCEDURE pi-cria-tt-pedido-del:

    DEF INPUT  PARAM p-num-pedido AS INT  NO-UNDO. 
    def output param p-email      as char no-undo.

    DEF VAR i-erro     AS INT NO-UNDO.
    DEF VAR v-cod-pais AS CHAR NO-UNDO.

    def buffer b-ordem-compra for ordem-compra.
    
    FIND pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = p-num-pedido NO-ERROR.
    IF AVAIL pedido-compr THEN DO:        
        FIND usuar-mater NO-LOCK
            WHERE usuar-mater.cod-usuario = pedido-compr.responsavel NO-ERROR.
        for first comprador fields(cod-comprado nome)
            where comprador.cod-comprado = pedido-compr.responsavel
                  no-lock: end.
        FIND FIRST ordem-compra OF pedido-compr NO-LOCK NO-ERROR.
        FIND FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
              AND cotacao-item.cot-aprovada = YES NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            CASE cotacao-item.mo-codigo: 
               WHEN 0 THEN ASSIGN v-des-moeda = "Real".  /* 0 - Real */ 
               WHEN 1 THEN ASSIGN v-des-moeda = "Dolar". /* 1 - D¢lar */ 
               WHEN 4 THEN ASSIGN v-des-moeda = "Yen".  /* 4 - Yen  */
               WHEN 5 THEN ASSIGN v-des-moeda = "Euro".  /* 5 - Euro  */           
               WHEN 6 THEN ASSIGN v-des-moeda = "Libra". /* 6 - Libra  */
               WHEN 7 THEN ASSIGN v-des-moeda = "Renminbi".  /* 7 - Iuan  */
               OTHERWISE ASSIGN v-des-moeda = "Real".
            END CASE.        
        END.
        
        FIND cond-pagto OF pedido-compr NO-LOCK NO-ERROR.
        FIND emitente OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND int-emitente OF emitente NO-LOCK NO-ERROR.
            IF NOT AVAIL int-emitente THEN
                RETURN.
            FIND emitente-cex OF emitente NO-LOCK NO-ERROR.
            FIND mgcad.pais NO-LOCK
                WHERE pais.nome-pais = emitente.pais NO-ERROR.
            IF AVAIL pais THEN
                ASSIGN v-cod-pais = SUBSTR (pais.char-1, 23, 2).
            ELSE
                ASSIGN v-cod-pais = "BR".
            FIND idioma NO-LOCK
                WHERE idioma.cod_idioma = emitente-cex.cod-idioma NO-ERROR.

            FIND FIRST transporte NO-LOCK
                WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

            IF NOT AVAIL transporte
            THEN FIND FIRST transporte NO-LOCK
                      WHERE transporte.cod-transp = emitente.cod-transp NO-ERROR.

            ASSIGN v-des-transp = "".
            IF AVAIL transporte THEN
                ASSIGN v-des-transp = transporte.nome
                       v-des-transp = STRING (transporte.cod-transp) + chr(32) + CHR(45) + CHR(32) + v-des-transp.    

            for first cont-emit fields(cod-emitente area e-mail) use-index codigo
                where cont-emit.cod-emitente = emitente.cod-emitente
                  and cont-emit.area         = "COMERCIAL"
                  and cont-emit.e-mail      <> ""
                      no-lock: end.

            if not avail cont-emit
            then for first cont-emit fields(cod-emitente sequencia e-mail)
                     where cont-emit.cod-emitente = emitente.cod-emitente
                       and cont-emit.sequencia    = 10
                       and cont-emit.e-mail      <> ""
                           no-lock: end.

            if avail cont-emit
            then assign p-email = trim(cont-emit.e-mail).
            else return.

            CREATE ttPEDDEL.
            ASSIGN ttPEDDEL.id                 = pedido-compr.num-pedido
                   ttPEDDEL.purchaseOrderId    = pedido-compr.num-pedido                   	
                   ttPEDDEL.buyerEmail	       = IF AVAIL usuar-mater THEN usuar-mater.e-mail ELSE ""
                   ttPEDDEL.currency    	   = v-des-moeda
                   ttPEDDEL.paymentTerms	   = pedido-compr.cod-cond-pag
                   ttPEDDEL.paymentDescription = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                   ttPEDDEL.paymentDays        = IF AVAIL cond-pagto THEN STRING (cond-pagto.prazos[1]) ELSE "30"
                   ttPEDDEL.language	       = IF AVAIL idioma THEN idioma.des_idioma ELSE "Portuguˆs"
                   ttPEDDEL.businessUnit	   = ordem-compra.cod-unid-negoc 
                   ttPEDDEL.supplierId	       = pedido-compr.cod-emitente
                   ttPEDDEL.supplierEmail	   = p-email
                   ttPEDDEL.corporateName	   = emitente.nome-emit               
                   ttPEDDEL.addressStreet	   = int-emitente.logradouro
                   ttPEDDEL.addressNumber	   = int-emitente.numero
                   ttPEDDEL.addressComplement  = int-emitente.complemento
                   ttPEDDEL.addressDistrict	   = emitente.bairro
                   ttPEDDEL.addressPostalCode  = emitente.cep
                   ttPEDDEL.addressCity	       = emitente.cidade
                   ttPEDDEL.addressState	   = emitente.estado
                   ttPEDDEL.addressCountry	   = v-cod-pais
                   ttPEDDEL.docVersion	       = (fn-get-version(input pedido-compr.num-pedido) - 1)
                   ttPEDDEL.buyerName          = if avail comprador 
                                                 then trim(comprador.nome)
                                                 else "".

           if ttPEDDEL.docVersion = 0
           then assign ttPEDDEL.docVersion = 1.

           RUN pi-billing (INPUT pedido-compr.end-cobranca).
           RUN pi-delivery (INPUT pedido-compr.end-entrega).

           ordem_blk:
           FOR EACH ordem-compra OF pedido-compr NO-LOCK:
               if  can-find(first b-ordem-compra of pedido-compr where
                                  b-ordem-compra.situacao <> 4
                                  no-lock)
               and ordem-compra.situacao = 4
               then next ordem_blk.

/*                IF ordem-compra.situacao = 4 /* Eliminada */     */
/*                OR ordem-compra.situacao = 6 /* Recebida */ then */
/*                    NEXT ordem_blk.                              */
               FIND FIRST cotacao-item NO-LOCK
                   WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                     AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                     AND cotacao-item.cot-aprovada = YES NO-ERROR.
               IF AVAIL cotacao-item THEN DO:
                   FIND ITEM OF ordem-compra NO-LOCK NO-ERROR.
                   IF AVAIL ITEM THEN DO:
                       ASSIGN v-desc-item = TRIM (ITEM.desc-item)
                              v-desc-item = fRemoveAcento (v-desc-item).    

                       ASSIGN v-desc-item = REPLACE (v-desc-item, CHR(9), " ")  
                              v-desc-item = REPLACE (v-desc-item, '"',"'").
                   END.
                   ELSE
                       ASSIGN v-desc-item = "".
                   FIND familia OF ITEM NO-LOCK NO-ERROR.
                   ASSIGN v-narrativa = TRIM (ordem-compra.narrativa)
                          v-narrativa = REPLACE (v-narrativa, CHR(10), CHR(32))
                          v-narrativa = REPLACE (v-narrativa, CHR(13), CHR(32)).

                   ASSIGN v-narrativa = REPLACE (v-narrativa, CHR(9), " ")
                          v-narrativa = REPLACE (v-narrativa, '"',"'").

                   FOR EACH prazo-compra OF ordem-compra NO-LOCK:
                       CREATE ttITDEL. 
                       ASSIGN v-num-item = INT (SUBSTR (STRING (ordem-compra.numero-ordem, "999999999"), 4) + STRING (prazo-compra.parcela, "99"))
                              ttITDEL.id              = pedido-compr.num-pedido
                              ttITDEL.itemPosition    = v-num-item
                              ttITDEL.action          = "ExclusÆo"
                              ttITDEL.quantity        = ordem-compra.qt-solic // ou prazo-compra.quantidade
                              ttITDEL.unitMeasure	  = cotacao-item.un
                              ttITDEL.unitPrice	      = cotacao-item.pre-unit-for
                              ttITDEL.materialBusinessUnit = "1"
                              ttITDEL.unitSubtotal    = cotacao-item.preco-fornec
                              ttITDEL.netWeight	      = IF AVAIL ITEM THEN item.peso-liquido ELSE 0
                              ttITDEL.centerId	      = pedido-compr.cod-estabel
                              ttITDEL.materialGroup   = IF AVAIL ITEM THEN item.fm-codigo ELSE ""
                              ttITDEL.expectedDeliveryDate = prazo-compra.data-entrega
                              ttITDEL.remittanceQuantity = "1"
                              ttITDEL.materialFamily  = IF AVAIL familia THEN familia.descricao ELSE ""
                              ttITDEL.productID       = ordem-compra.it-codigo
                              ttITDEL.productName     = v-desc-item
                              ttITDEL.productShortname = v-desc-item
                              /*
                              ttITDEL.shipper	     = TRIM (v-des-transp)                          
                              ttITDEL.productLongName = v-narrativa
                              ttITDEL.ncm	         = item.class-fiscal
                              ttITDEL.ipiTax	         = cotacao-item.aliquota-ipi
                              ttITDEL.icmsTax	     = cotacao-item.aliquota-icm
                              ttITDEL.issTax	         = cotacao-item.aliquota-iss
                              ttITDEL.serviceProvider = "False" 
                              */
                              NO-ERROR.                   
                   END.
               END.
           END.
        END.

        RUN pi-gera-json-arq (INPUT pedido-compr.num-pedido).
        
    END.

    IF SEARCH (cMessage) <> ? THEN DO:
        OS-DELETE cMessage.
    END.

END.

PROCEDURE pi-billing:

    DEF INPUT PARAM p-end-cobranca AS CHAR NO-UNDO.

    DEF VAR v-cod-pais AS CHAR NO-UNDO.

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = p-end-cobranca NO-ERROR.
    FIND emitente OF estabelec NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND mgcad.pais NO-LOCK
            WHERE pais.nome-pais = emitente.pais NO-ERROR.
        IF AVAIL pais THEN
            ASSIGN v-cod-pais = SUBSTR (pais.char-1, 23, 2).
        ELSE
            ASSIGN v-cod-pais = "BR".
        FIND int-emitente OF emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL int-emitente THEN
            RETURN.
        IF c-metodo <> "DELETE" THEN DO:
            ASSIGN ttPEDIDO.billingLocationDescription = TRIM (emitente.nome-abrev)
                   ttPEDIDO.billingCNPJ	       = emitente.cgc
                   ttPEDIDO.billingStreet	   = TRIM (int-emitente.logradouro)
                   ttPEDIDO.billingNumber	   = int-emitente.numero
                   ttPEDIDO.billingComplement  = TRIM (int-emitente.complemento)
                   ttPEDIDO.billingPostalCode  = emitente.cep
                   ttPEDIDO.billingDistrict	   = emitente.bairro
                   ttPEDIDO.billingCity	       = emitente.cidade
                   ttPEDIDO.billingState	   = emitente.estado
                   ttPEDIDO.billingCountry	   = v-cod-pais
                   ttPEDIDO.billingMunicipalRegistration = emitente.ins-municipal
                   ttPEDIDO.billingStateRegistration = emitente.ins-estadual.
        END.
        ELSE DO:
            ASSIGN ttPEDDEL.billingLocationDescription = TRIM (emitente.nome-abrev)
                   ttPEDDEL.billingStreet	   = TRIM (int-emitente.logradouro)
                   ttPEDDEL.billingNumber	   = int-emitente.numero
                   ttPEDDEL.billingComplement  = TRIM (int-emitente.complemento)
                   ttPEDDEL.billingPostalCode  = emitente.cep
                   ttPEDDEL.billingDistrict	   = emitente.bairro
                   ttPEDDEL.billingCity	       = emitente.cidade
                   ttPEDDEL.billingState	   = emitente.estado
                   ttPEDDEL.billingCountry	   = v-cod-pais.
        END.
    END.

END.

PROCEDURE pi-delivery:

    DEF INPUT PARAM p-end-entrega AS CHAR NO-UNDO.

    DEF VAR v-cod-pais AS CHAR NO-UNDO.

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = p-end-entrega NO-ERROR.
    FIND emitente OF estabelec NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND mgcad.pais NO-LOCK
            WHERE pais.nome-pais = emitente.pais NO-ERROR.
        IF AVAIL pais THEN
            ASSIGN v-cod-pais = SUBSTR (pais.char-1, 23, 2).
        ELSE
            ASSIGN v-cod-pais = "BR".
        FIND int-emitente OF emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL int-emitente THEN
            RETURN.
        IF c-metodo <> "DELETE" THEN DO:
            ASSIGN ttPEDIDO.deliveryLocationDescription = TRIM (emitente.nome-abrev)
                   ttPEDIDO.deliveryCNPJ	   = emitente.cgc
                   ttPEDIDO.deliveryStreet	   = TRIM (int-emitente.logradouro)
                   ttPEDIDO.deliveryNumber	   = int-emitente.numero
                   ttPEDIDO.deliveryPostalCode = emitente.cep
                   ttPEDIDO.deliveryComplement = TRIM (int-emitente.complemento)
                   ttPEDIDO.deliveryDistrict   = emitente.bairro
                   ttPEDIDO.deliveryCity	   = emitente.cidade
                   ttPEDIDO.deliveryState	   = emitente.estado
                   ttPEDIDO.deliveryCountry	   = v-cod-pais
                   ttPEDIDO.deliveryMunicipalRegistration = emitente.ins-municipal
                   ttPEDIDO.deliveryStateRegistration = emitente.ins-estadual.
        END.
        ELSE DO:
            ASSIGN ttPEDDEL.deliveryLocationDescription = TRIM (emitente.nome-abrev)
                   ttPEDDEL.deliveryStreet	   = TRIM (int-emitente.logradouro)
                   ttPEDDEL.deliveryNumber	   = int-emitente.numero
                   ttPEDDEL.deliveryPostalCode = emitente.cep
                   ttPEDDEL.deliveryComplement = TRIM (int-emitente.complemento)
                   ttPEDDEL.deliveryDistrict   = emitente.bairro
                   ttPEDDEL.deliveryCity	   = emitente.cidade
                   ttPEDDEL.deliveryState	   = emitente.estado
                   ttPEDDEL.deliveryCountry	   = v-cod-pais.
        END.
    END.
END.

PROCEDURE pi-gera-json-arq:

    DEF INPUT PARAM p-num-pedido AS INT NO-UNDO.

    DEF VAR mJson       AS MEMPTR            NO-UNDO.
    DEF VAR myParser    AS ObjectModelParser NO-UNDO.

    DEF VAR oEntity     AS LONGCHAR          NO-UNDO.
    DEF VAR cLongJson   AS LONGCHAR          NO-UNDO.
    DEF VAR jsonObject  AS JsonObject        NO-UNDO.
    DEF VAR pJsonInput  AS JsonObject        NO-UNDO.

    DEF VAR cArquivo    AS CHAR              NO-UNDO.
    DEF VAR cArqNew     AS CHAR              NO-UNDO.
    DEF VAR cJsonAux    AS CHAR              NO-UNDO.
    DEF VAR v-des-lin   AS CHAR              NO-UNDO.
    DEF VAR v-num-tot   AS INT               NO-UNDO.
    DEF VAR v-num-lin   AS INT               NO-UNDO.
    DEF VAR l-ok        AS LOG               NO-UNDO.

    IF c-metodo <> "DELETE" THEN DO:
        hdts = DATASET dts:HANDLE.
    END.
    ELSE DO:
        hdts = DATASET dtsdel:HANDLE.
    END.

    ASSIGN cArquivo = SESSION:TEMP-DIRECTORY + "PED_" + STRING (p-num-pedido) + ".json"
           cArqNew  = SESSION:TEMP-DIRECTORY + "PED_" + STRING (p-num-pedido) + "New.json".

    ASSIGN jsonObject = NEW JsonObject().
    IF c-metodo <> "DELETE" THEN
        ASSIGN l-ok = DATASET dts:write-json("JsonObject", jsonObject, FALSE, "UTF-8", false, TRUE, false).
    ELSE
        ASSIGN l-ok = DATASET dtsdel:write-json("JsonObject", jsonObject, false, "UTF-8", false, TRUE, false).

    jsonObject = jsonObject:getjsonarray("PEDIDO"):getjsonobject(1).
    // jsonObject:writefile(cArqNew).
    jsonObject:writefile(cArqNew).    
    ASSIGN cJson = "".
    FIX-CODEPAGE (cJson) = "UTF-8".
    jsonObject:WRITE (INPUT-OUTPUT cJson).    
    // assign cJson = STRING (jsonObject) no-error.
    // ASSIGN cJson = CODEPAGE-CONVERT(cJson, "UTF-8":U).

END.

function fn-get-version returns integer (input i-num-pedido as integer):
    def buffer b-int-mov-ped-compr for int-mov-ped-compr.

    def var i-cont as inte no-undo.

    for first int-ped-compr
        where int-ped-compr.num-pedido = i-num-pedido
              no-lock: end. 

    assign i-cont = 1.
    if avail int-ped-compr
    then for each b-int-mov-ped-compr fields(id-ped-compr ind-tip-movto) no-lock
            where b-int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
              and b-int-mov-ped-compr.ind-tip-movto = "Integrado":
             assign i-cont = i-cont + 1.
         end. /* for each b-int-mov-ped-compr */

    return i-cont.
end function.

