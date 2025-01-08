/***********************************************************************
**  Programa..: ESAPI\ESAPI010.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Envia E-mail
**  Vers∆o....: 001 09/12/2004
**                  Desenvolvimento Programa
************************************************************************/
/****************************  Temp-Tables  ****************************/
{utp/ut-glob.i}
{esapi/esapi010tt.i}
{utp/utapi019.i}
/* {cdp/cd0666.i} */
{esp/es0043.i}

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
/****************************  Variaveis    ****************************/
define variable h-api as handle no-undo.
DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-mail.
DEFINE OUTPUT       PARAM TABLE FOR tt-erro.

DEFINE STREAM sTerminal.
/*
IF OPSYS <> "UNIX" THEN
   OUTPUT STREAM sTerminal TO TERMINAL.
*/
FOR FIRST param-global NO-LOCK:
END.

IF param-global.serv-mail = "" THEN
DO:
    CREATE tt-erro.
    ASSIGN iCont             = iCont + 1
           tt-erro.i-sequen  = iCont
           tt-erro.cd-erro   = 17567
           tt-erro.mensagem  = "Servidor de E-mail n∆o cadastrado nos parÉmetros do EMS.".
END.
ELSE DO:

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
               tt-envio2.formato           = "TEXTO"
               tt-envio2.exchange          = NO.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem. /* Mensagem           */
                /*"<h1><center>message body 1</pre>"*/

       // OUTPUT STREAM sTerminal TO VALUE(SESSION:TEMP-DIRECTORY + "envemail.txt").
        OUTPUT STREAM sTerminal TO VALUE(c-dir-arquivo-session + "envemail.txt").

        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

        IF OPSYS <> "UNIX" THEN
           OUTPUT STREAM sTerminal CLOSE.
        ASSIGN tt-mail.lEnviado = CAN-FIND(FIRST tt-erros).

        FOR EACH tt-erros:
            CREATE tt-erro.
            ASSIGN iCont             = iCont + 1
                   tt-erro.i-sequen  = iCont
                   tt-erro.cd-erro   = tt-erros.cod-erro
                   tt-erro.mensagem  = tt-erros.desc-erro + tt-erros.desc-arq.
        END.
    END.

    DELETE PROCEDURE h-utapi019.

END.
