/********************************************************************************************/
/* Programa...: esp/esb/in/msg0014.p - REGISTRA_CLASSIFICAÄ«O CANAL                         */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver um cadastro ou atualizaá∆o                   */
/*              de Classificaá∆o de Canal.                                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0014.i}
{esp/esb/in/msg9999.i}

    
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0014
   DATA-RELATION FOR conteudo, msg0014 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0014r, resultado
   DATA-RELATION FOR conteudor, msg0014r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0014r, resultado RELATION-FIELDS (idm, idm) NESTED.    

DEF BUFFER b-int-class-canal FOR int-class-canal.    

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0014R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0014 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0014r.

/* CRIAÄ«O DA CLASSIFICAÄ«O */
RUN pi-classificacao.

IF  RETURN-VALUE = "NOK" THEN DO:
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
    IF  msg0014.CodigoClassificacao = "" THEN DO:
          RUN pi-erro (INPUT "C¢digo da Classificaá∆o deve ser diferente de 0 (zero) ou Brancos " ).
          RETURN "NOK".
    END.

    IF  msg0014.Nome = "" THEN DO:
          RUN pi-erro (INPUT 'Nome da Classificaáao n∆o foi informado').
          RETURN "NOK".
    END.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:        

        {esp/esb/in/msg9999.i01     "b-int-class-canal"
                                    " FIND FIRST b-int-class-canal 
                                        WHERE b-int-class-canal.codigo-classificacao = msg0014.CodigoClassificacao EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

                /*************************** CRIAÄ«O GRUPO CLIENTE **************************/
        
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
        
            CREATE int-class-canal.
            ASSIGN int-class-canal.codigo-classificacao = msg0014.CodigoClassificacao
                   int-class-canal.nome                 = msg0014.nome
                   int-class-canal.log-pertence-canais  = msg0014.PertenceProgramaCanais 
                   int-class-canal.situacao             = msg0014.Situacao.

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                
                RUN pi-erro (INPUT "Registro Classificaá∆o Canal em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE
                /* Est† Dispon°vel para atualizaá∆o */
                ASSIGN b-int-class-canal.nome                = msg0014.nome                    
                       b-int-class-canal.log-pertence-canais = msg0014.PertenceProgramaCanais  
                       b-int-class-canal.situacao            = msg0014.Situacao.                              

        END.

        RELEASE b-int-class-canal NO-ERROR.

    END. /* TRANZAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
