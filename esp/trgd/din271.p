/********************************************************************************
 ** UPC........: din271.p - UPC DELETE ord-prod
 ** Data.......: 
 ** Objetivo...: 
 ********************************************************************************/
 
{utp/ut-glob.i}
{esp/es0018.i}
{utp/utapi019.i}

DEFINE NEW GLOBAL SHARED VARIABLE c-nome-prog-elimina-op AS CHAR NO-UNDO.

DEF PARAM BUFFER b-ord-prod      FOR ord-prod.

DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2.

IF c-nome-prog-elimina-op = "upc/cp0301-upc.p" 
THEN DO:

    RUN pi-envia-mail.

END.

PROCEDURE pi-envia-mail:

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.
    DEF VAR c-emails      AS CHAR NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    RUN esp/es0018p.p (INPUT  "DIN271":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN c-emails = "".

    FOR EACH tt-prog-ponto:
        ASSIGN c-emails = c-emails + tt-prog-ponto.conteudo + ",".
    END.

    IF c-emails <> "" 
    THEN DO:
       RUN utp/utapi019.p PERSISTENT SET h-utapi019.
       
       FOR EACH tt-envio2.   DELETE tt-envio2.   END.
       FOR EACH tt-mensagem. DELETE tt-mensagem. END.
       
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
              tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
              tt-envio2.destino           = c-emails                             /* Destinatòrio       */ 
              tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
              tt-envio2.assunto           = "Eliminacao Ordem Producao " + STRING(b-ord-prod.nr-ord-produ) /* Assunto            */
              tt-envio2.formato           = "TEXTO".
       
       FIND usuar_mestre WHERE
            usuar_mestre.cod_usuario = c-seg-usuario 
            NO-LOCK NO-ERROR.
       ASSIGN c-corpo-email = "Eliminacao OP: " 
                            + STRING(b-ord-prod.nr-ord-produ) 
                            + CHR(13)
                            + "Usuario: " 
                            + c-seg-usuario
                            + " - "
                            + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".
       
       CREATE tt-mensagem.
       ASSIGN tt-mensagem.seq-mensagem = 1
              tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */
       
       RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                      INPUT  TABLE tt-mensagem,
                                      OUTPUT TABLE tt-erros).
       
       IF VALID-HANDLE(h-utapi019) THEN
           DELETE PROCEDURE h-utapi019.
    END.
END.

/* Emerson - Log n∆o Ç mais necessario
DEF VAR v_cod_arq_erro AS CHAR NO-UNDO.
DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2. 
DEFINE VARIABLE plist AS CHARACTER NO-UNDO FORMAT "x(70)".
DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

ASSIGN v_cod_arq_erro = c-dir + "/usr8/spool/em043280/ordprod/excluiOP.txt":U.

OUTPUT TO VALUE(v_cod_arq_erro) APPEND.

PUT "OP :" b-ord-prod.nr-ord-produ skip
    "Item :" b-ord-prod.it-codigo  SKIP
    "QtdOP :" b-ord-prod.qt-ordem  SKIP
    "Usuario :" v_cod_usuar_corren SKIP.

FORM plist  WITH FRAME what-prog OVERLAY ROW 10 CENTERED 5 DOWN NO-LABELS  TITLE " Program Trace ". 

DO WHILE PROGRAM-NAME(ix) <> ?:  
    IF ix = 2 THEN     
    plist = "Currently in       : " + PROGRAM-NAME(ix).  
    ELSE     plist = "Which was called by: " + PROGRAM-NAME(ix).   
    ix = ix + 1.  
    PUT plist SKIP.
END. 
PUT SKIP(2).

OUTPUT CLOSE.
*/

RETURN "OK".
