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

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
    FIELD r-rowid AS ROWID.
DEF VAR h-bocx230a   AS HANDLE      NO-UNDO.

DEF VAR httCust      AS HANDLE      NO-UNDO.
DEF VAR lReturnValue AS LOGICAL     NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi554 AS l NO-UNDO.

DEF VAR cJson        AS c        NO-UNDO.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi554 = NO.
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


    PUT UNFORMATTED
       STRING(lcInput) SKIP(5).

    ASSIGN 
       jsonParser = NEW ObjectModelParser()
       jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Ponto de Controle").

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

&IF DEFINED(EXCLUDE-piProcessa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessa Procedure 
PROCEDURE piProcessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR jsonObjectPayload   AS JsonObject                NO-UNDO.
   DEF VAR jItinerario         AS JsonArray                 NO-UNDO. 
      
   DEF VAR lErr                AS l                         NO-UNDO.
       
   DEF VAR lRetOK              AS l                         NO-UNDO.
   DEF VAR httpInput           AS HANDLE                    NO-UNDO.
   DEF VAR hQuery              AS HANDLE                    NO-UNDO.
   DEF VAR hBuffer             AS HANDLE                    NO-UNDO.
   DEF VAR iNumFields          AS i                         NO-UNDO.
   DEF VAR iLoop               AS i                         NO-UNDO.
   
   DEF VAR cNumeroEmbarque     AS c                         NO-UNDO.
   DEF VAR cNomePontoControle  AS c                         NO-UNDO.
   DEF VAR cDataUltimaPrevisao AS c                         NO-UNDO.
   DEF VAR cDataEfetiva        AS c                         NO-UNDO.
   DEF VAR cVeiculoTransporte  AS c                         NO-UNDO.
   
   DEF VAR i-cod-pto-contr     LIKE pto-contr.cod-pto-contr NO-UNDO.


   ASSIGN 
      jsonObjectPayload = jsonInput:GetJsonObject("payload")
      jItinerario       = jsonObjectPayload:GetJsonArray("Itinerario") 
      NO-ERROR.
   IF ERROR-STATUS:ERROR = YES 
   THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).

          RUN piErro (STRING(ERROR-STATUS:ERROR)
                    + " - "      
                    + ERROR-STATUS:GET-MESSAGE(i),
                      "").
      END.
      STOP.
   END.

   CREATE TEMP-TABLE httpInput.

   lRetOK = httpInput:READ-JSON("JsonArray", jItinerario, "empty") NO-ERROR.

   IF ERROR-STATUS:ERROR = YES 
   THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
         MESSAGE 
            "** Erro " 
            ERROR-STATUS:ERROR 
            " - "      
            ERROR-STATUS:GET-MESSAGE(i).

          RUN piErro (STRING(ERROR-STATUS:ERROR)
                    + " - "      
                    + ERROR-STATUS:GET-MESSAGE(i),
                      "").
      END.
      STOP.
   END.

   ASSIGN 
      hBuffer    = httpInput:DEFAULT-BUFFER-HANDLE
      iNumFields = hBuffer:NUM-FIELDS.

   CREATE QUERY hQuery.

   hQuery:SET-BUFFERS(httpInput:DEFAULT-BUFFER-HANDLE).
   hQuery:QUERY-PREPARE("FOR EACH " + httpInput:NAME).
   hQuery:QUERY-OPEN().
   hQuery:GET-FIRST().

   DO WHILE hQuery:QUERY-OFF-END = FALSE:

      ASSIGN
         cNumeroEmbarque     = ""
         cNomePontoControle  = ""
         cDataUltimaPrevisao = ""
         cDataEfetiva        = ""
         cVeiculoTransporte  = ""

         i-cod-pto-contr     = 0.

      REPEAT iLoop = 1 TO iNumFields:
         
         IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NumeroEmbarque"
         THEN ASSIGN
            cNumeroEmbarque     = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NomePontoControle"
         THEN ASSIGN
            cNomePontoControle  = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         IF hBuffer:BUFFER-FIELD(iLoop):NAME = "DataUltimaPrevisao"
         THEN ASSIGN
            cDataUltimaPrevisao = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         IF hBuffer:BUFFER-FIELD(iLoop):NAME = "DataEfetiva"
         THEN ASSIGN
            cDataEfetiva        = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         IF hBuffer:BUFFER-FIELD(iLoop):NAME = "VeiculoTransporte"
         THEN ASSIGN
            cVeiculoTransporte  = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.

      END.

      /*
      MESSAGE 

          "cNumeroEmbarque    " cNumeroEmbarque     SKIP
          "cNomePontoControle " cNomePontoControle  SKIP
          "cDataUltimaPrevisao" cDataUltimaPrevisao SKIP
          "cDataEfetiva       " cDataEfetiva        SKIP
          "cVeiculoTransporte " cVeiculoTransporte  SKIP

          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      */
      FIND FIRST embarque-imp NO-LOCK
           WHERE embarque-imp.embarque = cNumeroEmbarque
           NO-ERROR.
      IF NOT AVAIL embarque-imp
      THEN RUN piErro ("Embarque " + cNumeroEmbarque + " nao foi encontrado.","").
      ELSE DO:
         FIND FIRST ext-embarque-imp NO-LOCK
                 OF embarque-imp
              NO-ERROR.
         IF cNomePontoControle = "Entrega Invoice"
         THEN ASSIGN
            i-cod-pto-contr    = INT(SUBSTR(embarque-imp.char-1,81,5)).
         IF cNomePontoControle = "Instru‡Æo Embarque"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-instrucao.
         IF cNomePontoControle = "Coleta/Entrega Agente"
         THEN ASSIGN
            i-cod-pto-contr    = embarque-imp.cdn-pto-despch. //Entrega Agente
         IF cNomePontoControle = "Ponto de embarque 1"
         THEN ASSIGN
            i-cod-pto-contr    =  embarque-imp.cdn-pto-embarq. //embarque-imp.cdn-pto-embarq.
         IF cNomePontoControle = "Ponto de embarque 2"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-embarque2.
         IF cNomePontoControle = "Ponto de Chegada 1"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-chegada1.

         /*
         MESSAGE 
             "ext-embarque-imp.cdn-pto-embarque " ext-embarque-imp.cdn-pto-embarque  SKIP
             "ext-embarque-imp.cdn-pto-chegada1 " ext-embarque-imp.cdn-pto-chegada1  SKIP
             "ext-embarque-imp.cdn-pto-liberacao" ext-embarque-imp.cdn-pto-liberacao SKIP
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
         */
         
         IF cNomePontoControle = "Ponto de Chegada 2"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-chegada2.
         IF cNomePontoControle = "Ponto Nacionalizacao"
         THEN ASSIGN
            i-cod-pto-contr    = embarque-imp.cdn-pto-desembar.
         IF cNomePontoControle = "Liberacao"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-liberacao.
         IF cNomePontoControle = "Entrada Intelbras"
         THEN ASSIGN
            i-cod-pto-contr    = embarque-imp.cdn-pto-chegad.

         IF cNomePontoControle = "EmissÆo da NF"
         THEN ASSIGN
            i-cod-pto-contr    = ext-embarque-imp.cdn-pto-emissao-nf.

         IF i-cod-pto-contr = 0
         THEN RUN piErro ("Ponto de Controle nao foi encontrado: " + cNomePontoControle,"").
         ELSE DO:
            MESSAGE ">> 1 " i-cod-pto-contr.

            RUN cxbo/bocx230a.p  PERSISTENT SET h-bocx230a.
            RUN openQuery IN h-bocx230a (INPUT 1).


            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                   AND historico-embarque.embarque      = embarque-imp.embarque
                   AND historico-embarque.cod-pto-contr = i-cod-pto-contr
                 NO-ERROR.
            MESSAGE ">> 2 " AVAIL historico-embarque.
            IF AVAIL historico-embarque
            THEN DO:
               CREATE tt-historico-embarque.
               BUFFER-COPY historico-embarque TO tt-historico-embarque.
               ASSIGN
                  tt-historico-embarque.r-rowid         = ROWID(historico-embarque).

               MESSAGE ">> 2.1 " STRING(ROWID(historico-embarque)).
               IF cDataUltimaPrevisao <> ""
               THEN ASSIGN
                  cDataUltimaPrevisao                   = REPLACE(cDataUltimaPrevisao," ","-")
                  tt-historico-embarque.dt-ult-previsao = DATE(INT(ENTRY(2,cDataUltimaPrevisao,"-")),
                                                               INT(ENTRY(3,cDataUltimaPrevisao,"-")),
                                                               INT(ENTRY(1,cDataUltimaPrevisao,"-"))
                                                               ).
               IF cDataEfetiva <> "" 
               THEN ASSIGN
                  cDataEfetiva                          = REPLACE(cDataEfetiva," ","-")
                  tt-historico-embarque.dt-efetiva      = DATE(INT(ENTRY(2,cDataEfetiva,"-")),
                                                               INT(ENTRY(3,cDataEfetiva,"-")),
                                                               INT(ENTRY(1,cDataEfetiva,"-"))
                                                               ).
               MESSAGE ">> 2.2 " STRING(ROWID(historico-embarque)).
               ASSIGN
                  tt-historico-embarque.id-meio-transp  = IF cVeiculoTransporte = ? THEN "" ELSE cVeiculoTransporte.

               MESSAGE ">> 3 historico-embarque.dt-ult-previsao " tt-historico-embarque.dt-ult-previsao.
               MESSAGE ">> 4 historico-embarque.dt-efetiva "      tt-historico-embarque.dt-efetiva .
               MESSAGE ">> 5 historico-embarque.id-meio-transp "  tt-historico-embarque.id-meio-transp.

               MESSAGE ">> 6 cDataUltimaPrevisao"  cDataUltimaPrevisao.
               MESSAGE ">> 7 cDataEfetiva       "  cDataEfetiva       .
               MESSAGE ">> 8 cVeiculoTransporte "  cVeiculoTransporte .


               FIND FIRST ext-embarque-imp NO-LOCK
                    WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                      AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
               IF AVAIL ext-embarque-imp AND ext-embarque-imp.log-envio-comex = YES THEN 
                  RUN setRecalcula   IN h-bocx230a (INPUT NO).
               ELSE
                  RUN setRecalcula   IN h-bocx230a (INPUT tt-historico-embarque.log-1).

               RUN validateUpdate IN h-bocx230a (INPUT  TABLE tt-historico-embarque,
                                                 INPUT  ROWID(historico-embarque),
                                                 OUTPUT TABLE RowErrors). 

               FOR EACH RowErrors NO-LOCK:  
                  MESSAGE  "** ERR " RowErrors.ErrorNumber RowErrors.ErrorDescription  RowErrors.ErrorHelp.
               END.

            END.

            IF TEMP-TABLE RowErrors:HAS-RECORDS = NO THEN DO:
               FIND FIRST historico-embarque EXCLUSIVE-LOCK
                    WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                      AND historico-embarque.embarque      = embarque-imp.embarque
                      AND historico-embarque.cod-pto-contr = i-cod-pto-contr NO-ERROR.
               IF AVAIL historico-embarque THEN
                  ASSIGN historico-embarque.dt-ult-previsao = tt-historico-embarque.dt-ult-previsao.

               RELEASE historico-embarque.
    
            END.

         END.
      END.

      hQuery:GET-NEXT().
   END.

   hQuery:QUERY-CLOSE().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

