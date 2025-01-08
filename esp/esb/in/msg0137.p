/********************************************************************************************/
/* Programa...: esp/esb/in/msg0137.p - Relacionamentos do Canal                             */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* Objetivo...: Atualizaá∆o Relacionamentos do Canal                                        */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0137.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0137
   DATA-RELATION FOR conteudo, msg0137 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0137r1, resultado
   DATA-RELATION FOR conteudor, msg0137r1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0137r1, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-relacto-canal FOR int-relacto-canal.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0137R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0137 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0137r1.

/* EXLUIR CLASSIFICA«√O CANAL*/
RUN pi-trata-relacionamento-canal.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006.

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem = ''
               resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.


DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-trata-relacionamento-canal:

    EMPTY TEMP-TABLE tt-erro.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
                
        /***************************************************** ELIMINA GRUPO DE CLIENTE ****************************************************/
        {esp/esb/in/msg9999.i01     "b-int-relacto-canal"
                                    " FIND FIRST b-int-relacto-canal 
                                        WHERE b-int-relacto-canal.CodigoRelacionamentoCanal = msg0137.CodigoRelacionamentoCanal EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        IF  NOT l-reg-disponivel  THEN DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Regi∆o Geogr†fica em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE DO:
                CREATE b-int-relacto-canal.
                ASSIGN b-int-relacto-canal.CodigoRelacionamentoCanal = msg0137.CodigoRelacionamentoCanal
                       b-int-relacto-canal.Nome                      = msg0137.Nome                     
                       b-int-relacto-canal.CodigoConta               = msg0137.CodigoConta              
                       b-int-relacto-canal.CodigoRepresentante       = msg0137.CodigoRepresentante      
                       b-int-relacto-canal.CodigoAssistente          = msg0137.CodigoAssistente         
                       b-int-relacto-canal.CodigoAssistenteCRM       = msg0137.CodigoAssistenteCRM      
                       b-int-relacto-canal.CodigoSupervisor          = msg0137.CodigoSupervisor         
                       b-int-relacto-canal.CodigoSupervisorEMS       = msg0137.CodigoSupervisorEMS      
                       b-int-relacto-canal.DataInicial               = date(string(msg0137.DataInicial, "99/99/9999"))
                       b-int-relacto-canal.DataFinal                 = date(string(msg0137.DataFinal, "99/99/9999"))          
                       b-int-relacto-canal.Situacao                  = msg0137.Situacao.

                FIND int-emitente NO-LOCK
                    WHERE int-emitente.cod-guid = msg0137.CodigoConta NO-ERROR.

                IF  NOT AVAIL int-emitente THEN DO:
                    RUN pi-erro (INPUT "Inclus∆o n∆o permitida. N∆o existe registro de extens∆o do emitente n∆o dispon°vel"). 
                    UNDO, RETURN "NOK".
                END.

                ASSIGN b-int-relacto-canal.cod-emitente = int-emitente.cod-emitente.

            END.
        END.
        ELSE DO: /*Registro j· existente*/

            /*Verifica sÈ È para excluir...*/
            IF  msg0137.Situacao = 1 THEN DO:

                    /* ELIMINA O REGISTRO */
                DELETE b-int-relacto-canal.

            END.
            ELSE DO: /* Alteraá∆o */
                    
                ASSIGN b-int-relacto-canal.CodigoRelacionamentoCanal = msg0137.CodigoRelacionamentoCanal
                       b-int-relacto-canal.Nome                      = msg0137.Nome                     
                       b-int-relacto-canal.CodigoConta               = msg0137.CodigoConta              
                       b-int-relacto-canal.CodigoRepresentante       = msg0137.CodigoRepresentante      
                       b-int-relacto-canal.CodigoAssistente          = msg0137.CodigoAssistente         
                       b-int-relacto-canal.CodigoAssistenteCRM       = msg0137.CodigoAssistenteCRM      
                       b-int-relacto-canal.CodigoSupervisor          = msg0137.CodigoSupervisor         
                       b-int-relacto-canal.CodigoSupervisorEMS       = msg0137.CodigoSupervisorEMS      
                       b-int-relacto-canal.DataInicial               = date(string(msg0137.DataInicial, "99/99/9999"))
                       b-int-relacto-canal.DataFinal                 = date(string(msg0137.DataFinal, "99/99/9999"))           
                       b-int-relacto-canal.Situacao                  = msg0137.Situacao.     

                    FIND int-emitente NO-LOCK
                        WHERE int-emitente.cod-guid = msg0137.CodigoConta NO-ERROR.

                    IF  NOT AVAIL int-emitente THEN DO:
                        RUN pi-erro (INPUT "Alteraá∆o n∆o permitida. N∆o existe registro de extens∆o do emitente n∆o dispon°vel"). 
                        UNDO, RETURN "NOK".
                    END.

                    ASSIGN b-int-relacto-canal.cod-emitente = int-emitente.cod-emitente.
            END.

        END.

    END.

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
