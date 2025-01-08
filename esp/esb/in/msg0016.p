/********************************************************************************************/
/* Programa...: esp/esb/in/msg0016.p - REGISTRA_SUBCLASSIFICAÄ«O CANAL                         */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 04/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver um cadastro ou atualizaá∆o                   */
/*              de Classificaá∆o de Canal.                                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0016.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0016
   DATA-RELATION FOR conteudo, msg0016 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0016r, resultado
   DATA-RELATION FOR conteudor, msg0016r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0016r, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-subclass-canal FOR int-subclass-canal.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0016R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0016 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0016r.

/* CRIAÄ«O DA CLASSIFICAÄ«O */
RUN pi-classificacao.

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

IF resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-classificacao:

    EMPTY TEMP-TABLE tt-erro.

    /* N∆o pode ser criado com 0 */
    IF  msg0016.CodigoSubClassificacao = "" THEN DO:
          RUN pi-erro (INPUT "C¢digo de SubClassificaá∆o deve ser diferente de 0 (zero) ou Brancos " ).
          RETURN "NOK".
    END.

    IF  msg0016.Nome = "" THEN DO:
          RUN pi-erro (INPUT 'Nome da SubClassificaá∆o n∆o foi informado').
          RETURN "NOK".
    END.

    /* Verifica se existe Classificaá∆o (tabela pai) */
    IF  NOT CAN-FIND (int-class-canal 
                         WHERE int-class-canal.codigo-classificacao = msg0016.classificacao) THEN DO:

        RUN pi-erro (INPUT 'C¢digo da Classificaá∆o para Subclassificaá∆o n∆o cadastrada').
        RETURN "NOK".
    END.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
                

        {esp/esb/in/msg9999.i01     "b-int-subclass-canal"
                                    " FIND FIRST b-int-subclass-canal 
                                        WHERE b-int-subclass-canal.codigo-subclassificacao = msg0016.CodigoSubClassificacao EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /*************************** CRIAÄ«O GRUPO CLIENTE **************************/
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE int-subclass-canal.
            ASSIGN int-subclass-canal.codigo-subclassificacao = msg0016.CodigoSubClassificacao
                   int-subclass-canal.nome                    = msg0016.nome
                   int-subclass-canal.codigo-classificacao    = msg0016.classificacao 
                   int-subclass-canal.situacao                = msg0016.Situacao.

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro SubClassificaá∆o Canal em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE
                /* Est† Dispon°vel para atualizaá∆o */
                ASSIGN b-int-subclass-canal.nome                 = msg0016.nome                    
                       b-int-subclass-canal.codigo-classificacao = msg0016.classificacao  
                       b-int-subclass-canal.situacao             = msg0016.Situacao.                              

        END.

        RELEASE b-int-subclass-canal NO-ERROR.

    END. /* TRANZAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
