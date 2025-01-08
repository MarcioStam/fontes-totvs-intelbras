log-manager:WRITE-MESSAGE ("inicio msg0313").

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/*
define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", iXML, NO).
hDoc:SAVE("file","/mnt/spool/an052677/msg0313.xml").
*/

DEF VAR v_log_grupo_cob AS LOG NO-UNDO.

{esp/es0018.i}
{cdp/cd0666.i}
{utp/ut-glob.i}
{esp/esb/in/msg0313.i}

EMPTY TEMP-TABLE msg0313.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0313
   DATA-RELATION FOR conteudo, msg0313 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0313r, resultado
   DATA-RELATION FOR conteudor, msg0313r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0313r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND FIRST msg0313 NO-ERROR.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

IF  AVAIL msg0313 THEN
    log-manager:WRITE-MESSAGE ("avail msg0313 - gr econ: " + STRING(msg0313.CodigoGrupoEconomico) + " cnpj: " + string(msg0313.CpfCnpjCodEstrangeiro)). 
ELSE
    log-manager:WRITE-MESSAGE ("not avail msg0313").

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0313R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE msg0313r.

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

    IF  msg0313.CodigoGrupoEconomico <> "" THEN DO:

        /*IF  OPSYS = 'UNIX' THEN DO:
            OUTPUT TO "/mnt/spool/an052677/log_deps_sales.txt" APPEND.
            PUT UNFORMATTED "1 - msg0313" SKIP.
            OUTPUT CLOSE.                                
        END.*/

        FIND FIRST emitente
            WHERE emitente.nome-abrev = msg0313.CodigoGrupoEconomico NO-LOCK NO-ERROR.
    
        IF  NOT AVAIL emitente THEN
            RUN pi-erro (INPUT "Emitente n∆o encontrado para o grupo econìmico " + msg0313.CodigoGrupoEconomico + " !").
    
        IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "dps-limite", /* grupos tratados para pedidos */
                               INPUT 1,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

            IF  AVAIL tt-prog-ponto 
            AND tt-prog-ponto.conteudo = "MATRIZ" THEN DO:
                FIND FIRST emitente
                    WHERE emitente.nome-abrev = msg0313.CodigoGrupoEconomico EXCLUSIVE-LOCK NO-ERROR.

                IF  AVAIL emitente THEN DO:
                    log-manager:WRITE-MESSAGE ("msg0313 - atualiza limite por grupo - APENAS MATRIZ - cod emit: " + STRING(emitente.cod-emit) + " matriz: " + emitente.nome-matriz + " Vl limite: " + STRING(msg0313.LimiteAdotado)).

                    RUN pi_trata_limite.
                END.
            END.
            ELSE DO:
                FOR EACH emitente
                    WHERE emitente.nome-matriz = msg0313.CodigoGrupoEconomico EXCLUSIVE-LOCK:
            
                    log-manager:WRITE-MESSAGE ("msg0313 - atualiza limite por grupo - cod emit: " + STRING(emitente.cod-emit) + " matriz: " + emitente.nome-matriz + " Vl limite: " + STRING(msg0313.LimiteAdotado)).
    
                    RUN pi_trata_limite.
                END.
            END.
        END.
    END.
    
    IF  msg0313.CpfCnpjCodEstrangeiro <> "" THEN DO:

        FIND FIRST emitente
            WHERE emitente.cgc = msg0313.CpfCnpjCodEstrangeiro EXCLUSIVE-LOCK NO-ERROR.
    
        IF  NOT AVAIL emitente THEN
            RUN pi-erro (INPUT "Emitente n∆o encontrado com CNPJ " + msg0313.CpfCnpjCodEstrangeiro + " !").
    
        IF  NOT CAN-FIND (FIRST tt-erro) THEN DO:
            log-manager:WRITE-MESSAGE ("msg0313 - atualiza limite por cliente - cod emit: " + STRING(emitente.cod-emit) + " Vl limite: " + STRING(msg0313.LimiteAdotado)).

            RUN pi_trata_limite.
        END.
    END.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    
    FOR EACH tt-erro:
        IF  tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".

        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).
RETURN.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE pi_trata_limite:
    
    FIND FIRST int-emitente
        WHERE int-emitente.cod-emit = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF  AVAIL int-emitente THEN DO:

        ASSIGN v_log_grupo_cob = NO.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "dps-canal-vd", /* grupos tratados para pedidos */
                           INPUT 1,              /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF  CAN-FIND (FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN
            ASSIGN v_log_grupo_cob = YES.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "dp3-canal-vd", /* Nome do programa */
                           INPUT 1,         /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF  CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

            log-manager:WRITE-MESSAGE ("2 b - andrey").

            IF  v_log_grupo_cob = YES THEN DO:

                ASSIGN emitente.ind-lib-estoque   = YES
                       emitente.user-libcre       = "DEPS"
                       emitente.ind-aval          = 1
                       emitente.ind-aval-embarque = 2.

                IF  msg0313.LimiteAdotado > 0 THEN DO:

                    log-manager:WRITE-MESSAGE ("3.1 - grava limite e status de credito normal").

                    ASSIGN emitente.ind-cre-cli = 1
                           emitente.lim-credito = msg0313.LimiteAdotado              
                           emitente.dt-lim-cred = msg0313.DataValidade.
                END.
                ELSE DO:

                    log-manager:WRITE-MESSAGE ("4.1 - ttt status de credito suspenso").

                    ASSIGN emitente.ind-cre-cli = 5
                           emitente.lim-credito = msg0313.LimiteAdotado.
                           emitente.dt-lim-cred = ?.
                END.
            END.
            ELSE DO:

                IF  msg0313.LimiteAdotado > 0 THEN DO:

                    log-manager:WRITE-MESSAGE ("3.2 - grava limite e status de credito normal").

                    ASSIGN emitente.lim-credito = msg0313.LimiteAdotado              
                           emitente.dt-lim-cred = msg0313.DataValidade.
                END.
                ELSE DO:

                    log-manager:WRITE-MESSAGE ("4.2 - ttt status de credito suspenso").

                    ASSIGN emitente.lim-credito = msg0313.LimiteAdotado.
                           emitente.dt-lim-cred = ?.
                END.
            END.
        END.
    END.

END PROCEDURE.
