CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0161.i}


DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0161
   DATA-RELATION FOR conteudo, msg0161 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0161r, resultado
   DATA-RELATION FOR conteudor, msg0161r    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0161r, resultado    RELATION-FIELDS (idm, idm) NESTED.

FIND msg0161.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor .
ASSIGN cabecalhor.CodigoMensagem = 'MSG0161R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0161r.

FIND repres NO-LOCK
   WHERE repres.cod-rep = INT(msg0161.CodigoRepresentante) NO-ERROR.

IF NOT AVAILABLE repres THEN DO:
   RUN pi-erro (INPUT "Representante n∆o cadastrado!").
   ASSIGN msg0161r.RepresentanteValido = 0.
END.
ELSE DO:
    ASSIGN msg0161r.RepresentanteValido = 1.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = YES
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

return.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
