CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

/*
DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.

ASSIGN iXML = "<?xml version='1.0' encoding='ISO-8859-1' ?>
<MENSAGEM xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
    <CABECALHO>
        <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor>
        <NumeroOperacao>MSG0174</NumeroOperacao>
        <CodigoMensagem>MSG0174</CodigoMensagem>
        <LoginUsuario />
    </CABECALHO>
    <CONTEUDO>
        <MSG0174>
            <CodigoProduto>1994376</CodigoProduto>
            <QuantidadeSolicitada>5</QuantidadeSolicitada>
        </MSG0174>
    </CONTEUDO>
</MENSAGEM>".
*/

{esp/esb/in/msg0174.i}
{esapi/esapi023.i}     /*ttItem*/
{cdp/cd0666.i}         /*tt-erro*/

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0174
   DATA-RELATION FOR conteudo, MSG0174                   RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0174R1, MSG_Mac_R1, resultado
   DATA-RELATION FOR conteudor, MSG0174R1  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0174R1, MSG_Mac_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0174R1, resultado  RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0174R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0174 NO-ERROR.

CREATE conteudor.
CREATE MSG0174R1.
CREATE resultado.

RUN pi-gera-mac.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/*
DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
*/

RETURN.

PROCEDURE pi-gera-mac:
    DEFINE VARIABLE h-api023 AS HANDLE NO-UNDO.

    IF MSG0174.QuantidadeSolicitada = 0  THEN DO:
        RUN pi-erro("Quantidade Item deve ser informada.").
        RETURN "NOK".
    END.

    IF NOT CAN-FIND(FIRST item WHERE item.it-codigo = MSG0174.CodigoProduto) THEN DO:
        RUN pi-erro("O c¢digo do item informado ‚ inv lido.").
        RETURN "NOK".
    END.

    CREATE ttItem.
    ASSIGN ttItem.it-codigo = MSG0174.CodigoProduto
           ttitem.marcado   = YES
           ttItem.qt-pedido = MSG0174.QuantidadeSolicitada.

    RUN esapi/esapi023.p PERSISTENT SET h-api023.

    RUN piExecGeraMac IN h-api023 (INPUT  NO,
                                   INPUT  0,
                                   INPUT  TABLE ttItem,
                                   OUTPUT TABLE tt-mac-address,
                                   OUTPUT TABLE tt-erro).

    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK".

    FOR EACH tt-mac-address BY sequencia:
        CREATE MSG_Mac_R1.
        ASSIGN MSG_Mac_R1.CodigoMacAddress = tt-mac-address.mac.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
