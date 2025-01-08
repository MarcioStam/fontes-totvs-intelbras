CREATE WIDGET-POOL.

{esp/esb/esesb000.i}
{esp/esb/out/msg0312.i}
{utp/ut-glob.i}

DEFINE INPUT  PARAM p-cliente LIKE emitente.cod-emit NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR msg0312r1-DadosCliente.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEF VAR c-cnpj  LIKE emitente.cgc NO-UNDO.
DEF VAR i-canal LIKE int-emitente.cod-gr-cob NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0312
   DATA-RELATION FOR conteudo, msg0312          RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0312r1, msg0312r1-DadosCliente, resultado
   DATA-RELATION FOR conteudor, msg0312r1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0312r1, resultado       RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0312"
       cabecalho.LoginUsuario      = c-seg-usuario
       cabecalho.NumeroOperacao    = string(p-cliente).

FIND FIRST emitente
    WHERE emitente.cod-emit = p-cliente NO-LOCK NO-ERROR.

IF  AVAIL emitente THEN DO:

    FIND int-emitente
         WHERE int-emitente.cod-emitente = emitente.cod-emit NO-LOCK NO-ERROR.
    
    IF  AVAIL int-emitente THEN
        ASSIGN i-canal = int-emitente.cod-gr-cob
               c-cnpj  = emitente.cgc.
END.

CREATE conteudo.
CREATE msg0312.
ASSIGN msg0312.CpfCnpjCodEstrangeiro = c-cnpj
       msg0312.CodigoGrupoCobranca   = i-canal.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

FIND FIRST resultado NO-ERROR.

IF  AVAIL resultado THEN DO:
    IF  resultado.sucesso = YES THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.
END.

RETURN.
