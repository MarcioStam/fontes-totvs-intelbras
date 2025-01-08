/********************************************************************************
 ** UPC........: dad098.p - UPC DELETE emitente
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de emitente para a Base Oracle
 ********************************************************************************/

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i} 

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuario Corrente"
    column-label "Usuario Corrente"
    no-undo. 

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
   
DEFINE VARIABLE v_num_cont AS INTEGER     NO-UNDO.
DEFINE VARIABLE ctrace     AS CHARACTER   NO-UNDO.


DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)'   NO-UNDO.

DEF PARAM BUFFER b-emitente      FOR emitente.

DEF TEMP-TABLE tt-emitente-raw NO-UNDO LIKE emitente.

FIND FIRST int-emitente WHERE
     INT-emitente.cod-emitente = b-emitente.cod-emitente NO-ERROR.
IF AVAIL int-emitente THEN
   DELETE int-emitente.
  
/*
run esp/es0669.p (input "no", 
                  "emitente", 
                  string(b-emitente.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "", "").
*/

/* Chamada da API ESSDCV001API de integraá∆o com o OutBuyCenter (SDCV) - In°cio */
IF (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
   (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:
    /* Definiá∆o da temp-table "ttRawTabela" */
    {esp/sdcv/essdcv001api.i}

    /* Definiá∆o da temp-table "RowErrors" */
    {method/dbotterr.i}

    //apenas para n∆o dar erro de raw-transfer apos vers∆o 12.1.25
    empty temp-table tt-emitente-raw.
    CREATE tt-emitente-raw.
    BUFFER-COPY b-emitente TO tt-emitente-raw.
    //

    CREATE ttRawTabela.
    //RAW-TRANSFER b-emitente TO ttRawTabela.rawTabela.
    RAW-TRANSFER tt-emitente-raw TO ttRawTabela.rawTabela.

    RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                 INPUT  "E":U,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).
END.
/* Chamada da API ESSDCV001API de integraá∆o com o OutBuyCenter (SDCV) - Final */

IF b-emitente.cod-emitente = 0 THEN DO:
     assign v_num_cont = 1.
     bloco:
     repeat:
         if program-name(v_num_cont) = ? then 
             leave bloco.
         assign ctrace = ctrace + string(v_num_cont) + ': ' + program-name(v_num_cont) + chr(10).
         if v_num_cont = 10 then
             leave bloco.
         assign v_num_cont = v_num_cont + 1.
     end.

     ASSIGN cDescEmail = "Usuario: "       + v_cod_usuar_corren         +
                         " Data: "         + STRING(TODAY,"99/99/9999") +
                         " Hora: "         + STRING(TIME,"HH:MM:ss")    + CHR(10) + CHR(10) +
                         "Trace: "        + ctrace
            cDestino = "andre.inoue@intelbras.com.br"
            cAssunto = "Trigger Delete Emitente " + string(b-emitente.cod-emitente)
            cRemetente = "andre.inoue@intelbras.com.br".

     RUN piEnviaEmail(INPUT cRemetente, 
                      INPUT cDestino,
                      INPUT cAssunto,
                      INPUT cDescEmail,
                      INPUT cArqEmail).
  

END.

PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

       RUN utp/utapi019.p PERSISTENT SET h-utapi019.

       FOR EACH tt-mail:

           FOR EACH tt-envio2.   DELETE tt-envio2.   END.
           FOR EACH tt-mensagem. DELETE tt-mensagem. END.

           CREATE tt-envio2.
           ASSIGN tt-envio2.versao-integracao = 1
                  tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                  tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                  tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                  tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                  tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                  tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor†rio */
                  tt-envio2.formato           = "TEXTO".

           CREATE tt-mensagem.
           ASSIGN tt-mensagem.seq-mensagem = 1
                  tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */
                   /*"<h1><center>message body 1</pre>"*/

/*            CREATE tt-mensagem. */
/*            ASSIGN tt-mensagem.seq-mensagem = 2 */
/*                   tt-mensagem.mensagem     = "Port Pref Anterior: " + string(b-old-emitente.port-prefer) + */
/*                                              " Mod: " + STRING(INT(b-old-emitente.mod-prefer)) + */
/*                                              "Port Pref Atual: " + string(b-emitente.port-prefer) + */
/*                                              " Mod: " + STRING(INT(b-emitente.mod-prefer)) + CHR(13). */
/*    */
/*           REPEAT WHILE PROGRAM-NAME(level) <> ?. */
/*                   CREATE tt-mensagem. */
/*                   ASSIGN tt-mensagem.seq-mensagem = level + 2 */
/*                          tt-mensagem.mensagem     = "Nivel: " + string(LEVEL) + */
/*                                                     "  Programa: " + PROGRAM-NAME(level) + CHR(13) */
/*                          level = level + 1. */
/*            END. */

       /*    PUT 'TST 1 ' SKIP.*/
           RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                          INPUT  TABLE tt-mensagem,
                                          OUTPUT TABLE tt-erros).
   
/*           ASSIGN tt-mail.lEnviado = CAN-FIND(FIRST tt-erros). */
           FIND FIRST tt-erros NO-LOCK NO-ERROR.
           IF AVAIL tt-erros THEN
               OUTPUT TO erros-comerc.LOG APPEND.

           FOR EACH tt-erros:
               DISP tt-erros.cod-erro
                    tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
           END.
           OUTPUT CLOSE.
       END.

       IF  VALID-HANDLE(h-utapi019)
       THEN
           DELETE PROCEDURE h-utapi019.
       ASSIGN h-utapi019 = ?.

/*    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    IF CAN-FIND(FIRST tt-erro) THEN
        RUN cdp\cd0666.w (INPUT TABLE tt-erro). 
  */
END PROCEDURE.
