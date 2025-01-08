/********************************************************************************
** Datasul Technologia
**
** Programa: utappi019-upc - UPC repons vel para montar o comando de envio de email
**
** C¢digo de Parametros Dispon¡veis:
**
**      EmailFrom       - Email remetente
**      EmailTo         - Email destino
**      ServidorEmail   - Servidor SMTP
**      CorpoEmail      - Arquivo com o texto do e-mail
**      CommandEmail    - Retorna o comando completo do e-mail
**
********************************************************************************/
/* --- defini‡Æo da temp-table tt-epc - */
{include/i-epc200.i1}

{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* --- Parƒmetros de Entrada do Programa - */
DEF INPUT               PARAM p-ind-event   AS CHAR NO-UNDO.
DEF INPUT-OUTPUT        PARAM TABLE         FOR tt-epc.

/* --- Defini‡Æo de Vari veis locais - */
DEF VAR cComandoEmail AS CHAR NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEmailTo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ini     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-fim     AS INTEGER     NO-UNDO.

define variable c-arquivo as character no-undo.
define variable c-linha as character no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

DEFINE VARIABLE l-teste AS LOGICAL     NO-UNDO INITIAL no.

/******************************************************************************
*
*   Exemplo: Rotina para ponto de EPC do UNIX.
*
*   O comando que esta sendo montado abaixo:
*
*   sendmail -v <HostSMTP>:<eMailTo> <Arquivo Corpo Email>/dev/null
*    ou
*   sendmail -f <destin rio> -v <HostSMTP>:eMailTo <Arquivo Corpo Email>/dev/null
*
********************************************************************************/

define variable pmComando as character no-undo.
define variable pmAttach  as character no-undo.
define variable pmWhoami  as character no-undo.
define variable pmFile    as character no-undo.
define variable iCont     as integer   no-undo.
define variable mailTo    as character no-undo.
define variable mailCc    as character no-undo.
define variable mailBcc   as character no-undo.

if p-ind-event = 'eMailUnix' and can-find (first tt-epc where tt-epc.cod-event = 'eMailUnix' and tt-epc.cod-parameter = 'EmailFrom') then do:
   /** Envio de e-mail atrav‚s do perl **/
  /* output to value(session:temp-directory + 'tmpmail/log-mail.pl.txt') append. */
   output to value(c-dir-arquivo-session + 'tmpmail/log-mail.pl.txt') append.

   put unformatted '--- BEGIN @ ' now skip.

   assign pmComando = search('esp/utp/mail.pl').

   run esp/es0018p.p (input "utapi019-upc", /* Nome do programa */
                      input 1,              /* Ponto do programa */
                      input 0,
                      input "",
                      output table tt-prog-ponto).

   find first tt-prog-ponto
        where tt-prog-ponto.nome-programa = "utapi019-upc"
          and tt-prog-ponto.ponto         = 1 no-error.

   if avail tt-prog-ponto and tt-prog-ponto.conteudo <> "" then
       assign pmComando = pmComando + ' -u ' + entry(1, tt-prog-ponto.conteudo, ';')
                                    + ' -p ' + entry(2, tt-prog-ponto.conteudo, ';').

   /** Mudanca do destinatario **/
   run esp/es0018p.p (input "ambiente",
                      input 1,
                      input 0,
                      input "",
                      output table tt-prog-ponto).

   find first tt-prog-ponto no-error.

   if avail tt-prog-ponto and tt-prog-ponto.conteudo <> "PRODUCAO" then do:
      assign l-teste = yes
             c-email = 'totvshomo@intelbras.com.br'.

      run esp/es0018p.p (input "utapi019-upc",
                         input 2,
                         input 0,
                         input "",
                         output table tt-prog-ponto).

      find first tt-prog-ponto
           where tt-prog-ponto.nome-programa = "utapi019-upc"
             and tt-prog-ponto.ponto         = 2 no-error.

      if avail tt-prog-ponto and tt-prog-ponto.conteudo <> "" then
         assign c-email = tt-prog-ponto.conteudo.
   end.

   find tt-epc no-lock
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'EmailFrom' no-error.

   assign pmComando = pmComando + substitute(' -f "&1"', tt-epc.val-parameter).

   find tt-epc no-lock
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'Assunto' no-error.

   if (tt-epc.val-parameter) <> '' then
     assign pmComando = pmComando + substitute(' -s "&1"', replace(tt-epc.val-parameter, '"', '~\"')).

   find tt-epc no-lock
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'formato' no-error.

   if (tt-epc.val-parameter) = 'HTML' then
     assign pmComando = pmComando + ' -r'.

   /** Chamado 67177 - tratamento para CC/BCC **/
   find tt-epc no-lock
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'EmailTo' no-error.

   assign mailTo = if l-teste then c-email else tt-epc.val-parameter.

   find tt-epc no-lock
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'EmailCC' no-error.

   if (tt-epc.val-parameter) <> '' and not l-teste then do:
     assign mailTo = replace(mailTo, tt-epc.val-parameter, '').

     do iCont = 1 to num-entries(tt-epc.val-parameter):
        if (entry(iCont, tt-epc.val-parameter) begins 'BCC:') then
           assign mailBcc = mailBcc + replace(entry(iCont, tt-epc.val-parameter), 'BCC:', '') + ','.
        else
           assign mailCc = mailCc + entry(iCont, tt-epc.val-parameter) + ','.
     end.

     assign mailTo  = substring(mailTo, 1, length(mailTo) - 1)
            mailCc  = substring(mailCc, 1, length(mailCc) - 1)
            mailBcc = substring(mailBcc, 1, length(mailBcc) - 1).
   end.

   assign pmComando = pmComando + substitute(' -t "&1"', mailTo).

   if (mailCc ne '') then
      assign pmComando = pmComando + substitute(' -c "&1"', mailCc).

   if (mailBcc ne '') then
      assign pmComando = pmComando + substitute(' -b "&1"', mailBcc).
   /** Fim chamado 67177 **/

   find tt-epc no-lock
      where tt-epc.cod-event     = 'eMailUnix'
        and tt-epc.cod-parameter = 'Anexos' no-error.

   /** Tratamento correto para anexo **/
   if (tt-epc.val-parameter <> "") then do:
      do iCont = 1 to num-entries(tt-epc.val-parameter):
         assign pmAttach = pmAttach + '"' + entry(iCont, tt-epc.val-parameter) + '" '.
      end.
      assign pmAttach  = substring(pmAttach, 1, length(pmAttach) - 1)
             pmComando = pmComando + ' ' + pmAttach.
   end.

   find tt-epc no-lock
      where tt-epc.cod-event     = 'eMailUnix'
        and tt-epc.cod-parameter = 'CorpoEmail' no-error.

   assign pmComando = pmComando + ' < ' +  tt-epc.val-parameter
          pmFile    = entry(num-entries(tt-epc.val-parameter, '/'), tt-epc.val-parameter, '/').

  /* os-copy value(tt-epc.val-parameter) value(session:temp-directory + '/tmpmail/bkp/' + pmFile). */
   os-copy value(tt-epc.val-parameter) value(c-dir-arquivo-session + '/tmpmail/bkp/' + pmFile).

   input through whoami no-echo.
   import pmWhoami.
   input close.

   put unformatted '--- FILE: ' pmFile skip '--- by: ' pmWhoami skip 'cmd: ' pmComando skip.

   unix silent value (pmComando).

   put unformatted '--- END   @ ' now skip.

   output close.

   find tt-epc
     where tt-epc.cod-event     = 'eMailUnix'
       and tt-epc.cod-parameter = 'CommandEmail' no-error.

   assign tt-epc.val-parameter = '/bin/false'.
end.

IF  p-ind-event = "eMailBlat":U THEN DO:
    FIND FIRST tt-epc EXCLUSIVE-LOCK
         WHERE tt-epc.cod-event     = "eMailBlat":U
           AND tt-epc.cod-parameter = "CommandEmail":U NO-ERROR.
    IF  AVAIL tt-epc
        THEN ASSIGN cComandoEmail = tt-epc.val-parameter.

    /* --- Habilita Log do BLAT -
    ASSIGN cComandoEmail = cComandoEmail + " -log c:\tmp\blat.log -debug":U.
    */

    /* --- Define o parƒmetro Hostname -
    ASSIGN cComandoEmail = cComandoEmail + " -hostname ":U + chr(34) + "localhost":U + chr(34).
    */
    ASSIGN c-usuario = ""
           c-senha   = "".

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "utapi019-upc", /* Nome do programa */
                       INPUT 3,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).

    find first tt-prog-ponto
         where tt-prog-ponto.nome-programa = "utapi019-upc"
           and tt-prog-ponto.ponto         = 3
           and tt-prog-ponto.sequencia     = 0 no-error.
    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN c-usuario = TRIM(ENTRY(1,tt-prog-ponto.conteudo,";"))
               c-senha   = TRIM(ENTRY(2,tt-prog-ponto.conteudo,";")).
    END.

    /* --- Define a autentifica‡Æo - */
    ASSIGN cComandoEmail = cComandoEmail + " -u ":U + CHR(34) + c-usuario + CHR(34) + " -pw ":U + CHR(34) + c-senha + CHR(34).

    /* *** Altera o parƒmetro -f caso venha do m¢dulo IVC ***/
    IF INDEX(cComandoEmail, "-f @.") <> 0
    THEN DO:
         FIND usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
         IF AVAIL usuar_mestre
         AND usuar_mestre.cod_e_mail_local <> ""
             THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, "-f @.", "-f " + usuar_mestre.cod_e_mail_local).
             ELSE ASSIGN cComandoEmail = REPLACE(cComandoEmail, "-f @.", "-f ems@intelbras.com.br").
    END.

    RUN pi-verifica-bcc.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "ambiente":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF  AVAILABLE tt-prog-ponto AND
                  tt-prog-ponto.conteudo <> "PRODUCAO"
    THEN DO:
        /*ambiente de teste muda destinatario*/

        ASSIGN c-email = "totvshomo@intelbras.com.br".

        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "utapi019-upc", /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).

        find first tt-prog-ponto
             where tt-prog-ponto.nome-programa = "utapi019-upc"
               and tt-prog-ponto.ponto         = 2 no-error.
        IF AVAIL tt-prog-ponto AND tt-prog-ponto.conteudo <> "" THEN DO:
            ASSIGN c-email = TRIM(REPLACE(tt-prog-ponto.conteudo,";",",")).
        END.

        assign i-ini = INDEX(cComandoEmail," -t ")
               i-fim = INDEX(cComandoEmail," -server ").

        ASSIGN cComandoEmail = REPLACE(cComandoEmail,SUBSTRING(cComandoEmail,i-ini,i-fim - i-ini)," -t " + c-email).

        IF INDEX(cComandoEmail," -c ") <> 0 THEN DO:
            ASSIGN i-ini = 0
                   i-fim = 0.

            assign i-ini = INDEX(cComandoEmail," -c ")
                   i-fim = INDEX(cComandoEmail," -",i-ini + 1).

            ASSIGN cComandoEmail = REPLACE(cComandoEmail,SUBSTRING(cComandoEmail,i-ini,i-fim - i-ini)," ").
        END.

        IF INDEX(cComandoEmail," -cc ") <> 0 THEN DO:
            ASSIGN i-ini = 0
                   i-fim = 0.

            assign i-ini = INDEX(cComandoEmail," -cc ")
                   i-fim = INDEX(cComandoEmail," -",i-ini + 1).

            ASSIGN cComandoEmail = REPLACE(cComandoEmail,SUBSTRING(cComandoEmail,i-ini,i-fim - i-ini)," ").
        END.

        IF INDEX(cComandoEmail," -bcc ") <> 0 THEN DO:
            ASSIGN i-ini = 0
                   i-fim = 0.

            assign i-ini = INDEX(cComandoEmail," -bcc ")
                   i-fim = INDEX(cComandoEmail," -",i-ini + 1).

            ASSIGN cComandoEmail = REPLACE(cComandoEmail,SUBSTRING(cComandoEmail,i-ini,i-fim - i-ini)," ").
        END.

    END.

    IF AVAIL tt-epc THEN
        ASSIGN tt-epc.val-parameter = cComandoEmail.
END.

PROCEDURE pi-verifica-bcc:
    /* Para transforma‡Æo do CC em BCC, no inicio do email cc deve vir a expressao BCC: */

    /* Altera o CC para BCC caso esteja definido no campo */
    IF INDEX(cComandoEmail, " -c ") <> 0 THEN
        IF INDEX(cComandoEmail," -c BCC:") <> 0 THEN
            ASSIGN cComandoEmail = REPLACE(cComandoEmail," -c BCC:"," -bcc ").

    IF INDEX(cComandoEmail, " -cc ") <> 0 THEN
        IF INDEX(cComandoEmail," -cc BCC:") <> 0 THEN
            ASSIGN cComandoEmail = REPLACE(cComandoEmail," -cc BCC:"," -bcc ").

    IF INDEX(cComandoEmail, " -bcc ,") <> 0 THEN
        ASSIGN cComandoEmail = REPLACE(cComandoEmail," -bcc ,"," -bcc ").
    /* Fim alteracao bcc */
END PROCEDURE.
