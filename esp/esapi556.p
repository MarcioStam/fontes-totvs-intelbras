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



DEF NEW GLOBAL SHARED VAR l-esapi556 AS l NO-UNDO.

DEF VAR cJson                AS c           NO-UNDO.

DEF VAR httCust              AS HANDLE      NO-UNDO.
DEF VAR lReturnValue         AS LOGICAL     NO-UNDO.
DEF VAR cMetodo              AS c           NO-UNDO.

DEF VAR cNumeroEmbarque      AS c           NO-UNDO.
DEF VAR cNome                AS c           NO-UNDO.
DEF VAR cCodigoFornecedor    AS c           NO-UNDO.
DEF VAR cCondicaoPagamento   AS c           NO-UNDO.
DEF VAR iMoedaJson           AS i           NO-UNDO.
DEF VAR cValor               AS c           NO-UNDO.
DEF VAR i-mo-codigo          AS i           NO-UNDO.

DEF VAR i-cod-emitente       AS i           NO-UNDO.

DEF VAR c-pto-base           AS c           NO-UNDO.
DEF VAR i-pto-base           AS i           NO-UNDO.
DEF VAR i-cod-pto-contr      AS i           NO-UNDO.

DEF VAR h-bocx310            AS HANDLE      NO-UNDO.

DEF TEMP-TABLE auxRowErrors NO-UNDO
    LIKE RowErrors.

DEF TEMP-TABLE tt-desp-embarque NO-UNDO 
    LIKE desp-embarque
   FIELD r-rowid AS ROWID.


{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi556 = NO.
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

/*
    {
      "numeroEmbarque": "478946f",
      "nome": "Taxa siscomex",
      "codigoFornecedor": "344214312",
      "condicaoPagamento": "AtÇ 180 dias",
      "moeda": 220,
      "valor": "1.582,66"
    }
*/

/*

&scoped-define TABLE-NAME desp-embarque

DEFINE TEMP-TABLE RowObject NO-UNDO like desp-embarque
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-desp-embarque-old NO-UNDO like desp-embarque
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-desp-embarque-aux NO-UNDO like desp-embarque
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-bo-erro no-undo
                      field i-sequen as int
                      field cd-erro  as int
                      field mensagem as char format "x(255)"
                      field parametros as char format "x(255)" init ""
                      field errortype as char format "x(20)"
                      field errorhelp as char format "x(20)"
                      field errorsubtype as character.

DEF VAR i-pais-impto-usuario AS i NO-UNDO.
DEF VAR h-cdapi050 AS HANDLE NO-UNDO.
DEF VAR i-seq-erro AS i NO-UNDO.
DEF VAR l-query AS l NO-UNDO.

PROCEDURE validateDelete:

    MESSAGE 1.

    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.
 
    DEFINE VARIABLE h-bocx00451      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-possui-antecip AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-lb-forn-desp   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-del-desp    AS CHARACTER   NO-UNDO.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    MESSAGE 2.

//    RUN InitializeValidate.


    &IF DEFINED(LOCKCONTROL) > 0 &THEN
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
    &ELSE
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    &ENDIF    
MESSAGE 3.

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr"
                               AND funcao.ativo = YES) THEN DO:
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                 IF {&TABLE-NAME}.log-forma-preco-compra THEN DO:
            &ELSE
                 IF SUBSTRING({&TABLE-NAME}.char-1,4,1) = "1" THEN DO:
            &ENDIF
                    RUN RateioFormaPrecoCompra (INPUT TABLE RowObject,
                                                OUTPUT TABLE tt-desp-rateio-aux,
                                                OUTPUT TABLE tt-bo-erro).
                    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-bo-erro THEN DO:
                        RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                      INPUT TABLE tt-desp-rateio-aux,
                                                      INPUT "DEL":U,
                                                      OUTPUT TABLE tt-bo-erro).
                    END.
                    IF CAN-FIND(FIRST tt-bo-erro) THEN
                        UNDO, RETURN "NOK":U.
                 END.
          &ENDIF
    END.
    MESSAGE 4 AVAIL rowObject.
        
    IF AVAIL {&TABLE-NAME} THEN DO:
        /*** Siscoserv ***/
        IF NOT VALID-HANDLE(h-cdapi050) THEN
            RUN cdp/cdapi050 PERSISTENT SET h-cdapi050.
        MESSAGE 5.

        RUN pi-siscoserv-ativo IN h-cdapi050.
        MESSAGE 6 RETURN-VALUE.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN pi-apaga-despes-import-sis IN h-cdapi050 (INPUT rowObject.cod-estabel,      
                                                          INPUT rowObject.embarque,         
                                                          INPUT rowObject.cod-itiner,       
                                                          INPUT rowObject.cod-pto-contr,    
                                                          INPUT rowObject.cod-desp,         
                                                          INPUT rowObject.cod-emitente-desp).
        END.
        IF VALID-HANDLE(h-cdapi050) THEN DO:
            DELETE PROCEDURE h-cdapi050.
            ASSIGN h-cdapi050 = ?.
        END.
        /*** Siscoserv ***/

        
        /*** IFRIC ***/
        IF CAN-FIND(FIRST funcao 
                    WHERE funcao.cd-funcao = "spp-ifric22":U 
                      AND funcao.ativo) THEN DO:
                
            RUN cxbo/bocx00451.p PERSISTENT SET h-bocx00451.
    
            RUN piVerificaAntecipFornec IN h-bocx00451(INPUT rowObject.cod-estabel,
                                                       INPUT rowObject.embarque,
                                                       INPUT rowObject.cod-emitente-desp,
                                                       OUTPUT l-possui-antecip).
            DELETE PROCEDURE h-bocx00451.
            ASSIGN h-bocx00451 = ?.

            IF l-possui-antecip THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
    
                 {utp/ut-liter.i "fornecedor_da_despesa"}
                 ASSIGN c-lb-forn-desp = TRIM(RETURN-VALUE).
    
                 {utp/ut-liter.i "eliminar_a_despesa"}
                 ASSIGN c-lb-del-desp = TRIM(RETURN-VALUE).
    
    
                 RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 55823,
                                   INPUT c-lb-forn-desp + "~~":U + c-lb-del-desp).
                 CREATE tt-bo-erro.
                 ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                        tt-bo-erro.cd-erro  = 55823
                        tt-bo-erro.errorsubtype = "ERROR":U
                        tt-bo-erro.mensagem = TRIM(RETURN-VALUE)
                        tt-bo-erro.parametros = c-lb-forn-desp + "~~":U + c-lb-del-desp.
                 UNDO, RETURN "NOK":U.
            END.
        END.
        /*** IFRIC ***/

        if i-pais-impto-usuario = 9 /*Paraguay*/ then do:
            find first despes-embarq-internac
                 where despes-embarq-internac.cod-estabel       = {&TABLE-NAME}.cod-estabel       
                   and despes-embarq-internac.embarque          = {&TABLE-NAME}.embarque          
                   and despes-embarq-internac.cod-itiner        = {&TABLE-NAME}.cod-itiner        
                   and despes-embarq-internac.cod-pto-contr     = {&TABLE-NAME}.cod-pto-contr     
                   and despes-embarq-internac.cod-desp          = {&TABLE-NAME}.cod-desp          
                   and despes-embarq-internac.cod-emitente-desp = {&TABLE-NAME}.cod-emitente-desp exclusive-lock no-error.
            if available despes-embarq-internac then
                delete despes-embarq-internac.
        end.

        RUN executeDelete.

    END.
 
    IF l-query THEN //GET NEXT {&QUERY-NAME} NO-LOCK NO-WAIT
        .
    ELSE FIND NEXT {&TABLE-NAME} NO-LOCK NO-ERROR.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
       IF l-query THEN //GET PREV {&QUERY-NAME} NO-LOCK NO-WAIT
           .
       ELSE FIND PREV {&TABLE-NAME} NO-LOCK NO-ERROR.
    END.
    
    ASSIGN r-chave = ROWID({&TABLE-NAME}).
    
    RETURN "".
END PROCEDURE.

PROCEDURE executeDelete:
END.

*/

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

&IF DEFINED(EXCLUDE-piDeletaDespesa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeletaDespesa Procedure 
PROCEDURE piDeletaDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR r-desp-embarque AS ROWID NO-UNDO.
   FIND FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.embarque = cNumeroEmbarque 
        NO-ERROR.
   IF NOT AVAIL embarque-imp
   THEN DO:
      RUN piErro ("Embarque " + cNumeroEmbarque + " nao encontrada.","").
      STOP.
   END.

   FIND FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = INT(cNome)
        NO-ERROR.

   IF NOT AVAIL desp-imp
   THEN DO:
      RUN piErro ("Despesa " + cNome + " nao encontrada.","").
      STOP.
   END.

   /*
   FIND FIRST int-desp-imp NO-LOCK
        WHERE int-desp-imp.cod-desp = desp-imp.cod-desp
        NO-ERROR.

   IF NOT AVAIL int-desp-imp
   THEN DO:
      RUN piErro ("Extensao Despesa " + cNome + " nao encontrada.","").
      STOP.
   END.

   RUN pi-pto-base.
   ASSIGN
      i-pto-base = 0.

   FOR EACH historico-embarque NO-LOCK
      WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
        AND historico-embarque.embarque      = embarque-imp.embarque:
      FIND FIRST int-pto-contr NO-LOCK
           WHERE int-pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
           NO-ERROR.
      IF AVAIL int-pto-contr 
      THEN DO:
         ASSIGN
            i-pto-base = LOOKUP(int-pto-contr.nome-comex,c-pto-base).
         IF i-pto-base = int-desp-imp.cdn-pto-base
         THEN DO:
            ASSIGN
               i-cod-pto-contr = historico-embarque.cod-pto-contr.
            LEAVE.
         END.
      END.
   END.

   FIND FIRST historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
          AND historico-embarque.embarque      = embarque-imp.embarque
          AND historico-embarque.cod-pto-contr = i-cod-pto-contr
        NO-ERROR.

   IF NOT AVAIL historico-embarque
   THEN DO:
      RUN piErro ("Ponto de Controle " + STRING(int-desp-imp.cdn-pto-base) + " nao encontrado no embarque " + cNumeroEmbarque + ".","").
      STOP.
   END.
   */

   MESSAGE ">> embarque-imp.cod-estabel         " embarque-imp.cod-estabel         .
   MESSAGE ">> embarque-imp.embarque            " embarque-imp.embarque            .
   //MESSAGE ">> historico-embarque.cod-itiner    " historico-embarque.cod-itiner    .
   //MESSAGE ">> historico-embarque.cod-pto-contr " historico-embarque.cod-pto-contr .
   MESSAGE ">> desp-imp.cod-desp                " desp-imp.cod-desp                .
   

   FIND FIRST desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
          AND desp-embarque.embarque          = embarque-imp.embarque
   //       AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
   //       AND desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr //int-desp-imp.cdn-pto-base
          AND desp-embarque.cod-desp          = desp-imp.cod-desp
   //       AND desp-embarque.cod-emitente-desp = emitente.cod-emitente
       NO-ERROR.

   IF NOT AVAIL desp-embarque 
   THEN DO:
      RUN piErro ("Despesa nao encontrada no embarque.","").
      STOP.
   END.

   ASSIGN
      r-desp-embarque = ROWID(desp-embarque).

   PUT ">>> validateDelete 1 " AVAIL desp-embarque STRING(r-desp-embarque).

   /*
   RUN setConstraint2 IN h-bocx310 (desp-embarque.cod-estabel  ,
                                    desp-embarque.embarque     ,
                                    desp-embarque.cod-itiner   ,
                                    desp-embarque.cod-pto-contr
                                    ).

   RUN openQuery      IN h-bocx310 (2).
   */

   RUN findRowid      IN h-bocx310 (r-desp-embarque).

   RUN validateDelete IN h-bocx310 (INPUT-OUTPUT r-desp-embarque,
                                    OUTPUT TABLE auxRowErrors
                                    ).        
   

   PUT ">>> validateDelete 2 " AVAIL desp-embarque STRING(r-desp-embarque).

   IF NOT CAN-FIND(FIRST auxRowErrors) 
   THEN DO:
      FOR EACH auxRowErrors:  
         CREATE RowErrors.
         BUFFER-COPY auxRowErrors TO RowErrors.
         MESSAGE ">>> Elimina Despesa " RowErrors.ErrorDescription.
      END. 
      RETURN "NOK".
   END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraDespesa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraDespesa Procedure 
PROCEDURE piGeraDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND FIRST desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
          AND desp-embarque.embarque          = embarque-imp.embarque
          AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
//          AND desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr //int-desp-imp.cdn-pto-base
          AND desp-embarque.cod-desp          = desp-imp.cod-desp
//          AND desp-embarque.cod-emitente-desp = emitente.cod-emitente
       NO-ERROR.

   /*Criaá∆o*/

   MESSAGE ">> avail desp-embarque " AVAIL desp-embarque.
   IF NOT AVAIL desp-embarque 
   THEN DO:
      IF cMetodo = "PUT" 
      THEN DO:
         RUN piErro ("Despesa nao encontrada.","").
         STOP.
      END.

      CREATE tt-desp-embarque.                        
      ASSIGN tt-desp-embarque.cod-estabel       = embarque-imp.cod-estabel
             tt-desp-embarque.embarque          = embarque-imp.embarque   
             tt-desp-embarque.cod-itiner        = historico-embarque.cod-itiner   
             tt-desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
             tt-desp-embarque.cod-desp          = desp-imp.cod-desp               
             tt-desp-embarque.cod-emitente-desp = emitente.cod-emitente           

             
             tt-desp-embarque.descricao         = desp-imp.descricao
             tt-desp-embarque.cod-cond-pag      = cond-pagto.cod-cond-pag
             tt-desp-embarque.mo-codigo         = i-mo-codigo
             tt-desp-embarque.val-desp          = DEC(cValor)
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
   /*Alteraá∆o*/
   ELSE DO:
      IF cMetodo = "POST" 
      THEN DO:
         RUN piErro ("Despesa ja cadastrada.","").
         STOP.
      END.

      CREATE tt-desp-embarque.
      BUFFER-COPY desp-embarque TO tt-desp-embarque.

      ASSIGN 
         tt-desp-embarque.cod-cond-pag      = cond-pagto.cod-cond-pag
         tt-desp-embarque.mo-codigo         = i-mo-codigo
         tt-desp-embarque.val-desp          = DEC(cValor)
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
pu    codigo                  8         6 + cod-estabel
                                          + embarque
                                          + cod-itiner
                                          + cod-pto-contr
                                          + cod-desp
                                          + cod-emitente-desp
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
   // BOCX310

   DEF VAR jsonObjectPayload    AS JsonObject          NO-UNDO.
   DEF VAR jsonArrayPathParams  AS JsonArray           NO-UNDO.
                                                       
   DEF VAR lErr                 AS l                   NO-UNDO.
                                                       
   DEF VAR lRetOK               AS l                   NO-UNDO.
   DEF VAR httpInput            AS HANDLE              NO-UNDO.
   DEF VAR hQuery               AS HANDLE              NO-UNDO.
   DEF VAR hBuffer              AS HANDLE              NO-UNDO.
   DEF VAR iNumFields           AS i                   NO-UNDO.
                                                       
   DEF VAR iLoop                AS i                   NO-UNDO.
                                                       
   DEF VAR i-cod-desp           LIKE desp-imp.cod-desp NO-UNDO.

   ASSIGN 
      jsonObjectPayload = jsonInput:GetJsonObject("payload").

   ASSIGN
      cMetodo = jsonInput:GetCharacter("method").

   RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

   IF cMetodo = "DELETE" 
   THEN blk: DO ON STOP UNDO, LEAVE TRANSACTION:
      ASSIGN 
         jsonArrayPathParams = jsonInput:GetJsonArray("pathParams")
         cNumeroEmbarque     = jsonArrayPathParams:GetJsonText(1)
         cNome               = jsonArrayPathParams:GetJsonText(2)
         .
      RUN piDeletaDespesa.
   END.
   ELSE blk: DO ON STOP UNDO, LEAVE TRANSACTION:
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

      //MESSAGE 111 hQuery:QUERY-OFF-END VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE l AS l. IF l = YES THEN STOP.
      
      DO WHILE hQuery:QUERY-OFF-END = FALSE:

         //MESSAGE 2 VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE l. IF l = YES THEN STOP.
      
         ASSIGN
            cNumeroEmbarque    = ""
            cNome              = ""
            cCodigoFornecedor  = ""
            cCondicaoPagamento = ""
            iMoedaJson         = 0
            cValor             = ""
            .
         REPEAT iLoop = 1 TO iNumFields:
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "NumeroEmbarque"
            THEN ASSIGN
               cNumeroEmbarque     = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "nome"
            THEN ASSIGN
               cNome               = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "CodigoFornecedor"
            THEN ASSIGN
               cCodigoFornecedor   = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "CondicaoPagamento"
            THEN ASSIGN
               cCondicaoPagamento  = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.

            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "Moeda"
            THEN ASSIGN
               iMoedaJson          = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.

            IF hBuffer:BUFFER-FIELD(iLoop):NAME = "Valor"
            THEN ASSIGN
               cValor             = hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE.
         END.
                 
         MESSAGE ">> cnumeroEmbarque   " cNumeroEmbarque   .
         MESSAGE ">> cnome             " cNome             .
         MESSAGE ">> ccodigoFornecedor " cCodigoFornecedor .
         MESSAGE ">> ccondicaoPagamento" cCondicaoPagamento.
         MESSAGE ">> imoeda            " iMoedaJson        .
         MESSAGE ">> cvalor            " cValor            .

         ASSIGN
            cValor = REPLACE(cValor,".",",").

         FIND FIRST moeda NO-LOCK
              WHERE moeda.cod-decex = iMoedaJson
              NO-ERROR.
         
         IF NOT AVAIL moeda
         THEN DO:
            RUN piErro ("Moeda " + STRING(iMoedaJson) + " nao encontrada.","").
            STOP.
         END.

         FIND FIRST embarque-imp NO-LOCK
              WHERE embarque-imp.embarque = cNumeroEmbarque 
              NO-ERROR.
         IF NOT AVAIL embarque-imp
         THEN DO:
            RUN piErro ("Embarque " + cNumeroEmbarque + " nao encontrada.","").
            STOP.
         END.

         FIND FIRST ext-embarque-imp NO-LOCK
                 OF embarque-imp
              NO-ERROR.
         FIND FIRST desp-imp NO-LOCK
              WHERE desp-imp.cod-desp = INT(cNome)
              NO-ERROR.
        
         IF NOT AVAIL desp-imp
         THEN DO:
            RUN piErro ("Despesa " + cNome + " nao encontrada.","").
            STOP.
         END.

         FIND FIRST int-desp-imp NO-LOCK
              WHERE int-desp-imp.cod-desp = desp-imp.cod-desp
              NO-ERROR.

         IF NOT AVAIL int-desp-imp
         THEN DO:
            RUN piErro ("Extensao Despesa " + cNome + " nao encontrada.","").
            STOP.
         END.


         IF int-desp-imp.cdn-pto-base = 0
         THEN DO:
            RUN piErro ("Ponto de Controle Base n∆o foi encontrado para a Despesa " + cNome,"").
            STOP.
         END.

         ASSIGN
            i-cod-emitente = INT(cCodigoFornecedor).

         FIND FIRST es-agente NO-LOCK
              WHERE es-agente.cod-agente = INT(cCodigoFornecedor)
              NO-ERROR.
         IF AVAIL es-agente 
         THEN ASSIGN
            i-cod-emitente = es-agente.cod-fornecedor.

         FIND FIRST emitente NO-LOCK
              WHERE emitente.cod-emitente = i-cod-emitente
              NO-ERROR.
         IF NOT AVAIL emitente
         THEN DO:
            RUN piErro ("Fornecedor " + STRING(i-cod-emitente) + " nao encontrada.","").
            STOP.
         END.

         FIND FIRST cond-pagto NO-LOCK
              WHERE cond-pagto.cod-cond-pag = INT(cCondicaoPagamento)
              NO-ERROR.

         IF NOT AVAIL cond-pagto
         THEN DO:
            RUN piErro ("Condicao de Pagamento " + cCondicaoPagamento + " nao encontrada.","").
            STOP.
         END.

         RUN pi-pto-base.
         ASSIGN
            i-pto-base = 0.

         FOR EACH historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque:
            FIND FIRST int-pto-contr NO-LOCK
                 WHERE int-pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
                 NO-ERROR.
            IF AVAIL int-pto-contr 
            THEN DO:
               ASSIGN
                  i-pto-base = LOOKUP(int-pto-contr.nome-comex,c-pto-base).
               IF i-pto-base = int-desp-imp.cdn-pto-base
               THEN DO:
                  ASSIGN
                     i-cod-pto-contr = historico-embarque.cod-pto-contr.
                  LEAVE.
               END.
            END.
         END.

         IF i-cod-pto-contr = 0
         THEN DO:
            IF ENTRY(int-desp-imp.cdn-pto-base,c-pto-base) = "Ponto de Chegada 2" 
            THEN DO:
               FOR EACH historico-embarque NO-LOCK
                  WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                    AND historico-embarque.embarque      = embarque-imp.embarque:
                  FIND FIRST int-pto-contr NO-LOCK
                       WHERE int-pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
                       NO-ERROR.
                  IF AVAIL int-pto-contr 
                  THEN DO:
                     ASSIGN
                        i-pto-base = LOOKUP("Ponto de Chegada 1",c-pto-base).
                     IF i-pto-base = LOOKUP(int-pto-contr.nome-comex,c-pto-base)
                     THEN DO:
                        ASSIGN
                           i-cod-pto-contr = historico-embarque.cod-pto-contr.
                        LEAVE.
                     END.
                  END.
               END.
            END.
            IF ENTRY(int-desp-imp.cdn-pto-base,c-pto-base) = "Ponto de embarque 2"
            THEN DO:
               FOR EACH historico-embarque NO-LOCK
                  WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                    AND historico-embarque.embarque      = embarque-imp.embarque:
                  FIND FIRST int-pto-contr NO-LOCK
                       WHERE int-pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
                       NO-ERROR.
                  IF AVAIL int-pto-contr 
                  THEN DO:
                     ASSIGN
                        i-pto-base = LOOKUP("Ponto de embarque 1",c-pto-base).
                     IF i-pto-base = LOOKUP(int-pto-contr.nome-comex,c-pto-base)
                     THEN DO:
                        ASSIGN
                           i-cod-pto-contr = historico-embarque.cod-pto-contr.
                        LEAVE.
                     END.
                  END.
               END.
            END.
         END.

         IF i-cod-pto-contr = 0
         THEN DO:
            RUN piErro ("Ponto de Controle " + ENTRY(int-desp-imp.cdn-pto-base,c-pto-base) + " nao encontrado no embarque " + cNumeroEmbarque + ".","").
            STOP.
         END.


         FIND FIRST historico-embarque NO-LOCK
              WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                AND historico-embarque.embarque      = embarque-imp.embarque
                AND historico-embarque.cod-pto-contr = i-cod-pto-contr
              NO-ERROR.
         IF NOT AVAIL historico-embarque
         THEN DO:
            RUN piErro ("Historico nao cadastrado para o ponto de controle  " + STRING(i-cod-pto-contr),"").
            STOP.
         END.

         ASSIGN
            i-mo-codigo = moeda.mo-codigo.

         EMPTY TEMP-TABLE tt-desp-embarque.

         RUN piGeraDespesa.

         hQuery:GET-NEXT().
      END.
   END.

END PROCEDURE.


/*
pu    codigo                  8         6 + cod-estabel
                                          + embarque
                                          + cod-itiner
                                          + cod-pto-contr
                                          + cod-desp
                                          + cod-emitente-desp
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

