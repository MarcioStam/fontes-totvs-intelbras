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

{esp/esapi505.i}
{esp/es0018.i}

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF NEW GLOBAL SHARED VAR l-esapi555 AS l NO-UNDO.

DEF VAR cJson                AS c           NO-UNDO.

DEF VAR httCust              AS HANDLE      NO-UNDO.
DEF VAR lReturnValue         AS LOGICAL     NO-UNDO.
DEF VAR cMetodo              AS c           NO-UNDO.


DEF TEMP-TABLE auxRowErrors NO-UNDO
    LIKE RowErrors.

DEF TEMP-TABLE declaracao   NO-UNDO
    FIELD numeroEmbarque    AS c
    FIELD numeroDI          AS c
    FIELD dataRegistroDI    AS c
    .

DEF TEMP-TABLE Pedidos      NO-UNDO 
    FIELD numeroEmbarque    AS c
    FIELD numeroPedido      AS c
    FIELD codigoExportador  AS c
    FIELD moeda             AS i
    FIELD acrescimoPedido   AS de
    FIELD condicaoPagamento AS c
    .

DEF TEMP-TABLE ItensPedido  NO-UNDO
    FIELD numeroEmbarque    AS c
    FIELD numeroPedido      AS c
    FIELD codigo            AS c
    FIELD cquantidade       AS c
    FIELD quantidade        AS de
    FIELD cfop              AS i
    FIELD pesoLiquido       AS de
    FIELD pesoBruto         AS de
    FIELD numeroAdicao      AS i
    FIELD sequenciaAdicao   AS i
    FIELD aliquotaII        AS de
    FIELD aliquotaIPI       AS de
    FIELD aliquotaICMS      AS de 
    FIELD aliquotaPIS       AS de
    FIELD aliquotaCOFINS    AS de
    FIELD Proc              AS l

    FIELD ge-codigo         AS i
    FIELD condpagto         AS c
    .

DEFINE BUFFER b-embarque-imp FOR embarque-imp.

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225e
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO like ordens-embarque 
    field r-rowid  as rowid.

{include/boerrtab.i}

{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE tt-ordens-desemb NO-UNDO 
    LIKE ordens-embarque
   FIELD c-it-codigo like item.it-codigo
   FIELD c-desc-item like item.desc-item
   FIELD c-un like item.un
   FIELD c-un-item like item.un
   FIELD c-un-fornec like item.un
   FIELD de-quantidade like ordens-embarque.quantidade
   FIELD de-peso-bruto AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-bruto*/
   FIELD de-peso-bruto-unit AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-bruto*/
   FIELD de-peso-liquido AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-liquido*/
   FIELD de-peso-liquido-unit AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-liquido*/
   FIELD i-trib-ii as integer
   FIELD c-trib-ii as char format "!" label "Tributa»’o II"
   FIELD c-desc-ii as char format "x(10)" label "Tributa»’o II"
   FIELD i-trib-ipi as integer
   FIELD c-trib-ipi as char format "!" label "Tributa»’o IPI"
   FIELD c-desc-ipi as char format "x(10)" label "Tributa»’o IPI"
   FIELD i-trib-icms as integer
   FIELD c-trib-icms as char format "!" label "Tributa»’o ICMS"
   FIELD c-desc-icms as char format "x(10)" label "Tributa»’o ICMS"
   FIELD i-trib-pis as integer
   FIELD c-trib-pis as char format "!" label "Tributa»’o Pis"
   FIELD c-desc-pis as char format "x(10)" label "Tributa»’o PIS"
   FIELD i-trib-cofins as integer
   FIELD c-trib-cofins as char format "!" label "Tributa»’o COFINS"
   FIELD c-desc-cofins as char format "x(10)" label "Tributa»’o COFINS"
   FIELD de-aliq-ii as decimal format ">>>9.99" label "% II"
   FIELD de-aliq-ipi as decimal format ">>>9.99" label "% IPI"
   FIELD de-aliq-icms  as decimal format ">>>9.99" label "% ICMS"
   FIELD de-aliq-pis as decimal format ">>>9.99" label "% EXTERNO PIS"
   FIELD de-aliq-cofins as decimal format ">>>9.99" label "% EXTERNO COFINS"
   FIELD c-class-fiscal AS CHAR FORMAT "9999.99.99" LABEL "Class Fisc"
   FIELD c-nat-fiscal AS c     // Campo de diferen‡a da versÆo do FIX aplicado
   
   FIELD l-suspensao-II  AS LOGICAL FORMAT "Sim/N’o" LABEL "Susp II"
   FIELD l-suspensao-IPI AS LOGICAL FORMAT "Sim/N’o" LABEL "Susp IPI"

   FIELD de-cubagem like ordens-embarque.val-cub-tot
   FIELD de-cubagem-tot like ordens-embarque.val-cub-tot
   FIELD de-peso-embal AS DECIMAL FORMAT "->>>,>>9.99999" /*LIKE ordens-embarque.val-peso-embal*/
        
   FIELD cdn-adicao AS INTEGER FORMAT ">>>9" LABEL "Nr.Adi»’o"
   FIELD de-taxa-siscomex AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" LABEL "Taxa Siscomex"
   FIELD seq-item   AS INT FORMAT ">>>9" LABEL "Seq. Item Adi»’o"
   FIELD l-aplica-desc-icms AS l //
   FIELD r-rowid as rowid.



define temp-table tt-ordens-desemb-aux no-undo
   FIELD numero-ordem     as INTEGER FORMAT "zzzzz9,99"
   FIELD parcela          as INTEGER FORMAT ">>>>9"
   FIELD it-codigo        as CHAR    FORMAT "X(16)"
   FIELD un               as CHAR    FORMAT "X(2)"
   FIELD quantidade       as DECIMAL FORMAT ">>>>>,>>9.9999"
   FIELD peso-bruto       as DECIMAL FORMAT ">>>>,>>9.9999999999"
   FIELD peso-liquido     as DECIMAL FORMAT ">>>>,>>9.9999999999"
   FIELD trib-II          AS CHAR    FORMAT "X(1)"
   FIELD aliq-II          AS DECIMAL FORMAT ">>>9.99"
   FIELD trib-IPI         AS CHAR    FORMAT "X(1)"
   FIELD aliq-IPI         AS DECIMAL FORMAT ">>>9.99"
   FIELD trib-ICMS        AS CHAR    FORMAT "X(1)"
   FIELD aliq-ICMS        AS DECIMAL FORMAT ">>>9.99"
   FIELD trib-PIS         AS CHAR    FORMAT  "X(1)"
   FIELD aliq-pis         AS DECIMAL FORMAT ">>>9.99"
   FIELD trib-COFINS      AS CHAR    FORMAT  "X(1)"
   FIELD aliq-cofins      AS DECIMAL FORMAT ">>>9.99"
   FIELD c-class-fiscal   AS CHAR    FORMAT "9999.99.99".

DEF TEMP-TABLE tt-desp-embarque NO-UNDO 
    LIKE desp-embarque
   FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-alt-ordens-desemb NO-UNDO
    FIELD rw-registro AS ROWID.


DEF VAR h-bocx220       AS HANDLE                      NO-UNDO.                                         
DEF VAR h-bocx225e      AS HANDLE                      NO-UNDO.                                         
DEF VAR h-bocx250       AS HANDLE                      NO-UNDO.                                         
DEF VAR h-boin046na     AS HANDLE                      NO-UNDO.
DEF VAR h-bocx310       AS HANDLE                      NO-UNDO.
                                                       
DEF VAR i-mo-codigo     AS i                           NO-UNDO.
DEF VAR deValorDesp     LIKE tt-desp-embarque.val-desp NO-UNDO.
DEF VAR iNrRegistro     AS   INTEGER                   NO-UNDO.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi555 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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


/* ***************************  Main Block  *************************** */

DEF VAR lcInput    AS LONGCHAR         NO-UNDO.

DEF VAR jsonParser AS ObjectModelParser NO-UNDO.
DEF VAR jsonInput  AS JsonObject        NO-UNDO.

FOR FIRST es-api-log
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:

    ASSIGN
       es-api-log.dh-envio = NOW.

    COPY-LOB es-api-log.cl-envio TO lcInput.

    MESSAGE ">> " STRING(lcInput) SKIP.

    ASSIGN 
       jsonParser = NEW ObjectModelParser()
       jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Despesas").

    RUN pi-input-api-headers (jsonInput).

    RUN piProcessa.

    ASSIGN
       es-api-log.retorno-content-type = "application/json".
    IF TEMP-TABLE RowErrors:HAS-RECORDS = NO
    THEN ASSIGN
       es-api-log.cod-retorno = "200"
       es-api-log.aux         = "Integrado com sucesso".
    ELSE ASSIGN
       es-api-log.cod-retorno = "500".

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".


/*
{
   "numeroEmbarque":"478946f",
   "numeroDI":"4778ew65",
   "dataRegistroDI":"2020-10-26",
   "Pedidos":[
      {
         "numeroPedido":"382133",
         "codigoExportador":"161953",
         "moeda":1058,
         "acrescimoPedido":10.58,
         "condicaoPagamento":"At‚ 180 dias",
         "ItensPedido":[
            {
               "codigo":"65164er77",
               "quantidade":100,
               "cfop":315100,
               "pesoLiquido":50,
               "pesoBruto":60,
               "numeroAdicao":1,
               "sequenciaAdicao":2,
               "aliquotaII":5,
               "aliquotaIPI":10,
               "aliquotaICMS":15,
               "aliquotaPIS":20,
               "aliquotaCOFINS":25
            },
            {
               "codigo":"678963545",
               "quantidade":100,
               "cfop":315100,
               "pesoLiquido":50,
               "pesoBruto":60,
               "numeroAdicao":1,
               "sequenciaAdicao":2,
               "aliquotaII":5,
               "aliquotaIPI":10,
               "aliquotaICMS":15,
               "aliquotaPIS":20,
               "aliquotaCOFINS":25
            }
         ]
      },
      {
         "numeroPedido":"4154154",
         "codigoExportador":"161953",
         "moeda":1058,
         "acrescimoPedido":10.58,
         "condicaoPagamento":"At‚ 180 dias",
         "ItensPedido":[
            {
               "codigo":"231424312",
               "quantidade":100,
               "cfop":315100,
               "pesoLiquido":50,
               "pesoBruto":60,
               "numeroAdicao":1,
               "sequenciaAdicao":2,
               "aliquotaII":5,
               "aliquotaIPI":10,
               "aliquotaICMS":15,
               "aliquotaPIS":20,
               "aliquotaCOFINS":25
            },
            {
               "codigo":"4213214312",
               "quantidade":100,
               "cfop":315100,
               "pesoLiquido":50,
               "pesoBruto":60,
               "numeroAdicao":1,
               "sequenciaAdicao":2,
               "aliquotaII":5,
               "aliquotaIPI":10,
               "aliquotaICMS":15,
               "aliquotaPIS":20,
               "aliquotaCOFINS":25
            }
         ]
      }
   ]
}

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piGeraDespesa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraDespesa Procedure 
PROCEDURE piGeraDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   MESSAGE ">> Despesa".

   RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.
   
   FIND FIRST Pedidos NO-ERROR.

   FIND FIRST moeda NO-LOCK
        WHERE moeda.cod-decex = Pedidos.moeda
        NO-ERROR.
   
   IF NOT AVAIL moeda
   THEN DO:
      RUN piErro ("Moeda " + STRING(Pedidos.moeda) + " nao encontrada.","").
      STOP.
   END.

   FIND FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = 32
        NO-ERROR.

   FIND FIRST int-desp-imp NO-LOCK
        WHERE int-desp-imp.cod-desp = 32
        NO-ERROR.

   IF NOT AVAIL int-desp-imp
   THEN DO:
      RUN piErro ("Extensao Despesa 32 nao encontrada.","").
      STOP.
   END.

   IF int-desp-imp.cdn-pto-base = 0
   THEN DO:
      RUN piErro ("Ponto de Controle Base nÆo foi encontrado para a Despesa 32").
      STOP.
   END.

   FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = INT(Pedidos.codigoExportador)
        NO-ERROR.
   IF NOT AVAIL emitente
   THEN DO:
      RUN piErro ("Fornecedor " + Pedidos.codigoExportador + " nao encontrada.","").
      STOP.
   END.

   FIND FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido   = INT(Pedidos.NumeroPedido)
        NO-ERROR.

   IF NOT AVAIL pedido-compr
   THEN DO:
      RUN piErro ("Pedido " + Pedidos.NumeroPedido + " nao encontrado.","").
      STOP.
   END.

   FIND FIRST cond-pagto NO-LOCK
        WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
        NO-ERROR.

   IF NOT AVAIL cond-pagto
   THEN DO:
      RUN piErro ("Condicao de Pagamento " + Pedidos.condicaoPagamento + " nao encontrada.","").
      STOP.
   END.

   FIND FIRST historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
          AND historico-embarque.embarque      = embarque-imp.embarque
          AND historico-embarque.cod-pto-contr = int-desp-imp.cdn-pto-base
        NO-ERROR.

   IF NOT AVAIL historico-embarque
   THEN DO:
      RUN piErro ("Ponto de Controle " + STRING(int-desp-imp.cdn-pto-base) + " nao encontrado no embarque " + embarque-imp.embarque + ".","").
      STOP.
   END.

   ASSIGN
      i-mo-codigo = moeda.mo-codigo.

   FIND FIRST desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
          AND desp-embarque.embarque          = embarque-imp.embarque
          AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
//          AND desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr //int-desp-imp.cdn-pto-base
          AND desp-embarque.cod-desp          = int-desp-imp.cod-desp
//          AND desp-embarque.cod-emitente-desp = emitente.cod-emitente
       NO-ERROR.

   MESSAGE ">> embarque-imp.cod-estabel        " embarque-imp.cod-estabel        .
   MESSAGE ">> embarque-imp.embarque           " embarque-imp.embarque           .
   MESSAGE ">> historico-embarque.cod-itiner   " historico-embarque.cod-itiner   .
   MESSAGE ">> historico-embarque.cod-pto-contr" historico-embarque.cod-pto-contr.
   MESSAGE ">> int-desp-imp.cod-desp           " int-desp-imp.cod-desp               .
   MESSAGE ">> emitente.cod-emitente           " emitente.cod-emitente           .
   MESSAGE ">> deValorDesp                     " deValorDesp                     .
   MESSAGE ">> avail desp-embarque             " AVAIL desp-embarque.

   /*Cria‡Æo*/

   IF NOT AVAIL desp-embarque 
   THEN DO:
      CREATE tt-desp-embarque.                        
      ASSIGN tt-desp-embarque.cod-estabel       = embarque-imp.cod-estabel
             tt-desp-embarque.embarque          = embarque-imp.embarque   
             tt-desp-embarque.cod-itiner        = historico-embarque.cod-itiner   
             tt-desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
             tt-desp-embarque.cod-desp          = int-desp-imp.cod-desp               
             tt-desp-embarque.cod-emitente-desp = emitente.cod-emitente           

             
             tt-desp-embarque.descricao         = desp-imp.descricao
             tt-desp-embarque.cod-cond-pag      = cond-pagto.cod-cond-pag
             tt-desp-embarque.mo-codigo         = i-mo-codigo
             tt-desp-embarque.val-desp          = deValorDesp
             .

      RUN validateCreate IN h-bocx310 ( INPUT TABLE tt-desp-embarque,
                                       OUTPUT TABLE auxRowErrors,
                                       OUTPUT tt-desp-embarque.r-rowid
                                       ).        
   
      IF CAN-FIND(FIRST auxRowErrors) 
      THEN DO:
         FOR EACH auxRowErrors:  
            CREATE RowErrors.
            BUFFER-COPY auxRowErrors TO RowErrors.
            MESSAGE ">>> Cria Despesa " RowErrors.ErrorDescription.
         END. 
         RETURN "NOK".
      END.    
   END.
   /*Altera‡Æo*/
   ELSE DO:
      
      CREATE tt-desp-embarque.
      BUFFER-COPY desp-embarque TO tt-desp-embarque.

      ASSIGN 
         tt-desp-embarque.cod-cond-pag      = cond-pagto.cod-cond-pag
         tt-desp-embarque.mo-codigo         = i-mo-codigo
         tt-desp-embarque.val-desp          = deValorDesp
         .

      RUN validateUpdate IN h-bocx310 (INPUT  TABLE tt-desp-embarque,
                                       INPUT  ROWID(desp-embarque),
                                       OUTPUT TABLE auxRowErrors
                                       ). 
   
      IF CAN-FIND(FIRST auxRowErrors) 
      THEN DO:
         FOR EACH auxRowErrors:  
            CREATE RowErrors.
            BUFFER-COPY auxRowErrors TO RowErrors.
            MESSAGE ">>> Altera Despesa " RowErrors.ErrorDescription.
         END. 
         RETURN "NOK".
      END.    
   END.

END PROCEDURE.



/*
DEF TEMP-TABLE declaracao   NO-UNDO
    FIELD numeroEmbarque    AS c
    FIELD numeroDI          AS c
    FIELD dataRegistroDI    AS c
    .

DEF TEMP-TABLE Pedidos      NO-UNDO 
    FIELD numeroEmbarque    AS c
    FIELD numeroPedido      AS c
    FIELD codigoExportador  AS c
    FIELD moeda             AS i
    FIELD acrescimoPedido   AS de
    FIELD condicaoPagamento AS c
    .
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessa Procedure 
PROCEDURE piProcessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR jsonObjectPayload    AS JsonObject   NO-UNDO.
   DEF VAR jsonPedidos          AS JsonArray    NO-UNDO.
   DEF VAR JsonObjectPedidos    AS JsonObject   NO-UNDO.
   DEF VAR jsonItens            AS JsonArray    NO-UNDO.
   DEF VAR JsonObjectItens      AS JsonObject   NO-UNDO.

   DEF VAR lErr                 AS l            NO-UNDO.
                                               
   DEF VAR lRetOK               AS l            NO-UNDO.
   DEF VAR i                    AS i            NO-UNDO.
   DEF VAR j                    AS i            NO-UNDO.

   DEF VAR c-return             AS c            NO-UNDO.

   DEF VAR c-nat-operacao       AS c            NO-UNDO.
   DEF VAR c-condpagto          AS c            NO-UNDO.


   DO ON STOP  UNDO, LEAVE 
      ON ERROR UNDO, LEAVE:

      RUN esp/es0018p.p (INPUT "esapi557":U,
                         INPUT 1,
                         INPUT 0,
                         INPUT "":U,
                         OUTPUT TABLE tt-prog-ponto).

      ASSIGN 
         jsonObjectPayload = jsonInput:GetJsonObject("payload").
   
      CREATE declaracao.
   
      /*
      ASSIGN
         declaracao.numeroEmbarque   
         declaracao.numeroDI         
         declaracao.dataRegistroDI   
      */
   
      IF jsonObjectPayload:Has("numeroEmbarque") 
      THEN ASSIGN 
         declaracao.numeroEmbarque = jsonObjectPayload:GetCharacter("numeroEmbarque"). 
      IF jsonObjectPayload:Has("numeroDI") 
      THEN ASSIGN 
         declaracao.numeroDI       = jsonObjectPayload:GetCharacter("numeroDI"). 
      IF jsonObjectPayload:Has("dataRegistroDI") 
      THEN ASSIGN 
         declaracao.dataRegistroDI = jsonObjectPayload:GetCharacter("dataRegistroDI"). 
   
      MESSAGE ">> numeroEmbarque " declaracao.numeroEmbarque.
      MESSAGE ">> numeroDI       " declaracao.numeroDI      .
      MESSAGE ">> dataRegistroDI " declaracao.dataRegistroDI.
   
   
      IF jsonObjectPayload:Has("Pedidos") 
      THEN DO:
         jsonPedidos = jsonObjectPayload:GetJsonArray("Pedidos":U).     
         DO i = 1 TO jsonPedidos:LENGTH:
            JsonObjectPedidos = jsonPedidos:GetJsonObject(i).
            CREATE Pedidos.
            ASSIGN
               Pedidos.numeroEmbarque    = declaracao.numeroEmbarque.
   
            IF JsonObjectPedidos:Has("numeroPedido")
            THEN ASSIGN
               Pedidos.numeroPedido      = JsonObjectPedidos:GetCharacter("numeroPedido").
            IF JsonObjectPedidos:Has("codigoExportador")
            THEN ASSIGN
               Pedidos.codigoExportador  = JsonObjectPedidos:GetCharacter("codigoExportador").
            IF JsonObjectPedidos:Has("moeda")
            THEN ASSIGN
               Pedidos.moeda             = JsonObjectPedidos:GetInteger("moeda").
            IF JsonObjectPedidos:Has("acrescimoPedido")
            THEN ASSIGN
               Pedidos.acrescimoPedido   = JsonObjectPedidos:GetDecimal("acrescimoPedido").
            IF JsonObjectPedidos:Has("condicaoPagamento")
            THEN ASSIGN
               Pedidos.condicaoPagamento = JsonObjectPedidos:GetCharacter("condicaoPagamento").
   
            MESSAGE ">> numeroPedido      " Pedidos.numeroPedido     .
            MESSAGE ">> codigoExportador  " Pedidos.codigoExportador .
            MESSAGE ">> moeda             " Pedidos.moeda            . 
            MESSAGE ">> acrescimoPedido   " Pedidos.acrescimoPedido  . 
            MESSAGE ">> condicaoPagamento " Pedidos.condicaoPagamento. 
            
            IF JsonObjectPedidos:Has("ItensPedido") 
            THEN DO:
               jsonItens = JsonObjectPedidos:GetJsonArray("ItensPedido":U).     
               DO j = 1 TO jsonItens:LENGTH:
                  JsonObjectItens = jsonItens:GetJsonObject(j).
                  CREATE ItensPedido.
                  ASSIGN
                     ItensPedido.numeroEmbarque  = declaracao.numeroEmbarque
                     ItensPedido.numeroPedido    = Pedidos.numeroPedido     .
   
                  IF JsonObjectItens:Has("codigo")
                  THEN ASSIGN
                     ItensPedido.codigo          = JsonObjectItens:GetCharacter("codigo")
                     NO-ERROR.
                  IF JsonObjectItens:Has("quantidade")
                  THEN ASSIGN
                     ItensPedido.cquantidade     = JsonObjectItens:GetCharacter("quantidade")
                     ItensPedido.quantidade      = DECIMAL(REPLACE(ItensPedido.cquantidade,".",","))
                     NO-ERROR.
                  IF JsonObjectItens:Has("cfop")
                  THEN ASSIGN
                     ItensPedido.cfop            = JsonObjectItens:GetInteger("cfop")
                     NO-ERROR.
                  IF JsonObjectItens:Has("pesoLiquido")
                  THEN ASSIGN
                     ItensPedido.pesoLiquido     = JsonObjectItens:GetDecimal("pesoLiquido")
                     NO-ERROR.
                  IF JsonObjectItens:Has("pesoBruto")
                  THEN ASSIGN
                     ItensPedido.pesoBruto       = JsonObjectItens:GetDecimal("pesoBruto")
                     NO-ERROR.
                  IF JsonObjectItens:Has("numeroAdicao")
                  THEN ASSIGN
                     ItensPedido.numeroAdicao    = JsonObjectItens:GetInteger("numeroAdicao")
                     NO-ERROR.
                  IF JsonObjectItens:Has("sequenciaAdicao")
                  THEN ASSIGN
                     ItensPedido.sequenciaAdicao = JsonObjectItens:GetInteger("sequenciaAdicao")
                     NO-ERROR.
                  IF JsonObjectItens:Has("aliquotaII")
                  THEN ASSIGN
                     ItensPedido.aliquotaII      = JsonObjectItens:GetDecimal("aliquotaII")
                     NO-ERROR.
                  IF JsonObjectItens:Has("aliquotaIPI")
                  THEN ASSIGN
                     ItensPedido.aliquotaIPI     = JsonObjectItens:GetDecimal("aliquotaIPI")
                     NO-ERROR.
                  IF JsonObjectItens:Has("aliquotaICMS")
                  THEN ASSIGN
                     ItensPedido.aliquotaICMS    = JsonObjectItens:GetDecimal("aliquotaICMS")
                     NO-ERROR.
                  IF JsonObjectItens:Has("aliquotaPIS")
                  THEN ASSIGN
                     ItensPedido.aliquotaPIS     = JsonObjectItens:GetDecimal("aliquotaPIS")
                     NO-ERROR.
                  IF JsonObjectItens:Has("aliquotaCOFINS")
                  THEN ASSIGN
                     ItensPedido.aliquotaCOFINS  = JsonObjectItens:GetDecimal("aliquotaCOFINS")
                     NO-ERROR.
   
   
                  MESSAGE ">> codigo         " ItensPedido.codigo         .
                  MESSAGE ">> quantidade     " ItensPedido.quantidade     .
                  MESSAGE ">> cfop           " ItensPedido.cfop           .
                  MESSAGE ">> pesoLiquido    " ItensPedido.pesoLiquido    .
                  MESSAGE ">> pesoBruto      " ItensPedido.pesoBruto      .
                  MESSAGE ">> numeroAdicao   " ItensPedido.numeroAdicao   .
                  MESSAGE ">> sequenciaAdicao" ItensPedido.sequenciaAdicao.
                  MESSAGE ">> aliquotaII     " ItensPedido.aliquotaII     .
                  MESSAGE ">> aliquotaIPI    " ItensPedido.aliquotaIPI    .
                  MESSAGE ">> aliquotaICMS   " ItensPedido.aliquotaICMS   .
                  MESSAGE ">> aliquotaPIS    " ItensPedido.aliquotaPIS    .
                  MESSAGE ">> aliquotaCOFINS " ItensPedido.aliquotaCOFINS .

                  IF ERROR-STATUS:ERROR = YES 
                  THEN DO:
                     DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        RUN piErro (ERROR-STATUS:GET-MESSAGE(i),"").
                     END.
                     STOP.
                  END.
               END.
            END.
         END.
      END.

      FOR EACH declaracao:
         FIND FIRST embarque-imp NO-LOCK
              WHERE embarque-imp.embarque = declaracao.numeroEmbarque
              NO-ERROR.
      
         IF NOT AVAIL embarque-imp
         THEN DO:
            RUN piErro ("Embarque " +  declaracao.numeroEmbarque + " nao encontrado.","").
            STOP.
         END.

         ASSIGN
            c-condpagto = "com cobertura".


         FIND FIRST b-embarque-imp EXCLUSIVE-LOCK
              WHERE b-embarque-imp.embarque = declaracao.numeroEmbarque
              NO-ERROR.
         ASSIGN
            b-embarque-imp.declaracao-import = declaracao.numeroDI       
            declaracao.dataRegistroDI        = SUBSTR(declaracao.dataRegistroDI,1,10)
            b-embarque-imp.data-di           = DATE(INT(ENTRY(2,declaracao.dataRegistroDI,"-")),
                                                    INT(ENTRY(3,declaracao.dataRegistroDI,"-")),
                                                    INT(ENTRY(1,declaracao.dataRegistroDI,"-"))
                                                    ).
         RELEASE b-embarque-imp.

      
         /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
         RUN cxbo/bocx220.p   PERSISTENT SET {&hDBOParent}.
         
         
         RUN cxbo/bocx225e.p  PERSISTENT SET {&hDBOSon1}.
         RUN inbo/boin046na.p PERSISTENT SET h-boin046na.
         RUN openQueryStatic  IN h-boin046na (INPUT "Main":U).
         RUN cxbo/bocx250.p   PERSISTENT SET h-bocx250.
         RUN openQuery        IN h-bocx250 (INPUT "1":U).
         
         
         FOR EACH ItensPedido,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ItensPedido.codigo,
            FIRST Pedidos 
            WHERE Pedidos.numeroEmbarque = ItensPedido.numeroEmbarque
              AND Pedidos.numeroPedido   = ItensPedido.numeroPedido:

            ASSIGN
               c-nat-operacao = "com cobertura".

            IF Pedidos.condicaoPagamento = "Sem Cobertura Cambial" 
            THEN ASSIGN
               c-nat-operacao = "sem cobertura".

            FOR EACH tt-prog-ponto:
                IF  ENTRY(1,tt-prog-ponto.conteudo) = embarque-imp.cod-estabel
                AND ENTRY(2,tt-prog-ponto.conteudo) = STRING(ITEM.ge-codigo)
                AND ENTRY(3,tt-prog-ponto.conteudo) = c-condpagto

                THEN ASSIGN
                   c-nat-operacao = ENTRY(4,tt-prog-ponto.conteudo).
            END.

            IF c-nat-operacao = ""
            THEN DO:
               RUN piErro ("Embarque " 
                         + ItensPedido.numeroEmbarque 
                         + ", Pedido "
                         + ItensPedido.numeroPedido  
                         + ", Codigo "
                         + ItensPedido.codigo
                         + " sem natureza de operacao.","").
               STOP.
            END.

            EMPTY TEMP-TABLE tt-ordens-desemb.
            EMPTY TEMP-TABLE tt-alt-ordens-desemb.

            RUN setConstraint2  IN {&hDBOSon1}  (INPUT embarque-imp.cod-estabel,
                                                 INPUT embarque-imp.embarque).
            RUN openQuery       IN {&hDBOSon1}  (INPUT 2) NO-ERROR.
            RUN findFirst       IN {&hDBOSon1}. 
            RUN serverSendRows  IN {&hDBOSon1}  (INPUT  ?,                      
                                                 INPUT  ?,                     
                                                 INPUT  NO,                      
                                                 INPUT  0,     
                                                 OUTPUT iNrRegistro,
                                                 OUTPUT TABLE {&ttSon1}).
   
            RUN loadOrdensDesemb IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque,
                                                 INPUT c-nat-operacao, //"310100", //p-nat-operacao,
                                                 INPUT "comex",  //"ma053972", //p-usuario,
                                                 INPUT no,       //p-recarrega,
                                                 INPUT no,       //p-icms-diferido,
                                                 INPUT no,       //(i-peso = 2),
                                                 INPUT no,       //p-recarrega, /* II   */
                                                 INPUT no,       //p-recarrega, /* ipi  */
                                                 INPUT no,       //p-recarrega, /* icms */
                                                 INPUT no,       //p-recarrega, /* pis  */
                                                 INPUT no,       //p-recarrega, /* cof  */
                                                 INPUT no,       //p-peso-bruto,
                                                 INPUT no,       //p-peso-liquid,
                                                 INPUT no,       //p-cubagem,
                                                 OUTPUT TABLE tt-ordens-desemb,
                                                 OUTPUT TABLE tt-bo-erro).

            IF TEMP-TABLE tt-bo-erro:HAS-RECORDS
            THEN DO:
               FOR EACH tt-bo-erro:
                  RUN piErro (tt-bo-erro.mensagem,
                              tt-bo-erro.errorhelp
                      + " ("
                      + STRING(tt-bo-erro.cd-erro)
                      + ")"  ).
               END.
               STOP.
            END.
            
            FOR EACH tt-ordens-desemb
               WHERE tt-ordens-desemb.c-it-codigo   = ItensPedido.codigo
                 AND tt-ordens-desemb.de-quantidade = ItensPedido.quantidade,
               FIRST ordem-compra NO-LOCK
               WHERE ordem-compra.numero-ordem = tt-ordens-desemb.numero-ordem
                 AND ordem-compra.num-pedido   = INT(Pedidos.NumeroPedido):
               ASSIGN
                  tt-ordens-desemb.peso-liquido    = ItensPedido.pesoLiquido    
                  tt-ordens-desemb.peso-bruto      = ItensPedido.pesoLiquido + 1      
               
                  tt-ordens-desemb.de-peso-liquido = ItensPedido.pesoLiquido    
                  tt-ordens-desemb.de-peso-bruto   = ItensPedido.pesoLiquido + 1      
                  tt-ordens-desemb.cdn-adicao      = ItensPedido.numeroAdicao   
                  tt-ordens-desemb.seq-item        = ItensPedido.sequenciaAdicao
                  tt-ordens-desemb.de-aliq-ii      = ItensPedido.aliquotaII     
                  tt-ordens-desemb.de-aliq-ipi     = ItensPedido.aliquotaIPI    
                  tt-ordens-desemb.de-aliq-icms    = ItensPedido.aliquotaICMS   
                  tt-ordens-desemb.de-aliq-pis     = ItensPedido.aliquotaPIS    
                  tt-ordens-desemb.de-aliq-cofins  = ItensPedido.aliquotaCOFINS 
               
                  ItensPedido.proc                 = YES.

               MESSAGE ">> ALT Pedidos.numeroEmbarque           " Pedidos.numeroEmbarque          .
               MESSAGE ">> ALT Pedidos.numeroPedido             " Pedidos.numeroPedido            .
               MESSAGE ">> ALT tt-ordens-desemb.numero-ordem    " tt-ordens-desemb.numero-ordem   .
               MESSAGE ">> ALT ItensPedido.codigo               " ItensPedido.codigo              .
               MESSAGE ">> ALT c-nat-operacao                   " c-nat-operacao                  .
               MESSAGE ">> ALT tt-ordens-desemb.de-peso-liquido " tt-ordens-desemb.de-peso-liquido.
               MESSAGE ">> ALT tt-ordens-desemb.de-peso-bruto   " tt-ordens-desemb.de-peso-bruto  .
               MESSAGE ">> ALT tt-ordens-desemb.cdn-adicao      " tt-ordens-desemb.cdn-adicao     .
               MESSAGE ">> ALT tt-ordens-desemb.seq-item        " tt-ordens-desemb.seq-item       .
               MESSAGE ">> ALT tt-ordens-desemb.de-aliq-ii      " tt-ordens-desemb.de-aliq-ii     .
               MESSAGE ">> ALT tt-ordens-desemb.de-aliq-ipi     " tt-ordens-desemb.de-aliq-ipi    .
               MESSAGE ">> ALT tt-ordens-desemb.de-aliq-icms    " tt-ordens-desemb.de-aliq-icms   .
               MESSAGE ">> ALT tt-ordens-desemb.de-aliq-pis     " tt-ordens-desemb.de-aliq-pis    .
               MESSAGE ">> ALT tt-ordens-desemb.de-aliq-cofins  " tt-ordens-desemb.de-aliq-cofins .
               
               CREATE tt-alt-ordens-desemb.
               ASSIGN
                  tt-alt-ordens-desemb.rw-registro = ROWID(tt-ordens-desemb).

            END.

            FOR EACH tt-ordens-desemb:
               FIND FIRST tt-alt-ordens-desemb
                    WHERE tt-alt-ordens-desemb.rw-registro = ROWID(tt-ordens-desemb)
                    NO-ERROR.

               /*
               DISP
                   c-it-codigo 
                   c-desc-item 
                   AVAIL tt-alt-ordens-desemb
                   WITH STREAM-IO SCROLLABLE.
               */

               IF NOT AVAIL tt-alt-ordens-desemb
               THEN DELETE tt-ordens-desemb.
            END.
         
            RUN updateOrdensEmbarque IN h-bocx225e (INPUT  TABLE tt-ordens-desemb,
                                                    INPUT  2, //i-peso,
                                                    INPUT  2, //i-cubagem,
                                                    INPUT  "comex",
                                                    OUTPUT TABLE tt-bo-erro).
            IF TEMP-TABLE tt-bo-erro:HAS-RECORDS
            THEN DO:
               FOR EACH tt-bo-erro:
                  RUN piErro (tt-bo-erro.mensagem,
                              tt-bo-erro.errorhelp
                            + " ("
                            + STRING(tt-bo-erro.cd-erro)
                            + ")"  ).
               END.
               STOP.
            END.

            FOR EACH tt-ordens-desemb,
               FIRST ordens-embarque EXCLUSIVE-LOCK 
               WHERE ordens-embarque.cod-estabel   = tt-ordens-desemb.cod-estabel 
                 AND ordens-embarque.embarque      = tt-ordens-desemb.embarque    
                 AND ordens-embarque.numero-ordem  = tt-ordens-desemb.numero-ordem
                 AND ordens-embarque.parcela       = tt-ordens-desemb.parcela     
                 :
               ASSIGN 
                  ordens-embarque.peso-bruto    = tt-ordens-desemb.de-peso-bruto   
                  ordens-embarque.peso-liquido  = tt-ordens-desemb.de-peso-liquido 
                  .
            END.
         END.

         FOR EACH Pedidos 
            WHERE Pedidos.numeroEmbarque = declaracao.numeroEmbarque:
            ASSIGN
               deValorDesp = deValorDesp
                           + Pedidos.acrescimoPedido.
            
         END.
         IF deValorDesp > 0
         THEN RUN piGeraDespesa.
      END.
         
      IF CAN-FIND(FIRST ItensPedido
                  WHERE ItensPedido.proc = NO) 
      THEN DO:
         FOR EACH ItensPedido
            WHERE ItensPedido.proc = NO:
            RUN piErro ("Embarque " 
                      + ItensPedido.numeroEmbarque 
                      + ", Pedido "
                      + ItensPedido.numeroPedido  
                      + ", Codigo "
                      + ItensPedido.codigo
                      + " nao pode ser processado.","").
         END.
         STOP.
      END.
   END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

