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

DEF INPUT PARAM h-acomp     AS HANDLE  NO-UNDO.    
DEF INPUT PARAM i-acao      AS i       NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID   NO-UNDO.
                                       

DEF NEW GLOBAL SHARED VAR l-esapi565 AS l NO-UNDO.

DEF VAR cJson                AS c      NO-UNDO.

DEF VAR httCust              AS HANDLE NO-UNDO.
DEF VAR lReturnValue         AS l      NO-UNDO.

DEF VAR c-pto-base           AS c      NO-UNDO.


DEF TEMP-TABLE auxRowErrors NO-UNDO
    LIKE RowErrors.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi565 = NO.
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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-data Procedure 
FUNCTION fc-data RETURNS DATE
  ( c AS CHARACTER )  FORWARD.

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


/* ***************************  Main Block  *************************** */

DEF VAR lcInput    AS LONGCHAR          NO-UNDO.

DEF VAR jsonParser AS ObjectModelParser NO-UNDO.
DEF VAR jsonInput  AS JsonObject        NO-UNDO.

MESSAGE ">> esapi565".

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

    PUT ">> " STRING(lcInput) SKIP.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-pto-base) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pto-base Procedure 
PROCEDURE pi-pto-base :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN esp/es0018p.p (INPUT "cd2566":U,
                      INPUT 1,
                      INPUT 0,
                      INPUT "":U,
                      OUTPUT TABLE tt-prog-ponto).
   ASSIGN
      c-pto-base = "".

   FOR EACH tt-prog-ponto:
       IF c-pto-base = ""
       THEN ASSIGN
          c-pto-base = tt-prog-ponto.conteudo.
       ELSE ASSIGN
          c-pto-base = c-pto-base
                     + ","
                     + tt-prog-ponto.conteudo.
   END.
END PROCEDURE.

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
   DEF VAR jsonObjectPayload       AS JsonObject          NO-UNDO.
   DEF VAR jsonArrayPathParams     AS JsonArray           NO-UNDO.
                                                          
   DEF VAR lErr                    AS l                   NO-UNDO.
                                                          
   DEF VAR lRetOK                  AS l                   NO-UNDO.
   DEF VAR httpInput               AS HANDLE              NO-UNDO.
   DEF VAR hQuery                  AS HANDLE              NO-UNDO.
   DEF VAR hBuffer                 AS HANDLE              NO-UNDO.
   DEF VAR iNumFields              AS i                   NO-UNDO.
                                                          
   DEF VAR iLoop                   AS i                   NO-UNDO.
                                   
   DEF VAR i-pto-base              AS i                   NO-UNDO.
   DEF VAR i-cod-pto-contr         AS i                   NO-UNDO.
                                   
   DEF VAR cNumeroEmbarque         AS c                   NO-UNDO.
   DEF VAR icodigoAgenteCargas     AS i                   NO-UNDO.
   DEF VAR cdescricaoMaster        AS c                   NO-UNDO.
   DEF VAR cdescricaoHouse         AS c                   NO-UNDO.
   DEF VAR veiculoTransporte       AS c                   NO-UNDO.

   DEF VAR cdataPrevisaoEntrada    AS c                   NO-UNDO.
   DEF VAR cdataEfetivaColeta      AS c                   NO-UNDO.

   DEF VAR dadataPrevisaoEntrada   AS da                  NO-UNDO.
   DEF VAR dadataEfetivaColeta     AS da                  NO-UNDO.

   DEF VAR l-efetiva               AS l                   NO-UNDO.
                                                       
   ASSIGN 
      jsonObjectPayload = jsonInput:GetJsonObject("payload").

   RUN pi-pto-base.

   blk: DO ON STOP UNDO, LEAVE TRANSACTION:
      CREATE TEMP-TABLE httpInput.

      lRetOK = httpInput:READ-JSON("JsonObject", jsonObjectPayload, "empty").

      ASSIGN 
         hBuffer    = httpInput:DEFAULT-BUFFER-HANDLE
         iNumFields = hBuffer:NUM-FIELDS.

      CREATE QUERY hQuery.

      hQuery:SET-BUFFERS(httpInput:DEFAULT-BUFFER-HANDLE).
      hQuery:QUERY-PREPARE("FOR EACH " + httpInput:NAME).

      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().
      
      MESSAGE ">> " httpInput:NAME.

      DO WHILE hQuery:QUERY-OFF-END = FALSE:

         ASSIGN
            i-pto-base                 = 0
            i-cod-pto-contr            = 0
                                       
            cNumeroEmbarque            = ""
            icodigoAgenteCargas        = 0
            cdescricaoMaster           = ""
            veiculoTransporte          = ""
                                
            cdataPrevisaoEntrada       = ""
            cdataEfetivaColeta         = ""
                                
            dadataPrevisaoEntrada      = ?
            dadataEfetivaColeta        = ?
            .

         REPEAT iLoop = 1 TO iNumFields:
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NumeroEmbarque"
            THEN ASSIGN
               cNumeroEmbarque     = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "codigoAgenteCargas"
            THEN ASSIGN
               icodigoAgenteCargas = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "descricaoMaster"
            THEN ASSIGN
               cdescricaoMaster                 = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "descricaoHouse"
            THEN ASSIGN
               cdescricaoHouse                  = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "Navio"
            THEN ASSIGN
               veiculoTransporte                = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "dataPrevisaoEntrada"
            THEN ASSIGN
               cdataPrevisaoEntrada             = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "dataEfetivaColeta"
            THEN ASSIGN
               cdataEfetivaColeta               = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         END.

         ASSIGN
            dadataPrevisaoEntrada = fc-data(cdataPrevisaoEntrada) 
            dadataEfetivaColeta   = fc-data(cdataEfetivaColeta  ) 
            .

         MESSAGE ">> cNumeroEmbarque      " cNumeroEmbarque.
         MESSAGE ">> icodigoAgenteCargas  " icodigoAgenteCargas.
         MESSAGE ">> cdescricaoMaster     " cdescricaoMaster.
         MESSAGE ">> veiculoTransporte    " veiculoTransporte.
                                                        
         MESSAGE ">> cdataPrevisaoEntrada " cdataPrevisaoEntrada.
         MESSAGE ">> cdataEfetivaColeta   " cdataEfetivaColeta.
                                                        
         MESSAGE ">> dadataPrevisaoEntrada" dadataPrevisaoEntrada.
         MESSAGE ">> dadataEfetivaColeta  " dadataEfetivaColeta.

         FIND FIRST embarque-imp EXCLUSIVE-LOCK
              WHERE embarque-imp.embarque = cNumeroEmbarque 
              NO-ERROR.
         IF NOT AVAIL embarque-imp
         THEN DO:
            RUN piErro ("Embarque " + cNumeroEmbarque + " nao encontrada.","").
            STOP.
         END.

         FIND FIRST transporte NO-LOCK
              WHERE transporte.cod-transp = icodigoAgenteCargas
              NO-ERROR.
         IF NOT AVAIL transporte
         THEN DO:
            RUN piErro ("Agente " + STRING(icodigoAgenteCargas) + " nao encontrado.","").
            STOP.
         END.

         FOR EACH historico-embarque EXCLUSIVE-LOCK
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque:
            FIND FIRST int-pto-contr NO-LOCK
                 WHERE int-pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
                 NO-ERROR.
            IF AVAIL int-pto-contr 
            THEN DO:
               ASSIGN
                  i-pto-base = LOOKUP("Entrada Intelbras",c-pto-base).
               IF i-pto-base = LOOKUP(int-pto-contr.nome-comex,c-pto-base)
               THEN DO:
                  ASSIGN
                     i-cod-pto-contr                    = historico-embarque.cod-pto-contr
                     historico-embarque.dt-ult-previsao = dadataPrevisaoEntrada.
                  LEAVE.
               END.
            END.
         END.
         
         IF i-cod-pto-contr = 0
         THEN DO:
            RUN piErro ("Ponto de Controle Entrada Intelbras nao encontrado no embarque " + cNumeroEmbarque + ".","").
            STOP.
         END.

         FOR EACH historico-embarque 
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
              AND historico-embarque.embarque    = embarque-imp.embarque
            BREAK BY historico-embarque.cod-estabel
                  BY historico-embarque.embarque   
                  BY historico-embarque.sequencia:
            IF historico-embarque.dt-efetiva <> ? 
            THEN ASSIGN
               l-efetiva = YES.
            IF  l-efetiva = YES 
            AND historico-embarque.dt-efetiva = ?
            THEN ASSIGN
               historico-embarque.id-meio-transp = veiculoTransporte.
         END.

         ASSIGN
            embarque-imp.cod-conhecto-Master = cdescricaoMaster
            embarque-imp.cod-conhecto-House  = cdescricaoHouse
            embarque-imp.cod-transp          = icodigoAgenteCargas.
             
         hQuery:GET-NEXT().
      END.
   END.

END PROCEDURE.


/*
    {
      "numeroEmbarque": "478946f",
      "codigoAgenteCargas": 123,
      "descricaoMaster": "344214312",
      "descricaoHouse": "1231231"
      "Navio": "Navio",
      "dataPrevisaoEntrada": ,
      "dataEfetivaColeta": 
    }
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-data Procedure 
FUNCTION fc-data RETURNS DATE
  ( c AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR d AS da NO-UNDO.

  IF c > ""
  THEN ASSIGN
      d = DATE(INT(SUBSTR(c,6,2)),
               INT(SUBSTR(c,9,2)),
               INT(SUBSTR(c,1,4))
              ).

  RETURN d.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

