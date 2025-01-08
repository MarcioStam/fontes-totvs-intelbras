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

{esp/esb/in/msg0017.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0017
   DATA-RELATION FOR conteudo, msg0017 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0017r, resultado
   DATA-RELATION FOR conteudor, msg0017r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0017r, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-subclass-canal FOR int-subclass-canal.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'msg0017R'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0017 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0017r.

/* EXLUIR CLASSIFICAÄ«O CANAL*/
RUN pi-EXCLUI-grupo-cliente.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006.

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.


DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-EXCLUI-grupo-cliente:

    EMPTY TEMP-TABLE tt-erro.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
                
        /***************************************************** ELIMINA GRUPO DE CLIENTE ****************************************************/
        {esp/esb/in/msg9999.i01     "b-int-subclass-canal"
                                    " FIND FIRST b-int-subclass-canal 
                                        WHERE b-int-subclass-canal.codigo-subclassificacao = msg0017.CodigoSubClassificacao EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
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
        DELETE b-int-subclass-canal.

    END.

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
