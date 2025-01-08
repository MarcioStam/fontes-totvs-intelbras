/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0271 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0271
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD DataInicio         AS DATE
    FIELD DataFim            AS DATE
    FIELD StatusSolicitacao  AS CHAR
    FIELD StatusDespesa      AS CHAR
    FIELD TipoData           AS CHAR.

{esp/esb/esesb000.i}
{esp/esb/out/msg0271.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR ItemSolicitacaoAdiantamento.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0271
   DATA-RELATION FOR conteudo, msg0271 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0271r, ListaSolicitacaoAdiantamento, ItemSolicitacaoAdiantamento, resultado
   DATA-RELATION FOR conteudor, msg0271r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0271r, ListaSolicitacaoAdiantamento RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaSolicitacaoAdiantamento, ItemSolicitacaoAdiantamento RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0271r, resultado RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0271'.
     
CREATE conteudo.
CREATE msg0271.

FOR FIRST tt-param:
    ASSIGN msg0271.DataInicio        = tt-param.DataInicio       
           msg0271.DataFim           = tt-param.DataFim          
           msg0271.StatusSolicitacao = tt-param.StatusSolicitacao
           msg0271.StatusDespesa     = tt-param.StatusDespesa    
           msg0271.TipoData          = tt-param.TipoData          
           cabecalho.NumeroOperacao  = STRING(msg0271.DataInicio) + " " + STRING(msg0271.DataFim).
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
