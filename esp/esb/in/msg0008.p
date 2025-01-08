
/********************************************************************************************/
/* Programa...: esp/esb/in/msg0014.p - REGISTRA_CLASSIFICAÄ«O CANAL                         */
/* Altor......: Gustavo Eckel                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver um cadastro ou atualizaá∆o                   */
/*              de Regiao Geografica.                                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0008.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0008
   DATA-RELATION FOR conteudo, msg0008 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0008r, resultado
   DATA-RELATION FOR conteudor, msg0008r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0008r, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-regiao-geografica FOR int-regiao-geografica.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0008R'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0008 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0008r.

/* CRIAÄ«O DA CLASSIFICAÄ«O */
RUN pi-regiao-geografica.

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

PROCEDURE pi-regiao-geografica:

    EMPTY TEMP-TABLE tt-erro.

    /* N∆o pode ser criado com 0 */
    IF  msg0008.CodigoRegiaoGeografica = "" THEN DO:
          RUN pi-erro (INPUT "C¢digo da Regi∆o Geogr†fica deve ser diferente de 0 (zero) ou Branco").
          RETURN "NOK".
    END.

    IF  msg0008.Nome = "" THEN DO:
          RUN pi-erro (INPUT 'Nome da Regi∆o Geogr†fica n∆o foi informado').
          RETURN "NOK".
    END.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:

        {esp/esb/in/msg9999.i01     "b-int-regiao-geografica"
                                    " FIND FIRST b-int-regiao-geografica 
                                        WHERE b-int-regiao-geografica.cod-regiao = msg0008.CodigoRegiaoGeografica EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /*************************** CRIAÄ«O GRUPO CLIENTE **************************/
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE int-regiao-geografica.
            ASSIGN int-regiao-geografica.cod-regiao   = msg0008.CodigoRegiaoGeografica
                   int-regiao-geografica.nome         = msg0008.nome
                   int-regiao-geografica.ind-situacao = msg0008.Situacao.

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Classificaá∆o Canal em uso por outro Usu†rio. Tente novamente em alguns inst antes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE
                /* Est† Dispon°vel para atualizaá∆o */
                ASSIGN b-int-regiao-geografica.nome         = msg0008.nome                    
                       b-int-regiao-geografica.ind-situacao = msg0008.Situacao.                              

        END.

        RELEASE b-int-regiao-geografica NO-ERROR.

    END. /* TRANZAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

