/********************************************************************************************/
/* Programa...: esp/esb/in/msg0018.p - REGISTRA_CATEGORIA                                   */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 24/06/2014                                                                  */ 
/* Objetivo...: Mensagem criaá∆o/alteraá∆o Categoria (CRM)                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0018.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0018
   DATA-RELATION FOR conteudo, msg0018 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0018R1, resultado
   DATA-RELATION FOR conteudor, MSG0018R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0018R1, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-categoria FOR int-categoria.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0018R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0018 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE MSG0018R1.

/* CRIAÄ«O DA CLASSIFICAÄ«O */
RUN pi-categoria.

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

PROCEDURE pi-categoria:

    EMPTY TEMP-TABLE tt-erro.

    /* N∆o pode ser criado com 0 */
    IF  msg0018.CodigoCategoria = "" THEN DO:
          RUN pi-erro (INPUT "Identificador £nico CRM da Categoria n∆o est† preenchido.").
          RETURN "NOK".
    END.

    IF  msg0018.Nome = "" THEN DO:
          RUN pi-erro (INPUT 'Nome da Categoria n∆o foi informado').
          RETURN "NOK".
    END.

    IF  msg0018.Codigo = "" THEN DO:
          RUN pi-erro (INPUT 'C¢digo da Categoria n∆o foi informado').
          RETURN "NOK".
    END.


    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:

        {esp/esb/in/msg9999.i01     "b-int-categoria"
                                    " FIND FIRST b-int-categoria 
                                        WHERE b-int-categoria.guid-categoria = msg0018.CodigoCategoria EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /*************************** CATEGORIA **************************/
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE int-categoria.
            ASSIGN int-categoria.GUID-categoria = msg0018.CodigoCategoria
                   int-categoria.nome           = msg0018.nome
                   int-categoria.codigo         = msg0018.codigo
                   int-categoria.ind-situacao   = msg0018.Situacao.

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Categoria em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE
                /* Est† Dispon°vel para atualizaá∆o */
                ASSIGN b-int-categoria.nome         = msg0018.nome    
                       b-int-categoria.codigo       = msg0018.Codigo
                       b-int-categoria.ind-situacao = msg0018.Situacao.                              

        END.

        RELEASE b-int-categoria NO-ERROR.

    END. /* TRANZAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

