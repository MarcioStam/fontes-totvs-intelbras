CREATE WIDGET-POOL.

{esp/esb/out/msg0101.i}
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

DEFINE INPUT  PARAM p-conta AS CHAR.
DEFINE INPUT  PARAM TABLE FOR tt-itens.
DEFINE OUTPUT PARAM TABLE FOR ProdutoItemR.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0101, ProdutosItens, ProdutoItem
   DATA-RELATION FOR conteudo, msg0101          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0101, ProdutosItens     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutosItens, ProdutoItem RELATION-FIELDS (idm, idm) NESTED
   .

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0101r, resultado, ProdutosItensR, ProdutoItemR
   DATA-RELATION FOR conteudor, msg0101r          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0101r, ProdutosItensR     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutosItensR, ProdutoItemR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0101r, resultado          RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0101"
       cabecalho.LoginUsuario      = c-seg-usuario
       cabecalho.NumeroOperacao    = p-conta.

CREATE conteudo.
CREATE msg0101.
ASSIGN msg0101.Conta = p-conta.
CREATE ProdutosItens.

FOR EACH tt-itens:
    CREATE ProdutoItem.
    ASSIGN ProdutoItem.CodigoProduto           = tt-itens.it-codigo
           ProdutoItem.Moeda                   = "Real":U
           ProdutoItem.Quantidade              = tt-itens.de-quantidade
           ProdutoItem.TipoPortfolio           = tt-itens.TipoPortfolio        
           ProdutoItem.CodigoUnidadeNegocio    = tt-itens.CodigoUnidadeNegocio 
           ProdutoItem.CodigoFamiliaComercial  = tt-itens.CodigoFamiliaComercial
           ProdutoItem.CodigoEstabelecimento   = tt-itens.CodigoEstabelecimento.
END.


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
