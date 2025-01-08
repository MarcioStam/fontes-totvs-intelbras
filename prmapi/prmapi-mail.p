/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: PRMAPI-MAIL                                                                                                                                          **
** Data .........: Junho de 2016                                                                                                                                        **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: API PadrÆo para enviar e-mails                                                                                                                       **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.   Data                  Solicitante    Descri‡Æo                                                                                                  **
** Gabriel Poli  00.001 26/04/16              Rafael Rosa    1) Desenvolvimento inicial do programa                                                                     **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/
/*--- parƒmetros de entrada ---*/
DEFINE INPUT PARAMETER c-destinatario AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-assunto      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-corpo-email  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-arq-anexo    AS CHARACTER  NO-UNDO.

/*--- Vari veis Locais ---*/
DEFINE VARIABLE h-utils       AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-contador    AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-dest-valido AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-erros       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.

{utp/utapi019.i2} /*--- Include para envio de e-mails ---*/

/*--- inicializa‡Æo ---*/                                                          
RUN utp/ut-utils.p PERSISTENT SET h-utils.
RUN utp/utapi019.p PERSISTENT SET h-utapi019.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT 'Enviando E-Mail(s)...').

DO i-contador = 1 TO NUM-ENTRIES(c-destinatario,';'):

    RUN pi-acompanhar IN h-acomp (INPUT 'E-Mail(s): ' + string(i-contador)
                                      + ' / '         + string(NUM-ENTRIES(c-destinatario,';'))).

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-paramEmail2.

    FIND FIRST param_email NO-LOCK NO-ERROR.

    CREATE tt-paramEmail2.
    ASSIGN tt-paramEmail2.caminhoEmail     = param_email.idi_e-mail /* 1-Blat 2-Exchange 5-Datasul Mail Service */
           tt-paramEmail2.mailUser         = param_email.cod_usuar_email
           tt-paramEmail2.mailPass         = param_email.cod_senha
           tt-paramEmail2.TLS              = YES
           tt-paramEmail2.SSL              = LOGICAL(ENTRY(1,param_email.cod_livre_2,'|'))
           tt-paramEmail2.debug            = LOGICAL(ENTRY(3,param_email.cod_livre_2,'|'))
           tt-paramEmail2.ativaRemetPadrao = LOGICAL(ENTRY(4,param_email.cod_livre_2,'|'))
           tt-paramEmail2.codRemetPadrao   = (IF tt-paramEmail2.ativaRemetPadrao = FALSE THEN '' ELSE param_email.cod_remte_email).

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = ENTRY(i-contador,c-destinatario,';')
           tt-envio2.remetente         = param_email.cod_remte_email
           tt-envio2.assunto           = c-assunto
           tt-envio2.arq-anexo         = c-arq-anexo
           tt-envio2.exchange          = param_email.log_servid_exchange
           tt-envio2.servidor          = param_email.cod_servid_e_mail
           tt-envio2.porta             = param_email.num_porta.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = i-contador
           tt-mensagem.mensagem     = c-corpo-email.

    IF tt-envio2.destino  <> ''
    AND tt-envio2.destino <> ?
    THEN ASSIGN l-dest-valido = YES.
    ELSE ASSIGN l-dest-valido = NO.

    IF l-dest-valido = NO THEN NEXT.
    
    RUN pi-execute4 IN h-utapi019 (INPUT  table tt-envio2,
                                   INPUT  table tt-mensagem,
                                   INPUT  table tt-paramEmail2,
								   INPUT  table ttAttachment,
                                   OUTPUT table tt-erros).
    
    IF RETURN-VALUE = "NOK"
    THEN DO:
        FOR  EACH tt-erros:
            ASSIGN c-erros = c-erros + string(tt-erros.cod-erro) + ' - ' + tt-erros.desc-erro + chr(10) .
        END.
        
        //RUN utp/ut-msgs.p(INPUT "show":U,INPUT 17006,INPUT "Erro ao enviar o E-mail.~~" + c-erros ).
        
        ASSIGN c-arquivo = SESSION:TEMP-DIR + '\log_email_integrador.txt'.
        OUTPUT TO VALUE(c-arquivo) NO-CONVERT APPEND.

        PUT FILL("-",52) FORMAT "x(52)" TODAY FORMAT "99/99/9999" "--" STRING(TIME,"hh:mm:ss") SKIP. 
        PUT "           ERROS: ENVIO E-MAIL INTEGRADOR          " FORMAT "x(70)" SKIP.
        PUT FILL("-",72) FORMAT "x(72)" SKIP.
        PUT UNFORMATTED c-erros SKIP.
        PUT FILL("-",72) FORMAT "x(72)" SKIP.

        OUTPUT CLOSE.
    END.
           
END.


DELETE PROCEDURE h-utils.
DELETE PROCEDURE h-utapi019.

ASSIGN h-utils    = ?
       h-utapi019 = ?.

IF VALID-HANDLE(h-acomp) THEN 
    RUN pi-finalizar IN h-acomp.

/*--- fim ---*/
