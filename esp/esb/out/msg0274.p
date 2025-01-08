/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0274 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0274
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD CodigoARB        AS CHAR
    FIELD NomeSolicitacao  AS CHAR
    FIELD ValorSolicitacao AS DEC.

{esp/esb/esesb000.i}
{esp/esb/out/msg0274.i}.

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0274
   DATA-RELATION FOR conteudo, msg0274 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0274r, resultado
   DATA-RELATION FOR conteudor, msg0274r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0274r, resultado RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0274'.
     
CREATE conteudo.
CREATE msg0274.

FOR FIRST tt-param:
    ASSIGN msg0274.CodigoARB        = tt-param.CodigoARB       
           msg0274.NomeSolicitacao  = tt-param.NomeSolicitacao      
           msg0274.ValorSolicitacao = tt-param.ValorSolicitacao
           cabecalho.NumeroOperacao = msg0274.CodigoARB.
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

FIND FIRST resultado NO-ERROR.

RETURN.
