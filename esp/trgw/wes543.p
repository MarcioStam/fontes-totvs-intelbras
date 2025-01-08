TRIGGER PROCEDURE FOR WRITE OF crm-relacionamento-cliente.

/********************************************************************************
** UPC........: wes543.p - UPC WRITE crm-relacionamento-cliente
** Data.......: Setembro / 2010
** Objetivo...: Repassa inclusäes e modifica‡äes das atendentes para o CRM
********************************************************************************/
    DEFINE VARIABLE cDestino        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-mail          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAssunto        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cRemetente      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDescEmail      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cArqEmail       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE C-ALTERACAO AS char format "x(35)" no-undo initial ''.

DEF temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF VAR l-enviar-email AS LOG INIT YES NO-UNDO.
DEF VAR i-cont         AS INT.

{esp/esb/esesb000.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i} 

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-crm-relacionamento-cliente LIKE crm-relacionamento-cliente
     FIELD situacao AS INTEGER.

CREATE tt-crm-relacionamento-cliente.
BUFFER-COPY crm-relacionamento-cliente TO tt-crm-relacionamento-cliente.
ASSIGN tt-crm-relacionamento-cliente.situacao = 0. /* Manuten‡Æo */

RAW-TRANSFER tt-crm-relacionamento-cliente TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0194", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

IF AVAIL crm-relacionamento-cliente THEN DO:
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = crm-relacionamento-cliente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
       RUN esp/wso/eswso0008.p (INPUT emitente.cod-emitente).
    
    END.
END.

IF NEW(crm-relacionamento-cliente) THEN DO:
   RUN pi-envia-email.
END.

RETURN "OK".


/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

IF  l-web-service = NO THEN DO:

    RUN esp/crm/escrm001a.p (INPUT "Crm-relacionamento-Cliente",
                             INPUT "W",
                             INPUT ROWID(crm-relacionamento-cliente),
                             INPUT TABLE tt-raw-transfer).
END.
*/


PROCEDURE pi-envia-email.

    FOR FIRST ponto-programa NO-LOCK
      WHERE ponto-programa.nome-programa = "escdp036"
        AND ponto-programa.ponto         = 4:

     FOR EACH conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
          IF  c-mail = "" THEN
              c-mail = conteudo-programa.conteudo .
          ELSE
              c-mail = c-mail + "," + conteudo-programa.conteudo .
      END.
  END.

  FIND FIRST emitente 
       WHERE emitente.cod-emitente = crm-relacionamento-cliente.cod-emitente NO-LOCK NO-ERROR.
  
  ASSIGN cDescEmail = "Altera‡Æo de Excecutivo no Cliente: " + string(crm-relacionamento-cliente.cod-emitente) +
                      " Nome: " + STRING(crm-relacionamento-cliente.cod-emitente) + ' ' + emitente.nome-emit +
                      " Executivo: " + string(crm-relacionamento-cliente.cod-rep) +
                      " Usuario: " + v_cod_usuar_corren +
                      " Data: " + STRING(TODAY,"99/99/9999") +
                      " Hora: " + STRING(TIME,"HH:MM:ss")
           cDestino = c-mail
           cAssunto = "Altera‡Æo de executivo no Cliente" 
           cRemetente = "integra@intelbras.com.br".
  
   RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = 'ems@intelbras.com.br'
           tt-envio2.destino     = c-mail
           tt-envio2.assunto     = "Alera‡Æo de executivo no Cliente " + string(emitente.cod-emitente)
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".


    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "             Novo Executivo Cadastrado            " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Cliente: " + string(emitente.cod-emitente) + ' ' + emitente.nome-emit + CHR(13) +
                                      "Executivo: " + string(crm-relacionamento-cliente.cod-rep)   + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

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
                ASSIGN i-cont = i-cont + 1
                       tt-erro.i-sequen = i-cont
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

