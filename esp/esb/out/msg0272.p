/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0272 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0272
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD CodigoARB LIKE int_solicitacao_alatur.request_number_arb.

{esp/esb/esesb000.i}
{esp/esb/out/msg0272.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR msg0272r.
DEFINE OUTPUT PARAM TABLE FOR CentroCusto.
DEFINE OUTPUT PARAM TABLE FOR Reembolso.
DEFINE OUTPUT PARAM TABLE FOR Resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0272
   DATA-RELATION FOR conteudo, msg0272 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0272r, ListaCentroCusto, CentroCusto, ListaReembolsos, Reembolso, resultado
   DATA-RELATION FOR conteudor, msg0272r           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0272r, ListaCentroCusto    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaCentroCusto, CentroCusto RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0272r, ListaReembolsos     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ListaReembolsos, Reembolso    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0272r, resultado           RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0272'.
     
CREATE conteudo.
CREATE msg0272.

FOR FIRST tt-param:
    ASSIGN msg0272.CodigoARB        = tt-param.CodigoARB       
           cabecalho.NumeroOperacao = msg0272.CodigoARB.
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
