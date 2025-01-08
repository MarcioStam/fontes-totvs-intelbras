/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0190 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: msg0190
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-crm-categoria LIKE crm-categoria
    FIELD situacao AS INTEGER.

{esp/esb/out/msg0190.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-crm-categoria.
RAW-TRANSFER raw-param TO tt-crm-categoria.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0190
   DATA-RELATION FOR conteudo, msg0190 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0190r, resultado
   DATA-RELATION FOR conteudor, msg0190r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0190r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0190'.
     
CREATE conteudo.
CREATE msg0190.


FOR FIRST tt-crm-categoria NO-LOCK:

    ASSIGN cabecalho.NumeroOperacao = tt-crm-categoria.ds-categoria.

    ASSIGN msg0190.CodigoCategoriaB2B  = tt-crm-categoria.cd-categoria  
           msg0190.NomeCategoria       = tt-crm-categoria.ds-categoria
           msg0190.Situacao            = tt-crm-categoria.situacao.
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN "OK".
