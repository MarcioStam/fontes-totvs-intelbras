/********************************************************************************************/
/* Programa...: esp/esb/in/msg0014.p - REMOVE_CLASSIFICAÄ«O CANAL                           */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver ELIMINAÄ«O do cadastro                       */
/*              de uma Classificaá∆o de Canal  (grupo de cliente).                          */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0015.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0015
   DATA-RELATION FOR conteudo, msg0015 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0015r, resultado
   DATA-RELATION FOR conteudor, msg0015r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0015r, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-class-canal FOR int-class-canal.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor to cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'msg0015R'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0015 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0015r.

/* EXLUIR CLASSIFICAÄ«O CANAL*/
RUN pi-EXCLUI-grupo-cliente.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.

    RETURN "NOK".
END.

IF  resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-EXCLUI-grupo-cliente:

    EMPTY TEMP-TABLE tt-erro.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
                
        /***************************************************** ELIMINA GRUPO DE CLIENTE ****************************************************/
        {esp/esb/in/msg9999.i01     "b-int-class-canal"
                                    " FIND FIRST b-int-class-canal 
                                        WHERE b-int-class-canal.codigo-classificacao = msg0015.CodigoClassificacao EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        IF  NOT l-reg-disponivel  THEN DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Classificaá∆o Canal em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE DO:
                RUN pi-erro (INPUT "Registro Classificaá∆o Canal n∆o cadastrado."). 
                UNDO, RETURN "NOK".
            END.
        END.

        /* ELIMINA O REGISTRO */
        DELETE b-int-class-canal.

    END.

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
