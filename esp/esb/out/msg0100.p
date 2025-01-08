CREATE WIDGET-POOL.

{esp/esb/out/msg0100.i}
{utp/ut-glob.i}

DEFINE INPUT  PARAM p-conta AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR ProdutoItem.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-codigo-classificacao AS CHARACTER   NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0100
   DATA-RELATION FOR conteudo, msg0100          RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0100r, resultado, ProdutosItens, ProdutoItem
   DATA-RELATION FOR conteudor, msg0100r        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0100r, ProdutosItens    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutosItens, ProdutoItem RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0100r, resultado        RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0100"
       cabecalho.LoginUsuario      = c-seg-usuario
       cabecalho.NumeroOperacao    = p-conta.
FIND int-emitente
     WHERE int-emitente.cod-guid = p-conta
     NO-LOCK NO-ERROR.
ASSIGN c-codigo-classificacao = "".
IF AVAIL int-emitente THEN DO:
    FIND emitente
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
       FIND FIRST gr-cli-class-canal NO-LOCK
            WHERE gr-cli-class-canal.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

        IF AVAIL gr-cli-class-canal THEN DO:
            ASSIGN c-codigo-classificacao = gr-cli-class-canal.codigo-classificacao.
        END.
    END.
END.
CREATE conteudo.
CREATE msg0100.
ASSIGN msg0100.Conta          = p-conta
       msg0100.Classificacao  = c-codigo-classificacao
       msg0100.Bloqueado      = NO
       msg0100.Exclusivo      = NO.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

FIND FIRST resultado NO-ERROR.
IF  AVAIL resultado
AND resultado.sucesso = YES THEN DO:
    RETURN "OK":U.
END.
ELSE DO:
    RETURN "NOK":U.
END.

RETURN.
