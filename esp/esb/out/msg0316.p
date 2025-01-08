CREATE WIDGET-POOL.

{esp/esb/out/msg0316.i}
{utp/ut-glob.i}

DEFINE INPUT  PARAM p-cliente LIKE emitente.cod-emit NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR msg0316r1.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEF VAR c-cnpj  LIKE emitente.cgc NO-UNDO.
DEF VAR i-canal LIKE int-emitente.cod-gr-cob NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0316
   DATA-RELATION FOR conteudo, msg0316          RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0316r1, resultado
   DATA-RELATION FOR conteudor, msg0316r1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0316r1, resultado       RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = /*"DBFC273E-4811-40C4-8A4E-1629731ADD9A"*/ "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0316"
       cabecalho.LoginUsuario      = c-seg-usuario
       cabecalho.NumeroOperacao    = string(p-cliente).

/*MESSAGE "msg0316 - 1" VIEW-AS ALERT-BOX.*/

FIND FIRST emitente
    WHERE emitente.cod-emit = p-cliente NO-LOCK NO-ERROR.

IF  AVAIL emitente THEN DO:
    /*MESSAGE "msg0316 - 2" VIEW-AS ALERT-BOX.*/

    FIND int-emitente
         WHERE int-emitente.cod-emitente = emitente.cod-emit NO-LOCK NO-ERROR.
    
    IF  AVAIL int-emitente THEN
        ASSIGN i-canal = int-emitente.cod-gr-cob
               c-cnpj  = emitente.cgc.
END.

/*MESSAGE "msg0316 - 3" VIEW-AS ALERT-BOX.*/

CREATE conteudo.
CREATE msg0316.
ASSIGN msg0316.CpfCnpjCodEstrangeiro = c-cnpj
       msg0316.CodigoGrupoCobranca   = i-canal.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

FIND FIRST resultado NO-ERROR.

IF  AVAIL resultado THEN DO:
    IF  resultado.sucesso = YES THEN DO:
        /*MESSAGE "msg0316 - 4" VIEW-AS ALERT-BOX.*/
    
        RETURN "OK":U.
    END.
    ELSE DO:
        /*MESSAGE "msg0316 - 5 - resultado.sucesso " resultado.Sucesso SKIP
            resultado.CodigoErro SKIP
            resultado.Mensagem VIEW-AS ALERT-BOX.*/

        RETURN "NOK":U.
    END.
END.

RETURN.
