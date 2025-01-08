&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESAPI002.p
    Purpose     : Envio de email e tratamento email

    Syntax      :

    Description :

    Author(s)   : Carlos Daniel (Sensus Tecnologia)
    Created     : Setembro/2015
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{utp/utapi019.i}
{esapi/esapi010tt.i}
{esp/es0018.i}

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.
DEFINE            SHARED VARIABLE h-acomp            AS HANDLE    NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piEnviaEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail Procedure 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM premetente AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE INPUT  PARAM pDestino   AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE INPUT  PARAM pAssunto   AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE INPUT  PARAM pDescEmail AS CHARACTER FORMAT "X(60)" NO-UNDO.
DEFINE INPUT  PARAM pArquivo   AS CHARACTER FORMAT "X(60)" NO-UNDO.

DEFINE VARIABLE icont       AS INTEGER NO-UNDO.
DEFINE VARIABLE  h-utapi019 AS HANDLE  NO-UNDO.

EMPTY TEMP-TABLE tt-mail NO-ERROR.

FOR FIRST param-global NO-LOCK: END.

CREATE tt-mail.
ASSIGN tt-mail.Remetente     = pRemetente
       tt-mail.Destinatario  = pdestino
       tt-mail.Assunto       = pAssunto
       tt-mail.Arquivo       = IF pArquivo <> "" THEN pArquivo ELSE "" 
       tt-mail.Mensagem      = pDescEmail.

RUN utp/utapi019.p PERSISTENT SET h-utapi019.

FOR FIRST tt-mail:

    EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = tt-mail.Destinatario     /* Destinat rio       */ 
           tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
           tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
           tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor rio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = tt-mail.Mensagem. /* Mensagem           */
            
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF  AVAIL tt-erros THEN DO:
        OUTPUT TO erros-comerc.LOG APPEND.

        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END. /* IF  AVAIL tt-erros THEN DO: */
END. /* FOR FIRST tt-mail: */

DELETE PROCEDURE h-utapi019.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTrataEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataEmail Procedure 
PROCEDURE piTrataEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER cDestino   AS CHARACTER FORMAT "X(60)"   NO-UNDO. /*opcional*/
DEFINE INPUT PARAMETER cAssunto   AS CHARACTER FORMAT "X(60)"   NO-UNDO.
DEFINE INPUT PARAMETER cDescEmail AS CHARACTER FORMAT "X(2000)" NO-UNDO.
DEFINE INPUT PARAMETER cArqEmail  AS CHARACTER FORMAT "X(60)"   NO-UNDO. /*opcional*/
DEFINE INPUT PARAMETER c-prog-pt  AS CHARACTER FORMAT "X(12)"   NO-UNDO.

DEFINE VARIABLE cRemetente AS CHARACTER FORMAT "X(60)"   NO-UNDO.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-acompanhar IN h-acomp (INPUT "Envio de Email").

FOR FIRST usuar_mestre FIELDS(cod_e_mail_local)
    WHERE  usuar_mestre.cod_usuar = v_cod_usuar_corren NO-LOCK:

    ASSIGN cRemetente = usuar_mestre.cod_e_mail_local.
END.

IF cDestino = "" THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  c-prog-pt,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        ASSIGN cDestino = cDestino + (IF cDestino <> "" THEN ";" ELSE "") + tt-prog-ponto.conteudo.
    END.
END.

RUN piEnviaEmail(INPUT cRemetente, 
                 INPUT cDestino,
                 INPUT cAssunto,
                 INPUT cDescEmail,
                 INPUT cArqEmail).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

