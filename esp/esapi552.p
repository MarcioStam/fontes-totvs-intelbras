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


DEF TEMP-TABLE ttEmitente   NO-UNDO
    FIELD cod-emitente       LIKE emitente.cod-emitente          SERIALIZE-NAME "codigoExportador"
    FIELD nome-emit          LIKE emitente.nome-emit             SERIALIZE-NAME "razaoSocial"
    FIELD endereco           LIKE emitente.endereco              SERIALIZE-NAME "logradouro"
    FIELD numero             LIKE int-emitente.numero            SERIALIZE-NAME "numero"
    FIELD complemento        LIKE int-emitente.complemento       SERIALIZE-NAME "complemento"
    FIELD bairro             LIKE emitente.bairro                SERIALIZE-NAME "bairro"
    FIELD cep                LIKE emitente.cep                   SERIALIZE-NAME "cep"
    FIELD cidade             LIKE emitente.cidade                SERIALIZE-NAME "municipio"
    FIELD estado             LIKE emitente.estado                SERIALIZE-NAME "siglaEstado"
    FIELD pais               LIKE emitente.pais                  SERIALIZE-NAME "siglaPais"
    FIELD cod-pais-siscomex  LIKE mgcad.pais.cod-pais-siscomex   SERIALIZE-NAME "codigoPaisBacen"
    FIELD e-mail             LIKE emitente.e-mail                SERIALIZE-NAME "email"
    FIELD telefone           LIKE emitente.telefone[1]           SERIALIZE-NAME "telefone"
    INDEX i cod-emitente
    .

DEF VAR i-pag            AS i        NO-UNDO.
DEF VAR httCust          AS HANDLE   NO-UNDO.
DEF VAR lReturnValue     AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi552 AS l NO-UNDO.

DEF VAR cJson            AS c        NO-UNDO.
DEF VAR c-cod-exportador AS c        NO-UNDO.

DEF VAR j                AS i        NO-UNDO.
DEF VAR t                AS i        NO-UNDO.
                        
DEF VAR c-faixa-ge       AS c        NO-UNDO.
DEF VAR c-faixa-est      AS c        NO-UNDO.

ASSIGN
   t = TIME.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi552 = NO.
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

&IF DEFINED(EXCLUDE-fc-campo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-campo Procedure 
FUNCTION fc-campo RETURNS CHARACTER
  ( c AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
         HEIGHT             = 11.25
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    //MESSAGE 1 l-esapi505a i-acao VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 AS l. IF l1 = NO THEN STOP.

blk: FOR FIRST es-api-log
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
       es-api-log.dh-envio       = NOW
       es-api-log.flg-processado = YES.

    //MESSAGE 2 l-esapi505a VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.

    IF  l-esapi552       = NO
    AND length(es-api-log.cjson) = ?
    AND es-api-log.id-URI = "Exportador"
    THEN DO:
       FOR EACH emitente NO-LOCK
          WHERE emitente.identific > 1
            AND emitente.natureza  = 3,
          FIRST int-emitente NO-LOCK
          WHERE int-emitente.cod-emitente = emitente.cod-emitente:
           RUN pi-acompanhar IN h-acomp (STRING(TIME - t,"hh:mm:ss") + " Exportador - " + STRING(emitente.cod-emitente)).

          CREATE ttEmitente.
          ASSIGN
             ttEmitente.cod-emitente      = emitente.cod-emitente
             ttEmitente.nome-emit         = fc-campo(emitente.nome-emit)
             ttEmitente.e-mail            = fc-campo(emitente.e-mail)
             ttEmitente.telefone          = fc-campo(emitente.telefone[1])
             ttEmitente.telefone          = fc-campo(REPLACE(ttEmitente.telefone," ",""))
             ttEmitente.telefone          = fc-campo(REPLACE(ttEmitente.telefone,"(",""))
             ttEmitente.telefone          = fc-campo(REPLACE(ttEmitente.telefone,")",""))
             ttEmitente.telefone          = fc-campo(REPLACE(ttEmitente.telefone,"-",""))
             ttEmitente.bairro            = fc-campo(emitente.bairro)
             ttEmitente.cep               = fc-campo(emitente.cep)
             ttEmitente.complemento       = fc-campo(int-emitente.complemento)
             ttEmitente.endereco          = fc-campo(int-emitente.logradouro)
             ttEmitente.cidade            = fc-campo(emitente.cidade)
             ttEmitente.numero            = fc-campo(int-emitente.numero)
             ttEmitente.estado            = fc-campo(emitente.estado)
             ttEmitente.pais              = emitente.pais.
          FIND FIRST mgcad.pais NO-LOCK
               WHERE pais.nome-pais = emitente.pais
               NO-ERROR.
          IF AVAIL pais
          THEN ASSIGN
             ttEmitente.cod-pais-siscomex = mgcad.pais.cod-pais-siscomex
             .
       END.

/*-*-*-*-*/

       FOR EACH ttEmitente:
          IF ttEmitente.e-mail = "" 
          THEN NEXT.
          IF ttEmitente.cod-pais-siscomex = "" 
          THEN NEXT.

          /*
          DEF VAR X AS i.
          X = X + 1.
          IF X > 3
          THEN NEXT.
          MESSAGE X
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          */
          ASSIGN
             cJson =  '~{'
                   +    '"codigoExportador": "' + STRING(ttEmitente.cod-emitente)           + '",'
                   +    '"razaoSocial": "'      + ttEmitente.nome-emit                      + '",'
                   +    '"email": "'            + ttEmitente.e-mail                         + '",'
                   +    '"telefone": "'         + ttEmitente.telefone                       + '",'
                   +    '"Endereco": ~{'          
                   +      '"bairro": "'         + ttEmitente.bairro                         + '",'
                   +      '"cep": "'            + ttEmitente.cep                            + '",'
                   +      '"complemento": "'    + ttEmitente.complemento                    + '",'
                   +      '"logradouro": "'     + ttEmitente.endereco                       + '",'
                   +      '"municipio": "'      + ttEmitente.cidade                         + '",'
                   +      '"numero": "'         + ttEmitente.numero                         + '",'
                   +      '"siglaEstado": "'    + ttEmitente.estado                         + '",'
                   +      '"siglaPais": "'      + ttEmitente.pais                           + '",'
                   +      '"codigoPaisBacen": ' + STRING(INT(ttEmitente.cod-pais-siscomex)) + ''
                   +     '}'
                   +  '}'.


//          CLIPBOARD:VALUE = cJson.
          FIND FIRST es-api-cex-exportador 
               WHERE es-api-cex-exportador.cod-emitente = ttEmitente.cod-emitente
               NO-ERROR.

/*           MESSAGE ">> Fornecedor " ttEmitente.cod-emitente. */
   
          IF AVAIL es-api-cex-exportador 
          THEN DO:
             IF cJson <> es-api-cex-exportador.cJson
             THEN DO:
/*                 MESSAGE ">> Alterar". */
                ASSIGN
                   es-api-cex-exportador.cJson = cJson.
                RUN pi-criar-log ("Exportador",ttEmitente.cod-emitente,cJson).
             END.
          END.
          ELSE DO:
/*              MESSAGE ">> Criar". */
             CREATE es-api-cex-exportador.
             ASSIGN
                es-api-cex-exportador.cod-emitente = ttEmitente.cod-emitente
                es-api-cex-exportador.cJson        = cJson.
             RUN pi-criar-log ("Exportador-NEW",ttEmitente.cod-emitente,cJson).
          END.
          //LEAVE. /*-*-*-*/
       END.
       ASSIGN 
          l-esapi552 = YES.
       ASSIGN
          es-api-log.dh-retorno = NOW.

       LEAVE blk.
    END.

    IF  l-esapi552       = NO
    AND es-api-log.aux   = ""
    THEN DO:
       ASSIGN
          es-api-log.dh-retorno = NOW.
    END.

    RUN pi-acompanhar IN h-acomp ("Exportador " + es-api-log.aux).

    ASSIGN 
       lcEnvio = es-api-log.cjson
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

    IF es-api-aplicacao.Testes  = NO
    THEN ASSIGN
       c-endereco          = es-api-URI.ent-PRD.
    ELSE ASSIGN            
       c-endereco          = es-api-URI.end-TST.

    IF es-api-log.id-URI = "Exportador"
    THEN ASSIGN
       c-endereco          = c-endereco + "/" + es-api-log.aux.

    COPY-LOB lcEnvio TO es-api-log.cl-envio.

    IF STRING(lcEnvio) > ""
    THEN fc-chamada-1(). //fc-chamada-2().

    IF NO //es-api-log.cod-retorno >= "300"
    THEN DO:
       FIND FIRST es-api-cex-exportador 
            WHERE es-api-cex-exportador.cod-emitente = INT(es-api-log.aux)
            NO-ERROR.
       IF AVAIL es-api-cex-exportador 
       THEN DO:
          IF es-api-log.id-URI = "Exportador-NEW"
          THEN DELETE es-api-cex-exportador.
          ELSE ASSIGN
             es-api-cex-exportador.cJson = "".
       END.
    END.

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-criar-log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-log Procedure 
PROCEDURE pi-criar-log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF BUFFER bf-las-api-log FOR es-api-log.
   DEF BUFFER bf-new-api-log FOR es-api-log.
   DEF INPUT PARAM cURI      AS  c NO-UNDO.
   DEF INPUT PARAM i-codigo  AS  i NO-UNDO.
   DEF INPUT PARAM cJson     AS  c NO-UNDO.

   FIND LAST bf-las-api-log NO-LOCK
       WHERE bf-las-api-log.id-api-log > 0
       NO-ERROR.
   CREATE bf-new-api-log.
   ASSIGN
      bf-new-api-log.seqexec        = es-api-log.seqexec     
      bf-new-api-log.id-aplicacao   = es-api-log.id-aplicacao
      bf-new-api-log.id-codigo      = es-api-log.id-codigo   
      bf-new-api-log.id-URI         = cURI
      bf-new-api-log.dh-request     = NOW
      bf-new-api-log.end-envio      = es-api-log.end-envio
      bf-new-api-log.flg-processado = NO
      bf-new-api-log.Origem         = es-api-log.Origem
      bf-new-api-log.aux            = STRING(i-codigo) 
      bf-new-api-log.cJson          = cJson
      bf-new-api-log.id-api-log     = NEXT-VALUE(seq_api_log)
      .
   
   
   RELEASE bf-new-api-log.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fc-campo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-campo Procedure 
FUNCTION fc-campo RETURNS CHARACTER
  ( c AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN
      c = REPLACE(c,'"','')
      c = REPLACE(c,':','')
      c = REPLACE(c,',','')
      c = REPLACE(c,'\','')
      c = TRIM(c)
      .

   RETURN c.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
     d = DATE(INT(SUBSTR(c,5,2)),
              INT(SUBSTR(c,7,2)),
              INT(SUBSTR(c,1,4))
              ).

  RETURN d.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

