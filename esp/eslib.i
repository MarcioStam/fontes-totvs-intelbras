&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : eslib.i
    Purpose     : Cole‡Æo de rotinas utilizadas por diversos programas

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

&GLOBAL-DEFINE ARQUIVO-LOG "c:\temp\erros-email.log"

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD congelado Include 
FUNCTION congelado RETURNS LOGICAL
  ( 
    input pi-cod-estabel as char,
    INPUT co-it-codigo AS CHAR,
    INPUT co-cod-depos AS CHAR,
    INPUT co-localizacao AS CHAR
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

{cdp/cd0666.i}
{utp/utapi019.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

FOR FIRST param-estoq NO-LOCK:
END.

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
    DEF VAR c-arquivo AS CHAR NO-UNDO.

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
       IF OPSYS = "UNIX" THEN do:

           ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

           output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeAE Include 
PROCEDURE imprimeAE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**************************************************************************
       PROCEDURE DESCONTINUADA POIS FOI CRIADA A API ESAPI020.P PARA O MESMO
       FIM: UNIFICAR A IMPRESSÇO DAS ETIQUETAS DAS AES 
     **************************************************************************/

    /*
    DEF INPUT PARAM p-nom-impressora AS CHAR NO-UNDO.
    DEF INPUT PARAM p-destino AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-nr-ae LIKE ae-item.nr-ae NO-UNDO.
    DEF INPUT PARAM p-ini-sequencia LIKE ae-item.sequencia NO-UNDO.
    DEF INPUT PARAM p-fim-sequencia LIKE ae-item.sequencia NO-UNDO.

    def var c-linha AS CHAR NO-UNDO.
    DEF VAR i-it-digito AS INTEGER NO-UNDO.

    DEF BUFFER b-ae-item FOR ae-item.

    IF p-nom-impressora NE "local" THEN DO:
        FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
            where imprsor_usuar.nom_impressora = p-nom-impressora
            and   imprsor_usuar.cod_usuario    = c-seg-usuario
            use-index imprsrsr_id,
            FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
            FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

            output to value(imprsor_usuar.nom_disposit_so)
                   page-size 0
                   convert target tip_imprsor.cod_pag_carac_conver . 
        END.
    END.
    ELSE OUTPUT TO PRINTER.
    
    FOR EACH ae-item NO-LOCK
        WHERE ae-item.cod-estabel = v_cod_estab_usuar
        and   ae-item.nr-ae = p-nr-ae
        AND   ae-item.sequencia >= p-ini-sequencia
        AND   ae-item.sequencia <= p-fim-sequencia
        BY ae-item.sequencia:

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = ae-item.it-codigo:
        END.

        ASSIGN c-linha = substring(ae-item.it-codigo,1,7)   +
                         string(ae-item.quantidade,"99999") +
                         string(ae-item.nr-ae,"9999999")    +
                         string(ae-item.sequencia,"999").

        run esp/es0135(input c-linha, output i-it-digito).
        assign c-linha = c-linha + string(i-it-digito,"9").

        CASE p-destino:
            WHEN 1 OR WHEN 2 THEN DO:
                {esp/es0478.iz2} /* barra */
            END.
            WHEN 3 THEN DO:
                {esp/es0478.iz} /* zebra */
            END.
        END CASE.

        FIND b-ae-item OF ae-item EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN b-ae-item.impresso = YES.
    END.
    */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION congelado Include 
FUNCTION congelado RETURNS LOGICAL
  ( 
    input pi-cod-estabel as char,
    INPUT co-it-codigo AS CHAR,
    INPUT co-cod-depos AS CHAR,
    INPUT co-localizacao AS CHAR
  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    if co-localizacao <> ? then do:
    
        find saldo-estoq no-lock
             where saldo-estoq.cod-estabel = pi-cod-estabel
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo
               and saldo-estoq.cod-localiz = co-localizacao no-error.
        if not avail saldo-estoq then do:
            RETURN FALSE.
        end.
        
        find int-saldo-estoq
             where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
               and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
               and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
               and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                   no-lock no-error.
        if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
            RETURN TRUE.
        else    
            RETURN FALSE.
    end.
    else do:
        FOR each saldo-estoq no-lock
             where saldo-estoq.cod-estabel = pi-cod-estabel
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo :
            find int-saldo-estoq
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                       no-lock no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                RETURN TRUE.
        END.
    end.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

