&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

&if defined(GLOBALS) = 0 &then
    {utp/ut-glob.i}
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Include 
/* ************************* Included-Libraries *********************** */

{utp/utapi019.i}
{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaMail Include 
PROCEDURE enviaMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR c-arquivo-log AS CHAR NO-UNDO.

    IF OPSYS = "UNIX" THEN
        ASSIGN c-arquivo-log = session:TEMP-DIRECTORY + "/erros-email.log".
    ELSE
        ASSIGN c-arquivo-log = session:TEMP-DIRECTORY + "\erros-email.log".

   RUN utp/utapi019.p PERSISTENT SET h-utapi019.

   FOR EACH tt-envio2.   DELETE tt-envio2.   END.
   FOR EACH tt-mensagem. DELETE tt-mensagem. END.

   FOR FIRST param-global NO-LOCK:
   END.

   CREATE tt-envio2.
   ASSIGN tt-envio2.versao-integracao = 1
          tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
          tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
          tt-envio2.destino           = pDestino     /* Destinatÿrio       */ 
          tt-envio2.remetente         = pRemetente        /* Remetente          */ 
          tt-envio2.assunto           = pAssunto          /* Assunto            */
          tt-envio2.arq-anexo         = pArquivo          /* Arquivo Temporÿrio */
          tt-envio2.formato           = "TEXTO".

   CREATE tt-mensagem.
   ASSIGN tt-mensagem.seq-mensagem = 1
          tt-mensagem.mensagem     = pDescEmail. /* Mensagem           */

   RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                  INPUT  TABLE tt-mensagem,
                                  OUTPUT TABLE tt-erros).
   FIND FIRST tt-erros NO-LOCK NO-ERROR.
   IF AVAIL tt-erros THEN DO:
       IF OPSYS = "UNIX" THEN DO:
           OUTPUT TO VALUE(c-arquivo-log).
           FOR EACH tt-erros:
               DISP tt-erros.cod-erro
                    tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
           END.
           OUTPUT CLOSE.
       END.
       ELSE DO:
           FOR EACH tt-erro:
               DELETE tt-erro.
           END.
           FOR EACH tt-erros:
               CREATE tt-erro.
               ASSIGN i = i + 1
                      tt-erro.i-sequen = i
                      tt-erro.cd-erro  = tt-erros.cod-erro
                      tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
           END.
           RUN cdp/cd0666.w (INPUT TABLE tt-erro).
       END.
   END.

   DELETE PROCEDURE h-utapi019.
   h-utapi019 = ?.
   IF AVAIL tt-erros THEN RETURN "NOK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

