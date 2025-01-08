/****************************************************************************************/
/* Programa.: ESESB003a.p - Chamado nos programas de geraá∆o de mensagem. Ex: msg0006.p */
/* Funá∆o...: Receber o XML com a mensagem, enviar ao Barramento e                      */
/*            retornar a resposta.                                                      */
/****************************************************************************************/

CREATE WIDGET-POOL.

{esp/esb/err/err0001.i}
{esp/es0018.i}

{utp/ut-glob.i}
{esapi/esapi010tt.i}
{utp/utapi019.i}

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE VARIABLE c-emails AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE VARIABLE PostMessageResult AS CHARACTER NO-UNDO.
DEFINE VARIABLE hESB              AS HANDLE    NO-UNDO.
DEFINE VARIABLE hPort             AS HANDLE    NO-UNDO.

DEFINE INPUT  PARAMETER requisicao  AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER resposta    AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
define variable hDoc    as handle   no-undo.

def new global shared variable c-seg-usuario as char no-undo.


FOR FIRST param-global NO-LOCK:
END.

CREATE SERVER hESB.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "CANAIS":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto THEN DO:
    hESB:CONNECT(tt-prog-ponto.conteudo) NO-ERROR.
END.


IF  ERROR-STATUS:ERROR OR NOT hESB:CONNECTED() THEN DO:

    RUN pi-envia-email ("Erro na conex∆o com o barramento.").

    RUN pi-elimina-handles.
    RETURN ERROR.
    
END.
ELSE DO:
   
    RUN IMessageReceiver SET hPort ON SERVER hESB NO-ERROR.
   
    IF  ERROR-STATUS:ERROR THEN DO:
        RUN pi-elimina-handles. 
        RETURN ERROR.
    END.
    ELSE DO:
       
        RUN PostMessage IN hPort (INPUT requisicao, 
                                  INPUT '1', 
                                  INPUT '1', 
                                  OUTPUT PostMessageResult, 
                                  OUTPUT resposta) NO-ERROR.

        /**/

        IF ERROR-STATUS:ERROR THEN DO:

            RUN pi-envia-email ("").

        END.

        IF  ERROR-STATUS:ERROR THEN DO:
            RUN pi-elimina-handles.       
            RETURN ERROR.
        END.

    END.
   
END.

RUN pi-elimina-handles.   



PROCEDURE pi-elimina-handles:

    IF VALID-HANDLE (hPort) THEN 
       DELETE OBJECT hPort.

    IF VALID-HANDLE(hESB) AND hESB:CONNECTED() THEN 
       hESB:DISCONNECT().

    IF VALID-HANDLE(hESB) THEN 
       DELETE OBJECT hESB.
END.


RETURN.




PROCEDURE pi-envia-email:

    DEFINE INPUT PARAMETER p-mensagem AS CHAR NO-UNDO.


    empty temp-table tt-prog-ponto.
       
    if opsys = "unix":U then do:
        run esp/es0018p.p (input  "SPOOL-UNIX":U,
                           input  1,
                           input  0,
                           input  "":U,
                           output table tt-prog-ponto).

        for first tt-prog-ponto:
            assign c-arquivo = replace(tt-prog-ponto.conteudo, "~\":U, "/":U).
        end.

        if substring(c-arquivo, length(c-arquivo), 1) <> "/":U then
            assign c-arquivo = c-arquivo + "/":U.

        assign c-arquivo = c-arquivo + "/erro-extranet-":U .
    end.
    else do:
        run esp/es0018p.p (input  "SPOOL-WIN":U,
                           input  1,
                           input  0,
                           input  "":U,
                           output table tt-prog-ponto).

        for first tt-prog-ponto:
            assign c-arquivo = replace(tt-prog-ponto.conteudo, "/":U, "~\":U).
        end.

        if substring(c-arquivo, length(c-arquivo), 1) <> "~\":U then
            assign c-arquivo = c-arquivo + "~\":U.

        assign c-arquivo = c-arquivo + "~\erro-extranet-":U.
    end.

    ASSIGN c-arquivo = c-arquivo + "-" + c-seg-usuario + "-" +  string(YEAR(TODAY)) + "-" + string(MONTH(TODAY)) + "-" + string(DAY(TODAY)) + "-" + string(TIME) + ".xml".

    create x-document hDoc.
    hDoc:LOAD("longchar", requisicao, NO).
    hDoc:SAVE("file", c-arquivo).

    /**/

    run esp/es0018p.p (input  "esesb003a":U,
                       input  1,
                       input  0,
                       input  "":U,
                       output table tt-prog-ponto).

    ASSIGN c-emails = "".

    for EACH tt-prog-ponto:
        assign c-emails = c-emails + ";" + tt-prog-ponto.conteudo.
    end.

    IF LENGTH(c-emails) > 0 THEN DO:

        OVERLAY(c-emails, 1, 1) = "".

    END.

    IF NUM-ENTRIES(c-emails, ";") < 1 THEN
        RETURN.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail             /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail            /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                           /* Destinat†rio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"             /* Remetente          */ 
           tt-envio2.assunto           = "Erro de Integraá∆o ERP/Barramento"  /* Assunto            */
           tt-envio2.arq-anexo         = c-arquivo                                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Ocorreu um erro na Integraá∆o ERP/Barramento. " + CHR(13) + "Detalhes abaixo:" + CHR(13) + CHR(13).

    ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + p-mensagem + CHR(13).

    DO iCont = 1 TO ERROR-STATUS:NUM-MESSAGES:
        ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + string(ERROR-STATUS:GET-MESSAGE(iCont)) + CHR(13).
    END.

    EMPTY TEMP-TABLE tt-erros.
    EMPTY TEMP-TABLE tt-erro.

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    ASSIGN iCont = 0.
    
    FOR EACH tt-erros:
        CREATE tt-erro.
        ASSIGN iCont             = iCont + 1
               tt-erro.i-sequen  = iCont
               tt-erro.cd-erro   = tt-erros.cod-erro
               tt-erro.mensagem  = tt-erros.desc-erro + tt-erros.desc-arq.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

    END.

    DELETE PROCEDURE h-utapi019.

END PROCEDURE.



